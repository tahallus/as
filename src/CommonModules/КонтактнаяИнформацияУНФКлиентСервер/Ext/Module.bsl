﻿
#Область ПрограммныйИнтерфейс

// Функция получает представление значения контактной информации на форме
//
// Параметры:
//  Форма	 - ФормаКлиентскогоПриложения	 - форма-владелец контактной информации
//  Вид		 - СправочникСсылка.ВидыКонтактнойИнформации	 - вид для которого получается значение
// 
// Возвращаемое значение:
//  Строка - введенное на форме значение контактной информации
//
Функция ПолучитьЗначениеКонтактнойИнформации(Форма, Вид) Экспорт
	
	Отбор = Новый Структура("Вид", Вид);
	НайденныеСтроки = Форма.КонтактнаяИнформация.НайтиСтроки(Отбор);
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		Возврат НайденныеСтроки[0].Представление;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

// Функция - Имена полей ввода контактной информации. Может применятся для вывода сообщений об ошибке рядом с полем
//           контактной информации.
//
// Параметры:
//  Форма	 - ФормаКлиентскогоПриложения	 - форма-владелец контактной информации
//  Вид		 - СправочникСсылка.ВидыКонтактнойИнформации	 - вид для которого получаются имена полей
// 
// Возвращаемое значение:
//  Массив - массив строк с именами полей ввода
//
Функция ИменаПолейВводаКонтактнойИнформации(Форма, Вид) Экспорт
	
	Результат = Новый Массив;
	
	Отбор = Новый Структура("Вид", Вид);
	НайденныеСтроки = Форма.КонтактнаяИнформация.НайтиСтроки(Отбор);
	
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		
		Индекс = Форма.КонтактнаяИнформация.Индекс(НайденнаяСтрока);
		ИмяЭлемента = "ПредставлениеКИ_"+Индекс;
		Если Форма.Элементы.Найти(ИмяЭлемента) <> Неопределено Тогда
			Результат.Добавить(ИмяЭлемента);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Функция - Пути к данным полей контактной информации. Может применятся для вывода сообщений об ошибке рядом с полем
//           контактной информации.
//
// Параметры:
//  Форма	 - ФормаКлиентскогоПриложения	 - форма-владелец контактной информации
//  Вид		 - СправочникСсылка.ВидыКонтактнойИнформации	 - вид для которого получаются имена полей
// 
// Возвращаемое значение:
//  Массив - массив строк с путями к данным полей ввода
//
Функция ПутиКДаннымПолейКонтактнойИнформации(Форма, Вид) Экспорт
	
	Результат = Новый Массив;
	
	Отбор = Новый Структура("Вид", Вид);
	НайденныеСтроки = Форма.КонтактнаяИнформация.НайтиСтроки(Отбор);
	
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		
		Индекс = Форма.КонтактнаяИнформация.Индекс(НайденнаяСтрока);
		ПутьКПолю = "КонтактнаяИнформация["+Индекс+"].Представление";
		Результат.Добавить(ПутьКПолю);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция СписокВидовДляДобавленияКонтактнойИнформации(Форма) Экспорт
	
	СписокДоступныхВидов = Новый СписокЗначений;
	Отбор = Новый Структура("Вид");
	Для Каждого СтрокаТаблицы Из Форма.СвойстваВидовКонтактнойИнформации Цикл
		Отбор.Вид = СтрокаТаблицы.Вид;
		Если СтрокаТаблицы.РазрешитьВводНесколькихЗначений Или Форма.КонтактнаяИнформация.НайтиСтроки(Отбор).Количество() = 0 Тогда
			СписокДоступныхВидов.Добавить(СтрокаТаблицы.Вид, СтрокаТаблицы.ПредставлениеВида);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СписокДоступныхВидов;
	
КонецФункции

Процедура ЗаполнитьСписокВыбораАдресов(Форма) Экспорт
	
	МассивАдресов = Новый Массив;
	Отбор = Новый Структура("Вид");
	
	Для Каждого СтрокаТаблицы Из Форма.КонтактнаяИнформация Цикл
		
		Если СтрокаТаблицы.Тип <> ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
			Продолжить;
		КонецЕсли;
		
		Если Форма.СодержитДействуетС И СтрокаТаблицы.ЭтоИсторическаяКонтактнаяИнформация Тогда
			Продолжить;
		КонецЕсли;

		Отбор.Вид = СтрокаТаблицы.Вид;
		НайденныеСтроки = Форма.СвойстваВидовКонтактнойИнформации.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ПустаяСтрока(СтрокаТаблицы.Представление)
			И МассивАдресов.Найти(СтрокаТаблицы.Представление) = Неопределено Тогда
			
			МассивАдресов.Добавить(Новый Структура("Представление,Значение", СтрокаТаблицы.Представление, Новый Структура("Представление,Адрес", СтрокаТаблицы.Представление, СтрокаТаблицы.Значение)));
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого СтрокаТаблицы Из Форма.КонтактнаяИнформация Цикл
		
		Если СтрокаТаблицы.Тип <> ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
			Продолжить;
		КонецЕсли;
		
		Если Форма.СодержитДействуетС И СтрокаТаблицы.ЭтоИсторическаяКонтактнаяИнформация Тогда
			Продолжить;
		КонецЕсли;
		
		Отбор.Вид = СтрокаТаблицы.Вид;
		НайденныеСтроки = Форма.СвойстваВидовКонтактнойИнформации.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ПолеПредставление = Форма.Элементы["ПредставлениеКИ_" + Форма.КонтактнаяИнформация.Индекс(СтрокаТаблицы)];
		ПолеПредставление.СписокВыбора.Очистить();
		Для каждого ДанныеАдреса Из МассивАдресов Цикл
			Если НЕ ЕстьАдресВСписке(ПолеПредставление.СписокВыбора, ДанныеАдреса.Представление) Тогда
				ПолеПредставление.СписокВыбора.Добавить(ДанныеАдреса.Значение, ДанныеАдреса.Представление);
			КонецЕсли;
		КонецЦикла;
		
		ПолеПредставление.КнопкаВыпадающегоСписка = ПолеПредставление.СписокВыбора.Количество() > 0;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЕстьАдресВСписке(СписокЗначений, Адрес)
	
	Для каждого Элемент Из СписокЗначений Цикл
		
		Если Элемент.Представление = Адрес Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

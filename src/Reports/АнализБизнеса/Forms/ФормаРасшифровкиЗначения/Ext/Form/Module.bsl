﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ПараметрыОткрытия") Тогда
		Отказ = Истина;
	КонецЕсли; 
	
	ШаблонЗаголовка = НСтр("ru = 'Расшифровка %1 за %2'");
	ЗаголовокПериода = ПоказателиБизнесаФормы.ЗаголовокКолонки(Параметры.ПараметрыОткрытия.НачалоПериода, Параметры.ПараметрыОткрытия.Периодичность);
	ЭтаФорма.Заголовок = СтрШаблон(ШаблонЗаголовка, ВРЕГ(Параметры.ПараметрыОткрытия.Показатель), ЗаголовокПериода);
	
	ЗаполнитьТаблицуРасшифровкиПоПоказателю(Параметры.ПараметрыОткрытия);
	
	Если Параметры.ПараметрыОткрытия.ВыбранныйОтчет <> Перечисления.ВидыФинансовыхОтчетов.ДенежныйПоток Тогда
		Элементы.РасшифровкаЗначенияГруппаПроектПодразделение.Видимость = Ложь;
		Элементы.РасшифровкаЗначенияАналитика.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СобытияЭлементовФормы

&НаКлиенте
Процедура РасшифровкаЗначенияПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ТекущиеДанные = Элементы.РасшифровкаЗначения.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(, ТекущиеДанные.Документ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуРасшифровкиПоПоказателю(СтруктураПараметров)
	
	ТаблицаМеток = СтруктураПараметров.ДанныеМеток.Выгрузить();
	
	ДополнитьМеткиПоТекущейАналитике(ТаблицаМеток, СтруктураПараметров);
	
	МассивПоказателей = Новый Массив;
	Справочники.ПоказателиБизнеса.ПолучитьЗависимыеПоказателиРекурсивно(СтруктураПараметров.Показатель, МассивПоказателей);
	ОбщегоНазначенияКлиентСервер.СвернутьМассив(МассивПоказателей);

	ТекстЗапроса = ПоказателиБизнеса.ПолучитьТекстЗапросаРасшифровкаПоказателя(СтруктураПараметров.Показатель.ВидОтчета, СтруктураПараметров.СценарийПланирования);
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	ДобавитьПараметрыМетокВЗапрос(Запрос, СтруктураПараметров.ВыбранныйОтчет, ТаблицаМеток);
	
	Запрос.УстановитьПараметр("МассивПоказателей", МассивПоказателей);
	Запрос.УстановитьПараметр("СценарийПланирования", СтруктураПараметров.СценарийПланирования);
	Запрос.УстановитьПараметр("НачалоПериода", СтруктураПараметров.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", СтруктураПараметров.КонецПериода);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = РасшифровкаЗначения.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПараметрыМетокВЗапрос(Запрос, ВидОтчета, ДанныеМеток)
	
	Если ДанныеМеток = Неопределено ИЛИ ДанныеМеток.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Инициализация
	ПараметрыЗапроса = Новый Структура;
	СхемаЗапроса     = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(Запрос.Текст);
	НомерЗапроса     = 0;
	ПакетЗапроса 	 = СхемаЗапроса.ПакетЗапросов[СхемаЗапроса.ПакетЗапросов.Количество()-1];
	ОператорыЗапроса = ПакетЗапроса.Операторы[НомерЗапроса];
	
	Если ВидОтчета = Перечисления.ВидыФинансовыхОтчетов.ДоходыРасходы Тогда
		ИмяТаблицы = ОператорыЗапроса.Источники[НомерЗапроса].Источник.Псевдоним;
	ИначеЕсли ВидОтчета = Перечисления.ВидыФинансовыхОтчетов.ДенежныйПоток Тогда
		ИмяТаблицы = "ДвиженияДенежныхСредств"; // Не локализуется
	Иначе // Баланс
		ИмяТаблицы = "Управленческий"; // Не локализуется
	КонецЕсли;
	
	МассивОтборов = Новый Массив;
	
	Для каждого СтрокаМетки Из ДанныеМеток Цикл
		
		// Для Доходов и Расходов и Баланса - пока только отбор по организации
		Если ВидОтчета = Перечисления.ВидыФинансовыхОтчетов.Баланс И СтрокаМетки.ИмяПоляОтбора <> "Организация" Тогда // Не локализуется
			Продолжить;
		КонецЕсли;
		
		ИмяПоляОтбора = СтрокаМетки.ИмяПоляОтбора;
		Если ИмяПоляОтбора = "Подразделение" И ВидОтчета = Перечисления.ВидыФинансовыхОтчетов.ДоходыРасходы Тогда
			ИмяПоляОтбора= "СтруктурнаяЕдиница";
		КонецЕсли;
		
		СтрокаОтбора = СтрШаблон("%1.%2 В (&%3)", ИмяТаблицы, ИмяПоляОтбора, СтрокаМетки.ИмяПоляОтбора);
		
		Если МассивОтборов.Найти(СтрокаОтбора) = Неопределено Тогда
			МассивОтборов.Добавить(СтрокаОтбора);
		КонецЕсли;
		
		Если НЕ ПараметрыЗапроса.Свойство(СтрокаМетки.ИмяПоляОтбора) Тогда
			ПараметрыЗапроса.Вставить(СтрокаМетки.ИмяПоляОтбора, Новый Массив);
		КонецЕсли;
		
		ПараметрыЗапроса[СтрокаМетки.ИмяПоляОтбора].Добавить(СтрокаМетки.Метка);
		
	КонецЦикла;
	
	Для каждого СтрокаОтбора Из МассивОтборов Цикл
		ОператорыЗапроса.Отбор.Добавить(СтрокаОтбора);
	КонецЦикла;
	
	Запрос.Текст = СхемаЗапроса.ПолучитьТекстЗапроса();
	
	Для каждого КлючЗначение Из ПараметрыЗапроса Цикл
		Запрос.УстановитьПараметр(КлючЗначение.Ключ, КлючЗначение.Значение);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДополнитьМеткиПоТекущейАналитике(ТаблицаМеток, СтруктураПараметров)
	
	Если СтруктураПараметров.ВыбранныйОтчет = Перечисления.ВидыФинансовыхОтчетов.Баланс Тогда
		Возврат;
	КонецЕсли;
	
	Если СтруктураПараметров.Группировка = Перечисления.ГруппировкаАнализаБизнеса.Проекты Тогда
		ИмяПоляОтбора = "Проект"; // Не локализуется
	ИначеЕсли СтруктураПараметров.Группировка = Перечисления.ГруппировкаАнализаБизнеса.Подразделения Тогда
		ИмяПоляОтбора = "Подразделение"; // Не локализуется
	Иначе // Дополнять метки не требуется
		Возврат;
	КонецЕсли;
	
	НоваяМетка = ТаблицаМеток.Добавить();
	НоваяМетка.ИмяПоляОтбора = ИмяПоляОтбора;
	НоваяМетка.Метка = СтруктураПараметров.Аналитика;
	
КонецПроцедуры


#КонецОбласти 





﻿
#Область СлужебныеПроцедурыФункции

&НаКлиенте
// Процедура открывает конструктор формулы
//
Процедура ОткрытьКонструкторФормулы()
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормулы = Новый Структура;
	ПараметрыФормулы.Вставить("Формула",				Формула);
	ПараметрыФормулы.Вставить("ЭтоФормированиеЦен",		Истина);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КонструкторФормулЗавершение", ЭтотОбъект);
	ОткрытьФорму("Справочник.ВидыЦен.Форма.КонструкторФормул", ПараметрыФормулы, Элементы.Формула,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры // ОткрытьКонструкторФормулы()

&НаКлиенте
Процедура КонструкторФормулЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") 
		И Результат.Результат = КодВозвратаДиалога.Да Тогда
		
		Результат.Свойство("Формула", Формула);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВнестиФормулуВИсториюИспользований(Формула)
	
	Если ПустаяСтрока(Формула) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ПустаяСтрока(ИсторияФормул) Тогда
		
		ИсторияФормул = "~~~~";
		
	КонецЕсли;
	
	МассивФормул = СтрРазделить(ИсторияФормул, "~", Истина);
	
	ИндексЭтойФормулы = МассивФормул.Найти(СокрЛП(Формула));
	Если ИндексЭтойФормулы = Неопределено Тогда
		
		ИндексЭтойФормулы = 4;
		
	КонецЕсли;
	
	КопияМассиваФормул = Новый Массив(5);
	КопияМассиваФормул[0] = СокрЛП(Формула);
	
	СтандартноеПриращение = 1;
	Для ИндексМассива = 0 По 4 Цикл
		
		Если ИндексМассива = ИндексЭтойФормулы Тогда
			
			СтандартноеПриращение = 0;
			Продолжить;
			
		КонецЕсли;
		
		СохраненнаяФормула = СокрЛП(Строка(МассивФормул[ИндексМассива]));
		КопияМассиваФормул[ИндексМассива + СтандартноеПриращение] = СохраненнаяФормула;
		
	КонецЦикла;
	
	ИсторияФормул = СтрСоединить(КопияМассиваФормул, "~");
	
КонецПроцедуры

#КонецОбласти

#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИзменитьОднуКолонку = Истина;
	
	Параметры.Свойство("ВидРасчета", ВариантыИзменения);
	
	Если ВариантыИзменения = "Сумма" Тогда
		
		ЭтаФорма.Заголовок = НСтр("ru ='Изменить на сумму'");
		
	ИначеЕсли ВариантыИзменения = "Процент" Тогда
		
		ЭтаФорма.Заголовок = НСтр("ru ='Изменить на процент'");
		
	ИначеЕсли ВариантыИзменения = "Округление" Тогда
		
		ЭтаФорма.Заголовок = НСтр("ru ='Округление'");
		
	ИначеЕсли ВариантыИзменения = "Очистить" Тогда
		
		ЭтаФорма.Заголовок = НСтр("ru ='Очистить'");
		
	ИначеЕсли ВариантыИзменения = "Формула" Тогда
		
		ЭтаФорма.Заголовок = НСтр("ru ='Изменить по формуле'");
		
	КонецЕсли;
	
	Элементы.Страницы.ТекущаяСтраница = Элементы["Страница" + ВариантыИзменения];
	
	Для каждого ЭлементПеречисления Из Параметры.КэшЗначений.ВыбранныеВидыЦен Цикл
		
		Элементы.ТекущийВидЦен.СписокВыбора.Добавить(ЭлементПеречисления.Ключ.ИдентификаторФормул, ЭлементПеречисления.Ключ.Наименование);
		
	КонецЦикла;
	
	Если Элементы.ТекущийВидЦен.СписокВыбора.Количество() = 1 Тогда
		
		ТекущийВидЦен = Элементы.ТекущийВидЦен.СписокВыбора[0].Значение;
		
	ИначеЕсли Параметры.Свойство("ТекущаяКолонка") Тогда
		
		ТекущийВидЦен = ?(Элементы.ТекущийВидЦен.СписокВыбора.НайтиПоЗначению(Параметры.ТекущаяКолонка) = Неопределено, Элементы.ТекущийВидЦен.СписокВыбора[0].Значение, Параметры.ТекущаяКолонка);
		
	КонецЕсли;
	
	Если Элементы.ТекущийВидЦен.СписокВыбора.Количество() = 1 Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИзменитьОднуКолонку", "Доступность", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ТекущийВидЦен", "Доступность", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ИсторияФормул = Настройки.Получить("ИсторияФормул");
	Если ИсторияФормул = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ИсторияИспользованияФормул = СтрРазделить(ИсторияФормул, "~");
	Для каждого ЭлементМассива Из ИсторияИспользованияФормул Цикл
		
		Если НЕ ЗначениеЗаполнено(ЭлементМассива) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Элементы.Формула.СписокВыбора.Добавить(ЭлементМассива);
		
	КонецЦикла;
	
	Если Элементы.Формула.СписокВыбора.Количество() > 0 Тогда
		
		Элементы.Формула.КнопкаВыпадающегоСписка = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СобытияРеквизитовФормы

&НаКлиенте
Процедура ИзменитьОднуКолонкуПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ТекущийВидЦен", "Доступность", ИзменитьОднуКолонку);
	
КонецПроцедуры

&НаКлиенте
Процедура ФормулаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьКонструкторФормулы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура ОК(Команда)
	
	Результат = Новый Структура;
	Результат.Вставить("ВыборПроизведен",				Истина);
	Результат.Вставить("ЗаполнятьПоТекущемуВидуЦен",	?(ИзменитьОднуКолонку, 0, 1));
	Результат.Вставить("ИдентификаторТекущегоВидаЦен",	ТекущийВидЦен);
	Результат.Вставить("ВариантИзменения",				ВариантыИзменения);
	
	Если ВариантыИзменения = "Сумма" Тогда
		
		Результат.Вставить("Сумма",						Сумма);
		
	ИначеЕсли ВариантыИзменения = "Процент" Тогда
		
		Результат.Вставить("Процент",					Процент);
		
	ИначеЕсли ВариантыИзменения = "Округление" Тогда
		
		Результат.Вставить("ОкруглениеПорядок",			ОкруглениеПорядок);
		Результат.Вставить("ОкруглениеВБольшуюСторону", ОкруглениеВБольшуюСторону);
		
	ИначеЕсли ВариантыИзменения = "Формула" Тогда
		
		Результат.Вставить("Формула",					Формула);
		ВнестиФормулуВИсториюИспользований(Формула);
		
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Результат = Новый Структура;
	Результат.Вставить("ВыборПроизведен", Ложь);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьФормулу(Команда)
	
	ОткрытьКонструкторФормулы();
	
КонецПроцедуры

#КонецОбласти

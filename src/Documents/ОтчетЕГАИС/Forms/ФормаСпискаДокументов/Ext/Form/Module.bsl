﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ЗаполнитьПараметрыВидимостиКолонок();
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Ответственный",    Ответственный,    СтруктураБыстрогоОтбора);
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "ОрганизацияЕГАИС", ОрганизацииЕГАИС, СтруктураБыстрогоОтбора);
	
	ИнтеграцияЕГАИС.ОтборПоОрганизацииПриСозданииНаСервере(ЭтотОбъект, "Отбор");
	
	Если ИнтеграцияЕГАИСКлиентСервер.НеобходимОтборПоДальнейшемуДействиюЕГАИСПриСозданииНаСервере(ДальнейшееДействиеЕГАИС, СтруктураБыстрогоОтбора) Тогда
		УстановитьОтборПоДальнейшемуДействиюСервер();
	КонецЕсли;
	
	ИнтеграцияЕГАИС.ЗаполнитьСписокВыбораДальнейшееДействие(
		Элементы.СтраницаОформленоОтборДальнейшееДействиеЕГАИС.СписокВыбора,
		Документы.ОтчетЕГАИС.ВсеТребующиеДействия(),
		Документы.ОтчетЕГАИС.ВсеТребующиеОжидания());
	
	ИнтеграцияЕГАИС.УстановитьВидимостьКомандыВыполнитьОбмен(ЭтотОбъект, "СписокВыполнитьОбмен");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	ЕстьПравоДобавление = ПравоДоступа("Добавление", Метаданные.Документы.ОтчетЕГАИС);
	
	Элементы.СписокПодменюСоздать.Видимость            = ЕстьПравоДобавление;
	Элементы.СписокКонтекстноеПодменюСоздать.Видимость = ЕстьПравоДобавление;
	
	Если ЕстьПравоДобавление Тогда
		Элементы.СписокСоздатьЗапросДвиженийМеждуРегистрами.Видимость      = ПравоДоступа("Использование", Метаданные.Отчеты.ДвиженияМеждуРегистрамиЕГАИС);
		Элементы.СписокСоздатьЗапросДвиженийПоСправке2.Видимость           = ПравоДоступа("Использование", Метаданные.Отчеты.ДвиженияПоСправке2ЕГАИС);
		Элементы.СписокСоздатьЗапросИнформацииОбОрганизацииЕГАИС.Видимость = ПравоДоступа("Использование", Метаданные.Отчеты.ИнформацияОбОрганизацииЕГАИС);
		Элементы.СписокСоздатьЗапросИсторииСправок2.Видимость              = ПравоДоступа("Использование", Метаданные.Отчеты.ИсторияСправок2ЕГАИС);
		Элементы.СписокСоздатьЗапросНеобработанныхТТН.Видимость            = ПравоДоступа("Использование", Метаданные.Отчеты.НеобработанныеТТНЕГАИС);
		Элементы.СписокСоздатьЗапросОбработанныхЧеков.Видимость            = ПравоДоступа("Использование", Метаданные.Отчеты.ОбработанныеЧекиЕГАИС);
		Элементы.СписокСоздатьЗапросОстатковВРегистре1.Видимость           = ПравоДоступа("Использование", Метаданные.Отчеты.ОстаткиАлкогольнойПродукцииЕГАИС);
		Элементы.СписокСоздатьЗапросОстатковВРегистре2.Видимость           = ПравоДоступа("Использование", Метаданные.Отчеты.ОстаткиАлкогольнойПродукцииЕГАИС);
		Элементы.СписокСоздатьЗапросОстатковВРегистре3.Видимость           = ПравоДоступа("Использование", Метаданные.Отчеты.ОстаткиАкцизныхМарокЕГАИС);
		
		Элементы.СписокКонтекстноеМенюСоздатьЗапросДвиженийМеждуРегистрами.Видимость      = Элементы.СписокСоздатьЗапросДвиженийМеждуРегистрами.Видимость;
		Элементы.СписокКонтекстноеМенюСоздатьЗапросДвиженийПоСправке2.Видимость           = Элементы.СписокСоздатьЗапросДвиженийПоСправке2.Видимость;
		Элементы.СписокКонтекстноеМенюСоздатьЗапросИнформацииОбОрганизацииЕГАИС.Видимость = Элементы.СписокСоздатьЗапросИнформацииОбОрганизацииЕГАИС.Видимость;
		Элементы.СписокКонтекстноеМенюСоздатьЗапросИсторииСправок2.Видимость              = Элементы.СписокСоздатьЗапросИсторииСправок2.Видимость;
		Элементы.СписокКонтекстноеМенюСоздатьЗапросНеобработанныхТТН.Видимость            = Элементы.СписокСоздатьЗапросНеобработанныхТТН.Видимость;
		Элементы.СписокКонтекстноеМенюСоздатьЗапросОбработанныхЧеков.Видимость            = Элементы.СписокСоздатьЗапросОбработанныхЧеков.Видимость;
		Элементы.СписокКонтекстноеМенюСоздатьЗапросОстатковВРегистре1.Видимость           = Элементы.СписокСоздатьЗапросОстатковВРегистре1.Видимость;
		Элементы.СписокКонтекстноеМенюСоздатьЗапросОстатковВРегистре2.Видимость           = Элементы.СписокСоздатьЗапросОстатковВРегистре2.Видимость;
		Элементы.СписокКонтекстноеМенюСоздатьЗапросОстатковВРегистре3.Видимость           = Элементы.СписокСоздатьЗапросОстатковВРегистре3.Видимость;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ОтчетЕГАИС" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменениеСостоянияЕГАИС"
		И ТипЗнч(Параметр.Ссылка) = Тип("ДокументСсылка.ОтчетЕГАИС") Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменЕГАИС"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусВФормахДокументов)) Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
	СобытияФормИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	НастройкиОрганизацияЕГАИС = ИнтеграцияЕГАИСКлиентСервер.СтруктураПоискаПоляДляЗагрузкиИзНастроек(
		"ОрганизацииЕГАИС",
		Настройки);
	
	Если ИнтеграцияЕГАИСКлиентСервер.НеобходимОтборПоДальнейшемуДействиюЕГАИСПередЗагрузкойИзНастроек(ДальнейшееДействиеЕГАИС, СтруктураБыстрогоОтбора, Настройки) Тогда
		УстановитьОтборПоДальнейшемуДействиюСервер();
	КонецЕсли;
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                       "СтатусЕГАИС",
	                                                                       СтатусЕГАИС,
	                                                                       СтруктураБыстрогоОтбора,
	                                                                       Настройки);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                       "Ответственный",
	                                                                       Ответственный,
	                                                                       СтруктураБыстрогоОтбора,
	                                                                       Настройки);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                       "ОрганизацияЕГАИС",
	                                                                       ОрганизацииЕГАИС,
	                                                                       СтруктураБыстрогоОтбора,
	                                                                       НастройкиОрганизацияЕГАИС);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                       "ВидДокумента",
	                                                                       ВидДокумента,
	                                                                       СтруктураБыстрогоОтбора,
	                                                                       Настройки);
	
	Настройки.Удалить("ДальнейшееДействиеЕГАИС");
	Настройки.Удалить("СтатусЕГАИС");
	Настройки.Удалить("Ответственный");
	Настройки.Удалить("ОрганизацииЕГАИС");
	Настройки.Удалить("ВидДокумента");
	
	ИнтеграцияЕГАИС.ОтборПоОрганизацииПриСозданииНаСервере(ЭтотОбъект, "Отбор");
	
	УстановитьВидимость(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидДокументаОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "ВидДокумента",
	                                                                        ВидДокумента,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(ВидДокумента));
	
	УстановитьВидимость(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаОформленоОтборСтатусЕГАИСПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "СтатусЕГАИС",
	                                                                        СтатусЕГАИС,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(СтатусЕГАИС));
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаОформленоОтборДальнейшееДействиеЕГАИСПриИзменении(Элемент)
	
	УстановитьОтборПоДальнейшемуДействиюСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаОформленоОтборОтветственныйПриИзменении(Элемент)
	
	ОтветственныйОтборПриИзменении();
	
КонецПроцедуры

#Область ОтборПоОрганизацииЕГАИС

&НаКлиенте
Процедура ОтборОрганизацииЕГАИСПриИзменении(Элемент)
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, ОрганизацииЕГАИС, Истина, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииЕГАИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОткрытьФормуВыбораОрганизацийЕГАИС(
		ЭтотОбъект, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииЕГАИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, Неопределено, Истина, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииЕГАИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, ВыбранноеЗначение, Истина, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры


&НаКлиенте
Процедура ОтборОрганизацияЕГАИСПриИзменении(Элемент)
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, ОрганизацияЕГАИС, Истина, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияЕГАИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОткрытьФормуВыбораОрганизацийЕГАИС(
		ЭтотОбъект, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияЕГАИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, Неопределено, Истина, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияЕГАИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, ВыбранноеЗначение, Истина, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если ТекущиеДанные.СтатусЕГАИС = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиОтчетаЕГАИС.ПолученОтчет") Тогда
		СтандартнаяОбработка = Ложь;
		
		Отбор = Новый Структура;
		Отбор.Вставить("ОтчетЕГАИС", ТекущиеДанные.Ссылка);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Отбор", Отбор);
		ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
		
		Попытка
			Если ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияМеждуРегистрами") Тогда
				ОткрытьФорму("Отчет.ДвиженияМеждуРегистрамиЕГАИС.Форма", ПараметрыФормы,, ТекущиеДанные.Ссылка);
			ИначеЕсли ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияПоСправке2") Тогда
				ОткрытьФорму("Отчет.ДвиженияПоСправке2ЕГАИС.Форма", ПараметрыФормы,, ТекущиеДанные.Ссылка);
			ИначеЕсли ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаИнформацияОбОрганизации") Тогда
				ОткрытьФорму("Отчет.ИнформацияОбОрганизацииЕГАИС.Форма", ПараметрыФормы,, ТекущиеДанные.Ссылка);
			ИначеЕсли ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаНеобработанныеТТН") Тогда
				ОткрытьФорму("Отчет.НеобработанныеТТНЕГАИС.Форма", ПараметрыФормы,, ТекущиеДанные.Ссылка);
			ИначеЕсли ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаОбработанныеЧеки") Тогда
				ОткрытьФорму("Отчет.ОбработанныеЧекиЕГАИС.Форма", ПараметрыФормы,, ТекущиеДанные.Ссылка);
			ИначеЕсли ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре1") Тогда
				ПараметрыФормы.Вставить("КлючВарианта", "ОстаткиВРегистре1");
				ОткрытьФорму("Отчет.ОстаткиАлкогольнойПродукцииЕГАИС.Форма", ПараметрыФормы,, ТекущиеДанные.Ссылка);
			ИначеЕсли ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре2") Тогда
				ПараметрыФормы.Вставить("КлючВарианта", "ОстаткиВРегистре2");
				ОткрытьФорму("Отчет.ОстаткиАлкогольнойПродукцииЕГАИС.Форма", ПараметрыФормы,, ТекущиеДанные.Ссылка);
			ИначеЕсли ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре3") Тогда
				ОткрытьФорму("Отчет.ОстаткиАкцизныхМарокЕГАИС.Форма", ПараметрыФормы,, ТекущиеДанные.Ссылка);
			ИначеЕсли ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаИсторияСправок2") Тогда
				ОткрытьФорму("Отчет.ИсторияСправок2ЕГАИС.Форма", ПараметрыФормы,, ТекущиеДанные.Ссылка);
			КонецЕсли;
		Исключение
			ПоказатьПредупреждение(, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), 30);
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область КомандыСоздания

&НаКлиенте
Процедура СоздатьЗапросДвиженийМеждуРегистрами(Команда)
	
	СоздатьЗапросОтчета(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияМеждуРегистрами"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросДвиженийПоСправке2(Команда)
	
	СоздатьЗапросОтчета(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияПоСправке2"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросИнформацииОбОрганизацииЕГАИС(Команда)
	
	СоздатьЗапросОтчета(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаИнформацияОбОрганизации"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросНеобработанныхТТН(Команда)
	
	СоздатьЗапросОтчета(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаНеобработанныеТТН"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросОбработанныхЧеков(Команда)
	
	СоздатьЗапросОтчета(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаОбработанныеЧеки"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросОстатковВРегистре1(Команда)
	
	СоздатьЗапросОтчета(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре1"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросОстатковВРегистре2(Команда)
	
	СоздатьЗапросОтчета(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре2"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросОстатковВРегистре3(Команда)
	
	СоздатьЗапросОтчета(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре3"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросИсторииСправок2(Команда)
	
	СоздатьЗапросОтчета(ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросОтчетаИсторияСправок2"));
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ЗапроситьОтчет(Команда)
	
	ИнтеграцияЕГАИСКлиент.ПодготовитьСообщенияКПередаче(
		Элементы.Список,
		ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеОтчет"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ИнтеграцияЕГАИСКлиент.ВыполнитьОбмен(
		ИнтеграцияЕГАИСКлиент.ОрганизацииЕГАИСДляОбмена(
			ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьОтработкуРасхождений(Команда)
	
	ОчиститьСообщения();
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	ДанныеДляОбработки = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		
		ДанныеСтроки = Элементы.Список.ДанныеСтроки(ВыделеннаяСтрока);
		ОтработайтеРасхождения = ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОтработайтеРасхождения");
		Если ДанныеСтроки.ДальнейшееДействиеЕГАИС1 <> ОтработайтеРасхождения Тогда
			ТекстСообщения = НСтр("ru = 'Команда не может быть выполнена для ""%1""'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ВыделеннаяСтрока));
		Иначе
			Структура = Новый Структура("Ссылка, ВидДокумента", ДанныеСтроки.Ссылка, ДанныеСтроки.ВидДокумента);
			ДанныеДляОбработки.Добавить(Структура);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ДанныеДляОбработки.Количество() > 0 Тогда
		ОтметитьОтработкуРасхожденийВыделенныхСтрокНаСервере(ДанныеДляОбработки);
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтметитьОтработкуРасхожденийВыделенныхСтрокНаСервере(ДанныеДляОбработки)
	
	Для Каждого ЭлементДанных Из ДанныеДляОбработки Цикл
		
		ОтметитьОтработкуРасхожденийНаСервере(
		ЭлементДанных.Ссылка,
		ЭлементДанных.ВидДокумента);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура АрхивироватьДокументы(Команда)
	
	ИнтеграцияИСКлиент.АрхивироватьДокументы(ЭтотОбъект, Элементы.Список, ИнтеграцияЕГАИСКлиент);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

//@skip-warning
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	// Ошибки
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусЕГАИС.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.СтатусЕГАИС.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокСтатусов = Новый СписокЗначений;
	СписокСтатусов.ЗагрузитьЗначения(Документы.ОтчетЕГАИС.СтатусыОшибок());
	ОтборЭлемента.ПравоеЗначение = СписокСтатусов;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СтатусОбработкиОшибкаПередачиГосИС);
	
	// Требуется ожидание
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусЕГАИС.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.ДальнейшееДействиеЕГАИС.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокДействий = Новый СписокЗначений;
	СписокДействий.ЗагрузитьЗначения(Документы.ОтчетЕГАИС.ВсеТребующиеОжидания());
	ОтборЭлемента.ПравоеЗначение = СписокДействий;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СтатусОбработкиПередаетсяГосИС);
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВидДокумента.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ВидДокумента.ПутьКДанным);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияМеждуРегистрами;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Движения между регистрами'"));
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВидДокумента.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ВидДокумента.ПутьКДанным);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияПоСправке2;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Движения по справке 2'"));
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВидДокумента.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ВидДокумента.ПутьКДанным);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаИнформацияОбОрганизации;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Информация об организации'"));
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВидДокумента.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ВидДокумента.ПутьКДанным);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаНеобработанныеТТН;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Необработанные ТТН'"));
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВидДокумента.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ВидДокумента.ПутьКДанным);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОбработанныеЧеки;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Обработанные чеки'"));
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВидДокумента.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ВидДокумента.ПутьКДанным);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре1;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Остатки в регистре №1'"));
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВидДокумента.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ВидДокумента.ПутьКДанным);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре2;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Остатки в регистре №2'"));
	
	// Даты
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтметитьОтработкуРасхожденийНаСервере(ДокументСсылка, ВидДокумента)
	
	Если ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияМеждуРегистрами Тогда
		
		Операция = Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросОтчетаДвиженияМеждуРегистрами;
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияПоСправке2 Тогда
		
		Операция = Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросОтчетаДвиженияПоСправке2;
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаИнформацияОбОрганизации Тогда
		
		Операция = Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросОтчетаИнформацияОбОрганизации;
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаНеобработанныеТТН Тогда
		
		Операция = Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросОтчетаНеобработанныеТТН;
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОбработанныеЧеки Тогда
		
		Операция = Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросОтчетаОбработанныеЧеки;
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре1 Тогда
		
		Операция = Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросОтчетаОстаткиВРегистре1;
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре2 Тогда
		
		Операция = Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросОтчетаОстаткиВРегистре2;
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре3 Тогда
		
		Операция = Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросОтчетаОстаткиВРегистре3;
		Документы.ОтчетЕГАИС.ОтработатьРасхожденияЗапросОтчетаОстаткиВРегистре3(ДокументСсылка);
		
	КонецЕсли;
	
	ПараметрыОбновленияСтатуса = ИнтеграцияЕГАИС.ПараметрыОбновленияСтатуса();
	ПараметрыОбновленияСтатуса.ОбновлятьДвижения = Ложь;
	Документы.ОтчетЕГАИС.ОбновитьСтатусПослеПолученияДанных(ДокументСсылка, Операция, ПараметрыОбновленияСтатуса);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросОтчета(ВидДокумента)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ВидДокумента", ВидДокумента);
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.ОтчетЕГАИС.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

#Область Отборы

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "Ответственный",
	                                                                        Ответственный,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(Ответственный));
	
КонецПроцедуры

#КонецОбласти

#Область ОтборДальнейшиеДействия

&НаСервере
Процедура УстановитьОтборПоДальнейшемуДействиюСервер()
	
	ИнтеграцияЕГАИС.УстановитьОтборПоДальнейшемуДействию(Список,
		ДальнейшееДействиеЕГАИС,
		Документы.ОтчетЕГАИС.ВсеТребующиеДействия(),
		Документы.ОтчетЕГАИС.ВсеТребующиеОжидания());
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ЗаполнитьПараметрыВидимостиКолонок()
	
	ПараметрыВидимостиКолонок = Новый Структура;
	
	ПараметрыВидимостиКолонок.Вставить("Период",               Новый Массив);
	ПараметрыВидимостиКолонок.Вставить("АлкогольнаяПродукция", Новый Массив);
	ПараметрыВидимостиКолонок.Вставить("Справка2",             Новый Массив);
	ПараметрыВидимостиКолонок.Вставить("КодФСРАР",             Новый Массив);
	
	ПараметрыВидимостиКолонок.Период.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияМеждуРегистрами);
	ПараметрыВидимостиКолонок.Период.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаИнформацияОбОрганизации);
	ПараметрыВидимостиКолонок.Период.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОбработанныеЧеки);
	
	ПараметрыВидимостиКолонок.АлкогольнаяПродукция.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияМеждуРегистрами);
	ПараметрыВидимостиКолонок.АлкогольнаяПродукция.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияПоСправке2);
	ПараметрыВидимостиКолонок.АлкогольнаяПродукция.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОбработанныеЧеки);
	
	ПараметрыВидимостиКолонок.Справка2.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияПоСправке2);
	ПараметрыВидимостиКолонок.Справка2.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре3);
	ПараметрыВидимостиКолонок.Справка2.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаИсторияСправок2);
	
	ПараметрыВидимостиКолонок.КодФСРАР.Добавить(Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаИнформацияОбОрганизации);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимость(Форма)
	
	Форма.Элементы.ВидДокумента.Видимость = НЕ ЗначениеЗаполнено(Форма.ВидДокумента);
	
	УстановитьВидимостьКолонки(Форма, "Период");
	УстановитьВидимостьКолонки(Форма, "АлкогольнаяПродукция");
	УстановитьВидимостьКолонки(Форма, "Справка2");
	УстановитьВидимостьКолонки(Форма, "КодФСРАР");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьКолонки(Форма, ИмяКолонки)
	
	Форма.Элементы[ИмяКолонки].Видимость = Форма.ПараметрыВидимостиКолонок[ИмяКолонки].Найти(Форма.ВидДокумента) <> Неопределено;
	
КонецПроцедуры

#КонецОбласти

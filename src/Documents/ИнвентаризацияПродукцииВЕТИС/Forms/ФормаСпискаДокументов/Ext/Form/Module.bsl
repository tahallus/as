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
	
	ИнтеграцияВЕТИС.ПриСозданииНаСервереФормыСпискаДокументовВЕТИС(ЭтотОбъект, "Список", "СписокКОформлению");
	
	СтруктураБыстрогоОтбора = Неопределено;
	Если Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора) Тогда 
		
		ИнтеграцияВЕТИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список,            "Ответственный", Ответственный, СтруктураБыстрогоОтбора);
		ИнтеграцияВЕТИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокКОформлению, "Ответственный", Ответственный, СтруктураБыстрогоОтбора);
		
		ИнтеграцияВЕТИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "ОрганизацииВЕТИС", ОрганизацииВЕТИС, СтруктураБыстрогоОтбора, Ложь);
		
		ИнтеграцияВЕТИС.ОтборПоОрганизацииПриСозданииНаСервере(ЭтотОбъект);
		
		ИнтеграцияВЕТИСКлиентСервер.УстановитьОтборОрганизацияПредприятиеВЕТИС(Список,               ОрганизацииВЕТИС, "");
		ИнтеграцияВЕТИСКлиентСервер.УстановитьОтборОрганизацияПредприятиеВЕТИС(СписокКОформлению,    ОрганизацииВЕТИС, "");
		
		ОрганизацияВЕТИС = СтруктураБыстрогоОтбора.ОрганизацияВЕТИС;
		ОрганизацииВЕТИСПредставление = СтруктураБыстрогоОтбора.ОрганизацииВЕТИСПредставление;
		
		Если ИнтеграцияВЕТИСКлиентСервер.НеобходимОтборПоДальнейшемуДействиюВЕТИСПриСозданииНаСервере(ДальнейшееДействиеВЕТИС, СтруктураБыстрогоОтбора) Тогда
			УстановитьОтборПоДальнейшемуДействиюСервер();
		КонецЕсли;
		
	КонецЕсли;
	
	ИнтеграцияВЕТИС.ЗаполнитьСписокВыбораДальнейшееДействие(
		Элементы.СтраницаОформленоОтборДальнейшееДействиеВЕТИС.СписокВыбора,
		ВсеТребующиеДействия(),
		ВсеТребующиеОжидания());
	
	Если НЕ ПравоДоступа("Добавление",Метаданные.Документы.ИнвентаризацияПродукцииВЕТИС) Тогда
		Элементы.СтраницаКОформлению.Видимость = Ложь;
	ИначеЕсли Параметры.ОткрытьРаспоряжения Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКОформлению;
	КонецЕсли;
	
	ИнтеграцияВЕТИС.УстановитьВидимостьКомандыОформленияДокумента(ЭтотОбъект, Метаданные.Документы.ИнвентаризацияПродукцииВЕТИС, "СписокКОформлениюОформить");
	
	Если Не ПравоДоступа("Использование", Метаданные.Отчеты.АнализРасхожденийПриИнвентаризацииПродукцииВЕТИС) Тогда
		Элементы.СписокКОформлениюОтчетОРасхождениях.Видимость = Ложь;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьВидимостьДальнейшихДействий();
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	ИнтеграцияВЕТИС.УстановитьПризнакПравоИзмененияФормыСписка(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ИнтеграцияИСКлиент.ОбработкаОповещенияВФормеСпискаДокументовИС(
		ЭтотОбъект,
		ИнтеграцияВЕТИСКлиентСервер.ИмяПодсистемы(),
		ИмяСобытия,
		Параметр,
		Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	НастройкиОрганизацияВЕТИС = ИнтеграцияВЕТИСКлиентСервер.СтруктураПоискаПоляДляЗагрузкиИзНастроек(
		"ОрганизацииВЕТИС",
		Настройки);
	
	СтруктураПоиска = ИнтеграцияВЕТИСКлиентСервер.СтруктураПоискаПоляДляЗагрузкиИзНастроек("ОрганизацияВЕТИС", СтруктураБыстрогоОтбора);
	
	ИнтеграцияВЕТИСКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                       "Грузоотправитель",
	                                                                       ОрганизацииВЕТИС,
	                                                                       СтруктураПоиска,
	                                                                       НастройкиОрганизацияВЕТИС);
	
	ИнтеграцияВЕТИСКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                       "Ответственный",
	                                                                       Ответственный,
	                                                                       СтруктураБыстрогоОтбора,
	                                                                       Настройки);
	
	Настройки.Удалить("Ответственный");
	Настройки.Удалить("ОрганизацииВЕТИС");
	
	ИнтеграцияВЕТИС.ОтборПоОрганизацииПриСозданииНаСервере(ЭтотОбъект, "Отбор");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтраницаОформленоОтборСтатусВЕТИСПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "СтатусВЕТИС",
	                                                                        СтатусВЕТИС,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(СтатусВЕТИС));
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаОформленоОтборДальнейшееДействиеВЕТИСПриИзменении(Элемент)
	
	УстановитьОтборПоДальнейшемуДействиюСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаОформленоОтборОтветственныйПриИзменении(Элемент)
	
	ОтветственныйОтборПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаКОформлениюОтборОтветственныйПриИзменении(Элемент)
	
	ОтветственныйОтборПриИзменении();
	
КонецПроцедуры


#Область ОтборПоОрганизацииВЕТИС

&НаКлиенте
Процедура ОформленоОрганизацииВЕТИСПриИзменении(Элемент)
	
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, ОрганизацииВЕТИС, Истина, "Оформлено",,"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииВЕТИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОткрытьФормуВыбораОрганизацийВЕТИС(
		ЭтотОбъект, "Оформлено",,,"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииВЕТИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, Неопределено, Истина, "Оформлено",,"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииВЕТИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, ВыбранноеЗначение, Истина, "Оформлено",,"");
	
КонецПроцедуры


&НаКлиенте
Процедура ОформленоОрганизацияВЕТИСПриИзменении(Элемент)
	
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, ОрганизацииВЕТИС, Истина, "Оформлено",,"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияВЕТИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОткрытьФормуВыбораОрганизацийВЕТИС(
		ЭтотОбъект, "Оформлено",,,"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияВЕТИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, Неопределено, Истина, "Оформлено",,"");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияВЕТИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(
		ЭтотОбъект, ВыбранноеЗначение, Истина, "Оформлено",,"");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацииВЕТИСПриИзменении(Элемент)
	
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(ЭтотОбъект, ОрганизацииВЕТИС, Истина, "КОформлению",,"");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацииВЕТИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОткрытьФормуВыбораОрганизацийВЕТИС(
		ЭтотОбъект, "КОформлению",,,"");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацииВЕТИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(ЭтотОбъект, Неопределено, Истина, "КОформлению",,"");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацииВЕТИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(ЭтотОбъект, ВыбранноеЗначение, Истина, "КОформлению",,"");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацияВЕТИСПриИзменении(Элемент)
	
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(ЭтотОбъект, ОрганизацииВЕТИС, Истина, "КОформлению",,"");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацияВЕТИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОткрытьФормуВыбораОрганизацийВЕТИС(
		ЭтотОбъект, "КОформлению",,,"");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацияВЕТИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(ЭтотОбъект, Неопределено, Истина, "КОформлению",,"");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацияВЕТИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияВЕТИСКлиент.ОбработатьВыборОрганизацийВЕТИС(ЭтотОбъект, ВыбранноеЗначение, Истина, "КОформлению",,"");
	
КонецПроцедуры


#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Оформить(Команда)
	
	ОчиститьСообщения();
	
	Если Не ИнтеграцияИСКлиент.ВыборСтрокиДинамическогоСпискаКорректен(Элементы.СписокКОформлению) Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияИСКлиент.ОткрытьФормуСозданияДокумента(
		ИнтеграцияИСКлиентСервер.ИмяОбъектаИзИмениФормы(ЭтотОбъект),
		Элементы.СписокКОформлению.ТекущиеДанные.ДокументОснование,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Архивировать(Команда)
	
	ИнтеграцияИСКлиент.АрхивироватьРаспоряжения(
		ЭтотОбъект, Элементы.СписокКОформлению, ИнтеграцияВЕТИСКлиент,
		ПредопределенноеЗначение("Документ.ИнвентаризацияПродукцииВЕТИС.ПустаяСсылка"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетОРасхождениях(Команда)
	
	ИнтеграцияИСКлиент.ОткрытьОтчетОРасхожденияхИзРаспоряжений(Элементы.СписокКОформлению, "АнализРасхожденийПриИнвентаризацииПродукцииВЕТИС")
	
КонецПроцедуры

&НаКлиенте
Процедура АрхивироватьДокументы(Команда)
	
	ИнтеграцияИСКлиент.АрхивироватьДокументы(ЭтотОбъект, Элементы.Список, ИнтеграцияВЕТИСКлиент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередатьДанные(Команда)
	
	ПараметрыПередачи = ИнтеграцияВЕТИСКлиентСервер.СтруктураПараметрыПередачи();
	ПараметрыПередачи.ДальнейшееДействие = ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПередайтеДанные");
	
	ИнтеграцияВЕТИСКлиент.ПодготовитьСообщенияКПередаче(Элементы.Список, ПараметрыПередачи, ПравоИзменения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ИнтеграцияВЕТИСКлиент.ВыполнитьОбмен(
		ЭтотОбъект,
		ИнтеграцияВЕТИСКлиент.ОрганизацииВЕТИСДляОбмена(
			ЭтотОбъект));
	
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

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокКОформлению

&НаКлиенте
Процедура СписокКОформлениюВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ИнтеграцияИСКлиент.ОткрытьРаспоряжение(Элементы.СписокКОформлению, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Ошибки
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусВЕТИС.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.СтатусВЕТИС.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокСтатусов = Новый СписокЗначений;
	СписокСтатусов.ЗагрузитьЗначения(Документы.ПроизводственнаяОперацияВЕТИС.СтатусыОшибок());
	ОтборЭлемента.ПравоеЗначение = СписокСтатусов;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СтатусОбработкиОшибкаПередачиГосИС);
	
	// Требуется ожидание
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусВЕТИС.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.ДальнейшееДействиеВЕТИС.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокДействий = Новый СписокЗначений;
	СписокДействий.ЗагрузитьЗначения(Документы.ИнвентаризацияПродукцииВЕТИС.ВсеТребующиеОжидания());
	ОтборЭлемента.ПравоеЗначение = СписокДействий;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СтатусОбработкиПередаетсяГосИС);
	
	// Даты
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата",            Элементы.Дата.Имя);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДальнейшихДействий()
	
	КомандВГруппе = 1;
	
	ОперацииДопустимыхДействий = Документы.ИнвентаризацияПродукцииВЕТИС.ОперацииДопустимыхДействий();
	Если ОперацииДопустимыхДействий.Получить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПередайтеДанные) <> Неопределено Тогда
		Если НЕ ПользователиВЕТИС.ОперацияДоступнаПользователю(ОперацииДопустимыхДействий.Получить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПередайтеДанные)) Тогда
			КомандВГруппе = КомандВГруппе - 1;
			Элементы.СписокПередатьДанные.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если КомандВГруппе<2 Тогда
		Элементы.Действия.Вид = ВидГруппыФормы.ГруппаКнопок;
	КонецЕсли;
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьОбменОбработкаОжидания()
	
	ИнтеграцияВЕТИСКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект);
	
КонецПроцедуры

#Область Отбор

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "Ответственный",
	                                                                        Ответственный,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(Ответственный));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокКОформлению,
	                                                                        "Ответственный",
	                                                                        Ответственный,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(Ответственный));
	
КонецПроцедуры

#Область ОтборДальнейшиеДействия

&НаСервереБезКонтекста
Функция ВсеТребующиеДействия()
	
	Возврат Документы.ИнвентаризацияПродукцииВЕТИС.ВсеТребующиеДействия();
	
КонецФункции

&НаСервереБезКонтекста
Функция ВсеТребующиеОжидания()
	
	Возврат Документы.ИнвентаризацияПродукцииВЕТИС.ВсеТребующиеОжидания();
	
КонецФункции

&НаСервере
Процедура УстановитьОтборПоДальнейшемуДействиюСервер()
	
	ИнтеграцияВЕТИС.УстановитьОтборПоДальнейшемуДействию(Список,
	                                                     ДальнейшееДействиеВЕТИС,
	                                                     ВсеТребующиеДействия(),
	                                                     ВсеТребующиеОжидания());
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

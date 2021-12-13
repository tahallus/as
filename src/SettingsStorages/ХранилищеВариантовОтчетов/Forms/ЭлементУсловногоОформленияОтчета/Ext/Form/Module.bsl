﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПроверитьВозможностьРаботыСФормой();
	УстановитьЗаголовок();
	
	ЭлементОформления = ЭлементОформленияИсходный();
	Использование = ЭлементОформления.Использование;
	
	Если ИдентификаторКД <> Неопределено Тогда
		
		Наименование = ЭлементОформления.ПредставлениеПользовательскойНастройки;
		НаименованиеПоУмолчанию = ОтчетыКлиентСервер.ПредставлениеЭлементаУсловногоОформления(
			ЭлементОформления, Неопределено, "");
		
		НаименованиеПереопределено = (Наименование <> "" И Наименование <> НаименованиеПоУмолчанию);
		Элементы.Наименование.ПодсказкаВвода = НаименованиеПоУмолчанию;
		
		Если Не НаименованиеПереопределено Тогда
			
			Наименование = "";
			Элементы.Наименование.КнопкаОчистки = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ПроверитьПолеОформления(ЭлементОформления);
	ПроверитьУсловие(ЭлементОформления);
	
	Для Каждого ПолеФлажка Из Элементы.ВариантыИспользованияПометки.ПодчиненныеЭлементы Цикл
		
		ИмяФлажка = ПолеФлажка.Имя;
		ФлажкиОбластиОтображения.Добавить(ИмяФлажка);
		
		Если ЭлементОформления[ИмяФлажка] = ИспользованиеУсловногоОформленияКомпоновкиДанных.Использовать Тогда
			ЭтотОбъект[ИмяФлажка] = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	ЗаполнитьСписокВыбораОформляемыхПолей(ЭлементОформления);
	УстановитьВариантВыбораОформляемогоПоля(ЭлементОформления);
	
	ЗакрыватьПриВыборе = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантВыбораОформляемыхПолейПриИзменении(Элемент)
	
	ПрименитьВариантВыбораОформляемогоПоля(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОформляемоеПолеПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ОформляемоеПоле) Тогда 
		
		ВариантВыбораОформляемыхПолей = Элементы.ВариантВыбораОформляемыхПолей.СписокВыбора[0].Значение;
		ПрименитьВариантВыбораОформляемогоПоля(ЭтотОбъект);
		
	КонецЕсли;
	
	ОбновитьНаименованиеПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформляемоеПолеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИспользуемыеПоля = ИспользуемыеОформляемыеПоля(ЭтотОбъект);
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("ПолеКомпоновкиДанных") Тогда 
		
		Поле = ВыбранноеЗначение;
		
		Оформление = Оформление(ЭтотОбъект);
		ДоступноеПоле = Оформление.ДоступныеПоляПолей.НайтиПоле(Поле);
		
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("ДоступноеПолеКомпоновкиДанных") Тогда 
		
		Поле = ВыбранноеЗначение.Поле;
		ДоступноеПоле = ВыбранноеЗначение;
		
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("ПользовательскоеПолеВыражениеКомпоновкиДанных") Тогда 
		
		ОбновитьСоставОписанияФормул(ВыбранноеЗначение);
		
		Оформление = Оформление(ЭтотОбъект);
		
		ДоступноеПоле = ВыбранноеЗначение;
		ВариантыОтчетовСлужебныйКлиент.ДобавитьФормулу(КомпоновщикНастроек.Настройки, Оформление.ДоступныеПоляПолей, ДоступноеПоле);
		
		Поле = ДоступноеПоле.Поле;
		
	Иначе
		
		ВыбратьОформляемоеПоле(Элемент, ВыбранноеЗначение, ИспользуемыеПоля);
		Возврат;
		
	КонецЕсли;
	
	Если ИспользуемыеПоля.Количество() = 0 Тогда 
		
		ЭлементОформления = ЭлементОформления(КомпоновщикНастроек.Настройки);
		ИспользуемоеПоле = ЭлементОформления.Поля.Элементы.Вставить(0);
		ИспользуемоеПоле.Использование = Истина;
		
	Иначе
		
		ИспользуемоеПоле = ИспользуемыеПоля[0];
		
	КонецЕсли;
	
	ИспользуемоеПоле.Поле = Поле;
	
	ДополнитьСписокВыбораОформляемыхПолей(ЭтотОбъект, Поле, ДоступноеПоле);
	ОформляемоеПоле = Поле;
	
	ОбновитьНаименованиеПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Если Наименование = "" Или Наименование = Элементы.Наименование.ПодсказкаВвода Тогда
		ТребуетсяОбновлениеНаименованияПоУмолчанию = Истина;
		ОбновитьНаименованиеПоУмолчаниюЕслиТребуется();
		Элементы.Наименование.КнопкаОчистки = Ложь;
	Иначе
		Элементы.Наименование.КнопкаОчистки = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВГруппировкеПриИзменении(Элемент)
	
	ОбновитьНаименованиеПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВИерархическойГруппировкеПриИзменении(Элемент)
	
	ОбновитьНаименованиеПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВОбщемИтогеПриИзменении(Элемент)
	
	ОбновитьНаименованиеПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВЗаголовкеПолейПриИзменении(Элемент)
	
	ОбновитьНаименованиеПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВЗаголовкеПриИзменении(Элемент)
	
	ОбновитьНаименованиеПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВПараметрахПриИзменении(Элемент)
	
	ОбновитьНаименованиеПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВОтбореПриИзменении(Элемент)
	
	ОбновитьНаименованиеПоУмолчанию();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОформление

&НаКлиенте
Процедура ОформлениеПриИзменении(Элемент)
	
	ОбновитьНаименованиеПоУмолчанию();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОтбор

&НаКлиенте
Процедура ОтборПриИзменении(Элемент)
	
	ОбновитьНаименованиеПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ИзменитьПоле(Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПередНачаломИзменения(Элемент, Отказ)
	
	Если Элемент.ТекущийЭлемент.Имя = Элементы.ОтборЛевоеЗначение.Имя Тогда 
		ИзменитьПоле(Элемент, Отказ, Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОформляемыеПоля

&НаКлиенте
Процедура ОформляемыеПоляПриИзменении(Элемент)
	
	ОбновитьНаименованиеПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформляемыеПоляПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ИзменитьПоле(Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОформляемыеПоляПередНачаломИзменения(Элемент, Отказ)
	
	ИзменитьПоле(Элемент, Отказ, Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Показывать_УстановитьПометки(Команда)
	
	Для Каждого ЭлементСписка Из ФлажкиОбластиОтображения Цикл
		ЭтотОбъект[ЭлементСписка.Значение] = Истина;
	КонецЦикла;
	
	ОбновитьНаименованиеПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура Показывать_СнятьПометки(Команда)
	
	Для Каждого ЭлементСписка Из ФлажкиОбластиОтображения Цикл
		ЭтотОбъект[ЭлементСписка.Значение] = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьНаименованиеПоУмолчанию(Команда)
	
	Наименование = НаименованиеПоУмолчанию;
	Элементы.Наименование.КнопкаОчистки = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПроверитьВозможностьРаботыСФормой()
	
	Если Не Параметры.Свойство("КомпоновщикНастроек", КомпоновщикНастроек) Тогда
		ВызватьИсключение НСтр("ru = 'Не передан служебный параметр ""КомпоновщикНастроек"".'");
	КонецЕсли;
	
	Если Не Параметры.Свойство("НастройкиОтчета", НастройкиОтчета) Тогда
		ВызватьИсключение НСтр("ru = 'Не передан служебный параметр ""НастройкиОтчета"".'");
	КонецЕсли;
	
	Если Не Параметры.Свойство("ИдентификаторЭлементаСтруктурыНастроек", ИдентификаторЭлементаСтруктурыНастроек) Тогда
		ВызватьИсключение НСтр("ru = 'Не передан служебный параметр ""ИдентификаторЭлементаСтруктурыНастроек"".'");
	КонецЕсли;
	
	Если Не Параметры.Свойство("ИдентификаторКД", ИдентификаторКД) Тогда
		ВызватьИсключение НСтр("ru = 'Не передан служебный параметр ""ИдентификаторКД"".'");
	КонецЕсли;
	
	Если Не Параметры.Свойство("Наименование", Наименование) Тогда
		ВызватьИсключение НСтр("ru = 'Не передан служебный параметр ""Наименование"".'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовок()
	
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Заголовок) Тогда 
		Заголовок = НСтр("ru = 'Оформление'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЭлементОформленияИсходный()
	
	Источник = Новый ИсточникДоступныхНастроекКомпоновкиДанных(НастройкиОтчета.АдресСхемы);
	КомпоновщикНастроек.Инициализировать(Источник);
	
	Оформление = КомпоновщикНастроек.Настройки.УсловноеОформление;
	
	Если ИдентификаторКД = Неопределено Тогда // Новый элемент
		
		ЭтоНовый = Истина;
		
		ЭлементОформления = Оформление.Элементы.Вставить(0);
		ЭлементОформления.Использование = Истина;
		ЭлементОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
		
		Элементы.Наименование.КнопкаОчистки = Ложь;
		
	Иначе
		
		ОформлениеИсточник = Оформление(ЭтотОбъект);
		Если ОформлениеИсточник = Неопределено Тогда
			ВызватьИсключение НСтр("ru = 'Не существует узел отчета.'");
		КонецЕсли;
		
		ЭлементОформленияИсточник = ОформлениеИсточник.ПолучитьОбъектПоИдентификатору(ИдентификаторКД);
		Если ЭлементОформленияИсточник = Неопределено Тогда
			ВызватьИсключение НСтр("ru = 'Не существует элемент условного оформления.'");
		КонецЕсли;
		
		ЭлементОформления = ОтчетыКлиентСервер.СкопироватьРекурсивно(Оформление, ЭлементОформленияИсточник, Оформление.Элементы, 0, Новый Соответствие);
		
	КонецЕсли;
	
	Возврат ЭлементОформления;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭлементОформления(Настройки)
	
	Возврат Настройки.УсловноеОформление.Элементы[0];
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция Оформление(Форма)
	
	Настройки = Форма.КомпоновщикНастроек.Настройки;
	
	Если Форма.ИдентификаторЭлементаСтруктурыНастроек = Неопределено Тогда
		Возврат Настройки.УсловноеОформление;
	КонецЕсли;
	
	ЭлементСтруктуры = Настройки.ПолучитьОбъектПоИдентификатору(Форма.ИдентификаторЭлементаСтруктурыНастроек);
	
	Возврат ЭлементСтруктуры.УсловноеОформление;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция НайденноеПолеОформления(Настройки, ИскомоеПоле)
	
	ЭлементОформления = ЭлементОформления(Настройки);
	
	Для Каждого Элемент Из ЭлементОформления.Поля.Элементы Цикл 
		
		Если Элемент.Поле = ИскомоеПоле Тогда  
			Возврат Элемент;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Процедура ПроверитьПолеОформления(ЭлементОформления)
	
	Если Не Параметры.Свойство("Поле")
		Или ТипЗнч(Параметры.Поле) <> Тип("ПолеКомпоновкиДанных") Тогда 
		
		Возврат;
	КонецЕсли;
	
	ПолеОформления = НайденноеПолеОформления(КомпоновщикНастроек.Настройки, Параметры.Поле);
	
	Если ПолеОформления  = Неопределено Тогда 
		
		ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
		ПолеОформления.Поле = Параметры.Поле;
		
	КонецЕсли;
	
	ПолеОформления.Использование = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьУсловие(ЭлементОформления)
	
	Условие = Неопределено;
	
	Если Не Параметры.Свойство("Условие", Условие)
		Или ТипЗнч(Условие) <> Тип("Структура") Тогда 
		
		Возврат;
	КонецЕсли;
	
	ЭлементОтбора = Неопределено;
	
	Для Каждого Элемент Из ЭлементОформления.Отбор.Элементы Цикл 
		
		Если ТипЗнч(Элемент) = Тип("ЭлементОтбораКомпоновкиДанных")
			И Элемент.ЛевоеЗначение = Условие.ЛевоеЗначение Тогда 
			
			ЭлементОтбора = Элемент;
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЭлементОтбора = Неопределено Тогда 
		
		ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Условие.ЛевоеЗначение;
		
	КонецЕсли;
	
	ЭлементОтбора.ВидСравнения = Условие.ВидСравнения;
	ЭлементОтбора.ПравоеЗначение = Условие.ПравоеЗначение;
	ЭлементОтбора.Использование = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНаименованиеПоУмолчанию()
	
	ТребуетсяОбновлениеНаименованияПоУмолчанию = Истина;
	
	Если Наименование = "" Или Наименование = Элементы.Наименование.ПодсказкаВвода Тогда
		ПодключитьОбработчикОжидания("ОбновитьНаименованиеПоУмолчаниюЕслиТребуется", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНаименованиеПоУмолчаниюЕслиТребуется()
	
	Если Не ТребуетсяОбновлениеНаименованияПоУмолчанию Тогда
		Возврат;
	КонецЕсли;
	
	ТребуетсяОбновлениеНаименованияПоУмолчанию = Ложь;
	
	ЭлементОформления = ЭлементОформления(КомпоновщикНастроек.Настройки);
	
	НаименованиеПоУмолчанию = ОтчетыКлиентСервер.ПредставлениеЭлементаУсловногоОформления(ЭлементОформления, Неопределено, "");
	Если Наименование = Элементы.Наименование.ПодсказкаВвода Тогда
		
		Наименование = НаименованиеПоУмолчанию;
		Элементы.Наименование.ПодсказкаВвода = НаименованиеПоУмолчанию;
		
	ИначеЕсли Наименование = "" Тогда
		
		Элементы.Наименование.ПодсказкаВвода = НаименованиеПоУмолчанию;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИЗакрыть()
	
	ОтключитьОбработчикОжидания("ОбновитьНаименованиеПоУмолчаниюЕслиТребуется");
	ОбновитьНаименованиеПоУмолчаниюЕслиТребуется();
	
	Если Наименование = "" Тогда
		Наименование = НаименованиеПоУмолчанию;
	КонецЕсли;
	
	ЭлементОформления = ЭлементОформления(КомпоновщикНастроек.Настройки);
	
	Если Наименование = НаименованиеПоУмолчанию Тогда
		ЭлементОформления.ПредставлениеПользовательскойНастройки = "";
	Иначе
		ЭлементОформления.ПредставлениеПользовательскойНастройки = Наименование;
	КонецЕсли;
	
	Для Каждого ЭлементСписка Из ФлажкиОбластиОтображения Цикл
		
		ИмяФлажка = ЭлементСписка.Значение;
		
		Если ЭтотОбъект[ИмяФлажка] Тогда
			ЭлементОформления[ИмяФлажка] = ИспользованиеУсловногоОформленияКомпоновкиДанных.Использовать;
		Иначе
			ЭлементОформления[ИмяФлажка] = ИспользованиеУсловногоОформленияКомпоновкиДанных.НеИспользовать;
		КонецЕсли;
		
	КонецЦикла;
	
	УточнитьСоставОформляемыхПолей(ЭлементОформления);
	
	ЭлементОформления.Использование = Использование;
	
	ОписаниеФормул = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(НастройкиОтчета, "ОписаниеФормул", Новый Массив);
	
	Результат = Новый Структура();
	Результат.Вставить("ЭлементКД", ЭлементОформления);
	Результат.Вставить("Наименование", Наименование);
	Результат.Вставить("ОписаниеФормул", ОписаниеФормул);
	
	ОповеститьОВыборе(Результат);
	Закрыть(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораОформляемыхПолей(ЭлементОформления)
	
	Список = Элементы.ОформляемоеПоле.СписокВыбора;
	
	Оформление = Оформление(ЭтотОбъект);
	ДоступныеПоля = Оформление.ДоступныеПоляПолей.Элементы;
	
	Граница = Мин(19, ДоступныеПоля.Количество() - 1);
	
	Для Индекс = 0 По Граница Цикл 
		
		ДоступноеПоле = ДоступныеПоля[Индекс];
		
		Если Не ДоступноеПоле.Папка Тогда 
			
			КартинкаПоля = ВариантыОтчетовСлужебныйКлиентСервер.КартинкаПоля(ДоступноеПоле.ТипЗначения);
			Список.Добавить(ДоступноеПоле.Поле, ДоступноеПоле.Заголовок,, КартинкаПоля);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ИспользуемыеПоля = ИспользуемыеОформляемыеПоля(ЭтотОбъект, ЭлементОформления);
	
	Если ИспользуемыеПоля.Количество() > 0 Тогда 
		
		ИспользуемоеПоле = ИспользуемыеПоля[0].Поле;
		ДоступноеПоле = Оформление.ДоступныеПоляПолей.НайтиПоле(ИспользуемоеПоле);
		ДополнитьСписокВыбораОформляемыхПолей(ЭтотОбъект, ИспользуемоеПоле, ДоступноеПоле);
		
	КонецЕсли;
	
	Если Список.НайтиПоЗначению("Еще") = Неопределено Тогда 
		
		Список.СортироватьПоПредставлению();
		Список.Добавить("Еще", НСтр("ru = 'Еще...'"),, БиблиотекаКартинок.Пустая);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВариантВыбораОформляемогоПоля(ЭлементОформления)
	
	ИспользуемыеПоля = ИспользуемыеОформляемыеПоля(ЭтотОбъект, ЭлементОформления);
	ВариантыВыбора = Элементы.ВариантВыбораОформляемыхПолей.СписокВыбора;
	
	Если ИспользуемыеПоля.Количество() = 0 Тогда 
		
		ВариантВыбораОформляемыхПолей = ВариантыВыбора[0].Значение;
		
	ИначеЕсли ИспользуемыеПоля.Количество() = 1 Тогда 
		
		ВариантВыбораОформляемыхПолей = ВариантыВыбора[1].Значение;
		
	Иначе
		
		ВариантВыбораОформляемыхПолей = ВариантыВыбора[2].Значение;
		
	КонецЕсли;
	
	ПрименитьВариантВыбораОформляемогоПоля(ЭтотОбъект, ЭлементОформления, ИспользуемыеПоля);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИспользуемыеОформляемыеПоля(Форма, ЭлементОформления = Неопределено)
	
	Если ЭлементОформления = Неопределено Тогда 
		ЭлементОформления = ЭлементОформления(Форма.КомпоновщикНастроек.Настройки);
	КонецЕсли;
	
	ИспользуемыеПоля = Новый Массив;
	
	ОформляемыеПоля = ЭлементОформления.Поля.Элементы;
	
	Для Каждого ОформляемоеПоле Из ОформляемыеПоля Цикл 
		
		Если ОформляемоеПоле.Использование Тогда 
			ИспользуемыеПоля.Добавить(ОформляемоеПоле);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ИспользуемыеПоля;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПрименитьВариантВыбораОформляемогоПоля(Форма, ЭлементОформления = Неопределено, ИспользуемыеПоля = Неопределено)
	
	Если ЭлементОформления = Неопределено Тогда 
		ЭлементОформления = ЭлементОформления(Форма.КомпоновщикНастроек.Настройки);
	КонецЕсли;
	
	Если ИспользуемыеПоля = Неопределено Тогда 
		ИспользуемыеПоля = ИспользуемыеОформляемыеПоля(Форма, ЭлементОформления);
	КонецЕсли;
	
	ЭлементыФормы = Форма.Элементы;
	
	Вариант = Форма.ВариантВыбораОформляемыхПолей;
	Варианты = ЭлементыФормы.ВариантВыбораОформляемыхПолей.СписокВыбора;
	
	Если Вариант = Варианты[0].Значение Тогда 
		
		ЭлементыФормы.ОформляемыеПоляСтраницы.ТекущаяСтраница = ЭлементыФормы.СтраницаОформляемоеПоле;
		ЭлементыФормы.ОформляемыеПоля.Видимость = Ложь;
		
		Форма.ОформляемоеПоле = Неопределено;
		ЭлементыФормы.ОформляемоеПоле.ТолькоПросмотр = Истина;
		
	ИначеЕсли Вариант = Варианты[1].Значение Тогда 
		
		ЭлементыФормы.ОформляемыеПоляСтраницы.ТекущаяСтраница = ЭлементыФормы.СтраницаОформляемоеПоле;
		ЭлементыФормы.ОформляемыеПоля.Видимость = Ложь;
		
		Форма.ОформляемоеПоле = ?(ИспользуемыеПоля.Количество() = 0, Неопределено, ИспользуемыеПоля[0].Поле);
		ЭлементыФормы.ОформляемоеПоле.ТолькоПросмотр = Ложь;
		
	Иначе
		
		ЭлементыФормы.ОформляемыеПоляСтраницы.ТекущаяСтраница = ЭлементыФормы.СтраницаКоманднаяПанель;
		ЭлементыФормы.ОформляемыеПоля.Видимость = Истина;
		
		Форма.ОформляемоеПоле = Неопределено;
		ЭлементыФормы.ОформляемоеПоле.ТолькоПросмотр = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОформляемоеПоле(Элемент, ВыбранноеЗначение, ИспользуемыеПоля)
	
	Если ВыбранноеЗначение <> "Еще" Тогда 
		Возврат;
	КонецЕсли;
	
	Поле = ?(ИспользуемыеПоля.Количество() = 0, Неопределено, ИспользуемыеПоля[0].Поле);
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("НастройкиОтчета", НастройкиОтчета);
	ПараметрыВыбора.Вставить("КомпоновщикНастроек", КомпоновщикНастроек);
	ПараметрыВыбора.Вставить("Режим", "ВыбранныеПоля");
	ПараметрыВыбора.Вставить("ПолеКД", Поле);
	ПараметрыВыбора.Вставить("ИдентификаторЭлементаСтруктурыНастроек", ИдентификаторЭлементаСтруктурыНастроек);
	
	ОткрытьФорму("ХранилищеНастроек.ХранилищеВариантовОтчетов.Форма.ВыборПоляОтчета",
		ПараметрыВыбора, Элемент, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДополнитьСписокВыбораОформляемыхПолей(Форма, Поле, ДоступноеПоле)
	
	Список = Форма.Элементы.ОформляемоеПоле.СписокВыбора;
	НайденноеПоле = Список.НайтиПоЗначению(Поле);
	
	Если НайденноеПоле = Неопределено Тогда 
		
		ТипЗначенияПоля = Неопределено;
		ЗаголовокПоля = Строка(Поле);
		
		Если ДоступноеПоле <> Неопределено Тогда 
			
			ТипЗначенияПоля = ДоступноеПоле.ТипЗначения;
			ЗаголовокПоля = ДоступноеПоле.Заголовок;
			
		КонецЕсли;
		
		КартинкаПоля = ВариантыОтчетовСлужебныйКлиентСервер.КартинкаПоля(ТипЗначенияПоля);
		Список.Добавить(Поле, ЗаголовокПоля,, КартинкаПоля);
		
	ИначеЕсли ДоступноеПоле <> Неопределено Тогда 
		
		НайденноеПоле.Представление = ДоступноеПоле.Заголовок;
	
	КонецЕсли;
	
	ДополнительноеПоле = Список.НайтиПоЗначению("Еще");
	
	Если ДополнительноеПоле <> Неопределено Тогда
		Список.Удалить(ДополнительноеПоле);
	КонецЕсли;
	
	Список.СортироватьПоПредставлению();
	Список.Добавить("Еще", НСтр("ru = 'Еще...'"),, БиблиотекаКартинок.Пустая);
	
КонецПроцедуры

&НаКлиенте
Процедура УточнитьСоставОформляемыхПолей(ЭлементОформления)
	
	Варианты = Элементы.ВариантВыбораОформляемыхПолей.СписокВыбора;
	
	Если ВариантВыбораОформляемыхПолей = Варианты[2].Значение Тогда 
		Возврат;
	КонецЕсли;
	
	НачальныйИндекс = 1;
	
	Если ВариантВыбораОформляемыхПолей = Варианты[0].Значение Тогда 
		НачальныйИндекс = 0;
	КонецЕсли;
	
	ИспользуемыеПоля = ИспользуемыеОформляемыеПоля(ЭтотОбъект, ЭлементОформления);
	Поля = ЭлементОформления.Поля.Элементы;
	
	Для Индекс = НачальныйИндекс По ИспользуемыеПоля.ВГраница() Цикл 
		Поля.Удалить(ИспользуемыеПоля[Индекс]);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПоле(Элемент, Отказ, ЭтоДобавление = Истина)
	
	Отказ = Истина;
	
	ТекущаяЗаписьКоллекцииОформления = ТекущаяЗаписьКоллекцииОформления(Элемент, ЭтоДобавление);
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("НастройкиОтчета", НастройкиОтчета);
	ПараметрыВыбора.Вставить("КомпоновщикНастроек", КомпоновщикНастроек);
	ПараметрыВыбора.Вставить("Режим", РежимВыбораПоля(Элемент));
	ПараметрыВыбора.Вставить("ПолеКД", ТекущееПоле(ТекущаяЗаписьКоллекцииОформления));
	ПараметрыВыбора.Вставить("ИдентификаторЭлементаСтруктурыНастроек", ИдентификаторЭлементаСтруктурыНастроек);
	
	ДополнительныеПараметры = Новый Структура("Элемент, ТекущаяЗаписьКоллекцииОформления", Элемент, ТекущаяЗаписьКоллекцииОформления);
	Обработчик = Новый ОписаниеОповещения("ПослеВыбораПоля", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ХранилищеНастроек.ХранилищеВариантовОтчетов.Форма.ВыборПоляОтчета",
		ПараметрыВыбора, ЭтотОбъект, УникальныйИдентификатор,,, Обработчик);
	
КонецПроцедуры

// Параметры:
//  ВыбранноеЗначение - ПользовательскоеПолеВыражениеКомпоновкиДанных
//                    - ДоступноеПолеКомпоновкиДанных
//                    - ДоступноеПолеОтбораКомпоновкиДанных
//  ДополнительныеПараметры - Структура:
//    * Элемент - ТаблицаФормы
//    * ТекущаяЗаписьКоллекцииОформления - ЭлементОтбораКомпоновкиДанных
//                                       - ОформляемоеПолеКомпоновкиДанных
//                                       - Неопределено
//
&НаКлиенте
Процедура ПослеВыбораПоля(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт 
	
	Если ВыбранноеЗначение = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДоступныеПоля = ДоступныеПоля(ДополнительныеПараметры.Элемент);
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("ПользовательскоеПолеВыражениеКомпоновкиДанных") Тогда 
		
		ОбновитьСоставОписанияФормул(ВыбранноеЗначение);
		ВариантыОтчетовСлужебныйКлиент.ДобавитьФормулу(КомпоновщикНастроек.Настройки, ДоступныеПоля, ВыбранноеЗначение);
		
	КонецЕсли;
	
	Если ДоступныеПоля.НайтиПоле(ВыбранноеЗначение.Поле) = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ТекущаяЗаписьКоллекцииОформления = ДополнительныеПараметры.ТекущаяЗаписьКоллекцииОформления;
	
	Если ДополнительныеПараметры.Элемент = Элементы.ОформляемыеПоля Тогда 
		ОбновитьПолеОформления(КомпоновщикНастроек.Настройки, ТекущаяЗаписьКоллекцииОформления, ВыбранноеЗначение.Поле);
	Иначе
		ОбновитьПолеУсловияОформления(КомпоновщикНастроек.Настройки, ТекущаяЗаписьКоллекцииОформления, ВыбранноеЗначение.Поле);
	КонецЕсли;
	
	ОбновитьНаименованиеПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПолеОформления(Настройки, ТекущееПоле, ВыбранноеПоле)
	
	ЭлементОформления = ЭлементОформления(Настройки);
	
	Если ТекущееПоле = Неопределено Тогда 
		
		ПолеОформления = НайденноеПолеОформления(Настройки, ВыбранноеПоле);
		
		Если ПолеОформления = Неопределено Тогда 
			ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
		КонецЕсли;
		
	Иначе
		ПолеОформления = ТекущееПоле;
	КонецЕсли;
	
	ПолеОформления.Поле = ВыбранноеПоле;
	ПолеОформления.Использование = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПолеУсловияОформления(Настройки, ТекущееУсловие, ВыбранноеПоле)
	
	ЭлементОформления = ЭлементОформления(Настройки);
	
	Если ТекущееУсловие = Неопределено Тогда 
		
		Условие = НайденноеУсловиеОформления(Настройки, ВыбранноеПоле);
		
		Если Условие = Неопределено Тогда 
			
			Условие = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			Элементы.Отбор.Развернуть(Элементы.Отбор.ТекущаяСтрока, Истина);
			
		КонецЕсли;
		
	Иначе
		Условие = ТекущееУсловие;
	КонецЕсли;
	
	Условие.ЛевоеЗначение = ВыбранноеПоле;
	Условие.Использование = Истина;
	
КонецПроцедуры

&НаКлиенте
Функция НайденноеУсловиеОформления(Настройки, ИскомоеПоле, Условия = Неопределено, НайденноеУсловие = Неопределено)
	
	Если Условия = Неопределено Тогда 
		
		ЭлементОформления = ЭлементОформления(Настройки);
		Условия = ЭлементОформления.Отбор;
		
	КонецЕсли;
	
	Для Каждого Элемент Из Условия.Элементы Цикл 
		
		Если ТипЗнч(Элемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда 
			
			НайденноеУсловиеОформления(Настройки, ИскомоеПоле, Элемент, НайденноеУсловие);
			
		ИначеЕсли Элемент.ЛевоеЗначение = ИскомоеПоле Тогда  
			
			НайденноеУсловие = Элемент;
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат НайденноеУсловие;
	
КонецФункции

&НаКлиенте
Функция ТекущаяЗаписьКоллекцииОформления(Элемент, ЭтоДобавление)
	
	Если ЭтоДобавление Тогда 
		Возврат Неопределено;
	КонецЕсли;
	
	Строка = Элемент.ТекущиеДанные;
	
	Если Строка = Неопределено Тогда 
		Возврат Неопределено;
	КонецЕсли;
	
	Если Элемент = Элементы.ОформляемыеПоля Тогда 
		Возврат НайденноеПолеОформления(КомпоновщикНастроек.Настройки, Строка.Поле);
	КонецЕсли;
	
	Возврат НайденноеУсловиеОформления(КомпоновщикНастроек.Настройки, Строка.ЛевоеЗначение);
	
КонецФункции

&НаКлиенте
Функция ТекущееПоле(ТекущаяЗаписьКоллекцииОформления)
	
	Если ТипЗнч(ТекущаяЗаписьКоллекцииОформления) = Тип("ОформляемоеПолеКомпоновкиДанных") Тогда 
		
		Возврат ТекущаяЗаписьКоллекцииОформления.Поле;
		
	ИначеЕсли ТипЗнч(ТекущаяЗаписьКоллекцииОформления) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда 
		
		Возврат ТекущаяЗаписьКоллекцииОформления.ЛевоеЗначение;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Функция РежимВыбораПоля(Элемент)
	
	Если Элемент = Элементы.ОформляемыеПоля Тогда 
		Возврат "ПоляОформления";
	КонецЕсли;
	
	Возврат "УсловияОформления";
	
КонецФункции

&НаКлиенте
Функция ДоступныеПоля(Элемент)
	
	Оформление = Оформление(ЭтотОбъект);
	
	Если Элемент = Элементы.ОформляемыеПоля Тогда 
		Возврат Оформление.ДоступныеПоляПолей;
	КонецЕсли;
	
	Возврат Оформление.ДоступныеПоляОтбора;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьСоставОписанияФормул(ОписаниеФормулы)
	
	ОписаниеФормул = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(НастройкиОтчета, "ОписаниеФормул", Новый Массив);
	
	Если ОписаниеФормул.Найти(ОписаниеФормулы) = Неопределено Тогда 
		ОписаниеФормул.Добавить(ОписаниеФормулы);
	КонецЕсли;
	
	НастройкиОтчета.Вставить("ОписаниеФормул", ОписаниеФормул);
	
КонецПроцедуры

#КонецОбласти
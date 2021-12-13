﻿&НаКлиенте
Перем КонтекстЭДОКлиент Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	СписокПользователей = Параметры.СписокПользователей;
	ЗапретитьИзменение  = Параметры.ЗапретитьИзменение;
	Элементы.ПодсказкаФормы.Заголовок = Параметры.ПодсказкаКПользователям;
	
	Если ЗапретитьИзменение Тогда
		Элементы.Пользователи.ТолькоПросмотр = Истина;
		Элементы.Сохранить.Видимость = Ложь;
		Элементы.ФормаЗакрыть.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПередЗакрытием_Завершение", 
		ЭтотОбъект);
	
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(
		ОписаниеОповещения, 
		Отказ, 
		ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ПользователиПометкаПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда = Неопределено)
	
	Если ПользователиУказаныКорректно() Тогда
		Модифицированность = Ложь;
		Закрыть(СписокПользователей);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсех(Команда)
	
	Для каждого СтрокаПользователей Из СписокПользователей Цикл
		СтрокаПользователей.Пометка = Истина;
	КонецЦикла;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВсех(Команда)
	
	Для каждого СтрокаПользователей Из СписокПользователей Цикл
		СтрокаПользователей.Пометка = Ложь;
	КонецЦикла;
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПользователиУказаныКорректно()
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	Возврат КонтекстЭДОСервер.ПользователиУказаныКорректно(ЭтотОбъект);
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	Сохранить();
	
КонецПроцедуры

#КонецОбласти
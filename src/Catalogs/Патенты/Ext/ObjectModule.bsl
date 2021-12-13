﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)

	Если ДанныеЗаполнения = Неопределено Тогда
		ДанныеЗаполнения = Новый Структура;
	КонецЕсли;
	
	Если НЕ ДанныеЗаполнения.Свойство("ДатаНачала") Тогда
		Если ДанныеЗаполнения.Свойство("ДатаОкончания") Тогда
			ДатаНачала = НачалоГода(ДанныеЗаполнения.ДатаОкончания);
		Иначе
			ДатаНачала = НачалоГода(ТекущаяДатаСеанса());
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ДанныеЗаполнения.Свойство("ДатаОкончания") Тогда
		ДатаОкончания = КонецГода(ДатаНачала);
	КонецЕсли;
	

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(ДатаНачала) И ЗначениеЗаполнено(ДатаОкончания) Тогда
		
		ДатаНачалаДействияПатентнойСистемы	= '20130101';
		
		Если ДатаНачала > ДатаОкончания Тогда
			ТекстОшибки = НСтр("ru = 'Неверно задан период'");
			ТекстОшибки = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Поле", "Корректность", "Дата окончания", , , ТекстОшибки);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "ДатаОкончания", "Объект", Отказ);
		ИначеЕсли ДатаНачала < ДатаНачалаДействияПатентнойСистемы И ДатаОкончания >= ДатаНачалаДействияПатентнойСистемы Тогда
			ТекстОшибки = НСтр(
				"ru = 'Патенты со сроком действия, истекающим после 01.01.2013 г. действуют только до конца 2012 года'");
			ТекстОшибки = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Поле", "Корректность", "Дата окончания", , , ТекстОшибки);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "ДатаОкончания", "Объект", Отказ);
		ИначеЕсли ДатаНачала >= ДатаНачалаДействияПатентнойСистемы И Год(ДатаНачала) <> Год(ДатаОкончания) Тогда
			ТекстОшибки = НСтр(
				"ru = 'Патент выдается на период от одного до двенадцати месяцев включительно в пределах календарного года'");
			ТекстОшибки = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Поле", "Корректность", "Дата окончания", , , ТекстОшибки);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "ДатаОкончания", "Объект", Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли

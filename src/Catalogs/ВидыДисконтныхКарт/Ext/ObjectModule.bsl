﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПредопределенныеПроцедурыОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью.
//
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не СтарыйМеханизмСкидок Тогда
		КраткийСоставСкидок = НСтр("ru = '<Автоскидки>'");
	ИначеЕсли ВидСкидкиВДисконтныхКартах = Перечисления.ВидыСкидокВДисконтныхКартах.ФиксированнаяСкидка Тогда
		КраткийСоставСкидок = "" + Скидка + "%";
		ВидПериода = Перечисления.ВидыПериодовДляНакопительныхСкидок.ПустаяСсылка();
		Периодичность = Перечисления.Периодичность.ПустаяСсылка();
	Иначе
		ПервыйПроход = Истина;
		ТекСостав = "";
		Для каждого ТекСтр Из ПорогиНакопительныхСкидок Цикл
		
			Если ПервыйПроход Тогда
				ПервыйПроход = Ложь;
			Иначе
				ТекСостав = ТекСостав + "; ";
			КонецЕсли;
			ТекСостав = ТекСостав + ТекСтр.НижняяГраница + " - " + ТекСтр.Скидка + "%";
		
		КонецЦикла;
		
		КраткийСоставСкидок = ТекСостав;
		
		Если ВидПериода = Перечисления.ВидыПериодовДляНакопительныхСкидок.ВесьПериод Тогда
			Периодичность = Перечисления.Периодичность.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ВидСкидкиВДисконтныхКартах <> Перечисления.ВидыСкидокВДисконтныхКартах.НакопительнаяСкидка ИЛИ ВидПериода = Перечисления.ВидыПериодовДляНакопительныхСкидок.ВесьПериод Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Периодичность"));
	КонецЕсли;
	
	Если ВидСкидкиВДисконтныхКартах <> Перечисления.ВидыСкидокВДисконтныхКартах.НакопительнаяСкидка Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ВидПериода"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
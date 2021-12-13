﻿
#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	Если Параметры.Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПриЗапуске = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыПриЗапуске.ДоступноИспользованиеРазделенныхДанных 
		И ПараметрыПриЗапуске.МиграцияПриложенийОткрытьФорму Тогда
		Форма = ПолучитьФорму("Обработка.МастерПереходаВОблако.Форма.МиграцияПриложения");
		Форма.ПриОткрытииФормы(Истина);
	КонецЕсли;
	
КонецПроцедуры

// Возвращаемое значение: 
//  Строка - имя формы перехода в сервис.
Функция ИмяФормыПереходаВСервис() Экспорт

	Возврат "ТехнологияСервиса.МиграцияПриложений.ФормаПереходВСервис";
	
КонецФункции

// Возвращаемое значение: 
//  ФормаКлиентскогоПриложения, Неопределено - форма переход в сервис.
Функция ФормаПереходВСервис() Экспорт
	
	Возврат ПараметрыПриложения[ИмяФормыПереходаВСервис()];
	
КонецФункции

#КонецОбласти

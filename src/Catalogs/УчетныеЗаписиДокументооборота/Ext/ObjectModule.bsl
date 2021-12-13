﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем ЗаписатьПользователяПоУмолчанию Экспорт;
Перем ЭтоЗаписьНового Экспорт;
Перем ЭтоЗаписьНезаполненного Экспорт;

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоЗаписьНезаполненного <> Неопределено И ЭтоЗаписьНезаполненного Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонтекстЭДО.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонтекстЭДО.ПриЗаписиОбъекта(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(СообщениеОснование)
	
	КонтекстЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонтекстЭДО.ОбработкаЗаполненияОбъекта(ЭтотОбъект, СообщениеОснование);
	
КонецПроцедуры

#КонецОбласти

ЗаписатьПользователяПоУмолчанию = Ложь;

#КонецЕсли
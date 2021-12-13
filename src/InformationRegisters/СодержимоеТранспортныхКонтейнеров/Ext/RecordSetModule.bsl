﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
	КонтекстЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонтекстЭДО.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ, , , Замещение);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонтекстЭДО.ПриЗаписиОбъекта(ЭтотОбъект, Отказ, Замещение);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
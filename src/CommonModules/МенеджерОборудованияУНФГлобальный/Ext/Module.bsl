﻿
#Область ПрограммныйИнтерфейс

// Глобальный обработчик оповещения сканера штрихкодов
//
// Параметры:
//  ИмяСобытия	 - Строка - имя события,
//  Параметр	 - Массив - входящие данные,
//  Источник	 - Строка - источник события.
//
Процедура ПодключаемоеОборудованиеОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	Если Источник = "ПодключаемоеОборудование" Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУНФКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУНФКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработатьШтрихкоды(Данные)
	
	Если ШтрихкодированиеПечатныхФормКлиент.СтрокаПохожаНаШтрихкодПечатнойФормы(Данные.Штрихкод) Тогда
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
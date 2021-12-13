﻿#Область СлужебныйПрограммныйИнтерфейс

// Возвращает текст сообщения пользователю о необходимости  настройки системы.
//
// Параметры:
//  ВидОперации - Строка - признак выполняемой операции.
//
// Возвращаемое значение:
//  ТекстСообщения - Строка - Строка сообщения.
//
Функция ТекстСообщенияОНеобходимостиНастройкиСистемы(ВидОперации) Экспорт
	
	Если ВРег(ВидОперации) = "РАБОТАСЭД" Тогда
		ТекстСообщения = НСтр("ru = 'Для работы с электронными документами необходимо
		|в настройках системы включить использование обмена электронными документами.'");
	ИначеЕсли ВРег(ВидОперации) = "ПОДПИСАНИЕЭД" Тогда
		ТекстСообщения = НСтр("ru = 'Для возможности подписания ЭД необходимо
		|в настройках системы включить опцию использования электронных цифровых подписей.'");
	ИначеЕсли ВРег(ВидОперации) = "НАСТРОЙКАКРИПТОГРАФИИ" Тогда
		ТекстСообщения = НСтр("ru = 'Для возможности настройки криптографии необходимо 
		|в настройках системы включить опцию использования электронных цифровых подписей.'");
	ИначеЕсли ВРег(ВидОперации) = "РАБОТАСБАНКАМИ" Тогда
		ТекстСообщения = НСтр("ru = 'Для возможности обмена ЭД с банками необходимо 
		|в настройках системы включить опцию использования прямого взаимодействия с банками.'");
	Иначе
		ТекстСообщения = НСтр("ru='Операция не может быть выполнена. Не выполнены необходимые настройки системы.'");
	КонецЕсли;
	
	Возврат ТекстСообщения;
	
КонецФункции

#КонецОбласти
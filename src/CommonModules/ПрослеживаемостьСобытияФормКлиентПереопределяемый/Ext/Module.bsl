﻿#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиСобытийФормы

// Возникает на клиенте перед выполнением записи объекта из формы.
//
// Параметры:
//  Форма           - УправляемаяФорма - форма записываемого объекта,
//  Отказ           - Булево           - признак отказа от записи,
//  ПараметрыЗаписи - Структура        - структура, содержащая параметры записи.
//
Процедура ПередЗаписью(Форма, Отказ, ПараметрыЗаписи) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Возникает на клиенте после записи объекта из формы.
//
// Параметры:
//  Форма           - УправляемаяФорма - форма записываемого объекта,
//  ПараметрыЗаписи - Структура        - структура, содержащая параметры записи.
//
Процедура ПослеЗаписи(Форма, ПараметрыЗаписи) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Вызывается во всех созданных формах при вызове метода Оповестить.
//
// Параметры:
//  Форма      - УправляемаяФорма - оповещаемая форма,
//  ИмяСобытия - Строка           - имя события,
//  Параметр   - Произвольный     - параметр сообщения. Могут быть переданы любые необходимые данные,
//  Источник   - Произвольный     - источник события.
//
Процедура ОбработкаОповещения(Форма, Документ, ИмяСобытия, Параметр, Источник) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

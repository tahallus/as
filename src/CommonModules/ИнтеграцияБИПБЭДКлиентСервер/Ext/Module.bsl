﻿
#Область СлужебныйПрограммныйИнтерфейс

// Возвращает вид ошибки, возникающей при проблемах с интернет-поддержкой.
// 
// Возвращаемое значение:
// 	См. ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки
Функция ВидОшибкиИнтернетПоддержка() Экспорт
	
	ОбработчикВыполненияДиагностики = "ОбработкаНеисправностейБЭДКлиент.ОткрытьМастерДиагностики";
	
	ВидОшибки = ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки();
	ВидОшибки.Идентификатор = "ОшибкаИнтернетПоддержки";
	ВидОшибки.ВыполнятьОбработчикАвтоматически = Истина;
	ВидОшибки.АвтоматическиВыполняемыйОбработчик = ОбработчикВыполненияДиагностики;
	ВидОшибки.ЗаголовокПроблемы = НСтр("ru = 'Ошибка интернет-поддержки'");
	ВидОшибки.ОписаниеРешения = НСтр("ru = '<a href = ""Выполните"">Выполните</a> диагностику интернет-поддержки'");
	ВидОшибки.ОбработчикиНажатия.Вставить("Выполните", ОбработчикВыполненияДиагностики);
	
	Возврат ВидОшибки;
	
КонецФункции


// Возвращает идентификатор портала 1С ИТС как поставщика услуг.
// 
// Возвращаемое значение:
//  Строка - идентификатор портала.
//
Функция ИдентификаторПоставщикаУслугПортал1СИТС() Экспорт
	
	Возврат "Portal1CITS";
	
КонецФункции

// Возвращает идентификатор услуги обмена электронными документами для осуществления тарификации.
// 
// Возвращаемое значение:
//  Строка - идентификатор услуги.
//
Функция ИдентификаторУслугиОбменаЭлектроннымиДокументами() Экспорт
	
	Возврат "1c-edo-access";
	
КонецФункции

#КонецОбласти
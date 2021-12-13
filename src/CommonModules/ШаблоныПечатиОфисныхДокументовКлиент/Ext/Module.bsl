﻿
#Область ПрограммныйИнтерфейс

// Выполняет открытие формы печати шаблона офисного документа
//
// Параметры:
//  ПараметрКоманды  - Структура - структура, содержащая параметры:
//                     ДополнительныеПараметры - структура, содержащая параметры:
//                       ШаблонПечатиОфисныхДокументов - СправочникСсылка.ШаблоныПечатиОфисныхДокументов
//                     ОбъектыПечати - ОпределяемыйТип.ОбъектыПечатиОфисныхДокументов
//
Процедура ОткрытьПечатьПоШаблонуОфисногоДокумента(ПараметрКоманды) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ШаблонПечати   =  ПараметрКоманды.ДополнительныеПараметры.ШаблонПечатиОфисныхДокументов;
	ПараметрыФормы.Вставить("ШаблонПечати",  ШаблонПечати);
	ПараметрыФормы.Вставить("ОбъектыПечати", ПараметрКоманды.ОбъектыПечати);
	
	ОткрытьФорму("Справочник.ШаблоныПечатиОфисныхДокументов.Форма.ФормаПечати", ПараметрыФормы);
	
КонецПроцедуры

// Выполняет открытие списка шаблонов печати с отбором по назначению шаблона
//
// Параметры:
//  Назначение  - ПеречислениеСсылка.НазначенияШаблоновПечатиОфисныхДокументов - Назначение шаблона печати
//
Процедура ОткрытьШаблоныПечатиОфисныхДокументов(Назначение = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	Если Назначение <> Неопределено Тогда
		ПараметрыФормы.Вставить("Отбор", Новый Структура("Назначение", Назначение));
	КонецЕсли;
	ОткрытьФорму("Справочник.ШаблоныПечатиОфисныхДокументов.ФормаСписка", ПараметрыФормы);
	
КонецПроцедуры

// Устанавливает признак появления новой команды для группы команд печати
//
// Параметры:
//  ГруппаКомандПечати  - ГруппаКнопокФормы 
//
Процедура УстановитьПризнакПоявленияНовойКомандыПечати(ГруппаКомандПечати) Экспорт
	
	Если ЗначениеЗаполнено(ГруппаКомандПечати.Картинка) Тогда
		Возврат;
	КонецЕсли;
	
	ГруппаКомандПечати.Картинка  = БиблиотекаКартинок.ВосклицательныйЗнакКрасный;
	ТекстПоявлениеНовойКоманды   = НСтр("ru='требуется переоткрыть форму'");
	ГруппаКомандПечати.Заголовок = СтрШаблон("%1 (%2)", ГруппаКомандПечати.Заголовок, 
		ТекстПоявлениеНовойКоманды); 	
КонецПроцедуры

#КонецОбласти
﻿
#Область СобытияФорм

// Заполняет специфичные параметры открытия формы результатов сверки кодов маркировки в зависимости от точки вызова.
// Например, определяет доступность функционала по согласованию расхождений и заполняет признак режима проверки входящего электронного документа.
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма из которой происходит открытие формы результатов сверки кодов маркировки.
//  Параметры - Структура - (См. СверкаКодовМаркировкиИСМПКлиент.ПараметрыОткрытияФормыСверки).
//
Процедура ПриУстановкеПараметровОткрытияФормыСверкиКодовМаркировки(Форма, Параметры) Экспорт

	Возврат;

КонецПроцедуры

// Выполняет специфичные действия перед открытием формы результатов сверки кодов маркировки в зависимости от точки вызова.
// Для открытия результатов сверки из документа, полученного по ЭДО (например, акт о расхождениях, корректировка приобретения) необходимо 
// проверить заполненность реквизита документ-основание. (см. ПараметрыОткрытия.ИмяКоллекцииДокументыОснование, ПараметрыОткрытия.ИмяРеквизитаДокументОснования).
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма из которой происходит открытие формы сверки кодов маркировки.
//  ПараметрыОткрытия - Структура - (См. СверкаКодовМаркировкиИСМПКлиент.ПараметрыОткрытияФормыСверки()).
//  ПараметрыФормыПроверки - Структура - подготовленные параметры открытия формы сверки кодов маркировки.
//  Отказ - Булево - отказ от открытия формы.
//
Процедура ПередОткрытиемФормыРезультатыСверкиКодовМаркировки(Форма, ПараметрыОткрытия, ПараметрыФормыПроверки, Отказ) Экспорт
	
	
КонецПроцедуры

// Выполняет специфичные действия после закрытия форм сверки кодов маркировки в зависимости от точки вызова
//
// Параметры:
//  РезультатЗакрытия - Произвольный - результат закрытия формы проверки и подбора
//  ДополнительныеПараметры - Структура - структура с реквизитом Форма (управляемая форма из которой происходил вызов)
//
Процедура ПриЗакрытииФормыСверкиКодовМаркировки(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Возврат;
	
КонецПроцедуры

#КонецОбласти

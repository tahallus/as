﻿#Область СлужебныйПрограммныйИнтерфейс

#Область СерииНоменклатуры

// Формирует структуру, массив которых в дальнейшем будет передан в процедуру генерации серий.
//
// Параметры:
//  * ДанныеДляГенерацииСерии - Структура - Описание:
//  ** Номенклатура - ОпределяемыйТип.Номенклатура - Номенклатура, для которой будет генерироваться серия.
//  ** Серия        - ОпределяемыйТип.СерияНоменклатуры - В данное значение будет записана сгенерированная серия.
//  ** ЕстьОшибка   - Булево - Будет установлено в Истина, если по каким то причинам серия сгенерирована не будет.
//  ** ТекстОшибки  - Строка - причина, по которой серия не генерировалась.
//  ** МРЦ          - Число - только для табачной продукции, максимальная розничная цена.
//  * ВидМаркируемойПродукции - ПеречислениеСсылка.ВидыПродукцииИС - вид маркируемой продукции, для которой получается
//                                                                   структура данных
Процедура ПолучитьДанныеДляГенерацииСерии(ДанныеДляГенерацииСерии, ВидМаркируемойПродукции) Экспорт
	
	ИнтеграцияМОТПУНФКлиент.СтруктураДанныхДляГенерацииСерии(ДанныеДляГенерацииСерии, ВидМаркируемойПродукции);
	
КонецПроцедуры

#КонецОбласти

#Область ОткрытиеФормыПроверкиИПодбора

// Заполняет специфичные параметры открытия форм проверки и подбора маркируемой продукции в зависимости от точки вызова
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма из которой происходит открытие формы проверки и подбора
//  Параметры - (См. ПроверкаИПодборПродукцииИСМПКлиент.ПараметрыОткрытияФормыПроверкиИПодбора)
//
Процедура ПриУстановкеПараметровОткрытияФормыПроверкиИПодбора(Форма, Параметры) Экспорт
	
	ИнтеграцияМОТПУНФКлиент.ПриУстановкеПараметровОткрытияФормыПроверкиИПодбора(Форма, Параметры);
	
КонецПроцедуры

// Выполняет специфичные действия после закрытия форм проверки и подбора маркируемой продукции в зависимости от точки вызова
//
// Параметры:
//  РезультатЗакрытия - Произвольный - результат закрытия формы проверки и подбора
//  ДополнительныеПараметры - Структура с реквизитом Форма (управляемая форма из которой происходил вызов)
//
Процедура ПриЗакрытииФормыПроверкиИПодбора(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ИнтеграцияМОТПУНФКлиент.ПриЗакрытииФормыПроверкиИПодбора(РезультатЗакрытия, ДополнительныеПараметры);
	
КонецПроцедуры

// Выполняет специфичные действия перед открытием форм проверки и подбора маркируемой продукции в зависимости от точки вызова
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения       - форма из которой происходит открытие формы проверки и подбора
//  ПараметрыОткрытияФормыПроверки - Структура - параметры открытия формы проверки и подбора для формы-источника
//  ПараметрыФормыПроверки         - Структура - подготовленные параметры открытия формы проверки и подбора
//  Отказ                          - Булево    - отказ от открытия формы
//
Процедура ПередОткрытиемФормыПроверкиПодбора(Форма, ПараметрыОткрытияФормыПроверки, ПараметрыФормыПроверки, Отказ) Экспорт
	
	ИнтеграцияМОТПУНФКлиент.ПередОткрытиемФормыПроверкиПодбора(Форма, ПараметрыОткрытияФормыПроверки, ПараметрыФормыПроверки, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОткрытиеФормПрикладныхОбъектов

Процедура ОткрытьФормуАктаОРасхождениях(ДокументСсылка, ВладелецФормы) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

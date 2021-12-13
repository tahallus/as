﻿////////////////////////////////////////////////////////////////////////////////////////
// СопоставлениеНоменклатурыКонтрагентовСлужебныйВызовСервера: 
// механизм сопоставления номенклатуры контрагентов с номенклатурой информационной базы.
//
////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает список актуальной номенклатуры контрагента с учетом фильтра по владельцу, номенклатуре, характеристике, упаковке.
//
// Параметры:
//  ВладелецНоменклатуры - ОпределяемыйТип.ВладелецНоменклатурыБЭД       - владелец, для которого необходимо сформировать список выбора.
//  Номенклатура         - ОпределяемыйТип.НоменклатураБЭД               - номенклатура предприятия для фильтрации номенклатуры контрагента.
//  Характеристика       - ОпределяемыйТип.ХарактеристикаНоменклатурыБЭД - характеристика номенклатуры предприятия
//                                                                         для фильтрации номенклатуры контрагента.
//  Упаковка             - ОпределяемыйТип.УпаковкаНоменклатурыБЭД       - упаковка номенклатуры предприятия
//                                                                         для фильтрации номенклатуры контрагента.
//
// Возвращаемое значение:
//   Массив из СправочникСсылка.НоменклатураКонтрагентов - номенклатура контрагента, подходящая под условия фильтрации.
//
Функция СформироватьСписокВыбораНоменклатурыКонтрагента(Знач ВладелецНоменклатуры, Знач Номенклатура, Знач Характеристика, Знач Упаковка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВладелецНоменклатуры", ВладелецНоменклатуры);
	Запрос.УстановитьПараметр("Номенклатура"        , Номенклатура);
	Запрос.УстановитьПараметр("Характеристика"      , Характеристика);
	Запрос.УстановитьПараметр("Упаковка"            , Упаковка);

	СопоставлениеНоменклатурыКонтрагентовПереопределяемый.ТекстЗапросаСпискаВыбораНоменклатурыКонтрагента(Запрос);
	
	Если ПустаяСтрока(Запрос.Текст) Тогда
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	НоменклатураКонтрагентов.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.НоменклатураКонтрагентов КАК НоменклатураКонтрагентов
		|ГДЕ
		|	НоменклатураКонтрагентов.ВладелецНоменклатуры = &ВладелецНоменклатуры
		|	И НоменклатураКонтрагентов.Номенклатура = &Номенклатура
		|	И НоменклатураКонтрагентов.Характеристика = &Характеристика
		|	И НоменклатураКонтрагентов.Упаковка = &Упаковка
		|	И НЕ НоменклатураКонтрагентов.ПометкаУдаления
		|	И НЕ НоменклатураКонтрагентов.Недействителен";
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	МассивВыбора = Новый Массив();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			МассивВыбора.Добавить(Выборка.Ссылка);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат МассивВыбора;
	
КонецФункции

//++ Локализация

// Проверяет сопоставление номенклатуры контрагентов в документах.
//
// Параметры:
//  НаборДокументов - ДокументСсылка, Массив из ДокументСсылка - документы, в которых необходимо проверить сопоставление номенклатуры в терминах контрагента.
//
// Возвращаемое значение:
//  Структура - содержит результат проверки:
//   * НаборСопоставлений                     - Массив из Структура - набор сопоставления номенклатуры контрагентов по данным документов.
//      * Владелец                             - ОпределяемыйТип.ВладелецНоменклатурыБЭД       - владелец номенклатуры в документе.
//      * НомерСтроки                          - Число                                         - номер строки в документе
//      * Номенклатура                         - ОпределяемыйТип.НоменклатураБЭД               - ссылка номенклатуры в документе.
//      * Характеристика                       - ОпределяемыйТип.ХарактеристикаНоменклатурыБЭД - ссылка характеристики номенклатуры в документе.
//      * Упаковка                             - ОпределяемыйТип.УпаковкаНоменклатурыБЭД       - ссылка упаковки номенклатуры в документе.
//      * НоменклатураКонтрагента              - СправочникСсылка.НоменклатураКонтрагентов     - ссылка номенклатуры контрагента.
//      * КоличествоНоменклатурыКонтрагентов   - Число                                         - количество найденных номенклатур контрагента по данным документа.
//      * СсылкаНаДокумент                     - ДокументСсылка                                - ссылка на документ, в котором проверяется сопоставление.
//      * ИмяТабличнойЧасти                    - Строка                                        - имя табличной части, где расположена колонке с типом Справочник.НоменклатураКонтрагентов в документе.
//      * ИмяКолонкиНоменклатурыКонтрагента    - Строка                                        - имя колонки с типом Справочник.НоменклатураКонтрагентов в документе. 
//      * ПредставлениеНоменклатурыКонтрагента - Строка                                        - представление колонки с типом Справочник.НоменклатураКонтрагентов в документе,
//                                                                                               которое необходимо вывести пользователю.
//      * Сопоставлено                         - Булево                                        - признак корректного сопоставления номенклатуры контрагента.
//   * ОткрыватьФормуДляИзмененияСопоставления - Булево             - признак необходимости открыть форму для редактирования
//                                                                    сопоставления номенклатуры контрагента при наличии неоднозначного
//                                                                    сопоставления или неверного.По умолчанию установлено Истина.
//   * ЕстьОшибкиСопоставления                 - Булево             - признак наличия ошибок в сопоставление номенклатуры контрагента.
//
Функция ПроверкаСопоставленияНоменклатурыКонтрагентовВДокументах(Знач НаборДокументов) Экспорт
	
	Возврат СопоставлениеНоменклатурыКонтрагентовСлужебный.ПроверкаСопоставленияНоменклатурыКонтрагентовВДокументах(НаборДокументов);
	
КонецФункции

Функция ПоследняяНастройкаВариантаУказанияНоменклатуры(Знач ДокументСсылка, Знач Контрагент, Знач Организация) Экспорт
	
	Возврат РегистрыСведений.ВариантыУказанияНоменклатурыВДокументахБЭД.ПоследняяНастройкаВариантаУказанияНоменклатуры(ДокументСсылка,
																														Контрагент,
																														Организация);
		
КонецФункции

//-- Локализация

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//++ Локализация

Функция ЗапуститьПерезаполнениеСловаряСопоставленияНоменклатурыВФоне(УникальныйИдентификатор, Знач ПараметрыПроцедуры) Экспорт
	
	ОтменитьВыполнениеЗадания(УникальныйИдентификатор);
	
	НаименованиеЗадания = НСтр("ru = 'Обмен с контрагентами. Перезаполнение словаря сопоставления номенклатуры.'");
	ИмяПроцедуры        = "СопоставлениеНоменклатурыКонтрагентовСлужебный.НачатьПерезаполнениеСловаряСопоставленияНоменклатуры";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПроцедуры, ПараметрыВыполнения);

КонецФункции

Процедура ОтменитьВыполнениеЗадания(Знач ИдентификаторЗадания)
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

//-- Локализация

#КонецОбласти

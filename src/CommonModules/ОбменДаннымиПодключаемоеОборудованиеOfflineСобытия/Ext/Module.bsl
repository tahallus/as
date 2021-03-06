#Область ПрограммныйИнтерфейс

Процедура ЗарегистрироватьИзмененияСправочника(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьОбменСПодключаемымОборудованиемOffline") Тогда
		Возврат;
	КонецЕсли;
	
	ТипИсточника = ТипЗнч(Источник);
	Если ТипИсточника = Тип("СправочникОбъект.Номенклатура") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	КодыТоваровPLUНаОборудовании.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровPLUНаОборудовании.КодТовараPLU КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровPLUНаОборудовании КАК КодыТоваровPLUНаОборудовании
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровPLUНаОборудовании.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
		|		ПО КодыТоваровPLUНаОборудовании.КодТовараSKU = КодыТоваровSKU.SKU
		|ГДЕ
		|	ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И КодыТоваровSKU.Номенклатура = &Значение");
		
	ИначеЕсли ТипИсточника = Тип("СправочникОбъект.ХарактеристикиНоменклатуры") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	КодыТоваровPLUНаОборудовании.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровPLUНаОборудовании.КодТовараPLU КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровPLUНаОборудовании КАК КодыТоваровPLUНаОборудовании
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровPLUНаОборудовании.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
		|		ПО КодыТоваровPLUНаОборудовании.КодТовараSKU = КодыТоваровSKU.SKU
		|ГДЕ
		|	ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И КодыТоваровSKU.Характеристика = &Значение");
		
	ИначеЕсли ТипИсточника = Тип("СправочникОбъект.ПартииНоменклатуры") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	КодыТоваровPLUНаОборудовании.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровPLUНаОборудовании.КодТовараPLU КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровPLUНаОборудовании КАК КодыТоваровPLUНаОборудовании
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровPLUНаОборудовании.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
		|		ПО КодыТоваровPLUНаОборудовании.КодТовараSKU = КодыТоваровSKU.SKU
		|ГДЕ
		|	ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И КодыТоваровSKU.Партия = &Значение");
		
	ИначеЕсли ТипИсточника = Тип("СправочникОбъект.ЕдиницыИзмерения") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	КодыТоваровPLUНаОборудовании.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровPLUНаОборудовании.КодТовараPLU КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровPLUНаОборудовании КАК КодыТоваровPLUНаОборудовании
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровPLUНаОборудовании.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
		|		ПО КодыТоваровPLUНаОборудовании.КодТовараSKU = КодыТоваровSKU.SKU
		|ГДЕ
		|	ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И КодыТоваровSKU.ЕдиницаИзмерения = &Значение");
	
	ИначеЕсли ТипИсточника = Тип("СправочникОбъект.КатегорииНоменклатуры") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	КодыТоваровPLUНаОборудовании.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровPLUНаОборудовании.КодТовараPLU КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровPLUНаОборудовании КАК КодыТоваровPLUНаОборудовании
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровPLUНаОборудовании.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
		|		ПО КодыТоваровPLUНаОборудовании.КодТовараSKU = КодыТоваровSKU.SKU
		|ГДЕ
		|	ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И КодыТоваровSKU.Номенклатура.КатегорияНоменклатуры = &Значение");
		
	ИначеЕсли ТипИсточника = Тип("СправочникОбъект.ПодключаемоеОборудование") Тогда
		
		Если  ЗначениеЗаполнено(Источник.УзелИнформационнойБазы)
			И ЗначениеЗаполнено(Источник.ПравилоОбмена)
			И Источник.ПравилоОбмена <> Источник.Ссылка.ПравилоОбмена
			И (Источник.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККМОфлайн
			   ИЛИ Источник.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток) Тогда
			
			ПланыОбмена.УдалитьРегистрациюИзменений(Источник.УзелИнформационнойБазы);
			
			Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	КодыТоваровPLUНаОборудовании.ПравилоОбмена КАК ПравилоОбмена,
			|	КодыТоваровPLUНаОборудовании.Код           КАК Код,
			|	&УзелИнформационнойБазы                                   КАК УзелИнформационнойБазы
			|ИЗ
			|	РегистрСведений.КодыТоваровPLUНаОборудовании КАК КодыТоваровPLUНаОборудовании
			|ГДЕ
			|	КодыТоваровPLUНаОборудовании.ПравилоОбмена = &ПравилоОбмена");
			
			Запрос.УстановитьПараметр("ПравилоОбмена", Источник.ПравилоОбмена);
			Запрос.УстановитьПараметр("УзелИнформационнойБазы", Источник.УзелИнформационнойБазы);
			
		Иначе
			Возврат;
		КонецЕсли;
		
	Иначе
		Возврат;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Значение",             Источник.Ссылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Набор = РегистрыСведений.КодыТоваровPLUНаОборудовании.СоздатьНаборЗаписей();
	Пока Выборка.Следующий() Цикл
		
		Набор.Отбор.ПравилоОбмена.Значение = Выборка.ПравилоОбмена;
		Набор.Отбор.ПравилоОбмена.Использование = Истина;
		
		Набор.Отбор.КодТовараPLU.Значение = Выборка.Код;
		Набор.Отбор.КодТовараPLU.Использование = Истина;
		
		ПланыОбмена.ЗарегистрироватьИзменения(Выборка.УзелИнформационнойБазы, Набор);
	
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗарегистрироватьИзмененияДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьОбменСПодключаемымОборудованиемOffline") Тогда
		Возврат;
	КонецЕсли;
	
	ТипИсточника = ТипЗнч(Источник);
	Если ТипИсточника = Тип("ДокументОбъект.ЗаказПокупателя") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаказПокупателя.Ссылка КАК Ссылка,
		|	ЗаказПокупателя.КассаККМ КАК КассаККМ,
		|	ЗаказПокупателя.КассаККМ.ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	Документ.ЗаказПокупателя КАК ЗаказПокупателя
		|ГДЕ
		|	ЗаказПокупателя.КассаККМ <> ЗНАЧЕНИЕ(Справочник.КассыККМ.ПустаяСсылка)
		|	И ЗаказПокупателя.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", Источник.Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			Если ЗначениеЗаполнено(Выборка.УзелИнформационнойБазы) Тогда
				ПланыОбмена.ЗарегистрироватьИзменения(Выборка.УзелИнформационнойБазы, Выборка.Ссылка);
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗарегистрироватьИзмененияРегистраСведений(Источник, Отказ, Замещение) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьОбменСПодключаемымОборудованиемOffline") Тогда
		Возврат;
	КонецЕсли;
	
	ТипИсточника = ТипЗнч(Источник);
	Если ТипИсточника = Тип("РегистрСведенийНаборЗаписей.ШтрихкодыНоменклатуры") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	КодыТоваровPLUНаОборудовании.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровPLUНаОборудовании.КодТовараPLU КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровPLUНаОборудовании КАК КодыТоваровPLUНаОборудовании
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
		|		ПО КодыТоваровPLUНаОборудовании.КодТовараSKU = КодыТоваровSKU.SKU
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровPLUНаОборудовании.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
		|		ПО (КодыТоваровSKU.Номенклатура = ШтрихкодыНоменклатуры.Номенклатура)
		|			И (КодыТоваровSKU.Характеристика = ШтрихкодыНоменклатуры.Характеристика)
		|			И (КодыТоваровSKU.Партия = ШтрихкодыНоменклатуры.Партия)
		|			И (КодыТоваровSKU.ЕдиницаИзмерения = ШтрихкодыНоменклатуры.ЕдиницаИзмерения)
		|ГДЕ
		|	ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И ШтрихкодыНоменклатуры.Штрихкод = &Значение");
		
		Запрос.УстановитьПараметр("Значение", Источник.Отбор.Штрихкод.Значение);
		
	ИначеЕсли ТипИсточника = Тип("РегистрСведенийНаборЗаписей.ЦеныНоменклатуры") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	КодыТоваровPLUНаОборудовании.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровPLUНаОборудовании.КодТовараPLU КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровPLUНаОборудовании КАК КодыТоваровPLUНаОборудовании
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровPLUНаОборудовании.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровSKU КАК КодыТоваровSKU
		|		ПО КодыТоваровPLUНаОборудовании.КодТовараSKU = КодыТоваровSKU.SKU
		|ГДЕ
		|	ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И КодыТоваровSKU.Номенклатура = &Значение
		|	И КодыТоваровPLUНаОборудовании.ПравилоОбмена.ВидЦеныНоменклатуры = &ВидЦен");
		
		Запрос.УстановитьПараметр("Значение", Источник.Отбор.Номенклатура.Значение);
		Запрос.УстановитьПараметр("ВидЦен", Источник.Отбор.ВидЦен.Значение);
	
	Иначе
		Возврат;
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Набор = РегистрыСведений.КодыТоваровPLUНаОборудовании.СоздатьНаборЗаписей();
	Пока Выборка.Следующий() Цикл
		
		Набор.Отбор.ПравилоОбмена.Значение = Выборка.ПравилоОбмена;
		Набор.Отбор.ПравилоОбмена.Использование = Истина;
		
		Набор.Отбор.КодТовараPLU.Значение = Выборка.Код;
		Набор.Отбор.КодТовараPLU.Использование = Истина;
		
		ПланыОбмена.ЗарегистрироватьИзменения(Выборка.УзелИнформационнойБазы, Набор);
	
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗарегистрироватьИзмененияРегистраНакопленияДляОбменаСОборудованиемOfflineПриЗаписи(Источник, Отказ, Замещение) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("ОбменСПодключаемымОборудованиемOffline", Источник, Отказ, Замещение);
	
КонецПроцедуры

Процедура СоздатьУзелОбменаСПодключаемымОборудованиемOffline(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Источник.УзелИнформационнойБазы)
		И (Источник.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККМОфлайн
		ИЛИ Источник.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток
		ИЛИ Источник.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.УдалитьWebСервисОборудование) Тогда
		Источник.УзелИнформационнойБазы = ПолучитьУзелРИБ(Источник);
	КонецЕсли;
	
	Источник.ДополнительныеСвойства.Вставить("ИзмененоПравилоОбмена", Источник.ПравилоОбмена <> Источник.Ссылка.ПравилоОбмена);
	
КонецПроцедуры

Процедура ОчиститьУзелОбменаСПодключаемымОборудованиемOffline(Источник, ОбъектКопирования) Экспорт
	
	Источник.УзелИнформационнойБазы = ПланыОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка();
	
КонецПроцедуры

Процедура ЗарегистрироватьИзмененияПриСменеПравилаОбменаПодключаемогоОборудования(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если (Источник.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККМОфлайн
		ИЛИ Источник.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток)
		И Источник.ДополнительныеСвойства.ИзмененоПравилоОбмена Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		ПланыОбмена.ЗарегистрироватьИзменения(Источник.УзелИнформационнойБазы, Метаданные.РегистрыСведений.КодыТоваровPLUНаОборудовании);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция создаёт узел для данного экземпляра подключаемого оборудования и возвращает ссылку на него
// Применяется перед записью элемента справочника Подключаемое оборудование
//
Функция ПолучитьУзелРИБ(ПодключаемоеОборудованиеОбъект)
	
	УзелОбъект = ПланыОбмена.ОбменСПодключаемымОборудованиемOffline.СоздатьУзел();
	УзелОбъект.УстановитьНовыйКод();
	УзелОбъект.Наименование = ПодключаемоеОборудованиеОбъект.Наименование;
	УзелОбъект.Записать();
	
	Возврат УзелОбъект.Ссылка;
	
КонецФункции

#КонецОбласти
﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура заполняет авансы.
//
Процедура ЗаполнитьПредоплату() Экспорт
	
	Компания = Константы.УчетПоКомпании.Компания(Организация);
	
	// Заполнение расшифровки предоплаты.
	Запрос = Новый Запрос;
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыСПокупателямиОстатки.Документ КАК Документ,
	|	РасчетыСПокупателямиОстатки.Заказ КАК Заказ,
	|	РасчетыСПокупателямиОстатки.ДокументДата КАК ДокументДата,
	|	РасчетыСПокупателямиОстатки.Договор.ВалютаРасчетов КАК ВалютаРасчетов,
	|	СУММА(РасчетыСПокупателямиОстатки.СуммаОстаток) КАК СуммаОстаток,
	|	СУММА(РасчетыСПокупателямиОстатки.СуммаВалОстаток) КАК СуммаВалОстаток
	|ПОМЕСТИТЬ ВременнаяТаблицаРасчетыСПокупателямиОстатки
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыСПокупателямиОстатки.Договор КАК Договор,
	|		РасчетыСПокупателямиОстатки.Документ КАК Документ,
	|		РасчетыСПокупателямиОстатки.Документ.Дата КАК ДокументДата,
	|		РасчетыСПокупателямиОстатки.Заказ КАК Заказ,
	|		ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
	|		ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаВалОстаток, 0) КАК СуммаВалОстаток
	|	ИЗ
	|		РегистрНакопления.РасчетыСПокупателями.Остатки(
	|				,
	|				Организация = &Организация
	|					И Контрагент = &Контрагент
	|					И Договор = &Договор
	|					И Заказ = &Заказ
	|					И ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Аванс)) КАК РасчетыСПокупателямиОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияДокументаРасчетыСПокупателями.Договор,
	|		ДвиженияДокументаРасчетыСПокупателями.Документ,
	|		ДвиженияДокументаРасчетыСПокупателями.Документ.Дата,
	|		ДвиженияДокументаРасчетыСПокупателями.Заказ,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаРасчетыСПокупателями.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЕСТЬNULL(ДвиженияДокументаРасчетыСПокупателями.Сумма, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДвиженияДокументаРасчетыСПокупателями.Сумма, 0)
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаРасчетыСПокупателями.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЕСТЬNULL(ДвиженияДокументаРасчетыСПокупателями.СуммаВал, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДвиженияДокументаРасчетыСПокупателями.СуммаВал, 0)
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.РасчетыСПокупателями КАК ДвиженияДокументаРасчетыСПокупателями
	|	ГДЕ
	|		ДвиженияДокументаРасчетыСПокупателями.Регистратор = &Ссылка
	|		И ДвиженияДокументаРасчетыСПокупателями.Период <= &Период
	|		И ДвиженияДокументаРасчетыСПокупателями.Организация = &Организация
	|		И ДвиженияДокументаРасчетыСПокупателями.Контрагент = &Контрагент
	|		И ДвиженияДокументаРасчетыСПокупателями.Договор = &Договор
	|		И ДвиженияДокументаРасчетыСПокупателями.Заказ = &Заказ
	|		И ДвиженияДокументаРасчетыСПокупателями.ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Аванс)) КАК РасчетыСПокупателямиОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыСПокупателямиОстатки.Документ,
	|	РасчетыСПокупателямиОстатки.Заказ,
	|	РасчетыСПокупателямиОстатки.ДокументДата,
	|	РасчетыСПокупателямиОстатки.Договор.ВалютаРасчетов
	|
	|ИМЕЮЩИЕ
	|	СУММА(РасчетыСПокупателямиОстатки.СуммаВалОстаток) < 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыСПокупателямиОстатки.Документ КАК Документ,
	|	РасчетыСПокупателямиОстатки.Заказ КАК Заказ,
	|	РасчетыСПокупателямиОстатки.ДокументДата КАК ДокументДата,
	|	РасчетыСПокупателямиОстатки.ВалютаРасчетов КАК ВалютаРасчетов,
	|	-СУММА(РасчетыСПокупателямиОстатки.СуммаУчета) КАК СуммаУчета,
	|	-СУММА(РасчетыСПокупателямиОстатки.СуммаРасчетов) КАК СуммаРасчетов,
	|	-СУММА(РасчетыСПокупателямиОстатки.СуммаПлатежа) КАК СуммаПлатежа,
	|	СУММА(РасчетыСПокупателямиОстатки.СуммаУчета / ВЫБОР
	|			КОГДА ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаРасчетов, 0) <> 0
	|				ТОГДА РасчетыСПокупателямиОстатки.СуммаРасчетов
	|			ИНАЧЕ 1
	|		КОНЕЦ) * (КурсыВалютыУчетаКурс / КурсыВалютыУчетаКратность) КАК Курс,
	|	1 КАК Кратность,
	|	РасчетыСПокупателямиОстатки.КурсыВалютыДокументаКурс КАК КурсыВалютыДокументаКурс,
	|	РасчетыСПокупателямиОстатки.КурсыВалютыДокументаКратность КАК КурсыВалютыДокументаКратность
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыСПокупателямиОстатки.ВалютаРасчетов КАК ВалютаРасчетов,
	|		РасчетыСПокупателямиОстатки.Документ КАК Документ,
	|		РасчетыСПокупателямиОстатки.ДокументДата КАК ДокументДата,
	|		РасчетыСПокупателямиОстатки.Заказ КАК Заказ,
	|		ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаОстаток, 0) КАК СуммаУчета,
	|		ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаВалОстаток, 0) КАК СуммаРасчетов,
	|		ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаОстаток, 0) * КурсыВалютыУчета.Курс * &КратностьВалютыДокумента / (&КурсВалютыДокумента * КурсыВалютыУчета.Кратность) КАК СуммаПлатежа,
	|		КурсыВалютыУчета.Курс КАК КурсыВалютыУчетаКурс,
	|		КурсыВалютыУчета.Кратность КАК КурсыВалютыУчетаКратность,
	|		&КурсВалютыДокумента КАК КурсыВалютыДокументаКурс,
	|		&КратностьВалютыДокумента КАК КурсыВалютыДокументаКратность
	|	ИЗ
	|		ВременнаяТаблицаРасчетыСПокупателямиОстатки КАК РасчетыСПокупателямиОстатки
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Период, Валюта = &ВалютаУчета) КАК КурсыВалютыУчета
	|			ПО (ИСТИНА)) КАК РасчетыСПокупателямиОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыСПокупателямиОстатки.Документ,
	|	РасчетыСПокупателямиОстатки.Заказ,
	|	РасчетыСПокупателямиОстатки.ДокументДата,
	|	РасчетыСПокупателямиОстатки.ВалютаРасчетов,
	|	КурсыВалютыУчетаКурс,
	|	КурсыВалютыУчетаКратность,
	|	РасчетыСПокупателямиОстатки.КурсыВалютыДокументаКурс,
	|	РасчетыСПокупателямиОстатки.КурсыВалютыДокументаКратность
	|
	|ИМЕЮЩИЕ
	|	-СУММА(РасчетыСПокупателямиОстатки.СуммаРасчетов) > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДокументДата";
	
	Запрос.УстановитьПараметр("Заказ", Документы.ЗаказПокупателя.ПустаяСсылка());
	
	Запрос.УстановитьПараметр("Организация", Компания);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("ВалютаДокумента", ВалютаДокумента);
	Запрос.УстановитьПараметр("ВалютаУчета", Константы.ВалютаУчета.Получить());
	Если Договор.ВалютаРасчетов = ВалютаДокумента Тогда
		Запрос.УстановитьПараметр("КурсВалютыДокумента", Курс);
		Запрос.УстановитьПараметр("КратностьВалютыДокумента", Кратность);
	Иначе
		Запрос.УстановитьПараметр("КурсВалютыДокумента", 1);
		Запрос.УстановитьПараметр("КратностьВалютыДокумента", 1);
	КонецЕсли;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = ТекстЗапроса;
	
	Предоплата.Очистить();
	СуммаОсталосьРаспределить = ВнеоборотныеАктивы.Итог("Всего");
	СуммаОсталосьРаспределить = ЦенообразованиеСервер.ПересчитатьИзВалютыВВалюту(
		СуммаОсталосьРаспределить,
		?(Договор.ВалютаРасчетов = ВалютаДокумента, Курс, 1),
		Курс,
		?(Договор.ВалютаРасчетов = ВалютаДокумента, Кратность, 1),
		Кратность
	);
	
	ВыборкаРезультатаЗапроса = Запрос.Выполнить().Выбрать();
	
	Пока СуммаОсталосьРаспределить > 0 Цикл
		
		Если ВыборкаРезультатаЗапроса.Следующий() Тогда
			
			Если ВыборкаРезультатаЗапроса.СуммаРасчетов <= СуммаОсталосьРаспределить Тогда // сумма остатка меньше или равна чем осталось распределить
				
				НоваяСтрока = Предоплата.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРезультатаЗапроса);
				СуммаОсталосьРаспределить = СуммаОсталосьРаспределить - ВыборкаРезультатаЗапроса.СуммаРасчетов;
				
			Иначе // сумма остатка больше чем нужно распределить
				
				НоваяСтрока = Предоплата.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРезультатаЗапроса);
				НоваяСтрока.СуммаРасчетов = СуммаОсталосьРаспределить;
				НоваяСтрока.СуммаПлатежа = ЦенообразованиеСервер.ПересчитатьИзВалютыВВалюту(
					НоваяСтрока.СуммаРасчетов,
					ВыборкаРезультатаЗапроса.Курс,
					ВыборкаРезультатаЗапроса.КурсыВалютыДокументаКурс,
					ВыборкаРезультатаЗапроса.Кратность,
					ВыборкаРезультатаЗапроса.КурсыВалютыДокументаКратность
				);
				СуммаОсталосьРаспределить = 0;
				
			КонецЕсли;
			
		Иначе
			
			СуммаОсталосьРаспределить = 0;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик заполнения на основании документа ВнеоборотныеАктивы
//
// Параметры:
//	СправочникСсылкаВнеоборотныеАктивы - СправочникСсылка.ВнеоборотныеАктивы.
//	
Процедура ЗаполнитьПоВнеоборотныеАктивы(СправочникСсылкаВнеоборотныеАктивы) Экспорт
	
	НоваяСтрока = ВнеоборотныеАктивы.Добавить();
	
	НоваяСтрока.ВнеоборотныйАктив = СправочникСсылкаВнеоборотныеАктивы;
	
	РассчитатьАмортизацию(СправочникСсылкаВнеоборотныеАктивы);
	
КонецПроцедуры // ЗаполнитьПоВнеоборотныеАктивы()

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("СправочникСсылка.ВнеоборотныеАктивы")] = "ЗаполнитьПоВнеоборотныеАктивы";
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения, "СуммаВключаетНДС");
	
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Выполнение предварительного контроля.
	ВыполнитьПредварительныйКонтроль(Отказ);
	
	РасчетыРаботаСФормамиВызовСервера.ПроверитьЗаполнениеДокументаПредоплаты(Контрагент, ПроверяемыеРеквизиты);
	
	Если НЕ Контрагент.ВестиРасчетыПоДоговорам Тогда
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Договор");
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контрагент)
	И НЕ Контрагент.ВестиРасчетыПоДоговорам
	И НЕ ЗначениеЗаполнено(Договор) Тогда
		Договор = Справочники.ДоговорыКонтрагентов.ДоговорПоУмолчанию(Контрагент);
	КонецЕсли;
	
	СуммаДокумента = ВнеоборотныеАктивы.Итог("Всего");
	
КонецПроцедуры // ПередЗаписью()

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа
	Документы.ПередачаВА.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ПроведениеДокументовУНФ.ОтразитьДвижения("Запасы", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДоходыИРасходы", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("СостоянияВнеоборотныхАктивов", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ВнеоборотныеАктивы", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("РасчетыСПокупателями", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДоходыИРасходыКассовыйМетод", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДоходыИРасходыНераспределенные", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДоходыИРасходыОтложенные", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьУправленческий(ДополнительныеСвойства, Движения, Отказ);
	// Эквайринг
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДоходыИРасходыКассовыйМетодЭквайринг", ТаблицыДляДвижений, Движения, Отказ);

	// Запись наборов записей
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательных остатков.
	Документы.ПередачаВА.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательных остатков.
	Документы.ПередачаВА.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

Процедура ПриКопировании(ОбъектКопирования)
	
	Предоплата.Очистить();
	НомерЧекаККМ = 0;
	ПодписьКассира = Неопределено;
	
КонецПроцедуры // ПриКопировании()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет предварительный контроль.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	// Дубли строк.
	Запрос = Новый Запрос();
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.ВнеоборотныйАктив
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	&ТаблицаДокумента КАК ТаблицаДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ТаблицаДокумента1.НомерСтроки) КАК НомерСтроки,
	|	ТаблицаДокумента1.ВнеоборотныйАктив
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента1
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДокумента КАК ТаблицаДокумента2
	|		ПО ТаблицаДокумента1.НомерСтроки <> ТаблицаДокумента2.НомерСтроки
	|			И ТаблицаДокумента1.ВнеоборотныйАктив = ТаблицаДокумента2.ВнеоборотныйАктив
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента1.ВнеоборотныйАктив
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос.УстановитьПараметр("ТаблицаДокумента", ВнеоборотныеАктивы);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'Имущество ""%1"" указанное в строке %2 списка ""Имущество"", указано повторно.'"),
				СокрЛП(ВыборкаИзРезультатаЗапроса.ВнеоборотныйАктив), ВыборкаИзРезультатаЗапроса.НомерСтроки);
			КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ВнеоборотныеАктивы",
				ВыборкаИзРезультатаЗапроса.НомерСтроки, "ВнеоборотныйАктив");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
		КонецЦикла;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Константы.УчетПоКомпании.Компания(Организация));
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("СписокВнеоборотныхАктивов", ВнеоборотныеАктивы.ВыгрузитьКолонку("ВнеоборотныйАктив"));
	
	// Проверка состояний имущества.
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СостояниеВнеоборотногоАктиваСрезПоследних.ВнеоборотныйАктив КАК ВнеоборотныйАктив
	|ИЗ
	|	РегистрСведений.СостоянияВнеоборотныхАктивов.СрезПоследних(, Организация = &Организация) КАК СостояниеВнеоборотногоАктиваСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.ВнеоборотныйАктив КАК ВнеоборотныйАктив
	|ИЗ
	|	(ВЫБРАТЬ
	|		СостояниеВнеоборотногоАктива.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|		СУММА(ВЫБОР
	|				КОГДА СостояниеВнеоборотногоАктива.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияВнеоборотныхАктивов.ПринятКУчету)
	|					ТОГДА 1
	|				ИНАЧЕ -1
	|			КОНЕЦ) КАК ТекущееСостояние
	|	ИЗ
	|		РегистрСведений.СостоянияВнеоборотныхАктивов КАК СостояниеВнеоборотногоАктива
	|	ГДЕ
	|		СостояниеВнеоборотногоАктива.Регистратор <> &Ссылка
	|		И СостояниеВнеоборотногоАктива.Организация = &Организация
	|		И СостояниеВнеоборотногоАктива.ВнеоборотныйАктив В(&СписокВнеоборотныхАктивов)
	|	
	|	СГРУППИРОВАТЬ ПО
	|		СостояниеВнеоборотногоАктива.ВнеоборотныйАктив) КАК ВложенныйЗапрос
	|ГДЕ
	|	ВложенныйЗапрос.ТекущееСостояние > 0";
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	МассивВАСостояния = МассивРезультатов[0].Выгрузить().ВыгрузитьКолонку("ВнеоборотныйАктив");
	МассивВАПринятКУчету = МассивРезультатов[1].Выгрузить().ВыгрузитьКолонку("ВнеоборотныйАктив");
	
	Для каждого СтрокаВнеоборотныхАктивов Из ВнеоборотныеАктивы Цикл
		Если МассивВАСостояния.Найти(СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив) = Неопределено Тогда
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'Для имущества ""%1"" указанного в строке %2 списка ""Имущество"", не зарегистрированы состояния.'"),
				СокрЛП(СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив), СтрокаВнеоборотныхАктивов.НомерСтроки);
			КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ВнеоборотныеАктивы",
				СтрокаВнеоборотныхАктивов.НомерСтроки, "ВнеоборотныйАктив");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
		ИначеЕсли МассивВАПринятКУчету.Найти(СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив) = Неопределено Тогда
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'Для имущества ""%1"" указанного в строке %2 списка ""Имущество"", текущее состояние ""Снят с учета"".'"),
				СокрЛП(СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив), СтрокаВнеоборотныхАктивов.НомерСтроки);
			КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ВнеоборотныеАктивы",
				СтрокаВнеоборотныхАктивов.НомерСтроки, "ВнеоборотныйАктив");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // ВыполнитьПредварительныйКонтроль()

// Рассчитывает амортизацию имущества.
//
Процедура РассчитатьАмортизацию(ВнеоборотныйАктив)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПараметрыВнеоборотныхАктивовСрезПоследних.Регистратор.Организация КАК Организация
	|ИЗ
	|	РегистрСведений.ПараметрыВнеоборотныхАктивов.СрезПоследних КАК ПараметрыВнеоборотныхАктивовСрезПоследних
	|ГДЕ
	|	ПараметрыВнеоборотныхАктивовСрезПоследних.ВнеоборотныйАктив = &ВнеоборотныйАктив";
	
	Запрос.УстановитьПараметр("ВнеоборотныйАктив", ВнеоборотныйАктив);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Организация = Выборка.Организация;
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписокАмортизируемыхВА.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|	ПРЕДСТАВЛЕНИЕ(СписокАмортизируемыхВА.ВнеоборотныйАктив) КАК ВнеоборотныйАктивПредставление,
	|	СписокАмортизируемыхВА.ВнеоборотныйАктив.Код КАК Код,
	|	СписокАмортизируемыхВА.НачалоНачислятьАмортизацию КАК НачалоНачислятьАмортизацию,
	|	СписокАмортизируемыхВА.КонецНачислятьАмортизацию КАК КонецНачислятьАмортизацию,
	|	СписокАмортизируемыхВА.КонецНачислятьВТекущемМесяце КАК КонецНачислятьВТекущемМесяце,
	|	ЕСТЬNULL(СтоимостьВА.АмортизацияКонечныйОстаток, 0) КАК АмортизацияКонечныйОстаток,
	|	ЕСТЬNULL(СтоимостьВА.АмортизацияОборот, 0) КАК АмортизацияОборот,
	|	ЕСТЬNULL(СтоимостьВА.СтоимостьКонечныйОстаток, 0) КАК БалансоваяСтоимость,
	|	ЕСТЬNULL(СтоимостьВА.СтоимостьНачальныйОстаток, 0) КАК СтоимостьНачальныйОстаток,
	|	ЕСТЬNULL(АмортизацияОстаткиИОбороты.СтоимостьНачальныйОстаток, 0) - ЕСТЬNULL(АмортизацияОстаткиИОбороты.АмортизацияНачальныйОстаток, 0) КАК СтоимостьНаНачалоГода,
	|	ЕСТЬNULL(СписокАмортизируемыхВА.ВнеоборотныйАктив.СпособАмортизации, 0) КАК СпособНачисленияАмортизации,
	|	ЕСТЬNULL(СписокАмортизируемыхВА.ВнеоборотныйАктив.НачальнаяСтоимость, 0) КАК ПервоначальнаяСтоимость,
	|	ЕСТЬNULL(ПараметрыАмортизацииСрезПоследних.ПрименитьВТекущемМесяце, 0) КАК ПрименитьВТекущемМесяце,
	|	ПараметрыАмортизацииСрезПоследних.Период КАК Период,
	|	ВЫБОР
	|		КОГДА ПараметрыАмортизацииСрезПоследних.ПрименитьВТекущемМесяце
	|			ТОГДА ЕСТЬNULL(ПараметрыАмортизацииСрезПоследних.СрокИспользованияДляВычисленияАмортизации, 0)
	|		ИНАЧЕ ЕСТЬNULL(ПараметрыАмортизацииСрезПоследнихНачалоМесяца.СрокИспользованияДляВычисленияАмортизации, 0)
	|	КОНЕЦ КАК СрокИспользованияДляВычисленияАмортизации,
	|	ВЫБОР
	|		КОГДА ПараметрыАмортизацииСрезПоследних.ПрименитьВТекущемМесяце
	|			ТОГДА ЕСТЬNULL(ПараметрыАмортизацииСрезПоследних.СтоимостьДляВычисленияАмортизации, 0)
	|		ИНАЧЕ ЕСТЬNULL(ПараметрыАмортизацииСрезПоследнихНачалоМесяца.СтоимостьДляВычисленияАмортизации, 0)
	|	КОНЕЦ КАК СтоимостьДляВычисленияАмортизации,
	|	ЕСТЬNULL(ИзменениеПризнакаАмортизации.ИзменениеНачислятьАмортизацию, ЛОЖЬ) КАК ИзменениеНачислятьАмортизацию,
	|	ЕСТЬNULL(ИзменениеПризнакаАмортизации.НачислятьВТекМесяце, ЛОЖЬ) КАК НачислятьВТекМесяце,
	|	ЕСТЬNULL(ВыработкаВнеоборотногоАктиваОбороты.КоличествоОборот, 0) КАК ОбъемВыработки,
	|	ВЫБОР
	|		КОГДА ПараметрыАмортизацииСрезПоследних.ПрименитьВТекущемМесяце
	|			ТОГДА ЕСТЬNULL(ПараметрыАмортизацииСрезПоследних.ОбъемПродукцииРаботДляВычисленияАмортизации, 0)
	|		ИНАЧЕ ЕСТЬNULL(ПараметрыАмортизацииСрезПоследнихНачалоМесяца.ОбъемПродукцииРаботДляВычисленияАмортизации, 0)
	|	КОНЕЦ КАК ОбъемПродукцииРаботДляВычисленияАмортизации
	|ПОМЕСТИТЬ ВременнаяТаблицаДляРасчетаАмортизации
	|ИЗ
	|	(ВЫБРАТЬ
	|		СрезПервых.НачислятьАмортизацию КАК НачалоНачислятьАмортизацию,
	|		СрезПоследних.НачислятьАмортизацию КАК КонецНачислятьАмортизацию,
	|		СрезПоследних.НачислятьАмортизациюВТекущемМесяце КАК КонецНачислятьВТекущемМесяце,
	|		СрезПоследних.ВнеоборотныйАктив КАК ВнеоборотныйАктив
	|	ИЗ
	|		(ВЫБРАТЬ
	|			СостояниеВнеоборотногоАктиваСрезПервых.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|			СостояниеВнеоборотногоАктиваСрезПервых.НачислятьАмортизацию КАК НачислятьАмортизацию,
	|			СостояниеВнеоборотногоАктиваСрезПервых.НачислятьАмортизациюВТекущемМесяце КАК НачислятьАмортизациюВТекущемМесяце,
	|			СостояниеВнеоборотногоАктиваСрезПервых.Период КАК Период
	|		ИЗ
	|			РегистрСведений.СостоянияВнеоборотныхАктивов.СрезПоследних(
	|					&НачалоПериода,
	|					Организация = &Организация
	|						И ВнеоборотныйАктив В (&СписокВнеоборотныхАктивов)) КАК СостояниеВнеоборотногоАктиваСрезПервых) КАК СрезПервых
	|			ПОЛНОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|				СостояниеВнеоборотногоАктиваСрезПоследних.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|				СостояниеВнеоборотногоАктиваСрезПоследних.НачислятьАмортизацию КАК НачислятьАмортизацию,
	|				СостояниеВнеоборотногоАктиваСрезПоследних.НачислятьАмортизациюВТекущемМесяце КАК НачислятьАмортизациюВТекущемМесяце,
	|				СостояниеВнеоборотногоАктиваСрезПоследних.Период КАК Период
	|			ИЗ
	|				РегистрСведений.СостоянияВнеоборотныхАктивов.СрезПоследних(
	|						&КонецПериода,
	|						Организация = &Организация
	|							И ВнеоборотныйАктив В (&СписокВнеоборотныхАктивов)) КАК СостояниеВнеоборотногоАктиваСрезПоследних) КАК СрезПоследних
	|			ПО СрезПервых.ВнеоборотныйАктив = СрезПоследних.ВнеоборотныйАктив) КАК СписокАмортизируемыхВА
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВнеоборотныеАктивы.ОстаткиИОбороты(
	|				&НачалоГода,
	|				,
	|				,
	|				,
	|				Организация = &Организация
	|					И ВнеоборотныйАктив В (&СписокВнеоборотныхАктивов)) КАК АмортизацияОстаткиИОбороты
	|		ПО СписокАмортизируемыхВА.ВнеоборотныйАктив = АмортизацияОстаткиИОбороты.ВнеоборотныйАктив
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВнеоборотныеАктивы.ОстаткиИОбороты(
	|				&НачалоПериода,
	|				&КонецПериода,
	|				,
	|				,
	|				Организация = &Организация
	|					И ВнеоборотныйАктив В (&СписокВнеоборотныхАктивов)) КАК СтоимостьВА
	|		ПО СписокАмортизируемыхВА.ВнеоборотныйАктив = СтоимостьВА.ВнеоборотныйАктив
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыВнеоборотныхАктивов.СрезПоследних(
	|				&КонецПериода,
	|				Организация = &Организация
	|					И ВнеоборотныйАктив В (&СписокВнеоборотныхАктивов)) КАК ПараметрыАмортизацииСрезПоследних
	|		ПО СписокАмортизируемыхВА.ВнеоборотныйАктив = ПараметрыАмортизацииСрезПоследних.ВнеоборотныйАктив
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыВнеоборотныхАктивов.СрезПоследних(
	|				&НачалоПериода,
	|				Организация = &Организация
	|					И ВнеоборотныйАктив В (&СписокВнеоборотныхАктивов)) КАК ПараметрыАмортизацииСрезПоследнихНачалоМесяца
	|		ПО СписокАмортизируемыхВА.ВнеоборотныйАктив = ПараметрыАмортизацииСрезПоследнихНачалоМесяца.ВнеоборотныйАктив
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ИСТИНА) КАК ИзменениеНачислятьАмортизацию,
	|			СостояниеВнеоборотногоАктива.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|			СостояниеВнеоборотногоАктиваСрезПоследних.НачислятьАмортизациюВТекущемМесяце КАК НачислятьВТекМесяце
	|		ИЗ
	|			РегистрСведений.СостоянияВнеоборотныхАктивов КАК СостояниеВнеоборотногоАктива
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияВнеоборотныхАктивов.СрезПоследних(
	|						&КонецПериода,
	|						Организация = &Организация
	|							И ВнеоборотныйАктив В (&СписокВнеоборотныхАктивов)) КАК СостояниеВнеоборотногоАктиваСрезПоследних
	|				ПО СостояниеВнеоборотногоАктива.ВнеоборотныйАктив = СостояниеВнеоборотногоАктиваСрезПоследних.ВнеоборотныйАктив
	|		ГДЕ
	|			СостояниеВнеоборотногоАктива.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|			И СостояниеВнеоборотногоАктива.Организация = &Организация
	|			И СостояниеВнеоборотногоАктива.ВнеоборотныйАктив В(&СписокВнеоборотныхАктивов)
	|		
	|		СГРУППИРОВАТЬ ПО
	|			СостояниеВнеоборотногоАктива.ВнеоборотныйАктив,
	|			СостояниеВнеоборотногоАктиваСрезПоследних.НачислятьАмортизациюВТекущемМесяце) КАК ИзменениеПризнакаАмортизации
	|		ПО СписокАмортизируемыхВА.ВнеоборотныйАктив = ИзменениеПризнакаАмортизации.ВнеоборотныйАктив
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВыработкаВнеоборотныхАктивов.Обороты(
	|				&НачалоПериода,
	|				&КонецПериода,
	|				,
	|				Организация = &Организация
	|					И ВнеоборотныйАктив В (&СписокВнеоборотныхАктивов)) КАК ВыработкаВнеоборотногоАктиваОбороты
	|		ПО СписокАмортизируемыхВА.ВнеоборотныйАктив = ВыработкаВнеоборотногоАктиваОбороты.ВнеоборотныйАктив
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&Организация КАК Организация,
	|	&Период КАК Период,
	|	Таблица.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|	Таблица.ВнеоборотныйАктивПредставление КАК ВнеоборотныйАктивПредставление,
	|	Таблица.Код КАК Код,
	|	Таблица.АмортизацияКонечныйОстаток КАК АмортизацияКонечныйОстаток,
	|	Таблица.БалансоваяСтоимость КАК БалансоваяСтоимость,
	|	0 КАК Стоимость,
	|	ВЫБОР
	|		КОГДА ВЫБОР
	|				КОГДА Таблица.СуммаАмортизации < Таблица.ВсегоОсталосьСписать
	|					ТОГДА Таблица.СуммаАмортизации
	|				ИНАЧЕ Таблица.ВсегоОсталосьСписать
	|			КОНЕЦ > 0
	|			ТОГДА ВЫБОР
	|					КОГДА Таблица.СуммаАмортизации < Таблица.ВсегоОсталосьСписать
	|						ТОГДА Таблица.СуммаАмортизации
	|					ИНАЧЕ Таблица.ВсегоОсталосьСписать
	|				КОНЕЦ
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Амортизация
	|ПОМЕСТИТЬ ТаблицаРасчетаАмортизации
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВЫБОР
	|			КОГДА Таблица.СпособНачисленияАмортизации = ЗНАЧЕНИЕ(Перечисление.СпособыНачисленияАмортизацииВнеоборотныхАктивов.Линейный)
	|				ТОГДА Таблица.СтоимостьДляВычисленияАмортизации / ВЫБОР
	|						КОГДА Таблица.СрокИспользованияДляВычисленияАмортизации = 0
	|							ТОГДА 1
	|						ИНАЧЕ Таблица.СрокИспользованияДляВычисленияАмортизации
	|					КОНЕЦ
	|			КОГДА Таблица.СпособНачисленияАмортизации = ЗНАЧЕНИЕ(Перечисление.СпособыНачисленияАмортизацииВнеоборотныхАктивов.ПропорциональноОбъемуПродукции)
	|				ТОГДА Таблица.СтоимостьДляВычисленияАмортизации * Таблица.ОбъемВыработки / ВЫБОР
	|						КОГДА Таблица.ОбъемПродукцииРаботДляВычисленияАмортизации = 0
	|							ТОГДА 1
	|						ИНАЧЕ Таблица.ОбъемПродукцииРаботДляВычисленияАмортизации
	|					КОНЕЦ
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК СуммаАмортизации,
	|		Таблица.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|		Таблица.ВнеоборотныйАктивПредставление КАК ВнеоборотныйАктивПредставление,
	|		Таблица.Код КАК Код,
	|		Таблица.АмортизацияКонечныйОстаток КАК АмортизацияКонечныйОстаток,
	|		Таблица.БалансоваяСтоимость КАК БалансоваяСтоимость,
	|		Таблица.БалансоваяСтоимость - Таблица.АмортизацияКонечныйОстаток КАК ВсегоОсталосьСписать
	|	ИЗ
	|		ВременнаяТаблицаДляРасчетаАмортизации КАК Таблица) КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВременнаяТаблицаДляРасчетаАмортизации
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВнеоборотныеАктивы.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВнеоборотныеАктивы.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|	ТаблицаВнеоборотныеАктивы.Сумма КАК Сумма,
	|	ТаблицаВнеоборотныеАктивы.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаВнеоборотныеАктивы.СуммаНДС КАК СуммаНДС,
	|	ТаблицаВнеоборотныеАктивы.Всего КАК Всего
	|ПОМЕСТИТЬ ТаблицаВнеоборотныеАктивы
	|ИЗ
	|	&ТаблицаВнеоборотныеАктивы КАК ТаблицаВнеоборотныеАктивы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВнеоборотныеАктивы.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВнеоборотныеАктивы.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|	ТаблицаВнеоборотныеАктивы.Сумма КАК Сумма,
	|	ТаблицаВнеоборотныеАктивы.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаВнеоборотныеАктивы.СуммаНДС КАК СуммаНДС,
	|	ТаблицаВнеоборотныеАктивы.Всего КАК Всего,
	|	ТаблицаРасчетаАмортизации.БалансоваяСтоимость КАК Стоимость,
	|	ТаблицаРасчетаАмортизации.Амортизация КАК АмортизацияЗаМесяц,
	|	ТаблицаРасчетаАмортизации.АмортизацияКонечныйОстаток КАК Амортизация,
	|	ТаблицаРасчетаАмортизации.БалансоваяСтоимость - ТаблицаРасчетаАмортизации.АмортизацияКонечныйОстаток КАК ОстаточнаяСтоимость
	|ИЗ
	|	ТаблицаВнеоборотныеАктивы КАК ТаблицаВнеоборотныеАктивы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаРасчетаАмортизации КАК ТаблицаРасчетаАмортизации
	|		ПО ТаблицаВнеоборотныеАктивы.ВнеоборотныйАктив = ТаблицаРасчетаАмортизации.ВнеоборотныйАктив
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ТаблицаВнеоборотныеАктивы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ТаблицаРасчетаАмортизации";
	
	ТекДата = ТекущаяДата();
	
	Запрос.УстановитьПараметр("Период", ТекДата);
	Запрос.УстановитьПараметр("Организация", Константы.УчетПоКомпании.Компания(Организация));
	Запрос.УстановитьПараметр("НачалоГода", НачалоГода(ТекДата));
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(ТекДата));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ТекДата));
	Запрос.УстановитьПараметр("СписокВнеоборотныхАктивов", ВнеоборотныеАктивы.ВыгрузитьКолонку("ВнеоборотныйАктив"));
	Запрос.УстановитьПараметр("ТаблицаВнеоборотныеАктивы", ВнеоборотныеАктивы);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ТаблицаАмортизации = РезультатЗапроса[4].Выгрузить();
	
	ВнеоборотныеАктивы.Загрузить(ТаблицаАмортизации);
	
КонецПроцедуры // РассчитатьАмортизацию()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
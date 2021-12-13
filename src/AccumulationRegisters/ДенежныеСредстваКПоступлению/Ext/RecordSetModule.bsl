﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью набора записей.
//
Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;

	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Установка исключительной блокировки текущего набора записей регистратора.
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ДенежныеСредстваКПоступлению.НаборЗаписей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Регистратор", Отбор.Регистратор.Значение);
	Блокировка.Заблокировать();
	
	Если НЕ СтруктураВременныеТаблицы.Свойство("ДенежныеСредстваКПоступлениюИзменение") ИЛИ
		СтруктураВременныеТаблицы.Свойство("ДенежныеСредстваКПоступлениюИзменение") И НЕ СтруктураВременныеТаблицы.ДенежныеСредстваКПоступлениюИзменение Тогда
		
		// Если временная таблица "ДенежныеСредстваКПоступлениюИзменение" не существует или не содержит записей
		// об изменении набора, значит набор записывается первый раз или для набора был выполнен контроль остатков.
		// Текущее состояние набора помещается во временную таблицу "ДенежныеСредстваКПоступлениюПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	РегистрНакопленияДенежныеСредстваКПоступлению.НомерСтроки КАК НомерСтроки,
		|	РегистрНакопленияДенежныеСредстваКПоступлению.Организация КАК Организация,
		|	РегистрНакопленияДенежныеСредстваКПоступлению.Касса КАК Касса,
		|	РегистрНакопленияДенежныеСредстваКПоступлению.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	РегистрНакопленияДенежныеСредстваКПоступлению.ДокументПередачи КАК ДокументПередачи,
		|	ВЫБОР
		|		КОГДА РегистрНакопленияДенежныеСредстваКПоступлению.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА РегистрНакопленияДенежныеСредстваКПоступлению.Сумма
		|		ИНАЧЕ -РегистрНакопленияДенежныеСредстваКПоступлению.Сумма
		|	КОНЕЦ КАК СуммаПередЗаписью,
		|	ВЫБОР
		|		КОГДА РегистрНакопленияДенежныеСредстваКПоступлению.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА РегистрНакопленияДенежныеСредстваКПоступлению.СуммаВал
		|		ИНАЧЕ -РегистрНакопленияДенежныеСредстваКПоступлению.СуммаВал
		|	КОНЕЦ КАК СуммаВалПередЗаписью
		|ПОМЕСТИТЬ ДвиженияДенежныеСредстваКПоступлениюПередЗаписью
		|ИЗ
		|	РегистрНакопления.ДенежныеСредстваКПоступлению КАК РегистрНакопленияДенежныеСредстваКПоступлению
		|ГДЕ
		|	РегистрНакопленияДенежныеСредстваКПоступлению.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
				
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	Иначе
		
		// Если временная таблица "ДвиженияДенежныеСредстваКПоступлениюИзменение" существует и содержит записи
		// об изменении набора, значит набор записывается не первый раз и для набора не был выполнен контроль остатков.
		// Текущее состояние набора и текущее состояние изменений помещаются во временную таблицу "ДвиженияДенежныеСредстваПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно первоначального.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияДенежныеСредстваКПоступлениюИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияДенежныеСредстваКПоступлениюИзменение.Организация КАК Организация,
		|	ДвиженияДенежныеСредстваКПоступлениюИзменение.Касса КАК Касса,
		|	ДвиженияДенежныеСредстваКПоступлениюИзменение.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	ДвиженияДенежныеСредстваКПоступлениюИзменение.ДокументПередачи КАК ДокументПередачи,
		|	ДвиженияДенежныеСредстваКПоступлениюИзменение.СуммаПередЗаписью КАК СуммаПередЗаписью,
		|	ДвиженияДенежныеСредстваКПоступлениюИзменение.СуммаВалПередЗаписью КАК СуммаВалПередЗаписью
		|ПОМЕСТИТЬ ДвиженияДенежныеСредстваКПоступлениюИзменение
		|ИЗ
		|	ДвиженияДенежныеСредстваКПоступлениюИзменение КАК ДвиженияДенежныеСредстваКПоступлениюИзменение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РегистрНакопленияДенежныеСредстваКПоступлению.НомерСтроки,
		|	РегистрНакопленияДенежныеСредстваКПоступлению.Организация,
		|	РегистрНакопленияДенежныеСредстваКПоступлению.Касса,
		|	РегистрНакопленияДенежныеСредстваКПоступлению.ДоговорКонтрагента,
		|	РегистрНакопленияДенежныеСредстваКПоступлению.ДокументПередачи,
		|	ВЫБОР
		|		КОГДА РегистрНакопленияДенежныеСредстваКПоступлению.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА РегистрНакопленияДенежныеСредстваКПоступлению.Сумма
		|		ИНАЧЕ -РегистрНакопленияДенежныеСредстваКПоступлению.Сумма
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА РегистрНакопленияДенежныеСредстваКПоступлению.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА РегистрНакопленияДенежныеСредстваКПоступлению.СуммаВал
		|		ИНАЧЕ -РегистрНакопленияДенежныеСредстваКПоступлению.СуммаВал
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.ДенежныеСредстваКПоступлению КАК РегистрНакопленияДенежныеСредстваКПоступлению
		|ГДЕ
		|	РегистрНакопленияДенежныеСредстваКПоступлению.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
				
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	КонецЕсли;
	
	// Временная таблица "ДвиженияДенежныеСредстваКПоступлениюИзменение" уничтожается
	// Удаляется информация о ее существовании.
	
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияДенежныеСредстваКПоступлениюИзменение") Тогда
		
		Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияДенежныеСредстваКПоступлениюИзменение");
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		СтруктураВременныеТаблицы.Удалить("ДвиженияДенежныеСредстваКПоступлениюИзменение");
	
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ПриЗаписи набора записей.
//
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда	
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу "ДвиженияДенежныеСредстваИзменение".
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияДенежныеСредстваКПоступлениюИзменение.НомерСтроки) КАК НомерСтроки,
	|	ДвиженияДенежныеСредстваКПоступлениюИзменение.Организация КАК Организация,
	|	ДвиженияДенежныеСредстваКПоступлениюИзменение.Касса КАК Касса,
	|	ДвиженияДенежныеСредстваКПоступлениюИзменение.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ДвиженияДенежныеСредстваКПоступлениюИзменение.ДокументПередачи КАК ДокументПередачи,
	|	СУММА(ДвиженияДенежныеСредстваКПоступлениюИзменение.СуммаПередЗаписью) КАК СуммаПередЗаписью,
	|	СУММА(ДвиженияДенежныеСредстваКПоступлениюИзменение.СуммаИзменение) КАК СуммаИзменение,
	|	СУММА(ДвиженияДенежныеСредстваКПоступлениюИзменение.СуммаПриЗаписи) КАК СуммаПриЗаписи,
	|	СУММА(ДвиженияДенежныеСредстваКПоступлениюИзменение.СуммаВалПередЗаписью) КАК СуммаВалПередЗаписью,
	|	СУММА(ДвиженияДенежныеСредстваКПоступлениюИзменение.СуммаВалИзменение) КАК СуммаВалИзменение,
	|	СУММА(ДвиженияДенежныеСредстваКПоступлениюИзменение.СуммаВалПриЗаписи) КАК СуммаВалПриЗаписи
	|ПОМЕСТИТЬ ДвиженияДенежныеСредстваКПоступлениюИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияДенежныеСредстваКПоступлениюПередЗаписью.НомерСтроки КАК НомерСтроки,
	|		ДвиженияДенежныеСредстваКПоступлениюПередЗаписью.Организация КАК Организация,
	|		ДвиженияДенежныеСредстваКПоступлениюПередЗаписью.Касса КАК Касса,
	|		ДвиженияДенежныеСредстваКПоступлениюПередЗаписью.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|		ДвиженияДенежныеСредстваКПоступлениюПередЗаписью.ДокументПередачи КАК ДокументПередачи,
	|		ДвиженияДенежныеСредстваКПоступлениюПередЗаписью.СуммаПередЗаписью КАК СуммаПередЗаписью,
	|		ДвиженияДенежныеСредстваКПоступлениюПередЗаписью.СуммаПередЗаписью КАК СуммаИзменение,
	|		0 КАК СуммаПриЗаписи,
	|		ДвиженияДенежныеСредстваКПоступлениюПередЗаписью.СуммаВалПередЗаписью КАК СуммаВалПередЗаписью,
	|		ДвиженияДенежныеСредстваКПоступлениюПередЗаписью.СуммаВалПередЗаписью КАК СуммаВалИзменение,
	|		0 КАК СуммаВалПриЗаписи
	|	ИЗ
	|		ДвиженияДенежныеСредстваКПоступлениюПередЗаписью КАК ДвиженияДенежныеСредстваКПоступлениюПередЗаписью
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияДенежныеСредстваКПоступлениюПриЗаписи.НомерСтроки,
	|		ДвиженияДенежныеСредстваКПоступлениюПриЗаписи.Организация,
	|		ДвиженияДенежныеСредстваКПоступлениюПриЗаписи.Касса,
	|		ДвиженияДенежныеСредстваКПоступлениюПриЗаписи.ДоговорКонтрагента,
	|		ДвиженияДенежныеСредстваКПоступлениюПриЗаписи.ДокументПередачи,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияДенежныеСредстваКПоступлениюПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияДенежныеСредстваКПоступлениюПриЗаписи.Сумма
	|			ИНАЧЕ ДвиженияДенежныеСредстваКПоступлениюПриЗаписи.Сумма
	|		КОНЕЦ,
	|		ДвиженияДенежныеСредстваКПоступлениюПриЗаписи.Сумма,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияДенежныеСредстваКПоступлениюПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияДенежныеСредстваКПоступлениюПриЗаписи.СуммаВал
	|			ИНАЧЕ ДвиженияДенежныеСредстваКПоступлениюПриЗаписи.СуммаВал
	|		КОНЕЦ,
	|		ДвиженияДенежныеСредстваКПоступлениюПриЗаписи.СуммаВал
	|	ИЗ
	|		РегистрНакопления.ДенежныеСредстваКПоступлению КАК ДвиженияДенежныеСредстваКПоступлениюПриЗаписи
	|	ГДЕ
	|		ДвиженияДенежныеСредстваКПоступлениюПриЗаписи.Регистратор = &Регистратор) КАК ДвиженияДенежныеСредстваКПоступлениюИзменение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияДенежныеСредстваКПоступлениюИзменение.Организация,
	|	ДвиженияДенежныеСредстваКПоступлениюИзменение.Касса,
	|	ДвиженияДенежныеСредстваКПоступлениюИзменение.ДокументПередачи,
	|	ДвиженияДенежныеСредстваКПоступлениюИзменение.ДоговорКонтрагента
	|
	|ИМЕЮЩИЕ
	|	СУММА(ДвиженияДенежныеСредстваКПоступлениюИзменение.СуммаИзменение) <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Касса");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияДенежныеСредстваКПоступлениюИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияДенежныеСредстваКПоступлениюИзменение", ВыборкаИзРезультатаЗапроса.Количество > 0);
	
	// Временная таблица "ДвиженияДенежныеСредстваКПоступлениюПередЗаписью" уничтожается
	Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияДенежныеСредстваКПоступлениюПередЗаписью");
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
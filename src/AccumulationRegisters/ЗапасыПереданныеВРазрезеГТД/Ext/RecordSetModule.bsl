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
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ЗапасыПереданныеВРазрезеГТД.НаборЗаписей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Регистратор", Отбор.Регистратор.Значение);
	Блокировка.Заблокировать();
	
	Если НЕ СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыПереданныеВРазрезеГТДИзменение") ИЛИ
		СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыПереданныеВРазрезеГТДИзменение") И НЕ СтруктураВременныеТаблицы.ДвиженияЗапасыПереданныеВРазрезеГТДИзменение Тогда
		
		// Если временная таблица "ДвиженияЗапасыПереданныеВРазрезеГТДИзменение" не существует или не содержит записей
		// об изменении набора, значит набор записывается первый раз или для набора был выполнен контроль остатков.
		// Текущее состояние набора помещается во временную таблицу "ДвиженияЗапасыПереданныеВРазрезеГТДПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗапасыПереданныеВРазрезеГТД.НомерСтроки КАК НомерСтроки,
		|	ЗапасыПереданныеВРазрезеГТД.Организация КАК Организация,
		|	ЗапасыПереданныеВРазрезеГТД.СтранаПроисхождения КАК СтранаПроисхождения,
		|	ЗапасыПереданныеВРазрезеГТД.Номенклатура КАК Номенклатура,
		|	ЗапасыПереданныеВРазрезеГТД.Характеристика КАК Характеристика,
		|	ЗапасыПереданныеВРазрезеГТД.Партия КАК Партия,
		|	ЗапасыПереданныеВРазрезеГТД.НомерГТД КАК НомерГТД,
		|	ВЫБОР
		|		КОГДА ЗапасыПереданныеВРазрезеГТД.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗапасыПереданныеВРазрезеГТД.Количество
		|		ИНАЧЕ -ЗапасыПереданныеВРазрезеГТД.Количество
		|	КОНЕЦ КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияЗапасыПереданныеВРазрезеГТДПередЗаписью
		|ИЗ
		|	РегистрНакопления.ЗапасыПереданныеВРазрезеГТД КАК ЗапасыПереданныеВРазрезеГТД
		|ГДЕ
		|	ЗапасыПереданныеВРазрезеГТД.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	Иначе
		
		// Если временная таблица "ДвиженияЗапасыПереданныеВРазрезеГТДИзменение" существует и содержит записи
		// об изменении набора, значит набор записывается не первый раз и для набора не был выполнен контроль остатков.
		// Текущее состояние набора и текущее состояние изменений помещаются во временную таблицу "ДвиженияЗапасыПереданныеВРазрезеГТДПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно первоначального.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.Организация КАК Организация,
		|	ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.СтранаПроисхождения КАК СтранаПроисхождения,
		|	ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.Номенклатура КАК Номенклатура,
		|	ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.Характеристика КАК Характеристика,
		|	ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.Партия КАК Партия,
		|	ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.НомерГТД КАК НомерГТД,
		|	ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.КоличествоПередЗаписью КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияЗапасыПереданныеВРазрезеГТДПередЗаписью
		|ИЗ
		|	ДвиженияЗапасыПереданныеВРазрезеГТДИзменение КАК ДвиженияЗапасыПереданныеВРазрезеГТДИзменение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗапасыПереданныеВРазрезеГТД.НомерСтроки,
		|	ЗапасыПереданныеВРазрезеГТД.Организация,
		|	ЗапасыПереданныеВРазрезеГТД.СтранаПроисхождения,
		|	ЗапасыПереданныеВРазрезеГТД.Номенклатура,
		|	ЗапасыПереданныеВРазрезеГТД.Характеристика,
		|	ЗапасыПереданныеВРазрезеГТД.Партия,
		|	ЗапасыПереданныеВРазрезеГТД.НомерГТД,
		|	ВЫБОР
		|		КОГДА ЗапасыПереданныеВРазрезеГТД.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗапасыПереданныеВРазрезеГТД.Количество
		|		ИНАЧЕ -ЗапасыПереданныеВРазрезеГТД.Количество
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.ЗапасыПереданныеВРазрезеГТД КАК ЗапасыПереданныеВРазрезеГТД
		|ГДЕ
		|	ЗапасыПереданныеВРазрезеГТД.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	КонецЕсли;
	
	// Временная таблица "ДвиженияЗапасыПереданныеВРазрезеГТДИзменение" уничтожается
	// Удаляется информация о ее существовании.
	
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыПереданныеВРазрезеГТДИзменение") Тогда
		
		Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗапасыПереданныеВРазрезеГТДИзменение");
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		СтруктураВременныеТаблицы.Удалить("ДвиженияЗапасыПереданныеВРазрезеГТДИзменение");
	
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
	// и помещается во временную таблицу "ДвиженияЗапасыПереданныеВРазрезеГТДИзменение".
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.НомерСтроки) КАК НомерСтроки,
	|	ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.Организация КАК Организация,
	|	ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.СтранаПроисхождения КАК СтранаПроисхождения,
	|	ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.Номенклатура КАК Номенклатура,
	|	ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.Характеристика КАК Характеристика,
	|	ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.Партия КАК Партия,
	|	ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.НомерГТД КАК НомерГТД,
	|	СУММА(ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.КоличествоПередЗаписью) КАК КоличествоПередЗаписью,
	|	СУММА(ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.КоличествоИзменение) КАК КоличествоИзменение,
	|	СУММА(ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.КоличествоПриЗаписи) КАК КоличествоПриЗаписи
	|ПОМЕСТИТЬ ДвиженияЗапасыПереданныеВРазрезеГТДИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияЗапасыПереданныеВРазрезеГТДПередЗаписью.НомерСтроки КАК НомерСтроки,
	|		ДвиженияЗапасыПереданныеВРазрезеГТДПередЗаписью.Организация КАК Организация,
	|		ДвиженияЗапасыПереданныеВРазрезеГТДПередЗаписью.СтранаПроисхождения КАК СтранаПроисхождения,
	|		ДвиженияЗапасыПереданныеВРазрезеГТДПередЗаписью.Номенклатура КАК Номенклатура,
	|		ДвиженияЗапасыПереданныеВРазрезеГТДПередЗаписью.Характеристика КАК Характеристика,
	|		ДвиженияЗапасыПереданныеВРазрезеГТДПередЗаписью.Партия КАК Партия,
	|		ДвиженияЗапасыПереданныеВРазрезеГТДПередЗаписью.НомерГТД КАК НомерГТД,
	|		ДвиженияЗапасыПереданныеВРазрезеГТДПередЗаписью.КоличествоПередЗаписью КАК КоличествоПередЗаписью,
	|		ДвиженияЗапасыПереданныеВРазрезеГТДПередЗаписью.КоличествоПередЗаписью КАК КоличествоИзменение,
	|		0 КАК КоличествоПриЗаписи
	|	ИЗ
	|		ДвиженияЗапасыПереданныеВРазрезеГТДПередЗаписью КАК ДвиженияЗапасыПереданныеВРазрезеГТДПередЗаписью
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияЗапасыПереданныеВРазрезеГТДПриЗаписи.НомерСтроки,
	|		ДвиженияЗапасыПереданныеВРазрезеГТДПриЗаписи.Организация,
	|		ДвиженияЗапасыПереданныеВРазрезеГТДПриЗаписи.СтранаПроисхождения,
	|		ДвиженияЗапасыПереданныеВРазрезеГТДПриЗаписи.Номенклатура,
	|		ДвиженияЗапасыПереданныеВРазрезеГТДПриЗаписи.Характеристика,
	|		ДвиженияЗапасыПереданныеВРазрезеГТДПриЗаписи.Партия,
	|		ДвиженияЗапасыПереданныеВРазрезеГТДПриЗаписи.НомерГТД,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияЗапасыПереданныеВРазрезеГТДПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияЗапасыПереданныеВРазрезеГТДПриЗаписи.Количество
	|			ИНАЧЕ ДвиженияЗапасыПереданныеВРазрезеГТДПриЗаписи.Количество
	|		КОНЕЦ,
	|		ДвиженияЗапасыПереданныеВРазрезеГТДПриЗаписи.Количество
	|	ИЗ
	|		РегистрНакопления.ЗапасыПереданныеВРазрезеГТД КАК ДвиженияЗапасыПереданныеВРазрезеГТДПриЗаписи
	|	ГДЕ
	|		ДвиженияЗапасыПереданныеВРазрезеГТДПриЗаписи.Регистратор = &Регистратор) КАК ДвиженияЗапасыПереданныеВРазрезеГТДИзменение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.Организация,
	|	ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.СтранаПроисхождения,
	|	ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.Номенклатура,
	|	ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.Характеристика,
	|	ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.Партия,
	|	ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.НомерГТД
	|
	|ИМЕЮЩИЕ
	|	СУММА(ДвиженияЗапасыПереданныеВРазрезеГТДИзменение.КоличествоИзменение) <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	СтранаПроисхождения,
	|	Номенклатура,
	|	Характеристика,
	|	Партия,
	|	НомерГТД");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияЗапасыПереданныеВРазрезеГТДИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗапасыПереданныеВРазрезеГТДИзменение", ВыборкаИзРезультатаЗапроса.Количество > 0);
	
	// Временная таблица "ДвиженияЗапасыПереданныеВРазрезеГТДПередЗаписью" уничтожается
	Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗапасыПереданныеВРазрезеГТДПередЗаписью");
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
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
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.БонусныеБаллы.НаборЗаписей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Регистратор", Отбор.Регистратор.Значение);
	Блокировка.Заблокировать();
	
	Если НЕ СтруктураВременныеТаблицы.Свойство("ДвиженияБонусныеБаллыИзменение") ИЛИ
		СтруктураВременныеТаблицы.Свойство("ДвиженияБонусныеБаллыИзменение") И НЕ СтруктураВременныеТаблицы.ДвиженияБонусныеБаллыИзменение Тогда
		
		// Если временная таблица "ДвиженияБонусныеБаллыИзменение" не существует или не содержит записей
		// об изменении набора, значит набор записывается первый раз или для набора был выполнен контроль остатков.
		// Текущее состояние набора помещается во временную таблицу "ДвиженияБонусныеБаллыПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	БонусныеБаллы.НомерСтроки КАК НомерСтроки,
		|	БонусныеБаллы.БонуснаяКарта КАК БонуснаяКарта,
		|	ВЫБОР
		|		КОГДА БонусныеБаллы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА БонусныеБаллы.Начислено
		|		ИНАЧЕ -БонусныеБаллы.Начислено
		|	КОНЕЦ КАК НачисленоПередЗаписью,
		|	ВЫБОР
		|		КОГДА БонусныеБаллы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА БонусныеБаллы.КСписанию
		|		ИНАЧЕ -БонусныеБаллы.КСписанию
		|	КОНЕЦ КАК КСписаниюПередЗаписью
		|ПОМЕСТИТЬ ДвиженияБонусныеБаллыПередЗаписью
		|ИЗ
		|	РегистрНакопления.БонусныеБаллы КАК БонусныеБаллы
		|ГДЕ
		|	БонусныеБаллы.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	Иначе
		
		// Если временная таблица "ДвиженияБонусныеБаллыИзменение" существует и содержит записи
		// об изменении набора, значит набор записывается не первый раз и для набора не был выполнен контроль остатков.
		// Текущее состояние набора и текущее состояние изменений помещаются во временную таблицу "ДвиженияБонусныеБаллыПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно первоначального.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияБонусныеБаллыИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияБонусныеБаллыИзменение.БонуснаяКарта КАК БонуснаяКарта,
		|	ДвиженияБонусныеБаллыИзменение.НачисленоПередЗаписью КАК НачисленоПередЗаписью,
		|	ДвиженияБонусныеБаллыИзменение.КСписаниюПередЗаписью КАК КСписаниюПередЗаписью
		|ПОМЕСТИТЬ ДвиженияБонусныеБаллыПередЗаписью
		|ИЗ
		|	ДвиженияБонусныеБаллыИзменение КАК ДвиженияБонусныеБаллыИзменение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	БонусныеБаллы.НомерСтроки,
		|	БонусныеБаллы.БонуснаяКарта,
		|	ВЫБОР
		|		КОГДА БонусныеБаллы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА БонусныеБаллы.Начислено
		|		ИНАЧЕ -БонусныеБаллы.Начислено
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА БонусныеБаллы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА БонусныеБаллы.КСписанию
		|		ИНАЧЕ -БонусныеБаллы.КСписанию
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.БонусныеБаллы КАК БонусныеБаллы
		|ГДЕ
		|	БонусныеБаллы.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	КонецЕсли;
	
	// Временная таблица "ДвиженияБонусныеБаллыИзменение" уничтожается
	// Удаляется информация о ее существовании.
	
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияБонусныеБаллыИзменение") Тогда
		
		Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияБонусныеБаллыИзменение");
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		СтруктураВременныеТаблицы.Удалить("ДвиженияБонусныеБаллыИзменение");
	
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
	// и помещается во временную таблицу "ДвиженияБонусныеБаллыИзменение".
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияБонусныеБаллыИзменение.НомерСтроки) КАК НомерСтроки,
	|	ДвиженияБонусныеБаллыИзменение.БонуснаяКарта КАК БонуснаяКарта,
	|	СУММА(ДвиженияБонусныеБаллыИзменение.НачисленоПередЗаписью) КАК НачисленоПередЗаписью,
	|	СУММА(ДвиженияБонусныеБаллыИзменение.НачисленоИзменение) КАК НачисленоИзменение,
	|	СУММА(ДвиженияБонусныеБаллыИзменение.НачисленоПриЗаписи) КАК НачисленоПриЗаписи,
	|	СУММА(ДвиженияБонусныеБаллыИзменение.КСписаниюПередЗаписью) КАК КСписаниюПередЗаписью,
	|	СУММА(ДвиженияБонусныеБаллыИзменение.КСписаниюИзменение) КАК КСписаниюИзменение,
	|	СУММА(ДвиженияБонусныеБаллыИзменение.КСписаниюПриЗаписи) КАК КСписаниюПриЗаписи
	|ПОМЕСТИТЬ ДвиженияБонусныеБаллыИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияБонусныеБаллыПередЗаписью.НомерСтроки КАК НомерСтроки,
	|		ДвиженияБонусныеБаллыПередЗаписью.БонуснаяКарта КАК БонуснаяКарта,
	|		ДвиженияБонусныеБаллыПередЗаписью.НачисленоПередЗаписью КАК НачисленоПередЗаписью,
	|		ДвиженияБонусныеБаллыПередЗаписью.НачисленоПередЗаписью КАК НачисленоИзменение,
	|		0 КАК НачисленоПриЗаписи,
	|		ДвиженияБонусныеБаллыПередЗаписью.КСписаниюПередЗаписью КАК КСписаниюПередЗаписью,
	|		ДвиженияБонусныеБаллыПередЗаписью.КСписаниюПередЗаписью КАК КСписаниюИзменение,
	|		0 КАК КСписаниюПриЗаписи
	|	ИЗ
	|		ДвиженияБонусныеБаллыПередЗаписью КАК ДвиженияБонусныеБаллыПередЗаписью
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		БонусныеБаллыПриЗаписи.НомерСтроки,
	|		БонусныеБаллыПриЗаписи.БонуснаяКарта,
	|		0,
	|		ВЫБОР
	|			КОГДА БонусныеБаллыПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -БонусныеБаллыПриЗаписи.Начислено
	|			ИНАЧЕ БонусныеБаллыПриЗаписи.Начислено
	|		КОНЕЦ,
	|		БонусныеБаллыПриЗаписи.Начислено,
	|		0,
	|		ВЫБОР
	|			КОГДА БонусныеБаллыПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -БонусныеБаллыПриЗаписи.КСписанию
	|			ИНАЧЕ БонусныеБаллыПриЗаписи.КСписанию
	|		КОНЕЦ,
	|		БонусныеБаллыПриЗаписи.КСписанию
	|	ИЗ
	|		РегистрНакопления.БонусныеБаллы КАК БонусныеБаллыПриЗаписи) КАК ДвиженияБонусныеБаллыИзменение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияБонусныеБаллыИзменение.БонуснаяКарта
	|
	|ИМЕЮЩИЕ
	|	(СУММА(ДвиженияБонусныеБаллыИзменение.НачисленоИзменение) <> 0
	|		ИЛИ СУММА(ДвиженияБонусныеБаллыИзменение.КСписаниюИзменение) <> 0)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	БонуснаяКарта");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияБонусныеБаллыИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияБонусныеБаллыИзменение", ВыборкаИзРезультатаЗапроса.Количество > 0);
	
	// Временная таблица "ДвиженияБонусныеБаллыПередЗаписью" уничтожается
	Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияБонусныеБаллыПередЗаписью");
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура рассчитывает и записывает график выполнения заказа.
// Дата отгрузки указывается в "Периоде". При фактической отгрузке
// по заказу происходит закрытие графика по ФИФО.
//
Процедура РассчитатьГрафикВыполненияЗаказов()
	
	ТаблицаЗаказов = ДополнительныеСвойства.ТаблицаЗаказов;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивЗаказов", ТаблицаЗаказов.ВыгрузитьКолонку("ЗаказПоставщику"));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаказыПоставщикамОстатки.Организация КАК Организация,
	|	ЗаказыПоставщикамОстатки.Склад КАК Склад,
	|	ЗаказыПоставщикамОстатки.ЗаказПоставщику КАК ЗаказПоставщику,
	|	ЗаказыПоставщикамОстатки.Номенклатура КАК Номенклатура,
	|	ЗаказыПоставщикамОстатки.Характеристика КАК Характеристика,
	|	ЗаказыПоставщикамОстатки.КоличествоОстаток КАК КоличествоОстаток
	|ПОМЕСТИТЬ ВТ_Остатки
	|ИЗ
	|	РегистрНакопления.ЗаказыПоставщикам.Остатки(, ЗаказПоставщику В (&МассивЗаказов)) КАК ЗаказыПоставщикамОстатки
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Склад,
	|	ЗаказПоставщику,
	|	Номенклатура,
	|	Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(Таблица.ДатаПоступления, ДЕНЬ) КАК Период,
	|	Таблица.Организация КАК Организация,
	|	Таблица.Склад КАК Склад,
	|	Таблица.ЗаказПоставщику КАК ЗаказПоставщику,
	|	Таблица.Номенклатура КАК Номенклатура,
	|	Таблица.Характеристика КАК Характеристика,
	|	СУММА(Таблица.Количество) КАК КоличествоПлан
	|ПОМЕСТИТЬ ВТ_ПланДвижения
	|ИЗ
	|	РегистрНакопления.ЗаказыПоставщикам КАК Таблица
	|ГДЕ
	|	Таблица.ЗаказПоставщику В(&МассивЗаказов)
	|	И Таблица.ДатаПоступления <> ДАТАВРЕМЯ(1, 1, 1)
	|	И Таблица.Количество > 0
	|	И Таблица.Активность
	|
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(Таблица.ДатаПоступления, ДЕНЬ),
	|	Таблица.Организация,
	|	Таблица.Склад,
	|	Таблица.ЗаказПоставщику,
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Склад,
	|	ЗаказПоставщику,
	|	Номенклатура,
	|	Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Таблица.Период КАК Период,
	|	ВТ_Таблица.Организация КАК Организация,
	|	ВТ_Таблица.Склад КАК Склад,
	|	ВТ_Таблица.ЗаказПоставщику КАК ЗаказПоставщику,
	|	ВТ_Таблица.Номенклатура КАК Номенклатура,
	|	ВТ_Таблица.Характеристика КАК Характеристика,
	|	ВТ_Таблица.КоличествоПлан КАК КоличествоПлан,
	|	ЕСТЬNULL(ВТ_Остатки.КоличествоОстаток, 0) КАК КоличествоОстаток
	|ИЗ
	|	ВТ_ПланДвижения КАК ВТ_Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Остатки КАК ВТ_Остатки
	|		ПО ВТ_Таблица.Организация = ВТ_Остатки.Организация
	|			И ВТ_Таблица.Склад = ВТ_Остатки.Склад
	|			И ВТ_Таблица.ЗаказПоставщику = ВТ_Остатки.ЗаказПоставщику
	|			И ВТ_Таблица.Номенклатура = ВТ_Остатки.Номенклатура
	|			И ВТ_Таблица.Характеристика = ВТ_Остатки.Характеристика
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаказПоставщику,
	|	Номенклатура,
	|	Характеристика,
	|	Период УБЫВ";
	
	НаборЗаписей = РегистрыСведений.ГрафикВыполненияЗаказов.СоздатьНаборЗаписей();
	Выборка = Запрос.Выполнить().Выбрать();
	ЕстьЗаписиВВыборке = Выборка.Следующий();
	Пока ЕстьЗаписиВВыборке Цикл
		
		ТекПериод = Неопределено;
		ТекОрганизация = Неопределено;
		ТекСклад = Неопределено;
		ТекНоменклатура = Неопределено;
		ТекХарактеристика = Неопределено;
		ТекЗаказПоставщику = Выборка.ЗаказПоставщику;
		
		СписокПериодов = Новый СписокЗначений;
		
		НаборЗаписей.Отбор.Заказ.Установить(ТекЗаказПоставщику);
		
		// Из таблицы удаляем отработанный заказ.
		ТаблицаЗаказов.Удалить(ТаблицаЗаказов.Найти(ТекЗаказПоставщику, "ЗаказПоставщику"));
		
		// Цикл по строкам одного заказа.
		ВсегоПлан = 0;
		ВсегоОстаток = 0;
		СтруктураНаборЗаписей = Новый Структура;
		Пока ЕстьЗаписиВВыборке И Выборка.ЗаказПоставщику = ТекЗаказПоставщику Цикл
			
			ВсегоПлан = ВсегоПлан + Выборка.КоличествоПлан;
			
			Если ТекНоменклатура <> Выборка.Номенклатура
				ИЛИ ТекХарактеристика <> Выборка.Характеристика
				ИЛИ ТекОрганизация <> Выборка.Организация
				ИЛИ ТекСклад <> Выборка.Склад Тогда
				
				ТекНоменклатура = Выборка.Номенклатура;
				ТекХарактеристика = Выборка.Характеристика;
				ТекОрганизация = Выборка.Организация;
				ТекСклад = Выборка.Склад;
				
				ВсегоКоличествоОстаток = 0;
				Если Выборка.КоличествоОстаток > 0 Тогда
					ВсегоКоличествоОстаток = Выборка.КоличествоОстаток;
				КонецЕсли;
				
				ВсегоОстаток = ВсегоОстаток + Выборка.КоличествоОстаток;
				
			КонецЕсли;
			
			ТекКоличество = Мин(Выборка.КоличествоПлан, ВсегоКоличествоОстаток);
			Если ТекКоличество > 0 И ?(ЗначениеЗаполнено(ТекПериод), ТекПериод > Выборка.Период, Истина) Тогда
				
				СтруктураНаборЗаписей.Вставить("Период", Выборка.Период);
				СтруктураНаборЗаписей.Вставить("ЗаказПоставщику", Выборка.ЗаказПоставщику);
				
				ТекПериод = Выборка.Период;
				
			КонецЕсли;
			
			ВсегоКоличествоОстаток = ВсегоКоличествоОстаток - ТекКоличество;
			
			// Переход к следующей записи в выборке.
			ЕстьЗаписиВВыборке = Выборка.Следующий();
			
		КонецЦикла;
		
		// Запись и очистка набора.
		Если СтруктураНаборЗаписей.Количество() > 0 Тогда
			Запись = НаборЗаписей.Добавить();
			Запись.Период = СтруктураНаборЗаписей.Период;
			Запись.Заказ = СтруктураНаборЗаписей.ЗаказПоставщику;
			Запись.Выполнено = ВсегоПлан - ВсегоОстаток;
		КонецЕсли;
		
		НаборЗаписей.Записать(Истина);
		НаборЗаписей.Очистить();
		
		АссистентУправления.ПриСрабатыванииСобытия(ТекЗаказПоставщику, "ИзменениеПоступленияЗапасов", Отбор.Регистратор.Значение);
		
	КонецЦикла;
	
	// По неотработанным заказам нужно очистить движения.
	Если ТаблицаЗаказов.Количество() > 0 Тогда
		Для Каждого СтрокаТаб Из ТаблицаЗаказов Цикл
			
			НаборЗаписей.Отбор.Заказ.Установить(СтрокаТаб.ЗаказПоставщику);
			НаборЗаписей.Записать(Истина);
			НаборЗаписей.Очистить();
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры // РассчитатьГрафикВыполненияЗаказов()

// Процедура формирует таблицу заказов, которые были раньше в движениях
// и которые сейчас будут записаны.
//
Процедура СФормироватьТаблицуЗаказов()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаЗаказыПоставщикам.ЗаказПоставщику КАК ЗаказПоставщику
	|ИЗ
	|	РегистрНакопления.ЗаказыПоставщикам КАК ТаблицаЗаказыПоставщикам
	|ГДЕ
	|	ТаблицаЗаказыПоставщикам.Регистратор = &Регистратор";
	
	ТаблицаЗаказов = Запрос.Выполнить().Выгрузить();
	ТаблицаНовыхЗаказов = Выгрузить(, "ЗаказПоставщику");
	ТаблицаНовыхЗаказов.Свернуть("ЗаказПоставщику");
	Для Каждого Запись Из ТаблицаНовыхЗаказов Цикл
		
		Если ТаблицаЗаказов.Найти(Запись.ЗаказПоставщику, "ЗаказПоставщику") = Неопределено Тогда
			ТаблицаЗаказов.Добавить().ЗаказПоставщику = Запись.ЗаказПоставщику;
		КонецЕсли;
		
	КонецЦикла;
	
	ДополнительныеСвойства.Вставить("ТаблицаЗаказов", ТаблицаЗаказов);
	
КонецПроцедуры // СФормироватьТаблицуЗаказов()

// Процедура устанавливает блокировку данных для расчета графика.
//
Процедура УстановитьБлокировкиДанныхДляРасчетаГрафика()
	
	Блокировка = Новый БлокировкаДанных;
	
	// Блокировка регистра для подсчета остатков по заказам.
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ЗаказыПоставщикам");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	ЭлементБлокировки.ИсточникДанных = ДополнительныеСвойства.ТаблицаЗаказов;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ЗаказПоставщику", "ЗаказПоставщику");
	
	// Блокировка набора для записи.
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ГрафикВыполненияЗаказов");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ДополнительныеСвойства.ТаблицаЗаказов;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Заказ", "ЗаказПоставщику");
	
	Блокировка.Заблокировать();
	
КонецПроцедуры // УстановитьБлокировкиДанныхДляРасчетаГрафика()

// Процедура формирует таблицу исходных движений по регистру.
//
Процедура СформироватьТаблицуИсходныхДвижений(Отказ, Замещение)
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Установка исключительной блокировки текущего набора записей регистратора.
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ЗаказыПоставщикам.НаборЗаписей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Регистратор", Отбор.Регистратор.Значение);
	Блокировка.Заблокировать();
	
	Если НЕ СтруктураВременныеТаблицы.Свойство("ДвиженияЗаказыПоставщикамИзменение") ИЛИ
		СтруктураВременныеТаблицы.Свойство("ДвиженияЗаказыПоставщикамИзменение") И НЕ СтруктураВременныеТаблицы.ДвиженияЗаказыПоставщикамИзменение Тогда
		
		// Если временная таблица "ДвиженияЗаказыПоставщикамИзменение" не существует или не содержит записей
		// об изменении набора, значит набор записывается первый раз или для набора был выполнен контроль остатков.
		// Текущее состояние набора помещается во временную таблицу "ДвиженияЗаказыПоставщикамПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗаказыПоставщикам.НомерСтроки КАК НомерСтроки,
		|	ЗаказыПоставщикам.Организация КАК Организация,
		|	ЗаказыПоставщикам.Склад КАК Склад,
		|	ЗаказыПоставщикам.ЗаказПоставщику КАК ЗаказПоставщику,
		|	ЗаказыПоставщикам.Номенклатура КАК Номенклатура,
		|	ЗаказыПоставщикам.Характеристика КАК Характеристика,
		|	ВЫБОР
		|		КОГДА ЗаказыПоставщикам.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗаказыПоставщикам.Количество
		|		ИНАЧЕ -ЗаказыПоставщикам.Количество
		|	КОНЕЦ КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияЗаказыПоставщикамПередЗаписью
		|ИЗ
		|	РегистрНакопления.ЗаказыПоставщикам КАК ЗаказыПоставщикам
		|ГДЕ
		|	ЗаказыПоставщикам.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	Иначе
		
		// Если временная таблица "ДвиженияЗаказыПокупателейИзменение" существует и содержит записи
		// об изменении набора, значит набор записывается не первый раз и для набора не был выполнен контроль остатков.
		// Текущее состояние набора и текущее состояние изменений помещаются во временную таблицу "ДвиженияЗаказыПокупателейПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно первоначального.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияЗаказыПоставщикамИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияЗаказыПоставщикамИзменение.Организация КАК Организация,
		|	ДвиженияЗаказыПоставщикамИзменение.Склад КАК Склад,
		|	ДвиженияЗаказыПоставщикамИзменение.ЗаказПоставщику КАК ЗаказПоставщику,
		|	ДвиженияЗаказыПоставщикамИзменение.Номенклатура КАК Номенклатура,
		|	ДвиженияЗаказыПоставщикамИзменение.Характеристика КАК Характеристика,
		|	ДвиженияЗаказыПоставщикамИзменение.КоличествоПередЗаписью КАК КоличествоПередЗаписью
		|ПОМЕСТИТЬ ДвиженияЗаказыПоставщикамПередЗаписью
		|ИЗ
		|	ДвиженияЗаказыПоставщикамИзменение КАК ДвиженияЗаказыПоставщикамИзменение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗаказыПоставщикам.НомерСтроки,
		|	ЗаказыПоставщикам.Организация,
		|	ЗаказыПоставщикам.Склад,
		|	ЗаказыПоставщикам.ЗаказПоставщику,
		|	ЗаказыПоставщикам.Номенклатура,
		|	ЗаказыПоставщикам.Характеристика,
		|	ВЫБОР
		|		КОГДА ЗаказыПоставщикам.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ЗаказыПоставщикам.Количество
		|		ИНАЧЕ -ЗаказыПоставщикам.Количество
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.ЗаказыПоставщикам КАК ЗаказыПоставщикам
		|ГДЕ
		|	ЗаказыПоставщикам.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	КонецЕсли;
	
	// Временная таблица "ДвиженияЗаказыПоставщикамИзменение" уничтожается
	// Удаляется информация о ее существовании.
	
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияЗаказыПоставщикамИзменение") Тогда
		
		Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗаказыПоставщикамИзменение");
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		СтруктураВременныеТаблицы.Удалить("ДвиженияЗаказыПоставщикамИзменение");
	
	КонецЕсли;
	
КонецПроцедуры // СформироватьТаблицуИсходныхДвижений()

// Процедура формирует таблицу изменений движений по регистру.
//
Процедура СформироватьТаблицуИзмененийДвижений(Отказ, Замещение)
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу "ДвиженияЗаказыПоставщикамИзменение".
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияЗаказыПоставщикамИзменение.НомерСтроки) КАК НомерСтроки,
	|	ДвиженияЗаказыПоставщикамИзменение.Организация КАК Организация,
	|	ДвиженияЗаказыПоставщикамИзменение.Склад КАК Склад,
	|	ДвиженияЗаказыПоставщикамИзменение.ЗаказПоставщику КАК ЗаказПоставщику,
	|	ДвиженияЗаказыПоставщикамИзменение.Номенклатура КАК Номенклатура,
	|	ДвиженияЗаказыПоставщикамИзменение.Характеристика КАК Характеристика,
	|	СУММА(ДвиженияЗаказыПоставщикамИзменение.КоличествоПередЗаписью) КАК КоличествоПередЗаписью,
	|	СУММА(ДвиженияЗаказыПоставщикамИзменение.КоличествоИзменение) КАК КоличествоИзменение,
	|	СУММА(ДвиженияЗаказыПоставщикамИзменение.КоличествоПриЗаписи) КАК КоличествоПриЗаписи
	|ПОМЕСТИТЬ ДвиженияЗаказыПоставщикамИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияЗаказыПоставщикамПередЗаписью.НомерСтроки КАК НомерСтроки,
	|		ДвиженияЗаказыПоставщикамПередЗаписью.Организация КАК Организация,
	|		ДвиженияЗаказыПоставщикамПередЗаписью.Склад КАК Склад,
	|		ДвиженияЗаказыПоставщикамПередЗаписью.ЗаказПоставщику КАК ЗаказПоставщику,
	|		ДвиженияЗаказыПоставщикамПередЗаписью.Номенклатура КАК Номенклатура,
	|		ДвиженияЗаказыПоставщикамПередЗаписью.Характеристика КАК Характеристика,
	|		ДвиженияЗаказыПоставщикамПередЗаписью.КоличествоПередЗаписью КАК КоличествоПередЗаписью,
	|		ДвиженияЗаказыПоставщикамПередЗаписью.КоличествоПередЗаписью КАК КоличествоИзменение,
	|		0 КАК КоличествоПриЗаписи
	|	ИЗ
	|		ДвиженияЗаказыПоставщикамПередЗаписью КАК ДвиженияЗаказыПоставщикамПередЗаписью
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияЗаказыПоставщикамПриЗаписи.НомерСтроки,
	|		ДвиженияЗаказыПоставщикамПриЗаписи.Организация,
	|		ДвиженияЗаказыПоставщикамПриЗаписи.Склад,
	|		ДвиженияЗаказыПоставщикамПриЗаписи.ЗаказПоставщику,
	|		ДвиженияЗаказыПоставщикамПриЗаписи.Номенклатура,
	|		ДвиженияЗаказыПоставщикамПриЗаписи.Характеристика,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияЗаказыПоставщикамПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияЗаказыПоставщикамПриЗаписи.Количество
	|			ИНАЧЕ ДвиженияЗаказыПоставщикамПриЗаписи.Количество
	|		КОНЕЦ,
	|		ДвиженияЗаказыПоставщикамПриЗаписи.Количество
	|	ИЗ
	|		РегистрНакопления.ЗаказыПоставщикам КАК ДвиженияЗаказыПоставщикамПриЗаписи
	|	ГДЕ
	|		ДвиженияЗаказыПоставщикамПриЗаписи.Регистратор = &Регистратор) КАК ДвиженияЗаказыПоставщикамИзменение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияЗаказыПоставщикамИзменение.Организация,
	|	ДвиженияЗаказыПоставщикамИзменение.Склад,
	|	ДвиженияЗаказыПоставщикамИзменение.ЗаказПоставщику,
	|	ДвиженияЗаказыПоставщикамИзменение.Номенклатура,
	|	ДвиженияЗаказыПоставщикамИзменение.Характеристика
	|
	|ИМЕЮЩИЕ
	|	СУММА(ДвиженияЗаказыПоставщикамИзменение.КоличествоИзменение) <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Склад,
	|	ЗаказПоставщику,
	|	Номенклатура,
	|	Характеристика");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияЗаказыПоставщикамИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗаказыПоставщикамИзменение", ВыборкаИзРезультатаЗапроса.Количество > 0);
	
	// Временная таблица "ДвиженияЗаказыПоставщикамПередЗаписью" уничтожается
	Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияЗаказыПоставщикамПередЗаписью");
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры // СформироватьТаблицуИзмененийДвижений()

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью набора записей.
//
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СформироватьТаблицуИсходныхДвижений(Отказ, Замещение);
	
	СФормироватьТаблицуЗаказов();
	УстановитьБлокировкиДанныхДляРасчетаГрафика();
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ПриЗаписи набора записей.
//
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СформироватьТаблицуИзмененийДвижений(Отказ, Замещение);
	
	РассчитатьГрафикВыполненияЗаказов();
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
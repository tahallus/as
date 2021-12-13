﻿
#Область ПрограммныйИнтерфейс

#Область Обсуждения

Функция ЛогироватьИзмененияОбъектов() Экспорт
	
	#Если НЕ ВнешнееСоединение Тогда
		
		Возврат СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована();
		
	#КонецЕсли

	Возврат Ложь;
	
КонецФункции

#КонецОбласти

Функция ПроверяемыеРеквизитыОбсуждения() Экспорт
	
	СтруктураРеквизитов = Новый Структура;
	
	ДокументКлюч = "АвансовыйОтчет";
	СтрокаРеквизитов =
	"ДокументОснование,
	|Комментарий,
	|Организация,
	|Сотрудник,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "АктВыполненныхРабот";
	СтрокаРеквизитов =
	"Договор,
	|ДокументОснование,
	|Комментарий,
	|Контрагент,
	|Организация,
	|Ответственный,
	|Подразделение,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "ДополнительныеРасходы";
	СтрокаРеквизитов =
	"Договор,
	|Комментарий,
	|Контрагент,
	|Организация,
	|Ответственный,
	|Подразделение,
	|СтруктурнаяЕдиница,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "ЗаданиеНаРаботу";
	СтрокаРеквизитов =
	"Комментарий,
	|Организация,
	|Состояние,
	|Сотрудник,
	|СтруктурнаяЕдиница,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "ЗаказНаПеремещение";
	СтрокаРеквизитов =
	"ДокументОснование,
	|Комментарий,
	|Организация,
	|СтруктурнаяЕдиницаПолучатель,
	|СтруктурнаяЕдиницаРезерв";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "ЗаказНаПроизводство";
	СтрокаРеквизитов =
	"ДокументОснование,
	|Комментарий,
	|Организация,
	|Ответственный,
	|СостояниеЗаказа,
	|СтруктурнаяЕдиница,
	|СтруктурнаяЕдиницаРезерв";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "ЗаказПокупателя";
	СтрокаРеквизитов =
	"Договор,
	|ДокументОснование,
	|КалькуляцияРассчитана,
	|Комментарий,
	|Контрагент,
	|Организация,
	|Ответственный,
	|СостояниеЗаказа,
	|СтруктурнаяЕдиницаПродажи,
	|СтруктурнаяЕдиницаРезерв,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "ЗаказПоставщику";
	СтрокаРеквизитов =
	"Договор,
	|Комментарий,
	|Контрагент,
	|Организация,
	|Ответственный,
	|СостояниеЗаказа,
	|СтруктурнаяЕдиница,
	|СтруктурнаяЕдиницаРезерв,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "РасходДСПлан";
	СтрокаРеквизитов =
	"БанковскийСчет,
	|Договор,
	|ДокументОснование,
	|Касса,
	|Комментарий,
	|Контрагент,
	|Организация,
	|СтатусУтвержденияПлатежа,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "ИнвентаризацияЗапасов";
	СтрокаРеквизитов =
	"Комментарий,
	|Организация,
	|СтруктурнаяЕдиница";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "ОприходованиеЗапасов";
	СтрокаРеквизитов =
	"ДокументОснование,
	|Комментарий,
	|Организация,
	|СтруктурнаяЕдиница,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "ОтчетКомиссионера";
	СтрокаРеквизитов =
	"Договор,
	|Комментарий,
	|Контрагент,
	|Организация,
	|Ответственный,
	|Подразделение,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "ОтчетКомитенту";
	СтрокаРеквизитов =
	"Договор,
	|Комментарий,
	|Контрагент,
	|Организация,
	|Ответственный,
	|Подразделение,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "ОтчетОПереработке";
	СтрокаРеквизитов =
	"Договор,
	|Комментарий,
	|Контрагент,
	|Организация,
	|Ответственный,
	|Подразделение,
	|СтруктурнаяЕдиница,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "ОтчетОРозничныхПродажах";
	СтрокаРеквизитов =
	"КассаККМ,
	|Комментарий,
	|Организация,
	|Ответственный,
	|Подразделение,
	|СтруктурнаяЕдиница,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "ОтчетПереработчика";
	СтрокаРеквизитов =
	"Договор,
	|ДокументОснование,
	|Комментарий,
	|Контрагент,
	|Организация,
	|Ответственный,
	|Подразделение,
	|СтруктурнаяЕдиница";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "ПеремещениеДСПлан";
	СтрокаРеквизитов =
	"БанковскийСчет,
	|Касса,
	|Комментарий,
	|Организация,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "ПеремещениеЗапасов";
	СтрокаРеквизитов =
	"ДокументОснование,
	|Комментарий,
	|Организация,
	|СтруктурнаяЕдиницаПолучатель,
	|СтруктурнаяЕдиница";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "ПересортицаЗапасов";
	СтрокаРеквизитов =
	"ДокументОснование,
	|Комментарий,
	|Организация,
	|СтруктурнаяЕдиница,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "ПлатежноеПоручение";
	СтрокаРеквизитов =
	"БанковскийСчет,
	|Договор,
	|ДокументОснование,
	|Комментарий,
	|Контрагент,
	|Организация,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "ПоступлениеВКассу";
	СтрокаРеквизитов =
	"ДокументОснование,
	|Касса,
	|Комментарий,
	|Контрагент,
	|Организация,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "ПоступлениеДСПлан";
	СтрокаРеквизитов =
	"БанковскийСчет,
	|Договор,
	|ДокументОснование,
	|Касса,
	|Комментарий,
	|Контрагент,
	|Организация,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "ПоступлениеНаСчет";
	СтрокаРеквизитов =
	"БанковскийСчет,
	|ДокументОснование,
	|Комментарий,
	|Контрагент,
	|Организация,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "ПриходнаяНакладная";
	СтрокаРеквизитов =
	"Договор,
	|ДокументОснование,
	|Комментарий,
	|Контрагент,
	|Организация,
	|Ответственный,
	|Подразделение,
	|СтруктурнаяЕдиница,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "ПриходныйОрдер";
	СтрокаРеквизитов =
	"ДокументОснование,
	|Комментарий,
	|Организация,
	|СтруктурнаяЕдиница";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "СборкаЗапасов";
	СтрокаРеквизитов =
	"ДокументОснование,
	|Комментарий,
	|Организация,
	|СтруктурнаяЕдиница";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "РаспределениеЗатрат";
	СтрокаРеквизитов =
	"Комментарий,
	|Организация,
	|СтруктурнаяЕдиница";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "РасходИзКассы";
	СтрокаРеквизитов =
	"ДокументОснование,
	|Касса,
	|Комментарий,
	|Контрагент,
	|Организация,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "РасходСоСчета";
	СтрокаРеквизитов =
	"БанковскийСчет,
	|ДокументОснование,
	|Комментарий,
	|Контрагент,
	|Организация,
	|Подразделение,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "РасходнаяНакладная";
	СтрокаРеквизитов =
	"Договор,
	|ДокументОснование,
	|Комментарий,
	|Контрагент,
	|Организация,
	|Ответственный,
	|Подразделение,
	|СтруктурнаяЕдиница,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "РасходныйОрдер";
	СтрокаРеквизитов =
	"ДокументОснование,
	|Комментарий,
	|Организация,
	|СтруктурнаяЕдиница";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "РезервированиеЗапасов";
	СтрокаРеквизитов =
	"Комментарий,
	|Организация";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "СверкаВзаиморасчетов";
	СтрокаРеквизитов =
	"Комментарий,
	|Контрагент,
	|Организация";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "СдельныйНаряд";
	СтрокаРеквизитов =
	"ДокументОснование,
	|Исполнитель,
	|Комментарий,
	|Организация,
	|СтруктурнаяЕдиница,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "Событие";
	СтрокаРеквизитов =
	"ДокументОснование,
	|Ответственный,
	|Состояние";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "СписаниеЗапасов";
	СтрокаРеквизитов =
	"ДокументОснование,
	|Комментарий,
	|Организация,
	|СтруктурнаяЕдиница";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "СчетНаОплату";
	СтрокаРеквизитов =
	"Договор,
	|ДокументОснование,
	|Комментарий,
	|Контрагент,
	|Организация,
	|Ответственный,
	|Подразделение,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "СчетНаОплатуПоставщика";
	СтрокаРеквизитов =
	"БанковскийСчет,
	|Договор,
	|ДокументОснование,
	|Касса,
	|Комментарий,
	|Контрагент,
	|Организация,
	|Ответственный,
	|Подразделение,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "СчетФактура";
	СтрокаРеквизитов =
	"Договор,
	|Комментарий,
	|Контрагент,
	|Организация,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "СчетФактураПолученный";
	СтрокаРеквизитов =
	"Договор,
	|Комментарий,
	|Контрагент,
	|Организация,
	|СуммаДокумента";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	ДокументКлюч = "КомплектацияЗапасов";
	СтрокаРеквизитов =
	"Комментарий,
	|Организация,
	|СтруктурнаяЕдиница";
	СтруктураРеквизитов.Вставить(ДокументКлюч, СтрокаРеквизитов);
	
	Возврат СтруктураРеквизитов;
	
КонецФункции

// Получить значение Текущей даты сеанса
//
Функция ПолучитьТекущуюДатаСеанса() Экспорт
	
	Возврат ТекущаяДатаСеанса();
	
КонецФункции // ПолучитьТекущуюДатаСеанса()

// Функция возвращает значение по умолчанию для передаваемого пользователя и настройки.
//
// Параметры:
//  Пользователь - текущий пользователь программы
//  Настройка    - признак, для которого возвращается значение по умолчанию
//
// Возвращаемое значение:
//  Значение по умолчанию для настройки.
//
Функция ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь, Настройка, ПустоеЗначение = Неопределено) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("Настройка"   , ПланыВидовХарактеристик.НастройкиПользователей[Настройка]);
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Значение
	|ИЗ
	|	РегистрСведений.НастройкиПользователей КАК РегистрЗначениеПрав
	|
	|ГДЕ
	|	Пользователь = &Пользователь
	| И Настройка    = &Настройка";

	Выборка = Запрос.Выполнить().Выбрать();

	Если ПустоеЗначение = Неопределено Тогда
		ПустоеЗначение = ПланыВидовХарактеристик.НастройкиПользователей[Настройка].ТипЗначения.ПривестиЗначение();
	КонецЕсли;

	Если Выборка.Количество() = 0 Тогда
		
		Возврат ПустоеЗначение;

	ИначеЕсли Выборка.Следующий() Тогда

		Если НЕ ЗначениеЗаполнено(Выборка.Значение) Тогда
			Возврат ПустоеЗначение;
		Иначе
			Возврат Выборка.Значение;
		КонецЕсли;

	Иначе
		Возврат ПустоеЗначение;

	КонецЕсли;

КонецФункции // ПолучитьЗначениеПоУмолчаниюПользователя()

// Функция возвращает значение по умолчанию для передаваемого пользователя и настройки.
//
// Параметры:
//  Настройка    - признак, для которого возвращается значение по умолчанию
//
// Возвращаемое значение:
//  Значение по умолчанию для настройки.
//
Функция ПолучитьЗначениеНастройки(Настройка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", Пользователи.АвторизованныйПользователь());
	Запрос.УстановитьПараметр("Настройка"   , ПланыВидовХарактеристик.НастройкиПользователей[Настройка]);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Значение
		|ИЗ
		|	РегистрСведений.НастройкиПользователей КАК РегистрЗначениеПрав
		|
		|ГДЕ
		|	Пользователь = &Пользователь
		| И Настройка    = &Настройка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ПустоеЗначение = ПланыВидовХарактеристик.НастройкиПользователей[Настройка].ТипЗначения.ПривестиЗначение();
	
	Если Выборка.Количество() = 0 Тогда
		
		Возврат ПустоеЗначение;
		
	ИначеЕсли Выборка.Следующий() Тогда
		
		Если НЕ ЗначениеЗаполнено(Выборка.Значение) Тогда
			Возврат ПустоеЗначение;
		Иначе
			Возврат Выборка.Значение;
		КонецЕсли;
		
	Иначе
		Возврат ПустоеЗначение;
		
	КонецЕсли;
	
КонецФункции // ПолучитьЗначениеНастройки()

// Возвращает Истина или Ложь - указанная настройка пользователя находится в шапке.
//
// Параметры:
//  Настройка    - признак, для которого возвращается значение по умолчанию
//
// Возвращаемое значение:
//  Значение по умолчанию для настройки.
//
Функция РеквизитВШапке(Настройка) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	Запрос.УстановитьПараметр("Настройка"   , ПланыВидовХарактеристик.НастройкиПользователей[Настройка]);
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Значение
	|ИЗ
	|	РегистрСведений.НастройкиПользователей КАК РегистрЗначениеПрав
	|
	|ГДЕ
	|	Пользователь = &Пользователь
	| И Настройка    = &Настройка";

	Выборка = Запрос.Выполнить().Выбрать();

	ЗначениеПоУмолчанию = Истина;

	Если Выборка.Количество() = 0 Тогда
		
		Возврат ЗначениеПоУмолчанию;

	ИначеЕсли Выборка.Следующий() Тогда

		Если НЕ ЗначениеЗаполнено(Выборка.Значение) Тогда
			Возврат ЗначениеПоУмолчанию;
		Иначе
			Возврат Выборка.Значение = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке;
		КонецЕсли;

	Иначе
		Возврат ЗначениеПоУмолчанию;

	КонецЕсли;

КонецФункции // ПолучитьЗначениеПоУмолчаниюПользователя()

// Функция возвращает признак использования торгового оборудования.
//
Функция ИспользоватьПодключаемоеОборудование() Экспорт
	
	 Возврат ПолучитьФункциональнуюОпцию("ИспользоватьПодключаемоеОборудование")
		   И ТипЗнч(Пользователи.АвторизованныйПользователь()) = Тип("СправочникСсылка.Пользователи");
	 
КонецФункции // ИспользоватьПодключаемоеОборудование()

// Функция выполняет получение параметров кассы ККМ.
//
Функция ПолучитьПараметрыКассыККМ(КассаККМ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫБОР
	|		КОГДА КассыККМ.ТипКассы = ЗНАЧЕНИЕ(Перечисление.ТипыКассККМ.ФискальныйРегистратор)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоФискальныйРегистратор,
	|	КассыККМ.Владелец КАК Организация,
	|	КассыККМ.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	КассыККМ.ПодключаемоеОборудование КАК ИдентификаторУстройства,
	|	КассыККМ.ИспользоватьБезПодключенияОборудования КАК ИспользоватьБезПодключенияОборудования,
	|	КассыККМ.ЭлектронныйЧекSMSПередаютсяПрограммой1С КАК ЭлектронныйЧекSMSПередаютсяПрограммой1С,
	|	КассыККМ.ЭлектронныйЧекEmailПередаютсяПрограммой1С КАК ЭлектронныйЧекEmailПередаютсяПрограммой1С,
	|	КассыККМ.СоздаватьВыемку КАК СоздаватьВыемку,
	|	КассыККМ.СоздаватьПоступлениеВКассу КАК СоздаватьПоступлениеВКассу,
	|	КассыККМ.КассаДляРозничнойВыручки КАК КассаДляРозничнойВыручки,
	|	КассыККМ.МинимальныйОстатокВКассеККМ КАК МинимальныйОстатокВКассеККМ
	|ИЗ
	|	Справочник.КассыККМ КАК КассыККМ
	|ГДЕ
	|	КассыККМ.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", КассаККМ);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Возврат Новый Структура(
			"ИдентификаторУстройства,
			|ИспользоватьБезПодключенияОборудования,
			|ЭтоФискальныйРегистратор,
			|Организация,
			|СтруктурнаяЕдиница,
			|ЭлектронныйЧекSMSПередаютсяПрограммой1С,
			|ЭлектронныйЧекEmailПередаютсяПрограммой1С,
			|СоздаватьВыемку,
			|СоздаватьПоступлениеВКассу,
			|КассаДляРозничнойВыручки,
			|МинимальныйОстатокВКассеККМ",
			Выборка.ИдентификаторУстройства,
			Выборка.ИспользоватьБезПодключенияОборудования,
			Выборка.ЭтоФискальныйРегистратор,
			Выборка.Организация,
			Выборка.СтруктурнаяЕдиница,
			Выборка.ЭлектронныйЧекSMSПередаютсяПрограммой1С,
			Выборка.ЭлектронныйЧекEmailПередаютсяПрограммой1С,
			Выборка.СоздаватьВыемку,
			Выборка.СоздаватьПоступлениеВКассу,
			Выборка.КассаДляРозничнойВыручки,
			Выборка.МинимальныйОстатокВКассеККМ
		);
		
	Иначе
		
		Возврат Новый Структура(
			"ИдентификаторУстройства,
			|ИспользоватьБезПодключенияОборудования,
			|ЭтоФискальныйРегистратор,
			|Организация,
			|СтруктурнаяЕдиница,
			|ЭлектронныйЧекSMSПередаютсяПрограммой1С,
			|ЭлектронныйЧекEmailПередаютсяПрограммой1С,
			|СоздаватьВыемку,
			|СоздаватьПоступлениеВКассу,
			|КассаДляРозничнойВыручки,
			|МинимальныйОстатокВКассеККМ",
			Справочники.ПодключаемоеОборудование.ПустаяСсылка(),
			Ложь,
			Ложь,
			Справочники.Организации.ПустаяСсылка(),
			Справочники.СтруктурныеЕдиницы.ПустаяСсылка(),
			Ложь,
			Ложь,
			Ложь,
			Ложь,
			Справочники.Кассы.ПустаяСсылка(),
			0
		);
		
	КонецЕсли;
	
КонецФункции // ПолучитьПараметрыКассыККМ()

// Функция выполняет получение параметров ЭТ.
//
Функция ПолучитьПараметрыЭТ(ЭквайринговыйТерминал) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЭквайринговыеТерминалы.ПодключаемоеОборудование КАК ИдентификаторУстройства,
	|	ЭквайринговыеТерминалы.ИспользоватьБезПодключенияОборудования КАК ИспользоватьБезПодключенияОборудования
	|ИЗ
	|	Справочник.ЭквайринговыеТерминалы КАК ЭквайринговыеТерминалы
	|ГДЕ
	|	ЭквайринговыеТерминалы.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ЭквайринговыйТерминал);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Возврат Новый Структура("ИдентификаторУстройства,
								|ИспользоватьБезПодключенияОборудования",
								Выборка.ИдентификаторУстройства,
								Выборка.ИспользоватьБезПодключенияОборудования
				);
		
	Иначе
		
		Возврат Новый Структура("ИдентификаторУстройства,
								|ИспользоватьБезПодключенияОборудования",
								Справочники.ПодключаемоеОборудование.ПустаяСсылка(),
								Истина
				);
		
	КонецЕсли;
	
КонецФункции

// Функция выполняет проверку необходимости контроля договоров контрагентов.
//
Функция ТребуетсяКонтрольДоговоровКонтрагентов() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если (Не РаботаВМоделиСервиса.РазделениеВключено() И Не ПолучитьФункциональнуюОпцию("ИспользоватьСинхронизациюДанных")) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ОбменСБухгалтериейНастроен();
	
КонецФункции

// Функция проверяет наличие узлов в планах обмена с Бухгалтерией предприятия.
//
Функция ОбменСБухгалтериейНастроен() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1 1
	|ИЗ
	|	ПланОбмена.ОбменУправлениеНебольшойФирмойБухгалтерия20 КАК ОбменУправлениеНебольшойФирмойБухгалтерия20
	|ГДЕ
	|	ОбменУправлениеНебольшойФирмойБухгалтерия20.Ссылка <> &ЭтотУзелБП20
	|	И ОбменУправлениеНебольшойФирмойБухгалтерия20.Код <> """"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1 1
	|ИЗ
	|	ПланОбмена.ОбменУправлениеНебольшойФирмойБухгалтерия30 КАК ОбменУправлениеНебольшойФирмойБухгалтерия30
	|ГДЕ
	|	ОбменУправлениеНебольшойФирмойБухгалтерия30.Ссылка <> &ЭтотУзелБП30
	|	И ОбменУправлениеНебольшойФирмойБухгалтерия30.Код <> """"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1 1
	|ИЗ
	|	ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат КАК СинхронизацияДанныхЧерезУниверсальныйФормат
	|ГДЕ
	|	СинхронизацияДанныхЧерезУниверсальныйФормат.Ссылка <> &ЭтотУзелУФ
	|	И СинхронизацияДанныхЧерезУниверсальныйФормат.Код <> """"";
	
	Запрос.УстановитьПараметр("ЭтотУзелБП20", ПланыОбмена.ОбменУправлениеНебольшойФирмойБухгалтерия20.ЭтотУзел());
	Запрос.УстановитьПараметр("ЭтотУзелБП30", ПланыОбмена.ОбменУправлениеНебольшойФирмойБухгалтерия30.ЭтотУзел());
	Запрос.УстановитьПараметр("ЭтотУзелУФ", ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ЭтотУзел());
	
	Результат = Запрос.Выполнить();
	Возврат Не Результат.Пустой();
	
КонецФункции

// Функция возвращает значение настройки зачета авансов.
//
// Параметры:
//  Настройка    - признак, для которого возвращается значение по умолчанию
//
// Возвращаемое значение:
//  Значение по умолчанию для настройки.
//
Функция ПолучитьЗначениеНастройкиЗачетаАвансов() Экспорт
	
	ЗачитыватьАвтоматически = ПолучитьЗначениеНастройки("ЗачитыватьАвансыДолгиАвтоматически");
	Если НЕ ЗначениеЗаполнено(ЗачитыватьАвтоматически) Тогда
		ЗачитыватьАвтоматически = Константы.ЗачитыватьАвансыДолгиАвтоматически.Получить();
	КонецЕсли;
	
	Возврат ЗачитыватьАвтоматически;
	
КонецФункции // ПолучитьЗначениеНастройки()

// Функция определяет для какого режима работы приложения должны использоваться настройки синхронизации.
//
Функция НастройкиДляСинхронизацииВМоделиСервиса() Экспорт

	Возврат ПолучитьФункциональнуюОпцию("СтандартныеПодсистемыВМоделиСервиса");

КонецФункции // СинхронизацияВМоделиСервиса()

// Возвращает признак возможности обращения к разделенным данным из текущего сеанса.
// В случае вызова в неразделенной конфигурации возвращает Истина.
//
// Возвращаемое значение:
//   Булево.
//
Функция ДоступноИспользованиеРазделенныхДанных() Экспорт
	
	Возврат НЕ ОбщегоНазначения.РазделениеВключено() ИЛИ ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных();
	
КонецФункции

// Определяет использование функционально опции УчетПоЯчейкам
// Возвращает: 
// 			Истина - если включено
// 			Ложь  - если выключено
Функция ВключеноИспользованиеЯчеек() Экспорт
	Возврат ПолучитьФункциональнуюОпцию("УчетПоЯчейкам");
КонецФункции

// Определяет текущий режим работы программы.
//
Функция РежимРаботыПрограммы() Экспорт
	
	РежимРаботы = Новый Структура;
	
	// Права текущего пользователя.
	РежимРаботы.Вставить("ЭтоАдминистраторПрограммы", Пользователи.ЭтоПолноправныйПользователь(, Ложь, Ложь));
	РежимРаботы.Вставить("ЭтоАдминистраторСистемы",   Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь));
	
	// Режимы работы сервера.
	РежимРаботы.Вставить("МодельСервиса", ОбщегоНазначения.РазделениеВключено());
	РежимРаботы.Вставить("Автономный",    ОбщегоНазначения.ЭтоАвтономноеРабочееМесто());
	РежимРаботы.Вставить("Локальный",     НЕ РежимРаботы.Автономный И НЕ РежимРаботы.МодельСервиса);
	РежимРаботы.Вставить("Файловый",        Ложь);
	РежимРаботы.Вставить("КлиентСерверный", Ложь);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		РежимРаботы.Файловый = Истина;
	Иначе
		РежимРаботы.КлиентСерверный = Истина;
	КонецЕсли;
	
	РежимРаботы.Вставить("ЛокальныйФайловый",
		РежимРаботы.Локальный И РежимРаботы.Файловый);
	РежимРаботы.Вставить("ЛокальныйКлиентСерверный",
		РежимРаботы.Локальный И РежимРаботы.КлиентСерверный);
	
	// Режимы работы клиента.
	РежимРаботы.Вставить("ЭтоWindowsКлиент",   ОбщегоНазначения.ЭтоWindowsКлиент());
	РежимРаботы.Вставить("ЭтоLinuxКлиент",     ОбщегоНазначения.ЭтоLinuxКлиент());
	РежимРаботы.Вставить("ЭтоMacOSКлиент",     ОбщегоНазначения.ЭтоMacOSКлиент());
	РежимРаботы.Вставить("ЭтоВебКлиент",       ОбщегоНазначения.ЭтоВебКлиент());
	РежимРаботы.Вставить("ЭтоМобильныйКлиент", ОбщегоНазначения.ЭтоМобильныйКлиент());
	
	Возврат РежимРаботы;
	
КонецФункции

// Возвращает организацию по умолчанию
//
Функция ОрганизацияПоУмолчанию() Экспорт
	Возврат Справочники.Организации.ОрганизацияПоУмолчанию();
КонецФункции

Функция ИспользуетсяТелефония() Экспорт
	
	Возврат ТелефонияСервер.ИспользуетсяТелефония();
	
КонецФункции

Функция ДействиеПриИсходящемЗвонке() Экспорт
	
	Возврат ТелефонияСервер.ПолучитьНастройкиТелефонии().ДействиеИсходящегоЗвонка;
	
КонецФункции

#Область СтавкиНДС

// Получить значение ставки НДС.
//
Функция ПолучитьЗначениеСтавкиНДС(СтавкаНДС) Экспорт
	
	Возврат ?(ЗначениеЗаполнено(СтавкаНДС), СтавкаНДС.Ставка, 0);
	
КонецФункции // ПолучитьЗначениеСтавкиНДС()

// Функция возвращает ставку НДС - Без НДС.
//
Функция ПолучитьСтавкуНДСБезНДС() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтавкиНДС.Ссылка КАК СтавкаНДС
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	СтавкиНДС.НеОблагается
	|	И СтавкиНДС.Ставка = 0";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.СтавкаНДС;
	КонецЕсли;
	
	ТекстБезНДС = """Без НДС""";
	ТекстНеОблагается = """Не облагается""";
	ТекстСообщения = НСтр("ru='Не найдена ставка %БезНДС%. Откройте список ставок НДС (Компания - Все справочники - Ставки НДС) и проверьте,
		|что у ставки %БезНДС% значение ставки = 0 и установлен флаг %НеОблагается%.
		|Закройте и заново запустите программу.'");
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%БезНДС%", ТекстБезНДС);
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НеОблагается%", ТекстНеОблагается);
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщения;
	Сообщение.Сообщить();
	
	Возврат Неопределено;
	
КонецФункции // ПолучитьСтавкуНДСБезНДС()

// Функция возвращает ставку НДС - Ноль.
//
Функция ПолучитьСтавкуНДСНоль() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтавкиНДС.Ссылка КАК СтавкаНДС
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	(НЕ СтавкиНДС.НеОблагается)
	|	И СтавкиНДС.Ставка = 0";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.СтавкаНДС;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции // ПолучитьСтавкуНДСНоль()

// Функция возвращает ставку НДС - Расчетная.
//
Функция ПолучитьСтавкуНДСРасчетная(СтавкаНДС) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	РасчетныеСтавкиНДС.Ссылка КАК СтавкаНДС
	|ИЗ
	|	Справочник.СтавкиНДС КАК РасчетныеСтавкиНДС
	|ГДЕ
	|	РасчетныеСтавкиНДС.Расчетная
	|	И НЕ РасчетныеСтавкиНДС.НеОблагается
	|	И РасчетныеСтавкиНДС.Ставка = &Ставка";
	
	Запрос.УстановитьПараметр("Ставка", СтавкаНДС.Ставка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.СтавкаНДС;
	КонецЕсли;
	
	Возврат СтавкаНДС;
	
КонецФункции // ПолучитьСтавкуНДСРасчетная()

// Функция возвращает ставку НДС по значению ставки (не расчетная).
//
Функция ПолучитьСтавкуНДС(ЗначениеСтавкиНДС) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтавкиНДС.Ссылка КАК СтавкаНДС
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	НЕ СтавкиНДС.Расчетная
	|	И НЕ СтавкиНДС.НеОблагается
	|	И СтавкиНДС.Ставка = &Ставка";
	
	Запрос.УстановитьПараметр("Ставка", ЗначениеСтавкиНДС);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.СтавкаНДС;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции // ПолучитьСтавкуНДСРасчетная()

Функция СоответствиеСтавокНДС(Период = Неопределено) Экспорт
	Если Период = Неопределено Тогда
		Период = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Результат = Новый Соответствие();
	Результат.Вставить(Перечисления.ВидыСтавокНДС.Общая, ОбщаяСтавкаНДС(Период));
	Результат.Вставить(Перечисления.ВидыСтавокНДС.ОбщаяРасчетная, ОбщаяСтавкаНДС(Период, Истина));
	
	МассивПеречислений = Новый Массив;
	МассивПеречислений.Добавить(Перечисления.ВидыСтавокНДС.Пониженная);
	МассивПеречислений.Добавить(Перечисления.ВидыСтавокНДС.ПониженнаяРасчетная);
	МассивПеречислений.Добавить(Перечисления.ВидыСтавокНДС.Пониженная2);
	МассивПеречислений.Добавить(Перечисления.ВидыСтавокНДС.ПониженнаяРасчетная2);
	МассивПеречислений.Добавить(Перечисления.ВидыСтавокНДС.Нулевая);
	МассивПеречислений.Добавить(Перечисления.ВидыСтавокНДС.БезНДС);
	
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СтавкиНДС.Ссылка КАК Ставка,
	|	СтавкиНДС.ВидСтавкиНДС
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	СтавкиНДС.ВидСтавкиНДС В (&ВидСтавкиНДС);";
	Запрос.УстановитьПараметр("ВидСтавкиНДС", МассивПеречислений);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Результат.Вставить(Выборка.ВидСтавкиНДС,Выборка.Ставка);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ОбщаяСтавкаНДС(Знач Период, Расчетная = Ложь)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтавкиНДС.Ссылка КАК Ссылка,
	|	1 КАК Приоритет
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	СтавкиНДС.ВидСтавкиНДС = ЗНАЧЕНИЕ(Перечисление.ВидыСтавокНДС.Общая)
	|	И СтавкиНДС.Ставка = &ЗначениеСтавки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтавкиНДС.Ссылка,
	|	2
	|ИЗ
	|	Справочник.СтавкиНДС КАК СтавкиНДС
	|ГДЕ
	|	СтавкиНДС.ВидСтавкиНДС = ЗНАЧЕНИЕ(Перечисление.ВидыСтавокНДС.Общая)
	|	И СтавкиНДС.Ставка <> &ЗначениеСтавки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет";
	Если Период >= Дата('20190101') Тогда
		Запрос.УстановитьПараметр("ЗначениеСтавки", 20);
	Иначе
		Запрос.УстановитьПараметр("ЗначениеСтавки", 18);
	КонецЕсли;
	Если Расчетная Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, ".Общая", ".ОбщаяРасчетная");
	КонецЕсли;
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.СтавкиНДС.ПустаяСсылка();
	КонецЕсли;
КонецФункции

// Получить значение ставки НДС.
//
Функция ПолучитьЗначениеСтавкиНДСДляККТ(СтавкаНДС, ЭтоАванс = Ложь) Экспорт
	
	Если ЗначениеЗаполнено(СтавкаНДС) И Не СтавкаНДС.НеОблагается Тогда
		
		Если ЭтоАванс Тогда
			Если СтавкаНДС.Ставка = 10 Тогда
				Возврат 110;
			ИначеЕсли СтавкаНДС.Ставка = 18 Тогда
				Возврат 118;
			ИначеЕсли СтавкаНДС.Ставка = 20 Тогда
				Возврат 120;
			КонецЕсли;
		Иначе
			Возврат СтавкаНДС.Ставка;
		КонецЕсли;
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции // ПолучитьЗначениеСтавкиНДС()

#КонецОбласти

#Область Константы

// Функция возвращает национальную валюту
//
Функция ПолучитьНациональнуюВалюту() Экспорт
	
	Возврат Константы.НациональнаяВалюта.Получить();
	
КонецФункции // ПолучитьНациональнуюВалюту()

// Функция возвращает валюту учета
//
Функция ПолучитьВалютуУчета() Экспорт
	
	Возврат Константы.ВалютаУчета.Получить();
	
КонецФункции // ПолучитьВалютуУчета()

// Функция символьное представление валюты
//
Функция ПолучитьСимвольноеПредставлениеВалюты(Валюта) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Валюта) ИЛИ ТипЗнч(Валюта)<>Тип("СправочникСсылка.Валюты") Тогда
		Возврат "";
	КонецЕсли; 
	
	Возврат Валюта.СимвольноеПредставление;
	
КонецФункции // ПолучитьВалютуУчета()

// Получение значения константы.
//
Функция ПолучитьЗначениеКонстанты(ИмяКонстанты) Экспорт

	Возврат Константы[ИмяКонстанты].Получить();

КонецФункции

#КонецОбласти

#КонецОбласти
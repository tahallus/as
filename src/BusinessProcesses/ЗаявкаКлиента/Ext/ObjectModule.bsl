﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступом.ЗаполнитьНаборыЗначенийДоступа.
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	Партнер = Неопределено;
	
	Если ЗначениеЗаполнено(Предмет) Тогда
		Партнер = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Предмет, "Партнер");
	КонецЕсли;
	
	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.НомерНабора = 1;
	СтрокаТаб.ЗначениеДоступа = Партнер;
	
	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.НомерНабора = 2;
	СтрокаТаб.ЗначениеДоступа = Автор;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура СтартПередСтартом(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	ДатаНачала = ТекущаяДатаСеанса();

КонецПроцедуры

Процедура ЗавершениеПриЗавершении(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	ДатаЗавершения = ТекущаяДатаСеанса();
	
КонецПроцедуры

Процедура ЭтоСпецПроектПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = Предмет.СпецПроект;
	
КонецПроцедуры


Процедура ПодготовкаМедиапланаПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	Задача = СоздатьЗадачу(ТочкаМаршрутаБизнесПроцесса);
	ФормируемыеЗадачи.Добавить(Задача);
	
КонецПроцедуры

Процедура ПодготовкаМедиапланаПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура ПодготовкаМедиапланаПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
	ТекстЗапроса =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	_Медиаплан.Ссылка КАК Ссылка
		|ИЗ
		|	Документ._Медиаплан КАК _Медиаплан
		|ГДЕ
		|	_Медиаплан.ДокументОснование = &ОтборСсылка
		|	И _Медиаплан.Проведен = ИСТИНА";
	ТекстСообщения =
	НСтр("ru='Задача не может считаться выполненной, так как нет медиаплана.'");
	Если НЕ ДокументСоздан(ТекстЗапроса, Предмет, ТекстСообщения) Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры


Процедура ПодготовкаСметыПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Задача = СоздатьЗадачу(ТочкаМаршрутаБизнесПроцесса);
	ФормируемыеЗадачи.Добавить(Задача);
	
КонецПроцедуры

Процедура ПодготовкаСметыПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура ПодготовкаСметыПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
	ТекстЗапроса =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	_Медиаплан.Ссылка КАК Ссылка
		|ИЗ
		|	Документ._Смета КАК _Медиаплан
		|ГДЕ
		|	_Медиаплан.ДокументОснование = &ОтборСсылка
		|	И _Медиаплан.Проведен = ИСТИНА";
	ТекстСообщения =
	НСтр("ru='Задача не может считаться выполненной, так как нет сметы.'");
	Если НЕ ДокументСоздан(ТекстЗапроса, Предмет, ТекстСообщения) Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры


Процедура БронированиеМедиапланаПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Задача = СоздатьЗадачу(ТочкаМаршрутаБизнесПроцесса);
	ФормируемыеЗадачи.Добавить(Задача);
	
КонецПроцедуры

Процедура БронированиеМедиапланаПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура БронированиеМедиапланаПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
	ТекстЗапроса =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	_Медиаплан.Ссылка КАК Ссылка
		|ИЗ
		|	Документ._Медиаплан КАК _Медиаплан
		|ГДЕ
		|	_Медиаплан.ДокументОснование = &ОтборСсылка
		|	И _Медиаплан.Статус = ЗНАЧЕНИЕ(Перечисление._СтатусыМедиаПланов.Бронь)
		|	И _Медиаплан.Проведен = ИСТИНА";
	ТекстСообщения =
	НСтр("ru='Задача не может считаться выполненной, так как медиаплана не в статусе ""Бронь"".'");
	Если НЕ ДокументСоздан(ТекстЗапроса, Предмет, ТекстСообщения) Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры


Процедура ФормированиеЗаказаПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Задача = СоздатьЗадачу(ТочкаМаршрутаБизнесПроцесса);
	ФормируемыеЗадачи.Добавить(Задача);
	
КонецПроцедуры

Процедура ФормированиеЗаказаПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура ФормированиеЗаказаПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
	ТекстЗапроса =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЗаказПокупателя.Ссылка
		|ИЗ
		|	Документ.ЗаказПокупателя КАК ЗаказПокупателя
		|ГДЕ
		|	ЗаказПокупателя.Проведен
		|	И ЗаказПокупателя._Заявка = &ОтборСсылка";
	ТекстСообщения =
		НСтр("ru='Задача не может считаться выполненной, так как нет заказа покупателя.'");
	Результат = ДокументСоздан(ТекстЗапроса, Предмет, ТекстСообщения);
	
	Отказ = НЕ Результат;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////


Процедура ПервичныйКонтактПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)

	СделкиСервер.УстановитьЭтапПроцесса(Предмет, Справочники.СостоянияПроцессов.ПервичныйКонтакт);

КонецПроцедуры

Процедура КвалификацияКлиентаПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)

	СделкиСервер.УстановитьЭтапПроцесса(Предмет, Справочники.СостоянияПроцессов.КвалификацияКлиента);

КонецПроцедуры

Процедура ПодготовкаПредложенияПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)

	СделкиСервер.УстановитьЭтапПроцесса(Предмет, Справочники.СостоянияПроцессов.ФормированиеПредложения);

КонецПроцедуры

Процедура ПрезентацияПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)

	СделкиСервер.УстановитьЭтапПроцесса(Предмет, Справочники.СостоянияПроцессов.Презентация);

КонецПроцедуры

Процедура ТоргПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)

	СделкиСервер.УстановитьЭтапПроцесса(Предмет, Справочники.СостоянияПроцессов.СогласованиеУсловий);

КонецПроцедуры

Процедура ПодтверждениеОбязательствПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)

	СделкиСервер.УстановитьЭтапПроцесса(Предмет, Справочники.СостоянияПроцессов.ПодготовкаКВыполнениюОбязательств);

КонецПроцедуры

Процедура КонтрольВыполненияОбязательствПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)

	СделкиСервер.УстановитьЭтапПроцесса(Предмет, Справочники.СостоянияПроцессов.ВыполнениеОбязательств);

КонецПроцедуры

Процедура ФиксацияРезультатовСделкиПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
	Если Предмет.Статус = Перечисления.СтатусыСделок.Проиграна Тогда
		Результат = ЗначениеЗаполнено(Предмет.ПричинаПроигрышаСделки);
		Если НЕ Результат Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Для выполнения задачи необходимо определить причину проигрыша сделки'"));
		КонецЕсли;
	ИначеЕсли Предмет.Статус = Перечисления.СтатусыСделок.ВРаботе Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Для выполнения задачи сделка должна находится в статусе выиграна или проиграна.'"));
		Результат = Ложь;
	Иначе
		Результат = Истина;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Результат Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		|	СделкиСКлиентамиПервичныйСпрос.НомерСтроки КАК НомерСтроки
		|ИЗ
		|	Справочник.СделкиСКлиентами.ПервичныйСпрос КАК СделкиСКлиентамиПервичныйСпрос
		|ГДЕ
		|	СделкиСКлиентамиПервичныйСпрос.Ссылка = &Предмет
		|	И СделкиСКлиентамиПервичныйСпрос.ПроцентУдовлетворения <> 100
		|	И СделкиСКлиентамиПервичныйСпрос.ПричинаНеудовлетворения = ЗНАЧЕНИЕ(Справочник.ПричиныНеудовлетворенияПервичногоСпроса.ПустаяСсылка)";
		
		Запрос.УстановитьПараметр("Предмет",Предмет);
		
		Если НЕ Запрос.Выполнить().Пустой() Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Для выполнения задачи необходимо корректно заполнить результаты удовлетворения первичного спроса.'"));
			Результат = Ложь;
		Иначе
			Результат = Истина;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Результат Тогда
		ЗакрытьСделку(Отказ);
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПервичныйКонтактПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПочтовыйКлиент") Тогда
		ТекстЗапроса =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Взаимодействия.Ссылка
		|ИЗ
		|	ЖурналДокументов.Взаимодействия КАК Взаимодействия
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
		|		ПО Взаимодействия.Ссылка = ПредметыПапкиВзаимодействий.Взаимодействие
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(Взаимодействия.Ссылка) <> ТИП(Документ.ЗапланированноеВзаимодействие)
		|	И (НЕ Взаимодействия.ПометкаУдаления)
		|	И ПредметыПапкиВзаимодействий.Предмет = &ОтборСсылка";
		ТекстСообщения =
		НСтр("ru='Задача не может считаться выполненной, так как нет зарегистрированных взаимодействий.'");
		Если НЕ ДокументСоздан(ТекстЗапроса, Предмет, ТекстСообщения) Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура КвалификацияКлиентаПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
	Если ЗначениеЗаполнено(Предмет.СоглашениеСКлиентом) Тогда
		Результат = Истина;
	Иначе
		Результат = Ложь;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр(
				"ru='Задача не может считаться выполненной, так как не определено соглашение с клиентом.'"));
	КонецЕсли;
	
	Отказ = Отказ ИЛИ НЕ Результат;

КонецПроцедуры

Процедура ПодготовкаПредложенияПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
	ТекстЗапроса =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	КоммерческоеПредложениеКлиенту.Ссылка
		|ИЗ
		|	Документ.КоммерческоеПредложениеКлиенту КАК КоммерческоеПредложениеКлиенту
		|ГДЕ
		|	КоммерческоеПредложениеКлиенту.Сделка = &ОтборСсылка
		|	И КоммерческоеПредложениеКлиенту.Проведен
		|	И КоммерческоеПредложениеКлиенту.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыКоммерческихПредложенийКлиентам.Действует)
		|	И (КоммерческоеПредложениеКлиенту.СрокДействия = ДАТАВРЕМЯ(1, 1, 1)
		|			ИЛИ КоммерческоеПредложениеКлиенту.СрокДействия >= &ТекущаяДата)";
		
	ТекстСообщения =
		НСтр("ru='Задача не может считаться выполненной, так как нет действующего коммерческого предложения по сделке.'");
		
	Результат = ДокументСоздан(ТекстЗапроса, Предмет, ТекстСообщения);

	Отказ = Отказ ИЛИ НЕ Результат;
	
КонецПроцедуры


Процедура ПодтверждениеОбязательствПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Истина;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЗаказКлиента.Ссылка
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Проведен
		|	И ЗаказКлиента.Сделка = &ОтборСсылка
		|	И ЗаказКлиента.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоДоговорамКонтрагентов)");
	Запрос.УстановитьПараметр("ОтборСсылка", Предмет);
	РезультатЗапроса = Запрос.Выполнить();
	НетРасчетовПоДоговорам = РезультатЗапроса.Пустой();
	
	Если НетРасчетовПоДоговорам Тогда
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	ЕСТЬNULL(РасчетыСКлиентамиОбороты.СуммаПриход, 0) + ЕСТЬNULL(РасчетыСКлиентамиОбороты.СуммаРасход, 0) + ЕСТЬNULL(РасчетыСКлиентамиОбороты.КОтгрузкеПриход, 0) КАК Обязательства
			|ИЗ
			|	РегистрНакопления.РасчетыСКлиентами.Обороты(, , , ЗаказКлиента.Сделка = &ОтборСсылка) КАК РасчетыСКлиентамиОбороты");
		Запрос.УстановитьПараметр("ОтборСсылка", Предмет);
		Выборка = Запрос.Выполнить().Выбрать();
		Результат = Выборка.Следующий() И Выборка.Обязательства > 0;
		
	КонецЕсли;

	Если Не Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр(
				"ru='Задача не может считаться выполненной, так как нет открытых обязательств по сделке.'"));
	КонецЕсли;

	Отказ = Отказ ИЛИ НЕ Результат;
	
КонецПроцедуры

Процедура КонтрольВыполненияОбязательствПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Истина;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЗаказКлиента.Ссылка
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Проведен
		|	И ЗаказКлиента.Сделка = &ОтборСсылка
		|	И ЗаказКлиента.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоДоговорамКонтрагентов)");
	Запрос.УстановитьПараметр("ОтборСсылка", Предмет);
	РезультатЗапроса = Запрос.Выполнить();
	НетРасчетовПоДоговорам = РезультатЗапроса.Пустой();
	
	Если НетРасчетовПоДоговорам Тогда
		
		// проверить остатки по платежам
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	ЕСТЬNULL(РасчетыСКлиентамиОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
			|	ЕСТЬNULL(РасчетыСКлиентамиОстатки.КОплатеОстаток, 0) КАК КОплатеОстаток
			|ИЗ
			|	РегистрНакопления.РасчетыСКлиентами.Остатки(
			|			,
			|			ЗаказКлиента.Сделка = &Сделка) КАК РасчетыСКлиентамиОстатки");
		Запрос.УстановитьПараметр("Сделка", Предмет);
		ПлатежиОстатки = Запрос.Выполнить().Выбрать();
		ПлатежиОстатки.Следующий();
		Результат = ПлатежиОстатки.СуммаОстаток = 0 И ПлатежиОстатки.КОплатеОстаток = 0;

		// проверить остатки по отгрузкам
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	ЕСТЬNULL(ЗаказыКлиентовОстатки.ЗаказаноОстаток, 0) + ЕСТЬNULL(ЗаказыКлиентовОстатки.КОформлениюОстаток, 0) КАК КоличествоОстаток
			|ИЗ
			|	РегистрНакопления.ЗаказыКлиентов.Остатки(, ЗаказКлиента.Сделка = &Сделка) КАК ЗаказыКлиентовОстатки");
		Запрос.УстановитьПараметр("Сделка", Предмет);
		ОтгрузкиОстатки = Запрос.Выполнить().Выбрать();
		ОтгрузкиОстатки.Следующий();
		Результат = Результат И ОтгрузкиОстатки.КоличествоОстаток = 0;
		
	КонецЕсли;

	Если НЕ Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		НСтр("ru='Задача не может быть выполнена, так как есть не выполненные обязательства по сделке'"));
	КонецЕсли;
	
	Отказ = Отказ ИЛИ НЕ Результат;
	
КонецПроцедуры

Процедура СделкаПроигранаПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = (Предмет.Статус = Перечисления.СтатусыСделок.Проиграна);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьЗадачуПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи)

	СделкиСервер.ЗаполнитьРеквизитыЗадачПроцесса(
		Предмет, БизнесПроцессы.ЗаявкаКлиента,
		ТочкаМаршрутаБизнесПроцесса,
		ФормируемыеЗадачи);

КонецПроцедуры

Функция ДокументСоздан(ТекстЗапроса, Отбор, ТекстСообщенияОшибки)

	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ОтборСсылка", Отбор);
	Запрос.УстановитьПараметр("ТекущаяДата",НачалоДня(ТекущаяДатаСеанса()));
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщенияОшибки);
		Возврат Ложь;
	КонецЕсли;

	Возврат Истина;

КонецФункции

Процедура ЗакрытьСделку(Отказ = Ложь)

	Попытка
		ЗаблокироватьДанныеДляРедактирования(Предмет);
	Исключение
		
		ТекстСообщения = НСтр("ru='Не удалось заблокировать %Сделка%.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Сделка%", Предмет);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
		
		Возврат;
		
	КонецПопытки;
	
	Попытка
		СделкаОбъект               = Предмет.ПолучитьОбъект();
		СделкаОбъект.Закрыта       = Истина;
		СделкаОбъект.ДатаОкончания = ТекущаяДатаСеанса();
		СделкаОбъект.Записать();
		
		ТекущийЭтап = СделкиСервер.ПолучитьТекущийЭтап(Предмет);
		Если  ТекущийЭтап <> Справочники.СостоянияПроцессов.ПустаяСсылка() Тогда
				СделкиСервер.ЗакрытьСтатистику(Предмет, ТекущийЭтап);
		КонецЕсли;

	Исключение
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;

КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция СоздатьЗадачу(Знач ТочкаМаршрутаБизнесПроцесса)
	
	Задача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
	
	Задача.Дата                          = ТекущаяДатаСеанса();
	Задача.Автор                         = Автор;
	Задача.Наименование                  = ТочкаМаршрутаБизнесПроцесса.НаименованиеЗадачи;
	Задача.Описание                      = Наименование;
	Задача.Предмет                       = Предмет;
	//Задача.Важность                      = Важность;
	Задача.РольИсполнителя               = ТочкаМаршрутаБизнесПроцесса.РольИсполнителя;
	Задача.ОсновнойОбъектАдресации       = ТочкаМаршрутаБизнесПроцесса.ОсновнойОбъектАдресации;
	Задача.ДополнительныйОбъектАдресации = ТочкаМаршрутаБизнесПроцесса.ДополнительныйОбъектАдресации;
	Задача.БизнесПроцесс                 = Ссылка;
	//Задача.СрокИсполнения                = ДатаСогласования;
	Задача.ТочкаМаршрута                 = ТочкаМаршрутаБизнесПроцесса;
	
	Возврат Задача;

КонецФункции



#КонецОбласти

#КонецЕсли

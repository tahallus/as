﻿#Область СлужебныйПрограммныйИнтерфейс

#Область ДлительныеОперации

// Выполняет выгрузку данных.
// Параметры:
//   СтруктураПараметров - Структура - параметры выполнения процедуры:
// 
Процедура РезультатВыгрузкиВXML(СтруктураПараметров, АдресРезультата) Экспорт
	
	РезультатВыгрузки = ВыгрузитьДанныеВXML(СтруктураПараметров);
	
	Если РезультатВыгрузки.ЕстьОшибки Тогда
		ТекстСообщения = НСтр("ru = 'В ходе выполнения операции возникли ошибки'") + ": "
			+ Символы.ПС + РезультатВыгрузки.ТекстОшибки
			+ Символы.ПС + НСтр("ru = 'Данные могут быть выгружены не полностью.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	ИначеЕсли Не РезультатВыгрузки.ЕстьВыгруженныеОбъекты Тогда
		ТекстСообщения = НСтр("ru = 'Не найдено ни одного объекта к выгрузке.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
	// в файл
	ТХ = Новый ТекстовыйДокумент;
	ТХ.УстановитьТекст(РезультатВыгрузки.ТекстВыгрузки);
	АдресНаСервере = ПолучитьИмяВременногоФайла("xml");
	ТХ.Записать(АдресНаСервере);
	
	ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(АдресНаСервере), АдресРезультата);
	УдалитьФайлы(АдресНаСервере);
	
КонецПроцедуры

// Выполняет загрузку сообщения.
// Параметры:
//   СтруктураПараметров - Структура:
//    * ТекстXML - Строка - сообщение которое следует загрузить (в случае загрузки из текста).
//    * АдресНаСервере - Строка - имя временного файла с данными для загрузки (при загрузке из файла)
//   АдресРезультата - Строка - адрес для размещения результата, при запуске из фонового задания.
//
Процедура ЗагрузкаСообщения(СтруктураПараметров, АдресРезультата) Экспорт
	
	АдресФайлаЗагрузки = СтруктураПараметров.АдресФайлаЗагрузки;
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайлаЗагрузки); // ДвоичныеДанные
	АдресНаСервере = ПолучитьИмяВременногоФайла("xml");
	ДвоичныеДанные.Записать(АдресНаСервере);
	УдалитьИзВременногоХранилища(АдресФайлаЗагрузки);

	ЧтениеXML = Новый ЧтениеXML;
	
	ЧтениеXML.ОткрытьФайл(АдресНаСервере);
	
	РезультатЗагрузки = ЗагрузитьДанныеИзXML(ЧтениеXML);
	
	ЧтениеXML.Закрыть();
	
	Если ЗначениеЗаполнено(АдресНаСервере) Тогда
		УдалитьФайлы(АдресНаСервере);
	КонецЕсли;
	
	Если РезультатЗагрузки.ЕстьОшибки Тогда
		ВызватьИсключение РезультатЗагрузки.ТекстОшибки;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

// Выгружает объекты и возвращает результат выгрузки.
// 
// Возвращаемое значение:
//   Структура - структура с результатом выгрузки:
//     * ТекстВыгрузки - Строка - текст сообщения обмена.
//     * ЕстьВыгруженныеОбъекты - Булево - Истина, если выгружен хотя бы один объект.
//     * ЕстьОшибки - Булево - Истина, если при выгрузке произошли ошибки.
//     * ТекстОшибки - Строка - текст ошибки при выгрузке.
//     * ВыгруженныеОбъекты - Массив - массив выгруженных объектов по настройкам обработки.
//     * ВыгруженныеПоСсылкеОбъекты - Массив - массив выгруженных объектов по ссылкам.
//
Функция ВыгрузитьДанныеВXML(СтруктураПараметров)
	
	Параметры = СтруктураПараметров.ДанныеВыгрузки.Параметры;
	КомпонентыОбмена = КомпонентыОбмена("Отправка", СтруктураПараметров.ВерсияФормата, СтруктураПараметров.РасширениеФормата);
	
	КомпонентыОбмена.ПараметрыКонвертации.Вставить("ЭкземплярОборудования", Параметры.Идентификатор); 
	
	ЗаполнитьСписокОбъектовКВыгрузке(КомпонентыОбмена, СтруктураПараметров);
	
	ОбъектыКВыгрузке = СтруктураПараметров.ОбъектыКВыгрузке;
	ИсходныеДанные = СтруктураПараметров.ДанныеВыгрузки;

	РезультатВыгрузки = Новый Структура;

	// Открываем файл обмена.
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
		МодульОбменДаннымиXDTOСервер = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиXDTOСервер");

		МодульОбменДаннымиXDTOСервер.ОткрытьФайлВыгрузки(КомпонентыОбмена);
	
		ЕстьВыгруженныеОбъекты      = Ложь;
		ЕстьОшибкиПередКонвертацией = Ложь;
		
		УстановитьПривилегированныйРежим(Истина);
		
		ЗаписатьВФайлПризнакОбработан(КомпонентыОбмена); // Признак записывается с пустой датой.

		Попытка
			КомпонентыОбмена.МенеджерОбмена.ПередКонвертацией(КомпонентыОбмена);
		Исключение
			ЕстьОшибкиПередКонвертацией = Истина;
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Событие: %1.
					|Обработчик: ПередКонвертацией.
					|
					|Ошибка выполнения обработчика.
					|%2.'"),
				КомпонентыОбмена.НаправлениеОбмена,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			МодульОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, ТекстОшибки);
		КонецПопытки;
		
		Если ОбъектыКВыгрузке.Количество() > 0 Тогда
			Для Каждого СсылкаВыгрузки Из ОбъектыКВыгрузке Цикл
				Если ТипЗнч(СсылкаВыгрузки) <> Тип("Структура") Тогда
					МетаданныеСсылкиВыгрузки = СсылкаВыгрузки.Метаданные();
					ПравилоОбработки = КомпонентыОбмена.ПравилаОбработкиДанных.Найти(МетаданныеСсылкиВыгрузки, "ОбъектВыборкиМетаданные");
					Если ПравилоОбработки = Неопределено Тогда
						Продолжить;
					КонецЕсли;
					МодульОбменДаннымиXDTOСервер.ВыгрузкаОбъектаВыборки(КомпонентыОбмена, СсылкаВыгрузки, ПравилоОбработки);
					ЕстьВыгруженныеОбъекты = Истина;
				Иначе
					
					Если СсылкаВыгрузки.Свойство("Товар") Тогда
			
						// "Справочник.Номенклатура" - - Имя соответствует имени объекта XDTO пакета Cashbox_1_8_6
						ПКОНоменклатуры = КомпонентыОбмена.ПравилаКонвертацииОбъектов.Найти("Справочник.Номенклатура", "ОбъектФормата");
						ПравилоНоменклатуры = НайтиПравилаОбработкиДанныхПоПКО(КомпонентыОбмена, ПКОНоменклатуры.ИмяПКО);
						Если ПравилоНоменклатуры = Неопределено Тогда
							Продолжить;
						КонецЕсли;
						МодульОбменДаннымиXDTOСервер.ВыгрузкаОбъектаВыборки(КомпонентыОбмена, СсылкаВыгрузки, ПравилоНоменклатуры);
						КомпонентыОбмена.СчетчикВыгруженныхОбъектов = КомпонентыОбмена.СчетчикВыгруженныхОбъектов + 1;
					КонецЕсли;

					Если СсылкаВыгрузки.Свойство("Штрихкод") Тогда
			
						// "Справочник.ШтрихкодыНоменклатуры" - - Имя соответствует имени объекта XDTO пакета Cashbox_1_8_6
						ПКОШтрихкоды = КомпонентыОбмена.ПравилаКонвертацииОбъектов.Найти("Справочник.ШтрихкодыНоменклатуры", "ОбъектФормата");
						ПравилоШтрихкодыТоваров = НайтиПравилаОбработкиДанныхПоПКО(КомпонентыОбмена, ПКОШтрихкоды.ИмяПКО);
						Если ПравилоШтрихкодыТоваров = Неопределено Тогда
							Продолжить;
						КонецЕсли;
						МодульОбменДаннымиXDTOСервер.ВыгрузкаОбъектаВыборки(КомпонентыОбмена, СсылкаВыгрузки, ПравилоШтрихкодыТоваров);
						КомпонентыОбмена.СчетчикВыгруженныхОбъектов = КомпонентыОбмена.СчетчикВыгруженныхОбъектов + 1;
					КонецЕсли;
					
					Если СсылкаВыгрузки.Свойство("Упаковка") Тогда
			
						// "Справочник.Упаковки" - - Имя соответствует имени объекта XDTO пакета Cashbox_1_8_6
						ПКОУпаковки = КомпонентыОбмена.ПравилаКонвертацииОбъектов.Найти("Справочник.Упаковки", "ОбъектФормата");
						ПравилоУпаковки = НайтиПравилаОбработкиДанныхПоПКО(КомпонентыОбмена, ПКОУпаковки.ИмяПКО);
						Если ПравилоУпаковки = Неопределено Тогда
							Продолжить;
						КонецЕсли;
						МодульОбменДаннымиXDTOСервер.ВыгрузкаОбъектаВыборки(КомпонентыОбмена, СсылкаВыгрузки, ПравилоУпаковки);
						КомпонентыОбмена.СчетчикВыгруженныхОбъектов = КомпонентыОбмена.СчетчикВыгруженныхОбъектов + 1;
					КонецЕсли;
					
				КонецЕсли;
			КонецЦикла;
			
			Если ИсходныеДанные.Свойство("ПрайсЛист")
				И ИсходныеДанные.ПрайсЛист.Товары.Количество() > 0 Тогда
				
				СправочникПрайсЛист = Новый Массив;
				
				ПолучитьПрайсЛист(КомпонентыОбмена, ОбъектыКВыгрузке, ИсходныеДанные, СправочникПрайсЛист);
				
				// "Справочник.ПрайсЛист" - - Имя соответствует имени объекта XDTO пакета Cashbox_1_8_6
				ПКОПрайсЛист = КомпонентыОбмена.ПравилаКонвертацииОбъектов.Найти("Справочник.ПрайсЛист", "ОбъектФормата");
				ПравилоПрайсЛист = НайтиПравилаОбработкиДанныхПоПКО(КомпонентыОбмена, ПКОПрайсЛист.ИмяПКО);

				Если ПравилоПрайсЛист <> Неопределено
					И СправочникПрайсЛист.Количество() > 0 Тогда
					Для каждого ОбъектВыборкиСтруктура Из СправочникПрайсЛист Цикл
						МодульОбменДаннымиXDTOСервер.ВыгрузкаОбъектаВыборки(КомпонентыОбмена, ОбъектВыборкиСтруктура, ПравилоПрайсЛист);
						КомпонентыОбмена.СчетчикВыгруженныхОбъектов = КомпонентыОбмена.СчетчикВыгруженныхОбъектов + 1;
						
						ПозицииПрайсЛиста = Новый Массив;
						ИсходныеДанные.Вставить("СправочникПрайсЛист", ОбъектВыборкиСтруктура);
						
						ПолучитьПозициюПрайсЛиста(КомпонентыОбмена, ОбъектыКВыгрузке, ИсходныеДанные, ПозицииПрайсЛиста);
						
						// "Справочник.ПозицияПрайсЛиста" - - Имя соответствует имени объекта XDTO пакета Cashbox_1_8_6
						ПКОПозицияПрайсЛиста = КомпонентыОбмена.ПравилаКонвертацииОбъектов.Найти("Справочник.ПозицияПрайсЛиста", "ОбъектФормата");
						ПравилоПозицияПрайсЛиста = НайтиПравилаОбработкиДанныхПоПКО(КомпонентыОбмена, ПКОПозицияПрайсЛиста.ИмяПКО);

						Если ПравилоПозицияПрайсЛиста <> Неопределено
							И ПозицииПрайсЛиста.Количество() > 0 Тогда
							Для каждого ОбъектВыборкиСтруктура Из ПозицииПрайсЛиста Цикл
								МодульОбменДаннымиXDTOСервер.ВыгрузкаОбъектаВыборки(КомпонентыОбмена, ОбъектВыборкиСтруктура, ПравилоПозицияПрайсЛиста);
								КомпонентыОбмена.СчетчикВыгруженныхОбъектов = КомпонентыОбмена.СчетчикВыгруженныхОбъектов + 1;
							КонецЦикла;
						КонецЕсли;	
					КонецЦикла;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если Не ЕстьОшибкиПередКонвертацией Тогда
			Попытка
				КомпонентыОбмена.МенеджерОбмена.ПослеКонвертации(КомпонентыОбмена);
			Исключение
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Событие: %1.
						|Обработчик: ПослеКонвертации.
						|
						|Ошибка выполнения обработчика.
						|%2.'"),
					КомпонентыОбмена.НаправлениеОбмена,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				МодульОбменДаннымиXDTOСервер.ЗаписатьВПротоколВыполнения(КомпонентыОбмена, ТекстОшибки);
			КонецПопытки;
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Ложь);
		
		КомпонентыОбмена.ФайлОбмена.ЗаписатьКонецЭлемента(); // Body
		КомпонентыОбмена.ФайлОбмена.ЗаписатьКонецЭлемента(); // Message
		
		ТекстВыгрузки = КомпонентыОбмена.ФайлОбмена.Закрыть();
		
		РезультатВыгрузки.Вставить("ТекстВыгрузки",              ТекстВыгрузки);
		РезультатВыгрузки.Вставить("ЕстьВыгруженныеОбъекты",     ЕстьВыгруженныеОбъекты);
		РезультатВыгрузки.Вставить("ЕстьОшибки",                 КомпонентыОбмена.ФлагОшибки);
		РезультатВыгрузки.Вставить("ТекстОшибки",                КомпонентыОбмена.СтрокаСообщенияОбОшибке);
		РезультатВыгрузки.Вставить("ВыгруженныеОбъекты",         КомпонентыОбмена.ВыгруженныеОбъекты);
		РезультатВыгрузки.Вставить("ВыгруженныеПоСсылкеОбъекты", КомпонентыОбмена.ВыгруженныеПоСсылкеОбъекты);
	КонецЕсли;
	
	Возврат РезультатВыгрузки;
	
КонецФункции

// Выполняет подготовку структуры КомпонентыОбмена.
// Параметры:
//   НаправлениеОбмена - Строка - отправка или Получение.
//   ВерсияФорматаОбменаПриЗагрузке - Строка - версия формата, которая должна применяться при загрузке данных.
//
// Возвращаемое значение:
//   Структура - компоненты обмена.
//
Функция КомпонентыОбмена(НаправлениеОбмена, ВерсияФормата = "", РасширениеФормата = "", ВерсияФорматаОбменаПриЗагрузке = "", РасширениеФорматаПриЗагрузке = "") 
	
	КомпонентыОбмена = Новый Структура;

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
		МодульОбменДаннымиXDTOСервер = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиXDTOСервер");

		КомпонентыОбмена     = МодульОбменДаннымиXDTOСервер.ИнициализироватьКомпонентыОбмена(НаправлениеОбмена);
		ТекВерсияФормата     = ?(НаправлениеОбмена = "Отправка", ВерсияФормата, ВерсияФорматаОбменаПриЗагрузке);
		ТекРасширениеФормата = ?(НаправлениеОбмена = "Отправка", РасширениеФормата, РасширениеФорматаПриЗагрузке);
		
		КомпонентыОбмена.ЭтоОбменЧерезПланОбмена = Ложь;
		КомпонентыОбмена.КлючСообщенияЖурналаРегистрации = НСтр("ru = 'Обмен ККМ офлайн'", ОбщегоНазначения.КодОсновногоЯзыка());
		КомпонентыОбмена.ВерсияФорматаОбмена = ТекВерсияФормата;
		КомпонентыОбмена.XMLСхема = "http://v8.1c.ru/edi/edi_stnd/EnterpriseData/" + ТекВерсияФормата;
		ВключитьПространствоИмен(КомпонентыОбмена, ТекРасширениеФормата, "ext");
		
		ВерсииФорматаОбмена = Новый Соответствие;
		
		МодульОбменДаннымиПереопределяемый = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиПереопределяемый");
		
		МодульОбменДаннымиПереопределяемый.ПриПолученииДоступныхВерсийФормата(ВерсииФорматаОбмена);
		КомпонентыОбмена.МенеджерОбмена = ВерсииФорматаОбмена.Получить(ТекВерсияФормата);
		Если КомпонентыОбмена.МенеджерОбмена = Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не поддерживается версия формата обмена: <%1>.'"), ТекВерсияФормата);
		КонецЕсли;
		
		МодульОбменДаннымиXDTOСервер.ИнициализироватьТаблицыПравилОбмена(КомпонентыОбмена);
	КонецЕсли;
	
	Возврат КомпонентыОбмена;
	
КонецФункции

Процедура ЗаписатьВФайлПризнакОбработан(КомпонентыОбмена)
	
	СтрокаТипОбъекта = "Обработан";
	
	ТипОбъекта = ФабрикаXDTO.Тип("http://v8.1c.ru/edi/edi_stnd/EnterpriseData/1.8.Cashbox", СтрокаТипОбъекта);
	
	ОбъектВыгрузки = ФабрикаXDTO.Создать(ТипОбъекта);
	
	ОбъектВыгрузки.Дата = Дата(1,1,1);
	
	ФабрикаXDTO.ЗаписатьXML(КомпонентыОбмена.ФайлОбмена, ОбъектВыгрузки);

КонецПроцедуры

// Загружает данные из сообщения обмена.
//
// Параметры:
//  ЧтениеXML	 - ЧтениеXML - инициализированный сообщением обмена объект ЧтениеXML.
// 
// Возвращаемое значение:
//   Структура:
//    * ЕстьОшибки - Булево - признак, что во время загрузки сообщения обмена возникли ошибки.
//    * ТекстОшибки - Строка - текст сообщения об ошибке.
//    * ЗагруженныеОбъекты - Массив - массив загруженных объектов.
//
Функция ЗагрузитьДанныеИзXML(ЧтениеXML)
	
	РезультатЗагрузки = Новый Структура;
	РезультатЗагрузки.Вставить("ЕстьОшибки", Ложь);
	РезультатЗагрузки.Вставить("ТекстОшибки", "");
	РезультатЗагрузки.Вставить("ЗагруженныеОбъекты", Новый Массив);
	
	ЧтениеXML.Прочитать(); // Message
	ЧтениеXML.Прочитать(); // Header
	ЗаголовокСообщенияXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ФабрикаXDTO.Тип("http://www.1c.ru/SSL/Exchange/Message", "Header"));
	Если ЧтениеXML.ТипУзла <> ТипУзлаXML.НачалоЭлемента
		Или ЧтениеXML.ЛокальноеИмя <> "Body" Тогда
		
		РезультатЗагрузки.ЕстьОшибки = Истина;
		РезультатЗагрузки.ТекстОшибки = НСтр("ru = 'Ошибка чтения сообщения загрузки. Неверный формат сообщения.'");
		
		Возврат РезультатЗагрузки;
	КонецЕсли;
	
	СтруктураФормата = СтрРазделить(ЗаголовокСообщенияXDTO.Format, " ", Ложь);
	
	ФорматОбмена = РазложитьФорматОбмена(СтруктураФормата[0]);
	ВерсияФорматаДляЗагрузки = ФорматОбмена.Версия;
	РасширениеФорматаДляЗагрузки = "";
	
	Если СтруктураФормата.Количество() > 0 Тогда
		РасширениеФорматаДляЗагрузки = СтруктураФормата[СтруктураФормата.ВГраница()];
	КонецЕсли;
	
	КомпонентыОбмена = КомпонентыОбмена("Получение",,, ВерсияФорматаДляЗагрузки, РасширениеФорматаДляЗагрузки);
	
	ЧтениеXML.Прочитать(); // Body
	КомпонентыОбмена.Вставить("ФайлОбмена", ЧтениеXML);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
		МодульОбменДаннымиXDTOСервер = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиXDTOСервер");

		УстановитьПривилегированныйРежим(Истина);
		ОтключитьОбновлениеКлючейДоступа(Истина);
		Попытка
			МодульОбменДаннымиXDTOСервер.ПроизвестиЧтениеДанных(КомпонентыОбмена);
			ОтключитьОбновлениеКлючейДоступа(Ложь);
		Исключение
			ОтключитьОбновлениеКлючейДоступа(Ложь);
			ВызватьИсключение;
		КонецПопытки;
		УстановитьПривилегированныйРежим(Ложь);
		
		Если КомпонентыОбмена.ФлагОшибки Тогда
			РезультатЗагрузки.ЕстьОшибки = Истина;
			РезультатЗагрузки.ТекстОшибки = КомпонентыОбмена.СтрокаСообщенияОбОшибке;
		КонецЕсли;
		
		РезультатЗагрузки.ЗагруженныеОбъекты = КомпонентыОбмена.ЗагруженныеОбъекты.ВыгрузитьКолонку("СсылкаНаОбъект");
	КонецЕсли;
		
	Возврат РезультатЗагрузки;
	
КонецФункции

// Готовит список объектов, подлежащих выгрузке.
Процедура ЗаполнитьСписокОбъектовКВыгрузке(КомпонентыОбмена, СтруктураПараметров) 
	
	ДанныеВыгрузки = СтруктураПараметров.ДанныеВыгрузки;
	ОбъектыКВыгрузке = Новый Массив;
	
	Если ДанныеВыгрузки.Свойство("Заказы")
		И ДанныеВыгрузки.Заказы <> Неопределено Тогда
		Заказы = ДанныеВыгрузки.Заказы;
		Для каждого Заказ Из Заказы Цикл
			ДобавитьОбъектКВыгрузке(ОбъектыКВыгрузке, Заказ.СсылкаЗаказа);
		КонецЦикла;
	КонецЕсли;
	
	ПрайсЛист = ДанныеВыгрузки.ПрайсЛист;

	Если ПрайсЛист.Свойство("ГруппыТоваров") Тогда
		Для каждого ГруппаТоваров Из ПрайсЛист.ГруппыТоваров Цикл
			ДобавитьОбъектКВыгрузке(ОбъектыКВыгрузке, ГруппаТоваров.СсылкаГруппы);
		КонецЦикла;
	КонецЕсли;
	
	Если ПрайсЛист.Свойство("Товары") Тогда
		ИменаРеквизитов = Новый Структура;
		
		Для каждого Товар Из ПрайсЛист.Товары Цикл
			
			Если Не ИменаРеквизитов.Свойство("Ссылка") Тогда
				МетаданныеОбъекта = Товар.СсылкаНоменклатура.Метаданные();
				СтандартныеРеквизиты = МетаданныеОбъекта.СтандартныеРеквизиты; // ОписанияСтандартныхРеквизитов -
				Реквизиты = МетаданныеОбъекта.Реквизиты; // КоллекцияОбъектовМетаданных -
				
				Для Каждого Реквизит Из СтандартныеРеквизиты Цикл
			        ИменаРеквизитов.Вставить(Реквизит.Имя);
			    КонецЦикла;

				Для Каждого Реквизит Из Реквизиты Цикл
			        ИменаРеквизитов.Вставить(Реквизит.Имя);
			    КонецЦикла;
			КонецЕсли;
			
			ТоварСтруктура = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Товар.СсылкаНоменклатура, ИменаРеквизитов);
			ТоварСтруктура.Вставить("Товар");
			
			ДобавитьОбъектКВыгрузке(ОбъектыКВыгрузке, ТоварСтруктура);
			
			Если Товар.ИмеетХарактеристики Тогда
				Для каждого Характеристика Из Товар.Характеристики Цикл
					ДобавитьОбъектКВыгрузке(ОбъектыКВыгрузке, Характеристика.СсылкаХарактеристика);

					Если ЗначениеЗаполнено(Характеристика.Штрихкоды) Тогда
						ПараметрыШтрихкода = Новый Структура;
						ПараметрыШтрихкода.Вставить("Номенклатура", Товар.СсылкаНоменклатура);
						ПараметрыШтрихкода.Вставить("Характеристика", Характеристика.СсылкаХарактеристика);
						ПараметрыШтрихкода.Вставить("Штрихкоды", Характеристика.Штрихкоды);
						ВыгрузитьШтрихкоды(ПараметрыШтрихкода, ОбъектыКВыгрузке);
					КонецЕсли;
					Если Характеристика.ИмеетУпаковки Тогда
						Для каждого Упаковка Из Характеристика.Упаковки Цикл
							
								УпаковкаСтруктура = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
										Упаковка.СсылкаУпаковки, "Владелец, Наименование, ЕдиницаИзмерения, Коэффициент, Объем");
										
								ВладелецНоменклатура = УпаковкаСтруктура.Владелец = Товар.СсылкаНоменклатура;		
								
								Если ВладелецНоменклатура Тогда
									ДобавитьОбъектКВыгрузке(ОбъектыКВыгрузке, Упаковка.СсылкаУпаковки);
								Иначе
									УпаковкаСтруктура.Вставить("Упаковка");
									УпаковкаСтруктура.Вставить("Владелец", Товар.СсылкаНоменклатура);
									ДобавитьОбъектКВыгрузке(ОбъектыКВыгрузке, УпаковкаСтруктура);
								КонецЕсли;
					
							Если ЗначениеЗаполнено(Упаковка.Штрихкоды) Тогда
								ПараметрыШтрихкода = Новый Структура;
								ПараметрыШтрихкода.Вставить("Номенклатура", Товар.СсылкаНоменклатура);
								ПараметрыШтрихкода.Вставить("Характеристика", Характеристика.СсылкаХарактеристика);
								ПараметрыШтрихкода.Вставить("Упаковка", ?(ВладелецНоменклатура, Упаковка.СсылкаУпаковки, УпаковкаСтруктура));
								ПараметрыШтрихкода.Вставить("Штрихкоды", Упаковка.Штрихкоды);
								ВыгрузитьШтрихкоды(ПараметрыШтрихкода, ОбъектыКВыгрузке);
							КонецЕсли;
						КонецЦикла;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			Если Товар.ИмеетУпаковки Тогда
				Для каждого Упаковка Из Товар.Упаковки Цикл
												
					УпаковкаСтруктура = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
							Упаковка.СсылкаУпаковки, "Владелец, Наименование, ЕдиницаИзмерения, Коэффициент, Объем");
							
					ВладелецНоменклатура = УпаковкаСтруктура.Владелец = Товар.СсылкаНоменклатура;		

					Если ВладелецНоменклатура Тогда
						ДобавитьОбъектКВыгрузке(ОбъектыКВыгрузке, Упаковка.СсылкаУпаковки);
					Иначе
						УпаковкаСтруктура.Вставить("Упаковка");
						УпаковкаСтруктура.Вставить("Владелец", Товар.СсылкаНоменклатура);
						ДобавитьОбъектКВыгрузке(ОбъектыКВыгрузке, УпаковкаСтруктура);
					КонецЕсли;

					Если ЗначениеЗаполнено(Упаковка.Штрихкоды) Тогда
						ПараметрыШтрихкода = Новый Структура;
						ПараметрыШтрихкода.Вставить("Номенклатура", Товар.СсылкаНоменклатура);
						ПараметрыШтрихкода.Вставить("Упаковка", ?(ВладелецНоменклатура, Упаковка.СсылкаУпаковки, УпаковкаСтруктура));
						ПараметрыШтрихкода.Вставить("Штрихкоды", Упаковка.Штрихкоды);
						ВыгрузитьШтрихкоды(ПараметрыШтрихкода, ОбъектыКВыгрузке);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Товар.Штрихкоды) Тогда
				ПараметрыШтрихкода = Новый Структура;
				ПараметрыШтрихкода.Вставить("Номенклатура", Товар.СсылкаНоменклатура);
				ПараметрыШтрихкода.Вставить("Штрихкоды", Товар.Штрихкоды);
				ВыгрузитьШтрихкоды(ПараметрыШтрихкода, ОбъектыКВыгрузке);
			КонецЕсли;

		КонецЦикла;
	КонецЕсли;
	
	Если ПрайсЛист.Свойство("ЕдиницыИзмерения") Тогда
		Для каждого ЕдиницаИзмерения Из ПрайсЛист.ЕдиницыИзмерения Цикл
			ДобавитьОбъектКВыгрузке(ОбъектыКВыгрузке, ЕдиницаИзмерения.СсылкаЕдиницыИзмерения);
		КонецЦикла;
	КонецЕсли;

	СтруктураПараметров.Вставить("ОбъектыКВыгрузке", ОбъектыКВыгрузке);
	
КонецПроцедуры

Процедура ДобавитьОбъектКВыгрузке(ОбъектыКВыгрузке, ВыгружаемыйОбъект)
	
	Если ТипЗнч(ВыгружаемыйОбъект) <> Тип("Структура") Тогда
		Если ОбъектыКВыгрузке.Найти(ВыгружаемыйОбъект) = Неопределено Тогда
			ОбъектыКВыгрузке.Добавить(ВыгружаемыйОбъект);
		КонецЕсли;
	Иначе
		ХешСумма = ОбщегоНазначения.КонтрольнаяСуммаСтрокой(ВыгружаемыйОбъект);
		Для каждого ТекЭлемент Из ОбъектыКВыгрузке Цикл
			Если ТипЗнч(ТекЭлемент) <> Тип("Структура") Тогда
				Продолжить;
			КонецЕсли;
			ХешТекЭлемент = ОбщегоНазначения.КонтрольнаяСуммаСтрокой(ТекЭлемент);
			Если ХешСумма = ХешТекЭлемент Тогда
				Возврат;
			КонецЕсли;
		КонецЦикла;
		ОбъектыКВыгрузке.Добавить(ВыгружаемыйОбъект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыгрузитьШтрихкоды(ПараметрыШтрихкода, ОбъектыКВыгрузке)
	
	Если ПараметрыШтрихкода.Штрихкоды.Количество() > 0 Тогда
			
		Для каждого  ШК Из ПараметрыШтрихкода.Штрихкоды Цикл
			ДанныеИБ = Новый Структура("Штрихкод");
			ДанныеИБ.Штрихкод  = ШК.Штрихкод;
				
			Записи = ЗаписиШтрихКода(ПараметрыШтрихкода);

			НоваяСтрока = Записи.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ПараметрыШтрихкода);
			
			НоваяСтрока.Штрихкод = ШК.Штрихкод;

			ДанныеИБ.Вставить("Записи", Записи);
			ДобавитьОбъектКВыгрузке(ОбъектыКВыгрузке, ДанныеИБ)
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

Функция ЗаписиШтрихКода(ПараметрыШтрихкода)
	
	Записи = Новый ТаблицаЗначений;
	Записи.Колонки.Добавить("Штрихкод", Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(200)));
	
	Для каждого Параметр Из ПараметрыШтрихкода Цикл
		
		Если Параметр.Ключ = "Штрихкоды" Тогда
			Продолжить;
		КонецЕсли;
		
		ТипыПараметра = Новый Массив;
		ТипПараметра = ТипЗнч(Параметр.Значение);
		
		ТипыПараметра.Добавить(ТипПараметра);
	    Записи.Колонки.Добавить(Параметр.Ключ, Новый ОписаниеТипов(ТипыПараметра));
		
	КонецЦикла;
	
	Возврат Записи;
	
КонецФункции

Процедура ПолучитьПрайсЛист(КомпонентыОбмена, ОбъектыКВыгрузке, ИсходныеДанные, ПрайсЛист)
	
	Параметры = ИсходныеДанные.Параметры;
	
	ОрганизацияККМ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Идентификатор, "Организация");
	
	ДанныеИБ = Новый Структура;
	ДанныеИБ.Вставить("Дата", ТекущаяДатаСеанса());
	ДанныеИБ.Вставить("Организация", ОрганизацияККМ);
	ДанныеИБ.Вставить("ТипЦены", Новый Структура("Наименование", "Розничная"));
		
	ПрайсЛист.Добавить(ДанныеИБ);

КонецПроцедуры

Процедура ПолучитьПозициюПрайсЛиста(КомпонентыОбмена, ОбъектыКВыгрузке, ИсходныеДанные, ПозицииПрайсЛиста)
	
	Параметры 	= ИсходныеДанные.Параметры;
	Товары 		= ИсходныеДанные.ПрайсЛист.Товары;
	ПрайсЛист 	= ИсходныеДанные.СправочникПрайсЛист;
	
	Для каждого Товар Из Товары Цикл
		
		Если Товар.Характеристики.Количество() > 0 Тогда
			Для каждого Характеристика Из Товар.Характеристики Цикл
				ДанныеИБ = Новый Структура;
				Если Характеристика.Штрихкоды.Количество() > 0 Тогда
					ДанныеИБ.Вставить("Штрихкод", Характеристика.Штрихкоды[0].Штрихкод);
				КонецЕсли;
				ДанныеИБ.Вставить("ПрайсЛист", ПрайсЛист);
				ДанныеИБ.Вставить("Номенклатура", Товар.СсылкаНоменклатура);
				ДанныеИБ.Вставить("Характеристика", Характеристика.СсылкаХарактеристика);
				ДанныеИБ.Вставить("Цена", Характеристика.Цена);
				ДанныеИБ.Вставить("SKU", Характеристика.Код);
				
				ПозицииПрайсЛиста.Добавить(ДанныеИБ);
			КонецЦикла;
		Иначе
			ДанныеИБ = Новый Структура;
			Если Товар.Штрихкоды.Количество() > 0 Тогда
				ДанныеИБ.Вставить("Штрихкод", Товар.Штрихкоды[0].Штрихкод);
			КонецЕсли;
			ДанныеИБ.Вставить("ПрайсЛист", ПрайсЛист);
			ДанныеИБ.Вставить("Номенклатура", Товар.СсылкаНоменклатура);
			ДанныеИБ.Вставить("Цена", Товар.Цена);
			ДанныеИБ.Вставить("SKU", Товар.Код);
			
			ПозицииПрайсЛиста.Добавить(ДанныеИБ);
		КонецЕсли;
		
		Если Товар.Упаковки.Количество() > 0 Тогда
			Для каждого Упаковка Из Товар.Упаковки Цикл
				ДанныеИБ = Новый Структура;
				Если Упаковка.Штрихкоды.Количество() > 0 Тогда
					ДанныеИБ.Вставить("Штрихкод", Упаковка.Штрихкоды[0].Штрихкод);
				КонецЕсли;
				ДанныеИБ.Вставить("ПрайсЛист", ПрайсЛист);
				ДанныеИБ.Вставить("Номенклатура", Товар.СсылкаНоменклатура);
				ДанныеИБ.Вставить("Цена", Упаковка.Цена);
				ДанныеИБ.Вставить("SKU", Упаковка.Код);
				
				УпаковкаСтруктура = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
						Упаковка.СсылкаУпаковки, "Владелец, Наименование, ЕдиницаИзмерения, Коэффициент, Объем");
						
				Если УпаковкаСтруктура.Владелец = Товар.СсылкаНоменклатура Тогда
					ДанныеИБ.Вставить("Упаковка", Упаковка.СсылкаУпаковки);
				Иначе
					УпаковкаСтруктура.Вставить("Упаковка");
					УпаковкаСтруктура.Вставить("Владелец", Товар.СсылкаНоменклатура);
					
					СсылкаВыгрузки = Упаковка.СсылкаУпаковки;
					МетаданныеСсылкиВыгрузки = СсылкаВыгрузки.Метаданные();
					ПравилоОбработки = КомпонентыОбмена.ПравилаОбработкиДанных.Найти(МетаданныеСсылкиВыгрузки, "ОбъектВыборкиМетаданные");
					Если ПравилоОбработки = Неопределено Тогда
						Продолжить;
					КонецЕсли;
					ДанныеИБ.Вставить("Упаковка", УпаковкаСтруктура);
				КонецЕсли;
				
				ПозицииПрайсЛиста.Добавить(ДанныеИБ);
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
			
КонецПроцедуры

Функция РазложитьФорматОбмена(Знач ФорматОбмена)
	
	Результат = Новый Структура("БазовыйФормат, Версия");
	
	ЭлементыФормата = СтрРазделить(ФорматОбмена, "/");
	
	Если ЭлементыФормата.Количество() = 0 Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Неканоническое имя формата обмена <%1>'"), ФорматОбмена);
	КонецЕсли;
	
	Результат.Версия = ЭлементыФормата[ЭлементыФормата.ВГраница()];
	
	Версии = СтрРазделить(Результат.Версия, ".");
	
	Если Версии.Количество() = 0 Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Неканоническое представление версии формата обмена: <%1>.'"), Результат.Версия);
	КонецЕсли;
	
	ЭлементыФормата.Удалить(ЭлементыФормата.ВГраница());
	
	Результат.БазовыйФормат = СтрСоединить(ЭлементыФормата, "/");
	
	Возврат Результат;
	
КонецФункции

Функция НайтиПравилаОбработкиДанныхПоПКО(КомпонентыОбмена, ИмяПКО)
	
	Для каждого ПОД Из КомпонентыОбмена.ПравилаОбработкиДанных Цикл
		Если ПОД.ИспользуемыеПКО.Найти(ИмяПКО) <> Неопределено Тогда
			Возврат ПОД;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

Процедура ОтключитьОбновлениеКлючейДоступа(Отключить, ПланироватьОбновление = Истина)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ОтключитьОбновлениеКлючейДоступа(Отключить, ПланироватьОбновление);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВключитьПространствоИмен(КомпонентыОбмена, Знач ПространствоИмен, Знач Псевдоним = "")
	
	Если ПустаяСтрока(ПространствоИмен) Тогда
		Возврат;
	КонецЕсли;
	
	КомпонентыОбмена.РасширенияФормата.Вставить(ПространствоИмен, Псевдоним);
	
КонецПроцедуры

#КонецОбласти
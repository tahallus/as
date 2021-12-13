﻿#Область ПрограммныйИнтерфейс

Функция ПараметрыОбработкиСчитанныхRFID() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("СчитывательRFID");
	Результат.Вставить("УникальныйИдентификатор");
	Результат.Вставить("GTIN");
	Результат.Вставить("НастройкиИспользованияСерий");
	Результат.Вставить("ЭтоМаркировкаПерсонифицированнымиКиЗ");
	Результат.Вставить("ЭтоМаркировкаТоваровГИСМ");
	Результат.Вставить("Номенклатура");
	
	Возврат Результат;
	
КонецФункции

// Функция - Обработать считывание RFID
//
// Параметры:
//  ДанныеМеток					 - Массив - см. МенеджерОборудованияУНФКлиент.ПреобразоватьДанныеСоСканераВМассив
//  Параметры					 - Структура - 
//  ТЧСерии						 - ТаблицаЗначений - 
//  ИдентификаторТекущейСтроки	 - Число - 
// 
// Возвращаемое значение:
//  Структура - результат считывания RFID:
//   * ЗакрытьФорму - Булево - 
//   * ИдентификаторТекущейСтроки - Число - 
//   * ДанныеСерии - Структура
Функция ОбработатьСчитываниеRFID(ДанныеМеток, Параметры, ТЧСерии = Неопределено,
	ИдентификаторТекущейСтроки = Неопределено) Экспорт
	
	GTIN                                 = Параметры.GTIN;
	НастройкиИспользованияСерий          = Параметры.НастройкиИспользованияСерий;
	ЭтоМаркировкаПерсонифицированнымиКиЗ = Параметры.ЭтоМаркировкаПерсонифицированнымиКиЗ;
	
	КорректноСчитанныеМетки = Новый Массив;
	
	Для Каждого Метка Из ДанныеМеток Цикл
		
		// Если TID не считался, то нельзя считать чтение метки успешным
		Если ЗначениеЗаполнено(Метка.TID) Тогда
			КорректноСчитанныеМетки.Добавить(Метка);
		КонецЕсли;
		
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("ЗакрытьФорму", Ложь);
	Результат.Вставить("ИдентификаторТекущейСтроки", Неопределено);
	Результат.Вставить("ДанныеСерии", Неопределено);
	
	// От считывателя одна и та же метка могла приехать несколько раз
	// Поэтому сначала свернем приехавшие данные
	ТаблицаМеток = МассивВТаблицуЗначений(КорректноСчитанныеМетки);
	ИменаКолонок = Новый Массив;
	
	Для Каждого Колонка Из ТаблицаМеток.Колонки Цикл
		ИменаКолонок.Добавить(Колонка.Имя);
	КонецЦикла;
	
	ТаблицаМеток.Свернуть(СтрСоединить(ИменаКолонок,","));
	
	Если ТаблицаМеток.Количество() > 1 Тогда
		ТекстСообщения = НСтр("ru = 'Считалось сразу несколько RFID-меток.
                               |Оставьте в зоне действия считывателя только одну метку и повторите считывание.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Возврат Результат;
	КонецЕсли;
	
	ОбрабатываемаяСтрока = Неопределено;
	
	Если ТЧСерии = Неопределено Тогда
		ТЧСерии = Новый ТаблицаЗначений;
		ТЧСерии.Колонки.Добавить("Серия", Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
		ТЧСерии.Колонки.Добавить("НомерГИСМ",ОбщегоНазначения.ОписаниеТипаСтрока(50));
		ТЧСерии.Колонки.Добавить("НомерКиЗГИСМ", Метаданные.ОпределяемыеТипы.НомерКиЗГИСМ.Тип);
		ТЧСерии.Колонки.Добавить("RFIDTID", Метаданные.ОпределяемыеТипы.RFIDTID.Тип);
		ТЧСерии.Колонки.Добавить("RFIDUser",ОбщегоНазначения.ОписаниеТипаСтрока(30));
		ТЧСерии.Колонки.Добавить("RFIDEPC",ОбщегоНазначения.ОписаниеТипаСтрока(30));
		ТЧСерии.Колонки.Добавить("EPCGTIN", Метаданные.ОпределяемыеТипы.GTIN.Тип);
		ТЧСерии.Колонки.Добавить("ГоденДо", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.ДатаВремя));
		ТЧСерии.Колонки.Добавить("НужноЗаписатьМетку", Новый ОписаниеТипов("Булево"));
		ТЧСерии.Колонки.Добавить("ЗаполненRFIDTID", Новый ОписаниеТипов("Булево"));
		ТЧСерии.Колонки.Добавить("СтатусРаботыRFID", ОбщегоНазначения.ОписаниеТипаЧисло(1));
		ТЧСерии.Колонки.Добавить("Количество", ОбщегоНазначения.ОписаниеТипаЧисло(1));
		ТЧСерии.Колонки.Добавить("КоличествоУпаковок", ОбщегоНазначения.ОписаниеТипаЧисло(1));
	КонецЕсли;
	
	
	ТекущаяМетка = ТаблицаМеток[0];
	
	ИнформацияПоКиЗ = ИнтеграцияГИСМ.ИнформацияОКиЗПоRFIDTID(ТекущаяМетка.TID);
	
	Если ЗначениеЗаполнено(ИнформацияПоКиЗ.НомерКиЗ) Тогда
		ОбрабатываемаяСтрока = ДобавитьСериюПоИнформацииПоКиЗ(ИнформацияПоКиЗ, Параметры, ТЧСерии, ИдентификаторТекущейСтроки);
	Иначе
		ОбрабатываемаяСтрока = ДобавитьСериюПоИнформацииОМетке(ТекущаяМетка, Параметры, ТЧСерии, ИдентификаторТекущейСтроки);	
	КонецЕсли;

	СообщениеОбОшибке = "";
	RFIDКлиентСервер.ЗаполнитьФлагиРаботыСМеткой(ОбрабатываемаяСтрока, GTIN, ТекущаяМетка, НастройкиИспользованияСерий,
		ЭтоМаркировкаПерсонифицированнымиКиЗ, СообщениеОбОшибке);
	Если СообщениеОбОшибке <> "" Тогда
		ОбщегоНазначения.СообщитьПользователю(СообщениеОбОшибке);
	КонецЕсли;
	
	Если ОбщегоНазначения.РежимОтладки() Тогда
		СтрокаМетки = "";
		
		Для Каждого Колонка Из ТаблицаМеток.Колонки Цикл
			СтрокаМетки = СтрокаМетки + Колонка.Имя + " " + ТаблицаМеток[0][Колонка.Имя] + " ";
		КонецЦикла;
		ОбщегоНазначения.СообщитьПользователю(СтрокаМетки);
	КонецЕсли;
	
	Если ОбрабатываемаяСтрока <> Неопределено Тогда
		Если ТипЗнч(ТЧСерии) <> Тип("ТаблицаЗначений") Тогда
			Результат.ИдентификаторТекущейСтроки = ОбрабатываемаяСтрока.ПолучитьИдентификатор();
		Иначе
			Результат.ДанныеСерии = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ОбрабатываемаяСтрока);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

Функция ДобавитьСериюПоИнформацииПоКиЗ(ИнформацияПоКиЗ, Параметры, ТЧСерии, ИдентификаторТекущейСтроки) Экспорт
	
	GTIN                        = Параметры.GTIN;
	ЭтоМаркировкаТоваровГИСМ    = Параметры.ЭтоМаркировкаТоваровГИСМ;
	НастройкиИспользованияСерий = Параметры.НастройкиИспользованияСерий;
	ВидНоменклатуры             = Параметры.Номенклатура;
	ЭтоМаркировкаПерсонифицированнымиКиЗ = Параметры.ЭтоМаркировкаПерсонифицированнымиКиЗ;
	
	Если Не ЗначениеЗаполнено(ИнформацияПоКиЗ.НомерКиЗ) Тогда
		ТекстСообщения = НСтр("ru = 'Ошибка добавления серии по информации о КиЗ: не заполнен номер КиЗ.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Возврат Неопределено;
	КонецЕсли;
	
	Если ЭтоМаркировкаТоваровГИСМ Тогда		
		Если ЗначениеЗаполнено(ИнформацияПоКиЗ.GTIN) 
			И GTIN <> ИнформацияПоКиЗ.GTIN Тогда
			ТекстСообщения = НСтр("ru = 'Считанный КиЗ не может быть использован для маркировки товаров с GTIN %GTINТовара%, т.к. предназначен для маркировки товаров с GTIN %GTINКиЗ%.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%GTINТовара%", GTIN);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%GTINКиЗ%", ИнформацияПоКиЗ.GTIN);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	НайденныеСтроки = ТЧСерии.НайтиСтроки(Новый Структура("НомерКИЗГИСМ", ИнформацияПоКиЗ.НомерКиЗ));
	
	ОбрабатываемаяСтрока = Неопределено;
	
	Если ИдентификаторТекущейСтроки <> Неопределено Тогда
		ТекущаяСтрока = ТЧСерии.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
	Иначе
		ТекущаяСтрока = Неопределено;
	КонецЕсли;
	
	// Для случая, когда информации о КиЗ в системе нет, поэтому мы считываем RFID и сканером номер КиЗ
	Если НайденныеСтроки.Количество() = 0
		И ТекущаяСтрока <> Неопределено
		И Не ЗначениеЗаполнено(ТекущаяСтрока.НомерКИЗГИСМ)
		И (ТекущаяСтрока.RFIDTID = ИнформацияПоКиЗ.RFIDTID
		Или Не ЗначениеЗаполнено(ИнформацияПоКиЗ.RFIDTID)) Тогда
		
		ОбрабатываемаяСтрока = ТекущаяСтрока;
		ЗаполнитьСтрокуПоИнформацииПоКиЗ(ОбрабатываемаяСтрока, ИнформацияПоКиЗ, НастройкиИспользованияСерий);
		
	ИначеЕсли НайденныеСтроки.Количество() > 0 Тогда
		
		ОбрабатываемаяСтрока = НайденныеСтроки[0];
		
		Если Не ЗначениеЗаполнено(ОбрабатываемаяСтрока.Серия) Тогда
			Выборка = ВыборкаИзЗапросаПоискаСерииПоНомеруКиЗ(ИнформацияПоКиЗ.НомерКиЗ, ВидНоменклатуры);
			
			Если Выборка.Следующий() Тогда
				Если РеквизитыСерииСовпадаютСИнформациейПоКиЗ(Выборка, ИнформацияПоКиЗ, ЭтоМаркировкаТоваровГИСМ) Тогда
					ЗаполнитьЗначенияСвойств(ОбрабатываемаяСтрока, Выборка);
				КонецЕсли;
			Иначе
				ЗаполнитьСтрокуПоИнформацииПоКиЗ(ОбрабатываемаяСтрока, ИнформацияПоКиЗ, НастройкиИспользованияСерий);
			КонецЕсли;
			
		Иначе
			Если Не РеквизитыСерииСовпадаютСИнформациейПоКиЗ(ОбрабатываемаяСтрока, ИнформацияПоКиЗ, ЭтоМаркировкаТоваровГИСМ) Тогда
				ТЧСерии.Удалить(ОбрабатываемаяСтрока);
				ОбрабатываемаяСтрока = Неопределено;
			КонецЕсли;
		КонецЕсли;
	Иначе
		
		Выборка = ВыборкаИзЗапросаПоискаСерииПоНомеруКиЗ(ИнформацияПоКиЗ.НомерКиЗ, ВидНоменклатуры);
		
		Если Выборка.Следующий() Тогда
			Если РеквизитыСерииСовпадаютСИнформациейПоКиЗ(Выборка, ИнформацияПоКиЗ, ЭтоМаркировкаТоваровГИСМ) Тогда
				ОбрабатываемаяСтрока = ТЧСерии.Добавить();
				ЗаполнитьЗначенияСвойств(ОбрабатываемаяСтрока, Выборка);
			КонецЕсли;
		Иначе
			ОбрабатываемаяСтрока = ТЧСерии.Добавить();
			ЗаполнитьСтрокуПоИнформацииПоКиЗ(ОбрабатываемаяСтрока, ИнформацияПоКиЗ, НастройкиИспользованияСерий);
		КонецЕсли;	
				
	КонецЕсли;
	
	СообщениеОбОшибке = "";
	RFIDКлиентСервер.ЗаполнитьФлагиРаботыСМеткой(ОбрабатываемаяСтрока, GTIN, Неопределено, НастройкиИспользованияСерий,
		ЭтоМаркировкаПерсонифицированнымиКиЗ, СообщениеОбОшибке);
		
	Если СообщениеОбОшибке <> "" Тогда
		ОбщегоНазначения.СообщитьПользователю(СообщениеОбОшибке);
	КонецЕсли;
	
	Возврат ОбрабатываемаяСтрока;
	
КонецФункции

Функция ДобавитьСериюПоИнформацииОМетке(ТекущаяМетка, Параметры, ТЧСерии, ИдентификаторТекущейСтроки) Экспорт
	
	НастройкиИспользованияСерий = Параметры.НастройкиИспользованияСерий;
	Номенклатура             = Параметры.Номенклатура;
	
	Если Не ЗначениеЗаполнено(ТекущаяМетка.TID) Тогда
		ТекстСообщения = НСтр("ru = 'Ошибка добавления серии по информации о RFID-метке: не заполнен TID.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Возврат Неопределено;
	КонецЕсли;
	
	НайденныеСтроки = ТЧСерии.НайтиСтроки(Новый Структура("RFIDTID", ТекущаяМетка.TID));
		
	ОбрабатываемаяСтрока = Неопределено;
	
	Если ИдентификаторТекущейСтроки <> Неопределено Тогда
		ТекущаяСтрока = ТЧСерии.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
	Иначе
		ТекущаяСтрока = Неопределено;
	КонецЕсли;
	
	// Для случая, когда информации о КиЗ в системе нет, поэтому мы считываем RFID и сканером номер КиЗ
	Если НайденныеСтроки.Количество() = 0
		И ТекущаяСтрока <> Неопределено
		И Не ЗначениеЗаполнено(ТекущаяСтрока.RFIDTID)
		И (Не ЗначениеЗаполнено(ТекущаяСтрока.НомерГИСМ)
			Или Не НастройкиИспользованияСерий.ИспользоватьНомерСерии 
			Или ТекущаяСтрока.НомерГИСМ = ТекущаяМетка.СерийныйНомер) Тогда
		
		ОбрабатываемаяСтрока = ТекущаяСтрока;
		ОбрабатываемаяСтрока.RFIDTID = ТекущаяМетка.TID;
		Если ЗначениеЗаполнено(ТекущаяМетка.GTIN)
			И Не ЗначениеЗаполнено(ОбрабатываемаяСтрока.EPCGTIN) Тогда
			ОбрабатываемаяСтрока.EPCGTIN = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(ТекущаяМетка.GTIN, "0");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТекущаяМетка.СерийныйНомер)
			И Не ЗначениеЗаполнено(ОбрабатываемаяСтрока.НомерГИСМ) Тогда
			ОбрабатываемаяСтрока.НомерГИСМ = ТекущаяМетка.СерийныйНомер;
		КонецЕсли;
		
		Возврат ОбрабатываемаяСтрока;	
	
	ИначеЕсли НайденныеСтроки.Количество() > 0 Тогда
		ОбрабатываемаяСтрока = НайденныеСтроки[0];
		
		Возврат ОбрабатываемаяСтрока;
	Иначе
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СерииНоменклатуры.Ссылка КАК СерийныйНомер,
		|	СерииНоменклатуры.НомерГИСМ КАК Номер,
		|	СерииНоменклатуры.НомерКиЗГИСМ КАК НомерКиЗГИСМ,
		|	СерииНоменклатуры.RFIDTID КАК RFIDTID,
		|	СерииНоменклатуры.RFIDUser КАК RFIDUser,
		|	СерииНоменклатуры.RFIDEPC КАК RFIDEPC,
		|	СерииНоменклатуры.EPCGTIN КАК EPCGTIN
		|ИЗ
		|	Справочник.СерииНоменклатуры КАК СерииНоменклатуры
		|ГДЕ
		|	СерииНоменклатуры.Владелец = &Номенклатура
		|	И СерииНоменклатуры.RFIDTID = &TID";
		
		Запрос.УстановитьПараметр("TID", ТекущаяМетка.TID);
		Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			ОбрабатываемаяСтрока = ТЧСерии.Добавить();
			ЗаполнитьЗначенияСвойств(ОбрабатываемаяСтрока, Выборка);
		Иначе
			ОбрабатываемаяСтрока = ТЧСерии.Добавить();
			ОбрабатываемаяСтрока.RFIDTID = ТекущаяМетка.TID;
			
			Если ЗначениеЗаполнено(ТекущаяМетка.GTIN) Тогда
				ОбрабатываемаяСтрока.EPCGTIN = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(ТекущаяМетка.GTIN, "0");
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ТекущаяМетка.СерийныйНомер)
				И  НастройкиИспользованияСерий.ИспользоватьНомерСерии Тогда
				
				ОбрабатываемаяСтрока.НомерГИСМ = ТекущаяМетка.СерийныйНомер;
			КонецЕсли;
		КонецЕсли;	
				
	КонецЕсли;
		
	Возврат ОбрабатываемаяСтрока;
	
КонецФункции

// Описание типов по типу
//
// Параметры:
//  Тип - Тип - тип, на основании которого следует получить описание типов
// 
// Возвращаемое значение:
//  ОписаниеТипов - описание типов на основе переданного типа
//
Функция ОписаниеТиповПоТипу(Тип) Экспорт
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип);
	
	ОписаниеТипов = Новый ОписаниеТипов(МассивТипов);
	
	Возврат ОписаниеТипов;
	
КонецФункции

// Параметры обработки считанных RFIDИКи З
// 
// Возвращаемое значение:
//  Структура - 
//
Функция ПараметрыОбработкиСчитанныхRFIDИКиЗ() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("СчитывательRFID");
	Результат.Вставить("УникальныйИдентификатор");
	Результат.Вставить("GTIN");
	Результат.Вставить("НастройкиИспользованияСерий");
	Результат.Вставить("ЭтоМаркировкаПерсонифицированнымиКиЗ");
	Результат.Вставить("ЭтоМаркировкаТоваровГИСМ");
	Результат.Вставить("Номенклатура");
	Результат.Вставить("ЭтоМаркировкаОстатковГИСМ");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСтрокуПоИнформацииПоКиЗ(Строка, ИнформацияПоКиЗ, НастройкиИспользованияСерий)
	Строка.НомерКИЗГИСМ = ИнформацияПоКиЗ.НомерКиЗ;
		
	Если НастройкиИспользованияСерий.ИспользоватьRFIDМеткиСерии Тогда
		Если ЗначениеЗаполнено(ИнформацияПоКиЗ.RFIDTID) Тогда
			Строка.RFIDTID = ИнформацияПоКиЗ.RFIDTID;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ИнформацияПоКиЗ.RFIDEPC) Тогда
			Строка.RFIDEPC = ИнформацияПоКиЗ.RFIDEPC;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ИнформацияПоКиЗ.GTIN) Тогда
			Строка.EPCGTIN = ИнформацияПоКиЗ.GTIN;
		КонецЕсли;
	КонецЕсли;
	
	Если НастройкиИспользованияСерий.ИспользоватьНомерСерии 
		И ЗначениеЗаполнено(ИнформацияПоКиЗ.СерийныйНомер) Тогда
		Строка.НомерГИСМ = ИнформацияПоКиЗ.СерийныйНомер;
	КонецЕсли;
КонецПроцедуры

Функция ВыборкаИзЗапросаПоискаСерииПоНомеруКиЗ(НомерКиЗ, Номенклатура)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СерииНоменклатуры.Ссылка КАК Серия,
	|	СерииНоменклатуры.НомерГИСМ КАК Номер,
	|	СерииНоменклатуры.НомерКиЗГИСМ КАК НомерКиЗГИСМ,
	|	СерииНоменклатуры.RFIDTID КАК RFIDTID,
	|	СерииНоменклатуры.RFIDUser КАК RFIDUser,
	|	СерииНоменклатуры.RFIDEPC КАК RFIDEPC,
	|	СерииНоменклатуры.EPCGTIN КАК EPCGTIN
	|ИЗ
	|	Справочник.СерииНоменклатуры КАК СерииНоменклатуры
	|ГДЕ
	|	СерииНоменклатуры.Владелец = &Номенклатура
	|	И СерииНоменклатуры.НомерКиЗГИСМ = &НомерКиЗГИСМ";
	
	Запрос.УстановитьПараметр("НомерКиЗГИСМ", НомерКиЗ);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	Возврат Запрос.Выполнить().Выбрать();
КонецФункции

Функция РеквизитыСерииСовпадаютСИнформациейПоКиЗ(РеквизитыСерии, ИнформацияПоКиЗ, ЭтоМаркировкаТоваровГИСМ)
	
	Если ЭтоМаркировкаТоваровГИСМ
        И (РеквизитыСерии.RFIDTID <> ИнформацияПоКиЗ.RFIDTID 
		Или (ЗначениеЗаполнено(ИнформацияПоКиЗ.GTIN) 
			И РеквизитыСерии.EPCGTIN <> ИнформацияПоКиЗ.GTIN)
		Или (ЗначениеЗаполнено(ИнформацияПоКиЗ.СерийныйНомер)
		    И СтрЧислоВхождений(ИнформацияПоКиЗ.СерийныйНомер, "0") <> СтрДлина(ИнформацияПоКиЗ.СерийныйНомер)
			И РеквизитыСерии.НомерГИСМ <> ИнформацияПоКиЗ.СерийныйНомер)) Тогда
		ТекстСообщения = НСтр("ru = 'Информация о КиЗ с номером %НомерКиЗ% предоставленная эмитентом не соответствует информации, сохраненной в серии. Этот КиЗ не может быть использован для маркировки.'");	
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерКиЗ%", ИнформацияПоКиЗ.НомерКиЗ); 
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);	
		Возврат Ложь;
	КонецЕсли;

	Возврат Истина;
	
КонецФункции

// Возвращает таблицу значений на основании массива структур
// 
// Параметры:
//	МассивСтруктур - МассивСтруктур - массив структур, которые будут преобразованы в таблиц значений.
//										Свойства структуры первого элемента массива определяют состав колонок результирующей таблицы
//
// Возвращаемое значение:
//	ТаблицаЗначений - таблица значений, созданная из массива структур
// 
Функция МассивВТаблицуЗначений(МассивСтруктур)
	Таблица = Новый ТаблицаЗначений;
	// Создадим колонки по первой структуре массива
	Если ТипЗнч(МассивСтруктур) = Тип("Массив")
		И МассивСтруктур.Количество() <> 0 Тогда
		ПерваяСтруктура = МассивСтруктур[0];
		Для Каждого Свойство Из ПерваяСтруктура Цикл 
			Таблица.Колонки.Добавить(Свойство.Ключ, ОписаниеТиповПоТипу(ТипЗнч(Свойство.Значение)));
		КонецЦикла;
		
		Для Каждого Структура Из МассивСтруктур Цикл 
			НоваяСтрока = Таблица.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Структура);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Таблица;
КонецФункции

#КонецОбласти
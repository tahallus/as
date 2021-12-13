﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Общего назначения

// Определяет возможность использования Монитора
// в соответствии с текущим режимом работы информационной базы
// и правами пользователя.
//
// Возвращаемое значение:
//	Булево - Истина - возможно использование, Ложь - в противном случае.
//
Функция ДоступноИспользованиеМонитора() Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ПравоДоступа("Просмотр", Метаданные.Обработки.МониторПортала1СИТС);
	
КонецФункции

#Область ИнтеграцияСБиблиотекойСтандартныхПодсистем

// Добавляет необходимые параметры работы клиента при запуске.
// Добавленные параметры доступны в
// СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске().ИнтернетПоддержкаПользователей.<ИмяПараметра>;
// Используется в том случае, если подсистема реализует сценарий, выполняемый
// при начале работы системы.
// Вызывается из ИнтернетПоддержкаПользователей.ПараметрыРаботыКлиентаПриЗапуске().
//
// Параметры:
//	Параметры - Структура - заполняемые параметры;
//
Процедура ПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	Если Не ДоступноИспользованиеМонитора() Тогда
		Возврат;
	КонецЕсли;
	
	ОбщиеПараметры = ОбщиеПараметрыМонитора();
	Если Не ОбщиеПараметры.ИспользоватьОтображениеПриНачалеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ИнтернетПоддержкаПодключена =
		ИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
	Если ИнтернетПоддержкаПодключена Тогда
		ЗначениеНастройкиПоказыватьПриНачалеРаботы = ЗначениеНастройкиПоказыватьПриНачалеРаботы();
		Если ЗначениеНастройкиПоказыватьПриНачалеРаботы = 2 Тогда
			// Никогда не показывать при начале работы.
			Возврат;
		КонецЕсли;
	Иначе
		// Если Интернет-поддержка не подключена.
		Если ИнтернетПоддержкаПользователей.ДоступноПодключениеИнтернетПоддержки() Тогда
			// Есть право подключения Интернет-поддержки - при начале работы
			// будет предложено подключить Интернет-поддержку.
			ЗначениеНастройкиПоказыватьПриНачалеРаботы = ЗначениеНастройкиПоказыватьПриНачалеРаботы();
			Если ЗначениеНастройкиПоказыватьПриНачалеРаботы = 2 Тогда
				// Никогда не показывать при начале работы.
				Возврат;
			КонецЕсли;
		Иначе
			// Нет права подключения Интернет-поддержки - не обрабатывать
			// событие начала работы с программой.
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыМонитора = Новый Структура;
	ПараметрыМонитора.Вставить("ПоказыватьПриНачалеРаботы"  , Истина);
	ПараметрыМонитора.Вставить("ИнтернетПоддержкаПодключена", ИнтернетПоддержкаПодключена);
	ПараметрыМонитора.Вставить("ПриНаличииНовойИнформации", (ЗначениеНастройкиПоказыватьПриНачалеРаботы = 1));
	Параметры.Вставить("МониторПортала1СИТС", ПараметрыМонитора);
	
КонецПроцедуры

// Интеграция с подсистемой СтандартныеПодсистемы.БазоваяФункциональность.
//
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
	НовыеРазрешения = Новый Массив;
	
	Разрешение = РаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
		"HTTPS",
		ХостСервиса(0),
		443,
		НСтр("ru = 'Сервис Монитор Портала 1С:ИТС (зона ru)'"));
	НовыеРазрешения.Добавить(Разрешение);
	
	Разрешение = РаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
		"HTTPS",
		ХостСервиса(1),
		443,
		НСтр("ru = 'Сервис Монитор Портала 1С:ИТС (зона eu)'"));
	НовыеРазрешения.Добавить(Разрешение);
	
	ЗапросыРазрешений.Добавить(РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(НовыеРазрешения));
	
КонецПроцедуры

// См. процедуру
// ОбщегоНазначенияПереопределяемый.ПриДобавленииПереименованийОбъектовМетаданных().
//
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт
	
	ОбщегоНазначения.ДобавитьПереименование(
		Итог,
		"2.2.5.1",
		"Подсистема.ИнтернетПоддержкаПользователей.Подсистема.МониторИнтернетПоддержки",
		"Подсистема.ИнтернетПоддержкаПользователей.Подсистема.МониторПортала1СИТС",
		"ИнтернетПоддержкаПользователей");
	
	ОбщегоНазначения.ДобавитьПереименование(
		Итог,
		"2.2.5.1",
		"Роль.ИспользованиеМонитораИПП",
		"Роль.ИспользованиеМонитораПортала1СИТС",
		"ИнтернетПоддержкаПользователей");
	
КонецПроцедуры

// Вызывается из обработчика ПриСозданииНаСервере() панели администрирования
// БСП, выполняется настройку отображения элементов управления для подсистем
// библиотеки ИПП.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - форма панели управления.
//
Процедура ИнтернетПоддержкаИСервисы_ПриСозданииНаСервере(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	Элементы.БИПМониторИнтернетПоддержки.Видимость = ДоступноИспользованиеМонитора();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОбщиеПараметрыМонитора() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьОтображениеПриНачалеРаботы", Истина);
	ИнтеграцияПодсистемБИП.ПриОпределенииОбщихПараметровМонитора(
		Результат);
	МониторПортала1СИТСПереопределяемый.ПриОпределенииОбщихПараметровМонитора(
		Результат);
	
	Возврат Результат;
	
КонецФункции

Функция ЗначениеНастройкиПоказыватьПриНачалеРаботы() Экспорт
	
	НастройкаЗапуска = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ИнтернетПоддержкаПользователей",
		"ВсегдаПоказыватьПриСтартеПрограммы");
	
	Если НастройкаЗапуска = Неопределено Тогда
		Возврат 0; // Всегда
	ИначеЕсли НастройкаЗапуска = Истина Тогда
		ПоказыватьПриОбновлении = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"ИнтернетПоддержкаПользователей",
			"ПоказПриСтартеТолькоПриИзменении");
		Если ПоказыватьПриОбновлении = Истина Тогда
			Возврат 1; // Только при наличии новой информации.
		Иначе
			Возврат 0; // Всегда
		КонецЕсли;
	Иначе
		Возврат 2; // Никогда
	КонецЕсли;
	
КонецФункции

Функция ОтпечатокДанныхМонитора(Логин, ДанныеМонитора)
	
	Если Логин = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДанныеСтрока =
		Логин
		+ ", "
		+ ЗначениеЗаполнено(ДанныеМонитора.programName) + ", "
		+ ДанныеМонитора.supportConditionsImplStatus.status + ", "
		+ ДанныеМонитора.serviceContractsStatus.status + ", "
		+ ДанныеМонитора.ДоступноОбновление;
	
	Хеширование = Новый ХешированиеДанных(ХешФункция.SHA256);
	Хеширование.Добавить(ДанныеСтрока);
	Возврат Base64Строка(Хеширование.ХешСумма);
	
КонецФункции

Процедура СохранитьОтпечатокДанныхМонитора(Логин, ДанныеМонитора) Экспорт
	
	Если ДанныеМонитора <> Неопределено
		И ДанныеМонитора.authResult.authenticated Тогда
		Отпечаток = ОтпечатокДанныхМонитора(Логин, ДанныеМонитора);
	Иначе
		Отпечаток = Неопределено;
	КонецЕсли;
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"МониторПортала1СИТС",
		"ОтпечатокДанныхМонитора",
		Лев(Отпечаток, 48));
	
КонецПроцедуры

Функция ДанныеМонитораИзменены(Логин, ДанныеМонитора)
	
	Отпечаток = ОтпечатокДанныхМонитора(Логин, ДанныеМонитора);
	
	Если Отпечаток = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СохраненныйОтпечаток = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"МониторПортала1СИТС",
		"ОтпечатокДанныхМонитора");
	
	Возврат (СохраненныйОтпечаток <> Отпечаток);
	
КонецФункции

Процедура ПроверитьНаличиеНовойИнформацииВФоне(ПараметрыМетода, АдресРезультата) Экспорт
	
	РезультатОперации = ДанныеМонитора();
	Если ПустаяСтрока(РезультатОперации.ИмяОшибки) Тогда
		
		ДанныеМонитора = РезультатОперации.Данные;
		Если ДанныеМонитора.authResult.authenticated Тогда
			
			Если ДанныеМонитора.programName = Неопределено Тогда
				ПоместитьВоВременноеХранилище("НетИзменений", АдресРезультата);
				ЗаписатьИнформациюВЖурналРегистрации(
					НСтр("ru = 'Интернет-поддержка продукта не оказывается.
						|Не удалось проверить наличие новой информации в сервисе Монитора Портала 1С:ИТС.'"));
				Возврат;
			КонецЕсли;
			
			СообщениеОбОшибкеДанных = ОписаниеОшибкиПолученияДанныхМонитора(ДанныеМонитора);
			Если Не ПустаяСтрока(СообщениеОбОшибкеДанных) Тогда
				
				ЗаписатьОшибкуВЖурналРегистрации(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Не удалось проверить изменение информации Монитора Портала 1С:ИТС из-за ошибки получения данных:
							|%1'"),
						СообщениеОбОшибкеДанных));
				ПоместитьВоВременноеХранилище("Ошибка", АдресРезультата);
				
			Иначе
				
				Если ДанныеМонитораИзменены(РезультатОперации.Логин, РезультатОперации.Данные) Тогда
					ПоместитьВоВременноеХранилище("ДанныеИзменены", АдресРезультата);
				Иначе
					ПоместитьВоВременноеХранилище("НетИзменений", АдресРезультата);
				КонецЕсли;
				
			КонецЕсли;
			
		Иначе
			
			ЗаписатьОшибкуВЖурналРегистрации(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось проверить изменение информации Монитора Портала 1С:ИТС.
						|Заполнены некорректные данные аутентификации.
						|%1'"),
					РезультатОперации.ИнформацияОбОшибке));
			ПоместитьВоВременноеХранилище("Ошибка", АдресРезультата);
			
		КонецЕсли;
		
	ИначеЕсли РезультатОперации.ИмяОшибки = "НеЗаполненыДанныеАутентификации" Тогда
		
		ПоместитьВоВременноеХранилище("НетИзменений", АдресРезультата);
		
	Иначе
		
		ЗаписатьОшибкуВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось проверить изменение информации Монитора Портала 1С:ИТС.
					|%1'"),
				РезультатОперации.ИнформацияОбОшибке));
		ПоместитьВоВременноеХранилище("Ошибка", АдресРезультата);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ОписаниеОшибкиПолученияДанныхМонитора(ДанныеМонитора) Экспорт
	
	Результат = "";
	
	Если ДанныеМонитора.supportConditionsImplStatus <> Неопределено
		И ДанныеМонитора.supportConditionsImplStatus.blockStatus <> "200"
		И ДанныеМонитора.supportConditionsImplStatus.blockStatus <> 200 Тогда
		Результат = Результат + ?(ПустаяСтрока(Результат), "", Символы.ПС)
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '- состояние выполнения условий сопровождения (blockStatus: %1);'"),
				ДанныеМонитора.supportConditionsImplStatus.blockStatus);
	КонецЕсли;
	
	Если ДанныеМонитора.serviceContractsStatus <> Неопределено
		И ДанныеМонитора.serviceContractsStatus.blockStatus <> "200"
		И ДанныеМонитора.serviceContractsStatus.blockStatus <> 200 Тогда
		Результат = Результат + ?(ПустаяСтрока(Результат), "", Символы.ПС)
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '- подключение сервисов 1С (blockStatus: %1);'"),
				ДанныеМонитора.serviceContractsStatus.blockStatus);
	КонецЕсли;
	
	Если ДанныеМонитора.updateInfo <> Неопределено
		И ДанныеМонитора.updateInfo.blockStatus <> "200"
		И ДанныеМонитора.updateInfo.blockStatus <> 200 Тогда
		Результат = Результат + ?(ПустаяСтрока(Результат), "", Символы.ПС)
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '- наличие обновления программы (blockStatus: %1);'"),
				ДанныеМонитора.updateInfo.blockStatus);
	КонецЕсли;
	
	Если ДанныеМонитора.patchesInfo <> Неопределено
		И ДанныеМонитора.patchesInfo.blockStatus <> "200"
		И ДанныеМонитора.patchesInfo.blockStatus <> 200 Тогда
		Результат = Результат + ?(ПустаяСтрока(Результат), "", Символы.ПС)
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '- наличие исправлений (патчей) конфигурации (blockStatus: %1);'"),
				ДанныеМонитора.patchesInfo.blockStatus);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаписатьОшибкуВЖурналРегистрации(СообщениеОбОшибке) Экспорт
	
	ЗаписьЖурналаРегистрации(
		ИмяСобытияЖурналаРегистрации(),
		УровеньЖурналаРегистрации.Ошибка,
		,
		,
		СообщениеОбОшибке);
	
КонецПроцедуры

Процедура ЗаписатьПредупреждениеВЖурналРегистрации(СообщениеОбОшибке) Экспорт
	
	ЗаписьЖурналаРегистрации(
		ИмяСобытияЖурналаРегистрации(),
		УровеньЖурналаРегистрации.Предупреждение,
		,
		,
		СообщениеОбОшибке);
	
КонецПроцедуры

Процедура ЗаписатьИнформациюВЖурналРегистрации(СообщениеЖурнала) Экспорт
	
	ЗаписьЖурналаРегистрации(
		ИмяСобытияЖурналаРегистрации(),
		УровеньЖурналаРегистрации.Информация,
		,
		,
		СообщениеЖурнала);
	
КонецПроцедуры

Функция ИмяСобытияЖурналаРегистрации()
	
	Возврат НСтр("ru = 'Монитор Портала 1С:ИТС'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

#Область ВызовОперацийСервиса

Функция ДанныеМонитора() Экспорт
	
	Результат = НовыйРезультатВызоваОперации();
	
	Если Не ДоступноИспользованиеМонитора() Тогда
		ВызватьИсключение НСтр("ru = 'Использование Монитора недоступно в текущем режиме работы.'");
	КонецЕсли;
	
	НастройкиСоединения = ИнтернетПоддержкаПользователей.НастройкиСоединенияССерверами();
	Результат.Вставить("Логин", Неопределено);
	Результат.Вставить("Домен", НастройкиСоединения.ДоменРасположенияСерверовИПП);
	
	ИмяПрограммы                  = Неопределено;
	ДанныеАутентификации          = Неопределено;
	ПередВызовомОперацииСервиса(ИмяПрограммы, ДанныеАутентификации, Результат);
	Если Не ПустаяСтрока(Результат.ИмяОшибки) Тогда
		Возврат Результат;
	КонецЕсли;
	
	ВерсияКонфигурации = ИнтернетПоддержкаПользователей.ВерсияКонфигурации();
	ВерсияПлатформы    = ИнтернетПоддержкаПользователей.ТекущаяВерсияПлатформы1СПредприятие();
	ПараметрыОбновления = Неопределено;
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы") Тогда
		МодульПолучениеОбновленийПрограммы = ОбщегоНазначения.ОбщийМодуль("ПолучениеОбновленийПрограммы");
		ПараметрыОбновления = МодульПолучениеОбновленийПрограммы.ПараметрыПолученияОбновлений();
		Если ПараметрыОбновления.ПолучатьИсправления Тогда
			// Для пользователей с ограниченными правами,
			// информация о расширениях должна отображаться
			// в Мониторе Портала 1С:ИТС.
			УстановитьПривилегированныйРежим(Истина);
			ПараметрыОбновления.Вставить("УстановленныеИсправления",
				МодульПолучениеОбновленийПрограммы.ИдентификаторыУстановленныхИсправлений());
			УстановитьПривилегированныйРежим(Ложь);
		Иначе
			ПараметрыОбновления.Вставить("УстановленныеИсправления", Неопределено);
		КонецЕсли;
	КонецЕсли;
	
	ВызватьОперациюДанныеМонитора(
		ДанныеАутентификации,
		НастройкиСоединения.ДоменРасположенияСерверовИПП,
		ИмяПрограммы,
		ВерсияКонфигурации,
		ВерсияПлатформы,
		ПараметрыОбновления,
		Результат);
	
	Если Не ПустаяСтрока(Результат.ИмяОшибки) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Результат.Данные.Вставить("ДоступноОбновление", Ложь);
	Если Результат.Данные.updateInfo <> Неопределено Тогда
		Результат.Данные.ДоступноОбновление = Результат.Данные.ДоступноОбновление Или Результат.Данные.updateInfo.updateAvailable;
	КонецЕсли;
	Если Результат.Данные.patchesInfo <> Неопределено Тогда
		Результат.Данные.ДоступноОбновление = Результат.Данные.ДоступноОбновление Или Результат.Данные.patchesInfo.patchesAvailable;
	КонецЕсли;
	
	Если Результат.Данные = Неопределено Тогда
		Результат.ИмяОшибки          = "Ошибка";
		Результат.СообщениеОбОшибке  = НСтр("ru = 'Некорректный (пустой) ответ сервиса.'");
		Результат.ИнформацияОбОшибке = Результат.СообщениеОбОшибке;
		Возврат Результат;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ДеталиДанныхМонитора(
	Логин,
	Договоры1СИТС,
	АктивацияСервисовСопровождения,
	ДоговорыНаСервисы) Экспорт
	
	Результат = НовыйРезультатВызоваОперации();
	
	Если Не ДоступноИспользованиеМонитора() Тогда
		ВызватьИсключение НСтр("ru = 'Использование Монитора недоступно в текущем режиме работы.'");
	КонецЕсли;
	
	ИмяПрограммы         = Неопределено;
	ДанныеАутентификации = Неопределено;
	ПередВызовомОперацииСервиса(ИмяПрограммы, ДанныеАутентификации, Результат);
	Если Не ПустаяСтрока(Результат.ИмяОшибки) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если НРег(СокрЛП(Логин)) <> НРег(СокрЛП(ДанныеАутентификации.Логин)) Тогда
		Результат.ИмяОшибки          = "ИзмененыДанныеАутентификации";
		Результат.СообщениеОбОшибке  = НСтр("ru = 'Изменились данные аутентификации пользователя Интернет-поддержки.
			|Обновите содержимое Монитора.'");
		Результат.ИнформацияОбОшибке = Результат.СообщениеОбОшибке;
		Возврат Результат;
	КонецЕсли;
	
	ВызватьОперациюДеталиДанныхМонитора(
		ДанныеАутентификации,
		ИмяПрограммы,
		Договоры1СИТС,
		АктивацияСервисовСопровождения,
		ДоговорыНаСервисы,
		Результат);
	
	Если Не ПустаяСтрока(Результат.ИмяОшибки) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если Результат.Данные = Неопределено Тогда
		Результат.ИмяОшибки          = "Ошибка";
		Результат.СообщениеОбОшибке  = НСтр("ru = 'Некорректный (пустой) ответ сервиса.'");
		Результат.ИнформацияОбОшибке = Результат.СообщениеОбОшибке;
		Возврат Результат;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ПередВызовомОперацииСервиса(ИмяПрограммы, ДанныеАутентификации, РезультатОперации)
	
	ИмяПрограммы = ИнтернетПоддержкаПользователей.СлужебнаяИмяПрограммы();
	Если ИмяПрограммы = "Unknown" Тогда
		РезультатОперации.ИмяОшибки = "НеЗаполненоИмяПрограммы";
		РезультатОперации.СообщениеОбОшибке  = НСтр("ru = 'Не заполнено имя программы.'");
		РезультатОперации.ИнформацияОбОшибке =
			НСтр("ru = 'Не заполнено имя программы см. свойство ИдентификаторИнтернетПоддержки в методе ПриДобавленииПодсистемы().'");
	КонецЕсли;
	
	Если ДанныеАутентификации = Неопределено Тогда
		УстановитьПривилегированныйРежим(Истина);
		ДанныеАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Если ДанныеАутентификации = Неопределено Тогда
		РезультатОперации.ИмяОшибки = "НеЗаполненыДанныеАутентификации";
		РезультатОперации.СообщениеОбОшибке = НСтр("ru = 'Не заполнены данные аутентификации.'");
		РезультатОперации.ИнформацияОбОшибке = РезультатОперации.СообщениеОбОшибке;
		Возврат;
	ИначеЕсли РезультатОперации.Свойство("Логин") Тогда
		РезультатОперации.Логин = ДанныеАутентификации.Логин;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВызватьОперациюДанныеМонитора(
	ДанныеАутентификации,
	Домен,
	ИмяПрограммы,
	ВерсияКонфигурации,
	ВерсияПлатформы,
	ПолучитьИнформациюОбОбновлении,
	Результат)
	
	URLОперации = URLОперацииСервиса("monitor", Домен) + "/" + ИмяПрограммы;
	ТелоЗапроса = НовыйТелоЗапросаСодержимоеМонитора(
		ДанныеАутентификации,
		ВерсияКонфигурации,
		ВерсияПлатформы,
		ПолучитьИнформациюОбОбновлении);
	
	ТелоОтвета = "";
	ВызватьОперациюСервиса(URLОперации, Домен, ТелоЗапроса, Результат, ТелоОтвета);
	
	Если Не ПустаяСтрока(Результат.ИмяОшибки) Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(ТелоОтвета);
		Результат.Данные = ПрочитатьJSON(ЧтениеJSON);
		ЧтениеJSON.Закрыть();
		
		Если Результат.Данные.authResult.blockStatus = "429" Или Результат.Данные.authResult.blockStatus = 429 Тогда
			Результат.ИмяОшибки         = "Ошибка";
			Результат.СообщениеОбОшибке = НСтр("ru = 'Превышено количество попыток аутентификации с некорректным логином или паролем.
				|Проверьте правильность логина и пароля и повторите попытку через 30 минут.'");
			Результат.ИнформацияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при вызове операции %1 сервиса Монитора Портала 1С:ИТС.
					|Сервис сообщил об ошибке - authResult.blockStatus: %2'"),
				URLОперации,
				Результат.Данные.authResult.blockStatus);
		ИначеЕсли (Результат.Данные.authResult.blockStatus <> "200" И Результат.Данные.authResult.blockStatus <> 200) Тогда
			Результат.ИмяОшибки         = "ВнутренняяОшибкаСервиса";
			Результат.СообщениеОбОшибке = НСтр("ru = 'Внутренняя ошибка сервиса.
				|Повторите попытку подключения позднее.'");
			Результат.ИнформацияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при вызове операции %1 сервиса Монитора Портала 1С:ИТС.
					|Сервис сообщил об ошибке - authResult.blockStatus: %2'"),
				URLОперации,
				Результат.Данные.authResult.blockStatus);
		КонецЕсли;
		
	Исключение
		
		ПриОшибкеОбработкиОтветаСервиса(ИнформацияОбОшибке(), URLОперации, ТелоОтвета, Результат);
		
	КонецПопытки;
	
КонецПроцедуры

Процедура ВызватьОперациюДеталиДанныхМонитора(
	ДанныеАутентификации,
	ИмяПрограммы,
	Договоры1СИТС,
	АктивацияСервисовСопровождения,
	ДоговорыНаСервисы,
	Результат)
	
	НастройкиСоединения = ИнтернетПоддержкаПользователей.НастройкиСоединенияССерверами();
	URLОперации = URLОперацииСервиса("support-info", НастройкиСоединения.ДоменРасположенияСерверовИПП)
		+ "/" + ИмяПрограммы;
	ТелоЗапроса = НовыйТелоЗапросаДеталиМонитора(
		ДанныеАутентификации,
		Договоры1СИТС,
		АктивацияСервисовСопровождения,
		ДоговорыНаСервисы);
	
	ТелоОтвета = "";
	
	ВызватьОперациюСервиса(URLОперации, НастройкиСоединения.ДоменРасположенияСерверовИПП, ТелоЗапроса, Результат, ТелоОтвета);
	
	Если Не ПустаяСтрока(Результат.ИмяОшибки) Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(ТелоОтвета);
		
		ИменаСвойствСоЗначениямиДата = Новый Массив;
		ИменаСвойствСоЗначениямиДата.Добавить("from");
		ИменаСвойствСоЗначениямиДата.Добавить("to");
		Результат.Данные = ПрочитатьJSON(ЧтениеJSON, , ИменаСвойствСоЗначениямиДата, ФорматДатыJSON.ISO);
		ЧтениеJSON.Закрыть();
		
		// Проверка состояния получения данных в сервисе.
		ОшибкаСервисаПриПолученииДанных = Ложь;
		Если (Договоры1СИТС Или АктивацияСервисовСопровождения)
			И Результат.Данные.supportConditionsImplStatus.blockStatus <> "200"
			И Результат.Данные.supportConditionsImplStatus.blockStatus <> 200 Тогда
			
			ОшибкаСервисаПриПолученииДанных = Истина;
			Результат.ИнформацияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при вызове операции %1 сервиса Монитора Портала 1С:ИТС.
					|Сервис сообщил об ошибке - supportConditionsImplStatus.blockStatus: %2'"),
				URLОперации,
				Результат.Данные.supportConditionsImplStatus.blockStatus);
			
		ИначеЕсли Договоры1СИТС
			И Результат.Данные.itsContracts <> Неопределено
			И Результат.Данные.itsContracts.blockStatus <> "200"
			И Результат.Данные.itsContracts.blockStatus <> 200 Тогда
			
			ОшибкаСервисаПриПолученииДанных = Истина;
			Результат.ИнформацияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при вызове операции %1 сервиса Монитора Портала 1С:ИТС.
					|Сервис сообщил об ошибке - itsContracts.blockStatus: %2'"),
				URLОперации,
				Результат.Данные.itsContracts.blockStatus);
			
		ИначеЕсли АктивацияСервисовСопровождения
			И Результат.Данные.supportServiceActivations <> Неопределено
			И Результат.Данные.supportServiceActivations.blockStatus <> "200"
			И Результат.Данные.supportServiceActivations.blockStatus <> 200 Тогда
			
			ОшибкаСервисаПриПолученииДанных = Истина;
			Результат.ИнформацияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при вызове операции %1 сервиса Монитора Портала 1С:ИТС.
					|Сервис сообщил об ошибке - supportServiceActivations.blockStatus: %2'"),
				URLОперации,
				Результат.Данные.supportServiceActivations.blockStatus);
			
		ИначеЕсли ДоговорыНаСервисы
			И Результат.Данные.serviceContractsStatus.blockStatus <> "200"
			И Результат.Данные.serviceContractsStatus.blockStatus <> 200 Тогда
			
			ОшибкаСервисаПриПолученииДанных = Истина;
			Результат.ИнформацияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при вызове операции %1 сервиса Монитора Портала 1С:ИТС.
					|Сервис сообщил об ошибке - serviceContractsStatus.blockStatus: %2'"),
				URLОперации,
				Результат.Данные.serviceContractsStatus.blockStatus);
			
		ИначеЕсли ДоговорыНаСервисы
			И Результат.Данные.serviceContracts <> Неопределено
			И Результат.Данные.serviceContracts.blockStatus <> "200"
			И Результат.Данные.serviceContracts.blockStatus <> 200 Тогда
			
			ОшибкаСервисаПриПолученииДанных = Истина;
			Результат.ИнформацияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при вызове операции %1 сервиса Монитора Портала 1С:ИТС.
					|Сервис сообщил об ошибке - serviceContracts.blockStatus: %2'"),
				URLОперации,
				Результат.Данные.serviceContracts.blockStatus);
			
		КонецЕсли;
		
		Если ОшибкаСервисаПриПолученииДанных Тогда
			Результат.ИмяОшибки = "ВнутренняяОшибкаСервиса";
			Результат.СообщениеОбОшибке = НСтр("ru = 'Внутренняя ошибка сервиса.
				|Повторите попытку подключения позднее.'");
		КонецЕсли;
		
	Исключение
		
		ПриОшибкеОбработкиОтветаСервиса(ИнформацияОбОшибке(), URLОперации, ТелоОтвета, Результат);
		
	КонецПопытки;
	
КонецПроцедуры

Функция НовыйТелоЗапросаСодержимоеМонитора(
	ДанныеАутентификации,
	ВерсияКонфигурации,
	ВерсияПлатформы,
	ПараметрыОбновления)
	
	ЗаписьДанныхСообщения = Новый ЗаписьJSON;
	ЗаписьДанныхСообщения.УстановитьСтроку();
	ЗаписьДанныхСообщения.ЗаписатьНачалоОбъекта();
	
	ЗаписатьДанныеАутентификации(ЗаписьДанныхСообщения, ДанныеАутентификации);
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("programVersion");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(ВерсияКонфигурации);
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("platformVersion");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(ВерсияПлатформы);
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("getUpdateAvailabilityStatus");
	ЗаписьДанныхСообщения.ЗаписатьЗначение((ПараметрыОбновления <> Неопределено));
	Если ПараметрыОбновления <> Неопределено Тогда
		
		ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("getOnlyPlatformUpdateAvailabilityStatus");
		ЗаписьДанныхСообщения.ЗаписатьЗначение(Не ПараметрыОбновления.ПолучатьОбновленияКонфигурации);
		
		Если ПараметрыОбновления.ПолучатьИсправления Тогда
			
			ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("patchParameters");
			
			ЗаписьДанныхСообщения.ЗаписатьНачалоОбъекта();
			ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("checkPatchesUpdates");
			ЗаписьДанныхСообщения.ЗаписатьЗначение(ПараметрыОбновления.ПолучатьИсправления);
			ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("installedPatches");
			ЗаписьДанныхСообщения.ЗаписатьНачалоМассива();
			Для Каждого ИдентификаторИсправления Из ПараметрыОбновления.УстановленныеИсправления Цикл
				ЗаписьДанныхСообщения.ЗаписатьЗначение(Строка(ИдентификаторИсправления));
			КонецЦикла;
			ЗаписьДанныхСообщения.ЗаписатьКонецМассива();
			
			ЗаписьДанныхСообщения.ЗаписатьКонецОбъекта();
			
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("params");
	ЗаписатьДополнительныеПараметрыЗапроса(ЗаписьДанныхСообщения);
	
	ЗаписьДанныхСообщения.ЗаписатьКонецОбъекта();
	
	Возврат ЗаписьДанныхСообщения.Закрыть();
	
КонецФункции

Функция НовыйТелоЗапросаДеталиМонитора(
	ДанныеАутентификации,
	Договоры1СИТС,
	АктивацияСервисовСопровождения,
	ДоговорыНаСервисы)
	
	ЗаписьДанныхСообщения = Новый ЗаписьJSON;
	ЗаписьДанныхСообщения.УстановитьСтроку();
	ЗаписьДанныхСообщения.ЗаписатьНачалоОбъекта();
	
	ЗаписатьДанныеАутентификации(ЗаписьДанныхСообщения, ДанныеАутентификации);
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("getItsContracts");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(Договоры1СИТС);
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("getSupportServiceActivations");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(АктивацияСервисовСопровождения);
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("getServiceContracts");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(ДоговорыНаСервисы);
	
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("params");
	ЗаписатьДополнительныеПараметрыЗапроса(ЗаписьДанныхСообщения);
	
	ЗаписьДанныхСообщения.ЗаписатьКонецОбъекта();
	
	Возврат ЗаписьДанныхСообщения.Закрыть();
	
КонецФункции

Процедура ЗаписатьДанныеАутентификации(ЗаписьДанныхСообщения, ДанныеАутентификации)
	
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("auth");
	ЗаписьДанныхСообщения.ЗаписатьНачалоОбъекта();
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("login");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(ДанныеАутентификации.Логин);
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("password");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(ДанныеАутентификации.Пароль);
	ЗаписьДанныхСообщения.ЗаписатьКонецОбъекта();
	
КонецПроцедуры

Процедура ЗаписатьДополнительныеПараметрыЗапроса(ЗаписьПараметровЗапроса)
	
	ДопПараметрыЗапроса = ИнтернетПоддержкаПользователей.ДополнительныеПараметрыВызоваОперацииСервиса(Ложь);
	
	ЗаписьПараметровЗапроса.ЗаписатьНачалоОбъекта();
	
	ТипСтрока = Тип("Строка");
	ТипЧисло  = Тип("Число");
	ТипБулево = Тип("Булево");
	ТипДата   = Тип("Дата");
	Для Каждого КлючЗначение Из ДопПараметрыЗапроса Цикл
		ЗаписьПараметровЗапроса.ЗаписатьИмяСвойства(КлючЗначение.Ключ);
		Если КлючЗначение.Значение = Неопределено Тогда
			ЗаписьПараметровЗапроса.ЗаписатьЗначение(Неопределено);
		Иначе
			ТипЗнчПараметра = ТипЗнч(КлючЗначение.Значение);
			Если ТипЗнчПараметра = ТипСтрока
				Или ТипЗнчПараметра = ТипЧисло
				Или ТипЗнчПараметра = ТипБулево Тогда
				ЗаписьПараметровЗапроса.ЗаписатьЗначение(КлючЗначение.Значение);
			ИначеЕсли ТипЗнчПараметра = ТипДата Тогда
				ЗаписьПараметровЗапроса.ЗаписатьЗначение(ЗаписатьДатуJSON(КлючЗначение.Значение, ФорматДатыJSON.ISO));
			Иначе
				ЗаписьПараметровЗапроса.ЗаписатьЗначение(Строка(КлючЗначение.Значение));
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ЗаписьПараметровЗапроса.ЗаписатьКонецОбъекта();
	
КонецПроцедуры

Процедура ВызватьОперациюСервиса(URLОперации, Домен, ТелоЗапроса, Результат, ТелоОтвета)
	
	ПроверитьДоступностьСервиса(Домен, Результат);
	Если Не ПустаяСтрока(Результат.ИмяОшибки) Тогда
		Возврат;
	КонецЕсли;
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	ПараметрыПолученияСодержимого = Новый Структура;
	ПараметрыПолученияСодержимого.Вставить("Метод"                   , "POST");
	ПараметрыПолученияСодержимого.Вставить("ФорматОтвета"            , 1);
	ПараметрыПолученияСодержимого.Вставить("Заголовки"               , Заголовки);
	ПараметрыПолученияСодержимого.Вставить("ДанныеДляОбработки"      , ТелоЗапроса);
	ПараметрыПолученияСодержимого.Вставить("ФорматДанныхДляОбработки", 1);
	ПараметрыПолученияСодержимого.Вставить("Таймаут"                 , 60);
	
	РезультатЗагрузкиСодержимого = ИнтернетПоддержкаПользователей.ЗагрузитьСодержимоеИзИнтернет(
		URLОперации,
		,
		,
		ПараметрыПолученияСодержимого);
	
	Результат.КодСостояния = РезультатЗагрузкиСодержимого.КодСостояния;
	
	Если ПустаяСтрока(РезультатЗагрузкиСодержимого.КодОшибки) Тогда
		
		ТелоОтвета = РезультатЗагрузкиСодержимого.Содержимое;
		
		ДлинаТелаОтвета = СтрДлина(ТелоОтвета);
		Если ДлинаТелаОтвета > 100000 Тогда
			
			Результат.ИмяОшибки         = "ВнутренняяОшибкаСервиса";
			Результат.СообщениеОбОшибке = НСтр("ru = 'Некорректный ответ сервиса.'");
			Результат.ИнформацияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Превышена допустимая длина тела ответа 100000 символов.
					|Длина тела ответа: %1 символов.'"),
				ДлинаТелаОтвета);
			
		КонецЕсли;
		
	Иначе
		
		ПриОшибкеВызоваОперацииСервиса(РезультатЗагрузкиСодержимого, URLОперации, Результат);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОшибкеОбработкиОтветаСервиса(ИнформацияОбОшибке, URLОперации, ТелоОтвета, Результат)
	
	Результат.ИнформацияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Ошибка при вызове операции %1 сервиса Монитора Портала 1С:ИТС.
			|Ошибка при обработке ответа сервиса. %2
			|Тело ответа: %3'"),
		URLОперации,
		ПодробноеПредставлениеОшибки(ИнформацияОбОшибке),
		Лев(ТелоОтвета, 5120));
	
	Результат.ИмяОшибки         = "ВнутренняяОшибкаСервиса";
	Результат.СообщениеОбОшибке = НСтр("ru = 'Некорректный ответ сервиса.'");
	
КонецПроцедуры

Процедура ПриОшибкеВызоваОперацииСервиса(РезультатЗагрузкиСодержимого, URLОперации, Результат)
	
	ШапкаИнформацииОбОшибке =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка при вызове операции %1 сервиса Монитора Портала 1С:ИТС.'"),
			URLОперации);
	
	Если РезультатЗагрузкиСодержимого.КодОшибки = "ConnectError" Тогда
		
		Результат.ИмяОшибки = "ОшибкаСоединения";
		Результат.СообщениеОбОшибке =
			НСтр("ru = 'Ошибка соединения с сервисом.'")
			+ Символы.ПС
			+ РезультатЗагрузкиСодержимого.СообщениеОбОшибке;
		
	ИначеЕсли  РезультатЗагрузкиСодержимого.КодОшибки = "ConnectError" Тогда
		
		Результат.ИмяОшибки = "ВнутренняяОшибкаСервиса";
		Результат.СообщениеОбОшибке = НСтр("ru = 'В сервисе возникли неполадки.'")
			+ Символы.ПС
			+ РезультатЗагрузкиСодержимого.СообщениеОбОшибке;
		
	ИначеЕсли РезультатЗагрузкиСодержимого.КодСостояния = 401
		Или РезультатЗагрузкиСодержимого.КодСостояния = 403 Тогда
		
		Результат.ИмяОшибки = "НекорректныеДанныеАутентификации";
		Если ПустаяСтрока(Результат.СообщениеОбОшибке) Тогда
			Результат.СообщениеОбОшибке = НСтр("ru = 'Неверный логин или пароль пользователя Интернет-поддержки.'");
		КонецЕсли;
		
	ИначеЕсли РезультатЗагрузкиСодержимого.КодСостояния = 429 Тогда
		
		Результат.ИмяОшибки = "Ошибка";
		Если ПустаяСтрока(Результат.СообщениеОбОшибке) Тогда
			Результат.СообщениеОбОшибке = НСтр("ru = 'Превышено количество попыток аутентификации с некорректным логином или паролем.
			|Проверьте правильность логина и пароля и повторите попытку через 30 минут.'");
		КонецЕсли;
		
	Иначе
		
		Результат.ИмяОшибки = "Ошибка";
		Результат.СообщениеОбОшибке = РезультатЗагрузкиСодержимого.СообщениеОбОшибке;
		
	КонецЕсли;
	
	Результат.ИнформацияОбОшибке = ШапкаИнформацииОбОшибке
		+ Символы.ПС + Результат.СообщениеОбОшибке
		+ Символы.ПС + РезультатЗагрузкиСодержимого.ИнформацияОбОшибке;
	
КонецПроцедуры

Функция НовыйРезультатВызоваОперации()
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяОшибки"         , "");
	Результат.Вставить("СообщениеОбОшибке" , "");
	Результат.Вставить("ИнформацияОбОшибке", "");
	Результат.Вставить("КодСостояния"      , 0);
	Результат.Вставить("Данные"            , Неопределено);
	
	Возврат Результат;
	
КонецФункции

Процедура ПроверитьДоступностьСервиса(Домен, РезультатОперации)
	
	URLОперацииPing = URLОперацииСервиса("ping", Домен);
	РезультатПроверки = ИнтернетПоддержкаПользователей.ПроверитьURLДоступен(URLОперацииPing);
	
	Если ПустаяСтрока(РезультатПроверки.ИмяОшибки) Тогда
		
		Возврат;
		
	ИначеЕсли РезультатПроверки.ИмяОшибки = "ConnectError" Тогда
		
		РезультатОперации.ИмяОшибки = "ОшибкаСоединения";
		РезультатОперации.СообщениеОбОшибке =
			РезультатПроверки.СообщениеОбОшибке
			+ Символы.ПС
			+ НСтр("ru = 'Проверьте настройки подключения к сети Интернет.'");
		
	ИначеЕсли РезультатПроверки.ИмяОшибки = "ServerError" Тогда
		
		РезультатОперации.ИмяОшибки = "СервисВременноНедоступен";
		РезультатОперации.СообщениеОбОшибке = РезультатПроверки.СообщениеОбОшибке;
		
	Иначе
		
		РезультатОперации.ИмяОшибки = "Ошибка"; // Прочие ошибки.
		РезультатОперации.СообщениеОбОшибке =
			НСтр("ru = 'Не удалось подключиться к сервису.'")
			+ Символы.ПС
			+ РезультатПроверки.СообщениеОбОшибке;
		
	КонецЕсли;
	
	РезультатОперации.ИнформацияОбОшибке = НСтр("ru = 'Не удалось проверить доступность сервиса.'")
		+ Символы.ПС + РезультатПроверки.ИнформацияОбОшибке;
	
КонецПроцедуры

Функция ХостСервиса(Домен)
	
	
	Возврат ?(Домен = 0, "portal-monitor.1c.ru", "portal-monitor.1c.eu");
	
КонецФункции

Функция URLОперацииСервиса(Операция, Домен)
	
	Возврат "https://"
		+ ХостСервиса(Домен)
		+ "/rest/public/"
		+ Операция;
	
КонецФункции

#КонецОбласти

#КонецОбласти

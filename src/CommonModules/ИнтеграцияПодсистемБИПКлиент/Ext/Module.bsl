﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ИнтеграцияПодсистемБИП.
//
// Клиентские процедуры и функции интеграции с БСП и БИП:
//  - Подписка на события БСП;
//  - Обработка событий БСП в подсистемах БИП;
//  - Определение списка возможных подписок в БИП;
//  - Вызов методов БСП, на которые выполнена подписка;
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.БазоваяФункциональность

// Обработка программных событий, возникающих в подсистемах БСП.
// Только для вызовов из библиотеки БСП в БИП.

// Определяет события, на которые подписана эта библиотека.
//
// Параметры:
//  Подписки - Структура - См. ИнтеграцияПодсистемБСПКлиент.СобытияБСП.
//
Процедура ПриОпределенииПодписокНаСобытияБСП(Подписки) Экспорт
	
	// Варианты отчетов
	Подписки.ПриОбработкеВыбораТабличногоДокумента = Истина;
	Подписки.ПриОбработкеРасшифровки = Истина;
	
КонецПроцедуры

#Область НастройкиПрограммы

// Выполняет команду подключения Интернет-поддержки пользователей
// на панели администрирования "Интернет-поддержка и сервисы" (БСП).
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, из которой вызывается команда;
//  Команда - КомандаФормы - выполняемая команда.
//
Процедура ИнтернетПоддержкаИСервисы_БИПВойтиИлиВыйти(Форма, Команда) Экспорт
	
	Если Форма.БИПДанныеАутентификации = Неопределено Тогда
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(, Форма);
	Иначе
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"ПриОтветеНаВопросОВыходеИзИнтернетПоддержки",
				ЭтотОбъект,
				Форма),
			НСтр("ru = 'Логин и пароль для подключения к сервисам Интернет-поддержки пользователей будут удалены из программы.
				|Отключить Интернет-поддержку?'"),
			РежимДиалогаВопрос.ДаНет,
			,
			КодВозвратаДиалога.Нет,
			НСтр("ru = 'Выход из Интернет-поддержки пользователей'"));
	КонецЕсли;
	
КонецПроцедуры

// Выполняет обработку оповещения на панели администрирования
// "Интернет-поддержка и сервисы" (БСП).
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - форма, в которой обрабатывается оповещение;
//	ИмяСобытия - Строка - имя события;
//	Параметр - Произвольный - параметр;
//	Источник - Произвольный - источник события.
//
Процедура ИнтернетПоддержкаИСервисы_ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ИмяСобытия = "ИнтернетПоддержкаПодключена" Тогда
		
		// Обработка подключения Интернет-поддержки.
		ВведенныеДанныеАутентификации = Параметр;
		Если ВведенныеДанныеАутентификации <> Неопределено Тогда
			Форма.БИПДанныеАутентификации = ВведенныеДанныеАутентификации;
			ИнтернетПоддержкаПользователейКлиентСервер.ОтобразитьСостояниеПодключенияИПП(Форма);
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.РаботаСКлассификаторами") Тогда
		МодульРаботаСКлассификаторамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСКлассификаторамиКлиент");
		МодульРаботаСКлассификаторамиКлиент.ИнтернетПоддержкаИСервисы_ОбработкаОповещения(
			Форма,
			ИмяСобытия,
			Параметр,
			Источник);
	КонецЕсли;

КонецПроцедуры

// Выполняет обработку навигационных ссылок на панели администрирования
// "Интернет-поддержка и сервисы" (БСП).
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - форма, в которой обрабатывается оповещение;
//	Элемент - ДекорацияФормы - декорация на форме;
//	НавигационнаяСсылкаФорматированнойСтроки - Строка - навигационная ссылка;
//	СтандартнаяОбработка - Булево - признак стандартной обработки.
//
Процедура ИнтернетПоддержкаИСервисы_ДекорацияОбработкаНавигационнойСсылки(Форма, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	Если Элемент.Имя = "ДекорацияЛогинИПП" Тогда
		СтандартнаяОбработка = Ложь;
		ИнтернетПоддержкаПользователейКлиент.ОткрытьЛичныйКабинетПользователя();
	КонецЕсли;
	
КонецПроцедуры

// Обработчик команды БИПСообщениеВСлужбуТехническойПоддержки
// на форме панели администрирования "Интернет-поддержка и сервисы"
// Библиотеки стандартных подсистем.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - форма панели администрирования;
//	Команда - КомандаФормы - команда на панели администрирования.
//
Процедура ИнтернетПоддержкаИСервисы_СообщениеВСлужбуТехническойПоддержки(Форма, Команда) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СообщенияВСлужбуТехническойПоддержки") Тогда
		
		ДанныеСообщения = Новый Структура;
		ДанныеСообщения.Вставить("Получатель", "webIts");
		ДанныеСообщения.Вставить("Тема",       НСтр("ru = 'Интернет-поддержка пользователей'"));
		ДанныеСообщения.Вставить("Сообщение",  НСтр("ru = '<Заполните текст сообщения>'"));
		
		МодульСообщенияВСлужбуТехническойПоддержкиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СообщенияВСлужбуТехническойПоддержкиКлиент");
		МодульСообщенияВСлужбуТехническойПоддержкиКлиент.ОтправитьСообщение(
			ДанныеСообщения);
		
	Иначе
		
		ИнтернетПоддержкаПользователейКлиент.ОтправитьСообщениеВТехПоддержку(
			НСтр("ru = 'Интернет-поддержка пользователей'"),
			НСтр("ru = '<Заполните текст сообщения>'"));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВариантыОтчетов

// См. ОтчетыКлиентПереопределяемый.ОбработкаВыбораТабличногоДокумента.
//
Процедура ПриОбработкеВыбораТабличногоДокумента(ФормаОтчета, Элемент, Область, СтандартнаяОбработка) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СПАРКРиски") Тогда
		МодульСПАРКРискиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СПАРКРискиКлиент");
		МодульСПАРКРискиКлиент.ПриОбработкеВыбораТабличногоДокумента(
			ФормаОтчета,
			Элемент,
			Область,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// См. ОтчетыКлиентПереопределяемый.ОбработкаРасшифровки.
//
Процедура ПриОбработкеРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СПАРКРиски") Тогда
		МодульСПАРКРискиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СПАРКРискиКлиент");
		МодульСПАРКРискиКлиент.ПриОбработкеРасшифровки(
			ФормаОтчета,
			Элемент,
			Расшифровка,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.БазоваяФункциональность

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область БазоваяФункциональность

// См. ИнтернетПоддержкаПользователейКлиентПереопределяемый.ОткрытьИнтернетСтраницу.
//
Процедура ОткрытьИнтернетСтраницу(АдресСтраницы, ЗаголовокОкна, СтандартнаяОбработка) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ОткрытьИнтернетСтраницу Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ОткрытьИнтернетСтраницу(
			АдресСтраницы,
			ЗаголовокОкна,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ИнтеграцияСПлатежнымиСистемами

// См. ИнтеграцияСПлатежнымиСистемамиКлиентПереопределяемый.ПриОткрытииФормыНастроекИнтеграции.
//
Процедура ПриОткрытииФормыНастроекИнтеграции(Владелец, НастройкаИнтеграции, ОписаниеОповещения) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ПриОткрытииФормыНастроекИнтеграции Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ПриОткрытииФормыНастроекИнтеграции(
			Владелец,
			НастройкаИнтеграции,
			ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область МониторПортала1СИТС

// См. МониторПортала1СИТСКлиентПереопределяемый.ПередПолучениемДанныхМонитора.
//
Процедура ПередПолучениемДанныхМонитора(Форма) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ПередПолучениемДанныхМонитора Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ПередПолучениемДанныхМонитора(
			Форма);
	КонецЕсли;
	
КонецПроцедуры

// См. МониторПортала1СИТСКлиентПереопределяемый.ОбработатьКомандуВФормеМонитора.
//
Процедура ОбработатьКомандуВФормеМонитора(Форма, Команда) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ОбработатьКомандуВФормеМонитора Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ОбработатьКомандуВФормеМонитора(
			Форма,
			Команда);
	КонецЕсли;
	
КонецПроцедуры

// См. МониторПортала1СИТСКлиентПереопределяемый.ПриНажатииДекорацииВФормеМонитора.
//
Процедура ПриНажатииДекорацииВФормеМонитора(Форма, Элемент) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ПриНажатииДекорацииВФормеМонитора Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ПриНажатииДекорацииВФормеМонитора(
			Форма,
			Элемент);
	КонецЕсли;
	
КонецПроцедуры

// См. МониторПортала1СИТСКлиентПереопределяемый.ОбработатьНавигационнуюСсылкуВФормеМонитора.
//
Процедура ОбработатьНавигационнуюСсылкуВФормеМонитора(
	Форма,
	Элемент,
	НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ОбработатьНавигационнуюСсылкуВФормеМонитора Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ОбработатьНавигационнуюСсылкуВФормеМонитора(
			Форма,
			Элемент,
			НавигационнаяСсылкаФорматированнойСтроки,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// См. МониторПортала1СИТСКлиентПереопределяемый.ПриВыполненииОбработчикаОжиданияВФормеМонитора.
//
Процедура ПриВыполненииОбработчикаОжиданияВФормеМонитора(Форма) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ПриВыполненииОбработчикаОжиданияВФормеМонитора Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ПриВыполненииОбработчикаОжиданияВФормеМонитора(
			Форма);
	КонецЕсли;
	
КонецПроцедуры

// См. МониторПортала1СИТСКлиентПереопределяемый.ПриЗакрытииФормыМонитора.
//
Процедура ПриЗакрытииФормыМонитора(Форма, ЗавершениеРаботы) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ПриЗакрытииФормыМонитора Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ПриЗакрытииФормыМонитора(
			Форма,
			ЗавершениеРаботы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПолучениеОбновленийПрограммы

// См. ПолучениеОбновленийПрограммыКлиент.ПриОпределенииНеобходимостиПоказаОповещенийОДоступныхОбновлениях.
//
Процедура ПриОпределенииНеобходимостиПоказаОповещенийОДоступныхОбновлениях(Использование) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ПриОпределенииНеобходимостиПоказаОповещенийОДоступныхОбновлениях Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ПриОпределенииНеобходимостиПоказаОповещенийОДоступныхОбновлениях(Использование);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СПАРКРиски

// См. СПАРКРискиКлиентПереопределяемый.ОбработкаНавигационнойСсылки.
//
Процедура ОбработкаНавигационнойСсылкиСПАРКРиски(
		Форма,
		ЭлементФормы,
		НавигационнаяСсылка,
		СтандартнаяОбработкаФормой,
		СтандартнаяОбработкаБиблиотекой) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ОбработкаНавигационнойСсылкиСПАРКРиски Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ОбработкаНавигационнойСсылкиСПАРКРиски(
			Форма,
			ЭлементФормы,
			НавигационнаяСсылка,
			СтандартнаяОбработкаФормой,
			СтандартнаяОбработкаБиблиотекой);
	КонецЕсли;
	
КонецПроцедуры

// См. СПАРКРискиКлиентПереопределяемый.ОбработкаОповещения.
//
Процедура ОбработкаОповещенияСПАРКРиски(
		Форма,
		КонтрагентОбъект,
		ИмяСобытия,
		Параметр,
		Источник,
		СтандартнаяОбработкаБиблиотекой) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ОбработкаОповещенияСПАРКРиски Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ОбработкаОповещенияСПАРКРиски(
			Форма,
			КонтрагентОбъект,
			ИмяСобытия,
			Параметр,
			Источник,
			СтандартнаяОбработкаБиблиотекой);
	КонецЕсли;
	
КонецПроцедуры

// См. СПАРКРискиКлиентПереопределяемый.ПереопределитьПараметрыПроверкиФоновыхЗаданий.
//
Процедура ПереопределитьПараметрыПроверкиФоновыхЗаданийСПАРКРиски(
		КоличествоПроверок,
		ИнтервалПроверки) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ПереопределитьПараметрыПроверкиФоновыхЗаданийСПАРКРиски Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ПереопределитьПараметрыПроверкиФоновыхЗаданийСПАРКРиски(
			КоличествоПроверок,
			ИнтервалПроверки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет события, на которые могут подписаться другие библиотеки.
//
// Возвращаемое значение:
//   События - Структура - Ключами свойств структуры являются имена событий, на которые
//             могут быть подписаны библиотеки.
//
Функция СобытияБИП() Экспорт
	
	События = Новый Структура;
	
	// Базовая функциональность БИП
	События.Вставить("ОткрытьИнтернетСтраницу", Ложь);
	
	// Интеграция с платежными системами
	События.Вставить("ПриОткрытииФормыНастроекИнтеграции", Ложь);
	
	// Монитор Портала 1С:ИТС
	События.Вставить("ПередПолучениемДанныхМонитора", Ложь);
	События.Вставить("ОбработатьКомандуВФормеМонитора", Ложь);
	События.Вставить("ПриОткрытииФормыНастроекИнтеграции", Ложь);
	События.Вставить("ОбработатьНавигационнуюСсылкуВФормеМонитора", Ложь);
	События.Вставить("ПриВыполненииОбработчикаОжиданияВФормеМонитора", Ложь);
	События.Вставить("ПриЗакрытииФормыМонитора", Ложь);
	
	// Получение обновления программы
	События.Вставить("ПриОпределенииНеобходимостиПоказаОповещенийОДоступныхОбновлениях", Ложь);
	
	// СПАРК Риски
	События.Вставить("ОбработкаНавигационнойСсылкиСПАРКРиски", Ложь);
	События.Вставить("ОбработкаОповещенияСПАРКРиски", Ложь);
	События.Вставить("ПереопределитьПараметрыПроверкиФоновыхЗаданийСПАРКРиски", Ложь);
	
	Возврат События;
	
КонецФункции

Процедура ПриОтветеНаВопросОВыходеИзИнтернетПоддержки(КодВозврата, Форма) Экспорт
	
	Если КодВозврата = КодВозвратаДиалога.Да Тогда
		ИнтернетПоддержкаПользователейВызовСервера.ВыйтиИзИПП();
		Форма.БИПДанныеАутентификации = Неопределено;
		ИнтернетПоддержкаПользователейКлиентСервер.ОтобразитьСостояниеПодключенияИПП(Форма);
		Оповестить("ИнтернетПоддержкаОтключена");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

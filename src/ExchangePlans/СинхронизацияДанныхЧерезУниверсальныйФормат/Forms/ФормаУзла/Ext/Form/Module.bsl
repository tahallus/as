﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбменДаннымиСервер.ФормаУзлаПриСозданииНаСервере(ЭтотОбъект, Отказ);
	
	Если РаботаВМоделиСервиса.РазделениеВключено() Тогда
		
		Элементы.Код.Доступность = Ложь;
		
		НедоступныйЭлемент = Элементы.Найти("ФормаОбщаяКомандаСоставОтправляемыхДанных");
		Если НедоступныйЭлемент <> Неопределено Тогда
			НедоступныйЭлемент.Видимость = Ложь;
		КонецЕсли;
		
		НедоступныйЭлемент = Элементы.Найти("ФормаОбщаяКомандаУдалитьНастройкуСинхронизации");
		Если НедоступныйЭлемент <> Неопределено Тогда
			НедоступныйЭлемент.Видимость = Ложь;
		КонецЕсли;
		
		НедоступныйЭлемент = Элементы.Найти("ФормаУдалить");
		Если НедоступныйЭлемент <> Неопределено Тогда
			НедоступныйЭлемент.Видимость = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ПравилаОтправкиСправочников) Тогда
		Объект.ПравилаОтправкиСправочников = "АвтоматическаяСинхронизация";
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Объект.ПравилаОтправкиДокументов) Тогда
		Объект.ПравилаОтправкиДокументов = "АвтоматическаяСинхронизация";
	КонецЕсли;
	
	РежимСинхронизации = ?(Не Объект.РучнойОбмен, "АвтоматическаяСинхронизация", "РучнаяСинхронизация");
	
	РежимСинхронизацииОрганизаций = ?(Объект.ИспользоватьОтборПоОрганизациям,
		"СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям", "СинхронизироватьДанныеПоВсемОрганизациям");
	
	РежимСинхронизацииДокументов = ?(Объект.ИспользоватьОтборПоВидамДокументов,
		"СинхронизироватьДанныеТолькоПоВыбраннымВидамДокументов", "СинхронизироватьДанныеПоВсемДокументам");
	
	УстановитьВидимостьНаСервере();
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.Организации.Количество() > 0 Тогда
		Если РежимСинхронизацииОрганизаций = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям" Тогда
			ТекущийОбъект.ИспользоватьОтборПоОрганизациям = Истина;
		Иначе
			ТекущийОбъект.ИспользоватьОтборПоОрганизациям = Ложь;
			ТекущийОбъект.Организации.Очистить();
		КонецЕсли;
	Иначе
		ТекущийОбъект.ИспользоватьОтборПоОрганизациям = Ложь;
	КонецЕсли;
	
	Если ТекущийОбъект.ВидыДокументов.Количество() > 0 Тогда
		Если РежимСинхронизацииДокументов = "СинхронизироватьДанныеТолькоПоВыбраннымВидамДокументов" Тогда
			ТекущийОбъект.ИспользоватьОтборПоВидамДокументов = Истина;
		Иначе
			ТекущийОбъект.ИспользоватьОтборПоВидамДокументов = Ложь;
			ТекущийОбъект.ВидыДокументов.Очистить();
		КонецЕсли;
	Иначе
		ТекущийОбъект.ИспользоватьОтборПоВидамДокументов = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ОбменДаннымиСервер.ФормаУзлаПриЗаписиНаСервере(ТекущийОбъект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Оповестить("ЗакрытаФормаУзлаПланаОбмена");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ОбновитьДанныеОбъекта(ВыбранноеЗначение);
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПутьКМенеджеруОбменаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	НастройкиДиалога = Новый Структура;
	НастройкиДиалога.Вставить("Фильтр", НСтр("ru = 'Менеджер обмена (*.epf)'") + "|*.epf" );
	
	Оповещение = Новый ОписаниеОповещения("ЗавершениеВыбораФайлаМенеджераОбмена", ЭтотОбъект);
	ОбменДаннымиКлиент.ВыбратьИПередатьФайлНаСервер(Оповещение, НастройкиДиалога, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеВыбораФайлаМенеджераОбмена(Знач РезультатПомещенияФайлов, Знач ДополнительныеПараметры) Экспорт
	
	ОчиститьСообщения();
	
	Объект.ПутьКМенеджеруОбмена = РезультатПомещенияФайлов.Имя;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтбораПоОрганизациям(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("АдресТаблицыОрганизаций", ПолучитьАдресТабличнойЧасти("Организации"));
	ПараметрыФормы.Вставить("ИмяТаблицыДляЗаполнения", "Организации");
	
	ОткрытьФорму("ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.Форма.ФормаВыбораОрганизаций",
		ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокВыбранныхВидовЦенНажатие(Элемент)
	
	КоллекцияФильтров = Неопределено;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения", "ВидыЦен");
	ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "ВидЦен");
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора", "Справочник.ВидыЦен");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора", НСтр("ru = 'Выберите виды цен для отбора:'"));
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений", СформироватьМассивВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения", Неопределено);
	ПараметрыФормы.Вставить("КоллекцияФильтров", КоллекцияФильтров);
	
	ОткрытьФорму("ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.Форма.ФормаВыбораДополнительныхУсловий",
		ПараметрыФормы, ЭтотОбъект);
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокВыбранныхСкладовНажатие(Элемент)
	
	КоллекцияФильтров = Неопределено;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения", "Склады");
	ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "Склад");
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора", "Справочник.СтруктурныеЕдиницы");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора", НСтр("ru = 'Выберите склады для отбора:'"));
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений", СформироватьМассивВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения", Неопределено);
	ПараметрыФормы.Вставить("КоллекцияФильтров", КоллекцияФильтров);
	
	ОткрытьФорму("ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.Форма.ФормаВыбораДополнительныхУсловий",
		ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокВыбранныхОрганизацийСкладскихОстатковНажатие(Элемент)
	
	КоллекцияФильтров = Неопределено;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения", "ОрганизацииСкладскихОстатков");
	ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "Организация");
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора", "Справочник.Организации");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора", НСтр("ru = 'Выберите организации для отбора:'"));
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений", СформироватьМассивВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения", Неопределено);
	ПараметрыФормы.Вставить("КоллекцияФильтров", КоллекцияФильтров);
	
	ОткрытьФорму("ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.Форма.ФормаВыбораДополнительныхУсловий",
		ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокВыбраннойНоменклатуры(Элемент)
	
	КоллекцияФильтров = Неопределено;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения", "Номенклатура");
	ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "Номенклатура");
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора", "Справочник.Номенклатура");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора", НСтр("ru = 'Выберите номенклатуру для отбора:'"));
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений", СформироватьМассивВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения", Неопределено);
	ПараметрыФормы.Вставить("КоллекцияФильтров", КоллекцияФильтров);
	
	ОткрытьФорму("ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.Форма.ФормаВыбораДополнительныхУсловий",
		ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгружатьОстаткиНоменклатурыПриИзменении(Элемент)
	
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоВидамЦенПриИзменении(Элемент)
	
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоНоменклатуреПриИзменении(Элемент)
	
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииОрганизацийПриИзменении(Элемент)
	
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииДокументовПриИзменении(Элемент)
	
	Если РежимСинхронизацииДокументов = "СинхронизироватьДанныеТолькоПоДокументамОтобраннымВручную" Тогда
		РежимСинхронизации = "РучнаяСинхронизация";
	КонецЕсли;
	
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтбораПоВидамДокументов(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ВидыДокументов", ПолучитьМассивОбъектовТабличнойЧасти("ВидыДокументов", "ИмяОбъектаМетаданных"));
	
	ОткрытьФорму("ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.Форма.ФормаВыбораВидовДокументов",
		ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьОтборПоОрганизациям(Команда)
	
	ТекстЗаголовка = НСтр("ru='Подтверждение'");
	ТекстВопроса   = НСтр("ru='Очистить отбор по организациям?'");
	Продолжение = Новый ОписаниеОповещения("ОчиститьОтборПоОрганизациямЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Продолжение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , , ТекстЗаголовка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьОтборПоОрганизациямЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Ответ = Результат;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Объект.Организации.Очистить();
		УстановитьВидимостьНаСервере();
		ОбновитьНаименованиеКомандФормы();
		Модифицированность = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьОтборПоВидамДокументов(Команда)
	
	ТекстЗаголовка = НСтр("ru='Подтверждение'");
	ТекстВопроса   = НСтр("ru='Очистить отбор по видам документов?'");
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ОчиститьОтборПоВидамДокументовЗавершение", ЭтотОбъект), ТекстВопроса,
		РежимДиалогаВопрос.ДаНет, , , ТекстЗаголовка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьОтборПоВидамДокументовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Ответ = Результат;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Объект.ВидыДокументов.Очистить();
		УстановитьВидимостьНаСервере();
		ОбновитьНаименованиеКомандФормы();
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИПоНеобходимостиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИНикогдаПриИзменении(Элемент)
	Объект.ПравилаОтправкиДокументов = "НеСинхронизировать";
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыОтправлятьАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыОтправлятьВручнуюПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыНеОтправлятьПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьНаСервере()
	
	Элементы.ДатаНачалаВыгрузкиДокументов.Доступность =
		?(Объект.ПравилаОтправкиДокументов = "АвтоматическаяСинхронизация", Истина, Ложь);
		
	Элементы.ГруппаНастройкаОтборовДокументов.Доступность =
		?(Объект.ПравилаОтправкиДокументов = "АвтоматическаяСинхронизация", Истина, Ложь);
		
	Элементы.ПереключательДокументыНеОтправлять.Доступность =
		?(Не Объект.ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости", Истина, Ложь);
		
	Элементы.ГруппаДокументы.Доступность =
		?(Не Объект.ПравилаОтправкиСправочников = "НеСинхронизировать", Истина, Ложь);
		
	ОтборПоВидамДокументовИспользуется = РежимСинхронизацииДокументов
		= "СинхронизироватьДанныеТолькоПоВыбраннымВидамДокументов";
	ОтборПоВидамДокументовНастроен = Объект.ВидыДокументов.Количество() > 0;
	Элементы.ОткрытьФормуОтбораПоВидамДокументов.Видимость = ОтборПоВидамДокументовИспользуется;
	Элементы.ОчиститьОтборПоВидамДокументов.Видимость = ОтборПоВидамДокументовИспользуется
		И ОтборПоВидамДокументовНастроен;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Элементы.ГруппаОтборПоОрганизациям.Видимость = Ложь;
	Иначе
		Элементы.ГруппаОтборПоОрганизациям.Видимость = Истина;
		ОтборПоОрганизациямИспользуется = РежимСинхронизацииОрганизаций
			= "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям";
		ОтборПоОрганизациямНастроен = Объект.Организации.Количество() > 0;
		Элементы.ОткрытьФормуОтбораПоОрганизациям.Видимость = ОтборПоОрганизациямИспользуется;
		Элементы.ОчиститьОтборПоОрганизациям.Видимость = ОтборПоОрганизациямИспользуется И ОтборПоОрганизациямНастроен;
	КонецЕсли;
	
	Если Объект.ВариантНастройки = "ВебВитрина"
		ИЛИ Объект.ВариантНастройки = "КабинетКлиента"
		ИЛИ Объект.ВариантНастройки = "ОбменРТ" Тогда
		Элементы.ГруппаПереносКатегорий.Видимость = Ложь;
		Элементы.ГруппаПереносЗаказовПокупателей.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ОткрытьСписокВыбранныхВидовЦен.Доступность = Объект.ИспользоватьОтборПоВидамЦен;
	Элементы.ОткрытьСписокВыбранныхСкладов.Доступность = Объект.ВыгружатьОстаткиНоменклатуры;
	Элементы.ОткрытьСписокВыбранныхОрганизацийСкладскихОстатков.Доступность = Объект.ВыгружатьОстаткиНоменклатуры;
	Элементы.ОткрытьСписокВыбраннойНоменклатуры.Доступность = Объект.ИспользоватьОтборПоНоменклатуре;
	
	ИнформативныеОстаткиПоддерживаютсяФорматом = ВерсияФорматаЧислом(Объект.ВерсияФорматаОбмена) >= ВерсияФорматаЧислом(
		"1.8");
	Элементы.ГруппаВыгружатьОстаткиНоменклатуры.Видимость = ИнформативныеОстаткиПоддерживаютсяФорматом
		И НЕ Объект.ВариантНастройки = "ОбменБП30";
	Элементы.ОтборПоНоменклатуре.Видимость = Объект.ВариантНастройки = "КабинетКлиента";
	
КонецПроцедуры

&НаСервере
Функция ПолучитьМассивОбъектовТабличнойЧасти(ИмяТабличнойЧасти, ИмяКолонки)

	Возврат Объект[ИмяТабличнойЧасти].Выгрузить().ВыгрузитьКолонку(ИмяКолонки);

КонецФункции

&НаСервере
Функция ПолучитьАдресТабличнойЧасти(ИмяТабличнойЧасти)
	
	ТаблицаОрганизаций = Объект[ИмяТабличнойЧасти].Выгрузить();
	ТаблицаОрганизаций.Колонки.Добавить("Использовать");
	ТаблицаОрганизаций.ЗаполнитьЗначения(Истина, "Использовать");
	
	Возврат ПоместитьВоВременноеХранилище(ТаблицаОрганизаций);
	
КонецФункции

&НаСервере
Процедура ОбновитьДанныеОбъекта(СтруктураПараметров)
	
	ИмяТаблицыДляЗаполнения = СтруктураПараметров.ИмяТаблицыДляЗаполнения;
	
	Объект[ИмяТаблицыДляЗаполнения].Очистить();
	
	ТаблицаВыбранныхЗначений = ПолучитьИзВременногоХранилища(СтруктураПараметров.АдресТаблицыВоВременномХранилище);
	
	Если ТаблицаВыбранныхЗначений.Колонки.Найти("Идентификатор") <> Неопределено
		И ТаблицаВыбранныхЗначений.Колонки.Найти("Представление") <> Неопределено Тогда
		
		Для каждого СтрокаТаблицы Из ТаблицаВыбранныхЗначений Цикл
			
			НоваяСтрока = Объект[ИмяТаблицыДляЗаполнения].Добавить();
			НоваяСтрока[СтруктураПараметров.ИмяКолонкиДляЗаполнения] = СтрокаТаблицы.Представление;
			
		КонецЦикла;
		
	Иначе
		
		Для каждого СтрокаТаблицы Из ТаблицаВыбранныхЗначений Цикл
			
			Если СтрокаТаблицы.Использовать Тогда
				НоваяСтрока = Объект[ИмяТаблицыДляЗаполнения].Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	УстановитьВидимостьНаСервере();
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаименованиеКомандФормы()
	
	// Обновим заголовок выбранных организаций
	Если Объект.Организации.Количество() > 0 Тогда
		ВыбранныеОрганизации = Объект.Организации.Выгрузить().ВыгрузитьКолонку("Организация");
		НовыйЗаголовок = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.СокращенноеПредставлениеКоллекцииЗначений(ВыбранныеОрганизации);
	Иначе
		НовыйЗаголовок = НСтр("ru = 'Выбрать организации'");
	КонецЕсли;
	Элементы.ОткрытьФормуОтбораПоОрганизациям.Заголовок = НовыйЗаголовок;
	
	// Обновим заголовок выбранных видов документов
	Если Объект.ВидыДокументов.Количество() > 0 Тогда
		ВыбранныеВидыДокументов = Объект.ВидыДокументов.Выгрузить().ВыгрузитьКолонку("Представление");
		НовыйЗаголовок = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.СокращенноеПредставлениеКоллекцииЗначений(ВыбранныеВидыДокументов);
	Иначе
		НовыйЗаголовок = НСтр("ru = 'Выбрать виды документов'");
	КонецЕсли;
	Элементы.ОткрытьФормуОтбораПоВидамДокументов.Заголовок = НовыйЗаголовок;
	
	Если Объект.ВидыЦен.Количество() > 0 Тогда
		ВыбранныеЭлементы = Объект.ВидыЦен.Выгрузить().ВыгрузитьКолонку("ВидЦен");
		НовыйЗаголовок = СтрСоединить(ВыбранныеЭлементы, ", ");
	Иначе
		НовыйЗаголовок = НСтр("ru = 'Выбрать виды цен'");
	КонецЕсли;
	Элементы.ОткрытьСписокВыбранныхВидовЦен.Заголовок = НовыйЗаголовок;
	
	Если Объект.Склады.Количество() > 0 Тогда
		ВыбранныеЭлементы = Объект.Склады.Выгрузить().ВыгрузитьКолонку("Склад");
		НовыйЗаголовок = СтрСоединить(ВыбранныеЭлементы, ", ");
	Иначе
		НовыйЗаголовок = НСтр("ru = 'Выбрать склады'");
	КонецЕсли;
	Элементы.ОткрытьСписокВыбранныхСкладов.Заголовок = НовыйЗаголовок;
	
	Если Объект.ОрганизацииСкладскихОстатков.Количество() > 0 Тогда
		ВыбранныеЭлементы = Объект.ОрганизацииСкладскихОстатков.Выгрузить().ВыгрузитьКолонку("Организация");
		НовыйЗаголовок = СтрСоединить(ВыбранныеЭлементы, ", ");
	Иначе
		НовыйЗаголовок = НСтр("ru = 'Выбрать организации'");
	КонецЕсли;
	Элементы.ОткрытьСписокВыбранныхОрганизацийСкладскихОстатков.Заголовок = НовыйЗаголовок;
	
	Если Объект.Номенклатура.Количество() > 0 Тогда
		НовыйЗаголовок = СтрШаблон(НСтр("ru='Выбрано номенклатуры: %1'"), Объект.Номенклатура.Количество());
	Иначе
		НовыйЗаголовок = НСтр("ru='Выбрать номенклатуру'");
	КонецЕсли;
	Элементы.ОткрытьСписокВыбраннойНоменклатуры.Заголовок = НовыйЗаголовок;
	
КонецПроцедуры

&НаСервере
Функция СформироватьМассивВыбранныхЗначений(ПараметрыФормы)
	
	ТабличнаяЧасть           = Объект[ПараметрыФормы.ИмяЭлементаФормыДляЗаполнения];
	ТаблицаВыбранныхЗначений = ТабличнаяЧасть.Выгрузить(, ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения);
	МассивВыбранныхЗначений  = ТаблицаВыбранныхЗначений.ВыгрузитьКолонку(ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения);
	
	Возврат МассивВыбранныхЗначений;

КонецФункции

&НаСервере
Функция ВерсияФорматаЧислом(СтрокаВерсии)
	ВерсияФорматаЧислом = 0;
	
	РазрядыВерсии = СтрРазделить(СтрокаВерсии, ".");
	Если РазрядыВерсии.Количество() <> 2 Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Неправильный формат параметра СтрокаВерсии1: %1'"), СтрокаВерсии);
	КонецЕсли;
	
	МножительРазряда = 10000;
	Для ИндексРазрядаОбратный = 0 По 1 Цикл
		ВерсияФорматаЧислом = ВерсияФорматаЧислом + Число(РазрядыВерсии[ИндексРазрядаОбратный]) * МножительРазряда;
		МножительРазряда = МножительРазряда / 100;
	КонецЦикла;
	Возврат ВерсияФорматаЧислом;
КонецФункции

#КонецОбласти

﻿#Область ПрограммныйИнтерфейс

// См. ОбменДаннымиПереопределяемый.ПриОпределенииПрефиксаИнформационнойБазыПоУмолчанию.
// 
Процедура ПриОпределенииПрефиксаИнформационнойБазыПоУмолчанию(Префикс) Экспорт

	Префикс = НСтр("ru = 'НФ'");

КонецПроцедуры

// См. ОбменДаннымиПереопределяемый.ПолучитьПланыОбмена.
// 
Процедура ПолучитьПланыОбмена(ПланыОбменаПодсистемы) Экспорт

	УстановитьПривилегированныйРежим(Истина);

	Если ПолучитьФункциональнуюОпцию("РаботаВЛокальномРежиме") Тогда
		ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.ОбменУправлениеНебольшойФирмойБухгалтерия20);
	КонецЕсли;

	ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.ОбменРозницаУправлениеНебольшойФирмой);
	ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.ОбменУправлениеНебольшойФирмойБухгалтерия30);
	ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.АвтономнаяРабота);
	ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат);
	Если ВРег(Метаданные.Имя) = ВРег("УправлениеНебольшойФирмой") Тогда
		ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.Полный);
		ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.ПоОрганизации);
		ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.СОтборами);
	КонецЕсли;

КонецПроцедуры

// См. ОбменДаннымиПереопределяемый.РегистрацияИзмененийНачальнойВыгрузкиДанных.
// 
Процедура РегистрацияИзмененийНачальнойВыгрузкиДанных(Получатель, СтандартнаяОбработка, Отбор) Экспорт

	Если ТипЗнч(Получатель) <> Тип("ПланОбменаСсылка.ОбменУправлениеНебольшойФирмойБухгалтерия20") И ТипЗнч(Получатель)
		<> Тип("ПланОбменаСсылка.ОбменУправлениеНебольшойФирмойБухгалтерия30") И ТипЗнч(Получатель) <> Тип(
		"ПланОбменаСсылка.СинхронизацияДанныхЧерезУниверсальныйФормат") Тогда
		Возврат;
	КонецЕсли;

	ВариантНастройки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Получатель, "ВариантНастройки");

	Если ВариантНастройки = "КабинетКлиента" Тогда
		Справочники.НастройкиПубликацииМЛК.РегистрацияИзмененийНачальнойВыгрузкиДанных(
			Получатель, СтандартнаяОбработка, Отбор);
	Иначе
		ЗарегистрироватьНачальнуюВыгрузкуПоУмолчанию(Получатель, СтандартнаяОбработка, Отбор);
	КонецЕсли;

КонецПроцедуры

// См. ОбменДаннымиПереопределяемый.ПриПолученииДоступныхВерсийФормата.
// 
Процедура ПриПолученииДоступныхВерсийФормата(ВерсииФормата) Экспорт

	ВерсииФормата.Вставить("1.6", МенеджерОбменаЧерезУниверсальныйФормат18);
	ВерсииФормата.Вставить("1.7", МенеджерОбменаЧерезУниверсальныйФормат18);
	ВерсииФормата.Вставить("1.8", МенеджерОбменаЧерезУниверсальныйФормат18);
	ВерсииФормата.Вставить("1.10", МенеджерОбменаЧерезУниверсальныйФормат18);

КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// АПК:299-выкл вызывается программно из правил регистрации объекта

// Формирует текст запроса и параметры запроса по узлам обмена
// Для контроля прохождения фильтра ПРО
// 
// Параметры:
//  Объект - Произвольный - синхронизируемый объект
//  ТекстЗапроса - Строка - текст запроса
//  ПараметрыЗапроса - см. ОпределитьПараметрыЗапросаОбъекта 
//  ИмяПланаОбмена - Строка - "АвтономнаяРабота" или "СОтборами"
Процедура ЗаполнитьПараметрыЗапроса(Объект, ТекстЗапроса, ПараметрыЗапроса, ИмяПланаОбмена) Экспорт

	Если Не ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;

	ПараметрыЗапроса = ОпределитьПараметрыЗапросаОбъекта(Объект);
	ТекстЗапроса = ТекстЗапросаПравилРегистрации(ИмяПланаОбмена);

КонецПроцедуры
// АПК:299-выкл

// Возвращает структуру отборов на узле плана обмена с установленными значениями по умолчанию;
// Структура настроек повторяет состав реквизитов шапки и табличных частей плана обмена;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры,
// а для табличных частей используются структуры,
// содержащие массивы значений полей табличных частей плана обмена.
// 
// Возвращаемое значение:
//  Структура - Настройка отборов на узле:
// * Организации - Структура -:
// ** Организация - Массив -
// * СкладыИМагазины - Структура -:
// ** СкладыИМагазины - Массив -
Функция НастройкаОтборовНаУзле() Экспорт
	
	Результат = Новый Структура;
	
	Результат.Вставить("ИспользоватьОтборПоОрганизациям", Ложь);
	Результат.Вставить("ИспользоватьОтборПоСкладамИМагазинам", Ложь);
	
	КолонкиТабличнойЧастиОрганизации = Новый Структура;
	КолонкиТабличнойЧастиОрганизации.Вставить("Организация", Новый Массив);
	Результат.Вставить("Организации", КолонкиТабличнойЧастиОрганизации);
	
	КолонкиТабличнойЧастиМагазиныИСклады = Новый Структура;
	КолонкиТабличнойЧастиМагазиныИСклады.Вставить("СтруктурнаяЕдиница", Новый Массив);
	Результат.Вставить("СкладыИМагазины", КолонкиТабличнойЧастиМагазиныИСклады);
	
	Возврат Результат;
	
КонецФункции

// Возвращает имена реквизитов и табличных частей плана обмена, перечисленных через запятую,
// которые являются общими для пары обменивающихся конфигураций.
//
// Возвращаемое значение:
//  Строка - Общие данные узлов
Функция ОбщиеДанныеУзлов() Экспорт

	Возврат "ИспользоватьОтборПоОрганизациям, ИспользоватьОтборПоСкладамИМагазинам, Организации, СкладыИМагазины";

КонецФункции

// Обработчик при создании на сервере формы узла.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
Процедура ПриСозданииНаСервереФормыУзла(Форма, Элементы) Экспорт

	Форма.ДоступныОрганизации = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций")
		И Не ЗначениеЗаполнено(Справочники.Организации.ОрганизацияКомпания());
	Форма.ДоступныСкладыИМагазины = ПолучитьФункциональнуюОпцию("УчетПоНесколькимСкладам");

КонецПроцедуры

Процедура ОбновитьДанныеОбъекта(Объект, ВыбранноеЗначение) Экспорт

	Объект[ВыбранноеЗначение.ТаблицаЗаполнения].Очистить();

	ТаблицаВыбранныхЗначений = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресТаблицыВыбранныхЗначений);

	Если ТаблицаВыбранныхЗначений.Количество() > 0 Тогда
		ТаблицаВыбранныхЗначений.Колонки.Ссылка.Имя = ВыбранноеЗначение.КолонкаЗаполнения;
		Объект[ВыбранноеЗначение.ТаблицаЗаполнения].Загрузить(ТаблицаВыбранныхЗначений);
	КонецЕсли;

КонецПроцедуры

Процедура ОбновитьЗаголовкиКомандФормы(Объект, Элементы) Экспорт

	Если Объект.Организации.Количество() > 0 Тогда
		НовыйЗаголовокОрганизаций = ТекстовоеПредставлениеОрганизаций(Объект.Организации);
	Иначе
		НовыйЗаголовокОрганизаций = НСтр("ru = 'Выбрать организации'");
	КонецЕсли;
	Элементы.ВыбратьОрганизации.Заголовок = НовыйЗаголовокОрганизаций;

	Если Объект.СкладыИМагазины.Количество() > 0 Тогда
		ВыбранныеМагазиныИСклады = Объект.СкладыИМагазины.Выгрузить();
		ВыбранныеМагазиныИСклады.Колонки.СтруктурнаяЕдиница.Имя = "Ссылка";
		НовыйЗаголовокМагазиновИСкладов = ТекстовоеПредставлениеМагазиновИСкладов(ВыбранныеМагазиныИСклады);
	Иначе
		НовыйЗаголовокМагазиновИСкладов = НСтр("ru = 'Выбрать склады и магазины'");
	КонецЕсли;
	Элементы.ВыбратьСкладыИМагазины.Заголовок = НовыйЗаголовокМагазиновИСкладов;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗарегистрироватьНачальнуюВыгрузкуПоУмолчанию(Получатель, СтандартнаяОбработка, Отбор)

	СтандартнаяОбработка = Ложь;

	Отбор = Новый Массив;

	РеквизитыПолучателя = Новый Массив;
	РеквизитыПолучателя.Добавить("ВариантНастройки");
	РеквизитыПолучателя.Добавить("ИспользоватьОтборПоВидамДокументов");
	РеквизитыПолучателя.Добавить("РучнойОбмен");
	РеквизитыПолучателя.Добавить("ВидыДокументов");
	РеквизитыПолучателя.Добавить("ИспользоватьОтборПоОрганизациям");
	РеквизитыПолучателя.Добавить("ДатаНачалаВыгрузкиДокументов");
	РеквизитыПолучателя.Добавить("Организации");
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ИспользоватьОтборПоСкладамИМагазинам", Получатель.Метаданные()) Тогда
		РеквизитыПолучателя.Добавить("ИспользоватьОтборПоСкладамИМагазинам");
	КонецЕсли;

	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Получатель, РеквизитыПолучателя);

	Если ЗначенияРеквизитов.РучнойОбмен Или ЗначенияРеквизитов.ИспользоватьОтборПоВидамДокументов Тогда

		Для Каждого ЭлементСостава Из Получатель.Метаданные().Состав Цикл
			Если Метаданные.Справочники.Содержит(ЭлементСостава.Метаданные) Тогда
				Отбор.Добавить(ЭлементСостава.Метаданные);
			КонецЕсли;
		КонецЦикла;

		Если ЗначенияРеквизитов.ИспользоватьОтборПоВидамДокументов Тогда

			Для Каждого СтрокаТабличнойЧасти Из Получатель.ВидыДокументов Цикл
				ОбъектМетаданных = Метаданные.Документы.Найти(СтрокаТабличнойЧасти.ИмяОбъектаМетаданных);
				Если ОбъектМетаданных <> Неопределено Тогда
					Отбор.Добавить(ОбъектМетаданных);
				КонецЕсли;
			КонецЦикла;

		КонецЕсли;

	Иначе

		Для Каждого ЭлементСостава Из Получатель.Метаданные().Состав Цикл
			Отбор.Добавить(ЭлементСостава.Метаданные);
		КонецЦикла;

	КонецЕсли;

	МетаданныеКлассификаторов = Новый Массив;
	МетаданныеКлассификаторов.Добавить(Метаданные.Справочники.Банки);
	МетаданныеКлассификаторов.Добавить(Метаданные.Справочники.Валюты);
	МетаданныеКлассификаторов.Добавить(Метаданные.Справочники.КлассификаторЕдиницИзмерения);
	МетаданныеКлассификаторов.Добавить(Метаданные.Справочники.СтраныМира);

	МетаданныеРегистрируютсяВручную = Новый Массив;
	МетаданныеРегистрируютсяВручную.Добавить(Метаданные.РегистрыСведений.ФактОплатыЗаказов);

	Для Каждого ЭлементМассива Из МетаданныеКлассификаторов Цикл
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(Отбор, ЭлементМассива);
	КонецЦикла;
	Для Каждого ЭлементМассива Из МетаданныеРегистрируютсяВручную Цикл
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(Отбор, ЭлементМассива);
	КонецЦикла;

	Если ЗначенияРеквизитов.ИспользоватьОтборПоОрганизациям Тогда
		ОтборОрганизации = ЗначенияРеквизитов.Организации.Выгрузить().ВыгрузитьКолонку("Организация");
	Иначе
		ОтборОрганизации = Неопределено;
	КонецЕсли;

	ОбменДаннымиСервер.ЗарегистрироватьДанныеПоДатеНачалаВыгрузкиИОрганизациям(Получатель,
		ЗначенияРеквизитов.ДатаНачалаВыгрузкиДокументов, ОтборОрганизации, Отбор);

КонецПроцедуры

// Определяет параметры запроса ПРО для выгружаемых объектов
// 
// Параметры:
//  ЭлементДанных - выгружаемый элемент данных, для которого требуется определить параметры
// 
// Возвращаемое значение:
//  Структура - Определить параметры запроса объекта:
// * Отказ - Булево
// * КонтрольПроведенияПоОдномуИзУсловий - Булево
// * СообщениеПользователю - Строка
// * РеквизитПроверкиПодразделения - Строка
// * Организации - Массив из СправочникСсылка.Организации
// * СтруктурныеЕдиницы - Массив из СправочникСсылка.СтруктурныеЕдиницы
// * ФильтрПоОрганизации - Булево - применять к объекту фильтр по организации
// * ФильтрПоСкладуМагазину - Булево - применять к объекту фильтр по складу / магазину
Функция ОпределитьПараметрыЗапросаОбъекта(ЭлементДанных)

	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("Отказ", Ложь);
	ПараметрыЗапроса.Вставить("КонтрольПроведенияПоОдномуИзУсловий", Ложь);
	ПараметрыЗапроса.Вставить("СообщениеПользователю", "");
	ПараметрыЗапроса.Вставить("РеквизитПроверкиПодразделения", "");

	ПараметрыЗапроса.Вставить("Организации", Новый Массив);
	ПараметрыЗапроса.Вставить("СтруктурныеЕдиницы", Новый Массив);

	ПараметрыЗапроса.Вставить("ФильтрПоОрганизации", Ложь);
	ПараметрыЗапроса.Вставить("ФильтрПоСкладуМагазину", Ложь);

	МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипЗнч(ЭлементДанных));
	Если МетаданныеОбъекта = Неопределено Тогда
		Возврат ПараметрыЗапроса;
	КонецЕсли;

	ЗаполнитьПоля_ОрганизацияИСтруктурнаяЕдиница(ЭлементДанных, ПараметрыЗапроса, МетаданныеОбъекта);
	ЗаполнитьПоля_Владелец(ЭлементДанных, ПараметрыЗапроса, МетаданныеОбъекта);
	ЗаполнитьПоля_ВладелецФайла(ЭлементДанных, ПараметрыЗапроса, МетаданныеОбъекта);
	ЗаполнитьПоля_СтруктурнаяЕдиница_Документа(ЭлементДанных, ПараметрыЗапроса, МетаданныеОбъекта);
	ЗаполнитьПоля_СтруктурнаяЕдиница_ПоложениеСклада(ЭлементДанных, ПараметрыЗапроса, МетаданныеОбъекта);
	ЗаполнитьПоля_ОплатыПокупателейССайта(ЭлементДанных, ПараметрыЗапроса, МетаданныеОбъекта);

	ОчиститьПустыеСсылкиИзМассиваОбъектов(ПараметрыЗапроса.Организации);

	ПараметрыЗапроса.СтруктурныеЕдиницы = ИерархияПоСкладамИМагазинам(ПараметрыЗапроса.СтруктурныеЕдиницы);

	ОчиститьПустыеСсылкиИзМассиваОбъектов(ПараметрыЗапроса.СтруктурныеЕдиницы);

	ПараметрыЗапроса.ФильтрПоОрганизации = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций")
		И ЗначениеЗаполнено(ПараметрыЗапроса.Организации);

	ПараметрыЗапроса.ФильтрПоСкладуМагазину = ПолучитьФункциональнуюОпцию("УчетПоНесколькимСкладам")
		И ЗначениеЗаполнено(ПараметрыЗапроса.СтруктурныеЕдиницы);

	Возврат ПараметрыЗапроса;

КонецФункции

// Возвращает текст запроса ПРО для использования его в обработчиках правил регистрации
//
// Возвращаемое значение:
//  Строка - Текст запроса ПРО
//
Функция ТекстЗапросаПравилРегистрации(ИмяПланаОбмена)

	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланОбменаОсновнаяТаблица.Ссылка КАК Ссылка
	|ИЗ
	|	ПланОбмена.СОтборами КАК ПланОбменаОсновнаяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланОбмена.СОтборами.Организации КАК ПланОбменаТаблицаОрганизации
	|		ПО ПланОбменаОсновнаяТаблица.Ссылка = ПланОбменаТаблицаОрганизации.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланОбмена.СОтборами.СкладыИМагазины КАК ПланОбменаТаблицаСкладыМагазины
	|		ПО ПланОбменаОсновнаяТаблица.Ссылка = ПланОбменаТаблицаСкладыМагазины.Ссылка
	|ГДЕ
	|	НЕ ПланОбменаОсновнаяТаблица.Ссылка = &СОтборамиЭтотУзел
	|	И НЕ ПланОбменаОсновнаяТаблица.ПометкаУдаления
	|	И (НЕ &СвойствоОбъекта_ФильтрПоОрганизации
	|			ИЛИ (ПланОбменаТаблицаОрганизации.Организация В (&СвойствоОбъекта_Организации)
	|				ИЛИ НЕ ПланОбменаОсновнаяТаблица.ИспользоватьОтборПоОрганизациям))
	|	И (НЕ &СвойствоОбъекта_ФильтрПоСкладуМагазину
	|			ИЛИ (ПланОбменаТаблицаСкладыМагазины.СтруктурнаяЕдиница В (&СвойствоОбъекта_СтруктурныеЕдиницы)
	|				ИЛИ НЕ ПланОбменаОсновнаяТаблица.ИспользоватьОтборПоСкладамИМагазинам))";

	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "СОтборами", ИмяПланаОбмена);

	Возврат ТекстЗапроса;

КонецФункции

// Очищает пустые значения в массиве объектов
//
Процедура ОчиститьПустыеСсылкиИзМассиваОбъектов(МассивОбъектов)

	МаксимальныйИндекс = МассивОбъектов.ВГраница();

	Если МаксимальныйИндекс > 0 Тогда

		Пока МаксимальныйИндекс >= 0 Цикл

			ЭлементМассива = МассивОбъектов[МаксимальныйИндекс];

			Если Не ЗначениеЗаполнено(ЭлементМассива) Тогда
				МассивОбъектов.Удалить(МаксимальныйИндекс);
			КонецЕсли;

			МаксимальныйИндекс = МаксимальныйИндекс - 1;

		КонецЦикла;

	КонецЕсли;

КонецПроцедуры

Функция ИерархияПоСкладамИМагазинам(СтруктурныеЕдиницы)

	Если Не ЗначениеЗаполнено(СтруктурныеЕдиницы) Тогда
		Возврат Новый Массив;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СтруктурныеЕдиницы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|ГДЕ
	|	СтруктурныеЕдиницы.Ссылка В (&СтруктурныеЕдиницы)
	|	И СтруктурныеЕдиницы.ТипСтруктурнойЕдиницы В (&ТипыСтруктурныхЕдиниц)
	|ИТОГИ
	|ПО
	|	Ссылка ТОЛЬКО ИЕРАРХИЯ";
	Запрос.УстановитьПараметр("СтруктурныеЕдиницы", СтруктурныеЕдиницы);
	Запрос.УстановитьПараметр("ТипыСтруктурныхЕдиниц",
		ОбменДаннымиУНФКлиентСервер.ТипыСтруктурныхЕдиницСкладыИМагазины());
	Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	Возврат Результат;

КонецФункции

#Область РИБСОтборами

Процедура ЗаполнитьПоля_ОрганизацияИСтруктурнаяЕдиница(Объект, ПараметрыЗапроса, МетаданныеОбъекта)

	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Организация", МетаданныеОбъекта) Тогда
		ПараметрыЗапроса.Организации.Добавить(Объект.Организация);
	КонецЕсли;

	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурнаяЕдиница", МетаданныеОбъекта) Тогда
		ПараметрыЗапроса.СтруктурныеЕдиницы.Добавить(Объект.СтруктурнаяЕдиница);
	КонецЕсли;

	Если ТипЗнч(Объект) = Тип("ДокументОбъект.ПередачаТоваровМеждуОрганизациями") Тогда
		ПараметрыЗапроса.СтруктурныеЕдиницы.Добавить(Объект.ОрганизацияПолучатель);
	КонецЕсли;

	Если ТипЗнч(Объект) = Тип("РегистрСведенийЗапись.НастройкаПередачиТоваровМеждуОрганизациями") Тогда
		ПараметрыЗапроса.СтруктурныеЕдиницы.Добавить(Объект.ОрганизацияВладелец);
		ПараметрыЗапроса.СтруктурныеЕдиницы.Добавить(Объект.ОрганизацияПродавец);
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьПоля_Владелец(ЭлементДанных, ПараметрыЗапроса, МетаданныеОбъекта)

	Если Не ОбщегоНазначения.ЭтоСправочник(МетаданныеОбъекта) Тогда
		Возврат;
	КонецЕсли;

	Если МетаданныеОбъекта.Владельцы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Если ТипЗнч(ЭлементДанных.Владелец) = Тип("СправочникСсылка.Организации") Тогда
		ПараметрыЗапроса.Организации.Добавить(ЭлементДанных.Владелец);
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьПоля_ВладелецФайла(ЭлементДанных, ПараметрыЗапроса, МетаданныеОбъекта)

	Если Не ОбщегоНазначения.ЕстьРеквизитОбъекта("ВладелецФайла", МетаданныеОбъекта) Тогда
		Возврат;
	КонецЕсли;

	МетаданныеВладельца = ЭлементДанных.ВладелецФайла.Метаданные();

	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Организация", МетаданныеВладельца) Тогда
		ЗначениеФильтра = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементДанных.ВладелецФайла, "Организация");
		ПараметрыЗапроса.Организации.Добавить(ЗначениеФильтра);
	КонецЕсли;

	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурнаяЕдиница", МетаданныеВладельца) Тогда
		ЗначениеФильтра = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементДанных.ВладелецФайла, "СтруктурнаяЕдиница");
		ПараметрыЗапроса.СтруктурныеЕдиницы.Добавить(ЗначениеФильтра);
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьПоля_СтруктурнаяЕдиница_Документа(Объект, ПараметрыЗапроса, МетаданныеОбъекта)

	Если Не ОбщегоНазначения.ЭтоДокумент(МетаданныеОбъекта) Тогда
		Возврат;
	КонецЕсли;

	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурнаяЕдиницаПолучатель", МетаданныеОбъекта) Тогда
		ПараметрыЗапроса.СтруктурныеЕдиницы.Добавить(Объект.СтруктурнаяЕдиницаПолучатель);
	КонецЕсли;

	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурнаяЕдиницаПродажи", МетаданныеОбъекта) Тогда
		ПараметрыЗапроса.СтруктурныеЕдиницы.Добавить(Объект.СтруктурнаяЕдиницаПродажи);
	КонецЕсли;

	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурнаяЕдиницаРезерв", МетаданныеОбъекта) Тогда
		ПараметрыЗапроса.СтруктурныеЕдиницы.Добавить(Объект.СтруктурнаяЕдиницаРезерв);
	КонецЕсли;

	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("СтруктурнаяЕдиницаПродукции", МетаданныеОбъекта) Тогда
		ПараметрыЗапроса.СтруктурныеЕдиницы.Добавить(Объект.СтруктурнаяЕдиницаПродукции);
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьПоля_СтруктурнаяЕдиница_ПоложениеСклада(Объект, ПараметрыЗапроса, МетаданныеОбъекта)

	Если Не ОбщегоНазначения.ЭтоДокумент(МетаданныеОбъекта) Тогда
		Возврат;
	КонецЕсли;

	Если Не ОбщегоНазначения.ЕстьРеквизитОбъекта("ПоложениеСклада", МетаданныеОбъекта) Тогда
		Возврат;
	КонецЕсли;

	Если Не ЕстьРеквизитТабличнойЧастиОбъекта("Запасы.СтруктурнаяЕдиница", МетаданныеОбъекта) Тогда
		Возврат;
	КонецЕсли;

	Для Каждого ЗначениеРеквизита Из Объект.Запасы.ВыгрузитьКолонку("СтруктурнаяЕдиница") Цикл
		ПараметрыЗапроса.СтруктурныеЕдиницы.Добавить(ЗначениеРеквизита);
	КонецЦикла;

КонецПроцедуры

Процедура ЗаполнитьПоля_ОплатыПокупателейССайта(ЭлементДанных, ПараметрыЗапроса, МетаданныеОбъекта)

	Если ТипЗнч(ЭлементДанных) <> Тип("РегистрСведенийЗапись.ОплатыПокупателейССайта") Тогда
		Возврат;
	КонецЕсли;

	ЗначениеФильтра = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементДанных.ДокументОплаты, "Организация");
	ПараметрыЗапроса.Организации.Добавить(ЗначениеФильтра);

КонецПроцедуры

#КонецОбласти

Функция ЕстьРеквизитТабличнойЧастиОбъекта(ПутьКДанным, МетаданныеОбъекта)

	КомпонентыПути = СтрРазделить(ПутьКДанным, ".");
	Если КомпонентыПути.Количество() <> 2 Тогда
		Возврат Ложь;
	КонецЕсли;

	ТабличнаяЧасть = МетаданныеОбъекта.ТабличныеЧасти.Найти(КомпонентыПути[0]);
	Если ТабличнаяЧасть = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;

	Реквизит = ТабличнаяЧасть.Реквизиты.Найти(КомпонентыПути[1]);
	Возврат Реквизит <> Неопределено;

КонецФункции

Функция ТекстовоеПредставлениеОрганизаций(Коллекция)

	ВыбранныеОрганизации = Коллекция.Выгрузить().ВыгрузитьКолонку("Организация");
	Результат = СтрСоединить(ВыбранныеОрганизации, ", ");
	Возврат Результат;

КонецФункции

Функция ТекстовоеПредставлениеМагазиновИСкладов(Коллекция)

	Если Не ЗначениеЗаполнено(Коллекция) Тогда
		Возврат "";
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаВыбранныхЗначений.Ссылка КАК СсылкаНаОбъект
	|ПОМЕСТИТЬ ТаблицаВыбранныхЗначений
	|ИЗ
	|	&ТаблицаВыбранныхЗначений КАК ТаблицаВыбранныхЗначений
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	СсылкаНаОбъект
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтруктурныеЕдиницы.Наименование КАК НаименованиеОбъекта,
	|	ТаблицаВыбранныхЗначений.СсылкаНаОбъект КАК СсылкаНаОбъект,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПодчиненныеЭлементы.Ссылка) КАК ЕстьПодчиненные
	|ИЗ
	|	ТаблицаВыбранныхЗначений КАК ТаблицаВыбранныхЗначений
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктурныеЕдиницы КАК ПодчиненныеЭлементы
	|		ПО ПодчиненныеЭлементы.Родитель = ТаблицаВыбранныхЗначений.СсылкаНаОбъект
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|		ПО СтруктурныеЕдиницы.Ссылка = ТаблицаВыбранныхЗначений.СсылкаНаОбъект
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаВыбранныхЗначений.СсылкаНаОбъект,
	|	СтруктурныеЕдиницы.Наименование";

	Запрос.УстановитьПараметр("ТаблицаВыбранныхЗначений", Коллекция);

	Выборка = Запрос.Выполнить().Выбрать();

	КомпонентыПредставления = Новый Массив;

	Пока Выборка.Следующий() Цикл

		НаименованиеОбъекта = Выборка.НаименованиеОбъекта;

		Если Выборка.ЕстьПодчиненные > 0 Тогда
			НаименованиеОбъекта = СтрШаблон(НСтр("ru = '%1 (Включая подчиненные)'"), НаименованиеОбъекта);
		КонецЕсли;

		КомпонентыПредставления.Добавить(НаименованиеОбъекта);

	КонецЦикла;

	Возврат СтрСоединить(КомпонентыПредставления, ", ");

КонецФункции

#КонецОбласти
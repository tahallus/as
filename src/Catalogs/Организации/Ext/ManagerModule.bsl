﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

#Область УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Ссылка)";

КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеОбъектов

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
	Возврат;
КонецПроцедуры

#КонецОбласти

#Область ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	Возврат;
КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "РеквизитыОрганизации";
	КомандаПечати.Представление = НСтр("ru = 'Реквизиты'");
	КомандаПечати.СписокФорм = "ФормаЭлемента,ФормаСписка";
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Печать реквизитов организации'");
	КомандаПечати.Порядок = 1;

КонецПроцедуры

// Сформировать печатные формы объектов.
//
// Параметры:
//  МассивОбъектов - Массив - массив ссылок на объекты которые нужно распечатать (входящий),
//  ПараметрыПечати - Структура - структура дополнительных параметров печати (входящий),
//  КоллекцияПечатныхФорм - ТаблицаЗначений - Сформированные табличные документы (исходящий),
//  ОбъектыПечати - СписокЗначений - объекты печати, в поле "Значение" передается ссылка на объект,
//                     в поле "Представление" имя области, в которой был выведен объект (исходящий),
//  ПараметрыВывода - Структура - параметры сформированных табличных документов (исходящий).
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РеквизитыОрганизации") Тогда

		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, "РеквизитыОрганизации", НСтр("ru='Реквизиты организации'"),
			ПечатьКарточкиОрганизации(МассивОбъектов, ОбъектыПечати));

	КонецЕсли;

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "НапечататьПомощникСозданияФаксимилеПечати") Тогда

		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, "НапечататьПомощникСозданияФаксимилеПечати", НСтр(
			"ru='Как быстро и просто создать факсимиле печати?'"), СформироватьПомощникРаботыФаксимильнойПечати(
			МассивОбъектов, ОбъектыПечати, "ПомощникСозданияФаксимилеПечати"));

	КонецЕсли;

	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм,
		"ПредварительныйПросмотрПечатнойФормыСчетНаОплату");
	Если ПечатнаяФорма <> Неопределено Тогда

		ПечатнаяФорма.ТабличныйДокумент = Новый ТабличныйДокумент;
		ПечатнаяФорма.ТабличныйДокумент.КлючПараметровПечати = Обработки.ПечатьСчетНаОплату.КлючПараметровПечати();
		ПечатнаяФорма.ПолныйПутьКМакету = Обработки.ПечатьСчетНаОплату.ПолныйПутьКМакету();
		ПечатнаяФорма.СинонимМакета = Обработки.ПечатьСчетНаОплату.ПредставлениеПФ(Ложь);

		ДанныеОбъектовПечати = УниверсальныйЗапросПоДаннымДокумента(МассивОбъектов);
		Обработки.ПечатьСчетНаОплату.СформироватьПФ(ПечатнаяФорма, ДанныеОбъектовПечати, ОбъектыПечати, Ложь);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ТекущиеДела

// Заполняет список текущих дел пользователя.
// 
// Параметры:
// 	ТекущиеДела - См. ТекущиеДелаСлужебный.ТекущиеДела
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт

	ГруппаДел = НСтр("ru = 'ЭДО'");
	
	// Сервис 1С-ЭДО в режиме сервиса не работает
	Если РаботаВМоделиСервиса.РазделениеВключено() Или ТекущиеДелаСервер.ДелоОтключено(ГруппаДел) Тогда
		Возврат;
	КонецЕсли;

	СпособыОЭД = Новый Массив;
	СпособыОЭД.Добавить(Перечисления.СпособыОбменаЭД.ЧерезСервис1СЭДО);
	ВключенОбменЭД = ПолучитьФункциональнуюОпцию("ИспользоватьОбменЭД");
	ЕстьПравоНастройкиЭДО = УправлениеДоступомУНФ.ЕстьПравоНастройкиЭДО();

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка КАК Организация,
	|	Организации.Наименование КАК Наименование
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.ПометкаУдаления = ЛОЖЬ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование";

	Выборка = Запрос.Выполнить().Выбрать();
	НомерПоПорядку = 0;

	Пока Выборка.Следующий() Цикл

		Если ОбменСКонтрагентами.ОрганизацияПодключена(Выборка.Организация) Тогда
			Продолжить;
		КонецЕсли;

		НомерПоПорядку = НомерПоПорядку + 1;

		Дело = ТекущиеДела.Добавить();
		Дело.Идентификатор	 = "ПодключениеЭДО_" + НомерПоПорядку;
		Дело.ЕстьДела		= Истина;
		Дело.Важное			= Ложь;
		Дело.Представление	= НСтр("ru='Подключиться к 1С-ЭДО'") + ", " + Выборка.Наименование;
		Дело.Количество		= 0;
		Дело.Владелец		= ГруппаДел;

		Если ВключенОбменЭД Тогда

			Если ЕстьПравоНастройкиЭДО Тогда
				Дело.Форма			= "РегистрСведений.УчетныеЗаписиЭДО.Форма.ПомощникПодключенияЭДО";
				Дело.ПараметрыФормы = Новый Структура("Организация,СпособыОбменаЭД", Выборка.Организация, СпособыОЭД);
				Дело.Подсказка	= НСтр("ru='Подключиться к 1С-ЭДО (обмену электронными документами)'") + ", "
					+ Выборка.Наименование;
			Иначе
				Дело.Форма			= "";
				Дело.ПараметрыФормы = Новый Структура;
				Дело.Подсказка	= НСтр(
					"ru='Недостаточно прав для настройки обмена электронными документами. Обратитесь к администратору.'");
			КонецЕсли;

		ИначеЕсли Пользователи.ЭтоПолноправныйПользователь() Тогда

			Дело.Форма			= "Обработка.ПанельАдминистрированияЭДО.Форма.ОбменЭлектроннымиДокументами";
			Дело.ПараметрыФормы = Новый Структура;
			Дело.Подсказка	= НСтр("ru='Необходимо включить обмен электронными документами с контрагентами.'");

		Иначе

			Дело.Форма			= "";
			Дело.ПараметрыФормы = Новый Структура;
			Дело.Подсказка	= НСтр(
				"ru='Для включения возможности обмена электронными документами с контрагентами обратитесь к администратору.'");

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ОбновлениеВерсииИБ

// Определяет настройки начального заполнения элементов.
//
// Параметры:
//  Настройки - Структура - настройки заполнения
//   * ПриНачальномЗаполненииЭлемента - Булево - Если Истина, то для каждого элемента будет
//      вызвана процедура индивидуального заполнения ПриНачальномЗаполненииЭлемента.
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт

	Настройки.ПриНачальномЗаполненииЭлемента = Ложь;

КонецПроцедуры

// Вызывается при начальном заполнении справочника Организации.
//
// Параметры:
//  КодыЯзыков - Массив - список языков конфигурации. Актуально для мультиязычных конфигураций.
//  Элементы   - ТаблицаЗначений - данные заполнения. Состав колонок соответствует набору реквизитов
//                                 справочника Организации.
//  ТабличныеЧасти - Структура - описание табличных частей объекта, где:
//   * Ключ - Строка - имя табличной части;
//   * Значение - ТаблицаЗначений - табличная часть в виде таблицы значений, структуру которой
//                                  необходимо скопировать перед заполнением. Например:
//                                  Элемент.Ключи = ТабличныеЧасти.Ключи.Скопировать();
//                                  ЭлементТЧ = Элемент.Ключи.Добавить();
//                                  ЭлементТЧ.ИмяКлюча = "Первичный";
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт

	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ОсновнаяОрганизация";
	Элемент.Наименование = НСтр("ru = 'Наша фирма'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Код = "00-000001";
	Элемент.НаименованиеПолное = НСтр("ru = 'ООО ""Наша фирма""'");
	Элемент.Префикс = НСтр("ru = 'НФ-'");
	Элемент.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
	Элемент.НДСВключатьВСтоимость = Истина;
	Элемент.ВидСтавкиНДСПоУмолчанию = Перечисления.ВидыСтавокНДС.Общая;

КонецПроцедуры

#КонецОбласти

#Область ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив Из Строка
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт

	Результат = Новый Массив;

	Результат.Добавить("Префикс");
	Результат.Добавить("КонтактнаяИнформация.*");

	Возврат Результат

КонецФункции

#КонецОбласти

#КонецОбласти

// Возвращает организацию назначенную в качестве Компании.
//
// Возвращаемое значение:
// 	СправочникСсылка.Организации - организация, назначенная в качестве Компании.
Функция ОрганизацияКомпания() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Компания.Значение КАК Значение
	|ИЗ
	|	Константа.Компания КАК Компания
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО Компания.Значение = Организации.Ссылка";

	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Значение;
	Иначе
		Возврат ПустаяСсылка();
	КонецЕсли;

КонецФункции

// Возвращает организацию по умолчанию.
// Если в ИБ есть только одна организация, которая не помечена на удаление и не является предопределенной,
// то будет возвращена ссылка на нее, иначе будет возвращена пустая ссылка.
//
// Возвращаемое значение:
// 	СправочникСсылка.Организации - ссылка на организацию.
Функция ОрганизацияПоУмолчанию() Экспорт

	Организация = ПустаяСсылка();

	ОрганизацияКомпании = ОрганизацияКомпания();
	ПользовательскаяНастройкаОсновнойОрганизации = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
		Пользователи.АвторизованныйПользователь(), "ОсновнаяОрганизация");
	Если ЗначениеЗаполнено(ОрганизацияКомпании) Тогда

		Организация = ОрганизацияКомпании;

	ИначеЕсли ЗначениеЗаполнено(ПользовательскаяНастройкаОсновнойОрганизации) Тогда

		Организация = ПользовательскаяНастройкаОсновнойОрганизации;

	Иначе

		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
		|	Организации.Ссылка КАК Организация
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	НЕ Организации.ПометкаУдаления";

		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
			Организация = Выборка.Организация;
		Иначе
			Попытка
				Возврат ОсновнаяОрганизация;
			Исключение
				// если предопределенный элемент отсутствует в данных
				Возврат Организация;
			КонецПопытки;
		КонецЕсли;

	КонецЕсли;

	Возврат Организация;

КонецФункции

// Возвращает предопределенную организацию.
// 
// Возвращаемое значение:
// 	СправочникСсылка.Организации - предопределенный элемент справочника "Организации".
Функция ПредопределеннаяОрганизация() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка КАК Организация
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.Предопределенный";

	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Организация;
	Иначе
		Возврат ПустаяСсылка();
	КонецЕсли;

КонецФункции

// Возвращает количество элементов справочника Организации.
// Не учитывает предопределенные и помеченные на удаление элементы.
//
// Возвращаемое значение:
//     Число - количество организаций.
//
Функция КоличествоОрганизаций() Экспорт

	УстановитьПривилегированныйРежим(Истина);

	Количество = 0;

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	НЕ Организации.Предопределенный";

	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Количество = Выборка.Количество;
	КонецЕсли;

	УстановитьПривилегированныйРежим(Ложь);

	Возврат Количество;

КонецФункции

// Процедура добавляет в переданную структуру информацию о кассе по умолчанию организации и валюту денежных средств,
// если не заполнена основная касса в настройках пользователя.
//
// Параметры:
// 	ЗначенияЗаполнения - Структура - значения заполнения,
// 	Объект - ДанныеФормыСтруктура - данные заполняемого объекта,
// 	ЗначениеРеквизитаВалюта -СправочникСсылка.Валюты - значение реквизита "Валюта", 
// 	ИмяРеквизитаВалюта - Строка - имя реквизита "Валюта".
Процедура ДополнитьВалютуИКассуПоУмолчанию(ЗначенияЗаполнения, Объект, ЗначениеРеквизитаВалюта = Неопределено,
	ИмяРеквизитаВалюта = "") Экспорт

	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат;
	КонецЕсли;
	
	ТекКассаПоУмолчанию = КассаПоУмолчанию(Объект.Организация);

	Если Объект.Касса = ТекКассаПоУмолчанию Тогда
		Возврат;
	КонецЕсли;

	ПользовательскаяНастройкаОсновнойКассы = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
		Пользователи.АвторизованныйПользователь(), "ОсновнаяКасса");

	Если ЗначениеЗаполнено(ПользовательскаяНастройкаОсновнойКассы)
		И Не ПользовательскаяНастройкаОсновнойКассы.ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;

	ЗначенияЗаполнения.Вставить("Касса", ТекКассаПоУмолчанию);

	Если ЗначениеРеквизитаВалюта = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если ЗначениеЗаполнено(ЗначениеРеквизитаВалюта) Тогда
		ЗначенияЗаполнения.Вставить(ИмяРеквизитаВалюта, ЗначениеРеквизитаВалюта);
	Иначе
		ЗначенияЗаполнения.Вставить(ИмяРеквизитаВалюта, ТекКассаПоУмолчанию.ВалютаПоУмолчанию);
	КонецЕсли;

КонецПроцедуры

// Возвращает систему налогообложения организации.
// Параметры: 
//  Дата - Дата - ,
//  Организация - СправочникСсылка.Организации - .
// Возвращаемое значение:
//  Структура - ключи:
//   * Дата - Дата - дата применения системы налогообложения,
//   * СистемаНалогообложения - ПеречислениеСсылка.СистемыНалогообложения.
Функция ПолучитьСистемуНалогообложения(Дата, Организация) Экспорт

	Результат = Новый Структура;
	Результат.Вставить("Дата", '00010101');
	Результат.Вставить("СистемаНалогообложения", Перечисления.СистемыНалогообложения.ПустаяСсылка());

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СистемыНалогообложения.СистемаНалогообложения,
	|	СистемыНалогообложения.Период КАК Дата
	|ИЗ
	|	РегистрСведений.СистемыНалогообложенияОрганизаций.СрезПоследних(&Дата, Организация = &Организация) КАК
	|		СистемыНалогообложения";

	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат.Дата = Выборка.Дата;
		Результат.СистемаНалогообложения = Выборка.СистемаНалогообложения;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Возвращает значение функциональной опции 
// "ИспользоватьНесколькоОрганизаций".
//
// Возвращаемое значение:
//     Булево - признак использования нескольких организаций.
//
Функция ИспользуетсяНесколькоОрганизаций() Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
КонецФункции  

// КПП на дату
//
// Параметры:
//  Организация	 - СправочникСсылка.Организации	 - Организация, для которой нужно получить КПП
//  ДатаСведений - 	Дата - дата, на которую нужно получить значение КПП
// 
// Возвращаемое значение:
//   Строка - значение КПП на дату
//
Функция КППНаДату(Организация, ДатаСведений) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Организация)
		ИЛИ ТипЗнч(Организация) <> Тип("СправочникСсылка.Организации") Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДатаСведений) Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "КПП");
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("Организация", Организация);
	Запрос.Параметры.Вставить("ДатаСведений", ДатаСведений);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МАКСИМУМ(ИсторияКППОрганизаций.Период) КАК Период,
	|	ИсторияКППОрганизаций.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ЗначенияКПП
	|ИЗ
	|	Справочник.Организации.ИсторияКПП КАК ИсторияКППОрганизаций
	|ГДЕ
	|	ИсторияКППОрганизаций.Ссылка = &Организация
	|	И ИсторияКППОрганизаций.Период <= &ДатаСведений
	|
	|СГРУППИРОВАТЬ ПО
	|	ИсторияКППОрганизаций.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИсторияКППОрганизаций.КПП КАК КПП
	|ИЗ
	|	ЗначенияКПП КАК ЗначенияКПП
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации.ИсторияКПП КАК ИсторияКППОрганизаций
	|		ПО ЗначенияКПП.Ссылка = ИсторияКППОрганизаций.Ссылка
	|			И ЗначенияКПП.Период = ИсторияКППОрганизаций.Период";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.КПП;
	Иначе
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "КПП");
	КонецЕсли;
	
КонецФункции

// Полное наименование на дату
//
// Параметры:
//  Организация	 - СправочникСсылка.Организации	 - Организация, для которой нужно получить наименование
//  ДатаСведений - Дата - дата, на которую нужно получить значение наименования
// 
// Возвращаемое значение:
//   Строка - значение наименования на дату
//
Функция ПолноеНаименованиеНаДату(Организация, ДатаСведений) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Организация)
		ИЛИ ТипЗнч(Организация) <> Тип("СправочникСсылка.Организации") Тогда
		Возврат "";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаСведений) Тогда
		Запрос = Новый Запрос();
		Запрос.Параметры.Вставить("Организация", Организация);
		Запрос.Параметры.Вставить("ДатаСведений", ДатаСведений);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	МАКСИМУМ(ИсторияКППОрганизаций.Период) КАК Период,
		|	ИсторияКППОрганизаций.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ЗначенияНаименований
		|ИЗ
		|	Справочник.Организации.ИсторияКПП КАК ИсторияКППОрганизаций
		|ГДЕ
		|	ИсторияКППОрганизаций.Ссылка = &Организация
		|	И ИсторияКППОрганизаций.Период <= &ДатаСведений
		|
		|СГРУППИРОВАТЬ ПО
		|	ИсторияКППОрганизаций.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИсторияНаименованийОрганизаций.НаименованиеПолное КАК НаименованиеПолное
		|ИЗ
		|	ЗначенияНаименований КАК ЗначенияНаименований
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации.ИсторияНаименований КАК ИсторияНаименованийОрганизаций
		|		ПО ЗначенияНаименований.Ссылка = ИсторияНаименованийОрганизаций.Ссылка
		|			И ЗначенияНаименований.Период = ИсторияНаименованийОрганизаций.Период";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Возврат Выборка.НаименованиеПолное;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "НаименованиеПолное");
	
КонецФункции

// Наименование на дату
//
// Параметры:
//  Организация	 - СправочникСсылка.Организации	 - Организация, для которой нужно получить наименование
//  ДатаСведений - Дата - дата, на которую нужно получить значение наименования
// 
// Возвращаемое значение:
//   Строка - значение наименования на дату
//
Функция НаименованиеНаДату(Организация, ДатаСведений) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Организация)
		ИЛИ ТипЗнч(Организация) <> Тип("СправочникСсылка.Организации") Тогда
		Возврат "";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаСведений) Тогда
		Запрос = Новый Запрос();
		Запрос.Параметры.Вставить("Организация", Организация);
		Запрос.Параметры.Вставить("ДатаСведений", ДатаСведений);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	МАКСИМУМ(ИсторияНаименований.Период) КАК Период,
		|	ИсторияНаименований.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ЗначенияНаименований
		|ИЗ
		|	Справочник.Организации.ИсторияНаименований КАК ИсторияНаименований
		|ГДЕ
		|	ИсторияНаименований.Ссылка = &Организация
		|	И ИсторияНаименований.Период <= &ДатаСведений
		|
		|СГРУППИРОВАТЬ ПО
		|	ИсторияНаименований.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИсторияНаименованийОрганизаций.Представление КАК Представление
		|ИЗ
		|	ЗначенияНаименований КАК ЗначенияНаименований
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации.ИсторияНаименований КАК ИсторияНаименованийОрганизаций
		|		ПО ЗначенияНаименований.Ссылка = ИсторияНаименованийОрганизаций.Ссылка
		|			И ЗначенияНаименований.Период = ИсторияНаименованийОрганизаций.Период";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Возврат Выборка.Представление;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "Наименование");
	
КонецФункции

// Процедура устанавливает актуальное значение истории наименования
//
// Параметры:
//  НаименованиеСокращенное		 - Строка	 - текущее значение представления
//  НаименованиеПолное			 - Строка	 - текущее значение полного наименования
//  ИсторияНаименований	 - 	ТаблицаЗначений - таблица с историей наименования
//
Процедура УстановитьАктуальноеЗначениеИсторииНаименований(НаименованиеСокращенное, НаименованиеПолное, 
	ИсторияНаименований) Экспорт
	
	КоличествоЗаписей = ИсторияНаименований.Количество();
	
	Если КоличествоЗаписей > 0 Тогда
		
		ИсторияНаименований.Сортировать("Период");
		АктуальнаяЗаписьИстории = ИсторияНаименований[КоличествоЗаписей - 1];
		АктуальнаяЗаписьИстории.Представление = НаименованиеСокращенное;
		АктуальнаяЗаписьИстории.НаименованиеПолное = НаименованиеПолное;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура устанавливает актуальное значение истории КПП
//
// Параметры:
//  КПП			 - Строка	 - текущее значение КПП
//  ИсторияКПП	 - 	ТаблицаЗначений - таблица с историей КПП
//
Процедура УстановитьАктуальноеЗначениеИсторииКПП(КПП, ИсторияКПП) Экспорт
	
	КоличествоЗаписей = ИсторияКПП.Количество();
	
	Если КоличествоЗаписей > 0 Тогда
		
		ИсторияКПП.Сортировать("Период");
		АктуальнаяЗаписьИстории = ИсторияКПП[КоличествоЗаписей - 1];
		АктуальнаяЗаписьИстории.КПП = КПП;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)

	Если ПолучитьФункциональнуюОпцию("ЭтоМобильноеПриложение") Тогда
		Если ВидФормы = "ФормаОбъекта" Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "ФормаЭлементаМобильныйИнтерфейс";
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Процедура формирования макета печати
//
Функция СформироватьПомощникРаботыФаксимильнойПечати(МассивОрганизаций, ОбъектыПечати, ИмяМакета)

	ТабличныйДокумент = Новый ТабличныйДокумент;
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.Организации." + ИмяМакета);

	Для Каждого Организация Из МассивОрганизаций Цикл

		ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("ПоляКЗаполнению"));
		ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("Линия"));
		ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("Схема"));

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 1, ОбъектыПечати, Организация);

	КонецЦикла;

	ТабличныйДокумент.АвтоМасштаб = Истина;

	Возврат ТабличныйДокумент;

КонецФункции // СформироватьПомощникРаботыФаксимильнойПечати()

Функция УниверсальныйЗапросПоДаннымДокумента(МассивОбъектов)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаДокумента", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("Номер", "00000000001");
	Запрос.УстановитьПараметр("Организация", МассивОбъектов[0]);
	Запрос.УстановитьПараметр("ОрганизацияЮридическоеФизическоеЛицо", МассивОбъектов[0].ЮридическоеФизическоеЛицо);
	Запрос.УстановитьПараметр("Префикс", МассивОбъектов[0].Префикс);
	Запрос.УстановитьПараметр("БанковскийСчет", МассивОбъектов[0].БанковскийСчетПоУмолчанию);
	Запрос.УстановитьПараметр("ФайлЛоготип", МассивОбъектов[0].ФайлЛоготип);
	Запрос.УстановитьПараметр("ФайлФаксимильнаяПечать", МассивОбъектов[0].ФайлФаксимильнаяПечать);
	Запрос.УстановитьПараметр("ДолжностьРуководителя", МассивОбъектов[0].ПодписьРуководителя.Должность);
	Запрос.УстановитьПараметр("РасшифровкаПодписиРуководителя",
		МассивОбъектов[0].ПодписьРуководителя.РасшифровкаПодписи);
	Запрос.УстановитьПараметр("ФаксимилеПодписиРуководителя", МассивОбъектов[0].ПодписьРуководителя.Факсимиле);
	Запрос.УстановитьПараметр("РуководительДолжность", МассивОбъектов[0].ПодписьРуководителя.Должность);
	Запрос.УстановитьПараметр("РуководительРасшифровкаПодписи",
		МассивОбъектов[0].ПодписьРуководителя.РасшифровкаПодписи);
	Запрос.УстановитьПараметр("РуководительФаксимилеПодписи", МассивОбъектов[0].ПодписьРуководителя.Факсимиле);
	Запрос.УстановитьПараметр("ГлавныйБухгалтерДолжность", МассивОбъектов[0].ПодписьГлавногоБухгалтера.Должность);
	Запрос.УстановитьПараметр("ГлавныйБухгалтерРасшифровкаПодписи",
		МассивОбъектов[0].ПодписьГлавногоБухгалтера.РасшифровкаПодписи);
	Запрос.УстановитьПараметр("ГлавныйБухгалтерФаксимиле", МассивОбъектов[0].ПодписьГлавногоБухгалтера.Факсимиле);
	Запрос.УстановитьПараметр("ВалютаДокумента", Константы.НациональнаяВалюта.Получить());
	Запрос.УстановитьПараметр("Контрагент", Справочники.Контрагенты.ПустаяСсылка());
	Запрос.УстановитьПараметр("Договор", НСтр("ru ='Договор № 000001 от 30.12.1922'"));
	Запрос.УстановитьПараметр("ОснованиеПечати", НСтр("ru ='Договор № 000001 от 30.12.1922'"));
	Запрос.УстановитьПараметр("ЗапасДляПредварительногоПросмотра", НСтр("ru = 'Запас для предварительного просмотра'"));
	Запрос.УстановитьПараметр("Артикул", НСтр("ru = 'АРТ-0000001'"));
	Запрос.УстановитьПараметр("ЕдиницаИзмерения", НСтр("ru = 'шт.'"));

	Запрос.Текст =
	"ВЫБРАТЬ
	|	&Организация КАК Ссылка,
	|	&ДатаДокумента КАК ДатаДокумента,
	|	&Номер КАК Номер,
	|	&Организация КАК Организация,
	|	&ОрганизацияЮридическоеФизическоеЛицо КАК ОрганизацияЮридическоеФизическоеЛицо,
	|	&Префикс КАК Префикс,
	|	&БанковскийСчет КАК БанковскийСчет,
	|	&ФайлЛоготип КАК ФайлЛоготип,
	|	&ФайлФаксимильнаяПечать КАК ФаксимилеПечати,
	|	Неопределено КАК Подразделение,
	|	Значение(Перечисление.ДаНет.Да) КАК ИспользоватьФаксимиле,
	|	&РуководительДолжность КАК ДолжностьРуководителя,
	|	&РуководительРасшифровкаПодписи КАК РасшифровкаПодписиРуководителя,
	|	&РуководительРасшифровкаПодписи КАК РасшифровкаПодписиВыполнилРаботыУслуги,
	|	&РуководительФаксимилеПодписи КАК ФаксимилеРуководителя,
	|	&ГлавныйБухгалтерДолжность КАК ДолжностьГлавногоБухгалтера,
	|	&ГлавныйБухгалтерРасшифровкаПодписи КАК РасшифровкаПодписиГлавногоБухгалтера,
	|	&ГлавныйБухгалтерФаксимиле КАК ФаксимилеГлавногоБухгалтера,
	|	ИСТИНА КАК СуммаВключаетНДС,
	|	&ВалютаДокумента КАК ВалютаДокумента,
	|	&Контрагент КАК Контрагент,
	|	&Договор КАК Договор,
	|	Неопределено КАК ДополнительныеУсловия,
	|	Неопределено КАК ДокументОснование,
	|	Неопределено КАК Ответственный,
	|	Неопределено КАК ФизическоеЛицоОтветственного,
	|	Неопределено КАК Автор,
	|	Неопределено КАК ДисконтнаяКарта,
	|	Неопределено КАК ПроцентСкидкиПоДисконтнойКарте,
	|	Неопределено КАК Комментарий,
	|	&ОснованиеПечати КАК ОснованиеПечати,
	|	Неопределено КАК ОснованиеПечатиСсылка,
	|	Неопределено КАК ТаблицаЗапасы,
	|	Неопределено КАК ТаблицаПланаОплат,
	|	ЛОЖЬ КАК ОжидаетсяВыборВариантаКП";

	ТаблицаСчета = Запрос.Выполнить().Выгрузить();

	Запрос.Текст =
	"ВЫБРАТЬ
	|	1 КАК НомерСтроки,
	|	&ЗапасДляПредварительногоПросмотра КАК ПредставлениеНоменклатуры,
	|	Неопределено КАК Характеристика,
	|	&Артикул КАК Артикул,
	|	""0000000001"" КАК Код,
	|	&ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	118 КАК Цена,
	|	118 КАК Сумма,
	|	18 КАК СуммаНДС,
	|	118 КАК Всего,
	|	1 КАК Количество,
	|	Неопределено КАК Содержание,
	|	0 КАК ПроцентСкидкиНаценки,
	|	0 КАК ЕстьСкидка,
	|	0 КАК СуммаАвтоматическойСкидки,
	|	ЛОЖЬ КАК ЭтоРазделитель,
	|	ЛОЖЬ КАК ЭтоНабор,
	|	ЛОЖЬ КАК НеобходимоВыделитьКакСоставНабора,
	|	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) КАК НоменклатураНабора,
	|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК ХарактеристикаНабора";

	ТаблицаСчета[0].ТаблицаЗапасы = Запрос.Выполнить().Выгрузить();

	Запрос.Текст =
	"ВЫБРАТЬ
	|	0 КАК ПроцентОплаты,
	|	0 КАК СуммаОплаты,
	|	0 КАК СуммаНДСОплаты";

	ТаблицаСчета[0].ТаблицаПланаОплат = Запрос.Выполнить().Выгрузить();

	Возврат ТаблицаСчета;

КонецФункции

// Процедура формирования табличного документа с реквизитами организаций
// 
// Параметры:
// 	МассивОбъектов - Массив из СправочникСсылка.Организации - организации.
// 	ОбъектыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ОбъектыПечати
// Возвращаемое значение:
// 	ТабличныйДокумент - Описание
Функция ПечатьКарточкиОрганизации(МассивОбъектов, ОбъектыПечати)

	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Организация_КарточкаОрганизации";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.Организации.РеквизитыОрганизации");
	Разделитель = Макет.ПолучитьОбласть("Разделитель");

	ТекДата = ТекущаяДатаСеанса();
	ПервыйДокумент = Истина;

	Для Каждого Организация Из МассивОбъектов Цикл

		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.Вывести(Разделитель);
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		ЭтоЮрЛицо = ЭтоЮрЛицо(Организация);

		СведенияОбОрганизации = ПечатьДокументовУНФ.СведенияОЮрФизЛице(Организация, ТекДата);

		Область = Макет.ПолучитьОбласть("Наименование");
		Область.Параметры.ПолноеНаименование = СведенияОбОрганизации.ПолноеНаименование;
		ТабличныйДокумент.Вывести(Область);

		Если ЗначениеЗаполнено(СведенияОбОрганизации.ИНН) Тогда
			Область = Макет.ПолучитьОбласть("ИНН");
			Область.Параметры.ИНН = СведенияОбОрганизации.ИНН;
			ТабличныйДокумент.Вывести(Область);
		КонецЕсли;

		Если ЭтоЮрЛицо И ЗначениеЗаполнено(СведенияОбОрганизации.КПП) Тогда
			Область = Макет.ПолучитьОбласть("КПП");
			Область.Параметры.КПП = СведенияОбОрганизации.КПП;
			ТабличныйДокумент.Вывести(Область);
		КонецЕсли;

		Если ЗначениеЗаполнено(СведенияОбОрганизации.КодПоОКПО) Тогда
			Область = Макет.ПолучитьОбласть("ОКПО");
			Область.Параметры.КодПоОКПО = СведенияОбОрганизации.КодПоОКПО;
			ТабличныйДокумент.Вывести(Область);
		КонецЕсли;

		Если ЗначениеЗаполнено(СведенияОбОрганизации.НомерСчета) И ЗначениеЗаполнено(СведенияОбОрганизации.БИК)
			И ЗначениеЗаполнено(СведенияОбОрганизации.КоррСчет) И ЗначениеЗаполнено(СведенияОбОрганизации.Банк) Тогда
			Область = Макет.ПолучитьОбласть("РасчетныйСчет");
			Область.Параметры.НомерСчета = СведенияОбОрганизации.НомерСчета;
			Область.Параметры.БИК = СведенияОбОрганизации.БИК;
			Область.Параметры.КоррСчет = СведенияОбОрганизации.КоррСчет;
			Область.Параметры.Банк = СведенияОбОрганизации.Банк;
			ТабличныйДокумент.Вывести(Область);
		КонецЕсли;

		Если ЗначениеЗаполнено(СведенияОбОрганизации.ЮридическийАдрес) Или ЗначениеЗаполнено(
			СведенияОбОрганизации.Телефоны) Тогда
			ТабличныйДокумент.Вывести(Разделитель);
		КонецЕсли;

		Если ЭтоЮрЛицо И ЗначениеЗаполнено(СведенияОбОрганизации.ЮридическийАдрес) Тогда
			Область = Макет.ПолучитьОбласть("ЮридическийАдрес");
			Область.Параметры.ЮридическийАдрес = СведенияОбОрганизации.ЮридическийАдрес;
			ТабличныйДокумент.Вывести(Область);
		КонецЕсли;

		Если Не ЭтоЮрЛицо И ЗначениеЗаполнено(СведенияОбОрганизации.ЮридическийАдрес) Тогда
			Область = Макет.ПолучитьОбласть("АдресИП");
			Область.Параметры.АдресИП = СведенияОбОрганизации.ЮридическийАдрес;
			ТабличныйДокумент.Вывести(Область);
		КонецЕсли;

		Если ЗначениеЗаполнено(СведенияОбОрганизации.Телефоны) Тогда
			Область = Макет.ПолучитьОбласть("Телефон");
			Область.Параметры.Телефон = СведенияОбОрганизации.Телефоны;
			ТабличныйДокумент.Вывести(Область);
		КонецЕсли;

		Если Не ЭтоЮрЛицо И СведенияОбОрганизации.Свойство("СвидетельствоСерияНомер") И ЗначениеЗаполнено(
			СведенияОбОрганизации.СвидетельствоСерияНомер) И СведенияОбОрганизации.Свойство("СвидетельствоДатаВыдачи")
			И ЗначениеЗаполнено(СведенияОбОрганизации.СвидетельствоДатаВыдачи) Тогда
			Область = Макет.ПолучитьОбласть("Свидетельство");
			Область.Параметры.СвидетельствоСерияНомер = СведенияОбОрганизации.СвидетельствоСерияНомер;
			Область.Параметры.СвидетельствоДатаВыдачи = Формат(СведенияОбОрганизации.СвидетельствоДатаВыдачи, "ДЛФ=D");
			ТабличныйДокумент.Вывести(Область);
		КонецЕсли;

		ПодписьРуководителя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ПодписьРуководителя");

		Если ЭтоЮрЛицо И ЗначениеЗаполнено(ПодписьРуководителя) Тогда

			Область = Макет.ПолучитьОбласть("Руководитель");
			Область.Параметры.Должность = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПодписьРуководителя, "Должность");
			Область.Параметры.РасшифровкаПодписи = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				ПодписьРуководителя, "РасшифровкаПодписи");

			ТабличныйДокумент.Вывести(Область);

		КонецЕсли;

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Организация);

	КонецЦикла;

	Возврат ТабличныйДокумент;

КонецФункции

Функция ЭтоЮрЛицо(Организация)
	ЮридическоеФизическоеЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ЮридическоеФизическоеЛицо");
	Возврат ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
КонецФункции

#КонецОбласти

Функция КассаПоУмолчанию(Организация)
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат Справочники.Кассы.ПустаяСсылка();
	КонецЕсли;
	
	Если Не УправлениеДоступом.ЧтениеРазрешено(Организация) Тогда
		Возврат Справочники.Кассы.ПустаяСсылка();
	КонецЕсли;
	
	Результат = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "КассаПоУмолчанию");
	Если Не УправлениеДоступом.ЧтениеРазрешено(Результат) Тогда
		Возврат Справочники.Кассы.ПустаяСсылка();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Возврат Справочники.Кассы.ПустаяСсылка();
	КонецЕсли;
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Результат, "ПометкаУдаления") = Истина Тогда
		Возврат Справочники.Кассы.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
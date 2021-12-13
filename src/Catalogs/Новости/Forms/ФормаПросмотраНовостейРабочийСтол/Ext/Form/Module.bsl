﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если ОбработкаНовостейПовтИсп.РазрешенаРаботаСНовостямиТекущемуПользователю() <> Истина Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;

	// В конфигурации есть общие реквизиты с разделением и включена ФО РаботаВМоделиСервиса.
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		// Если включено разделение данных, и мы зашли в неразделенном сеансе,
		//  то нельзя устанавливать пользовательские свойства новости.
		// Зашли в конфигурацию под пользователем без разделения (и не вошли в область данных).
		Если ИнтернетПоддержкаПользователей.СеансЗапущенБезРазделителей() Тогда
			ПолучитьТекущегоПользователя = Ложь;
		Иначе
			ПолучитьТекущегоПользователя = Истина;
		КонецЕсли;
	Иначе
		ПолучитьТекущегоПользователя = Истина;
	КонецЕсли;

	Если ПолучитьТекущегоПользователя = Истина Тогда
		ЭтотОбъект.ПараметрыСеанса_ТекущийПользователь = Пользователи.ТекущийПользователь();
	Иначе
		ЭтотОбъект.ПараметрыСеанса_ТекущийПользователь = Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;

	ТипСтруктура = Тип("Структура");

	ЭтотОбъект.РежимПросмотра = "Декорации"; // Возможные значения: Декорации, ТаблицаЗначений, ФоновоеОбновление, Листание, Автолистание.
	ЭтотОбъект.ЧастотаАвтолистания = 10; // Секунд
	ЭтотОбъект.КоличествоНовостейДляЛистанияМаксимум = 5; // Реальное количество переключателей будет подстраиваться под количество новостей.

	СтруктураНастроекПоказаНовостей = ХранилищаНастроек.НастройкиНовостей.Загрузить(
		"НастройкиПоказаНовостей",
		"");
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураНастроекПоказаНовостей);

	ВозвращаемыеЗначения = Неопределено;
	ОбработкаНовостейПереопределяемый.ДополнительноОбработатьФормуПросмотраНовостейДляРабочегоСтолаПриСозданииНаСервере(
		ЭтотОбъект,
		ВозвращаемыеЗначения);

	Если (ЭтотОбъект.ЧастотаАвтолистания < 5) Тогда
		ЭтотОбъект.ЧастотаАвтолистания = 5;
	КонецЕсли;
	Если ЭтотОбъект.КоличествоНовостейДляЛистанияМаксимум <= 0 Тогда
		ЭтотОбъект.КоличествоНовостейДляЛистанияМаксимум = 5; // Реальное количество переключателей будет подстраиваться под количество новостей.
	КонецЕсли;

	ЭтотОбъект.ПропуститьЗаполнениеНовостями = Ложь;
	Если ТипЗнч(ВозвращаемыеЗначения) = ТипСтруктура Тогда
		Если (ВозвращаемыеЗначения.Свойство("ПропуститьЗаполнениеНовостями") = Истина)
				И (ВозвращаемыеЗначения.ПропуститьЗаполнениеНовостями = Истина) Тогда
			ЭтотОбъект.ПропуститьЗаполнениеНовостями = Истина;
		КонецЕсли;
	КонецЕсли;

	Если ЭтотОбъект.ПропуститьЗаполнениеНовостями <> Истина Тогда
		// Автоматически заполнить новостями и обновить форму.
		ЗагрузитьНовостиИОбновитьФормуСервер();
	Иначе
		// Если текст новости выводится прямо в этом окне, то заранее заполнить тексты новостей.
		ЗаполнитьТекстНовостейХТМЛ();
		// Только обновить форму - новости могут быть заполнены в переопределяемом модуле.
		УправлениеФормой();
		УстановитьУсловноеОформление();
	КонецЕсли;

	Если (ОбработкаНовостейПовтИсп.ЕстьРолиЧтенияНовостей()) Тогда
		Элементы.ГруппаНавигация.Видимость = Истина;
	Иначе
		Элементы.ГруппаНавигация.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если ЭтотОбъект.ПропуститьЗаполнениеНовостями <> Истина Тогда
		Если ЭтотОбъект.СписокНовостей_ИнтервалАвтообновления < 1 Тогда
			ЭтотОбъект.СписокНовостей_ИнтервалАвтообновления = 15;
		КонецЕсли;
		ЭтотОбъект.ПодключитьОбработчикОжидания("Подключаемый_АвтообновлениеСпискаНовостей", ЭтотОбъект.СписокНовостей_ИнтервалАвтообновления * 60, Ложь);
	КонецЕсли;

	// При создании на сервере были обнаружены интерактивные действия для клиента?
	Если ЭтотОбъект.ИнтерактивныеДействияПриОткрытии.Количество() > 0 Тогда
		ИнтерактивныеДействия = ЭтотОбъект.ИнтерактивныеДействияПриОткрытии.ВыгрузитьЗначения();
		ОбработкаНовостейКлиент.ВыполнитьИнтерактивныеДействия(ИнтерактивныеДействия);
	КонецЕсли;

	// Подключить автолистание.
	Если (ВРег(ЭтотОбъект.РежимПросмотра) = ВРег("Автолистание")) Тогда
		ЭтотОбъект.ОтключитьОбработчикОжидания("Подключаемый_ВыполнитьАвтолистание");
		Если ЭтотОбъект.КоличествоНовостейДляЛистания > 1 Тогда
			ЭтотОбъект.ПодключитьОбработчикОжидания("Подключаемый_ВыполнитьАвтолистание", ЭтотОбъект.ЧастотаАвтолистания, Ложь);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "Новости. Новость прочтена" Тогда
		// Не обновлять список новостей.

	ИначеЕсли ИмяСобытия = "Новости. Загружены новости" Тогда
		Если Источник <> ЭтотОбъект.УникальныйИдентификатор Тогда
			ЗагрузитьНовостиИОбновитьФормуСервер();
		КонецЕсли;

	ИначеЕсли ИмяСобытия = "Новости. Обновлены настройки чтения новостей" Тогда
		ПриСозданииНаСервере(Ложь, Истина);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПереходКНовости(Элемент)

	ИдентификаторЭлемента = Число(Сред(Элемент.Имя, 17, 3));
	Если (ИдентификаторЭлемента > 0) И (ИдентификаторЭлемента <= ЭтотОбъект.Новости.Количество()) Тогда
		ТекущаяСтрока = ЭтотОбъект.Новости[ИдентификаторЭлемента-1];
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("ИнициаторОткрытияНовости", "ФормаПросмотраНовостейРабочийСтол"); // Идентификатор.
		ПараметрыОткрытияФормы.Вставить("НовостьНаименование", ТекущаяСтрока.Наименование); // Заголовок новости.
		ПараметрыОткрытияФормы.Вставить("НовостьКодЛентыНовостей", ТекущаяСтрока.КодЛентыНовостей); // Код ленты новостей.
		ОбработкаНовостейКлиент.ПоказатьНовость(
			ТекущаяСтрока.Ссылка, // НовостьСсылка
			ПараметрыОткрытияФормы, // ПараметрыОткрытияФормы. БлокироватьОкноВладельца не нужно,
			       // т.к. неизвестно что будет за владелец и блокировать первое попавшееся окно неправильно.
			ЭтотОбъект, // ФормаВладелец
			Ложь); // Уникальность по-умолчанию (по ссылке)
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИндексТекущейНовостиПриИзменении(Элемент)

	// Если пользователь явно нажал на кнопку выбора новости, то остановить автолистание.
	// Оно автоматически включится после обновления списка новостей.
	// Отключить автолистание.
	Если (ВРег(ЭтотОбъект.РежимПросмотра) = ВРег("Автолистание")) Тогда
		ЭтотОбъект.ОтключитьОбработчикОжидания("Подключаемый_ВыполнитьАвтолистание");
	КонецЕсли;

	// Вывести текст текущей новости.
	ЭтотОбъект.ТекстНовостиХТМЛ = ЭтотОбъект.Новости.Получить(ЭтотОбъект.ИндексТекущейНовости).ТекстНовостиХТМЛ;

КонецПроцедуры

&НаКлиенте
Процедура ТекстНовостиХТМЛПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)

	// Отключить автолистание.
	Если (ВРег(ЭтотОбъект.РежимПросмотра) = ВРег("Автолистание")) Тогда
		ЭтотОбъект.ОтключитьОбработчикОжидания("Подключаемый_ВыполнитьАвтолистание");
	КонецЕсли;

	лкОбъект = ЭтотОбъект.Новости.Получить(ЭтотОбъект.ИндексТекущейНовости).Ссылка; // При открытии из формы элемента справочника / документа

	ОбработкаНовостейКлиент.ОбработкаНажатияВТекстеНовости(лкОбъект, ДанныеСобытия, СтандартнаяОбработка, ЭтотОбъект, Элемент);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Новости

&НаКлиенте
Процедура НовостиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если ВыбраннаяСтрока <> Неопределено Тогда
		ТекущаяНовость = ЭтотОбъект.Новости.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если ТекущаяНовость <> Неопределено Тогда
			Если НЕ ТекущаяНовость.Ссылка.Пустая() Тогда
				ПараметрыОткрытияФормы = Новый Структура;
				ПараметрыОткрытияФормы.Вставить("ИнициаторОткрытияНовости", "ФормаПросмотраНовостейРабочийСтол"); // Идентификатор.
				ПараметрыОткрытияФормы.Вставить("НовостьНаименование", ТекущаяНовость.Наименование); // Заголовок новости.
				ПараметрыОткрытияФормы.Вставить("НовостьКодЛентыНовостей", ТекущаяНовость.КодЛентыНовостей); // Код ленты новостей.
				ОбработкаНовостейКлиент.ПоказатьНовость(
					ТекущаяНовость.Ссылка, // НовостьСсылка
					, // ПараметрыОткрытияФормы. БлокироватьОкноВладельца не нужно, т.к. неизвестно что будет за владелец
					       // и блокировать первое попавшееся окно неправильно.
					, // ФормаВладелец
					Ложь); // Уникальность по-умолчанию (по ссылке)
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура обновляет все информационные надписи, но не устанавливает видимость групп СтраницаДекорации или СтраницаТаблицаЗначений.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура УправлениеФормой()

	Если ВРег(ЭтотОбъект.РежимПросмотра) = ВРег("Декорации") Тогда

		// Все новости делать в виде гиперссылок
		ВсегоНовостей = 3;
		Для С=1 По ВсегоНовостей Цикл
			ЭлементТекстНовости   = Элементы["ДекорацияНовость" + Формат(С, "ЧЦ=3; ЧДЦ=0; ЧН=000; ЧВН=; ЧГ=0") + "ТекстНовости"];
			ЭлементДатаПубликации = Элементы["ДекорацияНовость" + Формат(С, "ЧЦ=3; ЧДЦ=0; ЧН=000; ЧВН=; ЧГ=0") + "ДатаПубликации"];
			Если ЭтотОбъект.Новости.Количество() < С Тогда
				ЭлементТекстНовости.Видимость   = Ложь;
				ЭлементДатаПубликации.Видимость = Ложь;
			Иначе
				ЭлементТекстНовости.Видимость   = Истина;
				ЭлементДатаПубликации.Видимость = Истина;
				ЭлементТекстНовости.Заголовок   = ЭтотОбъект.Новости[С-1].Наименование;
				ЭлементДатаПубликации.Заголовок = Формат(
					МестноеВремя(ЭтотОбъект.Новости[С-1].ДатаПубликации, ЧасовойПояс()),
					ОбработкаНовостей.ФорматДатыВремениДляНовости());
			КонецЕсли;
		КонецЦикла;

		Если ЭтотОбъект.Новости.Количество() = 0 Тогда
			Элементы.ДекорацияНетНовостей.Видимость = Истина;
		Иначе
			Элементы.ДекорацияНетНовостей.Видимость = Ложь;
		КонецЕсли;

		// Переключить на страницу.
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаДекорации;

	ИначеЕсли ВРег(ЭтотОбъект.РежимПросмотра) = ВРег("ТаблицаЗначений") Тогда

		// Переключить на страницу.
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаТаблицаЗначений;

	ИначеЕсли ВРег(ЭтотОбъект.РежимПросмотра) = ВРег("ФоновоеОбновление") Тогда

		// Переключить на страницу.
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаДекорации; ////?

	ИначеЕсли (ВРег(ЭтотОбъект.РежимПросмотра) = ВРег("Листание"))
			ИЛИ (ВРег(ЭтотОбъект.РежимПросмотра) = ВРег("Автолистание")) Тогда
		// Исправить количество новостей для листания.
		ЭтотОбъект.КоличествоНовостейДляЛистания = Мин(ЭтотОбъект.Новости.Количество(), ЭтотОбъект.КоличествоНовостейДляЛистанияМаксимум);
		// Переключить на страницу.
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЛистание;
		// Перерисовать поле переключателей.
		Элементы.ИндексТекущейНовости.СписокВыбора.Очистить();
		Для С=0 По ЭтотОбъект.КоличествоНовостейДляЛистания-1 Цикл
			Элементы.ИндексТекущейНовости.СписокВыбора.Добавить(С, " ");
		КонецЦикла;
		// Если количество новостей для листания = 1, то скрыть поле переключателей.
		Если ЭтотОбъект.КоличествоНовостейДляЛистания <= 1 Тогда
			Элементы.ГруппаИндексТекущейНовости.Видимость = Ложь;
		Иначе
			Элементы.ГруппаИндексТекущейНовости.Видимость = Истина;
		КонецЕсли;
		// Сбросить счетчик текущей новости.
		ЭтотОбъект.ИндексТекущейНовости = 0;
		// Вывести текст текущей новости.
		ЭтотОбъект.ТекстНовостиХТМЛ = ЭтотОбъект.Новости.Получить(ЭтотОбъект.ИндексТекущейНовости).ТекстНовостиХТМЛ;

	КонецЕсли;

КонецПроцедуры

// Функция заполняет табличную часть "Новости" из справочника "Новости".
// Запускается только в том случае, если новости не были получены вручную.
// Возвращается массив интерактивных действий (если нужно): оповещения пользователю и т.п.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Массив структур.
//
&НаСервере
Функция ОбновитьСписокНовостейСервер()

	ИнтерактивныеДействия = Новый Массив;

	Справочники.Новости.ПолучитьСписокНовостей(
		ЭтотОбъект.Новости,
		ЭтотОбъект.ПараметрыСеанса_ТекущийПользователь,
		Новый Структура("ВариантОтбора", 0),
		ИнтерактивныеДействия);

	ЭтотОбъект.Новости.Сортировать("ДатаПубликации УБЫВ");

	// Заполнить текст новостей.
	ЗаполнитьТекстНовостейХТМЛ();

	// После загрузки новостей обновить отображение быстрых фильтров.
	УправлениеФормой();

	Возврат ИнтерактивныеДействия;

КонецФункции

// Процедура заполняет колонку "ТекстНовостиХТМЛ" табличной части "Новости".
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура ЗаполнитьТекстНовостейХТМЛ()

	// Заполнить текст новостей.
	Если (ВРег(ЭтотОбъект.РежимПросмотра) = ВРег("Листание"))
			ИЛИ (ВРег(ЭтотОбъект.РежимПросмотра) = ВРег("Автолистание")) Тогда
		С = 0; // АПК:247 это счетчик.
		Для Каждого ТекущаяНовость Из ЭтотОбъект.Новости Цикл
			Если С >= ЭтотОбъект.КоличествоНовостейДляЛистанияМаксимум Тогда
				Прервать;
			КонецЕсли;
			Если ПустаяСтрока(ТекущаяНовость.ТекстНовостиХТМЛ) И (НЕ ТекущаяНовость.Ссылка.Пустая()) Тогда
				ТекущаяНовость.ТекстНовостиХТМЛ = Справочники.Новости.ПолучитьХТМЛТекстНовостей(
					ТекущаяНовость.Ссылка,
					Новый Структура("ОтображатьЗаголовок",
						Ложь));
			КонецЕсли;
			С = С + 1; // АПК:247 это счетчик.
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

// Процедура для автоматического запуска обработкой ожидания - обновляет список новостей.
// В интерфейсе не видна.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура Подключаемый_АвтообновлениеСпискаНовостей()

	ИнтерактивныеДействия = ОбновитьСписокНовостейСервер();
	ОбработкаНовостейКлиент.ВыполнитьИнтерактивныеДействия(ИнтерактивныеДействия);

	// Исправить количество новостей для листания.
	ЭтотОбъект.КоличествоНовостейДляЛистания = Мин(ЭтотОбъект.Новости.Количество(), ЭтотОбъект.КоличествоНовостейДляЛистанияМаксимум);

	// Подключить автолистание.
	Если (ВРег(ЭтотОбъект.РежимПросмотра) = ВРег("Автолистание")) Тогда
		ЭтотОбъект.ОтключитьОбработчикОжидания("Подключаемый_ВыполнитьАвтолистание");
		Если ЭтотОбъект.КоличествоНовостейДляЛистания > 1 Тогда
			ЭтотОбъект.ПодключитьОбработчикОжидания("Подключаемый_ВыполнитьАвтолистание", ЭтотОбъект.ЧастотаАвтолистания, Ложь);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Процедура устанавливает условное оформление в форме.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

КонецПроцедуры

// Загружает новые новости и обновляет форму.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура ЗагрузитьНовостиИОбновитьФормуСервер()

	// Загрузка новостей в табличную часть из справочника.
	ИнтерактивныеДействия = ОбновитьСписокНовостейСервер(); // Здесь же вызовется УправлениеФормой();
	// ОбработкаНовостейКлиент.ВыполнитьИнтерактивныеДействия(ИнтерактивныеДействия); // На сервере вызвать нельзя, передадим на клиента через реквизиты формы.
	ЭтотОбъект.ИнтерактивныеДействияПриОткрытии.ЗагрузитьЗначения(ИнтерактивныеДействия);

	УстановитьУсловноеОформление();

КонецПроцедуры

// Процедура обеспечивает автопереключение новостей.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура Подключаемый_ВыполнитьАвтолистание()

	// Увеличить счетчик текущей новости.
	ЭтотОбъект.ИндексТекущейНовости = ЭтотОбъект.ИндексТекущейНовости + 1;
	Если ЭтотОбъект.ИндексТекущейНовости > (ЭтотОбъект.КоличествоНовостейДляЛистания - 1) Тогда
		ЭтотОбъект.ИндексТекущейНовости = 0;
	КонецЕсли;

	// Вывести текст текущей новости.
	ЭтотОбъект.ТекстНовостиХТМЛ = ЭтотОбъект.Новости.Получить(ЭтотОбъект.ИндексТекущейНовости).ТекстНовостиХТМЛ;

КонецПроцедуры

#КонецОбласти

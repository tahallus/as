#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция ДокументыОстатковНаДатуСвертки(ДатаСвертки) Экспорт

	Результат = Новый Массив;

	КоличествоРегистров = Метаданные.Документы.КорректировкаРегистров.Движения.Количество();
	Индекс = 0;

	Для Каждого ТекущийРегистр Из Метаданные.Документы.КорректировкаРегистров.Движения Цикл
		Индекс = Индекс + 1;
		Процент = Окр(Индекс / КоличествоРегистров * 100);
		ДлительныеОперации.СообщитьПрогресс(Процент, СтрШаблон(НСтр("ru = 'Формируются остатки для регистра ""%1""'"),
			ТекущийРегистр.Синоним));
		СформироватьОстаткиДляРегистра(ТекущийРегистр, ДатаСвертки, Результат);
	КонецЦикла;

	Возврат Результат;

КонецФункции

Функция ПометитьНаУдалениеОбъектыИУдалитьЗаписиРегистровДоДатыСвертки(ДатаСвертки) Экспорт

	Результат = Новый Массив;

	ПометитьНаУдалениеДокументы(ДатаСвертки, Результат);
	ПометитьНаУдалениеЭлементыСправочников(ДатаСвертки, Результат);
	УдалитьЗаписиРегистраБухгалтерии(ДатаСвертки);
	УдалитьЗаписиРегистровНакопления(ДатаСвертки);
	УдалитьЗаписиРегистровСведений(ДатаСвертки);

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПометитьНаУдалениеДокументы(ДатаСвертки, Результат)

	КоличествоДокументов = Метаданные.Документы.Количество();
	Индекс = 0;
	Для Каждого ТекущийДокумент Из Метаданные.Документы Цикл
		Индекс = Индекс + 1;
		Процент = Окр(Индекс / КоличествоДокументов * 100);
		ДлительныеОперации.СообщитьПрогресс(Процент, СтрШаблон(НСтр(
		"ru = 'Помечаются на удаление документы вида ""%1""'"), ТекущийДокумент.Синоним));

		Попытка
			ПометитьНаУдалениеДокументыВида(ТекущийДокумент, ДатаСвертки, Результат);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ШаблонОшибки = НСтр("ru = 'При пометке на удаление документов вида ""%1""'");
			ТекстИсключения = ТекстИсключения(ИнформацияОбОшибке, ТекущийДокумент, ШаблонОшибки);
			ВызватьИсключение ТекстИсключения;
		КонецПопытки;
	КонецЦикла;

КонецПроцедуры

Процедура ПометитьНаУдалениеЭлементыСправочников(ДатаСвертки, Результат)

	ОбрабатываемыеСправочники = Новый Массив;
	ОбрабатываемыеСправочники.Добавить(Метаданные.Справочники.ЗаписиКалендаряСотрудника);

	Для Каждого ТипПрисоединенногоФайла Из Метаданные.ОпределяемыеТипы.ПрисоединенныйФайл.Тип.Типы() Цикл
		ОбрабатываемыйСправочник = Метаданные.НайтиПоТипу(ТипПрисоединенногоФайла);
		Если Не ОбщегоНазначения.ЕстьРеквизитОбъекта("ВладелецФайла", ОбрабатываемыйСправочник) Тогда
			Продолжить;
		КонецЕсли;
		Для Каждого ТипВладельца Из ОбрабатываемыйСправочник.Реквизиты.ВладелецФайла.Тип.Типы() Цикл
			ВладелецФайла = Метаданные.НайтиПоТипу(ТипВладельца);
			Если ОбщегоНазначения.ЭтоДокумент(ВладелецФайла) Тогда
				ОбрабатываемыеСправочники.Добавить(ОбрабатываемыйСправочник);
				Продолжить;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;

	Индекс = 0;
	Для Каждого ТекущийСправочник Из ОбрабатываемыеСправочники Цикл
		Индекс = Индекс + 1;
		Процент = Окр(Индекс / ОбрабатываемыеСправочники.Количество() * 100);
		ДлительныеОперации.СообщитьПрогресс(Процент, СтрШаблон(НСтр(
		"ru = 'Помечаются на удаление элементы справочника ""%1""'"), ТекущийСправочник.Синоним));

		Попытка
			ПометитьНаУдалениеЭлементыСправочникаВида(ТекущийСправочник, ДатаСвертки, Результат);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ШаблонОшибки = НСтр("ru = 'При пометке на удаление элементов справочника ""%1""'");
			ТекстИсключения = ТекстИсключения(ИнформацияОбОшибке, ТекущийСправочник, ШаблонОшибки);
			ВызватьИсключение ТекстИсключения;
		КонецПопытки;
	КонецЦикла;

КонецПроцедуры

Процедура УдалитьЗаписиРегистраБухгалтерии(ДатаСвертки)

	Для Каждого ТекущийРегистр Из Метаданные.РегистрыБухгалтерии Цикл
		ДлительныеОперации.СообщитьПрогресс(0, СтрШаблон(НСтр("ru = 'Очищаются записи регистра бухгалтерии ""%1""'"),
			ТекущийРегистр.Синоним));
		Попытка
			УдалитьДвиженияПоПодчиненномуРегистру(ТекущийРегистр, ДатаСвертки);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ШаблонОшибки = НСтр("ru = 'При удалении записей регистра бухгалтерии ""%1""'");
			ТекстИсключения = ТекстИсключения(ИнформацияОбОшибке, ТекущийРегистр, ШаблонОшибки);
			ВызватьИсключение ТекстИсключения;
		КонецПопытки;
	КонецЦикла;

КонецПроцедуры

Процедура УдалитьЗаписиРегистровНакопления(ДатаСвертки)

	КоличествоРегистровНакопления = Метаданные.РегистрыНакопления.Количество();
	Индекс = 0;
	Для Каждого ТекущийРегистр Из Метаданные.РегистрыНакопления Цикл
		Индекс = Индекс + 1;
		Процент = Окр(Индекс / КоличествоРегистровНакопления * 100);
		ДлительныеОперации.СообщитьПрогресс(Процент, СтрШаблон(НСтр(
			"ru = 'Очищаются записи регистра накопления ""%1""'"), ТекущийРегистр.Синоним));
		Попытка
			УдалитьДвиженияПоПодчиненномуРегистру(ТекущийРегистр, ДатаСвертки);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ШаблонОшибки = НСтр("ru = 'При удалении записей регистра накопления ""%1""'");
			ТекстИсключения = ТекстИсключения(ИнформацияОбОшибке, ТекущийРегистр, ШаблонОшибки);
			ВызватьИсключение ТекстИсключения;
		КонецПопытки;
	КонецЦикла;

КонецПроцедуры

Процедура УдалитьЗаписиРегистровСведений(ДатаСвертки)

	ИсключаемыеРегистры = ИсключаемыеРегистры();

	КоличествоРегистровСведений = Метаданные.РегистрыСведений.Количество();
	Индекс = 0;
	Для Каждого ТекущийРегистр Из Метаданные.РегистрыСведений Цикл
		Индекс = Индекс + 1;
		Процент = Окр(Индекс / КоличествоРегистровСведений * 100);
		ДлительныеОперации.СообщитьПрогресс(Процент, СтрШаблон(НСтр("ru = 'Очищаются записи регистра сведений ""%1""'"),
			ТекущийРегистр.Синоним));
		Попытка
			Если ТекущийРегистр.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору Тогда
				Если ТекущийРегистр.ПериодичностьРегистраСведений
					<> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
					УдалитьДвиженияПоПодчиненномуРегистру(ТекущийРегистр, ДатаСвертки);
				Иначе
					УдалитьДвиженияПоПодчиненномуРегистру(ТекущийРегистр, '00010101');
				КонецЕсли;
			ИначеЕсли ТекущийРегистр.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.Независимый
				И ТекущийРегистр.ПериодичностьРегистраСведений
				<> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
				УдалитьДвиженияПоРегиструСведенийПериодическомуБезРегистратора(ТекущийРегистр, ДатаСвертки,
					ИсключаемыеРегистры);
			ИначеЕсли ТекущийРегистр.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.Независимый
				И ТекущийРегистр.ПериодичностьРегистраСведений
				= Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
				УдалитьДвиженияПоРегиструСведенийБезРегистратора(ТекущийРегистр, ИсключаемыеРегистры);
			КонецЕсли;
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ШаблонОшибки = НСтр("ru = 'При удалении записей регистра сведений ""%1""'");
			ТекстИсключения = ТекстИсключения(ИнформацияОбОшибке, ТекущийРегистр, ШаблонОшибки);
			ВызватьИсключение ТекстИсключения;
		КонецПопытки;
	КонецЦикла;

КонецПроцедуры

Функция ТекстИсключения(ИнформацияОбОшибке, ТекущийОбъект, ШаблонОшибки)
	ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
	ЗаголовокИсключения = СтрШаблон(ШаблонОшибки, ТекущийОбъект.Синоним);
	ТекстИсключения = СтрШаблон("%1:
								|%2", ЗаголовокИсключения, ПодробноеПредставлениеОшибки);
	Возврат ТекстИсключения;
КонецФункции

Процедура СформироватьОстаткиДляРегистра(ТекущийРегистр, ДатаСвертки, СформированныеДокументы)

	Если Не ОбщегоНазначения.ЭтоРегистрНакопления(ТекущийРегистр) Тогда
		Возврат;
	КонецЕсли;

	Если ТекущийРегистр.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Обороты Тогда
		Возврат;
	КонецЕсли;

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&ПериодЗаписи КАК Период
	|ИЗ
	|	&ТаблицаРегистра КАК ТаблицаРегистра";
	ТаблицаОстатков = СтрШаблон("%1.Остатки(&ПериодЗаписи)", ТекущийРегистр.ПолноеИмя());
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТаблицаРегистра", ТаблицаОстатков);

	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);

	Для Каждого Измерение Из ТекущийРегистр.Измерения Цикл
		ИмяИзмерения = СтрШаблон("ТаблицаРегистра.%1", Измерение.Имя);
		СхемаЗапроса.ПакетЗапросов[0].Операторы[0].ВыбираемыеПоля.Добавить(ИмяИзмерения);
	КонецЦикла;

	Для Каждого Ресурс Из ТекущийРегистр.Ресурсы Цикл
		ПсевдонимПоля = СтрШаблон("%1Остаток", Ресурс.Имя);
		ИмяРесурса = СтрШаблон("ТаблицаРегистра.%1", ПсевдонимПоля);
		СхемаЗапроса.ПакетЗапросов[0].Операторы[0].ВыбираемыеПоля.Добавить(ИмяРесурса);
		НайденнаяКолонка = СхемаЗапроса.ПакетЗапросов[0].Колонки.Найти(ПсевдонимПоля);
		НайденнаяКолонка.Псевдоним = Ресурс.Имя;
	КонецЦикла;

	Запрос = Новый Запрос;
	Запрос.Текст = СхемаЗапроса.ПолучитьТекстЗапроса();
	Запрос.УстановитьПараметр("ПериодЗаписи", ДатаСвертки);

	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;

	ТаблицаДвижений = РезультатЗапроса.Выгрузить();

	ДокументДвижения = НовыйДокументДвижения(ТекущийРегистр, ДатаСвертки);
	ЗаписатьДанные(ДокументДвижения);

	НаборЗаписей = РегистрыНакопления[ТекущийРегистр.Имя].СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Регистратор.Установить(ДокументДвижения.Ссылка);
	НаборЗаписей.Загрузить(ТаблицаДвижений);
	ЗаписатьДанные(НаборЗаписей);

	СформированныеДокументы.Добавить(ДокументДвижения.Ссылка);

КонецПроцедуры

Функция НовыйДокументДвижения(ТекущийРегистр, ДатаСвертки)

	НовыйДокументДвижения = Документы.КорректировкаРегистров.СоздатьДокумент();
	НовыйДокументДвижения.Автор = Пользователи.ТекущийПользователь();
	НовыйДокументДвижения.Дата = ДатаСвертки;
	НовыйДокументДвижения.Комментарий = СтрШаблон(НСтр("ru = 'Свертка регистра ""%1""'"), ТекущийРегистр.Синоним);
	НовыйДокументДвижения.УстановитьНовыйНомер();
	НоваяСтрокаТаблицыРегистров = НовыйДокументДвижения.ТаблицаРегистров.Добавить();
	НоваяСтрокаТаблицыРегистров.Имя = ТекущийРегистр.Имя;

	Возврат НовыйДокументДвижения;

КонецФункции

Процедура ПометитьНаУдалениеДокументыВида(ТекущийДокумент, ДатаСвертки, ПомеченныеНаУдаление)

	Если Не ПравоДоступа("Изменение", ТекущийДокумент) Тогда
		Возврат;
	КонецЕсли;

	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1000
	|	ТаблицаДокумента.Ссылка КАК Ссылка
	|ИЗ
	|	&ТаблицаДокумента КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Дата < &ДатаСвертки
	|	И НЕ ТаблицаДокумента.ПометкаУдаления";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТаблицаДокумента", ТекущийДокумент.ПолноеИмя());
	Если Не ЗначениеЗаполнено(ДатаСвертки) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ТаблицаДокумента.Дата < &ДатаСвертки", "ИСТИНА");
	КонецЕсли;

	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ДатаСвертки", ДатаСвертки);

	Пока Истина Цикл
		// BSLLS:CreateQueryInCycle-off
		// Пометка на удаление порциями
		РезультатЗапроса = Запрос.Выполнить();
		// BSLLS:CreateQueryInCycle-on
		Если РезультатЗапроса.Пустой() Тогда
			Возврат;
		КонецЕсли;

		ВыборкаДокументыДляУдаления = РезультатЗапроса.Выбрать();
		ЗаполняемыеПоля = Новый Структура;
		ЗаполняемыеПоля.Вставить("ПометкаУдаления", Истина);
		ЗаполняемыеПоля.Вставить("Проведен", Ложь);
		Пока ВыборкаДокументыДляУдаления.Следующий() Цикл
			ДокументДляУдаления = ВыборкаДокументыДляУдаления.Ссылка.ПолучитьОбъект();
			ЗаполнитьЗначенияСвойств(ДокументДляУдаления, ЗаполняемыеПоля);
			ЗаписатьДанные(ДокументДляУдаления);
			ПомеченныеНаУдаление.Добавить(ДокументДляУдаления.Ссылка);
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

Процедура ПометитьНаУдалениеЭлементыСправочникаВида(ТекущийСправочник, ДатаСвертки, ПомеченныеНаУдаление)

	Если Не ПравоДоступа("Изменение", ТекущийСправочник) Тогда
		Возврат;
	КонецЕсли;

	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1000
	|	ТаблицаСправочника.Ссылка КАК Ссылка
	|ИЗ
	|	&ТаблицаСправочника КАК ТаблицаСправочника
	|ГДЕ
	|	НЕ ТаблицаСправочника.ПометкаУдаления";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТаблицаСправочника", ТекущийСправочник.ПолноеИмя());
	Если ЗначениеЗаполнено(ДатаСвертки) И ОбщегоНазначения.ЕстьРеквизитОбъекта("Окончание", ТекущийСправочник) Тогда
		ТекстЗапроса = ТекстЗапроса + Символы.ПС + "И ТаблицаСправочника.Окончание < &ДатаСвертки";
	КонецЕсли;

	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ДатаСвертки", ДатаСвертки);

	Пока Истина Цикл
		// BSLLS:CreateQueryInCycle-off
		// Пометка на удаление порциями
		РезультатЗапроса = Запрос.Выполнить();
		// BSLLS:CreateQueryInCycle-on
		Если РезультатЗапроса.Пустой() Тогда
			Возврат;
		КонецЕсли;

		ВыборкаЭлементыДляУдаления = РезультатЗапроса.Выбрать();
		ЗаполняемыеПоля = Новый Структура;
		ЗаполняемыеПоля.Вставить("ПометкаУдаления", Истина);
		Пока ВыборкаЭлементыДляУдаления.Следующий() Цикл
			ЭлементДляУдаления = ВыборкаЭлементыДляУдаления.Ссылка.ПолучитьОбъект();
			ЗаполнитьЗначенияСвойств(ЭлементДляУдаления, ЗаполняемыеПоля);
			ЗаписатьДанные(ЭлементДляУдаления);
			ПомеченныеНаУдаление.Добавить(ЭлементДляУдаления.Ссылка);
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

Процедура УдалитьДвиженияПоПодчиненномуРегистру(ТекущийРегистр, ДатаСвертки)

	Если Не ПравоДоступа("Изменение", ТекущийРегистр) Тогда
		Возврат;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 10000
	|	ТаблицаРегистра.Регистратор КАК Регистратор
	|ИЗ
	|	&ТаблицаРегистра КАК ТаблицаРегистра
	|ГДЕ
	|	ТаблицаРегистра.Период < &ДатаСвертки";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТаблицаРегистра", ТекущийРегистр.ПолноеИмя());
	Если ЗначениеЗаполнено(ДатаСвертки) Тогда
		Запрос.УстановитьПараметр("ДатаСвертки", ДатаСвертки);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ТаблицаРегистра.Период < &ДатаСвертки", "ИСТИНА");
	КонецЕсли;

	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ТекущийРегистр.ПолноеИмя());
	МенеджерОбъекта.УстановитьИспользованиеИтогов(Ложь);

	Попытка
		Пока Истина Цикл
		// BSLLS:CreateQueryInCycle-off
		// Пометка на удаление порциями
		РезультатЗапроса = Запрос.Выполнить();
		// BSLLS:CreateQueryInCycle-on
			Если РезультатЗапроса.Пустой() Тогда
				Прервать;
			КонецЕсли;

			Выборка = РезультатЗапроса.Выбрать();
			Пока Выборка.Следующий() Цикл
				НаборЗаписей = МенеджерОбъекта.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
				ЗаписатьДанные(НаборЗаписей);
			КонецЦикла;
		КонецЦикла;
	Исключение
		МенеджерОбъекта.УстановитьИспользованиеИтогов(Истина);
		ВызватьИсключение;
	КонецПопытки;

	МенеджерОбъекта.УстановитьИспользованиеИтогов(Истина);

КонецПроцедуры

Процедура УдалитьДвиженияПоРегиструСведенийПериодическомуБезРегистратора(ТекущийРегистр, ДатаСвертки,
	ИсключаемыеРегистры)

	Если НеСворачиватьРегистр(ТекущийРегистр, ИсключаемыеРегистры) Тогда
		Возврат;
	КонецЕсли;

	Если Не ПравоДоступа("Изменение", ТекущийРегистр) Тогда
		Возврат;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ДатаСвертки) Тогда
		УдалитьДвиженияПоРегиструСведенийБезРегистратора(ТекущийРегистр, ИсключаемыеРегистры);
		Возврат;
	КонецЕсли;

	Если ТекущийРегистр.ПериодичностьРегистраСведений = Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Год Тогда
		ПериодЗаписи = НачалоГода(ДатаСвертки - 1);
	ИначеЕсли ТекущийРегистр.ПериодичностьРегистраСведений
		= Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Квартал Тогда
		ПериодЗаписи = НачалоКвартала(ДатаСвертки - 1);
	ИначеЕсли ТекущийРегистр.ПериодичностьРегистраСведений
		= Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Месяц Тогда
		ПериодЗаписи = НачалоМесяца(ДатаСвертки - 1);
	ИначеЕсли ТекущийРегистр.ПериодичностьРегистраСведений
		= Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.День Тогда
		ПериодЗаписи = НачалоДня(ДатаСвертки - 1);
	Иначе
		ПериодЗаписи = ДатаСвертки - 1;
	КонецЕсли;

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	*,
	|	ИСТИНА КАК Активность,
	|	&ПериодЗаписи КАК Период
	|ИЗ
	|	&ТаблицаРегистра КАК ТаблицаРегистра";
	
	Если ТекущийРегистр = Метаданные.РегистрыСведений.ГрафикПлатежей
		Или ТекущийРегистр = Метаданные.РегистрыСведений.ГрафикОплатыЗаказов Тогда
		УсловиеОтбора = ", НЕ СчетНаОплату.ПометкаУдаления";
	Иначе
		УсловиеОтбора = "";
	КонецЕсли;
	
	ТаблицаРегистра = СтрШаблон("%1.СрезПоследних(&МоментВремени%2)", ТекущийРегистр.ПолноеИмя(), УсловиеОтбора);
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТаблицаРегистра", ТаблицаРегистра);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("МоментВремени", Новый Граница(КонецДня(ДатаСвертки - 1), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("ПериодЗаписи", ПериодЗаписи);

	ТаблицаЗаписей = Запрос.Выполнить().Выгрузить();

	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ТекущийРегистр.ПолноеИмя());
	МенеджерОбъекта.УстановитьИспользованиеИтогов(Ложь);

	Попытка
		НаборЗаписей = МенеджерОбъекта.СоздатьНаборЗаписей();
		Если ТекущийРегистр <> Метаданные.РегистрыСведений.ГрафикПлатежей
			Или ТекущийРегистр = Метаданные.РегистрыСведений.ГрафикОплатыЗаказов Тогда
			НаборЗаписей.Отбор.Период.Установить(ПериодЗаписи);
		КонецЕсли;
		НаборЗаписей.Загрузить(ТаблицаЗаписей);
		ЗаписатьДанные(НаборЗаписей);
	Исключение
		МенеджерОбъекта.УстановитьИспользованиеИтогов(Истина);
		ВызватьИсключение;
	КонецПопытки;

	МенеджерОбъекта.УстановитьИспользованиеИтогов(Истина);

КонецПроцедуры

Процедура УдалитьДвиженияПоРегиструСведенийБезРегистратора(ТекущийРегистр, ИсключаемыеРегистры)

	Если НеСворачиватьРегистр(ТекущийРегистр, ИсключаемыеРегистры) Тогда
		Возврат;
	КонецЕсли;

	Если Не ПравоДоступа("Изменение", ТекущийРегистр) Тогда
		Возврат;
	КонецЕсли;

	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ТекущийРегистр.ПолноеИмя());
	МенеджерОбъекта.УстановитьИспользованиеИтогов(Ложь);

	Попытка
		НаборЗаписей = МенеджерОбъекта.СоздатьНаборЗаписей();
		ЗаписатьДанные(НаборЗаписей);
	Исключение
		МенеджерОбъекта.УстановитьИспользованиеИтогов(Истина);
		ВызватьИсключение;
	КонецПопытки;

	МенеджерОбъекта.УстановитьИспользованиеИтогов(Истина);

КонецПроцедуры

Функция НеСворачиватьРегистр(ТекущийРегистр, ИсключаемыеРегистры)

	Возврат ИсключаемыеРегистры[ТекущийРегистр.ПолноеИмя()] = Истина;

КонецФункции

Функция ИсключаемыеРегистры()

	Результат = Новый Соответствие;
	Результат[Метаданные.РегистрыСведений.АдресныеОбъекты.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.БлокировкиСеансовОбластейДанных.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ВерсииОбъектов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ВерсииПодсистем.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ВерсииПодсистемОбластейДанных.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ВложенияНеформализованныхДокументов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ГруппыЗначенийДоступа.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ДанныеОбъектовДляРегистрацииВОбменах.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ДанныеПроизводственногоКалендаря.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ДатыЗапретаИзменения.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ДокументыСОшибкамиПроверкиКонтрагентов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ДомаЗданияСтроения.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ДополнительныеАдресныеСведения.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ДополнительныеРеквизитыУчетнойЗаписи.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ДополнительныеРеквизитыУчетнойЗаписиПолучатели.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ДополнительныеСведения.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ДополнительныеФайлыРегламентированныхОтчетов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ЖурналНовыхСобытий.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ЖурналОтправокВКонтролирующиеОрганы.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ЗависимостиПравДоступа.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ЗагруженныеВерсииАдресныхСведений.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ЗамерыВремени.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервиса.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ЗначенияГруппДоступа.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ЗначенияГруппДоступаПоУмолчанию.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ИзмененияОбщихДанныхУзлов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ИспользованиеДополнительныхОтчетовИОбработокСервисаВАвтономномРабочемМесте.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ИспользованиеПоставляемыхДополнительныхОтчетовИОбработокВОбластяхДанных.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ИсторияАдресныхОбъектов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.КэшПрограммныхИнтерфейсов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.НаборыЗначенийДоступа.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.НазначениеДополнительныхОбработок.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.НаличиеДублейУКонтрагентов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.НаследованиеНастроекПравОбъектов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.НастройкиВариантовОтчетов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.НастройкиВерсионированияОбъектов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.НастройкиИнтеграцииСоСпринтером.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.НастройкиОбменаРПН.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.НастройкиОбменаФСРАР.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.НастройкиОбменаФСС.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.НастройкиОтправителя.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.НастройкиПравОбъектов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.НастройкиТранспортаОбменаОбластейДанных.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.НастройкиТранспортаОбменаОбластиДанных.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.НеразделенныеПользователи.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.НомераОтсканированныхФайлов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.НумераторПачекПФР.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ОбластиДанных.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ОбластиПерсональныхДанных.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ОбщиеНастройкиУзловИнформационныхБаз.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ОриентирыАдресныхОбъектов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ОтветыНаЗапросыВыпискиИзЕГРЮЛ_ЕГРИП.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ОтветыНаЗапросыИОН.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ОтветыНаЗапросыИОС.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ОтправкиОтчетностиКОбработке.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ОчередьИзвлеченияТекста.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ОчередьИнсталляцииПоставляемыхДополнительныхОтчетовИОбработокВОбластиДанных.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ПакетыОтчетности.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ПодпискиПолучателей.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ПодписываемыеВидыЭД.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ПользователиУчетныхЗаписейДокументооборота.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ПользовательскиеМакетыПечати.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ПользовательскиеНастройкиДоступаКОбработкам.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ПоставляемыеДанныеТребующиеОбработки.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ПраваРолей.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ПравилаДляОбменаДанными.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ПрименениеРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервиса.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ПрименениеРазрешенийНаИспользованиеВнешнихРесурсовОбластейДанных.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ПричиныИзмененияАдресныхСведений.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ПросмотренныеДанныеИнформационногоЦентра.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ПубличныеИдентификаторыСинхронизируемыхОбъектов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ПутиКПрограммамЭлектроннойПодписиИШифрованияНаСерверахLinux.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.РабочиеКаталогиФайлов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.РазрешенияНаИспользованиеВнешнихРесурсов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.РазрешенияНаИспользованиеВнешнихРесурсовВМоделиСервиса.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.РазрешенияНаИспользованиеВнешнихРесурсовОбластейДанных.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.РежимыПодключенияВнешнихМодулей.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.РежимыПодключенияВнешнихМодулейВМоделиСервиса.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.РежимыПодключенияВнешнихМодулейОбластейДанных.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.РезультатыОбменаДанными.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.РейтингАктивностиОбластейДанных.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.РесурсыМеханизмаОнлайнСервисовРО.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.СвойстваТранспортныхСообщений.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.СеансовыеДанныеGoogle.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.СессииОбменаСообщениямиСистемы.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.СкрытыеРегламентированныеОтчеты.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.СлужебныеАдресныеСведения.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.СобытияКалендаряБухгалтера.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.СодержимоеТранспортныхКонтейнеров.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.СообщенияОбменаДанными.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.СообщенияОбменаДаннымиОбластейДанных.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.СоответствияОбъектовИнформационныхБаз.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.СоставыГруппПользователей.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.СостоянияКонтрагентов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.СостоянияОбменовДанными.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.СостоянияОбменовДаннымиОбластейДанных.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.СостоянияОбменовЭДЧерезОператоровЭДО.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.СостоянияУспешныхОбменовДанными.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.СостоянияУспешныхОбменовДаннымиОбластейДанных.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.СтатусыОтправки.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ТаблицыГруппДоступа.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ТекущиеКадровыеДанныеСотрудников.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ТранспортныеКонтейнеры.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.УдалитьВложенияНеформализованныхДокументов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.УдалитьОтветыНаЗапросыВыпискиИзЕГРЮЛ_ЕГРИП.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.УдалитьОтветыНаЗапросыИОН.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.УдалитьУчастникиОбменовЭДЧерезОператоровЭДО.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.УдалитьФайлыДокументовРеализацииПолномочийНалоговыхОрганов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.УдалитьФайлыСведенийРОКИ.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.УдалитьФайлыСведенийСпецоператоры.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.УдалитьХранилищеЭлектронныхПредставленийРегламентированныхОтчетов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.УровниСокращенийАдресныхСведений.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ФайлыВРабочемКаталоге.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ФайлыДокументовРеализацииПолномочийНалоговыхОрганов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ФайлыСведенийРОКИ.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ФайлыСведенийСпецоператоры.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ХранилищеСертификатов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ХранилищеЭлектронныхПредставленийРегламентированныхОтчетов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ШаблоныПечатиМашиночитаемыхФорм.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ШаблоныЭВФОтчетовСтатистики.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ДокументыФизическихЛиц.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.КурсыВалют.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ПредельнаяВеличинаБазыСтраховыхВзносов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ПрименяемыеТарифыСтраховыхВзносов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.СчетчикиВыгрузок.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.ТарифыСтраховыхВзносов.ПолноеИмя()] = Истина;
	Результат[Метаданные.РегистрыСведений.АрхивДанныхРегламентированнойОтчетности.ПолноеИмя()] = Истина;

	Возврат Результат;

КонецФункции

Процедура ЗаписатьДанные(Данные)

	Данные.ОбменДанными.Загрузка = Истина;
	Данные.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
	Данные.Записать();

КонецПроцедуры

#КонецОбласти
#КонецЕсли
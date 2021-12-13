﻿

#Область ОписаниеПеременных

&НаКлиенте
Перем ИдентификаторЗадания;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЭтоРежимРасшифровки() Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Отчет.ДатаНачала) И НЕ ЗначениеЗаполнено(Отчет.ДатаОкончания) Тогда
		Отчет.ДатаНачала    = НачалоГода(ТекущаяДата());
		Отчет.ДатаОкончания = ТекущаяДата();
	КонецЕсли;
	
	ОтображениеСостояния = Элементы.ОтчетТабличныйДокумент.ОтображениеСостояния;
	ОтображениеСостояния.Видимость = Истина;
	#Если МобильныйКлиент Тогда
		ОтображениеСостояния.Текст = НСтр("ru = 'Отчет не сформирован. Нажмите ""Сформировать"" в заголовке формы для получения отчета.'");
	#Иначе
		ОтображениеСостояния.Текст = НСтр("ru = 'Отчет не сформирован. Нажмите ""Сформировать"" (F5) для получения отчета.'");
	#КонецЕсли
	ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		Возврат;
	КонецЕсли;
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ЗаполнитьЗначениямиПоУмолчанию(Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если НЕ ЗначениеЗаполнено(Отчет.Организация) ИЛИ
		 НЕ ЗначениеЗаполнено(Отчет.СтруктурнаяЕдиница) ИЛИ
		 НЕ ЗначениеЗаполнено(Отчет.ДатаНачала) ИЛИ
		 НЕ ЗначениеЗаполнено(Отчет.ДатаОкончания) Тогда
		Параметры.СформироватьПриОткрытии = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	ВариантыОтчетов.ПриСохраненииПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОтображениеСостояния = Элементы.ОтчетТабличныйДокумент.ОтображениеСостояния;
	ОтображениеСостояния.Видимость = Истина;
	ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	ОтображениеСостояния.Картинка = БиблиотекаКартинок.ДлительнаяОперация48;
	ОтображениеСостояния.Текст = НСтр("ru = 'Отчет формируется...'");
	
	ПодключитьОбработчикОжидания("НачатьФормированиеОтчета", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НачатьФормированиеОтчета()
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
	ПараметрыОжидания.ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения("ОтобразитьПрогресс", ЭтотОбъект);
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	КонецЕсли;
	
	Задание = ЗаданиеСформироватьОтчет();
	Если Задание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторЗадания = Задание.ИдентификаторЗадания;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
	Задание,
	Новый ОписаниеОповещения("ОбработатьЗавершениеФормированияОтчета", ЭтотОбъект),
	ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция ЗаданиеСформироватьОтчет()
	
	Если ПараметрыНекорректны() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Отчет.НомерОтчета = Отчет.НомерОтчета + 1;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ДатаНачала", Отчет.ДатаНачала);
	ПараметрыПроцедуры.Вставить("ДатаОкончания", Отчет.ДатаОкончания);
	ПараметрыПроцедуры.Вставить("Организация", Отчет.Организация);
	ПараметрыПроцедуры.Вставить("СтруктурнаяЕдиница", Отчет.СтруктурнаяЕдиница);
	ПараметрыПроцедуры.Вставить("ВыводитьСуммуДокументаИДельту", Отчет.ВыводитьСуммуДокументаИДельту);
	ПараметрыПроцедуры.Вставить("НомерОтчета", Отчет.НомерОтчета);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	Результат = ДлительныеОперации.ВыполнитьВФоне("Отчеты.ТоварныйОтчетТОРГ29.СформироватьОтчет",
	ПараметрыПроцедуры,
	ПараметрыВыполнения);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПараметрыНекорректны()
	
	Результат = Ложь;
	
	Если Отчет.ДатаНачала > Отчет.ДатаОкончания Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Дата начала периода не должна превышать дату окончания.'"),, "Отчет.ДатаНачала");
		Результат = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Отчет.Организация) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не указана организация.'"),, "Отчет.Организация");
		Результат = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Отчет.СтруктурнаяЕдиница) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не указана структурная единица.'"),, "Отчет.СтруктурнаяЕдиница");
		Результат = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Отчет.СтруктурнаяЕдиница, "РозничныйВидЦен")) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'У структурной единицы не указан розничный вид цен.'"),, "Отчет.СтруктурнаяЕдиница");
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОтобразитьПрогресс(СостояниеЗадания, Параметры) Экспорт
	
	Если ТипЗнч(СостояниеЗадания.Прогресс) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не СостояниеЗадания.Прогресс.Свойство("Текст") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ОтчетТабличныйДокумент.ОтображениеСостояния.Текст = СостояниеЗадания.Прогресс.Текст;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьЗавершениеФормированияОтчета(Результат, Параметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Результат.Свойство("Статус") Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ИдентификаторЗадания = Неопределено;
		ОтображениеСостояния = Элементы.ОтчетТабличныйДокумент.ОтображениеСостояния;
		ОтображениеСостояния.Видимость = Истина;
		ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
		ОтображениеСостояния.Картинка = Новый Картинка;
		ОтображениеСостояния.Текст = Результат.ПодробноеПредставлениеОшибки;
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		ОтчетТабличныйДокумент  = ТабличныйДокументИзРезультатаВыполненияЗадания(Результат.АдресРезультата);
		ИдентификаторЗадания = Неопределено;
		ОтображениеСостояния = Элементы.ОтчетТабличныйДокумент.ОтображениеСостояния;
		ОтображениеСостояния.Видимость = Ложь;
		ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.НеИспользовать;
		ОтображениеСостояния.Картинка = Новый Картинка;
		ОтображениеСостояния.Текст = "";
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ТабличныйДокументИзРезультатаВыполненияЗадания(АдресХранилища)
	
	Если Не ЭтоАдресВременногоХранилища(АдресХранилища)  Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	РезультатВыполненияЗадания = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если ТипЗнч(РезультатВыполненияЗадания) = Тип("ХранилищеЗначения") Тогда
		Возврат РезультатВыполненияЗадания.Получить();
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	
	Диалог.Период.ДатаНачала    = Отчет.ДатаНачала;
	Диалог.Период.ДатаОкончания = Отчет.ДатаОкончания;
	
	Диалог.Показать(Новый ОписаниеОповещения("УстановитьИнтервалЗавершение", ЭтотОбъект, Новый Структура("Диалог", Диалог)));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалЗавершение(Результат1, ДополнительныеПараметры) Экспорт
	
	Диалог = ДополнительныеПараметры.Диалог;
	
	Если ЗначениеЗаполнено(Результат1) Тогда
		
		Отчет.ДатаНачала    = Диалог.Период.ДатаНачала;
		Отчет.ДатаОкончания = Диалог.Период.ДатаОкончания;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполняет поля отчета значениями по умолчанию если они не заполнены.
//
&НаСервере
Процедура ЗаполнитьЗначениямиПоУмолчанию(Настройки)
	
	Если НЕ ЗначениеЗаполнено(Настройки.Получить("Отчет.Организация")) Тогда
		
		ЗначениеНастройки = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.ТекущийПользователь(), "ОсновнаяОрганизация");
		Если ЗначениеЗаполнено(ЗначениеНастройки) Тогда
			Отчет.Организация = ЗначениеНастройки;
		Иначе
			Отчет.Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Настройки.Получить("Отчет.СтруктурнаяЕдиница")) Тогда
		
		ЗначениеНастройки = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.ТекущийПользователь(), "ОсновнойСклад");
		Если ЗначениеЗаполнено(ЗначениеНастройки) Тогда
			Отчет.СтруктурнаяЕдиница = ЗначениеНастройки;
		Иначе
			Отчет.СтруктурнаяЕдиница = Справочники.СтруктурныеЕдиницы.ОсновнойСклад;	
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;
		ФормаРасшифровки = ПолучитьФорму("Отчет.ТоварныйОтчетТОРГ29.Форма.ФормаОтчета",,, Расшифровка.Дата);
		РезультатОбработкаРасшифровкиНаСервере(Расшифровка, ФормаРасшифровки.ОтчетТабличныйДокумент);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(ФормаРасшифровки.Элементы, "ГруппаПараметры", "Видимость", Ложь);
		ФормаРасшифровки.Открыть();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция РезультатОбработкаРасшифровкиНаСервере(Расшифровка, ПолеРезультат)
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	Макет = ОтчетОбъект.ПолучитьМакет("МакетРасшифровки");
	
	СведенияОПокупателе = ПечатьДокументовУНФ.СведенияОЮрФизЛице(Отчет.Организация, Расшифровка.Дата, ,);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.ОрганизацияПредставление = ПечатьДокументовУНФ.ОписаниеОрганизации(СведенияОПокупателе);
	ОбластьМакета.Параметры.СтруктурнаяЕдиницаПредставление = Отчет.СтруктурнаяЕдиница.Наименование;
	ОбластьМакета.Параметры.Дата = Формат(Расшифровка.Дата, "ДФ=dd.MM.yyyy");
	
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакета.Параметры.Дата = Формат(Расшифровка.Дата, "ДФ=dd.MM.yyyy");
	ТабДокумент.Вывести(ОбластьМакета);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаЦен.Период КАК Период,
		|	""Установка цен"" КАК Регистратор,
		|	ТаблицаЦен.Номенклатура КАК Номенклатура,
		|	ТаблицаЦен.Характеристика КАК Характеристика,
		|	ЕСТЬNULL(ЦеныНоменклатурыА.Цена, 0) КАК Цена,
		|	ЕСТЬNULL(ЦеныНоменклатурыБ.Цена, 0) КАК СтараяЦена,
		|	ЕСТЬNULL(ЦеныНоменклатурыА.Цена, 0) - ЕСТЬNULL(ЦеныНоменклатурыБ.Цена, 0) КАК Дельта,
		|	ПРЕДСТАВЛЕНИЕ(ТаблицаЦен.Номенклатура),
		|	ПРЕДСТАВЛЕНИЕ(ТаблицаЦен.Характеристика),
		|	ЗапасыНаСкладахОстатки.КоличествоОстаток КАК Остаток,
		|	ЗапасыНаСкладахОстатки.КоличествоОстаток * ЕСТЬNULL(ЦеныНоменклатурыА.Цена, 0) КАК Стоимость,
		|	ЗапасыНаСкладахОстатки.КоличествоОстаток * ЕСТЬNULL(ЦеныНоменклатурыБ.Цена, 0) КАК СтараяСтоимость,
		|	ЗапасыНаСкладахОстатки.КоличествоОстаток * (ЕСТЬNULL(ЦеныНоменклатурыА.Цена, 0) - ЕСТЬNULL(ЦеныНоменклатурыБ.Цена, 0)) КАК ДельтаСтоимости
		|ИЗ
		|	(ВЫБРАТЬ
		|		ЦеныНоменклатуры.Период КАК Период,
		|		МАКСИМУМ(ЦеныДоИзменения.Период) КАК ДатаПрошлогоИзменения,
		|		ЦеныНоменклатуры.ВидЦен КАК ВидЦен,
		|		ЦеныНоменклатуры.Номенклатура КАК Номенклатура,
		|		ЦеныНоменклатуры.Характеристика КАК Характеристика
		|	ИЗ
		|		РегистрСведений.ЦеныНоменклатуры КАК ЦеныНоменклатуры
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры КАК ЦеныДоИзменения
		|			ПО ЦеныНоменклатуры.Период > ЦеныДоИзменения.Период
		|				И ЦеныНоменклатуры.Номенклатура = ЦеныДоИзменения.Номенклатура
		|				И ЦеныНоменклатуры.Характеристика = ЦеныДоИзменения.Характеристика
		|				И (&ВидЦен = ЦеныДоИзменения.ВидЦен)
		|				И (ЦеныДоИзменения.Актуальность)
		|	ГДЕ
		|		ЦеныНоменклатуры.ВидЦен = &ВидЦен
		|		И ЦеныНоменклатуры.Актуальность
		|		И ЦеныНоменклатуры.Период МЕЖДУ &ПериодНачало И &ПериодОкончание
		|	{ГДЕ
		|		ЦеныНоменклатуры.Номенклатура.*,
		|		ЦеныНоменклатуры.Характеристика.*}
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ЦеныНоменклатуры.ВидЦен,
		|		ЦеныНоменклатуры.Номенклатура,
		|		ЦеныНоменклатуры.Характеристика,
		|		ЦеныНоменклатуры.Период) КАК ТаблицаЦен
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры КАК ЦеныНоменклатурыА
		|		ПО ТаблицаЦен.Период = ЦеныНоменклатурыА.Период
		|			И ТаблицаЦен.Номенклатура = ЦеныНоменклатурыА.Номенклатура
		|			И ТаблицаЦен.Характеристика = ЦеныНоменклатурыА.Характеристика
		|			И ТаблицаЦен.ВидЦен = ЦеныНоменклатурыА.ВидЦен
		|			И (ЦеныНоменклатурыА.Актуальность)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры КАК ЦеныНоменклатурыБ
		|		ПО ТаблицаЦен.ДатаПрошлогоИзменения = ЦеныНоменклатурыБ.Период
		|			И ТаблицаЦен.Номенклатура = ЦеныНоменклатурыБ.Номенклатура
		|			И ТаблицаЦен.Характеристика = ЦеныНоменклатурыБ.Характеристика
		|			И ТаблицаЦен.ВидЦен = ЦеныНоменклатурыБ.ВидЦен
		|			И (ЦеныНоменклатурыБ.Актуальность)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗапасыНаСкладах.Остатки(&ПериодНачалоГраница, СтруктурнаяЕдиница = &СтруктурнаяЕдиница) КАК ЗапасыНаСкладахОстатки
		|		ПО ТаблицаЦен.Номенклатура = ЗапасыНаСкладахОстатки.Номенклатура
		|			И ТаблицаЦен.Характеристика = ЗапасыНаСкладахОстатки.Характеристика
		|ГДЕ
		|	ЦеныНоменклатурыА.Период МЕЖДУ &ПериодНачало И &ПериодОкончание
		|ИТОГИ
		|	СУММА(Стоимость),
		|	СУММА(СтараяСтоимость),
		|	СУММА(ДельтаСтоимости)
		|ПО
		|	ОБЩИЕ";
	
	Запрос.УстановитьПараметр("ВидЦен", Отчет.СтруктурнаяЕдиница.РозничныйВидЦен);
	Запрос.УстановитьПараметр("ПериодНачало", НачалоДня(Расшифровка.Дата));
	Запрос.УстановитьПараметр("ПериодНачалоГраница", Новый Граница(НачалоДня(Расшифровка.Дата), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("ПериодОкончание", КонецДня(Расшифровка.Дата));
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", Отчет.СтруктурнаяЕдиница);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ОбластьМакета = Макет.ПолучитьОбласть("Строка");
	
	ВыборкаИтоги = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Если ВыборкаИтоги.Следующий() Тогда
		
		ИтогСтараяСтоимость = ВыборкаИтоги.СтараяСтоимость;
		ИтогСтоимость = ВыборкаИтоги.Стоимость;
		ИтогДельтаСтоимости = ВыборкаИтоги.ДельтаСтоимости;
		
		ВыборкаДетальныеЗаписи = ВыборкаИтоги.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			ОбластьМакета.Параметры.Заполнить(ВыборкаДетальныеЗаписи);
			Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Характеристика) Тогда
				ОбластьМакета.Параметры.НоменклатураХарактеристика = ""+ВыборкаДетальныеЗаписи.НоменклатураПредставление+
					" ("+ВыборкаДетальныеЗаписи.ХарактеристикаПредставление+")";
			Иначе
				ОбластьМакета.Параметры.НоменклатураХарактеристика = ВыборкаДетальныеЗаписи.Номенклатура;
			КонецЕсли;
			ТабДокумент.Вывести(ОбластьМакета);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
	// Итоги.
	ОбластьМакета.Параметры.ИтогСтараяСтоимость = ИтогСтараяСтоимость;
	ОбластьМакета.Параметры.ИтогСтоимость = ИтогСтоимость;
	ОбластьМакета.Параметры.ИтогДельтаСтоимости = ИтогДельтаСтоимости;
	
	ТабДокумент.Вывести(ОбластьМакета);
	
	ПолеРезультат.Очистить();
	ПолеРезультат.Вывести(ТабДокумент);
	
	Возврат ТабДокумент;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(ИдентификаторЗадания)
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаКлиенте
Функция ЭтоРежимРасшифровки()
	
	Возврат Элементы.ГруппаПараметры.Видимость = Ложь;
	
КонецФункции

#КонецОбласти

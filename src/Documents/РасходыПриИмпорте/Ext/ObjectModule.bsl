﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ПроцедурыЗаполненияДокумента

// Процедура заполнения документа на основании приходная накладной.
//
// Параметры:
//	ДанныеЗаполнения - Структура - данные заполнения документа
//					 - ДокументСсылка.ПриходнаяНакладная - приходная накладная
//
Процедура ЗаполнитьПоПриходнойНакладной(ДанныеЗаполнения) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПриходнаяНакладная.Ссылка КАК ДокументПоступления,
	|	ПриходнаяНакладная.Организация КАК Организация,
	|	ПриходнаяНакладная.Контрагент КАК Контрагент,
	|	ПриходнаяНакладная.Договор КАК Договор,
	|	ПриходнаяНакладная.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ПриходнаяНакладная.ПоложениеСклада КАК ПоложениеСклада,
	|	ПриходнаяНакладная.СуммаВключаетНДС КАК СуммаВключаетНДС,
	|	ПриходнаяНакладная.ВалютаДокумента КАК ВалютаДокументаОснования,
	|	ПриходнаяНакладная.Курс КАК КурсДокументаОснования,
	|	ПриходнаяНакладная.Кратность КАК КратностьДокументаОснования,
	|	ПриходнаяНакладная.Запасы.(
	|		Номенклатура КАК Номенклатура,
	|		Характеристика КАК Характеристика,
	|		Партия КАК Партия,
	|		ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		Ссылка КАК ДокументПоступления,
	|		ВЫБОР
	|			КОГДА ТИПЗНАЧЕНИЯ(ПриходнаяНакладная.Запасы.ЕдиницаИзмерения) = ТИП(Справочник.КлассификаторЕдиницИзмерения)
	|				ТОГДА ПриходнаяНакладная.Запасы.Количество
	|			ИНАЧЕ ПриходнаяНакладная.Запасы.Количество * ПриходнаяНакладная.Запасы.ЕдиницаИзмерения.Коэффициент
	|		КОНЕЦ КАК Количество,
	|		ПриходнаяНакладная.Запасы.Сумма - ПриходнаяНакладная.Запасы.СуммаНДС КАК Сумма,
	|		СтавкаНДС КАК СтавкаНДС,
	|		СуммаНДС КАК СуммаНДС,
	|		Заказ КАК Заказ,
	|		ЗаказПокупателя КАК ЗаказПокупателя,
	|		СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|		НомерГТД КАК НомерГТД,
	|		СтранаПроисхождения КАК СтранаПроисхождения
	|	) КАК Запасы
	|ИЗ
	|	Документ.ПриходнаяНакладная КАК ПриходнаяНакладная
	|ГДЕ
	|	ПриходнаяНакладная.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РазмещениеЗаказов.Номенклатура КАК Номенклатура,
	|	РазмещениеЗаказов.Характеристика КАК Характеристика,
	|	РазмещениеЗаказов.ЗаказПокупателя КАК ЗаказПокупателя,
	|	СУММА(ВЫБОР
	|			КОГДА РазмещениеЗаказов.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|				ТОГДА РазмещениеЗаказов.Количество
	|			ИНАЧЕ -РазмещениеЗаказов.Количество
	|		КОНЕЦ) КАК Количество
	|ИЗ
	|	РегистрНакопления.РазмещениеЗаказов КАК РазмещениеЗаказов
	|ГДЕ
	|	РазмещениеЗаказов.Регистратор = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	РазмещениеЗаказов.ЗаказПокупателя,
	|	РазмещениеЗаказов.Характеристика,
	|	РазмещениеЗаказов.Номенклатура";
	Результат = Запрос.ВыполнитьПакет();
	
	Шапка = Результат[0].Выбрать();
	Шапка.Следующий();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Шапка);
	
	ВалютаДокумента = Константы.НациональнаяВалюта.Получить();
	Курс = 1;
	Кратность = 1;
	НДСВключатьВСтоимость = Истина;
	НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ОблагаетсяНДС;
	СуммаДокумента = 0;
	
	ТаблицаОстатков = Результат[1].Выгрузить();
	ТаблицаОстатков.Индексы.Добавить("Номенклатура, Характеристика");
	
	Разделы.Очистить();
	Запасы.Очистить();
	ИсходнаяТаблицаЗапасов = Шапка.Запасы.Выгрузить();
	Если ИсходнаяТаблицаЗапасов.Количество() > 0 Тогда
		НомерГТД = ИсходнаяТаблицаЗапасов[0].НомерГТД;
	КонецЕсли; 
	
	СтруктураТаблиц = Неопределено;
	Если ИсходнаяТаблицаЗапасов.Количество() > 0 Тогда
		
		СтруктураТаблиц = РаспределитьЗапасыПоРазделам(ИсходнаяТаблицаЗапасов, ТаблицаОстатков);
		
	КонецЕсли;
	
	Если СтруктураТаблиц <> Неопределено Тогда
		
		ОтборСтрок = Новый Структура("НомерРаздела", -1);
		
		Для каждого Раздел Из СтруктураТаблиц.ТаблицаРазделы Цикл
			
			ОтборСтрок.НомерРаздела = СтруктураТаблиц.ТаблицаРазделы.Индекс(Раздел) + 1;
			МассивСтрокЗапасов = СтруктураТаблиц.ТаблицаЗапасы.НайтиСтроки(ОтборСтрок);
			Если МассивСтрокЗапасов.Количество() < 1 Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			НовыйРаздел = Разделы.Добавить();
			НовыйРаздел.СтавкаНДС		= Справочники.СтавкиНДС.СтавкаНДС(Организация.ВидСтавкиНДСПоУмолчанию);
			НовыйРаздел.СтавкаПошлины	= Раздел.СтавкаВвознойПошлины;
			НовыйРаздел.КодТНВЭД		= Раздел.КодТНВЭД;
			НовыйРаздел.СчетУчетаНДС	= ПланыСчетов.Управленческий.Налоги;
			
			СтрокаСведений = НСтр("ru ='Код товаров: %1, строк в разделе: %2'");
			НовыйРаздел.СведенияОРазделеГТД = СтрШаблон(СтрокаСведений, НовыйРаздел.КодТНВЭД,
				МассивСтрокЗапасов.Количество());
			
			Для каждого СтрокаТабличнойЧасти Из МассивСтрокЗапасов Цикл
				
				НоваяСтрока = Запасы.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТабличнойЧасти);
				
				НоваяСтрока.НомерРаздела = ОтборСтрок.НомерРаздела;
				НоваяСтрока.СуммаПошлины = Окр(НоваяСтрока.ФактурнаяСтоимость
					* НовыйРаздел.СтавкаПошлины / 100, 2);
				НоваяСтрока.ДокументПартии = ДанныеЗаполнения.Ссылка;
				
				Если ВалютаДокумента <> Шапка.ВалютаДокументаОснования Тогда

					НоваяСтрока.СуммаПошлины = Окр(НоваяСтрока.СуммаПошлины
						* Шапка.КурсДокументаОснования / Шапка.КратностьДокументаОснования, 2);
					НоваяСтрока.ФактурнаяСтоимость = Окр(НоваяСтрока.ФактурнаяСтоимость
						* Шапка.КурсДокументаОснования / Шапка.КратностьДокументаОснования, 2);
					НоваяСтрока.СуммаНДС = Окр(НоваяСтрока.СуммаНДС * Шапка.КурсДокументаОснования
						/ Шапка.КратностьДокументаОснования, 2);

				КонецЕсли;

				НовыйРаздел.ТаможеннаяСтоимость = НовыйРаздел.ТаможеннаяСтоимость
					+ НоваяСтрока.ФактурнаяСтоимость;
				НовыйРаздел.СуммаПошлины = НовыйРаздел.СуммаПошлины
					+ НоваяСтрока.СуммаПошлины;
				НовыйРаздел.СуммаНДС = НовыйРаздел.СуммаНДС + НоваяСтрока.СуммаНДС;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
	СуммаДокумента = Разделы.Итог("СуммаНДС") + Разделы.Итог("СуммаПошлины") + ТаможенныйСбор + ТаможенныйШтраф;
	
	//
	// Корректное распределение суммы сбора можно произвести только после заполнения ТЧ Запасы
	//
	Если ТаможенныйСбор > 0
		И Запасы.Количество() > 1 Тогда
		
		СоответствиеСтарыхСумм = Новый Соответствие;
		Для каждого СтрокаЗапасов Из Запасы Цикл
			
			СоответствиеСтарыхСумм.Вставить(Запасы.Индекс(СтрокаЗапасов), СтрокаЗапасов.ФактурнаяСтоимость);
			
		КонецЦикла;
		
		СоответствиеНовыхСумм = РаспределитьСуммыПропорционально(ТаможенныйСбор, СоответствиеСтарыхСумм);
		
		Если ТипЗнч(СоответствиеНовыхСумм) = Тип("Соответствие") Тогда
			
			Для каждого ЭлементСоответствия Из СоответствиеНовыхСумм Цикл
				
				СтрокаТаблицы = Запасы.Получить(ЭлементСоответствия.Ключ);
				СтрокаТаблицы.СуммаСбора = ЭлементСоответствия.Значение;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьПоПриходнойНакладной()

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.ПриходнаяНакладная")] = "ЗаполнитьПоПриходнойНакладной";
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ Контрагент.ВестиРасчетыПоДоговорам Тогда
		
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Договор");
		
	КонецЕсли;
		
	НоменклатураВДокументахСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, Отказ, Истина);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контрагент)
		И НЕ Контрагент.ВестиРасчетыПоДоговорам
		И НЕ ЗначениеЗаполнено(Договор) Тогда
		
		Договор = Справочники.ДоговорыКонтрагентов.ДоговорПоУмолчанию(Контрагент);
		
	КонецЕсли;
	
	Для каждого СтрокаЗапасов Из Запасы Цикл
		
		Если ЗначениеЗаполнено(СтрокаЗапасов.СтруктурнаяЕдиница) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		СтрокаЗапасов.СтруктурнаяЕдиница = Справочники.СтруктурныеЕдиницы.ОсновнойСклад;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.РасходыПриИмпорте.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ПроведениеДокументовУНФ.ОтразитьДвижения("Запасы", ТаблицыДляДвижений, Движения, Отказ);
	ПрочиеРасчетыУНФ.ОтразитьРасчетыСПрочимиКонтрагентами(ДополнительныеСвойства, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДоходыИРасходы", ТаблицыДляДвижений, Движения, Отказ);
	
	ПроведениеДокументовУНФ.ОтразитьУправленческий(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей.
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.РасходыПриИмпорте.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция РаспределитьЗапасыПоРазделам(ИсходнаяТаблицаЗапасов, ТаблицаОстатков)
	
	СтруктураТаблиц = Новый Структура;
	СтруктураТаблиц.Вставить("ТаблицаРазделы", Документы.РасходыПриИмпорте.ПустаяСсылка().Разделы.Выгрузить());
	СтруктураТаблиц.Вставить("ТаблицаЗапасы", Документы.РасходыПриИмпорте.ПустаяСсылка().Запасы.Выгрузить());
	
	КвалификаторыЧисла = Новый КвалификаторыЧисла(2);
	СтруктураТаблиц.ТаблицаРазделы.Колонки.Добавить("СтавкаВвознойПошлины", Новый ОписаниеТипов(КвалификаторыЧисла));
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИсходнаяТаблицаЗапасов", ИсходнаяТаблицаЗапасов);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	-1 КАК НомерРаздела,
	|	ВЫРАЗИТЬ(ИсходнаяТаблицаЗапасов.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	ИсходнаяТаблицаЗапасов.Характеристика КАК Характеристика,
	|	ИсходнаяТаблицаЗапасов.Партия КАК Партия,
	|	ИсходнаяТаблицаЗапасов.Количество КАК Количество,
	|	ИсходнаяТаблицаЗапасов.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ИсходнаяТаблицаЗапасов.Сумма КАК Сумма,
	|	ИсходнаяТаблицаЗапасов.СтавкаНДС КАК СтавкаНДС,
	|	ИсходнаяТаблицаЗапасов.СуммаНДС КАК СуммаНДС,
	|	ИсходнаяТаблицаЗапасов.СтранаПроисхождения КАК СтранаПроисхождения,
	|	ИсходнаяТаблицаЗапасов.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ВЫРАЗИТЬ(ИсходнаяТаблицаЗапасов.Заказ КАК Документ.ЗаказПоставщику) КАК ЗаказПоставщику,
	|	ИсходнаяТаблицаЗапасов.ЗаказПокупателя КАК ЗаказПокупателя
	|ПОМЕСТИТЬ врИсходнаяТаблицаЗапасов
	|ИЗ
	|	&ИсходнаяТаблицаЗапасов КАК ИсходнаяТаблицаЗапасов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИсходнаяТаблицаЗапасов.НомерРаздела КАК НомерРаздела,
	|	ИсходнаяТаблицаЗапасов.Номенклатура КАК Номенклатура,
	|	ИсходнаяТаблицаЗапасов.Номенклатура.ТоварнаяНоменклатураВЭД.Код КАК КодТНВЭД,
	|	ИсходнаяТаблицаЗапасов.Номенклатура.ТоварнаяНоменклатураВЭД.ВвознаяПошлина КАК ВвознаяПошлина,
	|	ИсходнаяТаблицаЗапасов.Характеристика КАК Характеристика,
	|	ИсходнаяТаблицаЗапасов.Партия КАК Партия,
	|	ИсходнаяТаблицаЗапасов.Количество КАК Количество,
	|	ВЫБОР
	|		КОГДА ИсходнаяТаблицаЗапасов.ЕдиницаИзмерения ССЫЛКА Справочник.ЕдиницыИзмерения
	|			ТОГДА ВЫРАЗИТЬ(ИсходнаяТаблицаЗапасов.ЕдиницаИзмерения КАК Справочник.ЕдиницыИзмерения).Коэффициент
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК Коэффициент,
	|	ИсходнаяТаблицаЗапасов.Сумма КАК Сумма,
	|	ИсходнаяТаблицаЗапасов.Сумма КАК ФактурнаяСтоимость,
	|	ИсходнаяТаблицаЗапасов.СтавкаНДС КАК СтавкаНДС,
	|	ИсходнаяТаблицаЗапасов.СуммаНДС КАК СуммаНДС,
	|	0 КАК СуммаСбора,
	|	ИсходнаяТаблицаЗапасов.СтранаПроисхождения КАК СтранаПроисхождения,
	|	ИсходнаяТаблицаЗапасов.ЗаказПоставщику КАК ЗаказПоставщику,
	|	ИсходнаяТаблицаЗапасов.ЗаказПокупателя КАК ЗаказПокупателя,
	|	ИсходнаяТаблицаЗапасов.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	НЕОПРЕДЕЛЕНО КАК ДокументПартии
	|ИЗ
	|	врИсходнаяТаблицаЗапасов КАК ИсходнаяТаблицаЗапасов";
	
	НоменклатураИКодыТНВЭД = Запрос.Выполнить().Выгрузить();
	
	// Распределение по заказам покупателей
	СтруктураОтбора = Новый Структура;
	Если ПолучитьФункциональнуюОпцию("РезервированиеЗапасов") Тогда
		
		ТаблицаРаспределения = НоменклатураИКодыТНВЭД.СкопироватьКолонки();
		
		Для каждого СтрокаТаблицы Из НоменклатураИКодыТНВЭД Цикл
			
			НоваяСтрока = ТаблицаРаспределения.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы, , "ЗаказПокупателя");
				
			Если ЗначениеЗаполнено(НоваяСтрока.ЗаказПоставщику) Тогда
				// Определение заказов покупателей по размещению
				Распределить = НоваяСтрока.Количество;
				СтруктураОтбора.Очистить();
				СтруктураОтбора.Вставить("Номенклатура", НоваяСтрока.Номенклатура);
				СтруктураОтбора.Вставить("Характеристика", НоваяСтрока.Характеристика);
				Если ЗначениеЗаполнено(НоваяСтрока.ЗаказПокупателя) Тогда
					СтруктураОтбора.Вставить("ЗаказПокупателя", НоваяСтрока.ЗаказПокупателя);
					СтрокиОстатков = ТаблицаОстатков.НайтиСтроки(СтруктураОтбора);
					Для каждого СтрокаОстатка Из СтрокиОстатков Цикл
						Количество = Мин(Распределить, СтрокаОстатка.Количество / НоваяСтрока.Коэффициент);
						СтрокаОстатка.Количество = СтрокаОстатка.Количество - Количество * НоваяСтрока.Коэффициент;
						Распределить = Распределить - Количество;
					КонецЦикла; 
				Иначе
					СтрокиОстатков = ТаблицаОстатков.НайтиСтроки(СтруктураОтбора);
					Для каждого СтрокаОстатка Из СтрокиОстатков Цикл
						Количество = Мин(Распределить, СтрокаОстатка.Количество / НоваяСтрока.Коэффициент);
						Если Количество = 0 Тогда
							Продолжить;
						КонецЕсли; 
						Если Количество = Распределить Тогда
							НоваяСтрока.ЗаказПокупателя = СтрокаОстатка.ЗаказПокупателя;
							Распределить = 0;
							СтрокаОстатка.Количество = СтрокаОстатка.Количество - Количество * НоваяСтрока.Коэффициент;
						Иначе
							ДополнительнаяСтрока = ТаблицаРаспределения.Добавить();
							ЗаполнитьЗначенияСвойств(ДополнительнаяСтрока, НоваяСтрока);
							ДополнительнаяСтрока.ЗаказПокупателя = СтрокаОстатка.ЗаказПокупателя;
							ДополнительнаяСтрока.Количество = Количество;
							НоваяСтрока.Количество = НоваяСтрока.Количество - Количество;
							ПеренестиВПропорции(ДополнительнаяСтрока, НоваяСтрока, "Сумма", Количество / Распределить);
							ПеренестиВПропорции(ДополнительнаяСтрока, НоваяСтрока, "СуммаНДС", Количество / Распределить);
							ПеренестиВПропорции(ДополнительнаяСтрока, НоваяСтрока, "ФактурнаяСтоимость", Количество / Распределить);
							Распределить = Распределить - Количество;
							СтрокаОстатка.Количество = 0;
						КонецЕсли; 
					КонецЦикла; 
				КонецЕсли; 
			КонецЕсли;
			
		КонецЦикла;
		
		НоменклатураИКодыТНВЭД = ТаблицаРаспределения;
		
	КонецЕсли; 
	
	Для каждого СтрокаТаблицы Из НоменклатураИКодыТНВЭД Цикл
		
		Если ПустаяСтрока(СокрЛП(СтрокаТаблицы.КодТНВЭД)) Тогда
			
			СтрокаТаблицы.КодТНВЭД = "0000000000";
			
		КонецЕсли;
		
		СтрокаТаблицыРазделов = СтруктураТаблиц.ТаблицаРазделы.Найти(СтрокаТаблицы.КодТНВЭД, "КодТНВЭД");
		Если СтрокаТаблицыРазделов = Неопределено Тогда
			
			СтрокаТаблицыРазделов = СтруктураТаблиц.ТаблицаРазделы.Добавить();
			СтрокаТаблицыРазделов.КодТНВЭД = СокрЛП(СтрокаТаблицы.КодТНВЭД);
			СтрокаТаблицыРазделов.СтавкаВвознойПошлины = СтрокаТаблицы.ВвознаяПошлина;
			
		КонецЕсли;
		
		СтрокаТаблицыЗапасов = СтруктураТаблиц.ТаблицаЗапасы.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицыЗапасов, СтрокаТаблицы);
		
		СтрокаТаблицыЗапасов.НомерРаздела =  СтруктураТаблиц.ТаблицаРазделы.Индекс(СтрокаТаблицыРазделов) + 1;
		
	КонецЦикла;
	
	Возврат СтруктураТаблиц;
	
КонецФункции

Процедура ПеренестиВПропорции(СтрокаПриемник, СтрокаИсточник, ИмяПоля, Пропорция)
	
	Значение = СтрокаИсточник[ИмяПоля] * Пропорция;
	СтрокаПриемник[ИмяПоля] = Значение;
	СтрокаИсточник[ИмяПоля] = СтрокаИсточник[ИмяПоля] - Значение;
	
КонецПроцедуры

Функция РаспределитьСуммыПропорционально(Знач ИсходнаяСумма, КоэффициентыСоответствие, Точность = 2)
	
	Если КоэффициентыСоответствие.Количество() = 0 
		ИЛИ ИсходнаяСумма = 0 
		ИЛИ ИсходнаяСумма = Null Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	ИндексМакс = 0;
	МаксЗнач   = 0;
	РаспрСумма = 0;
	СуммаКоэфф  = 0;
	
	Для каждого ЭлементСоответствия Из КоэффициентыСоответствие Цикл
		
		МодульЧисла = ?(ЭлементСоответствия.Значение > 0, ЭлементСоответствия.Значение, - ЭлементСоответствия.Значение);
		
		Если МаксЗнач < МодульЧисла Тогда
			
			МаксЗнач = МодульЧисла;
			ИндексМакс = ЭлементСоответствия.Ключ;
			
		КонецЕсли;
		
		СуммаКоэфф = СуммаКоэфф + ЭлементСоответствия.Значение;
		
	КонецЦикла;
	
	Если СуммаКоэфф = 0 Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	СоответствиеНовыхСумм = Новый Соответствие;
	Для каждого ЭлементСоответствия Из КоэффициентыСоответствие Цикл
		
		НоваяСумма = Окр(ИсходнаяСумма * ЭлементСоответствия.Значение / СуммаКоэфф, Точность, 1);
		СоответствиеНовыхСумм.Вставить(ЭлементСоответствия.Ключ, НоваяСумма);
		РаспрСумма = РаспрСумма + НоваяСумма;
		
	КонецЦикла;
	
	// Погрешности округления отнесем на коэффициент с максимальным весом
	Если Не РаспрСумма = ИсходнаяСумма Тогда
		
		ЗначениеЭлемента = СоответствиеНовыхСумм.Получить(ИндексМакс);
		ЗначениеЭлемента = ЗначениеЭлемента + (ИсходнаяСумма - РаспрСумма);
		
		СоответствиеНовыхСумм.Вставить(ИндексМакс, ЗначениеЭлемента);
		
	КонецЕсли;
	
	Возврат СоответствиеНовыхСумм;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
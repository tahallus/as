﻿Перем ДатаНомерДня, СтрокиМедиаплана, СтруктураТаблицы;

#Область Старое

#Если ВебКлиент Тогда 
	
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МедиапланСсылка = Параметры.МедиапланСсылка; 
	ДанныеТабличныхЧастей.Загрузить(Параметры.ДанныеТабличныхЧастей);
	
	СтрокиМедиаплана = Параметры.ДанныеТабличныхЧастей.Скопировать(,"НомерСтроки,Номенклатура");
	СтрокиМедиаплана.Свернуть("НомерСтроки,Номенклатура");
	СтрокиМедиаплана.Сортировать("НомерСтроки");
	
	ДатаНачала = Параметры.ДатаНачала;
	ДатаОкончания = Параметры.ДатаОкончания;
	
	ДанныеИнформационнойБазы = ПолучитьДанныеИнформационнойБазы();
	
	ЗаполнитьДатаНомерДня(ДанныеИнформационнойБазы.ТаблицаДатаНомерДня);	
	
	ВывестиЗаголовокПериоды(ДанныеИнформационнойБазы.ТаблицаМесяцКоличествоДней, ДанныеИнформационнойБазы.ТаблицаДатаНомерДня);
	ВывестиТаблицуТрафик(ДанныеИнформационнойБазы.ТаблицаПланируемыйТрафик, "Планируемый трафик");	
	ВывестиТаблицуТрафик(ДанныеИнформационнойБазы.ТаблицаБронирования, "Бронь");	
	ВывестиТаблицуТрафик(ДанныеИнформационнойБазы.ТаблицаПредварительногоБронирования, "Пребронь");	
	
	ЗаполнитьДанныеИзДанныхТабличныхЧастей();
    ВывестиТаблицуМедиаплан();
	
КонецПроцедуры

Процедура ЗаполнитьДатаНомерДня(ТаблицаДатаНомерДня)

	ДатаНомерДня = Новый Соответствие;
	
	Для Каждого СтрокаТаблицыДатаНомерДня Из ТаблицаДатаНомерДня Цикл 
		ДатаНомерДня.Вставить(СтрокаТаблицыДатаНомерДня.Дата, СтрокаТаблицыДатаНомерДня.НомерДня);
		ДатаНомерДня.Вставить(СтрокаТаблицыДатаНомерДня.НомерДня, СтрокаТаблицыДатаНомерДня.Дата);
	КонецЦикла;
	

КонецПроцедуры

&НаКлиенте
Процедура Установть(Команда)
	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеИнформационнойБазы()

	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Медиаплан", МедиапланСсылка);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДанныеТабличныхЧастей", ДанныеТабличныхЧастей.Выгрузить());
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДанныеТабличныхЧастей.НомерСтроки КАК НомерСтроки,
	               |	ДанныеТабличныхЧастей.Номенклатура КАК Номенклатура,
	               |	ДанныеТабличныхЧастей.Количество КАК Количество,
	               |	ДанныеТабличныхЧастей.ДатаНачала КАК ДатаНачала,
	               |	ДанныеТабличныхЧастей.ДатаОкончания КАК ДатаОкончания,
	               |	ДанныеТабличныхЧастей.КоличествоДней КАК КоличествоДней
	               |ПОМЕСТИТЬ ДанныеТабличныхЧастей
	               |ИЗ
	               |	&ДанныеТабличныхЧастей КАК ДанныеТабличныхЧастей
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Номенклатура_Состав.Ссылка КАК Номенклатура,
	               |	Номенклатура_Состав.Площадка КАК Площадка,
	               |	Номенклатура_Состав.Коэффициент КАК Коэффициент
	               |ПОМЕСТИТЬ ВТ_НоменклатураПлощадки
	               |ИЗ
	               |	Справочник.Номенклатура._Состав КАК Номенклатура_Состав
	               |ГДЕ
	               |	Номенклатура_Состав.Ссылка В
	               |			(ВЫБРАТЬ
	               |				ДанныеТабличныхЧастей.Номенклатура КАК Номенклатура
	               |			ИЗ
	               |				ДанныеТабличныхЧастей КАК ДанныеТабличныхЧастей)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ДанныеТабличныхЧастей.ДатаНачала КАК ДатаНачала,
	               |	ДанныеТабличныхЧастей.ДатаОкончания КАК ДатаОкончания
	               |ПОМЕСТИТЬ ВТ_Периоды
	               |ИЗ
	               |	ДанныеТабличныхЧастей КАК ДанныеТабличныхЧастей
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	&ДатаНачала,
	               |	&ДатаОкончания
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	МИНИМУМ(ВТ_Периоды.ДатаНачала) КАК ДатаНачала,
	               |	МАКСИМУМ(ВТ_Периоды.ДатаОкончания) КАК ДатаОкончания
	               |ПОМЕСТИТЬ ВТ_Период
	               |ИЗ
	               |	ВТ_Периоды КАК ВТ_Периоды
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	НАЧАЛОПЕРИОДА(ДанныеПроизводственногоКалендаря.Дата, МЕСЯЦ) КАК Месяц,
	               |	ДанныеПроизводственногоКалендаря.Дата КАК Дата,
	               |	РАЗНОСТЬДАТ(ВТ_Период.ДатаНачала, ДанныеПроизводственногоКалендаря.Дата, ДЕНЬ) + 1 КАК НомерДня
	               |ПОМЕСТИТЬ ВТ_Календарь
	               |ИЗ
	               |	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Период КАК ВТ_Период
	               |		ПО ДанныеПроизводственногоКалендаря.Дата >= ВТ_Период.ДатаНачала
	               |			И ДанныеПроизводственногоКалендаря.Дата <= ВТ_Период.ДатаОкончания
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ДанныеПроизводственногоКалендаря.Дата,
	               |	РАЗНОСТЬДАТ(ВТ_Период.ДатаНачала, ДанныеПроизводственногоКалендаря.Дата, ДЕНЬ) + 1
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_Календарь.Дата КАК Дата,
	               |	ВТ_Календарь.НомерДня КАК НомерДня
	               |ИЗ
	               |	ВТ_Календарь КАК ВТ_Календарь
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Дата
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_Календарь.Месяц КАК Месяц,
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВТ_Календарь.Дата) КАК КоличествоДней,
	               |	МИНИМУМ(ВТ_Календарь.НомерДня) КАК НомерДня
	               |ИЗ
	               |	ВТ_Календарь КАК ВТ_Календарь
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВТ_Календарь.Месяц
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Месяц
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_Календарь.Дата КАК Дата,
	               |	ВТ_Календарь.НомерДня КАК НомерДня,
	               |	_ОжидаемыеСуточныеПоказателиТрафика.Площадка КАК Площадка,
	               |	_ОжидаемыеСуточныеПоказателиТрафика.Показы КАК Трафик
	               |ИЗ
	               |	РегистрСведений._ОжидаемыеСуточныеПоказателиТрафика КАК _ОжидаемыеСуточныеПоказателиТрафика
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Календарь КАК ВТ_Календарь
	               |		ПО (ИСТИНА)
	               |ГДЕ
	               |	_ОжидаемыеСуточныеПоказателиТрафика.Площадка В
	               |			(ВЫБРАТЬ
	               |				ВТ_НоменклатураПлощадки.Площадка КАК Площадка
	               |			ИЗ
	               |				ВТ_НоменклатураПлощадки КАК ВТ_НоменклатураПлощадки
	               |			СГРУППИРОВАТЬ ПО
	               |				ВТ_НоменклатураПлощадки.Площадка)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	_ДанныеБронированияПлощадок.Период КАК Дата,
	               |	_ДанныеБронированияПлощадок.Площадка КАК Площадка,
	               |	_ДанныеБронированияПлощадок.Показы КАК Трафик,
	               |	ВТ_Календарь.НомерДня КАК НомерДня
	               |ИЗ
	               |	ВТ_Период КАК ВТ_Период
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления._ДанныеБронированияПлощадок КАК _ДанныеБронированияПлощадок
	               |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Календарь КАК ВТ_Календарь
	               |			ПО _ДанныеБронированияПлощадок.Период = ВТ_Календарь.Дата
	               |		ПО ВТ_Период.ДатаНачала <= _ДанныеБронированияПлощадок.Период
	               |			И ВТ_Период.ДатаОкончания >= _ДанныеБронированияПлощадок.Период
	               |ГДЕ
	               |	_ДанныеБронированияПлощадок.Площадка В
	               |			(ВЫБРАТЬ
	               |				ВТ_НоменклатураПлощадки.Площадка КАК Площадка
	               |			ИЗ
	               |				ВТ_НоменклатураПлощадки КАК ВТ_НоменклатураПлощадки
	               |			СГРУППИРОВАТЬ ПО
	               |				ВТ_НоменклатураПлощадки.Площадка)
	               |	И _ДанныеБронированияПлощадок.Регистратор <> &Медиаплан
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	_ДанныеПредварительногоБронированияПлощадок.Период КАК Дата,
	               |	ВТ_Календарь.НомерДня КАК НомерДня,
	               |	_ДанныеПредварительногоБронированияПлощадок.Площадка КАК Площадка,
	               |	_ДанныеПредварительногоБронированияПлощадок.Показы КАК Трафик
	               |ИЗ
	               |	ВТ_Период КАК ВТ_Период
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления._ДанныеПредварительногоБронированияПлощадок КАК _ДанныеПредварительногоБронированияПлощадок
	               |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Календарь КАК ВТ_Календарь
	               |			ПО _ДанныеПредварительногоБронированияПлощадок.Период = ВТ_Календарь.Дата
	               |		ПО ВТ_Период.ДатаНачала <= _ДанныеПредварительногоБронированияПлощадок.Период
	               |			И ВТ_Период.ДатаОкончания >= _ДанныеПредварительногоБронированияПлощадок.Период
	               |ГДЕ
	               |	_ДанныеПредварительногоБронированияПлощадок.Площадка В
	               |			(ВЫБРАТЬ
	               |				ВТ_НоменклатураПлощадки.Площадка КАК Площадка
	               |			ИЗ
	               |				ВТ_НоменклатураПлощадки КАК ВТ_НоменклатураПлощадки
	               |			СГРУППИРОВАТЬ ПО
	               |				ВТ_НоменклатураПлощадки.Площадка)
	               |	И _ДанныеПредварительногоБронированияПлощадок.Регистратор <> &Медиаплан
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_НоменклатураПлощадки.Номенклатура КАК Номенклатура,
	               |	ВТ_НоменклатураПлощадки.Площадка КАК Площадка,
	               |	ВТ_НоменклатураПлощадки.Коэффициент КАК Коэффициент
	               |ИЗ
	               |	ВТ_НоменклатураПлощадки КАК ВТ_НоменклатураПлощадки";
	
	ПакетРезультатов = Запрос.ВыполнитьПакет();
	
	
	Результат = Новый Структура;
	Результат.Вставить("ТаблицаДатаНомерДня", ПакетРезультатов[5].Выгрузить());
	Результат.Вставить("ТаблицаМесяцКоличествоДней", ПакетРезультатов[6].Выгрузить());
	Результат.Вставить("ТаблицаПланируемыйТрафик", ПакетРезультатов[7].Выгрузить());
	Результат.Вставить("ТаблицаБронирования", ПакетРезультатов[8].Выгрузить());
	Результат.Вставить("ТаблицаПредварительногоБронирования", ПакетРезультатов[9].Выгрузить());
	Результат.Вставить("ТаблицаНоменклатураПлощадка", ПакетРезультатов[10].Выгрузить());
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ВывестиЗаголовокПериоды(ТаблицаМесяцКоличествоДней, ТаблицаДатаНомерДня, ШиринаКолонкиДень = 10, ШиринаПеровойКолонки = 50)

	Сплошная_2 = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 2, Ложь);
	
	Таблица = Новый ТабличныйДокумент;
	ОбластьУгол = Таблица.Область(1, 1, 2, 1);
	ОбластьУгол.Объединить();
	ОбластьУгол.Обвести(Сплошная_2,Сплошная_2,Сплошная_2,Сплошная_2);
	ОбластьУгол.Узор = ТипУзораТабличногоДокумента.Узор1;
	ОбластьУгол.ШиринаКолонки = ШиринаПеровойКолонки;
	
	Для Каждого СтрокаМесяц Из ТаблицаМесяцКоличествоДней Цикл 
		ОбластьМесяц = Таблица.Область(1, 1 + СтрокаМесяц.НомерДня, 1,  СтрокаМесяц.НомерДня + СтрокаМесяц.КоличествоДней);
		ОбластьМесяц.Объединить();
		ОбластьМесяц.Обвести(Сплошная_2,Сплошная_2,Сплошная_2,Сплошная_2);
		ОбластьМесяц.Текст = Формат(СтрокаМесяц.Месяц, "ДФ=MMMM");
		ОбластьМесяц.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
	КонецЦикла;
	
	Для Каждого СтрокаДата Из ТаблицаДатаНомерДня Цикл 
		ОбластьДень = Таблица.Область(2, СтрокаДата.НомерДня + 1, 2, СтрокаДата.НомерДня + 1);
		ОбластьДень.Объединить();
		ОбластьДень.Обвести(Сплошная_2,Сплошная_2,Сплошная_2,Сплошная_2);
		ОбластьДень.Текст = Формат(СтрокаДата.Дата, "ДФ='дд ддд'");
		ОбластьДень.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
		ОбластьДень.ШиринаКолонки = ШиринаКолонкиДень;
	КонецЦикла;
	ТаблицаБронирования.Вывести(Таблица);

КонецПроцедуры

&НаСервере
Процедура ВывестиТаблицуТрафик(ТаблицаТрафик, ЗаголовокТаблицы = "Заголовок")//  Дата/НомерДня/Площадка/Трафик

	Сплошная_2 = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 2, Ложь);

	Таблица = Новый ТабличныйДокумент;
	
	ОбластьЗаголовок = Таблица.Область(2, 1, 2, ТаблицаБронирования.ШиринаТаблицы);
	ОбластьЗаголовок.Обвести(Сплошная_2,Сплошная_2,Сплошная_2,Сплошная_2);
	ОбластьЗаголовок.Объединить();
	ОбластьЗаголовок.Текст = ЗаголовокТаблицы;

	ТаблицаБронирования.Вывести(Таблица);
	Таблица.Очистить();
	
	ТабПлощадки = ТаблицаТрафик.Скопировать(,"Площадка");
	ТабПлощадки.Свернуть("Площадка");
	Площадки = ТабПлощадки.ВыгрузитьКолонку("Площадка");
	
	Для Каждого Площадка Из Площадки Цикл
		ОтборСтрок = Новый Структура("Площадка", Площадка);
		СтрокиПлощадки = ТаблицаТрафик.НайтиСтроки(ОтборСтрок);
		ОбластьПлощадка = Таблица.Область(1, 1, 1, 1);
		ОбластьПлощадка.Обвести(Сплошная_2,Сплошная_2,Сплошная_2,Сплошная_2);
		ОбластьПлощадка.Текст = Площадка.Наименование;
		Для Каждого СтрокаПлощадки Из СтрокиПлощадки Цикл
			ОбластьПлощадка = Таблица.Область(1, СтрокаПлощадки.НомерДня + 1, 1, СтрокаПлощадки.НомерДня + 1);
			ОбластьПлощадка.Обвести(Сплошная_2,Сплошная_2,Сплошная_2,Сплошная_2);
			ОбластьПлощадка.Текст = СтрокаПлощадки.Трафик;
		КонецЦикла;
		ТаблицаБронирования.Вывести(Таблица);	
		Таблица.Очистить();
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеИзДанныхТабличныхЧастей(ТаблицаНоменклатураПлощадка = Неопределено , ТаблицаДатаНомерДня = Неопределено)
	

	ДанныеМедиаплана.Очистить();
	Для Каждого СтрокаТабличнойЧасти из ДанныеТабличныхЧастей Цикл      //НомерСтроки.Номенклатура.ДатаНачала.ДатаОкончания.Количество.КоличествоДней
		
		ДатаНачала = СтрокаТабличнойЧасти.ДатаНачала;
		ДатаОкончания = СтрокаТабличнойЧасти.ДатаОкончания;
		КоличествоДней = СтрокаТабличнойЧасти.КоличествоДней;
		КоличествоВДень = Цел(СтрокаТабличнойЧасти.Количество/КоличествоДней);
		Остаток = СтрокаТабличнойЧасти.Количество - КоличествоДней*КоличествоВДень;
		КлючПериода = Новый УникальныйИдентификатор();
		Для СмещениеДень = 0 По СтрокаТабличнойЧасти.КоличествоДней-1  Цикл
			СтрокаМедиаплана = ДанныеМедиаплана.Добавить();
			СтрокаМедиаплана.НомерСтроки = СтрокаТабличнойЧасти.НомерСтроки;
			СтрокаМедиаплана.Номенклатура = СтрокаТабличнойЧасти.Номенклатура;
			СтрокаМедиаплана.КоличествоЦел = КоличествоВДень;
			СтрокаМедиаплана.Дата = ДатаНачала + СмещениеДень*86400;
			СтрокаМедиаплана.КлючПериода = КлючПериода;
			СтрокаМедиаплана.КоличествоОст = Мин(Остаток, 1);
			СтрокаМедиаплана.Количество = СтрокаМедиаплана.КоличествоЦел + СтрокаМедиаплана.КоличествоОст;
			Остаток = Макс(0, Остаток - 1);
			
		КонецЦикла;
	КонецЦикла;
	
	ОбновитьДанныеМедиапланаРасшифровка();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеМедиапланаРасшифровка()

	ДанныеМедиапланаРасшифровка.Очистить();
	
	Для Каждого СтрокаДанныеМедиаплана Из ДанныеМедиаплана Цикл 
		Площадки = ПолучитьСоставНоменклатуры(СтрокаДанныеМедиаплана.Номенклатура); 	
		Для Каждого СтрокаПлощадки из Площадки Цикл 
			СтрокаРасшифровки = ДанныеМедиапланаРасшифровка.Добавить();
			СтрокаРасшифровки.НомерСтроки = СтрокаДанныеМедиаплана.НомерСтроки;
			СтрокаРасшифровки.Площадка = СтрокаПлощадки.Площадка;
			СтрокаРасшифровки.Коэффициент = СтрокаПлощадки.Коэффициент;
			СтрокаРасшифровки.Количество = СтрокаРасшифровки.Коэффициент * СтрокаДанныеМедиаплана.Количество;
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция ПолучитьСоставНоменклатуры(Номенклатура)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Номенклатура_Состав.НомерСтроки КАК НомерСтроки,
		|	Номенклатура_Состав.Площадка КАК Площадка,
		|	Номенклатура_Состав.Коэффициент КАК Коэффициент
		|ИЗ
		|	Справочник.Номенклатура._Состав КАК Номенклатура_Состав
		|ГДЕ
		|	Номенклатура_Состав.Ссылка = &Номенклатура
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

&НаСервере
Процедура ВывестиТаблицуМедиаплан()

	Сплошная_2 = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 2, Ложь);

	Таблица = Новый ТабличныйДокумент;
	
	ОбластьЗаголовок = Таблица.Область(2, 1, 2, ТаблицаБронирования.ШиринаТаблицы);
	ОбластьЗаголовок.Обвести(Сплошная_2,Сплошная_2,Сплошная_2,Сплошная_2);
	ОбластьЗаголовок.Объединить();
	ОбластьЗаголовок.Текст = "Медиаплан";
	
	ТаблицаБронирования.Вывести(Таблица);
	Таблица.Очистить();
	
	
	Для Каждого СтрокаМедиаплана Из СтрокиМедиаплана Цикл
		
		
		
		ОбластьНаименование = Таблица.Область(1,1,1,1);
		ОбластьНаименование.Обвести(Сплошная_2,Сплошная_2,Сплошная_2,Сплошная_2);
		ОбластьНаименование.Текст = "" + СтрокаМедиаплана.НомерСтроки + ": " + СтрокаМедиаплана.Номенклатура.Наименование;

		Отбор = Новый Структура("НомерСтроки", СтрокаМедиаплана.НомерСтроки);
		СтрокиДанныхМедиаплана = ДанныеМедиаплана.НайтиСтроки(Отбор);
		СоставНоменклатуры = ПолучитьСоставНоменклатуры(СтрокаМедиаплана.Номенклатура);
		Для Каждого Площадка Из СоставНоменклатуры Цикл 
			ОбластьПлощадка = Таблица.Область(1 + Площадка.НомерСтроки, 1, 1 + Площадка.НомерСтроки, 1);
			ОбластьПлощадка.Обвести(Сплошная_2,Сплошная_2,Сплошная_2,Сплошная_2);
			ОбластьПлощадка.Текст = Площадка.Площадка.Наименование;
			ОбластьПлощадка.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Право;
		КонецЦикла;
		
		
		
		
		Для Каждого СтрокаДанныхМедиаплана Из СтрокиДанныхМедиаплана Цикл 
			
			ОбластьДата = Таблица.Область(1, ДатаНомерДня[СтрокаДанныхМедиаплана.Дата] + 1, 1, ДатаНомерДня[СтрокаДанныхМедиаплана.Дата] + 1);
			ОбластьДата.Обвести(Сплошная_2,Сплошная_2,Сплошная_2,Сплошная_2);
			ОбластьДата.Текст = СтрокаДанныхМедиаплана.Количество;
			Для Каждого Площадка Из СоставНоменклатуры Цикл 
				ОбластьПлощадкаДата = Таблица.Область(1 + Площадка.НомерСтроки, ДатаНомерДня[СтрокаДанныхМедиаплана.Дата] + 1, 1 + Площадка.НомерСтроки, ДатаНомерДня[СтрокаДанныхМедиаплана.Дата] + 1);
				ОбластьПлощадкаДата.Обвести(Сплошная_2,Сплошная_2,Сплошная_2,Сплошная_2);
				ОбластьПлощадкаДата.Текст = СтрокаДанныхМедиаплана.Количество * Площадка.Коэффициент;
				//ОбластьПлощадкаДата.Имя
			КонецЦикла;
			
			
			
			
		КонецЦикла;
		
		ТаблицаБронирования.Вывести(Таблица);
		Таблица.Очистить();
			
		
		
		
	КонецЦикла;

КонецПроцедуры

#КонецЕсли

&НаСервере
Процедура ОбновитьНаСервере()
	
	МакетСКД = Документы._Медиаплан.СоздатьДокумент().ПолучитьМакет("Макет");
	ТабличныйДокумент = Новый ТабличныйДокумент;
	КомпоновщикНастроек  = Неопределено;
	
	Если КомпоновщикНастроек = Неопределено Тогда
		КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
		КомпоновщикНастроек.ЗагрузитьНастройки(МакетСКД.НастройкиПоУмолчанию);		
	КонецЕсли;
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();  
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(МакетСКД, Настройки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТабличныйДокумент);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ТаблицаБронирования = ТабличныйДокумент;
// Пример вызова из отчета	
//Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
//	
//	СтандартнаяОбработка = Ложь; 
//	ПрограммнаяРаботаССКД.ВывестиСКДВТабличныйДокумент(СхемаКомпоновкиДанных, ДокументРезультат, КомпоновщикНастроек);
//	
//КонецПроцедуры	
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	ОбновитьНаСервере();
КонецПроцедуры


#КонецОбласти


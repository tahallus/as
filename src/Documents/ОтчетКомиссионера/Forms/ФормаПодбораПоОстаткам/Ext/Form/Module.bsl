﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтборОрганизация = Параметры.Организация;
	ОтборКонтрагент = Параметры.Контрагент;
	ОтборДоговор = Параметры.Договор;
	ВалютаДокумента = Параметры.ВалютаДокумента;
	ДатаДокумента = Параметры.ДатаДокумента;
	ЗаказПокупателя = ?(Параметры.Свойство("ЗаказПокупателя"), Параметры.ЗаказПокупателя, Неопределено);
	Проведен = ?(Параметры.Свойство("Проведен"), Параметры.Проведен, Ложь);
	Ссылка = ?(Параметры.Свойство("Ссылка"), Параметры.Ссылка, Неопределено);
	ВидОперации = ?(Параметры.Свойство("ВидОперации"), Параметры.ВидОперации, Неопределено);
	ОтчетКомиссионера = ?(Параметры.Свойство("ОтчетКомиссионера"), Параметры.ОтчетКомиссионера, Неопределено);
	НеПоказыватьЗаказ = ?(Параметры.Свойство("НеПоказыватьЗаказ"), Параметры.НеПоказыватьЗаказ, Ложь);
	
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.ОтчетКомиссионера")
		И ВидОперации = Перечисления.ВидыОперацийОтчетКомиссионера.ОтчетКомиссионераОВозвратах Тогда
		
		Элементы.ПредставлениеПериода.Видимость = Истина;
		Элементы.ТаблицаЗапасовОтчетКомиссионера.Видимость = Истина;
		
		Элементы.ТаблицаЗапасовОстаток.Видимость = Ложь;
		//Элементы.ТаблицаЗапасовЦенаПередачи.Видимость = Ложь;
		//Элементы.ТаблицаЗапасовСуммаРасчетов.Видимость = Ложь;
		
		ОтборПериод.ДатаНачала = НачалоДня(ТекущаяДатаСеанса() - 1209600);
		ОтборПериод.ДатаОкончания = КонецДня(ТекущаяДатаСеанса());
		
		ПредставлениеПериода = РаботаСОтборамиКлиентСервер.ОбновитьПредставлениеПериода(ОтборПериод);
		ЗаполнитьТаблицуЗапасовОВозвратах();
		
	Иначе
		Элементы.ПредставлениеПериода.Видимость = Ложь;
		Элементы.ТаблицаЗапасовОтчетКомиссионера.Видимость = Ложь;
	
		ЗаполнитьТаблицуЗапасов();
	КонецЕсли;
	
	Элементы.ТаблицаЗапасовЗаказПокупателя.Видимость = Не НеПоказыватьЗаказ;
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	ПолучитьПредставлениеПериода(СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаЗапасов

&НаКлиенте
Процедура ТаблицаЗапасовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.ТаблицаЗапасов.ТекущиеДанные <> Неопределено Тогда
		Если Поле.Имя = "ТаблицаЗапасовЗаказПокупателя" Тогда
			ПоказатьЗначение(Неопределено, Элементы.ТаблицаЗапасов.ТекущиеДанные.ЗаказПокупателя);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ТаблицаЗапасовВыбор()

&НаКлиенте
Процедура ТаблицаЗапасовКоличествоПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.ТаблицаЗапасов.ТекущиеДанные;
	СтрокаТабличнойЧасти.Выбран = (СтрокаТабличнойЧасти.Количество <> 0);
	
	СтрокаТабличнойЧасти.СуммаРасчетов = Окр(СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.ЦенаПередачи, 2, РежимОкругления.Окр15как20);
	СтрокаТабличнойЧасти.Сумма = Окр(СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.Цена, 2, РежимОкругления.Окр15как20);
	
КонецПроцедуры // ТаблицаЗапасовКоличествоПриИзменении()

&НаКлиенте
Процедура ТаблицаЗапасовЦенаПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.ТаблицаЗапасов.ТекущиеДанные;
	СтрокаТабличнойЧасти.Сумма = Окр(СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.Цена, 2, РежимОкругления.Окр15как20);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗапасовСуммаПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.ТаблицаЗапасов.ТекущиеДанные;
	
	Если СтрокаТабличнойЧасти.Количество = 0 Тогда
		Возврат
	КонецЕсли;
	
	СтрокаТабличнойЧасти.Цена = Окр(СтрокаТабличнойЧасти.Сумма * СтрокаТабличнойЧасти.Количество, 2, РежимОкругления.Окр15как20);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьВыделенныеСтроки(Команда)
	
	МассивСтрок = Элементы.ТаблицаЗапасов.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		
		СтрокаТабличнойЧасти = ТаблицаЗапасов.НайтиПоИдентификатору(НомерСтроки);
		Если СтрокаТабличнойЧасти <> Неопределено Тогда
			СтрокаТабличнойЧасти.Выбран = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ВыбратьВыделенныеСтроки()

&НаКлиенте
Процедура ИсключитьВыделенныеСтроки(Команда)
	
	МассивСтрок = Элементы.ТаблицаЗапасов.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		
		СтрокаТабличнойЧасти = ТаблицаЗапасов.НайтиПоИдентификатору(НомерСтроки);
		Если СтрокаТабличнойЧасти <> Неопределено Тогда
			СтрокаТабличнойЧасти.Выбран = Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ИсключитьВыделенныеСтроки()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуЗапасов()
	
	Запрос = Новый Запрос;
	
	Если Не Проведен Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗапасыПереданныеОстатки.Номенклатура КАК Номенклатура,
		|	ВЫРАЗИТЬ(ЗапасыПереданныеОстатки.Номенклатура.Наименование КАК СТРОКА(50)) КАК НоменклатураНаименование,
		|	ЗапасыПереданныеОстатки.Характеристика КАК Характеристика,
		|	ЗапасыПереданныеОстатки.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ЗапасыПереданныеОстатки.Партия КАК Партия,
		|	ЗапасыПереданныеОстатки.Заказ КАК ЗаказПокупателя,
		|	СУММА(ЗапасыПереданныеОстатки.КоличествоОстаток) КАК Количество,
		|	СУММА(ЗапасыПереданныеОстатки.КоличествоОстаток) КАК Остаток,
		|	СУММА(ВЫБОР
		|			КОГДА &ВалютаДокумента = &ВалютаРасчетов
		|				ТОГДА ЗапасыПереданныеОстатки.СуммаРасчетовОстаток
		|			ИНАЧЕ ЕСТЬNULL(ЗапасыПереданныеОстатки.СуммаРасчетовОстаток * КурсВалютыРасчетов.Курс * КурсВалютыДокумента.Кратность / (КурсВалютыДокумента.Курс * КурсВалютыРасчетов.Кратность), 0)
		|		КОНЕЦ) КАК СуммаРасчетов
		|ПОМЕСТИТЬ Итог
		|ИЗ
		|	РегистрНакопления.ЗапасыПереданные.Остатки(
		|			,
		|			Организация = &Организация
		|				И Контрагент = &Контрагент
		|				И Договор = &Договор
		|				И ТипПриемаПередачи = ЗНАЧЕНИЕ(Перечисление.ТипыПриемаПередачиТоваров.ПередачаКомиссионеру)
		|				И Заказ = &Заказ) КАК ЗапасыПереданныеОстатки,
		|	РегистрСведений.КурсыВалют.СрезПоследних(&ДатаОбработки, Валюта = &ВалютаРасчетов) КАК КурсВалютыРасчетов,
		|	РегистрСведений.КурсыВалют.СрезПоследних(&ДатаОбработки, Валюта = &ВалютаДокумента) КАК КурсВалютыДокумента
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗапасыПереданныеОстатки.Заказ,
		|	ЗапасыПереданныеОстатки.Номенклатура,
		|	ЗапасыПереданныеОстатки.Характеристика,
		|	ЗапасыПереданныеОстатки.Партия,
		|	ВЫРАЗИТЬ(ЗапасыПереданныеОстатки.Номенклатура.Наименование КАК СТРОКА(50)),
		|	ЗапасыПереданныеОстатки.Номенклатура.ЕдиницаИзмерения
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Итог.Номенклатура КАК Номенклатура,
		|	Итог.НоменклатураНаименование КАК НоменклатураНаименование,
		|	Итог.Характеристика КАК Характеристика,
		|	Итог.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	Итог.Партия КАК Партия,
		|	Итог.ЗаказПокупателя КАК ЗаказПокупателя,
		|	СУММА(Итог.Количество) КАК Количество,
		|	СУММА(Итог.Остаток) КАК Остаток,
		|	СУММА(Итог.СуммаРасчетов) КАК СуммаРасчетов,
		|	СУММА(ВЫБОР
		|			КОГДА ЕСТЬNULL(Итог.Остаток, 0) > 0
		|				ТОГДА ВЫРАЗИТЬ(Итог.СуммаРасчетов / Итог.Остаток КАК ЧИСЛО(10, 2))
		|			ИНАЧЕ Итог.СуммаРасчетов
		|		КОНЕЦ) КАК ЦенаПередачи
		|ИЗ
		|	Итог КАК Итог
		|
		|СГРУППИРОВАТЬ ПО
		|	Итог.Характеристика,
		|	Итог.Партия,
		|	Итог.НоменклатураНаименование,
		|	Итог.ЗаказПокупателя,
		|	Итог.Номенклатура,
		|	Итог.ЕдиницаИзмерения";
		
	Иначе
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.ОтчетКомиссионера")
			Или ТипЗнч(Ссылка) = Тип("ДокументСсылка.ОтчетКомиссионераОСписании") Тогда
			ВидДвижения = ВидДвиженияНакопления.Расход
		Иначе
			ВидДвижения = ВидДвиженияНакопления.Приход;
		КонецЕсли;
		
		Запрос.УстановитьПараметр("ВидДвижения", ВидДвижения);
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗапасыПереданныеОстатки.Номенклатура КАК Номенклатура,
		|	ЗапасыПереданныеОстатки.Характеристика КАК Характеристика,
		|	ЗапасыПереданныеОстатки.Партия КАК Партия,
		|	ЗапасыПереданныеОстатки.Заказ КАК ЗаказПокупателя,
		|	СУММА(ЗапасыПереданныеОстатки.КоличествоОстаток) КАК Количество,
		|	СУММА(ЗапасыПереданныеОстатки.КоличествоОстаток) КАК Остаток,
		|	ЗапасыПереданныеОстатки.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	СУММА(ВЫБОР
		|			КОГДА &ВалютаДокумента = &ВалютаРасчетов
		|				ТОГДА ЗапасыПереданныеОстатки.СуммаРасчетовОстаток
		|			ИНАЧЕ ЕСТЬNULL(ЗапасыПереданныеОстатки.СуммаРасчетовОстаток * КурсВалютыРасчетов.Курс * КурсВалютыДокумента.Кратность / (КурсВалютыДокумента.Курс * КурсВалютыРасчетов.Кратность), 0)
		|		КОНЕЦ) КАК СуммаРасчетов
		|ПОМЕСТИТЬ Итог
		|ИЗ
		|	РегистрНакопления.ЗапасыПереданные.Остатки(
		|			,
		|			Организация = &Организация
		|				И Контрагент = &Контрагент
		|				И Договор = &Договор
		|				И ТипПриемаПередачи = ЗНАЧЕНИЕ(Перечисление.ТипыПриемаПередачиТоваров.ПередачаКомиссионеру)) КАК ЗапасыПереданныеОстатки,
		|	РегистрСведений.КурсыВалют.СрезПоследних(&ДатаОбработки, Валюта = &ВалютаРасчетов) КАК КурсВалютыРасчетов,
		|	РегистрСведений.КурсыВалют.СрезПоследних(&ДатаОбработки, Валюта = &ВалютаДокумента) КАК КурсВалютыДокумента
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗапасыПереданныеОстатки.Заказ,
		|	ЗапасыПереданныеОстатки.Номенклатура,
		|	ЗапасыПереданныеОстатки.Характеристика,
		|	ЗапасыПереданныеОстатки.Партия,
		|	ЗапасыПереданныеОстатки.Номенклатура.ЕдиницаИзмерения
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗапасыПереданные.Номенклатура,
		|	ЗапасыПереданные.Характеристика,
		|	ЗапасыПереданные.Партия,
		|	ЗапасыПереданные.Заказ,
		|	СУММА(ВЫБОР
		|			КОГДА ЗапасыПереданные.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|					И ТИПЗНАЧЕНИЯ(&Ссылка) = ТИП(Документ.ПриходнаяНакладная)
		|				ТОГДА ЗапасыПереданные.Количество * -1
		|			ИНАЧЕ ЗапасыПереданные.Количество
		|		КОНЕЦ),
		|	СУММА(ВЫБОР
		|			КОГДА ЗапасыПереданные.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|					И ТИПЗНАЧЕНИЯ(&Ссылка) = ТИП(Документ.ПриходнаяНакладная)
		|				ТОГДА ЗапасыПереданные.Количество * -1
		|			ИНАЧЕ ЗапасыПереданные.Количество
		|		КОНЕЦ),
		|	ЗапасыПереданные.Номенклатура.ЕдиницаИзмерения,
		|	СУММА(ВЫБОР
		|			КОГДА ЗапасыПереданные.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|					И НЕ ТИПЗНАЧЕНИЯ(&Ссылка) = ТИП(Документ.ОтчетКомиссионера)
		|				ТОГДА ВЫБОР
		|						КОГДА &ВалютаДокумента = &ВалютаРасчетов
		|							ТОГДА ЗапасыПереданные.СуммаРасчетов * -1
		|						ИНАЧЕ ЕСТЬNULL(ЗапасыПереданные.СуммаРасчетов * -1 * КурсВалютыРасчетов.Курс * КурсВалютыДокумента.Кратность / (КурсВалютыДокумента.Курс * КурсВалютыРасчетов.Кратность), 0)
		|					КОНЕЦ
		|			ИНАЧЕ ВЫБОР
		|					КОГДА &ВалютаДокумента = &ВалютаРасчетов
		|						ТОГДА ЗапасыПереданные.СуммаРасчетов
		|					ИНАЧЕ ЕСТЬNULL(ЗапасыПереданные.СуммаРасчетов * КурсВалютыРасчетов.Курс * КурсВалютыДокумента.Кратность / (КурсВалютыДокумента.Курс * КурсВалютыРасчетов.Кратность), 0)
		|				КОНЕЦ
		|		КОНЕЦ)
		|ИЗ
		|	РегистрНакопления.ЗапасыПереданные КАК ЗапасыПереданные,
		|	РегистрСведений.КурсыВалют.СрезПоследних(, Валюта = &ВалютаДокумента) КАК КурсВалютыДокумента,
		|	РегистрСведений.КурсыВалют.СрезПоследних(, Валюта = &ВалютаРасчетов) КАК КурсВалютыРасчетов
		|ГДЕ
		|	ЗапасыПереданные.Регистратор = &Ссылка
		|	И ЗапасыПереданные.ТипПриемаПередачи = ЗНАЧЕНИЕ(Перечисление.ТипыПриемаПередачиТоваров.ПередачаКомиссионеру)
		|	И ЗапасыПереданные.ВидДвижения = &ВидДвижения
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗапасыПереданные.Номенклатура,
		|	ЗапасыПереданные.Характеристика,
		|	ЗапасыПереданные.Партия,
		|	ЗапасыПереданные.Заказ,
		|	ЗапасыПереданные.Номенклатура.ЕдиницаИзмерения
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Итог.Номенклатура КАК Номенклатура,
		|	Итог.Характеристика КАК Характеристика,
		|	Итог.Партия КАК Партия,
		|	Итог.ЗаказПокупателя КАК ЗаказПокупателя,
		|	СУММА(Итог.Количество) КАК Количество,
		|	СУММА(Итог.Остаток) КАК Остаток,
		|	Итог.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	СУММА(Итог.СуммаРасчетов) КАК СуммаРасчетов,
		|	ВЫБОР
		|		КОГДА СУММА(Итог.Остаток) > 0
		|			ТОГДА ВЫРАЗИТЬ(СУММА(Итог.СуммаРасчетов) / СУММА(Итог.Остаток) КАК ЧИСЛО(10, 2))
		|		ИНАЧЕ СУММА(Итог.СуммаРасчетов)
		|	КОНЕЦ КАК ЦенаПередачи
		|ИЗ
		|	Итог КАК Итог
		|
		|СГРУППИРОВАТЬ ПО
		|	Итог.Номенклатура,
		|	Итог.Партия,
		|	Итог.ЗаказПокупателя,
		|	Итог.Характеристика,
		|	Итог.ЕдиницаИзмерения";
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Организация", ОтборОрганизация);
	Запрос.УстановитьПараметр("Контрагент", ОтборКонтрагент);
	Запрос.УстановитьПараметр("Договор", ОтборДоговор);
	Запрос.УстановитьПараметр("ВалютаРасчетов", ОтборДоговор.ВалютаРасчетов);
	Запрос.УстановитьПараметр("ВалютаДокумента", ВалютаДокумента);
	Запрос.УстановитьПараметр("ДатаОбработки", ДатаДокумента);
	
	Если ЗначениеЗаполнено(ЗаказПокупателя) Тогда
		Запрос.УстановитьПараметр("Заказ", ЗаказПокупателя);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Заказ = &Заказ", "");
	КонецЕсли;
	
	ТаблицаЗапасов.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры // ЗаполнитьТаблицуЗапасов()

&НаСервере
Процедура ЗаполнитьТаблицуЗапасовОВозвратах()
	
	ТаблицаЗапасов.Очистить();
	
	Запрос = Новый Запрос;
	
	Если Не Проведен Тогда
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПродажиОбороты.Номенклатура КАК Номенклатура,
		|	ПродажиОбороты.КоличествоОборот КАК Количество,
		|	ПродажиОбороты.СуммаОборот КАК Сумма,
		|	ПродажиОбороты.Документ КАК ОтчетКомиссионера,
		|	ПродажиОбороты.ЗаказПокупателя КАК ЗаказПокупателя,
		|	ВЫРАЗИТЬ(ПродажиОбороты.СуммаОборот / ПродажиОбороты.КоличествоОборот КАК ЧИСЛО(15, 2)) КАК Цена,
		|	ПродажиОбороты.Характеристика КАК Характеристика
		|ПОМЕСТИТЬ Продажи
		|ИЗ
		|	РегистрНакопления.Продажи.Обороты(
		|			&ДатаНачала,
		|			&ДатаОкончания,
		|			,
		|			Организация = &Организация
		|				И Контрагент = &Контрагент
		|				И ТИПЗНАЧЕНИЯ(Документ) = ТИП(Документ.ОтчетКомиссионера)
		|				И Документ.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийОтчетКомиссионера.ОтчетКомиссионера)
		|				И Документ = &ОтчетКомиссионера) КАК ПродажиОбороты
		|ГДЕ
		|	НЕ ПродажиОбороты.КоличествоОборот = 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗапасыПереданные.Номенклатура КАК Номенклатура,
		|	ЗапасыПереданные.Характеристика КАК Характеристика,
		|	ВЫБОР
		|		КОГДА ЗапасыПереданные.Заказ = НЕОПРЕДЕЛЕНО
		|			ТОГДА ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)
		|		ИНАЧЕ ЗапасыПереданные.Заказ
		|	КОНЕЦ КАК Заказ,
		|	СУММА(ВЫБОР
		|			КОГДА ЗапасыПереданные.Количество > 0
		|				ТОГДА ВЫРАЗИТЬ(ЗапасыПереданные.СуммаРасчетов / ЗапасыПереданные.Количество КАК ЧИСЛО(15, 2))
		|			ИНАЧЕ ЗапасыПереданные.СуммаРасчетов
		|		КОНЕЦ) КАК ЦенаПередачи,
		|	ЗапасыПереданные.СуммаРасчетов КАК СуммаПередачи
		|ПОМЕСТИТЬ ЗапасыПереданные
		|ИЗ
		|	РегистрНакопления.ЗапасыПереданные КАК ЗапасыПереданные
		|ГДЕ
		|	ЗапасыПереданные.Организация = &Организация
		|	И ЗапасыПереданные.Контрагент = &Контрагент
		|	И ТИПЗНАЧЕНИЯ(ЗапасыПереданные.Регистратор) = ТИП(Документ.ОтчетКомиссионера)
		|	И ЗапасыПереданные.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|	И ЗапасыПереданные.Регистратор.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийОтчетКомиссионера.ОтчетКомиссионера)
		|	И ЗапасыПереданные.Регистратор = &ОтчетКомиссионера
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗапасыПереданные.Номенклатура,
		|	ЗапасыПереданные.Характеристика,
		|	ЗапасыПереданные.СуммаРасчетов,
		|	ВЫБОР
		|		КОГДА ЗапасыПереданные.Заказ = НЕОПРЕДЕЛЕНО
		|			ТОГДА ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)
		|		ИНАЧЕ ЗапасыПереданные.Заказ
		|	КОНЕЦ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Продажи.Номенклатура КАК Номенклатура,
		|	Продажи.Количество КАК Количество,
		|	Продажи.Сумма КАК Сумма,
		|	Продажи.ОтчетКомиссионера КАК ОтчетКомиссионера,
		|	Продажи.ЗаказПокупателя КАК ЗаказПокупателя,
		|	Продажи.Цена КАК Цена,
		|	Продажи.Характеристика КАК Характеристика,
		|	ЗапасыПереданные.ЦенаПередачи КАК ЦенаПередачи,
		|	ЗапасыПереданные.СуммаПередачи КАК СуммаРасчетов
		|ИЗ
		|	Продажи КАК Продажи
		|		ЛЕВОЕ СОЕДИНЕНИЕ ЗапасыПереданные КАК ЗапасыПереданные
		|		ПО Продажи.Номенклатура = ЗапасыПереданные.Номенклатура
		|			И Продажи.ЗаказПокупателя = ЗапасыПереданные.Заказ
		|			И Продажи.Характеристика = ЗапасыПереданные.Характеристика";
		
	Иначе
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПродажиОбороты.Номенклатура КАК Номенклатура,
		|	ПродажиОбороты.Документ КАК ОтчетКомиссионера,
		|	ПродажиОбороты.ЗаказПокупателя КАК ЗаказПокупателя,
		|	СУММА(ПродажиОбороты.КоличествоОборот) КАК Количество,
		|	СУММА(ПродажиОбороты.СуммаОборот) КАК Сумма,
		|	ПродажиОбороты.Характеристика КАК Характеристика
		|ПОМЕСТИТЬ ВтОбщая
		|ИЗ
		|	РегистрНакопления.Продажи.Обороты(
		|			&ДатаНачала,
		|			&ДатаОкончания,
		|			,
		|			Организация = &Организация
		|				И Контрагент = &Контрагент
		|				И ТИПЗНАЧЕНИЯ(Документ) = ТИП(Документ.ОтчетКомиссионера)
		|				И Документ.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийОтчетКомиссионера.ОтчетКомиссионера)
		|				И Документ = &ОтчетКомиссионера) КАК ПродажиОбороты
		|ГДЕ
		|	НЕ ПродажиОбороты.КоличествоОборот = 0
		|
		|СГРУППИРОВАТЬ ПО
		|	ПродажиОбороты.Номенклатура,
		|	ПродажиОбороты.ЗаказПокупателя,
		|	ПродажиОбороты.Документ,
		|	ПродажиОбороты.Характеристика
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Продажи.Номенклатура,
		|	Продажи.Документ,
		|	Продажи.ЗаказПокупателя,
		|	СУММА(Продажи.Количество * -1),
		|	СУММА(Продажи.Сумма * -1),
		|	Продажи.Характеристика
		|ИЗ
		|	РегистрНакопления.Продажи КАК Продажи
		|ГДЕ
		|	Продажи.Регистратор = &Ссылка
		|	И Продажи.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И НЕ Продажи.Количество = 0
		|
		|СГРУППИРОВАТЬ ПО
		|	Продажи.Номенклатура,
		|	Продажи.Документ,
		|	Продажи.ЗаказПокупателя,
		|	Продажи.Характеристика
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Итог.Номенклатура КАК Номенклатура,
		|	Итог.ОтчетКомиссионера КАК ОтчетКомиссионера,
		|	Итог.ЗаказПокупателя КАК ЗаказПокупателя,
		|	СУММА(Итог.Количество) КАК Количество,
		|	СУММА(Итог.Сумма) КАК Сумма,
		|	ВЫРАЗИТЬ(Итог.Сумма / Итог.Количество КАК ЧИСЛО(15, 2)) КАК Цена,
		|	Итог.Характеристика КАК Характеристика
		|ПОМЕСТИТЬ Итог
		|ИЗ
		|	ВтОбщая КАК Итог
		|
		|СГРУППИРОВАТЬ ПО
		|	Итог.ЗаказПокупателя,
		|	Итог.Номенклатура,
		|	Итог.ОтчетКомиссионера,
		|	ВЫРАЗИТЬ(Итог.Сумма / Итог.Количество КАК ЧИСЛО(15, 2)),
		|	Итог.Характеристика
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Итог.Номенклатура КАК Номенклатура,
		|	Итог.ОтчетКомиссионера КАК ОтчетКомиссионера,
		|	Итог.ЗаказПокупателя КАК ЗаказПокупателя,
		|	Итог.Количество КАК Количество,
		|	Итог.Сумма КАК Сумма,
		|	Итог.Цена КАК Цена,
		|	Итог.Характеристика КАК Характеристика,
		|	0 КАК ЦенаПередачи,
		|	0 КАК СуммаРасчетов
		|ИЗ
		|	Итог КАК Итог
		|ГДЕ
		|	НЕ Итог.Количество = 0";
		
	КонецЕсли;
	
	
	Запрос.УстановитьПараметр("Организация", ОтборОрганизация);
	Запрос.УстановитьПараметр("Контрагент", ОтборКонтрагент);
	Запрос.УстановитьПараметр("ДатаНачала", ОтборПериод.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ?(ЗначениеЗаполнено(ОтборПериод.ДатаОкончания), ОтборПериод.ДатаОкончания, ТекущаяДатаСеанса()));
	
	Если ЗначениеЗаполнено(ОтчетКомиссионера) Тогда
		Запрос.УстановитьПараметр("ОтчетКомиссионера", ОтчетКомиссионера);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Документ = &ОтчетКомиссионера", "");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И ЗапасыПереданные.Регистратор = &ОтчетКомиссионера", "");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Если Проведен И ЗначениеЗаполнено(ОтчетКомиссионера) Тогда
		
		ПараметрыПоиска = Новый Структура("Номенклатура, Характеристика, ЗаказПокупателя");
		
		Для Каждого СтрокаРезультата Из РезультатЗапроса Цикл
			
			ЗаполнитьЗначенияСвойств(ПараметрыПоиска, СтрокаРезультата);
			
			НайденныеСтроки = ОтчетКомиссионера.Запасы.НайтиСтроки(ПараметрыПоиска);
			
			Если НайденныеСтроки.Количество() Тогда
				СтрокаРезультата.ЦенаПередачи = НайденныеСтроки[0].ЦенаПередачи;
				СтрокаРезультата.СуммаРасчетов = Окр(СтрокаРезультата.ЦенаПередачи*СтрокаРезультата.Количество,2, РежимОкругления.Окр15как20);
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	ТаблицаЗапасов.Загрузить(РезультатЗапроса);
	
КонецПроцедуры // ЗаполнитьТаблицуЗапасов()

&НаСервере
Функция ПоместитьЗапасыВХранилище()
	
	Запасы = ТаблицаЗапасов.Выгрузить(, "Выбран, Номенклатура, Характеристика, Партия, ЗаказПокупателя, Количество, Остаток, СуммаРасчетов, ЕдиницаИзмерения, ОтчетКомиссионера, Цена, Сумма");
	
	МассивУдаляемыхСтрок = Новый Массив;
	Для Каждого СтрокаЗапасы Из Запасы Цикл
		
		Если Не СтрокаЗапасы.Выбран Тогда
			МассивУдаляемыхСтрок.Добавить(СтрокаЗапасы);
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого НомерСтроки Из МассивУдаляемыхСтрок Цикл
		Запасы.Удалить(НомерСтроки);
	КонецЦикла;
	
	АдресЗапасовВХранилище = ПоместитьВоВременноеХранилище(Запасы, УникальныйИдентификатор);
	
	Возврат АдресЗапасовВХранилище;
	
КонецФункции // ПоместитьЗапасыВХранилище()

&НаКлиенте
Процедура ВыбратьСтрокиВыполнить()

	Для Каждого СтрокаТабличнойЧасти Из ТаблицаЗапасов Цикл
		
		СтрокаТабличнойЧасти.Выбран = Истина;
		
	КонецЦикла;
	
КонецПроцедуры // ВыбратьСтрокиВыполнить()

&НаКлиенте
Процедура ИсключитьСтрокиВыполнить()

	Для Каждого СтрокаТабличнойЧасти Из ТаблицаЗапасов Цикл
		
		СтрокаТабличнойЧасти.Выбран = Ложь
		
	КонецЦикла;
	
КонецПроцедуры // ИсключитьСтрокиВыполнить()

&НаКлиенте
Процедура ПеренестиВДокументВыполнить()
	
	АдресЗапасовВХранилище = ПоместитьЗапасыВХранилище();
	ОповеститьОВыборе(АдресЗапасовВХранилище);
	
КонецПроцедуры // ПеренестиВДокументВыполнить()

&НаКлиенте
Процедура ПолучитьПредставлениеПериода(СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ПредставлениеПериодаНажатиеЗавершение", ЭтотОбъект, Параметры);
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода;
	Диалог.Период = ОтборПериод;
	Диалог.Показать(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатиеЗавершение(НовыйПериод, Параметры) Экспорт
	ОтборПериод = НовыйПериод;
	ПредставлениеПериода = РаботаСОтборамиКлиентСервер.ОбновитьПредставлениеПериода(НовыйПериод);
	ЗаполнитьТаблицуЗапасовОВозвратах();
КонецПроцедуры

#КонецОбласти


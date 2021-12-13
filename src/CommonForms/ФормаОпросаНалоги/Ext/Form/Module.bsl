﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаЗаголовка;
	
	ЗаполнитьСписокРегионов();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДекорацияЗаголовокОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "Отказаться" Тогда
		
		ЗавершитьРаботу();
		
	Иначе
		
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаОпрос;
		
	КонецЕсли;
	
КонецПроцедуры

// отваливаем константу
//
&НаСервере
Процедура ОтказатьсяОтОпроса()
	
	УстановитьПривилегированныйРежим(Истина);
	Константы.ФункциональнаяОпцияОпросНалоги.Установить(Ложь);
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокРегионов()
	
	СписокВыбора = Элементы.РегионДеятельности.СписокВыбора;
	
	СписокВыбора.Добавить("1", НСтр("ru = '01 - Республика Адыгея'"));
	СписокВыбора.Добавить("2", НСтр("ru = '02 - Республика Башкортостан'"));
	СписокВыбора.Добавить("3", НСтр("ru = '03 - Республика Бурятия'"));
	СписокВыбора.Добавить("4", НСтр("ru = '04 - Республика Алтай'"));
	СписокВыбора.Добавить("5", НСтр("ru = '05 - Республика Дагестан'"));
	СписокВыбора.Добавить("6", НСтр("ru = '06 - Республика Ингушетия'"));
	СписокВыбора.Добавить("7", НСтр("ru = '07 - Кабардино-Балкарская Республика'"));
	СписокВыбора.Добавить("8", НСтр("ru = '08 - Республика Калмыкия'"));
	СписокВыбора.Добавить("9", НСтр("ru = '09 - Карачаево-Черкесская Республика'"));
	СписокВыбора.Добавить("10", НСтр("ru = '10 - Республика Карелия'"));
	СписокВыбора.Добавить("11", НСтр("ru = '11 - Республика Коми'"));
	СписокВыбора.Добавить("12", НСтр("ru = '12 - Республика Марий Эл'"));
	СписокВыбора.Добавить("13", НСтр("ru = '13 - Республика Мордовия'"));
	СписокВыбора.Добавить("14", НСтр("ru = '14 - Республика Саха (Якутия)'"));
	СписокВыбора.Добавить("15", НСтр("ru = '15 - Республика Северная Осетия - Алания'"));
	СписокВыбора.Добавить("16", НСтр("ru = '16 - Республика Татарстан'"));
	СписокВыбора.Добавить("17", НСтр("ru = '17 - Республика Тыва'"));
	СписокВыбора.Добавить("18", НСтр("ru = '18 - Удмуртская Республика'"));
	СписокВыбора.Добавить("19", НСтр("ru = '19 - Республика Хакасия'"));
	СписокВыбора.Добавить("21", НСтр("ru = '21 - Чувашская Республика'"));
	СписокВыбора.Добавить("22", НСтр("ru = '22 - Алтайский край'"));
	СписокВыбора.Добавить("23", НСтр("ru = '23 - Краснодарский край'"));
	СписокВыбора.Добавить("24", НСтр("ru = '24 - Красноярский край'"));
	СписокВыбора.Добавить("25", НСтр("ru = '25 - Приморский край'"));
	СписокВыбора.Добавить("26", НСтр("ru = '26 - Ставропольский край'"));
	СписокВыбора.Добавить("27", НСтр("ru = '27 - Хабаровский край'"));
	СписокВыбора.Добавить("28", НСтр("ru = '28 - Амурская область'"));
	СписокВыбора.Добавить("29", НСтр("ru = '29 - Архангельская область'"));
	СписокВыбора.Добавить("30", НСтр("ru = '30 - Астраханская область'"));
	СписокВыбора.Добавить("31", НСтр("ru = '31 - Белгородская область'"));
	СписокВыбора.Добавить("32", НСтр("ru = '32 - Брянская область'"));
	СписокВыбора.Добавить("33", НСтр("ru = '33 - Владимирская область'"));
	СписокВыбора.Добавить("34", НСтр("ru = '34 - Волгоградская область'"));
	СписокВыбора.Добавить("35", НСтр("ru = '35 - Вологодская область'"));
	СписокВыбора.Добавить("36", НСтр("ru = '36 - Воронежская область'"));
	СписокВыбора.Добавить("37", НСтр("ru = '37 - Ивановская область'"));
	СписокВыбора.Добавить("38", НСтр("ru = '38 - Иркутская область'"));
	СписокВыбора.Добавить("39", НСтр("ru = '39 - Калининградская область'"));
	СписокВыбора.Добавить("40", НСтр("ru = '40 - Калужская область'"));
	СписокВыбора.Добавить("41", НСтр("ru = '41 - Камчатский край'"));
	СписокВыбора.Добавить("42", НСтр("ru = '42 - Кемеровская область'"));
	СписокВыбора.Добавить("43", НСтр("ru = '43 - Кировская область'"));
	СписокВыбора.Добавить("44", НСтр("ru = '44 - Костромская область'"));
	СписокВыбора.Добавить("45", НСтр("ru = '45 - Курганская область'"));
	СписокВыбора.Добавить("46", НСтр("ru = '46 - Курская область'"));
	СписокВыбора.Добавить("47", НСтр("ru = '47 - Ленинградская область'"));
	СписокВыбора.Добавить("48", НСтр("ru = '48 - Липецкая область'"));
	СписокВыбора.Добавить("49", НСтр("ru = '49 - Магаданская область'"));
	СписокВыбора.Добавить("50", НСтр("ru = '50 - Московская область'"));
	СписокВыбора.Добавить("51", НСтр("ru = '51 - Мурманская область'"));
	СписокВыбора.Добавить("52", НСтр("ru = '52 - Нижегородская область'"));
	СписокВыбора.Добавить("53", НСтр("ru = '53 - Новгородская область'"));
	СписокВыбора.Добавить("54", НСтр("ru = '54 - Новосибирская область'"));
	СписокВыбора.Добавить("55", НСтр("ru = '55 - Омская область'"));
	СписокВыбора.Добавить("56", НСтр("ru = '56 - Оренбургская область'"));
	СписокВыбора.Добавить("57", НСтр("ru = '57 - Орловская область'"));
	СписокВыбора.Добавить("58", НСтр("ru = '58 - Пензенская область'"));
	СписокВыбора.Добавить("59", НСтр("ru = '59 - Пермский край'"));
	СписокВыбора.Добавить("60", НСтр("ru = '60 - Псковская область'"));
	СписокВыбора.Добавить("61", НСтр("ru = '61 - Ростовская область'"));
	СписокВыбора.Добавить("62", НСтр("ru = '62 - Рязанская область'"));
	СписокВыбора.Добавить("63", НСтр("ru = '63 - Самарская область'"));
	СписокВыбора.Добавить("64", НСтр("ru = '64 - Саратовская область'"));
	СписокВыбора.Добавить("65", НСтр("ru = '65 - Сахалинская область'"));
	СписокВыбора.Добавить("66", НСтр("ru = '66 - Свердловская область'"));
	СписокВыбора.Добавить("67", НСтр("ru = '67 - Смоленская область'"));
	СписокВыбора.Добавить("68", НСтр("ru = '68 - Тамбовская область'"));
	СписокВыбора.Добавить("69", НСтр("ru = '69 - Тверская область'"));
	СписокВыбора.Добавить("70", НСтр("ru = '70 - Томская область'"));
	СписокВыбора.Добавить("71", НСтр("ru = '71 - Тульская область'"));
	СписокВыбора.Добавить("72", НСтр("ru = '72 - Тюменская область'"));
	СписокВыбора.Добавить("73", НСтр("ru = '73 - Ульяновская область'"));
	СписокВыбора.Добавить("74", НСтр("ru = '74 - Челябинская область'"));
	СписокВыбора.Добавить("75", НСтр("ru = '75 - Забайкальский край'"));
	СписокВыбора.Добавить("76", НСтр("ru = '76 - Ярославская область'"));
	СписокВыбора.Добавить("77", НСтр("ru = '77 - город Москва'"));
	СписокВыбора.Добавить("78", НСтр("ru = '78 - город Санкт-Петербург'"));
	СписокВыбора.Добавить("79", НСтр("ru = '79 - Еврейская автономная область'"));
	СписокВыбора.Добавить("82", НСтр("ru = '82 - Республика Крым'"));
	СписокВыбора.Добавить("83", НСтр("ru = '83 - Ненецкий автономный округ'"));
	СписокВыбора.Добавить("86", НСтр("ru = '86 - Ханты-Мансийский автономный округ - Югра'"));
	СписокВыбора.Добавить("87", НСтр("ru = '87 - Чукотский автономный округ'"));
	СписокВыбора.Добавить("89", НСтр("ru = '89 - Ямало-Ненецкий автономный округ'"));
	СписокВыбора.Добавить("92", НСтр("ru = '92 - город Севастополь'"));
	СписокВыбора.Добавить("95", НСтр("ru = '95 - Чеченская Республика'"));
	
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	
	ТекстПисьма = СформироватьТекст();
	
	Получатель = Новый СписокЗначений;
	Получатель.Добавить("sbm@1c.ru", "Фирма 1С");
	
	ПараметрыПисьма = Новый Структура;
	ПараметрыПисьма.Вставить("Получатель", Получатель);
	ПараметрыПисьма.Вставить("Тема", "Опрос по налогам");
	ПараметрыПисьма.Вставить("Текст", ТекстПисьма);
	
	ОП = Новый ОписаниеОповещения("ПослеОтправкиПисьма", ЭтотОбъект);
	РаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыПисьма, ОП);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтправкиПисьма(Результат, Параметры) Экспорт
	Если Результат = Истина Тогда
		ЗавершитьРаботу();
	КонецЕсли;
КонецПроцедуры

Функция СформироватьТекст()
	
	ТекстПисьма = 
		"Тип организации: " + ТипОрганизации + Символы.ПС +
		"Продолжительность деятельности: " + ПродолжительностьДеятельности + Символы.ПС +
		"Регион деятельности: " + РегионДеятельности + Символы.ПС +
		"Применяется ОСНО: " + РежимНалогообложенияОСНО + Символы.ПС +
		"Применяется УСН: " + РежимНалогообложенияУСН + Символы.ПС +
		"Применяется ЕНВД: " + РежимНалогообложенияЕНВД + Символы.ПС +
		"Применяется патент: " + РежимНалогообложенияПатент + Символы.ПС +
		"Применяется торговый сбор: " + РежимНалогообложенияТорговыйСбор + Символы.ПС +
		"Применяется НДС: " + РежимНалогообложенияНдс + Символы.ПС +
		"Имеются сотрудники: " + ИмеютсяСотрудники + Символы.ПС +
		"Кто готовит: " + КтоГотовит + Символы.ПС +
		"Способ сдачи: " + СпособСдачи + Символы.ПС +
		"Смотрели в унф раздел: " + РазделПросмотрен + Символы.ПС +
		"Востребован: " +Востребован + Символы.ПС +
		"Пожелания: " + Пожелания;
	
	Возврат ТекстПисьма;
	
КонецФункции

&НаКлиенте
Процедура ЗавершитьРаботу()
	
	ОтказатьсяОтОпроса();
	ОбновитьИнтерфейс();
	Закрыть(Ложь);
	
КонецПроцедуры

#КонецОбласти

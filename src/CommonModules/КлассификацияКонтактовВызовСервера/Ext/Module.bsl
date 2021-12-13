﻿
#Область СлужебныеПроцедурыИФункции

// Функция создания тега
//
// Параметры:
//  НаименованиеТега - строка - имя тега
// Возвращаемое значение:
//  СправочникСсылка.Теги - ссылка на созданный элемент
Функция СоздатьТег(НаименованиеТега) Экспорт
	
	Возврат КлассификацияКонтактов.СоздатьТег(НаименованиеТега);
	
КонецФункции

// Функция получения контрагентов по тегам
//
// Параметры:
//  Теги - массив - СправочникСсылка.Теги - теги по которым необходимо получить контрагентов
// Возвращаемое значение:
//  массив - СправочникСсылка.Контрагенты - контрагенты содержащие все заданные теги.
Функция КонтрагентыПоТегам(Теги, ТипКонтактов = Неопределено) Экспорт
	
	Контрагенты = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Контрагенты.Ссылка КАК Контрагент,
		|	Контрагенты.Теги.(
		|		Тег
		|	)
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты";
	
	Если ТипКонтактов <> Неопределено Тогда
		СправочникКонтактов = Метаданные.НайтиПоТипу(ТипКонтактов);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Справочник.Контрагенты", СправочникКонтактов.ПолноеИмя());
	КонецЕсли;
	
	ВыборкаКонтрагенты = Запрос.Выполнить().Выбрать();
	Отбор = Новый Структура("Тег");
	
	Пока ВыборкаКонтрагенты.Следующий() Цикл
		
		ВыборкаТеги = ВыборкаКонтрагенты.Теги.Выбрать();
		ЕстьВсеТеги = Истина;
		
		Для Каждого Тег Из Теги Цикл
			Отбор.Тег = Тег;
			ВыборкаТеги.Сбросить();
			Если НЕ ВыборкаТеги.НайтиСледующий(Отбор) Тогда
				ЕстьВсеТеги = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ЕстьВсеТеги Тогда
			Контрагенты.Добавить(ВыборкаКонтрагенты.Контрагент);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Контрагенты;
	
КонецФункции

// Функция получения контрагентов по сегментам
//
// Параметры:
//  Сегменты - массив - СправочникСсылка.Сегменты - сегменты для которых необходимо получить контрагентов
// Возвращаемое значение:
//  массив - СправочникСсылка.Контрагенты - контрагенты сегментов.
Функция КонтрагентыСегментов(Сегменты) Экспорт
	
	Контрагенты = Новый Массив;
	
	Для Каждого Сегмент Из Сегменты Цикл
		
		СоставСегмента = Справочники.СегментыКонтрагентов.ПолучитьСоставСегмента(Сегмент);
		
		Если Контрагенты.Количество() = 0 Тогда
			Контрагенты = СоставСегмента;
		Иначе
			Контрагенты = ОбщегоНазначенияУНФКлиентСервер.ПолучитьСовпадающиеЭлементыМассивов(Контрагенты, СоставСегмента);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Контрагенты;
	
КонецФункции

// Функция получения контрагентов по тегам и сегментам. Отборы складываются по логическому "И",
// т.е. отсекаются контрагенты, не удовлетворяющие хотя бы одному заданному отбору.
//
// Параметры:
//  Теги - массив - СправочникСсылка.Теги - теги по которым необходимо получить контрагентов
//  Сегменты - массив - СправочникСсылка.Сегменты - сегменты для которых необходимо получить контрагентов
// Возвращаемое значение:
//  массив - СправочникСсылка.Контрагенты - контрагенты по тегам и сегментам.
Функция КонтрагентыПоТегамИСегментам(Теги, Сегменты, ТипКонтактов = Неопределено) Экспорт
	
	Контрагенты = Новый Массив;
	
	Если Теги.Количество() > 0 И Сегменты.Количество() > 0 Тогда
		Контрагенты = ОбщегоНазначенияУНФКлиентСервер.ПолучитьСовпадающиеЭлементыМассивов(КонтрагентыПоТегам(Теги, ТипКонтактов), КонтрагентыСегментов(Сегменты));
	ИначеЕсли Теги.Количество() > 0 Тогда
		Контрагенты = КонтрагентыПоТегам(Теги, ТипКонтактов);
	ИначеЕсли Сегменты.Количество() > 0 Тогда
		Контрагенты = КонтрагентыСегментов(Сегменты);
	КонецЕсли;
	
	Возврат Контрагенты;
	
КонецФункции

Функция УстановитьТег(ВладельцыТегов, Тег) Экспорт
	
	Возврат КлассификацияКонтактов.УстановитьТег(ВладельцыТегов, Тег);
	
КонецФункции

#КонецОбласти

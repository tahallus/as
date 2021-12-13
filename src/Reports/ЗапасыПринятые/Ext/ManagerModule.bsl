﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Вызывается при работе в модели сервиса для получения сведений о предопределенных вариантах отчета.
//
// Возвращаемое значение:
//  Массив из Структура:
//    * Имя           - Строка - имя варианта отчета; например, "Основной";
//    * Представление - Строка - имя варианта отчета; например, НСтр("ru = 'Динамика изменений файлов'").
//
Функция ВариантыНастроек() Экспорт 
	
	Результат = Новый Массив;
	Результат.Добавить(Новый Структура("Имя, Представление", "Ведомость", 
		НСтр("ru = 'Товары, принятые на комиссию'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "Остатки", 
		НСтр("ru = 'Остатки запасов принятых'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "ЗапасыВПереработке", 
		НСтр("ru = 'Запасы, принятые в переработку'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "ЗапасыНаОтветхранении", 
		НСтр("ru = 'Запасы, принятые на ответхранение'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "АгентскиеУслуги", 
		НСтр("ru = 'Агентские услуги'")));
	Возврат Результат;
	
КонецФункции

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ЗапасыПринятые, "Ведомость");
	Вариант.Описание = НСтр("ru = 'Отчет позволяет получить информацию о товарах, принятых на комиссию за указанный период времени.'");
	Вариант.Размещение.Удалить(Метаданные.Подсистемы.Производство.Подсистемы.Переработка);
	Вариант.ФункциональныеОпции.Добавить("ПриемТоваровНаКомиссию");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ЗапасыПринятые, "ЗапасыВПереработке");
	Вариант.Описание = НСтр("ru = 'Отчет позволяет получить информацию о запасах, принятых в переработку за указанный период времени.'");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Закупки.Подсистемы.Переработка, "Важный");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Склад.Подсистемы.Склад, "Важный");
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Производство.Подсистемы.Переработка, "Важный");
	Вариант.ФункциональныеОпции.Добавить("ПереработкаДавальческогоСырья");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ЗапасыПринятые, "ЗапасыНаОтветхранении");
	Вариант.Описание = НСтр("ru = 'Отчет позволяет получить информацию о запасах, принятых на ответственное хранение за указанный период времени.'");
	Вариант.Размещение.Удалить(Метаданные.Подсистемы.Производство.Подсистемы.Переработка);
	Вариант.ФункциональныеОпции.Добавить("ПриемЗапасовНаОтветхранение");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ЗапасыПринятые, "Остатки");
	Вариант.Описание = НСтр("ru = 'Отчет позволяет получить информацию об остатках запасов, принятых на комиссию, в переработку и на ответственное хранение.'");
	Вариант.ВидимостьПоУмолчанию = Ложь;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ЗапасыПринятые, "АгентскиеУслуги");
	Вариант.Описание = НСтр("ru = 'Отчет позволяет получить информацию о количестве реализованных агентских услуг.'");
	Вариант.ФункциональныеОпции.Добавить("АгентскиеУслуги");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли
﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ВЫБОР КОГДА ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКредитаИЗайма.КредитПолученный) ТОГДА ЗначениеРазрешено(Контрагент)
	|	ИНАЧЕ ИСТИНА КОНЕЦ И ЗначениеРазрешено(ВидДоговора)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

// Функция возвращает список имен «ключевых» реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("ВалютаРасчетов");
	
	Возврат Результат;
	
КонецФункции // ПолучитьБлокируемыеРеквизитыОбъекта()

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
Процедура ИнициализироватьДанныеДокумента(ДокументСсылкаЧекККМ, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДоговорКредитаИЗаймаГрафикПлатежейИНачислений.Ссылка КАК ДоговорКредитаЗайма,
	|	ДоговорКредитаИЗаймаГрафикПлатежейИНачислений.Период,
	|	ДоговорКредитаИЗаймаГрафикПлатежейИНачислений.СуммаОсновногоДолга,
	|	ДоговорКредитаИЗаймаГрафикПлатежейИНачислений.СуммаПроцентов,
	|	ДоговорКредитаИЗаймаГрафикПлатежейИНачислений.СуммаКомиссии
	|ИЗ
	|	Документ.ДоговорКредитаИЗайма.ГрафикПлатежейИНачислений КАК ДоговорКредитаИЗаймаГрафикПлатежейИНачислений
	|ГДЕ
	|	ДоговорКредитаИЗаймаГрафикПлатежейИНачислений.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаЧекККМ);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаГрафикПогашенияКредитовИЗаймов", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

// Получает договор контрагента по умолчанию с учетом условий отбора. Возвращается основной договор или единственный или
// пустую ссылку.
//
// Параметры
//  Контрагент - <СправочникСсылка.Контрагенты> 
//							Контрагент, договор которого нужно получить
//  Организация - <СправочникСсылка.Организации> 
//							Организация, договор которой нужно получить
//  СписокВидовДоговора	 - <Массив> или <СписокЗначений>, состоящий из значений типа <ПеречислениеСсылка.ВидыДоговоров> 
//							Нужные виды договора
//
// Возвращаемое значение:
//   <СправочникСсылка.ДоговорыКонтрагентов> – найденный договор или пустая ссылка
//
Функция ПолучитьДоговорКредитаИЗаймаПоУмолчаниюПоОрганизацииВидуДоговора(Контрагент, Организация, СписокВидовДоговора = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДоговорКредитаИЗайма.Ссылка
	|ИЗ
	|	Документ.ДоговорКредитаИЗайма КАК ДоговорКредитаИЗайма
	|ГДЕ
	|	ДоговорКредитаИЗайма.Контрагент = &Контрагент
	|	И ДоговорКредитаИЗайма.Организация = &Организация
	|	И ДоговорКредитаИЗайма.Проведен"
	+?(СписокВидовДоговора <> Неопределено,"
	|	И ДоговорКредитаИЗайма.ВидДоговора В (&СписокВидовДоговора)","");
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("СписокВидовДоговора", СписокВидовДоговора);
	
	Если ТипЗнч(Контрагент) = Тип("СправочникСсылка.Сотрудники") Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДоговорКредитаИЗайма.Контрагент = &Контрагент", "ДоговорКредитаИЗайма.Сотрудник = &Контрагент");
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	Если Выборка.Количество() = 1 
	   И Выборка.Следующий()
	Тогда
		ДоговорКредитаИЗайма = Выборка.Ссылка;
	Иначе
		ДоговорКредитаИЗайма = Неопределено;
	КонецЕсли;
	
	Возврат ДоговорКредитаИЗайма;
	
КонецФункции // ПолучитьДоговорКредитаИЗаймаПоУмолчаниюПоОрганизацииВидуДоговора()

#Область ВерсионированиеОбъектов

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область ИнтерфейсПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

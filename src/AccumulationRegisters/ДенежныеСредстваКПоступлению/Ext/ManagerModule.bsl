﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура создает пустую временную таблицу изменения движений.
//
Процедура СоздатьПустуюВременнуюТаблицуИзменение(ДополнительныеСвойства) Экспорт
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
	 ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда	
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 0
	|	ДенежныеСредстваКПоступлению.НомерСтроки КАК НомерСтроки,
	|	ДенежныеСредстваКПоступлению.Организация КАК Организация,
	|	ДенежныеСредстваКПоступлению.Касса КАК Касса,
	|	ДенежныеСредстваКПоступлению.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ДенежныеСредстваКПоступлению.ДокументПередачи КАК ДокументПередачи,
	|	ДенежныеСредстваКПоступлению.Сумма КАК СуммаПередЗаписью,
	|	ДенежныеСредстваКПоступлению.Сумма КАК СуммаИзменение,
	|	ДенежныеСредстваКПоступлению.Сумма КАК СуммаПриЗаписи,
	|	ДенежныеСредстваКПоступлению.СуммаВал КАК СуммаВалПередЗаписью,
	|	ДенежныеСредстваКПоступлению.СуммаВал КАК СуммаВалИзменение,
	|	ДенежныеСредстваКПоступлению.СуммаВал КАК СуммаВалПриЗаписи
	|ПОМЕСТИТЬ ДвиженияДенежныеСредстваКПоступлениюИзменение
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваКПоступлению КАК ДенежныеСредстваКПоступлению");
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияДенежныеСредстваКПоступлениюИзменение", Ложь);
	
КонецПроцедуры // СоздатьПустуюВременнуюТаблицуИзменение()

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
	|	И ЗначениеРазрешено(Касса)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли
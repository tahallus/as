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
	|	ДенежныеСредства.НомерСтроки КАК НомерСтроки,
	|	ДенежныеСредства.Организация КАК Организация,
	|	ДенежныеСредства.ТипДенежныхСредств КАК ТипДенежныхСредств,
	|	ДенежныеСредства.БанковскийСчетКасса КАК БанковскийСчетКасса,
	|	ДенежныеСредства.Валюта КАК Валюта,
	|	ДенежныеСредства.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ДенежныеСредства.Сумма КАК СуммаПередЗаписью,
	|	ДенежныеСредства.Сумма КАК СуммаИзменение,
	|	ДенежныеСредства.Сумма КАК СуммаПриЗаписи,
	|	ДенежныеСредства.СуммаВал КАК СуммаВалПередЗаписью,
	|	ДенежныеСредства.СуммаВал КАК СуммаВалИзменение,
	|	ДенежныеСредства.СуммаВал КАК СуммаВалПриЗаписи
	|ПОМЕСТИТЬ ДвиженияДенежныеСредстваИзменение
	|ИЗ
	|	РегистрНакопления.ДенежныеСредства КАК ДенежныеСредства");
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияДенежныеСредстваИзменение", Ложь);
	
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
	|	И ЗначениеРазрешено(БанковскийСчетКасса)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли
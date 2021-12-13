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
	|	ДенежныеСредстваВКассахККМ.НомерСтроки КАК НомерСтроки,
	|	ДенежныеСредстваВКассахККМ.Организация КАК Организация,
	|	ДенежныеСредстваВКассахККМ.КассаККМ КАК КассаККМ,
	|	ДенежныеСредстваВКассахККМ.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ДенежныеСредстваВКассахККМ.Сумма КАК СуммаПередЗаписью,
	|	ДенежныеСредстваВКассахККМ.Сумма КАК СуммаИзменение,
	|	ДенежныеСредстваВКассахККМ.Сумма КАК СуммаПриЗаписи,
	|	ДенежныеСредстваВКассахККМ.СуммаВал КАК СуммаВалПередЗаписью,
	|	ДенежныеСредстваВКассахККМ.СуммаВал КАК СуммаВалИзменение,
	|	ДенежныеСредстваВКассахККМ.СуммаВал КАК СуммаВалПриЗаписи
	|ПОМЕСТИТЬ ДвиженияДенежныеСредстваВКассахККМИзменение
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваВКассахККМ КАК ДенежныеСредстваВКассахККМ");
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияДенежныеСредстваВКассахККМИзменение", Ложь);
	
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
	|	И ЗначениеРазрешено(КассаККМ)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли
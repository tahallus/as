﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ЕстьОстаткиПоЗапасамПереданнымВРазрезеГТД() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЗапасыПереданныеВРазрезеГТД.НомерГТД
		|ИЗ
		|	РегистрНакопления.ЗапасыПереданныеВРазрезеГТД.Остатки КАК ЗапасыПереданныеВРазрезеГТД";
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

// Процедура создает пустую временную таблицу изменения движений.
//
Процедура СоздатьПустуюВременнуюТаблицуИзменение(ДополнительныеСвойства) Экспорт
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
	 ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияЗапасыПереданныеВРазрезеГТДИзменение") Тогда
		
		Возврат
		
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 0
	|	ЗапасыПереданныеВРазрезеГТД.НомерСтроки КАК НомерСтроки,
	|	ЗапасыПереданныеВРазрезеГТД.Организация КАК Организация,
	|	ЗапасыПереданныеВРазрезеГТД.Номенклатура КАК Номенклатура,
	|	ЗапасыПереданныеВРазрезеГТД.НомерГТД КАК НомерГТД,
	|	ЗапасыПереданныеВРазрезеГТД.Партия КАК Партия,
	|	ЗапасыПереданныеВРазрезеГТД.Характеристика КАК Характеристика,
	|	ЗапасыПереданныеВРазрезеГТД.СтранаПроисхождения КАК СтранаПроисхождения,
	|	ЗапасыПереданныеВРазрезеГТД.Количество КАК КоличествоПередЗаписью,
	|	ЗапасыПереданныеВРазрезеГТД.Количество КАК КоличествоИзменение,
	|	ЗапасыПереданныеВРазрезеГТД.Количество КАК КоличествоПриЗаписи
	|ПОМЕСТИТЬ ДвиженияЗапасыПереданныеВРазрезеГТДИзменение
	|ИЗ
	|	РегистрНакопления.ЗапасыПереданныеВРазрезеГТД КАК ЗапасыПереданныеВРазрезеГТД");
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗапасыПереданныеВРазрезеГТДИзменение", Ложь);
	
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
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли
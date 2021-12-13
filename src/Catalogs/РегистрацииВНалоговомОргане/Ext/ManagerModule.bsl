﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс	
	
Функция ПолучитьКоличествоПодчиненныхЭлементовПоВладельцу(Владелец) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РегистрацииВНалоговомОргане.Ссылка
	|ИЗ
	|	Справочник.РегистрацииВНалоговомОргане КАК РегистрацииВНалоговомОргане
	|ГДЕ
	|	РегистрацииВНалоговомОргане.Владелец = &Владелец";
	Запрос.УстановитьПараметр("Владелец", Владелец);

	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат Выборка.Количество();

КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК ЭтотСписок
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Владельцы 
	|	ПО Владельцы.Ссылка = ЭтотСписок.Владелец
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК ОбособленныеПодразделения 
	|	ПО ОбособленныеПодразделения.ГоловнаяОрганизация = Владельцы.Ссылка
	|;
	|РазрешитьЧтение
	|ГДЕ
	|	ЗначениеРазрешено(Владелец)
	| ИЛИ ЗначениеРазрешено(ОбособленныеПодразделения.Ссылка)
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ЗначениеРазрешено(Владелец)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийМодуляМенеджера

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Организация") Тогда
		Если ЗначениеЗаполнено(Параметры.Отбор.Организация) Тогда
			Параметры.Отбор.Организация = РегламентированнаяОтчетность.ГоловнаяОрганизация(Параметры.Отбор.Организация);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
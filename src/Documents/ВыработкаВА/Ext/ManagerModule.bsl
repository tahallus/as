﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылкаВыработкаВнеоборотныхАктивов, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаВыработкаВнеоборотныхАктивов);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка.Дата КАК Период,
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	&Организация КАК Организация,
	|	ТаблицаДокумента.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|	ТаблицаДокумента.Количество КАК Количество
	|ИЗ
	|	Документ.ВыработкаВА.ВнеоборотныеАктивы КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаВыработкаВнеоборотныхАктивов", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

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
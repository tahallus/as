﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоВнеоборотнымАктивам(ДанныеЗаполнения) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПараметрыАмортизацииСрезПоследних.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|	ПараметрыАмортизацииСрезПоследних.СтруктурнаяЕдиница КАК Подразделение,
	|	ПараметрыАмортизацииСрезПоследних.ОбъемПродукцииРаботДляВычисленияАмортизации КАК ОбъемПродукцииРаботДляВычисленияАмортизации,
	|	ПараметрыАмортизацииСрезПоследних.СтоимостьДляВычисленияАмортизации КАК СтоимостьДляВычисленияАмортизации,
	|	ПараметрыАмортизацииСрезПоследних.СрокИспользованияДляВычисленияАмортизации КАК СрокИспользованияДляВычисленияАмортизации,
	|	ПараметрыАмортизацииСрезПоследних.СчетЗатрат КАК СчетЗатрат,
	|	ПараметрыАмортизацииСрезПоследних.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ПараметрыАмортизацииСрезПоследних.Регистратор.Организация КАК Организация
	|ИЗ
	|	РегистрСведений.ПараметрыВнеоборотныхАктивов.СрезПоследних(, ВнеоборотныйАктив = &ВнеоборотныйАктив) КАК ПараметрыАмортизацииСрезПоследних");
	
	Запрос.УстановитьПараметр("ВнеоборотныйАктив", ДанныеЗаполнения);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Выборка.Следующий();
	
	Организация = Выборка.Организация;
	
	НоваяСтрока = ВнеоборотныеАктивы.Добавить();
	
	НоваяСтрока.ВнеоборотныйАктив = Выборка.ВнеоборотныйАктив;
	НоваяСтрока.СрокИспользованияДляВычисленияАмортизации = Выборка.СрокИспользованияДляВычисленияАмортизации;
	НоваяСтрока.ОбъемПродукцииРаботДляВычисленияАмортизации = Выборка.ОбъемПродукцииРаботДляВычисленияАмортизации;
	НоваяСтрока.СтоимостьДляВычисленияАмортизации = Выборка.СтоимостьДляВычисленияАмортизации;
	НоваяСтрока.СчетЗатрат = Выборка.СчетЗатрат;
	НоваяСтрока.НаправлениеДеятельности = Выборка.НаправлениеДеятельности;
	НоваяСтрока.СтруктурнаяЕдиница = Выборка.Подразделение;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("СправочникСсылка.ВнеоборотныеАктивы")] = "ЗаполнитьПоВнеоборотнымАктивам";
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Константы.ФункциональнаяОпцияУчетПоНесколькимНаправлениямДеятельности.Получить() Тогда
		
		Для каждого СтрокаВнеоборотныеАктивы Из ВнеоборотныеАктивы Цикл
			
			Если СтрокаВнеоборотныеАктивы.СчетЗатрат.ТипСчета = Перечисления.ТипыСчетов.Расходы Тогда
				
				СтрокаВнеоборотныеАктивы.НаправлениеДеятельности = Справочники.НаправленияДеятельности.ОсновноеНаправление;
				
			Иначе
				
				СтрокаВнеоборотныеАктивы.НаправлениеДеятельности = Неопределено;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Выполнение предварительного контроля.
	ВыполнитьПредварительныйКонтроль(Отказ);
	
	Для каждого СтрокаВнеоборотныхАктивов Из ВнеоборотныеАктивы Цикл
			
		Если СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив.СпособАмортизации = Перечисления.СпособыНачисленияАмортизацииВнеоборотныхАктивов.Линейный
		   И СтрокаВнеоборотныхАктивов.СрокИспользованияДляВычисленияАмортизации = 0 Тогда
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'Для имущества ""%1"" указанного в строке %2 списка ""Имущество"", должен быть заполнен ""Срок использования для вычисления амортизации"".'"),
				СокрЛП(СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив), СтрокаВнеоборотныхАктивов.НомерСтроки);
			КонтекстныеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ВнеоборотныеАктивы",
				СтрокаВнеоборотныхАктивов.НомерСтроки, "СрокИспользованияДляВычисленияАмортизации");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , КонтекстныеПоле, , Отказ);
		КонецЕсли;
		
		Если СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив.СпособАмортизации = Перечисления.СпособыНачисленияАмортизацииВнеоборотныхАктивов.ПропорциональноОбъемуПродукции
		   И СтрокаВнеоборотныхАктивов.ОбъемПродукцииРаботДляВычисленияАмортизации = 0 Тогда
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'Для имущества ""%1"" указанного в строке %2 списка ""Имущество"", должен быть заполнен ""Объем продукции (работ) для исчисления амортизации в натуральных ед."".'"),
				СокрЛП(СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив), СтрокаВнеоборотныхАктивов.НомерСтроки);
			КонтекстныеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ВнеоборотныеАктивы",
				СтрокаВнеоборотныхАктивов.НомерСтроки, "ОбъемПродукцииРаботДляВычисленияАмортизации");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , КонтекстныеПоле, , Отказ);
		КонецЕсли;
		
		Если СтрокаВнеоборотныхАктивов.СтоимостьДляВычисленияАмортизации > СтрокаВнеоборотныхАктивов.СтоимостьДляВычисленияАмортизацииДоИзменения Тогда
			ПроверяемыеРеквизиты.Добавить("ВнеоборотныеАктивы.СчетПереоценки");
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа
	Документы.ИзменениеПараметровВА.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ПроведениеДокументовУНФ.ОтразитьДвижения("ПараметрыВнеоборотныхАктивов", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ВнеоборотныеАктивы", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДоходыИРасходы", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьУправленческий(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет предварительный контроль.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	// Дубли строк.
	Запрос = Новый Запрос();
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.ВнеоборотныйАктив
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	&ТаблицаДокумента КАК ТаблицаДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ТаблицаДокумента1.НомерСтроки) КАК НомерСтроки,
	|	ТаблицаДокумента1.ВнеоборотныйАктив
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента1
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДокумента КАК ТаблицаДокумента2
	|		ПО ТаблицаДокумента1.НомерСтроки <> ТаблицаДокумента2.НомерСтроки
	|			И ТаблицаДокумента1.ВнеоборотныйАктив = ТаблицаДокумента2.ВнеоборотныйАктив
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента1.ВнеоборотныйАктив
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос.УстановитьПараметр("ТаблицаДокумента", ВнеоборотныеАктивы);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'Имущество ""%1"" указанное в строке %2 списка ""Имущество"", указано повторно.'"), СокрЛП(
				ВыборкаИзРезультатаЗапроса.ВнеоборотныйАктив), ВыборкаИзРезультатаЗапроса.НомерСтроки);
			КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ВнеоборотныеАктивы",
				ВыборкаИзРезультатаЗапроса.НомерСтроки, "ВнеоборотныйАктив");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
		КонецЦикла;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Константы.УчетПоКомпании.Компания(Организация));
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("СписокВнеоборотныхАктивов", ВнеоборотныеАктивы.ВыгрузитьКолонку("ВнеоборотныйАктив"));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СостояниеВнеоборотногоАктиваСрезПоследних.ВнеоборотныйАктив КАК ВнеоборотныйАктив
	|ИЗ
	|	РегистрСведений.СостоянияВнеоборотныхАктивов.СрезПоследних(&Период, Организация = &Организация) КАК СостояниеВнеоборотногоАктиваСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СостояниеВнеоборотногоАктиваСрезПоследних.ВнеоборотныйАктив КАК ВнеоборотныйАктив
	|ИЗ
	|	РегистрСведений.СостоянияВнеоборотныхАктивов.СрезПоследних(
	|			&Период,
	|			Организация = &Организация
	|				И ВнеоборотныйАктив В (&СписокВнеоборотныхАктивов)
	|				И Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияВнеоборотныхАктивов.ПринятКУчету)) КАК СостояниеВнеоборотногоАктиваСрезПоследних";
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	МассивВАСостояния = МассивРезультатов[0].Выгрузить().ВыгрузитьКолонку("ВнеоборотныйАктив");
	МассивВАПринятКУчету = МассивРезультатов[1].Выгрузить().ВыгрузитьКолонку("ВнеоборотныйАктив");
	
	Для каждого СтрокаВнеоборотныхАктивов Из ВнеоборотныеАктивы Цикл
			
		Если МассивВАСостояния.Найти(СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив) = Неопределено Тогда
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'Для имущества ""%1"" указанного в строке %2 списка ""Имущество"", не зарегистрированы состояния.'"),
				СокрЛП(СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив), СтрокаВнеоборотныхАктивов.НомерСтроки);
			КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ВнеоборотныеАктивы",
				СтрокаВнеоборотныхАктивов.НомерСтроки, "ВнеоборотныйАктив");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
		ИначеЕсли МассивВАПринятКУчету.Найти(СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив) = Неопределено Тогда
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'Для имущества ""%1"" указанного в строке %2 списка ""Имущество"", текущее состояние ""Снят с учета"".'"),
				СокрЛП(СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив), СтрокаВнеоборотныхАктивов.НомерСтроки);
			КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ВнеоборотныеАктивы",
				СтрокаВнеоборотныхАктивов.НомерСтроки, "ВнеоборотныйАктив");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ВыполнитьПредварительныйКонтроль()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
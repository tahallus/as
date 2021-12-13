﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Обработчик заполнения на основании элемента справочника ВнеоборотныеАктивы
//
// Параметры:
//	СправочникСсылкаВнеоборотныеАктивы - СправочникСсылка.ВнеоборотныеАктивы.
//	
Процедура ЗаполнитьПоВнеоборотныеАктивы(СправочникСсылкаВнеоборотныеАктивы) Экспорт
	
	НоваяСтрока = ВнеоборотныеАктивы.Добавить();
	НоваяСтрока.ВнеоборотныйАктив = СправочникСсылкаВнеоборотныеАктивы;
	НоваяСтрока.НачислятьАмортизацию = Истина;
	НоваяСтрока.НачислятьАмортизациюВТекущемМесяце = Истина;
	
	Пользователь = Пользователи.ТекущийПользователь();
	ЗначениеНастройки = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь, "ОсновноеПодразделение");
	ОсновноеПодразделение = ?(ЗначениеЗаполнено(ЗначениеНастройки), ЗначениеНастройки, Справочники.СтруктурныеЕдиницы.ОсновноеПодразделение);
	
	НоваяСтрока.СтруктурнаяЕдиница = ОсновноеПодразделение;
	
КонецПроцедуры // ЗаполнитьПоВнеоборотныеАктивы()

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("СправочникСсылка.ВнеоборотныеАктивы")] = "ЗаполнитьПоВнеоборотныеАктивы";
	
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
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Выполнение предварительного контроля.
	ВыполнитьПредварительныйКонтроль(Отказ);
	
	// Корректность заполнения.
	Для каждого СтрокаВнеоборотныхАктивов Из ВнеоборотныеАктивы Цикл
			
		Если СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив.СпособАмортизации = Перечисления.СпособыНачисленияАмортизацииВнеоборотныхАктивов.Линейный
		   И СтрокаВнеоборотныхАктивов.СрокИспользованияДляВычисленияАмортизации = 0 Тогда
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'Для имущества ""%1"" указанного в строке %2 списка ""Имущество"", должен быть заполнен ""Срок использования для вычисления амортизации"".'"),
				СокрЛП(СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив), СтрокаВнеоборотныхАктивов.НомерСтроки);
			КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ВнеоборотныеАктивы",
				СтрокаВнеоборотныхАктивов.НомерСтроки, "СрокИспользованияДляВычисленияАмортизации");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
		КонецЕсли;
			
		Если СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив.СпособАмортизации = Перечисления.СпособыНачисленияАмортизацииВнеоборотныхАктивов.ПропорциональноОбъемуПродукции
		   И СтрокаВнеоборотныхАктивов.ОбъемПродукцииРаботДляВычисленияАмортизации = 0 Тогда
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'Для имущества ""%1"" указанного в строке %2 списка ""Имущество"", должен быть заполнен ""Объем продукции (работ) для исчисления амортизации в натуральных ед."".'"),
				СокрЛП(СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив), СтрокаВнеоборотныхАктивов.НомерСтроки);
			КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ВнеоборотныеАктивы",
				СтрокаВнеоборотныхАктивов.НомерСтроки, "ОбъемПродукцииРаботДляВычисленияАмортизации");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
	// Характеристики и партии
	Если Номенклатура.ПроверятьЗаполнениеХарактеристики И Не ЗначениеЗаполнено(Характеристика)
		Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Для данной номенклатуры, заполнение поля ""характеристика"" является обязательным!'"));
		Отказ = Истина;
	КонецЕсли;
	
	Если Номенклатура.ПроверятьЗаполнениеПартий И Не ЗначениеЗаполнено(Партия)
		Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Для данной номенклатуры, заполнение поля ""партия"" является обязательным!'"));
		Отказ = Истина;
	КонецЕсли;
	// Конец Характеристики и партии
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа
	Документы.ПринятиеКУчетуВА.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ПроведениеДокументовУНФ.ОтразитьДвижения("СостоянияВнеоборотныхАктивов", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ПараметрыВнеоборотныхАктивов", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ВнеоборотныеАктивы", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("Запасы", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ЗапасыКРасходуСоСкладов", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ЗапасыНаСкладах", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьУправленческий(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательных остатков.
	Документы.ПринятиеКУчетуВА.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательных остатков.
	Документы.ПринятиеКУчетуВА.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет предварительный контроль.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	// Проверка Дубли строк.
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
				"ru = 'Имущество ""%1"" указанное в строке %2 списка ""Имущество"", указано повторно.'"),
				ВыборкаИзРезультатаЗапроса.ВнеоборотныйАктив, ВыборкаИзРезультатаЗапроса.НомерСтроки);
			КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ВнеоборотныеАктивы",
				ВыборкаИзРезультатаЗапроса.НомерСтроки, "ВнеоборотныйАктив");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
		КонецЦикла;
	КонецЕсли;
	
	// Проверка стоимости.
	ИтогПервоначальнаяСтоимость = 0;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Константы.УчетПоКомпании.Компания(Организация));
	Запрос.УстановитьПараметр("СписокВнеоборотныхАктивов", ВнеоборотныеАктивы.ВыгрузитьКолонку("ВнеоборотныйАктив"));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СУММА(ВнеоборотныеАктивы.НачальнаяСтоимость) КАК НачальнаяСтоимость
	|ИЗ
	|	Справочник.ВнеоборотныеАктивы КАК ВнеоборотныеАктивы
	|ГДЕ
	|	ВнеоборотныеАктивы.Ссылка В (&СписокВнеоборотныхАктивов)";
	
	ВыборкаЗапроса = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаЗапроса.Следующий() Тогда
		ИтогПервоначальнаяСтоимость = ВыборкаЗапроса.НачальнаяСтоимость;
	КонецЕсли;
		
	Если ИтогПервоначальнаяСтоимость <> Сумма Тогда
		ТекстСообщения = СтрШаблон(НСтр(
			"ru = 'Стоимость номенклатуры: %1 , не соответствует сумме первоначальных стоимостей имущества: %2'"),
			Сумма, ИтогПервоначальнаяСтоимость);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, , , Отказ);
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.ВнеоборотныйАктив КАК ВнеоборотныйАктив
	|ИЗ
	|	(ВЫБРАТЬ
	|		СостоянияВнеоборотныхАктивов.ВнеоборотныйАктив КАК ВнеоборотныйАктив,
	|		СУММА(ВЫБОР
	|				КОГДА СостоянияВнеоборотныхАктивов.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияВнеоборотныхАктивов.ПринятКУчету)
	|					ТОГДА 1
	|				ИНАЧЕ -1
	|			КОНЕЦ) КАК ТекущееСостояние
	|	ИЗ
	|		РегистрСведений.СостоянияВнеоборотныхАктивов КАК СостоянияВнеоборотныхАктивов
	|	ГДЕ
	|		СостоянияВнеоборотныхАктивов.Регистратор <> &Ссылка
	|		И СостоянияВнеоборотныхАктивов.Организация = &Организация
	|		И СостоянияВнеоборотныхАктивов.ВнеоборотныйАктив В(&СписокВнеоборотныхАктивов)
	|	
	|	СГРУППИРОВАТЬ ПО
	|		СостоянияВнеоборотныхАктивов.ВнеоборотныйАктив) КАК ВложенныйЗапрос
	|ГДЕ
	|	ВложенныйЗапрос.ТекущееСостояние > 0";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	МассивВАСостояния = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("ВнеоборотныйАктив");
	
	Для каждого СтрокаВнеоборотныхАктивов Из ВнеоборотныеАктивы Цикл
			
		Если МассивВАСостояния.Найти(СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив) <> Неопределено Тогда
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'Для имущества ""%1"" указанного в строке %2 списка ""Имущество"", текущее состояние ""Принят к учету"".'"),
				СокрЛП(СтрокаВнеоборотныхАктивов.ВнеоборотныйАктив), СтрокаВнеоборотныхАктивов.НомерСтроки);
			КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ВнеоборотныеАктивы",
				СтрокаВнеоборотныхАктивов.НомерСтроки, "ВнеоборотныйАктив");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, , , Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ВыполнитьПредварительныйКонтроль()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
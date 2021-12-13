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

#КонецОбласти

// Отборы - Структура - Структура со значениями отборов
//
// Допустимые значения отборов:
//	Отборы.Период - Дата
//	Отборы.Организация - Справочник.Организации
//	Отборы.СтруктурнаяЕдиница - Справочник.СтруктурныеЕдиницы
//	Отборы.ОтраслевойДокумент - (см. ДокументыСКомиссиями)
//
Функция КомиссияПоУмолчанию(Отборы) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ Комиссии.Ссылка КАК Комиссия
	|ИЗ Справочник.Комиссии КАК Комиссии
	|ГДЕ НЕ Комиссии.КомиссияРасформирована
	| И &Период МЕЖДУ Комиссии.ДатаПодписаниеПриказа И Комиссии.КомиссияФункционируетПо
	| И Комиссии.Организация = &Организация
	| И Комиссии.ОтраслевойДокумент = &ОтраслевойДокумент
	| И (Комиссии.СтруктурнаяЕдиница = &СтруктурнаяЕдиница 
	|		ИЛИ Комиссии.СтруктурнаяЕдиница = Значение(Справочник.СтруктурныеЕдиницы.ПустаяСсылка))
	|УПОРЯДОЧИТЬ ПО Комиссии.СтруктурнаяЕдиница";
	
	Запрос.УстановитьПараметр("Период", Отборы.Период);
	Запрос.УстановитьПараметр("Организация", Отборы.Организация);
	Запрос.УстановитьПараметр("ОтраслевойДокумент", Отборы.ОтраслевойДокумент);
	
	Если Отборы.Свойство("СтруктурнаяЕдиница") Тогда
		
		Запрос.УстановитьПараметр("СтруктурнаяЕдиница", Отборы.СтруктурнаяЕдиница);
		
	Иначе
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Комиссии.СтруктурнаяЕдиница = &СтруктурнаяЕдиница", "Истина");
		
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат ?(Выборка.Следующий(), Выборка.Комиссия, Неопределено);
	
КонецФункции

Функция ОписаниеДокументовСКомиссиями(МетаданныеДокументов)
	
	ДокументыСКомиссиями	= Новый Соответствие;
	Для каждого МетаданныеДокумента Из МетаданныеДокументов Цикл
		
		ДокументыСКомиссиями.Вставить(МетаданныеДокумента.Имя, МетаданныеДокумента.Синоним);
		
	КонецЦикла;
	
	Возврат ДокументыСКомиссиями;
	
КонецФункции

Функция ДокументыСКомиссиями() Экспорт
	
	МетаданныеДокументов = Новый Массив;
	МетаданныеДокументов.Добавить(Метаданные.Документы.ИнвентаризацияЗапасов);
	МетаданныеДокументов.Добавить(Метаданные.Документы.ПриходныйОрдер);
	
	Возврат ОписаниеДокументовСКомиссиями(МетаданныеДокументов);
	
КонецФункции

Функция КомиссияИспользуетсяВДокументах(Комиссия) Экспорт
	
	ДокументыСКомиссиями		= ДокументыСКомиссиями();
	
	Схема						= Новый СхемаЗапроса;
	ПакетЗапросовСхемыЗапросов	= Схема.ПакетЗапросов[0];
	Операторы					= ПакетЗапросовСхемыЗапросов.Операторы;
	
	ПервыйОператор = Истина;
	Для каждого ОписаниеДокумента Из ДокументыСКомиссиями Цикл
		
		ОператорТаблицы = ?(ПервыйОператор, Операторы[0], Операторы.Добавить());
		ОператорТаблицы.Источники.Добавить("Документ." + ОписаниеДокумента.Ключ, ОписаниеДокумента.Ключ);
		ОператорТаблицы.ТипОбъединения = ТипОбъединенияСхемыЗапроса.ОбъединитьВсе;
		ОператорТаблицы.ВыбираемыеПоля.Добавить(ОписаниеДокумента.Ключ + ".Ссылка");
		ОператорТаблицы.Отбор.Добавить(ОписаниеДокумента.Ключ + ".Комиссия = &Комиссия И " + ОписаниеДокумента.Ключ + ".Комиссия <> ЗНАЧЕНИЕ(Справочник.Комиссии.ПустаяСсылка)");
		
		ПервыйОператор = Ложь;
		
	КонецЦикла;
	
	Запрос = Новый Запрос(Схема.ПолучитьТекстЗапроса());
	Запрос.УстановитьПараметр("Комиссия", Комиссия);
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

Функция ПодписиКомиссииМассивом(Комиссия) Экспорт
	
	РазмерКомиссии = 0;
	Если ЗначениеЗаполнено(Комиссия) Тогда
		
		РазмерКомиссии = Комиссия.ПодписиКомиссии.Количество();
		
	КонецЕсли;
	
	СтруктураКомиссии = Новый Структура;
	СтруктураКомиссии.Вставить("ПодписьПредседателя", Неопределено);
	СтруктураКомиссии.Вставить("РазмерКомиссии", РазмерКомиссии);
	СтруктураКомиссии.Вставить("ПодписиКомиссии", Новый Массив);
	
	Если РазмерКомиссии > 0 Тогда
		
		Для каждого СтрокаОписанияПодписи Из Комиссия.ПодписиКомиссии Цикл
			
			Если СтрокаОписанияПодписи.ЭтоПодписьПредседателяКомиссии Тогда
				
				СтруктураКомиссии.ПодписьПредседателя = СтрокаОписанияПодписи.ПодписьЧленаКомиссии;
				
			КонецЕсли;
			
			СтруктураКомиссии.ПодписиКомиссии.Добавить(СтрокаОписанияПодписи.ПодписьЧленаКомиссии);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат СтруктураКомиссии;
	
КонецФункции

Процедура РасформироватьКомиссииПриУвольнении(ДополнительныеСвойства, Отказ) Экспорт
	
	ТаблицаКомиссийКРасформированию = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаКомиссийКРасформированию;
	Для каждого СтрокаТаблицы Из ТаблицаКомиссийКРасформированию Цикл
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.Комиссия) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ПодписьОбъект = СтрокаТаблицы.Комиссия.ПолучитьОбъект();
		Попытка
			
			ПодписьОбъект.Заблокировать();
			ПодписьОбъект.КомиссияРасформирована = Истина;
			ПодписьОбъект.Записать();
			
		Исключение
			
			Отказ = Истина;
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	
	
КонецПроцедуры

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//   Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область ИнтерфейсПечати

Функция ШаблоныТекстовПечатнойФормы(ЭтоИнвентаризация)
	
	ТекстыЗаполненияПФ = Новый Структура;
	Если ЭтоИнвентаризация Тогда
		
		ТекстыЗаполненияПФ.Вставить("ОписаниеПриказа",					НСтр("ru ='о создании инвентаризационной комиссии по предприятию:'"));
		ТекстыЗаполненияПФ.Вставить("НазначениеКомиссии",				НСтр("ru ='с целью проведения инвентаризационных работ назначается постоянно действующая комиссия в составе:'"));
		ТекстыЗаполненияПФ.Вставить("ОбязанностиКомиссииЗаголовок",		НСтр("ru ='Постоянно действующая инвентаризационная комиссия осуществляет свою работу в соответствии с учетной политикой организации и утверждается текущим приказом. В обязанности комиссии входит:'"));
		ТекстыЗаполненияПФ.Вставить("Пункт1",							НСтр("ru ='1. Обеспечивает проведение инвентаризаций всего имущества и всех обязательств организации;'"));
		ТекстыЗаполненияПФ.Вставить("Пункт2",							НСтр("ru ='2. В период проведения плановых инвентаризаций курирует и обобщает деятельность рабочих предприятия.'"));
		ТекстыЗаполненияПФ.Вставить("СрокДействияКомиссииЗаголовок",	НСтр("ru ='Персональный состав постоянно действующей инвентаризационной комиссии назначается сроком до:'"));
		
	Иначе
		
		ТекстыЗаполненияПФ.Вставить("ОписаниеПриказа",					НСтр("ru ='о создании комиссии по предприятию:'"));
		ТекстыЗаполненияПФ.Вставить("НазначениеКомиссии",				НСтр("ru ='с целью оприходования товаров без счета поставщика назначается постоянно действующая комиссия в составе:'"));
		ТекстыЗаполненияПФ.Вставить("ОбязанностиКомиссииЗаголовок",		НСтр("ru ='Постоянно действующая комиссия осуществляет свою работу в соответствии с учетной политикой организации и утверждается текущим приказом. В обязанности комиссии входит:'"));
		ТекстыЗаполненияПФ.Вставить("Пункт1",							НСтр("ru ='1. Обеспечивает приемку и оприходования фактически полученных товарно-материальных ценностей, поступивших без счета поставщика;'"));
		ТекстыЗаполненияПФ.Вставить("Пункт2",							НСтр("ru ='2. Оформляет документы, которые подтверждают фактическое наличие товаров (ТОРГ-4) и обобщает деятельность рабочих предприятия.'"));
		ТекстыЗаполненияПФ.Вставить("СрокДействияКомиссииЗаголовок",	НСтр("ru ='Персональный состав постоянно действующей комиссии назначается сроком до:'"));
		
	КонецЕсли;
	
	Возврат ТекстыЗаполненияПФ;
	
КонецФункции

Функция ПечатьПриказа(МассивОбъектов, ОбъектыПечати, Макет) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПФ_XML_ПриказОСозданииКомиссии";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпрКомиссий.Ссылка
	|	,СпрКомиссий.Код КАК Номер
	|	,СпрКомиссий.Организация
	|	,СпрКомиссий.Организация.Префикс КАК Префикс
	|	,СпрКомиссий.Организация.ПодписьРуководителя.Должность КАК ПредставлениеДолжностиРуководителя
	|	,СпрКомиссий.Организация.ПодписьРуководителя.РасшифровкаПодписи КАК ПредставлениеРуководителя
	|	,СпрКомиссий.СтруктурнаяЕдиница
	|	,СпрКомиссий.ДатаПодписаниеПриказа
	|	,Выбор КОГДА СпрКомиссий.ОтраслевойДокумент = &ИмяДокументаИнвентаризация ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ КОНЕЦ КАК ЭтоИнвентаризация
	|	,СпрКомиссий.КомиссияФункционируетПо
	|	,СпрКомиссий.ПодписиКомиссии.(
	|		ЭтоПодписьПредседателяКомиссии КАК ЭтоПредседатель
	|		,ПодписьЧленаКомиссии.РасшифровкаПодписи КАК ПодписьЧленаКомиссии
	|		,ПодписьЧленаКомиссии.Должность КАК Должность) КАК СоставКомиссии
	|ИЗ Справочник.Комиссии КАК СпрКомиссий ГДЕ СпрКомиссий.Ссылка В(&МассивОбъектов)
	|УПОРЯДОЧИТЬ ПО ЭтоПредседатель УБЫВ";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.УстановитьПараметр("ИмяДокументаИнвентаризация", Метаданные.Документы.ИнвентаризацияЗапасов.Имя);
	ДанныеДокументов = Запрос.Выполнить().Выбрать();
	
	ЗначенияДокумента = Новый Структура;
	
	ПервыйДокумент = Истина;
	Пока ДанныеДокументов.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			ПервыйДокумент = Ложь;
			ЗначенияДокумента.Очистить();
			
		КонецЕсли;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ТекстыЗаполненияПФ = ШаблоныТекстовПечатнойФормы(ДанныеДокументов.ЭтоИнвентаризация);
		
		ОбластьМакетаШапка = Макет.ПолучитьОбласть("Шапка");
		
		ПредставлениеПриказа = НСтр("ru ='Приказ №%1 от %2'");
		НомерДокумента = ПечатьДокументовУНФ.НомерНаПечать(ДанныеДокументов.Номер, ДанныеДокументов.Префикс);
		ПредставлениеПриказа = СтрШаблон(ПредставлениеПриказа, НомерДокумента, Формат(ДанныеДокументов.ДатаПодписаниеПриказа, "ДЛФ=DD"));
		ЗначенияДокумента.Вставить("ПредставлениеПриказа", ПредставлениеПриказа);
		
		ЗначенияДокумента.Вставить("ОписаниеПриказа", ТекстыЗаполненияПФ.ОписаниеПриказа);
		ЗначенияДокумента.Вставить("НазначениеКомиссии", ТекстыЗаполненияПФ.НазначениеКомиссии);
		
		СведенияОбОрганизации = ПечатьДокументовУНФ.СведенияОЮрФизЛице(ДанныеДокументов.Организация, ДанныеДокументов.ДатаПодписаниеПриказа);
		ПредставлениеОрганизации = ПечатьДокументовУНФ.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование");
		ЗначенияДокумента.Вставить("Организация", ПредставлениеОрганизации);
		
		СтруктурнаяЕдиница = ?(ЗначениеЗаполнено(ДанныеДокументов.СтруктурнаяЕдиница), ДанныеДокументов.СтруктурнаяЕдиница, НСтр("ru ='По организации в целом'"));
		ЗначенияДокумента.Вставить("СтруктурнаяЕдиница", СтруктурнаяЕдиница);
		
		ОбластьМакетаШапка.Параметры.Заполнить(ЗначенияДокумента);
		ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
		
		ОбластьМакетаПредседатель = Макет.ПолучитьОбласть("Председатель");
		ОбластьМакетаПервый = Макет.ПолучитьОбласть("КомиссияПервый");
		ОбластьМакетаПоследующий = Макет.ПолучитьОбласть("КомиссияПоследующий");
		
		СоставКомиссии = ДанныеДокументов.СоставКомиссии.Выбрать();
		Пока СоставКомиссии.Следующий() Цикл
			
			ЗначенияДокумента.Очистить();
			
			ЗначенияДокумента.Вставить("Должность", СоставКомиссии.Должность);
			ЗначенияДокумента.Вставить("Представление", СоставКомиссии.ПодписьЧленаКомиссии);
			
			Если СоставКомиссии.ЭтоПредседатель И НЕ ОбластьМакетаПредседатель = Неопределено Тогда
				
				ОбластьМакетаПредседатель.Параметры.Заполнить(ЗначенияДокумента);
				ТабличныйДокумент.Вывести(ОбластьМакетаПредседатель);
				ОбластьМакетаПредседатель = Неопределено;
				
			ИначеЕсли НЕ ОбластьМакетаПервый = Неопределено Тогда
				
				ОбластьМакетаПервый.Параметры.Заполнить(ЗначенияДокумента);
				ТабличныйДокумент.Вывести(ОбластьМакетаПервый);
				ОбластьМакетаПервый = Неопределено;
				
			Иначе
				
				ОбластьМакетаПоследующий.Параметры.Заполнить(ЗначенияДокумента);
				ТабличныйДокумент.Вывести(ОбластьМакетаПоследующий);
				
			КонецЕсли;
			
		КонецЦикла;
		
		ОбластьМакетаПодвал = Макет.ПолучитьОбласть("Подвал");
		
		ЗначенияДокумента.Вставить("ОбязанностиКомиссииЗаголовок", ТекстыЗаполненияПФ.ОбязанностиКомиссииЗаголовок);
		ЗначенияДокумента.Вставить("Пункт1", ТекстыЗаполненияПФ.Пункт1);
		ЗначенияДокумента.Вставить("Пункт2", ТекстыЗаполненияПФ.Пункт2);
		ЗначенияДокумента.Вставить("СрокДействияКомиссииЗаголовок", ТекстыЗаполненияПФ.СрокДействияКомиссииЗаголовок);
		
		Если ЗначениеЗаполнено(ДанныеДокументов.КомиссияФункционируетПо) Тогда
			
			СрокДействияКомиссии = ПечатьДокументовУНФ.ПредставлениеДатыВДокументах(ДанныеДокументов.КомиссияФункционируетПо);
			
		Иначе
			
			СрокДействияКомиссии = НСтр("ru ='Комиссия функционирует бессрочно'");
			
		КонецЕсли;
		ЗначенияДокумента.Вставить("СрокДействияКомиссии", СрокДействияКомиссии);
		ЗначенияДокумента.Вставить("ПредставлениеРуководителя", ДанныеДокументов.ПредставлениеРуководителя);
		ЗначенияДокумента.Вставить("ДолжностьРуководителя", ДанныеДокументов.ПредставлениеДолжностиРуководителя);
		
		ОбластьМакетаПодвал.Параметры.Заполнить(ЗначенияДокумента);
		ТабличныйДокумент.Вывести(ОбластьМакетаПодвал);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеДокументов.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "ПриказОСозданииКомиссии");
	Если ПечатнаяФорма <> Неопределено Тогда
		
		ПолныйПутьКМакету				= "Справочник.Комиссии.ПФ_XML_ПриказОСозданииКомиссии";
		Макет							= УправлениеПечатью.МакетПечатнойФормы(ПолныйПутьКМакету);
		ПечатнаяФорма.ТабличныйДокумент = ПечатьПриказа(МассивОбъектов, ОбъектыПечати, Макет);
		ПечатнаяФорма.СинонимМакета		= НСтр("ru = 'Приказ о создании комиссии'");
		ПечатнаяФорма.ПолныйПутьКМакету = ПолныйПутьКМакету;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПриказОСозданииКомиссии";
	КомандаПечати.Представление = НСтр("ru = 'Приказ о создании комиссии'");
	КомандаПечати.СписокФорм = "ФормаЭлемента,ФормаСписка";
	КомандаПечати.Порядок = 1;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
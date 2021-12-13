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
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

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

#Область СлужебныеПроцедурыИФункции

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылкаУвольнение, СтруктураДополнительныеСвойства) Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	&Организация КАК Организация,
	|	УвольнениеСотрудники.НомерСтроки,
	|	УвольнениеСотрудники.Сотрудник,
	|	ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка) КАК СтруктурнаяЕдиница,
	|	ЗНАЧЕНИЕ(Справочник.Должности.ПустаяСсылка) КАК Должность,
	|	УвольнениеСотрудники.Период,
	|	УвольнениеСотрудники.ОтозватьПравоПодписи КАК ОтозватьПравоПодписи,
	|	УвольнениеСотрудники.Сотрудник.Физлицо КАК ФизическоеЛицо
	|ПОМЕСТИТЬ ТаблицаСотрудники
	|ИЗ
	|	Документ.Увольнение.Сотрудники КАК УвольнениеСотрудники
	|ГДЕ
	|	УвольнениеСотрудники.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСотрудники.Организация,
	|	ТаблицаСотрудники.НомерСтроки,
	|	ТаблицаСотрудники.Сотрудник,
	|	ТаблицаСотрудники.СтруктурнаяЕдиница,
	|	ТаблицаСотрудники.Должность,
	|	ТаблицаСотрудники.Период
	|ИЗ
	|	ТаблицаСотрудники КАК ТаблицаСотрудники
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.Сотрудник,
	|	ВложенныйЗапрос.ВидНачисленияУдержания,
	|	ВложенныйЗапрос.Валюта,
	|	ВложенныйЗапрос.Организация,
	|	ЛОЖЬ КАК Актуальность,
	|	ЗНАЧЕНИЕ(ПланСчетов.Управленческий.ПустаяСсылка) КАК СчетЗатрат,
	|	0 КАК Сумма,
	|	ВложенныйЗапрос.ПериодСтроки КАК Период
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаСотрудники.Сотрудник КАК Сотрудник,
	|		МАКСИМУМ(ПлановыеНачисленияИУдержания.Период) КАК Период,
	|		ПлановыеНачисленияИУдержания.ВидНачисленияУдержания КАК ВидНачисленияУдержания,
	|		ПлановыеНачисленияИУдержания.Валюта КАК Валюта,
	|		ПлановыеНачисленияИУдержания.Организация КАК Организация,
	|		ТаблицаСотрудники.Период КАК ПериодСтроки
	|	ИЗ
	|		ТаблицаСотрудники КАК ТаблицаСотрудники
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПлановыеНачисленияИУдержания КАК ПлановыеНачисленияИУдержания
	|			ПО ТаблицаСотрудники.Сотрудник = ПлановыеНачисленияИУдержания.Сотрудник
	|				И (ПлановыеНачисленияИУдержания.Период <= ТаблицаСотрудники.Период)
	|				И ТаблицаСотрудники.Организация = ПлановыеНачисленияИУдержания.Организация
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ПлановыеНачисленияИУдержания.ВидНачисленияУдержания,
	|		ПлановыеНачисленияИУдержания.Валюта,
	|		ТаблицаСотрудники.Сотрудник,
	|		ТаблицаСотрудники.Период,
	|		ПлановыеНачисленияИУдержания.Организация) КАК ВложенныйЗапрос
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПлановыеНачисленияИУдержания КАК ПлановыеНачисленияИУдержания
	|		ПО ВложенныйЗапрос.Организация = ПлановыеНачисленияИУдержания.Организация
	|			И ВложенныйЗапрос.Сотрудник = ПлановыеНачисленияИУдержания.Сотрудник
	|			И ВложенныйЗапрос.ВидНачисленияУдержания = ПлановыеНачисленияИУдержания.ВидНачисленияУдержания
	|			И ВложенныйЗапрос.Валюта = ПлановыеНачисленияИУдержания.Валюта
	|			И ВложенныйЗапрос.Период = ПлановыеНачисленияИУдержания.Период
	|ГДЕ
	|	ПлановыеНачисленияИУдержания.Актуальность
	|
	|;Выбрать
	|	ПодписиСотрудников.Ссылка КАК ПодписьУвольняемого
	|ИЗ ТаблицаСотрудники КАК ТаблицаСотрудники
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Подписи КАК ПодписиСотрудников
	|	ПО ТаблицаСотрудники.ОтозватьПравоПодписи
	|		И НЕ ПодписиСотрудников.ПравоОтозвано
	|		И ТаблицаСотрудники.ФизическоеЛицо = ПодписиСотрудников.ФизическоеЛицо
	|
	|;Выбрать
	|	ПодписиСотрудниковКомиссии.Ссылка КАК Комиссия
	|ИЗ ТаблицаСотрудники КАК ТаблицаСотрудники
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Комиссии.ПодписиКомиссии КАК ПодписиСотрудниковКомиссии
	|	ПО ТаблицаСотрудники.ОтозватьПравоПодписи
	|		И НЕ ПодписиСотрудниковКомиссии.Ссылка.КомиссияРасформирована
	|		И ТаблицаСотрудники.ФизическоеЛицо = ПодписиСотрудниковКомиссии.ПодписьЧленаКомиссии.ФизическоеЛицо");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаУвольнение);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСотрудники", МассивРезультатов[1].Выгрузить());
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПлановыеНачисленияИУдержания", МассивРезультатов[2].Выгрузить());
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаОтзываемыхПодписей", МассивРезультатов[3].Выгрузить());
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаКомиссийКРасформированию", МассивРезультатов[4].Выгрузить());
	
	СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц = Запрос.МенеджерВременныхТаблиц;
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#КонецОбласти

#Область ИнтерфейсПечати

Процедура СформироватьКадровыйПриказ(ОписаниеПечатнойФормы, МассивОбъектов, ОбъектыПечати) Экспорт
	Перем Ошибки, ПервыйДокумент, НомерСтрокиНачало;
	
	Макет				= УправлениеПечатью.МакетПечатнойФормы(ОписаниеПечатнойФормы.ПолныйПутьКМакету);
	ТабличныйДокумент	= ОписаниеПечатнойФормы.ТабличныйДокумент;
	ДанныеПечати		= Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОбщиеСведенияОбУвольнение.Ссылка
	|	,ОбщиеСведенияОбУвольнение.Номер
	|	,ОбщиеСведенияОбУвольнение.Дата КАК ДатаДокумента
	|	,ОбщиеСведенияОбУвольнение.Организация КАК Организация
	|	,ОбщиеСведенияОбУвольнение.Организация.Префикс КАК Префикс
	|	,ОбщиеСведенияОбУвольнение.Организация.КодПоОКПО КАК КодПоОКПО
	|	,ОбщиеСведенияОбУвольнение.ПодписьРуководителя.Должность КАК ДолжностьРуководителя
	|	,ОбщиеСведенияОбУвольнение.ПодписьРуководителя.РасшифровкаПодписи КАК РуководительРасшифровкаПодписи
	|ИЗ Документ.Увольнение КАК ОбщиеСведенияОбУвольнение
	|ГДЕ ОбщиеСведенияОбУвольнение.Ссылка В(&МассивОбъектов)
	|
	|;Выбрать
	|	СведенияОСотрудниках.Период КАК ДатаУвольнения
	|	,СведенияОСотрудниках.Сотрудник.Наименование КАК Работник
	|	,СведенияОСотрудниках.Сотрудник.Код КАК ТабельныйНомер
	|	,СведенияОСотрудниках.ОснованиеУвольнения КАК ОснованиеУвольнения
	|	,СведенияОСотрудниках.Подразделение КАК Подразделение
	|	,СведенияОСотрудниках.Должность КАК Должность
	|ИЗ Документ.Увольнение.Сотрудники КАК СведенияОСотрудниках
	|ГДЕ СведенияОСотрудниках.Ссылка В(&МассивОбъектов)";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ОбщиеСведенияОПриеме = РезультатЗапроса[0].Выгрузить();
	СведенияОСотрудниках = РезультатЗапроса[1].Выгрузить();
	
	Для каждого ДанныеСотрудника Из СведенияОСотрудниках Цикл
		
		ПечатьДокументовУНФ.ПередНачаломФормированияДокумента(ТабличныйДокумент, ПервыйДокумент, НомерСтрокиНачало, ДанныеПечати);
		
		СведенияОбОрганизации = ПечатьДокументовУНФ.СведенияОЮрФизЛице(ОбщиеСведенияОПриеме[0].Организация, ОбщиеСведенияОПриеме[0].ДатаДокумента, ,);
		ДанныеПечати.Вставить("НазваниеОрганизации", ПечатьДокументовУНФ.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование"));
		ДанныеПечати.Вставить("КодПоОКПО", ОбщиеСведенияОПриеме[0].КодПоОКПО);
		ДанныеПечати.Вставить("НомерДокумента", ПечатьДокументовУНФ.ПолучитьНомерНаПечатьСУчетомДатыДокумента(ОбщиеСведенияОПриеме[0].ДатаДокумента, ОбщиеСведенияОПриеме[0].Номер, ОбщиеСведенияОПриеме[0].Префикс));
		ДанныеПечати.Вставить("ДатаДокумента", ОбщиеСведенияОПриеме[0].ДатаДокумента);
		
		ДатаУвольненияСтрокой = Формат(ДанныеСотрудника.ДатаУвольнения, "ДЛФ=DD");
		ОписаниеУвольнения = НСтр("ru ='уволить ""'") + СокрЛП(Лев(ДатаУвольненияСтрокой, 2)) + """  " + СокрЛП(Прав(ДатаУвольненияСтрокой, СтрДлина(ДатаУвольненияСтрокой) - 2));
		ДанныеПечати.Вставить("Увольнение", ОписаниеУвольнения);
		
		ДанныеПечати.Вставить("Работник", ДанныеСотрудника.Работник);
		ДанныеПечати.Вставить("ТабельныйНомер", ДанныеСотрудника.ТабельныйНомер);
		ДанныеПечати.Вставить("Подразделение", ДанныеСотрудника.Подразделение);
		ДанныеПечати.Вставить("Должность", ДанныеСотрудника.Должность);
		ДанныеПечати.Вставить("СтатьяТКРФ", ДанныеСотрудника.ОснованиеУвольнения);
		ДанныеПечати.Вставить("ДолжностьРуководителя", ОбщиеСведенияОПриеме[0].ДолжностьРуководителя);
		ДанныеПечати.Вставить("РуководительРасшифровкаПодписи", ОбщиеСведенияОПриеме[0].РуководительРасшифровкаПодписи);
		
		Макет.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(Макет);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ОбщиеСведенияОПриеме[0].Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "Приказ_Т8");
	Если ПечатнаяФорма <> Неопределено Тогда
		
		ПечатнаяФорма.ТабличныйДокумент = Новый ТабличныйДокумент;
		ПечатнаяФорма.ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Увольнение_Т8";
		ПечатнаяФорма.ПолныйПутьКМакету = "Документ.Увольнение.ПФ_MXL_Т8";
		ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Т-8 (Приказ об увольнении)'");
		
		СформироватьКадровыйПриказ(ПечатнаяФорма, МассивОбъектов, ОбъектыПечати);
		
	КонецЕсли;
	
	// параметры отправки печатных форм по электронной почте
	ЭлектроннаяПочтаУНФ.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов,
		КоллекцияПечатныхФорм);
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Приказ_Т8";
	КомандаПечати.Представление = НСтр("ru = 'Т-8 (Приказ об увольнении)'");
	КомандаПечати.Порядок = 1;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
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

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Сотрудник)
	|	И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.СведенияОТрудовойДеятельностиРаботникаСТД_Р";
	КомандаПечати.Идентификатор = "ПФ_MXL_СТД_Р";
	КомандаПечати.Представление = НСтр("ru = 'Сведения о трудовой деятельности работника, СТД-Р'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_СТД_Р") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ПФ_MXL_СТД_Р", НСтр("ru = 'Сведения о трудовой деятельности работника, СТД-Р'"),
			ТабличныйДокументСТД_Р(МассивОбъектов, ОбъектыПечати), ,
			"Документ.СведенияОТрудовойДеятельностиРаботникаСТД_Р.ПФ_MXL_СТД_Р");
			
	КонецЕсли;
	
КонецПроцедуры

Функция ТабличныйДокументСТД_Р(МассивОбъектов, ОбъектыПечати)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	ОписаниеИсточникаДанных = ПерсонифицированныйУчет.ОписаниеИсточникаДанныхДляСоздатьВТСведенияОбОрганизациях();
	ОписаниеИсточникаДанных.ИмяТаблицы = "Документ.СведенияОТрудовойДеятельностиРаботникаСТД_Р";
	ОписаниеИсточникаДанных.ИмяПоляОрганизация = "Организация";
	ОписаниеИсточникаДанных.ИмяПоляПериод = "Дата";
	ОписаниеИсточникаДанных.СписокСсылок = МассивОбъектов;

	ПерсонифицированныйУчет.СоздатьВТСведенияОбОрганизацияхПоОписаниюДокументаИсточникаДанных(Запрос.МенеджерВременныхТаблиц, ОписаниеИсточникаДанных);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СведенияОТрудовойДеятельностиРаботникаСТД_Р.Ссылка КАК Ссылка,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_Р.Дата КАК Дата,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_Р.Организация КАК Организация,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_Р.Сотрудник КАК Сотрудник,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_Р.ФизическоеЛицо КАК ФизическоеЛицо,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_Р.Фамилия КАК Фамилия,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_Р.Имя КАК Имя,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_Р.Отчество КАК Отчество,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_Р.ДатаРождения КАК ДатаРождения,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_Р.СтраховойНомерПФР КАК СтраховойНомерПФР,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_Р.ЗаявлениеОПродолженииДата КАК ЗаявлениеОПродолженииДата,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_Р.ЗаявлениеОПредоставленииДата КАК ЗаявлениеОПредоставленииДата,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_Р.РуководительКадровойСлужбы КАК Руководитель,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_Р.ДолжностьРуководителяКадровойСлужбы КАК ДолжностьРуководителяКадровойСлужбы,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_Р.ОснованиеПодписиРуководителяКадровойСлужбы КАК ОснованиеПодписиРуководителяКадровойСлужбы
		|ПОМЕСТИТЬ ВТДанныеДокумента
		|ИЗ
		|	Документ.СведенияОТрудовойДеятельностиРаботникаСТД_Р КАК СведенияОТрудовойДеятельностиРаботникаСТД_Р
		|ГДЕ
		|	СведенияОТрудовойДеятельностиРаботникаСТД_Р.Ссылка В(&МассивОбъектов)";
	
	Запрос.Выполнить();
	
	ИменаПолейОтветственныхЛиц = Новый Массив;
	ИменаПолейОтветственныхЛиц.Добавить("Руководитель");
	УчетСтраховыхВзносов.СоздатьВТФИООтветственныхЛиц(Запрос.МенеджерВременныхТаблиц, Истина, ИменаПолейОтветственныхЛиц, "ВТДанныеДокумента");
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка КАК Ссылка,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.НомерСтроки КАК НомерСтроки,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.ДатаМероприятия КАК ДатаМероприятия,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.ВидМероприятия КАК ВидМероприятия,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.Подразделение КАК Подразделение,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.Должность КАК Должность,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.РазрядКатегория КАК РазрядКатегория,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.ТрудоваяФункция КАК ТрудоваяФункция,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.ТрудоваяФункция.КодПрофессиональнойДеятельности КАК ТрудоваяФункцияКод,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.ОснованиеУвольнения КАК ОснованиеУвольнения,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.ОснованиеУвольнения.Статья КАК ОснованиеУвольненияСтатья,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.ОснованиеУвольнения.Часть КАК ОснованиеУвольненияЧасть,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.ОснованиеУвольнения.Пункт КАК ОснованиеУвольненияПункт,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.ОснованиеУвольнения.Подпункт КАК ОснованиеУвольненияПодпункт,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.НаименованиеДокументаОснования КАК НаименованиеДокументаОснования,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.ДатаДокументаОснования КАК ДатаДокументаОснования,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.НомерДокументаОснования КАК НомерДокументаОснования,
		|	ВЫБОР
		|		КОГДА СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.ОснованиеУвольнения <> НЕОПРЕДЕЛЕНО
		|			ТОГДА ЕСТЬNULL(ПредставленияОснованийУвольнения.ТекстОснования, СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.ОснованиеУвольнения.ТекстОснования)
		|		ИНАЧЕ """"
		|	КОНЕЦ КАК ОснованиеПричиныУвольнения,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.Сведения КАК Сведения,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.КодПоРееструДолжностей КАК КодПоРееструДолжностей,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.СерияДокументаОснования КАК СерияДокументаОснования,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.ДатаС КАК ДатаС,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.ДатаПо КАК ДатаПо,
		|	СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.ДатаОтмены КАК ДатаОтмены,
		|	ДанныеДокумента.Дата КАК Дата,
		|	ДанныеДокумента.Организация КАК Организация,
		|	ДанныеДокумента.Сотрудник КАК Сотрудник,
		|	ДанныеДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ДанныеДокумента.Фамилия КАК Фамилия,
		|	ДанныеДокумента.Имя КАК Имя,
		|	ДанныеДокумента.Отчество КАК Отчество,
		|	ДанныеДокумента.ДатаРождения КАК ДатаРождения,
		|	ДанныеДокумента.СтраховойНомерПФР КАК СтраховойНомерПФР,
		|	ДанныеДокумента.ЗаявлениеОПродолженииДата КАК ЗаявлениеОПродолженииДата,
		|	ДанныеДокумента.ЗаявлениеОПредоставленииДата КАК ЗаявлениеОПредоставленииДата,
		|	СведенияОбОрганизациях.НаименованиеСокращенное КАК ОрганизацияНаименованиеСокращенное,
		|	СведенияОбОрганизациях.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	СведенияОбОрганизациях.КодОрганаПФР КАК РегистрационныйНомерПФР,
		|	СведенияОбОрганизациях.ИНН КАК ИНН,
		|	СведенияОбОрганизациях.КПП КАК КПП,
		|	ДанныеДокумента.Руководитель КАК РуководительКадровойСлужбы,
		|	ДанныеДокумента.Руководитель КАК РуководительКадровойСлужбыРасшифровкаПодписи,
		|	ДанныеДокумента.ДолжностьРуководителяКадровойСлужбы КАК ДолжностьРуководителяКадровойСлужбы,
		|	ДанныеДокумента.ОснованиеПодписиРуководителяКадровойСлужбы КАК ОснованиеПодписиРуководителяКадровойСлужбы,
		|	ВЫБОР
		|		КОГДА СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.ДатаОтмены > ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ""Х""
		|		ИНАЧЕ """"
		|	КОНЕЦ КАК ПризнакОтмены,
		|	0 КАК НомерСтрокиСотрудника,
		|	ЗНАЧЕНИЕ(Справочник.КлассификаторЗанятий.ПустаяСсылка) КАК КодПоОКЗ
		|ИЗ
		|	ВТДанныеДокумента КАК ДанныеДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СведенияОТрудовойДеятельностиРаботникаСТД_Р.Мероприятия КАК СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПредставленияОснованийУвольнения КАК ПредставленияОснованийУвольнения
		|			ПО СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.ОснованиеУвольнения = ПредставленияОснованийУвольнения.Объект
		|		ПО ДанныеДокумента.Ссылка = СведенияОТрудовойДеятельностиРаботникаСТД_РМероприятия.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСведенияОбОрганизациях КАК СведенияОбОрганизациях
		|		ПО ДанныеДокумента.Организация = СведенияОбОрганизациях.Организация
		|			И ДанныеДокумента.Дата = СведенияОбОрганизациях.Период
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка,
		|	НомерСтроки";
	
	ДокументРезультат = Новый ТабличныйДокумент;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат ЭлектронныеТрудовыеКнижки.ВывестиМакетыДокументов(ДокументРезультат, Выборка, "Документ.СведенияОТрудовойДеятельностиРаботникаСТД_Р.ПФ_MXL_СТД_Р", ОбъектыПечати);
	
КонецФункции

Процедура ЗаполнитьДокумент(ОбъектДокумента) Экспорт
	
	Если ЗначениеЗаполнено(ОбъектДокумента.Сотрудник) Тогда
		
		ДанныеСотрудника = ЭлектронныеТрудовыеКнижки.ДанныеТрудовойДеятельностиСотрудника(Истина,ОбъектДокумента.Ссылка, ОбъектДокумента.Сотрудник, ОбъектДокумента.Организация);
		Если ДанныеСотрудника <> Неопределено Тогда
			
			ЗаполнитьЗначенияСвойств(ОбъектДокумента, ДанныеСотрудника, , "Сотрудник");
			Для Каждого ЗаписьТрудовойДеятельности Из ДанныеСотрудника.ТрудоваяДеятельность Цикл
				ЗаполнитьЗначенияСвойств(ОбъектДокумента.Мероприятия.Добавить(), ЗаписьТрудовойДеятельности);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

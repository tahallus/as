﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		
		ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения, , Истина);
		Документы.СведенияОТрудовойДеятельностиРаботникаСТД_Р.ЗаполнитьДокумент(ЭтотОбъект);
		
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Увольнение") Тогда
		
		ДанныеУвольнения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "Организация, Сотрудник");
		Организация = ДанныеУвольнения["Организация"];
		Сотрудник = ДанныеУвольнения["Сотрудник"];
		
		Документы.СведенияОТрудовойДеятельностиРаботникаСТД_Р.ЗаполнитьДокумент(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПерсонифицированныйУчет.ПроверитьДанныеОрганизации(ЭтотОбъект, Организация, Отказ, КонецМесяца(Дата));
	
	Если ЗначениеЗаполнено(СтраховойНомерПФР) Тогда 
		ТекстСообщения = "";
		Если Не РегламентированныеДанныеКлиентСервер.СтраховойНомерПФРСоответствуетТребованиям(СтраховойНомерПФР, ТекстСообщения) Тогда 
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "Объект.СтраховойНомерПФР" , , Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьОбязательныеПоля(Отказ) Экспорт
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не указана организация.'"), ЭтотОбъект, "Организация", "Объект", Отказ);	
		Возврат;
	КонецЕсли;
	
	ДанныеОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, "РегистрационныйНомерПФР, КодОрганаПФР");

	Если Не ЗначениеЗаполнено(ДанныеОрганизации.РегистрационныйНомерПФР) Тогда
		ТекстСообщения = НСтр("ru = 'У организации не заполнен регистрационный номер ПФР.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Организация, "РегистрационныйНомерПФР", , Отказ);
	ИначеЕсли СтрДлина(ДанныеОрганизации.РегистрационныйНомерПФР) <> 14 Тогда
		ТекстСообщения = НСтр("ru = 'У организации не верно заполнен регистрационный номер ПФР.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Организация, "РегистрационныйНомерПФР", , Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДанныеОрганизации.КодОрганаПФР) Тогда
		ТекстСообщения = НСтр("ru = 'У организации не заполнен код органа ПФР '");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Организация, "КодОрганаПФР", , Отказ);
	КонецЕсли;
	
КонецПроцедуры	

// Заполняет документ по основанию сотрудник, осуществляет проверку корректности ввода документа.
// В случае , когда проверка не проходит вызывает исключение.
//
// Параметры:
//		ДокументОбъект - ДокументОбъект
//		ДанныеЗаполнения - СправочникСсылка.Сотрудники
//		ПроверкаОформленностиНаРаботу 	- Булево, когда Истина вызывает исключение, если сотрудник уже принят на работу,
//											Ложь - если сотрудник еще не принят.
//		ОтключитьПроверкуЗанятости 		- Булево, отключает проверку принятости сотрудника.
//		ТолькоГоловнаяОрганизация		- Булево, указывает, что организация может быть только головной.
//
// Возвращаемое значение - Булево, Истина - ДанныеЗаполнения заполнен имеют тип СправочникСсылка.Сотрудники, Ложь -
//   если  ДанныеЗаполнения содержат значение другого типа.
//
Процедура ЗаполнитьПоОснованиюСотрудником(ДокументОбъект, ДанныеЗаполнения, ПроверкаОформленностиНаРаботу = Ложь, ОтключитьПроверкуЗанятости = Ложь, ТолькоГоловнаяОрганизация = Ложь)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Описатель = Справочники.Сотрудники.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
		Запрос.МенеджерВременныхТаблиц, "ВТСотрудники");
	
	Описатель.ИмяВТКадровыеДанныеСотрудников = "ВТСотрудники";
	
	КадровыеДанныеПриема = "Организация,ФизическоеЛицо,ДатаПриема";
	
	УчетСтраховыхВзносов.СоздатьВТКадровыеДанныеСотрудников(Описатель, Истина, КадровыеДанныеПриема);
	Запрос.Текст = "ВЫБРАТЬ * ИЗ ВТСотрудники КАК ВТСотрудники ГДЕ ВТСотрудники.Сотрудник В(&МассивСотрудников)";
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		МассивСотрудников = Новый Массив;
		МассивСотрудников.Добавить(ДанныеЗаполнения);
	Иначе
		МассивСотрудников = ДанныеЗаполнения;
	КонецЕсли;
	Запрос.УстановитьПараметр("МассивСотрудников", МассивСотрудников);
	
	КадровыеДанные = Запрос.Выполнить().Выгрузить();
	
	Если КадровыеДанные.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
		
	СтрокаДанных = КадровыеДанные[0];
	
	Если НЕ ОтключитьПроверкуЗанятости Тогда
		
		Если ПроверкаОформленностиНаРаботу Тогда
			
			Если ЗначениеЗаполнено(СтрокаДанных.ДатаПриема) Тогда
				
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Сотрудник ""%1"" уже оформлен на работу с %2'"),
					ДанныеЗаполнения,
					Формат(СтрокаДанных.ДатаПриема, "ДЛФ=DD"));
				
			Иначе
					
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Сотрудник ""%1"" уже оформлен на работу'"),
					ДанныеЗаполнения);
				
			КонецЕсли;
			
		Иначе
			
			Если НЕ ЗначениеЗаполнено(СтрокаДанных.Организация) Тогда
				
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Сотрудник ""%1"" не оформлен на работу'"),
					ДанныеЗаполнения);
				
			КонецЕсли;
				
		КонецЕсли;
		
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(СтрокаДанных.Организация)  Тогда
		ДокументОбъект.Организация = СтрокаДанных.Организация;
	КонецЕсли;
	
	МетаданныеДокумента = ДокументОбъект.Метаданные();
	
	РеквизитСотрудник = МетаданныеДокумента.Реквизиты.Найти("Сотрудник");
	Если РеквизитСотрудник <> Неопределено Тогда
		
		Если РеквизитСотрудник.Тип.СодержитТип(Тип("СправочникСсылка.ФизическиеЛица")) Тогда
			ДокументОбъект.Сотрудник 		= СтрокаДанных.ФизическоеЛицо;
		Иначе
			ДокументОбъект.Сотрудник 		= СтрокаДанных.Сотрудник;
		КонецЕсли;
		
	КонецЕсли; 
	
	Если МетаданныеДокумента.Реквизиты.Найти("ФизическоеЛицо") <> Неопределено Тогда
		
		ДокументОбъект.ФизическоеЛицо 	= СтрокаДанных.ФизическоеЛицо;
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОкончаниеОтчетногоПериода = КонецМесяца(ОтчетныйПериод);

	Если Не ЗначениеЗаполнено(ИмяФайлаДляПФР) Тогда
		ИмяФайлаДляПФР = Документы.СведенияОЗастрахованныхЛицахСЗВ_М.ИмяФайла(Организация, Дата);
	КонецЕсли;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	ИмяФайлаДляПФР = "";
	ДокументПринятВПФР = Ложь;
	ФайлСформирован = Ложь;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьДанныеДокумента(Отказ) Экспорт
	Если Не ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ВыборкаДляПроверки = ВыбораДанныхФизическихЛицДляПроверки();
	
	Пока ВыборкаДляПроверки.Следующий() Цикл
		Если Не ЗначениеЗаполнено(ВыборкаДляПроверки.Сотрудник) Тогда
			Продолжить;
		КонецЕсли;
		
		ПутьКДаннымСтроки = "Сотрудники[" + Формат(ВыборкаДляПроверки.НомерСтроки - 1, "ЧГ=") + "]"; 
		
		ТекстСообщения = "";
		Если Не РегламентированныеДанныеКлиентСервер.СтраховойНомерПФРСоответствуетТребованиям(
			ВыборкаДляПроверки.СтраховойНомерПФР, ТекстСообщения) Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сотрудник %1: %2'"), ВыборкаДляПроверки.Наименование, ТекстСообщения);

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, ПутьКДаннымСтроки
				+ ".СтраховойНомерПФР", "Объект", Отказ);
		КонецЕсли;
		
		Если ВыборкаДляПроверки.ЕстьДубль Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сотрудник %1 был введен в документе ранее'"), ВыборкаДляПроверки.Наименование);

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, ПутьКДаннымСтроки
				+ ".Сотрудник", "Объект", Отказ);
		КонецЕсли;
		
		Если Не ВыборкаДляПроверки.РаботаетВОрганизации И Не ТипФормы = Перечисления.ТипыСведенийСЗВ_М.Отменяющая Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сотрудник %1 не работает в организации'"),
				ВыборкаДляПроверки.Наименование);	
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, ПутьКДаннымСтроки
				+ ".Сотрудник", "Объект", Отказ);
		КонецЕсли;
				
		Если ВыборкаДляПроверки.ЯвляетсяВоеннослужащим И Не ТипФормы = Перечисления.ТипыСведенийСЗВ_М.Отменяющая Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сотрудник %1 не должен включаться в СВЗ-М, т.к. является военнослужащим'"),
				ВыборкаДляПроверки.Наименование);

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, ПутьКДаннымСтроки
				+ ".Сотрудник", "Объект", Отказ);
		КонецЕсли;
		
		Если ВыборкаДляПроверки.РаботаетВСтуденческомОтряде И Не ТипФормы = Перечисления.ТипыСведенийСЗВ_М.Отменяющая Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сотрудник %1 не должен включаться в СВЗ-М, т.к. работает в студенческом отряде'"),
				ВыборкаДляПроверки.Наименование);

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, ПутьКДаннымСтроки
				+ ".Сотрудник", "Объект", Отказ);
		КонецЕсли;
		
	КонецЦикла;
КонецПроцедуры

Функция ВыбораДанныхФизическихЛицДляПроверки()
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СписокФизичесихЛиц = Сотрудники.ВыгрузитьКолонку("Сотрудник");
	
	Документы.СведенияОЗастрахованныхЛицахСЗВ_М.СоздатьВТФизическиеЛицаОрганизации(Запрос.МенеджерВременныхТаблиц, ЭтотОбъект, СписокФизичесихЛиц);
	
	Запрос.УстановитьПараметр("ТаблицаСотрудники", Сотрудники);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СведенияОЗастрахованныхЛицахСЗВ_МСотрудники.Сотрудник,
	|	СведенияОЗастрахованныхЛицахСЗВ_МСотрудники.Фамилия,
	|	СведенияОЗастрахованныхЛицахСЗВ_МСотрудники.Имя,
	|	СведенияОЗастрахованныхЛицахСЗВ_МСотрудники.Отчество,
	|	СведенияОЗастрахованныхЛицахСЗВ_МСотрудники.ИНН,
	|	СведенияОЗастрахованныхЛицахСЗВ_МСотрудники.СтраховойНомерПФР,
	|	СведенияОЗастрахованныхЛицахСЗВ_МСотрудники.НомерСтроки
	|ПОМЕСТИТЬ ВТСотрудники
	|ИЗ
	|	&ТаблицаСотрудники КАК СведенияОЗастрахованныхЛицахСЗВ_МСотрудники
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Сотрудники.НомерСтроки
	|ПОМЕСТИТЬ ВТДублиСтрок
	|ИЗ
	|	ВТСотрудники КАК Сотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСотрудники КАК СотрудникиДубль
	|		ПО Сотрудники.Сотрудник = СотрудникиДубль.Сотрудник
	|			И Сотрудники.НомерСтроки > СотрудникиДубль.НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Сотрудники.Сотрудник,
	|	Сотрудники.Фамилия,
	|	Сотрудники.Имя,
	|	Сотрудники.Отчество,
	|	Сотрудники.ИНН,
	|	Сотрудники.СтраховойНомерПФР,
	|	Сотрудники.НомерСтроки КАК НомерСтроки,
	|	ВЫБОР
	|		КОГДА ДублиСтрок.НомерСтроки ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ЕстьДубль,
	|	ЕСТЬNULL(ФизическиеЛицаОрганизации.ЯвляетсяПрокурором, ЛОЖЬ) КАК ЯвляетсяПрокурором,
	|	ЕСТЬNULL(ФизическиеЛицаОрганизации.ЯвляетсяВоеннослужащим, ЛОЖЬ) КАК ЯвляетсяВоеннослужащим,
	|	ЕСТЬNULL(ФизическиеЛицаОрганизации.РаботаетВСтуденческомОтряде, ЛОЖЬ) КАК РаботаетВСтуденческомОтряде,
	|	ВЫБОР
	|		КОГДА ФизическиеЛицаОрганизации.ФизическоеЛицо ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК РаботаетВОрганизации,
	|	ФизическиеЛица.Наименование
	|ИЗ
	|	ВТСотрудники КАК Сотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДублиСтрок КАК ДублиСтрок
	|		ПО Сотрудники.НомерСтроки = ДублиСтрок.НомерСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФизическиеЛицаОрганизации КАК ФизическиеЛицаОрганизации
	|		ПО Сотрудники.Сотрудник = ФизическиеЛицаОрганизации.ФизическоеЛицо
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК ФизическиеЛица
	|		ПО Сотрудники.Сотрудник = ФизическиеЛица.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Возврат Запрос.Выполнить().Выбрать();	
КонецФункции	

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область Служебные

Процедура НачальноеСальдоПоДоговорам()
	
	МассивДоговорыКонтрагентов = ДоговорыКонтрагентов.Выгрузить(,"Договор");
	
	Если НЕ ЗначениеЗаполнено(НачалоПериода) Тогда
		
		НачалоПериода = Дата(1980, 01, 01);
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Константы.УчетПоКомпании.Компания(Организация));
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("ДоговорыКонтрагентов", МассивДоговорыКонтрагентов);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДоговорыКонтрагентов.Ссылка КАК Договор
	|ПОМЕСТИТЬ ДоговорыКонтрагентов
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|ГДЕ
	|	ДоговорыКонтрагентов.Ссылка В(&ДоговорыКонтрагентов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА РасчетыСПоставщикамиОстатки.СуммаВалОстаток > 0
	|				И РасчетыСПокупателямиОстатки.СуммаВалОстаток < 0
	|			ТОГДА -1 * РасчетыСПокупателямиОстатки.СуммаВалОстаток + РасчетыСПоставщикамиОстатки.СуммаВалОстаток
	|		КОГДА РасчетыСПоставщикамиОстатки.СуммаВалОстаток > 0
	|			ТОГДА РасчетыСПоставщикамиОстатки.СуммаВалОстаток
	|		КОГДА РасчетыСПокупателямиОстатки.СуммаВалОстаток < 0
	|			ТОГДА -РасчетыСПокупателямиОстатки.СуммаВалОстаток
	|		ИНАЧЕ 0
	|	КОНЕЦ - ВЫБОР
	|		КОГДА РасчетыСПоставщикамиОстатки.СуммаВалОстаток < 0
	|				И РасчетыСПокупателямиОстатки.СуммаВалОстаток > 0
	|			ТОГДА -1 * РасчетыСПоставщикамиОстатки.СуммаВалОстаток + РасчетыСПокупателямиОстатки.СуммаВалОстаток
	|		КОГДА РасчетыСПоставщикамиОстатки.СуммаВалОстаток < 0
	|			ТОГДА -РасчетыСПоставщикамиОстатки.СуммаВалОстаток
	|		КОГДА РасчетыСПокупателямиОстатки.СуммаВалОстаток > 0
	|			ТОГДА РасчетыСПокупателямиОстатки.СуммаВалОстаток
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Сальдо,
	|	ДоговорыКонтрагентов.Договор.ВалютаРасчетов КАК ВалютыРасчетов
	|ИЗ
	|	ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСПокупателями.Остатки(&НачалоПериода, Организация = &Организация) КАК РасчетыСПокупателямиОстатки
	|		ПО ДоговорыКонтрагентов.Договор = РасчетыСПокупателямиОстатки.Договор
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСПоставщиками.Остатки(&НачалоПериода, Организация = &Организация) КАК РасчетыСПоставщикамиОстатки
	|		ПО ДоговорыКонтрагентов.Договор = РасчетыСПоставщикамиОстатки.Договор";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл 
		
		СальдоПоДоговору = 0;
		
		Если Выборка.ВалютыРасчетов <> ВалютаДокумента Тогда
			
			КурсВалютыРасчетов = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Выборка.ВалютыРасчетов, НачалоПериода);
			КурсВалютыДокумента = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, НачалоПериода);
			
			Если Выборка.Сальдо <> 0 Тогда
				
				ПараметрыТекущегоКурса = Новый Структура;
				ПараметрыТекущегоКурса.Вставить("Валюта",	Выборка.ВалютыРасчетов);
				ПараметрыТекущегоКурса.Вставить("Курс",		КурсВалютыРасчетов.Курс);
				ПараметрыТекущегоКурса.Вставить("Кратность",КурсВалютыРасчетов.Кратность);
				
				ПараметрыНовогоКурса = Новый Структура;
				ПараметрыНовогоКурса.Вставить("Валюта",		ВалютаДокумента);
				ПараметрыНовогоКурса.Вставить("Курс",		КурсВалютыДокумента.Курс);
				ПараметрыНовогоКурса.Вставить("Кратность",	КурсВалютыДокумента.Кратность);
				
				СальдоПоДоговору = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(Выборка.Сальдо, ПараметрыТекущегоКурса, ПараметрыНовогоКурса);
				
			КонецЕсли;
			
		Иначе
			
			СальдоПоДоговору = Выборка.Сальдо;
			
		КонецЕсли;
		
		СальдоНачалоПериода = СальдоНачалоПериода + СальдоПоДоговору;
		
	КонецЦикла;
	
КонецПроцедуры // НачальноеСальдоПоДоговорам()

Процедура ЗаполнитьДанныеКонтрагента()
	
	ЗаполнитьДанные = Истина;
	Если ДоговорыКонтрагентов.Количество() > 0 Тогда
		
		Если ДоговорыКонтрагентов[0].Договор.Владелец = Контрагент Тогда
			
			ЗаполнитьДанные = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗаполнитьДанные Тогда
		
		ПредставительКонтрагента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "КонтактноеЛицоПодписант");
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Контрагент", Контрагент);
		
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ИСТИНА КАК Отметка
		|	,СправочникДоговорыКонтрагентов.Ссылка КАК Договор
		|	,СправочникДоговорыКонтрагентов.ВалютаРасчетов КАК ВалютаДоговора
		|ИЗ Справочник.ДоговорыКонтрагентов КАК СправочникДоговорыКонтрагентов
		|ГДЕ СправочникДоговорыКонтрагентов.Владелец = &Контрагент";
		
		ДоговорыКонтрагентов.Загрузить(Запрос.Выполнить().Выгрузить());
		
		НачальноеСальдоПоДоговорам();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события "ПриКопировании".
//
Процедура ПриКопировании(ОбъектКопирования)
	
	// Очистим табличную часть документа.
	Если ДанныеКонтрагента.Количество() > 0 Тогда
		ДанныеКонтрагента.Очистить();
	КонецЕсли;
	
	Статус = Перечисления.СтатусыСверокВзаиморасчетов.Создана;
	
КонецПроцедуры // ПриКопировании()

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	КонецПериода = ТекущаяДатаСеанса();
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		
		ЗаполнитьДанныеКонтрагента();
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаЗаполнения()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
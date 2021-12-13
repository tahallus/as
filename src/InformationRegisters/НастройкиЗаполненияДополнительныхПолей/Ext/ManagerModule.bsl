﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура УдалитьНастройкуЗаполненияПолей(Отправитель, Получатель, Договор, ВидЭлектронногоДокумента, Формат) Экспорт
	
	Если Не ЗначениеЗаполнено(Отправитель)
		ИЛИ Не ЗначениеЗаполнено(Получатель)
		ИЛИ Не ЗначениеЗаполнено(ВидЭлектронногоДокумента)
		ИЛИ Не ЗначениеЗаполнено(Формат) Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.НастройкиЗаполненияДополнительныхПолей.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Отправитель.Установить(Отправитель);
	НаборЗаписей.Отбор.Получатель.Установить(Получатель);
	НаборЗаписей.Отбор.Договор.Установить(Договор);
	НаборЗаписей.Отбор.ВидЭлектронногоДокумента.Установить(ВидЭлектронногоДокумента);
	НаборЗаписей.Отбор.Формат.Установить(Формат);
	НаборЗаписей.Записать();
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ОбновлениеВерсииИБ

// Регистрирует данные для обработчика обновления
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.НастройкиЗаполненияДополнительныхПолей;
	ПолноеИмяРегистра = МетаданныеОбъекта.ПолноеИмя();
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.СпособВыборки        = ОбновлениеИнформационнойБазы.СпособВыборкиИзмеренияНезависимогоРегистраСведений();
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	
	// Переход на новую архитектуру настроек ЭДО.
	// 1. Заполнение новых измерений: Отправитель, Получатель, Договор
	// 2. Конвертация идентификатора формата.
	// 3. Конвертация видов ЭД (УПД и УКД).
	// 4. Заполнение вида документа значением СправочникСсылка.ВидыДокументовЭДО.
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НастройкиЗаполненияДополнительныхПолей.УдалитьФормат,
	|	НастройкиЗаполненияДополнительныхПолей.УдалитьНастройкаЭДО,
	|	НастройкиЗаполненияДополнительныхПолей.УдалитьВидЭлектронногоДокумента
	|ИЗ
	|	РегистрСведений.НастройкиЗаполненияДополнительныхПолей КАК НастройкиЗаполненияДополнительныхПолей
	|ГДЕ
	|	(НастройкиЗаполненияДополнительныхПолей.Отправитель = &ПустойОтправитель
	|	И НастройкиЗаполненияДополнительныхПолей.Получатель = &ПустойПолучатель
	|	И НастройкиЗаполненияДополнительныхПолей.Договор = &ПустойДоговор
	|	И НастройкиЗаполненияДополнительныхПолей.УдалитьНастройкаЭДО <> &ПустаяНастройка
	|	И НастройкиЗаполненияДополнительныхПолей.Формат = """"
	|	И НастройкиЗаполненияДополнительныхПолей.УдалитьФормат <> """")
	|	ИЛИ
	|		(НастройкиЗаполненияДополнительныхПолей.ВидЭлектронногоДокумента = ЗНАЧЕНИЕ(Справочник.ВидыДокументовЭДО.ПустаяСсылка)
	|	И
	|		НастройкиЗаполненияДополнительныхПолей.УдалитьВидЭлектронногоДокумента <> ЗНАЧЕНИЕ(Перечисление.ТипыДокументовЭДО.ПустаяСсылка))";
	
	Измерения = Метаданные.РегистрыСведений.НастройкиЗаполненияДополнительныхПолей.Измерения;
	
	Запрос.УстановитьПараметр("ПустойОтправитель", Измерения.Отправитель.Тип.ПривестиЗначение());
	Запрос.УстановитьПараметр("ПустойПолучатель", Измерения.Получатель.Тип.ПривестиЗначение());
	Запрос.УстановитьПараметр("ПустойДоговор", Измерения.Договор.Тип.ПривестиЗначение());
	Запрос.УстановитьПараметр("ПустаяНастройка", Измерения.УдалитьНастройкаЭДО.Тип.ПривестиЗначение());
	
	Данные = Запрос.Выполнить().Выгрузить();
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Данные, ДополнительныеПараметры);
	
КонецПроцедуры

// Обработчик обновления.
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ИнициализироватьПараметрыОбработкиДляПереходаНаНовуюВерсию(Параметры);
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.НастройкиЗаполненияДополнительныхПолей;
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
	
	ПараметрыОтметкиВыполнения = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ПараметрыОтметкиВыполнения.ЭтоДвижения = Ложь;
	ПараметрыОтметкиВыполнения.ПолноеИмяРегистра = ПолноеИмяОбъекта;
	ПараметрыОтметкиВыполнения.ОтметитьВсеРегистраторы = Ложь;
	ПараметрыОтметкиВыполнения.ЭтоНезависимыйРегистрСведений = Истина;
	
	Если ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Неопределено, "Справочник.ВидыДокументовЭДО") Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
			Параметры.Очередь, ПолноеИмяОбъекта);
		Возврат;
	КонецЕсли;
	
	ОбработанныхОбъектов = 0;
	ПроблемныхОбъектов = 0;
	
	ВыбранныеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Если ВыбранныеДанные.Количество() Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	УдалитьСоглашенияОбИспользованииЭД.Ссылка КАК НастройкаЭДО,
		|	УдалитьСоглашенияОбИспользованииЭД.Организация КАК Организация,
		|	УдалитьСоглашенияОбИспользованииЭД.Контрагент КАК Контрагент,
		|	УдалитьСоглашенияОбИспользованииЭД.ДоговорКонтрагента КАК Договор,
		|	УдалитьСоглашенияОбИспользованииЭД.ИспользоватьУПД КАК ИспользоватьУПД,
		|	УдалитьСоглашенияОбИспользованииЭД.ИспользоватьУКД КАК ИспользоватьУКД
		|ИЗ
		|	Справочник.УдалитьСоглашенияОбИспользованииЭД КАК УдалитьСоглашенияОбИспользованииЭД
		|ГДЕ
		|	УдалитьСоглашенияОбИспользованииЭД.Ссылка В (&Настройки)";
		
		Запрос.УстановитьПараметр("Настройки", ВыбранныеДанные.ВыгрузитьКолонку("УдалитьНастройкаЭДО"));
		Выборка = Запрос.Выполнить().Выбрать();
		РеквизитыНастроек = Новый Соответствие;
		Пока Выборка.Следующий() Цикл
			РеквизитыНастройки = Новый Структура("Организация,Контрагент,Договор,ИспользоватьУПД,ИспользоватьУКД");
			ЗаполнитьЗначенияСвойств(РеквизитыНастройки, Выборка);
			РеквизитыНастроек.Вставить(Выборка.НастройкаЭДО, РеквизитыНастройки);
		КонецЦикла;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВыбранныеДанные.УдалитьФормат КАК УдалитьФормат,
		|	ВыбранныеДанные.УдалитьНастройкаЭДО КАК УдалитьНастройкаЭДО,
		|	ВыбранныеДанные.УдалитьВидЭлектронногоДокумента КАК УдалитьВидЭлектронногоДокумента
		|ПОМЕСТИТЬ ВыбранныеДанные
		|ИЗ
		|	&ВыбранныеДанные КАК ВыбранныеДанные
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НастройкиЗаполненияДополнительныхПолей.Получатель КАК Получатель,
		|	НастройкиЗаполненияДополнительныхПолей.Отправитель КАК Отправитель,
		|	НастройкиЗаполненияДополнительныхПолей.Договор КАК Договор
		|ПОМЕСТИТЬ НастройкиЗаполненияДополнительныхПолей
		|ИЗ
		|	ВыбранныеДанные КАК ВыбранныеДанные
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиЗаполненияДополнительныхПолей КАК НастройкиЗаполненияДополнительныхПолей
		|		ПО ВыбранныеДанные.УдалитьФормат = НастройкиЗаполненияДополнительныхПолей.УдалитьФормат
		|			И ВыбранныеДанные.УдалитьНастройкаЭДО = НастройкиЗаполненияДополнительныхПолей.УдалитьНастройкаЭДО
		|			И ВыбранныеДанные.УдалитьВидЭлектронногоДокумента = НастройкиЗаполненияДополнительныхПолей.УдалитьВидЭлектронногоДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НастройкиЗаполненияДополнительныхПолей.Отправитель КАК Отправитель,
		|	НастройкиЗаполненияДополнительныхПолей.Получатель КАК Получатель,
		|	НастройкиЗаполненияДополнительныхПолей.Договор КАК Договор,
		|	ЕСТЬNULL(НастройкиОтправкиЭлектронныхДокументов.ИспользоватьУПД, ЛОЖЬ) КАК ИспользоватьУПД,
		|	ЕСТЬNULL(НастройкиОтправкиЭлектронныхДокументов.ИспользоватьУКД, ЛОЖЬ) КАК ИспользоватьУКД
		|ИЗ
		|	НастройкиЗаполненияДополнительныхПолей КАК НастройкиЗаполненияДополнительныхПолей
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиОтправкиЭлектронныхДокументов КАК НастройкиОтправкиЭлектронныхДокументов
		|		ПО НастройкиЗаполненияДополнительныхПолей.Отправитель = НастройкиОтправкиЭлектронныхДокументов.Отправитель
		|			И НастройкиЗаполненияДополнительныхПолей.Получатель = НастройкиОтправкиЭлектронныхДокументов.Получатель
		|			И НастройкиЗаполненияДополнительныхПолей.Договор = НастройкиОтправкиЭлектронныхДокументов.Договор";
		
		Запрос.УстановитьПараметр("ВыбранныеДанные", ВыбранныеДанные);
		НастройкиОтправки = Запрос.Выполнить().Выгрузить();
		
		СоответствиеФорматов = НастройкиЭДО.СоответствиеСтарыхФорматовНовым();
		
		СоответствиеВидовДокументов = ОбменСКонтрагентамиИнтеграция.СоответствиеВидовЭДВидамДокументовЭДО();
		
		Для Каждого СтрокаДанных Из ВыбранныеДанные Цикл
			
			РеквизитыНастройки = РеквизитыНастроек[СтрокаДанных.УдалитьНастройкаЭДО];
			
			НачатьТранзакцию();
			Попытка
				
				Блокировка = Новый БлокировкаДанных;
				ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
				ЭлементБлокировки.УстановитьЗначение("УдалитьФормат", СтрокаДанных.УдалитьФормат);
				ЭлементБлокировки.УстановитьЗначение("УдалитьНастройкаЭДО", СтрокаДанных.УдалитьНастройкаЭДО);
				ЭлементБлокировки.УстановитьЗначение("УдалитьВидЭлектронногоДокумента", СтрокаДанных.УдалитьВидЭлектронногоДокумента);
				ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
				Блокировка.Заблокировать();
				
				Записать = Ложь;
				
				Набор = РегистрыСведений.НастройкиЗаполненияДополнительныхПолей.СоздатьНаборЗаписей();
				Набор.Отбор.УдалитьФормат.Установить(СтрокаДанных.УдалитьФормат);
				Набор.Отбор.УдалитьНастройкаЭДО.Установить(СтрокаДанных.УдалитьНастройкаЭДО);
				Набор.Отбор.УдалитьВидЭлектронногоДокумента.Установить(СтрокаДанных.УдалитьВидЭлектронногоДокумента);
				
				Набор.Прочитать();
				
				ОбработатьДанные_НоваяАрхитектураНастроекЭДО(Набор, РеквизитыНастройки, НастройкиОтправки,
					СоответствиеФорматов, СоответствиеВидовДокументов, Записать);
				
				Если Записать Тогда
					ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(Набор);
				Иначе
					ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Набор, ПараметрыОтметкиВыполнения);
				КонецЕсли;
				
				ОбработанныхОбъектов = ОбработанныхОбъектов + 1;
				
				ЗафиксироватьТранзакцию();
				
			Исключение
				
				ОтменитьТранзакцию();
				ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
				ТекстСообщения = НСтр("ru = 'Не удалось обработать настройки заполнения дополнительных полей по причине:'") + Символы.ПС
					+ ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
					МетаданныеОбъекта,, ТекстСообщения);
				
			КонецПопытки;
			
		КонецЦикла;
	
	КонецЕсли;
	
	Если ОбработанныхОбъектов = 0 И ПроблемныхОбъектов <> 0 Тогда
		ШаблонСообщения = НСтр("ru = 'Не удалось обработать некоторые настройки заполнения дополнительных полей (пропущены): %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ШаблонСообщения = НСтр("ru = 'Обработана очередная порция настроек заполнения дополнительных полей: %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ОбработанныхОбъектов);
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			МетаданныеОбъекта,, ТекстСообщения);
	КонецЕсли;
	
	Параметры.ПрогрессВыполнения.ОбработаноОбъектов  = Параметры.ПрогрессВыполнения.ОбработаноОбъектов + ОбработанныхОбъектов;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Обновление

Процедура ИнициализироватьПараметрыОбработкиДляПереходаНаНовуюВерсию(Параметры)
	
	// Определим общее количество объектов к обработке.
	Если Параметры.ПрогрессВыполнения.ВсегоОбъектов = 0 Тогда
		
		ПараметрыВыборки = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыВыборкиДанныхДляОбработки();
		ПараметрыВыборки.ВыбиратьПорциями = Ложь;
		Выборка = ОбновлениеИнформационнойБазы.ВыбратьИзмеренияНезависимогоРегистраСведенийДляОбработки(
			Параметры.Очередь, "РегистрСведений.НастройкиЗаполненияДополнительныхПолей", ПараметрыВыборки);
		Параметры.ПрогрессВыполнения.ВсегоОбъектов = Выборка.Количество();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьДанные_НоваяАрхитектураНастроекЭДО(Набор, РеквизитыНастройки, НастройкиОтправки,
	СоответствиеФорматов, СоответствиеВидовДокументов, Записать)
	
	ТипыДокументов = Новый Массив;
	Для каждого Запись Из Набор Цикл
		Если ТипыДокументов.Найти(Запись.УдалитьВидЭлектронногоДокумента) = Неопределено Тогда
			ТипыДокументов.Добавить(Запись.УдалитьВидЭлектронногоДокумента);
		КонецЕсли;
	КонецЦикла;
	
	ВидыДокументовЗаменяемыеУПДУКД = ЭлектронныеДокументыЭДО.ВидыДокументовЗаменяемыеУПДУКД();
	ВидДокументаУПД = ВидыДокументовЗаменяемыеУПДУКД.УПД.ВидДокумента;
	ВидДокументаУКД = ВидыДокументовЗаменяемыеУПДУКД.УКД.ВидДокумента;
	
	Для каждого Запись Из Набор Цикл
		
		Если (Не ЗначениеЗаполнено(Запись.Отправитель)
			И Не ЗначениеЗаполнено(Запись.Получатель)
			И Не ЗначениеЗаполнено(Запись.Договор)
			И Не ЗначениеЗаполнено(Запись.Формат)
			И ЗначениеЗаполнено(Запись.УдалитьФормат)
			И ЗначениеЗаполнено(Запись.УдалитьНастройкаЭДО))
			Или (Не ЗначениеЗаполнено(Запись.ВидЭлектронногоДокумента)
				И ЗначениеЗаполнено(Запись.УдалитьВидЭлектронногоДокумента)) Тогда
			
			Если ЗначениеЗаполнено(Запись.УдалитьНастройкаЭДО) Тогда
				Запись.Отправитель = РеквизитыНастройки.Организация;
				Запись.Получатель = РеквизитыНастройки.Контрагент;
				Запись.Договор = РеквизитыНастройки.Договор;
				
				КлючФормата = Строка(Запись.УдалитьВидЭлектронногоДокумента) + "_" + Запись.УдалитьФормат;
				НовыйФормат = СоответствиеФорматов[КлючФормата];
				Если Не ЗначениеЗаполнено(НовыйФормат) Тогда
					НовыйФормат = Запись.УдалитьФормат;
				КонецЕсли;
				Запись.Формат = НовыйФормат;
				Записать = Истина;
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Запись.ВидЭлектронногоДокумента) И ЗначениеЗаполнено(Запись.УдалитьВидЭлектронногоДокумента) Тогда
				Отбор = Новый Структура("Отправитель, Получатель, Договор");
				ЗаполнитьЗначенияСвойств(Отбор, Запись);
				СтрокиТаблицыНастроек = НастройкиОтправки.НайтиСтроки(Отбор);
				Если СтрокиТаблицыНастроек.Количество() Тогда
					Настройка = СтрокиТаблицыНастроек[0];
					Если Настройка.ИспользоватьУПД 
						И Запись.УдалитьВидЭлектронногоДокумента = Перечисления.ТипыДокументовЭДО.СчетФактура Тогда
						НовыйВидДокумента = ВидДокументаУПД;
					ИначеЕсли Настройка.ИспользоватьУКД 
						И Запись.УдалитьВидЭлектронногоДокумента = Перечисления.ТипыДокументовЭДО.КорректировочныйСчетФактура Тогда
						НовыйВидДокумента = ВидДокументаУКД;
					Иначе
						НовыйВидДокумента = СоответствиеВидовДокументов[Запись.УдалитьВидЭлектронногоДокумента];
					КонецЕсли;
					
					Запись.ВидЭлектронногоДокумента = НовыйВидДокумента;
				КонецЕсли;
				Записать = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
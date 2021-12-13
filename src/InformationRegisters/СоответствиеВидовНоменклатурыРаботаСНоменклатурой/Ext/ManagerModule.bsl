﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс

// Регистрирует данные для обработчика обновления
// 
// Параметры:
//  Параметры - Структура - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеРегистра = Метаданные.РегистрыСведений.СоответствиеВидовНоменклатурыРаботаСНоменклатурой;
	ПолноеИмяРегистра  = МетаданныеРегистра.ПолноеИмя();
	
	ИмяТаблицыИзмеренияРегистра = РаботаСНоменклатурой.ИмяТаблицыПоТипу(МетаданныеРегистра.Измерения.ВидНоменклатуры.Тип);
	Если НЕ ЗначениеЗаполнено(ИмяТаблицыИзмеренияРегистра) Тогда
		// Не удалось определить таблицу хранения измерения регистра, обработка данных невозможна
		Возврат
	КонецЕсли;
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.СпособВыборки        = ОбновлениеИнформационнойБазы.СпособВыборкиИзмеренияНезависимогоРегистраСведений();
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("ВидНоменклатуры");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("ВидНоменклатуры");
	
	РегистрацияДанныхДляОбработки_1_7_2(ДополнительныеПараметры, Параметры, ИмяТаблицыИзмеренияРегистра);
	
КонецПроцедуры

// Обработчик обновления БЭД 1.7.2
// Дополняет данные регистра СоответствиеВидовНоменклатурыРаботаСНоменклатурой данными регистра УдалитьСоответствиеНоменклатурыБизнесСеть.
// Устанавливает пометки единственных записей - ресурс ЭтоЕдинственнаяЗапись = Истина.
// 
// Параметры:
//  Параметры - Структура - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеРегистра = Метаданные.РегистрыСведений.СоответствиеВидовНоменклатурыРаботаСНоменклатурой;
	ПолноеИмяРегистра  = МетаданныеРегистра.ПолноеИмя();
	
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	СписокВидовНоменклатуры = Новый Массив;
	Если ЗначениеЗаполнено(ОбновляемыеДанные) Тогда
		СписокВидовНоменклатуры = ОбновляемыеДанные.ВыгрузитьКолонку("ВидНоменклатуры");
	КонецЕсли;
	ДанныеДляЗаполнения_1_7_2 = ДанныеДляЗаполнения_1_7_2(СписокВидовНоменклатуры);
	
	ЕстьОтработанныеЗаписи = Ложь;
	ПроизошлаОшибка        = Ложь;
	Для Каждого Строка Из ОбновляемыеДанные Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки       = Блокировка.Добавить(ПолноеИмяРегистра);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.УстановитьЗначение("ВидНоменклатуры", Строка.ВидНоменклатуры);
			Блокировка.Заблокировать();
			
			НаборЗаписей = РегистрыСведений.СоответствиеВидовНоменклатурыРаботаСНоменклатурой.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ВидНоменклатуры.Установить(Строка.ВидНоменклатуры);
			НаборЗаписей.Прочитать();
			
			Записать = Ложь;
			ОбработкаДанных_1_7_2(НаборЗаписей, ДанныеДляЗаполнения_1_7_2, Строка.ВидНоменклатуры, Записать);
			
			Если Записать Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
			КонецЕсли;
			
			ЕстьОтработанныеЗаписи = Истина;
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ШаблонСообщения = НСтр("ru = 'Не удалось обработать записи по виду номенклатуры %1 по причине:'");
			ТекстСообщения  = СтрШаблон(ШаблонСообщения, Строка.ВидНоменклатуры) + Символы.ПС
				+ ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,
			МетаданныеРегистра, Строка.ВидНоменклатуры, ТекстСообщения);
			
			ПроизошлаОшибка = Истина;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Если НЕ ЕстьОтработанныеЗаписи И ПроизошлаОшибка Тогда
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Перенос данных из удаляемого регистра УдалитьСоответствиеНоменклатурыБизнесСеть.
// Заполнение ресурса ЭтоЕдинственнаяЗапись
Процедура РегистрацияДанныхДляОбработки_1_7_2(ДополнительныеПараметры, Параметры, ИмяТаблицыИзмеренияРегистра)
	
	// Общие принципы:
	// 1. Регистр-приемник (СоответствиеВидовНоменклатурыРаботаСНоменклатурой) имеет приоритет над регистром-источником (УдалитьСоответствиеНоменклатурыБизнесСеть).
	//    Это означает, что если ВидНоменклатуры уже описан в регистре-приемнике, то переносить дополнительные данные из регистра-источника не требуется.
	// 2. Признак ЭтоЕдинственнаяЗапись нужно установить в том случае, если существует ровно 1 запись по виду номенклатуры.
	// Регистрация выполняется в 2 этапа: отдельно перенос данных и отдельно заполнение ресурса ЭтоЕдинственнаяЗапись.
	// Условия регистрации (перенос данных):
	// 1. В регистре-источнике есть записи, где тип данных измерения ОбъектСопоставления - ВидНоменклатуры.
	// 2. В регистре-приемнике данных по виду номенклатуры нет.
	// Условия регистрации (пометка единственных записей, читаются только данные регистра СоответствиеВидовНоменклатурыРаботаСНоменклатурой):
	// 1. Найдена ровно 1 запись по виду номенклатуры в регистре.
	// 2. Не найдено записей по виду номенклатуры с пометкой Истина в ресурсе ЭтоЕдинственнаяЗапись.
	
	// Регистрация для переноса данных.
	ТекстЗапроса = "ВЫБРАТЬ ПЕРВЫЕ 1000
	|	ТаблицаСправочника.Ссылка КАК ВидНоменклатуры
	|ИЗ
	|	&ИмяТаблицыИзмеренияРегистра КАК ТаблицаСправочника
	|ГДЕ
	|	ТаблицаСправочника.Ссылка > &ПорядокОбхода
	|	И НЕ ИСТИНА В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					ИСТИНА
	|				ИЗ
	|					РегистрСведений.СоответствиеВидовНоменклатурыРаботаСНоменклатурой КАК СоответствиеВидовНоменклатурыРаботаСНоменклатурой
	|				ГДЕ
	|					СоответствиеВидовНоменклатурыРаботаСНоменклатурой.ВидНоменклатуры = ТаблицаСправочника.Ссылка)
	|	И ИСТИНА В
	|			(ВЫБРАТЬ ПЕРВЫЕ 1
	|				ИСТИНА
	|			ИЗ
	|				РегистрСведений.УдалитьСоответствиеНоменклатурыБизнесСеть КАК УдалитьСоответствиеНоменклатурыБизнесСеть
	|			ГДЕ
	|				УдалитьСоответствиеНоменклатурыБизнесСеть.ОбъектСопоставления = ТаблицаСправочника.Ссылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВидНоменклатуры";
	
	ОтметитьКОбработкеПоТекстуЗапроса(ТекстЗапроса, ДополнительныеПараметры, Параметры, ИмяТаблицыИзмеренияРегистра);
	
	// Регистрация для пометки единственных записей.
	ТекстЗапроса = "ВЫБРАТЬ ПЕРВЫЕ 1000
	|	СоответствиеВидовНоменклатуры.ВидНоменклатуры КАК ВидНоменклатуры
	|ИЗ
	|	РегистрСведений.СоответствиеВидовНоменклатурыРаботаСНоменклатурой КАК СоответствиеВидовНоменклатуры
	|ГДЕ
	|	НЕ СоответствиеВидовНоменклатуры.ЭтоЕдинственнаяЗапись
	|	И СоответствиеВидовНоменклатуры.ВидНоменклатуры > &ПорядокОбхода
	|
	|СГРУППИРОВАТЬ ПО
	|	СоответствиеВидовНоменклатуры.ВидНоменклатуры
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(СоответствиеВидовНоменклатуры.ВидНоменклатуры) = 1 И
	|	НЕ ИСТИНА В
	|			(ВЫБРАТЬ ПЕРВЫЕ 1
	|				ИСТИНА
	|			ИЗ
	|				РегистрСведений.СоответствиеВидовНоменклатурыРаботаСНоменклатурой КАК ТаблицаПроверки
	|			ГДЕ
	|				ТаблицаПроверки.ВидНоменклатуры = СоответствиеВидовНоменклатуры.ВидНоменклатуры
	|				И ТаблицаПроверки.ЭтоЕдинственнаяЗапись)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВидНоменклатуры";
	
	ОтметитьКОбработкеПоТекстуЗапроса(ТекстЗапроса, ДополнительныеПараметры, Параметры);
	
	// Запрос, обратный вышестоящему – проверка наличия записей с ЭтоЕдинственнаяЗапись = Истина и количеством больше 1.
	ТекстЗапроса = "ВЫБРАТЬ ПЕРВЫЕ 1000
	|	СоответствиеВидовНоменклатуры.ВидНоменклатуры КАК ВидНоменклатуры
	|ИЗ
	|	РегистрСведений.СоответствиеВидовНоменклатурыРаботаСНоменклатурой КАК СоответствиеВидовНоменклатуры
	|ГДЕ
	|	СоответствиеВидовНоменклатуры.ВидНоменклатуры > &ПорядокОбхода
	|
	|СГРУППИРОВАТЬ ПО
	|	СоответствиеВидовНоменклатуры.ВидНоменклатуры
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(СоответствиеВидовНоменклатуры.ВидНоменклатуры) > 1 И
	|	ИСТИНА В
	|		(ВЫБРАТЬ ПЕРВЫЕ 1
	|			ИСТИНА
	|		ИЗ
	|			РегистрСведений.СоответствиеВидовНоменклатурыРаботаСНоменклатурой КАК ТаблицаПроверки
	|		ГДЕ
	|			ТаблицаПроверки.ВидНоменклатуры = СоответствиеВидовНоменклатуры.ВидНоменклатуры
	|			И ТаблицаПроверки.ЭтоЕдинственнаяЗапись)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВидНоменклатуры";
	
	ОтметитьКОбработкеПоТекстуЗапроса(ТекстЗапроса, ДополнительныеПараметры, Параметры);
	
КонецПроцедуры

Процедура ОтметитьКОбработкеПоТекстуЗапроса(ТекстЗапроса, ДополнительныеПараметры, Параметры, ИмяТаблицыИзмеренияРегистра = "")
	
	РазмерПорции = 1000;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "1000", Формат(РазмерПорции, "ЧГ="));
	Если ИмяТаблицыИзмеренияРегистра <> "" Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяТаблицыИзмеренияРегистра", ИмяТаблицыИзмеренияРегистра);
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	ОтработаныВсеДанные = Ложь;
	ПорядокОбхода       = Неопределено;
	
	Пока НЕ ОтработаныВсеДанные Цикл
		
		Запрос.УстановитьПараметр("ПорядокОбхода", ПорядокОбхода);
		
		Выгрузка = Запрос.Выполнить().Выгрузить();
		
		КоличествоСтрок = Выгрузка.Количество();
		
		Если КоличествоСтрок < РазмерПорции Тогда
			ОтработаныВсеДанные = Истина;
		КонецЕсли;
		
		Если КоличествоСтрок > 0 Тогда
			ПорядокОбхода = Выгрузка[КоличествоСтрок - 1].ВидНоменклатуры;
		КонецЕсли;
		
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Выгрузка, ДополнительныеПараметры);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ДанныеДляЗаполнения_1_7_2(СписокВидовНоменклатуры)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СоответствиеНоменклатуры.ОбъектСопоставления КАК ВидНоменклатуры,
	|	СоответствиеНоменклатуры.ИдентификаторКатегории КАК ИдентификаторКатегории,
	|	СоответствиеНоменклатуры.ПредставлениеКатегории КАК ПредставлениеКатегории
	|ИЗ
	|	РегистрСведений.УдалитьСоответствиеНоменклатурыБизнесСеть КАК СоответствиеНоменклатуры
	|ГДЕ
	|	СоответствиеНоменклатуры.ОбъектСопоставления В(&СписокВидовНоменклатуры)
	|	И (СоответствиеНоменклатуры.ИдентификаторКатегории, ИСТИНА) В
	|			(ВЫБРАТЬ
	|				МАКСИМУМ(УдалитьСоответствиеНоменклатурыБизнесСеть.ИдентификаторКатегории),
	|				ИСТИНА
	|			ИЗ
	|				РегистрСведений.УдалитьСоответствиеНоменклатурыБизнесСеть КАК УдалитьСоответствиеНоменклатурыБизнесСеть
	|			ГДЕ
	|				УдалитьСоответствиеНоменклатурыБизнесСеть.ОбъектСопоставления = СоответствиеНоменклатуры.ОбъектСопоставления)";
	
	Запрос.УстановитьПараметр("СписокВидовНоменклатуры", СписокВидовНоменклатуры);
	
	Результат = Запрос.Выполнить().Выгрузить();
	Результат.Индексы.Добавить("ВидНоменклатуры");
	
	Возврат Результат;
	
КонецФункции

Процедура ОбработкаДанных_1_7_2(НаборЗаписей, ДанныеДляЗаполнения, ВидНоменклатурыСсылка, Записать)
	
	Если ТипЗнч(ДанныеДляЗаполнения) = Тип("ТаблицаЗначений") Тогда
		СтрокиДляЗаполнения = ДанныеДляЗаполнения.НайтиСтроки(Новый Структура("ВидНоменклатуры", ВидНоменклатурыСсылка));
		Если СтрокиДляЗаполнения.Количество() > 0 Тогда
			
			ПараметрыЗаполнения = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтрокиДляЗаполнения[0]);
			
			ДанныеЗаполнены = Ложь;
			
			Для каждого ЗаписьНабора Из НаборЗаписей Цикл
				Если НЕ ЗначениеЗаполнено(ЗаписьНабора.ИдентификаторКатегории) Тогда
					ЗаполнитьЗначенияСвойств(ЗаписьНабора, ПараметрыЗаполнения,, "ВидНоменклатуры");
					Записать = Истина;
				КонецЕсли;
				ДанныеЗаполнены = Истина;
			КонецЦикла;
			
			Если Не ДанныеЗаполнены Тогда
				Запись = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(Запись, ПараметрыЗаполнения);
				Записать = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ЭтоЕдинственнаяЗапись = (НаборЗаписей.Количество() = 1);
	Для каждого Запись Из НаборЗаписей Цикл
		Запись.ЭтоЕдинственнаяЗапись = ЭтоЕдинственнаяЗапись;
		Записать = Истина;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
	
#КонецЕсли
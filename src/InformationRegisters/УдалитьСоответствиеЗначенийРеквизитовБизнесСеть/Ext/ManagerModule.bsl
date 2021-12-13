﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс

// Регистрирует данные для обработчика обновления
// 
// Параметры:
//  Параметры - Структура - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеРегистра = Метаданные.РегистрыСведений.УдалитьСоответствиеЗначенийРеквизитовБизнесСеть;
	ПолноеИмяРегистра  = МетаданныеРегистра.ПолноеИмя();
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.СпособВыборки        = ОбновлениеИнформационнойБазы.СпособВыборкиИзмеренияНезависимогоРегистраСведений();
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("ОбъектСопоставления");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("ОбъектСопоставления");
	
	РегистрацияДанныхДляОбработки_1_7_2(ДополнительныеПараметры, Параметры);
	
КонецПроцедуры

// Обработчик обновления БЭД 1.7.2
// Дополняет данные регистра СоответствиеЗначенийРеквизитовРаботаСНоменклатурой данными регистра УдалитьСоответствиеЗначенийРеквизитовБизнесСеть.
// 
// Параметры:
//  Параметры - Структура - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ИмяМетода                = "РегистрыСведений.УдалитьСоответствиеЗначенийРеквизитовБизнесСеть.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	ЧитаемыеИзменяемыеДанные = РаботаСНоменклатуройСлужебный.ЧитаемыеИзменяемыеДанныеМетода(ИмяМетода);
	Для каждого ИмяЧитаемогоОбъекта Из ЧитаемыеИзменяемыеДанные.Читаемые Цикл
		Если ОбновлениеИнформационнойБазы.ЕстьЗаблокированныеПредыдущимиОчередямиДанные(Параметры.Очередь, ИмяЧитаемогоОбъекта) Тогда
			Параметры.ОбработкаЗавершена = Ложь;
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	МетаданныеРегистра = Метаданные.РегистрыСведений.УдалитьСоответствиеЗначенийРеквизитовБизнесСеть;
	ПолноеИмяРегистра  = МетаданныеРегистра.ПолноеИмя();
	
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	СписокОбъектов = Новый Массив;
	Если ЗначениеЗаполнено(ОбновляемыеДанные) Тогда
		СписокОбъектов = ОбновляемыеДанные.ВыгрузитьКолонку("ОбъектСопоставления");
	КонецЕсли;
	РеквизитыСопоставления    = РегистрыСведений.УдалитьСоответствиеРеквизитовБизнесСеть.РеквизитыСопоставления();
	ДанныеДляЗаполнения_1_7_2 = ДанныеДляЗаполнения_1_7_2(СписокОбъектов, РеквизитыСопоставления);
	
	ЕстьОтработанныеЗаписи = Ложь;
	ПроизошлаОшибка        = Ложь;
	Для Каждого Строка Из ОбновляемыеДанные Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки       = Блокировка.Добавить(ПолноеИмяРегистра);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.УстановитьЗначение("ОбъектСопоставления", Строка.ОбъектСопоставления);
			Блокировка.Заблокировать();
			
			НаборЗаписей = РегистрыСведений.УдалитьСоответствиеЗначенийРеквизитовБизнесСеть.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ОбъектСопоставления.Установить(Строка.ОбъектСопоставления);
			НаборЗаписей.Прочитать();
			
			Записать = Ложь;
			ОбработкаДанных_1_3_10(НаборЗаписей, РеквизитыСопоставления, Записать);
			ОбработкаДанных_1_7_2(НаборЗаписей, ДанныеДляЗаполнения_1_7_2, Строка.ОбъектСопоставления);
			
			Если Записать Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
			КонецЕсли;
			
			ЕстьОтработанныеЗаписи = Истина;
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ШаблонСообщения = НСтр("ru = 'Не удалось обработать записи по объекту сопоставления %1 по причине:'");
			ТекстСообщения  = СтрШаблон(ШаблонСообщения, Строка.ОбъектСопоставления) + Символы.ПС + 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,
			МетаданныеРегистра, Строка.ОбъектСопоставления, ТекстСообщения);
			
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

// Перенос данных из удаляемого регистра УдалитьСоответствиеЗначенийРеквизитовБизнесСеть.
Процедура РегистрацияДанныхДляОбработки_1_7_2(ДополнительныеПараметры, Параметры)
	
	РазмерПорции = 1000;
	ТекстЗапроса = "ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
	|	СоответствиеЗначений.ОбъектСопоставления КАК ОбъектСопоставления
	|ИЗ
	|	РегистрСведений.УдалитьСоответствиеЗначенийРеквизитовБизнесСеть КАК СоответствиеЗначений
	|ГДЕ
	|	СоответствиеЗначений.ОбъектСопоставления > &ПорядокОбхода
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОбъектСопоставления";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "1000", Формат(РазмерПорции, "ЧГ="));
	
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
			ПорядокОбхода = Выгрузка[КоличествоСтрок - 1][Выгрузка.Колонки[0].Имя];
		КонецЕсли;
		
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Выгрузка, ДополнительныеПараметры);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ДанныеДляЗаполнения_1_7_2(СписокОбъектов, РеквизитыСопоставления)
	
	Номенклатура = Новый Массив;
	Для каждого СсылкаНаОбъект Из СписокОбъектов Цикл
		Если РаботаСНоменклатуройСлужебный.ЭтоНоменклатура(СсылкаНаОбъект) Тогда
			Номенклатура.Добавить(СсылкаНаОбъект);
		КонецЕсли;
	КонецЦикла;
	
	ПрикладныеДанные = Новый ТаблицаЗначений;
	РаботаСНоменклатуройПереопределяемый.ПолучитьВидыНоменклатурыПоНоменклатуре(Номенклатура, ПрикладныеДанные);
	
	СоответствиеНоменклатурыВидам = Новый ТаблицаЗначений;
	СоответствиеНоменклатурыВидам.Колонки.Добавить("Номенклатура", Метаданные.ОпределяемыеТипы.НоменклатураРаботаСНоменклатурой.Тип);
	СоответствиеНоменклатурыВидам.Колонки.Добавить("ВидНоменклатуры", Метаданные.ОпределяемыеТипы.ВидНоменклатурыРаботаСНоменклатурой.Тип);
	Для каждого СтрокаДанных Из ПрикладныеДанные Цикл
		ЗаполнитьЗначенияСвойств(СоответствиеНоменклатурыВидам.Добавить(), СтрокаДанных);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СоответствиеНоменклатурыВидам.Номенклатура КАК Номенклатура,
	|	СоответствиеНоменклатурыВидам.ВидНоменклатуры КАК ВидНоменклатуры
	|ПОМЕСТИТЬ СоответствиеНоменклатурыВидам
	|ИЗ
	|	&СоответствиеНоменклатурыВидам КАК СоответствиеНоменклатурыВидам
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СоответствиеЗначений.ОбъектСопоставления КАК ОбъектСопоставленияРегистрация,
	|	ЕСТЬNULL(СоответствиеНоменклатурыВидам.ВидНоменклатуры, СоответствиеЗначений.ОбъектСопоставления) КАК ОбъектСопоставления,
	|	СоответствиеЗначений.РеквизитОбъекта КАК РеквизитОбъекта,
	|	СоответствиеЗначений.Значение КАК Значение,
	|	СоответствиеЗначений.ИдентификаторЗначенияРеквизитаКатегории КАК ИдентификаторЗначенияРеквизитаКатегории,
	|	СоответствиеЗначений.ПредставлениеЗначенияРеквизитаКатегории КАК ПредставлениеЗначенияРеквизитаКатегории,
	|	ТИПЗНАЧЕНИЯ(СоответствиеЗначений.РеквизитОбъекта) = ТИПЗНАЧЕНИЯ("""") КАК РеквизитСтрока
	|ИЗ
	|	РегистрСведений.УдалитьСоответствиеЗначенийРеквизитовБизнесСеть КАК СоответствиеЗначений
	|		ЛЕВОЕ СОЕДИНЕНИЕ СоответствиеНоменклатурыВидам КАК СоответствиеНоменклатурыВидам
	|		ПО СоответствиеЗначений.ОбъектСопоставления = СоответствиеНоменклатурыВидам.Номенклатура
	|ГДЕ
	|	СоответствиеЗначений.ОбъектСопоставления В(&СписокОбъектов)";
	
	Запрос.УстановитьПараметр("СоответствиеНоменклатурыВидам", СоответствиеНоменклатурыВидам);
	Запрос.УстановитьПараметр("СписокОбъектов", СписокОбъектов);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	РеквизитыСтрокой = Результат.НайтиСтроки(Новый Структура("РеквизитСтрока", Истина));
	Для каждого ОписаниеРеквизита Из РеквизитыСтрокой Цикл
		НовыйРеквизит = РеквизитыСопоставления.Получить(ОписаниеРеквизита.РеквизитОбъекта);
		Если НовыйРеквизит <> Неопределено Тогда
			ОписаниеРеквизита.РеквизитОбъекта = НовыйРеквизит;
		КонецЕсли;
	КонецЦикла;
	
	Результат.Индексы.Добавить("ОбъектСопоставленияРегистрация");
	
	Возврат Результат;
	
КонецФункции

Процедура ОбработкаДанных_1_3_10(НаборЗаписей, РеквизитыСопоставления, Записать)
	
	Если РеквизитыСопоставления.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ЗаписьНабора Из НаборЗаписей Цикл
		НовыйРеквизит = РеквизитыСопоставления.Получить(ЗаписьНабора.РеквизитОбъекта);
		Если НовыйРеквизит <> Неопределено Тогда
			ЗаписьНабора.РеквизитОбъекта = НовыйРеквизит;
			Записать = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаДанных_1_7_2(Знач НаборЗаписей, ДанныеДляЗаполнения, Знач ОбъектСопоставленияРегистрация)
	
	Если ТипЗнч(ДанныеДляЗаполнения) <> Тип("ТаблицаЗначений") Тогда
		Возврат
	КонецЕсли;
	
	СтрокиДляЗаполнения = ДанныеДляЗаполнения.НайтиСтроки(Новый Структура("ОбъектСопоставленияРегистрация", ОбъектСопоставленияРегистрация));
	Если СтрокиДляЗаполнения.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	ДанныеПоОбъекту = ДанныеДляЗаполнения.Скопировать(СтрокиДляЗаполнения);
	ДанныеПоОбъекту.Индексы.Добавить("РеквизитОбъекта,Значение");
	
	ОбъектСопоставления = ДанныеПоОбъекту[0].ОбъектСопоставления;
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СоответствиеЗначенийРеквизитовРаботаСНоменклатурой");
	ЭлементБлокировки.УстановитьЗначение("ОбъектСопоставления", ОбъектСопоставления);
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	Блокировка.Заблокировать();
	
	Набор = РегистрыСведений.СоответствиеЗначенийРеквизитовРаботаСНоменклатурой.СоздатьНаборЗаписей();
	Набор.Отбор.ОбъектСопоставления.Установить(ОбъектСопоставления);
	Набор.Прочитать();
	
	ПараметрыПоиска = Новый Структура("РеквизитОбъекта,Значение");
	Для каждого ЗаписьНабора Из Набор Цикл
		ЗаполнитьЗначенияСвойств(ПараметрыПоиска, ЗаписьНабора);
		СтрокиДляУдаления = ДанныеПоОбъекту.НайтиСтроки(ПараметрыПоиска);
		Для каждого СтрокаДляУдаления Из СтрокиДляУдаления Цикл
			ДанныеПоОбъекту.Удалить(СтрокаДляУдаления);
		КонецЦикла;
	КонецЦикла;
	
	Если ДанныеПоОбъекту.Количество() Тогда
		Для каждого СтрокаДанных Из ДанныеПоОбъекту Цикл
			ЗаполнитьЗначенияСвойств(Набор.Добавить(), СтрокаДанных);
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(Набор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
	
#КонецЕсли
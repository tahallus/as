﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ОбновлениеВерсииИБ

// Регистрирует данные для обработчика обновления
// 
// Параметры:
//  Параметры - Структура - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.НоменклатураКонтрагентовБЭД;
	ПолноеИмяРегистра = МетаданныеОбъекта.ПолноеИмя();
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.СпособВыборки        = ОбновлениеИнформационнойБазы.СпособВыборкиИзмеренияНезависимогоРегистраСведений();
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Идентификатор");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Идентификатор");

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1000
	|	НоменклатураКонтрагентовБЭД.Владелец КАК Владелец,
	|	НоменклатураКонтрагентовБЭД.Идентификатор КАК Идентификатор
	|ИЗ
	|	РегистрСведений.НоменклатураКонтрагентовБЭД КАК НоменклатураКонтрагентовБЭД
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НоменклатураКонтрагентов КАК НоменклатураКонтрагентов
	|		ПО НоменклатураКонтрагентовБЭД.Владелец = НоменклатураКонтрагентов.ВладелецНоменклатуры
	|			И НоменклатураКонтрагентовБЭД.Идентификатор = НоменклатураКонтрагентов.Идентификатор
	|ГДЕ
	|	(НоменклатураКонтрагентовБЭД.ИдентификаторНоменклатуры = """"
	|			ИЛИ НоменклатураКонтрагентов.Ссылка ЕСТЬ NULL
	|			ИЛИ (НоменклатураКонтрагентовБЭД.НаименованиеУпаковки = """"
	|				И НоменклатураКонтрагентовБЭД.ЕдиницаИзмерения <> """"))
	|	И НоменклатураКонтрагентовБЭД.Идентификатор > &Идентификатор
	|
	|УПОРЯДОЧИТЬ ПО
	|	Идентификатор";
	
	ОтработаныВсеДанные = Ложь;
	Идентификатор       = "";
	
	Пока Не ОтработаныВсеДанные Цикл
		
		Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
		
		Выгрузка = Запрос.Выполнить().Выгрузить();
		
		КоличествоСтрок = Выгрузка.Количество();
		
		Если КоличествоСтрок < 1000 Тогда
			ОтработаныВсеДанные = Истина;
		КонецЕсли;
		
		Если КоличествоСтрок > 0 Тогда
			Идентификатор = Выгрузка[КоличествоСтрок - 1].Идентификатор;
		КонецЕсли;
		
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Выгрузка, ДополнительныеПараметры);
		
	КонецЦикла;
	
КонецПроцедуры
	
// Обработчик обновления БЭД 1.8.1
//
// Перебирает записи в регистре сведений НоменклатураКонтрагентовБЭД и разбивает идентификатор на части:
//  Идентификатор Номенклатуры, Идентификатор Характеристики, Идентификатор Упаковки.
// 
// Параметры:
//  Параметры - Структура - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.НоменклатураКонтрагентовБЭД;
	ПолноеИмяОбъекта  = МетаданныеОбъекта.ПолноеИмя();
	
	Если Не ОбновлениеИнформационнойБазы.ОбъектОбработан(Метаданные.Справочники.НоменклатураКонтрагентов.ПолноеИмя()).Обработан Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Если ОбновляемыеДанные.Количество() = 0 Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
		Возврат;
	КонецЕсли;
	
	ВыборкаДляЗаписиВСправочник = ВыборкаОтсутствующейНоменклатурыКонтрагентовВСправочнике(ОбновляемыеДанные);

	ДополнительныеПараметры = СопоставлениеНоменклатурыКонтрагентов.НовыеДополнительныеПараметрыПриЗаписиНоменклатурыКонтрагентов();
	ДополнительныеПараметры.ТребуетсяЗаписьВРегистр = Ложь;
	ДополнительныеПараметры.ТребуетсяПоискСсылки    = Ложь;
	
	ЕстьОтработанныеЗаписи = Ложь;
	ПроизошлаОшибка        = Ложь;
	Для Каждого Строка Из ОбновляемыеДанные Цикл
		
		Отказ       = Ложь;
		ТекстОшибки = "";
		
		ПараметрыПоиска = Новый Структура;
		ПараметрыПоиска.Вставить("Владелец"     , Строка.Владелец);
		ПараметрыПоиска.Вставить("Идентификатор", Строка.Идентификатор);
		
		НачатьТранзакцию();
		Попытка
			
			НаборЗаписей = РегистрыСведений.НоменклатураКонтрагентовБЭД.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Владелец.Установить(Строка.Владелец);
			НаборЗаписей.Отбор.Идентификатор.Установить(Строка.Идентификатор);
			ОбщегоНазначенияБЭД.УстановитьУправляемуюБлокировкуПоНаборуЗаписей(НаборЗаписей);
			НаборЗаписей.Прочитать();
			
			Записать = Ложь;
			Если НаборЗаписей.Количество() Тогда
				
				ТекущаяЗапись = НаборЗаписей[0];
				
				Если (Не ЗначениеЗаполнено(ТекущаяЗапись.ИдентификаторНоменклатуры)
					Или Не ЗначениеЗаполнено(ТекущаяЗапись.ИдентификаторХарактеристики)
					Или Не ЗначениеЗаполнено(ТекущаяЗапись.ИдентификаторУпаковки)) Тогда
					
					Записать = Истина;
					
					СопоставлениеНоменклатурыКонтрагентовКлиентСервер.РазделитьИдентификаторНаЧасти(ТекущаяЗапись.Идентификатор, ТекущаяЗапись);
					
					Если ЗначениеЗаполнено(ТекущаяЗапись.Характеристика) Тогда
						ТекущаяЗапись.ИспользоватьХарактеристики = Истина;
					КонецЕсли;
				КонецЕсли;
				Если ВыборкаДляЗаписиВСправочник.НайтиСледующий(ПараметрыПоиска) Тогда
					
					Записать = Истина;
					НоменклатураКонтрагента = СопоставлениеНоменклатурыКонтрагентовКлиентСервер.НоваяНоменклатураКонтрагента();
					ЗаполнитьЗначенияСвойств(НоменклатураКонтрагента, ТекущаяЗапись);
					НоменклатураИБ = СопоставлениеНоменклатурыКонтрагентовКлиентСервер.НоваяНоменклатураИнформационнойБазы();
					ЗаполнитьЗначенияСвойств(НоменклатураИБ, ТекущаяЗапись);
					
					СопоставлениеНоменклатурыКонтрагентов.СоздатьОбновитьНоменклатуруКонтрагента(
						НоменклатураКонтрагента, НоменклатураИБ, Отказ, ТекстОшибки, ДополнительныеПараметры);
						
					ТекущаяЗапись.НаименованиеУпаковки = НоменклатураКонтрагента.НаименованиеУпаковки;
					ТекущаяЗапись.ЕдиницаИзмерения     = НоменклатураКонтрагента.ЕдиницаИзмерения;
					
				КонецЕсли;
			КонецЕсли;
			
			Если Отказ Тогда
				ВызватьИсключение ТекстОшибки;
			КонецЕсли;
			
			Если Записать Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
			КонецЕсли;
			
			ЕстьОтработанныеЗаписи = Истина;
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ШаблонСообщения = НСтр("ru = 'Не удалось обработать запись по идентификатору: %1 по причине:'");
			ТекстСообщения = СтрШаблон(ШаблонСообщения, Строка.Идентификатор) + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеОбъекта, Строка.Идентификатор, ТекстСообщения);
				
			ПроизошлаОшибка = Истина;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Если Не ЕстьОтработанныеЗаписи И ПроизошлаОшибка Тогда
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;

	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
		
КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВыборкаОтсутствующейНоменклатурыКонтрагентовВСправочнике(Знач ОбновляемыеДанные)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОбновляемыеДанные", ОбновляемыеДанные);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОбновляемыеДанные.Владелец КАК Владелец,
	|	ОбновляемыеДанные.Идентификатор КАК Идентификатор
	|ПОМЕСТИТЬ ОбновляемыеДанные
	|ИЗ
	|	&ОбновляемыеДанные КАК ОбновляемыеДанные
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОбновляемыеДанные.Владелец КАК Владелец,
	|	ОбновляемыеДанные.Идентификатор КАК Идентификатор
	|ИЗ
	|	ОбновляемыеДанные КАК ОбновляемыеДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НоменклатураКонтрагентов КАК НоменклатураКонтрагентов
	|		ПО ОбновляемыеДанные.Владелец = НоменклатураКонтрагентов.ВладелецНоменклатуры
	|			И ОбновляемыеДанные.Идентификатор = НоменклатураКонтрагентов.Идентификатор
	|ГДЕ
	|	НоменклатураКонтрагентов.Ссылка ЕСТЬ NULL";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выбрать();

КонецФункции


#КонецОбласти

#КонецЕсли
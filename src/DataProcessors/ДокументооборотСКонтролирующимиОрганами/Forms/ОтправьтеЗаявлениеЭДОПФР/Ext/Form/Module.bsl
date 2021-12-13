﻿&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Подготовить = НСтр("ru = 'Подготовить заявление'");
	ПодготовитьПовторно = НСтр("ru = 'Требуется повторное заявление'");
	Отправлено  = НСтр("ru = 'Отправлено в ПФР'");
	
	Для каждого Организация Из Параметры.Организации Цикл
		Если Параметры.ОрганизацииПредупредитьПовторно.Найти(Организация) <> Неопределено Тогда
			НоваяСтрока = Организации.Добавить();
			НоваяСтрока.Организация = Организация;
			НоваяСтрока.Статус = ПодготовитьПовторно;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого Организация Из Параметры.Организации Цикл
		Если Параметры.ОрганизацииПредупредитьПовторно.Найти(Организация) = Неопределено Тогда
			НоваяСтрока = Организации.Добавить();
			НоваяСтрока.Организация = Организация;
			НоваяСтрока.Статус = Подготовить;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Инициализируем контекст формы - контейнера клиентских методов
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Завершение отправки" И ТипЗнч(Источник) = Тип("ДокументСсылка.ЗаявленияПоЭлДокументооборотуСПФР") Тогда
		ОбновитьСтатусЗаявления(Источник);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиТаблицыФормы

&НаКлиенте
Процедура ОрганизацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Организации.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда 
		Если Поле.Имя = "ОрганизацииСтатус" Тогда
			
			ОткрытьЗаявление(ТекущиеДанные);
				
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отложить(Команда)
	
	СохранитьДатуНапоминания();
	
	Если НапомнитьЧерез = "-1" Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"Отложить_Завершение", 
			ЭтотОбъект);
			
		Текст = НСтр("ru = 'Вы всегда можете отправить заявление в ПФР из раздела ""Уведомления"" формы ""1С-Отчетность"".'");
		ПоказатьПредупреждение(ОписаниеОповещения, Текст);
		
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Отложить_Завершение(ВходящийКонтекст) Экспорт
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	Если КонтекстЭДОКлиент = Неопределено Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьДатуНапоминания()
	
	// Определяем, когда в следующий раз нужно напоминать пользователю
	ДатаНапоминания = НачалоДня(ТекущаяДатаСеанса());
	Если НапомнитьЧерез = "1" Тогда
		ДатаНапоминания = ДатаНапоминания + 24 * 60 * 60 * 7;
	ИначеЕсли НапомнитьЧерез = "2" Тогда
		ДатаНапоминания = ДобавитьМесяц(ДатаНапоминания, 1);
	ИначеЕсли НапомнитьЧерез = "-1" Тогда
		ДатаНапоминания = '00010101000000';
	Иначе
		ДатаНапоминания = ДатаНапоминания + 24 * 60 * 60;
	КонецЕсли;
	
	ХранилищеОбщихНастроек.Сохранить("ДокументооборотСКонтролирующимиОрганами_ОтправьтеЗаявлениеЭДОПФР", , ДатаНапоминания);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗаявление(ТекущиеДанные)
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Заявление) Тогда 
		Заявление = ТекущиеДанные.Заявление;
	Иначе
		
		Заявление = КонтекстЭДОКлиент.СоздатьЗаявлениеВПФР(
			ПредопределенноеЗначение("Перечисление.ВидыЗаявленийНаЭДОВПФР.НаПодключение"), 
			ТекущиеДанные.Организация);
			
		ТекущиеДанные.Заявление = Заявление;
		
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Ключ", Заявление);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОткрытьЗаявление_ПослеЗакрытия", 
		ЭтотОбъект,
		Заявление);
	
	ОткрытьФорму("Документ.ЗаявленияПоЭлДокументооборотуСПФР.ФормаОбъекта", ДополнительныеПараметры,,,,,ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗаявление_ПослеЗакрытия(Результат, Заявление) Экспорт
	
	ОбновитьСтатусЗаявления(Заявление);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтатусЗаявления(Заявление)
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	
	Для каждого Организация Из Организации Цикл
		Если Организация.Заявление = Заявление И ЗначениеЗаполнено(Заявление) Тогда
			
			Состояние = КонтекстЭДОСервер.ТекущееСостояниеОтправки(Заявление, "ПФР");
			Если Состояние <> Неопределено 
				И Состояние.ТекущийЭтапОтправки <> Неопределено
				И Состояние.ТекущийЭтапОтправки.СостояниеСдачиОтчетности = Перечисления.СостояниеСдачиОтчетности.ДокументооборотНачат Тогда
				
				Организация.Статус = Отправлено;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти


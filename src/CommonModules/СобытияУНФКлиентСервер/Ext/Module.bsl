﻿
#Область ПрограммныйИнтерфейс

// Процедура заполняет список выбора времени.
// Параметры:
//  ПолеВводаФормы  - элемент-владелец списка,
//  Интервал        - интервал, с которым необходимо заполнить список, по умолчанию час.
Процедура ЗаполнитьСписокВыбораВремени(ПолеВводаФормы, Интервал = 3600, Начало = '00010101080000', Окончание = '00010101200000') Экспорт
	
	СписокВремен = ПолеВводаФормы.СписокВыбора;
	СписокВремен.Очистить();
	
	ВремяСписка = НачалоЧаса(Начало);
	
	Пока НачалоЧаса(ВремяСписка) <= НачалоЧаса(Окончание) Цикл
		
		Если НЕ ЗначениеЗаполнено(ВремяСписка) Тогда
			ПредставлениеВремени = "00:00";
		Иначе
			ПредставлениеВремени = Формат(ВремяСписка,"ДФ=ЧЧ:мм");
		КонецЕсли;
		
		СписокВремен.Добавить(ВремяСписка, ПредставлениеВремени);
		
		ВремяСписка = ВремяСписка + Интервал;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПроверитьКорректностьАдресаЭлектроннойПочты(Адрес) Экспорт
	
	ТекстОшибки = "";
	РезультатПроверки = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(Адрес, Ложь);
	
	Для Каждого ПроверенныйАдрес Из РезультатПроверки Цикл
		Если Не ЗначениеЗаполнено(ПроверенныйАдрес.Адрес)
			Или Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(ПроверенныйАдрес.Адрес) Тогда
			
			ТекстОшибки = НСтр("ru='Указан некорректный адрес электронной почты.'");
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТекстОшибки;
	
КонецФункции

#КонецОбласти

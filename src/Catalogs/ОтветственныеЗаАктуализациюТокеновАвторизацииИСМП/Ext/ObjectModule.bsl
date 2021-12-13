﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Реквизиты = ЭтотОбъект.Метаданные().Реквизиты;
	
	ДлинаПоляОтветственные = Реквизиты.ОтветственныеСтрокой.Тип.КвалификаторыСтроки.Длина;
	ДлинаПоляОповещение    = Реквизиты.ОповещениеСтрокой.Тип.КвалификаторыСтроки.Длина;
	
	ПредставлениеЧасов = НСтр("ru = ';%1 час;;%1 часа;%1 часов;%1 часа'");
	ПредставлениеМинут = НСтр("ru = ';%1 минута;;%1 минуты;%1 минут;%1 минуты'");
	
	ТаблицаОтветственных = Ответственные.Выгрузить();
	ТаблицаОтветственных.Сортировать("ВремяВСекундах Убыв");
	
	МассивОтветственные = Новый Массив;
	МассивВремени       = Новый Массив;
	
	Для Каждого Строка Из ТаблицаОтветственных Цикл
		// Ответственные
		Если МассивОтветственные.Найти(Строка.Ответственный) = Неопределено Тогда
			МассивОтветственные.Добавить(Строка.Ответственный);
		КонецЕсли;
		
		// Время
		Время = Цел(Строка.ВремяВСекундах / 3600);
		
		Если Время > 0 Тогда
			ТипВремени = ПредставлениеЧасов;
		Иначе
			Время = Цел(Строка.ВремяВСекундах / 60);
			ТипВремени = ПредставлениеМинут;
		КонецЕсли;
		
		ПредставлениеВремени = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ТипВремени, Время);
		
		Если МассивВремени.Найти(ПредставлениеВремени) = Неопределено Тогда
			МассивВремени.Добавить(ПредставлениеВремени);
		КонецЕсли;
		
	КонецЦикла;
	
	Если МассивВремени.Количество() > 0 Тогда
		МассивВремени[0] = СтрШаблон(НСтр("ru = 'за %1'"), МассивВремени[0]);
	КонецЕсли;
	
	ОтветственныеСтрокой = СформироватьПредставлениеМассиваДанных(
		МассивОтветственные, ДлинаПоляОтветственные);
	
	ОповещениеСтрокой = СформироватьПредставлениеМассиваДанных(
		МассивВремени, ДлинаПоляОповещение);
	
	ИнтеграцияИСПереопределяемый.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьПредставлениеМассиваДанных(МассивДанных, ДлинаПоля)
	
	КоличествоДанных = МассивДанных.Количество();
	
	Если КоличествоДанных = 0 Тогда
		Возврат НСтр("ru = '<данные отсутствуют>'");;
	КонецЕсли;
	
	Разделитель            = ", ";
	ТекстОкончанияЭлемента = "...";
	ДлинаОкончанияЭлемента = СтрДлина(ТекстОкончанияЭлемента);
	ТекстОкончанияСтроки   = НСтр("ru = ' ( + еще %1 )'");
	ДлинаОкончанияСтроки   = СтрДлина(ТекстОкончанияСтроки);
	МаксимальнаяДлина      = ДлинаПоля - ДлинаОкончанияСтроки;
	Представление          = "";
	ПредставлениеДлина     = 0;
	КоличествоДобавлено    = 0;
	
	Для Каждого Элемент Из МассивДанных Цикл
		
		ТекущееПредставление = СокрЛП(Элемент);
		Если КоличествоДобавлено > 0 Тогда
			ТекущееПредставление = Разделитель + ТекущееПредставление;
		КонецЕсли;
			
		ПредставлениеДлина = ПредставлениеДлина + СтрДлина(ТекущееПредставление);
		
		Если КоличествоДанных = КоличествоДобавлено + 1 Тогда
			МаксимальнаяДлина = МаксимальнаяДлина + ДлинаОкончанияСтроки;
		КонецЕсли;
		
		Если ПредставлениеДлина > МаксимальнаяДлина Тогда
			
			Если КоличествоДобавлено = 0 Тогда
				Представление = Лев(ТекущееПредставление,
					МаксимальнаяДлина - ДлинаОкончанияЭлемента) + ТекстОкончанияЭлемента;
				КоличествоДобавлено = КоличествоДобавлено + 1;
			КонецЕсли;
			
			Если КоличествоДанных > 1 Тогда
				Представление = Представление + СтрШаблон(
					ТекстОкончанияСтроки, КоличествоДанных - КоличествоДобавлено);
			КонецЕсли;
		
			Прервать;
			
		КонецЕсли;
		
		Представление = Представление + ТекущееПредставление;
		
		КоличествоДобавлено = КоличествоДобавлено + 1;
		
	КонецЦикла;
	
	Возврат Представление;
	
КонецФункции

#КонецОбласти

#КонецЕсли
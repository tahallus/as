﻿#Область ПрограммныйИнтерфейс

Процедура ОчиститьРезультатыПроверкиСредствамиККТ(СсылкаНаОбъект) Экспорт
	
	Если Не ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.РезультатыПроверкиСредствамиККТИСМП.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(СсылкаНаОбъект);
	
	Блокировка        = Новый БлокировкаДанных();
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.РезультатыПроверкиСредствамиККТИСМП");
	ЭлементБлокировки.УстановитьЗначение(
		Метаданные.РегистрыСведений.РезультатыПроверкиСредствамиККТИСМП.Измерения.Документ.Имя,
		СсылкаНаОбъект);
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка.Заблокировать();
		
		УстановитьПривилегированныйРежим(Истина);
		НаборЗаписей.Записать();
		УстановитьПривилегированныйРежим(Ложь);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ТекстСообщения = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ПроверкаКМСредствамиККТ

Функция СохранитьРезультатПроверкиСредствамиККТ(РезультатПроверки, СсылкаНаОбъект) Экспорт
	
	Если Не ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.РезультатыПроверкиСредствамиККТИСМП.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(СсылкаНаОбъект);
	
	Блокировка        = Новый БлокировкаДанных();
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.РезультатыПроверкиСредствамиККТИСМП");
	ЭлементБлокировки.УстановитьЗначение(
		Метаданные.РегистрыСведений.РезультатыПроверкиСредствамиККТИСМП.Измерения.Документ.Имя,
		СсылкаНаОбъект);
	
	Для Каждого СтрокаПроверки Из РезультатПроверки.ЭлементыПроверки Цикл
		
		РезультатПроверкиПоСтроке = РезультатПроверки.ДанныеПроверки[СтрокаПроверки.ИдентификаторЭлемента];
		
		Если Не ЗначениеЗаполнено(РезультатПроверкиПоСтроке.ТекстОшибки)
			Или Не ЗначениеЗаполнено(СтрокаПроверки.ШтрихкодУпаковки) Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаПроверки);
		ЗаполнитьЗначенияСвойств(НоваяСтрока, РезультатПроверкиПоСтроке);
		НоваяСтрока.Документ = СсылкаНаОбъект;
		
	КонецЦикла;
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка.Заблокировать();
		УстановитьПривилегированныйРежим(Истина);
		НаборЗаписей.Записать();
		УстановитьПривилегированныйРежим(Ложь);
		
		ЗафиксироватьТранзакцию();
		
		Возврат Истина;
		
	Исключение
		
		ОтменитьТранзакцию();
		ТекстСообщения = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
		Возврат Ложь;
		
	КонецПопытки;
	
КонецФункции

Процедура ДополнитьДанныеШтрихкодаПоРезультатамУточненияДляПроверкиККТ(ДанныеШтрикхода, ДанныеВыбора, ПараметрыСканирования) Экспорт
	
	ДанныеШтрикхода.ВидПродукции = ИнтеграцияИС.ВидПродукцииПоНоменклатуре(ДанныеВыбора.Номенклатура);
	
КонецПроцедуры

#КонецОбласти

Процедура СохранениеПолногоКодаМаркировки(ДанныеШтрихкода, ПараметрыСканирования) Экспорт
	
	РезультатОбработкиШтрихкода = ШтрихкодированиеИС.ИнициализироватьРезультатОбработкиШтрихкода();
	ТаблицаКодовМаркировки      = ШтрихкодированиеИС.ИнициализацияТаблицыДанныхКодовМаркировки();
	
	НоваяСтрока = ТаблицаКодовМаркировки.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеШтрихкода);
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеШтрихкода.ДанныеРазбора);
	НоваяСтрока.ШтрихкодBase64 = ДанныеШтрихкода.ПолныйКодМаркировки;
	
	Для Каждого Колонка Из ТаблицаКодовМаркировки.Колонки Цикл
		Если Не ДанныеШтрихкода.Свойство(Колонка.Имя) Тогда
			ДанныеШтрихкода.Вставить(Колонка.Имя, НоваяСтрока[Колонка.Имя]);
		КонецЕсли;
	КонецЦикла;
	
	КодыМаркировки = ШтрихкодированиеИСМП.НоваяТаблицаПоискаКодаМаркировкивПуле();
	ШтрихкодированиеИСМП.ДобавитьКодМаркировкиВТаблицуДляПоискаВПуле(
			НоваяСтрока,
			КодыМаркировки);
	КодыМаркировкиВПуле = ШтрихкодированиеИСМП.РезультатПоискаВПулеКодовМаркировки(КодыМаркировки, "ВидПродукции, ПолныйКодМаркировки");
	
	Если КодыМаркировкиВПуле.Количество() Тогда
		ДанныеШтрихкода.ЕстьВПулеКодовМаркировки = Истина;
		Возврат;
	КонецЕсли;
	
	ШтрихкодированиеИСМПСлужебный.СохранениеКодаМаркировкиВПул(РезультатОбработкиШтрихкода, ДанныеШтрихкода, ПараметрыСканирования);
	
КонецПроцедуры

#КонецОбласти
﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ШаблоныНаименований.КатегорияНоменклатуры,
	|	ШаблоныНаименований.ВидНаименования
	|ИЗ
	|	РегистрСведений.ШаблоныНаименований КАК ШаблоныНаименований
	|ГДЕ
	|	ШаблоныНаименований.Шаблон = &Шаблон";
	
	Запрос.УстановитьПараметр("Шаблон", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	НаборЗаписей = РегистрыСведений.ШаблоныНаименований.СоздатьНаборЗаписей();
	
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей.Отбор.КатегорияНоменклатуры.Установить(Выборка.КатегорияНоменклатуры);
		НаборЗаписей.Отбор.ВидНаименования.Установить(Выборка.ВидНаименования);
		НаборЗаписей.Прочитать();
		НаборЗаписей.Очистить();
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Для Каждого Запись Из ЭтотОбъект Цикл
		Если Запись.Применяется Тогда
			Запись.Представление = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.КодВычета, "Наименование");
		Иначе
			Запись.Представление = НСтр("ru = 'Стандартный личный вычет не применяется'");
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда 
		Возврат; 
	КонецЕсли;
 
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
 
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если Не ЗначениеЗаполнено(Запись.Организация) Тогда
			ОписаниеОбъектаУчета = ИнтеграцияЭДО.ОписаниеОбъектаУчета(Запись.СсылкаНаОбъект);
			Если ЗначениеЗаполнено(ОписаниеОбъектаУчета.Организация) Тогда
				Запись.Организация = ОписаниеОбъектаУчета.Организация;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
	
	ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
	
#КонецЕсли

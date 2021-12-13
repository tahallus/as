﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	// Не выполнять дальнейшие действия при обмене данными
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ВидКарточки = Перечисления.ВидыКарточекАнализаБизнеса.КонтрольПоказателей Тогда
		
		Если ВариантПроверки = Перечисления.ВариантыПроверокАнализаБизнеса.СравнениеСПоказателем
			ИЛИ ВариантПроверки = Перечисления.ВариантыПроверокАнализаБизнеса.СравнениеСФиксированнымЗначением Тогда
			
			Если Период = Перечисления.ДоступныеПериодыОтчета.Месяц Тогда
				Периодичность = Перечисления.Периодичность.Месяц;
			ИначеЕсли Период = Перечисления.ДоступныеПериодыОтчета.Квартал Тогда
				Периодичность = Перечисления.Периодичность.Квартал;
			ИначеЕсли Период = Перечисления.ДоступныеПериодыОтчета.Полугодие Тогда
				Периодичность = Перечисления.Периодичность.Полугодие;
			Иначе // Год
				Периодичность = Перечисления.Периодичность.Год;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ВидКарточки = Перечисления.ВидыКарточекАнализаБизнеса.Цель Тогда
		
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ВариантПроверки");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ВидСравненияЗначений");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ЗначениеДляСравнения");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ВидИзменения");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Период");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Периодичность");
		
	Иначе // Проверки
		
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СценарийПланирования");
		
		Если ВариантПроверки = Перечисления.ВариантыПроверокАнализаБизнеса.Динамика Тогда
			
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ВидСравненияЗначений");
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ЗначениеДляСравнения");
			
			
		ИначеЕсли ВариантПроверки = Перечисления.ВариантыПроверокАнализаБизнеса.СравнениеСПоказателем Тогда
			
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ВидИзменения");
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Периодичность");
			
		Иначе // Сравнение с числом 
			
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ВидИзменения");
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Периодичность");
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ЗначениеДляСравнения");
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
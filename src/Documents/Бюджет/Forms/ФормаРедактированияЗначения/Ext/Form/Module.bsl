﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если 	НЕ Параметры.Свойство("Показатель") 
		ИЛИ НЕ Параметры.Свойство("Период") 
		ИЛИ НЕ Параметры.Свойство("Периодичность") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТекущийПоказатель = Параметры.Показатель;
	Период = Параметры.Период;
	ЭтоГруппаПоказателей = (ТекущийПоказатель.ТипПоказателя = Перечисления.ТипыПоказателейБизнеса.Группа);
	ЗаполнитьЗаголовокФормы(ТекущийПоказатель, Период, Параметры.Периодичность);
	
	Если ТекущийПоказатель.ВидОтчета = Перечисления.ВидыФинансовыхОтчетов.ДенежныйПоток Тогда
		Элементы.ДанныеНаправление.Видимость = Ложь;
		Элементы.ДанныеЗаказ.Видимость = Ложь;
	КонецЕсли;
	
	Если ТекущийПоказатель.ВидОтчета = Перечисления.ВидыФинансовыхОтчетов.Баланс Тогда
		Элементы.ДанныеНаправление.Видимость = Ложь;
		Элементы.ДанныеЗаказ.Видимость = Ложь;
		Элементы.ДанныеПроект.Видимость = Ложь;
	КонецЕсли;
	
	ПроектВШапке = ЗначениеЗаполнено(Параметры.Проект);
	ПодразделениеВШапке = ЗначениеЗаполнено(Параметры.Подразделение);
	
	Элементы.ДанныеПоказатель.Видимость = ЭтоГруппаПоказателей;
	
	Для каждого СтруктураСтроки Из Параметры.ДанныеЗаполненияТаблицы Цикл
		НоваяСтрока = Данные.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураСтроки);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отменить(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	Если ТабличнаяЧастьЗаполненаКорректно() Тогда
	
		Закрыть(ЗакончитьРедактированиеНаСервере());
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьЗаголовокФормы(Показатель, Период, Периодичность)
	
	ШаблонСтроки = НСтр("ru = '%1 за %2'");
	ПериодСтрокой = ПоказателиБизнесаФормы.ЗаголовокКолонки(Период, Периодичность);
	ЭтаФорма.Заголовок = СтрШаблон(ШаблонСтроки, Показатель, ПериодСтрокой);
	
КонецПроцедуры

&НаСервере
Функция ЗакончитьРедактированиеНаСервере()
	
	ДанныеЗаполненияТаблицы = Новый Массив;
	ВременнаяТаблица = Данные.Выгрузить();
	
	Для каждого ТекущаяСтрока Из ВременнаяТаблица Цикл
		
		ТекущаяСтрока.ДатаПланирования = Период;
		
		Если НЕ ЭтоГруппаПоказателей Тогда
			ТекущаяСтрока.Показатель = ТекущийПоказатель;
		КонецЕсли;
		
		Если ТекущаяСтрока.Показатель.ВидОтчета = Перечисления.ВидыФинансовыхОтчетов.ДенежныйПоток Тогда
			ТекущаяСтрока.Статья = ТекущаяСтрока.Показатель.ИсточникДанных;
			Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.Счет) Тогда
				ТекущаяСтрока.Счет = ПланыСчетов.Управленческий.Банк;
			КонецЕсли;
		Иначе
			ТекущаяСтрока.Счет = ТекущаяСтрока.Показатель.ИсточникДанных;
		КонецЕсли;
		
		СтруктураСтроки = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТекущаяСтрока);
		ДанныеЗаполненияТаблицы.Добавить(СтруктураСтроки);
		
	КонецЦикла;
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("ТекущийПоказатель", ТекущийПоказатель);
	СтруктураВозврата.Вставить("Период", Период);
	СтруктураВозврата.Вставить("ДанныеЗаполненияТаблицы", ДанныеЗаполненияТаблицы);
	
	Возврат СтруктураВозврата;
	
КонецФункции

&НаКлиенте

Функция ТабличнаяЧастьЗаполненаКорректно()
	
	ЕстьОшибки = Ложь;
	НомерСтроки = 0;
	
	Для каждого СтрокаДанных Из Данные Цикл
		
		Если ЭтоГруппаПоказателей И НЕ ЗначениеЗаполнено(СтрокаДанных.Показатель) Тогда
			
			ТекстСообщения = НСтр("ru = 'В строке №%1 необходимо заполнить показатель.'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, Строка(НомерСтроки + 1));
			ПутьКДанным = "Данные[%1].Показатель";
			ПутьКДанным = СтрШаблон(ПутьКДанным, Строка(НомерСтроки));
			
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"ДанныеПоказатель", ПутьКДанным, ЕстьОшибки);
			
		КонецЕсли;
		
		Если СтрокаДанных.Сумма = 0 Тогда
			
			ТекстСообщения = НСтр("ru = 'В строке №%1 необходимо заполнить сумму.'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, Строка(НомерСтроки + 1));
			ПутьКДанным = "Данные[%1].Сумма";
			ПутьКДанным = СтрШаблон(ПутьКДанным, Строка(НомерСтроки));
			
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"ДанныеСумма", ПутьКДанным, ЕстьОшибки);
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаДанных.КоррСчет) Тогда
			
			ТекстСообщения = НСтр("ru = 'В строке №%1 необходимо заполнить счет-источник.'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, Строка(НомерСтроки + 1));
			ПутьКДанным = "Данные[%1].КоррСчет";
			ПутьКДанным = СтрШаблон(ПутьКДанным, Строка(НомерСтроки));
			
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"ДанныеСумма", ПутьКДанным, ЕстьОшибки);
			
		КонецЕсли;
		
		НомерСтроки = НомерСтроки + 1;
		
	КонецЦикла;
	
	Возврат НЕ ЕстьОшибки;
	
КонецФункции

#КонецОбласти



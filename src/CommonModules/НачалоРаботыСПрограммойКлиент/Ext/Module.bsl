
#Область СлужебныйИнтерфейс

Процедура ОбработкаЗакрытияФормыНачалаРаботы(Результат, ПараметрыНачалаРаботы) Экспорт
	Перем ОбработкаЗавершена;
	
	Если Результат = Неопределено Тогда
		
		ЗавершитьРаботуСистемы(Ложь, Ложь);
		
	ИначеЕсли ТипЗнч(Результат) = Тип("Структура") Тогда
		
		Если Результат.ДополнительныйПараметр = НачалоРаботыСПрограммойСервер.ЗначениеДополнительногоПараметра() Тогда
			
			НачалоРаботыСПрограммойСервер.УстановитьСтандартныйИнтерфейс();
			ОбновитьИнтерфейс();
			
		Иначе
			
			Если Результат.НачатьРаботу <> Истина Тогда
				
				ЗавершитьРаботуСистемы(Ложь, Ложь)
				
			КонецЕсли;
			
			НачалоРаботыСПрограммойКлиентПереопределяемый.ОбработкаЗакрытияФормыНачалаРаботыНаКлиенте(Результат, ПараметрыНачалаРаботы, ОбработкаЗавершена);
			НачалоРаботыСПрограммойПереопределяемый.ОбработкаЗакрытияФормыНачалаРаботы(Результат, ПараметрыНачалаРаботы, ОбработкаЗавершена);
			
			Если ОбработкаЗавершена = Истина Тогда
				
				НачалоРаботыСПрограммойСервер.УстановитьСтандартныйИнтерфейс(Результат.ПользовательИмя);
				
				Если НЕ ПараметрыНачалаРаботы.РазделениеВключено
					И Результат.НачатьРаботу = Истина Тогда
					
					ДополнительныеПараметрыКоманднойСтроки = "";
					Если Результат.Свойство("ПользовательИмя") Тогда
						
						ДополнительныеПараметрыКоманднойСтроки = "/N" + """" + Результат.ПользовательИмя + """";
						
					КонецЕсли;
					
					ЗавершитьРаботуСистемы(Ложь, Истина, ДополнительныеПараметрыКоманднойСтроки);
					
				Иначе
					
					ОбновитьИнтерфейс();
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#конецОбласти
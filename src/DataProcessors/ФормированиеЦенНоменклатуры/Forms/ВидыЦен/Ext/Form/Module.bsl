﻿
#Область СлужебныеПроцедурыФункции

&НаСервере
Процедура ЗаполнитьДеревоОперандов(МассивВидовЦен)
	
	ДеревоРезультата = Новый ДеревоЗначений;
	
	ВключаяЦеныНоменклатуры = Истина;
	Параметры.Свойство("ЦеныНоменклатуры", ВключаяЦеныНоменклатуры);
	
	ВключаяЦеныКонтрагентов = КэшЗначений.ФОУчетЦенКонтрагентов;
	Если КэшЗначений.ФОУчетЦенКонтрагентов Тогда
		
		Параметры.Свойство("ЦеныКонтрагентов", ВключаяЦеныКонтрагентов);
		
	КонецЕсли;
	
	Обработки.ФормированиеЦенНоменклатуры.ПолучитьДеревоВидовЦен(ДеревоРезультата, МассивВидовЦен, ВключаяЦеныНоменклатуры, ВключаяЦеныКонтрагентов);
	
	ЗначениеВРеквизитФормы(ДеревоРезультата, "ВидыЦен");
	
КонецПроцедуры

#КонецОбласти

#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перем МассивВидовЦен;
	
	Если НЕ Параметры.Свойство("ВидыЦен", МассивВидовЦен) Тогда
		
		МассивВидовЦен = Новый Массив;
		
	КонецЕсли;
	
	ТекущийВидыЦен.ЗагрузитьЗначения(МассивВидовЦен);
	
	КэшЗначений = Новый Структура;
	КэшЗначений.Вставить("ФОУчетЦенКонтрагентов", ПолучитьФункциональнуюОпцию("УчетЦенКонтрагентов"));
	КэшЗначений.Вставить("Статический", Перечисления.ТипыВидовЦен.Статический);
	КэшЗначений.Вставить("ДинамическийПроцент", Перечисления.ТипыВидовЦен.ДинамическийПроцент);
	КэшЗначений.Вставить("ДинамическийФормула", Перечисления.ТипыВидовЦен.ДинамическийФормула);
	
	ЗаполнитьДеревоОперандов(МассивВидовЦен);
	
КонецПроцедуры

#КонецОбласти

#Область СобытияРеквизитовФормы

&НаКлиенте
Процедура ВидыЦенИспользованиеПриИзменении(Элемент)
	
	ДанныеТекущейСтроки = Элементы.ВидыЦен.ТекущиеДанные;
	
	Если ДанныеТекущейСтроки <> Неопределено
		И НЕ ЗначениеЗаполнено(ДанныеТекущейСтроки.ВидЦен) Тогда
		
		ПодчиненныеСтроки = ДанныеТекущейСтроки.ПолучитьЭлементы(); 
		Для каждого Строка Из ПодчиненныеСтроки Цикл
			
			ДанныеТекущейСтроки.Свойство("Использование", Строка.Использование);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура Выбрать(Команда)
	
	Результат			= Новый Структура;
	Результат.Вставить("ВыборПроизведен", Истина);
	
	ВыбранныеВидыЦен	= Новый Соответствие;
	
	// Дерево видов цен не велико, поэтому решим задачу в "лоб" (обходом)
	СтрокиГруппВидовЦен = ВидыЦен.ПолучитьЭлементы();
	Для каждого ГруппаВидовЦен Из СтрокиГруппВидовЦен Цикл
		
		СтрокиБазовыхВидовЦен = ГруппаВидовЦен.ПолучитьЭлементы();
		Для каждого СтрокаБазовогоВидаЦен Из СтрокиБазовыхВидовЦен Цикл
			
			Если НЕ СтрокаБазовогоВидаЦен.Использование Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			ПодчиненныеВидыЦен		= Новый Массив;
			СтрокиРасчетныхВидовЦен = СтрокаБазовогоВидаЦен.ПолучитьЭлементы();
			Для каждого СтрокаВидаЦен Из СтрокиРасчетныхВидовЦен Цикл
				
				ПодчиненныеВидыЦен.Добавить(СтрокаВидаЦен.ВидЦен);
				
			КонецЦикла;
			
			ВыбранныеВидыЦен.Вставить(СтрокаБазовогоВидаЦен.ВидЦен, ПодчиненныеВидыЦен);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Результат.Вставить("ВыбранныеВидыЦен", ВыбранныеВидыЦен);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Результат = Новый Структура;
	Результат.Вставить("ВыборПроизведен", Ложь);
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти
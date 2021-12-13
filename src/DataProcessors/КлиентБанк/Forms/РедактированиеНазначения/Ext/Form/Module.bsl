﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем КэшСтатьиРасходовНаОС; // чтобы по нескольку раз не обращаться к общему модулю за статьёй расходов. 

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Множественный Тогда
		ВидОперацииВходящие   = Параметры.ВидОперацииВходящих;
		ВидОперацииИсходящие  = Параметры.ВидОперацииИсходящих;
	Иначе
		ВидОперацииВходящие   = Параметры.ВидОперации;
		ВидОперацииИсходящие  = Параметры.ВидОперации;
	КонецЕсли;
	
	НазначениеПлатежа     = Параметры.НазначениеПлатежа;
	Исходящий             = Параметры.Исходящий;
	Множественный         = Параметры.Множественный;
	КоличествоВходящих    = Параметры.КоличествоВходящих;
	КоличествоИсходящих   = Параметры.КоличествоИсходящих;
	Если Параметры.Множественный Тогда
		Элементы.НазначениеПлатежа.Видимость = Ложь;
		
		Элементы.ВидОперацииВходящие.Заголовок = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Вид операции поступлений (%1 %2)'"),
				КоличествоВходящих,
				ПодобратьСловоПодЧисло(
					КоличествоВходящих,
					НСтр("ru='документ'"),
					НСтр("ru='документа'"),
					НСтр("ru='документов'")));
			
		Элементы.ВидОперацииИсходящие.Заголовок = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Вид операции списаний (%1 %2)'"),
				КоличествоИсходящих,
				ПодобратьСловоПодЧисло(
					КоличествоИсходящих,
					НСтр("ru='документ'"),
					НСтр("ru='документа'"),
					НСтр("ru='документов'")));
		
	Иначе
		Элементы.ВидОперацииВходящие.Видимость   = НЕ Параметры.Исходящий;
		Элементы.ВидОперацииИсходящие.Видимость  = Параметры.Исходящий;
	КонецЕсли;
	
	ЗаполнитьСпискиВыбораВидовОпераций();
	УстановитьВидимостьИДоступностьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Очистить();
	
	Если КоличествоИсходящих > 0 ИЛИ Исходящий Тогда
		ПроверяемыеРеквизиты.Добавить("ВидОперацииИсходящие");
	КонецЕсли;
	
	Если КоличествоВходящих > 0 ИЛИ (НЕ Исходящий И НЕ Множественный) Тогда
		ПроверяемыеРеквизиты.Добавить("ВидОперацииВходящие");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидОперацииИсходящиеПриИзменении(Элемент)
	
	УстановитьВидимостьИДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииВходящиеПриИзменении(Элемент)
	
	УстановитьВидимостьИДоступностьЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(
		Новый Структура("ВидОперации, ВидОперацииИсходящих, ВидОперацииВходящих", 
			?(Исходящий,ВидОперацииИсходящие, ВидОперацииВходящие),
			ВидОперацииИсходящие,
			ВидОперацииВходящие));
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть(КодВозвратаДиалога.Отмена);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСпискиВыбораВидовОпераций()
	
	ДвиженияДенежныхСредствВызовСервера.ЗаполнитьСписокВыбораВидовОпераций("ПоступлениеНаСчет", Элементы.ВидОперацииВходящие.СписокВыбора);
	ДвиженияДенежныхСредствВызовСервера.ЗаполнитьСписокВыбораВидовОпераций("РасходСоСчета", Элементы.ВидОперацииИсходящие.СписокВыбора);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьИДоступностьЭлементов()
	
	Если Множественный Тогда
		Элементы.ГруппаНастройкиВходящих.Видимость = (КоличествоВходящих>0);
		Элементы.ГруппаНастройкиИсходящих.Видимость = (КоличествоИсходящих>0);
	Иначе
		Если Исходящий Тогда
			Элементы.ГруппаНастройкиИсходящих.Видимость = Истина;
			Элементы.ГруппаНастройкиВходящих.Видимость = Ложь;
		Иначе
			Элементы.ГруппаНастройкиИсходящих.Видимость = Ложь;
			Элементы.ГруппаНастройкиВходящих.Видимость = Истина;
			Элементы.ГруппаВидыОпераций.ТекущаяСтраница = Элементы.ПустаяСтраницаГруппы;
		КонецЕсли;
	КонецЕсли;
	
	Попытка
		Если ЗначениеЗаполнено(ВидОперацииИсходящие) Тогда
			Элементы.ГруппаВидыОпераций.ТекущаяСтраница = Элементы["Страница"+ ОбщегоНазначения.ИмяЗначенияПеречисления(ВидОперацииИсходящие)];
		Иначе
			Элементы.ГруппаВидыОпераций.ТекущаяСтраница = Элементы.ПустаяСтраницаГруппы;
		КонецЕсли;
	Исключение
		//
	КонецПопытки;
	
КонецПроцедуры

// Подбирает слова под число
// Например:
//		ПодобратьСловоПодЧисло(21, "Дань", "Дня", "Дней") = День
//		ПодобратьСловоПодЧисло(35, "Дань", "Дня", "Дней") = Дней
//
Функция ПодобратьСловоПодЧисло(Число, СловоДляОдин, СловоДляДва, СловоДляПять) Экспорт
	
	Если Число > 4 И Число < 21 Тогда
		
		Возврат СловоДляПять;
		
	ИначеЕсли (Число % 10) = 1 Тогда
		
		Возврат СловоДляОдин;
		
	ИначеЕсли (Число % 10) <= 5 Тогда
		
		Возврат СловоДляДва;
		
	Иначе
		
		Возврат СловоДляПять;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

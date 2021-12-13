﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("КлючСвязи", КлючСвязи);
	Параметры.Свойство("Спецификация", Спецификация);
	
	ТекущийОбъект = Спецификация.ПолучитьОбъект();
	Если Параметры.Реквизиты.Количество()>0 Тогда
		ТекущийОбъект.ДополнительныеРеквизиты.Очистить();
		Для каждого ДанныеДопРеквизитов Из Параметры.Реквизиты Цикл
			НоваяСтрока = ТекущийОбъект.ДополнительныеРеквизиты.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеДопРеквизитов);
		КонецЦикла;
	КонецЕсли; 
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
	
	ДополнительныеПараметры = УправлениеСвойствамиУНФ.ЗаполнитьДополнительныеПараметры(Объект, "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СохранитьИзмененияСервер();
	
	Результат = Новый Структура;
	Результат.Вставить("КлючСвязи", КлючСвязи);
	Результат.Вставить("Реквизиты", Новый Массив);
	Для каждого СтрокаОписания Из ЭтотОбъект.Свойства_ОписаниеДополнительныхРеквизитов Цикл
		СтруктураСтроки = Новый Структура;
		СтруктураСтроки.Вставить("Свойство", СтрокаОписания.Свойство);
		СтруктураСтроки.Вставить("Значение", ЭтотОбъект[СтрокаОписания.ИмяРеквизитаЗначение]);
		Результат.Реквизиты.Добавить(СтруктураСтроки);
	КонецЦикла;
	Закрыть(Результат);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьИзмененияСервер()
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиБиблиотек

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти 


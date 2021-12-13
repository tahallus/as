﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТолькоПросмотр = Истина;
	
	Сообщение = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "Сообщение");
	Если Не ЗначениеЗаполнено(Сообщение) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПодписи(Сообщение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьПодписи(Сообщение)
	
	УстановленныеПодписи = ЭлектронныеДокументыЭДО.УстановленныеПодписи(Сообщение);
	Для Каждого СвойстваПодписи Из УстановленныеПодписи Цикл
		ЗаполнитьЗначенияСвойств(Список.Добавить(), СвойстваПодписи);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

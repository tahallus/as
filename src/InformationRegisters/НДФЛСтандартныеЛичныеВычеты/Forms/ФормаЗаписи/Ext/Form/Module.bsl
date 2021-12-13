﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ГруппаКодВычета.Доступность = Запись.Применяется;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПрименяетсяПриИзменении(Элемент)
	
	Элементы.ГруппаКодВычета.Доступность = Запись.Применяется;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьПодробнееКод104(Команда)
	
	РегламентированнаяОтчетностьУСНКлиент.ПоказатьОписаниеВычетаНДФЛ("104");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПодробнееКод105(Команда)
	
	РегламентированнаяОтчетностьУСНКлиент.ПоказатьОписаниеВычетаНДФЛ("105");
	
КонецПроцедуры

#КонецОбласти


﻿#Область ОбработчикиСобытийФормы

// Открытие формы из заказ-наряда (ТЧ Исполнители)
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("СписокМножественныВыбор") Тогда
		Элементы.Список.МножественныйВыбор = Истина;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВсеРесурсы = Справочники.ВидыРесурсовПредприятия.ВсеРесурсы;
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", ВсеРесурсы,
		ВидСравненияКомпоновкиДанных.НеРавно);
	
КонецПроцедуры

#КонецОбласти

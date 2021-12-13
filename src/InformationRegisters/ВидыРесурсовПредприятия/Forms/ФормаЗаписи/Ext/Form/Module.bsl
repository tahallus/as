﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если (Параметры.ЗначенияЗаполнения.Свойство("ВидРесурсаПредприятия")
		И ЗначениеЗаполнено(Параметры.ЗначенияЗаполнения.ВидРесурсаПредприятия))
		ИЛИ Параметры.Свойство("ДоступностьВида") Тогда
		
		Элементы.ВидРесурсаПредприятия.ТолькоПросмотр = Истина;
		
		Если Параметры.Свойство("ЗначениеВидРесурсаПредприятия") Тогда
			Запись.ВидРесурсаПредприятия = Параметры.ЗначениеВидРесурсаПредприятия;
		КонецЕсли;
		
	ИначеЕсли (Параметры.ЗначенияЗаполнения.Свойство("РесурсПредприятия")
		И ЗначениеЗаполнено(Параметры.ЗначенияЗаполнения.РесурсПредприятия))
		ИЛИ Параметры.Свойство("ДоступностьРесурса") Тогда
		
		Элементы.РесурсПредприятия.ТолькоПросмотр = Истина;
		
		Если Запись.ВидРесурсаПредприятия = Справочники.ВидыРесурсовПредприятия.ВсеРесурсы Тогда
			Элементы.ВидРесурсаПредприятия.ТолькоПросмотр = Истина;
		КонецЕсли;
		
	ИначеЕсли Параметры.Свойство("ДоступностьВсеРесурсы")
		И Запись.ВидРесурсаПредприятия = Справочники.ВидыРесурсовПредприятия.ВсеРесурсы Тогда
		
		Элементы.ВидРесурсаПредприятия.ТолькоПросмотр = Истина;
		
	ИначеЕсли Параметры.ЗначениеКопирования <> Неопределено 
		И Параметры.ЗначениеКопирования.ВидРесурсаПредприятия = Справочники.ВидыРесурсовПредприятия.ВсеРесурсы Тогда
		
		Элементы.ВидРесурсаПредприятия.ТолькоПросмотр = Истина;
		
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ВидыРесурсовПредприятия");
	
КонецПроцедуры // ПослеЗаписи()

#КонецОбласти
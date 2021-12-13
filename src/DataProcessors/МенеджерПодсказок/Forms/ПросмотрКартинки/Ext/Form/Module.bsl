﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ИмяКартинки") Тогда
		МакетКартинки = Обработки.МенеджерПодсказок.ПолучитьМакет(Параметры.ИмяКартинки);
		Картинка = ПоместитьВоВременноеХранилище(МакетКартинки, УникальныйИдентификатор);
	Иначе
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

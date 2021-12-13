﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокГруппНоменклатуры = Параметры.СписокГруппНоменклатуры;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ЗаполнитьПредставленияЭлементовСпискаСерверБезКонтекста(СписокГруппНоменклатуры);
	Закрыть(СписокГруппНоменклатуры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет представления элементов и удаляет пустые значения.
//
&НаСервереБезКонтекста
Процедура ЗаполнитьПредставленияЭлементовСпискаСерверБезКонтекста(СписокГруппНоменклатуры)
	
	МассивЭлементовНаУдаление = Новый Массив;
	
	Для каждого ЭлементСписка Из СписокГруппНоменклатуры Цикл
	
		Если НЕ ЗначениеЗаполнено(ЭлементСписка.Значение) Тогда
			
			МассивЭлементовНаУдаление.Добавить(ЭлементСписка);
			Продолжить;
			
		КонецЕсли;
		
		ЭлементСписка.Представление = ЭлементСписка.Значение.Наименование;
	
	КонецЦикла;
	
	Для каждого ЭлементМассива Из МассивЭлементовНаУдаление Цикл
	
		СписокГруппНоменклатуры.Удалить(ЭлементМассива);
	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

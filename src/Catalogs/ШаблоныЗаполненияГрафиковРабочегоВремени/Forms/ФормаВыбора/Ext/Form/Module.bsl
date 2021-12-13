﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьОтборНедействительная(ЭтотОбъект);
	УстановитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПоказыватьНедействительную(Команда)
	
	Элементы.ПоказыватьНедействительную.Пометка = Не Элементы.ПоказыватьНедействительную.Пометка;
	УстановитьОтборНедействительная(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		СтандартнаяОбработка = Ложь;
		Возврат 
	КонецЕсли;
	
	Если ТекущиеДанные.ЭтоГруппа Тогда
		СтандартнаяОбработка = Ложь;
		Возврат 
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

		НовоеУсловноеОформление = УсловноеОформление.Элементы.Добавить();
		РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Список.Недействителен", Истина, ВидСравненияКомпоновкиДанных.Равно);
		РаботаСФормой.ДобавитьОформляемыеПоля(НовоеУсловноеОформление, "Наименование");
		РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекстаТабличнойЧасти); 

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборНедействительная(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список,
		"Недействителен",
		Ложь,
		,
		,
		Не Форма.Элементы.ПоказыватьНедействительную.Пометка);
	
КонецПроцедуры

#КонецОбласти

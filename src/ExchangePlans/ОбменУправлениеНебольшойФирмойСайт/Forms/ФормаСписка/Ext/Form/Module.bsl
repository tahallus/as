#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра("ЭтотУзел", ПланыОбмена.ОбменУправлениеНебольшойФирмойСайт.ЭтотУзел());
	
	ИспользоватьОбменССайтами = ПолучитьФункциональнуюОпцию("ИспользоватьОбменССайтами");
	Элементы.ОткрытьСайты.Видимость = ПолучитьФункциональнуюОпцию("СайтСоздан");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗавершенСеансОбменаССайтом" Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Копирование Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВызовИзПланаОбмена", Истина);
	
	ОткрытьФорму("Обработка.ПомощникСозданияОбменаДаннымиССайтом.Форма.Форма", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодключитьОбмен(Команда)
	
	Если НЕ ИспользоватьОбменССайтами Тогда
		ПодключитьОбменСервер();
		ОбновитьИнтерфейс();
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВызовИзПланаОбмена", Истина);
	ОткрытьФорму("Обработка.ПомощникСозданияОбменаДаннымиССайтом.Форма.Форма", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодключитьОбменСервер()
	
	УстановитьПривилегированныйРежим(Истина);
	Константы.ФункциональнаяОпцияИспользоватьОбменССайтами.Установить(Истина);
	ИспользоватьОбменССайтами = Истина;
	
КонецПроцедуры

#КонецОбласти

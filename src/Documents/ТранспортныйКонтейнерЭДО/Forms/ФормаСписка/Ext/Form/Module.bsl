﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Распаковать(Команда)
	Контейнеры = Элементы.Список.ВыделенныеСтроки;
	ТранспортныеКонтейнерыЭДОСлужебныйКлиент.РаспаковатьКонтейнеры(Контейнеры);
КонецПроцедуры

#КонецОбласти

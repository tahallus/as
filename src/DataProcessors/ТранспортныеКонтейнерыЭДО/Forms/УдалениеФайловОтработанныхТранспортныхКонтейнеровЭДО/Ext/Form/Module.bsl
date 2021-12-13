﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьТаблицуФайловОтработанныхКонтейнеров();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтработанныеКонтейнерыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(, ТекущиеДанные.Документ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СнятьВсе(Команда)
	
	УстановитьЗначенияФлажков(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьВсе(Команда)
	
	УстановитьЗначенияФлажков(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдалениеОтмеченныеКонтейнеры(Команда)
	
	УдалитьДанные();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеПоТаблицам(Команда)
	
	ЗаполнитьТаблицуФайловОтработанныхКонтейнеров();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуФайловОтработанныхКонтейнеров()
	
	ОтработанныеТранспортныеКонтейнеры.Очистить();
	
	ЗапросКонтейнеров = Новый Запрос;
	УдаляемыеСтатусы = Новый СписокЗначений;
	УдаляемыеСтатусы.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.Отменен);
	УдаляемыеСтатусы.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.Доставлен);
	УдаляемыеСтатусы.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.Распакован);
	УдаляемыеСтатусы.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.Отправлен);
	ЗапросКонтейнеров.УстановитьПараметр("Статус", УдаляемыеСтатусы);
	
	ЗапросКонтейнеров.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
	|	ТранспортныйКонтейнерЭДОПрисоединенныеФайлы.Ссылка КАК Документ,
	|	ТранспортныйКонтейнерЭДОПрисоединенныеФайлы.ВладелецФайла.Статус КАК Статус,
	|	ЛОЖЬ КАК Выбран,
	|	ТранспортныйКонтейнерЭДОПрисоединенныеФайлы.ДатаСоздания КАК ДатаПолучения,
	|	ТранспортныйКонтейнерЭДОПрисоединенныеФайлы.ВладелецФайла.Организация КАК Организация,
	|	ТранспортныйКонтейнерЭДОПрисоединенныеФайлы.ВладелецФайла.Контрагент КАК Контрагент,
	|	ТранспортныйКонтейнерЭДОПрисоединенныеФайлы.ВладелецФайла.Направление КАК Направление
	|ИЗ
	|	Справочник.ТранспортныйКонтейнерЭДОПрисоединенныеФайлы КАК ТранспортныйКонтейнерЭДОПрисоединенныеФайлы
	|ГДЕ
	|	ТранспортныйКонтейнерЭДОПрисоединенныеФайлы.ВладелецФайла ССЫЛКА Документ.ТранспортныйКонтейнерЭДО
	|	И ТранспортныйКонтейнерЭДОПрисоединенныеФайлы.ПометкаУдаления = ЛОЖЬ
	|	И ВЫРАЗИТЬ(ТранспортныйКонтейнерЭДОПрисоединенныеФайлы.ВладелецФайла КАК Документ.ТранспортныйКонтейнерЭДО).Статус В (&Статус)";
	
	ЗначениеВРеквизитФормы(ЗапросКонтейнеров.Выполнить().Выгрузить(), "ОтработанныеТранспортныеКонтейнеры");
	
КонецПроцедуры

&НаСервере
Процедура УдалитьДанные()
	
	Для Каждого СтрокаУдаления Из ОтработанныеТранспортныеКонтейнеры Цикл
		Если СтрокаУдаления.Выбран Тогда
			НачатьТранзакцию();
			Попытка
				ОбъектУдаления = ОбщегоНазначенияБЭД.ОбъектПоСсылкеДляИзменения(СтрокаУдаления.Документ);
				ОбъектУдаления.ПометкаУдаления = Истина;
				ОбъектУдаления.Записать();
				ЗафиксироватьТранзакцию();
			Исключение
				ОтменитьТранзакцию();
				ВызватьИсключение;
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	
	ЗаполнитьТаблицуФайловОтработанныхКонтейнеров();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияФлажков(ПараметрУстановки)
	
	Для Каждого Строка Из ОтработанныеТранспортныеКонтейнеры Цикл
		Строка.Выбран = ПараметрУстановки;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

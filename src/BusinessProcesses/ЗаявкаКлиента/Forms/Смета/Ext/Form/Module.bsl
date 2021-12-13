﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НачальныйПризнакВыполнения = Объект.Выполнена;
	ЗадачаОбъект = РеквизитФормыВЗначение("Объект");
	ЗаданиеОбъект = ЗадачаОбъект.БизнесПроцесс.ПолучитьОбъект();
	ЗначениеВРеквизитФормы(ЗаданиеОбъект, "Задание");

	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.СрокНачалаИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.ДатаИсполнения.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");

	БизнесПроцессыИЗадачиСервер.ФормаЗадачиПриСозданииНаСервере(
		ЭтаФорма, Объект, Элементы.ГруппаСостояние, Элементы.ДатаИсполнения);

	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КоммерческоеПредложениеКлиенту.Ссылка
		|ИЗ
		|	Документ._Смета КАК КоммерческоеПредложениеКлиенту
		|ГДЕ
		|	НЕ КоммерческоеПредложениеКлиенту.ПометкаУдаления
		|	И КоммерческоеПредложениеКлиенту.ДокументОснование = &Сделка");
		
	Запрос.УстановитьПараметр("Сделка", Задание.Предмет);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	КоличествоДействующихМедиапланов = Выборка.Количество();
	
	Если КоличествоДействующихМедиапланов = 1 Тогда
		Выборка.Следующий();
		Смета = Выборка.Ссылка;
		Элементы.ДекорацияСмета.Заголовок   = Смета;
	ИначеЕсли КоличествоДействующихМедиапланов > 1 Тогда
		Элементы.ДекорацияСмета.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Смет - %1'"),
		                                                                                КоличествоДействующихМедиапланов) ;
	Иначе
		Элементы.ДекорацияСмета.Заголовок = НСтр("ru='Создать смету'");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Перем ПараметрЗаявкаКлиента;
	
	Если ИмяСобытия = "Запись_Смета"
		И Параметр.Свойство("ЗаявкаКлиента", ПараметрЗаявкаКлиента) Тогда
		
		Если ПараметрЗаявкаКлиента = Задание.Предмет Тогда
			Смета                               = Источник;
			Элементы.ДекорацияСмета.Заголовок   = Источник;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()

	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ВыполненоВыполнить()

	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма,Истина,Новый Структура("ЗаявкаКлиента",Объект.Предмет));

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСметаНажатие(Элемент)
	
	Если ЗначениеЗаполнено(Смета) Тогда
		ПоказатьЗначение(Неопределено, Смета);
	ИначеЕсли СтрНайти(Элементы.ДекорацияСмета.Заголовок,НСтр("ru = 'Создать'")) > 0  Тогда
		ОткрытьФорму(
			"Документ._Смета.ФормаОбъекта",
			Новый Структура("Основание", Задание.Предмет),,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		
		СтруктураОтбор = Новый Структура("ЗаявкаКлиента", Задание.Предмет);
		ПараметрыФормы = Новый Структура("Отбор", СтруктураОтбор);
		
		ОткрытьФорму(
			"Документ._Смета.Форма.ФормаСписка",
			ПараметрыФормы,,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

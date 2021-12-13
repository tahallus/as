﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Параметры.Свойство("ОбъектОтбора", ОбъектСсылка);
	
	Если ТипЗнч(ОбъектСсылка) = Тип("ДокументСсылка.СообщениеОбменСБанками") Тогда
		РеквизитыСообщения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОбъектСсылка, "ВидЭД, НастройкаОбмена");
		Если РеквизитыСообщения.ВидЭД = Перечисления.ВидыЭДОбменСБанками.ВыпискаБанка
			ИЛИ РеквизитыСообщения.ВидЭД = Перечисления.ВидыЭДОбменСБанками.ЗапросВыписки
			ИЛИ РеквизитыСообщения.ВидЭД = Перечисления.ВидыЭДОбменСБанками.ЗапросЗонд Тогда
			ОбъектСсылка = РеквизитыСообщения.НастройкаОбмена;
		Иначе
			ОбъектСсылка = ОбменСБанкамиСлужебный.ОбъектПривязки(ОбъектСсылка);
		КонецЕсли;
	КонецЕсли;
	
	ИсходныйОбъект = ОбъектСсылка;
	
	Если ЗначениеЗаполнено(ОбъектСсылка) Тогда
		ОбновитьДеревоСтруктурыПодчиненностиЭД();
	КонецЕсли;
	
	Элементы.ЖурналСобытий.Доступность = Пользователи.ЭтоПолноправныйПользователь();
	Элементы.ВыполнитьСинхронизациюСБанком.Видимость = ОбменСБанкамиСлужебныйВызовСервера.ПравоВыполненияОбмена();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСостояниеОбменСБанками" Тогда
		ОбновитьДеревоСтруктурыПодчиненностиЭД();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТаблицаОтчетаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	ОбъектРасшифровки = Элемент.ТекущаяОбласть.Расшифровка;
	Если ТипЗнч(ОбъектРасшифровки) = Тип("ДокументСсылка.СообщениеОбменСБанками") Тогда
		СтандартнаяОбработка = Ложь;
		ОбменСБанкамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(ОбъектРасшифровки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ВывестиСтруктуруПодчиненностиЭД();
	
КонецПроцедуры

&НаКлиенте
Процедура ЖурналСобытий(Команда)
	
	ПараметрыФормы = Новый Структура;
	
	Отбор = Новый Структура;
	Отбор.Вставить("СсылкаНаОбъект", ОбъектСсылка);
	
	ПараметрыФормы.Вставить("Отбор", Отбор);
	ПараметрыФормы.Вставить("РежимОткрытияОкна", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ОткрытьФорму("РегистрСведений.ЖурналСобытийОбменСБанками.Форма.ФормаСписка", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСинхронизациюСБанком(Команда)
	
	ОчиститьСообщения();
	РеквизитыНастройкиОбмена = РеквизитыНастройкиОбмена(НастройкаОбмена);
	ОбменСБанкамиКлиент.СинхронизироватьСБанком(РеквизитыНастройкиОбмена.Организация, РеквизитыНастройкиОбмена.Банк);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьДеревоСтруктурыПодчиненностиЭД()
	
	Если ТипЗнч(ОбъектСсылка) = Тип("СправочникСсылка.НастройкиОбменСБанками") Тогда
		НастройкаОбмена = ОбъектСсылка;
	Иначе
		НастройкиОбмена = ОбменСБанкамиСлужебный.ОпределитьНастройкиОбменаЭДПоИсточнику(
			ОбъектСсылка, Ложь, Неопределено, Неопределено);
		Если НастройкиОбмена.Результат = "НастройкиОпределены" Тогда
			НастройкаОбмена = НастройкиОбмена.НастройкаОбмена;
		Иначе
			Элементы.ВыполнитьСинхронизациюСБанком.Доступность = Ложь;
		КонецЕсли
	КонецЕсли;
	
	СформироватьДеревьяЭД();
	ВывестиТабличныйДокумент();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревьяЭД()
	
	ДеревоПодчиненныеЭД.ПолучитьЭлементы().Очистить();
	ВывестиПодчиненныеДокументы(ОбъектСсылка, ДеревоПодчиненныеЭД);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьВыборкуПоРеквизитамДокумента(СсылкаНаОбъект)
	
	МетаданныеОбъекта = СсылкаНаОбъект.Метаданные();
	
	Если ТипЗнч(СсылкаНаОбъект) = Тип("СправочникСсылка.НастройкиОбменСБанками") Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Ссылка,
		|	ЛОЖЬ КАК Проведен,
		|	ПометкаУдаления,
		|	Представление
		|ИЗ
		|	Справочник." + МетаданныеОбъекта.Имя + "
		|ГДЕ
		|	Ссылка = &Ссылка
		|";
	Иначе
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Ссылка,
		|	Проведен,
		|	ПометкаУдаления,
		|	Представление
		|ИЗ
		|	Документ." + МетаданныеОбъекта.Имя + "
		|ГДЕ
		|	Ссылка = &Ссылка
		|";
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаОбъект);
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

&НаСервере
Процедура ВывестиПодчиненныеДокументы(ТекущийОбъект, ДеревоРодитель)
	
	Запрос = Новый Запрос;
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	СостоянияОбменСБанками.СообщениеОбмена.Ссылка КАК Ссылка,
		|	СостоянияОбменСБанками.СообщениеОбмена.Статус КАК Статус,
		|	СостоянияОбменСБанками.СообщениеОбмена.ДатаИзмененияСтатуса КАК ДатаИзмененияСтатуса,
		|	СостоянияОбменСБанками.СообщениеОбмена.Направление КАК Направление,
		|	СостоянияОбменСБанками.СообщениеОбмена.Представление КАК Представление,
		|	СостоянияОбменСБанками.СообщениеОбмена.ПометкаУдаления КАК ПометкаУдаления,
		|	СостоянияОбменСБанками.СообщениеОбмена.СообщениеРодитель КАК СообщениеРодитель,
		|	СостоянияОбменСБанками.СообщениеОбмена.ВидЭД КАК ВидЭД
		|ИЗ
		|	РегистрСведений.СвязанныеОбъектыОбменСБанками КАК СостоянияОбменСБанками
		|ГДЕ
		|	СостоянияОбменСБанками.СсылкаНаОбъект = &ТекущийОбъект
		|
		|УПОРЯДОЧИТЬ ПО
		|	СостоянияОбменСБанками.СообщениеОбмена.Дата";
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ТекущийОбъект", ТекущийОбъект);
	
	ДеревоОбъект = РеквизитФормыВЗначение("ДеревоПодчиненныеЭД");
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Неопределено;
		Если Выборка.ВидЭД = Перечисления.ВидыЭДОбменСБанками.ДополнительныеДанные Тогда
			Продолжить;
		КонецЕсли;
		Если ЗначениеЗаполнено(Выборка.СообщениеРодитель) Тогда
			СтруктураОтбора = Новый Структура("Ссылка", Выборка.СообщениеРодитель);
			МассивСтрок = ДеревоОбъект.Строки.НайтиСтроки(СтруктураОтбора, Истина);
			Для Каждого СтрокаДерева Из МассивСтрок Цикл
				НоваяСтрока = СтрокаДерева.Строки.Добавить();
				Прервать;
			КонецЦикла;
		Иначе
			НоваяСтрока = ДеревоОбъект.Строки.Добавить();
		КонецЕсли;

		Если НоваяСтрока <> Неопределено Тогда	
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка,
				"Ссылка, Статус, ДатаИзмененияСтатуса, Направление, Представление, ПометкаУдаления");
		КонецЕсли;
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоОбъект, "ДеревоПодчиненныеЭД");
	
КонецПроцедуры

&НаСервере
Процедура ВывестиТабличныйДокумент()
	
	ТаблицаОтчета.Очистить();
	
	Макет = Документы.СообщениеОбменСБанками.ПолучитьМакет(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ЭД_Список_%1",
		ОбщегоНазначения.КодОсновногоЯзыка()));
	
	ВывестиТекущийДокумент(Макет);
	ВывестиПодчиненныеЭлементыДерева(ДеревоПодчиненныеЭД.ПолучитьЭлементы(), Макет, 1)
	
КонецПроцедуры

&НаСервере
Процедура ВывестиДокументИКартинку(СтрокаДерева, Макет, ЭтоТекущийДокумент = Ложь, ЭтоПодчиненный = Неопределено)
	
	Если ЭтоТекущийДокумент Тогда
		Если СтрокаДерева.Проведен Тогда
			Если ЭтоПодчиненный = Неопределено  Тогда
				Если ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() И ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторВерхНиз");
				ИначеЕсли ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторНиз");
				ИначеЕсли ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторВерх");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторВерх");
				КонецЕсли;
			ИначеЕсли ЭтоПодчиненный = Истина Тогда
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторЛевоНиз");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведен");
				КонецЕсли;
			Иначе
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторЛевоВерх");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведен");
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли СтрокаДерева.ПометкаУдаления Тогда
			Если ЭтоПодчиненный = Неопределено Тогда
				Если ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() И ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторВерхНиз");
				ИначеЕсли ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторНиз");
				ИначеЕсли ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторВерх");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторВерх");
				КонецЕсли;
			ИначеЕсли ЭтоПодчиненный = Истина Тогда
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторЛевоНиз");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдаление");
				КонецЕсли;
			Иначе
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторЛевоВерх");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдаление");
				КонецЕсли;
			КонецЕсли;
		Иначе
			Если СтрокаДерева.Ссылка = ОбъектСсылка Тогда
				Если ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() И ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторВерхНиз");
				ИначеЕсли ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторНиз");
				ИначеЕсли ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторВерх");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторВерх");
				КонецЕсли;
			ИначеЕсли ЭтоПодчиненный = Истина Тогда
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторЛевоНиз");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписан");
				КонецЕсли;
			Иначе
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторЛевоВерх");
				Иначе	
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписан");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		ТаблицаОтчета.Вывести(ОбластьКартинка);
	Иначе
		Если СтрокаДерева.ПометкаУдаления Тогда
			Если ЭтоПодчиненный = Неопределено Тогда
				Если ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() И ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторВерхНиз");
				ИначеЕсли ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторНиз");
				ИначеЕсли ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторВерх");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторВерх");
				КонецЕсли;
			ИначеЕсли ЭтоПодчиненный = Истина Тогда
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторЛевоНиз");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдаление");
				КонецЕсли;
			Иначе
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдалениеКоннекторЛевоВерх");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПомеченНаУдаление");
				КонецЕсли;
			КонецЕсли;
			
		ИначеЕсли СтрокаДерева.Направление = Перечисления.НаправленияЭДО.Исходящий
				И (СтрокаДерева.Статус = Перечисления.СтатусыОбменСБанками.Доставлен) Тогда
			Если ЭтоПодчиненный = Неопределено Тогда
				Если ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() И ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторВерхНиз");
				ИначеЕсли ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторНиз");
				ИначеЕсли ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторВерх");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторВерх");
				КонецЕсли;
			ИначеЕсли ЭтоПодчиненный = Истина Тогда
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторЛевоНиз");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведен");
				КонецЕсли;
			Иначе
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторЛевоВерх");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведен");
				КонецЕсли;
			КонецЕсли;
		Иначе
			Если СтрокаДерева.Ссылка = ОбъектСсылка Тогда
				Если ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() И ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторВерхНиз");
				ИначеЕсли ДеревоПодчиненныеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторНиз");
				ИначеЕсли ДеревоРодительскиеЭД.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторВерх");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторВерх");
				КонецЕсли;
			ИначеЕсли ЭтоПодчиненный = Истина Тогда
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторЛевоНиз");
				Иначе	
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписан");
				КонецЕсли;
			Иначе
				Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписанКоннекторЛевоВерх");
				Иначе
					ОбластьКартинка = Макет.ПолучитьОбласть("ДокументЗаписан");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		ТаблицаОтчета.Присоединить(ОбластьКартинка);
	КонецЕсли;
	
	ОбластьДокумент = Макет.ПолучитьОбласть(?(ЭтоТекущийДокумент,"ТекущийДокумент", "Документ"));
	Если ЭтоТекущийДокумент Тогда
		ОбластьДокумент.Параметры.ПредставлениеДокумента = ПолучитьПредставлениеДокументаДляПечати(СтрокаДерева);
	Иначе
		ОбластьДокумент.Параметры.ПредставлениеДокумента = ПолучитьПредставлениеЭД(СтрокаДерева);
	КонецЕсли;
	ОбластьДокумент.Параметры.Документ = СтрокаДерева.Ссылка;
	ТаблицаОтчета.Присоединить(ОбластьДокумент);
	
КонецПроцедуры

&НаСервере
Функция НеобходимоВывестиВертикальныйКоннектор(УровеньВверх, СтрокаДерева, ИщемСредиПодчиненных = Истина)
	
	ТекущаяСтрока = СтрокаДерева;
	
	Для инд=1 По УровеньВверх Цикл
		ТекущаяСтрока = ТекущаяСтрока.ПолучитьРодителя();
		Если инд = УровеньВверх Тогда
			ИскомыйРодитель = ТекущаяСтрока;
		ИначеЕсли инд = (УровеньВверх-1) Тогда
			ИскомаяСтрока = ТекущаяСтрока;
		КонецЕсли;
	КонецЦикла;
	
	Если ИскомыйРодитель = Неопределено Тогда
		Если ИщемСредиПодчиненных Тогда
			ПодчиненныеЭлементыРодителя = ДеревоПодчиненныеЭД.ПолучитьЭлементы();
		Иначе
			ПодчиненныеЭлементыРодителя = ДеревоРодительскиеЭД.ПолучитьЭлементы();
		КонецЕсли;
	Иначе
		ПодчиненныеЭлементыРодителя =  ИскомыйРодитель.ПолучитьЭлементы();
	КонецЕсли;
	
	Возврат ПодчиненныеЭлементыРодителя.Индекс(ИскомаяСтрока) < (ПодчиненныеЭлементыРодителя.Количество()-1);
	
КонецФункции

&НаСервере
Процедура ВывестиТекущийДокумент(Макет)
	
	Выборка = ПолучитьВыборкуПоРеквизитамДокумента(ОбъектСсылка);
	Если Выборка.Следующий() Тогда
		ВывестиДокументИКартинку(Выборка, Макет, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПредставлениеДокументаДляПечати(Выборка)
	
	ПредставлениеДокумента = Выборка.Представление;
	
	Возврат ПредставлениеДокумента;
	
КонецФункции

&НаСервере
Функция ПолучитьПредставлениеЭД(Выборка)
	
	ПредставлениеДокумента = Выборка.Представление;
	ПредставлениеДокумента = ПредставлениеДокумента + " <" +  Выборка.Статус + ", "
		+ Формат(Выборка.ДатаИзмененияСтатуса, "ДЛФ=") + ">";
	
	Возврат ПредставлениеДокумента;
	
КонецФункции

// Выводит строки дерева подчиненных документов
//
// Параметры:
//     СтрокиДерева - ДанныеФормыКоллекцияЭлементовДерева - строки дерева которые выводятся в табличный документ.
//     Макет - МакетТабличногоДокумента - макет, на основании которого происходит вывод в табличный документ.
//     УровеньРекурсии - Число - уровень рекурсии процедуры.
//
&НаСервере
Процедура ВывестиПодчиненныеЭлементыДерева(СтрокиДерева, Макет, УровеньРекурсии)
	
	Для каждого СтрокаДерева Из СтрокиДерева Цикл
		
		ЭтоИсходныйОбъект = (СтрокаДерева.Ссылка = ИсходныйОбъект);
		ПодчиненныеЭлементыДерева = СтрокаДерева.ПолучитьЭлементы();
		
		Для инд = 1 По УровеньРекурсии Цикл
			Если УровеньРекурсии > инд Тогда
				
				Если НеобходимоВывестиВертикальныйКоннектор(УровеньРекурсии - инд + 1,СтрокаДерева) Тогда
					Область = Макет.ПолучитьОбласть("КоннекторВерхНиз");
				Иначе
					Область = Макет.ПолучитьОбласть("Отступ");
					
				КонецЕсли;
			Иначе 
				
				Если СтрокиДерева.Количество() > 1 И (СтрокиДерева.Индекс(СтрокаДерева)<> (СтрокиДерева.Количество()-1)) Тогда
					Область = Макет.ПолучитьОбласть("КоннекторВерхПравоНиз");
				Иначе
					Область = Макет.ПолучитьОбласть("КоннекторВерхПраво");
				КонецЕсли;
				
			КонецЕсли;
			
			Область.Параметры.Документ = ?(ЭтоИсходныйОбъект, Неопределено, СтрокаДерева.Ссылка);
			
			Если инд = 1 Тогда
				ТаблицаОтчета.Вывести(Область);
			Иначе
				ТаблицаОтчета.Присоединить(Область);
			КонецЕсли;
			
		КонецЦикла;
		
		ВывестиДокументИКартинку(СтрокаДерева, Макет, Ложь, Истина);
		
		// Вывод подчиненных элементов дерева
		ВывестиПодчиненныеЭлементыДерева(ПодчиненныеЭлементыДерева, Макет, УровеньРекурсии + 1);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиСтруктуруПодчиненностиЭД()
	
	ОбновитьДеревоСтруктурыПодчиненностиЭД();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РеквизитыНастройкиОбмена(Знач НастройкаОбмена)
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НастройкаОбмена, "Организация, Банк");
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаОтчета.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоРодительскиеЭД.Ссылка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = ОбъектСсылка;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.ШрифтДиалоговИМеню, , , Истина, Ложь, Ложь, Ложь));
	
КонецПроцедуры

#КонецОбласти

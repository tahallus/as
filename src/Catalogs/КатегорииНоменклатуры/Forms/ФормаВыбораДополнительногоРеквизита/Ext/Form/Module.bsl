﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ЭтоДополнительноеСведение <> Неопределено Тогда
		ЭтоДополнительноеСведение = Параметры.ЭтоДополнительноеСведение;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ЭтоДополнительноеСведение", ЭтоДополнительноеСведение, , , Истина);
	КонецЕсли;
	
	Если Параметры.ВыборОбщегоСвойства Тогда
		
		ВидВыбора = "ВыборОбщегоСвойства";
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "НаборСвойств", , ВидСравненияКомпоновкиДанных.НеЗаполнено, , Истина);
		
		Если ЭтоДополнительноеСведение = Истина Тогда
			АвтоЗаголовок = Ложь;
			Заголовок = НСтр("ru = 'Выбор общего дополнительного сведения'");
		ИначеЕсли ЭтоДополнительноеСведение = Ложь Тогда
			АвтоЗаголовок = Ложь;
			Заголовок = НСтр("ru = 'Выбор общего дополнительного реквизита'");
		КонецЕсли;
		
	ИначеЕсли Параметры.ВыборВладельцаДополнительныхЗначений Тогда
		
		ВидВыбора = "ВыборВладельцаДополнительныхЗначений";
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "НаборСвойств", , ВидСравненияКомпоновкиДанных.Заполнено, , Истина);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ДополнительныеЗначенияИспользуются", Истина, , , Истина);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ВладелецДополнительныхЗначений", ,
			ВидСравненияКомпоновкиДанных.НеЗаполнено, , Истина);
		
		АвтоЗаголовок = Ложь;
		Заголовок = НСтр("ru = 'Выбор образца'");
		
		Элементы.ФормаСоздать.Видимость = Ложь;
		Элементы.ФормаСкопировать.Видимость = Ложь;
		Элементы.ФормаИзменить.Видимость = Ложь;
		Элементы.ФормаУстановитьПометкуУдаления.Видимость = Ложь;
		
		Элементы.СписокКонтекстноеМенюСоздать.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюСкопировать.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюИзменить.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюУстановитьПометкуУдаления.Видимость = Ложь;
	КонецЕсли;
	ЗаполнитьВыбранныеЗначения();
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список,
		"ПредставлениеГруппировкиОбщихСвойств",
		НСтр("ru = 'Общие (для нескольких наборов)'"),
		Истина);
	
	// Группировка свойств по наборам.
	ГруппировкаДанных = Список.КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ГруппировкаДанных.ИдентификаторПользовательскойНастройки = "ГруппировкаСвойствПоНаборам";
	ГруппировкаДанных.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ПоляГруппировки = ГруппировкаДанных.ПоляГруппировки;
	
	ЭлементГруппировкиДанных = ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ЭлементГруппировкиДанных.Поле = Новый ПолеКомпоновкиДанных("НаборСвойствГруппировка");
	ЭлементГруппировкиДанных.Использование = Истина;
	
	// УНФ
	Параметры.Свойство("НаборСвойств", НаборСвойств);
	// Конец УНФ
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Если ВидВыбора = "ВыборОбщегоСвойства" Тогда
		СтандартнаяОбработка = Ложь;
		ОповеститьОВыборе(Новый Структура("ОбщееСвойство", Значение));
		
	ИначеЕсли ВидВыбора = "ВыборВладельцаДополнительныхЗначений" Тогда
		СтандартнаяОбработка = Ложь;
		ОповеститьОВыборе(Новый Структура("ВладелецДополнительныхЗначений", Значение));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Отказ = Истина;
	
	Если НЕ Элементы.ФормаСоздать.Видимость Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЭтоДополнительноеСведение", ЭтоДополнительноеСведение);
	
	Если Копирование Тогда
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элемент.ТекущаяСтрока);
	Иначе
		ЗначенияЗаполнения = Новый Структура;
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	КонецЕсли;
	
	// УНФ
	Если ЗначениеЗаполнено(НаборСвойств) Тогда
		ПараметрыФормы.Вставить("ТекущийНаборСвойств", НаборСвойств);
	КонецЕсли;
	// Конец УНФ
	
	ОткрытьФорму("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	Если НЕ Элементы.ФормаСоздать.Видимость Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", Элемент.ТекущаяСтрока);
		ПараметрыФормы.Вставить("ЭтоДополнительноеСведение", ЭтоДополнительноеСведение);
		
		ОткрытьФорму("ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.ФормаОбъекта", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьВыбранныеЗначения()
	
	Если Параметры.Свойство("ВыбранныеЗначения")
	   И ТипЗнч(Параметры.ВыбранныеЗначения) = Тип("Массив") Тогда
		
		СписокВыбранных.ЗагрузитьЗначения(Параметры.ВыбранныеЗначения);
	КонецЕсли;
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Font");
	ЭлементЦветаОформления.Значение = Новый Шрифт(, , Истина);
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Список.Ссылка");
	ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбораДанных.ПравоеЗначение = СписокВыбранных;
	ЭлементОтбораДанных.Использование  = Истина;
	
	ЭлементОформляемогоПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОформляемогоПоля.Поле = Новый ПолеКомпоновкиДанных("Представление");
	ЭлементОформляемогоПоля.Использование = Истина;
	
КонецПроцедуры

#КонецОбласти

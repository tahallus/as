#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаГлобальныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Параметры.КонтекстныйВызов Тогда
		
		Элементы.Список.Период.ДатаНачала = Параметры.ДатаБольшеИлиРавно;
		Элементы.Список.Период.ДатаОкончания = Параметры.ДатаМеньшеИлиРавно; 
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				ЭтаФорма.Список, "Организация", Параметры.Организация, ВидСравненияКомпоновкиДанных.Равно, , Истина, 
				РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
				
		Если Параметры.ОтобратьУведомленияСРНПТ Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				ЭтаФорма.Список, "РНПТ", , ВидСравненияКомпоновкиДанных.Заполнено, , Истина, 
				РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				ЭтаФорма.Список, "НомерКорректировки", 0, ВидСравненияКомпоновкиДанных.Равно, , Истина, 
				РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		КонецЕсли;
		
	Иначе
		
		ПрослеживаемостьСобытияФормПереопределяемый.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Документы.УведомлениеОбОстаткахПрослеживаемыхТоваров);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	ПрослеживаемостьФормыКлиентПереопределяемый.ОбработкаОповещения(ИмяСобытия, Параметр, Источник, Список)
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеФункцииИПроцедуры

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

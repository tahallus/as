﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("ВладелецНоменклатуры") Тогда
		ВладелецОтбор = Параметры.Отбор.ВладелецНоменклатуры;
		Элементы.ВладелецОтбор.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Номенклатура") Тогда
		Элементы.Список.Отображение = ОтображениеТаблицы.Список;
		
		Если НЕ ЗначениеЗаполнено(Параметры.Отбор.Упаковка)
			И ЗначениеЗаполнено(Параметры.Отбор.Номенклатура) Тогда
			СопоставлениеНоменклатурыКонтрагентовПереопределяемый.БазоваяЕдиницаИзмеренияНоменклатуры(Параметры.Отбор.Номенклатура, Параметры.Отбор.Упаковка);
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьВидимостьКомандыПоискаДублей();

	УстановитьСвойстваПереопределяемыхЭлементовФормы();

	СопоставлениеНоменклатурыКонтрагентовПереопределяемый.ПриСозданииНаСервере_ФормаСпискаНоменклатурыКонтрагентов(ЭтаФорма, Отказ, СтандартнаяОбработка);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВладелецОтборПриИзменении(Элемент)
	
	ПриИзмененииВладельца(Список, ВладелецОтбор);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	СопоставлениеНоменклатурыКонтрагентовКлиентПереопределяемый.Подключаемый_ВыполнитьКомандуИнтеграции_НоменклатурыКонтрагентов(
		Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СопоставлениеНоменклатурыКонтрагентовКлиентПереопределяемый.Подключаемый_ВыполнитьПереопределяемуюКоманду_НоменклатурыКонтрагентов(
		ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискИУдалениеДублей(Команда)
	
	Если ПоискДублейДоступен Тогда
		
		МодульПоискИУдалениеДублейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПоискИУдалениеДублейКлиент");
		
		ПутьКФормеПоиска = МодульПоискИУдалениеДублейКлиент.ИмяФормыОбработкиПоискИУдалениеДублей();
		ОткрытьФорму(ПутьКФормеПоиска);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьСвойстваПереопределяемыхЭлементовФормы()
	
	МетаданныеСопоставления = СопоставлениеНоменклатурыКонтрагентовСлужебный.МетаданныеСопоставленияНоменклатуры();
	
	Заголовок = МетаданныеСопоставления.НоменклатураКонтрагентаПредставлениеСписка;
	
	Элементы.ВладелецОтбор.Заголовок               = МетаданныеСопоставления.ВладелецНоменклатурыПредставлениеОбъекта;
	Элементы.ВладелецНоменклатуры.Заголовок        = МетаданныеСопоставления.ВладелецНоменклатурыПредставлениеОбъекта;
	Элементы.ГруппаДанныеКонтрагента.Заголовок     = СтрШаблон(НСтр("ru = 'Данные %1'"), НРег(МетаданныеСопоставления.ВладелецНоменклатурыВРодительномПадеже));
	Элементы.Номенклатура.Заголовок                = МетаданныеСопоставления.НоменклатураПредставлениеОбъекта;
	Элементы.Характеристика.Заголовок              = МетаданныеСопоставления.ХарактеристикаПредставлениеОбъекта;
	Элементы.Упаковка.Заголовок                    = МетаданныеСопоставления.УпаковкаПредставлениеОбъекта;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКомандыПоискаДублей()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПоискИУдалениеДублей") Тогда
		ПоискДублейДоступен = Истина;
	Иначе
		Элементы.ГруппаПоискаДублей.Видимость = Ложь;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииВладельца(Список, Знач ВладелецОтбор)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "ВладелецНоменклатуры", ВладелецОтбор,,,ЗначениеЗаполнено(ВладелецОтбор));
		
КонецПроцедуры

#КонецОбласти
﻿
#Область ОбработчикиСобытийФормы

// Процедура обработчик события ПриСозданииНаСервере
// Осуществляет первоначальное заполнение реквизитов формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Налог = Перечисления.ТипыНачисленийИУдержаний.Налог;
	Удержание = Перечисления.ТипыНачисленийИУдержаний.Удержание;
	
	УчетНалогов = ПолучитьФункциональнуюОпцию("ВестиУчетНалогаНаДоходыИВзносов");
	Если Не УчетНалогов Тогда
		
		ЭлементСписка = Элементы.Тип.СписокВыбора.НайтиПоЗначению(Перечисления.ТипыНачисленийИУдержаний.Налог);
		Если ЭлементСписка <> Неопределено Тогда
			
			Элементы.Тип.СписокВыбора.Удалить(ЭлементСписка);
			
		КонецЕсли;
		
	КонецЕсли; 
	
	ЭтоНалог = (Объект.Тип = Налог);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВидНалога", "Видимость", ЭтоНалог);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаФормула", "Видимость", НЕ ЭтоНалог);
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПриИзмененииТипаВидаНачисленияНаСервере(Объект.Тип);
		
	КонецЕсли;
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура обработчик события ПослеЗаписиНаСервере
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
КонецПроцедуры // ПослеЗаписиНаСервере()

// Процедура обработчик события ОбработкаОповещения
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменилисьСчетаВидыНачисленийИУдержаний" Тогда
		
		Объект.СчетЗатрат = Параметр.СчетЗатрат;
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаОповещения()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьВидимостьИДоступность(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура обработчик события ПриИзменении поля ввода ЮрФизЛицо.
//
&НаКлиенте
Процедура ТипПриИзменении(Элемент)
	
	УстановитьВидимостьИДоступность(Истина);
	
	ПриИзмененииТипаВидаНачисленияНаСервере(Объект.Тип);
	
КонецПроцедуры // ЮрФизЛицоПриИзменении()

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура вызывается при нажатии кнопки "Редактировать формулу расчета". 
//
&НаКлиенте
Процедура КомандаРедактироватьФормулуРасчета(Команда)
	
	СтруктураПараметров = Новый Структура("ТекстФормулы", Объект.Формула);
	Оповещение = Новый ОписаниеОповещения("КомандаРедактироватьФормулуРасчетаЗавершение",ЭтаФорма);
	ОткрытьФорму("Справочник.ВидыНачисленийИУдержаний.Форма.ФормаРедактированияФормулыРасчета", СтруктураПараметров,,,,,Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаРедактироватьФормулуРасчетаЗавершение(ТекстФормулы,Параметры) Экспорт

	Если ТипЗнч(ТекстФормулы) = Тип("Строка") Тогда
		Объект.Формула = ТекстФормулы;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

//@skip-warning
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма);
	
КонецПроцедуры // Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта()

// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

// Процедура устанавливает доступность элементов формы.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура УстановитьВидимостьИДоступность(ОбнулитьЗначения)
	
	Если Объект.Тип = Налог Тогда
		
		Элементы.ГруппаФормула.Видимость = Ложь;
		Элементы.ГруппаКоды.Видимость = Ложь;
		Элементы.ВидНалога.Видимость = Истина;
		
		Если ОбнулитьЗначения Тогда
			
			Объект.СчетЗатрат = Неопределено;
			Объект.Формула = "";
			
		КонецЕсли;
		
	Иначе
		
		Элементы.ГруппаКоды.Видимость = НЕ (Объект.Тип = Удержание);
		Элементы.ГруппаФормула.Видимость = Истина;
		Элементы.ВидНалога.Видимость = Ложь;
		
		Если ОбнулитьЗначения Тогда
			
			Объект.ВидНалога = Неопределено;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура устанавливает значения в зависимости от выбранного типа
//
&НаСервере
Процедура ПриИзмененииТипаВидаНачисленияНаСервере(ТипВидаНачисления)
	
	Если ТипВидаНачисления = Перечисления.ТипыНачисленийИУдержаний.Удержание Тогда
		
		Объект.СчетЗатрат = ПланыСчетов.Управленческий.ПрочиеДоходы;
		
	Иначе
		
		Объект.СчетЗатрат = ПланыСчетов.Управленческий.УправленческиеРасходы;
		
	КонецЕсли;
	
КонецПроцедуры // ПриИзмененииТипаВидаНачисленияНаСервере()

// СтандартныеПодсистемы.ПодключаемыеКоманды

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры // ПриСозданииНаСервере()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
// Процедура - обработчик команды СоздатьНомерГТД
//
Процедура СоздатьНомерГТД(Команда)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	ОценкаПроизводительностиКлиент.ЗамерВремени("СправочникНомераГТДОткрытие");
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
	ОткрытьФорму("Справочник.НомераГТД.Форма.ФормаЭлемента");
	
КонецПроцедуры // СоздатьНомерГТД()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ ЭЛЕМЕНТОВ ФОРМЫ

// Процедура - обработчик события Выбор списка формы
//
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	ОценкаПроизводительностиКлиент.ЗамерВремени("СправочникНомераГТДОткрытие");
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
КонецПроцедуры // СписокВыбор()

#Область СлужебныеПроцедурыИФункции

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

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

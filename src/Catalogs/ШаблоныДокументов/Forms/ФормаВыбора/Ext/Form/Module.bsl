﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("ПолноеИмяОбъектаМетаданных") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("ВидыОпераций") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ДокументСсылка", ДокументСсылка);
	
	ИсключаемыеОбъекты = Новый Массив;
	
	Если ТипЗнч(Параметры.ИсключитьТипы) = Тип("Массив") Тогда
		
		Для Каждого ИсключаемыйТип Из Параметры.ИсключитьТипы Цикл
			ИсключаемыеОбъекты.Добавить(Метаданные.НайтиПоТипу(ИсключаемыйТип));
		КонецЦикла;
		
		Если Параметры.ИсключитьТипы.Найти(ТипЗнч(ДокументСсылка)) <> Неопределено Тогда
			ДокументСсылка = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДокументСсылка) Тогда
		ПолноеИмя = ДокументСсылка.Метаданные().ПолноеИмя();
	КонецЕсли;
	
	ЗаполнитьРеквизитыПоИдентификаторуОбъектаМетаданных(Параметры.ПолноеИмяОбъектаМетаданных, ИсключаемыеОбъекты);
	УстановитьОтборПоВидамОпераций(Параметры.ВидыОпераций);
	
	НастроитьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "ЗаписанШаблонДокумента" Тогда
		Возврат;
	КонецЕсли;
	
	#Если ВебКлиент ИЛИ МобильныйКлиент Тогда
	Высота = 25;
	#КонецЕсли
	
	ВыполнитьПереход(Параметр);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьФормуНовогоДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьСозданиеПустогоШаблона(ТекСтрокаИОМ)
	
	Если ТекСтрокаИОМ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ФормаДокумента = ПолучитьФорму(
	СтрШаблон("%1.ФормаОбъекта", ТекСтрокаИОМ.ПолноеИмя),
	ПараметрыФормыОбъектаПоИдентификаторуМетаданных(),
	ЭтаФорма);
	
	ФормаДокумента.СохранитьДокументКакШаблон(
	Новый ОписаниеОповещения("ОбработатьЗакрытиеФормыШаблона", ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьДокументПоШаблону(Команда)
	
	ОткрытьФормуНовогоДокумента();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонПоДокументу(Команда)
	
	ФормаДокумента = ПолучитьФорму(
	СтрШаблон("%1.ФормаОбъекта", ПолноеИмя),
	Новый Структура("Ключ", ДокументСсылка),
	ЭтаФорма);
	
	ФормаДокумента.СохранитьДокументКакШаблон(
	Новый ОписаниеОповещения("ОбработатьЗакрытиеФормыШаблона", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПустойШаблон(Команда)
	
	ВыбраннаяСтрока = СтрокаИдентификаторыОбъектовМетаданных();
	ОбработатьСозданиеПустогоШаблона(ВыбраннаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьФормуНовогоДокумента()
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("СозданиеДокументаПоШаблону");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", Новый Структура);
	ПараметрыФормы.ЗначенияЗаполнения.Вставить("ШаблонДокумента", Элементы.Список.ТекущиеДанные.Ссылка);
	
	ОткрытьФорму(СтрШаблон("%1.ФормаОбъекта", Элементы.Список.ТекущиеДанные.ПолноеИмяОбъекта), ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыПоИдентификаторуОбъектаМетаданных(ПолноеИмяОбъектаМетаданных, ИсключаемыеОбъекты)
	
	ИдентификаторыОбъектовМетаданных.Очистить();
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъектаМетаданных);
	
	Если Не Метаданные.ЖурналыДокументов.Содержит(ОбъектМетаданных) Тогда
		ДобавитьСтрокуВИдентификаторыОбъектовМетаданных(ОбъектМетаданных, ИсключаемыеОбъекты);
	Иначе
		Для Каждого ТекДокумент Из ОбъектМетаданных.РегистрируемыеДокументы Цикл
			Если ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ТекДокумент) Тогда
				ДобавитьСтрокуВИдентификаторыОбъектовМетаданных(ТекДокумент, ИсключаемыеОбъекты)
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ПравоеЗначениеОтбора = ИдентификаторыОбъектовМетаданных.Выгрузить( , "Ссылка").ВыгрузитьКолонку("Ссылка");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ИдентификаторОбъектаМетаданных",
		ПравоеЗначениеОтбора, ВидСравненияКомпоновкиДанных.ВСписке);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтрокуВИдентификаторыОбъектовМетаданных(ОбъектМетаданных, ИсключаемыеОбъекты)
	
	Если ИсключаемыеОбъекты.Найти(ОбъектМетаданных) <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НоваяСтрока = ИдентификаторыОбъектовМетаданных.Добавить();
	НоваяСтрока.Ссылка = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ОбъектМетаданных);
	НоваяСтрока.ПолноеИмя = ОбъектМетаданных.ПолноеИмя();
	НоваяСтрока.Синоним = ОбъектМетаданных.Синоним;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоВидамОпераций(ВидыОпераций)
	
	Если ВидыОпераций.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ВидОперации", ВидыОпераций,
		ВидСравненияКомпоновкиДанных.ВСписке);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СписокВидовОперацийДляОтбора(ПараметрыСписок)
	
	Результат = Новый СписокЗначений;
	
	Для Каждого ЭлементОтбора Из ПараметрыСписок.КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
		
		Если Не ЭлементОтбора.Использование Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЭлементОтбора.ЛевоеЗначение <> Новый ПолеКомпоновкиДанных("ВидОперации") Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
			Результат.Добавить(ЭлементОтбора.ПравоеЗначение);
			Возврат Результат;
		КонецЕсли;
		
		Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда
			Результат.ЗагрузитьЗначения(ЭлементОтбора.ПравоеЗначение.ВыгрузитьЗначения());
			Возврат Результат;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьЗакрытиеФормыШаблона(Результат, Параметры) Экспорт
	
	НастроитьФорму();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФорму()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ШаблоныДокументов.Ссылка
	|ИЗ
	|	Справочник.ШаблоныДокументов КАК ШаблоныДокументов
	|ГДЕ
	|	ШаблоныДокументов.ИдентификаторОбъектаМетаданных В(&ИдентификаторыОбъектовМетаданных)");
	Запрос.УстановитьПараметр(
	"ИдентификаторыОбъектовМетаданных",
	ИдентификаторыОбъектовМетаданных.Выгрузить(, "Ссылка").ВыгрузитьКолонку("Ссылка"));
	
	ДобавитьОтборПоВидамОпераций(Запрос);
	
	Если Запрос.Выполнить().Пустой() Тогда
		Элементы.Список.Видимость = Ложь;
		Заголовок = НСтр("ru = 'Шаблоны для документов отсутствуют.'");
	Иначе
		Элементы.Список.Видимость = Истина;
		Заголовок = НСтр("ru = 'Выберите шаблон для создания документа'");
	КонецЕсли;
	
	КлючСохраненияПоложенияОкна = Заголовок;
	
	Если ЗначениеЗаполнено(ДокументСсылка) Тогда
		Элементы.ГруппаШаблонПоДокументу.Видимость = Истина;
		Элементы.ДекорацияПустойШаблон.Заголовок = НСтр("ru = 'или'");
	Иначе
		Элементы.ГруппаШаблонПоДокументу.Видимость = Ложь;
		Элементы.ДекорацияПустойШаблон.Заголовок = НСтр("ru = 'Вы можете'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьОтборПоВидамОпераций(Запрос)
	
	ВидыОпераций = СписокВидовОперацийДляОтбора(Список);
	
	Если ВидыОпераций.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос.Текст = СтрШаблон("%1
	|И ШаблоныДокументов.ВидОперации В (&ВидыОпераций)",
	Запрос.Текст);
	
	Запрос.УстановитьПараметр("ВидыОпераций", ВидыОпераций);
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыФормыОбъектаПоИдентификаторуМетаданных()
	
	Результат = Новый Структура;
	Результат.Вставить("ЗначенияЗаполнения", Новый Структура);
	Результат.ЗначенияЗаполнения.Вставить("ПропуститьЗаполнение", Истина);
	
	ВидыОпераций = СписокВидовОперацийДляОтбора(Список);
	
	Если ВидыОпераций.Количество() = 1
		И ВидыОпераций[0].Значение = ПредопределенноеЗначение("Перечисление.ВидыОперацийЗаказПокупателя.ЗаказНаряд") Тогда
		Результат.ЗначенияЗаполнения.Вставить(
		"ВидОперации",
		ВидыОпераций[0].Значение);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция СтрокаИдентификаторыОбъектовМетаданных()
	
	Если ИдентификаторыОбъектовМетаданных.Количество() = 1 Тогда
		Возврат ИдентификаторыОбъектовМетаданных[0];
	КонецЕсли;
	
	СписокИдентификаторов = Новый СписокЗначений;
	Для Каждого ТекСтрока Из ИдентификаторыОбъектовМетаданных Цикл
		СписокИдентификаторов.Добавить(ТекСтрока.ПолучитьИдентификатор(), ТекСтрока.Синоним);
	КонецЦикла;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
	"ОбработатьВыборИзМеню",
	ЭтотОбъект);
	
	ПоказатьВыборИзМеню(ОписаниеОповещения, СписокИдентификаторов);
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьВыборИзМеню(Результат, Параметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("ЭлементСпискаЗначений") Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьСозданиеПустогоШаблона(
	ИдентификаторыОбъектовМетаданных.НайтиПоИдентификатору(Результат.Значение));
	
КонецПроцедуры

#КонецОбласти
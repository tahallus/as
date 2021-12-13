﻿&НаКлиенте
Перем КонтекстЭДОКлиент;

&НаСервере
Перем КонтекстЭДОСервер;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// инициализируем контекст ЭДО - модуль обработки
	ТекстСообщения = "";
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО(ТекстСообщения);
	Если КонтекстЭДОСервер = Неопределено Тогда 
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ЭтоНовый = Параметры.Ключ.Пустая();
	Если ЭтоНовый Тогда
		ТекстПредупреждения = НСтр("ru = 'Копирование описей входящих документов запрещено!'");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ПрорисоватьПанелиСтатусаИПриема();
	ЗаполнитьОтветы();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// инициализируем контекст формы - контейнера клиентских методов
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ОписиИсходящихДокументовВНалоговыеОрганы" 
		И ТипЗнч(Источник) = Тип("СправочникСсылка.ОписиИсходящихДокументовВНалоговыеОрганы")
		ИЛИ ИмяСобытия = "Запись_ПоясненияКДекларацииПоНДС" 
		И ТипЗнч(Источник) = Тип("ДокументСсылка.ПоясненияКДекларацииПоНДС")
		ИЛИ	ИмяСобытия = "Запись_ПерепискаСКонтролирующимиОрганами" 
		И ТипЗнч(Источник) = Тип("СправочникСсылка.ПерепискаСКонтролирующимиОрганами") Тогда
		
		ЗаполнитьОтветы();
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ОписиВходящихДокументовИзНалоговыхОрганов", ПараметрыЗаписи, Объект.Ссылка);
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

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВходящиеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДокументРеализации = Элемент.ТекущиеДанные.СсылкаНаОбъект;
	
	Если Поле.Имя = "ВходящиеДокументыОтвет" Тогда
		Если Элемент.ТекущиеДанные.Ответ <> "<не требуется>" Тогда
			//этот документ реализации является требованием
			СоздатьПоказатьОтветНаТребование(ДокументРеализации);
		Иначе
			ПоказатьЗначение(, ДокументРеализации);	
		КонецЕсли;
	Иначе
		ПоказатьЗначение(, ДокументРеализации);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПодтвердитьПрием(Команда)
	
	ОтправитьРезультатПриема(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтказатьВПриеме(Команда)
	
	ОтправитьРезультатПриема(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьОтветы()
	
	Если КонтекстЭДОСервер = Неопределено Тогда 
		// инициализируем контекст ЭДО - модуль обработки
		ТекстСообщения = "";
		КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО(ТекстСообщения);
		Если КонтекстЭДОСервер = Неопределено Тогда 
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецЕсли;
	КонецЕсли;

	// собираем ссылки на документы
	МассивДокументы = Новый Массив;
	Для Каждого ДанныеСтроки Из Объект.ВходящиеДокументы Цикл
		МассивДокументы.Добавить(ДанныеСтроки.СсылкаНаОбъект);
	КонецЦикла;
	
	// получаем количество ответов на требования
	КоличествоОтветов =  КонтекстЭДОСервер.ПолучитьКоличествоОтветовНаТребования(МассивДокументы);
	
	// прорисовываем ответы
	Для Каждого ДанныеСтроки Из Объект.ВходящиеДокументы Цикл
		КолвоОтветов = КоличествоОтветов[ДанныеСтроки.СсылкаНаОбъект];
		Если КолвоОтветов > 0 Тогда
			ДанныеСтроки.Ответ = КонтекстЭДОСервер.ПолучитьТекстКоличествоОтветов(КолвоОтветов);
		Иначе
			Если ДанныеСтроки.СсылкаНаОбъект.ВидДокумента = Перечисления.ВидыНалоговыхДокументов.ТребованиеОПредставленииДокументов
				ИЛИ ДанныеСтроки.СсылкаНаОбъект.ВидДокумента = Перечисления.ВидыНалоговыхДокументов.ТребованиеОПредставленииПоясненийКДекларацииНДС Тогда
				//этот документ реализации является требованием
				ДанныеСтроки.Ответ = "Создать";
			Иначе
				//этот документ реализации не является требованием
				ДанныеСтроки.Ответ = "<не требуется>";
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПрорисоватьПанелиСтатусаИПриема()
	
	// Прорисовываем видимость панели
	Если КонтекстЭДОСервер = Неопределено Тогда 
		// инициализируем контекст ЭДО - модуль обработки
		ТекстСообщения = "";
		КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО(ТекстСообщения);
		Если КонтекстЭДОСервер = Неопределено Тогда 
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецЕсли;
	КонецЕсли;

	// получаем список сообщений
	ПоследнийЦиклОбмена = ДокументооборотСКОВызовСервера.ПолучитьПоследнийЦиклОбмена(Объект.Ссылка);
	СообщенияЦикла = КонтекстЭДОСервер.ПолучитьСообщенияЦиклаОбмена(ПоследнийЦиклОбмена);
	СтрРезультатПриемаДокументНП 	= СообщенияЦикла.НайтиСтроки(Новый Структура("Тип", Перечисления.ТипыТранспортныхСообщений.РезультатПриемаДокументНП));
	//прорисуем панель приема
	Если СтрРезультатПриемаДокументНП.Количество() > 0 
		ИЛИ КонтекстЭДОСервер.ПолучитьМассивТребованийПоОписиВходящихДокументов(Объект.Ссылка).Количество() = 0 
		ИЛИ НЕ ЗначениеЗаполнено(ПоследнийЦиклОбмена) Тогда
		Элементы.ГруппаПанельПриема.Видимость = Ложь;
	Иначе
        Элементы.ГруппаПанельПриема.Видимость = Истина;
	КонецЕсли;

	
КонецПроцедуры

&НаСервере
Функция ПолучитьРезультатПриемаНаСервере()

	Если КонтекстЭДОСервер = Неопределено Тогда 
		// инициализируем контекст ЭДО - модуль обработки
		ТекстСообщения = "";
		КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО(ТекстСообщения);
		Если КонтекстЭДОСервер = Неопределено Тогда 
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	// получаем список сообщений
	ПоследнийЦиклОбмена 		= ДокументооборотСКОВызовСервера.ПолучитьПоследнийЦиклОбмена(Объект.Ссылка);
	СообщениеОснование			= КонтекстЭДОСервер.ПолучитьСообщениеЦиклаОбмена(ПоследнийЦиклОбмена, Перечисления.ТипыТранспортныхСообщений.ДокументНО);
	СообщениеРезультатПриема 	= КонтекстЭДОСервер.ПолучитьСообщениеЦиклаОбмена(ПоследнийЦиклОбмена, Перечисления.ТипыТранспортныхСообщений.РезультатПриемаДокументНП, СообщениеОснование);
	Если СообщениеРезультатПриема = Документы.ТранспортноеСообщение.ПустаяСсылка() Тогда
		Возврат Неопределено;
	Иначе
		Возврат СообщениеРезультатПриема;
	КонецЕсли;

КонецФункции

&НаСервере
Функция ПолучитьДокументНОНаСервере()

	Если КонтекстЭДОСервер = Неопределено Тогда 
		// инициализируем контекст ЭДО - модуль обработки
		ТекстСообщения = "";
		КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО(ТекстСообщения);
		Если КонтекстЭДОСервер = Неопределено Тогда 
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	// получаем список сообщений
	ПоследнийЦиклОбмена 		= ДокументооборотСКОВызовСервера.ПолучитьПоследнийЦиклОбмена(Объект.Ссылка);
	СообщениеДокументНО			= КонтекстЭДОСервер.ПолучитьСообщениеЦиклаОбмена(ПоследнийЦиклОбмена, Перечисления.ТипыТранспортныхСообщений.ДокументНО);
	Если СообщениеДокументНО = Документы.ТранспортноеСообщение.ПустаяСсылка() Тогда
		Возврат Неопределено;
	Иначе
		Возврат СообщениеДокументНО;
	КонецЕсли;

КонецФункции

&НаКлиенте
Процедура ОтправитьРезультатПриема(ПоложительныйРезультат = Истина)
	
	РезультатПриема = ПолучитьРезультатПриемаНаСервере();
	Если РезультатПриема = Неопределено Тогда
		Если ПоложительныйРезультат Тогда
			ТекстВопроса = "Подтвердить прием описи документов, содержащей требование о представлении документов (информации)?" 
				+ Символы.ПС + "Подтверждение будет отправлено в налоговый орган." 
				+ Символы.ПС + "После отправки подтверждения приема следует сформировать ответ, содержащий затребованные документы.";
		Иначе
			ТекстВопроса = "Отказать в приеме описи документов, содержащей требование о представлении документов (информации)?" 
				+ Символы.ПС + "Отказ будет отправлен в налоговый орган.";
		КонецЕсли;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ПоложительныйРезультат", ПоложительныйРезультат);
		ДополнительныеПараметры.Вставить("РезультатПриема", РезультатПриема);
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтправитьРезультатПриемаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		ПоказатьЗначение(, РезультатПриема);	
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтправитьРезультатПриемаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	РезультатПриема = ДополнительныеПараметры.РезультатПриема;
	ПоложительныйРезультат = ДополнительныеПараметры.ПоложительныйРезультат;
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ДокументНО = ПолучитьДокументНОНаСервере();
	//отправляем сообщение
	Если ДокументНО <> Неопределено Тогда
		Оповещение = Новый ОписаниеОповещения(
			"ОтправитьРезультатПриемаЗавершениеПослеСозданияСообщения", ЭтотОбъект, ДополнительныеПараметры);
		КонтекстЭДОКлиент.СоздатьРезультатПриемаНаКлиентеСУчетомВопроса(Оповещение, ДокументНО, ПоложительныйРезультат, Истина);		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьРезультатПриемаЗавершениеПослеСозданияСообщения(РезультатПриема, ВходящийКонтекст) Экспорт

	Если РезультатПриема <> Неопределено Тогда
		ВходящийКонтекст.Вставить("РезультатПриема", РезультатПриема);
		Оповещение = Новый ОписаниеОповещения(
			"ОтправитьРезультатПриемаЗавершениеПослеФормированияПакетаФНС", ЭтотОбъект, ВходящийКонтекст);
		КонтекстЭДОКлиент.СформироватьПакетФНС(Оповещение, РезультатПриема);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьРезультатПриемаЗавершениеПослеФормированияПакетаФНС(Результат, ВходящийКонтекст) Экспорт	
	
	//отправляем сообщение
	КонтекстЭДОКлиент.ОтправитьТранспортноеСообщение(ВходящийКонтекст.РезультатПриема);
	ПрорисоватьПанелиСтатусаИПриема();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		ОтключитьДоступностьЭУ();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьДоступностьЭУ()
	
	Элементы.ГруппаПанельПриема.Доступность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоказатьОтветНаТребование(Требование)
	
	КонтекстЭДОКлиент.НажатиеНаКнопкуПоказатьОтветыПоТребованию(Требование);
	
КонецПроцедуры

#КонецОбласти

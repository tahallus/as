﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

// Контекст взаимодействия с сервисом ИПП
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		ВызватьИсключение НСтр("ru = 'Использование Интернет-поддержки недоступно при работе в модели сервиса.'");
	КонецЕсли;
	
	Логин = Параметры.login;
	Если ЗначениеЗаполнено(Логин) Тогда
		Пароль = Новый УникальныйИдентификатор;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СообщенияВСлужбуТехническойПоддержки") Тогда
		Элементы.НадписьПоясненияПодключенияАвторизация.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(
			НСтр("ru = 'Введите логин и пароль, которые вы используете на <a href = ""action:openPortal"">Портале 1С:ИТС</a>. '"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Подключение1СТакскомКлиент.ОбработатьОткрытиеФормы(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ПрограммноеЗакрытие Тогда
		Подключение1СТакскомКлиент.ЗавершитьБизнесПроцесс(КонтекстВзаимодействия, ЗавершениеРаботы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИПП_АктивизироватьФормуПодключенияИПП" Тогда
		Если Параметр.Активизирована <> Истина Тогда
			Если ВладелецФормы = Неопределено
				Или РежимОткрытияОкна <> РежимОткрытияОкнаФормы.БлокироватьОкноВладельца Тогда
				Параметр.Активизирована = Истина;
				ПодключитьОбработчикОжидания("АктивизироватьЭтуФорму", 0.1, Истина);
			ИначеЕсли ЭтотОбъект.ВладелецФормы <> Неопределено Тогда
				Параметр.Активизирована = Истина;
				ПодключитьОбработчикОжидания("АктивизироватьВладельца", 0.1, Истина);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьПоясненияПодключенияАвторизацияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылкаФорматированнойСтроки = "action:openPortal" Тогда
		
		ИнтернетПоддержкаПользователейКлиент.ОткрытьГлавнуюСтраницуПортала();
		
	Иначе
		
		Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не получается подключить Интернет-поддержку пользователей.
				|Для подключения указывается логин %1.'"),
			Элементы.Логин.ТекстРедактирования);
	
		ДанныеСообщения = Новый Структура;
		ДанныеСообщения.Вставить("Получатель", "webIts");
		ДанныеСообщения.Вставить("Тема",       НСтр("ru = 'Интернет-поддержка. Подключение Интернет-поддержки'"));
		ДанныеСообщения.Вставить("Сообщение",  Сообщение);
		
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СообщенияВСлужбуТехническойПоддержки") Тогда
			МодульСообщенияВСлужбуТехническойПоддержкиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СообщенияВСлужбуТехническойПоддержкиКлиент");
			МодульСообщенияВСлужбуТехническойПоддержкиКлиент.ОтправитьСообщение(
				ДанныеСообщения);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВосстановленияПароляАвторизацияНажатие(Элемент)
	
	ИнтернетПоддержкаПользователейКлиент.ОткрытьСтраницуВосстановленияПароля();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьНетЛогинаИПароляАвторизацияНажатие(Элемент)
	
	ИнтернетПоддержкаПользователейКлиент.ОткрытьСтраницуРегистрацииНовогоПользователя();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИнформацияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтернетПоддержкаПользователейКлиент.ОткрытьГлавнуюСтраницуПортала();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОКБизнесПроцесс(Команда)
	
	Если ЗаполнениеЛогинаИПароляКорректно() Тогда
		ПродолжитьБизнесПроцесс();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Общего назначения.

&НаКлиенте
Функция ЗаполнениеЛогинаИПароляКорректно()
	
	Если ПустаяСтрока(Логин) Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Поле ""Логин"" не заполнено.'"),
			,
			"Логин");
		Возврат Ложь;
		
	ИначеЕсли ПустаяСтрока(Пароль) Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Поле ""Пароль"" не заполнено.'"),
			,
			"Пароль");
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура АктивизироватьЭтуФорму()
	
	ЭтотОбъект.Активизировать();
	
КонецПроцедуры

&НаКлиенте
Процедура АктивизироватьВладельца()
	
	ЭтотОбъект.ВладелецФормы.Активизировать();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработка бизнес-процессов.

&НаКлиенте
Процедура ПродолжитьБизнесПроцесс()
	
	Подключение1СТакскомКлиентСервер.ЗаписатьПараметрКонтекста(
		КонтекстВзаимодействия.КСКонтекст,
		"login",
		Логин);
	Подключение1СТакскомКлиентСервер.ЗаписатьПараметрКонтекста(
		КонтекстВзаимодействия.КСКонтекст,
		"savePassword",
		"true");
	
	// Сохранение логина и пароля пользователя, при успешной авторизации
	// будут переданы в метод
	// ИнтернетПоддержкаПользователейПереопределяемый.ПриИзмененииДанныхАутентификацииИнтернетПоддержки().
	
	КонтекстВзаимодействия.КСКонтекст.Логин = Логин;
	
	ПараметрыЗапроса = Новый Массив;
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "login", Логин));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "password", Пароль));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "savePassword", "true"));
	
	Подключение1СТакскомКлиент.ОбработкаКомандСервиса(
		КонтекстВзаимодействия,
		ЭтотОбъект,
		ПараметрыЗапроса);
	
КонецПроцедуры

#КонецОбласти

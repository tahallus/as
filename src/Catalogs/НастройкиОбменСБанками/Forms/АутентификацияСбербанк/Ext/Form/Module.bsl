﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НастройкаОбмена = Параметры.НастройкаОбмена;
	ТокенДоступа = Параметры.ТокенДоступа;
	НомерСчета = Параметры.НомерСчета;
	КлючСохраненияПоложенияОкна = Параметры.Цель;
	РеквизитыНастройкиОбмена = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НастройкаОбмена, "Организация, Банк");
	Организация = РеквизитыНастройкиОбмена.Организация;
	Банк = РеквизитыНастройкиОбмена.Банк;
	
	Элементы.НомерСчета.Видимость = Параметры.Цель = "Обмен";
	Элементы.Организация.Видимость = Параметры.Цель = "Обмен";
	Элементы.Банк.Видимость = Параметры.Цель = "Обмен";
	Элементы.ДекорацияПодключение.Видимость = Параметры.Цель = "Подключение";
	Элементы.ДекорацияАутентификация.Видимость = Параметры.Цель = "Обмен";
	Элементы.ДекорацияТест.Видимость = Параметры.Цель = "Тест";
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ФормаОткрыта = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ФормаОткрыта = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	ФормаОткрыта = Ложь;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиВЛичныйКабинет(Команда)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(Параметры.URL);
	ПодключитьОбработчикОжидания("ПроверитьДоступКСервису", 1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверитьДоступКСервису()
	
	Если Не ФормаОткрыта Тогда
		Возврат;
	КонецЕсли;
	
	РезультатВыполнения = ЗапускЗаданияПроверкиНаличияДоступаКДанным(
		НастройкаОбмена, ТокенДоступа, УникальныйИдентификатор);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПослеПроверкиДоступаКДанным = Новый ОписаниеОповещения("ПослеПроверкиДоступаКДанным", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(РезультатВыполнения, ПослеПроверкиДоступаКДанным, ПараметрыОжидания);

КонецПроцедуры

&НаКлиенте
Процедура ПослеПроверкиДоступаКДанным(Результат, ДополнительныеПараметры) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура("Успех, ТекстОшибки", Ложь);
	
	Если Результат = Неопределено Тогда
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		РезультатПодключения = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Если РезультатПодключения.status = "AUTH_COMPLETED_SUCCESS" Тогда
			ВозвращаемоеЗначение.Успех = Истина;
		ИначеЕсли РезультатПодключения.status = "AUTH_COMPLETED_ERROR" Тогда
			ТекстОшибки = НСтр("ru = 'При подключении к сервису Fintech Integration произошла ошибка.'");
			ВозвращаемоеЗначение.ТекстОшибки = ТекстОшибки;
		Иначе
			ПодключитьОбработчикОжидания("ПроверитьДоступКСервису", 1, Истина);
			Возврат;
		КонецЕсли;
	Иначе // Ошибка
		ВидОперации = НСтр("ru = 'Подключение к сервису 1С:ДиректБанк.'");
		ОбработатьОшибку(ВидОперации, Результат.ПодробноеПредставлениеОшибки, Результат.КраткоеПредставлениеОшибки,
			НастройкаОбмена);
		ВозвращаемоеЗначение.ТекстОшибки = Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
	Закрыть(ВозвращаемоеЗначение);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбработатьОшибку(Знач ВидОперации, Знач ПодробноеПредставлениеОшибки, Знач КраткоеПредставлениеОшибки, Знач НастройкаОбмена)
	ЭлектронноеВзаимодействие.ОбработатьОшибку(ВидОперации,
		ПодробноеПредставлениеОшибки, КраткоеПредставлениеОшибки, "ОбменСБанками",
		НастройкаОбмена);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗапускЗаданияПроверкиНаличияДоступаКДанным(НастройкаОбмена, ТокенДоступа, УникальныйИдентификатор)
	
	ПараметрыСессии = ОбменСБанкамиСлужебный.ПараметрыУстановленнойСессииСбербанк(НастройкаОбмена);
	НовыеПараметрыСессии = Новый Структура(ПараметрыСессии);
	НовыеПараметрыСессии.Вставить("ТокенДоступа", ТокенДоступа);
	ОбменСБанкамиСлужебныйВызовСервера.СохранитьСессиюНаСервереСбербанк(НастройкаОбмена, НовыеПараметрыСессии);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Проверка получения доступа к данным сервиса Fintech integration'");
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("НастройкаОбмена", НастройкаОбмена);
	ПараметрыПроцедуры.Вставить("ИдентификаторСессии", ПараметрыСессии.ИдентификаторСессии);
	ПараметрыПроцедуры.Вставить("ТокенДоступа", ТокенДоступа);
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"ОбменСБанкамиФинтехСлужебный.ПроверитьВыполнениеАутентификацииВЛичномКабинете",
		ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции



#КонецОбласти
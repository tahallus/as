﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.ПриЗаписиОбъекта(ЭтотОбъект, Отказ);

КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Идентификатор) Тогда
		Идентификатор = СтрЗаменить(Новый УникальныйИдентификатор, "-", "");
	КонецЕсли;
	ДатаСоздания = ТекущаяДатаСеанса();
	
	Отправитель = Организация;
	Тип = Перечисления.ТипыПерепискиСКонтролирующимиОрганами.ПерепискаСПФР;
	ЗаполнитьНаименование();
	ЗаполнитьСодержание();
	
	КонтекстЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонтекстЭДО.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(СообщениеОснование)
	
	КонтекстЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонтекстЭДО.ОбработкаЗаполненияОбъекта(ЭтотОбъект, СообщениеОснование);
	
	ДатаСообщения = ТекущаяДатаСеанса();
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		Модуль 		= ОбщегоНазначения.ОбщийМодуль("Справочники.Организации");
		Организация = Модуль.ОрганизацияПоУмолчанию();
		Отправитель = Организация;
	КонецЕсли;
	
	Если ТипЗнч(СообщениеОснование) = Тип("Структура")
		И СообщениеОснование.Свойство("Отправитель")
		И ТипЗнч(СообщениеОснование.Отправитель) = Тип("СправочникСсылка.Организации") Тогда
		Организация = СообщениеОснование.Отправитель;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Идентификатор = Неопределено;
	ИдентификаторОснования = Неопределено;
	ДатаОтправки = Неопределено;
	ДатаСообщения = ТекущаяДатаСеанса();
	
	Статус = Перечисления.СтатусыПисем.Сохраненное;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ОбработкаПроверкиЗаполненияЗаявленияОНазначенииПенсии(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьНаименование()
	
	Наименование = СтрШаблон("Заявление о назначении пенсии (%1)", Сотрудник);

КонецПроцедуры

Процедура ЗаполнитьСодержание()
	
	ШаблонПисьма = НСтр("ru = 'Направляем Вам %1:
                        |%2 (%3)
                        |
                        |Контактный телефон: %4'");
	
	Если ЭтоЗаявлениеОДоставкеПенсии И НЕ ЭтоЗаявлениеОНазначенииПенсии Тогда
		ВидЗаявления = НСтр("ru = 'заявление о доставке пенсии'"); 
	ИначеЕсли НЕ ЭтоЗаявлениеОДоставкеПенсии И ЭтоЗаявлениеОНазначенииПенсии Тогда
		ВидЗаявления = НСтр("ru = 'заявление о назначении пенсии'");
	Иначе
		ВидЗаявления = НСтр("ru = 'заявление о назначении и доствке пенсии'");
	КонецЕсли;
	
	ФИО = СокрЛП(Фамилия + " " + Имя + " " + Отчество);
	
	Содержание = СтрШаблон(
		ШаблонПисьма,
		ВидЗаявления,
		ФИО, 
		?(Стаж = Перечисления.ВидыСтажаДляНазначенияПенсии.ЗаВыслугуЛет, "льготные условия", "общие условия"),
		Телефон);
	
	КонецПроцедуры
	
#КонецОбласти

#КонецЕсли
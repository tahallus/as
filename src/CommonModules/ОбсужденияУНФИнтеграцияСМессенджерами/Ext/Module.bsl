﻿
#Область ПрограммныйИнтерфейс

// Проверяет наличие новых неотвеченных сообщений из внешних систем
// и добавляет их в контакт-центр при необходимости.
//
Процедура ДобавитьНеотвеченныеСообщенияВКонтактЦентр() Экспорт
	
	Если Не СистемаВзаимодействия.ИспользованиеДоступно() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ИнтеграцииДоступны() Тогда
		Возврат;
	КонецЕсли;
	
	НовыеСообщения = НовыеНеотвеченныеСообщенияВнешнихПользователей();
	
	Для каждого Сообщение Из НовыеСообщения Цикл
		Обсуждение = СистемаВзаимодействия.ПолучитьОбсуждение(Сообщение.Обсуждение);
		Если Обсуждение.Интеграция = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ИнтеграцияОбсуждения = ПолучитьИнтеграцию(Обсуждение.Интеграция);
		УчастникиОбсуждения = УчастникиОбсуждения(Обсуждение);
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(УчастникиОбсуждения, Сообщение.Автор);
		СотрудникиОбсуждения = Новый Массив;
		Для каждого Участник Из УчастникиОбсуждения Цикл
			СотрудникиОбсуждения.Добавить(ОбсужденияУНФ.СотрудникПользователя(Участник));
		КонецЦикла;
		
		ОписаниеВходящего = КонтактЦентр.ОписаниеВходящего();
		ОписаниеВходящего.Описание = Сообщение.Текст;
		ОписаниеВходящего.ОтКого = СистемаВзаимодействия.ПолучитьПользователя(Сообщение.Автор).ПолноеИмя;
		ОписаниеВходящего.ТипВнешнейСистемы = ИнтеграцияОбсуждения.ТипВнешнейСистемы;
		ОписаниеВходящего.Ответственный = СотрудникиОбсуждения;
		КонтактЦентр.ДобавитьВоВходящее(Сообщение.Обсуждение, ОписаниеВходящего);
	КонецЦикла;
	
КонецПроцедуры

// Определяет доступность интеграций системы взаимодействия.
// 
// Возвращаемое значение:
//  Булево
//
Функция ИнтеграцииДоступны() Экспорт
	
	ОписаниеСистемы = Новый СистемнаяИнформация;
	Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии("8.3.17.0", ОписаниеСистемы.ВерсияПриложения) > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает список обсуждений, интегрированных с мессенджерами, на которые нет ответа от сотрудников.
// 
// Возвращаемое значение:
//   Массив
//
Функция НовыеНеотвеченныеСообщенияВнешнихПользователей()
	
	Результат = Новый Массив;
	
	Если Не ИнтеграцииДоступны() Тогда
		Возврат Результат;
	КонецЕсли;
	
	СекундВСутках = 86400;
	
	ТекущаяДатаПроверки = ТекущаяДатаСеанса();
	ПоследняяДатаПроверки = Константы.ПоследняяДатаПроверкиВходящихСообщенийИнтеграции.Получить();
	Если НЕ ЗначениеЗаполнено(ПоследняяДатаПроверки) Тогда
		ПоследняяДатаПроверки = ТекущаяДатаПроверки - СекундВСутках;
	КонецЕсли;
	
	ОтборОбсуждений = Новый ОтборОбсужденийСистемыВзаимодействия;
	ОтборОбсуждений.ДатаНачала = ПоследняяДатаПроверки;
	ОтборОбсуждений.НаправлениеСортировки = НаправлениеСортировки.Возр;
	ПроверяемыеОбсуждения = СистемаВзаимодействия.ПолучитьОбсуждения(ОтборОбсуждений);
	
	Для каждого Обсуждение Из ПроверяемыеОбсуждения Цикл
		ПоследнееСообщение = ОбсужденияУНФ.ПолучитьПоследнееСообщение(Обсуждение.Идентификатор);
		Если ПоследнееСообщение = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ЭтоСообщениеОтВнешнегоПользователя(ПоследнееСообщение) Тогда
			Продолжить;
		КонецЕсли;
		
		Результат.Добавить(ПоследнееСообщение);
	КонецЦикла;
	
	Константы.ПоследняяДатаПроверкиВходящихСообщенийИнтеграции.Установить(ТекущаяДатаПроверки);
	Возврат Результат;
	
КонецФункции

Функция ЭтоСообщениеОтВнешнегоПользователя(Сообщение)
	
	Автор = СистемаВзаимодействия.ПолучитьПользователя(Сообщение.Автор);
	
	Возврат Автор.ИдентификаторПользователяВнешнейСистемы <> Неопределено;
	
КонецФункции

Функция УчастникиОбсуждения(Обсуждение)
	
	Результат = Новый Массив;
	Для каждого Участник Из Обсуждение.Участники Цикл
		Результат.Добавить(Участник);
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

Функция ПолучитьИнтеграцию(ИдентификаторИнтеграции)
	
	// Обход платформенной проверки конфигурации: метод доступен, начиная с версии 8.3.17.
	Возврат Вычислить("СистемаВзаимодействия.ПолучитьИнтеграцию(ИдентификаторИнтеграции)");
	
КонецФункции

#КонецОбласти
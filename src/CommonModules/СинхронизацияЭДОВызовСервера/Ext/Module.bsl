﻿
#Область СлужебныйПрограммныйИнтерфейс

// Метод проверяет наличие в регистре сведений записей о новых ЭД.
//
// Возвращаемое значение:
//  Булево - признак наличия в сервисе новых электронных документов.
//
Функция ЕстьСобытияЭДО() Экспорт
	
	Возврат ОповещенияОСобытияхЭДО.ЕстьСобытияЭДО();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// См. СинхронизацияЭДО.ЕстьПравоВыполненияОбмена.
//
// Возвращаемое значение:
//  См. СинхронизацияЭДО.ЕстьПравоВыполненияОбмена
Функция ЕстьПравоВыполненияОбмена() Экспорт
	
	ЕстьПраво = СинхронизацияЭДО.ЕстьПравоВыполненияОбмена();
		
	Возврат ЕстьПраво;
	
КонецФункции

Функция ЗапуститьПолучениеПараметровСинхронизации(Знач ПараметрыЗадания, Знач УникальныйИдентификатор) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания =
		НСтр("ru = 'Обмен с контрагентами. Получение настроек ЭДО и параметров сертификатов.'");
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, "СинхронизацияЭДОСлужебный.ПараметрыСинхронизации",
		ПараметрыЗадания);
	
КонецФункции

Функция ЗапуститьОтправкуПолучениеТранспортныхКонтейнеров(Знач ПараметрыЗадания, Знач УникальныйИдентификатор) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания =
		НСтр("ru = 'Обмен с контрагентами. Отправка и получение электронных документов.'");
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения,
		"СинхронизацияЭДОСлужебный.ОтправитьПолучитьТранспортныеКонтейнеры", ПараметрыЗадания);
	
КонецФункции

Функция НачатьФормированиеИОтправкуТранспортныхКонтейнеров(КонтекстОтправки, КонтекстДиагностики, КлючиСинхронизации,
	ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания =
		НСтр("ru = 'Обмен с контрагентами. Отправка объектов.'");
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения,
		"СинхронизацияЭДОСлужебный.СформироватьИОтправитьТранспортныеКонтейнеры", КонтекстОтправки, КонтекстДиагностики,
		КлючиСинхронизации, Неопределено, ДополнительныеПараметры);
	
КонецФункции

Функция РезультатОтправкиИПолученияДокументов(АдресРезультата) Экспорт
	
	РезультатОтправкиПолучения = ПолучитьИзВременногоХранилища(АдресРезультата);
	РезультатЗагрузкиДокументов = ЭлектронныеДокументыЭДО.ОбработатьРезультатЗагрузкиВФоне(
		РезультатОтправкиПолучения.РезультатЗагрузкиДокументовВФоне);
	
	РезультатОтправкиПолучения.РезультатЗагрузкиДокументов = РезультатЗагрузкиДокументов;
	
	РезультатОтправкиПолучения.Удалить("РезультатЗагрузкиДокументовВФоне");
	
	Возврат РезультатОтправкиПолучения;
	
КонецФункции

// См. УчетныеЗаписиЭДО.СоздатьУчетнуюЗапись
Функция СоздатьУчетнуюЗапись(ОписаниеУчетнойЗаписи) Экспорт
	
	Возврат УчетныеЗаписиЭДО.СоздатьУчетнуюЗапись(ОписаниеУчетнойЗаписи);

КонецФункции

Процедура ОбновитьКешиОператоровЭДОИФорматов() Экспорт
	
	СинхронизацияЭДО.ОбновитьКешиОператоровЭДОИФорматов();
	
КонецПроцедуры

Процедура ДобавитьСертификатВУчетныеЗаписиЭДО(УчетныеЗаписи, Сертификат) Экспорт
	
	Для каждого УчетнаяЗапись Из УчетныеЗаписи Цикл
		
		УчетныеЗаписиЭДО.ЗаписатьСертификатыУчетнойЗаписи(УчетнаяЗапись,
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сертификат), Ложь);
		
	КонецЦикла;
	
КонецПроцедуры

Функция УчетныеЗаписиЭДОДляОбновленияСертификата(Знач Организация, Знач Сертификат, Знач НовыйСертификат) Экспорт
	
	Возврат УчетныеЗаписиЭДО.УчетныеЗаписиЭДОДляОбновленияСертификата(Организация, Сертификат, НовыйСертификат);
	
КонецФункции

Функция ПолучитьОтпечаткиСертификатов(ВидОперации, КонтекстДиагностики, РезультатыПолученияОтпечатков,
	ОшибкаПолученияОтпечатков = "") Экспорт
	
	РезультатыПолучения = КриптографияБЭД.ПолучитьОтпечаткиСертификатов(ВидОперации, КонтекстДиагностики,
		РезультатыПолученияОтпечатков);
	ЕстьОшибкаПолученияОтпечатков = КриптографияБЭД.ЕстьОшибкаПолученияОтпечатков(РезультатыПолучения, ОшибкаПолученияОтпечатков);
	
	Возврат РезультатыПолучения;
	
КонецФункции

#Область ОбработкаНеисправностей

Процедура ИзменитьДатуЗапросаДанных(КлючиЗаписей, КонтекстДиагностики, СоответствиеОшибокДанным,
	ИсправленныеОшибки) Экспорт
	
	ИсправитьПроблемуНеполученныхДокументовИПриглашений(КлючиЗаписей, КонтекстДиагностики, СоответствиеОшибокДанным,
		ИсправленныеОшибки, Истина);
	
КонецПроцедуры

Процедура ИгнорироватьПредупреждениеОНеполученныхДокументах(КлючиЗаписей, КонтекстДиагностики, СоответствиеОшибокДанным,
	ИсправленныеОшибки) Экспорт
	
	ИсправитьПроблемуНеполученныхДокументовИПриглашений(КлючиЗаписей, КонтекстДиагностики, СоответствиеОшибокДанным,
		ИсправленныеОшибки, Ложь);
	
КонецПроцедуры

Процедура ИсправитьПроблемуНеполученныхДокументовИПриглашений(КлючиЗаписей, КонтекстДиагностики, СоответствиеОшибокДанным,
	ИсправленныеОшибки, ИзменитьДату = Истина)
	
	УчетныеЗаписи = Новый Массив;
	Для каждого КлючЗаписи Из КлючиЗаписей Цикл
		УчетныеЗаписи.Добавить(КлючЗаписи.ИдентификаторЭДО);
	КонецЦикла;
	ИсправленныеОшибки = Новый Массив;
	Для каждого УчетнаяЗапись Из УчетныеЗаписи Цикл
		Ошибки = ОбработкаНеисправностейБЭДКлиентСервер.ПолучитьОшибки(КонтекстДиагностики);
		НоваяДатаЗапросаДанных = 0;
		Отбор = Новый Структура("УчетнаяЗапись", УчетнаяЗапись);
		ЗначенияСвойствОшибок = ОбработкаНеисправностейБЭДКлиентСервер.ЗначенияСвойствОшибок(Ошибки,
			"ДополнительныеДанные", Отбор);
		Если ЗначенияСвойствОшибок.Количество() Тогда
			Если ИзменитьДату Тогда
				НоваяДатаЗапросаДанных = ЗначенияСвойствОшибок[0].ПроверочнаяДатаПолученияЭД - 1;
			Иначе 
				НоваяДатаЗапросаДанных = ЗначенияСвойствОшибок[0].ДатаПроверки;
			КонецЕсли;
		КонецЕсли;
		
		Если Ошибки.Количество() Тогда
			Если ИзменитьДату Тогда
				Если ОбработкаНеисправностейБЭДКлиентСервер.ЭтоОшибкаДанногоВида(Ошибки[0],
					СинхронизацияЭДО.ВидОшибкиЕстьНеполученныеЭлектронныеДокументы()) Тогда
					ИзменяемоеСвойство = "ДатаПолученияДокументов";
					ШаблонСообщения = НСтр("ru = 'Начальная дата запроса электронных документов изменена на %1'");
				Иначе
					ИзменяемоеСвойство = "ДатаПолученияПриглашений";
					ШаблонСообщения = НСтр(
						"ru = 'Начальная дата запроса приглашений к обмену электронными документами изменена на %1'");
				КонецЕсли;
			Иначе
				Если ОбработкаНеисправностейБЭДКлиентСервер.ЭтоОшибкаДанногоВида(Ошибки[0],
					СинхронизацияЭДО.ВидОшибкиЕстьНеполученныеЭлектронныеДокументы()) Тогда
					ИзменяемоеСвойство = "ПроверочнаяДатаПолученияДокументов";
				Иначе
					ИзменяемоеСвойство = "ПроверочнаяДатаПолученияПриглашений";
				КонецЕсли;
			КонецЕсли;

			Если ЗначениеЗаполнено(НоваяДатаЗапросаДанных) Тогда
				СинхронизацияЭДО.ИзменитьСостояниеОбмена(УчетнаяЗапись, ИзменяемоеСвойство, НоваяДатаЗапросаДанных);
				Если ИзменитьДату Тогда
					Дата = ОбщегоНазначенияБЭД.ДатаИзУниверсальнойДатыВМиллисекундах(НоваяДатаЗапросаДанных);
					ОбщегоНазначения.СообщитьПользователю(СтрШаблон(ШаблонСообщения, Дата));
				КонецЕсли;
				Для Каждого КлючИЗначение Из СоответствиеОшибокДанным Цикл
					Если УчетныеЗаписи.Найти(КлючИЗначение.Ключ) <> Неопределено Тогда
						ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ИсправленныеОшибки, КлючИЗначение.Значение);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
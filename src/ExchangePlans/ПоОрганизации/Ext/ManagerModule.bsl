﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - Структура - настройки плана обмена по умолчанию, см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию,
//                          описание возвращаемого значения функции.
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	Настройки.НазначениеПланаОбмена = "РИБСФильтром";
	Настройки.ИмяПланаОбменаДляПереходаНаНовыйОбмен = "СОтборами";
	Настройки.Алгоритмы.ОписаниеОграниченийПередачиДанных = Истина;
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	
КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                       см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                       описание возвращаемого значения.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт
	
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных()
		И Константы.УчетПоКомпании.Получить() Тогда
		
		ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = ЗаголовокИспользуетсяУчетПоКомпании();
	Иначе
		ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = НСтр("ru = 'РИБ с фильтром по организации (устарела)'");
	КонецЕсли;
	
	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника = НСтр("ru = 'Настройки обмена удаленное рабочего места'");
	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена = ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
	ОписаниеВарианта.ИмяФормыСозданияНачальногоОбраза = "ОбщаяФорма.СозданиеНачальногоОбразаСФайлами";
	ОписаниеВарианта.ИспользоватьПомощникСозданияОбменаДанными = Ложь;
	ОписаниеВарианта.Отборы = НастройкаОтборовНаУзле();
	ОписаниеВарианта.КраткаяИнформацияПоОбмену = НСтр(
		"ru = 'Настройка устарела. Следует использовать ""РИБ с фильтрами""'");
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену = "ПланОбмена.ПоОрганизации.Форма.ПодробнаяИнформация";
	
КонецПроцедуры

// Возвращает строку описания ограничений миграции данных для пользователя;
// Прикладной разработчик на основе установленных отборов на узле должен сформировать строку описания ограничений 
// удобную для восприятия пользователем.
// 
// Параметры:
//  НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена,
//                                       полученная при помощи функции НастройкаОтборовНаУзле().
// 
// Возвращаемое значение:
//  Строка - строка описания ограничений миграции данных для пользователя
//
Функция ОписаниеОграниченийПередачиДанных(НастройкаОтборовНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	Если НастройкаОтборовНаУзле.Организации.Организация.Количество() > 0 Тогда 
		СтрокаПредставленияОтбора = СтрСоединить(НастройкаОтборовНаУзле.Организации.Организация, "; ");
		НСтрока = НСтр("ru = 'Только по организациям: %1'");
		ОграничениеОтборПоОрганизациям = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтрока, СтрокаПредставленияОтбора);
		Возврат ОграничениеОтборПоОрганизациям;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

Функция ЗаголовокИспользуетсяУчетПоКомпании() Экспорт
	
	Возврат НСтр("ru = 'Удаленное рабочее место организации не совместимо с опцией ""Учет по компании""'");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает структуру отборов на узле плана обмена с установленными значениями по умолчанию;
// Структура настроек повторяет состав реквизитов шапки и табличных частей плана обмена;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры,
// а для табличных частей используются структуры,
// содержащие массивы значений полей табличных частей плана обмена.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура отборов на узле плана обмена
// 
Функция НастройкаОтборовНаУзле()
	
	СтруктураТабличнойЧастиОрганизации = Новый Структура;
	СтруктураТабличнойЧастиОрганизации.Вставить("Организация", Новый Массив);
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("Организации",СтруктураТабличнойЧастиОрганизации);
	
	Возврат СтруктураНастроек;
	
КонецФункции

#КонецОбласти

#КонецЕсли
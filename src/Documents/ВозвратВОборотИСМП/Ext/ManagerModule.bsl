﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Статусы

// Возвращает конечные статусы.
//
// Возвращаемое значение:
//  Массив - Конечные статусы.
//
Функция КонечныеСтатусы(ТребуетсяПовторноеОформление = Истина) Экспорт
	
	Статусы = Новый Массив;
	
	Если Не ТребуетсяПовторноеОформление Тогда
		Статусы.Добавить(Перечисления.СтатусыОбработкиВозвратаВОборотИСМП.КодыМаркировкиВозвращеныВОборот);
	КонецЕсли;
	
	Возврат Статусы;
	
КонецФункции

// Возвращает статусы ошибок.
//
// Возвращаемое значение:
//  Массив - Статусы ошибок.
//
Функция СтатусыОшибок() Экспорт
	
	Статусы = Новый Массив;
	
	Статусы.Добавить(Перечисления.СтатусыОбработкиВозвратаВОборотИСМП.ОшибкаПередачи);
	
	Возврат Статусы;
	
КонецФункции

// Возвращает статус по умолчанию.
//
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыОбработкиВозвратаВОборотИСМП- Статус по-умолчанию.
//
Функция СтатусПоУмолчанию() Экспорт
	
	Возврат Перечисления.СтатусыОбработкиВозвратаВОборотИСМП.Черновик;
	
КонецФункции

// Возвращает дальнейшее действие по умолчанию.
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюИСМП - Дальнейшее действие по-умолчанию.
//
Функция ДальнейшееДействиеПоУмолчанию(СтруктураПараметров=Неопределено) Экспорт
	
	Возврат Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.ПередайтеДанные;
	
КонецФункции

#КонецОбласти

#Область ДействияПриОбменеИСМП

// Статус после подготовки к передаче данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ВозвратВОборотИСМП - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыОперацийИСМП - Операция ИСМП
//  ДополнительныеПараметры - Структура - Дополнительные параметры
//
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * НовыйСтатус - ПеречислениеСсылка.СтатусыОбработкиВозвратаВОборотИСМП - Новый статус.
//   * ДальнейшееДействие1 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюИСМП - Дальнейшее действие 1.
//   * ДальнейшееДействие2 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюИСМП - Дальнейшее действие 2.
//   * ДальнейшееДействие3 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюИСМП - Дальнейшее действие 3.
//
Функция СтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Операция = Перечисления.ВидыОперацийИСМП.ВозвратВОборотПриРозничнойРеализации
		Или Операция = Перечисления.ВидыОперацийИСМП.ВозвратВОборотПриДистанционномСпособеПродажи Тогда
		
		ПараметрыОбновления = РегистрыСведений.СтатусыДокументовИСМП.РассчитатьСтатусыКПередаче(
			ДокументСсылка,
			Перечисления.СтатусыОбработкиВозвратаВОборотИСМП.КПередаче);
		
	Иначе
		ВызватьИсключение ИнтеграцияИС.ТекстИсключенияОбработкиСтатуса(ДокументСсылка, Операция);
	КонецЕсли;
	
	Возврат ПараметрыОбновления;
	
КонецФункции

// Статус после передачи данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ВозвратВОборотИСМП - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыОперацийИСМП - Операция ИСМП
//  СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийИСМП - Статус обработки сообщения
//
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * НовыйСтатус - ПеречислениеСсылка.СтатусыОбработкиВозвратаВОборотИСМП - Новый статус.
//   * ДальнейшееДействие1 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюИСМП - Дальнейшее действие 1.
//   * ДальнейшееДействие2 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюИСМП - Дальнейшее действие 2.
//   * ДальнейшееДействие3 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюИСМП - Дальнейшее действие 3.
//
Функция СтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки) Экспорт
	
	Если СтатусОбработки = Неопределено Тогда
		СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийИСМП.ЗаявкаПринята;
	КонецЕсли;
	
	Если Операция = Перечисления.ВидыОперацийИСМП.ВозвратВОборотПриРозничнойРеализации
		Или Операция = Перечисления.ВидыОперацийИСМП.ВозвратВОборотПриДистанционномСпособеПродажи Тогда
		
		СтатусыБазовыйПроцесс = РегистрыСведений.СтатусыДокументовИСМП.СтруктураСтатусы();
		
		СтатусыБазовыйПроцесс.Принят = Перечисления.СтатусыОбработкиВозвратаВОборотИСМП.Обрабатывается;
		СтатусыБазовыйПроцесс.ПринятДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.ОжидайтеЗавершенияОбработкиДанныхИСМП);
		
		СтатусыБазовыйПроцесс.Ошибка = Перечисления.СтатусыОбработкиВозвратаВОборотИСМП.ОшибкаПередачи;
		СтатусыБазовыйПроцесс.ОшибкаДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.ПередайтеДанные);
		СтатусыБазовыйПроцесс.ОшибкаДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.ОтменитеОперацию);
		
		ПараметрыОбновления = РегистрыСведений.СтатусыДокументовИСМП.РассчитатьСтатусы(ДокументСсылка, СтатусОбработки, СтатусыБазовыйПроцесс);
		
	Иначе
		ВызватьИсключение ИнтеграцияИС.ТекстИсключенияОбработкиСтатуса(ДокументСсылка, Операция);
	КонецЕсли;
	
	Возврат ПараметрыОбновления;
	
КонецФункции

// Статус после получения данных из ИСМП.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ВозвратВОборотИСМП - Документ, для которого требуется обновить статус.
//  Операция - ПеречислениеСсылка.ВидыОперацийИСМП - Операция обмена с ИСМП.
//  ДополнительныеПараметры - Неопределено, Структура - Свойства:
//   * СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийИСМП - Статус обработки сообщения.
//   * ОперацияКвитанции - ПеречислениеСсылка.ВидыОперацийИСМП - Операция квитанции.
//
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * НовыйСтатус - ПеречислениеСсылка.СтатусыОбработкиВозвратаВОборотИСМП - Новый статус.
//   * ДальнейшееДействие1 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюИСМП - Дальнейшее действие 1.
//   * ДальнейшееДействие2 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюИСМП - Дальнейшее действие 2.
//   * ДальнейшееДействие3 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюИСМП - Дальнейшее действие 3.
//
Функция СтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры) Экспорт
	
	Если Операция = Перечисления.ВидыОперацийИСМП.ПолучениеРезультатаОбработкиДокумента Тогда
		
		Статусы = РегистрыСведений.СтатусыДокументовИСМП.СтруктураСтатусы();
		Статусы.Принят = Перечисления.СтатусыОбработкиВозвратаВОборотИСМП.КодыМаркировкиВозвращеныВОборот;
		
		Статусы.Ошибка = Перечисления.СтатусыОбработкиВозвратаВОборотИСМП.ОшибкаПередачи;
		Статусы.ОшибкаДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.ПередайтеДанные);
		Статусы.ОшибкаДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.ОтменитеОперацию);
		
		ПараметрыОбновления = РегистрыСведений.СтатусыДокументовИСМП.РассчитатьСтатусы(
			ДокументСсылка,
			ДополнительныеПараметры.СтатусОбработки,
			Статусы);
		
	Иначе
		ВызватьИсключение ИнтеграцияИС.ТекстИсключенияОбработкиСтатуса(ДокументСсылка, Операция);
	КонецЕсли;
	
	Возврат ПараметрыОбновления;
	
КонецФункции

// Обновить статус после подготовки к передаче данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ВозвратВОборотИСМП - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыОперацийИСМП - Операция ИСМП.
//  ДополнительныеПараметры - Неопределено, Структура - дополнительные параметры обновления статуса.
//
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыОбработкиВозвратаВОборотИСМП - Новый статус.
//
Функция ОбновитьСтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОбновления = СтатусПослеПодготовкиКПередачеДанных(
		ДокументСсылка, Операция, ДополнительныеПараметры);
	
	Если ПараметрыОбновления = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатусПослеОбновления = РегистрыСведений.СтатусыДокументовИСМП.ОбновитьСтатус(
		ДокументСсылка,
		ПараметрыОбновления, ДополнительныеПараметры);
	
	Возврат НовыйСтатусПослеОбновления;
	
КонецФункции

// Обновить статус после передачи данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ВозвратВОборотИСМП - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыОперацийИСМП - Операция ИСМП
//  СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийИСМП - Статус обработки сообщения
//  ДополнительныеПараметры - Неопределено, Структура - дополнительные параметры обновления статуса.
//
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыОбработкиВозвратаВОборотИСМП - Новый статус.
//
Функция ОбновитьСтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОбновления = СтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки);
	
	Если ПараметрыОбновления = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатусПослеОбновления = РегистрыСведений.СтатусыДокументовИСМП.ОбновитьСтатус(
		ДокументСсылка,
		ПараметрыОбновления, ДополнительныеПараметры);
	
	Возврат НовыйСтатусПослеОбновления;
	
КонецФункции

// Обновить статус после получения данных из ИСМП.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ВозвратВОборотИСМП - Документ, для которого требуется обновить статус.
//  Операция - ПеречислениеСсылка.ВидыОперацийИСМП - Операция обмена с ИСМП.
//  ДополнительныеПараметры - Неопределено, Структура - Свойства:
//   * СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийИСМП - Статус обработки сообщения.
//   * ОперацияКвитанции - ПеречислениеСсылка.ВидыОперацийИСМП - Операция, на которую получена квитанция.
//
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыОбработкиВозвратаВОборотИСМП - Новый статус.
//
Функция ОбновитьСтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОбновления = СтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры);
	
	Если ПараметрыОбновления = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатусПослеОбновления = РегистрыСведений.СтатусыДокументовИСМП.ОбновитьСтатус(
		ДокументСсылка,
		ПараметрыОбновления, ДополнительныеПараметры);
	
	Возврат НовыйСтатусПослеОбновления;
	
КонецФункции

// Изменяет и возвращает статус документа ИС МП.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ВозвратВОборотИСМП - Документ ИС МП.
//  ПараметрыОбновления - Структура - Структура со свойствами:
//   * НовыйСтатус - ПеречислениеСсылка.СтатусыОбработкиВозвратаВОборотИСМП - Новый статус.
//   * ДальнейшееДействие1 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюИСМП - Дальнейшее действие 1.
//   * ДальнейшееДействие2 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюИСМП - Дальнейшее действие 2.
//   * ДальнейшееДействие3 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюИСМП - Дальнейшее действие 3.
//  ДополнительныеПараметры - Структура - Дополнительные параметры.
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыОбработкиВозвратаВОборотИСМП - новый статус документа ИС МП.
Функция ОбновитьСтатус(ДокументСсылка, ПараметрыОбновления, ДополнительныеПараметры) Экспорт
	
	НовыйСтатусПослеОбновления = РегистрыСведений.СтатусыДокументовИСМП.ОбновитьСтатус(
		ДокументСсылка,
		ПараметрыОбновления, ДополнительныеПараметры);
	
	Возврат НовыйСтатусПослеОбновления;
	
КонецФункции

// Получить последовательность операций в течении жизненного цикла документа.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ВозвратВОборотИСМП - Документ, для которого требуется обновить статус.
//
// Возвращаемое значение:
//  ТаблицаЗначений - см. ИнтеграцияИС.ПустаяТаблицаПоследовательностьОпераций.
//
Функция ПоследовательностьОпераций(ДокументСсылка, ЛинейныйСписок = Ложь) Экспорт
	
	Таблица = ИнтеграцияИС.ПустаяТаблицаПоследовательностьОпераций();
	
	Исходящий = Перечисления.ТипыЗапросовИС.Исходящий;
	
	ОперацияВПоследовательности = ИнтеграцияИС.ДобавитьОперациюВПоследовательность(Таблица, 1,
		Исходящий,
		Перечисления.ВидыОперацийИСМП.ВозвратВОборот);
	ОперацияВПоследовательности.АбстрактнаяОперация = Истина;
	
	ИнтеграцияИС.ДобавитьОперациюВПоследовательность(Таблица, 11,
		Исходящий,
		Перечисления.ВидыОперацийИСМП.ВозвратВОборотПриРозничнойРеализации);
	
	ИнтеграцияИС.ДобавитьОперациюВПоследовательность(Таблица, 12,
		Исходящий,
		Перечисления.ВидыОперацийИСМП.ВозвратВОборотПриДистанционномСпособеПродажи);
	
	Возврат Таблица;
	
КонецФункции

// Обработчик изменения статуса документа.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ВозвратВОборотИСМП - Документ.
//  ПредыдущийСтатус - ПеречислениеСсылка.СтатусыОбработкиВозвратаВОборотИСМП - Предыдущий статус.
//  НовыйСтатус - ПеречислениеСсылка.СтатусыОбработкиВозвратаВОборотИСМП - Новый статус.
//  ПараметрыОбновленияСтатуса - Структура - см. функцию ИнтеграцияИСМП.ПараметрыОбновленияСтатуса().
//
Процедура ПриИзмененииСтатусаДокумента(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус, ПараметрыОбновленияСтатуса) Экспорт
	
	ИнтеграцияИСМППереопределяемый.ПриИзмененииСтатусаДокумента(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус, ПараметрыОбновленияСтатуса);
	
	//Получение конечного статуса требующего повторного оформления
	Если КонечныеСтатусы().Найти(НовыйСтатус)<>Неопределено
		И КонечныеСтатусы().Найти(ПредыдущийСтатус)=Неопределено Тогда
		РасчетСтатусовОформленияИСМП.РассчитатьСтатусыОформленияДокументов(ДокументСсылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПанельОбменИСМП

// Возвращает массив дальнейших действий с документом, требующих участия пользователя
// 
// Возвращаемое значение:
// 	Массив из ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюИСМП - дальшейшие действия
//
Функция ВсеТребующиеДействия() Экспорт
	
	МассивДействий = Новый Массив;
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.ВыполнитеОбмен);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.ОтменитеОперацию);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.ПередайтеДанные);
	
	Возврат МассивДействий;
	
КонецФункции

Функция ВсеТребующиеОжидания() Экспорт
	
	МассивДействий = Новый Массив;
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.ОжидайтеПередачуДанныхРегламентнымЗаданием);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.ОжидайтеЗавершенияОбработкиДанныхИСМП);
	
	Возврат МассивДействий;
	
КонецФункции

#КонецОбласти

#Область Сообщения

// Сообщение к передаче JSON
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ВозвратВОборотИСМП - Возврат в оборот ИС МП.
//  ДальнейшееДействие - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюИСМП - Дальнейшее действие.
//  ДополнительныеПараметры - Неопределено, Структура - дополнительные параметры для формирования сообщения.
//
// Возвращаемое значение:
//  Структура - Данные JSON сообщения.
//
Функция СообщениеКПередачеJSON(ДокументСсылка, ДальнейшееДействие, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюИСМП.ПередайтеДанные Тогда
		
		Возврат ВозвратВОборотJSON(ДокументСсылка, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецФункции

// Формирование сообщения JSON для передачи в сервис ИС МП
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ВозвратВОборотИСМП - Возврат в оборот ИС МП.
// Возвращаемое значение:
//  Массив - Сформированные по сообщению сообщения
Функция ВозвратВОборотJSON(ДокументСсылка, ДополнительныеПараметры = Неопределено)
	
	СообщенияJSON = Новый Массив;
	
	СписокЗапросов = Новый СписокЗначений;
	
	СписокЗапросов.Добавить(
	"ВЫБРАТЬ
	|	ИСМППрисоединенныеФайлы.ВладелецФайла КАК Ссылка,
	|	КОЛИЧЕСТВО(ИСМППрисоединенныеФайлы.Ссылка) КАК ПоследнийНомерВерсии
	|ПОМЕСТИТЬ Версии
	|ИЗ
	|	Справочник.ИСМППрисоединенныеФайлы КАК ИСМППрисоединенныеФайлы
	|ГДЕ
	|	ИСМППрисоединенныеФайлы.ВладелецФайла = &Ссылка
	|	И ИСМППрисоединенныеФайлы.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовИС.Исходящий)
	|СГРУППИРОВАТЬ ПО
	|	ИСМППрисоединенныеФайлы.ВладелецФайла
	|");
	
	СписокЗапросов.Добавить(
	"ВЫБРАТЬ
	|	Шапка.Номер                              КАК Номер,
	|	Шапка.Дата                               КАК Дата,
	|	ЕСТЬNULL(Версии.ПоследнийНомерВерсии, 0) КАК ПоследнийНомерВерсии,
	|	Шапка.ДокументОснование                  КАК ДокументОснование,
	|
	|	Шапка.Организация                КАК Организация,
	|	Представление(Шапка.Организация) КАК ОрганизацияПредставление,
	|
	|	Шапка.Ответственный                КАК Ответственный,
	|	Представление(Шапка.Ответственный) КАК ОтветственныйПредставление,
	|
	|	Шапка.Операция                        КАК Операция,
	|	Шапка.ВидПродукции                    КАК ВидПродукции,
	|	Шапка.Ссылка                          КАК Ссылка
	|
	|ИЗ
	|	Документ.ВозвратВОборотИСМП КАК Шапка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Версии КАК Версии
	|		ПО Шапка.Ссылка = Версии.Ссылка
	|ГДЕ
	|	Шапка.Ссылка = &Ссылка",
	"Шапка");
	
	СписокЗапросов.Добавить(
	"ВЫБРАТЬ
	|	// Универсальные реквизиты
	|	Товары.Номенклатура   КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Серия          КАК Серия,
	|
	|	// Дополнительные реквизиты
	|	ЕСТЬNULL(Товары.КодМаркировки.ЗначениеШтрихкода, """") КАК КодМаркировки,
	|	Товары.Оплачен                                КАК Оплачен,
	|	
	|	Товары.ВидДокументаСертификации   КАК ВидДокументаСертификации,
	|	Товары.НомерДокументаСертификации КАК НомерДокументаСертификации,
	|	Товары.ДатаДокументаСертификации  КАК ДатаДокументаСертификации,
	|
	|	Товары.ВидПервичногоДокумента          КАК ВидПервичногоДокумента,
	|	Товары.НаименованиеПервичногоДокумента КАК НаименованиеПервичногоДокумента,
	|	Товары.НомерПервичногоДокумента        КАК НомерПервичногоДокумента,
	|	Товары.ДатаПервичногоДокумента         КАК ДатаПервичногоДокумента
	|ИЗ
	|	Документ.ВозвратВОборотИСМП.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|",
	"Товары");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	РезультатЗапроса = ИнтеграцияИС.ВыполнитьПакетЗапросов(Запрос, СписокЗапросов);
	
	//@skip-warning
	Шапка  = РезультатЗапроса["Шапка"].Выбрать();
	//@skip-warning
	Товары = РезультатЗапроса["Товары"].Выгрузить();
	
	Если Не Шапка.Следующий()
		Или Товары.Количество() = 0 Тогда
		
		СообщениеJSON = ИнтеграцияИСМПСлужебный.СтруктураСообщенияJSON();
		СообщениеJSON.Организация = Шапка.Организация;
		СообщениеJSON.Документ    = ДокументСсылка;
		СообщениеJSON.Описание = ИнтеграцияИСМПСлужебный.ОписаниеОперацииПередачиДанных(
			Шапка.Операция, ДокументСсылка);
		СообщениеJSON.ТекстОшибки = НСтр("ru = 'Нет данных для выгрузки.'");
		СообщениеJSON.ТребуетсяПодписание = Ложь;
		СообщенияJSON.Добавить(СообщениеJSON);
		
		Возврат СообщенияJSON;
		
	КонецЕсли;
	
	НомерВерсии = Шапка.ПоследнийНомерВерсии + 1;
	
	СообщениеJSON = ИнтеграцияИСМПСлужебный.СтруктураСообщенияJSON();
	СообщениеJSON.Организация       = Шапка.Организация;
	СообщениеJSON.Документ          = ДокументСсылка;
	СообщениеJSON.ДокументОснование = Шапка.ДокументОснование;
	
	СообщениеJSON.Описание = ИнтеграцияИСМПСлужебный.ОписаниеОперацииПередачиДанных(
		Шапка.Операция, ДокументСсылка, НомерВерсии);
	
	РеквизитыОрганизации = ИнтеграцияИСВызовСервера.ИННКПППоОрганизацииКонтрагенту(Шапка.Организация);
	
	Если Не ЗначениеЗаполнено(РеквизитыОрганизации.ИНН) Тогда
		ИнтеграцияИСКлиентСервер.ДобавитьТекстОшибки(
			СообщениеJSON,
			СтрШаблон(
				НСтр("ru = 'Не заполнено поле ""ИНН"" для организации %1'"), Шапка.Организация));
	КонецЕсли;
	
	ПараметрыНормализацииПрочее = РазборКодаМаркировкиИССлужебныйКлиентСервер.ПараметрыНормализацииКодаМаркировки();
	ПараметрыНормализацииПрочее.ИмяСвойстваКодМаркировки = "Штрихкод";
	ПараметрыНормализацииПрочее.НачинаетсяСоСкобки       = Ложь;
	
	ТелоЗапроса = Новый Структура;
	ТелоЗапроса.Вставить("trade_participant_inn", РеквизитыОрганизации.ИНН);
	ТелоЗапроса.Вставить("return_type",           ИнтерфейсИСМПСлужебный.ВидВозвратаВОборот(Шапка.Операция));
	ТелоЗапроса.Вставить("products_list",         Новый Массив);
	
	Для Каждого СтрокаТЧТовары Из Товары Цикл
		
		СтрокаТЧ = Новый Структура;
		РезультатРазбора = ШтрихкодированиеИС.НоваяСтруктураОбработкиШтрихкода(
			СтрокаТЧТовары.КодМаркировки, Шапка.ВидПродукции, Ложь);
		
		СтрокаТЧ.Вставить(
			"ki",
			ШтрихкодированиеИСМП.КодМаркировкиДляПередачиИСМП(РезультатРазбора, ПараметрыНормализацииПрочее));
		
		СтрокаТЧ.Вставить("paid", СтрокаТЧТовары.Оплачен);
		// Сертификация
		Если ЗначениеЗаполнено(СтрокаТЧТовары.ВидДокументаСертификации) Тогда
			СтрокаТЧ.Вставить("certificate_type",   ИнтерфейсИСМПСлужебный.ВидДокументаСертификации(СтрокаТЧТовары.ВидДокументаСертификации));
			СтрокаТЧ.Вставить("certificate_number", СтрокаТЧТовары.НомерДокументаСертификации);
			СтрокаТЧ.Вставить("certificate_date",   ИнтеграцияИС.ДатаUTC(СтрокаТЧТовары.ДатаДокументаСертификации));
		КонецЕсли;
		
		УказатьПервичныйДокумент = (СтрокаТЧТовары.Оплачен
			Или Шапка.Операция = Перечисления.ВидыОперацийИСМП.ВозвратВОборотПриРозничнойРеализации);
			
		Если УказатьПервичныйДокумент Тогда
			СтрокаТЧ.Вставить(
				"primary_document_type",
				ИнтерфейсИСМПСлужебный.ВидПервичногоДокумента(СтрокаТЧТовары.ВидПервичногоДокумента));
			Если СтрокаТЧТовары.ВидПервичногоДокумента = Перечисления.ВидыПервичныхДокументовИСМП.Прочее Тогда
				ТелоЗапроса.Вставить("primary_document_custom_name", СтрокаТЧТовары.НаименованиеПервичногоДокумента);
			КонецЕсли;
			
			СтрокаТЧ.Вставить("primary_document_date",   ИнтеграцияИС.ДатаUTC(СтрокаТЧТовары.ДатаПервичногоДокумента));
			СтрокаТЧ.Вставить("primary_document_number", СтрокаТЧТовары.НомерПервичногоДокумента);
		КонецЕсли;
		
		ТелоЗапроса.products_list.Добавить(СтрокаТЧ);
		
	КонецЦикла;
	
	ТекстСообщенияJSON = ИнтерфейсМОТПСлужебный.ОбъектВТекстJSON(ТелоЗапроса, Истина);
	
	СообщениеJSON.ТекстСообщенияJSON  = ТекстСообщенияJSON;
	СообщениеJSON.ТипСообщения        = Перечисления.ТипыЗапросовИС.Исходящий;
	СообщениеJSON.Версия              = НомерВерсии;
	СообщениеJSON.ТребуетсяПодписание = Истина;
	
	СообщениеJSON.Операция                  = Шапка.Операция;
	СообщениеJSON.Назначение                = Перечисления.НазначениеСообщенийИСМП.ИСМП;
	СообщениеJSON.СтанцияУправленияЗаказами = Неопределено;
	СообщениеJSON.ВидПродукции              = Шапка.ВидПродукции;
	
	СообщенияJSON.Добавить(СообщениеJSON);
	
	Возврат СообщенияJSON;
	
КонецФункции

#КонецОбласти

#Область ОбработкаКодовМаркировки

Функция ОбработатьДанныеШтрихкода(Форма, ДанныеШтрихкода, ПараметрыСканирования, ВложенныеШтрихкоды = Неопределено) Экспорт
	
	Результат = ШтрихкодированиеИС.ИнициализироватьРезультатОбработкиШтрихкода(ПараметрыСканирования, ДанныеШтрихкода);
	
	Если ДанныеШтрихкода.ВидУпаковки = Перечисления.ВидыУпаковокИС.Логистическая Тогда
		
		ОбработатьДанныеШтрихкодаУпаковкиМаркируемойПродукции(Результат, Форма, ДанныеШтрихкода);
		
	Иначе
		
		ОбработатьДанныеШтрихкодаПотребительскойУпаковки(Результат, Форма, ДанныеШтрихкода);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ОбработатьДанныеШтрихкодаУпаковкиМаркируемойПродукции(РезультатОбработки, Форма, ДанныеШтрихкода)
	
	РезультатОбработки.ЕстьОшибки = Истина;
	РезультатОбработки.ЕстьОшибкиВДеревеУпаковок = Истина;
	РезультатОбработки.ОбщаяОшибка = Истина;
	РезультатОбработки.ТекстОшибки = НСтр("ru = 'Невозможно вернуть в оборот логистическую упаковку'");
	
КонецПроцедуры

Процедура ОбработатьДанныеШтрихкодаПотребительскойУпаковки(РезультатОбработки, Форма, ДанныеШтрихкода)
	
	ПараметрыЗаполнения = Новый Структура("ДобавленныеСтроки, ИзмененныеСтроки", Новый Массив, Новый Массив);
	
	Если ИнтеграцияИСПовтИсп.ЭтоПродукцияИСМП(ДанныеШтрихкода.ВидПродукции, Истина) Тогда
		
		ИсточникДанных = Форма.Объект;
	
		ПараметрыПоиска = ИнтеграцияИС.ПоляПоискаМаркируемойПродукции();
		ЗаполнитьЗначенияСвойств(ПараметрыПоиска, ДанныеШтрихкода);
		ПараметрыПоиска.Вставить("КодМаркировки", Справочники.ШтрихкодыУпаковокТоваров.ПустаяСсылка());
		
		НайденныеСтрокиТовары = ИсточникДанных.Товары.НайтиСтроки(ПараметрыПоиска);
		Если НайденныеСтрокиТовары.Количество() > 0 Тогда
			СтрокаТовары = НайденныеСтрокиТовары[0];
			ПараметрыЗаполнения.ИзмененныеСтроки.Добавить(СтрокаТовары);
		Иначе
			СтрокаТовары = ИсточникДанных.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТовары, ДанныеШтрихкода);
			ПараметрыЗаполнения.ДобавленныеСтроки.Добавить(СтрокаТовары);
		КонецЕсли;
		СтрокаТовары.КодМаркировки = ДанныеШтрихкода.ШтрихкодУпаковки;
		
	КонецЕсли;
	
	РезультатОбработки.ИзмененныеСтроки  = ПараметрыЗаполнения.ИзмененныеСтроки;
	РезультатОбработки.ДобавленныеСтроки = ПараметрыЗаполнения.ДобавленныеСтроки;
	
КонецПроцедуры

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

#Область Отчеты

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//   Параметры - Структура - Вспомогательные параметры. См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры.
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	ИнтеграцияИСПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
	ИнтеграцияИСПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую.
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
	Возврат;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	УправлениеДоступомИСПереопределяемый.ПриЗаполненииОграниченияДоступа(
		Метаданные.Документы.ВозвратВОборотИСМП, Ограничение);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область Серии

//Имена реквизитов, от значений которых зависят параметры указания серий. Переопределяется.
//
//Возвращаемое значение:
//  Строка - имена реквизитов, перечисленные через запятую
//
Функция ИменаРеквизитовДляЗаполненияПараметровУказанияСерий() Экспорт
	
	Возврат ИнтеграцияИС.ИменаРеквизитовДляЗаполненияПараметровУказанияСерий(Метаданные.Документы.ВозвратВОборотИСМП);
	
КонецФункции

//Возвращает параметры указания серий для товаров, указанных в документе. Переопределяется.
//
//Параметры:
//  Объект - Структура - структура значений реквизитов объекта, необходимых для заполнения параметров указания серий.
//
//Возвращаемое значение:
//  Произвольный - параметры указания серий.
//
Функция ПараметрыУказанияСерий(Объект) Экспорт
	
	Возврат ИнтеграцияИС.ПараметрыУказанияСерий(Метаданные.Документы.ВозвратВОборотИСМП, Объект);
	
КонецФункции

//Возвращает текст запроса для расчета статусов указания серий. Переопределяется.
//
//Параметры:
//   ПараметрыУказанияСерий - Произвольный - см. ПараметрыУказанияСерий.
//
//Возвращаемое значение:
//  Строка - текст запроса.
//
Функция ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий) Экспорт
	
	Возврат ИнтеграцияИС.ТекстЗапросаЗаполненияСтатусовУказанияСерий(Метаданные.Документы.ВозвратВОборотИСМП, ПараметрыУказанияСерий);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
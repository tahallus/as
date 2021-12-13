﻿
#Область СлужебныйПрограммныйИнтерфейс

// Метод проверяет наличие в регистре сведений записей о новых ЭД.
//
// Возвращаемое значение:
//  Булево - признак наличия в сервисе новых электронных документов.
//
Функция ЕстьСобытияЭДО() Экспорт
	
	ЕстьНовыеСобытия = Ложь;
	
	Если Не ДоступноОповещениеОСобытияхЭДО() Тогда
		Возврат ЕстьНовыеСобытия;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	1 КАК ЕстьНовыеЭД
	|ИЗ
	|	РегистрСведений.НаличиеНовыхЭлектронныхДокументов КАК НаличиеНовыхЭлектронныхДокументов";
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		ЕстьНовыеСобытия = Истина;
	КонецЕсли;
	
	Возврат ЕстьНовыеСобытия;
	
КонецФункции

Функция ДоступноОповещениеОСобытияхЭДО() Экспорт
	
	Оповещать = Ложь;
	
	Если ЭлектронныеДокументыЭДО.ЕстьПравоОбработкиДокументов()
		И ОповещенияОСобытияхЭДОПовтИсп.ЕстьРегламентноеЗаданиеПроверкаНовыхЭлектронныхДокументов() Тогда
		Оповещать = Истина;
	КонецЕсли;
	
	Возврат Оповещать;
	
КонецФункции

// Возвращает идентификаторы учетных записей, для которых в сервисе ЭДО есть новые электронные документы.
// 
// Параметры:
// 	ИдентификаторыУчетныхЗаписей - Массив из Строка
// Возвращаемое значение:
// 	Массив из Строка - учетные записи, для которых есть новые электронные документы.
Функция ЕстьНовыеЭлектронныеДокументыВСервисеЭДО(ИдентификаторыУчетныхЗаписей) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	НаличиеНовыхЭлектронныхДокументов.ИдентификаторЭДО КАК ИдентификаторЭДО
	               |ИЗ
	               |	РегистрСведений.НаличиеНовыхЭлектронныхДокументов КАК НаличиеНовыхЭлектронныхДокументов
	               |ГДЕ
	               |	НаличиеНовыхЭлектронныхДокументов.ИдентификаторЭДО В(&МассивИдентификаторовЭДО)";
	Запрос.УстановитьПараметр("МассивИдентификаторовЭДО", ИдентификаторыУчетныхЗаписей);
	
	Результат = Новый Массив;
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			Результат.Добавить(Выборка.ИдентификаторЭДО);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Устанавливает факт наличия новых документов.
// 
// Параметры:
// 	ИдентификаторыУчетныхЗаписей - Массив из Строка
// 	ЕстьНовыеДокументы - Булево
Процедура УстановитьПризнакНаличияНовыхЭлектронныхДокументов(ИдентификаторыУчетныхЗаписей, ЕстьНовыеДокументы) Экспорт

	Для Каждого Идентификатор Из ИдентификаторыУчетныхЗаписей Цикл

		Набор = РегистрыСведений.НаличиеНовыхЭлектронныхДокументов.СоздатьНаборЗаписей();
		Набор.Отбор.ИдентификаторЭДО.Установить(Идентификатор);

		НачатьТранзакцию();
		Попытка
			ОбщегоНазначенияБЭД.УстановитьУправляемуюБлокировкуПоНаборуЗаписей(Набор);
			Если ЕстьНовыеДокументы Тогда
				Запись = Набор.Добавить();
				Запись.ИдентификаторЭДО = Идентификатор;
				Набор.Записать();
			Иначе
				Набор.Прочитать();

				Если ЗначениеЗаполнено(Набор) Тогда
					Набор.Очистить();
					Набор.Записать();
				КонецЕсли;
			КонецЕсли;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ИмяСобытия = НСтр("ru = 'Установка признака наличия новых электронных документов'",
				ОбщегоНазначения.КодОсновногоЯзыка());
			ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				ВызватьИсключение;
		КонецПопытки;
	КонецЦикла;

КонецПроцедуры

// Возвращает адрес информационной базы для отправки уведомлений. 
// 
// Параметры:
// 	СпособОбмена - ПеречислениеСсылка.СпособыОбменаЭД
// Возвращаемое значение:
// 	Строка - Описание
Функция АдресДляУведомленийЭДО(СпособОбмена) Экспорт
	
	Результат = "";
	
	Если СпособОбмена = Перечисления.СпособыОбменаЭД.ЧерезСервис1СЭДО
		И ИнтеграцияЭДО.ИспользоватьОповещенияОтСервисаЭДО()
		И ДоступноОповещениеОСобытияхЭДО() Тогда
		ПараметрыКлиентаНаСервере = СтандартныеПодсистемыСервер.ПараметрыКлиентаНаСервере();
		СтрокаСоединенияИнформационнойБазы = ПараметрыКлиентаНаСервере.Получить("СтрокаСоединенияИнформационнойБазы"); // Строка
		Если СтрНайти(ВРег(СтрокаСоединенияИнформационнойБазы), "WS=") = 1 Тогда
			СтрокаСоединенияИнформационнойБазы = Сред(СтрокаСоединенияИнформационнойБазы, 5);
			СтрокаСоединенияИнформационнойБазы = СтрЗаменить(СтрокаСоединенияИнформационнойБазы, """;", "");
			Если ЗначениеЗаполнено(СтрокаСоединенияИнформационнойБазы) Тогда
				Результат = СтрокаСоединенияИнформационнойБазы;
			КонецЕсли;
		Иначе
			АдресДляУведомлений = Константы.АдресДляУведомленийЭДО.Получить();
			Если ЗначениеЗаполнено(АдресДляУведомлений) Тогда
				Результат = СокрЛП(АдресДляУведомлений);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Отправляет сообщение системы взаимодействия от имени бота 1С-ЭДО.
// 
// Параметры:
// 	ИдентификаторПользователяИБ - УникальныйИдентификатор
// 	ТекстСообщения - ФорматированнаяСтрока - см. свойство Текст объекта СообщениеСистемыВзаимодействия
// 	Действия - СписокЗначений - см. свойство Действия объекта СообщениеСистемыВзаимодействия
// 	Данные - Произвольный - см. свойство Данные объекта СообщениеСистемыВзаимодействия
Процедура ОтправитьСообщениеСистемыВзаимодействия(ИдентификаторПользователяИБ, ТекстСообщения,
	Действия = Неопределено, Данные = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Действия = Неопределено Тогда
		Действия = Новый СписокЗначений;
	КонецЕсли;
	
	Получатель = ИдентификаторПользователяСистемыВзаимодействия(ИдентификаторПользователяИБ);
	Если Получатель = Неопределено Тогда
		Возврат; // Пользователь не зарегистрирован в системе взаимодействия.
	КонецЕсли;
	
	УдалитьСтароеОбсуждение(ИдентификаторПользователяИБ);
	
	Обсуждение = ОбсуждениеПользователяСБотом(ИдентификаторПользователяИБ);
	
	Если Обсуждение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторБота = ИдентификаторБотаВСистемеВзаимодействия();
	Если ИдентификаторБота = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Сообщение = СистемаВзаимодействия.СоздатьСообщение(Обсуждение.Идентификатор);
	
	Сообщение.Автор = ИдентификаторБота;
	Сообщение.Текст = ТекстСообщения;
	Если Данные <> Неопределено Тогда
		Сообщение.Данные = Данные;
	КонецЕсли;
	Сообщение.Получатели.Добавить(Получатель);
	Для каждого Действие Из Действия Цикл
		Сообщение.Действия.Добавить(Действие.Значение, Действие.Представление);
	КонецЦикла;
	
	Сообщение.Записать();
	
КонецПроцедуры

// Оповещает пользователей о наличии новых документов в сервисе 1С:ЭДО.
// 
// Параметры:
// 	ИдентификаторыУчетныхЗаписей - Массив из Строка
// 	ЕстьОшибки - Булево
Процедура ОповеститьОНовыхДокументахВСервисеЭДО(ИдентификаторыУчетныхЗаписей, ЕстьОшибки) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	РегламентноеЗадание = ОбщегоНазначенияБЭД.РегламентноеЗаданиеПоНаименованию("ПроверкаНовыхЭлектронныхДокументов");
	Если РегламентноеЗадание = Неопределено Или Не РегламентноеЗадание.Использование Тогда
		ЕстьОшибки = Истина;
		Возврат;
	КонецЕсли;

	ПроверитьНаличиеНовыхДокументовВСервисеЭДО(ИдентификаторыУчетныхЗаписей);
	
	Если СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована() Тогда
		СокращенныйМассив = ЕстьНовыеЭлектронныеДокументыВСервисеЭДО(ИдентификаторыУчетныхЗаписей);
	
		Если СокращенныйМассив.Количество() Тогда
			
			Запросы = Новый Массив;
	
			Отбор = СинхронизацияЭДО.НовыйОтборСертификатовУчетныхЗаписей();
			Отбор.УчетныеЗаписи = "&УчетныеЗаписи";
			ЗапросСертификатовУчетныхЗаписей = СинхронизацияЭДО.ЗапросСертификатовУчетныхЗаписей(
				"СертификатыУчетныхЗаписей", Отбор);
			
			Запросы.Добавить(ЗапросСертификатовУчетныхЗаписей);
			
			Запрос = Новый Запрос;
			Запрос.Текст =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	СертификатыУчетныхЗаписей.Сертификат.Пользователь КАК Пользователь,
			|	СертификатыУчетныхЗаписей.Сертификат.Пользователь.ИдентификаторПользователяИБ КАК ИдентификаторПользователяИБ
			|ИЗ
			|	СертификатыУчетныхЗаписей КАК СертификатыУчетныхЗаписей";
			
			ИтоговыйЗапрос = ОбщегоНазначенияБЭД.СоединитьЗапросы(Запрос, Запросы);
			
			ИтоговыйЗапрос.УстановитьПараметр("УчетныеЗаписи", СокращенныйМассив);
			
			Выборка = ИтоговыйЗапрос.Выполнить().Выбрать();
			
			МассивИдентификаторовПользователей = Новый Массив;
			
			Пока Выборка.Следующий() Цикл
				Если Не ЗначениеЗаполнено(Выборка.Пользователь)
					Или Выборка.Пользователь = Пользователи.СсылкаНеуказанногоПользователя() Тогда
					ОповеститьВсехПользователейОНовыхДокументах();
					МассивИдентификаторовПользователей.Очистить();
					Прервать;
				КонецЕсли;
				МассивИдентификаторовПользователей.Добавить(Выборка.ИдентификаторПользователяИБ);
			КонецЦикла;
			
			Если МассивИдентификаторовПользователей.Количество() Тогда
				ОтправитьСообщенияОНовыхДокументах(МассивИдентификаторовПользователей);
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Оповещает пользователей о наличии документов к подписанию.
// 
// Параметры:
// 	Пользователи - Массив из СправочникСсылка.Пользователи
// 	СписокДокументов - СписокЗначений:
//    * Значение - ДокументСсылка.СообщениеЭДО
//    * Представление - Строка
Процедура ОповеститьОДокументахКПодписанию(Пользователи, СписокДокументов) Экспорт 
	
	Если Не СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Пользователи.Ссылка КАК Ссылка,
		|	Пользователи.ИдентификаторПользователяИБ КАК ИдентификаторПользователяИБ
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|	Пользователи.Ссылка В (&Пользователи)";
	
	Запрос.УстановитьПараметр("Пользователи", Пользователи);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТекстСообщения = НСтр("ru = 'Есть документы к подписанию'");
	Действия = Новый СписокЗначений;
	Действия.Добавить("ПодписатьЭД", "" + СписокДокументов[0].Представление);
	Данные = Новый Структура;
	Данные.Вставить("ЭлектронныйДокумент", СписокДокументов[0].Значение);
	
	Пока Выборка.Следующий() Цикл
		ОтправитьСообщениеСистемыВзаимодействия(Выборка.ИдентификаторПользователяИБ, ТекстСообщения, Действия, Данные);
	КонецЦикла;
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами.Синхронизация

// См. СинхронизацияЭДОСобытия.ПриУдаленииУчетнойЗаписи
Процедура ПриУдаленииУчетнойЗаписи(ИдентификаторУчетнойЗаписи) Экспорт
	
	НаборЗаписей = РегистрыСведений.НаличиеНовыхЭлектронныхДокументов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИдентификаторЭДО.Установить(ИдентификаторУчетнойЗаписи);
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами.Синхронизация

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обработчик регламентного задания ПроверкаНовыхЭлектронныхДокументов.
// 
Процедура ПроверитьНовыеЭлектронныеДокументы() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ПроверкаНовыхЭлектронныхДокументов);
	
	ПроверитьНаличиеНовыхДокументовВСервисеЭДО();
	
КонецПроцедуры

Процедура ОбновитьИдентификаторыЭДО(ИдентификаторыЭДО, Удалить = Ложь)
	
	Если ИдентификаторыЭДО.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если Удалить Тогда
		ОчиститьИдентификаторыЭДО(ИдентификаторыЭДО);
	Иначе
		ЗаполнитьИдентификаторыЭДО(ИдентификаторыЭДО);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьИдентификаторыЭДО(ИдентификаторыЭДО)
	
	Для каждого Идентификатор Из ИдентификаторыЭДО Цикл
		
		Набор = РегистрыСведений.НаличиеНовыхЭлектронныхДокументов.СоздатьНаборЗаписей();
		Набор.Отбор.ИдентификаторЭДО.Установить(Идентификатор);
		Набор.Прочитать();
		
		Если ЗначениеЗаполнено(Набор) Тогда
			Набор.Очистить();
			Набор.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьИдентификаторыЭДО(ИдентификаторыЭДО)
	
	Для каждого Идентификатор Из ИдентификаторыЭДО Цикл
		
		Набор = РегистрыСведений.НаличиеНовыхЭлектронныхДокументов.СоздатьНаборЗаписей();
		Набор.Отбор.ИдентификаторЭДО.Установить(Идентификатор);
		Набор.Прочитать();
		
		Если Не ЗначениеЗаполнено(Набор) Тогда
			Запись = Набор.Добавить();
			Запись.ИдентификаторЭДО = Идентификатор;
			Набор.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Создает служебного пользователя для получения оповещений от сервиса ЭДО.
//
Процедура СоздатьСлужебногоПользователяОповещенийЭДО() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Если ОбщегоНазначения.РазделениеВключено()
		И НЕ ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат
	КонецЕсли;
	
	Логин = ИмяСлужебногоПользователяОповещенийЭДО();
	Пароль = "946135e8-a9a7-405f-a5df-19e734c712c7";
	
	ПользовательИзСправочника = Пользователи.НайтиПоИмени(Логин);
	
	Если ПользовательИзСправочника <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ОбщегоНазначения.РазделениеВключено()
		И НЕ ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() Тогда
		Возврат
	КонецЕсли;
	
	Попытка
		
		ОписаниеПользователяИБ = Пользователи.НовоеОписаниеПользователяИБ();
		ОписаниеПользователяИБ.Имя = Логин;
		ОписаниеПользователяИБ.ПолноеИмя = НСтр("ru='Бот 1С-ЭДО'");
		ОписаниеПользователяИБ.АутентификацияСтандартная = Истина;
		ОписаниеПользователяИБ.ПоказыватьВСпискеВыбора = Ложь;
		ОписаниеПользователяИБ.Вставить("Действие", "Записать");
		ОписаниеПользователяИБ.Вставить("ВходВПрограммуРазрешен", Истина);
		ОписаниеПользователяИБ.ЗапрещеноИзменятьПароль = Истина;
		ОписаниеПользователяИБ.Пароль = Пароль;
		ОписаниеПользователяИБ.Роли = Новый Массив;
		ОписаниеПользователяИБ.Роли.Добавить(Метаданные.Роли.ИспользованиеУведомленийЭДО.Имя);
		
		НовыйПользователь = Справочники.Пользователи.СоздатьЭлемент();
		НовыйПользователь.Наименование = ОписаниеПользователяИБ.ПолноеИмя;
		НовыйПользователь.Служебный = Истина;
		НовыйПользователь.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
		НовыйПользователь.Записать();
		
	Исключение
		
		МетаданныеОбъекта = Метаданные.Справочники.Пользователи;
		ТекстОшибки = НСтр("ru = 'Не удалось создать служебного пользователя по причине:'")
			+ Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
			МетаданныеОбъекта,, ТекстОшибки);
		ТекстСообщения = НСтр("ru = 'При создании служебного пользователя для получения уведомлений от сервиса ЭДО произошла ошибка: %1'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
	КонецПопытки;
	
КонецПроцедуры

Функция ИмяСлужебногоПользователяОповещенийЭДО()
	
	Возврат "EDIEvents";
	
КонецФункции

Процедура ОповеститьВсехПользователейОНовыхДокументах()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Пользователи.ИдентификаторПользователяИБ КАК ИдентификаторПользователяИБ
	               |ИЗ
	               |	Справочник.Пользователи КАК Пользователи
	               |ГДЕ
	               |	Пользователи.ИдентификаторПользователяИБ <> &EDIEvents
	               |	И Пользователи.Ссылка <> &ПользовательНеУказан";
	Запрос.УстановитьПараметр("EDIEvents", Новый УникальныйИдентификатор("ecabae76-1a0d-4a5d-b8d3-065cd57c0459"));
	Запрос.УстановитьПараметр("ПользовательНеУказан", Пользователи.СсылкаНеуказанногоПользователя());
	
	ТаблицаВыборки = Запрос.Выполнить().Выгрузить();
	ОтправитьСообщенияОНовыхДокументах(ТаблицаВыборки.ВыгрузитьКолонку("ИдентификаторПользователяИБ"));
	
КонецПроцедуры

Процедура ОтправитьСообщенияОНовыхДокументах(ИдентификаторыПользователей)
	
	Для каждого ИдентификаторПользователя Из ИдентификаторыПользователей Цикл
		
		ТекстСообщения = НСтр("ru = 'Есть новые документы в сервисе.
							|Запустите синхронизацию для их получения'");
		Действия = Новый СписокЗначений;
		Действия.Добавить("СинхронизироватьЭДО", "Синхронизировать");
		ОтправитьСообщениеСистемыВзаимодействия(ИдентификаторПользователя, ТекстСообщения, Действия);
		
	КонецЦикла;
	
КонецПроцедуры

// Проверяет наличие новых электронных документов в сервисе ЭДО.
//
// Параметры:
//  ИдентификаторыУчетныхЗаписей - Массив из Строка
//
Процедура ПроверитьНаличиеНовыхДокументовВСервисеЭДО(ИдентификаторыУчетныхЗаписей = Неопределено)
	
	Если Не НастройкиЭДО.ИспользуетсяОбменЭлектроннымиДокументами() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не НастройкиБЭД.ИспользоватьЭлектронныеПодписи() Тогда
		Возврат;
	КонецЕсли;
	
	СпособОбмена = Перечисления.СпособыОбменаЭД.ЧерезСервис1СЭДО;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	УчетныеЗаписиЭДО.ИдентификаторЭДО КАК ИдентификаторОрганизации
	|ИЗ
	|	УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО";
	
	Отбор = СинхронизацияЭДО.НовыйОтборУчетныхЗаписей();
	Если ИдентификаторыУчетныхЗаписей <> Неопределено Тогда
		Отбор.УчетныеЗаписи = "&УчетныеЗаписи";
	КонецЕсли;
	Отбор.СпособОбмена = "&СпособОбмена";
	ЗапросУчетныхЗаписей = СинхронизацияЭДО.ЗапросУчетныхЗаписей("УчетныеЗаписиЭДО", Отбор);
	
	Запросы = Новый Массив;
	Запросы.Добавить(ЗапросУчетныхЗаписей);
	
	ИтоговыйЗапрос = ОбщегоНазначенияБЭД.СоединитьЗапросы(Запрос, Запросы);
	ИтоговыйЗапрос.УстановитьПараметр("СпособОбмена", СпособОбмена);
	ИтоговыйЗапрос.УстановитьПараметр("УчетныеЗаписи", ИдентификаторыУчетныхЗаписей);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = ИтоговыйЗапрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	ИдентификаторыЕстьЭДО = Новый Массив;
	ИдентификаторыНетЭДО = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		
		ИдентификаторОрганизации = Выборка.ИдентификаторОрганизации;
		
		ЕстьНовыеЭД = СервисЭДО.ЕстьНовыеДокументы(ИдентификаторОрганизации);
		
		Если ЕстьНовыеЭД Тогда
			ИдентификаторыЕстьЭДО.Добавить(ИдентификаторОрганизации);
		Иначе
			ИдентификаторыНетЭДО.Добавить(ИдентификаторОрганизации);
		КонецЕсли;
		
	КонецЦикла;
	
	ОбновитьИдентификаторыЭДО(ИдентификаторыЕстьЭДО);
	ОбновитьИдентификаторыЭДО(ИдентификаторыНетЭДО, Истина);
	
КонецПроцедуры

#Область СистемаВзаимодействия

Функция ИдентификаторПользователяСистемыВзаимодействия(ИдентификаторПользователяИБ) 
	
	Попытка
		Идентификатор = СистемаВзаимодействия.ПолучитьИдентификаторПользователя(ИдентификаторПользователяИБ);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Получение идентификатора пользователя системы взаимодействия'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Идентификатор = Неопределено;
	КонецПопытки;
	
	Возврат Идентификатор;
	
КонецФункции

Функция ИдентификаторБотаВСистемеВзаимодействия() 
	
	Бот = Пользователи.СвойстваПользователяИБ(ИмяСлужебногоПользователяОповещенийЭДО());
	ИдентификаторБота = ИдентификаторПользователяСистемыВзаимодействия(Бот.УникальныйИдентификатор);
	Если ИдентификаторБота = Неопределено Тогда
		Попытка
			ПользовательСистемыВзаимодействия = СистемаВзаимодействия.СоздатьПользователя(Бот.ПользовательИБ);
			ПользовательСистемыВзаимодействия.Картинка = БиблиотекаКартинок.ЭмблемаСервиса1СЭДО48;
			ПользовательСистемыВзаимодействия.Записать();
			ИдентификаторБота = ПользовательСистемыВзаимодействия.Идентификатор;
		Исключение
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Создание пользователя системы взаимодействия'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ИдентификаторБота = Неопределено;
		КонецПопытки;
	Иначе 
		ПользовательСистемыВзаимодействия = СистемаВзаимодействия.ПолучитьПользователя(ИдентификаторБота);
		Если ПользовательСистемыВзаимодействия.Картинка.Вид = ВидКартинки.Пустая Тогда
			ПользовательСистемыВзаимодействия.Картинка = БиблиотекаКартинок.ЭмблемаСервиса1СЭДО48;
			ПользовательСистемыВзаимодействия.Записать();
		КонецЕсли;
	КонецЕсли;
	
	Возврат ИдентификаторБота;
	
КонецФункции 

Функция ОбсуждениеПользователяСБотом(ИдентификаторПользователя)

	ПользовательСВ = ИдентификаторПользователяСистемыВзаимодействия(ИдентификаторПользователя);
	БотСВ = ИдентификаторБотаВСистемеВзаимодействия();
	
	Возврат ЛичноеОбсуждениеПользователей(ПользовательСВ, БотСВ);
	
КонецФункции

// Возвращает ссылку на личное обсуждение пользователей.
//
// Параметры:
//  ИдентификаторПользователяСВ1 - ИдентификаторПользователяСистемыВзаимодействия - Первый пользователь.
//  ИдентификаторПользователяСВ2 - ИдентификаторПользователяСистемыВзаимодействия - Второй пользователь.
// 
// Возвращаемое значение:
//  ОбсуждениеСистемыВзаимодействия - Личное обсуждение пользователей.
//
Функция ЛичноеОбсуждениеПользователей(ИдентификаторПользователяСВ1, ИдентификаторПользователяСВ2)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЛичноеОбсуждениеПользователей = СистемаВзаимодействия.СоздатьОбсуждение();
	ЛичноеОбсуждениеПользователей.Групповое = Ложь;
	ЛичноеОбсуждениеПользователей.Участники.Добавить(ИдентификаторПользователяСВ1);
	ЛичноеОбсуждениеПользователей.Участники.Добавить(ИдентификаторПользователяСВ2);
	ЛичноеОбсуждениеПользователей.Записать();
	
	Возврат ЛичноеОбсуждениеПользователей;
	
КонецФункции

Процедура УдалитьСтароеОбсуждение(ИдентификаторПользователя)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Ключ = КлючОбсужденияСистемыВзаимодействияЭДО(ИдентификаторПользователя);
	
	Если Не СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована() Тогда
		Возврат;
	КонецЕсли;
	
	Обсуждение = Неопределено;
	
	Попытка
		Обсуждение = СистемаВзаимодействия.ПолучитьОбсуждение(Ключ);
	Исключение
		ВидОперации = НСтр("ru = 'Поиск обсуждения ""ЭДО"" системы взаимодействия по ключу'");
		ЭлектронноеВзаимодействие.ОбработатьОшибку(
			ВидОперации, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Если Обсуждение <> Неопределено Тогда
		Если Обсуждение.Участники.Количество() Тогда
			Обсуждение.Участники.Очистить();
			Попытка
				Обсуждение.Записать();
			Исключение
				ВидОперации = НСтр("ru='Очистка участников обсуждения ЭДО'");
				ЭлектронноеВзаимодействие.ОбработатьОшибку(
					ВидОперации, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Возвращает ключ обсуждения системы взаимодействия, используемый подсистемой "ОбменСКонтрагентами" для оповещения о событиях.
//
// Параметры:
//  ИдентификаторПользователя - УникальныйИдентификатор - идентификатор пользователя информационной базы
// 
// Возвращаемое значение:
//  Строка
//
Функция КлючОбсужденияСистемыВзаимодействияЭДО(ИдентификаторПользователя)
	
	Возврат "ЕстьНовыеДокументыЭДО" + Строка(ИдентификаторПользователя);
	
КонецФункции

#КонецОбласти

#КонецОбласти


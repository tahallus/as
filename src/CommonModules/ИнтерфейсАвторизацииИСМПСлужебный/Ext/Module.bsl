﻿#Область СлужебныйПрограммныйИнтерфейс

Функция АктуальныеПараметрыКлючаСессии(ПараметрыЗапроса, ДанныеКлючаСессии, СрокДействия = Неопределено) Экспорт
	
	Если СрокДействия = Неопределено Тогда
		
		Таймаут      = 60;
		СрокДействия = ТекущаяДатаСеанса() + Таймаут;
		
	КонецЕсли;
	
	Если ПараметрыЗапроса.Организация <> Неопределено Тогда
		
		Если ЭтоПараметрыЗапросаСУЗ(ПараметрыЗапроса) Тогда
			
			ДанныеПоОрганизации = ДанныеКлючаСессии.Получить(ПараметрыЗапроса.Организация);
			
			Если ДанныеПоОрганизации = Неопределено Тогда
				Возврат Неопределено;
			КонецЕсли;
			
			ПараметрыКлючаСессии = ДанныеПоОрганизации.Получить(ПараметрыЗапроса.ПроизводственныйОбъект);
			Если ПараметрыКлючаСессии = Неопределено Тогда
				Возврат Неопределено;
			КонецЕсли;
			
			// Ключ сессии устарел
			Если ПараметрыКлючаСессии.ДействуетДо <= СрокДействия Тогда
				Возврат Неопределено;
			КонецЕсли;
		
		Иначе
			
			ПараметрыКлючаСессии = ДанныеКлючаСессии.Получить(ПараметрыЗапроса.Организация);
			
			Если ПараметрыКлючаСессии = Неопределено Тогда
				Возврат Неопределено;
			КонецЕсли;
			
			// Ключ сессии устарел
			Если ПараметрыКлючаСессии.ДействуетДо <= СрокДействия Тогда
				Возврат Неопределено;
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Для Каждого КлючИЗначение Из ДанныеКлючаСессии Цикл
			
			Если КлючИЗначение.Значение.ДействуетДо > СрокДействия Тогда
				
				ПараметрыКлючаСессии = КлючИЗначение.Значение;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ПараметрыКлючаСессии;
	
КонецФункции

// Выполняет попытку обновления ключа сессии на сервере
// (на сервере предприятия должны быть установлены сертификаты для подписания и пароль).
//
// Параметры:
// 	ПараметрыЗапроса - См. ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии
// 	ОбновлятьКлючСессииНаСервере - Булево - Признак необходимости обновления ключа сессии на сервере.
// Возвращаемое значение:
// 	Булево - Истина, если обновление ключа сессии выполнено успешно.
Функция ОбновитьКлючСессииНаСервере(ПараметрыЗапроса, ОбновлятьКлючСессииНаСервере = Истина) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СохраненныеДанныеКлючаСессии = ПолучитьСохраненныеДанныеКлючаСессии(ПараметрыЗапроса.ИмяПараметраСеанса);
	
	Если СохраненныеДанныеКлючаСессии <> Неопределено Тогда
		
		ПараметрыКлючаСессии = АктуальныеПараметрыКлючаСессии(
			ПараметрыЗапроса, СохраненныеДанныеКлючаСессии);
		
		Если ПараметрыКлючаСессии <> Неопределено Тогда
			
			УстановитьКлючСессии(
				ПараметрыЗапроса,
				ПараметрыКлючаСессии, Ложь);
			
			Возврат Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ОбновлятьКлючСессииНаСервере Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СертификатыДляПодписанияНаСервере = СертификатыДляПодписанияНаСервере();
	Если СертификатыДляПодписанияНаСервере = Неопределено
		Или СертификатыДляПодписанияНаСервере.Сертификаты.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	РезультатЗапроса = ИнтерфейсАвторизацииИСМПВызовСервера.ЗапроситьПараметрыАвторизации(ПараметрыЗапроса);
	Если РезультатЗапроса.ПараметрыАвторизации = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ПараметрыЗапроса.Организация = Неопределено Тогда
		СтрокаСертификата = СертификатыДляПодписанияНаСервере.Сертификаты[0];
	Иначе
		СтрокаСертификата = СертификатыДляПодписанияНаСервере.Сертификаты.Найти(ПараметрыЗапроса.Организация, "Организация");
	КонецЕсли;
	
	Если СтрокаСертификата <> Неопределено Тогда
		
		// Для авторизации требуется прикрепленная подпись
		ПараметрыCMS = ЭлектроннаяПодпись.ПараметрыCMS();
		ПараметрыCMS.Открепленная = Ложь;
		
		СертификатыДляПодписанияНаСервере.МенеджерКриптографии.ПарольДоступаКЗакрытомуКлючу = СтрокаСертификата.Пароль;
		РезультатПодписания = Подписать(
			РезультатЗапроса.ПараметрыАвторизации.Данные,
			ПараметрыCMS,
			СтрокаСертификата.СертификатКриптографии,
			СертификатыДляПодписанияНаСервере.МенеджерКриптографии);
		
	КонецЕсли;
	
	Если СтрокаСертификата = Неопределено
		Или Не РезультатПодписания.Успех Тогда
		
		Возврат Ложь;
		
	Иначе
		
		Возврат ЗапроситьУстановитьКлючСессии(
			ПараметрыЗапроса,
			РезультатЗапроса.ПараметрыАвторизации,
			РезультатПодписания.Подпись).КлючСессииУстановлен;
		
	КонецЕсли;
	
КонецФункции

// Запрашивает ключ сессии и установливает его в параметры сеанса.
// 
// Параметры:
// 	ПараметрыЗапроса - См. ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии
// 	ПараметрыАвторизации - См. ПараметрыАвторизации
// 	Подпись - Строка - Подпись.
// Возвращаемое значение:
// 	Булево - Ключ сессии успешно запрошен и установлен
Функция ЗапроситьУстановитьКлючСессии(ПараметрыЗапроса, ПараметрыАвторизации, Подпись) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("КлючСессииУстановлен", Ложь);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",          "");
	
	СвойстваПодписи = Новый Структура("Подпись", Подпись);
	
	ПараметрыЗапросаПоОрганизации = Новый Структура;
	ПараметрыЗапросаПоОрганизации.Вставить("ПараметрыЗапроса",     ПараметрыЗапроса);
	ПараметрыЗапросаПоОрганизации.Вставить("ПараметрыАвторизации", ПараметрыАвторизации);
	ПараметрыЗапросаПоОрганизации.Вставить("СвойстваПодписи",      СвойстваПодписи);
	
	РезультатЗапросаКлючаСессии = ИнтерфейсАвторизацииИСМПВызовСервера.ЗапроситьКлючСессии(ПараметрыЗапросаПоОрганизации);
	Если РезультатЗапросаКлючаСессии.ПараметрыКлючаСессии <> Неопределено Тогда
		
		УстановитьКлючСессии(
			ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса,
			РезультатЗапросаКлючаСессии.ПараметрыКлючаСессии);
		
		ВозвращаемоеЗначение.КлючСессииУстановлен = Истина;
		
		Возврат ВозвращаемоеЗначение;
		
	Иначе
		
		ВозвращаемоеЗначение.КлючСессииУстановлен = Ложь;
		ВозвращаемоеЗначение.ТекстОшибки          = РезультатЗапросаКлючаСессии.ТекстОшибки;
		
		Возврат ВозвращаемоеЗначение;
		
	КонецЕсли;
	
КонецФункции

Процедура УстановитьКлючСессии(ПараметрыЗапроса, ПараметрыКлючаСессии, ЗаписатьВРегистр = Истина) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ЗаписатьВРегистр Тогда
		
		НачатьТранзакцию();
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ДанныеКлючаСессииИСМП");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("ИмяПараметраСеанса", ПараметрыЗапроса.ИмяПараметраСеанса);
		Блокировка.Заблокировать();
		
		ДанныеКлючаСессии = ИнтерфейсАвторизацииИСМПСлужебный.ПолучитьСохраненныеДанныеКлючаСессии(ПараметрыЗапроса.ИмяПараметраСеанса);
		
	Иначе
		Попытка
			ДанныеКлючаСессии = ПараметрыСеанса[ПараметрыЗапроса.ИмяПараметраСеанса].Получить();
		Исключение
			ДанныеКлючаСессии = Неопределено;
		КонецПопытки;
	КонецЕсли;
	
	Если ДанныеКлючаСессии = Неопределено Тогда
		ДанныеКлючаСессии = Новый Соответствие();
	КонецЕсли;
	
	Если ЭтоПараметрыЗапросаСУЗ(ПараметрыЗапроса) Тогда
		
		ДанныеПоОрганизации = ДанныеКлючаСессии.Получить(ПараметрыЗапроса.Организация);
		
		Если ДанныеПоОрганизации = Неопределено
			Или ТипЗнч(ДанныеПоОрганизации) = Тип("Структура") Тогда
			ДанныеПоОрганизации = Новый Соответствие;
			ДанныеКлючаСессии.Вставить(ПараметрыЗапроса.Организация, ДанныеПоОрганизации);
		КонецЕсли;
		
		Если ПараметрыКлючаСессии.КлючСессии  = ""
			Или ПараметрыКлючаСессии.ДействуетДо = Дата(1,1,1) Тогда
			ДанныеПоОрганизации.Удалить(ПараметрыЗапроса.ПроизводственныйОбъект);
		Иначе
			ДанныеПоОрганизации.Вставить(ПараметрыЗапроса.ПроизводственныйОбъект, ПараметрыКлючаСессии);
		КонецЕсли;
		
	Иначе
		
		Если ПараметрыКлючаСессии.КлючСессии  = ""
			Или ПараметрыКлючаСессии.ДействуетДо = Дата(1,1,1) Тогда
			ДанныеКлючаСессии.Удалить(ПараметрыЗапроса.Организация);
		Иначе
			ДанныеКлючаСессии.Вставить(ПараметрыЗапроса.Организация, ПараметрыКлючаСессии);
		КонецЕсли;
		
	КонецЕсли;
	
	СохраняемыеДанные = Новый ХранилищеЗначения(ДанныеКлючаСессии);
	
	Если ЗаписатьВРегистр Тогда
		
		НаборЗаписей = РегистрыСведений.ДанныеКлючаСессииИСМП.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ИмяПараметраСеанса.Установить(ПараметрыЗапроса.ИмяПараметраСеанса, Истина);
		
		ЗаписьНабора = НаборЗаписей.Добавить();
		ЗаписьНабора.ИмяПараметраСеанса = ПараметрыЗапроса.ИмяПараметраСеанса;
		ЗаписьНабора.Данные             = СохраняемыеДанные;
		
		Попытка
			НаборЗаписей.Записать(Истина);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЕсли;
	
	ПараметрыСеанса[ПараметрыЗапроса.ИмяПараметраСеанса] = СохраняемыеДанные;
	
КонецПроцедуры

// Возвращает ключ сессии для обмена с МОТП.
// 
// Параметры:
// 	ПараметрыЗапроса - См. ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии
// 	СрокДействия - Дата, Неопределено - Срок действия ключа сессии
// 	ОбновлятьКлючСессииНаСервере - Булево - Признак необходимости обновления ключа сессии на сервере
// Возвращаемое значение:
// 	Строка, Неопределено - Действующий ключ сессии для организации.
Функция ПроверитьОбновитьКлючСессии(ПараметрыЗапроса, Знач СрокДействия = Неопределено, ОбновлятьКлючСессииНаСервере = Истина) Экспорт
	
	КлючСессии = ИнтерфейсАвторизацииИСМПВызовСервера.ТекущийКлючСессии(ПараметрыЗапроса, СрокДействия);
	
	ТребуетсяОбновлениеКлючаСессии = (КлючСессии = Неопределено);
	
	Если ТребуетсяОбновлениеКлючаСессии
		И ОбновитьКлючСессииНаСервере(ПараметрыЗапроса, ОбновлятьКлючСессииНаСервере) Тогда
		КлючСессии = ИнтерфейсАвторизацииИСМПВызовСервера.ТекущийКлючСессии(ПараметрыЗапроса);
	КонецЕсли;
	
	Возврат КлючСессии;
	
КонецФункции

// Возвращает сохраненные данные ключа сессии.
// 
// Параметры:
//  ИмяПараметраСеанса - Строка - имя параметра сеанса для получения данных ключа сессии.
// Возвращаемое значение:
//  Неопределено, Соответствие - данные ключа сессии:
//  * Ключ - ОпределяемыйТип.Организация - Организация, для которой используется ключ сессии.
//  * Значение - Соответствие, Структура - см.ПараметрыКлючаСессии.
Функция ПолучитьСохраненныеДанныеКлючаСессии(ИмяПараметраСеанса) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИмяПараметраСеанса", ИмяПараметраСеанса);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Данные
	|ИЗ
	|	РегистрСведений.ДанныеКлючаСессииИСМП
	|ГДЕ
	|	ИмяПараметраСеанса = &ИмяПараметраСеанса";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Данные.Получить();
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Возвращает структуру данных запроса авторизации
// 
// Параметры:
// Возвращаемое значение:
// 	Структура - Параметры авторизации:
// * Идентификатор - Строка - Идентификатор запроса
// * Данные        - Строка - Данные для подписания
Функция ПараметрыАвторизации() Экспорт
	
	ПараметрыАвторизации = Новый Структура;
	ПараметрыАвторизации.Вставить("Идентификатор");
	ПараметрыАвторизации.Вставить("Данные");
	
	Возврат ПараметрыАвторизации;
	
КонецФункции

// Возвращает структуру данных ключа сессии обмена с МОТП.
// 
// Параметры:
// Возвращаемое значение:
// 	Структура - Параметры ключа сессии:
// * КлючСессии  - Строка - Ключ сессии.
// * ДействуетДо - Дата   - Дата и время окончания действия ключа сессии.
Функция ПараметрыКлючаСессии() Экспорт
	
	ПараметрыКлючаСессии = Новый Структура;
	ПараметрыКлючаСессии.Вставить("КлючСессии",  "");
	ПараметрыКлючаСессии.Вставить("ДействуетДо", '00010101');
	
	Возврат ПараметрыКлючаСессии;
	
КонецФункции

#Область ЭлектроннаяПодпись

// Получает сертификаты организаций, для предназначены для подписания на сервере.
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * Сертификаты - ТаблицаЗначений - содержит сертификат и пароль.
//   * МенеджерКриптографии - МенеджерКриптографии - менеджер криптографии.
//
Функция СертификатыДляПодписанияНаСервере() Экспорт
	
	НастройкиОбмена = ИнтеграцияИС.НастройкиОбменаГосИС();
	
	Если НастройкиОбмена = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Т.Организация КАК Организация,
	|	Т.Сертификат  КАК Сертификат
	|ПОМЕСТИТЬ ТаблицаДанных
	|ИЗ
	|	&Таблица КАК Т
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДанных.Организация          КАК Организация,
	|	ТаблицаДанных.Сертификат           КАК Сертификат,
	|	ТаблицаДанных.Сертификат.Отпечаток КАК Отпечаток,
	|	ТаблицаДанных.Сертификат.Программа КАК Программа
	|ИЗ
	|	ТаблицаДанных КАК ТаблицаДанных
	|");
	
	Запрос.УстановитьПараметр("Таблица", НастройкиОбмена);
	
	ДанныеСертификатовИзНастроекОбмена = Запрос.Выполнить().Выгрузить();
	
	СертификатыОрганизацийДляОбменаНаСервере = Новый ТаблицаЗначений();
	СертификатыОрганизацийДляОбменаНаСервере.Колонки.Добавить("Организация");
	СертификатыОрганизацийДляОбменаНаСервере.Колонки.Добавить("Сертификат");
	СертификатыОрганизацийДляОбменаНаСервере.Колонки.Добавить("Отпечаток");
	СертификатыОрганизацийДляОбменаНаСервере.Колонки.Добавить("СертификатКриптографии");
	СертификатыОрганизацийДляОбменаНаСервере.Колонки.Добавить("Пароль");
	
	Программа = Неопределено;
	Для Каждого ДанныеСертификата Из ДанныеСертификатовИзНастроекОбмена Цикл
		
		Пароль = ИнтеграцияИС.ПарольКСертификату(ДанныеСертификата.Сертификат);
		
		СертификатКриптографии = ЭлектроннаяПодписьСлужебный.ПолучитьСертификатПоОтпечатку(ДанныеСертификата.Отпечаток, Ложь, Ложь);
		Если СертификатКриптографии = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаТЧ = СертификатыОрганизацийДляОбменаНаСервере.Добавить();
		СтрокаТЧ.Организация            = ДанныеСертификата.Организация;
		СтрокаТЧ.Сертификат             = ДанныеСертификата.Сертификат;
		СтрокаТЧ.Отпечаток              = ДанныеСертификата.Отпечаток;
		СтрокаТЧ.СертификатКриптографии = СертификатКриптографии;
		Если Пароль <> Неопределено Тогда
			СтрокаТЧ.Пароль = Пароль;
		Иначе
			СтрокаТЧ.Пароль = "";
		КонецЕсли;
		
		Программа = ДанныеСертификата.Программа;
		
	КонецЦикла;
	
	Если СертификатыОрганизацийДляОбменаНаСервере.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МенеджерКриптографии = ЭлектроннаяПодпись.МенеджерКриптографии("Подписание", Ложь,, Программа);
	
	СертификатыДляПодписанияНаСервере = Новый Структура;
	СертификатыДляПодписанияНаСервере.Вставить("Сертификаты",          СертификатыОрганизацийДляОбменаНаСервере);
	СертификатыДляПодписанияНаСервере.Вставить("МенеджерКриптографии", МенеджерКриптографии);
	
	Возврат СертификатыДляПодписанияНаСервере;
	
КонецФункции

// Подписать сообщение XML
//
// Параметры:
//  ДанныеДляПодписания - Строка - Подписываемое сообщение XML
//  ПараметрыCMS - См. ЭлектроннаяПодпись.ПараметрыCMS
//  СертификатКриптографии - СертификатКриптографии - Сертификат криптографии
//  МенеджерКриптографии - МенеджерКриптографии - Менеджер криптографии.
// 
// Возвращаемое значение:
//  Структура - со свойствами:
//   * Успех       - Булево - Признак успешности подписания.
//   * КонвертSOAP - Строка - Конверт SOAP.
//   * ТекстОшибки - Строка - Текст ошибки.
//
Функция Подписать(ДанныеДляПодписания, ПараметрыCMS, СертификатКриптографии, МенеджерКриптографии) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Успех");
	ВозвращаемоеЗначение.Вставить("Подпись");
	ВозвращаемоеЗначение.Вставить("ТекстОшибки");
	
	Попытка
		
		Подпись = ЭлектроннаяПодписьСлужебный.ПодписатьCMS(
			ДанныеДляПодписания,
			ПараметрыCMS,
			СертификатКриптографии, МенеджерКриптографии);
		
		ВозвращаемоеЗначение.Успех   = Истина;
		ВозвращаемоеЗначение.Подпись = Подпись;
		
	Исключение
		
		ВозвращаемоеЗначение.Успех       = Ложь;
		ВозвращаемоеЗначение.ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
	КонецПопытки;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

Функция ЭтоПараметрыЗапросаСУЗ(ПараметрыЗапроса) Экспорт
	Возврат ПараметрыЗапроса.ИмяПараметраСеанса = Метаданные.ПараметрыСеанса.ДанныеКлючаСессииСУЗ.Имя;
КонецФункции

#КонецОбласти
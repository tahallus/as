﻿#Область JSON

// Получить из текста JSON структуру.
// 
// Параметры:
// 	ТекстJSON                    - Строка - Текст JSON.
// 	ПреобразовыватьВСоответствие - Булево - Признак преобразования в соответствие.
// Возвращаемое значение:
// 	Структура, Неопределено - Результат преобразования JSON.
Функция ТекстJSONВОбъект(ТекстJSON, ПреобразовыватьВСоответствие = Ложь) Экспорт
	
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(ТекстJSON);
	
	Попытка
		РезультатРазбора = ПрочитатьJSON(Чтение, ПреобразовыватьВСоответствие);
	Исключение
		РезультатРазбора = Неопределено;
	КонецПопытки;
	
	Возврат РезультатРазбора;
	
КонецФункции

// Формирует из структуры текст JSON
// 
// Параметры:
// 	Структура - Структура - Произвольная структура данных
// Возвращаемое значение:
// 	Строка - Текст JSON
Функция ОбъектВТекстJSON(Структура, УдалитьПробелыИПереносыСтрок = Ложь) Экспорт
	
	Если УдалитьПробелыИПереносыСтрок Тогда
		ПараметрыЗаписиJSON = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет, "");
	Иначе
		ПараметрыЗаписиJSON = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Авто, "  ");
	КонецЕсли;
	
	ЗаписьJSON = Новый ЗаписьJSON();
	ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписиJSON);
	
	ЗаписатьJSON(ЗаписьJSON, Структура);
	
	ТекстJSON = ЗаписьJSON.Закрыть();
	
	Возврат ТекстJSON;
	
КонецФункции

#КонецОбласти

#Область HTTPЗапросы

// Структура результата HTTP запроса
// 
// Параметры:
// Возвращаемое значение:
// 	Структура - Результат HTTP-запроса:
// * КодСостояния - Число        - Код состояния HTTP
// * Заголовки    - Соответствие - Заголовки HTTP ответа
// * ТекстОтвета  - Строка       - Текст ответа
// * ТекстОшибки  - Строка       - Текст ошибки
Функция РезультатHTTPЗапроса() Экспорт
	
	РезультатHTTPЗапроса = Новый Структура;
	РезультатHTTPЗапроса.Вставить("КодСостояния");
	РезультатHTTPЗапроса.Вставить("Заголовки");
	РезультатHTTPЗапроса.Вставить("ТекстОтвета");
	РезультатHTTPЗапроса.Вставить("ТекстОшибки");
	
	Возврат РезультатHTTPЗапроса;
	
КонецФункции

// Инициализирует структуру результата обработки HTTP-запроса после получения ответа.
// 
// Параметры:
// 	ТекстВходящегоСообщенияJSON - Строка - Текст входящего сообщения.
// 	КодСостояния                - Число  - Код состояния.
// 
// Возвращаемое значение:
// Структура - Структура со свойствами:
//   ЗапросОтправлен             - Булево - признак того, что сообщение отправлено.
//   ОтветПолучен                - Булево - признак того, что сообщение обработано сервером.
//   КодСостояния                - Число  - Код состояния HTTP-запроса.
//   ТекстОшибки                 - Строка - текст ошибки, если таковая возникла.
//   ТекстВходящегоСообщенияJSON - Строка - текст ответа, на отправленное сообщение.
//
Функция HTTPОтветПолучен(ТекстВходящегоСообщенияJSON, КодСостояния = 200, КакФайл = Ложь, ДополнительныеПараметры = Неопределено)
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
	ВозвращаемоеЗначение.Вставить("ЗапросОтправлен",         Истина);
	ВозвращаемоеЗначение.Вставить("ОтветПолучен",            Истина);
	
	ВозвращаемоеЗначение.Вставить("КодСостояния", КодСостояния);
	ВозвращаемоеЗначение.Вставить("Объект",       Неопределено);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",  "");
	
	Если КакФайл Тогда
		ВозвращаемоеЗначение.Вставить("ИмяФайла", ТекстВходящегоСообщенияJSON);
	Иначе
		Попытка
			ВозвращаемоеЗначение.Объект = ТекстJSONВОбъект(ТекстВходящегоСообщенияJSON, Ложь);
		Исключение
			ВозвращаемоеЗначение.Объект = ТекстJSONВОбъект(ТекстВходящегоСообщенияJSON, Истина);
		КонецПопытки;
		
		ВозвращаемоеЗначение.Вставить("ТекстВходящегоСообщения", ТекстВходящегоСообщенияJSON);
		Если ВозвращаемоеЗначение.Объект <> Неопределено Тогда
			ВозвращаемоеЗначение.Вставить("ТекстВходящегоСообщенияJSON", ОбъектВТекстJSON(ВозвращаемоеЗначение.Объект));
		Иначе
			ВозвращаемоеЗначение.Вставить("ТекстВходящегоСообщенияJSON", ТекстВходящегоСообщенияJSON);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Инициализирует структуру результата обработки HTTP-запроса после отправки сообщения, но до получения ответа.
// 
// Возвращаемое значение:
// Структура:
//   ЗапросОтправлен             - Булево - признак того, что сообщение отправлено.
//   ОтветПолучен                - Булево - признак того, что сообщение получено.
//   КодСостояния                - Число  - Код состояния HTTP-запроса.
//   ТекстОшибки                 - Строка - текст ошибки, если таковая возникла.
//   ТекстВходящегоСообщенияJSON - Строка - текст ответа, на отправленное сообщение.
//
Функция HTTPОтветНеПолучен(Ошибка, ЗапросОтправлен, КодСостояния = Неопределено, КакФайл = Ложь, ДополнительныеПараметры = Неопределено)
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
	ВозвращаемоеЗначение.Вставить("ЗапросОтправлен",         ЗапросОтправлен);
	ВозвращаемоеЗначение.Вставить("ОтветПолучен",            Ложь);
	
	ВозвращаемоеЗначение.Вставить("КодСостояния", КодСостояния);
	ВозвращаемоеЗначение.Вставить("Объект",       Неопределено);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",  Строка(Ошибка));
	
	Если КакФайл Тогда
		ВозвращаемоеЗначение.Вставить("ИмяФайла", "");
	Иначе
		ВозвращаемоеЗначение.Вставить("ТекстВходящегоСообщения",     "");
		ВозвращаемоеЗначение.Вставить("ТекстВходящегоСообщенияJSON", "");
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Обработать результат отправки HTTP-запроса к сервису ИС МОТП.
// 
// Параметры:
//  РезультатЗапроса - (См. РезультатЗапроса) - Результат запроса.
// Возвращаемое значение:
// Структура - Результат отправки HTTP-запроса:
//  * ЗапросОтправлен             - Булево - признак того, что сообщение отправлено.
//  * ОтветПолучен                - Булево - признак того, что сообщение получено.
//  * КодСостояния                - Число  - Код состояния HTTP-запроса.
//  * ТекстОшибки                 - Строка - текст ошибки, если таковая возникла.
//  * ТекстВходящегоСообщенияJSON - Строка - текст ответа, на отправленное сообщение.
Функция ОбработатьРезультатОтправкиHTTPЗапросаКакJSON(РезультатЗапроса) Экспорт
	
	ВозвращаемоеЗначение = Неопределено;
	
	РезультатОтправкиHTTPЗапроса = ИнтерфейсМОТПСлужебный.РезультатHTTPЗапроса();
	РезультатОтправкиHTTPЗапроса.ТекстОшибки = РезультатЗапроса.ТекстОшибки;
	Если РезультатЗапроса.HTTPОтвет <> Неопределено Тогда
		РезультатОтправкиHTTPЗапроса.КодСостояния = РезультатЗапроса.HTTPОтвет.КодСостояния;
		РезультатОтправкиHTTPЗапроса.Заголовки    = РезультатЗапроса.HTTPОтвет.Заголовки;
		Если ТипЗнч(РезультатЗапроса.HTTPОтвет) = Тип("Структура") Тогда
			РезультатОтправкиHTTPЗапроса.ТекстОтвета = РезультатЗапроса.HTTPОтвет.Тело;
		Иначе
			РезультатОтправкиHTTPЗапроса.ТекстОтвета = РезультатЗапроса.HTTPОтвет.ПолучитьТелоКакСтроку();
		КонецЕсли;
	КонецЕсли;
	
	КодСостояния = РезультатОтправкиHTTPЗапроса.КодСостояния;
	ТекстОтвета  = РезультатОтправкиHTTPЗапроса.ТекстОтвета;
	
	Если ЗначениеЗаполнено(ТекстОтвета) Тогда
		
		ВозвращаемоеЗначение = HTTPОтветПолучен(ТекстОтвета, КодСостояния, Ложь, РезультатЗапроса);
		
	Иначе
		
		Если Не ЗначениеЗаполнено(КодСостояния) Тогда
			ТекстСообщенияXMLОтправлен = Ложь;
			ЗаголовокОшибки = НСтр("ru = 'HTTP-запрос не отправлен.'");
		Иначе
			ТекстСообщенияXMLОтправлен = Истина;
			ЗаголовокОшибки = СтрШаблон(НСтр("ru = 'Код состояния HTTP: %1.'"), КодСостояния);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(РезультатОтправкиHTTPЗапроса.ТекстОшибки) Тогда
			ТекстОшибки = ЗаголовокОшибки + Символы.ПС + РезультатОтправкиHTTPЗапроса.ТекстОшибки;
		Иначе
			ТекстОшибки = ЗаголовокОшибки;
		КонецЕсли;
		
		ВозвращаемоеЗначение = HTTPОтветНеПолучен(
			ТекстОшибки,
			ТекстСообщенияXMLОтправлен,
			КодСостояния,
			Ложь, РезультатЗапроса);
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Обработать результат отправки HTTP-запроса к сервису ИС МОТП.
// 
// Параметры:
//  РезультатЗапроса - (См. РезультатЗапроса) - Результат запроса.
// Возвращаемое значение:
// Структура - Результат отправки HTTP-запроса:
//  * ЗапросОтправлен - Булево - признак того, что сообщение отправлено.
//  * ОтветПолучен    - Булево - признак того, что сообщение получено.
//  * КодСостояния    - Число  - Код состояния HTTP-запроса.
//  * ТекстОшибки     - Строка - текст ошибки, если таковая возникла.
//  * ИмяФайла        - Строка - ИмяФайла.
Функция ОбработатьРезультатОтправкиHTTPЗапросаКакФайл(РезультатЗапроса) Экспорт
	
	ВозвращаемоеЗначение = Неопределено;
	
	РезультатОтправкиHTTPЗапроса = ИнтерфейсМОТПСлужебный.РезультатHTTPЗапроса();
	РезультатОтправкиHTTPЗапроса.ТекстОшибки = РезультатЗапроса.ТекстОшибки;
	Если РезультатЗапроса.HTTPОтвет <> Неопределено Тогда
		РезультатОтправкиHTTPЗапроса.КодСостояния = РезультатЗапроса.HTTPОтвет.КодСостояния;
		РезультатОтправкиHTTPЗапроса.Заголовки    = РезультатЗапроса.HTTPОтвет.Заголовки;
		РезультатОтправкиHTTPЗапроса.ТекстОтвета  = РезультатЗапроса.HTTPОтвет.ПолучитьИмяФайлаТела();
	КонецЕсли;
	
	КодСостояния = РезультатОтправкиHTTPЗапроса.КодСостояния;
	ТекстОтвета  = РезультатОтправкиHTTPЗапроса.ТекстОтвета;
	
	Если ЗначениеЗаполнено(ТекстОтвета) Тогда
		
		ВозвращаемоеЗначение = HTTPОтветПолучен(ТекстОтвета, КодСостояния, Истина, РезультатЗапроса);
		
	Иначе
		
		Если Не ЗначениеЗаполнено(КодСостояния) Тогда
			ТекстСообщенияXMLОтправлен = Ложь;
			ЗаголовокОшибки = НСтр("ru = 'HTTP-запрос не отправлен.'");
		Иначе
			ТекстСообщенияXMLОтправлен = Истина;
			ЗаголовокОшибки = СтрШаблон(НСтр("ru = 'Код состояния HTTP: %1.'"), КодСостояния);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(РезультатОтправкиHTTPЗапроса.ТекстОшибки) Тогда
			ТекстОшибки = ЗаголовокОшибки + Символы.ПС + РезультатОтправкиHTTPЗапроса.ТекстОшибки;
		Иначе
			ТекстОшибки = ЗаголовокОшибки;
		КонецЕсли;
		
		ВозвращаемоеЗначение = HTTPОтветНеПолучен(
			ТекстОшибки,
			ТекстСообщенияXMLОтправлен,
			КодСостояния,
			Истина, РезультатЗапроса);
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

#Область Прочее

// Сформировать текст ошибки по результату отправки запроса.
//
// Параметры:
//  Заголовок - Строка - Заголовок ошибки, например: Параметры авторизации не получены из ИС МОТП.
//  РезультатОтправкиЗапроса - Структура - Результат отправки HTTP-запроса:
//  * ЗапросОтправлен             - Булево - признак того, что сообщение отправлено.
//  * ОтветПолучен                - Булево - признак того, что сообщение получено.
//  * КодСостояния                - Число  - Код состояния HTTP-запроса.
//  * ТекстОшибки                 - Строка - текст ошибки, если таковая возникла.
//  * ТекстВходящегоСообщенияJSON - Строка - текст ответа, на отправленное сообщение.
// Возвращаемое значение:
//  Строка - Текст ошибки.
Функция ТекстОшибкиПоРезультатуОтправкиЗапроса(URLЗапроса, РезультатОтправкиЗапроса) Экспорт
	
	Если РезультатОтправкиЗапроса.ОтветПолучен Тогда

		ТекстОшибки = СтрШаблон(
			НСтр("ru='При выполнении запроса %1 возникла ошибка.
				     |Код состояния HTTP: %2.
				     |Текст ошибки: %3.'"),
			URLЗапроса,
			РезультатОтправкиЗапроса.КодСостояния,
			ПредставлениеОшибкиИзJSON(РезультатОтправкиЗапроса.ТекстВходящегоСообщенияJSON));
			
	Иначе
		
		ТекстОшибки = СтрШаблон(
			НСтр("ru='При отправке запроса %1 возникла ошибка.
				     |Текст ошибки: %2.'"),
			URLЗапроса,
			РезультатОтправкиЗапроса.ТекстОшибки);

	КонецЕсли;
	
	Возврат ТекстОшибки;

КонецФункции

// Конвертирует входящий текст JSON содержащий globalErrors в представление ошибки.
// 
// Параметры:
// 	ТекстВходящегоСообщенияJSON - Строка - Текст сообщения JSON.
// Возвращаемое значение:
// 	Строка - Представление ошибки.
Функция ПредставлениеОшибкиИзJSON(ТекстВходящегоСообщенияJSON)
	
	ДанныеJSON = ТекстJSONВОбъект(ТекстВходящегоСообщенияJSON);
	
	Если ДанныеJSON <> Неопределено
		И ТипЗнч(ДанныеJSON) = Тип("Структура")
		И ДанныеJSON.Свойство("globalErrors")
		И ТипЗнч(ДанныеJSON.globalErrors) = Тип("Массив") Тогда
		
		ТекстыОшибок = Новый Массив;
		Для Каждого СтрокаОшибки Из ДанныеJSON.globalErrors Цикл
			
			Если Не ТипЗнч(СтрокаОшибки) = Тип("Строка") Тогда
				Возврат ТекстВходящегоСообщенияJSON;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаОшибки) Тогда
				ТекстыОшибок.Добавить(ТекстПредставленияОшибки(СтрокаОшибки));
			КонецЕсли;
			
			Если ДанныеJSON.Свойство("fieldErrors") И ТипЗнч(ДанныеJSON.fieldErrors) = Тип("Массив") Тогда
				
				Для Каждого СтрокаОшибкиПоля Из ДанныеJSON.fieldErrors Цикл
					
					ИмяПоля     = Неопределено;
					ТекстОшибки = Неопределено;
					СтрокаОшибкиПоля.Свойство("fieldName",  ИмяПоля);
					СтрокаОшибкиПоля.Свойство("fieldError", ТекстОшибки);
					
					ПредставлениеОшибки = СокрЛП(СтрШаблон("%1: %2", ИмяПоля, ТекстОшибки));
					Если ЗначениеЗаполнено(ИмяПоля) Или ЗначениеЗаполнено(ТекстОшибки) Тогда
						ТекстыОшибок.Добавить(ПредставлениеОшибки);
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Возврат СтрСоединить(ТекстыОшибок, Символы.ПС);
		
	ИначеЕсли ДанныеJSON <> Неопределено
		И ТипЗнч(ДанныеJSON) = Тип("Массив") Тогда
		
		ТекстыОшибок = Новый Массив;
		Для Каждого СтрокаОшибки Из ДанныеJSON Цикл
			
			Если Не ТипЗнч(СтрокаОшибки) = Тип("Структура")
				Или Не СтрокаОшибки.Свойство("cisInfo")
				Или Не СтрокаОшибки.Свойство("errorMessage") Тогда
				Возврат ТекстВходящегоСообщенияJSON;
			КонецЕсли;
			
			ТекстыОшибок.Добавить(ТекстПредставленияОшибки(СтрокаОшибки.errorMessage));
			
		КонецЦикла;
		
		Возврат СтрСоединить(ТекстыОшибок, Символы.ПС);
		
	Иначе
		Возврат ТекстВходящегоСообщенияJSON;
	КонецЕсли;
	
КонецФункции

// Возвращает найденое значение во внутреннем соответствии текстов ошибок.
// Если значение в соответствии не найдено, то возвращается исходное значение.
// 
// Параметры:
// 	ИсходноеСообщение - Строка - Исходный текст.
// Возвращаемое значение:
// 	Строка - Найденое значение или сходнное.
Функция ТекстПредставленияОшибки(ИсходноеСообщение)
	
	ЗначениеПоиска = СокрЛП(НРег(ИсходноеСообщение));
	
	ТекстыОшибок = Новый Соответствие();
	
	ТекстыОшибок.Вставить(
		НРег("Not enough balance"),
		НСтр("ru = 'Недостаточно средств на балансе для получения кодов маркировки из СУЗ'"));
	
	ВозвращаемоеЗначение = ТекстыОшибок.Получить(ЗначениеПоиска);
	
	Если ВозвращаемоеЗначение = Неопределено Тогда
		ВозвращаемоеЗначение = ИсходноеСообщение;
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Процедура ПривестиЗначениеМРЦ(СтрокаДанных)
	
	Если ТипЗнч(СтрокаДанных.МРЦ) = Тип("Число") Тогда
		СтрокаДанных.МРЦ = СтрокаДанных.МРЦ / 100;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает структуру данных кода маркировки.
// Параметры:
// 	ЭлементДанных - Соответствие, Неопределено - Данные ГИС МТ
// 	ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС, Неопределено - Вид продукции.
// Возвращаемое значение:
// 	Структура - Параметры статуса кода маркировки:
// * Статус       - ПеречислениеСсылка.СтатусыКодовМаркировкиМОТП - Статус кода маркировки.
// * ИННВладельца - Строка                                        - ИНН владельца кода маркировки.
Функция ПараметрыКодаМаркировки(ЭлементДанных = Неопределено, ВидПродукции = Неопределено, НастройкиРазбора = Неопределено) Экспорт
	
	ПараметрыКодаМаркировки = Новый Структура;
	ПараметрыКодаМаркировки.Вставить("РезультатРазбора");
	
	ПараметрыКодаМаркировки.Вставить("Статус");
	ПараметрыКодаМаркировки.Вставить("ОсобоеСостояние");
	
	ПараметрыКодаМаркировки.Вставить("ИННВладельца");
	ПараметрыКодаМаркировки.Вставить("НаименованиеВладельца");
	ПараметрыКодаМаркировки.Вставить("НаименованиеПроизводителя");
	ПараметрыКодаМаркировки.Вставить("ИННПроизводителя");
	ПараметрыКодаМаркировки.Вставить("GTIN");
	ПараметрыКодаМаркировки.Вставить("ПредставлениеНоменклатуры");
	
	ПараметрыКодаМаркировки.Вставить("ИдентификаторДокумента");
	
	ПараметрыКодаМаркировки.Вставить("ДатаЭмиссии",      '00010101');
	ПараметрыКодаМаркировки.Вставить("ДатаПроизводства", '00010101');
	ПараметрыКодаМаркировки.Вставить("ДатаВводаВОборот", '00010101');
	ПараметрыКодаМаркировки.Вставить("ДатаСписания",     '00010101');
	ПараметрыКодаМаркировки.Вставить("ГоденДо",          '00010101');
	
	ПараметрыКодаМаркировки.Вставить("РодительскаяУпаковка");
	ПараметрыКодаМаркировки.Вставить("ВложенныеУпаковки");
	ПараметрыКодаМаркировки.Вставить("ВидУпаковки");
	ПараметрыКодаМаркировки.Вставить("ВидПродукции");
	ПараметрыКодаМаркировки.Вставить("СпособВводаВОборот");
	
	ПараметрыКодаМаркировки.Вставить("МРЦ");
	ПараметрыКодаМаркировки.Вставить("ДатаПроизводства");
	
	Если ЭлементДанных = Неопределено Тогда
		Возврат ПараметрыКодаМаркировки;
	КонецЕсли;
	
	ТипЭлементаДанных = ТипЗнч(ЭлементДанных);
	Если ТипЭлементаДанных = Тип("Соответствие") Тогда
		ИсточникДанных = ЭлементДанных;
	ИначеЕсли ТипЭлементаДанных = Тип("КлючИЗначение") Тогда	
		ИсточникДанных = ЭлементДанных.Значение;
	КонецЕсли;
	
	Значение = ИсточникДанных["productGroup"];
	Если Значение <> Неопределено Тогда
		ПараметрыКодаМаркировки.ВидПродукции = ИнтерфейсИСМПСлужебный.ТоварнаяГруппа(Значение, ВидПродукции);
	КонецЕсли;
	
	ВидПродукцииДляРазбораКода = ВидПродукции;
	Если ЗначениеЗаполнено(ПараметрыКодаМаркировки.ВидПродукции) Тогда
		ВидПродукцииДляРазбораКода = ПараметрыКодаМаркировки.ВидПродукции;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВидПродукцииДляРазбораКода) Тогда
		ВызватьИсключение НСтр("ru = 'Вид продукции определить не удалось'");
	КонецЕсли;
	
	Если ИнтеграцияИСКлиентСервер.ЭтоПродукцияМОТП(ВидПродукцииДляРазбораКода) Тогда
		ПараметрыКодаМаркировки.Статус = СтатусКодаМаркировки(ИсточникДанных["status"]);
		Если ЗначениеЗаполнено(ИсточникДанных["statusEx"]) Тогда
			ПараметрыКодаМаркировки.ОсобоеСостояние = СтатусКодаМаркировки(ИсточникДанных["statusEx"]);
		КонецЕсли;
	Иначе
		ПараметрыКодаМаркировки.Статус          = ИнтерфейсИСМПСлужебный.СтатусКодаМаркировки(ИсточникДанных["status"]);
		Если ЗначениеЗаполнено(ИсточникДанных["statusEx"]) Тогда
			ПараметрыКодаМаркировки.ОсобоеСостояние = ИнтерфейсИСМПСлужебный.СтатусКодаМаркировки(ИсточникДанных["statusEx"]);
		КонецЕсли;
	КонецЕсли;
	
	Значение = ИсточникДанных["packageType"];
	Если Значение <> Неопределено Тогда
		ПараметрыКодаМаркировки.ВидУпаковки = ИнтерфейсИСМПСлужебный.ВидУпаковки(Значение, ВидПродукцииДляРазбораКода);
	КонецЕсли;
	
	Значение = ИсточникДанных["ownerInn"];
	Если Значение <> Неопределено Тогда
		ПараметрыКодаМаркировки.ИННВладельца = Значение;
	КонецЕсли;
	
	Значение = ИсточникДанных["gtin"];
	Если Значение <> Неопределено Тогда
		ПараметрыКодаМаркировки.GTIN = Значение;
	КонецЕсли;
	
	Значение = ИсточникДанных["lastDocId"];
	Если Значение <> Неопределено Тогда
		ПараметрыКодаМаркировки.ИдентификаторДокумента = Значение;
	КонецЕсли;
	
	Значение = ИсточникДанных["producerInn"];
	Если Значение <> Неопределено Тогда
		ПараметрыКодаМаркировки.ИННПроизводителя = Значение;
	КонецЕсли;
	
	Значение = ИсточникДанных["productName"];
	Если Значение <> Неопределено Тогда
		ПараметрыКодаМаркировки.ПредставлениеНоменклатуры = Значение;
	КонецЕсли;
	
	Значение = ИсточникДанных["producerName"];
	Если Значение <> Неопределено Тогда
		ПараметрыКодаМаркировки.НаименованиеПроизводителя = Значение;
	КонецЕсли;
	
	Значение = ИсточникДанных["maxRetailPrice"];
	Если Значение <> Неопределено Тогда
		ПараметрыКодаМаркировки.МРЦ = Значение;
		ПривестиЗначениеМРЦ(ПараметрыКодаМаркировки);
	КонецЕсли;
	
	Значение = ИсточникДанных["expirationDate"];
	Если Значение <> Неопределено Тогда
		ПараметрыКодаМаркировки.ГоденДо = ИнтеграцияИС.ДатаИзСтроки(Значение);
	КонецЕсли;
	
	Значение = ИсточникДанных["emissionDate"];
	Если Значение <> Неопределено Тогда
		ПараметрыКодаМаркировки.ДатаЭмиссии = ИнтеграцияИС.ДатаИзСтроки(Значение);
	КонецЕсли;
	
	Значение = ИсточникДанных["emissionType"];
	Если Значение <> Неопределено Тогда
		ПараметрыКодаМаркировки.СпособВводаВОборот = ИнтерфейсИСМПСлужебный.СпособВыпускаВОборот(Значение);
	КонецЕсли;
	
	Значение = ИсточникДанных["producedDate"];
	Если Значение <> Неопределено Тогда
		
		Если ИнтеграцияИСПовтИсп.ЭтоПродукцияМОТП(ПараметрыКодаМаркировки.ВидПродукции) Тогда
			ПараметрыКодаМаркировки.ДатаПроизводства = ИнтеграцияИС.ДатаИзСтроки(Значение);
		Иначе
			ПараметрыКодаМаркировки.ДатаВводаВОборот = ИнтеграцияИС.ДатаИзСтроки(Значение);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИсточникДанных["parent"] <> Неопределено Тогда
		ПараметрыКодаМаркировки.РодительскаяУпаковка = ИсточникДанных["parent"];
	КонецЕсли;
	
	Если ИсточникДанных["child"] <> Неопределено
		И ИсточникДанных["child"].Количество() > 0 Тогда
		
		Если НастройкиРазбора = Неопределено Тогда
			НастройкиРазбораКодаМаркировки = РазборКодаМаркировкиИССлужебный.НастройкиРазбораКодаМаркировки(, Ложь);
		Иначе
			НастройкиРазбораКодаМаркировки = НастройкиРазбора;
		КонецЕсли;
		
		ПараметрыКодаМаркировки.ВложенныеУпаковки = Новый Соответствие();
		Для Каждого ВложенныйКодМаркировки Из ИсточникДанных["child"] Цикл
			
			СтрокаКодаМаркировки = ШтрихкодированиеИС.НоваяСтруктураОбработкиШтрихкода(
				ВложенныйКодМаркировки, ВидПродукцииДляРазбораКода, Ложь, НастройкиРазбораКодаМаркировки);
			
			Если ПараметрыКодаМаркировки.ВидУпаковки = Перечисления.ВидыУпаковокИС.Групповая
				И Не ЗначениеЗаполнено(СтрокаКодаМаркировки.ВидУпаковки)
				И РазборКодаМаркировкиИССлужебныйКлиентСервер.ВидУпаковкиСоответствуетРазбору(
					ВидПродукции,
					Перечисления.ВидыУпаковокИС.Потребительская,
					СтрокаКодаМаркировки.ДанныеРазбора) Тогда
				СтрокаКодаМаркировки.ВидУпаковки = Перечисления.ВидыУпаковокИС.Потребительская;
			КонецЕсли;
			
			ШтрихкодированиеМОТП.РассчитатьХэшСуммуНормализации(
				СтрокаКодаМаркировки,
				СтрокаКодаМаркировки.ДанныеРазбора);
			
			ПараметрыКодаМаркировки.ВложенныеУпаковки.Вставить(
				СтрокаКодаМаркировки,
				ВложенныйКодМаркировки);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ПараметрыКодаМаркировки;
	
КонецФункции

// Преобразовывает текстовое представление статуса кода маркировки МОТП в значение перечисления.
//
// Параметры:
//  ЗначениеПоиска - Строка - значение для перекодировки
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыКодовМаркировкиМОТП - статус кода маркировки.
//
Функция СтатусКодаМаркировки(Знач ЗначениеПоиска) Экспорт
	
	Если ЗначениеПоиска = Неопределено Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.Неопределен;
	КонецЕсли;
	
	ЗначениеПоиска = ВРег(ЗначениеПоиска);
	
	Если ЗначениеПоиска = "EMITTED" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.Эмитирован;
	ИначеЕсли ЗначениеПоиска = "APPLIED" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.Нанесен;
	ИначеЕсли ЗначениеПоиска = "APPLIED_PAID" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.НанесенОплачен;
	ИначеЕсли ЗначениеПоиска = "APPLIED_NOT_PAID" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.НанесенНеОплачен;
	ИначеЕсли ЗначениеПоиска = "INTRODUCED" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.ВведенВОборот;
	ИначеЕсли ЗначениеПоиска = "RECYCLED" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.Утилизирован;
	ИначеЕсли ЗначениеПоиска = "RETIRED" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.ВыведенИзОборота;
	ИначеЕсли ЗначениеПоиска = "RESERVED_NOT_USED" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.Неопределен;
	ИначеЕсли ЗначениеПоиска = "WRITTEN_OFF" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.Списан;
	ИначеЕсли ЗначениеПоиска = "WITHDRAWN" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.Продан;
	ИначеЕсли ЗначениеПоиска = "INTRODUCED_RETURNED" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.ВведенВОборотВозвращен;
	ИначеЕсли ЗначениеПоиска = "DISAGGREGATED" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.Разагрегирован;
	ИначеЕсли ЗначениеПоиска = "WAIT_SHIPMENT" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.ОжидаетДоставки;
	ИначеЕсли ЗначениеПоиска = "EXPORTED" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.Экспортирован;
	ИначеЕсли ЗначениеПоиска = "LOAN_RETIRED" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.ВыведенИзОборотаПоДоговоруРассрочки;
	ИначеЕсли ЗначениеПоиска = "REMARK_RETIRED" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.ВыведенИзОборотаПриПеремаркировке;
	ИначеЕсли ЗначениеПоиска = "UNDEFINED" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.Неопределен;
	ИначеЕсли ЗначениеПоиска = "ELIMINATED" Тогда
		Возврат Перечисления.СтатусыКодовМаркировкиМОТП.НеИспользован;
	КонецЕсли;
	
	ВызватьИсключение
		СтрШаблон(
			НСтр("ru = 'Неизвестный статус кода маркировки: %1'"),
			ЗначениеПоиска);
	
КонецФункции

// Преобразовывает текстовое представление статуса участника МОТП в значение перечисления.
//
// Параметры:
//  ЗначениеПоиска - Строка - значение для перекодировки
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыУчастниковМОТП - статус участника.
//
Функция СтатусУчастника(Знач ЗначениеПоиска) Экспорт
	
	ЗначениеПоиска = ВРег(ЗначениеПоиска);
	
	Если ЗначениеПоиска = "ЗАРЕГИСТРИРОВАН" Или ЗначениеПоиска = "REGISTERED" Тогда
		Возврат Перечисления.СтатусыУчастниковМОТП.Зарегистрирован;
	КонецЕсли;
	
	ВызватьИсключение
		СтрШаблон(
			НСтр("ru = 'Неизвестный статус участника: %1'"),
			ЗначениеПоиска);
	
КонецФункции

// Преобразовывает текстовое представление типа операции движения кода маркировки МОТП в значение перечисления.
//
// Параметры:
//  ЗначениеПоиска - Строка - значение для перекодировки
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.ТипыОперацийДвиженияКодовМаркировкиМОТП - тип операции движения кода маркировки.
//
Функция ТипОперацииДвиженияКодаМаркировки(Знач ЗначениеПоиска) Экспорт
	
	ЗначениеПоиска = ВРег(ЗначениеПоиска);
	
	Если ЗначениеПоиска = "EMISSION" Тогда
		Возврат Перечисления.ТипыОперацийДвиженияКодовМаркировкиМОТП.Эмиссия;
	ИначеЕсли ЗначениеПоиска = "APPLICATION" Тогда
		Возврат Перечисления.ТипыОперацийДвиженияКодовМаркировкиМОТП.Нанесение;
	ИначеЕсли ЗначениеПоиска = "AGGREGATION" Тогда
		Возврат Перечисления.ТипыОперацийДвиженияКодовМаркировкиМОТП.Агрегация;
	ИначеЕсли ЗначениеПоиска = "OWNER_CHANGE" Тогда
		Возврат Перечисления.ТипыОперацийДвиженияКодовМаркировкиМОТП.СменаВладельца;
	КонецЕсли;
	
	ВызватьИсключение
		СтрШаблон(
			НСтр("ru = 'Неизвестный тип операции движения кода маркировки: %1'"),
			ЗначениеПоиска);
	
КонецФункции

// Преобразовывает текстовое представление типа документа ИС МОТП в значение перечисления.
//
// Параметры:
//  ЗначениеПоиска - Строка - значение для перекодировки
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.ТипыДокументовМОТП - тип документа.
//
Функция ТипДокумента(Знач ЗначениеПоиска) Экспорт
	
	ЗначениеПоиска = ВРег(ЗначениеПоиска);
	
	Если ЗначениеПоиска = "UNIVERSAL_TRANSFER_DOCUMENT" Тогда
		Возврат Перечисления.ТипыДокументовМОТП.УПД;
	ИначеЕсли ЗначениеПоиска = "AGGREGATION_DOCUMENT" Тогда
		Возврат Перечисления.ТипыДокументовМОТП.УведомлениеОбАгрегации;
	КонецЕсли;
	
	ВызватьИсключение
		СтрШаблон(
			НСтр("ru = 'Неизвестный тип документа: %1'"),
			ЗначениеПоиска);
	
КонецФункции

// Преобразовывает текстовое представление статуса документа ИС МОТП в значение перечисления.
//
// Параметры:
//  ЗначениеПоиска - Строка - значение для перекодировки
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыДокументовМОТП - статус документа МОТП.
//
Функция СтатусДокумента(Знач ЗначениеПоиска) Экспорт
	
	ЗначениеПоиска = ВРег(ЗначениеПоиска);
	
	Если ЗначениеПоиска = "CHECKED_OK" Тогда
		Возврат Перечисления.СтатусыДокументовМОТП.Проверен;
	КонецЕсли;
	
	ВызватьИсключение
		СтрШаблон(
			НСтр("ru = 'Неизвестный статус документа: %1'"),
			ЗначениеПоиска);
	
КонецФункции

#Область JWT

Функция РасшифроватьТокенJWT(Токен) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("РезультатРасшифровки", Неопределено);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",          "");
	ВозвращаемоеЗначение.Вставить("Данные",               Неопределено);
	
	ЭлементыТокена = СтрРазделить(Токен, ".");
	Если ЭлементыТокена.Count() <> 3 Тогда
		ВозвращаемоеЗначение.ТекстОшибки = НСтр("ru = 'Токен не соответствует формату JWT'");
		Возврат ВозвращаемоеЗначение;
	КонецЕсли;
	
	ЭлементТокенаДанные = ЭлементыТокена[1];
	
	ВозвращаемоеЗначение.Данные = ТекстJSONВОбъект(
		ПолучитьСтрокуИзДвоичныхДанных(
			ДвоичныеДанныеЭлементаТокенаJWT(ЭлементТокенаДанные)));
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ДвоичныеДанныеЭлементаТокенаJWT(Знач Значение)
	
	Значение = СтрЗаменить(Значение, "-", "+");
	Значение = СтрЗаменить(Значение, "_", "/");
	
	Остаток = СтрДлина(Значение) % 4;

	Если Остаток = 1 Тогда
		Возврат Неопределено;
	ИначеЕсли Остаток = 2 Тогда
		Значение = Значение + "==";
	ИначеЕсли Остаток = 3 Тогда
		Значение = Значение + "=";
	КонецЕсли;
	
	Возврат Base64Значение(Значение);
	
КонецФункции

#КонецОбласти

#Область XDTO

Функция ВерсияПрограммы() Экспорт
	Возврат СтрШаблон("%1 (%2)", Метаданные.Синоним, Метаданные.Версия);
КонецФункции

Функция ИмяФайлаXDTO(ДанныеДокумента, МетаданныеXDTO) Экспорт
	Возврат СтрШаблон(
		"MTTPS-%1_%2_%3_%4",
		ОписаниеНомераТипаДанных(МетаданныеXDTO),
		Формат(ДанныеДокумента.Дата, "ДФ=yyyy-MM-dd;"),
		ДанныеДокумента.ИНН,
		Строка(Новый УникальныйИдентификатор));
КонецФункции

Функция ОписаниеНомераТипаДанных(МетаданныеXDTO)
	
	Если МетаданныеXDTO = Метаданные.ПакетыXDTO.АгрегацияМОТП Тогда
		Возврат "60";
	ИначеЕсли МетаданныеXDTO = Метаданные.ПакетыXDTO.ВыбытиеМОТП Тогда
		Возврат "90";
	Иначе
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Внутренняя ошибка. Не описан номер типа данных для %1'"), МетаданныеXDTO);
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

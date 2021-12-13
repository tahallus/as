﻿&НаКлиенте
Процедура Инициализировать()
	Если Параметры.Ключ.Пустая() Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ИнициализироватьЗавершение", ЭтотОбъект, Новый Структура);
		ПоказатьВводСтроки(ОписаниеОповещения, "", "Введите значение X_Yandex_API_Key")
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИнициализироватьЗавершение(X_Yandex_API_Key, Параметры) Экспорт

    Соединение = Новый HTTPСоединение("adfox.yandex.ru", 443,,,,,Новый ЗащищенноеСоединениеOpenSSL(),Ложь);
	
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("X-Yandex-API-Key", X_Yandex_API_Key); 
	//Заголовки.Вставить("Accept-Encoding", "gzip"); 
	
	Параметры = Новый Структура("object, action", "account", "auth");
	
	СтрокаПараметров = "?encoding=UTF-8";
	
	Для каждого Параметр из Параметры Цикл 
		СтрокаПараметров = СтрокаПараметров + "&" + Параметр.Ключ  + "=" + Параметр.Значение;
	КонецЦикла;
	
	Запрос = Новый HTTPЗапрос("/api/v1" + СтрокаПараметров, Заголовки);

	Ответ = Соединение.Получить(Запрос);

	ОписаниеОповещения = Новый ОписаниеОповещения("ИзвещениеОбОшибке", ЭтотОбъект, Новый Структура);
	
	Если Ответ.КодСостояния <> 200 Тогда 
		ПоказатьПредупреждение(ОписаниеОповещения, "Код состояния (ответа): " + Ответ.КодСостояния, 30, "Сведения об ошибке");
	Иначе
		РезультатXML = ПрочитатьXMLВСтруктуру(Ответ.ПолучитьТелоКакСтроку(КодировкаТекста.Системная));
		Если РезультатXML.code <> 0 Тогда
			ПоказатьПредупреждение(ОписаниеОповещения, "code:" + РезультатXML.code + "; error: " + РезультатXML.error, 30, "Сведения об ошибке");
		Иначе
			Объект.Код = РезультатXML.accountID;
			Объект.X_Yandex_API_Key = X_Yandex_API_Key;
		КонецЕсли;
	КонецЕсли;        
		
КонецПроцедуры 

&НаКлиенте
Процедура ИзвещениеОбОшибке(Параметры) Экспорт

	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Инициализировать();
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПрочитатьXMLВСтруктуру(Строка)
	
	Попытка 
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.УстановитьСтроку(Строка);
		ЧтениеXML.ПерейтиКСодержимому();
		
		ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
		ЧтениеXML.Закрыть();
	Исключение
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Ошибка: " + ОписаниеОшибки();
		Сообщение.Сообщить();
	КонецПопытки;
	
	Результат = Новый Структура("code, error, accountID", 0, "", 0);

	Если ОбъектXDTO.status.code = "0" Тогда
		Результат.accountID = ОбъектXDTO.result.accountID;
	Иначе
		Результат.error = ОбъектXDTO.status.error;
	КонецЕсли;
		
	Возврат Результат;
                
КонецФункции

&НаСервере
Процедура СинхронизироватьНаСервере()
	СправочникОбъект = ДанныеФормыВЗначение(Объект, Тип("СправочникОбъект._adfox_account"));
	СправочникОбъект.Синхронизировать();
КонецПроцедуры

&НаКлиенте
Процедура Синхронизировать(Команда)
	СинхронизироватьНаСервере();
	ОбновитьОтображениеДанных();
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьКампании(Команда)
	Если Не ЗначениеЗаполнено(Объект.dateAddedFrom) Тогда 
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не заполнена дата начала синхронизации по кампании";
		Сообщение.Поле = "dateAddedFrom";
		Сообщение.УстановитьДанные(Объект);
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Объект.dateAddedTo) Тогда 
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не заполнена дата окончания синхронизации по кампании";
		Сообщение.Поле = "dateAddedTo";
		Сообщение.УстановитьДанные(Объект);
		Сообщение.Сообщить();            
		Возврат;
	КонецЕсли;  
	Если Объект.dateAddedTo<Объект.dateAddedFrom Тогда 
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Дата начала синхронизации не может быть больше даты окончания синхронизации";
		Сообщение.УстановитьДанные(Объект);
		Сообщение.Сообщить();            
		Возврат;
	КонецЕсли;
	СинхронизироватьКампанииНаСервере();
	ОбновитьОтображениеДанных();
КонецПроцедуры

&НаСервере
Процедура СинхронизироватьКампанииНаСервере()
	СправочникОбъект = ДанныеФормыВЗначение(Объект, Тип("СправочникОбъект._adfox_account"));
	СправочникОбъект.СинхронизироватьКампании();
КонецПроцедуры

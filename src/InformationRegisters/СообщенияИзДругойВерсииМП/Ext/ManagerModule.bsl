﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ДобавитьСообщение(Ссылка, ВерсияПакета, Сообщение, ПредопределенныеДанные, НовыеДанные, КодУзла) Экспорт
	
	Структура = РазложитьВерсиюНаЧисла(ВерсияПакета);
	
	НаборЗаписей = РегистрыСведений.СообщенияИзДругойВерсииМП.СоздатьНаборЗаписей();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СообщенияИзДругойВерсииМП.Номер КАК Номер,
	|	СообщенияИзДругойВерсииМП.Ссылка КАК Ссылка
	|ИЗ
	|	РегистрСведений.СообщенияИзДругойВерсииМП КАК СообщенияИзДругойВерсииМП
	|ГДЕ
	|	СообщенияИзДругойВерсииМП.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НомерСообщения = ВыборкаДетальныеЗаписи.Номер;
	КонецЦикла;
	
	Если НомерСообщения = Неопределено Тогда
		НомерСообщения = ПолучитьНомерСообщения();
	КонецЕсли;
	
	НаборЗаписей.Отбор.Ссылка.Установить(Ссылка);
	НаборЗаписей.Отбор.Номер.Установить(НомерСообщения);
	НаборЗаписей.Отбор.КодУзла.Установить(КодУзла);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Номер = НомерСообщения;
	НоваяЗапись.Ссылка = Ссылка;
	НоваяЗапись.ВерсияПакета = ВерсияПакета;
	НоваяЗапись.КодУзла = КодУзла;
	
	НоваяЗапись.Сообщение = Сообщение;
	//НоваяЗапись.НаименованияРеквизитов = НаименованияРеквизитов;
	НоваяЗапись.ПредопределенныеДанные = ПредопределенныеДанные;
	//НоваяЗапись.НаименованияТЧ = НаименованияТЧ;
	НоваяЗапись.НовыеДанные = НовыеДанные;
	
	НоваяЗапись.Редакция = Структура.Редакция;
	НоваяЗапись.Подредакция = Структура.Подредакция;
	НоваяЗапись.Версия = Структура.Версия;
	НоваяЗапись.Сборка = Структура.Сборка;
	
	НаборЗаписей.ОбменДанными.Загрузка = Истина;
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

Процедура ДобавитьСообщениеСХешем(СформированныйХеш, ВерсияПакета, Сообщение, НовыеДанные, ПредопределенныеДанные, КодУзла) Экспорт
	
	Структура = РазложитьВерсиюНаЧисла(ВерсияПакета);
	
	СформированныйХеш = Строка(СформированныйХеш);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СообщенияИзДругойВерсииМП.Номер КАК Номер,
	|	СообщенияИзДругойВерсииМП.Хеш КАК Хеш
	|ИЗ
	|	РегистрСведений.СообщенияИзДругойВерсииМП КАК СообщенияИзДругойВерсииМП
	|ГДЕ
	|	СообщенияИзДругойВерсииМП.Хеш = &Хеш";
	
	Запрос.УстановитьПараметр("Хеш", СформированныйХеш);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		НомерСообщения = ВыборкаДетальныеЗаписи.Номер;
	КонецЕсли;
	
	Если НомерСообщения = Неопределено Тогда
		НомерСообщения = ПолучитьНомерСообщения();
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.СообщенияИзДругойВерсииМП.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Номер.Установить(НомерСообщения);
	//НаборЗаписей.Отбор.КодУзла.Установить(КодУзла);
	НаборЗаписей.Отбор.Хеш.Установить(СформированныйХеш);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Номер = НомерСообщения;
	НоваяЗапись.ВерсияПакета = ВерсияПакета;
	НоваяЗапись.КодУзла = КодУзла;
	НоваяЗапись.Хеш = СформированныйХеш;
	
	НоваяЗапись.Сообщение = Сообщение;
	НоваяЗапись.ПредопределенныеДанные = ПредопределенныеДанные;
	НоваяЗапись.НовыеДанные = НовыеДанные;
	
	НоваяЗапись.Редакция = Структура.Редакция;
	НоваяЗапись.Подредакция = Структура.Подредакция;
	НоваяЗапись.Версия = Структура.Версия;
	НоваяЗапись.Сборка = Структура.Сборка;
	
	НаборЗаписей.ОбменДанными.Загрузка = Истина;
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

Функция РазложитьВерсиюНаЧисла(ВерсияПакета) Экспорт
	
	Редакция = "";
	Подредакция = "";
	Версия = "";
	Сборка = "";
	
	КоличествоТочек = 0;
	
	Для Индекс = 1 По СтрДлина(ВерсияПакета) Цикл 
		СимволСтроки = Сред(ВерсияПакета, Индекс, 1);
		Если СимволСтроки = "." Тогда
			КоличествоТочек = КоличествоТочек + 1;
			Продолжить;
		ИначеЕсли КоличествоТочек = 0 Тогда
			Редакция = Редакция + СимволСтроки;
		ИначеЕсли КоличествоТочек = 1 Тогда
			Подредакция = Подредакция + СимволСтроки;
		ИначеЕсли КоличествоТочек = 2 Тогда
			Версия = Версия + СимволСтроки;
		ИначеЕсли КоличествоТочек = 3 Тогда
			Сборка = Сборка + СимволСтроки;
		КонецЕсли;
	КонецЦикла;
	
	Если Редакция = "" Тогда
		Редакция = "0";
	КонецЕсли;
	
	Если Подредакция = "" Тогда
		Подредакция = "0";
	КонецЕсли;
	
	Если Версия = "" Тогда
		Версия = "0";
	КонецЕсли;
	
	Если Сборка = "" Тогда
		Сборка = "0";
	КонецЕсли;
	
	Возврат Новый Структура("Редакция, Подредакция, Версия, Сборка", Число(Редакция), Число(Подредакция), Число(Версия), Число(Сборка))
	
КонецФункции

Процедура УдалитьСообщение(Знач НомерСообщения) Экспорт
	
	НаборЗаписей = РегистрыСведений.СообщенияИзДругойВерсииМП.СоздатьНаборЗаписей();
	НаборЗаписей.ОбменДанными.Загрузка = Истина;
	НаборЗаписей.Отбор.Номер.Установить(НомерСообщения);
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры 

Процедура УдалитьСообщениеПоСсылке(Ссылка) Экспорт

	НаборЗаписей = РегистрыСведений.СообщенияИзДругойВерсииМП.СоздатьНаборЗаписей();
	НаборЗаписей.ОбменДанными.Загрузка = Истина;
	НаборЗаписей.Отбор.Ссылка.Установить(Ссылка);
	НаборЗаписей.Записать(Истина);

КонецПроцедуры

Процедура ДобавитьСообщениеСУникальнымИдентификаторомНовогоОбъекта(СформированныйХеш, ВерсияПакета, Сообщение, НовыеДанные, ПредопределенныеДанные, КодУзла, УникальныйИдентификаторНовогоОбъекта) Экспорт
	
	Структура = РазложитьВерсиюНаЧисла(ВерсияПакета);
	
	СформированныйХеш = Строка(СформированныйХеш);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СообщенияИзДругойВерсииМП.Номер КАК Номер,
	|	СообщенияИзДругойВерсииМП.Хеш КАК Хеш
	|ИЗ
	|	РегистрСведений.СообщенияИзДругойВерсииМП КАК СообщенияИзДругойВерсииМП
	|ГДЕ
	|	СообщенияИзДругойВерсииМП.Хеш = &Хеш";
	
	Запрос.УстановитьПараметр("Хеш", СформированныйХеш);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		НомерСообщения = ВыборкаДетальныеЗаписи.Номер;
	КонецЕсли;
	
	Если НомерСообщения = Неопределено Тогда
		НомерСообщения = ПолучитьНомерСообщения();
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.СообщенияИзДругойВерсииМП.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Номер.Установить(НомерСообщения);
	//НаборЗаписей.Отбор.КодУзла.Установить(КодУзла);
	НаборЗаписей.Отбор.УникальныйИдентификаторНовогоОбъекта.Установить(УникальныйИдентификаторНовогоОбъекта);
	НаборЗаписей.Отбор.Хеш.Установить(СформированныйХеш);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Номер = НомерСообщения;
	НоваяЗапись.ВерсияПакета = ВерсияПакета;
	НоваяЗапись.КодУзла = КодУзла;
	НоваяЗапись.Хеш = СформированныйХеш;
	НоваяЗапись.УникальныйИдентификаторНовогоОбъекта = УникальныйИдентификаторНовогоОбъекта;
	
	НоваяЗапись.Сообщение = Сообщение;
	НоваяЗапись.ПредопределенныеДанные = ПредопределенныеДанные;
	НоваяЗапись.НовыеДанные = НовыеДанные;
	
	НоваяЗапись.Редакция = Структура.Редакция;
	НоваяЗапись.Подредакция = Структура.Подредакция;
	НоваяЗапись.Версия = Структура.Версия;
	НоваяЗапись.Сборка = Структура.Сборка;
	
	НаборЗаписей.ОбменДанными.Загрузка = Истина;
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьНомерСообщения() 
	
	НомерСообщенияОбмена = 1;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СообщенияИзДругойВерсииМП.Номер КАК Номер
	|ИЗ
	|	РегистрСведений.СообщенияИзДругойВерсииМП КАК СообщенияИзДругойВерсииМП
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номер УБЫВ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		НомерСообщенияОбмена = ВыборкаДетальныеЗаписи.Номер + НомерСообщенияОбмена;
	КонецЕсли;
	
	Возврат НомерСообщенияОбмена;
	
КонецФункции

#КонецОбласти

#КонецЕсли

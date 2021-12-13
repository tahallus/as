﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ЗаписатьИнформацию(Структура) Экспорт
	
	НаборЗаписей = РегистрыСведений.ЖурналСинхронизацииМП.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Узел.Установить(Структура.Узел);
	
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда
		
		НоваяЗапись = НаборЗаписей.Добавить();
		Для Каждого Элемент Из Структура Цикл
			НоваяЗапись[Элемент.Ключ] = Элемент.Значение;
		КонецЦикла;
		
	Иначе
		Для каждого ЗаписьНабора Из НаборЗаписей Цикл
			Для Каждого Элемент Из Структура Цикл
				ЗаписьНабора[Элемент.Ключ] = Элемент.Значение;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Функция ПолучитьФормированиеПакетовНаКлиенте(КодУзла) Экспорт 
	
	Узел = ПланыОбмена.СинхронизацияМП.НайтиПоКоду(КодУзла);
	
	НаборЗаписей = РегистрыСведений.ЖурналСинхронизацииМП.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Узел.Установить(Узел);
	НаборЗаписей.Прочитать();
	
	Для каждого ЗаписьНабора Из НаборЗаписей Цикл
		ФормированиеПакетовНаКлиенте = ЗаписьНабора.ФормированиеПакетовНаКлиенте; 
	КонецЦикла;
	
	Возврат ФормированиеПакетовНаКлиенте

КонецФункции

Функция ПолучитьФормированиеПакетовНаСервере(КодУзла) Экспорт 
	
	Узел = ПланыОбмена.СинхронизацияМП.НайтиПоКоду(КодУзла);
	
	НаборЗаписей = РегистрыСведений.ЖурналСинхронизацииМП.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Узел.Установить(Узел);
	НаборЗаписей.Прочитать();
	
	Для каждого ЗаписьНабора Из НаборЗаписей Цикл
		ФормированиеПакетовНаСервере = ЗаписьНабора.ФормированиеПакетовНаСервере; 
	КонецЦикла;
	
	Возврат ФормированиеПакетовНаСервере

КонецФункции 

Функция ПолучитьВерсиюБазыСКоторойИдетСинхронизация(КодУзла) Экспорт 
	
	Узел = ПланыОбмена.СинхронизацияМП.НайтиПоКоду(КодУзла);
	
	НаборЗаписей = РегистрыСведений.ЖурналСинхронизацииМП.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Узел.Установить(Узел);
	НаборЗаписей.Прочитать();
	
	Для каждого ЗаписьНабора Из НаборЗаписей Цикл
		ВерсияБазыСКоторойИдетОбмен = ЗаписьНабора.ВерсияБазыСКоторойИдетОбмен; 
	КонецЦикла;
	
	Возврат ВерсияБазыСКоторойИдетОбмен

КонецФункции

Функция ПолучитьФоновоеЗаданиеНаСервереЗавершено(КодУзла) Экспорт 
	
	//Узел = ПланыОбмена.Синхронизация.НайтиПоКоду(КодУзла);
	//
	//НаборЗаписей = РегистрыСведений.ЖурналСинхронизации.СоздатьНаборЗаписей();
	//НаборЗаписей.Отбор.Узел.Установить(Узел);
	//НаборЗаписей.Прочитать();
	//
	//Для каждого ЗаписьНабора Из НаборЗаписей Цикл
	//	//ФоновоеЗаданиеНаСервереЗавершено = ЗаписьНабора.ФоновоеЗаданиеНаСервереЗавершено; 
	//КонецЦикла;
	//
	//Возврат ФоновоеЗаданиеНаСервереЗавершено

КонецФункции 

Функция ПолучитьИдентификаторФоновогоЗадания(КодУзла) Экспорт
	
	Узел = ПланыОбмена.СинхронизацияМП.НайтиПоКоду(КодУзла);
	
	НаборЗаписей = РегистрыСведений.ЖурналСинхронизацииМП.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Узел.Установить(Узел);
	НаборЗаписей.Прочитать();
	
	Для каждого ЗаписьНабора Из НаборЗаписей Цикл
		ИдентификаторФоновогоЗаданияНаСервере = ЗаписьНабора.ИдентификаторФоновогоЗаданияНаСервере;
	КонецЦикла;
	
	Возврат ИдентификаторФоновогоЗаданияНаСервере
	
КонецФункции // ()

Функция ПолучитьСтатусСинхронизации() Экспорт

	Узел = ПланыОбмена.СинхронизацияМП.НайтиПоКоду("001");
	
	НаборЗаписей = РегистрыСведений.ЖурналСинхронизацииМП.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Узел.Установить(Узел);
	НаборЗаписей.Прочитать();
	
	Для каждого ЗаписьНабора Из НаборЗаписей Цикл
		СтатусСинхронизации = ЗаписьНабора.СтатусСинхронизации;
	КонецЦикла;
	
	Возврат СтатусСинхронизации
	
КонецФункции

Функция ПушУведомлениеНеБылоОтправлено(КодУзла) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЖурналСинхронизацииМП.ДатаИВремяПоследнейСинхронизации КАК ДатаИВремяПоследнейСинхронизации,
		|	ЖурналСинхронизацииМП.ДатаИВремяПоследнегоПушУведомления КАК ДатаИВремяПоследнегоПушУведомления
		|ИЗ
		|	РегистрСведений.ЖурналСинхронизацииМП КАК ЖурналСинхронизацииМП
		|ГДЕ
		|	ЖурналСинхронизацииМП.Узел.Код = &КодУзла";
	
	Запрос.УстановитьПараметр("КодУзла", КодУзла);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Если ВыборкаДетальныеЗаписи.ДатаИВремяПоследнегоПушУведомления < ВыборкаДетальныеЗаписи.ДатаИВремяПоследнейСинхронизации Тогда
			Возврат Истина;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли

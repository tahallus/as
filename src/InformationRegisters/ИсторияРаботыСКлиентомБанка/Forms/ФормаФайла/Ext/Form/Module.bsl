﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МенеджерЗаписи = РегистрыСведений.ИсторияРаботыСКлиентомБанка.СоздатьМенеджерЗаписи();
	
	МенеджерЗаписи.Период = Параметры.Период;
	МенеджерЗаписи.Организация = Параметры.Организация;
	МенеджерЗаписи.БанковскийСчет = Параметры.БанковскийСчет;
	МенеджерЗаписи.Прочитать();
	
	Если НЕ МенеджерЗаписи.Выбран() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ТекстФайла = МенеджерЗаписи.ИсходныйФайл.Получить();
	Кодировка = МенеджерЗаписи.Кодировка;
	
	Если НЕ МенеджерЗаписи.ФайлОтформатирован Тогда
		
		РасскрашенныйТекст = РегистрыСведений.ИсторияРаботыСКлиентомБанка.ОтформатироватьИсходныйФайл(ТекстФайла);
		
		МенеджерЗаписи.ФорматированныйФайл = 
			Новый ХранилищеЗначения(
				РасскрашенныйТекст,
				Новый СжатиеДанных(5));
		МенеджерЗаписи.ФайлОтформатирован = Истина;
		МенеджерЗаписи.Записать();
		
	Иначе
		РасскрашенныйТекст = МенеджерЗаписи.ФорматированныйФайл.Получить();
	КонецЕсли;
	
	СпособПредставления = ХранилищеОбщихНастроек.Загрузить("ОбменСКлиентомБанка", "ПоказыватьФорматированно");
	
	Если СпособПредставления = Неопределено Тогда
		СпособПредставления = Истина;
	КонецЕсли;
	
	НачальноеПредставлениеФорматировано = СпособПредставления;
	Элементы.ФормаФорматированныйВид.Пометка = НачальноеПредставлениеФорматировано;
	
	Элементы.ФормаЗагрузитьСнова.Видимость = МенеджерЗаписи.Загрузка;
	Элементы.ФормаСохранитьНаДиск.Видимость = НЕ МенеджерЗаписи.Загрузка;
	
	УстановитьПредставление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ (НачальноеПредставлениеФорматировано = Элементы.ФормаФорматированныйВид.Пометка)
		И НЕ ЗавершениеРаботы Тогда
		
		СохранитьНастройкуНаСервере(Элементы.ФормаФорматированныйВид.Пометка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ФорматированныйВид(Команда)
	Элементы.ФормаФорматированныйВид.Пометка = НЕ Элементы.ФормаФорматированныйВид.Пометка;
	УстановитьПредставление();
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСнова(Команда)
	
	АдресФайлаКОбработке = ПоместитьВоВременноеХранилище(ТекстФайла, УникальныйИдентификатор);
	ПараметрыФормыЗагрузки = Новый Структура;
	ПараметрыФормыЗагрузки.Вставить("АдресФайлаКОбработке", АдресФайлаКОбработке);
	ПараметрыФормыЗагрузки.Вставить("БанковскийСчет", Параметры.БанковскийСчет);
	ПараметрыФормыЗагрузки.Вставить("Организация", Параметры.Организация);
	ПараметрыФормыЗагрузки.Вставить("Период", Параметры.Период);
	ОткрытьФорму("Обработка.КлиентБанк.Форма.ФормаЗагрузка", ПараметрыФормыЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНаДиск(Команда)
	
	ПараметрыЗаписи = ПолучитьТекстФайлаИКодировку(КлючУникальности);
	Если ПараметрыЗаписи = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Не удалось получить данные из информационной базы!'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ПараметрыЗаписи.ТекстовыйПоток);
	
	ПараметрыСохранения = ФайловаяСистемаКлиент.ПараметрыСохраненияФайла();
	ФайловаяСистемаКлиент.СохранитьФайл(Неопределено, АдресВоВременномХранилище, "1c_to_kl.txt",
		ПараметрыСохранения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПредставление()
	
	Элементы.РаскрашенныйТекст.Видимость = Элементы.ФормаФорматированныйВид.Пометка;
	Элементы.НеРаскрашенныйТекст.Видимость = НЕ Элементы.ФормаФорматированныйВид.Пометка;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНастройкуНаСервере(ЗначениеНастройки)
	
	ХранилищеОбщихНастроек.Сохранить("ОбменСКлиентомБанка", "ПоказыватьФорматированно", ЗначениеНастройки);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТекстФайлаИКодировку(Ключ)

	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("ТекстФайла", ТекстФайла);
	СтруктураВозврата.Вставить("Кодировка", Кодировка);
	
	ТекстовыйПоток = Новый ТекстовыйДокумент;
	ТекстовыйПоток.ДобавитьСтроку(СтруктураВозврата.ТекстФайла);
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("txt");
	Если Кодировка = "DOS" Тогда
		ТекстовыйПоток.Записать(ИмяВременногоФайла, КодировкаТекста.OEM);
	Иначе
		ТекстовыйПоток.Записать(ИмяВременногоФайла, КодировкаТекста.ANSI);
	КонецЕсли;
	ТекстовыйПоток = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ИмяВременногоФайла), Ключ);
	
	СтруктураВозврата.Вставить("ТекстовыйПоток", ТекстовыйПоток);
	
	// Удаляем временный файл
	Попытка
		УдалитьФайлы(ИмяВременногоФайла);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка при удалении временного файла.'",
			ОбщегоНазначения.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(
			ИнформацияОбОшибке()));
	КонецПопытки;
	
	Возврат СтруктураВозврата;
	
КонецФункции

#КонецОбласти

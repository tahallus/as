﻿////////////////////////////////////////////////////////////////////////////////
// Обработчики получения поставляемых данных.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Регистрирует обработчики поставляемых данных за день и за все время
//
Процедура ЗарегистрироватьОбработчикиПоставляемыхДанных(Знач Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ВидДанных = "ВнешнийРегламентированныйОтчет";
	Обработчик.КодОбработчика = "ВнешнийРегламентированныйОтчет";
	Обработчик.Обработчик = ВнешниеРегламентированныеОтчетыВМоделиСервиса;
	
КонецПроцедуры

// Вызывается при получении уведомления о новых данных.
// В теле следует проверить, необходимы ли эти данные приложению, 
// и если да - установить флажок Загружать
// 
// Параметры:
//   Дескриптор   - ОбъектXDTO Descriptor.
//   Загружать    - булево, возвращаемое
//
Процедура ДоступныНовыеДанные(Знач Дескриптор, Загружать) Экспорт
	
	Если Дескриптор.DataType = "ВнешнийРегламентированныйОтчет" Тогда
		
		Загружать = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается после вызова ДоступныНовыеДанные, позволяет разобрать данные.
//
// Параметры:
//   Дескриптор   - ОбъектXDTO Дескриптор.
//   ПутьКФайлу   - строка. Полное имя извлеченного файла. Файл будет автоматически удален 
//                  после завершения процедуры.
//
Процедура ОбработатьНовыеДанные(Знач Дескриптор, Знач ПутьКФайлу) Экспорт
	
	Если Дескриптор.DataType = "ВнешнийРегламентированныйОтчет"  Тогда
		
		ОбработатьВнРеглОтчет(Дескриптор, ПутьКФайлу);
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при отмене обработки данных в случае сбоя
//
Процедура ОбработкаДанныхОтменена(Знач Дескриптор) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьИмяФайла(Знач ИмяФайла)
	
	Если ЭтоАдресВременногоХранилища(ИмяФайла) Тогда
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("zip");
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ИмяФайла);
		ДвоичныеДанные.Записать(ИмяВременногоФайла);
		РабИмяФайла = ИмяВременногоФайла;
	Иначе
		РабИмяФайла = ИмяФайла;
	КонецЕсли;
	
	Возврат РабИмяФайла;
	
КонецФункции

Функция ФайлОтчетаИзАрхива(КаталогРаспаковки)
	
	НайденныеФайлы = НайтиФайлы(КаталогРаспаковки, "*.erf", Ложь);
	Если НайденныеФайлы.Количество() = 0 Тогда
		ВызватьИсключение(НСтр("ru = 'Ошибка получения отчета. Архив не содержит файл с расширением ""*.erf"".'"));
	Иначе
		Возврат НайденныеФайлы[0];
	КонецЕсли;
	
КонецФункции

Процедура ОбработатьВнРеглОтчет(Дескриптор, ПутьКФайлу)
	
	ИмяВременногоФайла = ПолучитьИмяФайла(ПутьКФайлу);
	
	КаталогРаспаковки = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(КаталогРаспаковки);
	
	Попытка
		
		Архиватор = Новый ЧтениеZipФайла(ИмяВременногоФайла);
		Архиватор.ИзвлечьВсе(КаталогРаспаковки);
		Архиватор.Закрыть();
		
		КаталогРаспаковки = КаталогРаспаковки + ?(ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ЭтоЛинукс(), "/", "\");
		
		Манифест = ПрочитатьМанифест(КаталогРаспаковки);
		
	Исключение
		
		ТекстОшибки = НСтр("ru = 'Не удалось распаковать архив с поставляемыми данными.'");
		ЗаписатьВЖурналРегистрации(УровеньЖурналаРегистрации.Ошибка, ТекстОшибки);
		Возврат;
		
	КонецПопытки;
	
	// Проверка данных манифеста
	// Прочитать версию отчета
	ИДКонфигурации      = Манифест.ИДКонфигурации;
	ВерсияКонфигурации  = Манифест.ВерсияКонфигурации;
	ИсточникОтчета      = Манифест.ИсточникОтчета;
	Версия              = Манифест.Версия;
	Имя                 = Манифест.Имя;
	
	ВнешнийОтчетИспользовать = Манифест.ВнешнийОтчетИспользовать;
	Если Манифест.ВнешнийОтчетИспользовать = Неопределено Тогда
		ВнешнийОтчетИспользовать = Истина;
	ИначеЕсли ВРег(Манифест.ВнешнийОтчетИспользовать) = "FALSE"
		ИЛИ ВРег(Манифест.ВнешнийОтчетИспользовать) = "ЛОЖЬ"
		ИЛИ ВРег(Манифест.ВнешнийОтчетИспользовать) = "НЕТ" Тогда
		ВнешнийОтчетИспользовать = Ложь;
	Иначе
		ВнешнийОтчетИспользовать = Истина;
	КонецЕсли;
	
	СвойстваМанифеста = Новый Структура;
	СвойстваКонфигурации = Новый Структура;
	СвойстваОтчета = Новый Структура;
	
	СвойстваМанифеста.Вставить("ИДКонфигурации", ИДКонфигурации);
	СвойстваМанифеста.Вставить("ВерсияКонфигурации", ВерсияКонфигурации);
	СвойстваМанифеста.Вставить("ИсточникОтчета", ИсточникОтчета);
	СвойстваМанифеста.Вставить("КраткаяВерсияВнешнегоОтчета", ВерсияКонфигурации + "." + Версия);
	
	СвойстваКонфигурации.Вставить("ИДКонфигурации", РегламентированнаяОтчетностьПереопределяемый.ИДКонфигурации());
	СвойстваКонфигурации.Вставить("ВерсияКонфигурации", Метаданные.Версия);
	
	// 1) проверка на соответствие идентификатора конфигурации в отчете идентификатору текущей конфигурации
	Если СвойстваМанифеста["ИДКонфигурации"] <> СвойстваКонфигурации["ИДКонфигурации"] Тогда
		ТекстОшибки = НСтр("ru = 'Не пройдена проверка на соответствие идентификатора конфигурации в отчете идентификатору текущей конфигурации'");
		ЗаписатьВЖурналРегистрации(УровеньЖурналаРегистрации.Ошибка, ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	// 2) проверка на соответствие версии в отчете версии текущей конфигурации
	Если СвойстваМанифеста["ВерсияКонфигурации"] <> СвойстваКонфигурации["ВерсияКонфигурации"] Тогда
		ТекстОшибки = НСтр("ru = 'Не пройдена проверка на соответствие версии в отчете версии текущей конфигурации.'");
		ЗаписатьВЖурналРегистрации(УровеньЖурналаРегистрации.Ошибка, ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	// проверка на соответсвие параметров манифеста и конфигурации пройдена
	// проверка на соответствие имени метаданных отчета свойству ИсточникОтчета текущего элемента
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	РегламентированныеОтчеты.Ссылка,
	               |	РегламентированныеОтчеты.ИсточникОтчета,
	               |	РегламентированныеОтчеты.ВнешнийОтчетИспользовать,
	               |	РегламентированныеОтчеты.ВнешнийОтчетВерсия
	               |ИЗ
	               |	Справочник.РегламентированныеОтчеты КАК РегламентированныеОтчеты
	               |ГДЕ
	               |	РегламентированныеОтчеты.Наименование = &Наименование
	               |	И РегламентированныеОтчеты.ИсточникОтчета = &ИсточникОтчета";
	Запрос.УстановитьПараметр("Наименование", Имя);
	Запрос.УстановитьПараметр("ИсточникОтчета", ИсточникОтчета);
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Если НЕ Выборка.Следующий() Тогда
		ТекстОшибки = НСтр("ru = 'Для внешнего отчета не найден соответствующий элемент.'");
		ЗаписатьВЖурналРегистрации(УровеньЖурналаРегистрации.Ошибка, ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	СвойстваКонфигурации.Вставить("ИсточникОтчета", Выборка.ИсточникОтчета);
	
	Если НЕ ВнешнийОтчетИспользовать Тогда 
		ОбъектСправочник = Выборка.Ссылка.ПолучитьОбъект();
		ОбъектСправочник.ВнешнийОтчетИспользовать = Ложь;
		ОбъектСправочник.Записать();
		ТекстДляЖурнала = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Внешний отчет ""%1"" вер. ""%2"" отключен.'"), Имя, СвойстваМанифеста["КраткаяВерсияВнешнегоОтчета"]);
		ЗаписатьВЖурналРегистрации(УровеньЖурналаРегистрации.Информация, ТекстДляЖурнала);
		Возврат;
	КонецЕсли;
	
	ИспользуетсяВнешнийОтчет = Выборка.ВнешнийОтчетИспользовать;
	
	Если ИспользуетсяВнешнийОтчет Тогда
		
		СвойстваКонфигурации.Вставить("КраткаяВерсияВнешнегоОтчета", Выборка.ВнешнийОтчетВерсия);
		
		// 4) сравнение версий манифеста выбранного и хранимого отчетов
		РезультатСравнениеВерсийХранимогоИЗагружаемогоОтчетов = 
		РегламентированнаяОтчетностьКлиентСервер.СравнитьКраткиеВерсииОтчетов(СвойстваКонфигурации["КраткаяВерсияВнешнегоОтчета"],
			СвойстваМанифеста["КраткаяВерсияВнешнегоОтчета"]);
		Если РезультатСравнениеВерсийХранимогоИЗагружаемогоОтчетов  = -1 Тогда // если загружаемый отчет старее хранимого
			ТекстОшибки = НСтр("ru = 'Не пройдена проверка на сравнение версий манифеста выбранного и хранимого отчетов'");
			ЗаписатьВЖурналРегистрации(УровеньЖурналаРегистрации.Информация, ТекстОшибки);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Попытка
		
		ФайлОтчета = ФайлОтчетаИзАрхива(КаталогРаспаковки);
		
		ОбъектОтчет = ВнешниеОтчеты.Создать(ФайлОтчета.ПолноеИмя, Истина, ОбщегоНазначения.ОписаниеЗащитыБезПредупреждений());
		
		АдресФайлаВоВременномХранилище = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ФайлОтчета.ПолноеИмя), Новый УникальныйИдентификатор);
		
	Исключение
		
		ЗаписатьВЖурналРегистрации(УровеньЖурналаРегистрации.Ошибка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат;
		
	КонецПопытки;
	
	ПолнаяВерсияВнешнегоОтчета = РегламентированнаяОтчетностьВызовСервера.ПолучитьВерсиюРегламентированногоОтчета(ОбъектОтчет);
	СвойстваПолнойВерсии = РегламентированнаяОтчетностьВызовСервера.РазложитьПолнуюВерсиюРегламентированногоОтчета(ПолнаяВерсияВнешнегоОтчета);
	
	СвойстваОтчета.Вставить("ИДКонфигурации", СвойстваПолнойВерсии.ИДКонфигурации);
	СвойстваОтчета.Вставить("ВерсияКонфигурации", СвойстваПолнойВерсии.ВерсияКонфигурации);
	СвойстваОтчета.Вставить("ИсточникОтчета", ОбъектОтчет.Метаданные().Имя);
	СвойстваОтчета.Вставить("КраткаяВерсияВнешнегоОтчета", СвойстваПолнойВерсии.КраткаяВерсия);
	
	// проверка на соответствие идентификатора конфигурации в отчете идентификатору конфигурации в текущем подключенном отчете
	Если СвойстваКонфигурации["ИДКонфигурации"] <> СвойстваОтчета["ИДКонфигурации"] Тогда
		ТекстОшибки = НСтр("ru = 'Не пройдена проверка на соответствие идентификатора конфигурации в отчете идентификатору конфигурации в текущем подключенном отчете'");
		ЗаписатьВЖурналРегистрации(УровеньЖурналаРегистрации.Ошибка, ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	// проверка на соответствие версии в отчете версии в текущем подключенном отчете, при условии, что подключен внешний
	Если ИспользуетсяВнешнийОтчет Тогда
		Если СвойстваОтчета["ВерсияКонфигурации"] <> СвойстваКонфигурации["ВерсияКонфигурации"] Тогда
			ТекстОшибки = НСтр("ru = 'Не пройдена проверка на соответствие версии в отчете версии в текущем подключенном отчете'");
			ЗаписатьВЖурналРегистрации(УровеньЖурналаРегистрации.Ошибка, ТекстОшибки);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	// проверка на соответствие имени метаданных отчета имени метаданных текущего подключенного отчета
	Если СвойстваОтчета["ИсточникОтчета"] <> СвойстваКонфигурации["ИсточникОтчета"] Тогда
		ТекстОшибки = НСтр("ru = 'Не пройдена проверка на имени метаданных отчета имени метаданных текущего подключенного отчета'");
		ЗаписатьВЖурналРегистрации(УровеньЖурналаРегистрации.Ошибка, ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	// сравнение версий выбранного и хранимого отчетов, при условии, что подключен внешний
	Если ИспользуетсяВнешнийОтчет Тогда
		РезультатСравнениеВерсийХранимогоИЗагружаемогоОтчетов = 
		РегламентированнаяОтчетностьКлиентСервер.СравнитьКраткиеВерсииОтчетов(СвойстваКонфигурации["КраткаяВерсияВнешнегоОтчета"], 
		СвойстваОтчета["КраткаяВерсияВнешнегоОтчета"]);
		Если РезультатСравнениеВерсийХранимогоИЗагружаемогоОтчетов  = -1 Тогда // если загружаемый отчет старее хранимого
			ТекстОшибки = НСтр("ru = 'Не пройдена проверка на сравнение версий выбранного и хранимого отчетов'");
			ЗаписатьВЖурналРегистрации(УровеньЖурналаРегистрации.Ошибка, ТекстОшибки);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	// Проверка пройдена успешно, загружаем отчет в ИБ
	Попытка
		ОбъектСправочник = Выборка.Ссылка.ПолучитьОбъект();
	Исключение
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Получение объекта отчета по ссылке из выборки.
			|Описание:
			|""%1""'"), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписатьВЖурналРегистрации(УровеньЖурналаРегистрации.Ошибка, ТекстОшибки);
		Возврат;
	КонецПопытки;
	
	Попытка
		
		ОбъектСправочник.ВнешнийОтчетИспользовать = Истина;
		
		ОбъектСправочник.ВнешнийОтчетХранилище = 
			Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресФайлаВоВременномХранилище), Новый СжатиеДанных(9));
		
		ОбъектСправочник.ВнешнийОтчетВерсия = СвойстваОтчета["КраткаяВерсияВнешнегоОтчета"];
		ОбъектСправочник.Записать();
		
		ТекстИнформации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Внешний отчет вер. ""%1"" успешно загружен.'"), СвойстваОтчета["КраткаяВерсияВнешнегоОтчета"]);
		
		ЗаписатьВЖурналРегистрации(УровеньЖурналаРегистрации.Информация, ТекстИнформации);
		
	Исключение
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Запись объекта отчета с новыми данными.
			|Описание:
			|""%1""'"), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписатьВЖурналРегистрации(УровеньЖурналаРегистрации.Ошибка, ТекстОшибки);
		
	КонецПопытки;
	
	Попытка
		УдалитьФайлы(КаталогРаспаковки);
	Исключение
	КонецПопытки;
	
КонецПроцедуры

Функция ПрочитатьМанифест(КаталогРаспаковки)
	
	ФайлМанифеста = КаталогРаспаковки + "ExternalManifest.xml";
	Чтение = Новый ЧтениеXML;
	Чтение.ОткрытьФайл(ФайлМанифеста);
	Чтение.ПерейтиКСодержимому();
	
	Если Чтение.ТипУзла <> ТипУзлаXML.НачалоЭлемента ИЛИ Чтение.Имя <> "Info" Тогда
		ВызватьИсключение(НСтр("ru = 'Ошибка чтения XML. Неверный формат файла. Ожидается начало элемента Info.'"));
	КонецЕсли;
	
	Если НЕ Чтение.Прочитать() Тогда
		ВызватьИсключение(НСтр("ru = 'Ошибка чтения XML. Обнаружено завершение файла.'"));
	КонецЕсли;
	
	Манифест = Новый Структура;
	
	ПостроительDOM = Новый ПостроительDOM;
	ДокументDOM = ПостроительDOM.Прочитать(Чтение);
	ТекстЗапроса = "//ns:ExternalReport";
	ВыражениеXPath = ДокументDOM.СоздатьВыражениеXPath(ТекстЗапроса,
		Новый РазыменовательПространствИменDOM("ns", "http://www.1c.ru/SaaS/ExternalReports"));
	РезультатXPath = ВыражениеXPath.Вычислить(ДокументDOM);
	УзелDOM = РезультатXPath.ПолучитьСледующий();
	Если УзелDOM <> Неопределено Тогда
		УзлыМанифеста = УзелDOM.ДочерниеУзлы;
		Для Каждого УзелМанифеста Из УзлыМанифеста Цикл
			Манифест.Вставить(УзелМанифеста.ИмяЭлемента, УзелМанифеста.ТекстовоеСодержимое);
		КонецЦикла;
	КонецЕсли;
	
	Чтение.Закрыть();
	
	Возврат ПроверитьМанифест(Манифест);
	
КонецФункции

Функция ПроверитьМанифест(Манифест)
	
	Если НЕ Манифест.Свойство("ИДКонфигурации") Тогда
		Манифест.Вставить("ИДКонфигурации", "");
	КонецЕсли;
	Если НЕ Манифест.Свойство("ВерсияКонфигурации") Тогда
		Манифест.Вставить("ВерсияКонфигурации", "");
	КонецЕсли;
	Если НЕ Манифест.Свойство("ИсточникОтчета") Тогда
		Манифест.Вставить("ИсточникОтчета", "");
	КонецЕсли;
	Если НЕ Манифест.Свойство("Версия") Тогда
		Манифест.Вставить("Версия", "");
	КонецЕсли;
	Если НЕ Манифест.Свойство("Имя") Тогда
		Манифест.Вставить("Имя", "");
	КонецЕсли;
	Если НЕ Манифест.Свойство("ВнешнийОтчетИспользовать") Тогда
		Манифест.Вставить("ВнешнийОтчетИспользовать", "true");
	КонецЕсли;
	
	Возврат Манифест;
	
КонецФункции

Процедура ЗаписатьВЖурналРегистрации(Уровень, ТекстОшибки)
	
	ЗаписьЖурналаРегистрации(ИмяСобытияВЖурналеРегистрации(), Уровень,,, ТекстОшибки);
	
КонецПроцедуры

Функция ИмяСобытияВЖурналеРегистрации()
	
	Возврат НСтр("ru = 'Поставляемые данные.Загрузка внешних регламентированных отчетов'");
	
КонецФункции

#КонецОбласти
﻿&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда
		
		//Создается новый объект
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Справочник не предназначен для ручного заполнения!'"));
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;

	Элементы.НадписьПомеченНаУдаление.Видимость = Объект.ПометкаУдаления;
	
	ОтчетСсылка = Объект.ОтчетСсылка;
	ТипЗнчСсылкаНаОтчет = ТипЗнч(ОтчетСсылка);
	ЭтоРеестрСведений = ДокументооборотСФССКлиентСервер.ЭтоРеестрСведенийНаВыплатуПособийФСС(ОтчетСсылка);
	ОбъектПоУмолчаниюРеестрЭЛНСуществует =
		Метаданные.Документы.Найти("РеестрДанныхЭЛНЗаполняемыхРаботодателем") <> Неопределено;
	ЭтоРеестрЭЛН = ДокументооборотСФССКлиентСервер.ЭтоРеестрДанныхЭЛНЗаполняемыхРаботодателем(ОтчетСсылка,
		ОбъектПоУмолчаниюРеестрЭЛНСуществует);
	ОбъектПоУмолчаниюРеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникамСуществует =
		Метаданные.Документы.Найти("РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам") <> Неопределено;
	ЭтоРеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам =
		ДокументооборотСФССКлиентСервер.ЭтоРеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам(ОтчетСсылка,
		ОбъектПоУмолчаниюРеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникамСуществует);
	
	Если ТипЗнчСсылкаНаОтчет = Тип("ДокументСсылка.РегламентированныйОтчет") Тогда
		ОтчетПредставление = Строка(РегламентированнаяОтчетностьКлиентСервер.ПредставлениеДокументаРеглОтч(ОтчетСсылка));
	ИначеЕсли ЭтоРеестрСведений ИЛИ ЭтоРеестрЭЛН ИЛИ ЭтоРеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам Тогда
		ОтчетПредставление = Строка(ОтчетСсылка);
	ИначеЕсли ТипЗнчСсылкаНаОтчет = Тип("СправочникСсылка.ЭлектронныеПредставленияРегламентированныхОтчетов") Тогда
		// электронное представление
		ОтчетПредставление = ОтчетСсылка.Наименование;
	Иначе
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ДатаОтправки = Объект.ДатаОтправки;
	ДатаЗакрытия = НСтр("ru = '<не завершена>'");
	ДатаОбновления = НСтр("ru = '<не определено>'");
	ОбновитьФорму();
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.СкрытьЭлементыФормыПриИспользованииОднойОрганизации(ЭтаФорма, "НадписьОрганизация");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтчетПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Объект.ОтчетСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьСтатусОтправкиНажатие(Элемент)
	
	КонтекстЭДОКлиент.ПоказатьПротоколОбработкиПоСсылкеИсточникаДляФСС(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьПервичноеСообщениеНажатие(Элемент)
	
	ВАрхиве = ОбъектВАрхиве(Объект.Ссылка, "ЗашифрованныйПакет");
	Если ВАрхиве Тогда 
		КонтекстЭДОКлиент.ПоказатьУведомлениеАрхивныхФайлов(, 15, 0, Истина);
		Возврат;
	КонецЕсли;
	
	Адрес = ПолучитьАдресФайлаПакета(Объект.Ссылка, УникальныйИдентификатор);
	ПолучитьФайл(Адрес, Объект.ИмяФайлаПакета);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбновитьЗавершение", ЭтотОбъект);
	КонтекстЭДОКлиент.ОбновитьРезультатКонкретнойОтправкиФСС(Объект.Ссылка, Ложь, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьПодписанныйПакет(Команда)
	
	ВАрхиве = ОбъектВАрхиве(Объект.Ссылка, "ПодписанныйПакет");
	Если ВАрхиве Тогда 
		КонтекстЭДОКлиент.ПоказатьУведомлениеАрхивныхФайлов(, 29, 0, Истина);
		Возврат;
	КонецЕсли;
	
	Адрес = ПолучитьАдресФайлаПодписанногоПакета(Объект.Ссылка, УникальныйИдентификатор);
	Если Адрес = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Отчет с подписью отсутствует.'"));
		Возврат;
	КонецЕсли;
	
	СвойстваФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(Объект.ИмяФайлаПакета);
	ПозицияРазделителя = СтрНайти(СвойстваФайла.ИмяБезРасширения, "_", НаправлениеПоиска.СКонца);
	ИмяФайлаПодписанногоПакета = ?(ПозицияРазделителя > 1, Лев(СвойстваФайла.ИмяБезРасширения, ПозицияРазделителя - 1),
		СвойстваФайла.ИмяБезРасширения) + СвойстваФайла.Расширение;
	ПолучитьФайл(Адрес, ИмяФайлаПодписанногоПакета);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьПакет(Команда)
	
	ВАрхиве = ОбъектВАрхиве(Объект.Ссылка, "ЗашифрованныйПакет");
	Если ВАрхиве Тогда 
		КонтекстЭДОКлиент.ПоказатьУведомлениеАрхивныхФайлов(, 15, 0, Истина);
		Возврат;
	КонецЕсли;
	
	Адрес = ПолучитьАдресФайлаПакета(Объект.Ссылка, УникальныйИдентификатор);
	ПолучитьФайл(Адрес, Объект.ИмяФайлаПакета);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьКвитанцию(Команда)
	
	ВАрхиве = ОбъектВАрхиве(Объект.Ссылка, "Квитанция");
	Если ВАрхиве Тогда 
		КонтекстЭДОКлиент.ПоказатьУведомлениеАрхивныхФайлов(, 1, 0, Истина);
		Возврат;
	КонецЕсли;
	
	ЭтоДанныеЭЛН = (Объект.ВидОтчета =
		ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.РеестрДанныхЭЛНЗаполняемыхРаботодателем"));
	ЭтоПодтверждениеВидаДеятельности = (Объект.ВидОтчета =
		ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ПодтверждениеВидаДеятельности"));
	ЭтоРеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам = (Объект.ВидОтчета =
		ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам"));
	
	Адрес = ПолучитьАдресФайлаКвитанции(Объект.Ссылка, УникальныйИдентификатор);
	ПолучитьФайл(Адрес, Объект.ИдентификаторОтправкиНаСервере
		+ ?(ЭтоДанныеЭЛН ИЛИ ЭтоПодтверждениеВидаДеятельности ИЛИ ЭтоРеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам,
		".xml", ".p7e"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьПакетКвитанции(Команда)
	
	ВАрхиве = ОбъектВАрхиве(Объект.Ссылка, "ПакетКвитанции");
	Если ВАрхиве Тогда 
		КонтекстЭДОКлиент.ПоказатьУведомлениеАрхивныхФайлов(, 30, 0, Истина);
		Возврат;
	КонецЕсли;
	
	Адрес = ПолучитьАдресФайлаПакетаКвитанции(Объект.Ссылка, УникальныйИдентификатор);
	Если Адрес = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Зашифрованная квитанция отсутствует.'"));
		Возврат;
	КонецЕсли;
	
	ПолучитьФайл(Адрес, НСтр("ru = 'Зашифрованная_квитанция'") + "_" + Объект.ИдентификаторОтправкиНаСервере + ".xml");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьПротокол(Команда)
	
	ВАрхиве = ОбъектВАрхиве(Объект.Ссылка, "Протокол");
	Если ВАрхиве Тогда 
		КонтекстЭДОКлиент.ПоказатьУведомлениеАрхивныхФайлов(, 16, 0, Истина);
		Возврат;
	КонецЕсли;
	
	Адрес = ПолучитьАдресФайлаПротокола(Объект.Ссылка, УникальныйИдентификатор);
	ПолучитьФайл(Адрес, НСтр("ru = 'Протокол'") + "_" + Объект.ИдентификаторОтправкиНаСервере + ".html");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеФормыНаСервере()
	
	Прочитать();
	ОбновитьФорму();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьФорму()
		
	ЦветСерый = Новый Цвет(128, 128, 128);
	ЦветСиний = Новый Цвет(0, 0, 255);
	
	ПустаяДата = Дата(1,1,1);
	
	ДатаОбновления = ?(Объект.ДатаПолученияРезультата = ПустаяДата, НСтр("ru = '<не определено>'"), Объект.ДатаПолученияРезультата);
	
	ЭтоДанныеЭЛН = (Объект.ВидОтчета =
		Справочники.ВидыОтправляемыхДокументов.РеестрДанныхЭЛНЗаполняемыхРаботодателем);
	ЭтоПодтверждениеВидаДеятельности = (Объект.ВидОтчета =
		Справочники.ВидыОтправляемыхДокументов.ПодтверждениеВидаДеятельности);
	ЭтоРеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам = (Объект.ВидОтчета =
		Справочники.ВидыОтправляемыхДокументов.РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам);
	
	Если Объект.СтатусОтправки = Перечисления.СтатусыОтправки.Отправлен Тогда
		Если ПротоколЗаполнен(Объект.Ссылка) Тогда
			Элементы.НадписьСтатусОтправки.Заголовок = НСтр("ru = 'Промежуточный протокол обработки получен'");
			Элементы.НадписьСтатусОтправки.ЦветТекста = ЦветСерый;
			Элементы.НадписьСтатусОтправки.ГиперСсылка = Истина;
		Иначе
			Элементы.НадписьСтатусОтправки.Заголовок = НСтр("ru = 'Протокол обработки пакета отсутствует'");
			Элементы.НадписьСтатусОтправки.ЦветТекста = ЦветСерый;
			Элементы.НадписьСтатусОтправки.ГиперСсылка = Ложь;
		КонецЕсли;
	Иначе
		Элементы.КартинкаПодтверждениеОтправки.Картинка = БиблиотекаКартинок.ЗеленыйШар;
		ДатаЗакрытия =  Объект.ДатаЗакрытия;
		
		Если Объект.СтатусОтправки = Перечисления.СтатусыОтправки.НеПринят Тогда
			Элементы.КартинкаСтатусОтправки.Картинка = БиблиотекаКартинок.РегламентированныйОтчетНеПринят;
			Элементы.НадписьСтатусОтправки.Заголовок = НСтр("ru = 'Протокол ошибок получен'");
			Элементы.НадписьСтатусОтправки.ЦветТекста = ЦветСиний;
			Элементы.НадписьСтатусОтправки.ГиперСсылка = Истина;
		ИначеЕсли Объект.СтатусОтправки = Перечисления.СтатусыОтправки.ПринятЕстьОшибки Тогда
			Элементы.КартинкаСтатусОтправки.Картинка = БиблиотекаКартинок.ПисьмоПодтверждениеПолучено;
			Элементы.НадписьСтатусОтправки.Заголовок = ?(ЭтоРеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам,
				НСтр("ru = 'Протокол о сдаче отчета с ошибками получен'"),
				НСтр("ru = 'Квитанция о сдаче отчета получена, протокол ошибок получен'"));
			Элементы.НадписьСтатусОтправки.ЦветТекста = ЦветСиний;
			Элементы.НадписьСтатусОтправки.ГиперСсылка = Истина;
		ИначеЕсли Объект.СтатусОтправки = Перечисления.СтатусыОтправки.Сдан Тогда
			Элементы.КартинкаСтатусОтправки.Картинка = БиблиотекаКартинок.ПисьмоПодтверждениеПолучено;
			Элементы.НадписьСтатусОтправки.Заголовок =
				?(ЭтоДанныеЭЛН ИЛИ ЭтоПодтверждениеВидаДеятельности ИЛИ ЭтоРеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам,
				НСтр("ru = 'Протокол о сдаче отчета получен'"), НСтр("ru = 'Квитанция о сдаче отчета получена'"));
			Элементы.НадписьСтатусОтправки.ЦветТекста = ЦветСиний;
			Элементы.НадписьСтатусОтправки.ГиперСсылка = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьМеню();
КонецПроцедуры

&НаСервере
Процедура ОбновитьМеню()
	
	КнопкаВыгрузитьКвитанцию 		= Элементы.Найти("ФормаВыгрузитьКвитанцию");
	КнопкаВыгрузитьПротокол 		= Элементы.Найти("ФормаВыгрузитьПротокол");
	КнопкаВыгрузитьПодписанныйПакет = Элементы.Найти("ФормаВыгрузитьПодписанныйПакет");
	КнопкаВыгрузитьПакетКвитанции 	= Элементы.Найти("ФормаВыгрузитьПакетКвитанции");
	
	ЭтоДанныеЭЛН = (Объект.ВидОтчета =
		Справочники.ВидыОтправляемыхДокументов.РеестрДанныхЭЛНЗаполняемыхРаботодателем);
	ЭтоПодтверждениеВидаДеятельности = (Объект.ВидОтчета =
		Справочники.ВидыОтправляемыхДокументов.ПодтверждениеВидаДеятельности);
	ЭтоРеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам = (Объект.ВидОтчета =
		Справочники.ВидыОтправляемыхДокументов.РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам);
	ЭтоПодписьИШифрованиеSOAP = ЭтоДанныеЭЛН ИЛИ ЭтоПодтверждениеВидаДеятельности
		ИЛИ ЭтоРеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам;
	
	Если Объект.СтатусОтправки = Перечисления.СтатусыОтправки.Отправлен Тогда
		КнопкаВыгрузитьКвитанцию.Видимость 			= ЭтоПодписьИШифрованиеSOAP;
		КнопкаВыгрузитьПротокол.Видимость 			= ЭтоПодписьИШифрованиеSOAP;
		КнопкаВыгрузитьПодписанныйПакет.Видимость 	= ЭтоПодписьИШифрованиеSOAP;
		КнопкаВыгрузитьПакетКвитанции.Видимость 	= ЭтоПодписьИШифрованиеSOAP;
	ИначеЕсли Объект.СтатусОтправки = Перечисления.СтатусыОтправки.НеПринят Тогда
		КнопкаВыгрузитьКвитанцию.Видимость 			= ЭтоПодписьИШифрованиеSOAP;
		КнопкаВыгрузитьПротокол.Видимость 			= Истина;
		КнопкаВыгрузитьПодписанныйПакет.Видимость 	= ЭтоПодписьИШифрованиеSOAP;
		КнопкаВыгрузитьПакетКвитанции.Видимость 	= ЭтоПодписьИШифрованиеSOAP;
	ИначеЕсли Объект.СтатусОтправки = Перечисления.СтатусыОтправки.Сдан 
		ИЛИ Объект.СтатусОтправки = Перечисления.СтатусыОтправки.ПринятЕстьОшибки Тогда
		КнопкаВыгрузитьКвитанцию.Видимость 			= Истина;
		КнопкаВыгрузитьПротокол.Видимость 			= Истина;
		КнопкаВыгрузитьПодписанныйПакет.Видимость 	= ЭтоПодписьИШифрованиеSOAP;
		КнопкаВыгрузитьПакетКвитанции.Видимость 	= ЭтоПодписьИШифрованиеSOAP;
	КонецЕсли;
	
	//кнопка Обновить
	КнопкаОбновить = Элементы.Найти("ФормаОбновить");
	КнопкаОбновить.Видимость = НЕ ЭтоДанныеЭЛН;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОбновитьДанныеФормыНаСервере();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьАдресФайлаПодписанногоПакета(ОтправкаСсылка, Знач УникальныйИдентификаторФормы)
	
	ДанныеПодписанногоПакета = ОтправкаСсылка.ПодписанныйПакет.Получить();
	Возврат ?(ДанныеПодписанногоПакета = Неопределено, Неопределено,
		ПоместитьВоВременноеХранилище(ДанныеПодписанногоПакета, УникальныйИдентификаторФормы));
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьАдресФайлаПакета(ОтправкаСсылка, Знач УникальныйИдентификаторФормы)
	
	ДанныеЗашифрованногоПакета = ОтправкаСсылка.ЗашифрованныйПакет.Получить();
	Возврат ПоместитьВоВременноеХранилище(ДанныеЗашифрованногоПакета, УникальныйИдентификаторФормы);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьАдресФайлаПротокола(ОтправкаСсылка, Знач УникальныйИдентификаторФормы)
	
	СтрПротокол = ОтправкаСсылка.Протокол.Получить();
	ВременныйФайл = ПолучитьИмяВременногоФайла();
	Текст = Новый ЗаписьТекста(ВременныйФайл, КодировкаТекста.UTF8);
	Текст.Записать(СтрПротокол);
	Текст.Закрыть();
	
	ДанныеПротокола = Новый ДвоичныеДанные(ВременныйФайл);
	Результат = ПоместитьВоВременноеХранилище(ДанныеПротокола, УникальныйИдентификаторФормы);
	
	ОперацииСФайламиЭДКО.УдалитьВременныйФайл(ВременныйФайл);
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьАдресФайлаКвитанции(ОтправкаСсылка, Знач УникальныйИдентификаторФормы)
	
	ДанныеКвитанции = ОтправкаСсылка.Квитанция.Получить();
	Возврат ПоместитьВоВременноеХранилище(ДанныеКвитанции, УникальныйИдентификаторФормы);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьАдресФайлаПакетаКвитанции(ОтправкаСсылка, Знач УникальныйИдентификаторФормы)
	
	ДанныеПакетаКвитанции = ОтправкаСсылка.ПакетКвитанции.Получить();
	Возврат ?(ДанныеПакетаКвитанции = Неопределено, Неопределено,
		ПоместитьВоВременноеХранилище(ДанныеПакетаКвитанции, УникальныйИдентификаторФормы));
	
КонецФункции

&НаСервереБезКонтекста
Функция ПротоколЗаполнен(ОтправкаСсылка)
	
	Возврат ЗначениеЗаполнено(ОтправкаСсылка.Протокол.Получить());
	
КонецФункции

&НаСервереБезКонтекста
Функция ОбъектВАрхиве(Знач ОбъектОтправки, Знач ИмяФайла)
	
	КонтекстМодуля = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	Возврат КонтекстМодуля.ОбъектВАрхиве(ОбъектОтправки, ИмяФайла);
	
КонецФункции

#КонецОбласти


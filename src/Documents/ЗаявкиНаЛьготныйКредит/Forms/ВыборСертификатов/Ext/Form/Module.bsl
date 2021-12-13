﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Инициализация(Параметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьТекущийСертификат();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СертификатыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбратьСертификат(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КоманднаяПанельСертификатыПоказать(Команда = Неопределено)
	
	ПоказатьСертификат()

КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельФормыВыбрать(Кнопка)
	
	ТекДанные = Элементы.Сертификаты.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		ПоказатьПредупреждение(, "Выберите сертификат!");
		Возврат;
	КонецЕсли;
	
	ВыбратьСертификат();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура Инициализация(Параметры)
	
	Отпечаток = Параметры.Отпечаток;
	ИНН       = Параметры.ИНН;
	Адрес     = Параметры.Адрес;
	
	ТаблицаНужныеСертификаты = ПолучитьИзВременногоХранилища(Адрес);
	Для каждого ТекущийСертфикат Из ТаблицаНужныеСертификаты Цикл
		НовыйСертификат = НужныеСертификаты.Добавить();
		ЗаполнитьЗначенияСвойств(НовыйСертификат, ТекущийСертфикат);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСертификат()
	
	ТекДанные = Элементы.Сертификаты.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите в таблице сертификат для показа.'"));
	Иначе
		СертификатДляПоказа = Новый Структура("СерийныйНомер, Поставщик", ТекДанные.СерийныйНомер, ТекДанные.Поставщик);
		КриптографияЭДКОКлиент.ПоказатьСертификат(СертификатДляПоказа);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекущийСертификат()
	
	// активизируем начальные значения выбора
	ТекСертСтроки = НужныеСертификаты.НайтиСтроки(Новый Структура("Отпечаток", Отпечаток));
	Если ТекСертСтроки.Количество() > 0 Тогда
		Для Каждого Стр Из ТекСертСтроки Цикл
			Элементы.Сертификаты.ТекущаяСтрока = Стр.ПолучитьИдентификатор();
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСертификат(парамМножественныйВыбор = Неопределено)
	
	Если Элементы.Сертификаты.ТекущаяСтрока <> Неопределено Тогда
		Закрыть(СвойстваСертификата(Элементы.Сертификаты.ТекущиеДанные));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СвойстваСертификата(ТекДанные)
	
	СвойстваСертификата = Новый Структура;
	СвойстваСертификата.Вставить("ДействителенС",			ТекДанные.ДействителенС);
	СвойстваСертификата.Вставить("ДействителенПо",			ТекДанные.ДействителенПо);
	СвойстваСертификата.Вставить("Отпечаток",				ТекДанные.Отпечаток);
	СвойстваСертификата.Вставить("Поставщик",				ТекДанные.Поставщик);
	СвойстваСертификата.Вставить("СерийныйНомер",			ТекДанные.СерийныйНомер);
	СвойстваСертификата.Вставить("Владелец",				ТекДанные.Владелец);
	СвойстваСертификата.Вставить("Наименование",			ТекДанные.Наименование);
	СвойстваСертификата.Вставить("ВозможностьПодписи",		ТекДанные.ПригоденДляПодписания);
	СвойстваСертификата.Вставить("ВозможностьШифрования",	ТекДанные.ПригоденДляШифрования);
	СвойстваСертификата.Вставить("ПоставщикСтруктура",		ТекДанные.ПоставщикСтруктура);
	СвойстваСертификата.Вставить("ВладелецСтруктура",		ТекДанные.ВладелецСтруктура);
	СвойстваСертификата.Вставить("ЭтоЭлектроннаяПодписьВМоделиСервиса",	ТекДанные.ЭтоЭлектроннаяПодписьВМоделиСервиса);
	
	Возврат СвойстваСертификата;
	
КонецФункции

#КонецОбласти


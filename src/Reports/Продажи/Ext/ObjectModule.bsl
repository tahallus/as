﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Задать настройки формы отчета.
//
// Параметры:
//  Форма		 - ФормаКлиентскогоПриложения	 - Форма отчета
//  КлючВарианта - Строка						 - Ключ загружаемого варианта
//  Настройки	 - Структура					 - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт

	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПриЗагрузкеВариантаНаСервере = Истина;
	Настройки.События.ПриЗагрузкеПользовательскихНастроекНаСервере = Истина;
	Настройки.Вставить("ИспользоватьСравнение", Истина);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

// Процедура - Обработчик заполнения настроек отчета и варианта
//
// Параметры:
//  НастройкиОтчета		 - Структура - Настройки отчета, подробнее см. процедуру ОтчетыУНФ.ИнициализироватьНастройкиОтчета 
//  НастройкиВариантов	 - Структура - Настройки варианта отчета, подробнее см. процедуру ОтчетыУНФ.ИнициализироватьНастройкиВарианта
//
Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиВариантов["Основной"].ИмяМакетаОбразца = "ОбразецПродажи";
	УстановитьТегиВариантов(НастройкиВариантов);
	ДобавитьОписанияСвязанныхПолей(НастройкиВариантов);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	ОтчетыУНФ.ФормаОтчетаПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

// Обработчик события ПриЗагрузкеВариантаНаСервере
//
// Параметры:
//  Форма			 - ФормаКлиентскогоПриложения	 - Форма отчета
//  НовыеНастройкиКД - НастройкиКомпоновкиДанных	 - Загружаемые настройки КД
//
Процедура ПриЗагрузкеВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	
	ОтчетыУНФ.ПреобразоватьСтарыеНастройки(Форма, НовыеНастройкиКД);	
	РаботаССегментами.ОпределитьВидимостьОтбораПоСегментуВОтчете(Форма);
	ОтчетыУНФ.ОбновитьВидимостьОтбораОрганизация(Форма.Отчет.КомпоновщикНастроек);	
	ОтчетыУНФ.ФормаОтчетаПриЗагрузкеВариантаНаСервере(Форма, НовыеНастройкиКД);
	
КонецПроцедуры

// Обработчик события ПриЗагрузкеПользовательскихНастроекНаСервере
//
// Параметры:
//  Форма							 - ФормаКлиентскогоПриложения				 - Форма отчета
//  НовыеПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных - Загружаемые пользовательские настройки КД
//
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Форма, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ОтчетыУНФ.ПеренестиПараметрыЗаголовкаВНастройки(КомпоновщикНастроек.Настройки, НовыеПользовательскиеНастройкиКД);	
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	УстановитьЗаголовокКолонкиВыручка();
	
	ОтчетыУНФ.ДобавитьСимволВалютыКЗаголовкамПолей(СхемаКомпоновкиДанных, "Себестоимость,Сумма,СуммаНДС,ВаловаяПрибыль");
	
	// Наборы
	МодифицироватьСхемуПродажаНаборов();
	// Конец Наборы
	
	ОтчетыУНФ.ОбъединитьСПользовательскимиНастройками(КомпоновщикНастроек);
	ОтчетыУНФ.ПриКомпоновкеРезультата(КомпоновщикНастроек, СхемаКомпоновкиДанных, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	НастройкиВариантов["Основной"].Теги = НСТР("ru = 'Главное,Продажи,CRM,Номенклатура,Выручка'");
	НастройкиВариантов["ВаловаяПрибыль"].Теги = НСТР("ru = 'Главное,Продажи,CRM,Номенклатура,Выручка,Себестоимость,Прибыль,Рентабельность,Маржа'");
	НастройкиВариантов["ВаловаяПрибыльПоКатегориямНоменклатуры"].Теги = НСТР("ru = 'Продажи,CRM,Категории,Выручка,Себестоимость,Прибыль,Рентабельность,Маржа'");
	НастройкиВариантов["ВаловаяПрибыльПоПокупателям"].Теги = НСТР("ru = 'Продажи,CRM,Контрагенты,Покупатели,Выручка,Себестоимость,Прибыль,Рентабельность,Маржа'");
	НастройкиВариантов["ВаловаяПрибыльПоМенеджерам"].Теги = НСТР("ru = 'Продажи,CRM,Менеджеры,Выручка,Себестоимость,Прибыль,Рентабельность,Маржа'");
	НастройкиВариантов["ДинамикаПродаж"].Теги = НСТР("ru = 'Продажи,CRM'");
	НастройкиВариантов["ДинамикаПродажПоНоменклатуре"].Теги = НСТР("ru = 'Продажи,CRM,Выручка,Номенклатура'");
	НастройкиВариантов["ДинамикаПродажПоКатегориямНоменклатуры"].Теги = НСТР("ru = 'Продажи,Выручка,Категории'");
	НастройкиВариантов["ДинамикаПродажПоПокупателям"].Теги = НСТР("ru = 'Продажи,CRM,Выручка,Контрагенты,Покупатели'");
	НастройкиВариантов["ДинамикаПродажПоМенеджерам"].Теги = НСТР("ru = 'Продажи,CRM,Выручка,Менеджеры'");
	НастройкиВариантов["ПродажиНашимОрганизациям"].Теги = НСТР("ru = 'Продажи,CRM,Передача,Интеркампани,Взаимозависимые'");
	НастройкиВариантов["ПродажиБезВнутрифирменныхПродаж"].Теги = НСТР("ru = 'Продажи,CRM,Передача,Интеркампани,Взаимозависимые'");
	
КонецПроцедуры

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)
	
	СтруктураВарианта = НастройкиВариантов["ПродажиКонтекст"];
	ОтчетыУНФ.ДобавитьОписаниеПривязки(СтруктураВарианта.СвязанныеПоля, "Контрагент", "Справочник.Контрагенты",,, Истина);
	ОтчетыУНФ.ДобавитьОписаниеПривязки(СтруктураВарианта.СвязанныеПоля, "Номенклатура", "Справочник.Номенклатура",,, Истина);
	ОтчетыУНФ.ДобавитьОписаниеПривязки(СтруктураВарианта.СвязанныеПоля, "ЗаказПокупателя", "Документ.ЗаказПокупателя",,, Истина);
	СтруктураВарианта = НастройкиВариантов["ВаловаяПрибыль"];
	ОтчетыУНФ.ДобавитьОписаниеПривязки(СтруктураВарианта.СвязанныеПоля, "Документ", "Документ.ЧекККМ",,, Истина);
	ОтчетыУНФ.ДобавитьОписаниеПривязки(СтруктураВарианта.СвязанныеПоля, "Документ", "Документ.ОтчетОРозничныхПродажах",,, Истина);
	
КонецПроцедуры

Процедура УстановитьЗаголовокКолонкиВыручка()
	
	ПараметрТолькоВозвраты = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ТолькоВозвраты"));
	Если Не ПараметрТолькоВозвраты.Значение Тогда
		Возврат;
	КонецЕсли;
	
	ПолеСумма = СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Поля.Найти("Сумма");
	ПолеСумма.Заголовок = НСтр("ru = 'Сумма'");
	
КонецПроцедуры

Процедура МодифицироватьСхемуПродажаНаборов()
	
	Группировка = ОтчетыУНФКлиентСервер.НайтиПолеРекурсивно(Новый ПолеКомпоновкиДанных("НоменклатураНабора"), КомпоновщикНастроек.Настройки.Структура);
	Если Группировка = Неопределено Тогда
		КУдалению = Новый Массив;
		Для каждого Поле Из СхемаКомпоновкиДанных.ПоляИтога Цикл
			Если Поле.ПутьКДанным="Количество" Тогда
				Если Поле.Группировки.Количество()>0 Тогда
					Поле.Группировки.Очистить();
				Иначе
					КУдалению.Добавить(Поле);
				КонецЕсли; 
			КонецЕсли; 
		КонецЦикла;
		Для каждого Поле Из КУдалению Цикл
			СхемаКомпоновкиДанных.ПоляИтога.Удалить(Поле);
		КонецЦикла; 
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ЭтоОтчетУНФ = Истина;

#КонецОбласти 

#КонецЕсли

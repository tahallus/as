﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	ЗаполнитьВременныеРеквизиты();

	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтаФорма);
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);
	
	ПрослеживаемостьСобытияФормПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	ПроверитьПолучениеОтветаОтФНС();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Документ.УведомлениеОбОстаткахПрослеживаемыхТоваров.Форма.ФормаВыбора" Тогда
		
		Объект.ДокументУведомлениеОбОстатках = ВыбранноеЗначение;
		ЗаполнитьДокументНаСервере();
		
	Иначе
		ПрослеживаемостьФормыКлиент.ОбработкаВыбораУведомления(ЭтотОбъект, ВыбранноеЗначение, ИсточникВыбора);
		
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Завершение отправки в контролирующий орган" 
		ИЛИ ИмяСобытия = "Завершение отправки" Тогда
		
		ПроверитьПолучениеОтветаОтФНС();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПодготовитьФормуНаСервере();
	
	ПрослеживаемостьСобытияФормПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.НомерКорректировки = 0 Тогда
		
		Отказ = Истина;
		ТекстИсключения = НСтр("ru = 'Корректировку c №0 вводить нельзя!'");
		
		ВызватьИсключение(ТекстИсключения);
		
	КонецЕсли;
	
	ПрослеживаемостьФормыКлиент.ПроверитьСоответствиеРеквизитовВШапкеИТабличнойЧасти(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
	ПрослеживаемостьСобытияФормКлиентПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Оповестить("Запись_УведомлениеОбОстаткахПрослеживаемыхТоваров", ПараметрыЗаписи, Объект.Ссылка);
	
	ПрослеживаемостьСобытияФормКлиентПереопределяемый.ПослеЗаписи(ЭтотОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПрослеживаемостьБРУ.УстановитьЗаголовокФормыУведомлениеОбОстатках(ЭтотОбъект);
	
	ПрослеживаемостьБРУ.СохранитьСтатусОтправки(ЭтотОбъект);
	
	УстановитьСостояниеДокумента();
	ЗаполнитьВременныеРеквизиты();
	
	ПрослеживаемостьСобытияФормПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЗаполнитьПризнакПолученияОтветаотФНС(Команда)
	
	Объект.ПолученоПодтверждениеИзФНС = Истина;
	ПроверитьПолучениеОтветаОтФНС();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолученоПодтверждениеИзФНСПриИзменении(Элемент)
	
	ПроверитьПолучениеОтветаОтФНС();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьОснование(Команда)

	СтруктураПараметров = Новый Структура("Организация, РНПТЗаполнен", Объект.Организация, Истина);
	ОткрытьФорму("Документ.УведомлениеОбОстаткахПрослеживаемыхТоваров.Форма.ФормаВыбора",
		СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьДокументОснованиеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Ключ", Объект.ДокументУведомлениеОбОстатках);
	
	ОткрытьФорму("Документ.УведомлениеОбОстаткахПрослеживаемыхТоваров.Форма.ФормаДокументаОсновная",
		ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КодТНВЭДПослеИзмененияПриИзменении(Элемент)
	
	КодТНВЭДПослеИзмененияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура КодТНВЭДПослеИзмененияПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.КодТНВЭДПослеИзменения) Тогда
		
		Объект.ЕдиницаПрослеживаемостиПослеИзменения = 
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.КодТНВЭДПослеИзменения, "ЕдиницаИзмерения");
		
	Иначе
		
		Объект.ЕдиницаПрослеживаемостиПослеИзменения = Справочники.КлассификаторТНВЭД.ПустаяСсылка();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьДополнительныеРеквизитыНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Форма = ЭтотОбъект;
	
	Если НЕ Форма.ТолькоПросмотр Тогда
		Форма.ЗаблокироватьДанныеФормыДляРедактирования();
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ТолькоПросмотр",        Форма.ТолькоПросмотр);
	ПараметрыФормы.Вставить("ИННДоРеорганизации",    Объект.ИННДоРеорганизации);
	ПараметрыФормы.Вставить("КППДоРеорганизации",    Объект.КППДоРеорганизации);
	ПараметрыФормы.Вставить("ФормаОткрытаИзКорректировочногоУведомления",  Истина);
	// Признак уведомления - признак после изменения
	ПараметрыФормы.Вставить("ПризнакУведомления",    Объект.ПризнакУведомления);
	ПараметрыФормы.Вставить("ПризнакУведомленияДоИзменения", Объект.ПризнакУведомленияДоИзменения);
	ПараметрыФормы.Вставить("КодФормыРеорганизации", Объект.КодФормыРеорганизации);
	ПараметрыФормы.Вставить("Продавцы", Объект.Продавцы);
	
	ОткрытьФорму(
		"Документ.УведомлениеОбОстаткахПрослеживаемыхТоваров.Форма.ФормаДополнительныхСведений",
		ПараметрыФормы, 
		Форма
	);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыЗаполнитьПоПоследнемуДокументу(Команда)
	
	Если Объект.Товары.Количество() > 0 Тогда
		
		ТекстВопроса = НСтр("ru = 'При заполнении табличная часть будет очищена. Заполнить?'");
	
		Оповещение = Новый ОписаниеОповещения("ТоварыОбработкаЗаполненияЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
		
	Иначе
		
		ЗаполнитьПоПоследнемуДокументу();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыОбработкаЗаполненияЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт

	Если РезультатВыбора = КодВозвратаДиалога.Да Тогда
		
		ЗаполнитьПоПоследнемуДокументу();

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыгрузитьУведомлениеВXML(Команда)
	
	ВыгрузитьКорректировочноеУведомлениеОбОстатках();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтаФорма);
	
КонецПроцедуры

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтаФорма, "ФНС");
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтаФорма, "ФНС");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(
		ЭтаФорма, "ФНС");
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтаФорма, "ФСС");
	
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтаФорма, "ФСС");
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНаименованиеЭтапаНажатие(Элемент)
	
	ПараметрыИзменения = Новый Структура;
	ПараметрыИзменения.Вставить("Форма", ЭтотОбъект);
	ПараметрыИзменения.Вставить("Организация", Объект.Организация);
	ПараметрыИзменения.Вставить("КонтролирующийОрган",
		ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФНС"));
	ПараметрыИзменения.Вставить("ТекстВопроса", НСтр("ru='Вы уверены, что уведомление уже сдано?'"));
	
	ИнтерфейсыВзаимодействияБРОКлиент.ИзменитьСтатусОтправки(ПараметрыИзменения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПроверитьПолучениеОтветаОтФНС() 

	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СтатусыОтправки.Статус КАК Статус
	|ИЗ
	|	РегистрСведений.СтатусыОтправки КАК СтатусыОтправки
	|ГДЕ
	|	СтатусыОтправки.Объект = &Объект";
	
	Запрос.УстановитьПараметр("Объект", Объект.Ссылка);
	
	Выбор = Запрос.Выполнить().Выбрать();
	
	СтатусОтправки = Перечисления.СтатусыОтправки.ПустаяСсылка();
	
	Если Выбор.Следующий() Тогда
		
		СтатусОтправки = Выбор.Статус;
		
	КонецЕсли;
	
	Если Объект.ПолученоПодтверждениеИзФНС
		ИЛИ НЕ СтатусОтправки = Перечисления.СтатусыОтправки.Сдан Тогда
		
		Элементы.ГруппаПанельСообщений.Видимость = Ложь;
		
		Возврат;
		
	КонецЕсли;
	
	Элементы.ГруппаПанельСообщений.Видимость = Истина;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоПоследнемуДокументу();

	Если Объект.Ссылка.Пустая() Тогда
		Записать();
	ИначеЕсли Объект.Проведен Тогда
		Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.ОтменаПроведения));
	КонецЕсли;
	
	ТаблицаТоваров = Документы.УведомлениеОбОстаткахПрослеживаемыхТоваров.ЗаполнитьДокументДанными(
			Объект.Дата, Объект.Организация, Объект.ДокументУведомлениеОбОстатках, Объект.Ссылка).Товары;
	
	Объект.Товары.Загрузить(ТаблицаТоваров);
	
	ЗаполнитьВременныеРеквизиты();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьКорректировочноеУведомлениеОбОстатках()
	
	Если Модифицированность
		ИЛИ НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Записать();
	КонецЕсли;
	
	ПрослеживаемостьКлиент.ВыгрузитьВФайлУведомлениеПоПрослеживаемости(Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ДобавитьУсловноеОформлениеЗначениеОтличается(
		ЭтотОбъект, "КодТНВЭДПослеИзменения", "Объект.КодТНВЭД", "Объект.КодТНВЭДПослеИзменения");
		
	ДобавитьУсловноеОформлениеЗначениеОтличается(
		ЭтотОбъект, "КодОКПД2ПослеИзменения", "Объект.КодОКПД2", "Объект.КодОКПД2ПослеИзменения");
		
	ДобавитьУсловноеОформлениеЗначениеОтличается(
		ЭтотОбъект, "ЕдиницаИзмеренияПослеИзменения", "Объект.ЕдиницаИзмерения", "Объект.ЕдиницаИзмеренияПослеИзменения");
		
	ДобавитьУсловноеОформлениеЗначениеОтличается(
		ЭтотОбъект, "ЕдиницаПрослеживаемостиПослеИзменения", "Объект.ЕдиницаПрослеживаемости",
			"Объект.ЕдиницаПрослеживаемостиПослеИзменения");
		
	// ТоварыКомиссионерПослеИзменения

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТоварыКомиссионерПослеИзменения");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Товары.КомиссионерПослеИзменения", ВидСравненияКомпоновкиДанных.НеЗаполнено);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Выбор комиссионера>'"));
		
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьУсловноеОформлениеЗначениеОтличается(Форма, ОформляемоеПоле, ПутьКРеквизитуУсловияЛево, 
		ПутьКРеквизитуУсловияПраво)
	
	ЭлементУО = Форма.УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, ОформляемоеПоле);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		ПутьКРеквизитуУсловияЛево, ВидСравненияКомпоновкиДанных.Равно, 
		Новый ПолеКомпоновкиДанных(ПутьКРеквизитуУсловияПраво));
		
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста, , , Ложь));
	
	ЭлементУО = Форма.УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, ОформляемоеПоле);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		ПутьКРеквизитуУсловияЛево, ВидСравненияКомпоновкиДанных.НеРавно, 
		Новый ПолеКомпоновкиДанных(ПутьКРеквизитуУсловияПраво));
		
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста, , , Истина));
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Если Не ЗначениеЗаполнено(Объект.ДатаСоздания) Тогда
		Объект.ДатаСоздания = ТекущаяДата();
	КонецЕсли;
	
	ПрослеживаемостьБРУ.УстановитьЗаголовокФормыУведомлениеОбОстатках(ЭтотОбъект);
	
	ИспользуетсяОтправкаОтчетовЧерез1СОтчетность = 
		ИнтерфейсыВзаимодействияБРО.ПодключенДокументооборотСКонтролирующимОрганом(
								Объект.Организация, Перечисления.ТипыКонтролирующихОрганов.ФНС, Ложь);
	
	УстановитьСостояниеДокумента();
	
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВременныеРеквизиты()
	
	ЭтотОбъект.НадписьСтароеЗначение = НСтр("ru = 'Старое значение'");
	ЭтотОбъект.НадписьНовоеЗначение     = НСтр("ru = 'Новое значение'");
	
	НадписьДоИзменения = НСтр("ru = 'до изменения'");
	НадписьПослеИзменения = НСтр("ru = 'после изменения'");
	
	Для каждого ТекущаяСтрока Из Объект.Товары Цикл
		
		ТекущаяСтрока.НадписьДоИзменения = НадписьДоИзменения;
		ТекущаяСтрока.НадписьПослеИзменения = НадписьПослеИзменения;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Форма.НадписьДокументОснование = ТекстДокументаДляПреставления(Объект.ДокументУведомлениеОбОстатках);
	
	Элементы.ПолученоПодтверждениеИзФНСРучное.Видимость = НЕ Форма.ИспользуетсяОтправкаОтчетовЧерез1СОтчетность;
	
	Элементы.ТоварыЗаполнитьПоПоследнемуДокументу.Доступность = НЕ Объект.ПолученоПодтверждениеИзФНС;
	
	СтруктураДополнительныхРеквизитов = Новый Структура("ПризнакУведомления,КодФормыРеорганизации",
		Объект.ПризнакУведомления, Объект.КодФормыРеорганизации);
	
	Форма.НадписьДополнительныеСведения = 
		ПрослеживаемостьФормыВызовСервера.ТекстДополнительныеСведения(СтруктураДополнительныхРеквизитов);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТекстДокументаДляПреставления(Документ)
	
	Возврат ПрослеживаемостьПереопределяемый.ПредставлениеДокумента(Документ);
	
КонецФункции

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	ПрослеживаемостьПереопределяемый.УстановитьСостояниеДокумента(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДокументНаСервере();

	ДанныеТаблиц = Документы.УведомлениеОбОстаткахПрослеживаемыхТоваров.ЗаполнитьДокументДанными(
			Объект.Дата, Объект.Организация, Объект.ДокументУведомлениеОбОстатках);

	ЗаполнитьЗначенияСвойств(Объект, 
		?(ДанныеТаблиц.Реквизиты.Количество()>0, ДанныеТаблиц.Реквизиты[0], Новый ТаблицаЗначений)
		,, "ДокументУведомлениеОбОстатках,Организация");
	
	Объект.Товары.Загрузить(ДанныеТаблиц.Товары);
	
КонецПроцедуры

#КонецОбласти

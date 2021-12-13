﻿#Область СобытияФормИСМПКлиентПереопределяемый

// Клиентская переопределяемая процедура, вызываемая из обработчика события элемента.
//
// Параметры:
//   Форма                   - УправляемаяФорма - форма, из которой происходит вызов процедуры.
//   Элемент                 - Строка           - имя элемента-источника события "При изменении"
//   ДополнительныеПараметры - Структура        - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	Если Форма.ИмяФормы = "Документ.РасходнаяНакладная.Форма.ФормаДокумента"
		ИЛИ Форма.ИмяФормы = "Документ.ПриходнаяНакладная.Форма.ФормаДокумента" Тогда
		
		Если Элемент = Форма.Элементы.Запасы Тогда
			
			Если Форма.Элементы.Найти("ЗапасыМаркируемаяПродукция") = Неопределено Тогда
				Возврат;
			КонецЕсли;
			
			ТекущаяСтрока = Форма.Элементы.Запасы.ТекущиеДанные;
			Если ТекущаяСтрока = Неопределено Тогда
				Возврат;
			КонецЕсли;
			
			НужноПересчитатьКеш = ПроверкаИПодборПродукцииИСКлиент.ПрименитьКешПоСтроке(
				Форма,
				Форма.Объект.Запасы,
				ТекущаяСтрока,
				Форма.ЗапасыКешТекущейСтроки);
			
			Если НужноПересчитатьКеш Тогда
				ДополнительныеПараметры.Вставить("ТребуетсяСерверныйВызов");
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник, ДополнительныеПараметры) Экспорт
	
	Если СтрНачинаетсяС(ИмяСобытия, "ЗакрытиеФормыПроверкиИПодбораГосИС") Тогда
		ДополнительныеПараметры.СтандартнаяОбработка = Ложь;
		Если Источник = Форма.УникальныйИдентификатор Тогда
			ДополнительныеПараметры.ТребуетсяСерверныйВызов = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// В процедуре нужно реализовать алгоритм заполнения формы данными из ТСД.
//
// Параметры:
//  ОписаниеОповещения - ОписаниеОповещения - процедура, которую нужно вызвать после заполнения данных формы,
//  Форма - УправляемаяФорма - форма, данные в которой требуется заполнить,
//  РезультатВыполнения - (См. МенеджерОборудованияКлиент.ПараметрыВыполненияОперацииНаОборудовании).
Процедура ПриПолученииДанныхИзТСД(ОписаниеОповещения, Форма, РезультатВыполнения) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения.ТаблицаТоваров);
		
	Иначе
		
		СобытияФормИСКлиент.СообщитьОбОшибке(РезультатВыполнения);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняется при начале выбора номенклатуры. Требуется определить и открыть форму выбора.
//
// Параметры:
//  Владелец             - ФормаКлиентскогоПриложения  - Форма владелец (возможен владелец - элемент формы).
//  ВидыПродукции        - ПеречислениеСсылка.ВидыПродукцииИС, Массив Из ПеречислениеСсылка.ВидыПродукцииИС - Виды продукции.
//  СтандартнаяОбработка - Булево - Использовать стандартную обработку события.
//  ОписаниеОповещения   - ОписаниеОповещения - Вызывается при выборе значения в форме выбора.
//  Реквизиты            - Структура - параметры формы создания номенклатуры.
//
Процедура ПриНачалеВыбораНоменклатуры(Владелец, ВидыПродукции, СтандартнаяОбработка, ОписаниеОповещения, Реквизиты) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ТипНоменклатуры", ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Запас"));
	
	// Формируем массив видов продукции, чтобы в форме установить отбор с условием ИЛИ по видам продукции
	ОтборВидПродукцииИС = Новый Массив;
	Если ТипЗнч(ВидыПродукции) = Тип("Массив") Тогда
		
		Для Каждого ВидПродукции Из ВидыПродукции Цикл
			
			Если ЗначениеЗаполнено(ВидПродукции) Тогда
			
				ОтборВидПродукцииИС.Добавить(ВидПродукции);
			
			КонецЕсли;
			
		КонецЦикла;
		
	ИначеЕсли ЗначениеЗаполнено(ВидыПродукции) Тогда
		
		ОтборВидПродукцииИС.Добавить(ВидыПродукции);
		
	КонецЕсли;
	
	ПараметрыФормы  = Новый Структура;
	ПараметрыФормы.Вставить("ОтборВидПродукцииИС", ОтборВидПродукцииИС);
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбора);
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	
	ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора", ПараметрыФормы, Владелец,,,, ОписаниеОповещения);
	
КонецПроцедуры

// Выполняется при начале выбора характеристики. Требуется определить и открыть форму выбора.
//
// Параметры:
//  Владелец     - УправляемаяФорма            - форма, в которой вызывается команда выбора характеристики.
//  ДанныеСтроки - ДанныеФормыЭлементКоллекции - текущие данные строки таблицы товаров откуда производится выбор.
//  СтандартнаяОбработка - Булево - Выключается в переопределении
//  Описание - ОписаниеОповещения - Вызывается при выборе значения в форме выбора.
//
Процедура ПриНачалеВыбораХарактеристики(
	Владелец, ДанныеСтроки, СтандартнаяОбработка, ИмяКолонкиНоменклатура, Описание) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормыВыбора = Новый Структура;
	ПараметрыФормыВыбора.Вставить("Отбор", Новый Структура("Владелец", ДанныеСтроки[ИмяКолонкиНоменклатура]));
	
	ОткрытьФорму("Справочник.ХарактеристикиНоменклатуры.ФормаВыбора", ПараметрыФормыВыбора, Владелец,,,, Описание);
	
КонецПроцедуры

// Выполняется при создании номенклатуры из формы МОТП. Требуется определить и открыть форму (диалога) создания номенклатуры.
//
// Параметры:
//  Владелец     - УправляемаяФорма            - Форма владелец.
//  ДанныеСтроки - ДанныеФормыЭлементКоллекции - текущие данные строки таблицы товаров откуда производится создание.
Процедура ПриСозданииНоменклатуры(Владелец, ДанныеСтроки, СтандартнаяОбработка, ВидПродукцииИС) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипНоменклатуры", ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Запас"));
	
	Если ВидПродукцииИС = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Табак") Тогда
		ПараметрыФормы.Вставить("ТабачнаяПродукция", Истина);
	ИначеЕсли ВидПродукцииИС = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Обувь") Тогда
		ПараметрыФормы.Вставить("ОбувнаяПродукция", Истина);
	КонецЕсли;
	
	Если ДанныеСтроки.Свойство("ПредставлениеНоменклатуры") Тогда
		ПараметрыФормы.Вставить("Наименование", ДанныеСтроки.ПредставлениеНоменклатуры);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.Номенклатура.ФормаОбъекта", ПараметрыФормы, Владелец);
	
КонецПроцедуры

// Выполняется при обработке выбора. Требуется выделить и обработать событие выбора номенклатуры.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - Метод формы, который обрабатывает событие выбора.
//  ВыбранноеЗначение       - ОпределяемыйТип..Номенклатура - Результат выбора.
//  ИсточникВыбора          - УправляемаяФорма - Форма, в которой произведен выбор.
Процедура ОбработкаВыбораНоменклатуры(ОповещениеПриЗавершении, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	Если СтрНачинаетсяС(ИсточникВыбора.ИмяФормы, "Справочник.Номенклатура") Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

// Выполняет действия при изменении номенклатуры в строке таблицы формы.
//
// Параметры:
//  Форма                  - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока          - ДанныеФормыЭлементКоллекции - текущие данные редактируемой строки таблицы товаров,
//  КэшированныеЗначения   - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыУказанияСерий - ФиксированнаяСтруктура - параметры указаний серий формы
Процедура ПриИзмененииНоменклатуры(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыУказанияСерий = Неопределено) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "Объект") Тогда
		
		Если Не ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) Тогда
			Возврат;
		КонецЕсли;
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Объект, "Запасы") Тогда
			ИмяТабличнойЧасти = "Запасы";
		ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Объект, "Товары") Тогда
			ИмяТабличнойЧасти = "Товары";
		КонецЕсли;
		
		СтруктураРеквизитов = УправлениеНебольшойФирмойВызовСервера.ЗначенияРеквизитовОбъекта(
			ТекущаяСтрока.Номенклатура,
			"ЕдиницаИзмерения, ИспользоватьХарактеристики, ТоварнаяНоменклатураВЭД",
			Истина);
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Упаковка") Тогда
			ТекущаяСтрока.Упаковка = СтруктураРеквизитов.ЕдиницаИзмерения;
		КонецЕсли;
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "ХарактеристикиИспользуются") Тогда
			ТекущаяСтрока.ХарактеристикиИспользуются = СтруктураРеквизитов.ИспользоватьХарактеристики;
		КонецЕсли;
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "КодТНВЭД") Тогда
			ТекущаяСтрока.КодТНВЭД = СтруктураРеквизитов.ТоварнаяНоменклатураВЭД;
		КонецЕсли;
		
		// ++( 00-00012169
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Серия") Тогда
			ТекущаяСтрокаСтруктура = ПолучитьТекущуюСтрокуСтруктурой(ТекущаяСтрока, "ПроверитьСериюРассчитатьСтатус");
			ИмяФормы = Форма.ИмяФормы;
			ИнтеграцияИСМПУНФВызовСервера.ПроверитьСериюРассчитатьСтатус(ТекущаяСтрокаСтруктура, ИмяФормы);
			ЗаполнитьЗначенияСвойств(ТекущаяСтрока, ТекущаяСтрокаСтруктура);
		КонецЕсли;
		// )++ 00-00012169
		
	ИначеЕсли Форма.ИмяФормы = "Обработка.ПроверкаИПодборПродукцииИСМП.Форма.ФормаВводаКодаМаркировки" Тогда
		
		 СтруктураРеквизитов = УправлениеНебольшойФирмойВызовСервера.ЗначенияРеквизитовОбъекта(
			ТекущаяСтрока.Номенклатура,
			"ИспользоватьХарактеристики",
			Истина);
			
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "ХарактеристикиИспользуются") Тогда
			ТекущаяСтрока.ХарактеристикиИспользуются = СтруктураРеквизитов.ИспользоватьХарактеристики;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму подбора номенклатуры.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой вызывается команда открытия обработки сопоставления,
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия формы подбора.
Процедура ОткрытьФормуПодбораНоменклатуры(Форма, ОповещениеПриЗавершении = Неопределено) Экспорт
	
	Объект = Форма.Объект;
	ТипОбъекта = ТипЗнч(Объект.Ссылка);
	ЭтоПриходныйДокумент = Истина;
	ИмяТабличнойЧасти = Форма.ТекущийЭлемент.Имя;
	
	Если ТипОбъекта = Тип("ДокументСсылка.МаркировкаТоваровИСМП") ИЛИ ТипОбъекта = Тип("ДокументСсылка.ПеремаркировкаТоваровИСМП") Тогда
		ЭтоПриходныйДокумент = Истина;
	ИначеЕсли ТипОбъекта = Тип("ДокументСсылка.СписаниеКодовМаркировкиИСМП") ИЛИ ТипОбъекта = Тип("ДокументСсылка.ВыводИзОборотаИСМП") Тогда
		ЭтоПриходныйДокумент = Ложь;
	Иначе
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЭтоМаркировка", Истина); 
	ПодборНоменклатурыВДокументахКлиент.ОткрытьФормуПодбораНоменклатуры(Форма,, ПараметрыФормы, ОповещениеПриЗавершении);
	
КонецПроцедуры

// Выполняется при обработке выбора. Требуется выделить и обработать событие выбора характеристики.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - Метод формы, который обрабатывает событие выбора.
//  ВыбранноеЗначение       - ОпределяемыйТип.ХарактеристикаНоменклатуры - результат выбора.
//  ИсточникВыбора          - УправляемаяФорма - Форма, в которой произведен выбор.
Процедура ОбработкаВыбораХарактеристики(ОповещениеПриЗавершении, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	Если СтрНачинаетсяС(ИсточникВыбора.ИмяФормы, "Справочник.ХарактеристикиНоменклатуры") Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

// Выполняет действия при изменении подобранного количества в строке таблицы формы.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыУказанияСерий - ФиксированнаяСтруктура - параметры указаний серий формы
Процедура ПриИзмененииКоличества(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыУказанияСерий = Неопределено) Экспорт
	
	СтруктураДействий = Новый Структура;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Упаковка") Тогда
		
		Если ТекущаяСтрока.КоличествоУпаковок = 0 Тогда
			ТекущаяСтрока.Количество = 0;
		Иначе
			Коэффициент = ?(ТипЗнч(ТекущаяСтрока.Упаковка) = Тип("СправочникСсылка.ЕдиницыИзмерения"),
							УправлениеНебольшойФирмойВызовСервера.ЗначениеРеквизитаОбъекта(ТекущаяСтрока.Упаковка, "Коэффициент"),
							1);
			Если Коэффициент <> 0 Тогда
				ТекущаяСтрока.Количество = ТекущаяСтрока.КоличествоУпаковок * Коэффициент;
			Иначе
				ТекстИсключения = НСтр("ru = 'При попытке пересчета количества из %ЕдИзмерения% превышена допустимая разрядность.'");
				ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ЕдИзмерения%", ТекущаяСтрока.Упаковка);
				
				ТекущаяСтрока.Количество = 0;
				ТекущаяСтрока.КоличествоУпаковок = 0;
				ТекущаяСтрока.Упаковка = ПредопределенноеЗначение("Справочник.ЕдиницыИзмерения.ПустаяСсылка");
				
				ВызватьИсключение ТекстИсключения;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Форма.ИмяФормы = "Документ.ВыводИзОборотаИСМП.Форма.ФормаДокумента" Тогда
		
		ПараметрыРасчета = Новый Структура("РассчитатьСумму, СуммаВключаетНДС", Истина, Истина);
		ТабличныеЧастиУНФКлиент.РассчитатьСуммыВСтрокеТЧ(ТекущаяСтрока, ПараметрыРасчета);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет действия при изменении суммы в строке таблицы формы.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров
Процедура ПриИзмененииСуммы(Форма, ТекущаяСтрока) Экспорт
	
	Если Форма.ИмяФормы = "Документ.ВыводИзОборотаИСМП.Форма.ФормаДокумента" Тогда
		
		ПараметрыРасчета = Новый Структура("РассчитатьЦену, СуммаВключаетНДС", Истина, Истина);
		ТабличныеЧастиУНФКлиент.РассчитатьСуммыВСтрокеТЧ(ТекущаяСтрока, ПараметрыРасчета);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет действия при изменении цены в строке таблицы формы.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров
Процедура ПриИзмененииЦены(Форма, ТекущаяСтрока) Экспорт
	
	Если Форма.ИмяФормы = "Документ.ВыводИзОборотаИСМП.Форма.ФормаДокумента" Тогда
		
		ПараметрыРасчета = Новый Структура("РассчитатьСумму, СуммаВключаетНДС", Истина, Истина);
		ТабличныеЧастиУНФКлиент.РассчитатьСуммыВСтрокеТЧ(ТекущаяСтрока, ПараметрыРасчета);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет действия при изменении ставки НДС в строке таблицы формы.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров
Процедура ПриИзмененииСтавкиНДС(Форма, ТекущаяСтрока) Экспорт
	
	Если Форма.ИмяФормы = "Документ.ВыводИзОборотаИСМП.Форма.ФормаДокумента" Тогда
	
		ПараметрыРасчета = Новый Структура("РассчитатьСумму, СуммаВключаетНДС", Истина, Истина);
		ТабличныеЧастиУНФКлиент.РассчитатьСуммыВСтрокеТЧ(ТекущаяСтрока, ПараметрыРасчета);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриНачалеВыбораКодТНВЭД(Владелец, ДанныеСтроки, СтандартнаяОбработка, Описание = Неопределено) Экспорт
	
	Если ДанныеСтроки <> Неопределено Тогда
		
		ПараметрыФормы = Новый Структура;
		
		ТНВЭД = ИнтеграцияИСМПВызовСервера.КлассификаторТНВЭДПоКоду(ДанныеСтроки.КодТНВЭД);
		Если ЗначениеЗаполнено(ТНВЭД) Тогда
			ПараметрыФормы.Вставить("ТекущаяСтрока", ТНВЭД);
		КонецЕсли;
		
		ОткрытьФорму("Справочник.КлассификаторТНВЭД.ФормаВыбора", ПараметрыФормы, Владелец,,,, Описание);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодированиеИСМПКлиентПереопределяемый

// Открывает форму для выбора шаблона для печати этикетки
// 
// Параметры:
// 	ДанныеДляПечати - Структура - Структура данных для печати
// 	Форма - УправляемаяФорма - Источник (форма) команды печати
// 	СтандартнаяОбработка - Булево - Признак необходимости выполнять печать БГосИС
// 	ДополнительныеПараметры - Структура - Дополнительные параметры для открытия формы
Процедура ОткрытьФормуВыбораШаблонаЭтикеткиИСМППоДаннымПечати(
	ДанныеДляПечати, Форма, СтандартнаяОбработка, ДополнительныеПараметры=Неопределено) Экспорт
	
	Перем Оповещение;
	Перем ПереданныеПараметрыОткрытия;
	СтандартнаяОбработка = Ложь;
	ПараметрыОткрытия = Новый Структура("АдресВХранилище", ПоместитьВоВременноеХранилище(ДанныеДляПечати));
	
	Если ДополнительныеПараметры <> Неопределено Тогда
		
		ДополнительныеПараметры.Свойство("Оповещение", Оповещение);
		
		Если ДополнительныеПараметры.Свойство("Параметры", ПереданныеПараметрыОткрытия) Тогда
			Для Каждого КлючЗначение Из ПереданныеПараметрыОткрытия Цикл
				ПараметрыОткрытия.Вставить(КлючЗначение.Ключ, КлючЗначение.Значение);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	ОткрытьФорму(
		"Справочник.ШаблоныЭтикетокИЦенников.Форма.ФормаШтрихкодыЭтикетокИСМП",
		ПараметрыОткрытия,
		Форма,
		Новый УникальныйИдентификатор,,,
		Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьСлужебныеРеквизитыИСМПВСтрокеТЧ(СтрокаТЧ, СтруктураДанные) Экспорт
	
	СписокСвойств = "
		|МаркируемаяПродукция,
		|ВидПродукцииИС";
	
	ЗаполнитьЗначенияСвойств(СтрокаТЧ, СтруктураДанные, СписокСвойств);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьТекущуюСтрокуСтруктурой(ТекущаяСтрока, Действие) Экспорт
	
	СтруктураПолейТЧ = Новый Структура;
	
	Если Действие = "ПроверитьСериюРассчитатьСтатус" Тогда
		
		СтруктураПолейТЧ.Вставить("Серия");
		СтруктураПолейТЧ.Вставить("Номенклатура");
		СтруктураПолейТЧ.Вставить("Характеристика");
	
		СтруктураПолейТЧ.Вставить("СтатусУказанияСерий");
		
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(СтруктураПолейТЧ, ТекущаяСтрока);
		
	Возврат СтруктураПолейТЧ;
	
КонецФункции

#КонецОбласти
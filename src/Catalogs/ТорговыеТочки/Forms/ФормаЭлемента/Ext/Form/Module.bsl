﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	// УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтотОбъект, Объект); // для проверки внедрения БСП
	КонтактнаяИнформацияУНФ.ПриСозданииПриЧтенииНаСервере(ЭтотОбъект, , 15);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	Если Объект.Ссылка.Пустая() Тогда
		
		Если Объект.Владелец.Пустая() Тогда
			
			ЗначениеНастройки = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.ТекущийПользователь(), "ОсновнаяОрганизация");
			Если ЗначениеЗаполнено(ЗначениеНастройки) Тогда
				Объект.Владелец = ЗначениеНастройки;
			Иначе
				Объект.Владелец = Справочники.Организации.ПредопределеннаяОрганизация();
			КонецЕсли;
			
		КонецЕсли;
		
		УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Новый Структура());
		ВыбратьИсточникИФНС();
		
	КонецЕсли;
	
	Элементы.КИ_0.ПодчиненныеЭлементы.ДействиеКИ_0.Видимость = Ложь;
	Элементы.КИ_0.ПодчиненныеЭлементы.ВидКИ_0.Видимость = Ложь;
	Элементы.КИ_0.ПодчиненныеЭлементы.ПредставлениеКИ_0.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Авто;
	Элементы.КИ_0.ПодчиненныеЭлементы.ПредставлениеКИ_0.Заголовок = НСтр("ru='Адрес торговой точки'");
	
	ЗагрузитьКлассификаторы();
	УстановитьВидимостьИДоступностьЭлементов();
	УстановитьНадписи();

	УстановитьСписокЛьгот();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	КонтактнаяИнформацияУНФ.ПриСозданииПриЧтенииНаСервере(ЭтаФорма);
	Элементы.КИ_0.ПодчиненныеЭлементы.ДействиеКИ_0.Видимость = Ложь;
	Элементы.КИ_0.ПодчиненныеЭлементы.ВидКИ_0.Видимость = Ложь;
	Элементы.КИ_0.ПодчиненныеЭлементы.ПредставлениеКИ_0.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Авто;
	Элементы.КИ_0.ПодчиненныеЭлементы.ПредставлениеКИ_0.Заголовок = НСтр("ru='Адрес торговой точки'");
	
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	// УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Объект, Отказ); // для проверки
	// внедрения БСП
	КонтактнаяИнформацияУНФ.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	// УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект); // для проверки внедрения БСП
	КонтактнаяИнформацияУНФ.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура КодОбъектаОсуществленияТорговлиПриИзменении(Элемент)
	КодОбъектаОсуществленияТорговлиПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура КодОбъектаОсуществленияТорговлиПриИзмененииНаСервере()
	
	Объект.КодВидаТорговойДеятельности = КодВидаТорговойДеятельностиПоТипуТорговойТочки(Объект.КодОбъектаОсуществленияТорговли);
	ВыбратьИсточникИФНС();
	УстановитьВидимостьИДоступностьЭлементов();
	УстановитьСписокЛьгот();
	РассчитатьТорговыйСбор();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьКодВидаТорговойДеятельности(Команда)
	
	СписокКодов = Новый СписокЗначений();
	
	Для Каждого Коды Из КодыВидовТорговойДеятельности() Цикл
		
		СписокКодов.Добавить(Коды.Ключ, Коды.Значение);
		
	КонецЦикла;
	
	Оповещние = Новый ОписаниеОповещения("ИзменитьКодВидаТорговойДеятельностиОкончание", ЭтотОбъект);
	СписокКодов.ПоказатьВыборЭлемента(Оповещние,НСтр("ru='Выберите код вида торговой деятельности'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьКодВидаТорговойДеятельностиОкончание(Результат, Дополнительные) Экспорт
	
	Если Результат <> Неопределено Тогда
		Объект.КодВидаТорговойДеятельности = Результат.Значение;
		//Элементы.ГруппаВидДеятельности.Подсказка = Результат.Представление;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПлощадьТорговогоЗалаПриИзменении(Элемент)
	РассчитатьТорговыйСбор();
КонецПроцедуры

&НаКлиенте
Процедура КодЛьготыПриИзменении(Элемент)
	КодЛьготыПриИзмененииНаСервере();
КонецПроцедуры

Процедура КодЛьготыПриИзмененииНаСервере()
	
	ОпределитьПрименимостьЛьготы();
	РассчитатьТорговыйСбор();
	УстановитьВидимостьИДоступностьЭлементов();
	
КонецПроцедуры
 
&НаКлиенте
Процедура СоздатьУведомление(Команда)
	
	
	ПараметрыДляАвтозаполненияФормыТС = ПараметрыДляАвтозаполненияФормыТС();
	
	Если ПараметрыДляАвтозаполненияФормыТС = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму(ПараметрыДляАвтозаполненияФормыТС.ИмяФормыУведомления,
		ПараметрыДляАвтозаполненияФормыТС.ПараметрыФормы,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КодПоОКТМОПриИзменении(Элемент)
	РассчитатьТорговыйСбор();
КонецПроцедуры

&НаКлиенте
Процедура КодИФНСПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.КодИФНС) Тогда
		ВыполнитьЗаполнениеСведенийОНалоговойИнспекции();
	КонецЕсли;

КонецПроцедуры



#КонецОбласти

#Область Служебные

&НаСервере
Функция ПараметрыДляАвтозаполненияФормыТС(Постановка=Истина)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	Если Постановка Тогда
		ИмяФормыУведомления = "Отчет.РегламентированноеУведомлениеТС1.Форма.Форма2015_1";
		ПараметрыФормы = ПараметрыФормыТС1();
	Иначе
		
		ИмяФормыУведомления = "Отчет.РегламентированноеУведомлениеТС2.Форма.Форма2015_1";
		ПараметрыФормы = ПараметрыФормыТС2();
	КонецЕсли;
	
	Результат = Новый Структура("ИмяФормыУведомления, ПараметрыФормы", ИмяФормыУведомления, ПараметрыФормы);
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПараметрыФормыТС1()
	
	ПараметрыФормы = Новый Структура;
	
	Данные = Новый Структура;
	
	Данные.Вставить("ИФНС", Объект.РегистрацияВИФНС);
	
	ДанныеТорговойТочки = Новый Структура;
	
	ДанныеТорговойТочки.Вставить("ТорговаяТочка", Объект.Ссылка);
	
	ДанныеТорговойТочки.Вставить("Т_1", ?(Объект.УведомлениеОтправлялось, "2", "1"));
	
	ДанныеТорговойТочки.Вставить("П_1_1", Объект.ДатаНачалаОсуществленияДеятельности);
	ДанныеТорговойТочки.Вставить("П_1_2", Объект.КодВидаТорговойДеятельности);
		
	ДанныеТорговойТочки.Вставить("П_2_1" , Объект.КодПоОКТМО);
	ДанныеТорговойТочки.Вставить("П_2_2" , Объект.КодОбъектаОсуществленияТорговли);
	ДанныеТорговойТочки.Вставить("П_2_3" , Объект.Наименование);
	Если Объект.КонтактнаяИнформация.Количество() > 0 Тогда
		ДанныеТорговойТочки.Вставить("П_2_4" , Объект.КонтактнаяИнформация[0].Значение);
	КонецЕсли;
	
	ДанныеТорговойТочки.Вставить("П_2_5" , Объект.ОснованиеДляПользованияОбъектом);
	ДанныеТорговойТочки.Вставить("П_2_6" , объект.НомерРазрешениеНаРазмещение);
	
	ЗаполнитьКадастровыйНомер(ДанныеТорговойТочки);
	
	ДанныеТорговойТочки.Вставить("П_2_10", Объект.ПлощадьТорговогоЗала);
	
	Если Объект.ПлощадьТорговогоЗала > 50 И 
		Объект.КодВидаТорговойДеятельности = "03" Тогда
		
		ДанныеТорговойТочки.Вставить("П_3_2", Окр(объект.ИсчисленнаяСумма / Объект.ПлощадьТорговогоЗала, 2));
		
	Иначе
		
		ДанныеТорговойТочки.Вставить("П_3_1", Объект.ИсчисленнаяСумма);
		
	КонецЕсли;
	
	ДанныеТорговойТочки.Вставить("П_3_4", Объект.СуммаЛьготы);
	
	Если объект.ЛьготаПрименяется Тогда
		КодНалоговойЛьготы = Объект.КодЛьготы;
	Иначе
		КодНалоговойЛьготы = "";
	КонецЕсли;
	
	ДанныеТорговойТочки.Вставить("П_3_5", КодНалоговойЛьготы);
	
	ДополнитьДаннымиРанееПоданногоУведомления(ДанныеТорговойТочки);
	
	Данные.Вставить("ДанныеТорговойТочки", ДанныеТорговойТочки);
	
	ПараметрыФормы.Вставить("Организация", Объект.Владелец);
	ПараметрыФормы.Вставить("Данные"     , Данные);
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаСервере
Процедура ДополнитьДаннымиРанееПоданногоУведомления(ДанныеТорговойТочки)
	//
	//Запрос = Новый Запрос;
	//Запрос.УстановитьПараметр("НаДату"       , ПараметрыТорговыхТочек.Период);
	//Запрос.УстановитьПараметр("ТорговаяТочка", ПараметрыТорговыхТочек.ТорговаяТочка);
	//Запрос.Текст =
	//"ВЫБРАТЬ
	//|	ПараметрыТорговыхТочекСрезПоследних.Уведомление
	//|ИЗ
	//|	РегистрСведений.ПараметрыТорговыхТочек.СрезПоследних(
	//|			&НаДату,
	//|			ТорговаяТочка = &ТорговаяТочка
	//|				И НЕ (Уведомление = НЕОПРЕДЕЛЕНО
	//|					ИЛИ Уведомление = ЗНАЧЕНИЕ(Документ.УведомлениеОСпецрежимахНалогообложения.ПустаяСсылка))) КАК ПараметрыТорговыхТочекСрезПоследних";
	//РезультатЗапроса = Запрос.Выполнить().Выбрать();
	//
	//Если НЕ РезультатЗапроса.Следующий() Тогда
	//	Возврат;
	//КонецЕсли;
	//
	//СведенияПоВсемОтправкам = СведенияПоОтправкам.СведенияПоВсемОтправкам(РезультатЗапроса.Уведомление);
	//
	//Для Каждого ОтправленныеСведения Из СведенияПоВсемОтправкам Цикл
	//	Если ЗначениеЗаполнено(ОтправленныеСведения.ДатаЗавершения) Тогда
	//		Идентификатор = ОтправленныеСведения.ИдентификаторОтправки;
	//		СведенияПоОтправке = СведенияПоОтправкам.СведенияПоОтправке(РезультатЗапроса.Уведомление, Идентификатор);
	//		
	//		Если СведенияПоОтправке.Статус = Перечисления.СтатусыОтправки.Сдан Тогда
	//			СтруктураПолногоИмениФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(СведенияПоОтправке.ИмяФайла);
	//			ДанныеТорговойТочки.Вставить("ИмяФайла"     , СтруктураПолногоИмениФайла.ИмяБезРасширения);
	//			ДанныеТорговойТочки.Вставить("АдресДвДанных", СведенияПоОтправке.АдресДвДанных);
	//			Прервать;
	//			
	//		Иначе
	//			Продолжить;
	//			
	//		КонецЕсли;
	//	КонецЕсли;
	//КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКадастровыйНомер(ДанныеТорговойТочки)
	
	П_2_7 = "";
	П_2_8 = "";
	П_2_9 = "";
	
	Если Объект.ТипКадастровогоНомера = 1 Тогда
		П_2_7 = Объект.КадастровыйНомер;
	ИначеЕсли Объект.ТипКадастровогоНомера = 2 Тогда
		П_2_8 = Объект.КадастровыйНомер;
	Иначе
		П_2_9 = Объект.КадастровыйНомер;
	КонецЕсли;
	
	ДанныеТорговойТочки.Вставить("П_2_7" , П_2_7);
	ДанныеТорговойТочки.Вставить("П_2_8" , П_2_8);
	ДанныеТорговойТочки.Вставить("П_2_9" , П_2_9);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыФормыТС2()
	
	ПараметрыФормы = Новый Структура;
	Данные = Новый Структура;
	
	Данные.Вставить("ИФНС", Объект.РегистрацияВИФНС);
	
	ДанныеТорговойТочки = Новый Структура;
	ДанныеТорговойТочки.Вставить("ТорговаяТочка", Объект.Ссылка);
	
	Данные.Вставить("ДанныеТорговойТочки", ДанныеТорговойТочки);
	
	ПараметрыФормы.Вставить("Организация", Объект.Организация);
	ПараметрыФормы.Вставить("Данные"     , Данные);
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаСервере
Процедура ОпределитьПрименимостьЛьготы()
	
	Если Объект.КодЛьготы = "000000000000" Тогда 
		Объект.ЛьготаПрименяется = Ложь;
	Иначе
		Объект.ЛьготаПрименяется = Истина;
	КонецЕсли;
	
	УстановитьВидимостьИДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТребуетсяКадастровыйНомер(КодОбъектаОсуществленияТорговли)
	
	Возврат СтрНайти("01020308", КодОбъектаОсуществленияТорговли) > 0;
	
КонецФункции

&НаСервере
Процедура УстановитьВидимостьИДоступностьЭлементов()
	
	Элементы.НомерРазрешениеНаРазмещение.Видимость = НЕ (Объект.КодОбъектаОсуществленияТорговли="01"); // не магазин
	Элементы.ГруппаКадастровыйНомер.Видимость = ТребуетсяКадастровыйНомер(Объект.КодОбъектаОсуществленияТорговли);
	Элементы.ПлощадьТорговогоЗала.Видимость = ТребуетсяПлощадьТороговогоЗала(Объект.КодОбъектаОсуществленияТорговли);
	Элементы.КодИФНС.Видимость = Объект.ИспользоватьИФНСТорговойТочки;
	Элементы.ВладелецКодНалоговогоОрганаПолучателя.Видимость = НЕ Объект.ИспользоватьИФНСТорговойТочки;
	
	Элементы.ИсчисленнаяСумма.Подсказка = Объект.РасшифровкаРасчета;
	
	Если Объект.ЛьготаПрименяется Тогда
		
		
		ИсчисленнаяСуммаСоЛьготой = Новый ФорматированнаяСтрока(
			НСтр("ru='Исчисленная сумма : '"),
			Новый ФорматированнаяСтрока(Строка(Объект.ИсчисленнаяСумма)+ " р.", Новый Шрифт("",,,,,Истина,,)),
			НСтр("ru=' Применяется льгота. Сумма платежей 0 р.'"));
		Элементы.ИсчисленнаяСумма.Видимость = Ложь;
		Элементы.ИсчисленнаяСуммаСоЛьготой.Видимость = Истина;
		Элементы.ИсчисленнаяСуммаСоЛьготой.Заголовок = ИсчисленнаяСуммаСоЛьготой;
		
	Иначе
		
		Элементы.ИсчисленнаяСумма.Видимость = Истина;
		Элементы.ИсчисленнаяСуммаСоЛьготой.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция КодВидаТорговойДеятельностиПоТипуТорговойТочки(КодОбъектаОсуществленияТорговли)
	
	ТипТорговойТочки = КодОбъектаОсуществленияТорговли;
	
	Если СтрНайти("0102", ТипТорговойТочки) > 0 Тогда // магазин, павильон
		
		Результат = "03"; // сети с торговым залом
		
	ИначеЕсли СтрНайти("0408", ТипТорговойТочки) > 0 Тогда // коиск, торговый автомат, иное
		
		Результат = "01"; // стационарные сети без торгового зала
		
	ИначеЕсли СтрНайти("06", ТипТорговойТочки) > 0 Тогда // торговый автомат
		
		Результат = "05"; // торговый автомат
		
	ИначеЕсли СтрНайти("0507", ТипТорговойТочки) > 0 Тогда // торговая палатка, автолавка
		
		Результат = "02"; // нестационарные сети
		
	ИначеЕсли СтрНайти("03", ТипТорговойТочки) > 0 Тогда // розничный рынок
		
		Результат = "05"; // рынок
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура УстановитьНадписи()
	
	КодыВидов = КодыВидовТорговойДеятельности();
	//Элементы.ГруппаВидДеятельности.Подсказка = КодыВидов[Объект.КодВидаТорговойДеятельности];
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция КодыВидовТорговойДеятельности()
	
	КодыСоответствие = Новый Соответствие();
	
	КодыСоответствие.Вставить("01","Торговля в стационарной торговой сети без торговых залов");
	КодыСоответствие.Вставить("02","Торговля в нестационарной торговой сети");
	КодыСоответствие.Вставить("03","Торговля в стационарной торговой сети, имеющей торговые залы");
	КодыСоответствие.Вставить("04","Торговля со склада");
	КодыСоответствие.Вставить("05","Деятельность по организации розничных рынков, торговый автомат");
	
	Возврат КодыСоответствие;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьКлассификаторы()
	
	Таб = Справочники.ТорговыеТочки.ПолучитьЛьготы();
	Для Каждого Стр Из Таб Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаЛьгот.Добавить(), Стр);
	КонецЦикла;
	
	Таб = Справочники.ТорговыеТочки.ПолучитьТерриторииОсуществленияДеятельности();
	Для Каждого Стр Из Таб Цикл
		ЗаполнитьЗначенияСвойств(ТерриторииОсуществленияДеятельности.Добавить(), Стр);
	КонецЦикла;
	
	Таб = Справочники.ТорговыеТочки.ПолучитьСтавки();
	Для Каждого Стр Из Таб Цикл
		ЗаполнитьЗначенияСвойств(СтавкиСбора.Добавить(), Стр);
	КонецЦикла;
	
КонецПроцедуры



&НаСервере
Процедура ВыбратьИсточникИФНС()
	
	Объект.ИспользоватьИФНСТорговойТочки = Справочники.ТорговыеТочки.СтационарныйТорговыйОбъект(Объект.КодОбъектаОсуществленияТорговли);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСписокЛьгот()
	
	КодЛьготы = объект.КодЛьготы;
	
	Отбор = Новый Структура("ТипТорговойТочки", Объект.КодОбъектаОсуществленияТорговли);
	
	Строки = ТаблицаЛьгот.НайтиСтроки(Отбор);
	
	СписокЛьгот = Элементы.КодЛьготы.СписокВыбора;
	СписокЛьгот.Очистить();
	
	Для Каждого элемент Из Строки Цикл
		
		СписокЛьгот.Добавить(Элемент.КодНалоговойЛьготы, Элемент.Наименование);
		
	КонецЦикла;
	
	Если НЕ ЗначениеЗаполнено(КодЛьготы) ИЛИ  СписокЛьгот.НайтиПоЗначению(КодЛьготы) = Неопределено Тогда
		Объект.КодЛьготы = СписокЛьгот[0].Значение;
		ОпределитьПрименимостьЛьготы();
	КонецЕсли;
	
	
	КодВидаТорговойДеятельности = Элементы.КодВидаТорговойДеятельности.СписокВыбора;
	КодВидаТорговойДеятельности.Очистить();
	
	Для Каждого элемент Из КодыВидовТорговойДеятельности() Цикл
		
		КодВидаТорговойДеятельности.Добавить(Элемент.Ключ,Элемент.Ключ +"-"+ Элемент.Значение);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТребуетсяПлощадьТороговогоЗала(КодОбъектаОсуществленияТорговли)
	
	Возврат СтрНайти("01020308", КодОбъектаОсуществленияТорговли) > 0;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьЗаполнениеСведенийОНалоговойИнспекции()
	
	ОписаниеОшибки = "";
	ЗаполнитьСведенияОНалоговойИнспекцииПоКоду(ОписаниеОшибки);
	
	// Обработка ошибок
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		Если ОписаниеОшибки = "НеУказаныПараметрыАутентификации" Тогда
			
			ТекстВопроса = НСтр("ru='Для автоматического создания налогового органа
				|в справочнике «Контрагенты» необходимо подключиться к Интернет-поддержке
				|пользователей. Данные по налоговому органу пригодятся при уплате налогов.
				|Подключиться сейчас?'");
				
			ПараметрыВопроса = Новый Структура("ВызовПослеПодключения", "ЗаполнитьСведенияОНалоговойИнспекцииПоКоду");
			ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьИнтернетПоддержку", ЭтотОбъект, ПараметрыВопроса);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			
		Иначе
			ПоказатьПредупреждение(, ОписаниеОшибки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСведенияОНалоговойИнспекцииПоКоду(ОписаниеОшибки = "")
	
	Если НЕ ЗначениеЗаполнено(Объект.КодИФНС) Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыНалоговогоОргана = ДанныеГосударственныхОрганов.РеквизитыНалоговогоОрганаПоКоду(Объект.КодИФНС);
	
	Если ЗначениеЗаполнено(РеквизитыНалоговогоОргана.ОписаниеОшибки) Тогда
		ОписаниеОшибки = РеквизитыНалоговогоОргана.ОписаниеОшибки;
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(РеквизитыНалоговогоОргана.Ссылка) Тогда
		ДанныеГосударственныхОрганов.ОбновитьДанныеГосударственногоОргана(РеквизитыНалоговогоОргана);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьИнтернетПоддержку(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Оповещение = Новый ОписаниеОповещения("ПодключитьИнтернетПоддержкуЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(Оповещение, ЭтотОбъект);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПодключитьИнтернетПоддержкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		
		Если ДополнительныеПараметры.Свойство("ВызовПослеПодключения") Тогда
			
			Если ДополнительныеПараметры.ВызовПослеПодключения = "ЗаполнитьСведенияОНалоговойИнспекцииПоКоду" Тогда
				
				ЗаполнитьСведенияОНалоговойИнспекцииПоКоду();
				
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры



#КонецОбласти

#Область РассчетСтавкиСбора

&НаСервере
Процедура РассчитатьТорговыйСбор()
	
	Если НЕ ЕстьДанныеДляРасчета() Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеТарифа = ПолучитьДанныеТарифа();
	Если ДанныеТарифа = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.СтавкаЗаОбъект = ДанныеТарифа.СтавкаДо50квм;
	Объект.ИсчисленнаяСумма = ДанныеТарифа.СтавкаДо50квм;
	Объект.СтавкаЗаКвМ = ДанныеТарифа.СтавкаБольше50квм;
	
	Если Объект.КодОбъектаОсуществленияТорговли = "08" Тогда
		
		Объект.ИсчисленнаяСумма = Объект.СтавкаЗаКвМ * Объект.ПлощадьТорговогоЗала;
		
		Объект.РасшифровкаРасчета = НСтр("ru='Ставка за объект составляет'") + Объект.ИсчисленнаяСумма + " р. ";
		
	ИначеЕсли Объект.КодОбъектаОсуществленияТорговли = "07" Тогда
		
		Объект.ИсчисленнаяСумма = ДанныеТарифа.СтавкаДо50квм;
		
		Объект.РасшифровкаРасчета = НСтр("ru='Исчисленная сумма при развозной и разносной торговле составляет'") + Объект.ИсчисленнаяСумма + " р. ";
		
	Иначе
		
		
		СуммаСбораЗаПревышение50м2 = 0;
		
		Если Объект.ПлощадьТорговогоЗала > 50 И ТребуетсяПлощадьТороговогоЗала(Объект.КодОбъектаОсуществленияТорговли) Тогда
			
			ПлощадьЗалаСвыше50м2 = ПлощадьЗалаСвыше50м(Объект.ПлощадьТорговогоЗала);
			СуммаСбораЗаПревышение50м2 = ?(ПлощадьЗалаСвыше50м2 > 100, 100,
			ПлощадьЗалаСвыше50м2)*ДанныеТарифа.СтавкаБольше50квм;
			
			СуммаСбораЗаПревышение150м2 = ?(ПлощадьЗалаСвыше50м2 > 250, 150,
				Макс(0, (ПлощадьЗалаСвыше50м2- 100)))*ДанныеТарифа.СтавкаБольше150квм;
			СуммаСбораЗаПревышение300м2 = Макс(0, (ПлощадьЗалаСвыше50м2- 250)*ДанныеТарифа.СтавкаБольше300квм);
			Объект.ИсчисленнаяСумма = Объект.СтавкаЗаОбъект + СуммаСбораЗаПревышение50м2
				+ СуммаСбораЗаПревышение150м2
				+ СуммаСбораЗаПревышение300м2;
				
			Объект.РасшифровкаРасчета = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Исчисленная сумма %1 р. состоит из %2 р. (ставка за объект) + %3 кв.м. (превышение 50 кв. м. площади) * %4 р. (ставка за превышение)'"),
				Объект.ИсчисленнаяСумма,
				Объект.СтавкаЗаОбъект,
				ПлощадьЗалаСвыше50м2,
				Объект.СтавкаЗаКвМ);
			
		Иначе 
			Объект.РасшифровкаРасчета = НСтр("ru='Ставка за объект составляет '") + Объект.СтавкаЗаОбъект + " р. ";
		КонецЕсли;
		
	КонецЕсли;
	
	Если Объект.ЛьготаПрименяется Тогда
		// применение льготы освобождает от уплаты торгового сбора
		Объект.СуммаЛьготы = Объект.ИсчисленнаяСумма;
		Объект.РасшифровкаРасчета = Объект.РасшифровкаРасчета + НСтр("ru=' Применяется льгота. Итоговая ставка равна нулю.'");
	Иначе
		Объект.СуммаЛьготы = 0;
	КонецЕсли;
	
	Элементы.ИсчисленнаяСумма.Подсказка = Объект.РасшифровкаРасчета;
	
КонецПроцедуры


&НаСервереБезКонтекста
Функция ПлощадьЗалаСвыше50м(ПлощадьЗала)
	
	ПлощадьЗалаСвыше50м = Макс(ПлощадьЗала - 50, 0);
	
	ЦелаяЧасть = Цел(ПлощадьЗалаСвыше50м);
	
	Если ПлощадьЗалаСвыше50м - ЦелаяЧасть > 0 Тогда
		ПлощадьЗалаСвыше50м = ЦелаяЧасть + 1;
	КонецЕсли;
	
	Возврат ПлощадьЗалаСвыше50м;
	
КонецФункции


Функция ЕстьДанныеДляРасчета()
	
	Если ПустаяСтрока(Объект.КодПоОКТМО) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ПустаяСтрока(объект.КодВидаТорговойДеятельности) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ПустаяСтрока(объект.КодОбъектаОсуществленияТорговли) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ПолучитьЗонуТарифа()
	
	ОтборОКТМО = Новый Структура("ОКТМО", Объект.КодПоОКТМО);
	
	СтрокиОКТМО = ТерриторииОсуществленияДеятельности.НайтиСтроки(ОтборОКТМО);
	
	Если СтрокиОКТМО.Количество() <> 1 Тогда
		Возврат Неопределено;
	Иначе
		Возврат СтрокиОКТМО[0].ЗонаТарифа;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПолучитьДанныеТарифа()
	
	ЗонаТарифа = ПолучитьЗонуТарифа();
	
	Если ЗонаТарифа = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИскатьПоКоду = Истина;
	ВидТорговойДеятельности = ОпределитьВидТорговойДеятельности();
	Если ВидТорговойДеятельности <> Неопределено Тогда
		ИскатьПоКоду = Ложь;
	КонецЕсли;
	
	Если Объект.КодОбъектаОсуществленияТорговли = "07"  Тогда
		КодВидаТорговойДеятельности = "99";
	Иначе
		КодВидаТорговойДеятельности = Объект.КодВидаТорговойДеятельности;
	КонецЕсли;
	
	СтавкиСбораТаблицаЗначений = СтавкиСбора.Выгрузить();
	СтавкиСбораТаблицаЗначений.Сортировать("ДействуетС Убыв"); 
	
	Для Каждого ТекущаяСтрокаСтавки Из СтавкиСбораТаблицаЗначений Цикл
		Если ТекущаяСтрокаСтавки.ЗонаТарифа = ЗонаТарифа
			И ТекущаяСтрокаСтавки.ДействуетС <= ТекущаяДатаСеанса() Тогда
			
			Если ИскатьПоКоду
				И ТекущаяСтрокаСтавки.КодВидаТорговойДеятельности = КодВидаТорговойДеятельности
				И Не ЗначениеЗаполнено(ТекущаяСтрокаСтавки.ВидТорговойДеятельности) Тогда
				Возврат ТекущаяСтрокаСтавки;
			КонецЕсли;
			
			Если Не ИскатьПоКоду
				И ТекущаяСтрокаСтавки.ВидТорговойДеятельности = ВидТорговойДеятельности Тогда
				Возврат ТекущаяСтрокаСтавки;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено
	
КонецФункции

&НаСервере
Функция ОпределитьВидТорговойДеятельности()
	
	Если Объект.КодОбъектаОсуществленияТорговли = "06" Тогда
		Возврат Перечисления.ВидыТорговойДеятельностиОблагаемыеСбором.ТорговыеАвтоматы;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область КонтактнаяИнформация

// СтандартныеПодсистемы.КонтактнаяИнформация
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
		УправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент,, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.Очистка(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	УправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда.Имя);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат) Экспорт
	УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПредставлениеКИНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	КонтактнаяИнформацияУНФКлиент.ПредставлениеКИНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьКонтактнуюИнформациюСервер(ДобавляемыйВид, УстановитьВыводВФормеВсегда = Ложь) Экспорт
	
	КонтактнаяИнформацияУНФ.ДобавитьКонтактнуюИнформацию(ЭтотОбъект, ДобавляемыйВид, УстановитьВыводВФормеВсегда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ДействиеКИНажатие(Элемент)
	
	КонтактнаяИнформацияУНФКлиент.ДействиеКИНажатие(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияУНФВыполнитьКоманду(Команда)
	
	КонтактнаяИнформацияУНФКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	КонтактнаяИнформацияУНФКлиент.АвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	КонтактнаяИнформацияУНФКлиент.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.КонтактнаяИнформация

#КонецОбласти
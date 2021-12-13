﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Отбор") Тогда
		Параметры.Отбор.Свойство("СертификатЭП", СертификатЭП);
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	ПодписываемыеВидыДокументов = КриптографияБЭД.ПодписываемыеВидыДокументов();
	Для Каждого ВидДокумента Из ПодписываемыеВидыДокументов Цикл
		Строки = ВидыПодписываемыхЭД.НайтиСтроки(Новый Структура("ВидЭД", ВидДокумента));
		Если Строки.Количество() = 0 Тогда
			Если Параметры.Отбор.Свойство("СертификатЭП") Тогда
				НоваяЗапись = ВидыПодписываемыхЭД.Добавить();
				НоваяЗапись.СертификатЭП = Параметры.Отбор.СертификатЭП;
				НоваяЗапись.ВидЭД = ВидДокумента;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ВидыПодписываемыхЭД.Сортировать("ВидЭД");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ЗавершениеРаботы И ДанныеИзменены Тогда
		ОчиститьСообщения();
		СохранитьИзмененияНаСервере(Отказ, Истина);

		Если Отказ Тогда
			СписокКнопок = Новый СписокЗначений;
			СписокКнопок.Добавить("Записать");
			СписокКнопок.Добавить("ПродолжитьРедактирование", НСтр("ru = 'Продолжить редактирование'"));
			СписокКнопок.Добавить("ЗакрытьБезСохранения", НСтр("ru = 'Закрыть без сохранения'"));
			ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
			
			ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'В заданных настройках обнаружены возможные ошибки.'"),
				СписокКнопок,, "ПродолжитьРедактирование", НСтр("ru = 'Настройка некорректна'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	#Если ВебКлиент Тогда
		Если ИмяСобытия = "Запись_СертификатыКлючейЭлектроннойПодписиИШифрования" И ДанныеИзменены Тогда
			ОчиститьСообщения();
			СохранитьИзмененияНаСервере(Ложь, Истина);
		КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыделитьВсе(Команда)
	
	ИзменитьОтметку(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	
	ИзменитьОтметку(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьОтметку(Пометка)
	
	ВидыЭД = Новый Массив;
	Для Каждого Строка Из ВидыПодписываемыхЭД Цикл
		Строка.Использовать = Пометка;
		Если Пометка Тогда
			ВидыЭД.Добавить(Строка.ВидЭД);
		КонецЕсли;
	КонецЦикла;
	ДанныеИзменены = Истина;
	Если ВидыЭД.Количество() Тогда
		ОповеститьОбИзмененииФлаговИспользовать(ВидыЭД);
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИспользоватьПриИзменении(Элемент)
	
	ДанныеИзменены = Истина;
	ТекущиеДанные = Элементы.ВидыПодписываемыхЭД.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ТекущиеДанные.Использовать Тогда
		ВидыЭД = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТекущиеДанные.ВидЭД);
		ОповеститьОбИзмененииФлаговИспользовать(ВидыЭД);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		
		УсловноеОформление.Элементы.Очистить();

		Элемент = УсловноеОформление.Элементы.Добавить();

		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВидЭД.Имя);

		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВидыПодписываемыхЭД.ВидЭД");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Перечисления["ТипыДокументовЭДО"].СоглашениеОбИзмененииСтоимости;

		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Соглашение об изменении стоимости (отправитель)'"));
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СохранитьИзмененияНаСервере(Отказ, ВыполнятьПроверку = Ложь)
	
	СертификатЭП = ВидыПодписываемыхЭД.Отбор.СертификатЭП.Значение;
	НаборЗаписейПосле = ВидыПодписываемыхЭД.Выгрузить();
	
	Если ВыполнятьПроверку Тогда
		НаборЗаписейДо = РегистрыСведений.ПодписываемыеВидыЭД.СоздатьНаборЗаписей();
		НаборЗаписейДо.Отбор.СертификатЭП.Установить(СертификатЭП);
		НаборЗаписейДо.Прочитать();
		НаборЗаписейДо = НаборЗаписейДо.Выгрузить();
		
		ПроверитьВалидностьПоВсемЗависимымНастройкам(Отказ, НаборЗаписейДо, НаборЗаписейПосле);
	КонецЕсли;
	
	Если Не Отказ Тогда
		РегистрыСведений.ПодписываемыеВидыЭД.СохранитьПодписываемыеВидыЭД(СертификатЭП, НаборЗаписейПосле);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьВалидностьПоВсемЗависимымНастройкам(Отказ, СтарыйНаборЗаписей, НовыйНаборЗаписей)
	
	ЕстьОбменСКонтрагентами = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами");
	ЕстьОбменСБанками = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСБанками");
	
	Если ЕстьОбменСКонтрагентами ИЛИ ЕстьОбменСБанками Тогда
		
		Запросы = Новый Массив;
		
		// Вычислим виды документов, по которым сняли флаг использования.
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("СтарыйНабор", СтарыйНаборЗаписей);
		Запрос.УстановитьПараметр("НовыйНабор", НовыйНаборЗаписей);
		Запрос.УстановитьПараметр("ПустойМаршрут", Справочники.МаршрутыПодписания.ПустаяСсылка());
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	СтарыйНабор.СертификатЭП,
		|	СтарыйНабор.ВидЭД,
		|	СтарыйНабор.Использовать
		|ПОМЕСТИТЬ СтарыйНабор
		|ИЗ
		|	&СтарыйНабор КАК СтарыйНабор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НовыйНабор.СертификатЭП,
		|	НовыйНабор.ВидЭД,
		|	НовыйНабор.Использовать
		|ПОМЕСТИТЬ НовыйНабор
		|ИЗ
		|	&НовыйНабор КАК НовыйНабор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СтарыйНабор.СертификатЭП,
		|	СтарыйНабор.ВидЭД
		|ПОМЕСТИТЬ ОтключенныеВидыДокументов
		|ИЗ
		|	СтарыйНабор КАК СтарыйНабор
		|		ЛЕВОЕ СОЕДИНЕНИЕ НовыйНабор КАК НовыйНабор
		|		ПО СтарыйНабор.СертификатЭП = НовыйНабор.СертификатЭП
		|			И СтарыйНабор.ВидЭД = НовыйНабор.ВидЭД
		|			И (НовыйНабор.Использовать)
		|ГДЕ
		|	СтарыйНабор.Использовать
		|	И НовыйНабор.СертификатЭП ЕСТЬ NULL
		|;";
		
		// Найдем все настройки обмена с банками / с контрагентами, в которых указан маршрут
		ТекстОбъединения = 
		"
		|	
		|ОБЪЕДИНИТЬ ВСЕ
		|	
		|";
		
		МассивЗапросовВидыДокументовПоНастройкам = Новый Массив;
		
		Если ЕстьОбменСКонтрагентами Тогда
			МодульНастройкиЭДО = ОбщегоНазначения.ОбщийМодуль("НастройкиЭДО");
			ЗапросНастроекОбменСКонтрагентами = МодульНастройкиЭДО.ЗапросНастроекОтправкиДляВалидацииМаршрутов("НастройкиОбменСКонтрагентами");
			Запросы.Добавить(ЗапросНастроекОбменСКонтрагентами);
			
			ТекстЗапросаОбменСКонтрагентами = "ВЫБРАТЬ
			|НастройкиОбменСКонтрагентами.ВидДокумента,
			|НастройкиОбменСКонтрагентами.МаршрутПодписания,
			|НастройкиОбменСКонтрагентами.Сертификат,
			|НастройкиОбменСКонтрагентами.Отправитель,
			|НастройкиОбменСКонтрагентами.Получатель,
			|НастройкиОбменСКонтрагентами.Договор,
			|НЕОПРЕДЕЛЕНО КАК НастройкаОбмена
			|ПОМЕСТИТЬ ВидыДокументовПоНастройкам
			|ИЗ
			|НастройкиОбменСКонтрагентами КАК НастройкиОбменСКонтрагентами";
			
			МассивЗапросовВидыДокументовПоНастройкам.Добавить(ТекстЗапросаОбменСКонтрагентами);
		КонецЕсли;
		
		Если ЕстьОбменСБанками Тогда
			МодульОбменСБанкамиСлужебный = ОбщегоНазначения.ОбщийМодуль("ОбменСБанкамиСлужебный");
			ЗапросНастроекОбменСБанками = МодульОбменСБанкамиСлужебный.ЗапросНастроекДляВалидацииМаршрутов("НастройкиОбменСБанками");
			Запросы.Добавить(ЗапросНастроекОбменСБанками);
			
			ТекстЗапросаОбменСБанками = "ВЫБРАТЬ
			|НастройкиОбменСБанками.ВидДокумента,
			|НастройкиОбменСБанками.МаршрутПодписания,
			|НастройкиОбменСБанками.Сертификат,
			|НЕОПРЕДЕЛЕНО КАК Отправитель,
			|НЕОПРЕДЕЛЕНО КАК Получатель,
			|НЕОПРЕДЕЛЕНО КАК Договор,
			|НастройкиОбменСБанками.НастройкаОбмена КАК НастройкаОбмена
			|ПОМЕСТИТЬ ВидыДокументовПоНастройкам
			|ИЗ
			|НастройкиОбменСБанками КАК НастройкиОбменСБанками";
			Если ЕстьОбменСКонтрагентами Тогда
				ТекстЗапросаОбменСБанками = СтрЗаменить(ТекстЗапросаОбменСБанками,
					"ПОМЕСТИТЬ ВидыДокументовПоНастройкам", "");
			КонецЕсли;
			МассивЗапросовВидыДокументовПоНастройкам.Добавить(ТекстЗапросаОбменСБанками);
		КонецЕсли;
		
		ТекстЗапросаВидыДокументовПоНастройкам = СтрСоединить(МассивЗапросовВидыДокументовПоНастройкам, ТекстОбъединения);
		
		ТекстЗапроса = ТекстЗапроса 
			+ Символы.ПС 
			+ ТекстЗапросаВидыДокументовПоНастройкам
			+ Символы.ПС
			+ ";"
			+ Символы.ПС +
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ВидыДокументовПоНастройкам.ВидДокумента КАК ВидДокумента,
			|	ВидыДокументовПоНастройкам.НастройкаОбмена КАК НастройкаОбмена
			|ПОМЕСТИТЬ ДанныеДляПроверки
			|ИЗ 
			|	ВидыДокументовПоНастройкам КАК ВидыДокументовПоНастройкам
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОтключенныеВидыДокументов
			|			ПО ВидыДокументовПоНастройкам.ВидДокумента = ОтключенныеВидыДокументов.ВидЭД
			|				И ВидыДокументовПоНастройкам.Сертификат = ОтключенныеВидыДокументов.СертификатЭП
			|;
			|
			|ВЫБРАТЬ
			|	ВидыДокументовПоНастройкам.ВидДокумента КАК ВидДокумента,
			|	ВидыДокументовПоНастройкам.НастройкаОбмена КАК НастройкаОбмена,
			|	ВидыДокументовПоНастройкам.МаршрутПодписания КАК МаршрутПодписания,
			|	ВидыДокументовПоНастройкам.Сертификат,
			|	ВидыДокументовПоНастройкам.Отправитель,
			|	ВидыДокументовПоНастройкам.Получатель,
			|	ВидыДокументовПоНастройкам.Договор
			|ИЗ
			|	ДанныеДляПроверки КАК ДанныеДляПроверки
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВидыДокументовПоНастройкам КАК ВидыДокументовПоНастройкам
			|			ПО ДанныеДляПроверки.ВидДокумента = ВидыДокументовПоНастройкам.ВидДокумента
			|				И ДанныеДляПроверки.НастройкаОбмена = ВидыДокументовПоНастройкам.НастройкаОбмена
			|ИТОГИ ПО
			|	НастройкаОбмена,
			|	Отправитель,
			|	Получатель,
			|	Договор,
			|	МаршрутПодписания,
			|	ВидДокумента";
		Запрос.Текст = ТекстЗапроса;
		
		ИтоговыйЗапрос = ОбщегоНазначенияБЭД.СоединитьЗапросы(Запрос, Запросы);
		ИтоговыйЗапрос.УстановитьПараметр("СтарыйНабор", СтарыйНаборЗаписей);
		ИтоговыйЗапрос.УстановитьПараметр("НовыйНабор", НовыйНаборЗаписей);
		
		// Обойдем настройки и проверим каждую на валидность
		УстановитьПривилегированныйРежим(Истина);
		ВыборкаНастроек = ИтоговыйЗапрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		УстановитьПривилегированныйРежим(Ложь);
		Пока ВыборкаНастроек.Следующий() Цикл
			НаборСертификатов = Новый Массив;
			СертификатыСчитаны = Ложь;

			ВыборкаОтправитель = ВыборкаНастроек.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаОтправитель.Следующий() Цикл
				ВыборкаПолучатель = ВыборкаОтправитель.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока ВыборкаПолучатель.Следующий() Цикл
					ВыборкаДоговор = ВыборкаПолучатель.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
					Пока ВыборкаДоговор.Следующий() Цикл
						ВыборкаМаршрутов = ВыборкаДоговор.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
						Пока ВыборкаМаршрутов.Следующий() Цикл
							НаборВидовЭД = Новый Массив;

							ВыборкаВидов = ВыборкаМаршрутов.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
							Пока ВыборкаВидов.Следующий() Цикл
								НаборВидовЭД.Добавить(ВыборкаВидов.ВидДокумента);

								Если Не СертификатыСчитаны Тогда
									ВыборкаСертификатов = ВыборкаВидов.Выбрать();
									Пока ВыборкаСертификатов.Следующий() Цикл
										Если ЗначениеЗаполнено(ВыборкаСертификатов.Сертификат) Тогда
											НаборСертификатов.Добавить(ВыборкаСертификатов.Сертификат);
										КонецЕсли;
									КонецЦикла;
									СертификатыСчитаны = Истина;
								КонецЕсли;
							КонецЦикла;
						
							РезультатыПроверки = МаршрутыПодписанияБЭД.РезультатыПроверкиМаршрутаПоПараметрамНастройки(
								ВыборкаМаршрутов.МаршрутПодписания, НаборСертификатов, НаборВидовЭД, НовыйНаборЗаписей);
						
							ПредставлениеНастройки = "";
							Если ЗначениеЗаполнено(ВыборкаДоговор.НастройкаОбмена) Тогда
								НастройкаОбмена = ВыборкаДоговор.НастройкаОбмена;
							Иначе 
								ОписаниеНастройки = Новый Структура("Отправитель, Получатель, Договор");
								ЗаполнитьЗначенияСвойств(ОписаниеНастройки, ВыборкаДоговор);
								МенеджерНастроек = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени("РегистрСведений.НастройкиОтправкиЭлектронныхДокументов");
								
								НастройкаОбмена        = МенеджерНастроек.СоздатьКлючЗаписи(ОписаниеНастройки);
								ПредставлениеНастройки = ОбщегоНазначения.ОбщийМодуль("НастройкиЭДО").ПредставлениеНастройкиОтправки(НастройкаОбмена);
							КонецЕсли;
						
							// Ошибки недоступности сертификатов для подписания вида ЭД в целом пропускаем - это не ошибка настройки маршрута.
							МаршрутыПодписанияБЭД.ВывестиРезультатыПроверкиМаршрута(РезультатыПроверки,
								НастройкаОбмена, ВыборкаМаршрутов.МаршрутПодписания, Отказ,, ПредставлениеНастройки);
						КонецЦикла;
					КонецЦикла;
				КонецЦикла;
			КонецЦикла;

		КонецЦикла;
	КонецЕсли;

КонецПроцедуры
	
&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ = "Записать" Тогда
		ОчиститьСообщения();
		СохранитьИзмененияНаСервере(Ложь);
	ИначеЕсли Ответ = "ЗакрытьБезСохранения" Тогда
		ДанныеИзменены = Ложь;
		ОчиститьСообщения();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОбИзмененииФлаговИспользовать(ВидыЭД) 
	
	ДанныеИзменены = Истина;
	ВидОшибки = КриптографияБЭДСлужебныйКлиентСервер.ВидОшибкиДляСертификатаНетПодписываемогоВидаДокумента();
	Отбор = Новый Соответствие;
	Отбор.Вставить("ВидОшибки", ВидОшибки);
	Отбор.Вставить("ДополнительныеДанные.Сертификат", СертификатЭП);
	Отбор.Вставить("ДополнительныеДанные.ВидЭД", ВидыЭД);
	ОбработкаНеисправностейБЭДКлиент.ОповеститьОбИсправленииОшибок(Отбор);
	
КонецПроцедуры

#КонецОбласти






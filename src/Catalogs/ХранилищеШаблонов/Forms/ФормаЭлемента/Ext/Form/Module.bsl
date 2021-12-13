﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Элементы.ТипШаблона.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если Объект.ТипШаблона = Перечисления.ТипыШаблонов.ЧекККМ Тогда
		Элементы.ТипШаблона.СписокВыбора.Добавить(Перечисления.ТипыШаблонов.ЧекККМ);
	КонецЕсли;
	
	ЗаполнитьСписокМетаданныхИспользующихШаблоны(Метаданные.Справочники);
	ЗаполнитьСписокМетаданныхИспользующихШаблоны(Метаданные.Документы);
	
	Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		ОбъектИсточник = Параметры.ЗначениеКопирования.ПолучитьОбъект();
	Иначе
		ОбъектИсточник = РеквизитФормыВЗначение("Объект", Тип("СправочникОбъект.ХранилищеШаблонов"));
	КонецЕсли;
	
	СтруктураШаблона = ОбъектИсточник.Шаблон.Получить();
	СКД = ОбъектИсточник.СхемаКомпоновкиДанных.Получить();
	
	Если ТипЗнч(СтруктураШаблона) = Тип("Структура") Тогда
		СтруктураШаблона.Свойство("XMLОписаниеМакета", XMLОписаниеМакета);
	КонецЕсли;
	
	АдресШаблона = ПоместитьВоВременноеХранилище(СтруктураШаблона, УникальныйИдентификатор);
	
	Если СКД <> Неопределено Тогда
		АдресСКД = ПоместитьВоВременноеХранилище(СКД, УникальныйИдентификатор);
	КонецЕсли;
	
	УстановитьВидимостьИДоступностьЭлементов();
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаРедактироватьМакет", "Видимость", Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(АдресШаблона) Тогда
		
		СтруктураШаблона = ПолучитьИзВременногоХранилища(АдресШаблона);
		
		Если СтруктураШаблона <> Неопределено Тогда
			ТекущийОбъект.Шаблон = Новый ХранилищеЗначения(СтруктураШаблона);
			Если СтруктураШаблона.Свойство("АдресСКДВХранилище") Тогда
				АдресСКД = СтруктураШаблона.АдресСКДВХранилище;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресСКД) Тогда
		
		СКД = ПолучитьИзВременногоХранилища(АдресСКД);
		ТекущийОбъект.СхемаКомпоновкиДанных = Новый ХранилищеЗначения(СКД);
		
		Если НЕ Отказ Тогда
			Если НЕ ОбязательныеПараметрыСКДЗаполнены(ТекущийОбъект) Тогда
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.ТипШаблона.ТолькоПросмотр = Истина;
	Элементы.ОбъектМетаданных.ТолькоПросмотр = Истина;
	Элементы.ОбъектМетаданных.АвтоОтметкаНезаполненного = Ложь;
	Элементы.ОбъектМетаданных.ОтметкаНезаполненного = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИзмененШаблон"
		ИЛИ ИмяСобытия = "ИзмененШаблонЧека" Тогда
		АдресШаблона = Параметр;
		Модифицированность = Истина;
		Если ИмяСобытия = "ИзмененШаблон"
			И ЗначениеЗаполнено(АдресШаблона) Тогда
			СтруктураШаблона = ПолучитьИзВременногоХранилища(АдресШаблона);
			Если СтруктураШаблона <> Неопределено Тогда
				
				Если СтруктураШаблона.Свойство("АдресСКДВХранилище")
					И ЗначениеЗаполнено(СтруктураШаблона.АдресСКДВХранилище) Тогда
					АдресСКД = СтруктураШаблона.АдресСКДВХранилище;
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипШаблонаПриИзменении(Элемент)
	
	Объект.ОбъектМетаданных = "";
	АдресШаблона = "";
	УстановитьВидимостьИДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	Элементы.Наименование.СписокВыбора.Очистить();
	Если ЗначениеЗаполнено(Объект.ОбъектМетаданных) 
		И Элементы.ОбъектМетаданных.СписокВыбора.НайтиПоЗначению(Объект.ОбъектМетаданных) <> Неопределено
	Тогда
		СтрокаНаименования = Элементы.ОбъектМетаданных.СписокВыбора.НайтиПоЗначению(Объект.ОбъектМетаданных).Представление;
		Элементы.Наименование.СписокВыбора.Добавить("Чек " + СтрокаНаименования);
		Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьФормуРедактированияМакета(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		
		Оповещение = Новый ОписаниеОповещения("ПерейтиКРедактированиюМакетаЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Для редактирования шаблона необходимо записать элемент! Записать?'"), РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
		
	Иначе
		ПерейтиКРедактированиюМакета();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Записать();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьОбъект(Команда)
	
	Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды


&НаКлиенте
Процедура ПерейтиКРедактированиюМакетаЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		Если ПроверитьЗаполнение() Тогда
			
			ЭтотОбъект.Записать();
			ПерейтиКРедактированиюМакета();
			
		КонецЕсли;;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКРедактированиюМакета()
	
	Если Объект.ТипШаблона = ПредопределенноеЗначение("Перечисление.ТипыШаблонов.ЭтикеткаЦенникПринтераЭтикеток") Тогда
		
		Если НЕ ЗначениеЗаполнено(АдресСКД) Тогда
			УстановитьСКДПоУмолчанию();
		КонецЕсли;
		
		ОповещениеПриЗавершении = Новый ОписаниеОповещения("НачатьРедактированиеМакетаЗавершение", ЭтотОбъект);
		МенеджерОборудованияКлиент.НачатьРедактированиеМакета(ОповещениеПриЗавершении, XMLОписаниеМакета, АдресСКД);
		
		Возврат;
		
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Ссылка", Объект.Ссылка);
	ПараметрыОткрытия.Вставить("ТипШаблона", Объект.ТипШаблона);
	ПараметрыОткрытия.Вставить("АдресШаблона", АдресШаблона);
	ПараметрыОткрытия.Вставить("АдресСКД", АдресСКД);
	
	Если Объект.ТипШаблона = ПредопределенноеЗначение("Перечисление.ТипыШаблонов.ЧекККМ") Тогда
		ПараметрыОткрытия.Вставить("ОбъектМетаданных", "Документ.ЧекККМ");
		ОткрытьФорму("Справочник.ХранилищеШаблонов.Форма.ФормаРедактированияШаблонаЧекаККТ",
			ПараметрыОткрытия,
			ЭтотОбъект,,,,,
			РежимОткрытияОкнаФормы.Независимый);
	Иначе
		ОткрытьФорму("Справочник.ХранилищеШаблонов.Форма.ФормаРедактированияШаблона",
			ПараметрыОткрытия,
			ЭтаФорма,,,,,
			РежимОткрытияОкнаФормы.Независимый);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокМетаданныхИспользующихШаблоны(КоллекцияМетаданных)
	
	Для Каждого МетаданныеОбъекта Из КоллекцияМетаданных Цикл
		Для Каждого Макет Из МетаданныеОбъекта.Макеты Цикл
			Если ВРег(Макет.Имя) = ВРег("ПоляШаблона") Тогда
				Элементы.ОбъектМетаданных.СписокВыбора.Добавить(МетаданныеОбъекта.ПолноеИмя(), МетаданныеОбъекта.Представление());
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	Элементы.ОбъектМетаданных.СписокВыбора.СортироватьПоПредставлению(НаправлениеСортировки.Возр);
	
КонецПроцедуры

&НаСервере
Функция ОбязательныеПараметрыСКДЗаполнены(ТекущийОбъект)
	
	ВсеВерно = Истина;
	Если ТекущийОбъект.СхемаКомпоновкиДанных <> Неопределено Тогда
		
		ПроверяемаяСхема = ТекущийОбъект.СхемаКомпоновкиДанных.Получить();
		
		Если ПроверяемаяСхема = Неопределено Тогда
			Возврат ВсеВерно;
		КонецЕсли;
		
		// Подготовка компоновщика макета компоновки данных, загрузка настроек.
		КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПроверяемаяСхема));
		
		КомпоновщикНастроек.ЗагрузитьНастройки(ПроверяемаяСхема.НастройкиПоУмолчанию);

		НастройкиСКД = КомпоновщикНастроек.Настройки;
		СписокПараметровСКД = НастройкиСКД.ПараметрыДанных.Элементы;
		ИндексПараметра = 0;
		Для Каждого ПараметрСКД Из СписокПараметровСКД Цикл
			Если ТипЗнч(ПараметрСКД) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
				ПараметрНастроек = КомпоновщикНастроек.Настройки.ПараметрыДанных.ДоступныеПараметры.НайтиПараметр(ПараметрСКД.Параметр);
				Если ПараметрНастроек <> Неопределено И ПараметрНастроек.ЗапрещатьНезаполненныеЗначения Тогда
					Если (НЕ ПараметрСКД.Использование) ИЛИ (НЕ ЗначениеЗаполнено(ПараметрСКД.Значение)) Тогда
						ТекстСообщения = НСтр("ru = 'В схеме компоновки не заполнено значение обязательного параметра ""%1"". Откройте редактор макета и настройте параметры СКД.'");
						ИмяПараметраСКД = ?(ЗначениеЗаполнено(ПараметрСКД.ПредставлениеПользовательскойНастройки),
												ПараметрСКД.ПредставлениеПользовательскойНастройки,
												?(ЗначениеЗаполнено(ПараметрНастроек.Заголовок),
																	ПараметрНастроек.Заголовок,
																	ПараметрНастроек.Имя));
						ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ИмяПараметраСКД);
						ОбщегоНазначения.СообщитьПользователю(
							ТекстСообщения,
							,
							"ФормаРедактироватьМакет",
							"Объект");
						ВсеВерно = Ложь;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			ИндексПараметра = ИндексПараметра + 1;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ВсеВерно;
	
КонецФункции

&НаСервере
Процедура ОбработкаОткрытияНастройкиСКД()
	
	Если ЗначениеЗаполнено(АдресСКД) Тогда
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСКД));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьРедактированиеМакетаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		
		Объект.РазмерМакета = ДополнительныеПараметры.РазмерМакета;
		XMLОписаниеМакета = ДополнительныеПараметры.XMLОписаниеМакета;
		Поля.Очистить();
		
		Для Каждого ТекПоле Из ДополнительныеПараметры.Поля Цикл
			
			НовоеПоле = Поля.Добавить();
			ЗаполнитьЗначенияСвойств(НовоеПоле, ТекПоле);
			
		КонецЦикла;
		
		АдресШаблона = СохранитьЗакрытьСервер();
		
	КонецЕсли;
	
	УстановитьВидимостьИДоступностьЭлементов();
	
КонецПроцедуры

&НаСервере
Функция СохранитьЗакрытьСервер()
	
	Возврат ПоместитьВоВременноеХранилище(СтруктураМакетаШаблона(), Новый УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Функция СтруктураМакетаШаблона()
	
	СтруктураМакетаШаблона = Новый Структура;
	
	СтруктураМакетаШаблона.Вставить("РазмерМакета"				, Объект.РазмерМакета);
	СтруктураМакетаШаблона.Вставить("XMLОписаниеМакета"			, XMLОписаниеМакета);
	СтруктураМакетаШаблона.Вставить("АдресСКДВХранилище"		, АдресСКД);
	
	ПоляМакета = Новый Массив;
	
	Для Каждого ТекПоле Из Поля Цикл
		
		НовоеПоле = Новый Структура("Наименование, ТипЗаполнения, Значение, ЗначениеПоУмолчанию, Тип",
			ТекПоле.Наименование,
			ТекПоле.ТипЗаполнения,
			ТекПоле.Значение,
			ТекПоле.ЗначениеПоУмолчанию,
			ТекПоле.Тип);
			
		ПоляМакета.Добавить(НовоеПоле);
		
	КонецЦикла;
	
	СтруктураМакетаШаблона.Вставить("ПоляМакета"				 , ПоляМакета);
	
	Возврат СтруктураМакетаШаблона;
	
КонецФункции

&НаКлиенте
Процедура ПерейтиКРедактированиюСКДЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ЭтаФорма.Модифицированность = Истина;
		ИмяШаблонаСКД = Результат.ИмяТекущегоШаблонаСКД;
		ОбработкаОткрытияНастройкиСКД();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСКДПоУмолчанию()
	
	СКД = Обработки.ПечатьЭтикетокИЦенников.ПолучитьМакет("ПоляШаблона");
	АдресСКД = ПоместитьВоВременноеХранилище(СКД, Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьИДоступностьЭлементов()
	
	ВидимостьОбъектаМетаданных = Ложь;
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОбъектМетаданных",
		"Видимость",
		ВидимостьОбъектаМетаданных);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"РазмерМакета",
		"Видимость",
		(Объект.ТипШаблона = ПредопределенноеЗначение("Перечисление.ТипыШаблонов.ЭтикеткаЦенникПринтераЭтикеток"))
			И ЗначениеЗаполнено(Объект.РазмерМакета));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ТипШаблона",
		"Доступность",
		Объект.ТипШаблона <> Перечисления.ТипыШаблонов.ЧекККМ);
	
КонецПроцедуры

#КонецОбласти

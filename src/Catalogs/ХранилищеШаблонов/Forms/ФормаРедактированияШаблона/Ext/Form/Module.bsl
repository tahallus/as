﻿ 
#Область ПрограммныйИнтерфейс

&НаКлиенте
Процедура ОбработкаОткрытияНастройкиСКД(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ЭтаФорма.Модифицированность = Истина;
		ИмяШаблонаСКД = Результат.ИмяТекущегоШаблонаСКД;
		ОбработкаОткрытияНастройкиСКДСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеЗаполнитьШаблонЭтикеткиПоУмолчанию(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПоместитьВТабличныйДокументШаблонПоУмолчанию("ШаблонЭтикеткиПоУмолчанию");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеЗаполнитьШаблонДисконтнойКартыПоУмолчанию(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПоместитьВТабличныйДокументШаблонПоУмолчанию("ШаблонДисконтнойКартыПоУмолчанию");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеЗаполнитьШаблонПодарочногоСертификатаПоУмолчанию(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПоместитьВТабличныйДокументШаблонПоУмолчанию("ШаблонПодарочногоСертификатаПоУмолчанию");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеЗаполнитьШаблонОбувьПоУмолчанию(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПоместитьВТабличныйДокументШаблонПоУмолчанию("ШаблонЭтикетки_58х40_ИС");
		ТипКода = 18;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеЗаполнитьШаблонОбувьУпаковкаПоУмолчанию(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПоместитьВТабличныйДокументШаблонПоУмолчанию("ШаблонЭтикеткиУпаковки_58х40_ИС");
		ТипКода = 2;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеЗаполнитьШаблонРегистрационнойКартыПоУмолчанию(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПоместитьВТабличныйДокументШаблонПоУмолчанию("ШаблонРегистрационнойКартыПоУмолчанию");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеЗаполнитьШаблонЦенникаПоУмолчанию(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПоместитьВТабличныйДокументШаблонПоУмолчанию("ШаблонЦенникаПоУмолчанию");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеЗаполнитьШаблонЦенникаАкционного(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПоместитьВТабличныйДокументШаблонПоУмолчанию("ШаблонЦенникаАкционного");
	КонецЕсли;
	
КонецПроцедуры

#Область ОповещенияИмпортаИзФайла

&НаКлиенте
Процедура ОповещениеИмпортироватьШаблонИзФайла(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Режим = РежимДиалогаВыбораФайла.Открытие;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Открыть шаблон'");
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	ДиалогОткрытияФайла.ПредварительныйПросмотр = Ложь;
	ДиалогОткрытияФайла.Фильтр = "Шаблоны|*.mxl";
	
	ОбработчикОповещения = Новый ОписаниеОповещения(
										"ВыборФайлаИмпортаШаблонаЗавершение",
										ЭтотОбъект,
										ДополнительныеПараметры);
	ДиалогОткрытияФайла.Показать(ОбработчикОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаИмпортаШаблонаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено
		И ВыбранныеФайлы.Количество() > 0 Тогда
		ДополнительныеПараметры.Вставить("ИмяФайла", ВыбранныеФайлы[0]);
		ОбработчикОповещения = Новый ОписаниеОповещения(
										"ИмпортШаблонаИзФайлаЗавершение",
										ЭтотОбъект,
										ДополнительныеПараметры);
		НачатьПомещениеФайлов(ОбработчикОповещения, Неопределено, ВыбранныеФайлы[0], Ложь) 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИмпортШаблонаИзФайлаЗавершение(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныеФайлы.Количество() > 0 Тогда
		АдресФайла = ПомещенныеФайлы[0].Хранение;
		ЗагрузкаШаблонаИзФайлаЗавершениеСервер(АдресФайла);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОповещениеЭкспортироватьШаблонВФайл(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено
		И ВыбранныеФайлы.Количество() > 0 Тогда
		ПолеТабличногоДокумента.Записать(ВыбранныеФайлы[0]);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеДобавитьШтрихкод(Ответ, ДополнительныеПараметры) Экспорт
	
	ТекущаяОбласть = ДополнительныеПараметры.ТекущаяОбласть;
	ИмяПоляВШаблоне = ДополнительныеПараметры.ИмяПоляВШаблоне;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		ВставитьВШаблонРисунокШтрихкода(ТекущаяОбласть.Имя, ИмяПоляВШаблоне);
		
	Иначе
		
		ТекущаяОбласть.Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Шаблон;
		ТекущаяОбласть.Текст = ТекущаяОбласть.Текст + "["+ИмяПоляВШаблоне+"]";
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеВопросаОЗакрытии(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		СохранитьЗакрыть(Неопределено);
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеВопросаОВключеннойАвтоВысотеСтрок(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		РазрешитьАвтоВысотуСтрок = Истина;
		СохранятьИзменения = Истина;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("ТипШаблона") Тогда
		ТипШаблона = Параметры.ТипШаблона;
	Иначе
		ТипШаблона = Перечисления.ТипыШаблонов.ЭтикеткаЦенник;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СхемаКомпоновкиДанных = Неопределено;
	Если Параметры.Свойство("АдресСКД")
		И ЗначениеЗаполнено(Параметры.АдресСКД) Тогда
		СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(Параметры.АдресСКД);
	КонецЕсли;
	
	// Заполнение доступных полей
	ЭтаФорма.АвтоЗаголовок = Ложь;
	Если ТипШаблона = Перечисления.ТипыШаблонов.ЭтикеткаКодМаркировкиИСМП Тогда
		
		СхемаКомпоновкиДанных = Обработки.ПечатьЭтикетокИЦенников.ПолучитьМакет("ПоляШаблонаИСМП");
		
		ЭтаФорма.Заголовок = НСтр("ru = 'Редактирование шаблона этикетки'");
		Элементы.ГруппаШаблоныПоУмолчанию.Видимость = Ложь;
		Элементы.ФормаЗагрузитьШаблонПодарочногоСертификатаПоУмолчанию.Видимость = Ложь;
		Элементы.ФормаЗагрузитьШаблонДисконтнойКартыПоУмолчанию.Видимость = Ложь;
		Элементы.ФормаЗагрузитьШаблонРегистрационнойКартыПоУмолчанию.Видимость = Ложь;
		Элементы.ФормаЗагрузитьШаблонОбувьПоУмолчанию.Видимость = Истина;
		
	Иначе
		
		Если СхемаКомпоновкиДанных = Неопределено Тогда
			СхемаКомпоновкиДанных = Обработки.ПечатьЭтикетокИЦенников.ПолучитьМакет("ПоляШаблона");
		КонецЕсли;
		
		ЭтаФорма.Заголовок = НСтр("ru = 'Редактирование шаблона ценника (этикетки)'");
		Элементы.ГруппаШаблоныПоУмолчанию.Видимость = Истина;
		Элементы.ФормаЗагрузитьШаблонПодарочногоСертификатаПоУмолчанию.Видимость = Ложь;
		Элементы.ФормаЗагрузитьШаблонДисконтнойКартыПоУмолчанию.Видимость = Ложь;
		Элементы.ФормаЗагрузитьШаблонРегистрационнойКартыПоУмолчанию.Видимость = Ложь;
		Элементы.ФормаЗагрузитьШаблонОбувьПоУмолчанию.Видимость = Ложь;
		
	КонецЕсли;
	
	СтруктураШаблона = СтруктураШаблона();
	АдресВХранилище = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресВХранилище));
	
	Если СтруктураШаблона <> Неопределено Тогда
		// Загрузка шаблона.
		СтруктураШаблона.Свойство("РедакторТабличныйДокумент"	, ПолеТабличногоДокумента);
		СтруктураШаблона.Свойство("КоличествоПоВертикали"		, КоличествоПоВертикали);
		СтруктураШаблона.Свойство("КоличествоПоГоризонтали"		, КоличествоПоГоризонтали);
		СтруктураШаблона.Свойство("ТипКода"						, ТипКода);
		СтруктураШаблона.Свойство("УровеньКоррекцииQR"			, УровеньКоррекцииQR);
		СтруктураШаблона.Свойство("РазмерШрифта"				, РазмерШрифта);
		СтруктураШаблона.Свойство("ОтображатьТекст"				, ОтображатьТекст);
		СтруктураШаблона.Свойство("УголПоворота"				, УголПоворота);
	Иначе
		// Создание нового шаблона.
		ПолеТабличногоДокумента = Новый ТабличныйДокумент;
		ПолеТабличногоДокумента.ОбластьПечати = ПолеТабличногоДокумента.Область("R2C2:R20C5");
		РедкийПунктир = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.РедкийПунктир, 1);
		ПолеТабличногоДокумента.ОбластьПечати.Обвести(РедкийПунктир,РедкийПунктир,РедкийПунктир,РедкийПунктир);
		КоличествоПоГоризонтали = 1;
		КоличествоПоВертикали   = 1;
		ТипКода                 = 99; // Автоматическое определение
		УровеньКоррекцииQR		= 0;
		ОтображатьТекст         = Истина;
		РазмерШрифта            = 12;
		УголПоворота            = 0;
	КонецЕсли;
	
	Элементы.РазмерШрифта.Доступность = ОтображатьТекст;
	Элементы.УровеньКоррекцииQR.Видимость = (ТипКода = 16 ИЛИ ТипКода = 99);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если СохранятьИзменения ИЛИ Модифицированность Тогда
		
		Если ЗавершениеРаботы Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если СохранятьИзменения Тогда
		Если ПолеТабличногоДокумента.ОбластьПечати = Неопределено Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Не установлена область печати'"),
				,
				"ПолеТабличногоДокумента",
				,
				Отказ);
			Возврат;
		КонецЕсли;
		
		НаличиеСтрокСАвтоВысотой = Ложь;
		
		Если Не РазрешитьАвтоВысотуСтрок Тогда
			
			Для Индекс=ПолеТабличногоДокумента.ОбластьПечати.Верх По ПолеТабличногоДокумента.ОбластьПечати.Низ Цикл
				
				Если ПолеТабличногоДокумента.Область("R" + Формат(Индекс, "ЧГ=0")).АвтоВысотаСтроки Тогда
					НаличиеСтрокСАвтоВысотой = Истина;
					Прервать;
				КонецЕсли;
				
			КонецЦикла;
			
			Если НаличиеСтрокСАвтоВысотой Тогда
				
				ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеВопросаОВключеннойАвтоВысотеСтрок", ЭтотОбъект);
				ПоказатьВопрос(ОбработчикОповещения, НСтр("ru = 'В шаблоне содержатся строки с автоопределением высоты.
					|О влиянии строк с автоопределением высоты на печать см. справку справочника ""Шаблоны этикеток, ценников и чеков ККМ"".
					|Продолжить сохранение изменений?'"), РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если РазрешитьАвтоВысотуСтрок ИЛИ НЕ НаличиеСтрокСАвтоВысотой Тогда
			
			АдресШаблона = СохранитьЗакрытьСервер(Отказ);
			
			Если НЕ Отказ Тогда
				Оповестить("ИзмененШаблон", АдресШаблона, ЭтаФорма);
			КонецЕсли;
			
		Иначе
			
			Отказ = Истина;
			
		КонецЕсли;
		
	ИначеЕсли Модифицированность Тогда
		Отказ = Истина;
		ДополнительныеПараметры = Новый Структура;
		ОбработчикОповещения = Новый ОписаниеОповещения(
										"ОповещениеВопросаОЗакрытии",
										ЭтотОбъект,
										ДополнительныеПараметры);
		ПоказатьВопрос(
			ОбработчикОповещения,
			НСтр("ru = 'Данные были изменены. Сохранить изменения?'"),
			РежимДиалогаВопрос.ДаНетОтмена,
			,
			КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтображатьТекстПриИзменении(Элемент)
	Элементы.РазмерШрифта.Доступность = ОтображатьТекст;
КонецПроцедуры

&НаКлиенте
Процедура ТипКодаПриИзменении(Элемент)
	Элементы.УровеньКоррекцииQR.Видимость = (ТипКода = 16 ИЛИ ТипКода = 99);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДоступныеПоля

&НаКлиенте
Процедура ДоступныеПоляВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ЭтаФорма.ТолькоПросмотр Тогда
		Возврат;
	КонецЕсли;

	Модифицированность = Истина;
	ВыбратьДоступнуюСтрокуВШаблон(ВыбраннаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура устанавливает область печати в табличном документе и рисует по краю пунктирную рамку.
//
&НаКлиенте
Процедура УстановитьОбластьПечати(Команда)
	
	Если (ПолеТабличногоДокумента.ВыделенныеОбласти[0].Лево <> 0 И ПолеТабличногоДокумента.ВыделенныеОбласти[0].Верх <> 0)
		И ПолеТабличногоДокумента.ВыделенныеОбласти.Количество() = 1
		И ТипЗнч(ПолеТабличногоДокумента.ВыделенныеОбласти[0]) = Тип("ОбластьЯчеекТабличногоДокумента") Тогда
		
		УстановитьОбластьПечатиНаСервере(ПолеТабличногоДокумента.ВыделенныеОбласти[0].Имя);
		
	Иначе
		
		ОчиститьСообщения();
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Некорректная область печати'");
		Сообщение.Поле = "ПолеТабличногоДокумента";
		Сообщение.Сообщить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьШаблонЭтикеткиПоУмолчанию(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеЗаполнитьШаблонЭтикеткиПоУмолчанию", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Редактируемый шаблон будет заменен на шаблон по умолчанию, продолжить?'"), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьШаблонЦенникаПоУмолчанию(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеЗаполнитьШаблонЦенникаПоУмолчанию", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Редактируемый шаблон будет заменен на шаблон по умолчанию, продолжить?'"), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьШаблонЦенникаАкционного(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеЗаполнитьШаблонЦенникаАкционного", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Редактируемый шаблон будет заменен на шаблон по умолчанию, продолжить?'"), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьШаблонПодарочногоСертификатаПоУмолчанию(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеЗаполнитьШаблонПодарочногоСертификатаПоУмолчанию", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Редактируемый шаблон будет заменен на шаблон по умолчанию, продолжить?'"), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьШаблонОбувьПоУмолчанию(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеЗаполнитьШаблонОбувьПоУмолчанию", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Редактируемый шаблон будет заменен на шаблон по умолчанию, продолжить?'"), РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьШаблонОбувьУпаковкаПоУмолчанию(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеЗаполнитьШаблонОбувьУпаковкаПоУмолчанию", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Редактируемый шаблон будет заменен на шаблон по умолчанию, продолжить?'"), РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьШаблонДисконтнойКартыПоУмолчанию(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеЗаполнитьШаблонДисконтнойКартыПоУмолчанию", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Редактируемый шаблон будет заменен на шаблон по умолчанию, продолжить?'"), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьШаблонРегистрационнойКартыПоУмолчанию(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеЗаполнитьШаблонРегистрационнойКартыПоУмолчанию", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Редактируемый шаблон будет заменен на шаблон по умолчанию, продолжить?'"), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъединитьОбластьЯчеекШаблона(Команда)
	
	Если ПолеТабличногоДокумента.ВыделенныеОбласти.Количество() = 1
		И ТипЗнч(ПолеТабличногоДокумента.ВыделенныеОбласти[0]) = Тип("ОбластьЯчеекТабличногоДокумента") Тогда
		
		ТекущаяОбласть = ПолеТабличногоДокумента.ТекущаяОбласть;
		ОбъединитьОбластьЯчеекШаблонаСервер(ТекущаяОбласть.Имя);
		
	Иначе
		
		ОчиститьСообщения();
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Некорректная область!'");
		Сообщение.Поле = "ПолеТабличногоДокумента";
		Сообщение.Сообщить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазъединитьОбластьЯчеекШаблона(Команда)
	
	Если ПолеТабличногоДокумента.ВыделенныеОбласти.Количество() = 1
		И ТипЗнч(ПолеТабличногоДокумента.ВыделенныеОбласти[0]) = Тип("ОбластьЯчеекТабличногоДокумента") Тогда
		
		ТекущаяОбласть = ПолеТабличногоДокумента.ТекущаяОбласть;
		РазъединитьОбластьЯчеекШаблонаСервер(ТекущаяОбласть.Имя);
		
	Иначе
		
		ОчиститьСообщения();
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Некорректная область!'");
		Сообщение.Поле = "ПолеТабличногоДокумента";
		Сообщение.Сообщить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВШаблонДоступнуюСтроку(Команда)
	
	ТекущаяСтрока = Элементы.ДоступныеПоля.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		ВыбратьДоступнуюСтрокуВШаблон(ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьЗакрыть(Команда)
	
	СохранятьИзменения = Истина;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	СохранятьИзменения = Истина;
	ПередЗакрытием(Ложь, Ложь, "", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмпортироватьШаблонИзФайла(Команда)
	
	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения(
								"ОповещениеИмпортироватьШаблонИзФайла",
								ЭтотОбъект,
								ДополнительныеПараметры);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Текущий шаблон будет потерян. Продолжить?'"), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭкспортШаблонаВФайл(Команда)
	
	Режим = РежимДиалогаВыбораФайла.Сохранение;
	ДиалогСохраненияФайла = Новый ДиалогВыбораФайла(Режим);
	
	ДиалогСохраненияФайла.Заголовок = НСтр("ru = 'Сохранить шаблон'");
	ДиалогСохраненияФайла.ПолноеИмяФайла = "";
	ДиалогСохраненияФайла.ПредварительныйПросмотр = Ложь;
	ДиалогСохраненияФайла.Фильтр = "Шаблоны|*.mxl";
	
	ДополнительныеПараметры = Новый Структура;
	ОбработчикОповещения = Новый ОписаниеОповещения(
										"ОповещениеЭкспортироватьШаблонВФайл",
										ЭтотОбъект,
										ДополнительныеПараметры);
	ДиалогСохраненияФайла.Показать(ОбработчикОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СтруктураШаблона()
	
	ШаблонОбъекта = ?(ПустаяСтрока(Параметры.АдресШаблона), Неопределено, ПолучитьИзВременногоХранилища(Параметры.АдресШаблона));
	
	СтруктураШаблона = Неопределено;
	
	Если ТипЗнч(ШаблонОбъекта) = Тип("Структура") Тогда
		СтруктураШаблона = ШаблонОбъекта;
	Иначе
		ЗначениеКопирования = Неопределено;
		Параметры.Свойство("ЗначениеКопирования", ЗначениеКопирования);
		Если ЗначениеКопирования <> Неопределено Тогда
			СтруктураШаблона = ЗначениеКопирования.Шаблон.Получить();
		КонецЕсли;
	КонецЕсли;
	
	Возврат СтруктураШаблона;
	
КонецФункции

// Возвращает параметры из строки-шаблона табличного документа.
//
&НаСервере
Функция ПозицииПараметров(ТекстЯчейки)
	
	Массив = Новый Массив;
	
	Начало = -1;
	Конец  = -1;
	СчетчикСкобокОткрывающих = 0;
	СчетчикСкобокЗакрывающих = 0;
	
	Для Индекс = 1 По СтрДлина(ТекстЯчейки) Цикл
		Символ = Сред(ТекстЯчейки, Индекс, 1);
		Если Символ = "[" Тогда
			СчетчикСкобокОткрывающих = СчетчикСкобокОткрывающих + 1;
			Если СчетчикСкобокОткрывающих = 1 Тогда
				Начало = Индекс;
			КонецЕсли;
		ИначеЕсли Символ = "]" Тогда
			СчетчикСкобокЗакрывающих = СчетчикСкобокЗакрывающих + 1;
			Если СчетчикСкобокЗакрывающих = СчетчикСкобокОткрывающих Тогда
				Конец = Индекс;
				
				Массив.Добавить(Новый Структура("Начало, Конец", Начало, Конец));
				
				Начало = -1;
				Конец  = -1;
				СчетчикСкобокОткрывающих = 0;
				СчетчикСкобокЗакрывающих = 0;
				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Массив;
	
КонецФункции

// Возвращает структуру макета шаблона ценников и этикеток.
//
&НаСервере
Функция СтруктураМакетаШаблона()
	
	СтруктураМакетаШаблона = Новый Структура;
	
	ПараметрыШаблона       = Новый Соответствие;
	СчетчикПараметров      = 0;
	ПрефиксИмениПараметра  = "ПараметрМакета";
	
	ОбластьМакетаЭтикетки = ПолеТабличногоДокумента.ПолучитьОбласть();
	
	// Копирование настроек табличного документа.
	ЗаполнитьЗначенияСвойств(ОбластьМакетаЭтикетки, ПолеТабличногоДокумента);
	
	Для НомерКолонки = 1 По ОбластьМакетаЭтикетки.ШиринаТаблицы Цикл
		
		Для НомерСтроки = 1 По ОбластьМакетаЭтикетки.ВысотаТаблицы Цикл
			
			Ячейка = ОбластьМакетаЭтикетки.Область(НомерСтроки, НомерКолонки);
			Если Ячейка.Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Шаблон Тогда
				
				МассивПараметров = ПозицииПараметров(Ячейка.Текст);
				
				КоличествоПараметров = МассивПараметров.Количество();
				Для Индекс = 0 По КоличествоПараметров - 1 Цикл
					
					Структура = МассивПараметров[КоличествоПараметров - 1 - Индекс];
					
					ИмяПараметра = Сред(Ячейка.Текст, Структура.Начало + 1, Структура.Конец - Структура.Начало - 1);
					Если Найти(ИмяПараметра, ПрефиксИмениПараметра) = 0 Тогда
						
						ЛеваяЧасть = Лев(Ячейка.Текст, Структура.Начало);
						ПраваяЧасть = Прав(Ячейка.Текст, СтрДлина(Ячейка.Текст) - Структура.Конец+1);
						
						СохраненноеИмяПараметраМакета = ПараметрыШаблона.Получить(ИмяПараметра);
						Если СохраненноеИмяПараметраМакета = Неопределено Тогда
							СчетчикПараметров = СчетчикПараметров + 1;
							Ячейка.Текст = ЛеваяЧасть + (ПрефиксИмениПараметра + СчетчикПараметров) + ПраваяЧасть;
							ПараметрыШаблона.Вставить(ИмяПараметра, ПрефиксИмениПараметра + СчетчикПараметров);
						Иначе
							Ячейка.Текст = ЛеваяЧасть + (СохраненноеИмяПараметраМакета) + ПраваяЧасть;
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЦикла;
				
			ИначеЕсли Ячейка.Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Параметр Тогда
				
				Если Найти(Ячейка.Параметр, ПрефиксИмениПараметра) = 0 Тогда
					СохраненноеИмяПараметраМакета = ПараметрыШаблона.Получить(Ячейка.Параметр);
					Если СохраненноеИмяПараметраМакета = Неопределено Тогда
						СчетчикПараметров = СчетчикПараметров + 1;
						ПараметрыШаблона.Вставить(Ячейка.Параметр, ПрефиксИмениПараметра + СчетчикПараметров);
						Ячейка.Параметр = ПрефиксИмениПараметра + СчетчикПараметров;
					Иначе
						Ячейка.Параметр = СохраненноеИмяПараметраМакета;
					КонецЕсли;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	// Вставляем в параметры штрихкод.
	Если ПараметрыШаблона.Получить(ИмяПараметраШтрихкод()) = Неопределено Тогда
		Для Каждого Рисунок Из ОбластьМакетаЭтикетки.Рисунки Цикл
			Если Лев(Рисунок.Имя,8) = ИмяПараметраШтрихкод() Тогда
				ПараметрыШаблона.Вставить(ИмяПараметраШтрихкод(), ПрефиксИмениПараметра + (СчетчикПараметров+1));
			КонецЕсли;
			Если Лев(Рисунок.Имя,13) = ИмяПараметраШтрихкодСправкиБ() Тогда
				ПараметрыШаблона.Вставить(ИмяПараметраШтрихкодСправкиБ(), ПрефиксИмениПараметра + (СчетчикПараметров+1));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Заменяем на пустую картинку.
	Для Каждого Рисунок Из ОбластьМакетаЭтикетки.Рисунки Цикл
		Если Лев(Рисунок.Имя,8) = ИмяПараметраШтрихкод() ИЛИ Лев(Рисунок.Имя,13) = ИмяПараметраШтрихкодСправкиБ() Тогда
			Рисунок.Картинка = Новый Картинка;
		КонецЕсли;
	КонецЦикла;
	
	СтруктураМакетаШаблона.Вставить("МакетЭтикетки"				, ОбластьМакетаЭтикетки);
	СтруктураМакетаШаблона.Вставить("ИмяОбластиПечати"			, ПолеТабличногоДокумента.ОбластьПечати.Имя);
	СтруктураМакетаШаблона.Вставить("ТипКода"					, ТипКода);
	СтруктураМакетаШаблона.Вставить("УровеньКоррекцииQR"		, УровеньКоррекцииQR);
	СтруктураМакетаШаблона.Вставить("РазмерШрифта"				, РазмерШрифта);
	СтруктураМакетаШаблона.Вставить("ОтображатьТекст"			, ОтображатьТекст);
	СтруктураМакетаШаблона.Вставить("ПараметрыШаблона"			, ПараметрыШаблона);
	СтруктураМакетаШаблона.Вставить("РедакторТабличныйДокумент"	, ПолеТабличногоДокумента);
	СтруктураМакетаШаблона.Вставить("КоличествоПоВертикали"		, КоличествоПоВертикали);
	СтруктураМакетаШаблона.Вставить("КоличествоПоГоризонтали"	, КоличествоПоГоризонтали);
	СтруктураМакетаШаблона.Вставить("УголПоворота"				, УголПоворота);
	СтруктураМакетаШаблона.Вставить("АдресСКДВХранилище"		, АдресВХранилище);
	
	Возврат СтруктураМакетаШаблона;
	
КонецФункции

// Выполняет проверку размещения ценников и этикеток на листе с заданными параметрами.
//
&НаСервере
Процедура ПроверитьРазмещение(Отказ)
	
	ОбластьМакета = ПолеТабличногоДокумента.ПолучитьОбласть(ПолеТабличногоДокумента.ОбластьПечати.Имя);
	
	НовыйТабличныйДокумент = Новый ТабличныйДокумент;
	НовыйТабличныйДокумент.РазмерСтраницы = ПолеТабличногоДокумента.РазмерСтраницы;
	НовыйТабличныйДокумент.ОриентацияСтраницы = ПолеТабличногоДокумента.ОриентацияСтраницы;
	
	НовыйТабличныйДокумент.ПолеСлева = ПолеТабличногоДокумента.ПолеСлева;
	НовыйТабличныйДокумент.ПолеСправа = ПолеТабличногоДокумента.ПолеСправа;
	НовыйТабличныйДокумент.ПолеСверху = ПолеТабличногоДокумента.ПолеСверху;
	НовыйТабличныйДокумент.ПолеСнизу = ПолеТабличногоДокумента.ПолеСнизу;
	
	НовыйТабличныйДокумент.РазмерКолонтитулаСверху = ПолеТабличногоДокумента.РазмерКолонтитулаСверху;
	НовыйТабличныйДокумент.РазмерКолонтитулаСнизу = ПолеТабличногоДокумента.РазмерКолонтитулаСнизу;
	
	НовыйТабличныйДокумент.МасштабПечати = ПолеТабличногоДокумента.МасштабПечати;
	НовыйТабличныйДокумент.ЭкземпляровНаСтранице = ПолеТабличногоДокумента.ЭкземпляровНаСтранице;
	
	Если НЕ (ПолеТабличногоДокумента.ОбластьПечати.Лево = 0 И ПолеТабличногоДокумента.ОбластьПечати.Право = 0) Тогда
		
		МассивТаблиц = Новый Массив;
		Для Инд = 1 По КоличествоПоГоризонтали Цикл
			МассивТаблиц.Добавить(ОбластьМакета);
		КонецЦикла;
		
		Пока НЕ НовыйТабличныйДокумент.ПроверитьПрисоединение(МассивТаблиц) Цикл
			МассивТаблиц.Удалить(МассивТаблиц.Количество()-1);
		КонецЦикла;
		
		Если КоличествоПоГоризонтали <> МассивТаблиц.Количество() Тогда
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru = 'Максимальное количество по горизонтали:'") + " " + МассивТаблиц.Количество();
			Сообщение.Поле  = "КоличествоПоГоризонтали";
			Сообщение.Сообщить();
			
			Отказ = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ (ПолеТабличногоДокумента.ОбластьПечати.Верх = 0 И ПолеТабличногоДокумента.ОбластьПечати.Низ = 0) Тогда
		
		МассивТаблиц = Новый Массив;
		Для Инд = 1 По КоличествоПоВертикали Цикл
			МассивТаблиц.Добавить(ОбластьМакета);
		КонецЦикла;
		
		Пока НЕ НовыйТабличныйДокумент.ПроверитьВывод(МассивТаблиц) Цикл
			МассивТаблиц.Удалить(МассивТаблиц.Количество()-1);
		КонецЦикла;
		
		Если КоличествоПоВертикали <> МассивТаблиц.Количество() Тогда
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru = 'Максимальное количество по вертикали:'") +" " + МассивТаблиц.Количество();
			Сообщение.Поле  = "КоличествоПоВертикали";
			Сообщение.Сообщить();
			
			Отказ = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Отказ Тогда
		СохранятьИзменения = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает область печати в табличном документе и рисует по краю пунктирную рамку.
//
&НаСервере
Процедура УстановитьОбластьПечатиНаСервере(ИмяОбласти)
	
	ВыделеннаяОбласть = ПолеТабличногоДокумента.Область(ИмяОбласти);
	
	НетЛинии = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.НетЛинии, 0);
	РедкийПунктир = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.РедкийПунктир, 1);
	
	Если ПолеТабличногоДокумента.ОбластьПечати <> Неопределено Тогда
		ПолеТабличногоДокумента.ОбластьПечати.Обвести(НетЛинии,НетЛинии,НетЛинии,НетЛинии);
	КонецЕсли;
	
	ПолеТабличногоДокумента.ОбластьПечати = ВыделеннаяОбласть;
	ПолеТабличногоДокумента.ОбластьПечати.Обвести(РедкийПунктир,РедкийПунктир,РедкийПунктир,РедкийПунктир);
	
	ПолеТабличногоДокумента.ОбластьПечати.АвтоВысотаСтроки = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ВставитьВШаблонРисунокШтрихкода(ИмяТекущейОбласти, ИмяПоляВШаблоне)
	
	// Получим рисунок штрихкода из дополнительного макета.
	МакетШтрихкода = Новый Картинка(Справочники.ХранилищеШаблонов.ПолучитьМакет("КартинкаШтрихкода"));
	
	РисунокШтрихкода = ПолеТабличногоДокумента.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Картинка);
	Индекс = ПолеТабличногоДокумента.Рисунки.Индекс(РисунокШтрихкода);
	ПолеТабличногоДокумента.Рисунки[Индекс].Картинка = МакетШтрихкода;
	ПолеТабличногоДокумента.Рисунки[Индекс].Имя = ИмяПоляВШаблоне+СтрЗаменить(Новый УникальныйИдентификатор,"-","_");
	ПолеТабличногоДокумента.Рисунки[Индекс].РазмерКартинки = РазмерКартинки.РеальныйРазмер;
	ПолеТабличногоДокумента.Рисунки[Индекс].Расположить(ПолеТабличногоДокумента.Область(ИмяТекущейОбласти));
	
КонецПроцедуры

// Возвращает строку с именем параметра штрихкода для передачи в СКД (Схему Компоновки Данных).
//
&НаКлиентеНаСервереБезКонтекста
Функция ИмяПараметраШтрихкод()
	
	Возврат "Штрихкод";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяПараметраШтрихкодСправкиБ()
	
	Возврат "ШтрихСправкиБ";
	
КонецФункции

&НаСервере
Процедура ОбъединитьОбластьЯчеекШаблонаСервер(ИмяОбласти)
	
	Область = ПолеТабличногоДокумента.Область(ИмяОбласти);
	Область.Объединить();
	
КонецПроцедуры

&НаСервере
Процедура РазъединитьОбластьЯчеекШаблонаСервер(ИмяОбласти)
	
	Область = ПолеТабличногоДокумента.Область(ИмяОбласти);
	Область.Разъединить();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьДоступнуюСтрокуВШаблон(ВыбраннаяСтрока)
	
	// Перед началом добавления необходимо выделить область в табличном документе.
	Если ТипЗнч(ПолеТабличногоДокумента.ТекущаяОбласть) <> Тип("ОбластьЯчеекТабличногоДокумента") Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Для переноса поля шаблона нужно выделить ячейку или область ячеек!'"));
		Возврат;
	Иначе
		ТекущаяОбласть = ПолеТабличногоДокумента.ТекущаяОбласть;
		ОбъединитьОбластьЯчеекШаблонаСервер(ТекущаяОбласть.Имя);
	КонецЕсли;
	
	ДоступноеПоле = КомпоновщикНастроек.Настройки.ДоступныеПоляПорядка.ПолучитьОбъектПоИдентификатору(ВыбраннаяСтрока);
	Если ДоступноеПоле.Папка Тогда
		Возврат;
	КонецЕсли;
	
	// Подготовка данных.
	ИмяПоляВШаблоне = Строка(ДоступноеПоле.Поле);
	
	// Размещение поля в шаблоне.
	Если ИмяПоляВШаблоне = ИмяПараметраШтрихкод() ИЛИ ИмяПоляВШаблоне = ИмяПараметраШтрихкодСправкиБ() Тогда
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("ТекущаяОбласть", ТекущаяОбласть);
			ДополнительныеПараметры.Вставить("ИмяПоляВШаблоне", ИмяПоляВШаблоне);

		ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеДобавитьШтрихкод", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Добавить штрихкод, как картинку?'"), РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ТекущаяОбласть.Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Шаблон;
		ТекущаяОбласть.Текст = ТекущаяОбласть.Текст + "["+ИмяПоляВШаблоне+"]";
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПоместитьВТабличныйДокументШаблонПоУмолчанию(ИмяШаблона)
	
	ШаблонПоУмолчанию = Справочники.ХранилищеШаблонов.ПолучитьМакет(ИмяШаблона);
	
	ПолеТабличногоДокумента = ШаблонПоУмолчанию;
	
	Если Ложь Тогда
		
	ИначеЕсли ИмяШаблона = "ШаблонЦенникаАкционного" Тогда
		
		СхемаКомпоновкиДанных = Обработки.ПечатьЭтикетокИЦенников.ПолучитьМакет("ПоляШаблонаЦенникАкционный");
		
	ИначеЕсли ИмяШаблона = "ШаблонЭтикетки_58х40_ИС" Тогда
		
		СхемаКомпоновкиДанных = Обработки.ПечатьЭтикетокИЦенников.ПолучитьМакет("ПоляШаблонаИСМП");
		
	ИначеЕсли ИмяШаблона = "ШаблонЭтикеткиУпаковки_58х40_ИС" Тогда
		
		СхемаКомпоновкиДанных = Обработки.ПечатьЭтикетокИЦенников.ПолучитьМакет("ПоляШаблонаИСМП");
		
	Иначе
		
		СхемаКомпоновкиДанных = Обработки.ПечатьЭтикетокИЦенников.ПолучитьМакет("ПоляШаблона");
		
	КонецЕсли;
	
	АдресВХранилище = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресВХранилище));
	
КонецПроцедуры

&НаСервере
Функция СохранитьЗакрытьСервер(Отказ)
	
	ПроверитьРазмещение(Отказ);
	
	Возврат ПоместитьВоВременноеХранилище(СтруктураМакетаШаблона(), Новый УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ПолеТабличногоДокументаПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаОткрытияНастройкиСКДСервер()
	
	Если ЗначениеЗаполнено(АдресВХранилище) Тогда
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресВХранилище));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузкаШаблонаИзФайлаЗавершениеСервер(АдресФайла)
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайла);
	ИмяВременногоФайла = КаталогВременныхФайлов() + Новый УникальныйИдентификатор + ".xml";
	ДвоичныеДанные.Записать(ИмяВременногоФайла);
	ПолеТабличногоДокумента.Очистить();
	ПолеТабличногоДокумента.Прочитать(ИмяВременногоФайла);
	УдалитьФайлы(ИмяВременногоФайла);
	
КонецПроцедуры

// Проверка внедрения БСП
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Если Ложь Тогда
		ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	Если Ложь Тогда
		ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	Если Ложь Тогда
		ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Неопределено);
	КонецЕсли;
КонецПроцедуры
// Конец Проверка внедрения БСП

#КонецОбласти

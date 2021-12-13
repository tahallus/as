﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АдресКаталогаТоваров") Тогда
		ТЗ = ПолучитьИзВременногоХранилища(Параметры.АдресКаталогаТоваров);
		МассивНоменклатуры = ТЗ.ВыгрузитьКолонку("Номенклатура");
		СписокВыбранных.ЗагрузитьЗначения(МассивНоменклатуры);
	КонецЕсли;
	
	Если Параметры.Свойство("ОтборНоменклатуры") Тогда
		ОтборНоменклатуры = Параметры.ОтборНоменклатуры;
		Элементы.СписокНоменклатурыВБазеГруппы.Видимость = Ложь;
		Элементы.СписокНоменклатурыВБазеКатегории.Видимость = Истина;
	Иначе
		ОтборНоменклатуры = Перечисления.ВидыОтборовНоменклатуры.КатегорииНоменклатуры;
	КонецЕсли;
	
	Элементы.СписокНоменклатурыВБазеГруппы.Видимость = ОтборНоменклатуры <> Перечисления.ВидыОтборовНоменклатуры.КатегорииНоменклатуры;
	Элементы.СписокНоменклатурыВБазеКатегории.Видимость = ОтборНоменклатуры = Перечисления.ВидыОтборовНоменклатуры.КатегорииНоменклатуры;		
	
	Если Параметры.Свойство("ВидЦен") Тогда
		ВидЦен = Параметры.ВидЦен;
	Иначе
		ВидЦен = Справочники.ВидыЦен.Оптовая;
	КонецЕсли;
	
	Если Параметры.Свойство("ТипПоля") Тогда
		ТипПоля = Параметры.ТипПоля;
	Иначе
		ТипПоля = Перечисления.ТипыПолейКонструктораФорм.ОдинИзСписка;
	КонецЕсли;
	
	Если Параметры.Свойство("ЗаголовокПоля") Тогда
		ЗаголовокПоля = Параметры.ЗаголовокПоля;
	Иначе
		ЗаголовокПоля = "";
	КонецЕсли;

	Элементы.ТипПоля.СписокВыбора.Добавить(Перечисления.ТипыПолейКонструктораФорм.ОдинИзСписка, НСтр("ru = 'Один из списка'"));
	Элементы.ТипПоля.СписокВыбора.Добавить(Перечисления.ТипыПолейКонструктораФорм.НесколькоИзСписка, НСтр("ru = 'Несколько из списка'"));
	Элементы.ТипПоля.СписокВыбора.Добавить(Перечисления.ТипыПолейКонструктораФорм.РаскрывающийсяСписок, НСтр("ru = 'Раскрывающийся список'"));
	Элементы.ТипПоля.РежимВыбораИзСписка = Истина;
	
	СписокНоменклатурыВБазеГруппы.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДатаСеанса());
	СписокНоменклатурыВБазеГруппы.Параметры.УстановитьЗначениеПараметра("ВидЦен", ВидЦен);
	
	СписокНоменклатурыВБазеКатегории.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДатаСеанса());
	СписокНоменклатурыВБазеКатегории.Параметры.УстановитьЗначениеПараметра("ВидЦен", ВидЦен);
	
	СписокНоменклатурыВыбранной.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДатаСеанса());
	СписокНоменклатурыВыбранной.Параметры.УстановитьЗначениеПараметра("ВидЦен", ВидЦен);
	
	УстановитьОтборы();
	ОбновитьКартинкуПоля();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура ТипПоляПриИзменении(Элемент)
	ОбновитьКартинкуПоля();
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыВБазеГруппыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Перемещение;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыВыбраннойПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	СписокНоменклатурыВыбраннойПеретаскиваниеНаСервере(ПараметрыПеретаскивания.Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыВыбраннойОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Перемещение Тогда
		СписокНоменклатурыВыбраннойОкончаниеПеретаскиванияНаСервере(ПараметрыПеретаскивания.Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыВБазеКатегорииПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Перемещение;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыВБазеГруппыВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Перенести1ВВыгрузкуНаСервере(Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыВБазеКатегорииВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Перенести1ВВыгрузкуНаСервере(Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыВыбраннойВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Удалить1ИзВыгрузкиНаСервере(Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВсеВВыгрузку(Команда)
	
	ПеренестиВсеВВыгрузкуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Перенести1ВВыгрузку(Команда)
	
	Если Элементы.СписокНоменклатурыВБазеГруппы.Видимость Тогда
		ТекущиеДанные = Элементы.СписокНоменклатурыВБазеГруппы.ТекущиеДанные;
		СписокНоменклатурыВыбраннойПеретаскиваниеНаСервере(Элементы.СписокНоменклатурыВБазеГруппы.ВыделенныеСтроки);
	КонецЕсли;
	
	Если Элементы.СписокНоменклатурыВБазеКатегории.Видимость Тогда
		ТекущаяСтрока = Элементы.СписокНоменклатурыВБазеКатегории.ТекущаяСтрока;
		ТекущиеДанные = Элементы.СписокНоменклатурыВБазеКатегории.ТекущиеДанные;
		СписокНоменклатурыВыбраннойПеретаскиваниеНаСервере(Элементы.СписокНоменклатурыВБазеКатегории.ВыделенныеСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Удалить1ИзВыгрузки(Команда)
	
	СписокНоменклатурыВыбраннойОкончаниеПеретаскиванияНаСервере(Элементы.СписокНоменклатурыВыбранной.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВсеИзВыгрузки(Команда)
	
	УдалитьВсеИзВыгрузкиНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если ЕстьОшибкиЗаполнения() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("ТипПоля", ТипПоля);
	СтруктураВозврата.Вставить("Заголовок", ЗаголовокПоля);
	СтруктураВозврата.Вставить("ВидЦен", ВидЦен);
	СтруктураВозврата.Вставить("ОтборНоменклатуры", ОтборНоменклатуры);
	СтруктураВозврата.Вставить("АдресВХранилище", 			  СохранитьВыбраннуюНоменклатуруВТЗ());
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Функция ЕстьОшибкиЗаполнения()
	
	ЕстьОшибки = Ложь;
	
	Если НЕ ЗначениеЗаполнено(ТипПоля) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не заполнено представление списка товаров'"),,"ТипПоля");
		ЕстьОшибки = Истина;
	КонецЕсли;
	
	Возврат ЕстьОшибки;
	
КонецФункции

&НаКлиенте
Процедура СписокНоменклатурыВБазеГруппыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	Для каждого ТекущаяНоменклатура Из Элемент.ВыделенныеСтроки Цикл
		
		ДанныеСтроки = Элемент.ДанныеСтроки(ТекущаяНоменклатура);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыВБазеКатегорииНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	Для каждого ТекущаяНоменклатура Из Элемент.ВыделенныеСтроки Цикл
		
		Если ТипЗнч(ТекущаяНоменклатура) <> Тип("СправочникСсылка.Номенклатура") Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеСтроки = Элемент.ДанныеСтроки(ТекущаяНоменклатура);
		
		Если ДанныеСтроки <> Неопределено И ДанныеСтроки.Цена = 0 Тогда
			ИндексЭлемента = ПараметрыПеретаскивания.Значение.Найти(ТекущаяНоменклатура);
			Если ИндексЭлемента <> Неопределено Тогда
				ПараметрыПеретаскивания.Значение.Удалить(ИндексЭлемента);
				ТекстСообщения = СтрШаблон(НСтр("ru ='%1 - отсутствует цена. Данный товар не попадет в выгрузку'"), Строка(ТекущаяНоменклатура));
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюОКоличествеИРазмереКартинок()
	
	Запрос = Новый Запрос();
	Запрос.Текст = СписокНоменклатурыВыбранной.ТекстЗапроса;
	
	Запрос.УстановитьПараметр("СписокВыбранных", СписокВыбранных.ВыгрузитьЗначения());
	Запрос.УстановитьПараметр("СписокГрупп", СписокГрупп.ВыгрузитьЗначения());
	Запрос.УстановитьПараметр("СписокИсключенных", СписокИсключенных.ВыгрузитьЗначения());
	Запрос.УстановитьПараметр("СписокКатегорий", СписокКатегорий.ВыгрузитьЗначения());
	Запрос.УстановитьПараметр("ВидЦен", ВидЦен);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	
	КоличествоВыбранныхСтрок = ТЗ.Количество();
	
	Элементы.ДекорацияПревышеноКоличествоТоваров.Заголовок = СтрШаблон(НСтр("ru ='Выбрано %1 (Максимум %2)'"), КоличествоВыбранныхСтрок, 1000);
	
	ЗаблокироватьЗаписатьИЗакрыть = Ложь;
	Если КоличествоВыбранныхСтрок > 1000 Тогда
		Элементы.ДекорацияПревышеноКоличествоТоваров.ЦветТекста = ЦветаСтиля.ДосьеПлохаяОценкаЦвет;
		Элементы.ДекорацияПревышеноКоличествоТоваров.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
		ЗаблокироватьЗаписатьИЗакрыть = Истина;
	Иначе
		Элементы.ДекорацияПревышеноКоличествоТоваров.ЦветТекста = Новый Цвет();
		Элементы.ДекорацияПревышеноКоличествоТоваров.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
	КонецЕсли;
	
	Элементы.ФормаЗаписатьИЗакрыть.Доступность = НЕ ЗаблокироватьЗаписатьИЗакрыть;
	
КонецПроцедуры

#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьКартинкуПоля()
	
	Если ТипПоля = Перечисления.ТипыПолейКонструктораФорм.ОдинИзСписка Тогда
		Элементы.ДекорацияПримерПоля.Картинка = БиблиотекаКартинок.ПримерПоляКонтактнойФормы_1;
	КонецЕсли;
	
	Если ТипПоля = Перечисления.ТипыПолейКонструктораФорм.НесколькоИзСписка Тогда
		Элементы.ДекорацияПримерПоля.Картинка = БиблиотекаКартинок.ПримерПоляКонтактнойФормы_2;
	КонецЕсли;
	
	Если ТипПоля = Перечисления.ТипыПолейКонструктораФорм.РаскрывающийсяСписок Тогда
		Элементы.ДекорацияПримерПоля.Картинка = БиблиотекаКартинок.ПримерПоляКонтактнойФормы_3;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СписокНоменклатурыВыбраннойПеретаскиваниеНаСервере(Знач МассивЭлементов)
	
	Для каждого ТекЭлемент Из МассивЭлементов Цикл
		ДобавитьЭлементВВыбранные(ТекЭлемент);
	КонецЦикла;
	
	УстановитьОтборы();
	
КонецПроцедуры

&НаСервере
Процедура СписокНоменклатурыВыбраннойОкончаниеПеретаскиванияНаСервере(Знач МассивЭлементов)
	
	Для каждого ТекЭлемент Из МассивЭлементов Цикл
		УдалитьЭлементИзВыбранных(ТекЭлемент);
	КонецЦикла;
	
	УстановитьОтборы();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборы()
	
	СписокНоменклатурыВыбранной.Параметры.УстановитьЗначениеПараметра("СписокВыбранных", СписокВыбранных.ВыгрузитьЗначения());
	СписокНоменклатурыВыбранной.Параметры.УстановитьЗначениеПараметра("СписокГрупп", СписокГрупп.ВыгрузитьЗначения());
	СписокНоменклатурыВыбранной.Параметры.УстановитьЗначениеПараметра("СписокИсключенных", СписокИсключенных.ВыгрузитьЗначения());
	СписокНоменклатурыВыбранной.Параметры.УстановитьЗначениеПараметра("СписокКатегорий", СписокКатегорий.ВыгрузитьЗначения());
	
	Элементы.СписокНоменклатурыВыбранной.Обновить();
	ОбновитьИнформациюОКоличествеИРазмереКартинок();
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьЭлементВВыбранные(ТекЭлемент)
	
	Если НЕ ЗначениеЗаполнено(ТекЭлемент) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекЭлемент) = Тип("СправочникСсылка.Номенклатура") Тогда
		ЭтоГруппа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекЭлемент, "ЭтоГруппа");
		Если ЭтоГруппа Тогда
			ДобавитьГруппуВОтбор(ТекЭлемент);
		Иначе
			ДобавитьНоменклатуруВОтбор(ТекЭлемент);
			УдалитьНоменклатуруИзИсключенных(ТекЭлемент);
		КонецЕсли;
	ИначеЕсли ТипЗнч(ТекЭлемент) = Тип("СтрокаГруппировкиДинамическогоСписка")
		И ТипЗнч(ТекЭлемент.Ключ) = Тип("СправочникСсылка.КатегорииНоменклатуры") Тогда
		ДобавитьКатегориюВОтбор(ТекЭлемент.Ключ);
	КонецЕсли;

КонецПроцедуры 

&НаСервере
Процедура ДобавитьГруппуВОтбор(ТекЭлемент)
	
	Если СписокГрупп.НайтиПоЗначению(ТекЭлемент) = Неопределено Тогда
		СписокГрупп.Добавить(ТекЭлемент);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка В ИЕРАРХИИ(&Группа)";
	
	Запрос.УстановитьПараметр("Группа", ТекЭлемент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		УдалитьНоменклатуруИзИсключенных(Выборка.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьНоменклатуруВОтбор(ТекЭлемент)
	
	Если СписокВыбранных.НайтиПоЗначению(ТекЭлемент) = Неопределено Тогда
		СписокВыбранных.Добавить(ТекЭлемент);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьКатегориюВОтбор(ТекЭлемент)
	
	Если СписокКатегорий.НайтиПоЗначению(ТекЭлемент) = Неопределено Тогда
		СписокКатегорий.Добавить(ТекЭлемент);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.КатегорияНоменклатуры = &КатегорияНоменклатуры";
	
	Запрос.УстановитьПараметр("КатегорияНоменклатуры", ТекЭлемент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		УдалитьНоменклатуруИзИсключенных(Выборка.Ссылка);
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ДобавитьИсключеннуюНоменклатуруВОтбор(ТекЭлемент)
	
	Если СписокИсключенных.НайтиПоЗначению(ТекЭлемент) = Неопределено Тогда
		СписокИсключенных.Добавить(ТекЭлемент);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьНоменклатуруИзВыбранных(ТекЭлемент)
	
	Номенклатура = СписокВыбранных.НайтиПоЗначению(ТекЭлемент);
	Если Номенклатура <> Неопределено Тогда
		СписокВыбранных.Удалить(Номенклатура);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьНоменклатуруИзИсключенных(ТекЭлемент)
	
	Номенклатура = СписокИсключенных.НайтиПоЗначению(ТекЭлемент);
	Если Номенклатура <> Неопределено Тогда
		СписокИсключенных.Удалить(Номенклатура);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьЭлементИзВыбранных(ТекЭлемент)
	
	Если НЕ ЗначениеЗаполнено(ТекЭлемент) Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьИсключеннуюНоменклатуруВОтбор(ТекЭлемент);
	УдалитьНоменклатуруИзВыбранных(ТекЭлемент);
	
КонецПроцедуры 

&НаСервере
Процедура ПеренестиВсеВВыгрузкуНаСервере()
	
	УдалитьВсеИзВыгрузкиНаСервере();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.ЭтоГруппа
	|	И НЕ Номенклатура.ПометкаУдаления";
	
	МассивГрупп = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	МассивГрупп.Добавить(Справочники.Номенклатура.ПустаяСсылка());
	
	Для каждого ТекЭлемент Из МассивГрупп Цикл
		ДобавитьГруппуВОтбор(ТекЭлемент);
	КонецЦикла;
	
	УстановитьОтборы();
	
КонецПроцедуры

&НаСервере
Процедура Перенести1ВВыгрузкуНаСервере(ТекЭлемент)
	
	ДобавитьЭлементВВыбранные(ТекЭлемент);
	УстановитьОтборы();
	
КонецПроцедуры

&НаСервере
Процедура Удалить1ИзВыгрузкиНаСервере(ТекЭлемент)
	
	УдалитьЭлементИзВыбранных(ТекЭлемент);
	УстановитьОтборы();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьВсеИзВыгрузкиНаСервере()
	
	СписокВыбранных.Очистить();
	СписокГрупп.Очистить();
	СписокИсключенных.Очистить();
	СписокКатегорий.Очистить();
	УстановитьОтборы();
	
КонецПроцедуры

&НаСервере
Функция СохранитьВыбраннуюНоменклатуруВТЗ()
	
	Запрос = Новый Запрос();
	Запрос.Текст = СписокНоменклатурыВыбранной.ТекстЗапроса;
	
	Запрос.УстановитьПараметр("СписокВыбранных", СписокВыбранных.ВыгрузитьЗначения());
	Запрос.УстановитьПараметр("СписокГрупп", СписокГрупп.ВыгрузитьЗначения());
	Запрос.УстановитьПараметр("СписокИсключенных", СписокИсключенных.ВыгрузитьЗначения());
	Запрос.УстановитьПараметр("СписокКатегорий", СписокКатегорий.ВыгрузитьЗначения());
	Запрос.УстановитьПараметр("ВидЦен", ВидЦен);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	
	АдресВХранилище = ПоместитьВоВременноеХранилище(ТЗ, Новый УникальныйИдентификатор);
	
	Возврат АдресВХранилище;
КонецФункции

&НаКлиенте
Процедура ОтборНоменклатурыПриИзменении(Элемент)
	УстановитьВидимостьИерархии();
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьИерархии()
	Элементы.СписокНоменклатурыВБазеГруппы.Видимость = ОтборНоменклатуры <> Перечисления.ВидыОтборовНоменклатуры.КатегорииНоменклатуры;
	Элементы.СписокНоменклатурыВБазеКатегории.Видимость = ОтборНоменклатуры = Перечисления.ВидыОтборовНоменклатуры.КатегорииНоменклатуры;
КонецПроцедуры

&НаКлиенте
Процедура ВидЦенПриИзменении(Элемент)
	
	СписокНоменклатурыВБазеГруппы.Параметры.УстановитьЗначениеПараметра("ВидЦен", ВидЦен);
	СписокНоменклатурыВБазеКатегории.Параметры.УстановитьЗначениеПараметра("ВидЦен", ВидЦен);
	СписокНоменклатурыВыбранной.Параметры.УстановитьЗначениеПараметра("ВидЦен", ВидЦен);
	Элементы.СписокНоменклатурыВыбранной.Обновить();
	
КонецПроцедуры

#КонецОбласти





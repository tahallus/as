﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если РаботаВМоделиСервиса.РазделениеВключено() Тогда
		
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		
		Элементы.Служебные.Видимость 			 = Ложь;
		Элементы.Служебные.Доступность			 = Ложь;
		
	КонецЕсли;
	
	РежимСинхронизации = 
		?(Не Объект.РучнойОбмен, "АвтоматическаяСинхронизация", "РучнаяСинхронизация")
	;
	
	РежимСинхронизацииОрганизаций =
		?(Объект.ИспользоватьОтборПоОрганизациям, "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям", "СинхронизироватьДанныеПоВсемОрганизациям")
	;
	
	РежимСинхронизацииДокументов =
		?(Объект.ИспользоватьОтборПоВидамДокументов, "СинхронизироватьДанныеТолькоПоВыбраннымВидамДокументов", "СинхронизироватьДанныеПоВсемДокументам")
	;
	
	УстановитьВидимостьНаСервере();
	ПриИзмененииРежимаСинхронизацииДанных();
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если РежимСинхронизации <> "АвтоматическаяСинхронизация" Тогда
		
		ТекущийОбъект.ИспользоватьОтборПоОрганизациям = Ложь;
		ТекущийОбъект.Организации.Очистить();
		
		ТекущийОбъект.ИспользоватьОтборПоВидамДокументов = Ложь;
		ТекущийОбъект.ВидыДокументов.Очистить();
		
		ТекущийОбъект.РучнойОбмен = Истина;
		ТекущийОбъект.РежимСинхронизацииДанных = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную;
		
	Иначе
		
		Если ТекущийОбъект.Организации.Количество() > 0 Тогда
			Если РежимСинхронизацииОрганизаций = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям" Тогда
				ТекущийОбъект.ИспользоватьОтборПоОрганизациям = Истина;
			Иначе
				ТекущийОбъект.ИспользоватьОтборПоОрганизациям = Ложь;
				ТекущийОбъект.Организации.Очистить();
			КонецЕсли;
		Иначе
			ТекущийОбъект.ИспользоватьОтборПоОрганизациям = Ложь;
		КонецЕсли;
		
		Если ТекущийОбъект.ВидыДокументов.Количество() > 0 Тогда
			Если РежимСинхронизацииДокументов = "СинхронизироватьДанныеТолькоПоВыбраннымВидамДокументов" Тогда
				ТекущийОбъект.ИспользоватьОтборПоВидамДокументов = Истина;
			Иначе
				ТекущийОбъект.ИспользоватьОтборПоВидамДокументов = Ложь;
				ТекущийОбъект.ВидыДокументов.Очистить();
			КонецЕсли;
		Иначе
			ТекущийОбъект.ИспользоватьОтборПоВидамДокументов = Ложь;
		КонецЕсли;
		
		ТекущийОбъект.РучнойОбмен = Ложь;
		ТекущийОбъект.РежимСинхронизацииДанных = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВсегда;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ОбменДаннымиСервер.ФормаУзлаПриЗаписиНаСервере(ТекущийОбъект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Оповестить("ЗакрытаФормаУзлаПланаОбмена");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ОбновитьДанныеОбъекта(ВыбранноеЗначение);
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьФормуОтбораПоОрганизациям(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("МассивОрганизаций", ПолучитьМассивОбъектовТабличнойЧасти("Организации", "Организация"));
	
	ОткрытьФорму("ПланОбмена.ОбменУправлениеНебольшойФирмойБухгалтерия20.Форма.ФормаВыбораОрганизаций",
		ПараметрыФормы,
		ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииОрганизацийПриИзменении(Элемент)
	
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииДокументовПриИзменении(Элемент)
	
	Если РежимСинхронизацииДокументов = "СинхронизироватьДанныеТолькоПоДокументамОтобраннымВручную" Тогда
		РежимСинхронизации = "РучнаяСинхронизация";
	КонецЕсли;
	
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтбораПоВидамДокументов(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ВидыДокументов", ПолучитьМассивОбъектовТабличнойЧасти("ВидыДокументов", "ИмяОбъектаМетаданных"));
	
	ОткрытьФорму("ПланОбмена.ОбменУправлениеНебольшойФирмойБухгалтерия20.Форма.ФормаВыбораВидовДокументов",
		ПараметрыФормы,
		ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьОтборПоОрганизациям(Команда)
	
	ТекстЗаголовка = НСтр("ru='Подтверждение'");
	ТекстВопроса   = НСтр("ru='Очистить отбор по организациям?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("ОчиститьОтборПоОрганизациямЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет,,,ТекстЗаголовка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьОтборПоОрганизациямЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Ответ = Результат;
    Если Ответ=КодВозвратаДиалога.Да Тогда
        Объект.Организации.Очистить();
        УстановитьВидимостьНаСервере();
        ОбновитьНаименованиеКомандФормы();
        Модифицированность = Истина;
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьОтборПоВидамДокументов(Команда)
	
	ТекстЗаголовка = НСтр("ru='Подтверждение'");
	ТекстВопроса   = НСтр("ru='Очистить отбор по видам документов?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("ОчиститьОтборПоВидамДокументовЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет,,,ТекстЗаголовка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьОтборПоВидамДокументовЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Ответ = Результат;
    Если Ответ=КодВозвратаДиалога.Да Тогда
        Объект.ВидыДокументов.Очистить();
        УстановитьВидимостьНаСервере();
        ОбновитьНаименованиеКомандФормы();
        Модифицированность = Истина;
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура АвтоматическаяСинхронизацияПриИзменении(Элемент)
	
	ПриИзмененииРежимаСинхронизацииДанных();
	
КонецПроцедуры

&НаКлиенте
Процедура РучнаяСинхронизацияПриИзменении(Элемент)
	
	ПриИзмененииРежимаСинхронизацииДанных();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьНаСервере()
	
	// Видимость отбора по организациям
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Элементы.ГруппаОтборПоОрганизациям.Видимость = Ложь;
	Иначе
		Элементы.ГруппаОтборПоОрганизациям.Видимость = Истина;
		ОтборПоОрганизациямИспользуется = РежимСинхронизацииОрганизаций = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям";
		ОтборПоОрганизациямНастроен = Объект.Организации.Количество() > 0;
		Элементы.ОткрытьФормуОтбораПоОрганизациям.Видимость = ОтборПоОрганизациямИспользуется;
		Элементы.ОчиститьОтборПоОрганизациям.Видимость = ОтборПоОрганизациямИспользуется И ОтборПоОрганизациямНастроен;
	КонецЕсли;
	
	// Видимость отбора по видам документов
	ОтборПоВидамДокументовИспользуется = РежимСинхронизацииДокументов = "СинхронизироватьДанныеТолькоПоВыбраннымВидамДокументов";
	ОтборПоВидамДокументовНастроен = Объект.ВидыДокументов.Количество() > 0;
	Элементы.ОткрытьФормуОтбораПоВидамДокументов.Видимость = ОтборПоВидамДокументовИспользуется;
	Элементы.ОчиститьОтборПоВидамДокументов.Видимость = ОтборПоВидамДокументовИспользуется И ОтборПоВидамДокументовНастроен;

КонецПроцедуры

&НаСервере
Функция ПолучитьМассивОбъектовТабличнойЧасти(ИмяТабличнойЧасти, ИмяКолонки)

	Возврат Объект[ИмяТабличнойЧасти].Выгрузить().ВыгрузитьКолонку(ИмяКолонки);

КонецФункции

&НаСервере
Процедура ОбновитьДанныеОбъекта(СтруктураПараметров)
	
	Объект[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Очистить();
	
	СписокВыбранныхЗначений = ПолучитьИзВременногоХранилища(СтруктураПараметров.АдресТаблицыВоВременномХранилище);
	
	Если СписокВыбранныхЗначений.Количество() > 0 Тогда
		Объект[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Загрузить(СписокВыбранныхЗначений);
	КонецЕсли;
	
	УстановитьВидимостьНаСервере();
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаименованиеКомандФормы()
	
	// Обновим заголовок выбранных организаций
	Если Объект.Организации.Количество() > 0 Тогда
		
		ВыбранныеОрганизации = Объект.Организации.Выгрузить().ВыгрузитьКолонку("Организация");
		НовыйЗаголовокОрганизаций = ПланыОбмена.ОбменУправлениеНебольшойФирмойБухгалтерия20.СокращенноеПредставлениеКоллекцииЗначений(ВыбранныеОрганизации);
		
	Иначе
		
		НовыйЗаголовокОрганизаций = НСтр("ru = 'Выбрать организации '");
		
	КонецЕсли;
	
	Элементы.ОткрытьФормуОтбораПоОрганизациям.Заголовок = НовыйЗаголовокОрганизаций;
	
	// Обновим заголовок выбранных видов документов
	Если Объект.ВидыДокументов.Количество() > 0 Тогда
		
		ВыбранныеВидыДокументов = Объект.ВидыДокументов.Выгрузить().ВыгрузитьКолонку("Представление");
		НовыйЗаголовокВидовДокументов = ПланыОбмена.ОбменУправлениеНебольшойФирмойБухгалтерия20.СокращенноеПредставлениеКоллекцииЗначений(ВыбранныеВидыДокументов);
		
	Иначе
		
		НовыйЗаголовокВидовДокументов = НСтр("ru = 'Выбрать виды документов '");
		
	КонецЕсли;
	
	Элементы.ОткрытьФормуОтбораПоВидамДокументов.Заголовок = НовыйЗаголовокВидовДокументов;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРежимаСинхронизацииДанных()

	Если РежимСинхронизации = "АвтоматическаяСинхронизация" Тогда
		
		Элементы.ГруппаУсловияОтправкиДанных.Доступность = Истина;
		Элементы.ГруппаЗагрузкаДокументовИзБухгалтерии.Доступность = Ложь;
		
	Иначе
		
		Элементы.ГруппаУсловияОтправкиДанных.Доступность = Ложь;
		Элементы.ГруппаЗагрузкаДокументовИзБухгалтерии.Доступность = Истина;
		
	КонецЕсли;

КонецПроцедуры



#КонецОбласти

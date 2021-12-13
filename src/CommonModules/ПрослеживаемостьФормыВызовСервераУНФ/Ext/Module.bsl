﻿
#Область СлужебныйПрограммныйИнтерфейс

Функция ПоместитьРНПТВХранилище(ДокументОбъект, ИдентификаторСтроки, ИдентификаторФормы) Экспорт
	
	СтрокиСРНПТ = ДокументОбъект.СведенияПрослеживаемости.НайтиСтроки(Новый Структура("ИдентификаторСтроки", ИдентификаторСтроки));
	ТаблицаРНПТ = ДокументОбъект.СведенияПрослеживаемости.Выгрузить(СтрокиСРНПТ);
	
	АдресТаблицыРНПТВХранилище = ПоместитьВоВременноеХранилище(ТаблицаРНПТ, ИдентификаторФормы);
	
	Возврат АдресТаблицыРНПТВХранилище;
	
КонецФункции

Функция ИсходныйДокументРекурсивно(ИсходныйДокумент) Экспорт
	
	Основание = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ИсходныйДокумент, "ДокументОснование", Истина);
	Если ИсходныйДокумент.ДокументОснование = ИсходныйДокумент Тогда
		Возврат Неопределено;
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.РасходнаяНакладная")
		ИЛИ ТипЗнч(Основание) = Тип("ДокументСсылка.ПриходнаяНакладная") Тогда
		Возврат Основание;
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.КорректировкаПоступления")
		ИЛИ ТипЗнч(Основание) = Тип("ДокументСсылка.КорректировкаРеализации") Тогда
		Возврат ИсходныйДокументРекурсивно(Основание);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Выполняет установку отбора по указанной организации в динамических списках.
// Вызывать необходимо из обработчика формы ПриСозданииНаСервере.
// Если в форму при открытии был передан отбор по организации, то функция не будет выполнена.
//
// Параметры
//  Форма          - ФормаКлиентскогоПриложения  - форма, в которой необходимо установить отбор
//  ИмяСписка      - Строка - имя реквизита формы типа ДинамическийСписок.
//  ИмяРеквизита   - Строка - имя поля-организации в динамическом списке.
//  ЗначениеОтбора - СправочникСсылка.Организации, СписокЗначений, Массив - значение отбора.
//                   Если значение не задано, то будет подставлена основная организация из
//                   настроек пользователя.
//
// Возвращаемое значение:
//   СправочникСсылка.Организации - Если отбор установлен, то вернет значение отбора.
//
Функция УстановитьОтборПоОсновнойОрганизации(Форма, ИмяСписка = "Список", ИмяРеквизита = "Организация", ЗначениеОтбора = Неопределено) Экспорт

	Если Справочники.Организации.ИспользуетсяНесколькоОрганизаций() Тогда
		
		Если Форма.Параметры.Свойство("Отбор") И Форма.Параметры.Отбор.Свойство(ИмяРеквизита) Тогда
			// Если значение отбора передается в параметрах формы - берем его оттуда, параметр при этом удаляем
			ОсновнаяОрганизация = Форма.Параметры.Отбор[ИмяРеквизита];
			Форма.Параметры.Отбор.Удалить(ИмяРеквизита);
		ИначеЕсли ТипЗнч(ЗначениеОтбора) = Тип("СправочникСсылка.Организации") 
			ИЛИ ТипЗнч(ЗначениеОтбора) = Тип("СписокЗначений") 
			ИЛИ ТипЗнч(ЗначениеОтбора) = Тип("Массив") Тогда
			ОсновнаяОрганизация = ЗначениеОтбора;
		Иначе
			ОсновнаяОрганизация = Справочники.Организации.ОрганизацияПоУмолчанию();
		КонецЕсли;
		
		Если ТипЗнч(ОсновнаяОрганизация) = Тип("СправочникСсылка.Организации") Тогда
			ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.Равно;
		Иначе
			ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.ВСписке;
		КонецЕсли;
		
		ИспользованиеОтбора = ЗначениеЗаполнено(ОсновнаяОрганизация);
		
		РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
		
	Иначе
		
		ОсновнаяОрганизация = Справочники.Организации.ПустаяСсылка();
		ВидСравненияОтбора  = ВидСравненияКомпоновкиДанных.Равно;
		ИспользованиеОтбора = Ложь;
		РежимОтображения    = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма[ИмяСписка], ИмяРеквизита, ОсновнаяОрганизация, ВидСравненияОтбора, , ИспользованиеОтбора, РежимОтображения);
	
	Возврат ОсновнаяОрганизация;
	
КонецФункции

// Изменяет значение отбора в динамическом списке.
// Поиск производится по представлению в элементах отборов верхнего уровня.
//
// Надо анализировать возвращаемое значение - и если вернется
//  Неопределено (т.е. отбор не установлен по причине того, что в списке
//  нет отбора по основной организации (он исправлен вручную и т.п.)), то не надо
//  присваивать Неопределено специальному полю "ОтборПоОрганизации" в форме списка.
//
// Параметры
//  Список         - ДинамическийСписок - список, в котором необходимо изменить значение отбора.
//  ИмяРеквизита   - Строка - имя поля-организации в динамическом списке.
//  ЗначениеОтбора - СправочникСсылка.Организации, СписокЗначений, Массив - значение отбора.
//
// Возвращаемое значение:
//   СправочникСсылка.Организации - Если отбор установлен, то вернет значение отбора.
//
Функция ИзменитьОтборПоОсновнойОрганизации(Список, ИмяРеквизита = "Организация", Знач ЗначениеОтбора = Неопределено) Экспорт

	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.КомпоновщикНастроек.Настройки.Отбор, ИмяРеквизита);
	
	Если ЗначениеЗаполнено(ЗначениеОтбора) Тогда
		Если ТипЗнч(ЗначениеОтбора) <> Тип("СправочникСсылка.Организации")
			И ТипЗнч(ЗначениеОтбора) <> Тип("Массив")
			И ТипЗнч(ЗначениеОтбора) <> Тип("СписокЗначений") Тогда
			ЗначениеОтбора = ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка");
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(ЗначениеОтбора) = Тип("Массив")
		ИЛИ ТипЗнч(ЗначениеОтбора) = Тип("СписокЗначений") Тогда
		ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.ВСписке;
	Иначе
		ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли;
	
	ИспользованиеОтбора = ЗначениеЗаполнено(ЗначениеОтбора);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, ИмяРеквизита, ЗначениеОтбора, ВидСравненияОтбора, , ИспользованиеОтбора, 
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
		
	Возврат ЗначениеОтбора;
	
КонецФункции

// Заменяет отбор, установленный пользователем в сохраненной настройке списка, на отбор, установленный программно при создании формы списка.
// Вызывается при восстановлении пользовательских настроек динамического списка
// из обработчика списка ПередЗагрузкойПользовательскихНастроекНаСервере.
//
// Параметры:
//  Список      - ДинамическийСписок - Динамический список, для которого устанавливается отбор.
//  Настройки   - ПользовательскиеНастройкиКомпоновкиДанных - Восстанавливаемые настройки списка.
//  ИмяОтбора   - Строка - Имя элемента отбора.
//
Процедура ВосстановитьОтборСписка(Список, Настройки, ИмяОтбора) Экспорт

	Если Настройки = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Отборы = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(
		Список.КомпоновщикНастроек.Настройки.Отбор, ИмяОтбора);
	
	Если Отборы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементОтбора = Отборы[0];
	ИдентификаторНастройки = ЭлементОтбора.ИдентификаторПользовательскойНастройки;
	
	Для каждого ЭлементНастроек Из Настройки.Элементы Цикл
		Если ТипЗнч(ЭлементНастроек) = Тип("ЭлементОтбораКомпоновкиДанных") 
			И ЭлементНастроек.ИдентификаторПользовательскойНастройки = ИдентификаторНастройки Тогда
			ЭлементНастроек.ПравоеЗначение = ЭлементОтбора.ПравоеЗначение;
			ЭлементНастроек.Использование  = ЭлементОтбора.Использование;
			Прервать;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

// Позволяет получить индекс картинки состояния документа из коллекции СостоянияДокумента
// по свойствам Проведен/ПометкаУдаления/РучнаяКорректировка
//
// Параметры:
// Объект - основной реквизит формы документа, с типом ДанныеФормыСтруктура
//
Функция СостояниеДокумента(Объект) Экспорт
	
	РучнаяКорректировка = Неопределено;
	
	Если Объект.Свойство("РучнаяКорректировка", РучнаяКорректировка) Тогда
		Если Объект.РучнаяКорректировка Тогда
			Если Объект.ПометкаУдаления Тогда
				СостояниеДокумента = 10;
			ИначеЕсли НЕ Объект.Проведен Тогда
				СостояниеДокумента = 9;
			Иначе
				СостояниеДокумента = 8;
			КонецЕсли;
		Иначе
			Если Объект.ПометкаУдаления Тогда
				СостояниеДокумента = 2;
			ИначеЕсли Объект.Проведен Тогда
				СостояниеДокумента = 1;
			Иначе
				СостояниеДокумента = 0;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Если Объект.ПометкаУдаления Тогда
			СостояниеДокумента = 2;
		ИначеЕсли Объект.Проведен Тогда
			СостояниеДокумента = 1;
		Иначе
			СостояниеДокумента = 0;
		КонецЕсли;
	КонецЕсли;
	
	Возврат СостояниеДокумента;
	
КонецФункции

#КонецОбласти

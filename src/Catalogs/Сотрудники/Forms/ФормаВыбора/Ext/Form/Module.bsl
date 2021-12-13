﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	// Установка текущей строки.
	Если Параметры.Свойство("Ответственный") И ЗначениеЗаполнено(Параметры.Ответственный) Тогда

		Элементы.Список.ТекущаяСтрока = Параметры.Ответственный;

	КонецЕсли;
	
	// Выделение основного элемента.
	ДинамическиеСпискиУНФ.ВыделитьЖирнымОсновнойЭлемент(
		УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеНастройки("ОсновнойОтветственный"), Список);
	
	// Настройка списка	
	Если Параметры.РежимВыбора И Параметры.ЗакрыватьПриВыборе = Ложь Тогда
		Элементы.Список.МножественныйВыбор = Истина;
		Элементы.Список.РежимВыделения = РежимВыделенияТаблицы.Множественный;
	КонецЕсли;

	Если Элементы.Список.РежимВыбора И Не ЗакрыватьПриВыборе Тогда

		Если Не ПустаяСтрока(Параметры.АдресСпискаПодобранныхСотрудников) Тогда
			МассивПодобранных = ПолучитьИзВременногоХранилища(Параметры.АдресСпискаПодобранныхСотрудников);
			СписокПодобранных.ЗагрузитьЗначения(МассивПодобранных);
		КонецЕсли;

	КонецЕсли;

	УстановитьСписокПодобранныхСотрудников();

	УстановитьОтборНедействительные(ЭтотОбъект);

	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Элементы, "Организация") Тогда
		Элементы.Организация.Видимость = Справочники.Организации.КоличествоОрганизаций() > 0;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаУстановитьОсновнойЭлемент(Команда)

	ВыбранныйЭлемент = Элементы.Список.ТекущаяСтрока;
	Если ЗначениеЗаполнено(ВыбранныйЭлемент) Тогда
		УстановитьОсновнойЭлемент(ВыбранныйЭлемент);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНедействительных(Команда)

	Элементы.ПоказыватьНедействительных.Пометка = Не Элементы.ПоказыватьНедействительных.Пометка;

	УстановитьОтборНедействительные(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОсновнойЭлемент(ВыбранныйЭлемент)

	Если ВыбранныйЭлемент <> УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеНастройки("ОсновнойОтветственный") Тогда
		РегистрыСведений.НастройкиПользователей.Установить(ВыбранныйЭлемент, "ОсновнойОтветственный");
		ДинамическиеСпискиУНФ.ВыделитьЖирнымОсновнойЭлемент(ВыбранныйЭлемент, Список);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформлениеНедействителен = Список.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();

	Оформление = УсловноеОформлениеНедействителен.Оформление.Элементы.Найти("ЦветТекста");
	Оформление.Значение = ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет;
	Оформление.Использование = Истина;

	Отбор = УсловноеОформлениеНедействителен.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	Отбор.Использование = Истина;
	Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Недействителен");
	Отбор.ПравоеЗначение = Истина;
	
	УсловноеОформлениеПодобранные = Список.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	
	УсловноеОформлениеПодобранные.Представление = ПредставлениеУсловногоОформленияПодобранные();

	Оформление = УсловноеОформлениеПодобранные.Оформление.Элементы.Найти("ЦветТекста");
	Оформление.Значение = ЦветаСтиля.ЦветТекстаКонтрагентаДействующего;
	Оформление.Использование = Истина;

	Отбор = УсловноеОформлениеПодобранные.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	Отбор.Использование = Истина;
	Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	Отбор.ПравоеЗначение = Новый СписокЗначений();;

КонецПроцедуры

#Область НедействительныеЭлементыСписка

&НаСервере
Процедура УстановитьСписокПодобранныхСотрудников()

	ЭлементУсловногоОформления = Неопределено;
	Для Каждого ЭлементОформления Из УсловноеОформление.Элементы Цикл
		Если ЭлементОформления.Представление = ПредставлениеУсловногоОформленияПодобранные() Тогда
			ЭлементУсловногоОформления = ЭлементОформления;
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Если ЭлементУсловногоОформления <> Неопределено Тогда
		ЭлементУсловногоОформления.Отбор.Элементы[0].ПравоеЗначение = СписокПодобранных;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПредставлениеУсловногоОформленияПодобранные()
	Возврат НСтр("ru='Выделение подобранных'");
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборНедействительные(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список, "Недействителен", Ложь, , , Не Форма.Элементы.ПоказыватьНедействительных.Пометка);

КонецПроцедуры

#КонецОбласти

#КонецОбласти
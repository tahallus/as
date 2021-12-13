﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.РезервноеКопированиеВРежимеСервиса.Видимость =ОбщегоНазначения.РазделениеВключено();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	НастроитьЭлементыФормы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СворачиватьОстаткиПриИзменении(Элемент)
	НастроитьЭлементыФормы();
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПерейтиКСформированнымДокументамНажатие(Элемент)
	ОткрытьФорму("Документ.КорректировкаРегистров.Форма.ФормаСписка");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)

	Элементы.ГруппаРезервнаяКопия.Видимость = Ложь;
	Элементы.СворачиватьОстатки.Доступность = Ложь;
	Элементы.СостояниеСтарыеДокументы.Видимость = Ложь;
	Элементы.СостояниеФормированияОстатков.ТекущаяСтраница = Элементы.ГруппаПрогрессФормированияОстатков;
	ДлительнаяОперация = СформироватьОстаткиНаДатуСвертки(ДатаСвертки);
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьРезультатФормированияОстатков", ЭтотОбъект);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
	ПараметрыОжидания.ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения("ОповещениеОПрогрессеФормированияОстатков",
		ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);

КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдаление(Команда)

	Элементы.СостояниеСтарыеДокументы.ТекущаяСтраница = Элементы.ГруппаПрогрессПометкиУдаления;
	ДлительнаяОперация = ПометитьНаУдалениеОбъектыИУдалитьЗаписиРегистровДоДатыСвертки(ДатаСвертки);
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьРезультатПометкиНаУдаление", ЭтотОбъект);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
	ПараметрыОжидания.ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения("ОповещениеОПрогрессеПометкиУдаления",
		ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);

КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НастроитьЭлементыФормы()

	Элементы.СостояниеФормированияОстатков.Видимость = СворачиватьОстатки;
	Если СворачиватьОстатки Тогда
		ДатаСвертки = ОбщегоНазначенияКлиент.ДатаСеанса();
		Элементы.СостояниеСтарыеДокументы.Видимость = Ложь;
		Элементы.ПометитьНаУдаление.Заголовок = НСтр("ru = 'Пометить на удаление все документы до даты свертки'");
	Иначе
		ДатаСвертки = '00010101';
		Элементы.СостояниеСтарыеДокументы.Видимость = Истина;
		Элементы.ПометитьНаУдаление.Заголовок = НСтр("ru = 'Пометить на удаление все документы'");
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция СформироватьОстаткиНаДатуСвертки(ДатаСвертки)

	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	Результат = ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения,
		"Обработки.СверткаИнформационнойБазы.ДокументыОстатковНаДатуСвертки", ДатаСвертки);
	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура ОповещениеОПрогрессеФормированияОстатков(Прогресс, Параметры) Экспорт

	Если ТипЗнч(Прогресс) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;

	Если Не Прогресс.Свойство("Прогресс") Тогда
		Возврат;
	КонецЕсли;

	Если ТипЗнч(Прогресс.Прогресс) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;

	Элементы.ПрогрессФормированияОстатков.Подсказка = Прогресс.Прогресс.Текст;
	ПрогрессФормированияОстатков = Прогресс.Прогресс.Процент;

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатФормированияОстатков(Результат, Параметры) Экспорт

	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;

	Если Результат.Статус = "Ошибка" Тогда
		Элементы.ПояснениеОшибкиФормированияОстатков.Подсказка = Результат.ПодробноеПредставлениеОшибки;
		Элементы.СостояниеФормированияОстатков.ТекущаяСтраница = Элементы.ГруппаОшибкаФормированияОстатков;
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		РезультатВыполнения = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Если ТипЗнч(РезультатВыполнения) = Тип("Массив") Тогда
			ИсходнаяСтрока = НСтр(
				"ru = ';Сформирован %1 документ;;Сформированы %1 документа;Сформировано %1 документов;Сформирован %1 документ'");
			Элементы.ДекорацияСформированыОстатки.Заголовок = СтрокаСЧислом(ИсходнаяСтрока,
				РезультатВыполнения.Количество(), ВидЧисловогоЗначения.Количественное, "ЧН=0;");
		КонецЕсли;
		Элементы.СостояниеФормированияОстатков.ТекущаяСтраница = Элементы.ГруппаОстаткиСформированы;
		Элементы.СостояниеСтарыеДокументы.Видимость = Истина;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПометитьНаУдалениеОбъектыИУдалитьЗаписиРегистровДоДатыСвертки(ДатаСвертки)

	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	Результат = ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения,
		"Обработки.СверткаИнформационнойБазы.ПометитьНаУдалениеОбъектыИУдалитьЗаписиРегистровДоДатыСвертки",
		ДатаСвертки);
	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура ОповещениеОПрогрессеПометкиУдаления(Прогресс, Параметры) Экспорт

	Если ТипЗнч(Прогресс) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;

	Если Не Прогресс.Свойство("Прогресс") Тогда
		Возврат;
	КонецЕсли;

	Если ТипЗнч(Прогресс.Прогресс) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;

	Элементы.ПрогрессПометкиУдаления.Подсказка = Прогресс.Прогресс.Текст;
	ПрогрессПометкиУдаления = Прогресс.Прогресс.Процент;

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатПометкиНаУдаление(Результат, Параметры) Экспорт

	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;

	Если Результат.Статус = "Ошибка" Тогда
		Элементы.ПояснениеОшибкиПометкиУдаления.Подсказка = Результат.ПодробноеПредставлениеОшибки;
		Элементы.СостояниеСтарыеДокументы.ТекущаяСтраница = Элементы.ГруппаОшибкаПометкиУдаления;
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		РезультатВыполнения = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Если ТипЗнч(РезультатВыполнения) = Тип("Массив") Тогда
			ИсходнаяСтрока = НСтр(
				"ru = ';Помечен на удаление %1 объект;;Помечены на удаление %1 объекта;Помечено на удаление %1 объектов;Помечен на удаление %1 объект'");
			Элементы.ДекорацияДокументыПомеченыНаУдаление.Заголовок = СтрокаСЧислом(ИсходнаяСтрока,
				РезультатВыполнения.Количество(), ВидЧисловогоЗначения.Количественное, "ЧН=0;");
		КонецЕсли;
		Элементы.СостояниеСтарыеДокументы.ТекущаяСтраница = Элементы.ГруппаДокументыПомеченыНаУдаление;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
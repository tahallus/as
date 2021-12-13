﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Организация", Организация);
	Если Организация.Пустая() Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	СостоянияВыгрузкиНоменклатуры.Организация КАК Организация
		|ИЗ
		|	РегистрСведений.СостоянияВыгрузкиНоменклатуры КАК СостоянияВыгрузкиНоменклатуры";
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		Если Выборка.Следующий() Тогда 
			Организация = Выборка.Организация;
		Иначе 
			ТекстСообщения = НСтр("ru = 'Результаты выгрузки не найдены. Форма не может быть открыта.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
			Возврат;
		КонецЕсли;
	Иначе 
		Элементы.Организация.Видимость = Ложь;
	КонецЕсли;
	
	Обработки.РаботаСНоменклатурой.СоздатьКомандыСостояния(ЭтаФорма, Элементы.СостоянияВыгрузки.Имя);
	
	Если Параметры.Свойство("СтатистикаРезультатов") Тогда
		СтатистикаРезультатов = Параметры.СтатистикаРезультатов;
	КонецЕсли;
	
	ИмяКоманды = "";
	Параметры.Свойство("ИмяКоманды", ИмяКоманды);
	ОбработатьОтборПоСостоянию(ИмяКоманды);
	
	ВедетсяУчетПоХарактеристикам = (РаботаСНоменклатурой.ВедетсяУчетПоХарактеристикам() = Истина);
	ПустаяХарактеристика         = ?(ВедетсяУчетПоХарактеристикам, РаботаСНоменклатурой.ПустаяСсылкаНаХарактеристику(), Неопределено);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ВедетсяУчетПоХарактеристикам", ВедетсяУчетПоХарактеристикам);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ПустаяХарактеристика", ПустаяХарактеристика);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Организация", Организация);
	
	ПроверитьЗапуститьОбновлениеДанных(Организация, УникальныйИдентификатор, ПодсчетСтатистикиРезультатов);
	
	Если ПодсчетСтатистикиРезультатов = Неопределено Тогда
		ПодсчетСтатистикиРезультатов = РаботаСНоменклатуройСлужебный.ПолучитьСтатистикуРезультатов(УникальныйИдентификатор, Организация);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЭтоОбновление = Ложь;
	ПроверитьОбработатьЗавершениеДлительнойОперации(ЭтоОбновление);
	Если НЕ ЭтоОбновление Тогда
		РаботаСНоменклатуройСлужебныйКлиент.ОбновитьСтатистикуРезультатов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ТипЗнч(ОписаниеОповещенияОЗакрытии) = Тип("ОписаниеОповещения")
		И ТипЗнч(ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры) = Тип("Структура")
		И ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.Свойство("СтатистикаРезультатов") Тогда
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.СтатистикаРезультатов = СтатистикаРезультатов;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если Поле = Элементы.СписокОписаниеОшибки И ЗначениеЗаполнено(Элемент.ТекущиеДанные.ОписаниеОшибки) Тогда
		Оповещение = Новый ОписаниеОповещения("ОповещениеВводСтроки", ЭтотОбъект);
		ПоказатьВводСтроки(Оповещение, Элемент.ТекущиеДанные.ОписаниеОшибки, НСтр("ru = 'Описание ошибки'"),, Истина);
	Иначе 
		ТекущиеДанные = Элемент.ТекущиеДанные;
		НезаполненныеРеквизиты = Новый Массив;
		Если ЗначениеЗаполнено(ТекущиеДанные.РасшифровкаПроблемы) Тогда
			Расшифровка = РаботаСНоменклатуройСлужебныйКлиент.ЗначениеИзСтрокиJSON(ТекущиеДанные.РасшифровкаПроблемы);
			Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
				Расшифровка.Свойство("Проблемы", НезаполненныеРеквизиты);
			КонецЕсли;
		КонецЕсли;
		РаботаСНоменклатуройКлиентПереопределяемый.ПоказатьНезаполненныеДанныеНоменклатуры(ТекущиеДанные.Номенклатура, 
			НезаполненныеРеквизиты, ЭтотОбъект, Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Организация", Организация);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ДействиеКомандыСостояние(Команда)
	
	ОбработатьОтборПоСостоянию(Команда.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьКВыгрузке(Команда)
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() = 0 Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не выбраны данные для повторной выгрузки'"));
		Возврат
	КонецЕсли;
	
	СостояниеОтклонено = ПредопределенноеЗначение("Перечисление.СостоянияВыгрузкиНоменклатуры.Отклонена");
	СтрокиКОбмену      = Новый Массив;
	Для каждого ВыделеннаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		Если Элементы.Список.ДанныеСтроки(ВыделеннаяСтрока).Свойство("Состояние") 
			И Элементы.Список.ДанныеСтроки(ВыделеннаяСтрока).Состояние = СостояниеОтклонено Тогда
			СтрокиКОбмену.Добавить(ВыделеннаяСтрока);
		КонецЕсли;
	КонецЦикла;
	
	Если СтрокиКОбмену.Количество() > 0 Тогда
		Состояние          = ПредопределенноеЗначение("Перечисление.СостоянияВыгрузкиНоменклатуры.ОжидаетВыгрузки");
		ДлительнаяОперация = РаботаСНоменклатуройСлужебныйВызовСервера.ИзменитьЗаписиРегистраПоСписку(УникальныйИдентификатор,
			Организация, СтрокиКОбмену, Состояние);
		ДополнительныеПараметры = Новый Структура();
		ДополнительныеПараметры.Вставить("КоличествоИзменение", СтрокиКОбмену.Количество());
		
		Если ДлительнаяОперация.Статус = "Выполнено" Тогда
			ПометкаНоменклатурыКВыгрузкеЗавершение(ДлительнаяОперация, ДополнительныеПараметры);
			Возврат
		КонецЕсли;
		
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ПометкаНоменклатурыКВыгрузкеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПараметрыОжидания     = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтаФорма);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	Иначе 
		ОчиститьСообщения();
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Выгрузить повторно можно только товарные позиции в состоянии ""Отклонено""'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПометкаНоменклатурыКВыгрузкеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Статус <> "Выполнено" Тогда
		Возврат;
	КонецЕсли;

	КоличествоИзменение = ДополнительныеПараметры.КоличествоИзменение;
	
	СтатистикаРезультатов["Отклонена"] = СтатистикаРезультатов["Отклонена"] - КоличествоИзменение;
	СтатистикаРезультатов["ОжидаетВыгрузки"] = СтатистикаРезультатов["ОжидаетВыгрузки"] + КоличествоИзменение;
	РаботаСНоменклатуройСлужебныйКлиент.ОбновитьЗаголовкиКнопокСостояние(ЭтотОбъект);
	
	ОчиститьСообщения();
	ОбщегоНазначенияКлиент.СообщитьПользователю(СтрШаблон(НСтр("ru = 'Отмечено к выгрузке %1 элементов'"), КоличествоИзменение));
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьРезультаты(Команда)
	ПодсчетСтатистикиРезультатов = ОбновлениеСостоянийВыгрузки(Организация, УникальныйИдентификатор);
	ПодсчетСтатистикиРезультатов.Вставить("ЭтоОбновление", Истина);
	ПроверитьОбработатьЗавершениеДлительнойОперации();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбработатьОтборПоСостоянию(ИмяКоманды = "")
	
	ОтборСостоянияВыгрузки = Новый СписокЗначений;
	Если НЕ ИмяКоманды = "" Тогда 
		Пометка = НЕ Элементы[ИмяКоманды].Пометка;
		Элементы[ИмяКоманды].Пометка = Пометка;
		
		Для каждого Состояние Из СписокСостояний Цикл
			Если Состояние.Представление = ИмяКоманды Тогда
				Состояние.Пометка = Пометка;
			КонецЕсли;
			Если Состояние.Пометка Тогда
				ОтборСостоянияВыгрузки.Добавить(Состояние.Значение);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ОтборСостоянияВыгрузки.Количество() = 0 Тогда
		ОтборСостоянияВыгрузки = СписокСостояний;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "СписокСостояний", ОтборСостоянияВыгрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеВводСтроки(ВведенныйТекст, ДополнительныеПараметры) Экспорт
	Если ВведенныйТекст = Неопределено Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПроверитьЗапуститьОбновлениеДанных(Знач Организация, Знач УникальныйИдентификатор, ДлительнаяОперация)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	1 КАК Поле1
	|ИЗ
	|	РегистрСведений.СостоянияВыгрузкиНоменклатуры КАК СостоянияВыгрузкиНоменклатуры
	|ГДЕ
	|	СостоянияВыгрузкиНоменклатуры.Организация = &Организация
	|	И СостоянияВыгрузкиНоменклатуры.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияВыгрузкиНоменклатуры.ПроверяетсяМодератором)";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ДлительнаяОперация = ОбновлениеСостоянийВыгрузки(Организация, УникальныйИдентификатор);
	ДлительнаяОперация.Вставить("ЭтоОбновление", Истина);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОбновлениеСостоянийВыгрузки(Знач Организация, Знач УникальныйИдентификатор)
	
	НаименованиеЗадания = НСтр("ru = '1С:Номенклатура: обновление результатов выгрузки.'");
	ИмяМетода           = "РаботаСНоменклатуройСлужебный.ОбновленнаяСтатистикаРезультатов";
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, ИмяМетода, Организация);
	
КонецФункции

&НаКлиенте
Процедура ПроверитьОбработатьЗавершениеДлительнойОперации(ЭтоОбновление = Ложь)
	
	Если ТипЗнч(ПодсчетСтатистикиРезультатов) <> Тип("Структура") Тогда
		Возврат
	КонецЕсли;
	
	Если ПодсчетСтатистикиРезультатов.Свойство("ЭтоОбновление") Тогда
		ЭтоОбновление = Истина;
	Иначе 
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	Сообщить(НСтр("ru = 'Запущено обновление результатов выгрузки.'"));
	
	Если ПодсчетСтатистикиРезультатов.Свойство("Статус") И ПодсчетСтатистикиРезультатов.Статус = "Выполнено" Тогда
		ОбновлениеСтатистикиЗавершение(ПодсчетСтатистикиРезультатов, Неопределено);
	Иначе
		Элементы.ДлительнаяОперация.Видимость = Истина;
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбновлениеСтатистикиЗавершение", ЭтотОбъект);
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		ПараметрыОжидания.ВыводитьПрогрессВыполнения = Ложь;
		ПараметрыОжидания.ВыводитьСообщения = Ложь;
		ПараметрыОжидания.ТекстСообщения  = НСтр("ru = 'Выполняется обновление результатов выгрузки…'");
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ПодсчетСтатистикиРезультатов, ОповещениеОЗавершении, ПараметрыОжидания);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновлениеСтатистикиЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Сообщить(НСтр("ru = 'Завершено обновление результатов выгрузки.'"));
	РаботаСНоменклатуройСлужебныйКлиент.ОбновлениеСтатистикиЗавершение(Результат, ЭтотОбъект);
	Элементы.ДлительнаяОперация.Видимость = Ложь;
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти
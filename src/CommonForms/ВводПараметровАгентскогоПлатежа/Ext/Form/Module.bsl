﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Платеж = Параметры.Платеж;
	ДанныеАгентскогоДоговора = Параметры.ДанныеАгентскогоДоговора;
	
	Если НЕ Параметры.Свойство("ВознаграждениеВключеноВСтоимость", ВознаграждениеВключеноВСтоимость) Тогда
		ВознаграждениеВключеноВСтоимость = ДанныеАгентскогоДоговора.ВознаграждениеВключеноВСтоимость;
	КонецЕсли;
	
	Если ВознаграждениеВключеноВСтоимость Тогда
		ЭтотОбъект.ТекущийЭлемент = Элементы.ПлатежСАгентскимВознаграждением;
		Элементы.ПлатежСАгентскимВознаграждением.ШрифтЗаголовка = ШрифтыСтиля.ВажнаяНадписьШрифт;
		Элементы.ПлатежСАгентскимВознаграждением.АктивизироватьПоУмолчанию = Истина;
	Иначе
		ЭтотОбъект.ТекущийЭлемент = Элементы.Платеж;
		Элементы.Платеж.ШрифтЗаголовка = ШрифтыСтиля.ВажнаяНадписьШрифт;
		Элементы.Платеж.АктивизироватьПоУмолчанию = Истина;
	КонецЕсли;
	
	Шаблон = НСтр("ru='Агентское вознаграждение [ПроцентВознаграждения]%[ВознаграждениеВключеноВСтоимость]'");
	ПараметрыДляПодстановки = Новый Структура;
	ПараметрыДляПодстановки.Вставить("ВознаграждениеВключеноВСтоимость", "");
	ПараметрыДляПодстановки.Вставить("ПроцентВознаграждения", ДанныеАгентскогоДоговора.ПроцентВознаграждения);
	Если ДанныеАгентскогоДоговора.ВознаграждениеВключеноВСтоимость Тогда
		ПараметрыДляПодстановки.ВознаграждениеВключеноВСтоимость = НСтр("ru=', включено в сумму платежа'");
	КонецЕсли;
	
	Элементы.ДекорацияПояснение.Заголовок = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(Шаблон, ПараметрыДляПодстановки);
	
	РассчитатьСуммовыеПоказатели(ЭтотОбъект, "Сумма");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	РассчитатьСуммовыеПоказатели(ЭтотОбъект, "Сумма");
КонецПроцедуры

&НаКлиенте
Процедура СуммаСАгентскимВознаграждениемПриИзменении(Элемент)
	РассчитатьСуммовыеПоказатели(ЭтотОбъект, "СуммаСАгентскимВознаграждением");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	ЗакрытьСПередачейРезультата();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗакрытьСПередачейРезультата()
	
	СтруктураОтвета = Новый Структура;
	СтруктураОтвета.Вставить("Платеж", Платеж);
	СтруктураОтвета.Вставить("ПлатежСАгентскимВознаграждением", ПлатежСАгентскимВознаграждением);
	
	Закрыть(СтруктураОтвета)
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьСуммовыеПоказатели(Форма, Источник)
	
	Если Источник = "Сумма" Тогда
		// Число ввода = сумма.
		Форма.ПлатежСАгентскимВознаграждением = 0;
	Иначе
		// Число ввода = сумма + а.в.
		Форма.Платеж = 0;
	КонецЕсли;
	
	АгентскиеПлатежиУНФКлиентСервер.РассчитатьПоказателиАгентскогоПлатежа(Форма.ДанныеАгентскогоДоговора, Форма.Платеж, Форма.ПлатежСАгентскимВознаграждением, Форма.АгентскоеВознаграждение);
	
КонецПроцедуры

#КонецОбласти


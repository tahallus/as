﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СчетУчетаВРознице = Параметры.СчетУчетаВРознице;
	СчетУчетаНаценки = Параметры.СчетУчетаНаценки;
	Ссылка = Параметры.Ссылка;
	
	Если ОтказИзменитьСчетУчета(Ссылка) Тогда
		Элементы.Пояснение.Заголовок = НСтр("ru = 'В базе есть движения по этой розничной точке: изменение счета учета запрещено.'");
		Элементы.Пояснение.Видимость = Истина;
		Элементы.ГруппаСчетовУчета.ТолькоПросмотр = Истина;
		Элементы.ПоУмолчанию.Видимость = Ложь;
	КонецЕсли;
	
	Если Ссылка.ТипСтруктурнойЕдиницы <> Перечисления.ТипыСтруктурныхЕдиниц.РозницаСуммовойУчет Тогда
		Элементы.Пояснение.Заголовок = НСтр("ru = 'Счета учета редактируются только для розницы с суммовым учетом.'");
		Элементы.Пояснение.Видимость = Истина;
		Элементы.ГруппаСчетовУчета.Видимость = Ложь;
		Элементы.ПоУмолчанию.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ПравоДоступа("Редактирование", Ссылка.Метаданные()) Тогда
		Элементы.ГруппаСчетовУчета.ТолькоПросмотр = Истина;
		Элементы.ПоУмолчанию.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СчетУчетаВРозницеПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СчетУчетаВРознице) Тогда
		СчетУчетаВРознице = ПредопределенноеЗначение("ПланСчетов.Управленческий.ТоварыПродукция");
	КонецЕсли;
	ОповеститьОбИзмененииСчетовРасчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаНаценкиПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СчетУчетаНаценки) Тогда
		СчетУчетаНаценки = ПредопределенноеЗначение("ПланСчетов.Управленческий.ТорговаяНаценка");
	КонецЕсли;
	ОповеститьОбИзмененииСчетовРасчетов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоУмолчанию(Команда)
	
	СчетУчетаВРознице = ПредопределенноеЗначение("ПланСчетов.Управленческий.ТоварыПродукция");
	СчетУчетаНаценки = ПредопределенноеЗначение("ПланСчетов.Управленческий.ТорговаяНаценка");
	ОповеститьОбИзмененииСчетовРасчетов();
	
КонецПроцедуры // ПоУмолчанию()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция проверяет возможность изменения счета.
//
&НаСервере
Функция ОтказИзменитьСчетУчета(Ссылка)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СуммовойУчетВРознице.Период,
	|	СуммовойУчетВРознице.Регистратор,
	|	СуммовойУчетВРознице.НомерСтроки,
	|	СуммовойУчетВРознице.Активность,
	|	СуммовойУчетВРознице.ВидДвижения,
	|	СуммовойУчетВРознице.Организация,
	|	СуммовойУчетВРознице.СтруктурнаяЕдиница,
	|	СуммовойУчетВРознице.Валюта,
	|	СуммовойУчетВРознице.Сумма,
	|	СуммовойУчетВРознице.СуммаВал,
	|	СуммовойУчетВРознице.Себестоимость,
	|	СуммовойУчетВРознице.СодержаниеПроводки,
	|	СуммовойУчетВРознице.ДокументПродажи
	|ИЗ
	|	РегистрНакопления.СуммовойУчетВРознице КАК СуммовойУчетВРознице
	|ГДЕ
	|	СуммовойУчетВРознице.СтруктурнаяЕдиница = &СтруктурнаяЕдиница");
	
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", ?(ЗначениеЗаполнено(Ссылка), Ссылка, Неопределено));
	
	Результат = Запрос.Выполнить();
	
	Возврат НЕ Результат.Пустой();
	
КонецФункции // ОтказИзменитьСчетУчета()

&НаКлиенте
Процедура ОповеститьОбИзмененииСчетовРасчетов()
	
	СтруктураПараметры = Новый Структура(
		"СчетУчетаВРознице, СчетУчетаНаценки",
		СчетУчетаВРознице, СчетУчетаНаценки
	);
	
	Оповестить("ИзменилисьСчетаСтруктурныеЕдиницы", СтруктураПараметры);
	
КонецПроцедуры

#КонецОбласти

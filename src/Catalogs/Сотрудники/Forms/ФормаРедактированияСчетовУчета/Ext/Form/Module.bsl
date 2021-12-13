﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	СчетРасчетовСПерсоналом = Параметры.СчетРасчетовСПерсоналом;
	СчетРасчетовСПодотчетниками = Параметры.СчетРасчетовСПодотчетниками;
	СчетРасчетовПоПерерасходу = Параметры.СчетРасчетовПоПерерасходу;
	Ссылка = Параметры.Ссылка;

	Если ОтказИзменитьСчетРасчетовСПерсоналом(Ссылка) Тогда
		Элементы.ПояснениеСПерсоналом.Заголовок = НСтр(
			"ru = 'В базе есть движения по этому сотруднику. Изменение счетов учета по расчетам с персоналом запрещено.'");
		Элементы.ПояснениеСПерсоналом.Видимость = Истина;
		Элементы.СПерсоналом.ТолькоПросмотр = Истина;
	КонецЕсли;

	Если ОтказИзменитьСчетРасчетовСПодотчетниками(Ссылка) Тогда
		Элементы.ПояснениеСПодотчетником.Заголовок = НСтр(
			"ru = 'В базе есть движения по этому подотчетнику. Изменение счетов учета по расчетам с подотчетниками запрещено.'");
		Элементы.ПояснениеСПодотчетником.Видимость = Истина;
		Элементы.СПодотчетником.ТолькоПросмотр = Истина;
	КонецЕсли;

	Если Не ПравоДоступа("Редактирование", Ссылка.Метаданные()) Тогда
		Элементы.СПерсоналом.ТолькоПросмотр = Истина;
		Элементы.СПодотчетником.ТолькоПросмотр = Истина;
		Элементы.ПоУмолчанию.Видимость = Ложь;
	КонецЕсли;

	Если Элементы.СПерсоналом.ТолькоПросмотр И Элементы.СПодотчетником.ТолькоПросмотр Тогда
		Элементы.ПоУмолчанию.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СчетРасчетовСПерсоналомПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(СчетРасчетовСПерсоналом) Тогда
		СчетРасчетовСПерсоналом = ПредопределенноеЗначение("ПланСчетов.Управленческий.РасчетыСПерсоналомПоОплатеТруда");
	КонецЕсли;
	ОповеститьОбИзмененииСчетовРасчетов();

КонецПроцедуры

&НаКлиенте
Процедура СчетРасчетовСПодотчетникамиПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(СчетРасчетовСПодотчетниками) Тогда
		СчетРасчетовСПодотчетниками = ПредопределенноеЗначение("ПланСчетов.Управленческий.РасчетыСПодотчетниками");
	КонецЕсли;
	ОповеститьОбИзмененииСчетовРасчетов();

КонецПроцедуры

&НаКлиенте
Процедура СчетРасчетовПоПерерасходуПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(СчетРасчетовПоПерерасходу) Тогда
		СчетРасчетовПоПерерасходу = ПредопределенноеЗначение("ПланСчетов.Управленческий.ПерерасходПодотчетников");
	КонецЕсли;
	ОповеститьОбИзмененииСчетовРасчетов();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик нажатия команды ПоУмолчанию.
//
&НаКлиенте
Процедура ПоУмолчанию(Команда)

	Если Не Элементы.СПерсоналом.ТолькоПросмотр Тогда
		СчетРасчетовСПерсоналом = ПредопределенноеЗначение("ПланСчетов.Управленческий.РасчетыСПерсоналомПоОплатеТруда");
	КонецЕсли;

	Если Не Элементы.СПодотчетником.ТолькоПросмотр Тогда
		СчетРасчетовСПодотчетниками = ПредопределенноеЗначение("ПланСчетов.Управленческий.РасчетыСПодотчетниками");
		СчетРасчетовПоПерерасходу = ПредопределенноеЗначение("ПланСчетов.Управленческий.ПерерасходПодотчетников");
	КонецЕсли;

	ОповеститьОбИзмененииСчетовРасчетов();

КонецПроцедуры // ПоУмолчанию()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция проверяет возможность изменения счета.
//
&НаСервере
Функция ОтказИзменитьСчетРасчетовСПерсоналом(Ссылка)

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РасчетыСПерсоналом.Период,
	|	РасчетыСПерсоналом.Регистратор,
	|	РасчетыСПерсоналом.НомерСтроки,
	|	РасчетыСПерсоналом.Активность,
	|	РасчетыСПерсоналом.ВидДвижения,
	|	РасчетыСПерсоналом.Организация,
	|	РасчетыСПерсоналом.СтруктурнаяЕдиница,
	|	РасчетыСПерсоналом.Сотрудник,
	|	РасчетыСПерсоналом.Валюта,
	|	РасчетыСПерсоналом.ПериодРегистрации,
	|	РасчетыСПерсоналом.Сумма,
	|	РасчетыСПерсоналом.СуммаВал,
	|	РасчетыСПерсоналом.СодержаниеПроводки
	|ИЗ
	|	РегистрНакопления.РасчетыСПерсоналом КАК РасчетыСПерсоналом
	|ГДЕ
	|	РасчетыСПерсоналом.Сотрудник = &Сотрудник";

	Запрос.УстановитьПараметр("Сотрудник", ?(ЗначениеЗаполнено(Ссылка), Ссылка, Неопределено));

	Результат = Запрос.Выполнить();

	Возврат Не Результат.Пустой();

КонецФункции // ОтказИзменитьСчетРасчетовСПерсоналом()

// Функция проверяет возможность изменения счета.
//
&НаСервере
Функция ОтказИзменитьСчетРасчетовСПодотчетниками(Ссылка)

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РасчетыСПодотчетниками.Период,
	|	РасчетыСПодотчетниками.Регистратор,
	|	РасчетыСПодотчетниками.НомерСтроки,
	|	РасчетыСПодотчетниками.Активность,
	|	РасчетыСПодотчетниками.ВидДвижения,
	|	РасчетыСПодотчетниками.Организация,
	|	РасчетыСПодотчетниками.Сотрудник,
	|	РасчетыСПодотчетниками.Валюта,
	|	РасчетыСПодотчетниками.Документ,
	|	РасчетыСПодотчетниками.Сумма,
	|	РасчетыСПодотчетниками.СуммаВал,
	|	РасчетыСПодотчетниками.СодержаниеПроводки
	|ИЗ
	|	РегистрНакопления.РасчетыСПодотчетниками КАК РасчетыСПодотчетниками
	|ГДЕ
	|	РасчетыСПодотчетниками.Сотрудник = &Сотрудник";

	Запрос.УстановитьПараметр("Сотрудник", ?(ЗначениеЗаполнено(Ссылка), Ссылка, Неопределено));

	Результат = Запрос.Выполнить();

	Возврат Не Результат.Пустой();

КонецФункции // ОтказИзменитьСчетРасчетовСПодотчетниками()

&НаКлиенте
Процедура ОповеститьОбИзмененииСчетовРасчетов()

	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("СчетРасчетовСПерсоналом", СчетРасчетовСПерсоналом);
	СтруктураПараметры.Вставить("СчетРасчетовСПодотчетниками", СчетРасчетовСПодотчетниками);
	СтруктураПараметры.Вставить("СчетРасчетовПоПерерасходу", СчетРасчетовПоПерерасходу);

	Оповестить("ИзменилисьСчетаСотрудники", СтруктураПараметры);

КонецПроцедуры

#КонецОбласти
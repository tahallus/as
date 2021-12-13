﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДата();
	КонецЕсли;
	
	Компания = Константы.УчетПоКомпании.Компания(Объект.Организация);
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьСовместительство") Тогда
		
		Если Элементы.Найти("СотрудникиСотрудникКод") <> Неопределено Тогда
			
			Элементы.СотрудникиСотрудникКод.Видимость = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ИзменитьОтображениеПодсказки(Элементы, Не ЗначениеЗаполнено(Объект.Ссылка)И ПолучитьФункциональнуюОпцию("ИспользоватьОтчетность"));
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	ПечатьДокументовУНФ.УстановитьОтображениеПодменюПечати(Элементы.ПодменюПечать);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	
	Оповестить("ИзменениеПоКадровомуУчету");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СотрудникиСотрудникПриИзменении(Элемент)
	
	ДанныеТекущейСтроки = Элементы.Сотрудники.ТекущиеДанные;
	
	СтруктураДанные = ПолучитьДанныеСотрудникаПриИзменении(НачалоДня(Объект.Дата), Объект.Организация, ДанныеТекущейСтроки.Сотрудник);
	
	ЗаполнитьЗначенияСвойств(ДанныеТекущейСтроки, СтруктураДанные);
	
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода Дата.
// В процедуре определяется ситуация, когда при изменении своей даты документ 
// оказывается в другом периоде нумерации документов, и в этом случае
// присваивает документу новый уникальный номер.
// Переопределяет соответствующий параметр формы.
//
Процедура ДатаПриИзменении(Элемент)
	
	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ДатаПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода Организация.
// В процедуре осуществляется очистка номера документа,
// а также производится установка параметров функциональных опций формы.
// Переопределяет соответствующий параметр формы.
//
Процедура ОрганизацияПриИзменении(Элемент)

	// Обработка события изменения организации.
	Объект.Номер = "";
	
	УвольняемыеСотрудники = Новый Соответствие;
	Для каждого СтрокаТаблицы Из Объект.Сотрудники Цикл
		
		УвольняемыеСотрудники.Вставить(СтрокаТаблицы.Сотрудник, Новый Структура("ПериодВыборки, Подразделение, Должность", НачалоДня(Объект.Дата)));
		
	КонецЦикла;
	
	СтруктураДанные = ПолучитьДанныеОрганизацияПриИзменении(Объект.Организация, УвольняемыеСотрудники);
	Компания = СтруктураДанные.Компания;
	
КонецПроцедуры // ОрганизацияПриИзменении()

&НаКлиенте
Процедура ДекорацияЗакрытьПодсказкуНажатие(Элемент)
	
	ИзменитьОтображениеПодсказки(Элементы, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДекорацияПечатьНажатие(Элемент)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьИзмененияРеквизитовПечати", ЭтотОбъект);
	ОткрытьФорму("Обработка.РеквизитыПечати.Форма.РеквизитыПечатиУвольнение", Новый Структура("КонтекстПечати", Объект), ЭтотОбъект, , , , ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьИзмененияРеквизитовПечати(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		
		ПечатьДокументовУНФКлиент.ОбновитьЗначенияРеквизитовПечати(ЭтотОбъект, Результат.ИзмененныеРеквизиты);
		
		Если Результат.Свойство("Команда") Тогда
			
			Подключаемый_ВыполнитьКоманду(Результат.Команда);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеДатаПриИзменении(ДокументСсылка, ДатаНовая, ДатаПередИзменением)
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("РазностьДат", ДокументыУНФ.ПроверитьНомерДокумента(ДокументСсылка, ДатаНовая, ДатаПередИзменением));
	
	Возврат СтруктураДанные;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаполнитьСведенияОСотруднике(ПериодВыборки, Сотрудник, Организация, СведенияОСотруднике)
	
	Если НЕ ЗначениеЗаполнено(ПериодВыборки) Тогда
		
		ДатаУвольнения = ТекущаяДатаСеанса();
		
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапросаОСведенияхПоСотруднику());
	Запрос.УстановитьПараметр("ПериодВыборки", ПериодВыборки - 1);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		ЗаполнитьЗначенияСвойств(СведенияОСотруднике, Выборка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеОрганизацияПриИзменении(Организация, УвольняемыеСотрудники)
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("Компания", Константы.УчетПоКомпании.Компания(Организация));
	
	Для каждого ОписаниеСотрудника Из УвольняемыеСотрудники Цикл
		
		ЗаполнитьСведенияОСотруднике(ОписаниеСотрудника.Значение.ПериодВыборки, ОписаниеСотрудника.Ключ, Организация, ОписаниеСотрудника.Значение);
		
	КонецЦикла;
	
	Возврат СтруктураДанные;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеСотрудникаПриИзменении(ПериодВыборки, Организация, Сотрудник)
	
	СведенияОСотруднике = Новый Структура("Подразделение, Должность");
	
	ЗаполнитьСведенияОСотруднике(ПериодВыборки, Сотрудник, Организация, СведенияОСотруднике);
	
	Возврат СведенияОСотруднике;
	
КонецФункции

&НаСервереБезКонтекста
Функция ТекстЗапросаОСведенияхПоСотруднику()
	
	Возврат 
	"ВЫБРАТЬ 
	|	СведенияОСотруднике.СтруктурнаяЕдиница КАК Подразделение
	|	,СведенияОСотруднике.Должность 
	|ИЗ РегистрСведений.Сотрудники.СрезПоследних(&ПериодВыборки, Организация = &Организация И Сотрудник = &Сотрудник) КАК СведенияОСотруднике";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОтображениеПодсказки(Элементы, Показать)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаПодсказкаАссистента",
		"Видимость",
		Показать);
	
КонецПроцедуры

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

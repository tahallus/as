﻿#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере формы
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Отборы
	// Банк и касса
	ПрочитатьРасчетныеСчетаИКассы();
	// Конец Отборы
	
	// Итоги
	РасчетыРаботаСФормамиВызовСервера.НастроитьПанельИтоговПриСозданииНаСервере(ЭтаФорма, "ПланированиеДенег");
	// Конец Итоги
	
	//УНФ.ОтборыСписка
	РаботаСОтборами.ОпределитьПорядокПредопределенныхОтборов(ЭтотОбъект);
	СписокКассИСчетов = Новый Массив;
	Список.Параметры.УстановитьЗначениеПараметра("БезОтбора", Истина);
	Список.Параметры.УстановитьЗначениеПараметра("СписокКассИСчетов", СписокКассИСчетов);
	
	Если Параметры.Свойство("ЭтоНачальнаяСтраница") Тогда
		РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список, "Список");
		ЭтоНачальнаяСтраница = Ложь;
	Иначе
		ЭтоНачальнаяСтраница = Истина;
		РаботаСОтборами.СвернутьРазвернутьОтборыНаСервере(ЭтотОбъект, Ложь);
		ПредставлениеПериода = РаботаСОтборамиКлиентСервер.ОбновитьПредставлениеПериода(Неопределено);
		ЭтоНачальнаяСтраница = Истина;
	КонецЕсли;
	//Конец УНФ.ОтборыСписка
	
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы Тогда
		//УНФ.ОтборыСписка
		СохранитьНастройкиОтборов();
		//Конец УНФ.ОтборыСписка
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ОбработатьАктивизациюСтрокиСписка", 0.2, Истина);
		
	Иначе
		
		Дата = "<Не выбран документ>";
		
		ТаблицаИтогов[0].Значение = 0;
		ТаблицаИтогов[1].Значение = 0;
		ТаблицаИтогов[2].Значение = 0;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьПоШаблону(Команда)
	
	ЗаполнениеОбъектовУНФКлиент.ПоказатьВыборШаблонаДляСозданияДокументаИзСписка(
	"ЖурналДокументов.ДокументыПланированияДенег",
	Список.КомпоновщикНастроек.Настройки.Отбор.Элементы,
	Элементы.Список.ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область Отборы

&НаСервере
Процедура ПрочитатьРасчетныеСчетаИКассы()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Кассы.Ссылка,
		|	ПРЕДСТАВЛЕНИЕ(Кассы.Ссылка) КАК Представление
		|ИЗ
		|	Справочник.Кассы КАК Кассы
		|
		|УПОРЯДОЧИТЬ ПО
		|	Кассы.Наименование
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	БанковскиеСчета.Ссылка,
		|	ПРЕДСТАВЛЕНИЕ(БанковскиеСчета.Ссылка) КАК Представление
		|ИЗ
		|	Справочник.БанковскиеСчета КАК БанковскиеСчета
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
		|		ПО БанковскиеСчета.Владелец = Организации.Ссылка";
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ВыборкаКасс = МассивРезультатов[0].Выбрать();
	ВыборкаСчетов = МассивРезультатов[1].Выбрать();
	
	Элементы.ОтборСчетИКасса.СписокВыбора.Очистить();
	
	Пока ВыборкаСчетов.Следующий() Цикл
		Элементы.ОтборСчетИКасса.СписокВыбора.Добавить(ВыборкаСчетов.Ссылка,,, БиблиотекаКартинок.Банк);
	КонецЦикла;
	Пока ВыборкаКасс.Следующий() Цикл
		Элементы.ОтборСчетИКасса.СписокВыбора.Добавить(ВыборкаКасс.Ссылка,,, БиблиотекаКартинок.Касса);
	КонецЦикла;
	
КонецПроцедуры

#Область ОтборПоПериоду

// Процедура настраивает период динамического списка (если требуется интерактивный выбор периода).
//
&НаКлиенте
Процедура УстановитьПериодЗавершение(Результат, Параметры) Экспорт
	
	УстановитьПериодЗавершениеНаСервере(Результат, Параметры);
	
КонецПроцедуры

// Процедура настраивает период динамического списка на сервере (если требуется интерактивный выбор периода).
//
&НаСервере
Процедура УстановитьПериодЗавершениеНаСервере(Результат, Параметры)
	
	Если Результат <> Неопределено Тогда
		
		Элементы[Параметры.ИмяСписка].Период.Вариант = Результат.Вариант;
		Элементы[Параметры.ИмяСписка].Период.ДатаНачала = Результат.ДатаНачала;
		Элементы[Параметры.ИмяСписка].Период.ДатаОкончания = Результат.ДатаОкончания;
		Элементы[Параметры.ИмяСписка].Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ДИНАМИЧЕСКОГО СПИСКА

// Выбор значения отбора в поле отбора
&НаКлиенте
Процедура ОтборКонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Список", "Контрагент", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Список", "Организация", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВидОперацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Список", "ВидОперации", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСчетИКассаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Список", "", Элемент.Родитель.Имя, ВыбранноеЗначение,, "СписокКассИСчетов");
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборАвторОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Список", "Автор", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВидОперацииНачалоВыбораЗавершение(РезультатЗавершения, ПараметрыЗавершения) Экспорт
	
	Если ЗначениеЗаполнено(РезультатЗавершения) Тогда
		Если ТипЗнч(РезультатЗавершения) = Тип("Строка") Тогда
			УстановитьМеткуИОтборСписка("Список", "ВидОперации", "ГруппаОтборВидОперации", "Перемещение. "
				+ РезультатЗавершения);
		Иначе
			УстановитьМеткуИОтборСписка("Список", "ВидОперации", "ГруппаОтборВидОперации", РезультатЗавершения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВалютаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Список", "Валюта", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСтатусПлатежногоПорученияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Список", "СтатусПлатежногоПоручения", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область Отборы

&НаСервере
Процедура УстановитьМеткуИОтборСписка(СписокДляОтбора, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения="", ИмяПараметраЗапроса="")
	
	Если ПредставлениеЗначения="" Тогда
		ПредставлениеЗначения=Строка(ВыбранноеЗначение);
	КонецЕсли; 
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения, СписокДляОтбора, ИмяПараметраЗапроса);
	
	Если ИмяПараметраЗапроса="" Тогда
		РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, ЭтотОбъект[СписокДляОтбора], ИмяПоляОтбораСписка);
	Иначе	
		
		СтруктураОтбораМеток = Новый Структура("ИмяПараметраЗапроса", ИмяПараметраЗапроса);
		НайденныеСтроки = ДанныеМеток.НайтиСтроки(СтруктураОтбораМеток);
		МассивОтбора = Новый Массив;
		Для каждого стр Из НайденныеСтроки Цикл
			МассивОтбора.Добавить(стр.Метка);
		КонецЦикла;
		ЭтотОбъект[СписокДляОтбора].Параметры.УстановитьЗначениеПараметра("БезОтбора", НайденныеСтроки.Количество()=0);
		ЭтотОбъект[СписокДляОтбора].Параметры.УстановитьЗначениеПараметра(ИмяПараметраЗапроса, МассивОтбора);
	КонецЕсли; 
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_") + 1);
	
	ИмяРеквизитаСписка = "Список";
	
	УдалитьМеткуОтбора(МеткаИД, ИмяРеквизитаСписка);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД, ИмяРеквизитаСписка)
	
	РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, ЭтотОбъект[ИмяРеквизитаСписка], МеткаИД, ИмяРеквизитаСписка);

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтруктураИменЭлементов = Новый Структура("ОтборПериод, ПредставлениеПериода, СобытиеОповещения", "ОтборПериод",
		"ПредставлениеПериода", "ОповещениеОбИзмененииДолга");
	
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, "Список", "Дата", СтруктураИменЭлементов);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтборов()
	
	Если НЕ ЭтоНачальнаяСтраница Тогда
		РаботаСОтборами.СохранитьНастройкиОтборов(ЭтотОбъект, "Список");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьРазвернутьПанельОтборов(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтборы(Команда)
	
	ИмяРеквизитаСписка = "Список";
	ИмяТЧДанныеМеток = "ДанныеМеток";
	ИмяТЧДанныеОтборов = "ДанныеОтборов";
	ИмяГруппыОтборов = "ГруппаОтборы";
	ИмяПредопределенныеОтборыПоУмолчанию = "ПредопределенныеОтборыПоУмолчанию";
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяРеквизитаСписка", ИмяРеквизитаСписка);
	ДополнительныеПараметры.Вставить("ИмяТЧДанныеМеток", ИмяТЧДанныеМеток);
	ДополнительныеПараметры.Вставить("ИмяТЧДанныеОтборов", ИмяТЧДанныеОтборов);
	ДополнительныеПараметры.Вставить("ИмяГруппыОтборов", ИмяГруппыОтборов);
	ДополнительныеПараметры.Вставить("ИмяПредопределенныеОтборыПоУмолчанию", ИмяПредопределенныеОтборыПоУмолчанию);
	
	РаботаСОтборамиКлиент.НастроитьОтборыНажатие(ЭтотОбъект, ПараметрыОткрытияФормыСНастройкамиОтборов(ДополнительныеПараметры), ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыОткрытияФормыСНастройкамиОтборов(ДополнительныеПараметры)
	
	Возврат РаботаСОтборами.ПараметрыДляОткрытияФормыСНастройкамиОтборов(ЭтотОбъект, ДополнительныеПараметры);
	
КонецФункции

&НаКлиенте
Процедура НастройкаОтборовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НастройкаОтборовЗавершениеНаСервере(Результат.АдресВыбранныеОтборы, Результат.АдресУдаленныеОтборы, ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Процедура НастройкаОтборовЗавершениеНаСервере(АдресВыбранныеОтборы, АдресУдаленныеОтборы, ДополнительныеПараметры)
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ИмяРеквизитаСписка = "Список";
		ИмяТЧДанныеМеток = "ДанныеМеток";
		ИмяТЧДанныеОтборов = "ДанныеОтборов";
	Иначе
		ИмяРеквизитаСписка = ДополнительныеПараметры.ИмяРеквизитаСписка;
		ИмяТЧДанныеМеток = ДополнительныеПараметры.ИмяТЧДанныеМеток;
		ИмяТЧДанныеОтборов = ДополнительныеПараметры.ИмяТЧДанныеОтборов;
	КонецЕсли;
	
	РаботаСОтборами.НастройкаОтборовЗавершение(ЭтотОбъект, АдресВыбранныеОтборы, АдресУдаленныеОтборы, ДополнительныеПараметры);
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ОтборПриИзменении(Элемент)
	
	Подключаемый_ОтборПриИзмененииНаСервере(Элемент.Имя, Элемент.Родитель.Имя)
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОтборПриИзмененииНаСервере(ЭлементИмя, ЭлементРодительИмя)
	
	РаботаСОтборами.Подключаемый_ОтборПриИзменении(ЭтотОбъект, ЭлементИмя, ЭлементРодительИмя);
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ОтборОчистка(Элемент)
	
	Подключаемый_ОтборОчисткаНаСервере(Элемент.Имя, Элемент.Родитель.Имя)
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОтборОчисткаНаСервере(ЭлементИмя, ЭлементРодительИмя)
	
	РаботаСОтборами.Подключаемый_ОтборОчистка(ЭтотОбъект, ЭлементИмя);

КонецПроцедуры

#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ОбработатьАктивизациюСтрокиСписка()
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	
	РасчетыРаботаСФормамиКлиент.ОбновлениеИтоговПриАктивизацииСтрокиСписка(ЭтаФорма, ТекущаяСтрока, "ПланированиеДенег");
	
КонецПроцедуры // ОбработатьАктивизациюСтрокиСписка()

&НаКлиенте
Процедура ДатаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		ПериодОтчета = Новый СтандартныйПериод;
		ПериодОтчета.ДатаНачала = Элементы.Список.ТекущиеДанные.Дата;
		ПериодОтчета.ДатаОкончания = Элементы.Список.ТекущиеДанные.Дата;
		ПараметрыОтчета = Новый Структура("СтПериод", ПериодОтчета);
	Иначе
		ПериодОтчета = Новый СтандартныйПериод;
		ПериодОтчета.ДатаНачала = '00010101';
		ПериодОтчета.ДатаОкончания = '00010101';
		ПараметрыОтчета = Новый Структура("СтПериод", ПериодОтчета);
	КонецЕсли;
	
	ОткрытьФорму("Отчет.ПлатежныйКалендарь.Форма.Форма", Новый Структура("СформироватьПриОткрытии, Отбор", Истина,
		ПараметрыОтчета));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеДанныхПлатежногоКалендаря" Тогда
		Подключаемый_ОбработатьАктивизациюСтрокиСписка();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьИтогиКонтекстноеМеню(Команда)
	
	РасчетыРаботаСФормамиКлиент.ОткрытьФормуИтоговКонтекстноеМеню(ЭтаФорма, "ПланированиеДенег");
	
КонецПроцедуры

#КонецОбласти

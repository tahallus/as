﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	// Установка способа выбора структурной единицы в зависимости от ФО.
	Если НЕ Константы.ФункциональнаяОпцияУчетПоНесколькимПодразделениям.Получить()
		И НЕ Константы.ФункциональнаяОпцияУчетПоНесколькимСкладам.Получить() Тогда
		
		Элементы.ОтборСклад.РежимВыбораИзСписка = Истина;
		Элементы.ОтборСклад.СписокВыбора.Добавить(Справочники.СтруктурныеЕдиницы.ОсновнойСклад);
		Элементы.ОтборСклад.СписокВыбора.Добавить(Справочники.СтруктурныеЕдиницы.ОсновноеПодразделение);
		
	КонецЕсли;
	
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(Список);
	
	//УНФ.ОтборыСписка
	РаботаСОтборами.ОпределитьПорядокПредопределенныхОтборов(ЭтотОбъект);
	РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список);
	//Конец УНФ.ОтборыСписка
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
		
	Если НЕ ЗавершениеРаботы Тогда
		//УНФ.ОтборыСписка
		СохранитьНастройкиОтборов();
		//Конец УНФ.ОтборыСписка
	КонецЕсли; 

КонецПроцедуры

// Процедура - обработчик события формы "ПриЗагрузкеДанныхИзНастроекНаСервере".
//
&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОтборТипОприходование	= Настройки.Получить("ОтборТипОприходование");
	ОтборТипСписание		= Настройки.Получить("ОтборТипСписание");
	ОтборТипИнвентаризация	= Настройки.Получить("ОтборТипИнвентаризация");
	ОтборТипПересортица		= Настройки.Получить("ОтборТипПересортица");
	
	УстановитьОтборПоТипуДокумента();
	
КонецПроцедуры // ПриЗагрузкеДанныхИзНастроекНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
// Процедура - обработчик события ПриИзменении реквизита ТипДокумента.
// 
Процедура ТипДокументаПриИзменении(Элемент)
	
	УстановитьОтборПоТипуДокумента();
	
КонецПроцедуры


&НаКлиенте
Процедура ОтборТипПересортицаПриИзменении(Элемент)
	
	УстановитьОтборПоТипуДокумента();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоТипуДокумента()
	
	МассивОтбора = Новый Массив;
	Если ОтборТипОприходование Тогда
		МассивОтбора.Добавить(Тип("ДокументСсылка.ОприходованиеЗапасов"));
	КонецЕсли;
	Если ОтборТипСписание Тогда
		МассивОтбора.Добавить(Тип("ДокументСсылка.СписаниеЗапасов"));
	КонецЕсли;
	Если ОтборТипИнвентаризация Тогда
		МассивОтбора.Добавить(Тип("ДокументСсылка.ИнвентаризацияЗапасов"));
	КонецЕсли;
	Если ОтборТипПересортица Тогда
		МассивОтбора.Добавить(Тип("ДокументСсылка.ПересортицаЗапасов"));
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Тип", МассивОтбора, , ,
		ЗначениеЗаполнено(МассивОтбора));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСкладОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("СтруктурнаяЕдиница", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;

КонецПроцедуры

&НаКлиенте
Процедура ОтборЯчейкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Ячейка", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;

КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Организация", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Параметр) Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	СтруктураПараметров = Новый Структура();
	РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ДанныеМеток, СтруктураПараметров, "СтруктурнаяЕдиница");
	РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ДанныеМеток, СтруктураПараметров, "Ячейка");
	РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ДанныеМеток, СтруктураПараметров, "Организация");
		
	ИмяФормыСтрока = РаботаСФормойДокументаКлиент.ИмяДокументаПоТипу(Параметр);
	ОткрытьФорму("Документ."+ИмяФормыСтрока+".ФормаОбъекта", Новый Структура("ЗначенияЗаполнения",СтруктураПараметров));

КонецПроцедуры

#КонецОбласти

#Область Отборы

&НаСервере
Процедура УстановитьМеткуИОтборСписка(ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения="")
	
	Если ПредставлениеЗначения="" Тогда
		ПредставлениеЗначения=Строка(ВыбранноеЗначение);
	КонецЕсли; 
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения);
	РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, Список, ИмяПоляОтбораСписка);
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_") + 1);
	УдалитьМеткуОтбора(МеткаИД);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД)
	
	РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, Список, МеткаИД);

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтборов()
	
	РаботаСОтборами.СохранитьНастройкиОтборов(ЭтотОбъект);
	
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

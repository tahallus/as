﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.ГруппаПодсказка.Видимость = Объект.Периодичный;
	Элементы.ДекорацияГодНумерации.Заголовок = НСтр("ru = 'за '") + Формат(Год(ТекущаяДатаСеанса()), "ЧГ=0")+ НСтр("ru = ' г.'");
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекущийНомер = 1;
		ЗаписыватьНумерацию = Истина;
		Если Параметры.Свойство("Организация") Тогда
			Объект.Организация = Параметры.Организация;
		Иначе
			Объект.Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
		КонецЕсли;
		СформироватьНаименование(ЭтаФорма);
		Если Не ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			Объект.ФорматНомера = "[Номер]";
		КонецЕсли;
	Иначе
		РедактировалосьНаименование = Истина;
		ТекущийНомер = ПолучитьАктуальныйНомер();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Договор) Тогда 
		ВидНумерации = 2;
	ИначеЕсли ЗначениеЗаполнено(Объект.ВидДоговора) Тогда 
		ВидНумерации = 1;
	ИначеЕсли ЗначениеЗаполнено(Объект.КатегорияДоговора) Тогда 
		ВидНумерации = 4;
	Иначе
		ВидНумерации = 3;
	КонецЕсли;
	
	Элементы.ГруппаОрганизация.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	Элементы.ПрефиксРИБ.Видимость = ЗначениеЗаполнено(ПолучитьФункциональнуюОпцию("ПрефиксИнформационнойБазы"));
	
	УстановитьВидимостьИДоступность(ЭтаФорма);
	Если ЭтотОбъект.ТолькоПросмотр Тогда
		Элементы.ПодменюВставки.Доступность = Ложь;
		Элементы.ВидНумерации.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		СформироватьПримерНомера();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	ТекстСообщения = "";
	ИмяРеквизита = "";
	Если ВидНумерации = 1 Тогда
		Если Не ЗначениеЗаполнено(Объект.ВидДоговора) Тогда
			ТекстСообщения = НСтр("ru = 'Не заполнено поле Вид договора.'");
			ИмяРеквизита = "Объект.ВидДоговора";
		КонецЕсли;
	ИначеЕсли ВидНумерации = 2 Тогда
		Если Не ЗначениеЗаполнено(Объект.Договор) Тогда
			ТекстСообщения = НСтр("ru = 'Не заполнено поле Группа договоров.'");
			ИмяРеквизита = "Объект.Договор";
		КонецЕсли;
	ИначеЕсли ВидНумерации = 4 Тогда
		Если Не ЗначениеЗаполнено(Объект.КатегорияДоговора) Тогда
			ТекстСообщения = НСтр("ru = 'Не заполнено поле Категория договора.'");
			ИмяРеквизита = "Объект.КатегорияДоговора";
		КонецЕсли;
	КонецЕсли;
	
	Если Не ПустаяСтрока(ТекстСообщения) Тогда
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,, ИмяРеквизита, Отказ);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_НастройкаАвтонумерацииДоговоров", Объект.Ссылка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДеньМесяца(Команда)
	Объект.ФорматНомера = Объект.ФорматНомера + "[День]";
	СформироватьПримерНомера();
КонецПроцедуры

&НаКлиенте
Процедура НомерМесяца(Команда)
	Объект.ФорматНомера = Объект.ФорматНомера + "[Месяц]";
	СформироватьПримерНомера();
КонецПроцедуры

&НаКлиенте
Процедура НомерКвартала(Команда)
	Объект.ФорматНомера = Объект.ФорматНомера + "[Квартал]";
	СформироватьПримерНомера();
КонецПроцедуры

&НаКлиенте
Процедура Год2(Команда)
	Объект.ФорматНомера = Объект.ФорматНомера + "[Год2]";
	СформироватьПримерНомера();
КонецПроцедуры

&НаКлиенте
Процедура Год4(Команда)
	Объект.ФорматНомера = Объект.ФорматНомера + "[Год4]";
	СформироватьПримерНомера();
КонецПроцедуры

&НаКлиенте
Процедура Номер(Команда)
	Объект.ФорматНомера = Объект.ФорматНомера + "[Номер]";
	СформироватьПримерНомера();
КонецПроцедуры

&НаКлиенте
Процедура ПрефиксРИБ(Команда)
	Объект.ФорматНомера = Объект.ФорматНомера + "[ПрефиксИБ]";
	СформироватьПримерНомера();
КонецПроцедуры

&НаКлиенте
Процедура ПрефиксКатегории(Команда)
	Объект.ФорматНомера = Объект.ФорматНомера + "[ПрефиксКатегории]";
	СформироватьПримерНомера();
КонецПроцедуры

&НаКлиенте
Процедура ВидКонтрагента(Команда)
	Объект.ФорматНомера = Объект.ФорматНомера + "[ВидКонтрагента]";
	СформироватьПримерНомера();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНумерациюДоговоров(Команда)
	Если Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("Отбор", Новый Структура("НастройкиНумерации", Объект.Ссылка));
	ОткрытьФорму("РегистрСведений.АвтоНумерацияДоговоровКонтрагента.ФормаСписка",ПараметрыОткрытия, ЭтаФорма, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ФорматНомераПриИзменении(Элемент)
	СформироватьПримерНомера();
КонецПроцедуры

&НаКлиенте
Процедура ПериодичныйПриИзменении(Элемент)
	Элементы.ГруппаПодсказка.Видимость = Объект.Периодичный;
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	РедактировалосьНаименование = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДоговорПриИзменении(Элемент)
	ДоговорПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура КатегорияДоговораПриИзменении(Элемент)
	КатегорияДоговораПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВидДоговораПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.ВидДоговора) Тогда
		Объект.Договор = Неопределено;
	КонецЕсли;
	
	СформироватьНаименование(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура НачатьСПриИзменении(Элемент)
	Модифицированность = Истина;
	ЗаписыватьНумерацию = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ВидНумерацииПриИзменении(Элемент)
	ВидНумерацииПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура ВидНумерацииПриИзмененииНаСервере()
	
	Если ВидНумерации = 1 Тогда
		Объект.КатегорияДоговора = Справочники.КатегорииДоговоров.ПустаяСсылка();
		Объект.Договор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	ИначеЕсли ВидНумерации = 2 Тогда
		Объект.ВидДоговора = Перечисления.ВидыДоговоров.ПустаяСсылка();
		Объект.КатегорияДоговора = Справочники.КатегорииДоговоров.ПустаяСсылка();
	ИначеЕсли ВидНумерации = 4 Тогда
		Объект.Договор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
		Объект.ВидДоговора = Перечисления.ВидыДоговоров.ПустаяСсылка();
	Иначе
		Объект.Договор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
		Объект.ВидДоговора = Перечисления.ВидыДоговоров.ПустаяСсылка();
		Объект.КатегорияДоговора = Справочники.КатегорииДоговоров.ПустаяСсылка();
	КонецЕсли;
	
	УстановитьВидимостьИДоступность(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ДоговорПриИзмененииНаСервере()
	Если ЗначениеЗаполнено(Объект.Договор) Тогда
		Объект.ВидДоговора = Перечисления.ВидыДоговоров.ПустаяСсылка();
		Объект.КатегорияДоговора = Справочники.КатегорииДоговоров.ПустаяСсылка();
		Объект.Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Договор, "Организация");
	КонецЕсли;
	СформироватьНаименование(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура КатегорияДоговораПриИзмененииНаСервере()
	Если ЗначениеЗаполнено(Объект.КатегорияДоговора) Тогда
		Объект.ВидДоговора = Перечисления.ВидыДоговоров.ПустаяСсылка();
		Объект.Договор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	КонецЕсли;
	СформироватьНаименование(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПримерНомера()
	
	ОписаниеОшибки = "";
	Если Не Нумерация.СформироватьПримерНомера(Объект.ФорматНомера, Объект.ПримерНомера, ОписаниеОшибки) Тогда 
		Объект.ПримерНомера = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка в формате номера: %1'"), ОписаниеОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СформироватьНаименование(Форма)
	Объект = Форма.Объект;
	Если Форма.РедактировалосьНаименование Тогда
		Возврат;
	КонецЕсли;
	
	Наименование = "";
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		Наименование = Наименование + НСтр("ru = 'По организации '")+ Объект.Организация;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ВидДоговора) Тогда
		Наименование = Наименование +?(ПустаяСтрока(Наименование), НСтр("ru = 'По '"), НСтр("ru = ', '")) + НСтр("ru = 'виду договора '")+ Объект.ВидДоговора;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Договор) Тогда
		Наименование = Наименование +?(ПустаяСтрока(Наименование), НСтр("ru = 'По '"), НСтр("ru = ', '")) + НСтр("ru = 'договору '")+ Объект.Договор;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.КатегорияДоговора) Тогда
		Наименование = Наименование +?(ПустаяСтрока(Наименование), НСтр("ru = 'По '"), НСтр("ru = ', '")) + НСтр("ru = 'категории '")+ Объект.КатегорияДоговора;
	КонецЕсли;
	
	Объект.Наименование = Наименование;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	Если ЗаписыватьНумерацию Тогда
		ЗаписьНумерации = РегистрыСведений.АвтоНумерацияДоговоровКонтрагента.СоздатьМенеджерЗаписи();
		ЗаписьНумерации.НастройкиНумерации = Объект.Ссылка;
		ЗаписьНумерации.ПериодНумерации = ?(Объект.Периодичный, НачалоГода(ТекущаяДатаСеанса()), Дата('00010101'));
		ЗаписьНумерации.ТекущийНомер = ТекущийНомер;
		ЗаписьНумерации.Записать(Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьАктуальныйНомер()
	
	ПериодНумерации = ?(Объект.Периодичный, НачалоГода(ТекущаяДатаСеанса()), Дата('00010101'));
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	АвтоНумерацияДоговоровКонтрагента.ТекущийНомер КАК ТекущийНомер
	|ИЗ
	|	РегистрСведений.АвтоНумерацияДоговоровКонтрагента КАК АвтоНумерацияДоговоровКонтрагента
	|ГДЕ
	|	АвтоНумерацияДоговоровКонтрагента.НастройкиНумерации = &НастройкиНумерации
	|	И АвтоНумерацияДоговоровКонтрагента.ПериодНумерации = &ПериодНумерации";
	
	Запрос.УстановитьПараметр("НастройкиНумерации", Объект.Ссылка);
	Запрос.УстановитьПараметр("ПериодНумерации", ПериодНумерации);
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ТекущийНомер;
	Иначе
		// Настал новый год, необходимо создать новую нумерацию
		ЗаписьНумерации = РегистрыСведений.АвтоНумерацияДоговоровКонтрагента.СоздатьМенеджерЗаписи();
		ЗаписьНумерации.НастройкиНумерации = Объект.Ссылка;
		ЗаписьНумерации.ПериодНумерации = ПериодНумерации;
		ЗаписьНумерации.ТекущийНомер = 1;
		ЗаписьНумерации.Записать(Истина);
		Возврат 1;
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьИДоступность(Форма)
	Элементы = Форма.Элементы;
	Если Форма.ВидНумерации = 1 Тогда
		Элементы.ГруппаВидДоговора.Видимость = Истина;
		Элементы.ГруппаРамочныйДоговор.Видимость = Ложь;
		Элементы.ГруппаКатегорияДоговоров.Видимость = Ложь;
	ИначеЕсли Форма.ВидНумерации = 2 Тогда
		Элементы.ГруппаВидДоговора.Видимость = Ложь;
		Элементы.ГруппаРамочныйДоговор.Видимость = Истина;
		Элементы.ГруппаКатегорияДоговоров.Видимость = Ложь;
	ИначеЕсли Форма.ВидНумерации = 4 Тогда
		Элементы.ГруппаВидДоговора.Видимость = Ложь;
		Элементы.ГруппаРамочныйДоговор.Видимость = Ложь;
		Элементы.ГруппаКатегорияДоговоров.Видимость = Истина;
	Иначе
		Элементы.ГруппаВидДоговора.Видимость = Ложь;
		Элементы.ГруппаРамочныйДоговор.Видимость = Ложь;
		Элементы.ГруппаКатегорияДоговоров.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры


#КонецОбласти
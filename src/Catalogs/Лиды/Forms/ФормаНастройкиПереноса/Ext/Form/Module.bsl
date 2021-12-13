﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РазрешеноИзменятьНастройки = Пользователи.РолиДоступны("ПолныеПрава");
	
	Если НЕ РазрешеноИзменятьНастройки Тогда
		Элементы.ГруппаПолей.Доступность = Ложь;
		Элементы.ФормаОК.Доступность = Ложь;
		Элементы.ФормаОтмена.Доступность = Ложь;
		Элементы.ПереноситьФайлы.Доступность = Ложь;
	КонецЕсли;
	
	ЗаполнитьРеквизитыЛида();
	ЗаполнитьРеквизитыКонтрагента();
	ЗаполнитьСоответствия();
	ОбновитьЭлементыСоответствий();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура Подключаемый_ПолеЛидаПриИзменении(Элемент)
	
	Индекс = ИндексСоответствия(Элемент.Имя);
	Соответствие = Соответствия[Число(Индекс)];
	ЭлементКонтрагента = Элементы["ПолеПокупателя_" + Индекс];
	
	Соответствие.Удалено = НЕ ЗначениеЗаполнено(Соответствие.НаименованиеРеквизитаЛид) 
		И НЕ ЗначениеЗаполнено(Соответствие.ИмяРеквизитаКонтрагент);
		
	Если НЕ ЗначениеЗаполнено(Соответствие.НаименованиеРеквизитаЛид) Тогда
		Соответствие.ИмяРеквизитаЛид = "";
		ЗаполнитьСписокВыбора(ЭлементКонтрагента, РеквизитыКонтрагента);
		Возврат;
	КонецЕсли;
	
	ТипЗначения = ТипРеквизитаПоИмени(Соответствие.ИмяРеквизитаЛид, РеквизитыЛида);
	ИзменитьСписокВыбораПоТипуЗначения(ЭлементКонтрагента.Имя, РеквизитыКонтрагента, ТипЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеЛидаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Индекс = ИндексСоответствия(Элемент.Имя);
	Соответствие = Соответствия[Число(Индекс)];
	ЭлементКонтрагента = Элементы["ПолеПокупателя_" + Индекс];
	
	Соответствие.ИмяРеквизитаЛид = ВыбранноеЗначение;
	Соответствие.НаименованиеРеквизитаЛид = НаименованиеРеквизитаПоИмени(ВыбранноеЗначение, РеквизитыЛида);
	
	ТипЗначенияЛид = ТипРеквизитаПоИмени(Соответствие.ИмяРеквизитаЛид, РеквизитыЛида);
	ТипЗначенияКонтрагент = ТипРеквизитаПоИмени(Соответствие.ИмяРеквизитаКонтрагент, РеквизитыКонтрагента);
	СписокТиповЛиды = ТипЗначенияЛид.Типы();
	
	Соответствие.Удалено = НЕ ЗначениеЗаполнено(Соответствие.НаименованиеРеквизитаЛид) 
		И НЕ ЗначениеЗаполнено(Соответствие.ИмяРеквизитаКонтрагент);
		
	Если НЕ ЗначениеЗаполнено(Соответствие.НаименованиеРеквизитаЛид) Тогда
		Соответствие.ИмяРеквизитаЛид = "";
		ЗаполнитьСписокВыбора(ЭлементКонтрагента, РеквизитыКонтрагента);
		Возврат;
	КонецЕсли;
	
	СписокСодержитТип = Ложь;
	Для Каждого ТипЛида Из СписокТиповЛиды Цикл
		
		СписокСодержитТип = ТипЗначенияКонтрагент.СодержитТип(ТипЛида);
		Если СписокСодержитТип Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ СписокСодержитТип Тогда
		Соответствие.ИмяРеквизитаКонтрагент = "";
		Соответствие.НаименованиеРеквизитаКонтрагент = "";
	КонецЕсли;
	
	ИзменитьСписокВыбораПоТипуЗначения(ЭлементКонтрагента.Имя, РеквизитыКонтрагента, ТипЗначенияЛид);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПокупателяПриИзменении(Элемент)
	
	Индекс = ИндексСоответствия(Элемент.Имя);
	Соответствие = Соответствия[Число(Индекс)];
	ЭлементЛида = Элементы["ПолеЛида_" + Индекс];
	
	Соответствие.Удалено = НЕ ЗначениеЗаполнено(Соответствие.НаименованиеРеквизитаКонтрагент) 
		И НЕ ЗначениеЗаполнено(Соответствие.ИмяРеквизитаЛид);
	
	Если НЕ ЗначениеЗаполнено(Соответствие.НаименованиеРеквизитаКонтрагент) Тогда
		Соответствие.ИмяРеквизитаКонтрагент = "";
		ЗаполнитьСписокВыбора(ЭлементЛида, РеквизитыЛида);
		Возврат;
	КонецЕсли;
	
	ТипЗначения = ТипРеквизитаПоИмени(Соответствие.ИмяРеквизитаКонтрагент, РеквизитыКонтрагента);
	ИзменитьСписокВыбораПоТипуЗначения(ЭлементЛида.Имя, РеквизитыЛида, ТипЗначения);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПокупателяОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Индекс = ИндексСоответствия(Элемент.Имя);
	Соответствие = Соответствия[Число(Индекс)];
	ЭлементЛида = Элементы["ПолеЛида_" + Индекс];

	
	Соответствие.ИмяРеквизитаКонтрагент = ВыбранноеЗначение;
	Соответствие.НаименованиеРеквизитаКонтрагент = НаименованиеРеквизитаПоИмени(ВыбранноеЗначение, РеквизитыКонтрагента);
	
	ТипЗначенияЛид = ТипРеквизитаПоИмени(Соответствие.ИмяРеквизитаЛид, РеквизитыЛида);
	ТипЗначенияКонтрагент = ТипРеквизитаПоИмени(Соответствие.ИмяРеквизитаКонтрагент, РеквизитыКонтрагента);
	СписокТиповКонтрагент = ТипЗначенияКонтрагент.Типы();
	
	Соответствие.Удалено = НЕ ЗначениеЗаполнено(Соответствие.НаименованиеРеквизитаКонтрагент) 
		И НЕ ЗначениеЗаполнено(Соответствие.ИмяРеквизитаЛид);

	Если НЕ ЗначениеЗаполнено(Соответствие.НаименованиеРеквизитаКонтрагент) Тогда
		Соответствие.ИмяРеквизитаКонтрагент = "";
		ЗаполнитьСписокВыбора(ЭлементЛида, РеквизитыЛида);
		Возврат;
	КонецЕсли;
	
	СписокСодержитТип = Ложь;
	Для Каждого ТипКонтрагента Из СписокТиповКонтрагент Цикл
		
		СписокСодержитТип = ТипЗначенияЛид.СодержитТип(ТипКонтрагента);
		Если СписокСодержитТип Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если НЕ СписокСодержитТип Тогда
		Соответствие.ИмяРеквизитаЛид = "";
		Соответствие.НаименованиеРеквизитаЛид = "";
	КонецЕсли;

	ИзменитьСписокВыбораПоТипуЗначения(ЭлементЛида.Имя, РеквизитыЛида, ТипЗначенияКонтрагент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеЛидаОчистка(Элемент, СтандартнаяОбработка)
	
	Индекс = ИндексСоответствия(Элемент.Имя);
	Соответствие = Соответствия[Число(Индекс)];
	ЭлементКонтрагента = Элементы["ПолеПокупателя_" + Индекс];
	
	Соответствие.ИмяРеквизитаЛид = "";
	
	Соответствие.Удалено = НЕ ЗначениеЗаполнено(Соответствие.ИмяРеквизитаКонтрагент) 
		И НЕ ЗначениеЗаполнено(Соответствие.ИмяРеквизитаЛид);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПокупателяОчистка(Элемент, СтандартнаяОбработка)
	
	Индекс = ИндексСоответствия(Элемент.Имя);
	Соответствие = Соответствия[Число(Индекс)];
	ЭлементЛида = Элементы["ПолеЛида_" + Индекс];
	
	Соответствие.ИмяРеквизитаКонтрагент = "";
	
	Соответствие.Удалено = НЕ ЗначениеЗаполнено(Соответствие.ИмяРеквизитаКонтрагент) 
		И НЕ ЗначениеЗаполнено(Соответствие.ИмяРеквизитаЛид);
		
	Элемент.АвтоОтметкаНезаполненного = ЗначениеЗаполнено(Соответствие.НаименованиеРеквизитаЛид) 
		И НЕ ЗначениеЗаполнено(Соответствие.НаименованиеРеквизитаКонтрагент);
	ЭлементЛида.АвтоОтметкаНезаполненного = ЗначениеЗаполнено(Соответствие.НаименованиеРеквизитаКонтрагент) 
		И НЕ ЗначениеЗаполнено(Соответствие.НаименованиеРеквизитаЛид);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьРеквизитыЛида()
	
	СправочникЛиды = Метаданные.Справочники["Лиды"];
	СправочникЛидыРеквизиты = СправочникЛиды.Реквизиты;
	
	СтандартныеРеквизиты = Справочники.Лиды.СтандартныеРеквизитыДляПереводаВПокупателя();
	
	Для Каждого Реквизит Из СтандартныеРеквизиты Цикл
		НовыйРеквизит = РеквизитыЛида.Добавить();
		НовыйРеквизит.Имя           = Реквизит.Ключ;
		НовыйРеквизит.Представление = Реквизит.Значение;
		НовыйРеквизит.ТипЗначения   = ТипЗначенияРеквизита(Реквизит.Ключ, СправочникЛидыРеквизиты);
	КонецЦикла;
	
	НаборДопРеквизитов = Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Лиды;
	ДобавитьДополнительныеРеквизиты(НаборДопРеквизитов, РеквизитыЛида);
	
	РеквизитыЛида.Сортировать("Представление");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыКонтрагента()
	
	СправочникКонтрагенты = Метаданные.Справочники["Контрагенты"];
	СправочникКонтрагентыРеквизиты = СправочникКонтрагенты.Реквизиты;
	
	СтандартныеРеквизиты = Справочники.Контрагенты.СтандартныеРеквизитыДляПереводаВПокупателя();
	
	Для Каждого Реквизит Из СтандартныеРеквизиты Цикл
		НовыйРеквизит = РеквизитыКонтрагента.Добавить();
		НовыйРеквизит.Имя           = Реквизит.Ключ;
		НовыйРеквизит.Представление = Реквизит.Значение;
		НовыйРеквизит.ТипЗначения   = ТипЗначенияРеквизита(Реквизит.Ключ, СправочникКонтрагентыРеквизиты);
	КонецЦикла;
	
	НаборДопРеквизитов = Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Контрагенты;
	ДобавитьДополнительныеРеквизиты(НаборДопРеквизитов, РеквизитыКонтрагента);
	
	РеквизитыКонтрагента.Сортировать("Представление");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСоответствия()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СоответствиеПолейЛидаИКонтрагента.ИмяРеквизитаЛид КАК ИмяРеквизитаЛид,
	|	СоответствиеПолейЛидаИКонтрагента.ИмяРеквизитаКонтрагент КАК ИмяРеквизитаКонтрагент
	|ИЗ
	|	РегистрСведений.СоответствиеПолейЛидаИКонтрагента КАК СоответствиеПолейЛидаИКонтрагента";
	
	Результат = Запрос.Выполнить();
	Выборка   = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ИмяРеквизитаЛид = "ПрисоединенныеФайлы" Тогда
			ПереноситьФайлы = Истина;
			Продолжить;
		КонецЕсли;
		
		НоваяНастройка = Соответствия.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяНастройка, Выборка);
		НоваяНастройка.НаименованиеРеквизитаЛид        = НаименованиеРеквизитаПоИмени(Выборка.ИмяРеквизитаЛид, РеквизитыЛида);
		НоваяНастройка.НаименованиеРеквизитаКонтрагент = НаименованиеРеквизитаПоИмени(Выборка.ИмяРеквизитаКонтрагент, РеквизитыКонтрагента);
		
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Процедура УстановитьОформлениеПоля(ДобавляемыйЭлемент, ЭлементФормы)
	
	ДобавляемыйЭлемент.Вид = ЭлементФормы.Вид;
	ДобавляемыйЭлемент.ПоложениеЗаголовка = ЭлементФормы.ПоложениеЗаголовка;
	ДобавляемыйЭлемент.Заголовок = ЭлементФормы.Заголовок;
	ДобавляемыйЭлемент.АвтоМаксимальнаяШирина = ЭлементФормы.АвтоМаксимальнаяШирина;
	ДобавляемыйЭлемент.МаксимальнаяШирина = ЭлементФормы.МаксимальнаяШирина;
	ДобавляемыйЭлемент.РежимВыбораИзСписка = ЭлементФормы.РежимВыбораИзСписка;
	ДобавляемыйЭлемент.КнопкаВыпадающегоСписка = ЭлементФормы.КнопкаВыпадающегоСписка;
	ДобавляемыйЭлемент.КнопкаОткрытия = ЭлементФормы.КнопкаОткрытия;
	ДобавляемыйЭлемент.КнопкаВыбора = ЭлементФормы.КнопкаВыбора;
	ДобавляемыйЭлемент.АвтоОтметкаНезаполненного = ЭлементФормы.АвтоОтметкаНезаполненного;
	ДобавляемыйЭлемент.ОтображениеПодсказки = ЭлементФормы.ОтображениеПодсказки;
	ДобавляемыйЭлемент.Подсказка = ЭлементФормы.Подсказка;
	ДобавляемыйЭлемент.ИсторияВыбораПриВводе = ЭлементФормы.ИсторияВыбораПриВводе;
	ДобавляемыйЭлемент.КнопкаСоздания = ЭлементФормы.КнопкаСоздания;
	ДобавляемыйЭлемент.КнопкаОткрытия = ЭлементФормы.КнопкаОткрытия;
	ДобавляемыйЭлемент.КнопкаОчистки = ЭлементФормы.КнопкаОчистки;
	ДобавляемыйЭлемент.ПодсказкаВвода = ЭлементФормы.ПодсказкаВвода;

КонецПроцедуры

&НаСервере
Процедура УстановитьОформлениеГруппы(ДобавляемаяГруппа, ГруппаФормы)
	
	ДобавляемаяГруппа.Вид = ГруппаФормы.Вид;
	ДобавляемаяГруппа.Отображение = ГруппаФормы.Отображение;
	ДобавляемаяГруппа.Группировка = ГруппаФормы.Группировка;
	ДобавляемаяГруппа.ОтображатьЗаголовок = ГруппаФормы.ОтображатьЗаголовок;
	ДобавляемаяГруппа.ЦветФона = ГруппаФормы.ЦветФона;
	ДобавляемаяГруппа.СквозноеВыравнивание = ГруппаФормы.СквозноеВыравнивание;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыСоответствий()
	
	Элементы.Переместить(Элементы.ДобавитьСоответствие, Элементы.Соответствие_0);
	УдалитьЭлементыСоответствий(Элементы);
	
	Для Каждого СтрокаНастроек Из Соответствия Цикл
		
		ИндексНастройки = Соответствия.Индекс(СтрокаНастроек);
		
		Если ИндексНастройки > 0 Тогда
			
			ОбщаяГруппаДействия = Элементы.Добавить("Соответствие_" + ИндексНастройки, Тип("ГруппаФормы"), Элементы.ГруппаСоответствий);
			УстановитьОформлениеГруппы(ОбщаяГруппаДействия, Элементы.Соответствие_0);
							
			ПолеРеквизитЛида = Элементы.Добавить("ПолеЛида_" + ИндексНастройки, Тип("ПолеФормы"), ОбщаяГруппаДействия);
			ПолеРеквизитЛида.ПутьКДанным = "Соответствия[" + ИндексНастройки + "].НаименованиеРеквизитаЛид";
			УстановитьОформлениеПоля(ПолеРеквизитЛида, Элементы.ПолеЛида_0);
			ЗаполнитьСписокВыбора(ПолеРеквизитЛида, РеквизитыЛида);
			ПолеРеквизитЛида.УстановитьДействие("Очистка", "Подключаемый_ПолеЛидаОчистка");
			ПолеРеквизитЛида.УстановитьДействие("ПриИзменении", "Подключаемый_ПолеЛидаПриИзменении");
			ПолеРеквизитЛида.УстановитьДействие("ОбработкаВыбора", "Подключаемый_ПолеЛидаОбработкаВыбора");
			
			ДекорацияКартинка           = Элементы.Добавить("Картинка_" + ИндексНастройки, Тип("ДекорацияФормы"), ОбщаяГруппаДействия);
			ДекорацияКартинка.Вид       = Элементы.Картинка_0.Вид;
			ДекорацияКартинка.Заголовок = Элементы.Картинка_0.Заголовок;
			ДекорацияКартинка.Ширина    = Элементы.Картинка_0.Ширина;
			ДекорацияКартинка.Высота    = Элементы.Картинка_0.Высота;
			ДекорацияКартинка.Картинка  = Элементы.Картинка_0.Картинка;
			ДекорацияКартинка.РазмерКартинки = Элементы.Картинка_0.РазмерКартинки;

			ПолеРеквизитКонтрагента = Элементы.Добавить("ПолеПокупателя_" + ИндексНастройки, Тип("ПолеФормы"), ОбщаяГруппаДействия);
			ПолеРеквизитКонтрагента.ПутьКДанным = "Соответствия[" + ИндексНастройки + "].НаименованиеРеквизитаКонтрагент";
			УстановитьОформлениеПоля(ПолеРеквизитКонтрагента, Элементы.ПолеПокупателя_0);
			ЗаполнитьСписокВыбора(ПолеРеквизитКонтрагента, РеквизитыКонтрагента);
			ПолеРеквизитКонтрагента.УстановитьДействие("Очистка", "Подключаемый_ПолеПокупателяОчистка");
			ПолеРеквизитКонтрагента.УстановитьДействие("ПриИзменении", "Подключаемый_ПолеПокупателяПриИзменении");
			ПолеРеквизитКонтрагента.УстановитьДействие("ОбработкаВыбора", "Подключаемый_ПолеПокупателяОбработкаВыбора");
			
			Элементы.Переместить(Элементы.ДобавитьСоответствие, Элементы["ГруппаСоответствий"]);
			
		КонецЕсли;
	КонецЦикла;
	
	// Заполнить список выбора для первых элементов
	ЗаполнитьСписокВыбора(Элементы.ПолеЛида_0, РеквизитыЛида);
	ЗаполнитьСписокВыбора(Элементы.ПолеПокупателя_0, РеквизитыКонтрагента);

КонецПроцедуры

&НаСервере
Процедура УдалитьЭлементыСоответствий(Элементы)
	
	УдаляемыеЭлементы = Новый Массив;
	Для ИндексГруппы = 1 По Элементы.ГруппаСоответствий.ПодчиненныеЭлементы.Количество()-1 Цикл
		УдаляемыеЭлементы.Добавить(Элементы.ГруппаСоответствий.ПодчиненныеЭлементы[ИндексГруппы]);
	КонецЦикла;
	Для Каждого УдаляемыйЭлемент Из УдаляемыеЭлементы Цикл
		Элементы.Удалить(УдаляемыйЭлемент);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСоответствие(Команда)
	Соответствия.Добавить();
	ОбновитьЭлементыСоответствий();
КонецПроцедуры

&НаСервере
Функция ТипЗначенияРеквизита(ИмяРеквизита, ВсеРеквизиты)
	
	Если ИмяРеквизита = "Наименование" Тогда
		Возврат Новый ОписаниеТипов("Строка");
	КонецЕсли;
	
	Реквизит = ВсеРеквизиты.Найти(ИмяРеквизита);
	Возврат Реквизит.Тип;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция НаименованиеРеквизитаПоИмени(ИмяРеквизита, Таблица)
	
	Отбор = Новый Структура("Имя", ИмяРеквизита);
	Строки = Таблица.НайтиСтроки(Отбор);
	
	Если Строки.Количество() = 0 Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат Строки[0].Представление;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТипРеквизитаПоИмени(ИмяРеквизита, Таблица)
	
	Отбор = Новый Структура("Имя", ИмяРеквизита);
	Строки = Таблица.НайтиСтроки(Отбор);
	
	Если Строки.Количество() = 0 Тогда
		Возврат Новый ОписаниеТипов("Строка");
	КонецЕсли;
	
	Возврат Строки[0].ТипЗначения;
	
КонецФункции

&НаСервере
Процедура ДобавитьДополнительныеРеквизиты(Владелец, Таблица)
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПВХДополнительныеРеквизитыИСведения.Ссылка КАК Ссылка,
	|	ПВХДополнительныеРеквизитыИСведения.Имя КАК ИмяРеквизита,
	|	ПВХДополнительныеРеквизитыИСведения.ТипЗначения КАК Тип,
	|	ПВХДополнительныеРеквизитыИСведения.Наименование КАК Наименование
	|ИЗ
	|	Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеРеквизиты КАК ТабличнаяЧастьДопРеквизиты
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения КАК ПВХДополнительныеРеквизитыИСведения
	|		ПО (ПВХДополнительныеРеквизитыИСведения.Ссылка = ТабличнаяЧастьДопРеквизиты.Свойство)
	|ГДЕ
	|	ТабличнаяЧастьДопРеквизиты.Ссылка = &ВладелецРеквизита";
	
	Запрос.УстановитьПараметр("ВладелецРеквизита", Владелец);
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();

	Пока Выборка.Следующий() Цикл
		НовыйРеквизит = Таблица.Добавить();
		НовыйРеквизит.Имя           = Выборка.ИмяРеквизита;
		НовыйРеквизит.Представление = Выборка.Наименование;
		НовыйРеквизит.ТипЗначения   = Выборка.Тип;
		НовыйРеквизит.СсылкаНаДопРеквизит = Выборка.Ссылка;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	ЕстьОшибки = ЕстьОшибкиЗаполненияСоответствий();
	
	Если ЕстьОшибки Тогда
		Возврат;
	КонецЕсли;

	ЗаписатьСоответствия();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Функция ЕстьОшибкиЗаполненияСоответствий()
	
	ОшибкиЗаполнения = Ложь;
	
	Для Каждого Соответствие Из Соответствия Цикл
		
		Если (НЕ ЗначениеЗаполнено(Соответствие.ИмяРеквизитаЛид) И ЗначениеЗаполнено(Соответствие.ИмяРеквизитаКонтрагент))
			ИЛИ (ЗначениеЗаполнено(Соответствие.ИмяРеквизитаЛид) И НЕ ЗначениеЗаполнено(Соответствие.ИмяРеквизитаКонтрагент)) Тогда
			ОшибкиЗаполнения = Истина;
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не заполнены обязательные данные'"));
			Продолжить;
		КонецЕсли;
		
		ТипРеквизитаЛид         = ТипРеквизитаПоИмени(Соответствие.ИмяРеквизитаЛид, РеквизитыЛида);
		ТипРеквизитаКонтрагент  = ТипРеквизитаПоИмени(Соответствие.ИмяРеквизитаКонтрагент, РеквизитыКонтрагента);
		СписокТиповРеквизита    = ТипРеквизитаЛид.Типы();
		
		СписокСодержитТип = Ложь;
		Для Каждого ТипЛида Из СписокТиповРеквизита Цикл
			
			СписокСодержитТип = ТипРеквизитаЛид.СодержитТип(ТипЛида);
			Если СписокСодержитТип Тогда
				Продолжить;
			КонецЕсли;
			
		КонецЦикла;
		
		Если СписокСодержитТип Тогда
			Продолжить;
		КонецЕсли;
		
		ОшибкиЗаполнения = Истина;
		ОбщегоНазначенияКлиент.СообщитьПользователю(СтрШаблон(НСтр("ru = 'Не соответствуют типы реквизитов ""%1"" и ""%2"".'"),
			Соответствие.НаименованиеРеквизитаЛид, Соответствие.НаименованиеРеквизитаКонтрагент));
		
	КонецЦикла;
	
	Возврат ОшибкиЗаполнения;
	
КонецФункции

&НаСервере
Процедура ЗаписатьСоответствия()
	
	УдалитьОдинаковыеСоответствия();
	НаборЗаписей = РегистрыСведений.СоответствиеПолейЛидаИКонтрагента.СоздатьНаборЗаписей();
	
	Для Каждого Соответствие Из Соответствия Цикл
		
		Если Соответствие.Удалено Тогда
			Продолжить;
		КонецЕсли;

		Если НЕ ЗначениеЗаполнено(Соответствие.ИмяРеквизитаКонтрагент) 
			И НЕ ЗначениеЗаполнено(Соответствие.ИмяРеквизитаЛид) Тогда
			Продолжить;
		КонецЕсли;
			
		Запись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(Запись, Соответствие);
		Запись.СсылкаНаДопРеквизитКонтрагент = СсылкаНаДопРеквизит(Соответствие.ИмяРеквизитаКонтрагент, РеквизитыКонтрагента);
		Запись.СсылкаНаДопРеквизитЛид = СсылкаНаДопРеквизит(Соответствие.ИмяРеквизитаЛид, РеквизитыЛида);
	КонецЦикла;
	
	Если ПереноситьФайлы Тогда
		Запись = НаборЗаписей.Добавить();
		Запись.ИмяРеквизитаЛид = "ПрисоединенныеФайлы";
		Запись.ИмяРеквизитаКонтрагент = "ПрисоединенныеФайлы";
	КонецЕсли;

	НаборЗаписей.Записать();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСписокВыбора(Элемент, Таблица)
	
	Элемент.СписокВыбора.Очистить();
	
	Для Каждого Строка Из Таблица Цикл
		Элемент.СписокВыбора.Добавить(Строка.Имя, Строка.Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСписокВыбораПоТипуЗначения(ИмяЭлемента, Таблица, ТипЗначения)
	
	ИзменяемыйЭлемент = Элементы[ИмяЭлемента];
	ИзменяемыйЭлемент.СписокВыбора.Очистить();
	
	МассивТипов = ТипЗначения.Типы();
	
	Для Каждого Реквизит Из Таблица Цикл
		
		РеквизитСодержитТип = Ложь;
		
		Для Каждого ТипЗначенияРеквизита Из МассивТипов Цикл
			Если Реквизит.ТипЗначения.СодержитТип(ТипЗначенияРеквизита) Тогда
				РеквизитСодержитТип = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если НЕ РеквизитСодержитТип Тогда
			Продолжить;
		КонецЕсли;
		
		ИзменяемыйЭлемент.СписокВыбора.Добавить(Реквизит.Имя, Реквизит.Представление);
	КонецЦикла;
	
	Если ИзменяемыйЭлемент.СписокВыбора.Количество() = 0 Тогда
		ИзменяемыйЭлемент.СписокВыбора.Добавить("ПустаяСтрока", НСтр("ru = 'Нет реквизитов заданного типа'"));
		Возврат;
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИндексСоответствия(ЭлементИмя)
	
	Возврат Прав(ЭлементИмя, СтрДлина(ЭлементИмя) - СтрНайти(ЭлементИмя, "_"));
	
КонецФункции

&НаСервере
Функция СсылкаНаДопРеквизит(ИмяРеквизита, Таблица)
	
	Отбор = Новый Структура("Имя", ИмяРеквизита);
	Строки = Таблица.НайтиСтроки(Отбор);
	
	Если Строки.Количество() = 0 Тогда
		Возврат ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Строки[0].СсылкаНаДопРеквизит;

КонецФункции

&НаСервере
Процедура УдалитьОдинаковыеСоответствия()
		
	Для Каждого СтрокаСоответствия Из Соответствия Цикл
					
		ОтборПоУсловиям = Новый Структура;
		ОтборПоУсловиям.Вставить("Удалено", Ложь);
		ОтборПоУсловиям.Вставить("ИмяРеквизитаЛид",          СтрокаСоответствия.ИмяРеквизитаЛид);
		ОтборПоУсловиям.Вставить("ИмяРеквизитаКонтрагент",   СтрокаСоответствия.ИмяРеквизитаКонтрагент);
				
		ЕстьСоответствияСОдинаковымиУсловиями = Соответствия.НайтиСтроки(ОтборПоУсловиям).Количество() > 1;
		
		Если ЕстьСоответствияСОдинаковымиУсловиями Тогда
			СтрокаСоответствия.Удалено = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
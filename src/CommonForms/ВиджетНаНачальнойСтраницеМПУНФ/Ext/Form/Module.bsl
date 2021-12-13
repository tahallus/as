﻿
&НаКлиенте
Процедура Попробовать(Команда)
		Текст = НСтр("ru = 'В случае обратного перехода в мобильное приложение, данные, созданные в пробной версии, не сохранятся.
		|Продолжить?'");
	Результат = Неопределено;
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ПопробоватьЗавершение", ЭтотОбъект), Текст, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	

КонецПроцедуры

&НаКлиенте
Процедура ПопробоватьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ПопробоватьПриСогласииНаСервере();
		
		ПланПоиска = ГлобальныйПоиск.ПолучитьПлан();
		ПланПоиска.Добавить(СтандартныйВидГлобальногоПоиска.МенюФункций);
		ПланПоиска.Добавить(СтандартныйВидГлобальногоПоиска.Данные);
		ГлобальныйПоиск.УстановитьПлан(ПланПоиска);

		ОбновитьИнтерфейс();
		ОткрытьФорму("ОбщаяФорма.МобильныйКлиент");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПопробоватьПриСогласииНаСервере()
	ПереходВБольшойУНФИзМобильногоПриложения20МПУНФ.ВыполнитьПереход();
КонецПроцедуры

&НаКлиенте
Процедура Декорация37Нажатие(Элемент)
	
	Элементы.ЗаказовНаСумму.Видимость = Истина;
	Элементы.ПереходВПолнуюВерсию.Видимость = Ложь;
	//Элементы.ГруппаЛево.Видимость = Истина;
	Элементы.Декорация34.Видимость = Истина;
	Элементы.Лево.Видимость = Истина;
	Элементы.Декорация33.Видимость = Истина;
	Элементы.Право.Видимость = Истина;
	Элементы.Декорация37.Видимость = Ложь;
	Элементы.ДекорацияИндикатор.Видимость = Истина;
	Элементы.Попробовать.Видимость = Ложь;
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СформироватьТекстЗаголовка(Заголовок, Знач ИсходнаяСумма, РазделятьРазряды = Истина, ТекущаяСтраница)
	
	Если РазделятьРазряды И ИсходнаяСумма <> 0 Тогда
		ФорматированнаяСумма = Формат(ИсходнаяСумма, НСтр("ru = 'ЧДЦ=2; ЧРГ='' ''; ЧН=—; ЧГ=3,0'"));
		Разделитель = СтрДлина(ФорматированнаяСумма) - 3;
		СтрокаРазрядТысячи = Лев(ФорматированнаяСумма, Разделитель - 4);
		СтрокаРазрядЕдиницы = Сред(ФорматированнаяСумма, Разделитель - 3);
	Иначе
		ФорматированнаяСумма = Формат(ИсходнаяСумма, НСтр("ru = 'ЧДЦ=0; ЧРГ='' ''; ЧН=—; ЧГ=3,0'"));
	КонецЕсли;
	
	ЭлементыСтроки = Новый Массив;
	Обработки.УдалитьМониторыРуководителя.ДобавитьЭлементФорматированнойСтроки(ЭлементыСтроки, Заголовок, , WebЦвета.Серый); 
	ЭлементыСтроки.Добавить(Новый Структура("Строка", Символы.ПС));
	
	Если РазделятьРазряды И ИсходнаяСумма <> 0 Тогда
		Шрифт = Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста, , , Истина, , , , 300);
		Обработки.УдалитьМониторыРуководителя.ДобавитьЭлементФорматированнойСтроки(
			ЭлементыСтроки, СтрокаРазрядТысячи, Шрифт, WebЦвета.Золотой);
		Шрифт = Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста, , , , , , , 250);
		Обработки.УдалитьМониторыРуководителя.ДобавитьЭлементФорматированнойСтроки(
			ЭлементыСтроки, СтрокаРазрядЕдиницы, Шрифт, WebЦвета.Золотой);
	ИначеЕсли ИсходнаяСумма = 0 Тогда
		Шрифт = Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста, , , , , , , 200);
		Обработки.УдалитьМониторыРуководителя.ДобавитьЭлементФорматированнойСтроки(
			ЭлементыСтроки, НСтр("ru = 'нет данных'"), Шрифт, WebЦвета.Золотой);
	Иначе
		Шрифт = Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста, , , Истина, , , , 300);
		Обработки.УдалитьМониторыРуководителя.ДобавитьЭлементФорматированнойСтроки(
			ЭлементыСтроки, Строка(ИсходнаяСумма), Шрифт, WebЦвета.Золотой);
	КонецЕсли;
	
	Возврат Обработки.УдалитьМониторыРуководителя.СкомпоноватьФорматированнуюСтроку(ЭлементыСтроки);
	
КонецФункции

&НаКлиенте
Функция ПолучитьИндикаторТекущейСтраницы(ТекущаяСтраница)
	
	Индикатор = "○○○○○";
	
	Если ТекущаяСтраница = 1 Тогда
		Индикатор = "●○○○○○";
	ИначеЕсли ТекущаяСтраница = 2 Тогда
		Индикатор = "○●○○○○";
	ИначеЕсли ТекущаяСтраница = 3 Тогда
		Индикатор = "○○●○○○";
	ИначеЕсли ТекущаяСтраница = 4 Тогда
		Индикатор = "○○○●○○";
	ИначеЕсли ТекущаяСтраница = 5 Тогда
		Индикатор = "○○○○●○";
	ИначеЕсли ТекущаяСтраница = 6 Тогда
		Индикатор = "○○○○○●";
	КонецЕсли;
	
	Возврат Индикатор;
	
КонецФункции

&НаСервере
Процедура ПолучитьНазваниеОрганизации()
	
	МояФирма = Константы.НазваниеОрганизацииМП.Получить();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьКоличествоЗаказовВРаботеНаСервере()
	
	Элементы.ЗаказовВРаботе.Заголовок = СформироватьТекстЗаголовка(
		НСтр("ru='заказов в работе';en='Orders In Progress'"),
		Документы.ЗаказМП.ПолучитьКоличествоЗаказовВСостоянии(Перечисления.СостоянияЗаказовМП.ВРаботе),
		Ложь,
		2
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьКоличествоЗаказовВРаботе()
	
	ПолучитьКоличествоЗаказовВРаботеНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСуммуЗаказовВРаботеНаСервере()
	
	Элементы.ЗаказовНаСумму.Заголовок = СформироватьТекстЗаголовка(
		НСтр("ru='сумма заказов в работе';en='Amount Of Orders'"),
		Документы.ЗаказМП.ПолучитьСуммуЗаказовВСостоянии(Перечисления.СостоянияЗаказовМП.ВРаботе),
		Истина,
		1
	);
	
КонецПроцедуры

Функция ПолучитьКоличествоЗаказовВСостоянииВРаботе() Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(Заказ.Ссылка) КАК КоличествоЗаказов
	|ИЗ
	|	Документ.ЗаказПокупателя КАК Заказ
	|ГДЕ
	|	НЕ Заказ.ПометкаУдаления
	|	И Заказ.Проведен
	|	И Заказ.СостояниеЗаказа <> ЗНАЧЕНИЕ(Справочник.СостоянияЗаказовПокупателей.Завершен)";
	
	ВыборкаЗаказов = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаЗаказов.Следующий() Тогда
		Возврат ВыборкаЗаказов.КоличествоЗаказов;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьСуммуЗаказовВСостоянииВРаботе() Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(Заказ.СуммаДокумента), 0) КАК СуммаЗаказов
	|ИЗ
	|	Документ.ЗаказПокупателя КАК Заказ
	|ГДЕ
	|	НЕ Заказ.ПометкаУдаления
	|	И Заказ.Проведен
	|	И Заказ.СостояниеЗаказа <> ЗНАЧЕНИЕ(Справочник.СостоянияЗаказовПокупателей.Завершен)";
	
	ВыборкаЗаказов = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаЗаказов.Следующий() Тогда
		Возврат ВыборкаЗаказов.СуммаЗаказов;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПолучитьСуммуЗаказовВРаботе()
	
	ПолучитьСуммуЗаказовВРаботеНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСуммуОстаткаТоваровВЦенахПоставщиковНаСервере()
	
	Элементы.ТоваровНаСумму.Заголовок = СформироватьТекстЗаголовка(
		НСтр("ru='остаток товаров на сумму';en='Goods In The Amount'"),
		РегистрыНакопления.ОстаткиТоваровМП.ПолучитьСуммуОстаткаТоваровВЦенахПоставщиков(),
		Истина,
		4
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСуммуОстаткаТоваровВЦенахПоставщиков()
	
	ПолучитьСуммуОстаткаТоваровВЦенахПоставщиковНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСуммуОстаткаНашихДолговНаСервере()
	
	Элементы.МыДолжны.Заголовок = СформироватьТекстЗаголовка(
		НСтр("ru='мы должны';en='Our Duty'"),
		РегистрыНакопления.ВзаиморасчетыСКонтрагентамиМП.ПолучитьОстатокНашихДолгов(),
		Истина,
		5
	);

	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСуммуОстаткаНашихДолгов()
	
	ПолучитьСуммуОстаткаНашихДолговНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСуммуОстаткаДолговНамНаСервере()
	
	Элементы.ДолгиНам.Заголовок = СформироватьТекстЗаголовка(
		НСтр("ru='долги нам';en='Debt Us'"),
		РегистрыНакопления.ВзаиморасчетыСКонтрагентамиМП.ПолучитьОстатокДолговНам(),
		Истина,
		4
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСуммуОстаткаДолговНам()
	
	ПолучитьСуммуОстаткаДолговНамНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСуммуПродажЗаСмену()
	
	ПолучитьСуммуПродажЗаСменуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСуммуПродажЗаСменуНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	Элементы.ПродажЗаСмену.Заголовок = СформироватьТекстЗаголовка(
		НСтр("ru='продаж за смену';en='Retail Sales'"),
		РозничныеПродажиМПСервер.ПолучитьСуммуПродажЗаТекущуюСмену(),
		Истина,
		6
	);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПолучитьНазваниеОрганизации();
	
	НужноОбновитьИнтерфейс = Ложь;
	
	//Если Константы.ЭтоМобильноеПриложение.Получить() Тогда
	//	Запрос = Новый Запрос();
	//	Запрос.Текст =
	//	"ВЫБРАТЬ ПЕРВЫЕ 1
	//	|	СборкаЗапасов.Ссылка
	//	|ИЗ
	//	|	Документ.СборкаЗапасов КАК СборкаЗапасов";
	//	Выборка = Запрос.Выполнить().Выбрать();
	//	ПодсистемаПроизводствоВключена = Константы.ФункциональнаяОпцияИспользоватьПодсистемуПроизводствоМоб.Получить();
	//	Если Выборка.Следующий() Тогда
	//		Если НЕ ПодсистемаПроизводствоВключена Тогда
	//			Константы.ФункциональнаяОпцияИспользоватьПодсистемуПроизводствоМоб.Установить(Истина);
	//			НужноОбновитьИнтерфейс = Истина;
	//		КонецЕсли;
	//	Иначе
	//		Если ПодсистемаПроизводствоВключена Тогда
	//			Константы.ФункциональнаяОпцияИспользоватьПодсистемуПроизводствоМоб.Установить(Ложь);
	//			НужноОбновитьИнтерфейс = Истина;
	//		КонецЕсли;
	//	КонецЕсли;
	//КонецЕсли;
	
	//ФункциональнаяОпцияИспользоватьПодсистемуПроизводствоМоб = Константы.ФункциональнаяОпцияИспользоватьПодсистемуПроизводствоМоб.Получить();
	//Элементы.Группа12.Видимость = ФункциональнаяОпцияИспользоватьПодсистемуПроизводствоМоб;
	//Элементы.Группа11.Видимость = ФункциональнаяОпцияИспользоватьПодсистемуПроизводствоМоб;
	//Элементы.Группа17.Видимость = ФункциональнаяОпцияИспользоватьПодсистемуПроизводствоМоб;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменилисьНастройки" Тогда
		ПолучитьНазваниеОрганизации();
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменилсяЗаказ" Тогда
		ПодключитьОбработчикОжидания("ПолучитьСуммуЗаказовВРаботе", 0.1, Истина);
		ПодключитьОбработчикОжидания("ПолучитьКоличествоЗаказовВРаботе", 0.2, Истина);
		ПодключитьОбработчикОжидания("ПолучитьСуммуОстаткаТоваровВЦенахПоставщиков", 0.3, Истина);
		ПодключитьОбработчикОжидания("ПолучитьСуммуОстаткаДолговНам", 0.4, Истина);
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменилосьКоличествоТовара" Тогда
		ПодключитьОбработчикОжидания("ПолучитьСуммуОстаткаТоваровВЦенахПоставщиков", 0.3, Истина);
		ПодключитьОбработчикОжидания("ПолучитьСуммуПродажЗаСмену", 0.6, Истина);
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменилосьКоличествоТовара"
		ИЛИ ИмяСобытия = "ИзменилосьКоличествоДенег" Тогда
		ПодключитьОбработчикОжидания("ПолучитьСуммуОстаткаДолговНам", 0.4, Истина);
		ПодключитьОбработчикОжидания("ПолучитьСуммуОстаткаНашихДолгов", 0.5, Истина);
		ПодключитьОбработчикОжидания("ПолучитьСуммуПродажЗаСмену", 0.6, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ПолучитьСуммуЗаказовВРаботе", 0.1, Истина);
	ПодключитьОбработчикОжидания("ПолучитьКоличествоЗаказовВРаботе", 0.2, Истина);
	ПодключитьОбработчикОжидания("ПолучитьСуммуОстаткаТоваровВЦенахПоставщиков", 0.3, Истина);
	ПодключитьОбработчикОжидания("ПолучитьСуммуОстаткаДолговНам", 0.4, Истина);
	ПодключитьОбработчикОжидания("ПолучитьСуммуОстаткаНашихДолгов", 0.5, Истина);
	ПодключитьОбработчикОжидания("ПолучитьСуммуПродажЗаСмену", 0.6, Истина);
	
	Если НужноОбновитьИнтерфейс Тогда
		ОбновитьИнтерфейс();
	КонецЕсли;
	
	Элементы.ЗаказовНаСумму.Видимость = Ложь;
	Элементы.ПереходВПолнуюВерсию.Видимость = Истина;
	//Элементы.ГруппаЛево.Видимость = Ложь;
	Элементы.Декорация34.Видимость = Ложь;
	Элементы.Лево.Видимость = Ложь;
	Элементы.Декорация33.Видимость = Ложь;
	Элементы.Право.Видимость = Ложь;
	Элементы.Декорация37.Видимость = Истина;
	Элементы.ДекорацияИндикатор.Видимость = Ложь;
	Элементы.Попробовать.Видимость = Истина;
	
	ПланПоиска = ГлобальныйПоиск.ПолучитьПлан();
	ПланПоиска.Удалить(СтандартныйВидГлобальногоПоиска.МенюФункций);
	ПланПоиска.Удалить(СтандартныйВидГлобальногоПоиска.Данные);
	ГлобальныйПоиск.УстановитьПлан(ПланПоиска);

	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура Настройки(Команда)
	
	ОткрытьФорму("ОбщаяФорма.НастройкиПриложенияМП");
	
КонецПроцедуры

&НаКлиенте
Процедура СледующийВиджет(Направление)
	
	ТекущийВиджет = ПолучитьИндексТекущегоВиджета();
	
	Если ТекущийВиджет + Направление > 6 Тогда
		ПоказатьВиджет(1);
	ИначеЕсли ТекущийВиджет + Направление < 1 Тогда
		ПоказатьВиджет(6);
	Иначе
		ПоказатьВиджет(ТекущийВиджет + Направление);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьИндексТекущегоВиджета()
	
	ТекущийВиджет = 0;
	
	Если Элементы.ЗаказовНаСумму.Видимость Тогда
		ТекущийВиджет = 1;
	ИначеЕсли Элементы.ЗаказовВРаботе.Видимость Тогда
		ТекущийВиджет = 2;
	ИначеЕсли Элементы.ТоваровНаСумму.Видимость Тогда
		ТекущийВиджет = 3;
	ИначеЕсли Элементы.ДолгиНам.Видимость Тогда
		ТекущийВиджет = 4;
	ИначеЕсли Элементы.МыДолжны.Видимость Тогда
		ТекущийВиджет = 5;
	ИначеЕсли Элементы.ПродажЗаСмену.Видимость Тогда
		ТекущийВиджет = 6;
	КонецЕсли;
	
	Возврат ТекущийВиджет;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьВиджет(НомерВиджета)
	
	Элементы.ЗаказовНаСумму.Видимость = Ложь;
	Элементы.ЗаказовВРаботе.Видимость = Ложь;
	Элементы.ТоваровНаСумму.Видимость = Ложь;
	Элементы.ДолгиНам.Видимость = Ложь;
	Элементы.МыДолжны.Видимость = Ложь;
	Элементы.ПродажЗаСмену.Видимость = Ложь;
	
	Если НомерВиджета = 1 Тогда
		Элементы.ЗаказовНаСумму.Видимость = Истина;
	ИначеЕсли НомерВиджета = 2 Тогда
		Элементы.ЗаказовВРаботе.Видимость = Истина;
	ИначеЕсли НомерВиджета = 3 Тогда
		Элементы.ТоваровНаСумму.Видимость = Истина;
	ИначеЕсли НомерВиджета = 4 Тогда
		Элементы.ДолгиНам.Видимость = Истина;
	ИначеЕсли НомерВиджета = 5 Тогда
		Элементы.МыДолжны.Видимость = Истина;
	ИначеЕсли НомерВиджета = 6 Тогда
		Элементы.ПродажЗаСмену.Видимость = Истина;
	КонецЕсли;
	
	Элементы.ДекорацияИндикатор.Заголовок = ПолучитьИндикаторТекущейСтраницы(НомерВиджета);
	
КонецПроцедуры

&НаКлиенте
Процедура Лево(Команда)
	
	СледующийВиджет(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура Право(Команда)
	
	СледующийВиджет(1);
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация1Нажатие(Элемент)
	
	ОткрытьФорму("Документ.ЗаказМП.ФормаОбъекта");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация3Нажатие(Элемент)
	
	ОткрытьФорму("Документ.РасходТовараМП.ФормаОбъекта");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация5Нажатие(Элемент)
	
	ОткрытьФорму("Документ.ПриходДенегМП.ФормаОбъекта");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация7Нажатие(Элемент)
	
	ОткрытьФорму("Документ.РасходДенегМП.ФормаОбъекта");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация11Нажатие(Элемент)
	
	ОткрытьФорму("Документ.ЗаказМП.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация15Нажатие(Элемент)
	
	ОткрытьФорму("ЖурналДокументов.РозничныеПродажиМП.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация17Нажатие(Элемент)
	
	ОткрытьФорму("ЖурналДокументов.ДвиженияТоваровМП.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация13Нажатие(Элемент)
	
	ОткрытьФорму("ЖурналДокументов.ДвиженияДенегМП.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация19Нажатие(Элемент)
	
	ОткрытьФорму("Справочник.ТоварыМП.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация21Нажатие(Элемент)
	
	ОткрытьФорму("Справочник.КонтрагентыМП.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация39Нажатие(Элемент)
	
	ОткрытьФорму("Обработка.ДвиженияДенегМП.Форма");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация33Нажатие(Элемент)
	
	ПодключитьОбработчикОжидания("ПолучитьСуммуЗаказовВРаботе", 0.1, Истина);
	ПодключитьОбработчикОжидания("ПолучитьКоличествоЗаказовВРаботе", 0.2, Истина);
	ПодключитьОбработчикОжидания("ПолучитьСуммуОстаткаТоваровВЦенахПоставщиков", 0.3, Истина);
	ПодключитьОбработчикОжидания("ПолучитьСуммуОстаткаДолговНам", 0.4, Истина);
	ПодключитьОбработчикОжидания("ПолучитьСуммуОстаткаНашихДолгов", 0.5, Истина);
	ПодключитьОбработчикОжидания("ПолучитьСуммуПродажЗаСмену", 0.6, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация9Нажатие(Элемент)
	
	ОткрытьФорму("Документ.ПроизводствоМП.ФормаОбъекта");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация23Нажатие(Элемент)
	
	ОткрытьФорму("ЖурналДокументов.ПроизводствоМП.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация43Нажатие(Элемент)
	
	ОткрытьФорму("Обработка.ОстаткиТоваровНаСкладахМП.Форма");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация45Нажатие(Элемент)
	ОткрытьФорму("Обработка.ПродажиМП.Форма");
КонецПроцедуры

&НаКлиенте
Процедура Декорация47Нажатие(Элемент)
	ОткрытьФорму("Обработка.ВыпускПродукцииМП.Форма");
КонецПроцедуры

&НаКлиенте
Процедура Декорация27Нажатие(Элемент)
	ОткрытьФорму("ОбщаяФорма.КорзинаПомеченныеНаУдалениеМП");
КонецПроцедуры

&НаКлиенте
Процедура Декорация41Нажатие(Элемент)
	
	ОткрытьФорму("Обработка.ДолгиМП.Форма");

КонецПроцедуры

&НаКлиенте
Процедура Декорация25Нажатие(Элемент)
	ОткрытьФорму("Документ.ЧекККММП.Форма.ФормаПродажа");

КонецПроцедуры

#КонецОбласти

﻿////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы библиотеки интеграции с МОТП.
// 
/////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Получение сведений о библиотеке (или конфигурации).

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПриДобавленииПодсистемы
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя    = "БиблиотекаИнтеграцииИСМП";
	Описание.Версия = ИнтеграцияИС.ВерсияПодсистемы("10");
	Описание.РежимВыполненияОтложенныхОбработчиков = "Параллельно";
	
	Описание.ТребуемыеПодсистемы.Добавить("СтандартныеПодсистемы");
	Описание.ТребуемыеПодсистемы.Добавить("БиблиотекаПодключаемогоОборудования");
	Описание.ТребуемыеПодсистемы.Добавить("БиблиотекаЭлектронныхДокументов");
	
КонецПроцедуры

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

#Область Монопольно
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.0.0";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыИСМП.НачальноеЗаполнениеТабак";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.РежимВыполнения = "Монопольно";
	Обработчик.Комментарий = НСтр("ru = 'Заполнение настроек интеграции МОТП.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.0.0";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыИСМП.НачальноеЗаполнениеОбувь";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.РежимВыполнения = "Монопольно";
	Обработчик.Комментарий = НСтр("ru = 'Заполнение настроек интеграции ИС МП (обувь).'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "10.1.2.102";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыИСМП.НачальноеЗаполнениеГИСМП";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.РежимВыполнения = "Монопольно";
	Обработчик.Комментарий = НСтр("ru = 'Заполнение настроек интеграции ГИС МП.'");

#КонецОбласти

#Область Оперативно

#КонецОбласти

#Область Отложенно

	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.0.0";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Процедура = "РегистрыСведений.СтатусыПроверкиИПодбораДокументовИСМП.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("587fe1ca-d648-4b3a-b1cb-7f3d0243da67");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.СтатусыПроверкиИПодбораДокументовИСМП.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ОчередьОтложеннойОбработки = 1;
	Обработчик.ПроцедураПроверки = "";
	Обработчик.ЧитаемыеОбъекты = "РегистрСведений.СтатусыПроверкиИПодбораДокументовИСМП";
	Обработчик.ИзменяемыеОбъекты = "РегистрСведений.СтатусыПроверкиИПодбораДокументовИСМП";
	Обработчик.БлокируемыеОбъекты = "";
	Обработчик.Комментарий = НСтр("ru = 'Заполняет новое измерение регистра ""Вид маркируемой продукции"" ссылками на перечисление ""ВидыПродукцииИС.Табак"".'");
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "10.1.1.3";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Процедура = "Справочники.ШтрихкодыУпаковокТоваров.ОбработатьДанныеДляПереходаНаНовуюВерсиюЗаполнениеХешСуммаЗначенияШтрихкодаGS1";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("b0ecb2a5-bc53-43c4-a2ab-9b3e5e1d60f7");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.ШтрихкодыУпаковокТоваров.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсиюЗаполнениеХешСуммаЗначенияШтрихкодаGS1";
	Обработчик.ОчередьОтложеннойОбработки = 2;
	Обработчик.ПроцедураПроверки = "";
	Обработчик.ЧитаемыеОбъекты = "Справочник.ШтрихкодыУпаковокТоваров";
	Обработчик.ИзменяемыеОбъекты = "Справочник.ШтрихкодыУпаковокТоваров";
	Обработчик.БлокируемыеОбъекты = "";
	Обработчик.Комментарий = НСтр("ru = 'Заполнение реквизита ХэшСуммаНормализации'");
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();
	ОбновлениеИнформационнойБазыГосИС.ДополнитьПриоритетВыполненияОбработчикаОбновленияСправочникаШтрихкодыУпаковокТоваров(Обработчик.ПриоритетыВыполнения);
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "10.1.2.100";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Процедура = "РегистрыСведений.НастройкиУчетаМаркируемойПродукцииИСМП.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("dd0e16c9-5efa-475f-9150-b07e587bc1f8");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.НастройкиУчетаМаркируемойПродукцииИСМП.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ОчередьОтложеннойОбработки = 1;
	Обработчик.ЧитаемыеОбъекты = "РегистрСведений.НастройкиУчетаМаркируемойПродукцииИСМП";
	Обработчик.ИзменяемыеОбъекты = "РегистрСведений.НастройкиУчетаМаркируемойПродукцииИСМП";
	Обработчик.БлокируемыеОбъекты = "";
	Обработчик.Комментарий = НСтр("ru = 'Заполнение даты начала обязательной маркировки товаров'");
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "10.1.2.100";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Процедура = "РегистрыСведений.ПулКодовМаркировкиСУЗ.ОбработатьДанныеДляПереходаНаНовуюВерсиюНормализацияБезМРЦ";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("b05c6849-90a6-41df-9980-8d0a8b61788a");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.ПулКодовМаркировкиСУЗ.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсиюНормализацияБезМРЦ";
	Обработчик.ОчередьОтложеннойОбработки = 1;
	Обработчик.ЧитаемыеОбъекты = "РегистрСведений.ПулКодовМаркировкиСУЗ";
	Обработчик.ИзменяемыеОбъекты = "РегистрСведений.ПулКодовМаркировкиСУЗ";
	Обработчик.Комментарий = НСтр("ru = 'Обработка кодов маркировки табачной продукции (нормализация без МРЦ)'");
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "10.1.4.3";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Процедура = "Обработки.ПанельАдминистрированияИСМП.ОбработатьДанныеДляПереходаНаНовуюВерсиюРаздельныйКонтрольСтатусовВладельцевКМ";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("d14beed3-f977-4795-b485-d816169f3cdb");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Обработки.ПанельАдминистрированияИСМП.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсиюРаздельныйКонтрольСтатусовВладельцевКМ";
	Обработчик.ОчередьОтложеннойОбработки = 1;
	Обработчик.ЧитаемыеОбъекты = "Константа.ЗапрашиватьДанныеСервисаИСМП,Константа.УдалитьКонтролироватьСтатусыКодовМаркировкиВРозницеИСМП, Константа.НастройкиСканированияКодовМаркировкиИСМП";
	Обработчик.ИзменяемыеОбъекты = "Константа.ЗапрашиватьДанныеСервисаИСМП, Константа.НастройкиСканированияКодовМаркировкиИСМП";
	Обработчик.Комментарий = НСтр("ru = 'Переход на настройки раздельного контроля статусов и владельцев кодов маркировки'");
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();
	
#КонецОбласти

КонецПроцедуры

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПередОбновлениемИнформационнойБазы
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
	ВерсияКонфигурации = ОбновлениеИнформационнойБазы.ВерсияИБ(Метаданные.Имя);
	Если ВерсияКонфигурации <> "0.0.0.0" Тогда
		
		ИдентификаторБиблиотекаИнтеграцииИСМП = "БиблиотекаИнтеграцииИСМП";
		ВерсияБиблиотекаИнтеграцииИСМП = ОбновлениеИнформационнойБазы.ВерсияИБ(ИдентификаторБиблиотекаИнтеграцииИСМП);
		Если ВерсияБиблиотекаИнтеграцииИСМП = "0.0.0.0" Тогда
			
			ОбновлениеИнформационнойБазы.УстановитьВерсиюИБ("БиблиотекаИнтеграцииИСМП", "1.0.0.0", Ложь);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПослеОбновленияИнформационнойБазы
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
КонецПроцедуры

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПриПодготовкеМакетаОписанияОбновлений.
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	

КонецПроцедуры

// Позволяет переопределить режим обновления данных информационной базы.
// Для использования в редких (нештатных) случаях перехода, не предусмотренных в
// стандартной процедуре определения режима обновления.
//
// Параметры:
//   РежимОбновленияДанных - Строка - в обработчике можно присвоить одно из значений:
//              "НачальноеЗаполнение"     - если это первый запуск пустой базы (области данных);
//              "ОбновлениеВерсии"        - если выполняется первый запуск после обновление конфигурации базы данных;
//              "ПереходСДругойПрограммы" - если выполняется первый запуск после обновление конфигурации базы данных, 
//                                          в которой изменилось имя основной конфигурации.
//
//   СтандартнаяОбработка  - Булево - если присвоить Ложь, то стандартная процедура
//                                    определения режима обновления не выполняется, 
//                                    а используется значение РежимОбновленияДанных.
//
Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт
 
КонецПроцедуры

// Добавляет в список процедуры-обработчики перехода с другой программы (с другим именем конфигурации).
// Например, для перехода между разными, но родственными конфигурациями: базовая -> проф -> корп.
// Вызывается перед началом обновления данных ИБ.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - с колонками:
//    * ПредыдущееИмяКонфигурации - Строка - имя конфигурации, с которой выполняется переход;
//                                           или "*", если нужно выполнять при переходе с любой конфигурации.
//    * Процедура                 - Строка - полное имя процедуры-обработчика перехода с программы ПредыдущееИмяКонфигурации. 
//                                  Например, "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику"
//                                  Обязательно должна быть экспортной.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.ПредыдущееИмяКонфигурации  = "УправлениеТорговлей";
//  Обработчик.Процедура                  = "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику";
//
Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
 
КонецПроцедуры

// Вызывается после выполнения всех процедур-обработчиков перехода с другой программы (с другим именем конфигурации),
// и до начала выполнения обновления данных ИБ.
//
// Параметры:
//  ПредыдущееИмяКонфигурации    - Строка - имя конфигурации до перехода.
//  ПредыдущаяВерсияКонфигурации - Строка - имя предыдущей конфигурации (до перехода).
//  Параметры                    - Структура - 
//    * ВыполнитьОбновлениеСВерсии   - Булево - по умолчанию Истина. Если установить Ложь, 
//        то будут выполнена только обязательные обработчики обновления (с версией "*").
//    * ВерсияКонфигурации           - Строка - номер версии после перехода. 
//        По умолчанию, равен значению версии конфигурации в свойствах метаданных.
//        Для того чтобы выполнить, например, все обработчики обновления с версии ПредыдущаяВерсияКонфигурации, 
//        следует установить значение параметра в ПредыдущаяВерсияКонфигурации.
//        Для того чтобы выполнить вообще все обработчики обновления, установить значение "0.0.0.1".
//    * ОчиститьСведенияОПредыдущейКонфигурации - Булево - по умолчанию Истина. 
//        Для случаев когда предыдущая конфигурация совпадает по имени с подсистемой текущей конфигурации, следует
//        указать Ложь.
//
Процедура ПриЗавершенииПереходаСДругойПрограммы(Знач ПредыдущееИмяКонфигурации, Знач ПредыдущаяВерсияКонфигурации, Параметры) Экспорт
 
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиОбновления

Процедура НачальноеЗаполнениеТабак() Экспорт
	
	Если Константы.УдалитьДатаОбязательнойМаркировкиТабачнойПродукцииМОТП.Получить() = '00010101' Тогда
		Константы.УдалитьДатаОбязательнойМаркировкиТабачнойПродукцииМОТП.Установить('20190301');
	КонецЕсли;
	
КонецПроцедуры

Процедура НачальноеЗаполнениеОбувь() Экспорт
	
	Если Константы.УдалитьДатаОбязательнойМаркировкиОбувиИСМП.Получить() = '00010101' Тогда
		Константы.УдалитьДатаОбязательнойМаркировкиОбувиИСМП.Установить('20200301');
	КонецЕсли;
	
КонецПроцедуры

Процедура НачальноеЗаполнениеГИСМП() Экспорт
	
	ВидыПродукцииИСМП = ИнтеграцияИСКлиентСервер.ВидыПродукцииИСМП(Истина);
	Для Каждого ВидПродукции Из ВидыПродукцииИСМП Цикл
		
		НаборЗаписей = РегистрыСведений.НастройкиУчетаМаркируемойПродукцииИСМП.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ВидПродукции.Установить(ВидПродукции);
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() = 0 Тогда
			ЗаполнитьНастройкуУчетаВидаПродукции(НаборЗаписей.Добавить(), ВидПродукции);
			НаборЗаписей.Записать(Истина);
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не Константы.ВестиУчетМаркируемойПродукцииИСМП.Получить()
		И Константы.УдалитьВестиУчетТабачнойПродукцииМОТП.Получить() Тогда
		Константы.ВестиУчетМаркируемойПродукцииИСМП.Установить(Истина);
	КонецЕсли;
	
	Если Не Константы.ЗапрашиватьДанныеСервисаИСМП.Получить()
		И Константы.УдалитьКонтролироватьСтатусыКодовМаркировкиМОТП.Получить() Тогда
		Константы.ЗапрашиватьДанныеСервисаИСМП.Установить(Истина);
	КонецЕсли;
	
	Если Не Константы.УдалитьКонтролироватьСтатусыКодовМаркировкиВРозницеИСМП.Получить()
		И Константы.УдалитьКонтролироватьСтатусыКодовМаркировкиВРозницеМОТП.Получить() Тогда
		Константы.УдалитьКонтролироватьСтатусыКодовМаркировкиВРозницеИСМП.Установить(Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

Процедура ЗаполнитьНастройкуУчетаВидаПродукции(НастройкаУчета, ВидМаркируемойПродукции)
	
	НастройкаУчета.ВидПродукции = ВидМаркируемойПродукции;
	
	ДатаНачалаУчета = РегистрыСведений.НастройкиУчетаМаркируемойПродукцииИСМП.ДатаНачалаУчетаМаркируемойПродукции(
		ВидМаркируемойПродукции);
		
	Если ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.Табак Тогда
		
		НастройкаУчета.ВестиУчетПродукции = Константы.УдалитьВестиУчетТабачнойПродукцииМОТП.Получить();
		НастройкаУчета.ДатаОбязательнойМаркировки = Константы.УдалитьДатаОбязательнойМаркировкиТабачнойПродукцииМОТП.Получить();
		Если НастройкаУчета.ДатаОбязательнойМаркировки = '00010101' Тогда
			НастройкаУчета.ДатаОбязательнойМаркировки = ДатаНачалаУчета;
		КонецЕсли;
		
	ИначеЕсли ВидМаркируемойПродукции = Перечисления.ВидыПродукцииИС.Обувь Тогда
		
		НастройкаУчета.ВестиУчетПродукции = Константы.ВестиУчетМаркируемойПродукцииИСМП.Получить();
		НастройкаУчета.ДатаОбязательнойМаркировки = Константы.УдалитьДатаОбязательнойМаркировкиОбувиИСМП.Получить();
		Если НастройкаУчета.ДатаОбязательнойМаркировки = '00010101' Тогда
			НастройкаУчета.ДатаОбязательнойМаркировки = ДатаНачалаУчета;
		КонецЕсли;
		
	Иначе
		
		НастройкаУчета.ДатаОбязательнойМаркировки = ДатаНачалаУчета;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

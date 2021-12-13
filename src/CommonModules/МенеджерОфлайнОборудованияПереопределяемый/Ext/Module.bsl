﻿
#Область ПрограммныйИнтерфейс

 // Возвращает список доступных типов оборудования.
//
// Возвращаемое значение:
//   Массив - Массив доступных типов офлайн подключаемого оборудования в конфигурации
//
Функция ПолучитьДоступныеТипыОфлайнОборудования() Экспорт
	
	СписокОборудования = Новый Массив;
	
	СписокОборудования.Добавить(Перечисления.ТипыОфлайнОборудования.ККМ);
	СписокОборудования.Добавить(Перечисления.ТипыОфлайнОборудования.ПрайсЧекер);
	
	Возврат СписокОборудования;
	
КонецФункции

#Область ВыгрузкаДанныхНаОфлайнОборудование

// Событие вызываемое при выгрузке настроек на оборудование. Тип офлайн оборудования: ККМ
// Вызывается при файловом или Web-сервис обмене (метод EquipmentService.GetSettings)
//
// Параметры:
//   ОфлайнОборудование - СправочникСсылка.ПодключаемоеОборудование - ссылка на экземпляр оборудования.
//   НастройкиОборудования - Структура - структура, которую необходимо заполнить настройками для выгрузки на ККМ.
//
// Вспомогательные методы для заполнения НастройкиОборудования:
//    Модуль - МенеджерОфлайнОборудования:
//             ПолучитьЗаписьВидЭлектроннойОплаты()
//             ТипЭлектроннойОплатыПлатежнаяКарта()
//             ТипЭлектроннойОплатыБанковскийКредит()
//             ТипЭлектроннойОплатыПодарочныйСертификат()
//             ТипЭлектроннойОплатыБонусы()
//
Процедура ПриВыгрузкеНастроек(ОфлайнОборудование, НастройкиОборудования) Экспорт
	
	ПодключаемоеОборудованиеOfflineВызовСервера.ЗаполнитьНастройкиККМ(ОфлайнОборудование, НастройкиОборудования);
	
КонецПроцедуры

// Событие вызываемое при выгрузке прайс-листа на оборудование. Тип офлайн оборудования: ККМ, Прайс-чекер
// Вызывается при файловом или Web-сервис обмене (метод EquipmentService.GetPriceList или EquipmentService.PreparePriceList)
//
// Параметры:
//   ОфлайнОборудование - СправочникСсылка.ПодключаемоеОборудование - ссылка на экземпляр оборудования.
//   ПрайсЛист - Структура - структура, которую необходимо заполнить данными прайс-листа для выгрузки на офлайн оборудование.
//   ПолнаяВыгрузка - Булево - если ПолнаяВыгрузка = Истина,
//      то предполагается полная очистка прайс-листа на офлайн оборудовании перед загрузкой (сервисная команда "Выгрузить полный прайс-лист")
//      При ПолнаяВыгрузка = Истина рекомендуется выгружать полный список товаров по правилу обмена,
//      при ПолнаяВыгрузка = Ложь рекомендуется выгружать список товаров зарегистрированных к обмену (измененных).
//
Процедура ПриВыгрузкеПрайсЛиста(ОфлайнОборудование, ПрайсЛист, ПолнаяВыгрузка) Экспорт
	
	ПодключаемоеОборудованиеOfflineВызовСервера.ЗаполнитьПрайсЛистККМ(ОфлайнОборудование, ПрайсЛист, ПолнаяВыгрузка);
	
КонецПроцедуры

// Событие вызываемое при выгрузке прайс-листа на оборудование с отбором по штрихкоду. Тип офлайн оборудования: Прайс-чекер
// Вызывается при Web-сервис обмене (метод EquipmentService.GetGood)
//
// Параметры:
//   ОфлайнОборудование - СправочникСсылка.ПодключаемоеОборудование - ссылка на экземпляр оборудования.
//   ПрайсЛист - Структура - структура, которую необходимо заполнить данными прайс-листа для выгрузки на офлайн оборудование.
//   Штрихкод - Строка - значение штрихкода для отбора.
//
Процедура ПриВыгрузкеТовараПоШтрихкоду(ОфлайнОборудование, ПрайсЛист, Штрихкод) Экспорт
	
	ПодключаемоеОборудованиеOfflineВызовСервера.ЗаполнитьПрайсЛистККМПоШтрихкоду(ОфлайнОборудование, ПрайсЛист, Штрихкод);
	
КонецПроцедуры

// Событие вызываемое при выгрузке заказов на оборудование. Тип офлайн оборудования: ККМ
// Вызывается при файловом или Web-сервис обмене (метод EquipmentService.GetDocs, DocType = "Order")
//
// Параметры:
//   ОфлайнОборудование - СправочникСсылка.ПодключаемоеОборудование - ссылка на экземпляр оборудования.
//   Заказы - Структура - структура, которую необходимо заполнить данными заказов для выгрузки на офлайн оборудование.
//
Процедура ПриВыгрузкеЗаказов(ОфлайнОборудование, Заказы) Экспорт
	
	ПодключаемоеОборудованиеOfflineВызовСервера.ЗаполнитьЗаказыККМ(ОфлайнОборудование, Заказы);
	
КонецПроцедуры

// Событие вызываемое после успешной выгрузки данных на оборудование. Тип офлайн оборудования: ККМ, Прайс-чекер
// Вызывается при файловом или Web-сервис обмене 
//    (методы EquipmentService: GetSettings; GetPriceList; GetPriceListPackage; GetDocs, DocType = "Order")
//
// Параметры:
//   ОфлайнОборудование - СправочникСсылка.ПодключаемоеОборудование - ссылка на экземпляр оборудования.
//   НаборВыгруженныхДанных - Структура - структура, в которой описаны типы наборов выгруженных данных "Настройки", "ПрайсЛист", "Заказы";
//   в зависимости от набора необходимо снимать данные с регистрации в узлах обмена.
//
Процедура ПослеУспешнойВыгрузкиДанных(ОфлайнОборудование, НаборВыгруженныхДанных) Экспорт
	
	Если НаборВыгруженныхДанных.ПрайсЛист Тогда
		
		// снять с регистрации товары
		ПодключаемоеОборудованиеOfflineВызовСервера.УдалитьРегистрациюПрайсЛистаПослеВыгрузки(ОфлайнОборудование);
		
	КонецЕсли;
	
	Если НаборВыгруженныхДанных.Заказы Тогда
		
		// снять с регистрации заказы
		ПодключаемоеОборудованиеOfflineВызовСервера.УдалитьРегистрациюЗаказовПослеВыгрузки(ОфлайнОборудование);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузкаДанныхИзОфлайнОборудования

// Событие вызываемое при загрузке данных о продажах из оборудования. Тип офлайн оборудования: ККМ
// Вызывается при файловом или Web-сервис обмене (метод EquipmentService.PostDocs, DocType = "SalesReport")
//
// Параметры:
//   ОфлайнОборудование - Справочник.ПодключаемоеОборудование - ссылка на экземпляр оборудования.
//   ДанныеОПродажах - Структура - полученные данные из офлайн оборудования для загрузки в прикладную конфигурацию
//   Отказ - Булево - признак возникновения ошибки при загрузке в прикладной конфигурации,
//                    если Отказ не установлен Истина, то загружаемый пакет данных помечается как обработанный.
//   СообщениеОбОшибке - Строка - сообщение выводимое пользователю если Отказ = Истина
//
Процедура ПриЗагрузкеДанныхОПродажахИзККМ(ОфлайнОборудование, ДанныеОПродажах, Отказ, СообщениеОбОшибке) Экспорт
	
	ПодключаемоеОборудованиеOfflineВызовСервера.ЗагрузитьОтчетыОПродажахИзККМ(ОфлайнОборудование, ДанныеОПродажах, Отказ, СообщениеОбОшибке);
	
КонецПроцедуры

// Событие вызываемое при загрузке данных о вкрытиях алкогольной тары из оборудования. Тип офлайн оборудования: ККМ
// Вызывается при файловом или Web-сервис обмене (метод EquipmentService.PostDocs, DocType = "AlcoholTareOpenings")
//
// Параметры:
//   ОфлайнОборудование - СправочникСсылка.ПодключаемоеОборудование - ссылка на экземпляр оборудования.
//   ДанныеОВскрытияхТары - Структура - полученные данные из офлайн оборудования для загрузки в прикладную конфигурацию
//   Отказ - Булево - признак возникновения ошибки при загрузке в прикладной конфигурации,
//                    если Отказ не установлен Истина, то загружаемый пакет данных помечается как обработанный.
//   СообщениеОбОшибке - Строка - сообщение выводимое пользователю если Отказ = Истина
//
Процедура ПриЗагрузкеДанныхОВскрытияхАлкогольнойТарыИзККМ(ОфлайнОборудование, ДанныеОВскрытияхТары, Отказ, СообщениеОбОшибке) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Событие вызываемое при загрузке данных о проверках ценников из оборудования. Тип офлайн оборудования: Прайс-чекер
// Вызывается при Web-сервис обмене (метод EquipmentService.PostDocs, DocType = "PriceCheckerReport")
//
// Параметры:
//   ОфлайнОборудование - СправочникСсылка.ПодключаемоеОборудование - ссылка на экземпляр оборудования.
//   ДанныеОПроверкахЦенников - Структура - полученные данные из офлайн оборудования для загрузки в прикладную конфигурацию
//   Отказ - Булево - признак возникновения ошибки при загрузке в прикладной конфигурации,
//                    если Отказ не установлен Истина, то загружаемый пакет данных помечается как обработанный.
//   СообщениеОбОшибке - Строка - сообщение выводимое пользователю если Отказ = Истина
//
Процедура ПриЗагрузкеДанныхОПроверкахЦенников(ОфлайнОборудование, ДанныеОПроверкахЦенников, Отказ, СообщениеОбОшибке) Экспорт
	
	ВыполненоУспешно = Ложь;
	
	ПодключаемоеОборудованиеOfflineВызовСервера.ЗагрузитьЦенники(ОфлайнОборудование, ДанныеОПроверкахЦенников, ВыполненоУспешно);
	
	Если ВыполненоУспешно = Ложь Тогда
		Отказ = Истина;
		СообщениеОбОшибке = НСтр("ru = 'Ошибка загрузки. Принимающая сторона не смогла обработать принятый отчет.'");
	КонецЕсли;
	
	МассивСозданныхДокументов = Новый Массив;
	
	Для каждого Документ Из ДанныеОПроверкахЦенников Цикл
		
		Товары = Новый ТаблицаЗначений;
		Товары.Колонки.Добавить("Номенклатура");
		Товары.Колонки.Добавить("Характеристика");
		Товары.Колонки.Добавить("Упаковка");
		Товары.Колонки.Добавить("Штрихкод");
		Товары.Колонки.Добавить("КоличествоЦенников");
		
		ДанныеОТоваре = Новый Структура;
		
		Для каждого Строка Из Документ.Товары Цикл
			
			ПодключаемоеОборудованиеOfflineВызовСервера.ПолучитьДанныеОТоваре(Строка, ДанныеОТоваре);
			СтрокаТовар = Товары.Добавить();
			СтрокаТовар.Номенклатура =       ДанныеОТоваре.Номенклатура;
			СтрокаТовар.Характеристика =     ДанныеОТоваре.Характеристика;
			СтрокаТовар.Упаковка =           ДанныеОТоваре.Упаковка;
			СтрокаТовар.Штрихкод =           Строка.Штрихкод;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ПереопределяемыеПроцедурыФорм

// Переопределяемая процедура, вызываемая при создании формы обработки ОбменСОфлайнОборудованием.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма обработки
//
Процедура ФормаОбменСОфлайнОборудованиемПриСозданииНаСервере(Форма) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая при создании формы настройки офлайн оборудования.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма обработки
//   ОфлайнОборудование - СправочникСсылка.ПодключаемоеОборудование - ссылка на экземпляр оборудования.
//
Процедура ФормаНастройкиОфлайнОборудованияПриСозданииНаСервере(Форма, ОфлайнОборудование) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая при создании формы настройки офлайн оборудования.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма обработки
//   ОфлайнОборудование - СправочникСсылка.ПодключаемоеОборудование - ссылка на экземпляр оборудования.
//
Процедура ФормаНастройкиПроизвольногоПериодаЭвоторПриСозданииНаСервере(Форма) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
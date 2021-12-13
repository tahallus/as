﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - Структура - настройки плана обмена по умолчанию, см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию,
//                          описание возвращаемого значения функции.
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	Настройки.ИмяКонфигурацииИсточника = "УправлениеНебольшойФирмой";
	Настройки.ПланОбменаИспользуетсяВМоделиСервиса = Ложь;
	Настройки.ПредупреждатьОНесоответствииВерсийПравилОбмена = Ложь;
	
	Настройки.Алгоритмы.ПриПолученииВариантовНастроекОбмена = Истина;
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	
КонецПроцедуры

// Заполняет коллекцию вариантов настроек, предусмотренных для плана обмена.
// 
// Параметры:
//  ВариантыНастроекОбмена - ТаблицаЗначений - коллекция вариантов настроек обмена, см. описание возвращаемого значения
//                                       функции НастройкиПланаОбменаПоУмолчанию общего модуля ОбменДаннымиСервер.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияВариантовНастроек,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииВариантовНастроекОбмена(ВариантыНастроекОбмена, ПараметрыКонтекста) Экспорт
	
	ВариантНастройки = ВариантыНастроекОбмена.Добавить();
	ВариантНастройки.ИдентификаторНастройки        = "";
	ВариантНастройки.КорреспондентВМоделиСервиса   = Истина;
	ВариантНастройки.КорреспондентВЛокальномРежиме = Истина;
	
КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                       см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                       описание возвращаемого значения.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт

	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника = "Настройки обмена для УНФ-БП";
	ОписаниеВарианта.ИспользоватьПомощникСозданияОбменаДанными = Истина;
	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена = ИспользуемыеТранспортыСообщенийОбмена();
	ОписаниеВарианта.КраткаяИнформацияПоОбмену = КраткаяИнформацияПоОбмену(ИдентификаторНастройки);
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену = ПодробнаяИнформацияПоОбмену(ИдентификаторНастройки);
	ОписаниеВарианта.ПояснениеДляНастройкиПараметровУчета = ПояснениеДляНастройкиПараметровУчета(ИдентификаторНастройки);
	ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = НСтр("ru = '1C: Бухгалтерия предприятия 8, ред. 2.0'");
	
	ОписаниеВарианта.ОбщиеДанныеУзлов = ОбщиеДанныеУзлов();
	ОписаниеВарианта.ПутьКФайлуКомплектаПравилВКаталогеШаблонов = "\1c\smallbusiness\";
	
	ОписаниеВарианта.ИмяКонфигурацииКорреспондента = "БухгалтерияПредприятия";

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Дополнение к функционалу БСП

// Возвращает режим запуска, в случае интерактивного инициирования синхронизации
// Возвращаемые значения АвтоматическаяСинхронизация Или ИнтерактивнаяСинхронизация
// На основании этих значений запускается либо помощник интерактивного обмена, либо автообмен
Функция РежимЗапускаСинхронизацииДанных(УзелИнформационнойБазы) Экспорт
	
	Если УзелИнформационнойБазы.РучнойОбмен Тогда
		
		Возврат "ИнтерактивнаяСинхронизация";
		
	Иначе
		
		Возврат "АвтоматическаяСинхронизация";
		
	КонецЕсли;
	
КонецФункции

// Возвращает сценарий работы помощника интерактивного сопоставления
// НеОтправлять, ИнтерактивнаяСинхронизацияДокументов, ИнтерактивнаяСинхронизацияСправочников либо пустую строку
Функция ИнициализироватьСценарийРаботыПомощникаИнтерактивногоОбмена(УзелИнформационнойБазы) Экспорт
	
	Если УзелИнформационнойБазы.РучнойОбмен Тогда
		
		Возврат "ИнтерактивнаяСинхронизацияДокументов";
		
	КонецЕсли;
	
КонецФункции

// Возвращает значения ограничений объектов узла плана обмена для интерактивной регистрации к обмену
// Структура: ВсеДокументы, ВсеСправочники, ДетальныйОтбор
// Детальный отбор либо неопределено, либо массив объектов метаданных входящих в состав узла (Указывается полное имя метаданных)
Функция ДобавитьГруппыОграничений(УзелИнформационнойБазы) Экспорт
	// Пример типового возврата
	Возврат Новый Структура("ВсеДокументы, ВсеСправочники, ДетальныйОтбор", Ложь, Ложь, Неопределено);
КонецФункции

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

// Возвращает массив используемых транспортов сообщений для этого плана обмена
//
// 1. Например, если план обмена поддерживает только два транспорта сообщений FILE и FTP,
// то тело функции следует определить следующим образом:
//
//	Результат = Новый Массив;
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
//	Возврат Результат;
//
// 2. Например, если план обмена поддерживает все транспорты сообщений, определенных в конфигурации,
// то тело функции следует определить следующим образом:
//
//	Возврат ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
//
// Возвращаемое значение:
//  Массив - массив содержит значения перечисления ВидыТранспортаСообщенийОбмена
//
Функция ИспользуемыеТранспортыСообщенийОбмена()
	
	Результат = Новый Массив;
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
	Возврат Результат;
	
КонецФункции

Функция ОбщиеДанныеУзлов()
	
	Возврат "";
	
КонецФункции

Функция ПояснениеДляНастройкиПараметровУчета(ИдентификаторНастройки)
	
	Возврат "";
	
КонецФункции

// Возвращает краткую информацию по обмену, выводимую при настройке синхронизации данных.
//
Функция КраткаяИнформацияПоОбмену(ИдентификаторНастройки)
	
	ПоясняющийТекст = НСтр("ru = '	Позволяет синхронизировать данные между приложениями 1С:Управление нашей фирмой, ред. 1.6 и 1С:Бухгалтерия предприятия 8, ред. 2.0.
	|Из приложения Управление нашей фирмой в приложение Бухгалтерия предприятия переносятся справочники и все необходимые документы, а 
	|из приложения Бухгалтерия предприятия в приложение Управление нашей фирмой - справочники и документы учета денежных средств. Для 
	|получения более подробной информации нажмите на ссылку Подробное описание.'");
	
	Возврат ПоясняющийТекст;
	
КонецФункции // КраткаяИнформацияПоОбмену()

// Возвращаемое значение: Строка - Ссылка на подробную информацию по настраиваемой синхронизации,
//   в виде гиперссылки или полного пути к форме
Функция ПодробнаяИнформацияПоОбмену(ИдентификаторНастройки)
	
	Возврат "ПланОбмена.ОбменУправлениеНебольшойФирмойБухгалтерия20.Форма.ФормаПодробнойИнформацииПоОбмену";
	
КонецФункции

// Возвращает сокращенное строковое представление коллекции значений.
// 
// Параметры:
//  Коллекция 						- массив или список значений.
//  МаксимальноеКоличествоЭлементов - число, максимальное количество элементов включаемое в представление.
//
// Возвращаемое значение:
//  Строка.
//
Функция СокращенноеПредставлениеКоллекцииЗначений(Коллекция, МаксимальноеКоличествоЭлементов = 3) Экспорт
	
	СтрокаПредставления = "";
	
	КоличествоЗначений			 = Коллекция.Количество();
	КоличествоВыводимыхЭлементов = Мин(КоличествоЗначений, МаксимальноеКоличествоЭлементов);
	
	Если КоличествоВыводимыхЭлементов = 0 Тогда
		
		Возврат "";
		
	Иначе
		
		Для НомерЗначения = 1 По КоличествоВыводимыхЭлементов Цикл
			
			СтрокаПредставления = СтрокаПредставления + Коллекция.Получить(НомерЗначения - 1) + ", ";	
			
		КонецЦикла;
		
		СтрокаПредставления = Лев(СтрокаПредставления, СтрДлина(СтрокаПредставления) - 2);
		Если КоличествоЗначений > КоличествоВыводимыхЭлементов Тогда
			СтрокаПредставления = СтрокаПредставления + ", ... ";
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтрокаПредставления;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииУНФ

// Инициализирует у всех узлов режим выгрузки при необходимости
//
Процедура ИнициализироватьРежимВыгрузкиПриНеобходимости() Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	БП.Ссылка
	                      |ИЗ
	                      |	ПланОбмена.ОбменУправлениеНебольшойФирмойБухгалтерия20 КАК БП
	                      |ГДЕ
	                      |	БП.Ссылка <> &ЭтотУзел
	                      |	И ВЫБОР
	                      |			КОГДА БП.РежимВыгрузкиПриНеобходимости <> ЗНАЧЕНИЕ(Перечисление.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости)
	                      |				ТОГДА ИСТИНА
	                      |			ИНАЧЕ ЛОЖЬ
	                      |		КОНЕЦ = ИСТИНА");
						  
	Запрос.УстановитьПараметр("ЭтотУзел", ПланыОбмена.ОбменУправлениеНебольшойФирмойБухгалтерия20.ЭтотУзел());
	
	ВыборкаУзлов = Запрос.Выполнить().Выбрать();
	Пока ВыборкаУзлов.Следующий() Цикл
		
		УзелПланаОбменаОбъект = ВыборкаУзлов.Ссылка.ПолучитьОбъект();
		УзелПланаОбменаОбъект.РежимВыгрузкиПриНеобходимости = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
		УзелПланаОбменаОбъект.ДополнительныеСвойства.Вставить("Загрузка");
		УзелПланаОбменаОбъект.Записать();
		
		РегистрыСведений.ИзмененияОбщихДанныхУзлов.ЗарегистрироватьИзменения(УзелПланаОбменаОбъект.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

// Определяет массив узлов на которых будет произведена регистрация объекта
//
Функция ОпределитьМассивПолучателей(Выгрузка, Объект, Получатели) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Выгрузка Тогда
		Возврат Получатели;
	КонецЕсли;
	
	Если Объект.ДополнительныеСвойства.Свойство("УзлыДляРегистрации")
		И ТипЗнч(Объект.ДополнительныеСвойства.УзлыДляРегистрации) = Тип("Массив") Тогда
		
		Получатели = Объект.ДополнительныеСвойства.УзлыДляРегистрации;
		
		Возврат Получатели;
	КонецЕсли;
	
	МассивИсключаемыхУзлов = Новый Массив;
	
	Для Каждого Узел Из Получатели Цикл
		
		Если Узел.РучнойОбмен Тогда
			
			МассивИсключаемыхУзлов.Добавить(Узел);
			
		ИначеЕсли Узел.ИспользоватьОтборПоВидамДокументов Тогда
			
			Если Узел.ВидыДокументов.Найти(Объект.Метаданные().Имя, "ИмяОбъектаМетаданных") = Неопределено Тогда
				МассивИсключаемыхУзлов.Добавить(Узел);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Получатели = ОбщегоНазначенияКлиентСервер.РазностьМассивов(Получатели, МассивИсключаемыхУзлов);
	
	Возврат Получатели;
	
КонецФункции

// Регистрирует документы, связанные с переданным документом по ссылке.
//
Процедура ЗарегистрироватьСвязанныеДокументы(Выгрузка, Объект, ПРО, Получатели) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Выгрузка
		ИЛИ Объект = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивЗарегистрированныхДокументов = Неопределено;
	Объект.ДополнительныеСвойства.Свойство("ЗарегистрированныеДокументы", МассивЗарегистрированныхДокументов);
	Если ТипЗнч(МассивЗарегистрированныхДокументов) <> Тип("Массив") Тогда
		МассивЗарегистрированныхДокументов = Новый Массив;
	КонецЕсли;
	
	Если МассивЗарегистрированныхДокументов.Найти(Объект.Ссылка) = Неопределено Тогда
		МассивЗарегистрированныхДокументов.Добавить(Объект.Ссылка);
	КонецЕсли;
	
	МассивУзловДляРегистрации = Новый Массив;
	Для каждого УзелПолучатель Из Получатели Цикл
		Если УзелПолучатель.ИспользоватьОтборПоВидамДокументов
			ИЛИ УзелПолучатель.РучнойОбмен Тогда
			МассивУзловДляРегистрации.Добавить(УзелПолучатель);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивУзловДляРегистрации.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СвязанныеДокументы = Новый ТаблицаЗначений;
	СвязанныеДокументы.Колонки.Добавить("Документ");
	
	Если ТипЗнч(Объект) = Тип("ДокументОбъект.АвансовыйОтчет") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.ВыданныеАвансы Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Оплаты Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.АктВыполненныхРабот") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Предоплата Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ДополнительныеРасходы") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Запасы Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.ДокументПоступления;
		КонецЦикла;
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Предоплата Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ЗаказПокупателя")
		И Объект.ВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаряд Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Предоплата Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ОтчетКомиссионера") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Покупатели Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.СчетФактура;
		КонецЦикла;
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Предоплата Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ОтчетКомитенту") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Предоплата Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ОтчетОПереработке") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Предоплата Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ОтчетПереработчика") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Предоплата Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ПоступлениеВКассу") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.РасшифровкаПлатежа Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ПоступлениеНаСчет") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.РасшифровкаПлатежа Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ПриходнаяНакладная") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Предоплата Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.РасходИзКассы") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.РасшифровкаПлатежа Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.РасходнаяНакладная") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Предоплата Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.РасходСоСчета") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.РасшифровкаПлатежа Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.Документ;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.СчетФактура") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.ДокументыОснования Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.ДокументОснование;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.СчетФактураПолученный") Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Объект.ДокументыОснования Цикл
			НоваяСтрока = СвязанныеДокументы.Добавить();
			НоваяСтрока.Документ = СтрокаТабличнойЧасти.ДокументОснование;
		КонецЦикла;
		
	КонецЕсли;
	
	СвязанныеДокументы.Свернуть("Документ");
	Если СвязанныеДокументы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого СтрокаТаблицы Из СвязанныеДокументы Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.Документ) Тогда
			Продолжить;
		КонецЕсли;
		
		ДокументОбъект = СтрокаТаблицы.Документ.ПолучитьОбъект();
		Если ДокументОбъект = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если МассивЗарегистрированныхДокументов.Найти(ДокументОбъект.Ссылка) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		РегистацияДоступна = Истина;
		МетаДокумент = ДокументОбъект.Метаданные();
		Для каждого УзелДляРегистрации Из МассивУзловДляРегистрации Цикл
			Если УзелДляРегистрации.Метаданные().Состав.Найти(МетаДокумент) = Неопределено Тогда
				РегистацияДоступна = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Не РегистацияДоступна Тогда
			Продолжить;
		КонецЕсли;
		
		ДокументОбъект.ДополнительныеСвойства.Вставить("УзлыДляРегистрации", МассивУзловДляРегистрации);
		ДокументОбъект.ДополнительныеСвойства.Вставить("ЗарегистрированныеДокументы", МассивЗарегистрированныхДокументов);
		ОбменДаннымиСобытия.ВыполнитьПравилаРегистрацииДляОбъекта(ДокументОбъект, ПРО.ИмяПланаОбмена, Неопределено);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
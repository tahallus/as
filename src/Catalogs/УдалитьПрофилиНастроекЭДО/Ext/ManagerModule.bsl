﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция формирует краткое наименование оператора из полного.
//
// Параметры:
//  Наименование - Строка - полное наименование оператора.
//
// Возвращаемое значение:
//  Строка - краткое наименование оператора.
Функция КраткоеНаименованиеОператора(Наименование) Экспорт
	
	КраткоеНаименование = СтрЗаменить(Наименование, "«", "");
	КраткоеНаименование = СтрЗаменить(КраткоеНаименование, "»", "");
	
	Если СтрНайти(КраткоеНаименование, "ЗАО ") Тогда
		КраткоеНаименование = СтрЗаменить(КраткоеНаименование, "ЗАО ", "");
	ИначеЕсли СтрНайти(КраткоеНаименование, "ООО ") Тогда
		КраткоеНаименование = СтрЗаменить(КраткоеНаименование, "ООО ", "");
	ИначеЕсли СтрНайти(КраткоеНаименование, "ПАО ") Тогда
		КраткоеНаименование = СтрЗаменить(КраткоеНаименование, "ПАО ", "");
	ИначеЕсли СтрНайти(КраткоеНаименование, "АО ") Тогда
		КраткоеНаименование = СтрЗаменить(КраткоеНаименование, "АО ", "");
	ИначеЕсли СтрНайти(КраткоеНаименование, "ОАО ") Тогда
		КраткоеНаименование = СтрЗаменить(КраткоеНаименование, "ОАО ", "");
	КонецЕсли;
	
	Возврат КраткоеНаименование;
	
КонецФункции

// Обработчик обновления на БЭД 1.3.6.7
// Заполняет реквизиты табличных частей справочников "Профили настроек ЭДО"
// и "Соглашение об использовании ЭДО".
//
Процедура ЗаполнитьРегламентЭДО() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УдалитьПрофилиНастроекЭДО.Ссылка КАК Профиль,
	|	УдалитьПрофилиНастроекЭДО.ИспользоватьУПД,
	|	УдалитьПрофилиНастроекЭДО.ИспользоватьУКД
	|ИЗ
	|	Справочник.УдалитьПрофилиНастроекЭДО КАК УдалитьПрофилиНастроекЭДО";
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Профиль = Выборка.Профиль;
		ПрофильОбъект = Профиль.ПолучитьОбъект();
		ИсходящиеДокументы = ПрофильОбъект.ИсходящиеДокументы;
		Для Каждого ТекСтрока Из ИсходящиеДокументы Цикл
			
			ТекСтрока.ТребуетсяИзвещениеОПолучении = Истина;
			
			Если ТекСтрока.ИсходящийДокумент = Перечисления.ТипыДокументовЭДО.СчетФактура Тогда
				
				Если Выборка.ИспользоватьУПД Тогда
					ТекСтрока.ТребуетсяОтветнаяПодпись = Истина;
					
				Иначе
					ТекСтрока.ТребуетсяОтветнаяПодпись = Ложь;
				КонецЕсли;
			ИначеЕсли ТекСтрока.ИсходящийДокумент = Перечисления.ТипыДокументовЭДО.КорректировочныйСчетФактура Тогда
				Если Выборка.ИспользоватьУКД Тогда
					ТекСтрока.ТребуетсяОтветнаяПодпись = Истина;
					
				Иначе
					ТекСтрока.ТребуетсяОтветнаяПодпись = Ложь;
				КонецЕсли;
				
			ИначеЕсли ТекСтрока.ИсходящийДокумент = Перечисления.ТипыДокументовЭДО.СчетНаОплату Тогда
				
				ТекСтрока.ТребуетсяОтветнаяПодпись = Ложь;
				
			Иначе
				ТекСтрока.ТребуетсяОтветнаяПодпись = ТекСтрока.ИспользоватьЭП;
				
			КонецЕсли;
		КонецЦикла;
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ПрофильОбъект);
		
		ПрофильОбъект.ИзменитьДанныеВСвязанныхНастройкахЭДО(ПрофильОбъект, Ложь);
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УдалитьСоглашенияОбИспользованииЭД.Ссылка КАК Настройка
	|ИЗ
	|	Справочник.УдалитьСоглашенияОбИспользованииЭД КАК УдалитьСоглашенияОбИспользованииЭД
	|ГДЕ
	|	УдалитьСоглашенияОбИспользованииЭД.РасширенныйРежимНастройкиСоглашения = ИСТИНА";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Соглашение = Выборка.Настройка;
		СоглашениеОбъект = Соглашение.ПолучитьОбъект();
		Для Каждого ТекСтрока Из СоглашениеОбъект.ИсходящиеДокументы Цикл
			
			ВидЭД = ТекСтрока.ИсходящийДокумент;
			ПрофильЭДО = ТекСтрока.ПрофильНастроекЭДО;
			
			СвойстваЭД = Новый Структура("ТребуетсяИзвещение, ТребуетсяОтветнаяПодпись, ИспользоватьЭП");
			ЗаполнитьСвойстваЭДИзПрофиля(ПрофильЭДО, ВидЭД, СвойстваЭД);
			
			ЗаполнитьЗначенияСвойств(ТекСтрока, СвойстваЭД);
			
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СоглашениеОбъект);
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БЭД 1.3.6.25
Процедура СнятьФлагОтветнойПодписиУСчетаНаОплату() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПрофилиНастроекЭДОИсходящиеДокументы.Ссылка КАК ПрофильЭДО
	|ИЗ
	|	Справочник.УдалитьПрофилиНастроекЭДО.ИсходящиеДокументы КАК ПрофилиНастроекЭДОИсходящиеДокументы
	|ГДЕ
	|	ПрофилиНастроекЭДОИсходящиеДокументы.ИсходящийДокумент = ЗНАЧЕНИЕ(Перечисление.ТипыДокументовЭДО.СчетНаОплату)
	|	И ПрофилиНастроекЭДОИсходящиеДокументы.ТребуетсяОтветнаяПодпись = ИСТИНА";
	
	Результат = Запрос.Выполнить();
	
	ИсходящийДокументСчетНаОплату = Перечисления.ТипыДокументовЭДО.СчетНаОплату;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ПрофильОбъект = Выборка.ПрофильЭДО.ПолучитьОбъект();
		ИсходящиеДокументыПрофиля = ПрофильОбъект.ИсходящиеДокументы;
		
		СтрокаСчетНаОплату = ИсходящиеДокументыПрофиля.Найти(ИсходящийДокументСчетНаОплату, "ИсходящийДокумент");
		СтрокаСчетНаОплату.ТребуетсяОтветнаяПодпись = Ложь;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ПрофильОбъект);
		
		ПрофильОбъект.ИзменитьДанныеВСвязанныхНастройкахЭДО(ПрофильОбъект, Ложь);
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка КАК НастройкаЭДО
	|ИЗ
	|	Справочник.УдалитьСоглашенияОбИспользованииЭД.ИсходящиеДокументы КАК СоглашенияОбИспользованииЭДИсходящиеДокументы
	|ГДЕ
	|	СоглашенияОбИспользованииЭДИсходящиеДокументы.ИсходящийДокумент = ЗНАЧЕНИЕ(Перечисление.ТипыДокументовЭДО.СчетНаОплату)
	|	И СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.РасширенныйРежимНастройкиСоглашения = ИСТИНА";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НастройкаЭДООбъект = Выборка.НастройкаЭДО.ПолучитьОбъект();
		ИсходящиеДокументыНастройки = НастройкаЭДООбъект.ИсходящиеДокументы;
		
		СтрокаСчетНаОплатуНастройки = ИсходящиеДокументыНастройки.Найти(ИсходящийДокументСчетНаОплату, "ИсходящийДокумент");
		СтрокаСчетНаОплатуНастройки.ТребуетсяОтветнаяПодпись = Ложь;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(НастройкаЭДООбъект);
		
	КонецЦикла;
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// Возвращает профили настроек организации для отправки Запроса коммерческих предложений исходящего через ЭДО.
//
// Параметры:
//  Организация - ОпределяемыйТип.Организация - Организация, от имени которой планируется отправка документа.
//
// Возвращаемое значение:
//  Массив - Перечень профилей, с помощью которых возможно формирование, подписания и отправка Запроса
//           коммерческих предложений поставщиков. Элементы массива имеют тип СправочникСсылка.ПрофилиНастроекЭДО.
//
Функция ПрофилиДляОтправкиЗапросаКоммерческихПредложенийЧерезЭДО(Знач Организация) Экспорт
	
	Если Не ПравоДоступа("Чтение", Метаданные.Справочники.УдалитьПрофилиНастроекЭДО) Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УдалитьПрофилиНастроекЭДО.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ПрофилиОрганизации
	|ИЗ
	|	Справочник.УдалитьПрофилиНастроекЭДО КАК УдалитьПрофилиНастроекЭДО
	|ГДЕ
	|	НЕ УдалитьПрофилиНастроекЭДО.ПометкаУдаления
	|	И УдалитьПрофилиНастроекЭДО.СпособОбменаЭД = ЗНАЧЕНИЕ(Перечисление.СпособыОбменаЭД.ЧерезСервис1СЭДО)
	|	И УдалитьПрофилиНастроекЭДО.Организация = &Организация
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	УдалитьПрофилиНастроекЭДО.Ссылка
	|ИЗ
	|	Справочник.УдалитьПрофилиНастроекЭДО КАК УдалитьПрофилиНастроекЭДО
	|ГДЕ
	|	НЕ УдалитьПрофилиНастроекЭДО.ПометкаУдаления
	|	И УдалитьПрофилиНастроекЭДО.СпособОбменаЭД = ЗНАЧЕНИЕ(Перечисление.СпособыОбменаЭД.ЧерезОператораЭДОТакском)
	|	И УдалитьПрофилиНастроекЭДО.Организация = &Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПрофилиОрганизации.Ссылка КАК Ссылка
	|ИЗ
	|	ПрофилиОрганизации КАК ПрофилиОрганизации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УдалитьПрофилиНастроекЭДО.ИсходящиеДокументы КАК ПрофилиНастроекЭДОИсходящиеДокументы
	|		ПО ПрофилиОрганизации.Ссылка = ПрофилиНастроекЭДОИсходящиеДокументы.Ссылка
	|			И (ПрофилиНастроекЭДОИсходящиеДокументы.ИсходящийДокумент = ЗНАЧЕНИЕ(Перечисление.ВидыЭД.ЗапросКоммерческихПредложений))
	|			И (ПрофилиНастроекЭДОИсходящиеДокументы.Формировать = ИСТИНА)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УдалитьПрофилиНастроекЭДО.СертификатыПодписейОрганизации КАК ПрофилиНастроекЭДОСертификатыПодписейОрганизации
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПодписываемыеВидыЭД КАК ПодписываемыеВидыЭД
	|			ПО (ПодписываемыеВидыЭД.СертификатЭП = ПрофилиНастроекЭДОСертификатыПодписейОрганизации.Сертификат)
	|				И (ПодписываемыеВидыЭД.ВидЭД = ЗНАЧЕНИЕ(Перечисление.ВидыЭД.ЗапросКоммерческихПредложений))
	|				И (ПодписываемыеВидыЭД.Использовать = ИСТИНА)
	|		ПО ПрофилиОрганизации.Ссылка = ПрофилиНастроекЭДОСертификатыПодписейОрганизации.Ссылка";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ОбновлениеВерсииИБ

// Регистрирует данные для обработчика обновления
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МассивСсылок = Новый Массив;
	
	ПустойМаршрут    = Справочники.МаршрутыПодписания.ПустаяСсылка();
	СоответствиеИспользуемыхТипов = ИнтеграцияЭДО.ИспользуемыеТипыДокументов();
	ИспользуемыеТипы = Новый Массив;
	Для Каждого ИспользуемыйТип Из СоответствиеИспользуемыхТипов Цикл
		ИспользуемыеТипы.Добавить(ИспользуемыйТип.Ключ);
	КонецЦикла;
	ПрикладныеТипы   = ИнтеграцияЭДО.ПрикладныеТипыЭлектронныхДокументов();
	
	ИспользуемыеВидыВНастройках = Новый Массив;
	ПрикладныеВидыВНастройках   = Новый Массив;
	
	ПредставленияОснований = ИнтеграцияЭДО.ПредставленияОснованийПоТипамДокументов();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	УдалитьПрофилиНастроекЭДО.Ссылка КАК Ссылка,
		|	УдалитьПрофилиНастроекЭДО.СпособОбменаЭД КАК СпособОбменаЭД,
		|	УдалитьПрофилиНастроекЭДО.Наименование КАК Наименование,
		|	УдалитьПрофилиНастроекЭДО.ОператорЭДО КАК ОператорЭДО,
		|	УдалитьПрофилиНастроекЭДО.ИсходящиеДокументы.(
		|		ИспользоватьЭП КАК ИспользоватьЭП,
		|		ИсходящийДокумент КАК ИсходящийДокумент,
		|		ПрикладнойВидЭД КАК ПрикладнойВидЭД,
		|		ДокументУчета КАК ДокументУчета,
		|		МаршрутПодписания КАК МаршрутПодписания
		|	) КАК ИсходящиеДокументы
		|ИЗ
		|	Справочник.УдалитьПрофилиНастроекЭДО КАК УдалитьПрофилиНастроекЭДО";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезСервис1СЭДО
			И ЗначениеЗаполнено(Выборка.ОператорЭДО) Тогда
			
			ОператорЭДО = КраткоеНаименованиеОператора(Выборка.ОператорЭДО);
			Если СтрНайти(Выборка.Наименование, ОператорЭДО) = 0 Тогда
				МассивСсылок.Добавить(Выборка.Ссылка);
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		ИспользуемыеВидыВНастройках.Очистить();
		ПрикладныеВидыВНастройках.Очистить();
		
		ОтмеченКОбработке = Ложь;
		
		ВыборкаИсходящиеДокументы = Выборка.ИсходящиеДокументы.Выбрать();
		Пока ВыборкаИсходящиеДокументы.Следующий() Цикл
			
			Если ВыборкаИсходящиеДокументы.ИспользоватьЭП 
				И ВыборкаИсходящиеДокументы.МаршрутПодписания = ПустойМаршрут Тогда
				
				МассивСсылок.Добавить(Выборка.Ссылка);
				ОтмеченКОбработке = Истина;
				Прервать;
			КонецЕсли;
			
			Если ВыборкаИсходящиеДокументы.ИсходящийДокумент = Перечисления.ТипыДокументовЭДО.Прикладной Тогда
				ПредставлениеОснования = ПредставленияОснований[ВыборкаИсходящиеДокументы.ПрикладнойВидЭД];
				ПрикладныеВидыВНастройках.Добавить(ВыборкаИсходящиеДокументы.ПрикладнойВидЭД);
			Иначе
				ПредставлениеОснования = ПредставленияОснований[ВыборкаИсходящиеДокументы.ИсходящийДокумент];
				ИспользуемыеВидыВНастройках.Добавить(ВыборкаИсходящиеДокументы.ИсходящийДокумент);
			КонецЕсли;
			
			Если ПредставлениеОснования <> ВыборкаИсходящиеДокументы.ДокументУчета Тогда
				МассивСсылок.Добавить(Выборка.Ссылка);
				ОтмеченКОбработке = Истина;
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		Если ОтмеченКОбработке Тогда
			Продолжить;
		ИначеЕсли ОбщегоНазначенияКлиентСервер.РазностьМассивов(ИспользуемыеТипы, ИспользуемыеВидыВНастройках).Количество()
			ИЛИ ОбщегоНазначенияКлиентСервер.РазностьМассивов(ПрикладныеТипы, ПрикладныеВидыВНастройках).Количество() Тогда
			МассивСсылок.Добавить(Выборка.Ссылка);
		КонецЕсли;
		
	КонецЦикла;
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
	
	Данные_НоваяАрхитектураНастроекЭДО = ДанныеКОбработке_НоваяАрхитектураНастроекЭДО();
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Данные_НоваяАрхитектураНастроекЭДО, ДополнительныеПараметры);
	
КонецПроцедуры

// Обработчик обновления.
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ИнициализироватьПараметрыОбработкиДляПереходаНаНовуюВерсию(Параметры);
	
	МетаданныеОбъекта = Метаданные.Справочники.УдалитьПрофилиНастроекЭДО;
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
	ПараметрыОтметкиВыполнения = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ОбработанныхОбъектов = 0;
	ПроблемныхОбъектов = 0;
	
	// Обрабатывать настройки можно только после обновления предопределенных маршрутов.
	Если Не ОбновлениеИнформационнойБазы.ОбъектОбработан("Справочник.МаршрутыПодписания").Обработан Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
			Параметры.Очередь, ПолноеИмяОбъекта);
		Возврат;
	КонецЕсли;
	
	ПараметрыВыборки = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыВыборкиДанныхДляОбработки();
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта, ПараметрыВыборки);
	
	НаборСсылок = Новый Массив;
	Пока Выборка.Следующий() Цикл
		НаборСсылок.Добавить(Выборка.Ссылка);
	КонецЦикла;
	ПредставленияОснований = ИнтеграцияЭДО.ПредставленияОснованийПоТипамДокументов();
	
	Для каждого СсылкаНаОбъект Из НаборСсылок Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", СсылкаНаОбъект);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			Записать = Ложь;
			
			Объект = СсылкаНаОбъект.ПолучитьОбъект();
			Если Объект <> Неопределено Тогда
				ОбработатьДанные_Основной(Объект, ПредставленияОснований, Записать);
				ОбработатьДанные_НоваяАрхитектураНастроекЭДО(Объект);
			КонецЕсли;
			
			Если Записать Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Объект);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(СсылкаНаОбъект, ПараметрыОтметкиВыполнения);
			КонецЕсли;
			
			ОбработанныхОбъектов = ОбработанныхОбъектов + 1;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			ШаблонСообщения = НСтр("ru = 'Не удалось обработать профиль настроек ЭДО: %1 по причине:'");
			ТекстСообщения = СтрШаблон(ШаблонСообщения, СсылкаНаОбъект) + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеОбъекта, СсылкаНаОбъект, ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Если ОбработанныхОбъектов = 0 И ПроблемныхОбъектов <> 0 Тогда
		ШаблонСообщения = НСтр("ru = 'Не удалось обработать некоторые профили настроек ЭДО (пропущены): %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ШаблонСообщения = НСтр("ru = 'Обработана очередная порция профилей настроек ЭДО: %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ОбработанныхОбъектов);
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			МетаданныеОбъекта,, ТекстСообщения);
	КонецЕсли;
	
	Параметры.ПрогрессВыполнения.ОбработаноОбъектов  = Параметры.ПрогрессВыполнения.ОбработаноОбъектов  + ОбработанныхОбъектов;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
		Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

// Обработчик обновления для добавления из вне библиотеки.
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсиюВнешнийВызов(Параметры) Экспорт
	
	ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры);
	
КонецПроцедуры

// См. ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы.
Функция ДанныеОбновленыНаНовуюВерсиюПрограммы(МетаданныеИОтбор) Экспорт
	
	Если МетаданныеИОтбор.ПолноеИмя = "Справочник.УдалитьПрофилиНастроекЭДО" Тогда
		МетаданныеИОтборПрофиляНастроек = МетаданныеИОтбор;
	ИначеЕсли МетаданныеИОтбор.ПолноеИмя = "Документ.ЭлектронныйДокументИсходящий" 
		ИЛИ МетаданныеИОтбор.ПолноеИмя = "Документ.ЭлектронныйДокументВходящий" Тогда
		ПрофильНастроек = МетаданныеИОтбор.Отбор.УдалитьПрофильНастроекЭДО;
		МетаданныеИОтборПрофиляНастроек = ОбновлениеИнформационнойБазы.МетаданныеИОтборПоДанным(ПрофильНастроек);
	КонецЕсли;
	
	Возврат ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы(МетаданныеИОтборПрофиляНастроек);
	
КонецФункции

// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСвойстваЭДИзПрофиля(ПрофильЭДО, ВидЭД, СвойстваЭД)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПрофилиНастроекЭДОИсходящиеДокументы.ТребуетсяИзвещениеОПолучении КАК ТребуетсяИзвещение,
	|	ПрофилиНастроекЭДОИсходящиеДокументы.ТребуетсяОтветнаяПодпись КАК ТребуетсяОтветнаяПодпись,
	|	ПрофилиНастроекЭДОИсходящиеДокументы.ИспользоватьЭП КАК ИспользоватьЭП
	|ИЗ
	|	Справочник.УдалитьПрофилиНастроекЭДО.ИсходящиеДокументы КАК ПрофилиНастроекЭДОИсходящиеДокументы
	|ГДЕ
	|	ПрофилиНастроекЭДОИсходящиеДокументы.Ссылка = &ПрофильЭДО
	|	И ПрофилиНастроекЭДОИсходящиеДокументы.ИсходящийДокумент = &ВидЭД";
	
	Запрос.УстановитьПараметр("ПрофильЭДО", ПрофильЭДО);
	Запрос.УстановитьПараметр("ВидЭД", ВидЭД);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(СвойстваЭД, Выборка);
	КонецЦикла;
	
	
КонецПроцедуры

Процедура ДобавитьВидЭлектронногоДокументаДляПодписания(ВидЭлектронногоДокумента, СертификатыПрофиля)
	
	НаборЗаписей = РегистрыСведений.ПодписываемыеВидыЭД.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ВидЭД.Установить(ВидЭлектронногоДокумента);
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() Тогда
		СертификатыНабора = НаборЗаписей.ВыгрузитьКолонку("СертификатЭП");
		СертификатыКДобавлению = ОбщегоНазначенияКлиентСервер.РазностьМассивов(СертификатыПрофиля, СертификатыНабора);
	Иначе
		СертификатыКДобавлению = СертификатыПрофиля;
	КонецЕсли;
	
	Если СертификатыКДобавлению.Количество() Тогда
		Для Каждого Сертификат Из СертификатыКДобавлению Цикл
			Запись = НаборЗаписей.Добавить();
			Запись.ВидЭД = ВидЭлектронногоДокумента;
			Запись.СертификатЭП = Сертификат;
			Запись.Использовать = Истина;
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
	КонецЕсли;
	
КонецПроцедуры

#Область Обновление

Процедура ИнициализироватьПараметрыОбработкиДляПереходаНаНовуюВерсию(Параметры)
	
	// Определим общее количество объектов к обработке.
	Если Параметры.ПрогрессВыполнения.ВсегоОбъектов = 0 Тогда
		
		ПараметрыВыборки = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыВыборкиДанныхДляОбработки();
		ПараметрыВыборки.ВыбиратьПорциями = Ложь;
		Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.УдалитьПрофилиНастроекЭДО", ПараметрыВыборки);
		Параметры.ПрогрессВыполнения.ВсегоОбъектов = Выборка.Количество();
		
	КонецЕсли;
	
КонецПроцедуры

Функция ДанныеКОбработке_НоваяАрхитектураНастроекЭДО()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СертификатыПрофилей.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.УдалитьПрофилиНастроекЭДО.СертификатыПодписейОрганизации КАК СертификатыПрофилей
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СертификатыУчетныхЗаписейЭДО КАК СертификатыУчетныхЗаписейЭДО
	|		ПО СертификатыПрофилей.Ссылка.ИдентификаторОрганизации = СертификатыУчетныхЗаписейЭДО.ИдентификаторЭДО
	|			И СертификатыПрофилей.Сертификат = СертификатыУчетныхЗаписейЭДО.Сертификат
	|ГДЕ
	|	СертификатыУчетныхЗаписейЭДО.Сертификат ЕСТЬ NULL";
	
	Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат Результат;
КонецФункции

Процедура ОбработатьДанные_НоваяАрхитектураНастроекЭДО(Объект)
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СертификатыУчетныхЗаписейЭДО");
	ЭлементБлокировки.УстановитьЗначение("ИдентификаторЭДО", Объект.ИдентификаторОрганизации);
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	Блокировка.Заблокировать();
	
	Набор = РегистрыСведений.СертификатыУчетныхЗаписейЭДО.СоздатьНаборЗаписей();
	Набор.Отбор.ИдентификаторЭДО.Установить(Объект.ИдентификаторОрганизации);
	Набор.Прочитать();
	
	Если Не ЗначениеЗаполнено(Набор) Тогда
		
		Сертификаты = Объект.СертификатыПодписейОрганизации.ВыгрузитьКолонку("Сертификат");
		Сертификаты = ОбщегоНазначенияКлиентСервер.СвернутьМассив(Сертификаты);
		ДействителенДо = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Сертификаты, "ДействителенДо");
		
		Для каждого СтрокаСертификата Из Сертификаты Цикл
			
			Запись = Набор.Добавить();
			Запись.ИдентификаторЭДО = Объект.ИдентификаторОрганизации;
			Запись.Сертификат = СтрокаСертификата;
			Запись.ДействителенДо = ДействителенДо.Получить(СтрокаСертификата);
			
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(Набор);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьДанные_Основной(Объект, ПредставленияОснований, Записать)
	
	ПараметрыОтбора = Новый Структура("МаршрутПодписания, ИспользоватьЭП", 
		Справочники.МаршрутыПодписания.ПустаяСсылка(), Истина);
	СтрокиСПустымМаршрутом = Объект.ИсходящиеДокументы.НайтиСтроки(ПараметрыОтбора);
	
	Если СтрокиСПустымМаршрутом.Количество() Тогда
		Для Каждого СтрокаНастройки Из СтрокиСПустымМаршрутом Цикл
			СтрокаНастройки.МаршрутПодписания = МаршрутыПодписанияБЭД.МаршрутОднойДоступнойПодписью();
		КонецЦикла;
		
		Записать = Истина;
	КонецЕсли;
	
	Если Объект.СпособОбменаЭД = Перечисления.СпособыОбменаЭД.ЧерезСервис1СЭДО
		И ЗначениеЗаполнено(Объект.ОператорЭДО) Тогда
		
		ОператорЭДО = КраткоеНаименованиеОператора(Объект.ОператорЭДО);
		Если СтрНайти(Объект.Наименование, ОператорЭДО) = 0 Тогда
			Объект.Наименование = Объект.Наименование + " (" + ОператорЭДО + ")";
			Записать = Истина;
		КонецЕсли;
	КонецЕсли;
	
	СоответствиеИспользуемыхТипов = ИнтеграцияЭДО.ИспользуемыеТипыДокументов();
	ИспользуемыеТипы = Новый Массив;
	Для Каждого ИспользуемыйТип Из СоответствиеИспользуемыхТипов Цикл
		ИспользуемыеТипы.Добавить(ИспользуемыйТип.Ключ);
	КонецЦикла;
	ПрикладныеТипы   = ИнтеграцияЭДО.ПрикладныеТипыЭлектронныхДокументов();
	
	ВидыДокументов = Новый Массив;
	ВидыДокументовПоТипам = ЭлектронныеДокументыЭДО.ВидыДокументовПоСтандартнымТипам(ИспользуемыеТипы);
	Для Каждого ВидДокументаПоТипу Из ВидыДокументовПоТипам Цикл
		ВидыДокументов.Добавить(ВидДокументаПоТипу.Значение);
	КонецЦикла;
	ПрикладныеВидыДокументовПоТипам = ЭлектронныеДокументыЭДО.ВидыДокументовПоПрикладнымТипам(ПрикладныеТипы);
	ОбщегоНазначенияКлиентСервер.ДополнитьСоответствие(ВидыДокументовПоТипам, ПрикладныеВидыДокументовПоТипам);
	Для Каждого ВидДокументаПоТипу Из ПрикладныеВидыДокументовПоТипам Цикл
		ВидыДокументов.Добавить(ВидДокументаПоТипу.Значение);
	КонецЦикла;
	
	ШаблоныНастроекПоВидам = ЭлектронныеДокументыЭДО.ШаблоныНастроекОтправкиВидовДокументов(ВидыДокументов);
	
	Для Каждого СтрокаТаблицы Из Объект.ИсходящиеДокументы Цикл
		
		Если СтрокаТаблицы.ИсходящийДокумент = Перечисления.ТипыДокументовЭДО.Прикладной Тогда
			Индекс = ПрикладныеТипы.Найти(СтрокаТаблицы.ПрикладнойВидЭД);
			Если Индекс <> Неопределено Тогда
				ПрикладныеТипы.Удалить(Индекс);
			КонецЕсли;
			ПредставлениеОснования = ПредставленияОснований[СтрокаТаблицы.ПрикладнойВидЭД];
		Иначе
			Индекс = ИспользуемыеТипы.Найти(СтрокаТаблицы.ИсходящийДокумент);
			Если Индекс <> Неопределено Тогда
				ИспользуемыеТипы.Удалить(Индекс);
			КонецЕсли;
			ПредставлениеОснования = ПредставленияОснований[СтрокаТаблицы.ИсходящийДокумент];
		КонецЕсли;
		
		Если ПредставлениеОснования <> СтрокаТаблицы.ДокументУчета Тогда
			СтрокаТаблицы.ДокументУчета = ПредставлениеОснования;
			Записать = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	СертификатыПрофиляТЧ = Объект.СертификатыПодписейОрганизации.ВыгрузитьКолонку("Сертификат");
	СертификатыПрофиля = Новый Массив;
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СертификатыПрофиля, СертификатыПрофиляТЧ, Истина); 
	ПараметрыОтбора = Новый Структура("ИспользоватьЭП", Истина);
	ИспользоватьЭП = ЭлектроннаяПодпись.ИспользоватьЭлектронныеПодписи()
		И (НЕ СинхронизацияЭДО.ЭтоПрямойОбмен(Объект.СпособОбменаЭД)
			ИЛИ ЗначениеЗаполнено(Объект.ИсходящиеДокументы.НайтиСтроки(ПараметрыОтбора)));
	
	Если ИспользуемыеТипы.Количество() Тогда
		Записать = Истина;
		
		Для Каждого ТипЭлектронногоДокумента Из ИспользуемыеТипы Цикл
			ВидДокумента = ВидыДокументовПоТипам[ТипЭлектронногоДокумента];
			ШаблонНастройки = ШаблоныНастроекПоВидам.Найти(ВидДокумента, "ВидДокумента");
			ЗаполнитьНастройкуВидаЭлектронногоДокумента(
				Объект.ИсходящиеДокументы.Добавить(), ШаблонНастройки, ТипЭлектронногоДокумента,
				Объект.СпособОбменаЭД, ИспользоватьЭП);
			
			ДобавитьВидЭлектронногоДокументаДляПодписания(ВидДокумента,
				СертификатыПрофиля);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ПрикладныеТипы.Количество() Тогда
		Записать = Истина;
		
		Для Каждого ТипЭлектронногоДокумента Из ПрикладныеТипы Цикл
			ВидДокумента = ВидыДокументовПоТипам[ТипЭлектронногоДокумента];
			ШаблонНастройки = ШаблоныНастроекПоВидам.Найти(ВидДокумента, "ВидДокумента");
			ЗаполнитьНастройкуВидаЭлектронногоДокумента(
				Объект.ИсходящиеДокументы.Добавить(), ШаблонНастройки, ТипЭлектронногоДокумента,
				Объект.СпособОбменаЭД, ИспользоватьЭП);
			ДобавитьВидЭлектронногоДокументаДляПодписания(ВидДокумента, СертификатыПрофиля);
		КонецЦикла;
		
	КонецЕсли;
	
	Объект.ИсходящиеДокументы.Сортировать("Приоритет");
	
КонецПроцедуры

Процедура ЗаполнитьНастройкуВидаЭлектронногоДокумента(Настройка, ШаблонНастройки, ТипЭлектронногоДокумента,
	СпособОбмена, ИспользоватьЭП) Экспорт
	
	ЗаполнитьЗначенияСвойств(Настройка, ШаблонНастройки);
	Настройка.ИсходящийДокумент = ТипЭлектронногоДокумента;
	Если ТипЭлектронногоДокумента = Перечисления.ТипыДокументовЭДО.Прикладной Тогда
		Настройка.ИсходящийДокумент = Перечисления.ТипыДокументовЭДО.Прикладной;
		Настройка.ПрикладнойВидЭД   = ТипЭлектронногоДокумента;
	КонецЕсли;
	Настройка.ВерсияФормата = ШаблонНастройки.Формат;
	Настройка.Формировать = Истина;
	Настройка.ИспользоватьЭП = ИспользоватьЭП;
	Если (ТипЭлектронногоДокумента = Перечисления.ТипыДокументовЭДО.СчетФактура
		Или ТипЭлектронногоДокумента = Перечисления.ТипыДокументовЭДО.КорректировочныйСчетФактура)
		И СинхронизацияЭДО.ЭтоПрямойОбмен(СпособОбмена) Тогда
		Настройка.Формировать = Ложь;
		Настройка.ИспользоватьЭП = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли

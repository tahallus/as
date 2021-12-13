﻿#Область ПрограммныйИнтерфейс

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиентаПриЗапуске.
//
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	ТребуетсяУстановитьРабочийСтолПользователя = ТребуетсяУстановитьРабочийСтолПользователя();
	Параметры.Вставить("ТребуетсяУстановитьРабочийСтолПользователяУНФ", ТребуетсяУстановитьРабочийСтолПользователя);
	
КонецПроцедуры

// Определяет состав форм рабочего стола в зависимости от прав доступа пользователя.
//
// Параметры:
//  СоставФормИзменен	 - Булево	 - Признак изменения состава форм рабочего стола в процедуре
//
Процедура УстановитьРабочийСтолПользователя(СоставФормИзменен = Ложь) Экспорт
	
	Если ТребуетсяУстановитьРабочийСтолПользователя() Тогда
		УстановитьСоставФорм(СоставФормИзменен);
	КонецЕсли;
	
КонецПроцедуры

// Определяет состав форм рабочего стола в зависимости от прав доступа пользователя.
//
// Параметры:
//  СоставФормИзменен	 - Булево	 - Признак изменения состава форм рабочего стола в процедуре
//  ИмяПользователя		 - Строка	 - Имя пользователя, для которого следует изменить состав форм рабочего стола
//
Процедура УстановитьСоставФорм(СоставФормИзменен = Ложь, ИмяПользователя = "") Экспорт
	
	НастройкиНачальнойСтраницы = Новый НастройкиНачальнойСтраницы;
	СоставФорм = НастройкиНачальнойСтраницы.ПолучитьСоставФорм();
	СоставФорм.ЛеваяКолонка.Очистить();
	
	// МобильноеПриложение
	Если МобильноеПриложениеВызовСервера.НужноОграничитьФункциональность() Тогда
		СоставФорм.ЛеваяКолонка.Добавить("ОбщаяФорма.ВиджетНаНачальнойСтранице");
	ИначеЕсли МобильноеПриложениеВызовСервера.НужноОграничитьФункциональность20() Тогда
		СоставФорм.ЛеваяКолонка.Добавить("ОбщаяФорма.ВиджетНаНачальнойСтраницеМПУНФ");
	// Конец МобильноеПриложение
	ИначеЕсли ПравоДоступа("Просмотр", Метаданные.Обработки.ПульсБизнеса) Тогда
		СоставФорм.ЛеваяКолонка.Добавить("Обработка.ПульсБизнеса.Форма.ПульсБизнеса");
	ИначеЕсли ПравоДоступа("Просмотр", Метаданные.ЖурналыДокументов.ДокументыПоПродажам) Тогда
		СоставФорм.ЛеваяКолонка.Добавить("ЖурналДокументов.ДокументыПоПродажам.ФормаСписка");
	ИначеЕсли ПравоДоступа("Просмотр", Метаданные.ЖурналыДокументов.ДокументыПоЗакупкам) Тогда
		СоставФорм.ЛеваяКолонка.Добавить("ЖурналДокументов.ДокументыПоЗакупкам.ФормаСписка");
	ИначеЕсли ПравоДоступа("Просмотр", Метаданные.ЖурналыДокументов.ДокументыПоСкладу) Тогда
		СоставФорм.ЛеваяКолонка.Добавить("ЖурналДокументов.ДокументыПоСкладу.ФормаСписка");
	ИначеЕсли ПравоДоступа("Просмотр", Метаданные.ЖурналыДокументов.ДокументыПоПроизводству) Тогда
		СоставФорм.ЛеваяКолонка.Добавить("ЖурналДокументов.ДокументыПоПроизводству.ФормаСписка");
	ИначеЕсли ПравоДоступа("Просмотр", Метаданные.ЖурналыДокументов.ДокументыПоЗарплате) Тогда
		СоставФорм.ЛеваяКолонка.Добавить("ЖурналДокументов.ДокументыПоЗарплате.ФормаСписка");
	ИначеЕсли ПравоДоступа("Просмотр", Метаданные.ЖурналыДокументов.ДокументыПоБанку) Тогда
		СоставФорм.ЛеваяКолонка.Добавить("ЖурналДокументов.ДокументыПоБанку.ФормаСписка");
	ИначеЕсли ПравоДоступа("Изменение", Метаданные.Справочники.ЗаписиКалендаряПодготовкиОтчетности) Тогда
		СоставФорм.ЛеваяКолонка.Добавить(
			"Справочник.ЗаписиКалендаряПодготовкиОтчетности.Форма.КалендарьНалоговИОтчетности");
	КонецЕсли;
	
	СоставФорм.ПраваяКолонка.Очистить();
	СоставФорм.ПраваяКолонка.Добавить("ОбщаяФорма.НовостиИИнформационныйЦентр");
	СоставФорм.ПраваяКолонка.Добавить("Обработка.ТекущиеДела.Форма");
	
	НастройкиНачальнойСтраницы.УстановитьСоставФорм(СоставФорм);
	Если ЗначениеЗаполнено(ИмяПользователя) Тогда
		ОбщегоНазначения.ХранилищеСистемныхНастроекСохранить("Общее/НастройкиНачальнойСтраницы", "",
			НастройкиНачальнойСтраницы, , ИмяПользователя);
	Иначе
		ОбщегоНазначения.ХранилищеСистемныхНастроекСохранить("Общее/НастройкиНачальнойСтраницы", "",
			НастройкиНачальнойСтраницы);
	КонецЕсли;
	
	СоставФормИзменен = Истина;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТребуетсяУстановитьРабочийСтолПользователя()
	
	Если ОбщегоНазначения.РазделениеВключено()
		И Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	НастройкиНачальнойСтраницы = ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить(
		"Общее/НастройкиНачальнойСтраницы", "");
	
	Возврат НастройкиНачальнойСтраницы = Неопределено;
	
КонецФункции

#КонецОбласти

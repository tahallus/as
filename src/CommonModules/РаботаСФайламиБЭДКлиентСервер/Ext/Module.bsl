﻿#Область СлужебныйПрограммныйИнтерфейс

// Возвращает вид ошибки, возникающей при работе с файлами.
// 
// Возвращаемое значение:
// 	См. ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки
Функция ВидОшибкиРаботаСФайлами() Экспорт
	
	ОбработчикВыполненияДиагностики = "ОбработкаНеисправностейБЭДКлиент.ОткрытьМастерДиагностики";
	
	ВидОшибки = ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки();
	ВидОшибки.Идентификатор = "ОшибкаРаботыСФайлами";
	ВидОшибки.ВыполнятьОбработчикАвтоматически = Истина;
	ВидОшибки.АвтоматическиВыполняемыйОбработчик = ОбработчикВыполненияДиагностики;
	ВидОшибки.ЗаголовокПроблемы = НСтр("ru = 'Ошибка работы с файлами'");
	ВидОшибки.ОписаниеРешения = НСтр("ru = '<a href = ""Выполните"">Выполните</a> диагностику работы с файлами'");
	ВидОшибки.ОбработчикиНажатия.Вставить("Выполните", ОбработчикВыполненияДиагностики);
	
	Возврат ВидОшибки;
	
КонецФункции

// Возвращает пустую структуру описания файла.
// 
// Возвращаемое значение:
// 	Структура - Описание:
//  * ИмяФайла - Строка - имя файла.
//  * ДвоичныеДанные - ДвоичныеДанные - двоичные данные файла.
// 
Функция НовоеОписаниеФайла() Экспорт
	
	ОписаниеФайла = Новый Структура;
	
	ОписаниеФайла.Вставить("ИмяФайла", "");
	ОписаниеФайла.Вставить("ДвоичныеДанные", Неопределено);		
	
	Возврат ОписаниеФайла;
		
КонецФункции

// Возвращает уникальное имя файла, полученное от исходного добавлением порядкового номера.
// 
// Параметры:
//  ИсходноеИмяФайла - Строка - Имя файла.
//  ЭтоКаталог - Булево - Истина, если это каталог.
//  
//  Возвращаемое значение:
//   Строка - Уникальное имя файла.
//
Функция ОпределитьУникальноеИмяФайла(Знач ИсходноеИмяФайла, Знач ЭтоКаталог = Ложь) Экспорт
	
	ПозицияДляДополнения = СтрНайти(ИсходноеИмяФайла, ".", НаправлениеПоиска.СКонца);
	Если ПозицияДляДополнения = 0 Или ЭтоКаталог Тогда
		ПозицияДляДополнения = СтрДлина(ИсходноеИмяФайла) + 1;
	КонецЕсли;
	
	Счетчик = 0;
	Пока Истина Цикл
		
		ДополнениеИмени = ?(Счетчик = 0, "", СтрШаблон(" (%1)", Формат(Счетчик, "ЧГ=0;")));
		ИмяФайла = Лев(ИсходноеИмяФайла, ПозицияДляДополнения - 1) + ДополнениеИмени
			+ Сред(ИсходноеИмяФайла, ПозицияДляДополнения);

		Файл = Новый Файл(ИмяФайла);
		Если Не Файл.Существует() Тогда
			Прервать;
		КонецЕсли;
		
		Счетчик = Счетчик + 1;
		
	КонецЦикла;
	
	Возврат ИмяФайла;
	
КонецФункции

#КонецОбласти
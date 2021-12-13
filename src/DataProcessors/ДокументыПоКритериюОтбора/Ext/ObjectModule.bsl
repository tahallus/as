﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Заполняет таблицу запросов
//
// Параметры
//  ТаблицаЗапросов            - ТаблицаЗначений - содержит документы и соответствующие им запросы
//  ИмяКритерияОтбора          - Строка - либо ДокументыПоКонтрагенту, либо ДокументыПоСделке
//  ДополнительныеДокументы    - Массив - в запрос могут добавляются документы, которые в критерий не входят, но имеют ссылку
//                               на документ, который входит в критерий по реквизиту шапки.
//  ПоляШапки                  - Массив - имена дополнительных полей шапки, которые будут получаться в запросе
//  АдресТаблицыСоответствия   - Строка - адрес во временном хранилище таблицы соответствия
//  УникальныйИдентификатор    - УникальныйИдентификатор - уникальный идентификатор формы, из которой вызывается процедура
//
Процедура ЗаполнитьТаблицуЗапросов(ТаблицаЗапросов, 
	ИмяКритерияОтбора,
	ДополнительныеДокументы,
	ПоляШапки,
	АдресТаблицыСоответствия,
	УникальныйИдентификатор) Экспорт
	
	ОтборыДокументов = Обработки.ДокументыПоКритериюОтбора.ОтборыДокументов();
	
	ДеревоДокументов = Новый ДеревоЗначений;
	ДеревоДокументов.Колонки.Добавить("Документ");
	ДеревоДокументов.Колонки.Добавить("СтруктураДанных");
	ДеревоДокументов.Колонки.Добавить("ТабличнаяЧасть");
	ДеревоДокументов.Колонки.Добавить("ТекстУсловия");
	
	// Используется для гибкой настройки объектов по видам операций;
	ТаблицаСоответствияПрофилей = СформироватьТаблицуСоответствияПрофиляИВидаОперации();
	
	АдресТаблицыСоответствия = ПоместитьВоВременноеХранилище(ТаблицаСоответствияПрофилей, УникальныйИдентификатор);
	
	УточняемыеОбъекты = ПолучитьУточняемыеТипыДокументов();
	
	Для Каждого ЭлементСостава Из Метаданные.КритерииОтбора[ИмяКритерияОтбора].Состав Цикл
		
		СтруктураДанных = СтруктураДанных(ЭлементСостава.ПолноеИмя());
		
		Если Не ПравоДоступа("Просмотр", СтруктураДанных.Метаданные) Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(СтруктураДанных.Метаданные) Тогда
			Продолжить;
		КонецЕсли;
		
		КореньДокумента = ДеревоДокументов.Строки.Найти(СтруктураДанных.Метаданные, "Документ", Ложь);
		Если КореньДокумента = Неопределено Тогда
			
			КореньДокумента = ДеревоДокументов.Строки.Добавить();
			КореньДокумента.Документ = СтруктураДанных.Метаданные;
			
		КонецЕсли;
		
		СтрокаШапкаТЧ = КореньДокумента.Строки.Найти(СтруктураДанных.ИмяТаблЧасти, "ТабличнаяЧасть", Ложь);
		Если СтрокаШапкаТЧ = Неопределено Тогда
			
			СтрокаШапкаТЧ = КореньДокумента.Строки.Добавить();
			СтрокаШапкаТЧ.ТабличнаяЧасть = СтруктураДанных.ИмяТаблЧасти;
			
		КонецЕсли;
		
		СтрокаДанных = СтрокаШапкаТЧ.Строки.Добавить();
		СтрокаДанных.СтруктураДанных = СтруктураДанных;
		
	КонецЦикла;
	
	ШаблонУсловияШапки = " %ПутьКТаблицеРеквизита%.%ПолеПараметрШапки% = &Параметр ";
	ШаблонЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаШапки.Ссылка				КАК Документ,
	|	ТаблицаШапки.Дата				КАК Дата
	|	//%ПОМЕСТИТЬ%
	|ИЗ
	|	Документ.%ИмяТаблицыШапки% КАК ТаблицаШапки
	|ГДЕ
	|	(%ТекстУсловия%) И (%ТекстУсловияПоВидам%)";
	
	ШаблонУсловияДляТЧ = " ТаблицаСтрок.%ПолеПараметрТЧ% = &Параметр ";
	ШаблонУсловияТЧ    = 
	" 1 В
	|	(ВЫБРАТЬ ПЕРВЫЕ 1
	|			1
	|	ИЗ
	|		Документ.%ИмяТаблицыТЧ% КАК ТаблицаСтрок
	|	ГДЕ
	|		ТаблицаСтрок.Ссылка = %УсловиеНаСсылкуВТЧ%
	|		И ( %УсловиеНаСтрокиТЧ% )
	|	)";
	
	Для Каждого СтрокаКорня Из ДеревоДокументов.Строки Цикл
		
		ТекстУсловийПоДокументу = ""; ТекстУсловийПоВидам = "";
		// Цикл по реквизитам и табличным частям одного документа
		Для Каждого СтрокаРеквизитТЧ Из СтрокаКорня.Строки Цикл
			
			ТекстУсловия = ""; ТекстУсловияПоВидам = "";
			// Условие на поле в ТЧ.
			Если Не ПустаяСтрока(СтрокаРеквизитТЧ.ТабличнаяЧасть) Тогда
				
				ВремТекст = "";
				// Цикл по табличным частям
				Для Каждого СтрокаТЧ Из СтрокаРеквизитТЧ.Строки Цикл
					
					ВремТекст = ВремТекст + ?(ПустаяСтрока(ВремТекст),"", " ИЛИ ")
						+ СтрЗаменить(ШаблонУсловияДляТЧ, "%ПолеПараметрТЧ%", СтрокаТЧ.СтруктураДанных.ИмяРеквизита);
						
				КонецЦикла;
				
				ТекстУсловия = СтрЗаменить(ШаблонУсловияТЧ, "%ИмяТаблицыТЧ%", СтрокаКорня.Документ.Имя + "." + СтрокаРеквизитТЧ.ТабличнаяЧасть);
				ТекстУсловия = СтрЗаменить(ТекстУсловия, "%УсловиеНаСтрокиТЧ%", ВремТекст);
				
			Иначе // Условие по шапке
				
				// Цикл по реквизитам
				Для Каждого СтрокаТЧ Из СтрокаРеквизитТЧ.Строки Цикл
					
					ТекстУсловия = ТекстУсловия + ?(ПустаяСтрока(ТекстУсловия),"", " ИЛИ ")
						+ СтрЗаменить(ШаблонУсловияШапки, "%ПолеПараметрШапки%", СтрокаТЧ.СтруктураДанных.ИмяРеквизита);
						
				КонецЦикла;
				
			КонецЕсли;
			
			Если Не Пользователи.ЭтоПолноправныйПользователь()
				И УточняемыеОбъекты[СтрокаКорня.Документ.Имя] <> Неопределено Тогда
				ВремТекстУсловия = СтрЗаменить(ШаблонУсловияШапки, "%ПолеПараметрШапки%", "ВидОперации");
				ВремТекстУсловия = СтрЗаменить(ВремТекстУсловия, "= &Параметр", "В (&МассивДопустимыхВидовОпераций"
					+ СтрокаКорня.Документ.Имя + ")");
				ТекстУсловияПоВидам = ТекстУсловияПоВидам + ?(ПустаяСтрока(ТекстУсловияПоВидам), "", " И ")
					+ ВремТекстУсловия;
			КонецЕсли;
			
			Если Не ПустаяСтрока(ТекстУсловия) Тогда
				
				ДобавитьТекстВСтроку(ТекстУсловийПоДокументу, ТекстУсловия, " ИЛИ ");
				
			КонецЕсли;
			
			ДобавитьТекстВСтроку(ТекстУсловийПоВидам, ?(ПустаяСтрока(ТекстУсловияПоВидам), "ИСТИНА", ТекстУсловияПоВидам), " И ");
			
		КонецЦикла;
		
		Если Не ПустаяСтрока(ТекстУсловийПоДокументу) Тогда
			
			ТекстЗапроса = СтрЗаменить(ШаблонЗапроса, "%ИмяТаблицыШапки%", СтрокаКорня.Документ.Имя);
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ТекстУсловия%", ТекстУсловийПоДокументу);
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ТекстУсловияПоВидам%"
			, ?(ПустаяСтрока(ТекстУсловийПоВидам), "ИСТИНА", ТекстУсловийПоВидам));
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ПутьКТаблицеРеквизита%", "ТаблицаШапки");
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%УсловиеНаСсылкуВТЧ%", " ТаблицаШапки.Ссылка");
			ДобавитьДополнительныеПоляШапки(ТекстЗапроса,СтрокаКорня.Документ, ПоляШапки);
			ДобавитьЗапросВТаблицу(ТаблицаЗапросов, СтрокаКорня.Документ, ТекстЗапроса, ОтборыДокументов);
			
			СтрокаКорня.ТекстУсловия = ТекстУсловийПоДокументу;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// В запрос добавляются документы, которые в критерий не входят, но имеют ссылку
	// на документ, который входит в критерий по реквизиту шапки.
	
	МассивУсловий      = Новый Массив;
	СоответствиеПолей  = Новый Соответствие;
	
	Для Каждого Документ Из ДополнительныеДокументы Цикл
		Если Не ПравоДоступа("Редактирование", Документ) Тогда
			Продолжить;
		КонецЕсли;
		
		МассивУсловий.Очистить();
		СоответствиеПолей.Очистить();
		
		Для Каждого Реквизит Из Документ.Реквизиты Цикл
			Для Каждого СтрокаДерева Из ДеревоДокументов.Строки Цикл
				
				// Проверка, что документ-основание содержит нужную ссылку только в шапке.
				Если Не РеквизитСодержитТип(Реквизит, "ДокументСсылка." + СтрокаДерева.Документ.Имя)
				 Или Не РеквизитТолькоВШапке(СтрокаДерева) Тогда
					Продолжить;
				КонецЕсли;
				
				МассивСтруктур = СоответствиеПолей.Получить(Реквизит);
				Если МассивСтруктур = Неопределено Тогда
					
					МассивСтруктур = Новый Массив;
					СоответствиеПолей.Вставить(Реквизит, МассивСтруктур);
					
				КонецЕсли;
				
				МассивСтруктур.Добавить(Новый Структура("Документ, ТекстУсловия",
												СтрокаДерева.Документ,
												СтрокаДерева.ТекстУсловия));
			КонецЦикла;
		КонецЦикла;
		
		Для Каждого КлючИЗначение Из СоответствиеПолей Цикл
			Для Каждого ЭлементСтруктура Из КлючИЗначение.Значение Цикл
				
				Если РеквизитСоставной(КлючИЗначение.Ключ) Тогда
					ПутьКТаблицеРеквизита = "ВЫРАЗИТЬ(ТаблицаШапки." + КлючИЗначение.Ключ.Имя +" КАК Документ." + ЭлементСтруктура.Документ.Имя + ")";
				Иначе
					ПутьКТаблицеРеквизита = "ТаблицаШапки." + КлючИЗначение.Ключ.Имя;
				КонецЕсли;
				
				ВремТекст = ЭлементСтруктура.ТекстУсловия;
				ВремТекст = СтрЗаменить(ВремТекст, "%ПутьКТаблицеРеквизита%", ПутьКТаблицеРеквизита);
				ВремТекст = СтрЗаменить(ВремТекст, "%ПолеПараметр%", КлючИЗначение.Ключ.Имя);
				ВремТекст = СтрЗаменить(ВремТекст, "%УсловиеНаСсылкуВТЧ%", "ТаблицаШапки." + КлючИЗначение.Ключ.Имя);
				МассивУсловий.Добавить(ВремТекст);
				
			КонецЦикла;
		КонецЦикла;
		
		Если МассивУсловий.Количество() > 0 Тогда
			
			ТекстЗапроса = СтрЗаменить(ШаблонЗапроса, "%ИмяТаблицыШапки%", Документ.Имя);
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ТекстУсловия%", СтрокаИзМассиваСтрок(МассивУсловий, " ИЛИ "));
			
			ДобавитьДополнительныеПоляШапки(ТекстЗапроса, Документ, ПоляШапки);
			ДобавитьЗапросВТаблицу(ТаблицаЗапросов, Документ, ТекстЗапроса, ОтборыДокументов);
			
		КонецЕсли;
		
	КонецЦикла;
		
	ШаблонЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаШапки.Ссылка              КАК Документ,
	|	//%СтрокаДопПолей%
	|	ТаблицаШапки.Номер               КАК Номер,
	|	ТаблицаШапки.Дата                КАК Дата,
	|	ТИПЗНАЧЕНИЯ(ТаблицаШапки.Ссылка) КАК ТипДокумента,
	|	ТаблицаШапки.ПометкаУдаления КАК ПометкаУдаления,
	|	ВЫБОР
	|		КОГДА ТаблицаШапки.Проведен ТОГДА
	|			0
	|		КОГДА ТаблицаШапки.ПометкаУдаления ТОГДА
	|			1
	|		ИНАЧЕ 2
	|	КОНЕЦ                        КАК ИдентификаторКартинки
	|ИЗ
	|	Документ.%ИмяТаблицыШапки% КАК ТаблицаШапки
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтТаблицаОтбора КАК ТаблицаОтбора ПО ТаблицаШапки.Ссылка = ТаблицаОтбора.Документ
	|";
	Для Каждого СтрокаТаб Из ТаблицаЗапросов Цикл
		
		ВремТекст= СтрЗаменить(ШаблонЗапроса, "%ИмяТаблицыШапки%", СтрокаТаб.ИмяДокумента);
		ДобавитьДополнительныеПоляШапки(ВремТекст, Метаданные.Документы[СтрокаТаб.ИмяДокумента], ПоляШапки);
		
		Если СтрокаТаб.ИмяДокумента = "СчетФактура"
			ИЛИ СтрокаТаб.ИмяДокумента = "СчетФактураПолученный" Тогда
			
			ВремТекст = СтрЗаменить(ВремТекст, "ТаблицаШапки.СуммаДокумента", "ТаблицаШапки.СуммаДокумента + ТаблицаШапки.СуммаНДСДокумента");
			
		КонецЕсли;
		
		СтрокаТаб.ТекстЗапросаВыборка = ВремТекст;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьТекстВСтроку(Строка, Текст, Разделитель = " Или ")

	Строка = Строка + ?(ПустаяСтрока(Строка), "", Разделитель) + Текст;

КонецПроцедуры

Функция СтрокаИзМассиваСтрок(МассивСтрок, Разделитель = " Или ")

	Результат = "";
	Для Каждого Элемент Из МассивСтрок Цикл

		ДобавитьТекстВСтроку(Результат, Элемент, Разделитель);

	КонецЦикла;

	Возврат Результат;

КонецФункции

Функция СтруктураДанных(ПутьКДанным)
	
	Структура = Новый Структура;
	
	СоответствиеИмен = Новый Массив();
	СоответствиеИмен.Добавить("ТипОбъекта");
	СоответствиеИмен.Добавить("ВидОбъекта");
	СоответствиеИмен.Добавить("ПутьКДанным");
	СоответствиеИмен.Добавить("ИмяТаблЧасти");
	СоответствиеИмен.Добавить("ИмяРеквизита");
	
	Для ТекИндекс = 1 По 3 Цикл
		
		Точка = СтрНайти(ПутьКДанным, ".");
		ТекущееЗначение = Лев(ПутьКДанным, Точка-1);
		Структура.Вставить(СоответствиеИмен[ТекИндекс-1], ТекущееЗначение);
		ПутьКДанным = Сред(ПутьКДанным, Точка+1);
		
	КонецЦикла;
	
	ПутьКДанным = СтрЗаменить(ПутьКДанным, "Реквизит.", "");
	
	Если Структура.ПутьКДанным = "ТабличнаяЧасть" Тогда
		
		Для ТекИндекс = 4 По 5  Цикл 
			
			Точка = СтрНайти(ПутьКДанным, ".");
			Если Точка = 0 Тогда
				ТекущееЗначение = ПутьКДанным;
			Иначе
				ТекущееЗначение = Лев(ПутьКДанным, Точка-1);
			КонецЕсли;
			
			Структура.Вставить(СоответствиеИмен[ТекИндекс-1], ТекущееЗначение);
			ПутьКДанным = Сред(ПутьКДанным,  Точка+1);
			
		КонецЦикла;
		
	Иначе
		
		Структура.Вставить(СоответствиеИмен[3], "");
		Структура.Вставить(СоответствиеИмен[4], ПутьКДанным);
		
	КонецЕсли;
	
	Если Структура.ТипОбъекта = "Документ" Тогда
		Структура.Вставить("Метаданные", Метаданные.Документы[Структура.ВидОбъекта]);
	Иначе
		Структура.Вставить("Метаданные", Метаданные.Справочники[Структура.ВидОбъекта]);
	КонецЕсли;
	
	Возврат Структура;
	
КонецФункции

Процедура ДобавитьЗапросВТаблицу(ТаблицаЗапросов, МетаданныеДокумента, ТекстЗапроса, ОтборыДокументов)
	
	НоваяСтрока = ТаблицаЗапросов.Добавить();
	НоваяСтрока.ИмяДокумента = МетаданныеДокумента.Имя;
	НоваяСтрока.СинонимДокумента = МетаданныеДокумента.Синоним;
	НоваяСтрока.Использовать = Истина;
	НоваяСтрока.ТекстЗапроса = ТекстЗапроса;
	НоваяСтрока.ГруппаОтбора = ОтборыДокументов[МетаданныеДокумента.Имя];
	
КонецПроцедуры

Процедура ДобавитьДополнительныеПоляШапки(ТекстЗапроса, МетаданныеДокумента, ДопПоляШапки)

	ШаблонПоля  = "%ИмяПоля% КАК %ПсевдонимПоля%,";
	СтрокаПолей = "";

	Для Каждого ИмяПоля Из ДопПоляШапки Цикл

		Если МетаданныеДокумента.Реквизиты.Найти(ИмяПоля) <> Неопределено Тогда

			Текст = СтрЗаменить(ШаблонПоля, "%ИмяПоля%", "ПРЕДСТАВЛЕНИЕССЫЛКИ(ТаблицаШапки." + ИмяПоля +" ) ");
			
		Иначе

			Текст = СтрЗаменить(ШаблонПоля, "%ИмяПоля%", " NULL ");

		КонецЕсли;

		СтрокаПолей = СтрокаПолей + ?(ПустаяСтрока(СтрокаПолей), "", Символы.ПС)
				+ СтрЗаменить(Текст, "%ПсевдонимПоля%", ИмяПоля);

	КонецЦикла;

	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//%СтрокаДопПолей%", СтрокаПолей);

КонецПроцедуры

Функция РеквизитСоставной(МетаданныеРеквизита)

	Возврат МетаданныеРеквизита.Тип.Типы().Количество() > 1;

КонецФункции

Функция РеквизитСодержитТип(МетаданныеРеквизита, ИмяТипа)

	Возврат МетаданныеРеквизита.Тип.СодержитТип(Тип(ИмяТипа));

КонецФункции

Функция РеквизитТолькоВШапке(СтрокаДерева)

	Возврат СтрокаДерева.Строки.НайтиСтроки(Новый Структура("ТабличнаяЧасть", ""), Ложь).Количество()>0;

КонецФункции

Функция СформироватьТаблицуСоответствияПрофиляИВидаОперации()
	
	// На остальные ограничение действовать не будет.
	ОписаниеОбъектов = ПолучитьУточняемыеТипыДокументов();
	
	УточняемыеПрофили = ПолучитьУточняемыеПрофилиПользователей();
	
	ПоставляемыеПрофили = Справочники.ПрофилиГруппДоступа.ОписаниеПоставляемыхПрофилей();
	
	ОписанияПрофилей = ПоставляемыеПрофили.ОписанияПрофилейМассив;
	
	ПравилаУточненияПоВидамОперации = ПолучитьПравилаУточненияПоВидамОперации(ОписанияПрофилей, УточняемыеПрофили, ОписаниеОбъектов);
	
	ТаблицаСоответствия = Новый ТаблицаЗначений();
		
	ЗаполнитьТаблицуСоответствия(ТаблицаСоответствия, ПравилаУточненияПоВидамОперации);
	
	Возврат ТаблицаСоответствия; 

КонецФункции

Процедура ЗаполнитьТаблицуСоответствия(ТаблицаСоответствия, ПравилаУточненияПоВидамОперации)
	
	ТаблицаСоответствия.Колонки.Добавить("Профиль");
	ТаблицаСоответствия.Колонки.Добавить("Объект");
	ТаблицаСоответствия.Колонки.Добавить("ВидОперации");
		
	Для Каждого ПервыйУровень Из ПравилаУточненияПоВидамОперации Цикл
		Для Каждого ВторойУровень Из ПервыйУровень.Значение Цикл
			Для Каждого ТретийУровень Из ВторойУровень.Значение Цикл
				НоваяСтрока = ТаблицаСоответствия.Добавить();
				НоваяСтрока.Профиль			= ПервыйУровень.Ключ;
				НоваяСтрока.Объект			= ВторойУровень.Ключ;
				НоваяСтрока.ВидОперации		= ТретийУровень;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	ТаблицаСоответствия.Свернуть("Профиль,Объект,ВидОперации");
	
КонецПроцедуры

Функция ПолучитьПравилаУточненияПоВидамОперации(Знач ОписаниеПрофилей, Знач УточняемыеПрофили, Знач ОписаниеОбъектов)
	
	СоответствиеПрофилей = Новый Соответствие;
		
	Для Каждого ПоставляемыйПрофиль Из ОписаниеПрофилей Цикл
		
		Если УточняемыеПрофили[ПоставляемыйПрофиль.Имя] <> Неопределено Тогда  
			
			СоответствиеОбъектов = Новый Соответствие;
			
			Для Каждого Объект Из ОписаниеОбъектов Цикл
				
				ВидыОперацийСоответствие = Новый Соответствие();
				
				ВидыОперацийСоответствие.Вставить(ПоставляемыйПрофиль.Имя,
				ПолучитьМассивВидовОперацийПоТипуДокумента(ПоставляемыйПрофиль, Объект.Значение));
				
				СоответствиеПрофилей.Вставить(ПоставляемыйПрофиль.Имя, СоответствиеОбъектов);
				
				МассивВидовОпераций = Новый Массив;
				
				СоответствиеОбъектов.Вставить(Объект.Значение, МассивВидовОпераций);
				
				Для Каждого ВидОперации Из ВидыОперацийСоответствие[ПоставляемыйПрофиль.Имя] Цикл
					МассивВидовОпераций.Добавить(ВидОперации);
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СоответствиеПрофилей;
	
КонецФункции

Функция ПолучитьМассивВидовОперацийПоТипуДокумента(Профиль, ТипДокумента)
	
	Результат = Новый Массив;
	
	Если Профиль.Имя = "Закупки" Тогда
		
		Если ТипДокумента = Тип("ДокументСсылка.ПриходнаяНакладная") ИЛИ ТипДокумента = "ПриходнаяНакладная" Тогда
			
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПриходнаяНакладная.ПоступлениеОтПоставщика"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПриходнаяНакладная.ПриемНаКомиссию"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПриходнаяНакладная.ПриемВПереработку"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПриходнаяНакладная.ПриемНаОтветХранение"));
			
		ИначеЕсли ТипДокумента = Тип("ДокументСсылка.РасходнаяНакладная") ИЛИ ТипДокумента = "РасходнаяНакладная" Тогда
			
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходнаяНакладная.ВозвратПоставщику"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходнаяНакладная.ВозвратКомитенту"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходнаяНакладная.ВозвратИзПереработки"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходнаяНакладная.ВозвратСОтветХранения"))
			
		КонецЕсли;
		
	ИначеЕсли Профиль.Имя = "Продажи" Тогда
		
		Если ТипДокумента = Тип("ДокументСсылка.РасходнаяНакладная") ИЛИ ТипДокумента = "РасходнаяНакладная" Тогда
			
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходнаяНакладная.ПродажаПокупателю"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходнаяНакладная.ПередачаНаКомиссию"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходнаяНакладная.ПередачаВПереработку"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходнаяНакладная.ПередачаНаОтветХранение"));
			
		ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ПриходнаяНакладная") ИЛИ ТипДокумента = "ПриходнаяНакладная" Тогда
			
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПриходнаяНакладная.ВозвратОтПокупателя"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПриходнаяНакладная.ВозвратОтКомиссионера"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПриходнаяНакладная.ВозвратОтПереработчика"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПриходнаяНакладная.ВозвратСОтветХранения"));
			
		КонецЕсли;	
		
	ИначеЕсли Профиль.Имя = "Администратор" ИЛИ Профиль.Имя = "Деньги" ИЛИ Профиль.Имя = "ТолькоПросмотр" ИЛИ Профиль.Имя = "Налоги" Тогда
		
		Если ТипДокумента = Тип("ДокументСсылка.РасходнаяНакладная") ИЛИ ТипДокумента = "РасходнаяНакладная" Тогда
			
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходнаяНакладная.ПродажаПокупателю"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходнаяНакладная.ПередачаНаКомиссию"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходнаяНакладная.ПередачаВПереработку"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходнаяНакладная.ПередачаНаОтветХранение"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходнаяНакладная.ВозвратПоставщику"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходнаяНакладная.ВозвратКомитенту"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходнаяНакладная.ВозвратИзПереработки"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходнаяНакладная.ВозвратСОтветХранения"));
			
			
		ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ПриходнаяНакладная") ИЛИ ТипДокумента = "ПриходнаяНакладная" Тогда
			
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПриходнаяНакладная.ВозвратОтПокупателя"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПриходнаяНакладная.ВозвратОтКомиссионера"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПриходнаяНакладная.ВозвратОтПереработчика"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПриходнаяНакладная.ВозвратСОтветХранения"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПриходнаяНакладная.ПоступлениеОтПоставщика"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПриходнаяНакладная.ПриемНаКомиссию"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПриходнаяНакладная.ПриемВПереработку"));
			Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПриходнаяНакладная.ПриемНаОтветХранение"));
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьУточняемыеТипыДокументов()
	
	ОписаниеОбъектов = Новый Соответствие();
	ОписаниеОбъектов.Вставить("ПриходнаяНакладная", Тип("ДокументСсылка.ПриходнаяНакладная"));
	ОписаниеОбъектов.Вставить("РасходнаяНакладная", Тип("ДокументСсылка.РасходнаяНакладная"));
	
	Возврат ОписаниеОбъектов;
	
КонецФункции

Функция ПолучитьУточняемыеПрофилиПользователей()
	
	Результат = Новый Соответствие();
	
	Результат.Вставить("Продажи",        Истина);
	Результат.Вставить("Закупки",        Истина);
	Результат.Вставить("Деньги",         Истина);
	Результат.Вставить("Администратор",  Истина);
	Результат.Вставить("ТолькоПросмотр", Истина);
	Результат.Вставить("Налоги",         Истина);
	
	Возврат Результат;

КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
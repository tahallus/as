﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	ТаблицаСотрудники 			= Сотрудники.Выгрузить(,"НомерСтроки, Сотрудник, Период, КлючСвязи");
	ТаблицаНачисленияУдержания 	= НачисленияУдержания.Выгрузить(,"НомерСтроки, ВидНачисленияУдержания, Валюта, КлючСвязи");
	
	// Добавим колонки и заполним по ключу связи. 
	// Связь должна присутствовать обязательно и соответствовать только одному сотруднику.
	ТаблицаНачисленияУдержания.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ТаблицаНачисленияУдержания.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	Для каждого СтрокаНачисленияУдержания Из ТаблицаНачисленияУдержания Цикл
		
		МассивСтрокСотрудников = ТаблицаСотрудники.НайтиСтроки(Новый Структура("КлючСвязи", СтрокаНачисленияУдержания.КлючСвязи));
		
		Если МассивСтрокСотрудников.Количество() = 1 Тогда
			
			СтрокаНачисленияУдержания.Сотрудник	= МассивСтрокСотрудников[0].Сотрудник;
			СтрокаНачисленияУдержания.Период	= МассивСтрокСотрудников[0].Период;
			
		Иначе
			
			// Ошибочная связь, не должна встречаться, но проверку оставим
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'Неверное условие связи в строке №%1 табл. части ""Начислений и удержаний"".'"),
				СтрокаНачисленияУдержания.НомерСтроки);
			КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленияУдержания",
				СтрокаНачисленияУдержания.НомерСтроки, "НомерСтроки");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПриемНаРаботуСотрудники.НомерСтроки КАК НомерСтроки,
	|	ПриемНаРаботуСотрудники.Сотрудник КАК Сотрудник,
	|	ПриемНаРаботуСотрудники.Период КАК Период,
	|	ПриемНаРаботуСотрудники.КлючСвязи КАК КлючСвязи
	|ПОМЕСТИТЬ ТаблицаСотрудники
	|ИЗ
	|	&ТаблицаСотрудники КАК ПриемНаРаботуСотрудники
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаНачисленияУдержания.НомерСтроки КАК НомерСтроки,
	|	ТаблицаНачисленияУдержания.ВидНачисленияУдержания КАК ВидНачисленияУдержания,
	|	ТаблицаНачисленияУдержания.Валюта КАК Валюта,
	|	ТаблицаНачисленияУдержания.Сотрудник КАК Сотрудник,
	|	ТаблицаНачисленияУдержания.Период КАК Период
	|ПОМЕСТИТЬ ТаблицаНачисленияУдержания
	|ИЗ
	|	&ТаблицаНачисленияУдержания КАК ТаблицаНачисленияУдержания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаСотрудники.НомерСтроки КАК НомерСтроки,
	|	Сотрудники.Регистратор КАК Регистратор
	|ИЗ
	|	ТаблицаСотрудники КАК ТаблицаСотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники КАК Сотрудники
	|		ПО (Сотрудники.Организация = &Организация)
	|			И ТаблицаСотрудники.Сотрудник = Сотрудники.Сотрудник
	|			И ТаблицаСотрудники.Период = Сотрудники.Период
	|			И (Сотрудники.Регистратор <> &Ссылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаНачисленияУдержания.НомерСтроки КАК НомерСтроки,
	|	ПлановыеНачисленияИУдержания.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрСведений.ПлановыеНачисленияИУдержания КАК ПлановыеНачисленияИУдержания
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаНачисленияУдержания КАК ТаблицаНачисленияУдержания
	|		ПО (ПлановыеНачисленияИУдержания.Организация = &Организация)
	|			И ПлановыеНачисленияИУдержания.Сотрудник = ТаблицаНачисленияУдержания.Сотрудник
	|			И ПлановыеНачисленияИУдержания.ВидНачисленияУдержания = ТаблицаНачисленияУдержания.ВидНачисленияУдержания
	|			И ПлановыеНачисленияИУдержания.Валюта = ТаблицаНачисленияУдержания.Валюта
	|			И ПлановыеНачисленияИУдержания.Период = ТаблицаНачисленияУдержания.Период
	|			И (ПлановыеНачисленияИУдержания.Регистратор <> &Ссылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ТаблицаСотрудникиДублиСтрок.НомерСтроки) КАК НомерСтроки,
	|	ТаблицаСотрудникиДублиСтрок.Сотрудник КАК Сотрудник
	|ИЗ
	|	ТаблицаСотрудники КАК ТаблицаСотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаСотрудники КАК ТаблицаСотрудникиДублиСтрок
	|		ПО ТаблицаСотрудники.НомерСтроки <> ТаблицаСотрудникиДублиСтрок.НомерСтроки
	|			И ТаблицаСотрудники.Сотрудник = ТаблицаСотрудникиДублиСтрок.Сотрудник
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаСотрудникиДублиСтрок.Сотрудник
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки");
	
	
	Запрос.УстановитьПараметр("Ссылка", 					Ссылка);
	Запрос.Параметры.Вставить("Организация", 				Константы.УчетПоКомпании.Компания(Организация));
	Запрос.Параметры.Вставить("ТаблицаСотрудники", 			ТаблицаСотрудники);
	Запрос.Параметры.Вставить("ТаблицаНачисленияУдержания", ТаблицаНачисленияУдержания);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Регистр "Сотрудники".
	Если НЕ МассивРезультатов[2].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[2].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'В строке №%1 табл. части ""Сотрудники"" период действия приказа противоречит кадровому приказу ""%2"".'"),
				ВыборкаИзРезультатаЗапроса.НомерСтроки, ВыборкаИзРезультатаЗапроса.Регистратор);
			КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Сотрудники",
				ВыборкаИзРезультатаЗапроса.НомерСтроки, "Период");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
		КонецЦикла;
	КонецЕсли;

	// Регистр "Плановые начисления и удержания".
	Если НЕ МассивРезультатов[3].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[3].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'В строке №%1 табл. части ""Начисления и удержания"" период действия приказа противоречит кадровому приказу ""%2"".'"),
				ВыборкаИзРезультатаЗапроса.НомерСтроки, ВыборкаИзРезультатаЗапроса.Регистратор);
			КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленияУдержания",
				ВыборкаИзРезультатаЗапроса.НомерСтроки, "ВидНачисленияУдержания");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
		КонецЦикла;
	КонецЕсли;
	
	// Дубли строк.
	Если НЕ МассивРезультатов[4].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[4].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'В строке №%1 табл. части ""Сотрудники"" сотрудник указывается повторно.'"),
				ВыборкаИзРезультатаЗапроса.НомерСтроки);
			КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Сотрудники",
				ВыборкаИзРезультатаЗапроса.НомерСтроки, "Сотрудник");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Выполняет контроль противоречий.
//
Процедура ВыполнитьКонтроль(ДополнительныеСвойства, Отказ)
	
	Если Отказ Тогда
		Возврат;	
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.Сотрудник,
	|	ВложенныйЗапрос.НомерСтроки,
	|	Сотрудники.СтруктурнаяЕдиница
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаСотрудники.Сотрудник КАК Сотрудник,
	|		ТаблицаСотрудники.НомерСтроки КАК НомерСтроки,
	|		МАКСИМУМ(Сотрудники.Период) КАК Период
	|	ИЗ
	|		РегистрСведений.Сотрудники КАК Сотрудники
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаСотрудники КАК ТаблицаСотрудники
	|			ПО Сотрудники.Сотрудник = ТаблицаСотрудники.Сотрудник
	|				И (Сотрудники.Организация = &Организация)
	|				И Сотрудники.Период <= ТаблицаСотрудники.Период
	|				И (Сотрудники.Регистратор <> &Ссылка)
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ТаблицаСотрудники.Сотрудник,
	|		ТаблицаСотрудники.НомерСтроки) КАК ВложенныйЗапрос
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники КАК Сотрудники
	|		ПО ВложенныйЗапрос.Сотрудник = Сотрудники.Сотрудник
	|			И ВложенныйЗапрос.Период = Сотрудники.Период
	|			И (Сотрудники.Организация = &Организация)
	|ГДЕ
	|	Сотрудники.СтруктурнаяЕдиница <> ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВложенныйЗапрос.НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.Сотрудник,
	|	ВложенныйЗапрос.Сотрудник.Физлицо КАК Физлицо,
	|	ВложенныйЗапрос.НомерСтроки,
	|	Сотрудники.СтруктурнаяЕдиница,
	|	Сотрудники.Сотрудник КАК ПринятыйСотрудник
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаСотрудники.Сотрудник КАК Сотрудник,
	|		ТаблицаСотрудники.НомерСтроки КАК НомерСтроки,
	|		МАКСИМУМ(Сотрудники.Период) КАК ДатаПриема,
	|		Сотрудники.Сотрудник КАК ОсновнойСотрудник
	|	ИЗ
	|		РегистрСведений.Сотрудники КАК Сотрудники
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаСотрудники КАК ТаблицаСотрудники
	|			ПО (Сотрудники.Организация = &Организация)
	|				И (Сотрудники.Регистратор <> &Ссылка)
	|				И Сотрудники.Период <= ТаблицаСотрудники.Период
	|				И ТаблицаСотрудники.Сотрудник.Физлицо <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|				И Сотрудники.Сотрудник.Физлицо = ТаблицаСотрудники.Сотрудник.Физлицо
	|				И (ТаблицаСотрудники.Сотрудник.ТипЗанятости = ЗНАЧЕНИЕ(Перечисление.ТипыЗанятости.ОсновноеМестоРаботы))
	|				И (Сотрудники.Сотрудник.ТипЗанятости = ЗНАЧЕНИЕ(Перечисление.ТипыЗанятости.ОсновноеМестоРаботы))
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ТаблицаСотрудники.Сотрудник,
	|		ТаблицаСотрудники.НомерСтроки,
	|		Сотрудники.Сотрудник) КАК ВложенныйЗапрос
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники КАК Сотрудники
	|		ПО (Сотрудники.Организация = &Организация)
	|			И ВложенныйЗапрос.ОсновнойСотрудник = Сотрудники.Сотрудник
	|			И ВложенныйЗапрос.ДатаПриема = Сотрудники.Период
	|ГДЕ
	|	Сотрудники.СтруктурнаяЕдиница <> ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВложенныйЗапрос.НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСотрудники.НомерСтроки,
	|	ТаблицаСотрудникиДубль.НомерСтроки КАК НомерСтрокиДубль,
	|	ТаблицаСотрудникиДубль.Сотрудник,
	|	ТаблицаСотрудники.Сотрудник.Физлицо КАК Физлицо
	|ИЗ
	|	
	|		ТаблицаСотрудники КАК ТаблицаСотрудники
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаСотрудники КАК ТаблицаСотрудникиДубль
	|			ПО ТаблицаСотрудники.Сотрудник.Физлицо = ТаблицаСотрудникиДубль.Сотрудник.Физлицо
	|				И ТаблицаСотрудники.Сотрудник.Физлицо <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|				И (ТаблицаСотрудники.Сотрудник.ТипЗанятости = ЗНАЧЕНИЕ(Перечисление.ТипыЗанятости.ОсновноеМестоРаботы))
	|				И (ТаблицаСотрудникиДубль.Сотрудник.ТипЗанятости = ЗНАЧЕНИЕ(Перечисление.ТипыЗанятости.ОсновноеМестоРаботы))
	|				И ТаблицаСотрудникиДубль.НомерСтроки > ТаблицаСотрудники.НомерСтроки
	|	
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаСотрудники.НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСотрудники.НомерСтроки,
	|	Сотрудники.Сотрудник
	|ИЗ
	|	
	|		ТаблицаСотрудники КАК ТаблицаСотрудники
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники КАК Сотрудники
	|			ПО ТаблицаСотрудники.Сотрудник = Сотрудники.Сотрудник
	|				И (Сотрудники.Регистратор <> &Ссылка)
	|				И (Сотрудники.Регистратор ССЫЛКА Документ.ПриемНаРаботу)
	|
	|СГРУППИРОВАТЬ ПО
	|		Сотрудники.Сотрудник,
	|		ТаблицаСотрудники.НомерСтроки
	|		
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаСотрудники.НомерСтроки");
	
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", ДополнительныеСвойства.ДляПроведения.Организация);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Сотрудник уже принят на работу на дату приема.
	Если НЕ МассивРезультатов[0].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[0].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'В строке №%1 табл. части ""Сотрудники"" сотрудник %2 уже работает в подразделении %3.'"),
				ВыборкаИзРезультатаЗапроса.НомерСтроки, ВыборкаИзРезультатаЗапроса.Сотрудник,
				ВыборкаИзРезультатаЗапроса.СтруктурнаяЕдиница);
			КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Сотрудники",
				ВыборкаИзРезультатаЗапроса.НомерСтроки, "Сотрудник");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
		КонецЦикла;
	КонецЕсли;

	// Для Физлица Сотрудника, принимаемого на основное место работы, уже принят на основное место работы другой Сотрудник.
	Если НЕ МассивРезультатов[1].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'В строке №%1 табл. части ""Сотрудники"" для физлица %2 уже принят на основное место работы сотрудник %3 в подразделение %4.'"),
				ВыборкаИзРезультатаЗапроса.НомерСтроки, ВыборкаИзРезультатаЗапроса.Физлицо,
				ВыборкаИзРезультатаЗапроса.ПринятыйСотрудник, ВыборкаИзРезультатаЗапроса.СтруктурнаяЕдиница);
			КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Сотрудники",
				ВыборкаИзРезультатаЗапроса.НомерСтроки, "Сотрудник"); 
		КонецЦикла;
	КонецЕсли;

	// Для Физлица Сотрудника, принимаемого на основное место работы, в этом документе уже указан другой Сотрудник с
	// основным местом работы.
	Если НЕ МассивРезультатов[2].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[2].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'В строке №%1 табл. части ""Сотрудники"" для физлица %2 повторно принимается на основное место работы сотрудник %3. Физлицо уже указано в строке №%4.'"),
				ВыборкаИзРезультатаЗапроса.НомерСтроки, ВыборкаИзРезультатаЗапроса.Физлицо,
				ВыборкаИзРезультатаЗапроса.Сотрудник, ВыборкаИзРезультатаЗапроса.НомерСтрокиДубль);
			КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Сотрудники",
				ВыборкаИзРезультатаЗапроса.НомерСтрокиДубль, "Сотрудник");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
		КонецЦикла;
	КонецЕсли;

	// Сотрудник принимается повторно. 
	Если НЕ МассивРезультатов[3].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[3].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'В строке №%1 табл. части ""Сотрудники"": сотрудник %2 уже работал в компании. Для повторного приема на работу необходимо создать нового сотрудника.'"),
				ВыборкаИзРезультатаЗапроса.НомерСтроки, ВыборкаИзРезультатаЗапроса.Сотрудник);
			КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Сотрудники",
				ВыборкаИзРезультатаЗапроса.НомерСтроки, "Сотрудник");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Выполняет контроль штатного расписания.
//
Процедура ВыполнитьКонтрольШтатногоРасписания(ДополнительныеСвойства, Отказ) 
	
	Если Отказ ИЛИ НЕ Константы.ФункциональнаяОпцияВестиШтатноеРасписание.Получить() Тогда
		Возврат;	
	КонецЕсли; 
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ВЫБОР
	                      |		КОГДА ЕСТЬNULL(ИтогШтатноеРасписание.КоличествоСтавокПоШР, 0) - ЕСТЬNULL(ИтогЗанятоСтавок.ЗанимаемыхСтавок, 0) < 0
	                      |			ТОГДА ИСТИНА
	                      |		ИНАЧЕ ЛОЖЬ
	                      |	КОНЕЦ КАК ПротиворечиеШР,
	                      |	ВЫБОР
	                      |		КОГДА ИтогШтатноеРасписание.НомерСтроки ЕСТЬ NULL 
	                      |			ТОГДА ИтогЗанятоСтавок.НомерСтроки
	                      |		ИНАЧЕ ИтогШтатноеРасписание.НомерСтроки
	                      |	КОНЕЦ КАК НомерСтроки
	                      |ИЗ
	                      |	(ВЫБРАТЬ
	                      |		МаксимальныеПериодыШтатногоРасписания.НомерСтроки КАК НомерСтроки,
	                      |		ШтатноеРасписание.КоличествоСтавок КАК КоличествоСтавокПоШР,
	                      |		ШтатноеРасписание.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	                      |		ШтатноеРасписание.Должность КАК Должность,
	                      |		ШтатноеРасписание.Организация КАК Организация
	                      |	ИЗ
	                      |		(ВЫБРАТЬ
	                      |			ШтатноеРасписание.Организация КАК Организация,
	                      |			ШтатноеРасписание.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	                      |			ШтатноеРасписание.Должность КАК Должность,
	                      |			МАКСИМУМ(ШтатноеРасписание.Период) КАК Период,
	                      |			ПриемНаРаботуСотрудники.НомерСтроки КАК НомерСтроки
	                      |		ИЗ
	                      |			Документ.ПриемНаРаботу.Сотрудники КАК ПриемНаРаботуСотрудники
	                      |				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ШтатноеРасписание КАК ШтатноеРасписание
	                      |				ПО ПриемНаРаботуСотрудники.СтруктурнаяЕдиница = ШтатноеРасписание.СтруктурнаяЕдиница
	                      |					И ПриемНаРаботуСотрудники.Должность = ШтатноеРасписание.Должность
	                      |					И ПриемНаРаботуСотрудники.Период >= ШтатноеРасписание.Период
	                      |					И (ШтатноеРасписание.Организация = &Организация)
	                      |		ГДЕ
	                      |			ПриемНаРаботуСотрудники.Ссылка = &Ссылка
	                      |		
	                      |		СГРУППИРОВАТЬ ПО
	                      |			ШтатноеРасписание.Должность,
	                      |			ШтатноеРасписание.СтруктурнаяЕдиница,
	                      |			ШтатноеРасписание.Организация,
	                      |			ПриемНаРаботуСотрудники.НомерСтроки) КАК МаксимальныеПериодыШтатногоРасписания
	                      |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтатноеРасписание КАК ШтатноеРасписание
	                      |			ПО МаксимальныеПериодыШтатногоРасписания.Период = ШтатноеРасписание.Период
	                      |				И МаксимальныеПериодыШтатногоРасписания.Организация = ШтатноеРасписание.Организация
	                      |				И МаксимальныеПериодыШтатногоРасписания.СтруктурнаяЕдиница = ШтатноеРасписание.СтруктурнаяЕдиница
	                      |				И МаксимальныеПериодыШтатногоРасписания.Должность = ШтатноеРасписание.Должность) КАК ИтогШтатноеРасписание
	                      |		ПОЛНОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	                      |			Сотрудники.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	                      |			Сотрудники.Должность КАК Должность,
	                      |			СУММА(Сотрудники.ЗанимаемыхСтавок) КАК ЗанимаемыхСтавок,
	                      |			Сотрудники.Организация КАК Организация,
	                      |			МаксимальныеПериодыСотрудников.НомерСтроки КАК НомерСтроки
	                      |		ИЗ
	                      |			(ВЫБРАТЬ
	                      |				Сотрудники.Организация КАК Организация,
	                      |				МАКСИМУМ(Сотрудники.Период) КАК Период,
	                      |				ПриемНаРаботуСотрудники.НомерСтроки КАК НомерСтроки,
	                      |				Сотрудники.Сотрудник КАК Сотрудник,
	                      |				ПриемНаРаботуСотрудники.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	                      |				ПриемНаРаботуСотрудники.Должность КАК Должность
	                      |			ИЗ
	                      |				Документ.ПриемНаРаботу.Сотрудники КАК ПриемНаРаботуСотрудники
	                      |					ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники КАК Сотрудники
	                      |					ПО ПриемНаРаботуСотрудники.Период >= Сотрудники.Период
	                      |						И (Сотрудники.Организация = &Организация)
	                      |			ГДЕ
	                      |				ПриемНаРаботуСотрудники.Ссылка = &Ссылка
	                      |			
	                      |			СГРУППИРОВАТЬ ПО
	                      |				Сотрудники.Организация,
	                      |				ПриемНаРаботуСотрудники.НомерСтроки,
	                      |				Сотрудники.Сотрудник,
	                      |				ПриемНаРаботуСотрудники.СтруктурнаяЕдиница,
	                      |				ПриемНаРаботуСотрудники.Должность) КАК МаксимальныеПериодыСотрудников
	                      |				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники КАК Сотрудники
	                      |				ПО МаксимальныеПериодыСотрудников.Сотрудник = Сотрудники.Сотрудник
	                      |					И МаксимальныеПериодыСотрудников.СтруктурнаяЕдиница = Сотрудники.СтруктурнаяЕдиница
	                      |					И МаксимальныеПериодыСотрудников.Должность = Сотрудники.Должность
	                      |					И МаксимальныеПериодыСотрудников.Период = Сотрудники.Период
	                      |					И (Сотрудники.Организация = &Организация)
	                      |		ГДЕ
	                      |			Сотрудники.СтруктурнаяЕдиница <> ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	                      |		
	                      |		СГРУППИРОВАТЬ ПО
	                      |			Сотрудники.СтруктурнаяЕдиница,
	                      |			Сотрудники.Должность,
	                      |			Сотрудники.Организация,
	                      |			МаксимальныеПериодыСотрудников.НомерСтроки) КАК ИтогЗанятоСтавок
	                      |		ПО ИтогШтатноеРасписание.НомерСтроки = ИтогЗанятоСтавок.НомерСтроки
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	НомерСтроки");
						  
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", Константы.УчетПоКомпании.Компания(Организация));
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.ПротиворечиеШР Тогда
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'Строка №%1 табл. части ""Сотрудники"": в штатном расписании не предусмотрены ставки для приема сотрудника.'"),
				Выборка.НомерСтроки);
			КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Сотрудники", Выборка.НомерСтроки,
				"ЗанимаемыхСтавок");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// В обработчике события ОбработкаПроверкиЗаполнения документа выполняется
// копирование и обнуление проверяемых реквизитов для исключения стандартной
// проверки заполнения платформой и последующей проверки средствами встроенного языка.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	// Предварительный контроль
	ВыполнитьПредварительныйКонтроль(Отказ);	
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ПриемНаРаботу.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ПроведениеДокументовУНФ.ОтразитьДвижения("Сотрудники", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ПлановыеНачисленияИУдержания", ТаблицыДляДвижений, Движения, Отказ);
	
	// Запись наборов записей.
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Отражение текущих кадровых данных
	РегистрыСведений.ТекущиеКадровыеДанныеСотрудников.ОбновитьТекущиеКадровыеДанныеСотрудников(ЭтотОбъект);
	
	// Контроль
	ВыполнитьКонтроль(ДополнительныеСвойства, Отказ);
	ВыполнитьКонтрольШтатногоРасписания(ДополнительныеСвойства, Отказ);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Отражение текущих кадровых данных
	РегистрыСведений.ТекущиеКадровыеДанныеСотрудников.ОбновитьТекущиеКадровыеДанныеСотрудников(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
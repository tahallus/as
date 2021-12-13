﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользоватьАлкогольнуюПродукцию = ПолучитьФункциональнуюОпцию("ВестиСведенияДляДекларацийПоАлкогольнойПродукции");
	ВыгружатьРеквизитыАлкогольнойПродукции = Ложь;
	Элементы.ВыгружатьРеквизитыАлкогольнойПродукции.Видимость = ИспользоватьАлкогольнуюПродукцию;
	Элементы.ТоварыГруппаАлкоголь.Видимость = ВыгружатьРеквизитыАлкогольнойПродукции;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьБазуТоваров()
	
	Запрос = Обработки.УдалитьВыгрузкаБазыТоваровВТСД.НовыйЗапросЗаполнитьБазуТоваров();
	
	ТекТаблица = Запрос.Выполнить().Выгрузить();
	
	ЗначениеВРеквизитФормы(ТекТаблица, "ТаблицаВыгрузки");
	
КонецПроцедуры

&НаСервере
Функция ПолучитьМассивБазыТоваров()
	
	ТекТаблица = РеквизитФормыВЗначение("ТаблицаВыгрузки");
	
	МассивВыгрузки = Новый Массив();
	
	Для каждого СтрокаТЧ Из ТекТаблица Цикл
		ВыгружаемыйТовар = Новый Структура;
		ВыгружаемыйТовар.Вставить("Штрихкод", СтрокаТЧ.Штрихкод);
		ВыгружаемыйТовар.Вставить("Номенклатура", СтрокаТЧ.Номенклатура);
		ВыгружаемыйТовар.Вставить("ЕдиницаИзмерения", СтрокаТЧ.Партия);
		ВыгружаемыйТовар.Вставить("ХарактеристикаНоменклатуры", СтрокаТЧ.Характеристика);
		ВыгружаемыйТовар.Вставить("СерияНоменклатуры", "");
		ВыгружаемыйТовар.Вставить("Качество", "");
		ВыгружаемыйТовар.Вставить("Цена", "");
		ВыгружаемыйТовар.Вставить("Количество", 0);
			
		Если ВыгружатьРеквизитыАлкогольнойПродукции Тогда
			ВыгружаемыйТовар.Вставить("Алкоголь"                   , СтрокаТЧ.Алкоголь);
			ВыгружаемыйТовар.Вставить("Маркируемый"                , СтрокаТЧ.Маркируемый);
			ВыгружаемыйТовар.Вставить("КодВидаАлкогольнойПродукции", СтрокаТЧ.КодВидаАлкогольнойПродукции);
			ВыгружаемыйТовар.Вставить("КодАлкогольнойПродукции"    , "");
			ВыгружаемыйТовар.Вставить("ЕмкостьТары"                , СтрокаТЧ.ЕмкостьТары);
			ВыгружаемыйТовар.Вставить("Крепость"                   , СтрокаТЧ.Крепость);
			ВыгружаемыйТовар.Вставить("ИННПроизводителя"           , СтрокаТЧ.ИННПроизводителя);
			ВыгружаемыйТовар.Вставить("КПППроизводителя"           , СтрокаТЧ.КПППроизводителя);
		КонецЕсли;
		
		МассивВыгрузки.Добавить(ВыгружаемыйТовар);
	КонецЦикла;
	
	Возврат МассивВыгрузки;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьВыполнить()
	
	ЗаполнитьБазуТоваров();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьВыполнить()
	
	ЭтотОбъект.Доступность = Ложь; 
	
	ОповещенияПриВыгрузкеВТСД = Новый ОписаниеОповещения("ВыгрузитьВТСДЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьВыгрузкуДанныеВТСД(ОповещенияПриВыгрузкеВТСД, УникальныйИдентификатор,
		ПолучитьМассивБазыТоваров());
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьВТСДЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	ЭтотОбъект.Доступность = Истина; 
	
	Если РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр("ru = 'Данные успешно выгружены в ТСД.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	Иначе
		ПоказатьПредупреждение(Неопределено, РезультатВыполнения.ОписаниеОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгружатьРеквизитыАлкогольнойПродукцииПриИзменении(Элемент)
	
	Элементы.ТоварыГруппаАлкоголь.Видимость = ВыгружатьРеквизитыАлкогольнойПродукции;
	
КонецПроцедуры

#КонецОбласти

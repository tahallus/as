﻿
#Область Служебные

&НаКлиенте
Процедура ДобавитьДокументКакОснованиеСчетФактуры()
	
	ТекущиеДанные = Элементы.ОснованияНаРеализацию.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Недоступен Тогда 
		ПоказатьПредупреждение( , НСтр("ru='Этот документ уже выбран'"));
		Возврат;
	КонецЕсли;
	
	СтруктураВыбора = Новый Структура;
	СтруктураВыбора.Вставить("Документ", ТекущиеДанные.ПредставлениеДокумента);
	
	ОповеститьОВыборе(СтруктураВыбора);
	
КонецПроцедуры

&НаСервере
Функция МассивДокументовСВыставленнымиСчетамиФактура()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", Параметры.Ссылка);
	Запрос.УстановитьПараметр("Организация", Параметры.Организация);
	Запрос.УстановитьПараметр("Контрагент", Параметры.Контрагент);
	Запрос.УстановитьПараметр("Договор", Параметры.Договор);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОснованияСчетовФактур.ДокументОснование КАК Ссылка
	|ИЗ Документ.СчетФактура.ДокументыОснования КАК ОснованияСчетовФактур
	|ГДЕ ОснованияСчетовФактур.Ссылка <> &ТекущийДокумент
	|	И ОснованияСчетовФактур.Ссылка.Организация = &Организация
	|	И ОснованияСчетовФактур.Ссылка.Контрагент = &Контрагент
	|	И ОснованияСчетовФактур.Ссылка.Договор = &Договор
	|";
	
	ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаЗапроса.ВыгрузитьКолонку("Ссылка");
	
КонецФункции

#КонецОбласти

#Область Форма

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭлементыОтбора = ОснованияНаРеализацию.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы;
	
	ГруппаОтбораОрганизация = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(ЭлементыОтбора, "ГруппаОтбораОрганизация", ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбораОрганизация, "Организация", ВидСравненияКомпоновкиДанных.Равно, Параметры.Организация);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбораОрганизация, "Организация", ВидСравненияКомпоновкиДанных.НеРавно, Справочники.Организации.ПустаяСсылка());
	
	ГруппаОтбораКонтрагент = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(ЭлементыОтбора, "ГруппаОтбораКонтрагент", ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбораКонтрагент, "Контрагент", ВидСравненияКомпоновкиДанных.Равно, Параметры.Контрагент);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбораКонтрагент, "Контрагент", ВидСравненияКомпоновкиДанных.НеРавно, Справочники.Контрагенты.ПустаяСсылка());
	
	Если Параметры.ЕстьАвансы = Ложь Тогда
		
		ГруппаОтбораДоговор = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(ЭлементыОтбора, "ГруппаОтбораДоговор", ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбораДоговор, "Договор", ВидСравненияКомпоновкиДанных.Равно, Параметры.Договор);
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаОтбораДоговор, "Договор", ВидСравненияКомпоновкиДанных.НеРавно, Справочники.ДоговорыКонтрагентов.ПустаяСсылка());
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ОснованияНаРеализацию, "РеализацииДоступны", Параметры.ЕстьРеализация, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ОснованияНаРеализацию, "ОтчетКомитентуДоступен", Параметры.ЕстьОтчетКомитенту, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ОснованияНаРеализацию, "АвансыДоступны", Параметры.ЕстьАвансы, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ОснованияНаРеализацию, "ЭтоВозврат", Параметры.ЭтоВозврат, ВидСравненияКомпоновкиДанных.Равно, , Истина);
	
	МассивДокументов = МассивДокументовСВыставленнымиСчетамиФактура();
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ОснованияНаРеализацию, "ПредставлениеДокумента", МассивДокументов, ВидСравненияКомпоновкиДанных.НеВСписке, , Истина);
	
	ЗаголовокОрганизации = НСтр("ru ='Организация: %1'");
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДекорацияОтборОрганизация", "Заголовок", СтрШаблон(ЗаголовокОрганизации, Параметры.Организация));
	
	ЗаголовокКонтрагента = НСтр("ru ='Контрагент: %1 (%2)'");
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДекорацияОтборКонтрагентДоговор", "Заголовок", СтрШаблон(ЗаголовокКонтрагента, Параметры.Контрагент, Параметры.Договор));
	
КонецПроцедуры

#КонецОбласти

#Область Команды

&НаКлиенте
Процедура ВыбратьДокументОснование(Команда)
	
	ДобавитьДокументКакОснованиеСчетФактуры();
	
КонецПроцедуры

#КонецОбласти

#Область Команды

&НаКлиенте
Процедура ОснованияНаРеализациюВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ДобавитьДокументКакОснованиеСчетФактуры();
	
КонецПроцедуры

#КонецОбласти
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ПроцедурыЗаполненияДокумента

// Обработчик заполнения на основании документа ИнвентаризацияЗапасов.
//
// Параметры:
//  ДокументСсылкаИнвентаризацияЗапасов	 - ДокументСсылка.ИнвентаризацияЗапасов
//  ЗаполняетсяИзФормыДокумента - Булево - признак заполнения из формы
//
Процедура ЗаполнитьПоИнвентаризацииВсеРасхождения(ДокументСсылкаИнвентаризацияЗапасов, ЗаполняетсяИзФормыДокумента = Ложь) Экспорт
	
	Если Не ЗначениеЗаполнено(ДокументСсылкаИнвентаризацияЗапасов) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗаполняетсяИзФормыДокумента Тогда
		ДокументОснование = ДокументСсылкаИнвентаризацияЗапасов.Ссылка;
		Организация = ДокументСсылкаИнвентаризацияЗапасов.Организация;
		СтруктурнаяЕдиница = ДокументСсылкаИнвентаризацияЗапасов.СтруктурнаяЕдиница;
		Ячейка = ДокументСсылкаИнвентаризацияЗапасов.Ячейка;
		
		// ФО Использовать подсистему Производство.
		Если Не Константы.ФункциональнаяОпцияИспользоватьПодсистемуПроизводство.Получить()
			И СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.Подразделение Тогда
			ВызватьИсключение НСтр("ru = 'Нельзя ввести Оприходование запасов на основании инвентаризации запасов, т.к. недоступен вид деятельности Производство.'");
		КонецЕсли;
		
		Запасы.Очистить();
		СерииНоменклатуры.Очистить();
		СерииНоменклатурыОприходование.Очистить();
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МИНИМУМ(ИнвентаризацияЗапасов.НомерСтроки) КАК НомерСтроки,
	|	ИнвентаризацияЗапасов.Номенклатура КАК НоменклатураОприходование,
	|	ИнвентаризацияЗапасов.Характеристика КАК ХарактеристикаОприходование,
	|	ИнвентаризацияЗапасов.Партия КАК ПартияОприходование,
	|	ИнвентаризацияЗапасов.ЕдиницаИзмерения КАК ЕдиницаИзмеренияОприходование,
	|	МАКСИМУМ(ИнвентаризацияЗапасов.Количество - ИнвентаризацияЗапасов.КоличествоУчет) КАК КоличествоОтклонениеИнвентаризации,
	|	СУММА(ВЫБОР
	|			КОГДА ОприходованиеЗапасов.Количество ЕСТЬ NULL
	|				ТОГДА 0
	|			ИНАЧЕ ОприходованиеЗапасов.Количество
	|		КОНЕЦ + ВЫБОР
	|			КОГДА ПересортицаЗапасовОприходование.Количество ЕСТЬ NULL
	|				ТОГДА 0
	|			ИНАЧЕ ПересортицаЗапасовОприходование.Количество
	|		КОНЕЦ) КАК КоличествоОприходованное,
	|	СУММА(ВЫБОР
	|			КОГДА СписаниеЗапасов.Количество ЕСТЬ NULL
	|				ТОГДА 0
	|			ИНАЧЕ СписаниеЗапасов.Количество
	|		КОНЕЦ + ВЫБОР
	|			КОГДА ПересортицаЗапасовСписание.Количество ЕСТЬ NULL
	|				ТОГДА 0
	|			ИНАЧЕ ПересортицаЗапасовСписание.Количество
	|		КОНЕЦ) КАК КоличествоСписанное,
	|	ИнвентаризацияЗапасов.Цена КАК Цена,
	|	ИнвентаризацияЗапасов.КлючСвязи КАК КлючСвязи,
	|	ИнвентаризацияЗапасов.СерииНоменклатуры КАК СерииНоменклатурыОприходование
	|ИЗ
	|	Документ.ИнвентаризацияЗапасов.Запасы КАК ИнвентаризацияЗапасов
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ОприходованиеЗапасовЗапасы.Номенклатура КАК Номенклатура,
	|			ОприходованиеЗапасовЗапасы.Характеристика КАК Характеристика,
	|			ОприходованиеЗапасовЗапасы.Партия КАК Партия,
	|			СУММА(ОприходованиеЗапасовЗапасы.Количество) КАК Количество
	|		ИЗ
	|			Документ.ОприходованиеЗапасов.Запасы КАК ОприходованиеЗапасовЗапасы
	|		ГДЕ
	|			ОприходованиеЗапасовЗапасы.Ссылка.ДокументОснование = &ДокументОснование
	|			И ОприходованиеЗапасовЗапасы.Ссылка.Проведен
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ОприходованиеЗапасовЗапасы.Номенклатура,
	|			ОприходованиеЗапасовЗапасы.Характеристика,
	|			ОприходованиеЗапасовЗапасы.Партия) КАК ОприходованиеЗапасов
	|		ПО ИнвентаризацияЗапасов.Номенклатура = ОприходованиеЗапасов.Номенклатура
	|			И ИнвентаризацияЗапасов.Характеристика = ОприходованиеЗапасов.Характеристика
	|			И ИнвентаризацияЗапасов.Партия = ОприходованиеЗапасов.Партия
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			СписаниеЗапасовЗапасы.Номенклатура КАК Номенклатура,
	|			СписаниеЗапасовЗапасы.Характеристика КАК Характеристика,
	|			СписаниеЗапасовЗапасы.Партия КАК Партия,
	|			СУММА(СписаниеЗапасовЗапасы.Количество) КАК Количество
	|		ИЗ
	|			Документ.СписаниеЗапасов.Запасы КАК СписаниеЗапасовЗапасы
	|		ГДЕ
	|			СписаниеЗапасовЗапасы.Ссылка.ДокументОснование = &ДокументОснование
	|			И СписаниеЗапасовЗапасы.Ссылка.Проведен
	|		
	|		СГРУППИРОВАТЬ ПО
	|			СписаниеЗапасовЗапасы.Номенклатура,
	|			СписаниеЗапасовЗапасы.Характеристика,
	|			СписаниеЗапасовЗапасы.Партия) КАК СписаниеЗапасов
	|		ПО ИнвентаризацияЗапасов.Номенклатура = СписаниеЗапасов.Номенклатура
	|			И ИнвентаризацияЗапасов.Характеристика = СписаниеЗапасов.Характеристика
	|			И ИнвентаризацияЗапасов.Партия = СписаниеЗапасов.Партия
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ПересортицаЗапасовЗапасы.Номенклатура КАК Номенклатура,
	|			ПересортицаЗапасовЗапасы.Характеристика КАК Характеристика,
	|			ПересортицаЗапасовЗапасы.Партия КАК Партия,
	|			СУММА(ПересортицаЗапасовЗапасы.Количество) КАК Количество
	|		ИЗ
	|			Документ.ПересортицаЗапасов.Запасы КАК ПересортицаЗапасовЗапасы
	|		ГДЕ
	|			ПересортицаЗапасовЗапасы.Ссылка.ДокументОснование = &ДокументОснование
	|			И ПересортицаЗапасовЗапасы.Ссылка.Проведен
	|			И ПересортицаЗапасовЗапасы.Ссылка <> &ДокументСсылка
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ПересортицаЗапасовЗапасы.Номенклатура,
	|			ПересортицаЗапасовЗапасы.Характеристика,
	|			ПересортицаЗапасовЗапасы.Партия) КАК ПересортицаЗапасовСписание
	|		ПО ИнвентаризацияЗапасов.Номенклатура = ПересортицаЗапасовСписание.Номенклатура
	|			И ИнвентаризацияЗапасов.Характеристика = ПересортицаЗапасовСписание.Характеристика
	|			И ИнвентаризацияЗапасов.Партия = ПересортицаЗапасовСписание.Партия
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ПересортицаЗапасовЗапасы.НоменклатураОприходование КАК НоменклатураОприходование,
	|			ПересортицаЗапасовЗапасы.ХарактеристикаОприходование КАК ХарактеристикаОприходование,
	|			ПересортицаЗапасовЗапасы.ПартияОприходование КАК ПартияОприходование,
	|			СУММА(ПересортицаЗапасовЗапасы.Количество) КАК Количество
	|		ИЗ
	|			Документ.ПересортицаЗапасов.Запасы КАК ПересортицаЗапасовЗапасы
	|		ГДЕ
	|			ПересортицаЗапасовЗапасы.Ссылка.ДокументОснование = &ДокументОснование
	|			И ПересортицаЗапасовЗапасы.Ссылка.Проведен
	|			И ПересортицаЗапасовЗапасы.Ссылка <> &ДокументСсылка
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ПересортицаЗапасовЗапасы.НоменклатураОприходование,
	|			ПересортицаЗапасовЗапасы.ХарактеристикаОприходование,
	|			ПересортицаЗапасовЗапасы.ПартияОприходование) КАК ПересортицаЗапасовОприходование
	|		ПО ИнвентаризацияЗапасов.Номенклатура = ПересортицаЗапасовОприходование.НоменклатураОприходование
	|			И ИнвентаризацияЗапасов.Характеристика = ПересортицаЗапасовОприходование.ХарактеристикаОприходование
	|			И ИнвентаризацияЗапасов.Партия = ПересортицаЗапасовОприходование.ПартияОприходование
	|ГДЕ
	|	ИнвентаризацияЗапасов.Ссылка = &ДокументОснование
	|	И ИнвентаризацияЗапасов.Количество - ИнвентаризацияЗапасов.КоличествоУчет <> 0
	|	И ВЫБОР
	|			КОГДА ИнвентаризацияЗапасов.Партия <> ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка)
	|				ТОГДА ИнвентаризацияЗапасов.Партия.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПартий.СобственныеЗапасы)
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|
	|СГРУППИРОВАТЬ ПО
	|	ИнвентаризацияЗапасов.Номенклатура,
	|	ИнвентаризацияЗапасов.Характеристика,
	|	ИнвентаризацияЗапасов.Партия,
	|	ИнвентаризацияЗапасов.ЕдиницаИзмерения,
	|	ИнвентаризацияЗапасов.Цена,
	|	ИнвентаризацияЗапасов.КлючСвязи,
	|	ИнвентаризацияЗапасов.СерииНоменклатуры");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументСсылкаИнвентаризацияЗапасов);
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		ВызватьИсключение НСтр("ru = 'Нет данных для оформления пересортицы: в инвентаризации нет отклонений или все документы уже оформлены!'");
	КонецЕсли;
	
	ТЗСоответствиеКлючейСвязи = Новый ТаблицаЗначений;
	ТЗСоответствиеКлючейСвязи.Колонки.Добавить("КлючСвязиНовый", Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(10, 0)));
	ТЗСоответствиеКлючейСвязи.Колонки.Добавить("КлючСвязи", Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(10, 0)));
	ТЗСоответствиеКлючейСвязи.Колонки.Добавить("ЭтоСписание", Новый ОписаниеТипов("Булево"));
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		// Если нужно списать.
		Если Выборка.КоличествоОтклонениеИнвентаризации < 0 Тогда
			КоличествоОприходовать = Выборка.КоличествоОтклонениеИнвентаризации - Выборка.КоличествоОприходованное + Выборка.КоличествоСписанное;
			Если КоличествоОприходовать >= 0 Тогда
				Продолжить;
			КонецЕсли;
		// Если нужно оприходовать.
		Иначе
			КоличествоОприходовать = Выборка.КоличествоОтклонениеИнвентаризации - Выборка.КоличествоОприходованное + Выборка.КоличествоСписанное;
			Если КоличествоОприходовать <= 0 Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		СтрокаТабличнойЧасти = Запасы.Добавить();
		Если КоличествоОприходовать > 0 Тогда
			
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, Выборка);
			ЭтоСписание = Ложь;
			
		Иначе
			
			СтрокаТабличнойЧасти.Номенклатура = Выборка.НоменклатураОприходование;
			СтрокаТабличнойЧасти.Характеристика = Выборка.ХарактеристикаОприходование;
			СтрокаТабличнойЧасти.Партия = Выборка.ПартияОприходование;
			СтрокаТабличнойЧасти.ЕдиницаИзмерения = Выборка.ЕдиницаИзмеренияОприходование;
			СтрокаТабличнойЧасти.СерииНоменклатуры = Выборка.СерииНоменклатурыОприходование;
			
			КоличествоОприходовать = -КоличествоОприходовать;
			
			ЭтоСписание = Истина;
			
		КонецЕсли;
		
		СтрокаТабличнойЧасти.КлючСвязи = 0;
		ТабличныеЧастиУНФКлиентСервер.ЗаполнитьКлючСвязи(Запасы, СтрокаТабличнойЧасти, "КлючСвязи");
		
		НоваяСтрокаСоответствия = ТЗСоответствиеКлючейСвязи.Добавить();
		НоваяСтрокаСоответствия.КлючСвязиНовый = СтрокаТабличнойЧасти.КлючСвязи;
		НоваяСтрокаСоответствия.КлючСвязи = Выборка.КлючСвязи;
		НоваяСтрокаСоответствия.ЭтоСписание = ЭтоСписание;
		
		СтрокаТабличнойЧасти.Количество = КоличествоОприходовать;
		СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.Цена;
		
	КонецЦикла;
	
	Если Запасы.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Нет данных для оформления пересортицы: в инвентаризации нет отклонений или все документы уже оформлены!'");
	Иначе
		// Возможно повторное заполнение данными из того же документа. Табличная часть при этом не очищается, а строки добавляются.
		СерииНоменклатурыУНФ.ЗаполнитьТЧСерииНоменклатурыПоКлючуСвязиУстановитьНовыйКлючСвязи(ТЗСоответствиеКлючейСвязи, ЭтотОбъект, ДокументСсылкаИнвентаризацияЗапасов,,, "СерииНоменклатуры", Истина);
		СерииНоменклатурыУНФ.ЗаполнитьТЧСерииНоменклатурыПоКлючуСвязиУстановитьНовыйКлючСвязи(ТЗСоответствиеКлючейСвязи, ЭтотОбъект, ДокументСсылкаИнвентаризацияЗапасов,,, "СерииНоменклатурыОприходование", Ложь);
	КонецЕсли;
	
	СерииНоменклатурыУНФ.УдалитьСерииНоменклатурыВТабличнойЧастиВЗависимостиОтПолитики(ЭтотОбъект);
	
КонецПроцедуры

// Обработчик заполнения на основании документа ПриходныйОрдер.
//
// Параметры:
//  ДокументСсылкаПриходныйОрдер	 - ДокументСсылка.ПриходныйОрдер
//
Процедура ЗаполнитьПоПриходномуОрдеру(ДокументСсылкаПриходныйОрдер) Экспорт
	
	Организация = ДокументСсылкаПриходныйОрдер.Организация;
	СтруктурнаяЕдиница = ДокументСсылкаПриходныйОрдер.СтруктурнаяЕдиница;
	Ячейка = ДокументСсылкаПриходныйОрдер.Ячейка;
	
	Для Каждого ТекСтрокаЗапасы Из ДокументСсылкаПриходныйОрдер.Запасы Цикл
		НоваяСтрока = Запасы.Добавить();
		НоваяСтрока.НоменклатураОприходование = ТекСтрокаЗапасы.Номенклатура;
		НоваяСтрока.ХарактеристикаОприходование = ТекСтрокаЗапасы.Характеристика;
		НоваяСтрока.ПартияОприходование = ТекСтрокаЗапасы.Партия;
		НоваяСтрока.СерииНоменклатурыОприходование = ТекСтрокаЗапасы.СерииНоменклатуры;
		НоваяСтрока.ЕдиницаИзмеренияОприходование = ТекСтрокаЗапасы.ЕдиницаИзмерения;
		НоваяСтрока.КлючСвязи = ТекСтрокаЗапасы.КлючСвязи;
	КонецЦикла;
	
	СерииНоменклатурыУНФ.ЗаполнитьТЧСерииНоменклатурыПоКлючуСвязи(ЭтотОбъект, ДокументСсылкаПриходныйОрдер,,, "СерииНоменклатурыОприходование");
	СерииНоменклатурыУНФ.УдалитьСерииНоменклатурыВТабличнойЧастиВЗависимостиОтПолитики(ЭтотОбъект,,,"СерииНоменклатурыОприходование");
	
КонецПроцедуры

// Обработчик заполнения на основании документа ПриходныйОрдер.
//
// Параметры:
//  ДокументСсылкаПриходныйОрдер	 - ДокументСсылка.ПриходныйОрдер
//
Процедура ЗаполнитьПоПриемИПередачаВРемонт(ДокументСсылкаПриемИПередачаВРемонт) Экспорт
	
	Если Ложь Тогда
		ДокументСсылкаПриемИПередачаВРемонт = Документы.ПриемИПередачаВРемонт.ПустаяСсылка();
	КонецЕсли;
	
	Организация = ДокументСсылкаПриемИПередачаВРемонт.Организация;
	СтруктурнаяЕдиница = ДокументСсылкаПриемИПередачаВРемонт.СтруктурнаяЕдиница;
	ДокументОснование = ДокументСсылкаПриемИПередачаВРемонт;
	
	НоваяСтрока = Запасы.Добавить();
	НоваяСтрока.НоменклатураОприходование = ДокументСсылкаПриемИПередачаВРемонт.Номенклатура;
	НоваяСтрока.ХарактеристикаОприходование = ДокументСсылкаПриемИПередачаВРемонт.Характеристика;
	НоваяСтрока.КлючСвязи = 1;
	НоваяСтрока.Количество = 1;
	НоваяСтрока.ЕдиницаИзмеренияОприходование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НоваяСтрока.НоменклатураОприходование, "ЕдиницаИзмерения");
	
	Если ЗначениеЗаполнено(ДокументСсылкаПриемИПередачаВРемонт.Серия) Тогда
		НоваяСтрокаСН = СерииНоменклатурыОприходование.Добавить();
		НоваяСтрокаСН.Серия = ДокументСсылкаПриемИПередачаВРемонт.Серия;
		НоваяСтрокаСН.КлючСвязи = НоваяСтрока.КлючСвязи;
		
		НоваяСтрока.СерииНоменклатурыОприходование = СерииНоменклатурыУНФКлиентСервер.СтроковоеПредставлениеСерийНоменклатурыСтроки(СерииНоменклатурыОприходование, НоваяСтрокаСН.КлючСвязи);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура проверяет наличие розничной цены.
//
Процедура ПроверитьНаличиеРозничнойЦены(Отказ)
	
	Если СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.Розница
	 ИЛИ СтруктурнаяЕдиница.ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.РозницаСуммовойУчет Тогда
	 
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Дата", Дата);
		Запрос.УстановитьПараметр("ТаблицаДокумента", Запасы);
		Запрос.УстановитьПараметр("РозничныйВидЦен", СтруктурнаяЕдиница.РозничныйВидЦен);
		Запрос.УстановитьПараметр("СписокНоменклатура", Запасы.ВыгрузитьКолонку("НоменклатураОприходование"));
		Запрос.УстановитьПараметр("СписокХарактеристика", Запасы.ВыгрузитьКолонку("ХарактеристикаОприходование"));
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
		|	ТаблицаДокумента.НоменклатураОприходование КАК Номенклатура,
		|	ТаблицаДокумента.ХарактеристикаОприходование КАК Характеристика,
		|	ТаблицаДокумента.ПартияОприходование КАК Партия
		|ПОМЕСТИТЬ ПеремещениеЗапасовЗапасы
		|ИЗ
		|	&ТаблицаДокумента КАК ТаблицаДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПеремещениеЗапасовЗапасы.НомерСтроки КАК НомерСтроки,
		|	ПРЕДСТАВЛЕНИЕ(ПеремещениеЗапасовЗапасы.Номенклатура) КАК НоменклатураПредставление,
		|	ПРЕДСТАВЛЕНИЕ(ПеремещениеЗапасовЗапасы.Характеристика) КАК ХарактеристикаПредставление,
		|	ПРЕДСТАВЛЕНИЕ(ПеремещениеЗапасовЗапасы.Партия) КАК ПартияПредставление
		|ИЗ
		|	ПеремещениеЗапасовЗапасы КАК ПеремещениеЗапасовЗапасы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
		|				&Дата,
		|				ВидЦен = &РозничныйВидЦен
		|					И Номенклатура В (&СписокНоменклатура)
		|					И Характеристика В (&СписокХарактеристика)) КАК ЦеныНоменклатурыСрезПоследних
		|		ПО ПеремещениеЗапасовЗапасы.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
		|			И ПеремещениеЗапасовЗапасы.Характеристика = ЦеныНоменклатурыСрезПоследних.Характеристика
		|ГДЕ
		|	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0) = 0";
		
		ВыборкаРезультатаЗапроса = Запрос.Выполнить().Выбрать();
		
		Пока ВыборкаРезультатаЗапроса.Следующий() Цикл
			
			ПредставлениеНоменклатуры = Справочники.Номенклатура.Представление(
				ВыборкаРезультатаЗапроса.НоменклатураПредставление,
				ВыборкаРезультатаЗапроса.ХарактеристикаПредставление,
				ВыборкаРезультатаЗапроса.ПартияПредставление);
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'Для номенклатуры %1 в строке %2 списка ""Запасы"" не установлена розничная цена.'"),
				ПредставлениеНоменклатуры, ВыборкаРезультатаЗапроса.НомерСтроки);
			КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Запасы",
				ВыборкаРезультатаЗапроса.НомерСтроки, "НоменклатураОприходование");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры // ПроверитьНаличиеРозничнойЦены()

Процедура ПроверитьДополнительныеПоляГТД(Отказ)
	Перем Ошибки;
	
	Если НЕ ПолучитьФункциональнуюОпцию("УчетГТД") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Для каждого СтрокаТаблицыДокумента Из Запасы Цикл
		
		СтранаПроисхожденияТребуетНомерГТД = (ЗначениеЗаполнено(СтрокаТаблицыДокумента.СтранаПроисхожденияОприходование) И СтрокаТаблицыДокумента.СтранаПроисхожденияОприходование <> Справочники.СтраныМира.Россия);
		
		Если ЗначениеЗаполнено(СтрокаТаблицыДокумента.НомерГТДОприходование)
			И НЕ СтранаПроисхожденияТребуетНомерГТД
			Тогда
			
			ТекстОшибки = СтрШаблон(НСтр("ru = 'В строке [%1] табличной части %2 не верно указана страна происхождения для оприходования'"), СокрЛП(СтрокаТаблицыДокумента.НомерСтроки), "Запасы");
			ПолеОшибки = "Объект.Запасы[%1].СтранаПроисхожденияОприходование";
			
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, ПолеОшибки, ТекстОшибки, "", Запасы.Индекс(СтрокаТаблицыДокумента));
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицыДокумента.НомерГТДОприходование)
			И СтранаПроисхожденияТребуетНомерГТД
			Тогда
			
			ТекстОшибки = СтрШаблон(НСтр("ru = 'В строке [%1] табличной части %2 не указан номер ГТД оприходования'"), СокрЛП(СтрокаТаблицыДокумента.НомерСтроки), "Запасы");
			ПолеОшибки = "Объект.Запасы[%1].НомерГТДОприходование";
			
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, ПолеОшибки, ТекстОшибки, "", Запасы.Индекс(СтрокаТаблицыДокумента));
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если НЕ Ошибки = Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// В обработчике события ОбработкаЗаполнения документа выполняется
// - заполнение документа по инвентаризации запасов на складе.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.ИнвентаризацияЗапасов")] = "ЗаполнитьПоИнвентаризацииВсеРасхождения";
	СтратегияЗаполнения[Тип("ДокументСсылка.ПриходныйОрдер")] = "ЗаполнитьПоПриходномуОрдеру";
	СтратегияЗаполнения[Тип("ДокументСсылка.ПриемИПередачаВРемонт")] = "ЗаполнитьПоПриемИПередачаВРемонт";
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа
	Документы.ПересортицаЗапасов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ПроведениеДокументовУНФ.ОтразитьДвижения("ЗапасыКРасходуСоСкладов", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ЗапасыКПоступлениюНаСклады", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ЗапасыНаСкладах", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("Запасы", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ЗапасыВРазрезеГТД", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДоходыИРасходы", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьУправленческий(ДополнительныеСвойства, Движения, Отказ);
	
	// СерииНоменклатуры
	ПроведениеДокументовУНФ.ОтразитьДвижения("СерииНоменклатурыГарантии", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДвиженияСерииНоменклатуры", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("СерииНоменклатуры", ТаблицыДляДвижений, Движения, Отказ);
	
	// Запись наборов записей
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль
	Документы.ПересортицаЗапасов.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	// Контроль
	Документы.ПересортицаЗапасов.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Проверка наличия розничной цены.
	ПроверитьНаличиеРозничнойЦены(Отказ);
	
	// Серии номенклатуры
	Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктурнаяЕдиница,"ОрдерныйСклад") = Истина Тогда
		СерииНоменклатурыУНФ.ПроверкаЗаполненияСерийНоменклатуры(Отказ, Запасы, СерииНоменклатуры, СтруктурнаяЕдиница, ЭтотОбъект);
		СерииНоменклатурыУНФ.ПроверкаЗаполненияСерийНоменклатуры(Отказ, Запасы, СерииНоменклатурыОприходование, СтруктурнаяЕдиница, ЭтотОбъект,, "НоменклатураОприходование");
	КонецЕсли;
	
	Если ПриходоватьТоварыПоСебестоимостиСписания Тогда
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Запасы.Цена");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Запасы.Сумма");
	КонецЕсли;
	
	НоменклатураВДокументахСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, Отказ, Истина);
	
	ГрузовыеТаможенныеДекларацииСервер.ПриОбработкеПроверкиЗаполнения(Отказ, ЭтотОбъект);
	ПроверитьДополнительныеПоляГТД(Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	// Проверка признака ОбменДанными.Загрузка выполняется ниже по коду.
	
	// ИнтеграцияГИСМ
	ЕстьМаркируемаяПродукцияГИСМ = ИнтеграцияГИСМУНФ.ЕстьМаркируемаяПродукцияГИСМ(Запасы);
	ЕстьКиЗГИСМ = ИнтеграцияГИСМУНФ.ЕстьКиЗГИСМ(Запасы);
	// Конец ИнтеграцияГИСМ
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПриходоватьТоварыПоСебестоимостиСписания Тогда
		СуммаДокумента = 0;
	Иначе
		СуммаДокумента = Запасы.Итог("Сумма");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ПереданВЕГАИС = Неопределено;
	АктСписанияЕГАИС = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
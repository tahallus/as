﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	ЗаполнениеОтветственныхЛиц();
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события ПередЗаписью.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроизводствоСервер.ЗаполнитьКлючиСвязи(Запасы);
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		
		ЗначенияРеквизитовНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Номенклатура,
			"ИспользоватьПартии, ПроверятьЗаполнениеПартий, ИспользоватьХарактеристики, ПроверятьЗаполнениеХарактеристики, ИспользоватьСерииНоменклатуры", Истина);
		
		// Серии номенклатуры
		Если СерииНоменклатурыУНФ.ИспользоватьСерииНоменклатурыОстатки() = Истина Тогда
			ОрдерныйСклад = ПолучитьФункциональнуюОпцию("ИспользоватьОрдерныйСклад") 
				И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктурнаяЕдиница, "ОрдерныйСклад", Истина);
			Если ЗначенияРеквизитовНоменклатуры.ИспользоватьСерииНоменклатуры И НЕ ОрдерныйСклад Тогда
				Если ТипЗнч(ЕдиницаИзмерения) = Тип("СправочникСсылка.ЕдиницыИзмерения") Тогда
					Коэффициент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЕдиницаИзмерения, "Коэффициент");
				Иначе
					Коэффициент = 1;
				КонецЕсли;
				ПродукцияКоличество = Количество * Коэффициент;
				
				КонтрольКоличестваСерий = СерииНоменклатурыУНФ.КонтролироватьЗаполнениеСерии(Номенклатура, Организация, СтруктурнаяЕдиница);
				
				Если КонтрольКоличестваСерий Тогда
					Если Не СерииНоменклатуры.Итог("Количество") = ПродукцияКоличество Тогда
						ТекстОшибки = НСтр("ru = 'Число серий номенклатуры не равно количеству.'");
						ПолеОшибки = "Объект.Количество";
						ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , ПолеОшибки, , Отказ);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли; 
		КонецЕсли; 
		СерииНоменклатурыУНФ.ПроверкаЗаполненияСерийНоменклатуры(Отказ, Запасы, СерииНоменклатурыЗапасы, СтруктурнаяЕдиница, ЭтотОбъект);
		
		// Характеристики и партии
		ИспользоватьХарактеристики = ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристики");
		ИспользоватьПартии = ПолучитьФункциональнуюОпцию("ИспользоватьПартии");
		Если ИспользоватьХарактеристики И ЗначенияРеквизитовНоменклатуры.ИспользоватьХарактеристики 
			И ЗначенияРеквизитовНоменклатуры.ПроверятьЗаполнениеХарактеристики Тогда
			ПроверяемыеРеквизиты.Добавить("Характеристика");
		КонецЕсли; 
		Если ИспользоватьПартии И ЗначенияРеквизитовНоменклатуры.ИспользоватьПартии 
			И ЗначенияРеквизитовНоменклатуры.ПроверятьЗаполнениеПартий Тогда
			ПроверяемыеРеквизиты.Добавить("Партия");
		КонецЕсли;
		НоменклатураВДокументахСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, Отказ, Истина);
		
		// ГТД
		УчетГТД = ПолучитьФункциональнуюОпцию("УчетГТД");
		СтранаПроисхожденияТребуетНомерГТД = ЗначениеЗаполнено(СтранаПроисхождения)
			И СтранаПроисхождения <> Справочники.СтраныМира.Россия;
		Если УчетГТД И Константы.ТребоватьЗаполнениеГТДИмпортногоТовара.Получить() И СтранаПроисхожденияТребуетНомерГТД
			И ВидОперации = Перечисления.ВидыОперацийКомплектацияЗапасов.Разборка Тогда
			ПроверяемыеРеквизиты.Добавить("НомерГТД");
		КонецЕсли;
		Если НЕ СтранаПроисхожденияТребуетНомерГТД И ЗначениеЗаполнено(НомерГТД) Тогда
			ТекстОшибки = НСтр("ru = 'Не верно указана страна происхождения'");
			ПолеОшибки = "Объект.СтранаПроисхождения";
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , ПолеОшибки, , Отказ);
		КонецЕсли; 
		ГрузовыеТаможенныеДекларацииСервер.ПриОбработкеПроверкиЗаполнения(Отказ, ЭтотОбъект);
		
		ПроверитьТЧНаСовпадениеНоменклатуры(Отказ);
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа
	Документы.КомплектацияЗапасов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ПроведениеДокументовУНФ.ОтразитьДвижения("Запасы", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ЗапасыВРазрезеГТД", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ЗапасыНаСкладах", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ЗапасыКПоступлениюНаСклады", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ЗапасыКРасходуСоСкладов", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ВыпускПродукции", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("СуммовойУчетВРознице", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьУправленческий(ДополнительныеСвойства, Движения, Отказ);
	
	// СерииНоменклатуры
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДвиженияСерииНоменклатуры", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("СерииНоменклатуры", ТаблицыДляДвижений, Движения, Отказ);
	
	// Запись наборов записей
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль
	Документы.КомплектацияЗапасов.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Этапы производства
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 

	// Инициализация дополнительных свойств для проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль
	Документы.КомплектацияЗапасов.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ПроцедурыЗаполненияДокумента

Процедура ЗаполнитьТабличнуюЧастьПоКомплектации() Экспорт
	
	Запасы.Очистить();
	Если НЕ ЗначениеЗаполнено(Комплектация) Тогда
		Возврат;
	КонецЕсли; 
	
	КоличествоПродукции = Количество * ?(ТипЗнч(ЕдиницаИзмерения) = Тип("СправочникСсылка.ЕдиницыИзмерения"), ЕдиницаИзмерения.Коэффициент, 1);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Комплектация", Комплектация);
	Запрос.УстановитьПараметр("КоличествоПродукции", КоличествоПродукции);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КомплектацииНоменклатурыСостав.Номенклатура КАК Номенклатура,
	|	КомплектацииНоменклатурыСостав.Характеристика КАК Характеристика,
	|	КомплектацииНоменклатурыСостав.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВЫРАЗИТЬ(КомплектацииНоменклатурыСостав.Количество * &КоличествоПродукции / ВЫБОР
	|			КОГДА КомплектацииНоменклатурыСостав.КоличествоПродукции = 0
	|				ТОГДА 1
	|			ИНАЧЕ КомплектацииНоменклатурыСостав.КоличествоПродукции
	|		КОНЕЦ КАК ЧИСЛО(15, 3)) КАК Количество,
	|	КомплектацииНоменклатурыСостав.ДоляСтоимости КАК ДоляСтоимости,
	|	ВЫБОР
	|		КОГДА ФункциональнаяОпцияУчетГТД.Значение
	|			ТОГДА КомплектацииНоменклатурыСостав.Номенклатура.СтранаПроисхождения
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СтраныМира.ПустаяСсылка)
	|	КОНЕЦ КАК СтранаПроисхождения
	|ИЗ
	|	Справочник.КомплектацииНоменклатуры.Состав КАК КомплектацииНоменклатурыСостав,
	|	Константа.ФункциональнаяОпцияУчетГТД КАК ФункциональнаяОпцияУчетГТД
	|ГДЕ
	|	КомплектацииНоменклатурыСостав.Ссылка = &Комплектация";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.Количество = 0 Тогда
			Продолжить;
		КонецЕсли; 	
		НоваяСтрока = Запасы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	КонецЦикла; 
	
	СтатусПартии = Новый СписокЗначений;
	СтатусПартии.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыПартий.СобственныеЗапасы"));
	
	Для каждого СтрокаТабличнойЧасти Из Запасы Цикл
		
		СтрокаТабличнойЧасти.Партия = ?(ЗначениеЗаполнено(СтрокаТабличнойЧасти.Номенклатура), 
			НоменклатураВДокументахСервер.ЗначенияПартийНоменклатурыПоУмолчанию(СтрокаТабличнойЧасти.Номенклатура, 
			СтатусПартии), Неопределено);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

// Процедура - Проверка использования в продукции и материалах одинаковых запасов
//
// Параметры:
//  Отказ	 - 	Булево - Признак отказа проведения, устанавливается, если проверка не пройдена
//
Процедура ПроверитьТЧНаСовпадениеНоменклатуры(Отказ)
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("Номенклатура", Номенклатура);
	СтруктураПоиска.Вставить("Характеристика", Характеристика);
	СтруктураПоиска.Вставить("Партия", Партия);
	НайденныеСтроки = Запасы.НайтиСтроки(СтруктураПоиска);
	Если НайденныеСтроки.Количество() > 0 Тогда
		СтрокаТаблицы = НайденныеСтроки[0];
		ТекстСообщения = НСтр(
		"ru = 'В таблице товаров присутствует сам комплект. Такой режим комплектации
		|не поддерживается, он может приводить к ошибкам расчета фактической себестоимости
		|при закрытии месяца. Следует использовать дополнительные разрезы учета для разделения 
		|комплекта и комплектующих (характеристики, партии)'");
		КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Запасы", СтрокаТаблицы.НомерСтроки,
			"Номенклатура");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле);
	КонецЕсли; 
	
КонецПроцедуры

#Область ПроцедурыЗаполненияДокумента

Процедура ЗаполнениеОтветственныхЛиц()
	
	ПодписьКладовщика = СтруктурнаяЕдиница.ПодписьМОЛ;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти 

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
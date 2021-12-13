﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с номенклатурой".
// ОбщийМодуль.РаботаСНоменклатуройСлужебныйКлиентСервер.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбщегоНазначения

// Сравнивает данные сложной структуры с учетом вложенности.
//
// Параметры:
//  Данные1 - Структура,    ФиксированнаяСтруктура,
//            Соответствие, ФиксированноеСоответствие,
//            Массив,       ФиксированныйМассив,
//            ХранилищеЗначения,
//            Строка, Число, Булево - сравниваемые данные.
//
//  Данные2 - Произвольный - те же типы, что и для параметра Данные1.
//
// Возвращаемое значение:
//  Булево - Истина, если совпадают.
//
Функция ДанныеСовпадают(Данные1, Данные2) Экспорт
	
	Если ТипЗнч(Данные1) <> ТипЗнч(Данные2) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Данные1) = Тип("Структура")
	 ИЛИ ТипЗнч(Данные1) = Тип("ФиксированнаяСтруктура") Тогда
		
		Если Данные1.Количество() <> Данные2.Количество() Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Для каждого КлючИЗначение Из Данные1 Цикл
			СтароеЗначение = Неопределено;
			
			Если НЕ Данные2.Свойство(КлючИЗначение.Ключ, СтароеЗначение)
			 ИЛИ НЕ ДанныеСовпадают(КлючИЗначение.Значение, СтароеЗначение) Тогда
			
				Возврат Ложь;
			КонецЕсли;
		КонецЦикла;
		
		Возврат Истина;
		
	ИначеЕсли ТипЗнч(Данные1) = Тип("Соответствие")
	      ИЛИ ТипЗнч(Данные1) = Тип("ФиксированноеСоответствие") Тогда
		
		Если Данные1.Количество() <> Данные2.Количество() Тогда
			Возврат Ложь;
		КонецЕсли;
		
		КлючиНовогоСоответствия = Новый Соответствие;
		
		Для каждого КлючИЗначение Из Данные1 Цикл
			КлючиНовогоСоответствия.Вставить(КлючИЗначение.Ключ, Истина);
			СтароеЗначение = Данные2.Получить(КлючИЗначение.Ключ);
			
			Если НЕ ДанныеСовпадают(КлючИЗначение.Значение, СтароеЗначение) Тогда
				Возврат Ложь;
			КонецЕсли;
		КонецЦикла;
		
		Для каждого КлючИЗначение Из Данные2 Цикл
			Если КлючиНовогоСоответствия[КлючИЗначение.Ключ] = Неопределено Тогда
				Возврат Ложь;
			КонецЕсли;
		КонецЦикла;
		
		Возврат Истина;
		
	ИначеЕсли ТипЗнч(Данные1) = Тип("Массив")
	      ИЛИ ТипЗнч(Данные1) = Тип("ФиксированныйМассив") Тогда
		
		Если Данные1.Количество() <> Данные2.Количество() Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Индекс = Данные1.Количество()-1;
		Пока Индекс >= 0 Цикл
			Если НЕ ДанныеСовпадают(Данные1.Получить(Индекс), Данные2.Получить(Индекс)) Тогда
				Возврат Ложь;
			КонецЕсли;
			Индекс = Индекс - 1;
		КонецЦикла;
		
		Возврат Истина;
		
	ИначеЕсли ТипЗнч(Данные1) = Тип("ХранилищеЗначения") Тогда
	
		Если НЕ ДанныеСовпадают(Данные1.Получить(), Данные2.Получить()) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Возврат Истина;
	КонецЕсли;
	
	Возврат Данные1 = Данные2;
	
КонецФункции

// Возвращает массив, состоящий из элементов, повторяющихся в обоих входящих массивах
// Массив1 имеет приоритет в порядке следования элементов
Функция ПересечениеМассивов(Знач Массив1, Знач Массив2) Экспорт 
	
	Результат          = Новый Массив;
	УникальныеЗначения = Новый Соответствие;
	Для каждого ЭлементМассива Из Массив2 Цикл
		УникальныеЗначения.Вставить(ЭлементМассива, 0);
	КонецЦикла;
	Для каждого ЭлементМассива Из Массив1 Цикл
		Если УникальныеЗначения.Получить(ЭлементМассива) = 0 Тогда
			Результат.Добавить(ЭлементМассива);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

#КонецОбласти

#Область РаботаСКатегориями

Функция ЕстьКорневыеКатегорииВКэше(КэшКатегорий) Экспорт
	
	Результат = КэшКатегорий.Свойство("_");
	
	Возврат Результат;
	
КонецФункции

// Находит текущую ветку на форме в дереве категорий.
//
// Параметры:
//    Категории              - ДанныеФормыДерево        - дерево категорий на форме.
//    ИдентификаторКатегории - Строка                   - идентификатор строки категории.
//    ТекущаяВетка           - ДанныеФормыЭлементДерева - строка выбранной категории в дереве категорий.
//    ТребуетсяЗагрузка      - Булево                   - признак необходимости загрузки категорий.
//    ПоискКатегории         - Булево                   - признак необходимости найти категорию без дополнительной информации о загрузке.
//    ВеткаРодителя          - ДанныеФормыЭлементДерева - строка родителя выбранной категории в дереве категорий.
//
Процедура ПодготовитьТекущуюВеткуКатегории(Категории, Знач ИдентификаторКатегории, ТекущаяВетка,
			ТребуетсяЗагрузка = Истина, Знач ПоискКатегории = Ложь, ВеткаРодителя = Неопределено) Экспорт
	
	Если ИдентификаторКатегории <> Неопределено Тогда
		Для Каждого СтрокаВетки Из Категории.ПолучитьЭлементы() Цикл
			Если СтрокаВетки.Идентификатор = ИдентификаторКатегории Тогда
				Если Не ПоискКатегории Тогда
					Если СтрокаВетки.ДочерниеПодгружены Тогда
						ТекущаяВетка = СтрокаВетки;
						ТребуетсяЗагрузка = Ложь;
						Возврат;
					КонецЕсли;
					СтрокаВетки.ВОбработке = Истина;
				КонецЕсли;
				ТекущаяВетка = СтрокаВетки;
			Иначе
				СледующаяВетка = СтрокаВетки.ПолучитьЭлементы();
				Если СледующаяВетка.Количество() > 0 И НЕ СледующаяВетка[0].ПустаяГруппа Тогда
					ПодготовитьТекущуюВеткуКатегории(СтрокаВетки, ИдентификаторКатегории, ТекущаяВетка, ТребуетсяЗагрузка, ПоискКатегории, ВеткаРодителя);
					Если ТекущаяВетка <> Неопределено И ВеткаРодителя = Неопределено Тогда
						ВеткаРодителя = СтрокаВетки;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает видимость области категорий.
//
// Параметры:
//   Элементы           - ВсеЭлементыФормы.
//   РубрикаторЗаполнен - Булево - признак наличия в дереве категорий строк.
//
Процедура УстановитьВидимостьОбластиКатегорий(Элементы, РубрикаторЗаполнен) Экспорт
	
	Элементы.ГруппаСтраницКатегорий.ТекущаяСтраница = ?(РубрикаторЗаполнен,
		Элементы.ГруппаСтраницаКатегорий, Элементы.ГруппаСтраницаПустыхКатегорий);

КонецПроцедуры

// Устанавливает видимость области отборов.
//
// Параметры:
//   Элементы               - ВсеЭлементыФормы.
//   ДеревоОтборовЗаполнено - Булево - признак наличия в дереве отборов строк.
//
Процедура УстановитьВидимостьЗаполненностиДереваОтборов(Элементы, ДеревоОтборовЗаполнено) Экспорт
	
	Элементы.ГруппаСтраницыДереваОтборов.ТекущаяСтраница = ?(ДеревоОтборовЗаполнено,
		Элементы.ГруппаДеревоОтборов, Элементы.ГруппаПустоеДеревоОтборов);

КонецПроцедуры

// Параметры формы сопоставления номенклатуры с рубрикатором 1С:Номенклатура
// 
// Возвращаемое значение:
//  Структура - параметры формы.
//   Ключи:
//    * СценарийИспользования - Строка - 
//       - ПубликацияТорговыхПредложенийБезКонтекста - открытие из подсистемы
//           "ЭлектронноеВзаимодействие.ТорговыеПредложения" без отборов.
//       - ПубликацияТорговыхПредложений - открытие из подсистемы 
//           "ЭлектронноеВзаимодействие.ТорговыеПредложения" с отборами.
//       - ВыгрузкаНоменклатуры - открытие из подсистемы 
//           "ЭлектронноеВзаимодействие.РаботаСНоменклатурой" для выгрузки номенклатуры.
//    * НастройкиОтбора - НастройкиКомпоновкиДанных - содержит настройки отбора номенклатуры.
//    * Номенклатура - Массив из ОпределяемыйТип.НоменклатураРаботаСНоменклатурой - массив номенклатуры для которой
//                     требуется установить отбор.
//    * ВидыНоменклатуры - Массив из ОпределяемыйТип.ВидНоменклатурыРаботаСНоменклатурой - массив видов номенклатуры
//                     для которых требуется установить отбор.
//    * Родители - Массив из ОпределяемыйТип.НоменклатураРаботаСНоменклатурой - массив номенклатуры для которых
//                     требуется установить отбор с учетом иерархии.
//    * РежимСопоставления - Строка - способ сопоставления категорий:
//       - ПоНоменклатуре - сопоставление с категориями по номенклатуре.
//       - ПоИерархии - сопоставление с категориями по иерархии.
//       - ПоВидам - сопоставление с категориями по видам номенклатуры.
//    * Заголовок             Строка - заголовок формы.
//    * ЗаголовокКатегории    Строка - заголовок колонок Категория на всех закладках формы.
//    * ЗаголовокРеквизита    Строка - заголовок колонки таблицы формы РеквизитыПредставлениеРеквизитаКатегории.
//    * ЗаголовокТипа         Строка - заголовок колонки таблицы формы РеквизитыТипРеквизитаРубрикатора.
//    * ИнформацияСписок      Строка - заголовок надписи ИнформацияСписок.
//    * ИнформацияРеквизиты   Строка - заголовок надписи ИнформацияРеквизиты.
//
Функция ПараметрыФормыСопоставленияНоменклатурыСРубрикатором() Экспорт 

	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("СценарийИспользования" , "ПубликацияТорговыхПредложенийБезКонтекста");
	ПараметрыФормы.Вставить("НастройкиОтбора"       , Неопределено);
	ПараметрыФормы.Вставить("Номенклатура"          , Неопределено);
	ПараметрыФормы.Вставить("ВидыНоменклатуры"      , Неопределено);
	ПараметрыФормы.Вставить("Родители"              , Неопределено);
	ПараметрыФормы.Вставить("РежимСопоставления"    , Неопределено);
	
	ПараметрыФормы.Вставить("Заголовок"             , НСтр("ru = 'Сопоставление номенклатуры с категориями 1С:Бизнес-сеть'"));
	ПараметрыФормы.Вставить("ЗаголовокКатегории"    , НСтр("ru = 'Категория 1С:Бизнес-сеть'"));
	ПараметрыФормы.Вставить("ЗаголовокРеквизита"    , НСтр("ru = 'Реквизит 1С:Бизнес-сеть'"));
	ПараметрыФормы.Вставить("ЗаголовокТипа"         , НСтр("ru = 'Тип 1С:Бизнес-сеть'"));
	ПараметрыФормы.Вставить("ИнформацияСписок"      , НСтр("ru = 'Необходимо сопоставить категории рубрикатора 1С:Бизнес-сеть.'"));
	ПараметрыФормы.Вставить("ИнформацияРеквизиты"   , НСтр("ru = 'Необходимо сопоставить реквизиты номенклатуры с реквизитами сервиса 1С:Бизнес-сеть.'"));
	
	Возврат ПараметрыФормы;

КонецФункции

Функция ОписаниеСлужебнойКорневойКатегории() Экспорт 
	
	СтруктураКорневогоРаздела = ОписаниеЗаписиКэшаКатегорий(НСтр("ru='Все категории'"));
	
	СтруктураКорневогоРаздела.Удалить("СвойстваКэшированы");
	СтруктураКорневогоРаздела.Удалить("СписокКэшированныхСвойств");
	
	Возврат СтруктураКорневогоРаздела
	
КонецФункции

Функция ОписаниеЗаписиКэшаКатегорий(
			НаименованиеКатегории = "", 
			ИдентификаторКатегории = "", 
			ИдентификаторРодителя = "") Экспорт
	
	СтруктураДанныхСервиса = Новый Структура;
	
	СтруктураДанныхСервиса.Вставить("Идентификатор",         ИдентификаторКатегории);
	СтруктураДанныхСервиса.Вставить("ИдентификаторРодителя", ИдентификаторРодителя);
	СтруктураДанныхСервиса.Вставить("Наименование",          НаименованиеКатегории);
	СтруктураДанныхСервиса.Вставить("КоличествоПодчиненных", 0);
	СтруктураДанныхСервиса.Вставить("ДатаИзменения",         Дата(1,1,1));
	СтруктураДанныхСервиса.Вставить("ДочерниеКэшированы",    Ложь);
	СтруктураДанныхСервиса.Вставить("Ранг",                  0);
	СтруктураДанныхСервиса.Вставить("ЛистоваяКатегория",     Истина);
	СтруктураДанныхСервиса.Вставить("ИндексСтрокиКатегории", 0);
	СтруктураДанныхСервиса.Вставить("СвойстваКэшированы",        Ложь);
	СтруктураДанныхСервиса.Вставить("СписокКэшированныхСвойств", Новый СписокЗначений);
	
	Возврат СтруктураДанныхСервиса;
	
КонецФункции

#КонецОбласти

#Область ЛокализацияЗначений

// Возвращает идентификатор категории "Прочее" сервиса "1С:Номенклатура"
// 
// Возвращаемое значение:
//  Строка - идентификатор категории "Прочее" сервиса "1С:Номенклатура"
//
Функция ИдентификаторКатегорииПрочее() Экспорт 
	Возврат "6341";
КонецФункции
 
// Возвращает идентификатор категории "Автоматически из 1С:Номенклатура"
// 
// Возвращаемое значение:
//  Строка - идентификатор категории "Автоматически из 1С:Номенклатура"
//
Функция ИдентификаторКатегорииРаботаСНоменклатурой() Экспорт 
	Возврат "АвтоматическиРаботаСНоменклатурой";
КонецФункции

#КонецОбласти 

#Область ВыгрузкаНоменклатуры

// Ограничение размера порции данных для выборки в запросе и/или последующей обработке
Функция РазмерПорции() Экспорт
	Возврат 1000;
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПодсказкиФормыНастройкиНоменклатурыПриЗагрузке

Процедура СформироватьСписокВыбораХарактеристик(Данные, СписокВыбораХарактеристик) Экспорт
	
	КоличествоХарактеристик            = Данные.КоличествоХарактеристик;            // Количество характеристик номенклатуры сервиса
	КоличествоВыбранныхХарактеристик   = Данные.КоличествоВыбранныхХарактеристик;   // Идентификаторы выбранных характеристик
	ВсеРеквизитыСопоставлены           = Данные.ВсеРеквизитыСопоставлены;           // Признак сопоставления всех реквизитов
	ИспользуютсяХарактеристикиВСервисе = Данные.ИспользуютсяХарактеристикиВСервисе; // Признак использования характеристик для номенклатуры сервиса
	СтатусВеденияУчетаХарактеристик    = Данные.СтатусВеденияУчетаХарактеристик;    // Статус ведения учета характеристик для вида номенклатуры
	
	СписокВыбораХарактеристик.Очистить();
	
	Если ИспользуютсяХарактеристикиВСервисе Тогда
		
		Если СтатусВеденияУчетаХарактеристик = "НеВедутся" Тогда
			СписокВыбораХарактеристик.Добавить("БезХарактеристик", НСтр("ru = 'Создать номенклатуру без учета характеристик'"));
			СписокВыбораХарактеристик.Добавить("ВсеХарактеристики", 
				СтрШаблон(НСтр("ru = 'Создать номенклатуру по каждой характеристике (%1)'"), КоличествоХарактеристик));
			
			Если КоличествоВыбранныхХарактеристик = 0 Тогда
				СписокВыбораХарактеристик.Добавить("ВыбранныеХарактеристики", НСтр("ru = 'Создать номенклатуру по выбранным характеристикам'"));	
			Иначе
				СписокВыбораХарактеристик.Добавить("ВыбранныеХарактеристики", 
					СтрШаблон(НСтр("ru = 'Выбрано характеристик: %1 из %2'"), КоличествоВыбранныхХарактеристик, КоличествоХарактеристик));
			КонецЕсли;	
			
		Иначе
			СписокВыбораХарактеристик.Добавить("БезХарактеристик", НСтр("ru = 'Не создавать характеристики'"));
			СписокВыбораХарактеристик.Добавить("ВсеХарактеристики", 
				СтрШаблон(НСтр("ru = 'Создать все характеристики (%1)'"), КоличествоХарактеристик));
			
			Если КоличествоВыбранныхХарактеристик = 0 Тогда
				СписокВыбораХарактеристик.Добавить("ВыбранныеХарактеристики", НСтр("ru = 'Выбрать характеристики для создания'"));	
			Иначе
				СписокВыбораХарактеристик.Добавить("ВыбранныеХарактеристики", 
					СтрШаблон(НСтр("ru = 'Выбрано характеристик: %1 из %2'"), КоличествоВыбранныхХарактеристик, КоличествоХарактеристик));
			КонецЕсли;	
			
		КонецЕсли;
				
	Иначе
		СписокВыбораХарактеристик.Добавить("БезХарактеристик", НСтр("ru = 'Характеристики не используются'"));	
	КонецЕсли;
		
КонецПроцедуры

Процедура СформироватьПодсказкуКХарактеристикам(Данные, РеквизитХраненияПодсказки) Экспорт
	
	ВсеРеквизитыСопоставлены           = Данные.ВсеРеквизитыСопоставлены;
	ИспользуютсяХарактеристикиВСервисе = Данные.ИспользуютсяХарактеристикиВСервисе;
	КоличествоХарактеристик            = Данные.КоличествоХарактеристик;
	КоличествоВыбранныхХарактеристик   = Данные.КоличествоВыбранныхХарактеристик;
	РежимЗагрузкиХарактеристик         = Данные.РежимЗагрузкиХарактеристик;
	СтатусВеденияУчетаХарактеристик    = Данные.СтатусВеденияУчетаХарактеристик;
	
	Подсказки = Новый Соответствие;
	
	Если ИспользуютсяХарактеристикиВСервисе Тогда
		Если СтатусВеденияУчетаХарактеристик = "НеВедутся" ИЛИ СтатусВеденияУчетаХарактеристик = "" Тогда
							
			Подсказки.Вставить("БезХарактеристик",         НСтр("ru = 'Будет создана 1 номенклатура'"));
			Подсказки.Вставить("ВсеХарактеристики",        СтрШаблон(НСтр("ru = 'Будет создано %1 %2 номенклатуры'"), 
				КоличествоХарактеристик, СогласованнаяСтрока("Элемент", КоличествоХарактеристик)));
				
			Если КоличествоВыбранныхХарактеристик = 0 Тогда
				Подсказки.Вставить("ВыбранныеХарактеристики", НСтр("ru = 'Номенклатура создана не будет'"));
			Иначе
				Подсказки.Вставить("ВыбранныеХарактеристики", СтрШаблон(НСтр("ru = 'Будет создано %1 %2 номенклатуры'"), 
					КоличествоВыбранныхХарактеристик, СогласованнаяСтрока("Элемент", КоличествоВыбранныхХарактеристик)));
			КонецЕсли;	
				
		Иначе
						
			Подсказки.Вставить("БезХарактеристик",         НСтр("ru = 'Будет создана 1 номенклатура'"));
			Подсказки.Вставить("ВсеХарактеристики",        СтрШаблон(НСтр("ru = 'Будет создана 1 номенклатура, %1 %2'"), 
				КоличествоХарактеристик, СогласованнаяСтрока("Характеристика", КоличествоХарактеристик)));
				
			Если КоличествоВыбранныхХарактеристик = 0 Тогда
				Подсказки.Вставить("ВыбранныеХарактеристики", НСтр("ru = 'Будет создана 1 номенклатура'"));
			Иначе
				Подсказки.Вставить("ВыбранныеХарактеристики", СтрШаблон(НСтр("ru = 'Будет создана 1 номенклатура, %1 %2'"), 
					КоличествоВыбранныхХарактеристик, СогласованнаяСтрока("Характеристика", КоличествоВыбранныхХарактеристик)));
			КонецЕсли;	
				
		КонецЕсли;	
	Иначе
		Подсказки.Вставить("БезХарактеристик", НСтр("ru = 'Будет создана 1 номенклатура'"));
	КонецЕсли;
	
	РеквизитХраненияПодсказки = Подсказки[РежимЗагрузкиХарактеристик];
		
КонецПроцедуры

Функция СогласованнаяСтрока(СогласуемаяСтрока, ЧислоДляСогласования) Экспорт
	
	Результат = "";
	
	Если СогласуемаяСтрока = "Характеристика" Тогда
		Результат = СтрокаСЧислом(";характеристика;;характеристики;характеристик;характеристик", 
			ЧислоДляСогласования, ВидЧисловогоЗначения.Количественное)
	ИначеЕсли СогласуемаяСтрока = "Элемент" Тогда	
		Результат = СтрокаСЧислом(";элемент;;элемента;элементов;элементов", 
			ЧислоДляСогласования, ВидЧисловогоЗначения.Количественное)		
	КонецЕсли;
		
	Возврат Результат;	
	
КонецФункции

#КонецОбласти

#Область ПараметровМетодов

Функция ДополнительныеПараметрыЗагрузкиНоменклатуры() Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	
	ДополнительныеПараметры.Вставить("ВидНоменклатуры",             Неопределено);
	ДополнительныеПараметры.Вставить("Номенклатура",                Неопределено);
	ДополнительныеПараметры.Вставить("РежимЗагрузкиХарактеристик",  РежимыЗагрузкиХарактеристик().ВНаименование);
	ДополнительныеПараметры.Вставить("ХарактеристикиВыбраны",       Ложь);
	ДополнительныеПараметры.Вставить("ВыбранныеХарактеристики",     Новый Массив);
	ДополнительныеПараметры.Вставить("ЗагружатьВсеХарактеристики ", Ложь);
	
	Возврат ДополнительныеПараметры;
	
КонецФункции

Функция ДополнительныеПараметрыЗагрузкиКатегорий() Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	
	ДополнительныеПараметры.Вставить("РежимЗагрузкиКатегорий",    "ПоОтдельности");
	ДополнительныеПараметры.Вставить("КоличествоУровнейИерархии", 0);
	ДополнительныеПараметры.Вставить("ВидНоменклатуры",           Неопределено);

	Возврат ДополнительныеПараметры;
	
КонецФункции

Функция ПараметрыЗагрузкиХарактеристик() Экспорт
	
	Результат = Новый Структура;
	
	Результат.Вставить("Номенклатура",                Неопределено); // Номенклатура, для которой загружаются характеристики.
	Результат.Вставить("ИдентификаторыХарактеристик", Новый Массив); // Идентификаторы выбранных для загрузки характеристик.
	Результат.Вставить("ЗагружатьВсеХарактеристики",  Ложь);         // Флаг загрузки всех характеристик, идентификаторы выбранных игнорируются.
	Результат.Вставить("ЗаполнитьСозданныеОбъекты",   Ложь);         // Истина - если в результат выполнения метода должен попадать массив созданных элементов.
	
	Возврат Результат;
		
КонецФункции

Функция ПараметрыЗапросаХарактеристик() Экспорт
	
	Результат = Новый Структура;
	
	Результат.Вставить("ИдентификаторНоменклатуры",   "");
	Результат.Вставить("ИдентификаторыХарактеристик", Новый Массив);
	Результат.Вставить("ИдентификаторКатегории",      "");
	Результат.Вставить("НомерСтраницыДанных",         0);
	Результат.Вставить("НаборПолей",                  "Минимальный"); // "Минимальный", "Максимальный".
	Результат.Вставить("ЗаполнитьПризнакЗагрузки",    Ложь);
	Результат.Вставить("ИсключитьЗагруженные",        Ложь);
	Результат.Вставить("НоменклатураИсключение",      Неопределено);
	Результат.Вставить("ДополнительныеРеквизиты",     Новый Массив);
	Результат.Вставить("РеквизитыХарактеристик",      Новый Массив);
	Результат.Вставить("ТаблицаТипов",                Неопределено);
		
	Возврат Результат;	
	
КонецФункции

Функция ШаблонДанныхНоменклатуры() Экспорт
	
	Шаблон = Новый Структура;
	
	Шаблон.Вставить("Номенклатура", Неопределено);
	Шаблон.Вставить("Характеристика", Неопределено);
	Шаблон.Вставить("ИдентификаторНоменклатуры", "");
	Шаблон.Вставить("ИдентификаторХарактеристики", "");
	
	Возврат Шаблон;
	
КонецФункции

Функция ПараметрыПоискаКатегорийПоСтроке() Экспорт
	
	Результат = Новый Структура;
	
	Результат.Вставить("СтрокаПоиска",                   "");
	Результат.Вставить("КоличествоКатегорийВРезультате", 100);
	Результат.Вставить("ТолькоЛистовыеКатегории",        Ложь);
	Результат.Вставить("НаборПолей",                     "Минимальный"); // Минимальный, Максимальный
	Результат.Вставить("РезультатВМассиве",              Истина);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ЗапретРедактированияРеквизитов

Процедура СнятьПометкиСБлокируемыхРеквизитов(Форма, ТаблицаФормы, БлокироватьРеквизиты) Экспорт
	
	Для каждого ЭлементКоллекции Из Форма.БлокируемыеРеквизиты Цикл
		
		СтрокиРеквизита = ТаблицаФормы.
			НайтиСтроки(Новый Структура("РеквизитОбъекта", ЭлементКоллекции.Значение));
		
		Если СтрокиРеквизита.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаДанных = СтрокиРеквизита[0];
		
		СтрокаДанных.Пометка = Ложь;
		
		СтрокаДанных.ТолькоПросмотр = БлокироватьРеквизиты;
		
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти

Функция БудутЗагружатьсяХарактеристики(Форма) Экспорт
	
	Возврат Форма.РаботаСНоменклатурой_РежимЗагрузкиХарактеристик = "Все" 
		ИЛИ Форма.РаботаСНоменклатурой_РежимЗагрузкиХарактеристик = "Выбранные";
	
	КонецФункции

Функция РежимыЗагрузкиХарактеристик() Экспорт
	
	Режимы = Новый Структура;
	
	Режимы.Вставить("ВХарактеристики");          // характеристика номенклатуры создается как характеристика ИБ
	Режимы.Вставить("ВДополнительныеРеквизиты"); // на каждую характеристику создается номенклатура
	Режимы.Вставить("ВНаименование");            // на каждую характеристику создается номенклатура
	Режимы.Вставить("НеЗагружать");              // характеристики игнорируются
	Режимы.Вставить("НеВедутся");                // характеристики для номенклатуры не ведутся
	
	Для каждого ЭлементКоллекции Из Режимы Цикл
		Режимы[ЭлементКоллекции.Ключ] = ЭлементКоллекции.Ключ;
	КонецЦикла;
	
	Возврат Режимы;
		
КонецФункции

// Сброс представления объекта сервиса на формах объектов информационной базы.
//
// Параметры:
//  Форма								 - ФормаКлиентскогоПриложения - обрабатываемая форма.
//  ПодсказкаВвода						 - Строка - подсказка ввода для поля объекта сервиса.
//  ПредставлениеПустогоОбъектСервиса	 - Строка - представление пустого объекта.
//
Процедура СброситьДанныеОбъектаСервиса(Форма) Экспорт
	
	Форма.РаботаСНоменклатурой_ИдентификаторОбъектаСервиса = "";
	Форма.РаботаСНоменклатурой_ИдентификаторыОбъектовСервиса.Очистить();
	Форма.Элементы.РаботаСНоменклатурой_Характеристики.Видимость = Ложь;
	
	Если Форма.РаботаСНоменклатурой_ЭтоРежимТолькоСопоставление Тогда
		Возврат;
	КонецЕсли;
	
	Если Форма.РаботаСНоменклатурой_РежимПредставленияОбъектаСервиса = "ПолеВвода" Тогда
		
		Если Форма.РаботаСНоменклатурой_ТипОбъекта = "Номенклатура" Тогда
			Форма.Элементы.ПредставлениеНоменклатурыСервиса.ПодсказкаВвода = НСтр("ru = 'Выберите номенклатуру из сервиса'");
		ИначеЕсли Форма.РаботаСНоменклатурой_ТипОбъекта = "ВидНоменклатуры" Тогда
			Форма.Элементы.ПредставлениеКатегорииСервиса.ПодсказкаВвода = НСтр("ru = 'Выберите категорию из сервиса'");
		Иначе
			ВызватьИсключение НСтр("ru = 'Ошибка определения типа объекта'");
		КонецЕсли;
		
		Форма.Элементы.РежимОбновления.Доступность = Ложь;
		
	Иначе
		Форма.РаботаСНоменклатурой_ПредставлениеОбъектаСервиса = Новый ФорматированнаяСтрока(НСтр("ru = 'Выбрать'"),,,,"Выбрать");
		НастроитьВидимостьГиперссылок(Форма);
	КонецЕсли;
		
КонецПроцедуры	

// Состояния сервиса.
// 
// Возвращаемое значение:
// Структура - Ключ - параметр, Значение - значение по-умолчанию.
//
Функция ОписаниеСостоянияСервиса() Экспорт 
	
	Состояние = Новый Структура();
	Состояние.Вставить("ПодключенаИнтернетПоддержка", Ложь);
	Состояние.Вставить("ЕстьДоступныеОпции",          Ложь);
	Состояние.Вставить("ДоступенСтартовыйПакет",      Ложь);
	Состояние.Вставить("ОшибкаОпределенияСостояния",  Ложь);
	
	Возврат Состояние;
	
КонецФункции

// Детализация ошибки при покупке карточек номенклатуры.
// 
// Возвращаемое значение:
//   Структура - Ключ - параметр, Значение - значение по-умолчанию.
//
Функция ОписаниеОшибкиПокупкиНоменклатуры() Экспорт 
	
	Ошибка = Новый Структура();
	Ошибка.Вставить("ПокупаемоеКоличество", 0);
	Ошибка.Вставить("ДоступныйОстаток",     0);
	
	Возврат Ошибка;
	
КонецФункции

// Идентификатор сервиса 1С:Номенклатура.
// 
// Возвращаемое значение:
//   Строка - идентификатор сервиса.
//
Функция ИдентификаторСервиса() Экспорт 
	
	Возврат "1C-Nomenclature";
	
КонецФункции

// Заголовок гиперссылки режима обновления
//
// Параметры:
//  АвтоматическийРежимОбновления	 - Булево - Истина если режим автоматического обновления.
// 
// Возвращаемое значение:
//  Строка - заголовок.
//
Функция ЗаголовокГиперссылкиРежимаОбновления(АвтоматическийРежимОбновления) Экспорт
	
	Возврат СтрШаблон(НСтр("ru = 'Обновлять %1'"), ?(АвтоматическийРежимОбновления, "автоматически", "вручную"));
	
КонецФункции

// Настройка отображения гиперссылок.
//
// Параметры:
//  Форма	 - ФормаКлиентскогоПриложения - управляемая форма.
//
Процедура НастроитьВидимостьГиперссылок(Форма) Экспорт
	
	ОбъектСервисаУказан = ЗначениеЗаполнено(Форма.РаботаСНоменклатурой_ИдентификаторОбъектаСервиса)
			ИЛИ Форма.РаботаСНоменклатурой_ИдентификаторыОбъектовСервиса.Количество() > 0;
			
	Заголовок = ЗаголовокГиперссылкиРежимаОбновления(Форма.РаботаСНоменклатурой_ОбновляетсяАвтоматически);
			
	Форма.Элементы.РаботаСНоменклатурой_ОчиститьОбъектСервиса.Видимость = ОбъектСервисаУказан;
	Форма.Элементы.РаботаСНоменклатурой_ОбновитьСейчас.Видимость        = ОбъектСервисаУказан;
	Форма.Элементы.РежимОбновления.Видимость                            = ОбъектСервисаУказан;
	Форма.Элементы.РежимОбновления.Заголовок                            = Заголовок;
	
КонецПроцедуры

#КонецОбласти

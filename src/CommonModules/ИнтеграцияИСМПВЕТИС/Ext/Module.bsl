﻿/////////////////////////////////////////////////////////////////////////////
// Совместная работа подсистем ВетИС и ИСМП.
//   * Если подсистема ВетИС отсутствует, изменения модуля не требуется.
//

#Область ПрограммныйИнтерфейс

// Проверяет использование встроенной или внешней подсистемы ВетИС
// 
// Возвращаемое значение:
//  Булево - Истина, если используется встроенная или внешняя подсистема работы с ВетИС
//
Функция ИспользуетсяПодсистемаВетИС() Экспорт
	
	ИспользуетсяВнешняяПодсистемаВетИС = Ложь;
	ИнтеграцияИСМПВЕТИСПереопределяемый.ПриПроверкеИспользованияВнешнейПодсистемыВетИС(ИспользуетсяВнешняяПодсистемаВетИС);
	
	Если ИспользуетсяВнешняяПодсистемаВетИС Тогда
		Возврат ИспользуетсяВнешняяПодсистемаВетИС;
	ИначеЕсли ОбщегоНазначения.ПодсистемаСуществует("ГосИС.ВетИС") Тогда
		Возврат ПолучитьФункциональнуюОпцию("ВестиУчетПодконтрольныхТоваровВЕТИС");
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#Область ОбщийМодульШтрихкодированиеИС

// Заполняет данные документа-основания из подсистемы ВетИС для документа ИСМП
// 
// Параметры:
//   ДанныеОснования    - см. ШтрихкодированиеИС.ИнициализицияТаблицыДанныхДокумента.
//   ДокументОснование  - ДокументСсылка  - документ-основание.
//   ДанныеСформированы - Булево          - заполнение произведено.
//
Процедура СформироватьДанныеДокументаОснования(ДанныеОснования, ДокументОснование, ДанныеСформированы) Экспорт
	
	ИнтеграцияИСМПВЕТИСПереопределяемый.СформироватьДанныеДокументаОснования(ДанныеОснования, ДокументОснование, ДанныеСформированы);
	Если ДанныеСформированы Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ГосИС.ВетИС") Тогда
		МодульВЕТИС = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияВЕТИС");
		МодульВЕТИС.СформироватьДанныеДокументаОснования(ДанныеОснования, ДокументОснование, ДанныеСформированы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбщийМодульШтрихкодированиеИСМПСлужебный

// Проверяет код маркировки молочной продукции на соответствие документу-основанию
// 
// Параметры:
//   СтрокаДанных          - Структура - известные данные кода маркировки.
//   ПравилоПроверки       - Структура - текущее правило проверки кода маркировки:
//     * ЕстьОшибка - Булево - код маркировки не соответствует документу-основанию.
//   ПараметрыСканирования - см. ШтрихкодированиеИС.ПараметрыСканирования.
//
Процедура ПроверитьДанныеСтрокиПоСрокуГодностиДокументаОснования(СтрокаДанных, ПравилоПроверки, ПараметрыСканирования) Экспорт
	
	СтандартнаяОбработка = Истина;
	ИнтеграцияИСМПВЕТИСПереопределяемый.ПроверитьДанныеСтрокиПоСрокуГодностиДокументаОснования(СтрокаДанных, ПравилоПроверки, ПараметрыСканирования, СтандартнаяОбработка);
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ГосИС.ВетИС") Тогда
		Возврат;
	ИначеЕсли Не ЭтоАдресВременногоХранилища(ПараметрыСканирования.АдресДанныхДокументаОснования) Тогда
		Возврат;
	КонецЕсли;
	
	МодульВЕТИС = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияВЕТИСКлиентСервер");
	
	Скоропортящаяся = Ложь;
	ГоденДо         = '00010101';
	ГоденДоПоДаннымВСД = '00010101';
	Если СтрокаДанных.СоставКодаМаркировки <> Неопределено
		И СтрокаДанных.СоставКодаМаркировки.Свойство("ГоденДо")
		И ЗначениеЗаполнено(СтрокаДанных.СоставКодаМаркировки.ГоденДо) Тогда
		ГоденДо         = СтрокаДанных.СоставКодаМаркировки.ГоденДо;
		Скоропортящаяся = СтрокаДанных.СоставКодаМаркировки.Скоропортящаяся;
	КонецЕсли;
	
	ДанныеДокументаОснования = ПолучитьИзВременногоХранилища(ПараметрыСканирования.АдресДанныхДокументаОснования);
	СтруктураПоиска = Новый Структура("Номенклатура, Характеристика", СтрокаДанных.Номенклатура, СтрокаДанных.Характеристика);
	НайденныеДанные = ДанныеДокументаОснования.НайтиСтроки(СтруктураПоиска);
	
	ПодходящиеИдентификаторыПроисхожденияВЕТИС = Новый Массив;
	Для Каждого НайденнаяСтрока Из НайденныеДанные Цикл
		
		ДанныеИдентификатораПроисхожденияВЕТИС = НайденнаяСтрока.ДанныеИдентификатораПроисхожденияВЕТИС;
		
		Если ЗначениеЗаполнено(ГоденДо) Тогда
			
			Если ДанныеИдентификатораПроисхожденияВЕТИС.Скоропортящаяся = Скоропортящаяся Тогда
				
				НачалоПериода = МодульВЕТИС.ЗначениеЭлементаПериодаВЕТИС(
					ДанныеИдентификатораПроисхожденияВЕТИС.НачалоПериода,
					ДанныеИдентификатораПроисхожденияВЕТИС.ТочностьЗаполнения);
				
				КонецПериода = МодульВЕТИС.ЗначениеЭлементаПериодаВЕТИС(
					ДанныеИдентификатораПроисхожденияВЕТИС.КонецПериода,
					ДанныеИдентификатораПроисхожденияВЕТИС.ТочностьЗаполнения,
					Истина);
				
				Если ГоденДо >= НачалоПериода
					И (ГоденДо <= КонецПериода Или Не ЗначениеЗаполнено(КонецПериода))Тогда
					ПодходящиеИдентификаторыПроисхожденияВЕТИС.Добавить(ДанныеИдентификатораПроисхожденияВЕТИС.ИдентификаторПроисхожденияВЕТИС);
				КонецЕсли;
				
			КонецЕсли;
			
		Иначе
			
			Если ЗначениеЗаполнено(ДанныеИдентификатораПроисхожденияВЕТИС.НачалоПериода)
				И Не ЗначениеЗаполнено(ДанныеИдентификатораПроисхожденияВЕТИС.КонецПериода) Тогда
				ГоденДоПоДаннымВСД = ДанныеИдентификатораПроисхожденияВЕТИС.НачалоПериода;
			КонецЕсли;
			ПодходящиеИдентификаторыПроисхожденияВЕТИС.Добавить(ДанныеИдентификатораПроисхожденияВЕТИС.ИдентификаторПроисхожденияВЕТИС);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПодходящиеИдентификаторыПроисхожденияВЕТИС.Количество() > 1 Тогда
		СтрокаДанных.ИдентификаторыПроисхожденияВЕТИС = ПодходящиеИдентификаторыПроисхожденияВЕТИС;
	ИначеЕсли ПодходящиеИдентификаторыПроисхожденияВЕТИС.Количество() = 1 Тогда
		СтрокаДанных.ИдентификаторПроисхожденияВЕТИС = ПодходящиеИдентификаторыПроисхожденияВЕТИС[0];
		Если ЗначениеЗаполнено(ГоденДо) Тогда
			СтрокаДанных.ГоденДо = ГоденДо;
			СтрокаДанных.ТребуетсяВыборВСД = Ложь;
		ИначеЕсли ЗначениеЗаполнено(ГоденДоПоДаннымВСД) Тогда
			СтрокаДанных.ГоденДо = ГоденДоПоДаннымВСД;
			СтрокаДанных.ТребуетсяВыборВСД = Ложь;
		КонецЕсли;
		Если ЗначениеЗаполнено(СтрокаДанных.СтрокаДерева) Тогда
			ЗаполнитьЗначенияСвойств(СтрокаДанных.СтрокаДерева, СтрокаДанных, "ИдентификаторПроисхожденияВЕТИС, ГоденДо");
		КонецЕсли;
	Иначе
		ПравилоПроверки.ЕстьОшибка     = Истина;
		СтрокаДанных.ТребуетсяВыборВСД = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Дополняет дерево вложенных штрихкодов сохраненными данными ВетИС табличной части "Штрихкоды упаковок"
//   для документа МаркировкаТоваровИСМП:
//     * Заполняет признаки ИдентификаторПроисхожденияВЕТИС, ГоденДо, Скоропортящаяся по заполненным данным
//      табличной части "ШтрихкодыУпаковок".
//     * Заполняет эти же признаки для всех дочерних узлов дерева.
//     * Заполняет эти же признаки для таблицы МаркированныеТовары вложенных штрихкодов.
// 
// Параметры:
//   ВложенныеШтрихкоды    - см. ШтрихкодированиеИС.ВложенныеШтрихкодыУпаковокПоДокументу.
//   ПараметрыСканирования - см. ШтрихкодированиеИС.ПараметрыСканирования.
//
Процедура ДополнитьВложенныеШтрихкодыДаннымиВЕТИС(ВложенныеШтрихкоды, ПараметрыСканирования) Экспорт
	
	СтандартнаяОбработка = Истина;
	ИнтеграцияИСМПВЕТИСПереопределяемый.ДополнитьВложенныеШтрихкодыДаннымиВЕТИС(ВложенныеШтрихкоды, ПараметрыСканирования, СтандартнаяОбработка);
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ГосИС.ВетИС") Тогда
		Возврат;
	ИначеЕсли Не ПараметрыСканирования.ЗаполнятьДанныеВЕТИС Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ШтрихкодыУпаковок.ШтрихкодУпаковки,
	|	ШтрихкодыУпаковок.ИдентификаторПроисхожденияВЕТИС,
	|	ЕСТЬNULL(ШтрихкодыУпаковок.ИдентификаторПроисхожденияВЕТИС.СкоропортящаясяПродукция, ЛОЖЬ) КАК Скоропортящаяся,
	|	ШтрихкодыУпаковок.СрокГодности КАК ГоденДо
	|ИЗ
	|	Документ.МаркировкаТоваровИСМП.ШтрихкодыУпаковок КАК ШтрихкодыУпаковок
	|ГДЕ
	|	ШтрихкодыУпаковок.Ссылка = &Ссылка
	|	И (ШтрихкодыУпаковок.ИдентификаторПроисхожденияВЕТИС <> Неопределено
	|		ИЛИ ШтрихкодыУпаковок.СрокГодности <> ДАТАВРЕМЯ(1, 1, 1))");
	
	Запрос.УстановитьПараметр("Ссылка", ПараметрыСканирования.СсылкаНаОбъект);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	УпаковкиСДаннымиВЕТИС = Новый Соответствие;
	
	Пока Выборка.Следующий() Цикл
		
		Если ЗначениеЗаполнено(Выборка.ИдентификаторПроисхожденияВЕТИС)
			Или ЗначениеЗаполнено(Выборка.ГоденДо) Тогда
			
			ДанныеВЕТИС = Новый Структура("ИдентификаторПроисхожденияВЕТИС, ГоденДо, Скоропортящаяся",
			Выборка.ИдентификаторПроисхожденияВЕТИС, Выборка.ГоденДо, Выборка.Скоропортящаяся);
			
			УпаковкиСДаннымиВЕТИС.Вставить(Выборка.ШтрихкодУпаковки, ДанныеВЕТИС);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ДеревоУпаковок = ВложенныеШтрихкоды.ДеревоУпаковок;
	ДополнитьВложенныеШтрихкодыДереваДаннымиВЕТИС(ДеревоУпаковок, УпаковкиСДаннымиВЕТИС);
	
	// Если сканирование выполняется в форме проверки и подбора, то заполнение таблицы маркированных товаров не требуется
	Если Не ПараметрыСканирования.ИспользуетсяСоответствиеШтрихкодовСтрокДерева Тогда
		МаркированныеТовары = ВложенныеШтрихкоды.МаркированныеТовары;
		Для Каждого СтрокаТЧ Из МаркированныеТовары Цикл
			ЗаполнитьЗначенияСвойств(СтрокаТЧ, СтрокаТЧ.СтрокаДерева, "ИдентификаторПроисхожденияВЕТИС, ГоденДо, Скоропортящаяся");
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ДокументЗаказНаЭмиссиюКодовМаркировкиСУЗ

// Определяет ожидаемый шаблон кода маркировки молочной продукции по идентификатору происхождения ВетИС. Ожидаемое поведение:
//   * Для скоропортящейся продукции выставление шаблона "СкоропортящаясяМолочнаяПродукцияВЕТИС".
//   * Для нескоропортящейся продукции выставление шаблона "МолочнаяПродукцияПодконтрольнаяВЕТИС".
//   * При незаполненности идентификатора происхождения незаполнение шаблона.
// 
// Параметры:
//  Запрос - Запрос - запрос обработчика заполнения табличной части заказа на эмиссию по маркировке
//
Процедура ДоработатьЗапросЗаполненияЗаказаНаЭмиссиюПоМаркировке(Запрос) Экспорт
	
	СтандартнаяОбработка = Истина;
	ИнтеграцияИСМПВЕТИСПереопределяемый.ДоработатьЗапросЗаполненияЗаказаНаЭмиссиюПоМаркировке(Запрос, СтандартнаяОбработка);
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ГосИС.ВетИС") Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонМаркировки = "ВЫБОР
	|		КОГДА ЕСТЬNULL(%1.ИдентификаторПроисхожденияВЕТИС.СкоропортящаясяПродукция, НЕОПРЕДЕЛЕНО) = ИСТИНА
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ШаблоныКодовМаркировкиСУЗ.СкоропортящаясяМолочнаяПродукцияВЕТИС)
	|		КОГДА ЕСТЬNULL(%1.ИдентификаторПроисхожденияВЕТИС.СкоропортящаясяПродукция, НЕОПРЕДЕЛЕНО) = ЛОЖЬ
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ШаблоныКодовМаркировкиСУЗ.МолочнаяПродукцияПодконтрольнаяВЕТИС)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ШаблоныКодовМаркировкиСУЗ.ПустаяСсылка)
	|	КОНЕЦ";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ШаблонМаркировкаТовары", СтрШаблон(ШаблонМаркировки, "МаркировкаТоваровИСМПТовары"));
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ШаблонМаркировкаШтрихкоды", СтрШаблон(ШаблонМаркировки, "МаркировкаТоваровИСМПШтрихкоды"));
	
КонецПроцедуры

#КонецОбласти

#Область ДокументМаркировкаТоваровИСМП

// Обработка заполнения документа "Маркировка товаров ИСМП" по документам ВетИС.
//   
// Параметры:
//   ДокументОбъект - ДокументОбъект.МаркировкаТоваровИСМП - заполняемый документ
//   ДанныеЗаполнения - Произвольный - данные заполнения
//   ТекстЗаполнения - Строка - текст заполнения
//   СтандартнаяОбработка - Булево - признак стандартной обработки события
Процедура ОбработкаЗаполненияМаркировкиТоваровИСМП(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	ИнтеграцияИСМПВЕТИСПереопределяемый.ОбработкаЗаполненияМаркировкиТоваровИСМП(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ГосИС.ВетИС") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнениеВыполнено = Ложь;
	МодульВЕТИС = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияВЕТИС");
	МодульВЕТИС.ЗаполнитьДокументМаркировкаТоваровИСМП(ЗаполнениеВыполнено, ДанныеЗаполнения, ДокументОбъект);
	Если ЗаполнениеВыполнено Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Определяет признак "Скоропортящаяся продукция" по идентификатору происхождения ВетИС. Ожидаемое поведение:
//   * Для скоропортящейся продукции выставление Истина.
//   * Для прочей продукции (в т. ч. при незаполненном идентификаторе) выставление Ложь.
// 
// Параметры:
//  Запрос - Запрос - запрос обработчика заполнения маркируемой продукции документа Маркировка.
//         - Строка - текст части запроса заполнения специфики маркируемой продукции.
Процедура ДоработатьЗапросЗаполненияМаркируемойПродукцииДокументаМаркировка(Запрос) Экспорт
	
	СтандартнаяОбработка = Истина;
	ИнтеграцияИСМПВЕТИСПереопределяемый.ДоработатьЗапросЗаполненияМаркируемойПродукцииДокументаМаркировка(Запрос, СтандартнаяОбработка);
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ГосИС.ВетИС") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Запрос) = Тип("Строка") Тогда
		Запрос = СтрЗаменить(Запрос, "&ИдентификаторПроисхожденияВЕТИССтрокой",
			"ЕСТЬNULL(Товары.ИдентификаторПроисхожденияВЕТИС.Идентификатор, """")");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Скоропортящаяся",
			"ЕСТЬNULL(МаркировкаТоваровИСМПТовары.ИдентификаторПроисхожденияВЕТИС.СкоропортящаясяПродукция, ЛОЖЬ)");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбщийМодульРасчетСтатусовОформленияИСМП

// Заполняет имена реквизитов документа-основания ВЕТИС для документа ИСМП.
//   При использовании внешней подсистемы ВетИС, расчет статусов оформления пишется в общем переопределении.
//
// Параметры:
//  МетаданныеОснования - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.Основание<Имя документа ИСМП>
//  МетаданныеДокументаИСМП - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.ДокументыИСМППоддерживающиеСтатусыОформления
//  Реквизиты  - Структура - имена реквизитов:
//  * Ключ  - Строка - служебное имя реквизита в ИСМП
//  * Значение - Строка - имя реквизита документа-основания, которое при необходимости надо переопределить
//  (см. РасчетСтатусовОформленияИСМП.СтруктураРеквизитовДляРасчетаСтатусаОформленияДокументов).
Процедура ПриОпределенииИменРеквизитовДляРасчетаСтатусаОформления(МетаданныеОснования, МетаданныеДокументаИСМП, Реквизиты) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ГосИС.ВетИС") Тогда
		Возврат;
	КонецЕсли;
	
	Если МетаданныеОснования = Метаданные.Документы["ПроизводственнаяОперацияВЕТИС"] Тогда
		Реквизиты.Контрагент = "ХозяйствующийСубъект.Контрагент";
	ИначеЕсли МетаданныеОснования = Метаданные.Документы["ВходящаяТранспортнаяОперацияВЕТИС"] Тогда
		Реквизиты.Контрагент = "ГрузополучательХозяйствующийСубъект.Контрагент";
	КонецЕсли;
	
КонецПроцедуры

// Позволяет переопределить текст запроса выборки данных из документов-основания для расчета статуса оформления.
//   При использовании внешней подсистемы ВетИС, расчет статусов оформления пишется в общем переопределении.
//   Требования к тексту запроса:
//     Если данные из документа выбирать не требуется, переопределение также не заполнять.
//     Результат запроса обязательно должен содержать следующие поля:
//      * Ссылка - ОпределяемыйТип.Основание<Имя документа ИСМП> - ссылка на документ-основание
//      * ЭтоДвижениеПриход - Булево - вид движения ТМЦ (Истина - приход, Ложь - расход)
//      * Номенклатура - ОпределяемыйТип.Номенклатура - номенклатура
//      * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - характеристика номенклатуры
//      * Серия - ОпределяемыйТип.СерияНоменклатуры - серия номенклатуры
//      * Количество - Число - количество номенклатуры в ее основной единице измерения
//     В результат запроса нужно включать только подконтрольную номенклатуру ИСМП (табак, обувь)
//     Для отбора документов-основания в запросе нужно использовать отбор "В (&МассивДокументов)"
//     Выбранные данные необходимо поместить во временную таблицу (См. РасчетСтатусовОформленияИС.ИмяВременнойТаблицыДляВыборкиДанныхДокумента).
//
//Параметры:
//   МетаданныеОснования - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.Основание<Имя документа ИСМП>
//   МетаданныеДокументаИСМП - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.ДокументыИСМППоддерживающиеСтатусыОформления
//   ТекстЗапроса - Строка - текст запроса выборки данных, который надо переопределить
//   ПараметрыЗапроса - Структура - дополнительные параметры запроса, требуемые для выполнения запроса 
//       конкретного документа; при необходимости можно дополнить данную структуру
//     Ключ     - имя параметры
//     Значение - значение параметра.
//
Процедура ПриОпределенииТекстаЗапросаДляРасчетаСтатусаОформления(
			МетаданныеОснования, МетаданныеДокументаИСМП, ТекстЗапроса, ПараметрыЗапроса) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ГосИС.ВетИС") Тогда
		Возврат;
	КонецЕсли;
	
	Если МетаданныеДокументаИСМП <> Метаданные.Документы.МаркировкаТоваровИСМП Тогда
		Возврат;
	ИначеЕсли МетаданныеОснования <> Метаданные.Документы["ПроизводственнаяОперацияВЕТИС"]
			И МетаданныеОснования <> Метаданные.Документы["ВходящаяТранспортнаяОперацияВЕТИС"] Тогда
		Возврат;
	КонецЕсли;
	
	ЧастиЗапроса = Новый Массив;
	
	Если МетаданныеОснования = Метаданные.Документы["ПроизводственнаяОперацияВЕТИС"] Тогда
		
		ТекстЗапроса = "ВЫБРАТЬ
		|	ТаблицаТовары.Ссылка КАК Ссылка,
		|	ТаблицаТовары.Номенклатура КАК Номенклатура,
		|	ТаблицаТовары.Характеристика КАК Характеристика,
		|	ТаблицаТовары.Серия КАК Серия,
		|	СУММА(ТаблицаТовары.Количество) КАК Количество
		|ПОМЕСТИТЬ ДанныеШтрихкодовУпаковок
		|ИЗ
		|	Документ.ПроизводственнаяОперацияВЕТИС.Товары КАК ТаблицаТовары
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПроизводственнаяОперацияВЕТИС КАК ТаблицаДокумента
		|		ПО ТаблицаДокумента.Ссылка = ТаблицаТовары.Ссылка
		|ГДЕ
		|	ТаблицаДокумента.Ссылка В (&МассивДокументов)
		|	И ТаблицаДокумента.Проведен
		|	И ТаблицаТовары.ВетеринарноСопроводительныйДокумент <> ЗНАЧЕНИЕ(Справочник.ВетеринарноСопроводительныйДокументВЕТИС.ПустаяСсылка)
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаТовары.Ссылка,
		|	ТаблицаТовары.Номенклатура,
		|	ТаблицаТовары.Характеристика,
		|	ТаблицаТовары.Серия
		|ИМЕЮЩИЕ
		|	СУММА(ТаблицаТовары.Количество) > 0
		|"
		
	ИначеЕсли МетаданныеОснования = Метаданные.Документы["ВходящаяТранспортнаяОперацияВЕТИС"] Тогда
		
		ТекстЗапроса = "ВЫБРАТЬ
		|	ТаблицаТовары.Ссылка КАК Ссылка,
		|	ТаблицаТовары.Номенклатура КАК Номенклатура,
		|	ТаблицаТовары.Характеристика КАК Характеристика,
		|	ТаблицаТовары.Серия КАК Серия,
		|	СУММА(ТаблицаТовары.Количество) КАК Количество
		|ПОМЕСТИТЬ ДанныеШтрихкодовУпаковок
		|ИЗ
		|	Документ.ВходящаяТранспортнаяОперацияВЕТИС.Товары КАК ТаблицаТовары
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВходящаяТранспортнаяОперацияВЕТИС КАК ТаблицаДокумента
		|		ПО ТаблицаДокумента.Ссылка = ТаблицаТовары.Ссылка
		|ГДЕ
		|	ТаблицаДокумента.Ссылка В (&МассивДокументов)
		|	И ТаблицаДокумента.Проведен
		|	И ТаблицаДокумента.ГашениеНаСВХ
		|	И ТаблицаТовары.ВетеринарноСопроводительныйДокумент <> ЗНАЧЕНИЕ(Справочник.ВетеринарноСопроводительныйДокументВЕТИС.ПустаяСсылка)
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаТовары.Ссылка,
		|	ТаблицаТовары.Номенклатура,
		|	ТаблицаТовары.Характеристика,
		|	ТаблицаТовары.Серия
		|ИМЕЮЩИЕ
		|	СУММА(ТаблицаТовары.Количество) > 0
		|";
		
	КонецЕсли;
	
	ЧастиЗапроса.Добавить(ТекстЗапроса);
	ЧастиЗапроса.Добавить(ШтрихкодированиеИС.ОпределитьТекстЗапросаСвойстваМаркируемойПродукции());
	ЧастиЗапроса.Добавить("ВЫБРАТЬ
		|	ТаблицаТовары.Ссылка КАК Ссылка,
		|	ИСТИНА КАК ЭтоДвижениеПриход,
		|	ТаблицаТовары.Номенклатура КАК Номенклатура,
		|	ТаблицаТовары.Характеристика КАК Характеристика,
		|	ТаблицаТовары.Серия КАК Серия,
		|	ТаблицаТовары.Количество КАК Количество
		|ПОМЕСТИТЬ %1
		|ИЗ
		|	ДанныеШтрихкодовУпаковок КАК ТаблицаТовары
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ СвойстваМаркируемойПродукции КАК МаркируемаяПродукцияИСМПВЕТИС
		|		ПО ТаблицаТовары.Номенклатура = МаркируемаяПродукцияИСМПВЕТИС.Номенклатура
		|		И ТаблицаТовары.Характеристика = МаркируемаяПродукцияИСМПВЕТИС.Характеристика
		|		И МаркируемаяПродукцияИСМПВЕТИС.ВидПродукции = ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.МолочнаяПродукцияПодконтрольнаяВЕТИС)
		|"
	);
	ЧастиЗапроса.Добавить("УНИЧТОЖИТЬ ДанныеШтрихкодовУпаковок");
	ЧастиЗапроса.Добавить("УНИЧТОЖИТЬ СвойстваМаркируемойПродукции");
	ТекстЗапроса = СтрСоединить(ЧастиЗапроса, ИнтеграцияИС.РазделительЗапросовВПакете());
	
КонецПроцедуры

#КонецОбласти

// Возвращает данные ВетИС по идентификаторам происхождения:
//   * СрокГодности    - Дата   - дата начала последнего периода срока годности.
//   * Скоропортящаяся - Булево - признак скоропорта.
//   * Представление   - Строка - представление идентификатора (без имени), ожидается "Дата (срок годности)"
//   * Идентификатор   - ОпределяемыйТип.УникальныйИдентификаторИС - GUID объекта ВетИС.
//	 * Продукция       - Произвольный - продукция ВетИС.
// Параметры:
//   ИдентификаторыПроисхождения - Массив Из ОпределяемыйТип.ИдентификаторПроисхожденияВЕТИС - идентификаторы происхождения.
//
//  Возвращаемое значение:
//   Соответствие - данные ВетИС по идентификаторам происхождения, где ключ - ссылка на идентификатор, значение - полученные данные.
//
Функция ДанныеИдентификаторовПроисхождения(ИдентификаторыПроисхождения) Экспорт
	
	ДанныеПоСрокамГодности = Новый Соответствие;
	
	СтандартнаяОбработка = Истина;
	ИнтеграцияИСМПВЕТИСПереопределяемый.ПриПолученииДанныхИдентификаторовПроисхождения(ИдентификаторыПроисхождения, ДанныеПоСрокамГодности, СтандартнаяОбработка);
	Если Не СтандартнаяОбработка Тогда
		Возврат ДанныеПоСрокамГодности;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ГосИС.ВетИС") Тогда
		Возврат ДанныеПоСрокамГодности;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ИдентификаторыПроисхождения) Тогда
		Возврат ДанныеПоСрокамГодности;
	КонецЕсли;
	
	МодульВЕТИС = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияВЕТИСКлиентСервер");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИдентификаторПроисхожденияВЕТИС.Ссылка КАК ИдентификаторыПроисхождения,
	|	ВЫБОР
	|		КОГДА ИдентификаторПроисхожденияВЕТИС.СрокГодностиКонецПериода = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ИдентификаторПроисхожденияВЕТИС.СрокГодностиНачалоПериода
	|		ИНАЧЕ ИдентификаторПроисхожденияВЕТИС.СрокГодностиКонецПериода
	|	КОНЕЦ КАК СрокГодности,
	|	ИдентификаторПроисхожденияВЕТИС.СрокГодностиНачалоПериода КАК НачалоПериода,
	|	ИдентификаторПроисхожденияВЕТИС.СрокГодностиКонецПериода КАК КонецПериода,
	|	ИдентификаторПроисхожденияВЕТИС.СрокГодностиТочностьЗаполнения КАК ТочностьЗаполнения,
	|	ИдентификаторПроисхожденияВЕТИС.Продукция КАК Продукция,
	|	ИдентификаторПроисхожденияВЕТИС.Идентификатор,
	|	ИдентификаторПроисхожденияВЕТИС.Дата,
	|	ИдентификаторПроисхожденияВЕТИС.СкоропортящаясяПродукция
	|ИЗ
	|	Справочник.ВетеринарноСопроводительныйДокументВЕТИС КАК ИдентификаторПроисхожденияВЕТИС
	|ГДЕ
	|	ИдентификаторПроисхожденияВЕТИС.Ссылка В (&ИдентификаторыПроисхождения)";
	Запрос.УстановитьПараметр("ИдентификаторыПроисхождения", ИдентификаторыПроисхождения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СрокГодности = МодульВЕТИС.ЗначениеЭлементаПериодаВЕТИС(Выборка.СрокГодности, Выборка.ТочностьЗаполнения);
		
		Период = МодульВЕТИС.ПредставлениеПериодаВЕТИС(
			Выборка.ТочностьЗаполнения, Выборка.НачалоПериода, Выборка.КонецПериода);
		ПредставлениеШаблон = НСтр("ru = '%1 (%2)'");
		Представление = СтрШаблон(ПредставлениеШаблон, Формат(Выборка.Дата, "ДФ=dd.MM.yyyy"), Период);
		
		ДанныеВЕТИС = Новый Структура;
		ДанныеВЕТИС.Вставить("СрокГодности",    СрокГодности);
		ДанныеВЕТИС.Вставить("Скоропортящаяся", Выборка.СкоропортящаясяПродукция);
		ДанныеВЕТИС.Вставить("Идентификатор",   Выборка.Идентификатор);
		ДанныеВЕТИС.Вставить("Представление",   Представление);
		ДанныеВЕТИС.Вставить("Продукция",       Выборка.Продукция);
		
		ДанныеПоСрокамГодности.Вставить(Выборка.ИдентификаторыПроисхождения, ДанныеВЕТИС);
		
	КонецЦикла;
	
	Возврат ДанныеПоСрокамГодности;
	
КонецФункции

// Проверяет продукцию идентификатора происхождения на соответствие сопоставленной продукции по переданной структуре данных товара.
//
// Параметры:
//  ИдентификаторыПроисхождения   - Массив Из ОпределяемыйТип.УникальныйИдентификаторИС - GUID объекта ВетИС.
//  ДанныеСопоставления - Структура - со свойствами:
//   * Номенклатура   - ОпределяемыйТип.Номенклатура               - номенклатура.
//   * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - характеристика.
//   * Серия          - ОпределяемыйТип.СерияНоменклатуры          - серия.
//  Соответствует - Булево - переопределяемый параметр, Истина, если продукция идентификатора совпадает с сопоставленной продукцией данных для сопоставления.
//  СтандартнаяОбработка - Булево - признак библиотечной обработки.
//
// Возвращаемое значение:
//   Булево - номенклатура соответствует.
Функция НоменклатураСоответствуетСопоставленнойПродукцииВЕТИСПоИдентификаторуПроисхождения(ИдентификаторыПроисхождения, ДанныеСопоставления) Экспорт
	
	Соответствует = Ложь;
	
	СтандартнаяОбработка = Истина;
	ИнтеграцияИСМПВЕТИСПереопределяемый.ПриПроверкеСоответствияНоменклатурыИдентификаторуПроисхождения(
		ИдентификаторыПроисхождения,
		ДанныеСопоставления,
		Соответствует,
		СтандартнаяОбработка);
	Если Не СтандартнаяОбработка Тогда
		Возврат Соответствует;
	КонецЕсли;
	
	ДанныеВЕТИС = ДанныеИдентификаторовПроисхождения(ИдентификаторыПроисхождения);
	ДанныеПоИдентификаторуВЕТИС = ДанныеВЕТИС[ИдентификаторыПроисхождения];
	
	Если ДанныеПоИдентификаторуВЕТИС = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Номенклатура   = ДанныеСопоставления.Номенклатура;
	Характеристика = ДанныеСопоставления.Характеристика;
	Серия          = ДанныеСопоставления.Серия;
	
	МодульВЕТИС = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияВЕТИС");
	СопоставленнаяПродукция = МодульВЕТИС.СопоставленнаяПродукция(Номенклатура, Характеристика, Серия);
	
	Если СопоставленнаяПродукция.Найти(ДанныеПоИдентификаторуВетИС.Продукция) <> Неопределено Тогда
		Соответствует = Истина;
	КонецЕсли;
	
	Возврат Соответствует;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДополнитьВложенныеШтрихкодыДереваДаннымиВЕТИС(ДеревоУпаковок, УпаковкиСДаннымиВЕТИС, Знач ДанныеВЕТИС = Неопределено)
	
	Для Каждого СтрокаДерева Из ДеревоУпаковок.Строки Цикл
		
		Если ДанныеВЕТИС = Неопределено Тогда
			ТекущиеДанныеВЕТИС = УпаковкиСДаннымиВЕТИС[СтрокаДерева.ШтрихкодУпаковки];
		Иначе
			ТекущиеДанныеВЕТИС = ДанныеВЕТИС;
		КонецЕсли;
		
		Если ТекущиеДанныеВЕТИС <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(СтрокаДерева, ТекущиеДанныеВЕТИС);
		КонецЕсли;
		
		ДополнитьВложенныеШтрихкодыДереваДаннымиВЕТИС(СтрокаДерева, УпаковкиСДаннымиВЕТИС, ТекущиеДанныеВЕТИС);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

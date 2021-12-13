﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с формой документа".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает отчет по взаиморасчетам с контрагентом.
//
// Параметры:
//  Контрагент - СправочникСсылка.Контрагенты - контрагент, по которому следует получить отчет по взаиморасчетам.
//
Процедура ОткрытьОтчетВзаиморасчетыСКонтрагентом(Контрагент) Экспорт
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("СформироватьПриОткрытии", Истина);
	ОтборРасшифровки = Новый Структура;
	ОтборРасшифровки.Вставить("Контрагент", Контрагент);
	ПараметрыОткрытия.Вставить("Отбор", ОтборРасшифровки);
	Вариант = РаботаСФормойДокументаКлиентСервер.ВариантОтчета("АктСверки", "АктСверкиКонтекст");
	ВариантыОтчетовКлиент.ОткрытьФормуОтчета(, Вариант, ПараметрыОткрытия);
	
КонецПроцедуры

// Открывает отчет "Денежные средства" с указанными параметрами.
//
// Параметры:
//  БанковскийСчетКасса - СправочникСсылка.БанковскиеСчета - отбор для отчета "Денежные средства".
//                      - СправочникСсылка.Кассы - отбор для отчета "Денежные средства".
//  Организация - СправочникСсылка.Организации - отбор для отчета "Денежные средства".
//
Процедура ОткрытьОтчетДенежныеСредства(БанковскийСчетКасса, Организация = Неопределено) Экспорт
	
	Вариант = РаботаСФормойДокументаКлиентСервер.ВариантОтчета("ДенежныеСредства", "ВедомостьВВалюте");
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("СформироватьПриОткрытии", Истина);
	
	ОтборРасшифровки = Новый Соответствие;
	ОтборРасшифровки.Вставить("БанковскийСчетКасса", БанковскийСчетКасса);
	Если Организация <> Неопределено
		И НЕ УправлениеНебольшойФирмойВызовСервера.ПолучитьКонстантуСервер("УчетПоКомпании") Тогда
		ОтборРасшифровки.Вставить("Организация", Организация);
	КонецЕсли;
	
	ПараметрыОткрытия.Вставить("ОтборРасшифровки", ОтборРасшифровки);
	
	ВариантыОтчетовКлиент.ОткрытьФормуОтчета(, Вариант, ПараметрыОткрытия);
	
КонецПроцедуры

// Открывает форму документа по переданной ссылке.
//
// Параметры:
//  ДокументСсылка	 - ДокументСсылка - ссылка на документ, форму которого следует открыть.
//
Процедура ОткрытьФормуДокументаПоСсылке(ДокументСсылка) Экспорт
	
	Если ЗначениеЗаполнено(ДокументСсылка) Тогда
		ПоказатьЗначение(, ДокументСсылка);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает имя документа по типу документа.
//
// Параметры:
//  ТипДокумента - Тип - тип документа, для которого вернуть имя.
// 
// Возвращаемое значение:
//  Строка - имя документа, которое можно использовать, например, в методе ОткрытьФорму()
//
Функция ИмяДокументаПоТипу(ТипДокумента) Экспорт
	
	ИменаДокументовПоТипу = РаботаСФормойДокументаКлиентПовтИсп.ИменаДокументовПоТипу();
	Возврат ИменаДокументовПоТипу[ТипДокумента];
	
КонецФункции

// Добавляет последнее значение отбора поля в СтруктураПараметров.
//
// При создании документа из списка, в котором были установлены отборы,
// в новом документе будут автоматически заполнены значения, которые были у отборов.
//
// Параметры:
//  ДанныеМеток			 - ДанныеФормыКоллекция - данные по установленным отборам.
//  СтруктураПараметров	 - Структура - в эту структуру попадут значения отборов.
//  ИмяПоляОтбора		 - Строка - имя поля, по которому установлен отбор.
//
Процедура ДобавитьПоследнееЗначениеОтбораПоля(ДанныеМеток, СтруктураПараметров, ИмяПоляОтбора) Экспорт
	
	НайденныеСтроки = ДанныеМеток.НайтиСтроки(Новый Структура("ИмяПоляОтбора",ИмяПоляОтбора));
	Если НайденныеСтроки.Количество() > 0 Тогда
		СтруктураПараметров.Вставить(ИмяПоляОтбора, НайденныеСтроки[НайденныеСтроки.Количество()-1].Метка);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает представление заголовка подчиненного счета-фактуры.
//
// Параметры:
//  ТекущийДокументСсылка	 - ДокументСсылка - документ, на основании которого введен счет-фактура.
//  Источник				 - ДокументСсылка - ссылка на счет-фактуру.
//  ПараметрыОповещения		 - Структура - дополнительные параметры, переданные в оповещение.
//  КэшЗначений				 - Структура - структура, у которого определено свойство "СчетФактураСсылка".
// 
// Возвращаемое значение:
//  Строка - представление подчиненного счета-фактуры.
//
Функция ПредставлениеЗаголовкаПодчиненногоСчетаФактуры(ТекущийДокументСсылка, Источник, ПараметрыОповещения, КэшЗначений) Экспорт
	Перем ПредставлениеЗаголовка;
	
	ТекущийДокументУказанОснованиемСФ = ТипЗнч(ПараметрыОповещения) = Тип("Структура")
		И ПараметрыОповещения.Свойство("ДокументыОснования")
		И ПараметрыОповещения.ДокументыОснования.Найти(ТекущийДокументСсылка) <> Неопределено;
	
	ТекущийДокументИспользовалсяОснованиемСФ = (Источник = КэшЗначений.СчетФактураСсылка);
	
	Если ТекущийДокументУказанОснованиемСФ Тогда
		
		КэшЗначений.Вставить("СчетФактураСсылка", Источник);
		ПредставлениеЗаголовка = РаботаСФормойДокументаКлиентСервер.СформироватьНадписьСчетФактура(ПараметрыОповещения.ПредставлениеСчетФактуры);
		
	ИначеЕсли ТекущийДокументИспользовалсяОснованиемСФ Тогда
		
		КэшЗначений.Вставить("СчетФактураСсылка", Неопределено);
		ПредставлениеЗаголовка = РаботаСФормойДокументаКлиентСервер.СформироватьНадписьСчетФактура("");
		
	КонецЕсли;
	
	Возврат ПредставлениеЗаголовка;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура КомментарийЗавершениеВвода(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
	
	Если ВведенныйТекст = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитФормы = ДополнительныеПараметры.ФормаВладелец;
	
	ПутьКРеквизитуФормы = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ДополнительныеПараметры.ИмяРеквизита, ".");
	// Если реквизит вида "Объект.Комментарий" и т.п.
	Если ПутьКРеквизитуФормы.Количество() > 1 Тогда
		Для Индекс = 0 По ПутьКРеквизитуФормы.Количество() - 2 Цикл 
			РеквизитФормы = РеквизитФормы[ПутьКРеквизитуФормы[Индекс]];
		КонецЦикла;
	КонецЕсли;
	
	РеквизитФормы[ПутьКРеквизитуФормы[ПутьКРеквизитуФормы.Количество() - 1]] = ВведенныйТекст;
	ДополнительныеПараметры.ФормаВладелец.Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Открывает форму редактирования произвольного многострочного текста.
//
// Параметры:
//  ОповещениеОЗакрытии     - ОписаниеОповещения - содержит описание процедуры, которая будет вызвана 
//                            после закрытия формы ввода текста с теми же параметрами, что и для метода ПоказатьВводСтроки.
//  МногострочныйТекст      - Строка - произвольный текст, который необходимо отредактировать;
//  Заголовок               - Строка - текст, который необходимо отобразить в заголовке формы.
//
// Пример:
//
//   Оповещение = Новый ОписаниеОповещения("КомментарийЗавершениеВвода", ЭтотОбъект);
//   ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(Оповещение, Элемент.ТекстРедактирования);
//
//   &НаКлиенте
//   Процедура КомментарийЗавершениеВвода(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
//      Если ВведенныйТекст = Неопределено Тогда
//		   Возврат;
//   	КонецЕсли;	
//	
//	   Объект.МногострочныйКомментарий = ВведенныйТекст;
//	   Модифицированность = Истина;
//   КонецПроцедуры
//
Процедура ПоказатьФормуРедактированияМногострочногоТекста(Знач ОповещениеОЗакрытии, 
	Знач МногострочныйТекст, Знач Заголовок = Неопределено) Экспорт
	
	Если Заголовок = Неопределено Тогда
		ПоказатьВводСтроки(ОповещениеОЗакрытии, МногострочныйТекст,,, Истина);
	Иначе
		ПоказатьВводСтроки(ОповещениеОЗакрытии, МногострочныйТекст, Заголовок,, Истина);
	КонецЕсли;

КонецПроцедуры

// Открывает форму редактирования многострочного комментария.
//
// Параметры:
//  МногострочныйТекст      - Строка - произвольный текст, который необходимо отредактировать
//  ФормаВладелец 			- ФормаКлиентскогоПриложения - форма, в поле которой выполняется ввод комментария
//  ИмяРеквизита            - Строка - имя реквизита формы, в который будет помещен введенный пользователем комментарий. 
//  Заголовок               - Строка - текст, который необходимо отобразить в заголовке формы.
//                                     По умолчанию: "Комментарий".
//
// Пример использования:
//
//	 ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
//
Процедура ПоказатьФормуРедактированияКомментария(Знач МногострочныйТекст, Знач ФормаВладелец, Знач ИмяРеквизита, 
	Знач Заголовок = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура("ФормаВладелец,ИмяРеквизита", ФормаВладелец, ИмяРеквизита);
	Оповещение = Новый ОписаниеОповещения("КомментарийЗавершениеВвода", ЭтотОбъект, ДополнительныеПараметры);
	ЗаголовокФормы = ?(Заголовок <> Неопределено, Заголовок, НСтр("ru='Комментарий'"));
	ПоказатьФормуРедактированияМногострочногоТекста(Оповещение, МногострочныйТекст, ЗаголовокФормы);
	
КонецПроцедуры

#КонецОбласти
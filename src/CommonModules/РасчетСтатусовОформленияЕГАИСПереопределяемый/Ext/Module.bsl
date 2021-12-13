﻿// Механизм расчета статусов оформления документов ИС МП.
//

#Область СлужебныйПрограммныйИнтерфейс

//Позволяет переопределить имена реквизитов документа-основания для документа ЕГАИС.
//
//Параметры:
//   МетаданныеДокументаОснования - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.Основание<Имя документа ЕГАИС>.
//   МетаданныеДокументаЕГАИС - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.ДокументыЕГАИСПоддерживающиеСтатусыОформления.
//   Реквизиты  - См. РасчетСтатусовОформленияЕГАИС.РеквизитыДляРасчета - заполняемое соответствие имен реквизитов.
//
Процедура ПриОпределенииРеквизитовОснования(
			Знач МетаданныеДокументаОснования, Знач МетаданныеДокументаЕГАИС, Реквизиты) Экспорт
	
	ИнтеграцияЕГАИСУНФ.ПриОпределенииРеквизитовОснования(МетаданныеДокументаОснования, МетаданныеДокументаЕГАИС, Реквизиты);
	
КонецПроцедуры

// Позволяет переопределить текст запроса выборки данных из документов-основания для расчета статуса оформления.
//   Требования к тексту запроса:
//     Если данные из документа выбирать не требуется, то данному параметру надо присвоить значение "" (пустая строка).
//     Результат запроса обязательно должен содержать следующие поля:
//      * Ссылка - ОпределяемыйТип.Основание<Имя документа ЕГАИС> - ссылка на документ-основание
//      * ЭтоДвижениеПриход - Булево - вид движения ТМЦ (Истина - приход, Ложь - расход)
//      * Номенклатура - ОпределяемыйТип.Номенклатура - номенклатура
//      * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - характеристика номенклатуры
//      * Серия - ОпределяемыйТип.СерияНоменклатуры - серия номенклатуры
//      * Количество - Число - количество номенклатуры в ее основной единице измерения
//     В результат запроса нужно включать только алкогольную продукцию для передачи сведений в ЕГАИС
//     Для отбора документов-основания в запросе нужно использовать отбор "В (&МассивДокументов)"
//     Выбранные данные необходимо поместить во временную таблицу (См. РасчетСтатусовОформленияИС.ИмяВременнойТаблицыДляВыборкиДанныхДокумента).
//
//Параметры:
//   МетаданныеДокументаОснования - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.Основание<Имя документа ЕГАИС>.
//   МетаданныеДокументаЕГАИС - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.ДокументыЕГАИСПоддерживающиеСтатусыОформления.
//   ТекстЗапроса - Строка - текст запроса выборки данных, который надо переопределить
//   ДополнительныеПараметрыЗапроса - Структура - дополнительные параметры запроса, требуемые для выполнения запроса 
//       конкретного документа; при необходимости можно дополнить данную структуру.
//
Процедура ПриОпределенииЗапросаТоварыДокументаОснования(
			Знач МетаданныеДокументаОснования, Знач МетаданныеДокументаЕГАИС, ТекстЗапроса, ДополнительныеПараметрыЗапроса) Экспорт
	
	ИнтеграцияЕГАИСУНФ.ПриОпределенииЗапросаТоварыДокументаОснования(МетаданныеДокументаОснования, МетаданныеДокументаЕГАИС, ТекстЗапроса, ДополнительныеПараметрыЗапроса);

КонецПроцедуры

#КонецОбласти

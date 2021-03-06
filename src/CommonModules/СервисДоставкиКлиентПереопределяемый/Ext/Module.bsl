////////////////////////////////////////////////////////////////////////////////
// Подсистема "Сервис доставки".
// ОбщийМодуль.СервисДоставкиКлиентПереопределяемый.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Устанавливает имя формы выбора объекта, если она отличается от формы выбора по умолчанию.
//
// Параметры:
//  ИмяОбъекта - Строка - имя объекта метаданных.
//  ИмяФормыВыбора - Строка - полное имя формы выбора объекта. Например, "Документ.ЗаказПокупателя.ФормаВыбора".
//
Процедура УстановитьИмяФормыВыбораОбъектаПоИмени(ИмяОбъекта, ИмяФормыВыбора) Экспорт
	
КонецПроцедуры

// Открытие формы нового заказа на доставку, создаваемого на основании переданного объекта
// в параметре "МассивСсылок". Вызывается из подсистемы "ПодключаемыеКоманды".
//
// Параметры:
//  МассивСсылок - ЛюбаяСсылка, Массив - объект или список объектов.
//  ПараметрыВыполнения - Структура - см. ПодключаемыеКомандыКлиентСервер.ПараметрыВыполненияКоманды().
//
Процедура ЗаказНаДоставкуСоздатьНаОсновании(МассивСсылок, ПараметрыВыполнения) Экспорт
	
КонецПроцедуры

// Открытие формы нового заказа на доставку, создаваемого на основании документа.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма документа.
//
Процедура ОткрытьФормуНовогоЗаказаНаДоставку(Форма) Экспорт
	
КонецПроцедуры

// Обработка выбора заказа на доставку из списка выбора заказов.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма документа.
//  ВыбранныйЗаказ - ДанныеФормыЭлементКоллекции, Неопределено - Строка списка заказов.
//  ИмяПроцедурыОбработки - Строка - Имя процедуры обработки выбора заказа в списке заказов.
//
Процедура ОбработатьРезультатВыбораЗаказаНаДоставку(Форма, ВыбранныйЗаказ, ИмяПроцедурыОбработки) Экспорт
КонецПроцедуры

#КонецОбласти

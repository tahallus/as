﻿#Область ПрограммныйИнтерфейс

#Область ПараметрыВыбора

// Устанавливает параметры выбора номенклатуры.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой нужно установить параметры выбора
//  ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС, Массив Из ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции.
//  ИмяПоляВвода - Строка - имя поля ввода номенклатуры.
Процедура УстановитьПараметрыВыбораНоменклатуры(Форма, ВидыПродукции = Неопределено, ИмяПоляВвода = "ТоварыНоменклатура") Экспорт
	
	ИнтеграцияИСМПУНФКлиентСервер.УстановитьПараметрыВыбораНоменклатуры(Форма, ВидыПродукции, ИмяПоляВвода);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

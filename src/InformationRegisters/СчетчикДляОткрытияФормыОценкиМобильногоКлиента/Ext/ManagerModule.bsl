﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс


// Устанавливает значение счетчика открытия формы оценки мобильного клиента.
// 
// Параметры:
// 	ЗначениеСчетчика - Число - устанавливаемое значение
Процедура УстановитьЗначение(ЗначениеСчетчика) Экспорт
	
	ИдентификаторПриложения = УникальныйИдентификаторПриложения();
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ИдентификаторПриложения = ИдентификаторПриложения;
	МенеджерЗаписи.КоличествоЗапусков = ЗначениеСчетчика;
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры


// Возвращает значение счетчика открытия формы оценки мобильного клиента текущего устройства.
// 
// Возвращаемое значение:
// 	Число
Функция ЗначениеСчетчика() Экспорт
	
	ИдентификаторПриложения = УникальныйИдентификаторПриложения();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СчетчикДляОткрытияФормыОценкиМобильногоКлиента.ИдентификаторПриложения КАК ИдентификаторПриложения,
	|	СчетчикДляОткрытияФормыОценкиМобильногоКлиента.КоличествоЗапусков КАК КоличествоЗапусков
	|ИЗ
	|	РегистрСведений.СчетчикДляОткрытияФормыОценкиМобильногоКлиента КАК СчетчикДляОткрытияФормыОценкиМобильногоКлиента
	|ГДЕ
	|	СчетчикДляОткрытияФормыОценкиМобильногоКлиента.ИдентификаторПриложения = &ИдентификаторПриложения";
	
	Запрос.УстановитьПараметр("ИдентификаторПриложения", ИдентификаторПриложения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.КоличествоЗапусков;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция УникальныйИдентификаторПриложения()
	
	СисИнфо = Новый СистемнаяИнформация;
	Возврат СисИнфо.ИдентификаторКлиента;
	
КонецФункции

#КонецОбласти

#КонецЕсли

﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура УдалитьИнформациюОСостоянииЗаказов(Знач Состояние) Экспорт
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
		|ВЫБРАТЬ
		|	ИсторияСостоянийЗаказов.Период КАК Период,
		|	ИсторияСостоянийЗаказов.Заказ КАК Заказ
		|ИЗ
		|	РегистрСведений.ИсторияСостоянийЗаказов КАК ИсторияСостоянийЗаказов
		|ГДЕ
		|	ИсторияСостоянийЗаказов.Состояние = &Состояние";
	
	Запрос.УстановитьПараметр("Состояние", Состояние);
	
	Выборка = Запрос.Выполнить().Выбрать();
	НаборЗаписей = РегистрыСведений.ИсторияСостоянийЗаказов.СоздатьНаборЗаписей();
	
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей.Отбор.Период.Установить(Выборка.Период);
		НаборЗаписей.Отбор.Заказ.Установить(Выборка.Заказ);
		
		НаборЗаписей.Записать(Истина);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
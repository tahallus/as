﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает значение МРОт на переданную дату
//
Функция МРОТНаДату(Дата = Неопределено) Экспорт
	
	// МРОТ
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МРОТСрезПоследних.Значение
	|ИЗ
	|	РегистрСведений.МРОТ.СрезПоследних(&ДатаСреза, ) КАК МРОТСрезПоследних");
	Запрос.УстановитьПараметр("ДатаСреза", НачалоГода(Дата));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Значение;
	Иначе
		ВызватьИсключение НСтр("ru='Регистр сведений МРОТ не заполнен'");
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли
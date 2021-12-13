﻿
#Область СлужебныйПрограммныйИнтерфейс

// Служебный обработчик события глобального контекста ПриГлобальномПоиске.
//  См. модуль управляемого приложения.
//
// Параметры:
//  ВидПоиска - Строка - Стандартный вид поиска.
//
Процедура ПриВыбореРезультатаГлобальногоПоиска(ВидПоиска) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Запись = РегистрыСведений.ИсторияГлобальногоПоиска.СоздатьМенеджерЗаписи();
	Запись.Идентификатор = Пользователи.АвторизованныйПользователь().УникальныйИдентификатор();
	Запись.Дата = ТекущаяДатаСеанса();
	Запись.ЭтоВыборЗначения = Истина;
	Запись.ВидПоиска = ВидПоиска;
	Запись.Записать(Истина);
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Функция НайтиВалютуПоСтроке(СтрокаПоиска) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Валюты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	(Валюты.ПараметрыПрописи ПОДОБНО &СтрокаПоиска
	|			ИЛИ Валюты.СимвольноеПредставление ПОДОБНО &СтрокаПоиска)";
	Запрос.УстановитьПараметр("СтрокаПоиска", "%" + СтрокаПоиска + "%");
	
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда
		Возврат Результат.Ссылка;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

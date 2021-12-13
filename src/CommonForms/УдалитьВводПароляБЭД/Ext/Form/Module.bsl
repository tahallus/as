﻿////////////////////////////////////////////////////////////////////////////////
// Модуль формы ВводПароляБЭД
//
////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.Заголовок) Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	Если ЗначениеЗаполнено(Параметры.Подсказка) Тогда
		Элементы.Пароль.Подсказка = Параметры.Подсказка;
	КонецЕсли;
	Элементы.Запомнить.Видимость = Параметры.ИспользоватьЗапоминание;
	Если ЗначениеЗаполнено(Параметры.ПодсказкаЗапоминания) Тогда
		Элементы.Запомнить.Подсказка = Параметры.ПодсказкаЗапоминания;
		Элементы.Запомнить.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	СвойстваПароля = Новый Структура;
	СвойстваПароля.Вставить("Пароль", Пароль);
	СвойстваПароля.Вставить("Запомнить", Запомнить);
	
	Закрыть(СвойстваПароля);
	
КонецПроцедуры

#КонецОбласти

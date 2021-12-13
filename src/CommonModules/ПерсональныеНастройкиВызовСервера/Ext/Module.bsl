﻿#Область ПрограммныйИнтерфейс

// Установить настройку пользователя.
// 
// Параметры:
//  ЗначениеНастройки  - Произвольный - Значение настройки
//  ИмяНастройки - Строка - Имя настройки
//  Пользователь - СправочникСсылка.Пользователи, Неопределено - Пользователь
Процедура Установить(Знач ЗначениеНастройки, Знач ИмяНастройки, Знач Пользователь = Неопределено) Экспорт
	РегистрыСведений.НастройкиПользователей.Установить(ЗначениеНастройки, ИмяНастройки, Пользователь);
КонецПроцедуры

#КонецОбласти
﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
		
	Отбор = Новый Структура("Владелец", ПараметрКоманды);
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	
	ОткрытьФорму("РегистрСведений.ПолитикиУчетаСерий.Форма.ФормаСписка", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры

#КонецОбласти

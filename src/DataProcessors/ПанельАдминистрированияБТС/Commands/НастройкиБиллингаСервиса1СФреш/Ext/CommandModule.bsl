﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ПараметрыФормы = Новый Структура;
	ОткрытьФорму(
		"Обработка.ПанельАдминистрированияБТС.Форма.НастройкиБиллингаСервиса1СФреш", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		"Обработка.ПанельАдминистрированияБТС.Форма.НастройкиБиллингаСервиса1СФреш" 
			+ ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
		ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры

#КонецОбласти

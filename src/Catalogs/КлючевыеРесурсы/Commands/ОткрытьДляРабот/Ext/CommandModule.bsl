﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура();
	ОткрытьФорму("Справочник.КлючевыеРесурсы.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, "ПланировщикРаботы", ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры

#КонецОбласти
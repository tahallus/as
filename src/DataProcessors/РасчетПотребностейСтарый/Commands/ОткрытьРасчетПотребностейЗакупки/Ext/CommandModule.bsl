﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ТолькоЗакупки", Истина);
	ОткрытьФорму("Обработка.РасчетПотребностейСтарый.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, "РасчетПотребностейЗакупки", ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти 


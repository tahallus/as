﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытия = Новый Структура("Заголовок, КлючПодсказки", 
		"Типовые схемы учета в розничной торговле",
		"ГрафическаяСхема_Розница");
	
	ОткрытьФорму("Обработка.МенеджерПодсказок.Форма", ПараметрыОткрытия,, ПараметрыВыполненияКоманды.Уникальность);
	
КонецПроцедуры

#КонецОбласти
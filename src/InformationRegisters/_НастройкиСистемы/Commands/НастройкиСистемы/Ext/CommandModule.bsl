﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("РегистрСведений._НастройкиСистемы.ФормаЗаписи", ПараметрыОткрытияФормы());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПараметрыОткрытияФормы()
	
	КлючЗапись = РегистрыСведений._НастройкиСистемы.СоздатьКлючЗаписи(
		Новый Структура("Организация", Справочники.Организации.ПустаяСсылка())); 
	Возврат Новый Структура("Ключ", КлючЗапись);
	
КонецФункции

#КонецОбласти
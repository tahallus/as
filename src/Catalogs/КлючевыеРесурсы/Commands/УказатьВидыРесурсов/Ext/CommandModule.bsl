﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Отбор = Новый Структура("РесурсПредприятия", ПараметрКоманды);
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	ОткрытьФорму("РегистрСведений.ВидыРесурсовПредприятия.Форма.ФормаДляРесурсов", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры

#КонецОбласти
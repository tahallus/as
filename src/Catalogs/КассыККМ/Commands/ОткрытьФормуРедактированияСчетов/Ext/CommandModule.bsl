﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму(
	"Справочник.КассыККМ.Форма.ФормаРедактированияСчетовУчета",
	СтруктураПараметров(ПараметрКоманды),
	ПараметрыВыполненияКоманды.Источник,
	ПараметрыВыполненияКоманды.Уникальность,
	ПараметрыВыполненияКоманды.Окно,
	ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СтруктураПараметров(ПараметрКоманды)
	
	Результат = Новый Структура;
	Результат.Вставить("СчетУчета", ПараметрКоманды.СчетУчета);
	Результат.Вставить("Ссылка", ПараметрКоманды.Ссылка);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

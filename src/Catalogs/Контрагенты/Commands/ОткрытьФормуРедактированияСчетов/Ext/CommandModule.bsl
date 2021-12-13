﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму(
	"Справочник.Контрагенты.Форма.ФормаРедактированияСчетовУчета",
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
	Результат.Вставить("СчетУчетаРасчетовСПокупателем", ПараметрКоманды.СчетУчетаРасчетовСПокупателем);
	Результат.Вставить("СчетУчетаАвансовПокупателя", ПараметрКоманды.СчетУчетаАвансовПокупателя);
	Результат.Вставить("СчетУчетаРасчетовСПоставщиком", ПараметрКоманды.СчетУчетаРасчетовСПоставщиком);
	Результат.Вставить("СчетУчетаАвансовПоставщику", ПараметрКоманды.СчетУчетаАвансовПоставщику);
	Результат.Вставить("Ссылка", ПараметрКоманды.Ссылка);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

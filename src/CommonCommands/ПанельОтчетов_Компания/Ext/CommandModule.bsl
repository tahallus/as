﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПутьКПодсистеме = "Компания";
	ФормаПараметры = Новый Структура("ПутьКПодсистеме", ПутьКПодсистеме);
	
	ФормаОкно = ?(ПараметрыВыполненияКоманды = Неопределено, Неопределено, ПараметрыВыполненияКоманды.Окно);
	ФормаСсылка = ?(ПараметрыВыполненияКоманды = Неопределено, Неопределено, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
	ПараметрыКлиента = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске(),
		"ВариантыОтчетов");
	Если ПараметрыКлиента.ВыполнятьЗамеры Тогда
		МодульОценкаПроизводительностиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОценкаПроизводительностиКлиент");
		ИдентификаторЗамера = МодульОценкаПроизводительностиКлиент.ЗамерВремени(
			"ПанельОтчетов.Открытие",,
			Ложь);
		МодульОценкаПроизводительностиКлиент.УстановитьКомментарийЗамера(ИдентификаторЗамера, 
			ПараметрыКлиента.ПрефиксЗамеров + "; " + ПутьКПодсистеме);
	КонецЕсли;
	
	Форма = ОткрытьФорму("ОбщаяФорма.ФормаСпискаОтчетов", ФормаПараметры, , ПутьКПодсистеме, ФормаОкно, ФормаСсылка);
	
	Если ПараметрыКлиента.ВыполнятьЗамеры Тогда
		МодульОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(ИдентификаторЗамера);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
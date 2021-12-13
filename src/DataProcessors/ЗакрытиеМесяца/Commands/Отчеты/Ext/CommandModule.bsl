﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ТипЗнч(ПараметрыВыполненияКоманды.Источник) <> Тип("ФормаКлиентскогоПриложения") Тогда
		Возврат;
	КонецЕсли; 
	СтруктураПараметров = Новый Структура("ТекГод, ТекМесяц, Организация");
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, ПараметрыВыполненияКоманды.Источник);
	СтруктураОткрытия = Новый Структура;
	ДополнитьСтруктуруОткрытияНаСервере(СтруктураПараметров, СтруктураОткрытия);
	ПараметрыФормы = Новый Структура("Ссылка", СтруктураОткрытия);
	Форма = ОткрытьФорму("ОбщаяФорма.ФормаСпискаОтчетов", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
	СтатистикаИспользованияФормКлиент.ПроверитьЗаписатьСтатистикуКоманды(
		"СвязанныеОтчеты",
		ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДополнитьСтруктуруОткрытияНаСервере(СтруктураПараметров, СтруктураОткрытия)
	
	Если НЕ ЗначениеЗаполнено(СтруктураПараметров.ТекГод) Тогда
		СтруктураПараметров.ТекГод = Год(ТекущаяДатаСеанса());
	КонецЕсли; 
	Если НЕ ЗначениеЗаполнено(СтруктураПараметров.ТекМесяц) Тогда
		СтруктураПараметров.ТекМесяц = Месяц(ТекущаяДатаСеанса());
	КонецЕсли; 
	Месяц = Дата(СтруктураПараметров.ТекГод, СтруктураПараметров.ТекМесяц, 1);
	Если НЕ ЗначениеЗаполнено(СтруктураПараметров.Организация) Тогда
		Если Константы.УчетПоКомпании.Получить() Тогда
			СтруктураПараметров.Организация = Справочники.Организации.ОрганизацияКомпания();
		Иначе
			СтруктураПараметров.Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
		КонецЕсли;
	КонецЕсли;
	СтруктураОткрытия.Вставить("ПериодРасшифровки", Новый СтандартныйПериод(НачалоМесяца(Месяц), КонецМесяца(Месяц)));
	СтруктураОткрытия.Вставить("Организация", СтруктураПараметров.Организация);
	СтруктураОткрытия.Вставить("Контекст", ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Обработки.ЗакрытиеМесяца));
	
КонецПроцедуры
 
#КонецОбласти 

 
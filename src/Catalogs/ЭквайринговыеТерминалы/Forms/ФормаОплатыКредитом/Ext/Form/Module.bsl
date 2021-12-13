﻿#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если СуммаОплаты > КОплате Тогда
		ТекстСообщения = НСтр("ru = 'Сумма оплаты не может превышать сумму документа!'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "СуммаОплаты", "СуммаОплаты");
		Возврат;
	КонецЕсли;
	
	Если СуммаОплаты = 0 Тогда
		ПараметрыЗакрытия = Неопределено;
	Иначе
		ЭквайринговыйТерминал = ПолучитьТерминалПоДоговору(Договор);
		Если ЭквайринговыйТерминал = Неопределено Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'По данному договору невозможно определить параметры кредита.
					|Пожалуйста, проверьте настройки договора'"));
			Возврат;
		Иначе
			ПараметрыЗакрытия = Новый Структура("ЭквайринговыйТерминал, ВидПлатежнойКарты, Сумма, ВидОплаты",
				ЭквайринговыйТерминал,
				ЭквайринговыеОперацииКлиентСервер.ВидПлатежнойКартыДляКредита(),
				СуммаОплаты,
				ПредопределенноеЗначение("Перечисление.ВидыБезналичныхОплат.Кредит"));
		КонецЕсли;
	КонецЕсли;
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("КОплате") Тогда
		КОплате = Параметры.КОплате;
		СуммаОплаты = КОплате;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Документ") Тогда
		Организация = Параметры.Документ.Организация;
	КонецЕсли;
	
	Если Параметры.Свойство("ЭквайринговыйТерминал") Тогда
		Договор = Параметры.ЭквайринговыйТерминал.Договор;
	КонецЕсли;
	
	Если Параметры.Свойство("Сумма") Тогда
		СуммаОплаты = Параметры.Сумма;
	КонецЕсли;
	
	Элементы.СуммаОплаты.СписокВыбора.Добавить(КОплате, СтрШаблон(НСтр("ru = '%1 (К оплате)'"), КОплате));
	
	ЕдинственныйДоговор = Справочники.ДоговорыКонтрагентов.ЕдинственныйДоговорКредита(Организация);
	Если Не ЕдинственныйДоговор = Неопределено Тогда
		Договор = ЕдинственныйДоговор;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьТерминалПоДоговору(Договор)
	
	МассивТерминалов = ЭквайринговыеОперацииСервер.ПолучитьТерминалыПоДоговору(Договор);
	Если МассивТерминалов.Количество() > 0 Тогда
		Возврат МассивТерминалов[0];
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти
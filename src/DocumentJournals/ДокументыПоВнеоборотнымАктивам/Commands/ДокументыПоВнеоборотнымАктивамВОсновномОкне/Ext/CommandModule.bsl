﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	ОценкаПроизводительностиКлиент.ЗамерВремени("ЖурналДокументыПоВнеоборотнымАктивам");
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
	ПараметрыФормы = Новый Структура("ВнеоборотныйАктив, ЭтоНачальнаяСтраница", ПараметрКоманды, Ложь);
	ОткрытьФорму("ЖурналДокументов.ДокументыПоВнеоборотнымАктивам.ФормаСписка", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ОсновноеОкно());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ОсновноеОкно()
	
	ОсновноеОкно = Неопределено;
	
	Окна = ПолучитьОкна();
	Если Окна <> Неопределено Тогда
		Для каждого Окно Из Окна Цикл
			Если Окно.Основное Тогда
				ОсновноеОкно = Окно;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ОсновноеОкно;
	
КонецФункции

#КонецОбласти

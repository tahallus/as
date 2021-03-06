////////////////////////////////////////////////////////////////////////////////
//
// Серверные процедуры и функции регламентированных отчетов общего назначения 
// с кешируемым результатом на время сеанса.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция СоздаватьСертификатПоПриказуФСБ_N31_от_29января2021(ИдентификаторДокументооборота) Экспорт
	
	ЭтоНовыйФормат = Ложь;
	
	Ответ = ДокументооборотСКО.PostЗапросОператору("IsOrder795Activated");
	
	Если Ответ = Неопределено Тогда
		Возврат ЭтоНовыйФормат;
	КонецЕсли;

	ДОМ = ДокументооборотСКО.ДваждыРазобратьОтветНаPostЗапрос(Ответ);
	
	Строки = ДОМ.ПолучитьЭлементыПоИмени("value");
	Если Строки.Количество() > 0 Тогда
		Строка = Строки[0];
		ЭтоНовыйФормат = XMLЗначение(Тип("Булево"), Строка.ТекстовоеСодержимое);
	КонецЕсли;

	Возврат ЭтоНовыйФормат;
		
КонецФункции

#КонецОбласти
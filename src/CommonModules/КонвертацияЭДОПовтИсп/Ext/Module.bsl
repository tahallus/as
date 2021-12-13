﻿#Область КонвертерЭлектронныхДокументов

Функция ПреобразованиеXSL_ПараметрыПроизвольногоДокумента() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ИсходныйФормат", "ПроизвольныйXML");
	Параметры.Вставить("ИтоговыйФормат", "ПараметрыЭлектронногоДокумента");
	
	ТекстПравила = КонвертацияЭДО.ТекстПравилаПреобразованияФормата(Параметры);
	Если НЕ ЗначениеЗаполнено(ТекстПравила) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Преобразователь = Новый ПреобразованиеXSL;
	Преобразователь.ЗагрузитьТаблицуСтилейXSLИзСтроки(ТекстПравила);
	
	Возврат Преобразователь;
	
КонецФункции

Функция ФабрикаXDTOЭлектронногоДокумента(ФорматЭД) Экспорт
	
	ПараметрыСхемыXML = Новый Структура;
	ПараметрыСхемыXML.Вставить("ИсходныйФормат", ФорматЭД);
	ПараметрыСхемыXML.Вставить("ИтоговыйФормат", "СхемаXML");
	
	ТекстСхемыXML = КонвертацияЭДО.ТекстПравилаПреобразованияФормата(ПараметрыСхемыXML);
	Если НЕ ЗначениеЗаполнено(ТекстСхемыXML) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ЧтениеСхемыXML = Новый ЧтениеXML;
	ЧтениеСхемыXML.УстановитьСтроку(ТекстСхемыXML);
	
	ПостроительDOM = Новый ПостроительDOM;
	ДокументDOM = ПостроительDOM.Прочитать(ЧтениеСхемыXML);
	ЧтениеСхемыXML.Закрыть();
	
	ПостроительСхемXML = Новый ПостроительСхемXML;
	СхемаXML = ПостроительСхемXML.СоздатьСхемуXML(ДокументDOM);
	
	НаборСхемXML = Новый НаборСхемXML;
	НаборСхемXML.Добавить(СхемаXML);
	
	Фабрика = Новый ФабрикаXDTO(НаборСхемXML);
	
	Возврат Фабрика;
	
КонецФункции

#КонецОбласти
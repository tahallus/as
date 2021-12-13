﻿
#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриОбработкеПроизвольногоДействияСообщенияАссистента(ОписаниеСообщения, СтандартнаяОбработка) Экспорт
	
	Если ТипЗнч(ОписаниеСообщения.Данные) = Тип("ХранилищеЗначения") Тогда
		СодержимоеДанныхСообщения = ОписаниеСообщения.Данные.Получить();
		Если ТипЗнч(СодержимоеДанныхСообщения) = Тип("ФиксированнаяСтруктура") Тогда
			ВыполнитьЗадачуАссистентаИнтерактивно(ОписаниеСообщения, СодержимоеДанныхСообщения);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ОписаниеСообщения.ДанныеРазыменованы Тогда
		АссистентУправления.РазыменоватьДанныеСообщенияСВ(ОписаниеСообщения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьДействиеОтменаСообщенияАссистента(ОписаниеСообщения, ОтразитьРезультатСообщением = Истина) Экспорт
	
	АссистентУправления.ОбработатьДействиеОтменаСообщенияАссистента(ОписаниеСообщения, ОтразитьРезультатСообщением);
	
КонецПроцедуры

Процедура ПослеОбработкиДействияСообщенияАссистента(ОписаниеСообщения) Экспорт
	
	АссистентУправления.ПослеОбработкиДействияСообщенияАссистента(ОписаниеСообщения);
	
КонецПроцедуры

Процедура ОтветитьНаСообщениеПользователя(ОписаниеСообщения, ОбрабатываемоеСообщение) Экспорт
	
	АссистентУправления.ОтветитьНаСообщениеПользователя(ОписаниеСообщения, ОбрабатываемоеСообщение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыполнитьЗадачуАссистентаИнтерактивно(ОписаниеСообщения, ДанныеЗадачиСтруктура)
	
	ДополнительныеПараметры = Неопределено;
	Если ДанныеЗадачиСтруктура.Свойство("ДополнительныеПараметры") Тогда
		ДополнительныеПараметры = ДанныеЗадачиСтруктура.ДополнительныеПараметры;
	КонецЕсли;
	
	АссистентУправления.ВыполнитьДействияЗадачи(ДанныеЗадачиСтруктура.Источник, ДанныеЗадачиСтруктура.Событие, ДанныеЗадачиСтруктура.Предмет, ДанныеЗадачиСтруктура.Задача, ДополнительныеПараметры);
	АссистентУправления.ПослеОбработкиДействияСообщенияАссистента(ОписаниеСообщения);
	
	ФоновоеЗадание = ФоновыеЗадания.Выполнить("ОбсужденияУНФ.ЗаписатьОтложенныеСообщенияВСистемуВзаимодействия",,, НСтр("ru = 'Логирование изменений в систему взаимодействия'"));
	
КонецПроцедуры

#КонецОбласти
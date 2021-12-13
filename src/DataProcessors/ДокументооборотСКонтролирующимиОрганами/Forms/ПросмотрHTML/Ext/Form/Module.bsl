﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ИмяФайла) Тогда 
		Заголовок = Параметры.ИмяФайла + " - просмотр";
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Параметры.Содержимое) Тогда 
		Возврат;
	КонецЕсли;
	
	Содержимое = Параметры.Содержимое;
	
	ТипСодержимого = ТипЗнч(Содержимое);
	Если ТипСодержимого = Тип("ДвоичныеДанные") Тогда
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла(Параметры.ИмяФайла);
		Содержимое.Записать(ИмяВременногоФайла);
		КонтекстЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО();
		ТекстСодержимого = КонтекстЭДО.ТекстHTMLСАвтоопределениемКодировки(ИмяВременногоФайла);
		HTMLДокумент = ТекстСодержимого;
		
	ИначеЕсли ТипСодержимого = Тип("ХранилищеЗначения") Тогда
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла(Параметры.ИмяФайла);
		Содержимое.Получить().Записать(ИмяВременногоФайла);
		КонтекстЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО();
		ТекстСодержимого = КонтекстЭДО.ТекстHTMLСАвтоопределениемКодировки(ИмяВременногоФайла);
		HTMLДокумент = ТекстСодержимого;
		
	ИначеЕсли ТипСодержимого = Тип("Строка") Тогда
		// В качестве значения реквизита формы может выступать навигационная ссылка или текст HTML-документа
		HTMLДокумент = Содержимое;
		
	ИначеЕсли ЗначениеЗаполнено(Параметры.ИмяФайла) Тогда
		HTMLДокумент = Параметры.ИмяФайла;
	КонецЕсли;
	
	Если Параметры.Свойство("ПолеНастроекПечати") И ЗначениеЗаполнено(Параметры.ПолеНастроекПечати) Тогда
		ЦиклОбмена = Параметры.ЦиклОбмена;
		ФорматДокументооборота = Параметры.ЦиклОбмена.ФорматДокументооборота;
		ПолеНастроекПечати = Параметры.ПолеНастроекПечати;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	Если ЗначениеЗаполнено(ПолеНастроекПечати) Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПечатьЗавершение", ЭтотОбъект);
		ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
		
	Иначе
		Элементы.ПолеHTMLДокумента.Документ.execCommand("Print");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПечатьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	РезультатНастройки = Новый Структура(ПолеНастроекПечати + ", ФорматДокументооборота", Истина, ФорматДокументооборота);
	КонтекстЭДОКлиент.СформироватьИПоказатьПечатныеДокументы(ЦиклОбмена, РезультатНастройки);
	
КонецПроцедуры

#КонецОбласти


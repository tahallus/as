﻿
#Область СлужебныеПроцедурыФункции

&НаСервере
Процедура ПолучитьНоменклатуру(АдресВременногоХранилища)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("МассивПриходныхНакладных", ПриходныеНакладные.ВыгрузитьЗначения());
	СтруктураПараметров.Вставить("ИспользоватьХарактеристики", ИспользоватьХарактеристики);
	
	Документы.УстановкаЦенНоменклатуры.ПолучитьНоменклатуруПоПриходнымНакладным(СтруктураПараметров, АдресВременногоХранилища)
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтчетСПредварительнымРезультатом()
	
	ПараметрыОткрытия = Новый Структура();
	ПараметрыОткрытия.Вставить("ИмяСКД", 					"ПоПриходнымНакладным");
	ПараметрыОткрытия.Вставить("МассивПриходныхНакладных", 	ПриходныеНакладные.ВыгрузитьЗначения());
	ПараметрыОткрытия.Вставить("ИспользоватьХарактеристики",ИспользоватьХарактеристики);
	
	ОткрытьФорму("Документ.УстановкаЦенНоменклатуры.Форма.ФормаПредварительногоПросмотра", ПараметрыОткрытия, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьВХранилищеДанныеТабличнойЧасти(АдресВременногоХранилища)
	
	ПолучитьНоменклатуру(АдресВременногоХранилища);
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиСообщениеОНеправильномВыборе()
	
	ТекстСообщения = НСтр("ru ='Необходимо заполнить список приходных накладных'");
	ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "ПриходныеНакладные");
	
КонецПроцедуры

#КонецОбласти

#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Только номенклатуру(0); Номенклатуру и ее характеристики(1);
	ИспользоватьХарактеристики = ?(Параметры.ХарактеристикиВидны = Истина, 1, 0);
	Если Параметры.Свойство("ПоказыватьНедействительныеХарактеристики") Тогда
		ПоказыватьНедействительныеХарактеристики = Параметры.ПоказыватьНедействительныеХарактеристики;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		// Обход ошибки платформы 30163126
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДекорацияКартинка", "Ширина", 2);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДекорацияКартинка", "Высота", 0);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура ОК(Команда)
	
	Если ПриходныеНакладные.Количество() > 0 Тогда
		
		АдресВременногоХранилища = "";
		ЗаписатьВХранилищеДанныеТабличнойЧасти(АдресВременногоХранилища);
		
		Закрыть(Новый Структура("ВыборПроизведен, АдресВременногоХранилища", Истина, АдресВременногоХранилища));
		
	Иначе
		
		ВывестиСообщениеОНеправильномВыборе();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредварительныйПросмотр(Команда)
	
	Если ПриходныеНакладные.Количество() > 0 Тогда
		
		ПоказатьОтчетСПредварительнымРезультатом();
		
	Иначе
		
		ВывестиСообщениеОНеправильномВыборе();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


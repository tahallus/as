#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьПараметрыДинамическихСписков();
	
	Номенклатура = Параметры.Номенклатура;
	Характеристика = Параметры.Характеристика;
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
// Процедура устанавливает значения параметров динамических списков 
//
// Значения считываются из реквизитов обработки
//
Процедура УстановитьПараметрыДинамическихСписков()
	
	СписокРасшифровкаРезерва.Параметры.УстановитьЗначениеПараметра("Организация",		Константы.УчетПоКомпании.Компания(Параметры.Организация));
	СписокРасшифровкаРезерва.Параметры.УстановитьЗначениеПараметра("Номенклатура",		Параметры.Номенклатура);
	СписокРасшифровкаРезерва.Параметры.УстановитьЗначениеПараметра("Характеристика",	Параметры.Характеристика);
	
КонецПроцедуры // УстановитьПараметрыДинамическихСписков()

#КонецОбласти


#Область ШтрихкодированиеИСМППереопределяемый

// См. ШтрихкодированиеИСМППереопределяемый.ЗаполнитьПроверяемыеGTIN()
//
Процедура ЗаполнитьПроверяемыеGTIN(ТаблицаПроверки, ПроверяемыеGTIN, СоответствиеGTIN) Экспорт
	
	СоответствиеGTIN = ИнтеграцияИСУНФ.GTINМаркированныхТоваров(ТаблицаПроверки);
	Для Каждого КлючИЗначение Из СоответствиеGTIN Цикл
		ПроверяемыеGTIN.Добавить(КлючИЗначение.Ключ);
	КонецЦикла;
	
	Возврат;
	
КонецПроцедуры
	          
#КонецОбласти
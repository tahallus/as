﻿#Область СлужебныеПроцедурыИФункции

Функция newDocPOST(Запрос)
	
	Тело = Запрос.ПолучитьТелоКакСтроку();
	ИдентификаторыУчетныхЗаписей = ОбщегоНазначенияБЭД.JSONЗначение(Тело);
	ЕстьОшибки = Ложь;
	ОповещенияОСобытияхЭДО.ОповеститьОНовыхДокументахВСервисеЭДО(ИдентификаторыУчетныхЗаписей, ЕстьОшибки);
	
	Если ЕстьОшибки Тогда
		Ответ = Новый HTTPСервисОтвет(500);
		Возврат Ответ;
	КонецЕсли;
	
	Ответ = Новый HTTPСервисОтвет(200);
	Возврат Ответ;
	
КонецФункции

#КонецОбласти


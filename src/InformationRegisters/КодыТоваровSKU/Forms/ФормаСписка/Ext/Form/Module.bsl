﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДоступностьРаботыСКодамиТоваровSKU = Истина;
	
	Если Параметры.Свойство("Номенклатура") Тогда 
		Номенклатура = Параметры.Номенклатура;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Номенклатура",
			Параметры.Номенклатура);
		
		Элементы.Список.ТолькоПросмотр = НЕ ДоступностьРаботыСКодамиТоваровSKU;
	Иначе
		
		Элементы.ФормаСоздатьКодыSKU.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьКодыSKU(Команда)
	
	Если ДоступностьРаботыСКодамиТоваровSKU Тогда
		
		ЗаполнитьАвтоматическиКодыSKU();
		Элементы.Список.Обновить();
		
	Иначе
		
		ПоказатьПредупреждение(,НСтр("ru = 'Создание и удаление SKU осуществляется в главном узле РИБ'"));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьАвтоматическиКодыSKU()
	
	ЗакончилисьSKU = Ложь;
	РегистрыСведений.КодыТоваровSKU.СоздатьSKU(Номенклатура, ЗакончилисьSKU);
	
	Если ЗакончилисьSKU Тогда
		
		ТекстСообщения = НСтр("ru = 'В процессе заполнения закончились доступные SKU коды товара. Операция завершена не полностью.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("Ключ", УчетнаяЗапись) Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
	УчетнаяЗапись,
	"АдресЭлектроннойПочты,ИмяПользователя");
	
	АдресЭлектроннойПочты = ЗначенияРеквизитов.АдресЭлектроннойПочты;
	ИмяОтправителяПисем = ЗначенияРеквизитов.ИмяПользователя;
	
	ПараметрыСинхронизации = ОбменСGoogle.ПараметрыСинхронизации(УчетнаяЗапись);
	
	ВариантЗагрузкиПисем = ПараметрыСинхронизации.ВариантЗагрузки;
	ВариантСинхронизацииПисем = ПараметрыСинхронизации.ВариантСинхронизации;
	ВариантУдаленияПисем = ПараметрыСинхронизации.ВариантУдаления;
	ВариантСостояния = ПараметрыСинхронизации.ВариантСостояния;
	ОтветственныйДляНовыхПисем = ПараметрыСинхронизации.ОтветственныйДляНовыхПисем;
	
	Если Не ПравоДоступа("Изменение", Метаданные.Справочники.УчетныеЗаписиЭлектроннойПочты) Тогда
		Элементы.ИмяОтправителяПисем.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.НастройкиЗагрузкиПисем) Тогда
		Элементы.ВариантЗагрузкиПисем.ТолькоПросмотр = Истина;
		Элементы.ВариантСинхронизацииПисем.ТолькоПросмотр = Истина;
		Элементы.ВариантУдаленияПисем.ТолькоПросмотр = Истина;
		Элементы.ВариантСостояния.ТолькоПросмотр = Истина;
		Элементы.ОтветственныйДляНовыхПисем.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если Элементы.ИмяОтправителяПисем.ТолькоПросмотр И Элементы.ВариантЗагрузкиПисем.ТолькоПросмотр Тогда
		Элементы.ФормаЗаписатьИЗакрыть.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	ПоказатьВопрос(
	Новый ОписаниеОповещения("ОбработатьОтветПользователя", ЭтотОбъект),
	НСтр("ru = 'Данные были изменены. Сохранить изменения?'"),
	РежимДиалогаВопрос.ДаНетОтмена);
	
КонецПроцедуры

#КонецОбласти

#Область КомандыФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьНаСервере();
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьОтветПользователя(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
		Возврат
	КонецЕсли;
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаписатьНаСервере();
		Закрыть();
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере()
	
	УчетнаяЗаписьОбъект = УчетнаяЗапись.ПолучитьОбъект();
	УчетнаяЗаписьОбъект.ИмяПользователя = ИмяОтправителяПисем;
	УчетнаяЗаписьОбъект.Записать();
	
	МенеджерЗаписи = РегистрыСведений.НастройкиЗагрузкиПисем.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.УчетнаяЗапись = УчетнаяЗапись;
	МенеджерЗаписи.ПочтоваяПапка = ОбменСGoogle.ИдентификаторПочтовойПапки(УчетнаяЗапись);
	МенеджерЗаписи.ВариантЗагрузки = ВариантЗагрузкиПисем;
	МенеджерЗаписи.ВариантСинхронизации = ВариантСинхронизацииПисем;
	МенеджерЗаписи.ВариантУдаления = ВариантУдаленияПисем;
	МенеджерЗаписи.ВариантСостояния = ВариантСостояния;
	МенеджерЗаписи.ОтветственныйДляНовыхПисем = ОтветственныйДляНовыхПисем;
	МенеджерЗаписи.Записать();
	
	Модифицированность = Ложь;
	
КонецПроцедуры

#КонецОбласти

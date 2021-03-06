#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ТипНоменклатурыВключен(ПараметрТипНоменклатуры) Экспорт
	
	Если ПараметрТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.ПодарочныйСертификат")
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьПодарочныеСертификаты") Тогда
		Возврат Ложь;
	ИначеЕсли ПараметрТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.ВидРабот")
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьПодсистемуРаботы") Тогда
		Возврат Ложь;
	ИначеЕсли ПараметрТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Работа")
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьПодсистемуРаботы") Тогда
		Возврат Ложь;
	ИначеЕсли ПараметрТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Операция")
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьТехоперации") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#КонецЕсли

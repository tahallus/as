
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	// УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтотОбъект, Объект); // для проверки внедрения БСП
	Если Параметры.Ключ.Пустая() Тогда
		КонтактнаяИнформацияУНФ.ПриСозданииПриЧтенииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	// УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект); // для проверки внедрения БСП
	КонтактнаяИнформацияУНФ.ПриСозданииПриЧтенииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	// УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект); // для проверки внедрения БСП
	КонтактнаяИнформацияУНФ.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	// УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Объект, Отказ); // для проверки
	// внедрения БСП
	КонтактнаяИнформацияУНФ.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

#Область КонтактнаяИнформацияУНФ

&НаСервере
Процедура ДобавитьКонтактнуюИнформациюСервер(ДобавляемыйВид, УстановитьВыводВФормеВсегда = Ложь) Экспорт
	
	КонтактнаяИнформацияУНФ.ДобавитьКонтактнуюИнформацию(ЭтотОбъект, ДобавляемыйВид, УстановитьВыводВФормеВсегда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ДействиеКИНажатие(Элемент)
	
	КонтактнаяИнформацияУНФКлиент.ДействиеКИНажатие(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПредставлениеКИПриИзменении(Элемент)
	
	КонтактнаяИнформацияУНФКлиент.ПредставлениеКИПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПредставлениеКИНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	КонтактнаяИнформацияУНФКлиент.ПредставлениеКИНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПредставлениеКИОчистка(Элемент, СтандартнаяОбработка)
	
	КонтактнаяИнформацияУНФКлиент.ПредставлениеКИОчистка(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КомментарийКИПриИзменении(Элемент)
	
	КонтактнаяИнформацияУНФКлиент.КомментарийКИПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияУНФВыполнитьКоманду(Команда)
	
	КонтактнаяИнформацияУНФКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если Истина Тогда
		
		КонтактнаяИнформацияУНФКлиент.АвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка);
		
	Иначе
		
		// Вызов оставлен для проверки внедрения БСП
		УправлениеКонтактнойИнформациейКлиент.АвтоПодборАдреса(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных,
			Ожидание, СтандартнаяОбработка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Истина Тогда
		
		КонтактнаяИнформацияУНФКлиент.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, Элемент, СтандартнаяОбработка);
		
	Иначе
		
		// Вызов оставлен для проверки внедрения БСП
		УправлениеКонтактнойИнформациейКлиент.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, Элемент.Имя, СтандартнаяОбработка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаВнедренияБСП

// СтандартныеПодсистемы.КонтактнаяИнформация
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	
	УправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.Очистка(ЭтотОбъект, Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	
	УправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда.Имя);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат) Экспорт
	
	УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.КонтактнаяИнформация

#КонецОбласти

#КонецОбласти

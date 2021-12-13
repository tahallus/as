﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Узел = ОбменСКассовымСерверомШтрихМПовтИсп.УзелОбменаШтрих();
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		Если НЕ ЗначениеЗаполнено(Запись.ИдентификаторОбластиНаСервереШтрихМ) Тогда
			Запись.ИдентификаторОбластиНаСервереШтрихМ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Узел, "ИдентификаторОбластиНаСервереШтрихМ");
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Запись.РегистрационныйНомер) Тогда
			Сообщение = НСтр("ru = 'Введите регистрационный номер.'", ОбщегоНазначения.КодОсновногоЯзыка());
			ОбщегоНазначения.СообщитьПользователю(Сообщение,, "РегистрационныйНомер", "Запись.РегистрационныйНомер", Отказ);
			Возврат;
		КонецЕсли;
		
		
		ПроверитьРегистрационныйНомер(Запись.РегистрационныйНомер, Запись.КассаККМ, Отказ);
		
		Если Отказ Тогда
			КлючДанных = РегистрыСведений.НастройкиКассыШтрихМ.СоздатьКлючЗаписи(Новый Структура("КассаККМ", Запись.КассаККМ));
			Сообщение = СтрШаблон(НСтр("ru = 'Регистрационный номер: %1 уже используется.'"), Запись.РегистрационныйНомер);
			ОбщегоНазначения.СообщитьПользователю(Сообщение, КлючДанных, "РегистрационныйНомер",, Отказ);
			Возврат;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьРегистрационныйНомер(НовыйРегистрационныйНомер, СсылкаНаОбъект, Отказ)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	КассовыеАппараты.КассаККМ
	|ИЗ
	|	РегистрСведений.НастройкиКассыШтрихМ КАК КассовыеАппараты
	|ГДЕ
	|	НЕ КассовыеАппараты.КассаККМ = &СсылкаНаОбъект
	|	И КассовыеАппараты.РегистрационныйНомер = &РегистрационныйНомер");
	
	Запрос.УстановитьПараметр("СсылкаНаОбъект", СсылкаНаОбъект);
	Запрос.УстановитьПараметр("РегистрационныйНомер", НовыйРегистрационныйНомер);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
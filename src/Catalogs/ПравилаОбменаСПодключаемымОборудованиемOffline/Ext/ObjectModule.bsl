﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ТипПодключаемогоОборудования = Перечисления.ТипыПодключаемогоОборудования.ККМОфлайн
	 ИЛИ ТипПодключаемогоОборудования = Перечисления.ТипыПодключаемогоОборудования.УдалитьWebСервисОборудование Тогда
	 
		МассивНепроверяемыхРеквизитов.Добавить("ЕдиницаИзмеренияВеса");
		МассивНепроверяемыхРеквизитов.Добавить("СтруктурнаяЕдиница");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить(
		"ЗарегистрироватьИзменения",
		НЕ ЭтоНовый()
		И (ПрефиксВесовогоТовара <> Ссылка.ПрефиксВесовогоТовара
		   ИЛИ ЕдиницаИзмеренияВеса <> Ссылка.ЕдиницаИзмеренияВеса
		)
	);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.ЗарегистрироватьИзменения Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы,
		|	ПодключаемоеОборудование.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|ГДЕ
		|	ПодключаемоеОборудование.ПравилоОбмена = &ПравилоОбмена
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|");
		
		Запрос.УстановитьПараметр("ПравилоОбмена", Ссылка);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			ПланыОбмена.ЗарегистрироватьИзменения(Выборка.УзелИнформационнойБазы, Метаданные.РегистрыСведений.КодыТоваровPLUНаОборудовании);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	ВидЦеныНоменклатуры = Справочники.ВидыЦен.ПолучитьОсновнойВидЦенПродажи();
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Доступные поля загрузки данных из внешнего источника
// 
// Параметры:
// 	ОбъектЗагрузки - СправочникСсылка.ИдентификаторыОбъектовМетаданных - .
// 	ИмяТабличнойЧасти - Строка - .
// 	ВключаяДополнительныеРеквизиты - Булево - .
// 	ПолноеИмяОбъектаЗаполнения - Строка - .
// Возвращаемое значение:
// 	Структура - поля, доступные для загрузки данных из внешнего источника
Функция ДоступныеПоляЗагрузкиДанныхИзВнешнегоИсточника(ОбъектЗагрузки, ИмяТабличнойЧасти = "",
	ВключаяДополнительныеРеквизиты = Ложь, ПолноеИмяОбъектаЗаполнения = "") Экспорт
	Перем ТаблицаПолейЗагрузки;
	
	ДоступныеПоляЗагрузкиДанных = Новый Структура;
	Если НЕ ЗначениеЗаполнено(ОбъектЗагрузки) Тогда
		
		Возврат ДоступныеПоляЗагрузкиДанных;
		
	КонецЕсли;
	
	НастройкиЗагрузкиДанных = Новый Структура;
	НастройкиЗагрузкиДанных.Вставить("СодержаниеВидимо", НЕ ПустаяСтрока(ИмяТабличнойЧасти));
	НастройкиЗагрузкиДанных.Вставить("ПолноеИмяОбъектаЗаполнения", ПолноеИмяОбъектаЗаполнения);
	
	ЗагрузкаДанныхИзВнешнегоИсточника.СоздатьТаблицуПолейОписанияЗагрузки(ТаблицаПолейЗагрузки);
	
	МенеджерОбъектаЗагрузки = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ОбъектЗагрузки.ПолноеИмя);
	МенеджерОбъектаЗагрузки.ПоляЗагрузкиДанныхИзВнешнегоИсточника(ТаблицаПолейЗагрузки, НастройкиЗагрузкиДанных);
	
	Для каждого СтрокаТаблицы Из ТаблицаПолейЗагрузки Цикл
		
		Если СтрокаТаблицы.ИмяПоля = ЗагрузкаДанныхИзВнешнегоИсточника.ИмяПоляДобавленияДополнительныхРеквизитов() Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ДоступныеПоляЗагрузкиДанных.Вставить(СтрокаТаблицы.ИмяПоля, СтрокаТаблицы.ПредставлениеПоля);
		
	КонецЦикла;
	
	Если ВключаяДополнительныеРеквизиты Тогда
		
		Владелец = ВладелецДополнительныхРеквизитовПоПолномуИмени(ОбъектЗагрузки.ПолноеИмя);
		Если Владелец <> Неопределено Тогда
			
			ЗагрузкаДанныхИзВнешнегоИсточника.ПодготовитьСоответствиеПоДополнительнымРеквизитам(
				НастройкиЗагрузкиДанных, Владелец);
			
			Для каждого ЭлементСоответствия Из НастройкиЗагрузкиДанных.ОписаниеДополнительныхРеквизитов Цикл
				
				ДоступныеПоляЗагрузкиДанных.Вставить(ЭлементСоответствия.Значение, ЭлементСоответствия.Ключ);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ДоступныеПоляЗагрузкиДанных;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВладелецДополнительныхРеквизитовПоПолномуИмени(ПолноеИмя)
	
	Если СтрНайти(ПолноеИмя, "Справочник.КонтактныеЛица") > 0 Тогда
		
		Возврат Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_КонтактныеЛица;
		
	ИначеЕсли СтрНайти(ПолноеИмя, "Справочник.Контрагенты") > 0 Тогда
		
		Возврат Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Контрагенты;
		
	ИначеЕсли СтрНайти(ПолноеИмя, "Справочник.Лиды") > 0 Тогда
		
		Возврат Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Лиды;
		
	ИначеЕсли СтрНайти(ПолноеИмя, "Справочник.Номенклатура") > 0 Тогда
		
		Возврат Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Номенклатура;
		
	ИначеЕсли СтрНайти(ПолноеИмя, "Справочник.ХарактеристикиНоменклатуры") > 0 Тогда
		
		Возврат Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_ХарактеристикиНоменклатуры;
		
	ИначеЕсли СтрНайти(ПолноеИмя, "Справочник.Спецификации") > 0 Тогда
		
		Возврат Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Спецификации;
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли

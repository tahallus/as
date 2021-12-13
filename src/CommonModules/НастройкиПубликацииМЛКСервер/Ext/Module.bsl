﻿
#Область ПрограммныйИнтерфейс

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиентаПриЗапуске.
//
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	Параметры.Вставить("НеобходимоОткрытьФормуОпросаКабинетКлиентаУНФ", НеобходимоОткрытьФормуОпросаКабинетКлиента());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция НеобходимоОткрытьФормуОпросаКабинетКлиента() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НастройкиОпросаПоКК = Константы.НастройкиОпросаПоМЛК.Получить().Получить();
	
	Если НастройкиОпросаПоКК <> Неопределено Тогда
		Если НастройкиОпросаПоКК.ОпросЗавершен Или НастройкиОпросаПоКК.КоличествоОткрытийОпроса > 2 Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	НастройкиПубликацииМЛК = Справочники.НастройкиПубликацииМЛК.ПолучитьНастройкиПубликацииМЛК();
	
	Если НастройкиПубликацииМЛК = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	НастройкиИнтеграцииКабинетКлиента = Справочники.НастройкиПубликацииМЛК.НастройкиИнтеграцииКабинетКлиента(НастройкиПубликацииМЛК);
	
	Если НастройкиИнтеграцииКабинетКлиента = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	РеквизитыНастройкиПубликацииМЛК = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НастройкиПубликацииМЛК, "ДатаСоздания, ПоследнийПользователь");
	
	Если ЗначениеЗаполнено(РеквизитыНастройкиПубликацииМЛК.ДатаСоздания) И ЗначениеЗаполнено(РеквизитыНастройкиПубликацииМЛК.ПоследнийПользователь) Тогда
		СравнительнаяДата = ТекущаяДатаСеанса() - 86400 * 5;
		Если РеквизитыНастройкиПубликацииМЛК.ПоследнийПользователь = Пользователи.ТекущийПользователь() И РеквизитыНастройкиПубликацииМЛК.ДатаСоздания < СравнительнаяДата Тогда
			Возврат Истина;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	Иначе
		РежимРаботы = Новый ФиксированнаяСтруктура(УправлениеНебольшойФирмойПовтИсп.РежимРаботыПрограммы());
		Если ЗначениеЗаполнено(РеквизитыНастройкиПубликацииМЛК.ПоследнийПользователь) И РеквизитыНастройкиПубликацииМЛК.ПоследнийПользователь = Пользователи.ТекущийПользователь() Тогда
			Возврат Истина;
		ИначеЕсли РежимРаботы.ЭтоАдминистраторПрограммы Тогда
			Возврат Истина;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецФункции

#КонецОбласти
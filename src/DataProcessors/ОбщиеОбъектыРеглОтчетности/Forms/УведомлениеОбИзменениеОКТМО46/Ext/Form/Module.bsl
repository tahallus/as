﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Организация = Параметры.Организация;
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Информация = ОбработкаОбъект.ПолучитьМакет("ТекстУведомленияОбИзменениеОКТМО46").ПолучитьТекст();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиКИсправлению(Команда)
	
	ИмяФормыРегистрации = "Справочник.РегистрацииВНалоговомОргане.ФормаСписка";
	
	ПараметрыФормыОтбор = Новый Структура;
	ПараметрыФормыОтбор.Вставить("Владелец", Организация);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", ПараметрыФормыОтбор);
	
	ОткрытьФорму(ИмяФормыРегистрации, ПараметрыФормы);
	
	ОтключитьВыводУведомленияПоОрганизации();
	Закрыть(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НапомнитьПозже(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура БольшеНеПоказывать(Команда)
	
	ОтключитьВыводУведомленияПоОрганизации();
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтключитьВыводУведомленияПоОрганизации()
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ХранилищеНастроекДанныхФорм.Сохранить("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.УведомлениеОбИзменениеОКТМО46",
			"УведомлениеОбИзменениеОКТМО46_НеПоказыватьДляОрганизации_" + Организация.УникальныйИдентификатор(),
			Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	СообщениеОбмена = Параметры.СообщениеОбмена;
	НастройкаОбмена = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СообщениеОбмена, "НастройкаОбмена");
	ПрограммаБанка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НастройкаОбмена, "ПрограммаБанка");
	
	Если ПрограммаБанка = Перечисления.ПрограммыБанка.СбербанкОнлайн Тогда
		КлючСохраненияПоложенияОкна = "СбербанкОнлайн";
		Элементы.БИК.Видимость = Ложь;
	Иначе
		КлючСохраненияПоложенияОкна = "ОбменЧерезВК"
	КонецЕсли;
	
	ДанныеЭД = ОбменСБанкамиСлужебныйВызовСервера.ДвоичныеДанныеПрисоединенногоФайла(СообщениеОбмена);
	
	Если ДанныеЭД = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	СтруктураДанных = ОбменСБанкамиСлужебный.СформироватьДеревоРазбора(
		Перечисления.ВидыЭДОбменСБанками.ПлатежноеПоручение, ДанныеЭД);
	
	СуммаЧислом = ДеревоЭлектронногоДокументаБЭД.ЗначениеРеквизитаСтрокиДереваРазбора(
		СтруктураДанных.ДеревоРазбора, СтруктураДанных.СтрокаОбъекта, "Сумма");
	Сумма = Формат(СуммаЧислом, "ЧДЦ=2") + " руб.";
	Получатель = ДеревоЭлектронногоДокументаБЭД.ЗначениеРеквизитаСтрокиДереваРазбора(
		СтруктураДанных.ДеревоРазбора, СтруктураДанных.СтрокаОбъекта, "ПолучательНаименование");
	БИК = ДеревоЭлектронногоДокументаБЭД.ЗначениеРеквизитаСтрокиДереваРазбора(
		СтруктураДанных.ДеревоРазбора, СтруктураДанных.СтрокаОбъекта, "ПолучательБИКБанка");
	НомерСчета = ДеревоЭлектронногоДокументаБЭД.ЗначениеРеквизитаСтрокиДереваРазбора(
		СтруктураДанных.ДеревоРазбора, СтруктураДанных.СтрокаОбъекта, "ПолучательРасчСчет");
		
	ИдентификаторСессии = Параметры.ИдентификаторСессии;
	
	Если Не ЗначениеЗаполнено(ИдентификаторСессии) Тогда
		Элементы.ИдентификаторСессии.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЭлектронныйДокументВладелецФайлаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбменСБанкамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(СообщениеОбмена, , ЭтотОбъект, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПодтвердить(Команда)

	Если ПустаяСтрока(Пароль) Тогда
		ТекстСообщения = НСтр("ru = 'Для продолжения необходимо указать код подтверждения.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Пароль");
		Возврат;
	КонецЕсли;

	Закрыть(Пароль);

КонецПроцедуры

#КонецОбласти

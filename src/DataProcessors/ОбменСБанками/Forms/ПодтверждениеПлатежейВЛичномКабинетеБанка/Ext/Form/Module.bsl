﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МассивНастроек = ОбщегоНазначенияКлиентСервер.СвернутьМассив(Параметры.НастройкиОбмена);
	
	РеквизитыНастроекОбмена = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(МассивНастроек, "АдресЛичногоКабинета, Банк");
	
	Индекс = 0;
	Для каждого ЭлементКоллекции Из РеквизитыНастроекОбмена Цикл
		Индекс = Индекс + 1;
		НовЭлемент = Элементы.Добавить("Банк" + Индекс, Тип("ДекорацияФормы"), Элементы.СписокБанков);
		НовЭлемент.Заголовок = ЭлементКоллекции.Значение.Банк;
		НовЭлемент.Гиперссылка = Истина;
		НовЭлемент.УстановитьДействие("Нажатие", "Подключаемый_НажатиеНаИнформационнуюСсылку");
		НовЭлемент.Подсказка = ЭлементКоллекции.Значение.АдресЛичногоКабинета;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если БольшеНеПоказывать И НЕ ЗавершениеРаботы Тогда
		ОтключитьПоказОкнаПодтвержденияПлатежей();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_НажатиеНаИнформационнуюСсылку()
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(ТекущийЭлемент.Подсказка);
	
КонецПроцедуры

&НаСервере
Процедура ОтключитьПоказОкнаПодтвержденияПлатежей()

	УстановитьПривилегированныйРежим(Истина);
	Для Каждого НастройкаОбмена Из Параметры.НастройкиОбмена Цикл
		НастройкаОбменаОбъект = НастройкаОбмена.ПолучитьОбъект();
		НастройкаОбменаОбъект.ПоказыватьОкноПодтвержденияПлатежей = Ложь;
		НастройкаОбменаОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

﻿#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Отказ = Истина;
	
	КлючНастроекОтправки = НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтправки();
	КлючНастроекОтправки.Отправитель = Запись.Отправитель;
	КлючНастроекОтправки.Получатель = Запись.Получатель;
	КлючНастроекОтправки.Договор = Запись.Договор;
	
	ПараметрыФормы = НастройкиОтправкиЭДОКлиент.НовыеПараметрыФормыНастроекОтправки();
	ПараметрыФормы.КлючНастроекОтправки = КлючНастроекОтправки;
	
	ПараметрыОткрытия = ОбщегоНазначенияБЭДКлиент.НовыеПараметрыОткрытияФормы();
	ПараметрыОткрытия.РежимОткрытияОкна = РежимОткрытияОкнаФормы.Независимый;
	
	НастройкиОтправкиЭДОКлиент.ОткрытьНастройкуОтправки(ПараметрыФормы, ПараметрыОткрытия);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

#КонецОбласти

﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.НастройкаОбмена) Тогда
		ТекущаяЗапись = РегистрыСведений.ПараметрыОбменСБанками.СоздатьМенеджерЗаписи();
		ТекущаяЗапись.НастройкаОбмена = Параметры.НастройкаОбмена;
		ТекущаяЗапись.Прочитать();
		
		// Для новой настройки записей в регистре еще нет
		Если Не ТекущаяЗапись.Выбран() Тогда
			ТекущаяЗапись.НастройкаОбмена = Параметры.НастройкаОбмена;
		КонецЕсли;
	
		ЗначениеВРеквизитФормы(ТекущаяЗапись, "Запись");
		
		РеквизитыНастройкиОбмена = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Параметры.НастройкаОбмена, "ПрограммаБанка, ИспользуетсяКриптография");
		ПрограммаБанка = РеквизитыНастройкиОбмена.ПрограммаБанка;
		ИспользуетсяКриптография = РеквизитыНастройкиОбмена.ИспользуетсяКриптография;
		
	КонецЕсли;
	
	Элементы.КаталогДляЖурналирования.Видимость = ТекущаяЗапись.ИспользоватьЖурналирование
		И (ПрограммаБанка = Перечисления.ПрограммыБанка.ОбменЧерезВК
			ИЛИ ПрограммаБанка = Перечисления.ПрограммыБанка.СбербанкОнлайн И ИспользуетсяКриптография);

	Элементы.ОткрытьЖурнал.Видимость = НЕ Элементы.КаталогДляЖурналирования.Видимость
										И ТекущаяЗапись.ИспользоватьЖурналирование;
										
	Элементы.ДатаПолученияЭД.Видимость = ПрограммаБанка = Перечисления.ПрограммыБанка.АсинхронныйОбмен;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
		Элементы.КаталогДляЖурналирования.КнопкаВыбора = Ложь;
		Оповещение = Новый ОписаниеОповещения("ПослеПодключенияРасширенияДляРаботыСФайламиПриОткрытии", ЭтотОбъект);
		НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
	#КонецЕсли
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Запись.ИспользоватьЖурналирование И Не ЗначениеЗаполнено(Запись.КаталогДляЖурналирования)
		И (ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.ОбменЧерезВК")
			ИЛИ ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.СбербанкОнлайн")
				И ИспользуетсяКриптография) Тогда
		ТекстСообщения = НСтр("ru = 'Укажите каталог для журналирования.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Запись.КаталогДляЖурналирования", , Отказ);
		Возврат;
	КонецЕсли;
	
	Запись.ИдентификаторКлиента = ИдентификаторКлиента;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ИзмененаНастройкаОбменСБанками", Запись.НастройкаОбмена);
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьЖурналированиеПриИзменении(Элемент)

	Элементы.КаталогДляЖурналирования.Видимость = Запись.ИспользоватьЖурналирование
		И (ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.ОбменЧерезВК")
			ИЛИ ПрограммаБанка = ПредопределенноеЗначение("Перечисление.ПрограммыБанка.СбербанкОнлайн")
				И ИспользуетсяКриптография);

	Элементы.ОткрытьЖурнал.Видимость = НЕ Элементы.КаталогДляЖурналирования.Видимость И Запись.ИспользоватьЖурналирование;

КонецПроцедуры

&НаКлиенте
Процедура КаталогДляЖурналированияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Оповещение = Новый ОписаниеОповещения("ПослеВыбораКаталога", ЭтотОбъект);
	ФайловаяСистемаКлиент.ВыбратьКаталог(Оповещение, НСтр("ru = 'Выберите каталог для сохранения файлов журнала.'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЖурналНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура("НастройкаОбмена", Запись.НастройкаОбмена);
	ОткрытьФорму("Обработка.ОбменСБанками.Форма.ЖурналОбмена", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеПодключенияРасширенияДляРаботыСФайламиПриОткрытии(Подключено, ДополнительныеПараметры) Экспорт
	
	Если Подключено Тогда
		Элементы.КаталогДляЖурналирования.КнопкаВыбора = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораКаталога(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = "" Тогда
		Возврат;
	КонецЕсли;
	
	Запись.КаталогДляЖурналирования = Результат;
	
КонецПроцедуры


#КонецОбласти


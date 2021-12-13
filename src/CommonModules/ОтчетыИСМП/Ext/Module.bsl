﻿
#Область ПрограммныйИнтерфейс

// Задает настройки размещения вариантов отчетов в панели отчетов.
//
// Параметры:
//  Настройки - Коллекция - настройки отчетов и вариантов отчетов конфигурации.
//
Процедура НастроитьВариантыОтчетов(Настройки) Экспорт
	
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.КодыМаркировкиДляДекларацииИСМП);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализРасхожденийПриВыводеИзОборотаИСМП);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализРасхожденийПриМаркировкеТоваровИСМП);
	
КонецПроцедуры

// Вызывается при выполнении отчета с помощью метода СкомпоноватьРезультат.
//
Процедура ПриКомпоновкеРезультата(НастройкиОтчета, ВнешниеНаборыДанных = Неопределено) Экспорт
	
	Перем ИмяОтчета, ДанныеИнформационнойБазы;
	
	Если НЕ НастройкиОтчета.ДополнительныеСвойства.Свойство("ИмяОтчета", ИмяОтчета) Тогда
		Возврат;
	КонецЕсли;
	
	СписокОтчетов    = ЗначениеПараметраКомпоновкиДанных(НастройкиОтчета, "ДокументИСМП");
	
	Если ИмяОтчета = Метаданные.Отчеты.КодыМаркировкиДляДекларацииИСМП.Имя Тогда
		ДанныеИнформационнойБазы = Отчеты.КодыМаркировкиДляДекларацииИСМП.ДанныеИнформационнойБазы(СписокОтчетов);
		
	КонецЕсли;
	
	Если ДанныеИнформационнойБазы <> Неопределено Тогда
		ВнешниеНаборыДанных = Новый Структура;
		ВнешниеНаборыДанных.Вставить("ДанныеИнформационнойБазы" + ИмяОтчета, ДанныеИнформационнойБазы);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает значение параметра компоновки данных.
//
// Параметры:
//  НастройкиОтчета - НастройкиКомпоновкиДанных - формируемые настройки отчета,
//  ИмяПараметра - Строка - имя параметра, значение которого требуется получить.
//
Функция ЗначениеПараметраКомпоновкиДанных(НастройкиОтчета, ИмяПараметра) Экспорт
	
	Параметр = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	
	Если Параметр <> Неопределено Тогда
		Возврат Параметр.Значение;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти
﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДата();
	КонецЕсли;
	
	Компания = Константы.УчетПоКомпании.Компания(Объект.Организация);
	
	Элементы.ОперацииПнДлительность.Заголовок = НСтр("ru = 'Пн '") + Формат(Объект.ДатаС, "ДФ=dd.MM");
	Элементы.ОперацииВтДлительность.Заголовок = НСтр("ru = 'Вт '") + Формат(Объект.ДатаС + 86400, "ДФ=dd.MM");
	Элементы.ОперацииСрДлительность.Заголовок = НСтр("ru = 'Ср '") + Формат(Объект.ДатаС + 86400*2, "ДФ=dd.MM");
	Элементы.ОперацииЧтДлительность.Заголовок = НСтр("ru = 'Чт '") + Формат(Объект.ДатаС + 86400*3, "ДФ=dd.MM");
	Элементы.ОперацииПтДлительность.Заголовок = НСтр("ru = 'Пт '") + Формат(Объект.ДатаС + 86400*4, "ДФ=dd.MM");
	Элементы.ОперацииСбДлительность.Заголовок = НСтр("ru = 'Сб '") + Формат(Объект.ДатаС + 86400*5, "ДФ=dd.MM");
	Элементы.ОперацииВсДлительность.Заголовок = НСтр("ru = 'Вс '") + Формат(Объект.ДатаС + 86400*6, "ДФ=dd.MM");
	
	Если НЕ Константы.ФункциональнаяОпцияИспользоватьСовместительство.Получить() Тогда
		Если Элементы.Найти("СотрудникКод") <> Неопределено Тогда
			Элементы.СотрудникКод.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	ПечатьДокументовУНФ.УстановитьОтображениеПодменюПечати(Элементы.ПодменюПечать);
	
	// Характеристики
	УстановитьУсловноеОформлениеФормы();
	Если Параметры.Ключ.Пустая() Тогда
		НоменклатураВДокументахСервер.ЗаполнитьПризнакиИспользованияХарактеристик(Объект, Истина)
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	НоменклатураВДокументахСервер.ЗаполнитьПризнакиИспользованияХарактеристик(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ОценкаПроизводительностиКлиент.ЗамерВремени("Проведение"+ РаботаСФормойДокументаКлиентСервер.ПолучитьИмяФормыСтрокой(ЭтотОбъект.ИмяФормы));
	КонецЕсли;
	// СтандартныеПодсистемы.ОценкаПроизводительности
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	НоменклатураВДокументахСервер.ЗаполнитьПризнакиИспользованияХарактеристик(Объект);
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	// Обработка события изменения организации.
	Объект.Номер = "";
	СтруктураДанные = ПолучитьДанныеОрганизацияПриИзменении(Объект.Организация);
	Компания = СтруктураДанные.Компания;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаСПриИзменении(Элемент)
	
	Объект.ДатаС 	= НачалоНедели(Объект.ДатаС);
	Объект.ДатаПо 	= КонецНедели(Объект.ДатаС);
	
	УстановитьЗаголовкиКолонок();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПоПриИзменении(Элемент)
	
	Объект.ДатаС 	= НачалоНедели(Объект.ДатаПо);
	Объект.ДатаПо 	= КонецНедели(Объект.ДатаПо);
	
	УстановитьЗаголовкиКолонок();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОперации

&НаКлиенте
Процедура ОперацииВидРаботПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Операции.ТекущиеДанные;
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("Номенклатура", 	ТекущаяСтрока.ВидРабот);	
	СтруктураДанные.Вставить("ВидЦен", 			ТекущаяСтрока.ВидЦен);	
	СтруктураДанные.Вставить("ДатаОбработки", 	ДатаДокумента);
	ТекущаяСтрока.Расценка = ПолучитьРасценку(СтруктураДанные).Цена;
	ТекущаяСтрока.Сумма = ТекущаяСтрока.Расценка * ТекущаяСтрока.Всего;
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииРасценкаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Операции.ТекущиеДанные;
	ТекущаяСтрока.Сумма = ТекущаяСтрока.Расценка * ТекущаяСтрока.Всего;
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииСуммаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Операции.ТекущиеДанные;
	ТекущаяСтрока.Расценка = ?(ТекущаяСтрока.Всего = 0, 0, ТекущаяСтрока.Сумма / ТекущаяСтрока.Всего);
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииКомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Операции.ТекущиеДанные;
	ПараметрыФормы = Новый Структура("Текст, Заголовок", ТекущиеДанные.Комментарий, "Редактирование комментария");  
	ВозвращаемыйКомментарий = Неопределено;
  
	ОткрытьФорму("ОбщаяФорма.РедактированиеТекста", ПараметрыФормы,,,,, Новый ОписаниеОповещения("ОперацииКомментарийНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("ТекущиеДанные", ТекущиеДанные))); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииКомментарийНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ТекущиеДанные = ДополнительныеПараметры.ТекущиеДанные;
    
    
    ВозвращаемыйКомментарий = Результат;
    
    Если ТипЗнч(ВозвращаемыйКомментарий) = Тип("Строка") Тогда
        
        Если ТекущиеДанные.Комментарий <> ВозвращаемыйКомментарий Тогда
            Модифицированность = Истина;
        КонецЕсли;
        
        ТекущиеДанные.Комментарий = ВозвращаемыйКомментарий;
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОперацииПнДлительностьПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Операции.ТекущиеДанные;
	
	ДлительностьВСекундах = ТекущиеДанные.ПнДлительность * 3600;	
	ТекущиеДанные.ПнВремяОкончания = ТекущиеДанные.ПнВремяНачала + ДлительностьВСекундах;
	                                       
	Если '00010101235959' - ТекущиеДанные.ПнВремяНачала < ДлительностьВСекундах Тогда	
		ТекущиеДанные.ПнВремяОкончания = '00010101235959';
		ТекущиеДанные.ПнДлительность = РассчитатьДлительность(ТекущиеДанные.ПнВремяНачала, ТекущиеДанные.ПнВремяОкончания);		
	КонецЕсли;
	
	РассчитатьВсего();
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииПнСПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Операции.ТекущиеДанные;
	
	ДлительностьВСекундах = ТекущиеДанные.ПнДлительность * 3600;	
	ТекущиеДанные.ПнВремяОкончания = ТекущиеДанные.ПнВремяНачала + ДлительностьВСекундах;
	                                       
	Если '00010101235959' - ТекущиеДанные.ПнВремяНачала < ДлительностьВСекундах Тогда	
		ТекущиеДанные.ПнВремяОкончания = '00010101235959';
		ТекущиеДанные.ПнДлительность = РассчитатьДлительность(ТекущиеДанные.ПнВремяНачала, ТекущиеДанные.ПнВремяОкончания);		
		РассчитатьВсего(); 
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииПнПоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Операции.ТекущиеДанные;
	Если ТекущиеДанные.ПнВремяНачала > ТекущиеДанные.ПнВремяОкончания Тогда
		ТекущиеДанные.ПнВремяНачала = ТекущиеДанные.ПнВремяОкончания;
	КонецЕсли; 
	
	ТекущиеДанные.ПнДлительность = РассчитатьДлительность(ТекущиеДанные.ПнВремяНачала, ТекущиеДанные.ПнВремяОкончания);
	РассчитатьВсего(); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииВтДлительностьПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Операции.ТекущиеДанные;
	
	ДлительностьВСекундах = ТекущиеДанные.ВтДлительность * 3600;	
	ТекущиеДанные.ВтВремяОкончания = ТекущиеДанные.ВтВремяНачала + ДлительностьВСекундах;
	                                       
	Если '00010101235959' - ТекущиеДанные.ВтВремяНачала < ДлительностьВСекундах Тогда	
		ТекущиеДанные.ВтВремяОкончания = '00010101235959';
		ТекущиеДанные.ВтДлительность = РассчитатьДлительность(ТекущиеДанные.ВтВремяНачала, ТекущиеДанные.ВтВремяОкончания);		
	КонецЕсли;
	
	РассчитатьВсего();
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииВтСПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Операции.ТекущиеДанные;
	
	ДлительностьВСекундах = ТекущиеДанные.ВтДлительность * 3600;	
	ТекущиеДанные.ВтВремяОкончания = ТекущиеДанные.ВтВремяНачала + ДлительностьВСекундах;
	                                       
	Если '00010101235959' - ТекущиеДанные.ВтВремяНачала < ДлительностьВСекундах Тогда	
		ТекущиеДанные.ВтВремяОкончания = '00010101235959';
		ТекущиеДанные.ВтДлительность = РассчитатьДлительность(ТекущиеДанные.ВтВремяНачала, ТекущиеДанные.ВтВремяОкончания);		
		РассчитатьВсего(); 
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииВтПоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Операции.ТекущиеДанные;
	Если ТекущиеДанные.ВтВремяНачала > ТекущиеДанные.ВтВремяОкончания Тогда
		ТекущиеДанные.ВтВремяНачала = ТекущиеДанные.ВтВремяОкончания;
	КонецЕсли; 
	
	ТекущиеДанные.ВтДлительность = РассчитатьДлительность(ТекущиеДанные.ВтВремяНачала, ТекущиеДанные.ВтВремяОкончания);
	РассчитатьВсего(); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииСрДлительностьПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Операции.ТекущиеДанные;
	
	ДлительностьВСекундах = ТекущиеДанные.СрДлительность * 3600;	
	ТекущиеДанные.СрВремяОкончания = ТекущиеДанные.СрВремяНачала + ДлительностьВСекундах;
	                                       
	Если '00010101235959' - ТекущиеДанные.СрВремяНачала < ДлительностьВСекундах Тогда	
		ТекущиеДанные.СрВремяОкончания = '00010101235959';
		ТекущиеДанные.СрДлительность = РассчитатьДлительность(ТекущиеДанные.СрВремяНачала, ТекущиеДанные.СрВремяОкончания);		
	КонецЕсли;
	
	РассчитатьВсего();
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииСрСПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Операции.ТекущиеДанные;
	
	ДлительностьВСекундах = ТекущиеДанные.СрДлительность * 3600;	
	ТекущиеДанные.СрВремяОкончания = ТекущиеДанные.СрВремяНачала + ДлительностьВСекундах;
	                                       
	Если '00010101235959' - ТекущиеДанные.СрВремяНачала < ДлительностьВСекундах Тогда	
		ТекущиеДанные.СрВремяОкончания = '00010101235959';
		ТекущиеДанные.СрДлительность = РассчитатьДлительность(ТекущиеДанные.СрВремяНачала, ТекущиеДанные.СрВремяОкончания);		
		РассчитатьВсего(); 
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииСрПоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Операции.ТекущиеДанные;
	Если ТекущиеДанные.СрВремяНачала > ТекущиеДанные.СрВремяОкончания Тогда
		ТекущиеДанные.СрВремяНачала = ТекущиеДанные.СрВремяОкончания;
	КонецЕсли; 
	
	ТекущиеДанные.СрДлительность = РассчитатьДлительность(ТекущиеДанные.СрВремяНачала, ТекущиеДанные.СрВремяОкончания);
	РассчитатьВсего(); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииЧтДлительностьПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Операции.ТекущиеДанные;
	
	ДлительностьВСекундах = ТекущиеДанные.ЧтДлительность * 3600;	
	ТекущиеДанные.ЧтВремяОкончания = ТекущиеДанные.ЧтВремяНачала + ДлительностьВСекундах;
	                                       
	Если '00010101235959' - ТекущиеДанные.ЧтВремяНачала < ДлительностьВСекундах Тогда	
		ТекущиеДанные.ЧтВремяОкончания = '00010101235959';
		ТекущиеДанные.ЧтДлительность = РассчитатьДлительность(ТекущиеДанные.ЧтВремяНачала, ТекущиеДанные.ЧтВремяОкончания);		
	КонецЕсли;
	
	РассчитатьВсего();
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииЧтСПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Операции.ТекущиеДанные;
	
	ДлительностьВСекундах = ТекущиеДанные.ЧтДлительность * 3600;	
	ТекущиеДанные.ЧтВремяОкончания = ТекущиеДанные.ЧтВремяНачала + ДлительностьВСекундах;
	                                       
	Если '00010101235959' - ТекущиеДанные.ЧтВремяНачала < ДлительностьВСекундах Тогда	
		ТекущиеДанные.ЧтВремяОкончания = '00010101235959';
		ТекущиеДанные.ЧтДлительность = РассчитатьДлительность(ТекущиеДанные.ЧтВремяНачала, ТекущиеДанные.ЧтВремяОкончания);		
		РассчитатьВсего(); 
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииЧтПоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Операции.ТекущиеДанные;
	Если ТекущиеДанные.ЧтВремяНачала > ТекущиеДанные.ЧтВремяОкончания Тогда
		ТекущиеДанные.ЧтВремяНачала = ТекущиеДанные.ЧтВремяОкончания;
	КонецЕсли; 
	
	ТекущиеДанные.ЧтДлительность = РассчитатьДлительность(ТекущиеДанные.ЧтВремяНачала, ТекущиеДанные.ЧтВремяОкончания);
	РассчитатьВсего(); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииПтДлительностьПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Операции.ТекущиеДанные;
	
	ДлительностьВСекундах = ТекущиеДанные.ПтДлительность * 3600;	
	ТекущиеДанные.ПтВремяОкончания = ТекущиеДанные.ПтВремяНачала + ДлительностьВСекундах;
	                                       
	Если '00010101235959' - ТекущиеДанные.ПтВремяНачала < ДлительностьВСекундах Тогда	
		ТекущиеДанные.ПтВремяОкончания = '00010101235959';
		ТекущиеДанные.ПтДлительность = РассчитатьДлительность(ТекущиеДанные.ПтВремяНачала, ТекущиеДанные.ПтВремяОкончания);		
	КонецЕсли;
	
	РассчитатьВсего();
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииПтСПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Операции.ТекущиеДанные;
	
	ДлительностьВСекундах = ТекущиеДанные.ПтДлительность * 3600;	
	ТекущиеДанные.ПтВремяОкончания = ТекущиеДанные.ПтВремяНачала + ДлительностьВСекундах;
	                                       
	Если '00010101235959' - ТекущиеДанные.ПтВремяНачала < ДлительностьВСекундах Тогда	
		ТекущиеДанные.ПтВремяОкончания = '00010101235959';
		ТекущиеДанные.ПтДлительность = РассчитатьДлительность(ТекущиеДанные.ПтВремяНачала, ТекущиеДанные.ПтВремяОкончания);		
		РассчитатьВсего(); 
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииПтПоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Операции.ТекущиеДанные;
	Если ТекущиеДанные.ПтВремяНачала > ТекущиеДанные.ПтВремяОкончания Тогда
		ТекущиеДанные.ПтВремяНачала = ТекущиеДанные.ПтВремяОкончания;
	КонецЕсли; 
	
	ТекущиеДанные.ПтДлительность = РассчитатьДлительность(ТекущиеДанные.ПтВремяНачала, ТекущиеДанные.ПтВремяОкончания);
	РассчитатьВсего(); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииСбДлительностьПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Операции.ТекущиеДанные;
	
	ДлительностьВСекундах = ТекущиеДанные.СбДлительность * 3600;	
	ТекущиеДанные.СбВремяОкончания = ТекущиеДанные.СбВремяНачала + ДлительностьВСекундах;
	                                       
	Если '00010101235959' - ТекущиеДанные.СбВремяНачала < ДлительностьВСекундах Тогда	
		ТекущиеДанные.СбВремяОкончания = '00010101235959';
		ТекущиеДанные.СбДлительность = РассчитатьДлительность(ТекущиеДанные.СбВремяНачала, ТекущиеДанные.СбВремяОкончания);		
	КонецЕсли;
	
	РассчитатьВсего();
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииСбСПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Операции.ТекущиеДанные;
	
	ДлительностьВСекундах = ТекущиеДанные.СбДлительность * 3600;	
	ТекущиеДанные.СбВремяОкончания = ТекущиеДанные.СбВремяНачала + ДлительностьВСекундах;
	                                       
	Если '00010101235959' - ТекущиеДанные.СбВремяНачала < ДлительностьВСекундах Тогда	
		ТекущиеДанные.СбВремяОкончания = '00010101235959';
		ТекущиеДанные.СбДлительность = РассчитатьДлительность(ТекущиеДанные.СбВремяНачала, ТекущиеДанные.СбВремяОкончания);		
		РассчитатьВсего(); 
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииСбПоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Операции.ТекущиеДанные;
	Если ТекущиеДанные.СбВремяНачала > ТекущиеДанные.СбВремяОкончания Тогда
		ТекущиеДанные.СбВремяНачала = ТекущиеДанные.СбВремяОкончания;
	КонецЕсли; 
	
	ТекущиеДанные.СбДлительность = РассчитатьДлительность(ТекущиеДанные.СбВремяНачала, ТекущиеДанные.СбВремяОкончания);
	РассчитатьВсего(); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииВсДлительностьПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Операции.ТекущиеДанные;
	
	ДлительностьВСекундах = ТекущиеДанные.ВсДлительность * 3600;	
	ТекущиеДанные.ВсВремяОкончания = ТекущиеДанные.ВсВремяНачала + ДлительностьВСекундах;
	                                       
	Если '00010101235959' - ТекущиеДанные.ВсВремяНачала < ДлительностьВСекундах Тогда	
		ТекущиеДанные.ВсВремяОкончания = '00010101235959';
		ТекущиеДанные.ВсДлительность = РассчитатьДлительность(ТекущиеДанные.ВсВремяНачала, ТекущиеДанные.ВсВремяОкончания);		
	КонецЕсли;
	
	РассчитатьВсего();
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииВсСПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Операции.ТекущиеДанные;
	
	ДлительностьВСекундах = ТекущиеДанные.ВсДлительность * 3600;	
	ТекущиеДанные.ВсВремяОкончания = ТекущиеДанные.ВсВремяНачала + ДлительностьВСекундах;
	                                       
	Если '00010101235959' - ТекущиеДанные.ВсВремяНачала < ДлительностьВСекундах Тогда	
		ТекущиеДанные.ВсВремяОкончания = '00010101235959';
		ТекущиеДанные.ВсДлительность = РассчитатьДлительность(ТекущиеДанные.ВсВремяНачала, ТекущиеДанные.ВсВремяОкончания);		
		РассчитатьВсего(); 
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииВсПоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Операции.ТекущиеДанные;
	Если ТекущиеДанные.ВсВремяНачала > ТекущиеДанные.ВсВремяОкончания Тогда
		ТекущиеДанные.ВсВремяНачала = ТекущиеДанные.ВсВремяОкончания;
	КонецЕсли; 
	
	ТекущиеДанные.ВсДлительность = РассчитатьДлительность(ТекущиеДанные.ВсВремяНачала, ТекущиеДанные.ВсВремяОкончания);
	РассчитатьВсего(); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииЗаказчикОбработкаВыбораВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
	
		СтандартнаяОбработка = Ложь;
		
		ВыбранныйДоговор = Неопределено;

		
		ОткрытьФорму("Справочник.ДоговорыКонтрагентов.Форма.ФормаВыбораСКонтрагентом",,,,,, Новый ОписаниеОповещения("ОперацииЗаказчикОбработкаВыбораВыбораЗавершение", ЭтотОбъект));
	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииЗаказчикОбработкаВыбораВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ВыбранныйДоговор = Результат;
    
    Если ТипЗнч(ВыбранныйДоговор) = Тип("СправочникСсылка.ДоговорыКонтрагентов")Тогда
        Элементы.Операции.ТекущиеДанные.Заказчик = ВыбранныйДоговор;
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОперацииНоменклатураПриИзменении(Элемент)

СтрокаТабличнойЧасти = Элементы.Операции.ТекущиеДанные;	

//Характеристики
СтруктураДанные = Новый Структура();
СтруктураДанные.Вставить("Номенклатура", СтрокаТабличнойЧасти.Номенклатура);
СтруктураДанные.Вставить("Характеристика", СтрокаТабличнойЧасти.Характеристика);

СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);

СтрокаТабличнойЧасти.ИспользоватьХарактеристики = СтруктураДанные.ИспользоватьХарактеристики;
СтрокаТабличнойЧасти.ПроверятьЗаполнениеХарактеристики = СтруктураДанные.ПроверятьЗаполнениеХарактеристики;
СтрокаТабличнойЧасти.ЗаполнениеХарактеристикиПроверено = Истина;

Если СтруктураДанные.ИспользоватьХарактеристики Тогда
	Если ПодборНоменклатурыИзСписка И ТипЗнч(СтруктураВыбораНоменклатуры) = Тип("Структура") Тогда
		СтрокаТабличнойЧасти.Характеристика = СтруктураВыбораНоменклатуры.Характеристика;
		СтруктураВыбораНоменклатуры.Характеристика = Неопределено;
	Иначе
		СтрокаТабличнойЧасти.Характеристика = СтруктураДанные.Характеристика;
	КонецЕсли;
КонецЕсли;

ПодборНоменклатурыИзСписка = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура ОперацииНоменклатураОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		Если НЕ ТипЗнч(СтруктураВыбораНоменклатуры) = Тип("Структура") Тогда
			СтруктураВыбораНоменклатуры = Новый Структура("Характеристика");
		КонецЕсли;
		
		ПодборНоменклатурыИзСписка = ВыбранноеЗначение.Свойство("Ячейка");
		
		СтруктураВыбораНоменклатуры.Характеристика = ВыбранноеЗначение.Характеристика;
		СтрокаТабличнойЧасти = Элементы.Операции.ТекущиеДанные;
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ВыбранноеЗначение);
		ВыбранноеЗначение = ВыбранноеЗначение.Номенклатура;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоПлану(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Не заполнена организация! Заполнение отменено.'");
		Сообщение.Поле = "Объект.Организация";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.СтруктурнаяЕдиница) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Не заполнено подразделение! Заполнение отменено.'");
		Сообщение.Поле = "Объект.СтруктурнаяЕдиница";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Не выбран сотрудник! Заполнение отменено.'");
		Сообщение.Поле = "Объект.Сотрудник";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.ДатаС) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Не выбрано начало недели! Заполнение отменено.'");
		Сообщение.Поле = "Объект.ДатаС";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.ДатаПо) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Не выбрано окончание недели! Заполнение отменено.'");
		Сообщение.Поле = "Объект.ДатаПо";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;

	Если Объект.Операции.Количество() > 0 Тогда
		Ответ = Неопределено;
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьПоПлануЗавершение", ЭтотОбъект), НСтр("ru = 'Табличная часть документа будет очищена! Продолжить выполнение операции?'"), РежимДиалогаВопрос.ДаНет, 0);
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПоПлануФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПлануЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Ответ = Результат;
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли; 
    
    ЗаполнитьПоПлануФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПлануФрагмент()
	
	Объект.Операции.Очистить();
	ЗаполнитьПоПлануНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеДатаПриИзменении(ДокументСсылка, ДатаНовая, ДатаПередИзменением)
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("РазностьДат", ДокументыУНФ.ПроверитьНомерДокумента(ДокументСсылка, ДатаНовая, ДатаПередИзменением));
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеДатаПриИзменении()

&НаСервереБезКонтекста
Функция ПолучитьДанныеОрганизацияПриИзменении(Организация)
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("Компания", Константы.УчетПоКомпании.Компания(Организация));
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеОрганизацияПриИзменении()

&НаСервереБезКонтекста
Функция ПолучитьРасценку(СтруктураДанные)
	
	СтруктураДанные.Вставить("Характеристика", Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка());
	СтруктураДанные.Вставить("СуммаВключаетНДС", СтруктураДанные.ВидЦен.ЦенаВключаетНДС);
	СтруктураДанные.Вставить("ВалютаДокумента", СтруктураДанные.ВидЦен.ВалютаЦены);
	СтруктураДанные.Вставить("Коэффициент", 1);
	
	СтруктураДанные.Вставить("Цена", ЦенообразованиеСервер.ПолучитьЦенуНоменклатурыПоВидуЦен(СтруктураДанные));
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеНоменклатураПриИзменении()	

&НаКлиенте
Процедура РассчитатьВсего()

	ТекущаяСтрока = Элементы.Операции.ТекущиеДанные;
	ТекущаяСтрока.Всего = ТекущаяСтрока.ПнДлительность + ТекущаяСтрока.ВтДлительность + ТекущаяСтрока.СрДлительность 
							+ ТекущаяСтрока.ЧтДлительность + ТекущаяСтрока.ПтДлительность + ТекущаяСтрока.СбДлительность  
							+ ТекущаяСтрока.ВсДлительность;
	ТекущаяСтрока.Сумма = ТекущаяСтрока.Расценка * ТекущаяСтрока.Всего;
		
КонецПроцедуры

&НаКлиенте
Функция РассчитатьДлительность(ВремяНачала, ВремяОкончания)
	
	ВремяОкончания = ?(Минута(ВремяОкончания) = 59, КонецМинуты(ВремяОкончания), НачалоМинуты(ВремяОкончания));
	
	ДлительностьВСекундах = ВремяОкончания - ВремяНачала;	
	Возврат Окр(ДлительностьВСекундах / 3600, 2);
	
КонецФункции

&НаКлиенте
Процедура УстановитьЗаголовкиКолонок()

	Элементы.ОперацииПнДлительность.Заголовок = НСтр("ru = 'Пн '") + Формат(Объект.ДатаС, "ДФ=dd.MM");
	Элементы.ОперацииВтДлительность.Заголовок = НСтр("ru = 'Вт '") + Формат(Объект.ДатаС + 86400, "ДФ=dd.MM");
	Элементы.ОперацииСрДлительность.Заголовок = НСтр("ru = 'Ср '") + Формат(Объект.ДатаС + 86400*2, "ДФ=dd.MM");
	Элементы.ОперацииЧтДлительность.Заголовок = НСтр("ru = 'Чт '") + Формат(Объект.ДатаС + 86400*3, "ДФ=dd.MM");
	Элементы.ОперацииПтДлительность.Заголовок = НСтр("ru = 'Пт '") + Формат(Объект.ДатаС + 86400*4, "ДФ=dd.MM");
	Элементы.ОперацииСбДлительность.Заголовок = НСтр("ru = 'Сб '") + Формат(Объект.ДатаС + 86400*5, "ДФ=dd.MM");
	Элементы.ОперацииВсДлительность.Заголовок = НСтр("ru = 'Вс '") + Формат(Объект.ДатаС + 86400*6, "ДФ=dd.MM");

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоПлануНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаданиеНаРаботуРаботы.ВидРабот КАК ВидРабот,
	|	ЗаданиеНаРаботуРаботы.Заказчик КАК Заказчик,
	|	ЗаданиеНаРаботуРаботы.Номенклатура КАК Номенклатура,
	|	ЗаданиеНаРаботуРаботы.Характеристика КАК Характеристика,
	|	ЗаданиеНаРаботуРаботы.Ссылка.ВидЦен КАК ВидЦен,
	|	ЗаданиеНаРаботуРаботы.Цена КАК Расценка,
	|	ЗаданиеНаРаботуРаботы.Трудоемкость КАК Трудоемкость,
	|	ЗаданиеНаРаботуРаботы.ДатаНачала КАК ДатаНачала,
	|	ЗаданиеНаРаботуРаботы.ДатаОкончания КАК ДатаОкончания
	|ИЗ
	|	Документ.ЗаданиеНаРаботу.Работы КАК ЗаданиеНаРаботуРаботы,
	|	Константы КАК Константы
	|ГДЕ
	|	ЗаданиеНаРаботуРаботы.Ссылка.Проведен
	|	И ЗаданиеНаРаботуРаботы.Ссылка.СтруктурнаяЕдиница = &СтруктурнаяЕдиница
	|	И ЗаданиеНаРаботуРаботы.Ссылка.Сотрудник = &Сотрудник
	|	И ВЫБОР
	|			КОГДА Константы.УчетПоКомпании
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЗаданиеНаРаботуРаботы.Ссылка.Организация = &Организация
	|		КОНЕЦ
	|	И ЗаданиеНаРаботуРаботы.Трудоемкость > 0
	|	И ЗаданиеНаРаботуРаботы.ДатаНачала МЕЖДУ &ДатаС И &ДатаПо";
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", Объект.СтруктурнаяЕдиница);
	Запрос.УстановитьПараметр("Сотрудник", Объект.Сотрудник);
	Запрос.УстановитьПараметр("ДатаС", НачалоДня(Объект.ДатаС));
	Запрос.УстановитьПараметр("ДатаПо", КонецДня(Объект.ДатаПо));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Объект.Операции.Добавить();
		НоваяСтрока.ВидЦен = Выборка.ВидЦен;
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка, "ВидРабот,Заказчик,Номенклатура,Характеристика,Расценка");
		
		НомерПоследнегоДняНедели = ДеньНедели(Мин(Объект.ДатаПо, Выборка.ДатаОкончания));
		ТекНомерДняНедели = ДеньНедели(Выборка.ДатаНачала);
		ОставшаясяТрудоемкость = Выборка.Трудоемкость;
		
		Пока ТекНомерДняНедели <= НомерПоследнегоДняНедели И ОставшаясяТрудоемкость > 0 Цикл
			
			ИмяДня = ИмяДняНедели(ТекНомерДняНедели);
			
			НачалоТекущегоДня   = '00010101000000';
			КонецТекущегоДня    = '00010101235959';
			НачалоСледующегоДня = '00010102';
			
			НоваяСтрока[ИмяДня + "ВремяНачала"] = ?(ТекНомерДняНедели = ДеньНедели(Выборка.ДатаНачала), ВыделитьВремяИзДаты(Выборка.ДатаНачала), НачалоТекущегоДня);
			НоваяСтрока[ИмяДня + "Длительность"] = Мин((НачалоСледующегоДня - НоваяСтрока[ИмяДня + "ВремяНачала"]) / 3600, ОставшаясяТрудоемкость);
			
			Если НоваяСтрока[ИмяДня + "Длительность"] = 24 Тогда
				ВремяОкончания = КонецТекущегоДня;
			Иначе
				ВремяОкончания = НоваяСтрока[ИмяДня + "ВремяНачала"] + НоваяСтрока[ИмяДня + "Длительность"] * 3600;
			КонецЕсли;
			
			Если ВремяОкончания >= НачалоСледующегоДня Тогда
				ВремяОкончания = КонецТекущегоДня;
			КонецЕсли;
			
			НоваяСтрока[ИмяДня + "ВремяОкончания"] = ВремяОкончания;
			
			ТекНомерДняНедели = ТекНомерДняНедели + 1;
			ОставшаясяТрудоемкость = ОставшаясяТрудоемкость - НоваяСтрока[ИмяДня + "Длительность"];
			
		КонецЦикла;
		
		НоваяСтрока.Всего = Выборка.Трудоемкость - ОставшаясяТрудоемкость;
		НоваяСтрока.Сумма = НоваяСтрока.Всего * НоваяСтрока.Расценка;
		
	КонецЦикла;
	
	НоменклатураВДокументахСервер.ЗаполнитьПризнакиИспользованияХарактеристик(Объект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИмяДняНедели(НомерДняНедели)
	
	ДниНедели = Новый Массив;
	ДниНедели.Добавить("Пн");
	ДниНедели.Добавить("Вт");
	ДниНедели.Добавить("Ср");
	ДниНедели.Добавить("Чт");
	ДниНедели.Добавить("Пт");
	ДниНедели.Добавить("Сб");
	ДниНедели.Добавить("Вс");
	
	Возврат ДниНедели[НомерДняНедели - 1];
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ВыделитьВремяИзДаты(Дата)
	
	Возврат '00010101' + (Дата - НачалоДня(Дата));
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеФормы()
	
	УсловноеОформление.Элементы.Очистить();
	
	ТекстПустаяДата = Формат(Дата('00010101'), "ДП='00:00'");
	
	// 1.
	НовоеУсловноеОформление = УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Объект.Операции.ПнВремяНачала",,    ВидСравненияКомпоновкиДанных.НеЗаполнено);
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Объект.Операции.ПнВремяОкончания",, ВидСравненияКомпоновкиДанных.Заполнено);
	РаботаСФормой.ДобавитьОформляемоеПоле(НовоеУсловноеОформление, Элементы.ОперацииПнВремяНачала.Имя);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "Текст", ТекстПустаяДата);
	
	НовоеУсловноеОформление = УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Объект.Операции.ВтВремяНачала",,    ВидСравненияКомпоновкиДанных.НеЗаполнено);
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Объект.Операции.ВтВремяОкончания",, ВидСравненияКомпоновкиДанных.Заполнено);
	РаботаСФормой.ДобавитьОформляемоеПоле(НовоеУсловноеОформление, Элементы.ОперацииВтВремяНачала.Имя);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "Текст", ТекстПустаяДата);
	
	НовоеУсловноеОформление = УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Объект.Операции.СрВремяНачала",,    ВидСравненияКомпоновкиДанных.НеЗаполнено);
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Объект.Операции.СрВремяОкончания",, ВидСравненияКомпоновкиДанных.Заполнено);
	РаботаСФормой.ДобавитьОформляемоеПоле(НовоеУсловноеОформление, Элементы.ОперацииСрВремяНачала.Имя);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "Текст", ТекстПустаяДата);
	
	НовоеУсловноеОформление = УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Объект.Операции.ЧтВремяНачала",,    ВидСравненияКомпоновкиДанных.НеЗаполнено);
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Объект.Операции.ЧтВремяОкончания",, ВидСравненияКомпоновкиДанных.Заполнено);
	РаботаСФормой.ДобавитьОформляемоеПоле(НовоеУсловноеОформление, Элементы.ОперацииЧтВремяНачала.Имя);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "Текст", ТекстПустаяДата);
	
	НовоеУсловноеОформление = УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Объект.Операции.ПтВремяНачала",,    ВидСравненияКомпоновкиДанных.НеЗаполнено);
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Объект.Операции.ПтВремяОкончания",, ВидСравненияКомпоновкиДанных.Заполнено);
	РаботаСФормой.ДобавитьОформляемоеПоле(НовоеУсловноеОформление, Элементы.ОперацииПтВремяНачала.Имя);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "Текст", ТекстПустаяДата);
	
	НовоеУсловноеОформление = УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Объект.Операции.СбВремяНачала",,    ВидСравненияКомпоновкиДанных.НеЗаполнено);
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Объект.Операции.СбВремяОкончания",, ВидСравненияКомпоновкиДанных.Заполнено);
	РаботаСФормой.ДобавитьОформляемоеПоле(НовоеУсловноеОформление, Элементы.ОперацииСбВремяНачала.Имя);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "Текст", ТекстПустаяДата);
	
	НовоеУсловноеОформление = УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Объект.Операции.ВсВремяНачала",,    ВидСравненияКомпоновкиДанных.НеЗаполнено);
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Объект.Операции.ВсВремяОкончания",, ВидСравненияКомпоновкиДанных.Заполнено);
	РаботаСФормой.ДобавитьОформляемоеПоле(НовоеУсловноеОформление, Элементы.ОперацииВсВремяНачала.Имя);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "Текст", ТекстПустаяДата);
	
	// 2.
	НаименованиеПоляХарактеристика = "ОперацииХарактеристика";
	
	ЗначениеПоиска = ЭтаФорма.Элементы.Найти(НаименованиеПоляХарактеристика);
	
	Если НЕ ЗначениеПоиска = Неопределено Тогда
		ИмяПоляПроверятьЗаполнениеХарактеристики = "Объект.Операции.ПроверятьЗаполнениеХарактеристики";
		ИмяПоляИспользоватьХарактеристики = "Объект.Операции.ИспользоватьХарактеристики";
		ИмяПоляХарактеристики = НаименованиеПоляХарактеристика; 
		
		НовоеУсловноеОформление = ЭтаФорма.УсловноеОформление.Элементы.Добавить();
		РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, ИмяПоляИспользоватьХарактеристики, Ложь, ВидСравненияКомпоновкиДанных.Равно);

		РаботаСФормой.ДобавитьОформляемыеПоля(НовоеУсловноеОформление, ИмяПоляХарактеристики);
		РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "Текст", НСтр("ru = '<Не используется>'"));
		РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ТолькоПросмотр", Истина);
		РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекстаТабличнойЧасти);
		
		НовоеУсловноеОформление = ЭтаФорма.УсловноеОформление.Элементы.Добавить();
		РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, ИмяПоляПроверятьЗаполнениеХарактеристики, Истина, ВидСравненияКомпоновкиДанных.Равно);
		
		РаботаСФормой.ДобавитьОформляемыеПоля(НовоеУсловноеОформление, ИмяПоляХарактеристики);
		РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ОтметкаНезаполненного", Истина);
		
		НовоеУсловноеОформление = ЭтаФорма.УсловноеОформление.Элементы.Добавить();
		РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Объект.Операции.Характеристика", Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка(), ВидСравненияКомпоновкиДанных.НеРавно);
		РаботаСФормой.ДобавитьОформляемыеПоля(НовоеУсловноеОформление, ИмяПоляХарактеристики);
		РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ОтметкаНезаполненного", Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные)
	
	// Характеристики
	СтруктураДанные.Вставить("ИспользоватьХарактеристики",Ложь);
	СтруктураДанные.Вставить("ПроверятьЗаполнениеХарактеристики",Ложь);
	
	Если ЗначениеЗаполнено(СтруктураДанные.Номенклатура) И СтруктураДанные.Номенклатура.ИспользоватьХарактеристики
		Тогда
		ЗначенияПоУмолчанию = НоменклатураВДокументахСервер.ЗначенияНоменклатурыПоУмолчанию(СтруктураДанные.Номенклатура);
		
		Если Не ЗначенияПоУмолчанию = Неопределено
			Тогда		
			ХарактеристикаПоУмолчанию = ЗначенияПоУмолчанию;
		КонецЕсли;
		
		Если НЕ СтруктураДанные.Свойство("Характеристика") Тогда
			СтруктураДанные.Вставить("Характеристика",ХарактеристикаПоУмолчанию);
		Иначе
			СтруктураДанные.Характеристика = ?(ЗначениеЗаполнено(СтруктураДанные.Характеристика), СтруктураДанные.Характеристика, ХарактеристикаПоУмолчанию);
		КонецЕсли;
		
		СтруктураДанные.Вставить("ИспользоватьХарактеристики",Истина);
		СтруктураДанные.Вставить("ПроверятьЗаполнениеХарактеристики",СтруктураДанные.Номенклатура.ПроверятьЗаполнениеХарактеристики);
	КонецЕсли; 
	// Конец Характеристики
	
	Возврат СтруктураДанные;
	
КонецФункции

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

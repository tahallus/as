﻿#Область ПрограммныйИнтерфейс

// Возвращает соответствие ключей идентификаторов применения и свойств идентификатора
//
// Возвращаемое значение:
// 	Соответствие Из КлючИЗначение - Идентификаторы применения:
// 	 * Ключ     - Строка    - Ключ идентификатора, заданный без скобок. Ключ задается без дополнительного параметра.
// 	                          Только цифровые символы ключа идентификатора. Например, код "310X" будет преобразован в "310".
// 	                          Например, для МассаНеттоВКг задается один ключ 310, вместо ключей 3100, 3101, 3102, 3103 и т.д.
// 	 * Значение - Структура - Ключи:
// 	    ** ИмяИдентификатора  - Строка - Имя идентификатора в верхнем регистре, например, "МАССАНЕТТОВКГ".
// 	    ** ПредставлениеИдентификатора - Строка - пользовательское представление имени идентификатора, например, "Масса нетто в кг. (310x)"
// 	    ** ПредставлениеИдентификатораДляУпорядочивания - Строка - Пользовательское представление имени идентификатора, ключ идентификатора с нецифровыми символами указывается в начале. 
// 	                                                               Используется в списках, где упорядочивание идет по представлению. Например, "(310Х) Масса нетто в кг.".
// 	    ** ДлинаКода          - Число - Максимальная длина параметра в штрихкоде.
// 	    ** ЗначениеПеременнойДлины - Булево - Признак переменной длины параметра в штрихкоде.
// 	    ** ДополнительныйПараметрИмя - Строка - Имя дополнительного параметра. Если доп. параметра нет, то пустая строка.
// 	    ** ДлинаДопПараметра  - Число - Длина дополнительного параметра. Дополнительный параметр указывается сразу после
// 	                                   ключа идентификатора. Например 3103: 310 - ключ идентификатора, 3 - дополнительный параметр,
// 	                                   указывающий количество дробных знаков. Если доп.параметра нет, то 0.
// 	    ** ДополнительныйПараметрМинимальноеЗначение  - Число - Значение по умолчанию - 0.
// 	    ** ДополнительныйПараметрМаксимальноеЗначение - Число - Значение по умолчанию - 0.
// 	    ** ДополнительныйПараметрПредставление - Строка - Представление дополнительного параметра.
// 	    ** БазовыйТипДанных - ОписаниеТипов - Описание типов данных для значения идентификатора GS1. Может уточняться в зависимости
// 	                                                  от значения дополнительного параметра.
//
Функция СвойстваКлючейИдентификаторовПрименения() Экспорт
	
	Возврат ШтрихкодыУпаковокВызовСервера.ПрочитатьСвойстваКлючейИдентификаторовПрименения();
	
КонецФункции

// Возвращает соответствие Идентификатор применения - ключ идентификатора (без скобок)
//
// Возвращаемое значение:
// 	Соответствие Из КлючИЗначение - Идентификаторы применения:
// 	  * Ключ     - Строка - Имя идентификатора применения
// 	  * Значение - Строка - Ключ идентификатора применения, заданный без скобок
//
Функция КлючиИдентификаторовПрименения() Экспорт
	СвойстваКлючейИдентификаторов = СвойстваКлючейИдентификаторовПрименения();
	
	КлючиИдентификаторов = Новый Соответствие;
	
	Для каждого КлючИЗначение Из СвойстваКлючейИдентификаторов Цикл
		КлючиИдентификаторов.Вставить(КлючИЗначение.Значение.ИмяИдентификатора, КлючИЗначение.Ключ);
	КонецЦикла;
	
	Возврат КлючиИдентификаторов;
КонецФункции

// Возвращаем массив структур Идентификатор колонки - возможный тип значения колонки
//
// Параметры:
// 	ТипШтрихкода - ПеречислениеСсылка.ТипыШтрихкодов - Тип штрихкода
//
// Возвращаемое значение:
// 	Соответствие Из КлючИЗначение:
// 	 * Ключ - Строка - Идентификатор колонки - Для типов штрихкодов "GS1-128" и "GS1-DataBar Expanded Stacked"
// 	                                           идентификатором колонки является ключ идентификатора применения GS1 (код).
// 	                                           Для других типов штрихкодов задается как имя свойства, перечисленного в методах
// 	                                           ШтрихкодыУпаковокКлиентСервер.ПараметрыШтрихкодаSSCC
// 	                                           и ШтрихкодыУпаковокКлиентСервер.ПараметрыШтрихкодаCode128.
// 	 * Значение - ОписаниеТипов - Описание типов возможного значения
//
Функция ТипыКолонокПечатиПоТипуШтрихкода(ТипШтрихкода) Экспорт
	
	ТипыКолонок = Новый Соответствие;
	
	Если ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.Code128") Тогда
		ТипыКолонок.Вставить("ИдентификаторОрганизации", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(12, ДопустимаяДлина.Переменная)));
		ТипыКолонок.Вставить("ДатаМаркировки", Новый ОписаниеТипов("Дата",,,,, Новый КвалификаторыДаты(ЧастиДаты.Дата)));
		ТипыКолонок.Вставить("НомерПоПорядку", Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(9, 0, ДопустимыйЗнак.Неотрицательный)));
		ТипыКолонок.Вставить("ТипЛогистическойЕдиницы", Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(1, 0, ДопустимыйЗнак.Неотрицательный)));
		ТипыКолонок.Вставить("НомерПлощадкиМаркировки", Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(2, 0, ДопустимыйЗнак.Неотрицательный)));
		ТипыКолонок.Вставить("ГодГенерацииШтрихкода", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(4, ДопустимаяДлина.Переменная)));
	ИначеЕсли ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.SSCC") Тогда
		ТипыКолонок.Вставить("ЦифраРасширения",    Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(1, 0, ДопустимыйЗнак.Неотрицательный)));
		ТипыКолонок.Вставить("ПрефиксКомпанииGS1", Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(9, 0, ДопустимыйЗнак.Неотрицательный)));
		ТипыКолонок.Вставить("СерийныйНомерSSCC",  Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(7, 0, ДопустимыйЗнак.Неотрицательный)));
		ТипыКолонок.Вставить("КонтрольноеЧисло",   Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(1, 0, ДопустимыйЗнак.Неотрицательный)));
	ИначеЕсли ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.GS1_128")
		Или ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.GS1_DataBarExpandedStacked")
		Или ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.GS1_DataMatrix") Тогда
		
		СвойстваИдентификаторов = ШтрихкодыУпаковокКлиентСерверПовтИсп.СвойстваКлючейИдентификаторовПрименения();
		Для каждого КлючИЗначение Из СвойстваИдентификаторов Цикл
			
			КлючИдентификатора = КлючИЗначение.Ключ;
			ТипПараметра = КлючИЗначение.Значение.БазовыйТипДанных;
			Если ТипПараметра.СодержитТип(Тип("Число"))
			И КлючИЗначение.Значение.ДополнительныйПараметрИмя = ВРЕГ("ЧислоЗнаковПослеЗапятой") Тогда
				// Корректируем базовый тип, он должен предусматривать возможность установки максимального количества
				// знаков после запятой, а также иметь максимальное количество значимых разрядов
				ЧислоЗнаковПослеЗапятой = КлючИЗначение.Значение.ДополнительныйПараметрМаксимальноеЗначение;
				ОбщееЧислоРазрядов = КлючИЗначение.Значение.ДлинаКода
					+ КлючИЗначение.Значение.ДополнительныйПараметрМаксимальноеЗначение;
				ТипПараметра = Новый ОписаниеТипов(ТипПараметра,,,
					Новый КвалификаторыЧисла(ОбщееЧислоРазрядов, ЧислоЗнаковПослеЗапятой, ДопустимыйЗнак.Неотрицательный));
				
			КонецЕсли;
			ТипыКолонок.Вставить(КлючИдентификатора, ТипПараметра);
			
		КонецЦикла;
	ИначеЕсли ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.PDF417")
		Или ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.DataMatrix") Тогда
		ТипыКолонок.Вставить("СерияМарки", Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(3, ДопустимаяДлина.Переменная)));
		ТипыКолонок.Вставить("НомерМарки", Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(9, ДопустимаяДлина.Переменная)));
	КонецЕсли;
	
	Возврат ТипыКолонок;
	
КонецФункции

#КонецОбласти
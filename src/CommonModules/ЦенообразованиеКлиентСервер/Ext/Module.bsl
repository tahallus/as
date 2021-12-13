﻿#Область ПрограммныйИнтерфейс

// Дополняет структуру параметров получения данных номенклатуры параметром Структурная единица для получения минимальной цены
//
// Параметры:
//  Объект - ДокументОбъект - Документ объект.
//  СтрокаНабора - СтрокаТабличнойЧасти - текущая строка табличной части объекта.
//  СтруктураДанные - Структура - содержит параметры вызова формы ФормаЦеныИВалюта.
//  СкладВШапке - Булево - если Истина, то будет выбран склад из шапки. По умолчанию Неопределено;
//  ПрименитьОбщийВидЦен - Булево - если Истина, то будет подобрана структурная единица независимо от объекта. По умолчанию Ложь;
//
Процедура ДополнитьСтруктуруДанныхНоменклатурыСтруктурнойЕдиницей(Объект, СтрокаНабора, СтруктураДанные, СкладВШапке = Неопределено, ПрименитьОбщийВидЦен = Ложь) Экспорт
	
	Если СкладВШапке = Неопределено Тогда
		СкладВШапке = ОпределитьПоложениеСкладаВОбъекте(Объект);
	КонецЕсли;
		
	Если ПрименитьОбщийВидЦен Тогда 		
		ИмяРеквизита = "";   		
	Иначе     		
		ИмяРеквизита = ОпределитьИмяРеквизитаСкладаВОбъекте(Объект); 		
	КонецЕсли;	
	
	СтруктурнаяЕдиница = ПолучитьЗначениеСкладаВОбъекте(Объект, СтрокаНабора, ИмяРеквизита, СкладВШапке);	   	 	
	
	СтруктураДанные.Вставить("СтруктурнаяЕдиница", СтруктурнаяЕдиница);
	
КонецПроцедуры

// Определяет положение реквизита склада в объекте
//
// Параметры:
//	Объект - ДокументОбъект - Документ объект.
//
// Возвращаемое значение:
//  Булево - Истина, реквизит склад-структурная единица в шапке, Ложь если в табличной части
//
Функция ОпределитьПоложениеСкладаВОбъекте(Объект) Экспорт
	
	СкладВШапке = Истина;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "ПоложениеСклада") Тогда
		СкладВШапке = Объект.ПоложениеСклада = ПредопределенноеЗначение("Перечисление.ПоложениеРеквизитаНаФорме.ВШапке");
	КонецЕсли;
	
	Возврат СкладВШапке;
	
КонецФункции

// Определяет имя реквизита склада в объекте
//
// Параметры:
//	Объект - ДокументОбъект - Документ объект.
//
// Возвращаемое значение:
//  Строка - Имя реквизита склада-структурной
//
Функция ОпределитьИмяРеквизитаСкладаВОбъекте(Объект) Экспорт
	
	ИмяРеквизита = "";
	ВозможныеИменаРеквизитов = Новый Массив;
	ВозможныеИменаРеквизитов.Добавить("СтруктурнаяЕдиница");
	ВозможныеИменаРеквизитов.Добавить("СтруктурнаяЕдиницаРезерв");
	
	Для каждого ТекИмяРеквизита Из ВозможныеИменаРеквизитов Цикл
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, ТекИмяРеквизита) Тогда
			ИмяРеквизита = ТекИмяРеквизита;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ИмяРеквизита;
	
КонецФункции

// Определяет имя реквизита склада в объекте
//
// Параметры:
//	Объект - ДокументОбъект - Документ объект.
//  СтрокаНабора - СтрокаТабличнойЧасти - текущая строка табличной части объекта.
//	ИмяРеквизита - Строка - Имя реквизита склада в объекте или строке набора
//	СкладВШапке - Булево - Признак безусловного определения положения склада в шапке
//
// Возвращаемое значение:
//  СправочникСсылка.СтруктурныеЕдиницы - ссылка на структурную единицу объекта или строки табличной части
//
Функция ПолучитьЗначениеСкладаВОбъекте(Объект, СтрокаНабора, ИмяРеквизита, СкладВШапке) Экспорт
	
	СтруктурнаяЕдиница = Неопределено;  	
	
	Если ЗначениеЗаполнено(ИмяРеквизита) Тогда
		
		Если СкладВШапке Тогда
			
			СтруктурнаяЕдиница = Объект[ИмяРеквизита];
			
		Иначе
			Если НЕ СтрокаНабора = Неопределено 
				И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаНабора, ИмяРеквизита) Тогда	
				
				СтруктурнаяЕдиница = СтрокаНабора[ИмяРеквизита];
		
			КонецЕсли;		
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтруктурнаяЕдиница;
	
КонецФункции

// Пересчитывает строку табличной части по минимальным ценам, в конце расчета в структуру будет добавлен
// параметр "СообщениеПользователю", который позже будет отображен пользователю. 
//
// Параметры:
//	СтрокаТабличнойЧасти - СтрокаТабличнойЧасти - строка табличной части
//  КоличествоСтроки - Число - количество из строки табличной части
//	ПараметрыРасчета - Структура:
//		* ИспользоватьМинимальныеЦены - Булево - признак использования минимальных цен
//		* РассчитатьСуммуСкидки - Булево - признак расчета суммы скидки
//		* РассчитатьПроцентСкидки - Булево - признак расчета процента скидки
//
Процедура ПересчитатьСтрокуТЧПоМинимальнымЦенам(СтрокаТабличнойЧасти, КоличествоСтроки, ПараметрыРасчета) Экспорт
	
	Если ПараметрыРасчета.Свойство("ИспользоватьМинимальныеЦены")
		И ПараметрыРасчета.ИспользоватьМинимальныеЦены Тогда
		
		Если 	(ПараметрыРасчета.Свойство("РассчитатьСуммуСкидки") И ПараметрыРасчета.РассчитатьСуммуСкидки)  
			ИЛИ (ПараметрыРасчета.Свойство("РассчитатьПроцентСкидки") И ПараметрыРасчета.РассчитатьПроцентСкидки) Тогда
	
			Если СтрокаТабличнойЧасти.Свойство("МинимальнаяЦена") 
				И ЗначениеЗаполнено(СтрокаТабличнойЧасти.МинимальнаяЦена) Тогда
				
				МинимальнаяСумма = КоличествоСтроки * СтрокаТабличнойЧасти.МинимальнаяЦена;
				СуммаПоСтроке = КоличествоСтроки * СтрокаТабличнойЧасти.Цена;
								
				Если СтрокаТабличнойЧасти.Сумма < МинимальнаяСумма Тогда				
					
					Если СтрокаТабличнойЧасти.Свойство("СуммаСкидкиНаценки")
						И СтрокаТабличнойЧасти.Свойство("ПроцентСкидкиНаценки") Тогда 
						
						СуммаСкидкиНаценкиДоИзменения = СтрокаТабличнойЧасти.СуммаСкидкиНаценки;
						СтрокаТабличнойЧасти.СуммаСкидкиНаценки = Макс(СуммаПоСтроке - МинимальнаяСумма, 0);					
						
						Если СтрокаТабличнойЧасти.Цена = 0 Тогда
							
							СтрокаТабличнойЧасти.ПроцентСкидкиНаценки = Окр(100*СтрокаТабличнойЧасти.СуммаСкидкиНаценки 
																	/ (КоличествоСтроки * СтрокаТабличнойЧасти.МинимальнаяЦена), 2);
																	
						Иначе
																	
							СтрокаТабличнойЧасти.ПроцентСкидкиНаценки = Окр(100*СтрокаТабличнойЧасти.СуммаСкидкиНаценки 
																	/ (КоличествоСтроки * СтрокаТабличнойЧасти.Цена), 2);
						КонецЕсли;
																
						СтрокаТабличнойЧасти.Сумма = КоличествоСтроки * СтрокаТабличнойЧасти.Цена - СтрокаТабличнойЧасти.СуммаСкидкиНаценки;
						
						Если СуммаСкидкиНаценкиДоИзменения > СтрокаТабличнойЧасти.СуммаСкидкиНаценки 
							И СтрокаТабличнойЧасти.Цена >= СтрокаТабличнойЧасти.МинимальнаяЦена Тогда
												
							ПараметрыРасчета.Вставить("СообщениеПользователю", НСтр("ru = 'Размер и сумма скидки были изменены по минимальной цене'"));
							
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЕсли;			
				
			КонецЕсли;
			
		КонецЕсли;		
		
	КонецЕсли;
		
КонецПроцедуры

// Возвращает строку для описания способа округления цен, в строку подставляются от 2 до 4 параметров
//
// Параметры:
//	СтруктураВидаЦен - Структура:
//  	* ПервыйПараметр - Строка - первый параметр для подстановки
//  	* ВторойПараметр - Строка - второй параметр для подстановки
//  	* ПорядокОкругления - Число - значение порядка округления
//  	* ПсихологическоеОкругление - Число - значение психологического округления
//
// Возвращаемое значение:
//  Строка - результирующая строка
//
Функция ПолучитьКраткоеОписаниеСпособаОкругленияВидаЦены(СтруктураВидаЦен) Экспорт

	ИспользоватьРасширеннуюНастройкуОкругления = СтруктураВидаЦен.ИспользоватьРасширеннуюНастройкуОкругления;
	
	ПервыйПараметр 				= СтруктураВидаЦен.ПервыйПараметр;
	ВторойПараметр 				= СтруктураВидаЦен.ВторойПараметр;
	ПорядокОкругления 			= СтруктураВидаЦен.ПорядокОкругления;
	ПсихологическоеОкругление 	= СтруктураВидаЦен.ПсихологическоеОкругление;
	
	Если ИспользоватьРасширеннуюНастройкуОкругления Тогда                                                                       
		
		Результат = СтрШаблон(НСтр("ru ='Округление: %1 по правилам %2'"), ПервыйПараметр, ВторойПараметр); 
		
	Иначе
		
		ТретийПараметр = ПорядокОкругления;
		ЧетвертыйПараметр = ?(ЗначениеЗаполнено(ПсихологическоеОкругление), 
			СтрШаблон(" %1 ", НСтр("ru='и вычитать'")) + ПсихологическоеОкругление,
			"");
		Результат = СтрШаблон(НСтр("ru ='Округление: %1 по правилам %2 с точностью %3%4'"), ПервыйПараметр, ВторойПараметр, ТретийПараметр, ЧетвертыйПараметр); 
		
	КонецЕсли; 
	
	Возврат Результат;
	
КонецФункции

// Применяет "психологическое округление" к числу.
//
// Параметры:
//  Число                     - Число - к которому применяется округление.
//  ПсихологическоеОкругление - Число - значение "психологического округления".
//
// Возвращаемое значение:
//  Число - результат применения "психологического округления" к числу.
//
Функция ПрименитьПсихологическоеОкругление(Число, ПсихологическоеОкругление) Экспорт
	
	Если Число = 0 ИЛИ ПсихологическоеОкругление = 0 Тогда
		Возврат Число;
	Иначе
		РезультатОкругления = Число - ПсихологическоеОкругление;
		Возврат ?(РезультатОкругления < Число, РезультатОкругления, Число);
	КонецЕсли;
		
КонецФункции

#КонецОбласти

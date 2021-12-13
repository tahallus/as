﻿
#Область ПрограммныйИнтерфейс

// Открывает форму выбора общего значения в зависимости от выбираемого элемента
//
// Параметры:
//  Форма - форма, которая содержит общее значение
//  НастройкиЗагрузкиДанных - структура настроек загрузки
//  ТаблицаСопоставленияДанных - таблица сопоставления загружаемых данных
//
Процедура ПриУстановкеОбщегоЗначения(Форма, НастройкиЗагрузкиДанных, ТаблицаСопоставленияДанных) Экспорт
	
	ДополнительныеНастройки = Новый Структура("Форма, НастройкиЗагрузкиДанных, ТаблицаСопоставленияДанных", Форма, НастройкиЗагрузкиДанных, ТаблицаСопоставленияДанных);
	ОписаниеОповещения 		= Новый ОписаниеОповещения("ПриОбработкеРезультатаВыбораОбщегоЗначения", ЭтотОбъект, ДополнительныеНастройки);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("МножественныйВыбор", Ложь);
	ПараметрыОткрытия.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыОткрытия.Вставить("ВыборГруппИЭлементов", ГруппыИЭлементы.Группы);
	
	Если НастройкиЗагрузкиДанных.ПолноеИмяОбъектаЗаполнения = "Справочник.Контрагенты" Тогда
		
		ИмяФормыВыбораГруппы = "Справочник.Контрагенты.ФормаВыбораГруппы";
		
	ИначеЕсли НастройкиЗагрузкиДанных.ПолноеИмяОбъектаЗаполнения = "Справочник.Номенклатура"
		ИЛИ НастройкиЗагрузкиДанных.ЭтоЗагрузкаТабличнойЧасти Тогда
		
		ИмяФормыВыбораГруппы = "Справочник.Номенклатура.ФормаВыбораГруппы";
		
	ИначеЕсли НастройкиЗагрузкиДанных.ПолноеИмяОбъектаЗаполнения = "Справочник.КонтактныеЛица" Тогда
		
		ИмяФормыВыбораГруппы = "Справочник.КонтактныеЛица.ФормаВыбораГруппы";
		
	ИначеЕсли НастройкиЗагрузкиДанных.ПолноеИмяОбъектаЗаполнения = "Справочник.Лиды" Тогда
		
		ИмяФормыВыбораГруппы = "Справочник.Лиды.ФормаВыбораГруппы";
		
	ИначеЕсли НастройкиЗагрузкиДанных.ПолноеИмяОбъектаЗаполнения = "РегистрСведений.ЦеныНоменклатуры" Тогда
		
		ПараметрыОткрытия.ВыборГруппИЭлементов = ГруппыИЭлементы.Элементы;
		ИмяФормыВыбораГруппы = "Справочник.ВидыЦен.ФормаВыбора";
		
	КонецЕсли;
	
	ОткрытьФорму(ИмяФормыВыбораГруппы, ПараметрыОткрытия, ЭтотОбъект, , , , ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура ПриОчисткеОбщегоЗначения(Форма, НастройкиЗагрузкиДанных, ТаблицаСопоставленияДанных) Экспорт
	
	Если НастройкиЗагрузкиДанных.ПолноеИмяОбъектаЗаполнения = "Справочник.Контрагенты" 
		ИЛИ НастройкиЗагрузкиДанных.ПолноеИмяОбъектаЗаполнения = "Справочник.Номенклатура"
		ИЛИ НастройкиЗагрузкиДанных.ПолноеИмяОбъектаЗаполнения = "Справочник.КонтактныеЛица"
		ИЛИ НастройкиЗагрузкиДанных.ПолноеИмяОбъектаЗаполнения = "Справочник.Лиды"
		ИЛИ НастройкиЗагрузкиДанных.ЭтоЗагрузкаТабличнойЧасти
		Тогда
		
		ЗаполнитьПолеРодительВТаблицеСопоставленияДанных(Неопределено, ТаблицаСопоставленияДанных, НастройкиЗагрузкиДанных);
		
	ИначеЕсли НастройкиЗагрузкиДанных.ПолноеИмяОбъектаЗаполнения = "РегистрСведений.ЦеныНоменклатуры" Тогда
		
		ЗаполнитьПолеРодительВТаблицеСопоставленияДанных(ЗагрузкаДанныхИзВнешнегоИсточникаПереопределяемый.ОсновнойВидЦен(), ТаблицаСопоставленияДанных, НастройкиЗагрузкиДанных);
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет заголовок элемента общего значения на форме обработки загрузки
// вызывает процедуру заполнения таблицы ТаблицаСопоставленияДанных для заполнения общего значения
//
// Параметры:
//  Результат - результат обработки выбора
//  ДополнительныеНастройки - структура дополнительных настроек обработки выбора
//
Процедура ПриОбработкеРезультатаВыбораОбщегоЗначения(Результат, ДополнительныеНастройки) Экспорт
	
	Форма 						= ДополнительныеНастройки.Форма;
	НастройкиЗагрузкиДанных 	= ДополнительныеНастройки.НастройкиЗагрузкиДанных;
	ТаблицаСопоставленияДанных 	= ДополнительныеНастройки.ТаблицаСопоставленияДанных;
	ЭтоЗаполнениеВидаЦен		= ?(ДополнительныеНастройки.Свойство("ЭтоЗаполнениеВидаЦен"), ДополнительныеНастройки.ЭтоЗаполнениеВидаЦен, Ложь);
	
	ЗаполнитьПолеРодительВТаблицеСопоставленияДанных(Результат, ТаблицаСопоставленияДанных, НастройкиЗагрузкиДанных, ЭтоЗаполнениеВидаЦен);

	Если НЕ ЭтоЗаполнениеВидаЦен Тогда
		Форма.ОбщееЗначениеСправочникНоменклатура = Результат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПолеРодительВТаблицеСопоставленияДанных(Значение, ТаблицаСопоставленияДанных, НастройкиЗагрузкиДанных, ЭтоЗаполнениеВидаЦен = Ложь)
	
	Если НастройкиЗагрузкиДанных.ПолноеИмяОбъектаЗаполнения = "Справочник.Контрагенты" Тогда
		
		ИмяПроверяемогоПоля = "Контрагент";
		ИмяЗаполняемогоПоля = "Родитель";
		НастройкиЗагрузкиДанных.Вставить("ОбщееЗначениеСправочник", Значение);
		
	ИначеЕсли (НастройкиЗагрузкиДанных.ПолноеИмяОбъектаЗаполнения = "Справочник.Номенклатура" 
		ИЛИ  НастройкиЗагрузкиДанных.ЭтоЗагрузкаТабличнойЧасти)
		И НЕ ЭтоЗаполнениеВидаЦен
		Тогда
		
		ИмяПроверяемогоПоля = "Номенклатура"; // Родителя устанавливаем только для новых
		ИмяЗаполняемогоПоля = "Родитель";
		НастройкиЗагрузкиДанных.Вставить("ОбщееЗначениеСправочник", Значение);
		
	ИначеЕсли НастройкиЗагрузкиДанных.ПолноеИмяОбъектаЗаполнения = "Справочник.КонтактныеЛица" Тогда
		
		ИмяПроверяемогоПоля = "Контакт";
		ИмяЗаполняемогоПоля = "Родитель";
		НастройкиЗагрузкиДанных.Вставить("ОбщееЗначениеСправочник", Значение);
		
	ИначеЕсли НастройкиЗагрузкиДанных.ПолноеИмяОбъектаЗаполнения = "Справочник.Лиды" Тогда
		
		ИмяПроверяемогоПоля = "Лид";
		ИмяЗаполняемогоПоля = "Родитель";
		НастройкиЗагрузкиДанных.Вставить("ОбщееЗначениеСправочник", Значение);
		
	ИначеЕсли НастройкиЗагрузкиДанных.ПолноеИмяОбъектаЗаполнения = "РегистрСведений.ЦеныНоменклатуры"
		ИЛИ ЭтоЗаполнениеВидаЦен Тогда
		
		ИмяПроверяемогоПоля = "ВидЦен";
		ИмяЗаполняемогоПоля = "ВидЦен";
		НастройкиЗагрузкиДанных.Вставить("ВидЦен", Значение);
		
	КонецЕсли;

	НастройкиЗагрузкиДанных.Вставить("ОбщееЗначениеСправочник", Значение);
	
	Для каждого СтрокаТаблицы Из ТаблицаСопоставленияДанных Цикл
		
		Если ИмяЗаполняемогоПоля = "Родитель" Тогда
			
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицы, ИмяЗаполняемогоПоля) Тогда
				
				ОбщееЗначениеЗаполнено = ЗначениеЗаполнено(СтрокаТаблицы[ИмяПроверяемогоПоля]);
				Если НЕ ОбщееЗначениеЗаполнено Тогда
					
					СтрокаТаблицы[ИмяЗаполняемогоПоля] = Значение;
					
				КонецЕсли;
				
			КонецЕсли;
			
		ИначеЕсли ИмяЗаполняемогоПоля = "ВидЦен"
			И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТаблицы, ИмяЗаполняемогоПоля)
			И ЭтоЗаполнениеВидаЦен Тогда
			
			СтрокаТаблицы[ИмяЗаполняемогоПоля] = Значение;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти 


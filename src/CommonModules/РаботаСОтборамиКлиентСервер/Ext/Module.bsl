﻿
#Область ПрограммныйИнтерфейс

// Процедура - Устанавливает отбор по периоду в форме списка документов
//
// Параметры:
//  СписокОтбор		 - ОтборКомпоновкиДанных - Отбор элемента формы - списка
//  ДатаНачала		 - Дата					 - Дата начала периода отображения
//  ДатаОкончания	 - Дата					 - Дата окончания периода отображения
//  ИмяПоляОтбора	 - Строка				 - Имя поля отбора периода в панели отборов 
//
Процедура УстановитьОтборПоПериоду(СписокОтбор, ДатаНачала, ДатаОкончания, ИмяПоляОтбора = "Дата") Экспорт
	
	// Отбор на список по периоду
	ГруппаОтборПоПериоду = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		СписокОтбор.Элементы,
		"Период",
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ГруппаОтборПоПериоду,
		ИмяПоляОтбора,
		ВидСравненияКомпоновкиДанных.БольшеИлиРавно,
		ДатаНачала,
		"ДатаНачала",
		ЗначениеЗаполнено(ДатаНачала));
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ГруппаОтборПоПериоду,
		ИмяПоляОтбора,
		ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,
		ДатаОкончания,
		"ДатаОкончания",
		ЗначениеЗаполнено(ДатаОкончания));
		
КонецПроцедуры
	
// Функция - Формирует представление периода для панели отборов
//
// Параметры:
//  Период	 - СтандартныйПериод - Период, для которого требуется сформировать представление
// 
// Возвращаемое значение:
//  Строка - Представление периода
//
Функция ОбновитьПредставлениеПериода(Период) Экспорт

	Если Не ЗначениеЗаполнено(Период) Или (Не ЗначениеЗаполнено(Период.ДатаНачала) И Не ЗначениеЗаполнено(
		Период.ДатаОкончания)) Тогда
		ПредставлениеПериода = НСтр("ru = 'Период: за все время'");
	Иначе
		ДатаОкончанияПериода = ?(ЗначениеЗаполнено(Период.ДатаОкончания), КонецДня(Период.ДатаОкончания),
			Период.ДатаОкончания);
		Если ДатаОкончанияПериода < Период.ДатаНачала Тогда
#Если Клиент Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр(
				"ru = 'Выбрана дата окончания периода, которая меньше даты начала'"));
#КонецЕсли
			ПредставлениеПериода = СтрШаблон(НСтр("ru = 'с %1'"), Формат(Период.ДатаНачала, "ДЛФ=D;"));
		Иначе
			ПредставлениеПериода = СтрШаблон(НСтр("ru = 'за %1'"), НРег(ПредставлениеПериода(Период.ДатаНачала,
				ДатаОкончанияПериода)));
		КонецЕсли;
	КонецЕсли;

	Возврат ПредставлениеПериода;

КонецФункции

Функция УбратьЗапрещенныеСимволы(Текст, Разрешенные) Экспорт
	
	Результат = Текст;
	Для Сч = 1 По СтрДлина(Текст) Цикл
		ТекСимвол = Сред(Текст, Сч, 1);
		Если СтрНайти(Разрешенные, НРег(ТекСимвол))=0 Тогда
			Результат = СтрЗаменить(Результат, ТекСимвол,"");
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьИмяОтбора(ЭлементИмя, ДанныеОтборов) Экспорт

	ИмяЭлемента = Прав(ЭлементИмя, СтрДлина(ЭлементИмя)-СтрНайти(ЭлементИмя,"_", НаправлениеПоиска.СНачала));
	НайденнаяСтрокаМассив = ДанныеОтборов.НайтиСтроки(Новый Структура("ИмяЭлемента", ИмяЭлемента));
	Если НайденнаяСтрокаМассив.Количество() > 0 Тогда
		Возврат НайденнаяСтрокаМассив[0].ИмяОтбора;
	Иначе
		Возврат ИмяЭлемента;
	КонецЕсли;
	
КонецФункции // ()

#КонецОбласти


 



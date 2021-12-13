﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Торговые предложения".
// ОбщийМодуль.ТорговыеПредложенияВызовСервера.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область СервисРекомендаций

Функция ОтразитьОткликНаРекомендацию(Организация, УникальныйИдентификатор, АдресРесурса) Экспорт
	
	Результат = ТорговыеПредложенияСлужебный.ОтразитьОткликНаРекомендациюАсинхронно(
		Организация, УникальныйИдентификатор, АдресРесурса);
		
	Возврат Результат;	
	
КонецФункции

Функция ДеактивироватьРекомендацию(Организация, УникальныйИдентификатор, АдресРесурса) Экспорт
	
	Результат = ТорговыеПредложенияСлужебный.ДеактивироватьРекомендациюАсинхронно(
		Организация, УникальныйИдентификатор, АдресРесурса);
		
	Возврат Результат;	
	
КонецФункции

#КонецОбласти

#Область РаботаСКорзиной

Функция ВыполнитьДействиеСТоваромКорзиныВФоне(ПараметрыМетода, УникальныйИдентификатор) Экспорт
	
	Результат = ТорговыеПредложенияСлужебный.ВыполнитьДействиеСТоваромКорзиныВФоне(ПараметрыМетода, УникальныйИдентификатор);
	
	Возврат Результат;
	
КонецФункции

Функция УдалитьКорзинуВФоне(ПараметрыМетода, УникальныйИдентификатор) Экспорт
	
	Результат = ТорговыеПредложенияСлужебный.УдалитьКорзинуВФоне(ПараметрыМетода, УникальныйИдентификатор);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область РаботаСКатегориями

Функция ПолучитьКатегорииТорговыхПредложенийВФоне(УникальныйИдентификатор) Экспорт
	
	Результат = ТорговыеПредложенияСлужебный.ПолучитьКатегорииТорговыхПредложенийВФоне(УникальныйИдентификатор);
	
	Возврат Результат;
	
КонецФункции

// Получение характеристик категории.
//
// Параметры:
//  Идентификатор            - Строка - идентификатор категории.
//  УникальныйИдентификатор  - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания     - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ПолучитьХарактеристикиКатегорииВФоне(Идентификатор, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт 
	
	Результат = ТорговыеПредложенияСлужебный.ПолучитьХарактеристикиКатегорииВФоне(Идентификатор, УникальныйИдентификатор, ИдентификаторЗадания);
	
	Возврат Результат;
		
КонецФункции

#КонецОбласти

#Область Синхронизация

Функция ОбновитьСтатистикуСинхронизацииВФоне(УникальныйИдентификатор, ПараметрыПроцедуры) Экспорт
	
	НаименованиеЗадания = НСтр("ru = 'Торговые предложения. Обновление статистики синхронизации.'");
	ИмяПроцедуры        = "ТорговыеПредложенияСлужебный.ОбновитьСтатистикуСинхронизации";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

Процедура ВыполнитьСинхронизациюТорговыхПредложенийВФоне(ДлительнаяОперация) Экспорт 
	ТорговыеПредложенияСлужебный.ВыполнитьСинхронизациюТорговыхПредложенийВФоне(ДлительнаяОперация);
КонецПроцедуры

Процедура НайтиДлительнуюОперациюТорговогоСинхронизацииТорговыхПредложений(ДлительнаяОперация) Экспорт
	ТорговыеПредложенияСлужебный.НайтиДлительнуюОперациюТорговогоСинхронизацииТорговыхПредложений(ДлительнаяОперация);
КонецПроцедуры

#КонецОбласти

Процедура ОтменитьФоновоеЗадание(ДлительнаяОперация) Экспорт 
	ТорговыеПредложенияСлужебный.ОтменитьФоновоеЗадание(ДлительнаяОперация);
КонецПроцедуры

#КонецОбласти


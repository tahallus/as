﻿
#Область СлужебныеПроцедурыИФункции

// Возвращает значение свойства XDTO
//
// Параметры:
//  ОбъектXDTO - ОбъектXDTO - объект, значение свойства которого нужно получить
//  Путь - Строка - путь к свойству, разделителем является символ ".".
// 
// Возвращаемое значение:
//  Неопределено - данное свойство отсутствует;
//  Строка - значение свойства;
//  ОбъектXDTO - объект XDTO.
//
Функция ЗначениеСвойстваXDTO(ОбъектXDTO, Путь) Экспорт
	
	Если ТипЗнч(ОбъектXDTO) <> Тип("ОбъектXDTO") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МассивСтрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивСлов(Путь, ".");
	
	Если ОбъектXDTO.Свойства().Получить(МассивСтрок[0]) = Неопределено Тогда
		Возврат Неопределено
	КонецЕсли;
	
	Если МассивСтрок.Количество() = 1 Тогда
		Значение = ОбъектXDTO[МассивСтрок[0]];
		Если ТипЗнч(Значение) = Тип("ОбъектXDTO") И Значение.Свойства().Количество() = 0 Тогда
			Возврат Неопределено;
		КонецЕсли;
		Возврат Значение;
	Иначе
		НаборСвойств = ОбъектXDTO.Свойства();
		Свойство = НаборСвойств.Получить(МассивСтрок[0]);
		Если Свойство = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		Если Свойство.ВерхняяГраница = 1 Тогда
			ПодОбъектXDTO = ОбъектXDTO.ПолучитьXDTO(Свойство);
		Иначе
			Список = ОбъектXDTO.ПолучитьСписок(Свойство);
			Если Список.Количество() = 0 Тогда
				Возврат Неопределено;
			Иначе
				ПодОбъектXDTO = Список[0];
			КонецЕсли;
		КонецЕсли;
		МассивСтрок.Удалить(0);
		НоваяСтрока = "";
		Для Каждого Элемент Из МассивСтрок Цикл
			НоваяСтрока = НоваяСтрока + ?(ПустаяСтрока(НоваяСтрока), "", ".") + Элемент;
		КонецЦикла;
		Возврат ЗначениеСвойстваXDTO(ПодОбъектXDTO, НоваяСтрока);
	КонецЕсли;
	
КонецФункции

#КонецОбласти
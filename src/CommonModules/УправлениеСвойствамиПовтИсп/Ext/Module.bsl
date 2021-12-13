﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Только для внутреннего использования.
// 
// Возвращаемое значение:
//  ФиксированноеСоответствие из КлючИЗначение:
//     * Ключ     - Строка
//                - СправочникСсылка.НаборыДополнительныхРеквизитовИСведений
//     * Значение - см. Справочники.НаборыДополнительныхРеквизитовИСведений.СвойстваНабора
//
Функция ПредопределенныеНаборыСвойств() Экспорт

	Возврат Справочники.НаборыДополнительныхРеквизитовИСведений.ПредопределенныеНаборыСвойств();
	
КонецФункции

// Только для внутреннего использования.
//
Функция НаименованияНаборовСвойств() Экспорт
	
	Возврат УправлениеСвойствамиСлужебный.НаименованияНаборовСвойств();
	
КонецФункции

#КонецОбласти
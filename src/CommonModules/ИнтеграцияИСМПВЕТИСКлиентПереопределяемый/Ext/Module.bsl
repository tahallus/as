﻿/////////////////////////////////////////////////////////////////////////////
// Совместная работа подсистем ВетИС и ИСМП.
//   * Процедуры взаимодействия с внешним модулем ВетИС
//

#Область ПрограммныйИнтерфейс

#Область ФормаУточненияДанныхИС

// Обработчик выбора произвольного идентификатора происхождения (не из списка выбора)
// 
// Параметры:
//   ИсточникДанных      - см. ИнтеграцияИСМПВЕТИСКлиент.ПараметрыВыбораИдентификатораПросхождения
//   СтандартнаяОбработка- Булево - признак стандартной обработки события
//
Процедура ОткрытьФормуВыбораИдентификатораПроисхожденияВЕТИС(ИсточникДанных, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
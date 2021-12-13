﻿#Область ПрограммныйИнтерфейс

Процедура ПроверитьОтветыНаЗаявленияНаПодключениеКлиент() Экспорт
	ПроверитьОтветыНаЗаявленияНаПодключение();
	ПодключитьОбработчикОжидания("ПроверитьОтветыНаЗаявленияНаПодключение", 86400); // = 24(ч)*60(мин)*60(сек) = 1 сутки
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьОтветыНаЗаявленияНаПодключение() Экспорт
	Попытка
		ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьОтветыНаЗаявленияНаПодключениеЗавершение",
			ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент);
		ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	Исключение
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр(
			"ru = 'Не удалось инициализировать обработчик автоматической проверки наличия ответов на заявления подключения к информационному взаимодействию'")
			+ ":
			  |" + ИнформацияОбОшибке().Описание);
	КонецПопытки;
КонецПроцедуры

#КонецОбласти

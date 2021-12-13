﻿// Переопределяемые клиентские процедуры ВЕТИС

#Область ПрограммныйИнтерфейс

#Область ФормыДокументовОснований

// Вызывается при возникновении события ОбработкаОповещения в форме документа-основания.
// В данной процедуре можно переопределить стандартную обработку этого события механизмом ВЕТИС.
// Если процедура переопределена, то необходимо установить параметр СобытиеОбработано в значение Истина.
Процедура ОбработкаОповещенияВФормеДокументаОснования(Форма, Объект, ИмяСобытия,
			Параметр, Источник, СобытиеОбработано) Экспорт
	Возврат;
КонецПроцедуры

// Вызывается при возникновении события ОбработкаНавигационнойСсылки поля гиперссылки ВЕТИС в форме документа-основания.
// В данной процедуре можно переопределить стандартную обработку этого события механизмом ВЕТИС.
// Если процедура переопределена, то необходимо установить параметр СобытиеОбработано в значение Истина.
Процедура ОбработкаНавигационнойСсылкиВФормеДокументаОснования(Форма, Объект,
			Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, СобытиеОбработано) Экспорт
	Возврат;
КонецПроцедуры

#КонецОбласти

#Область Прочие

// Обработчик команды "Разбить строку".
//
// Параметры:
//  ТЧ - ДанныеФормыКоллекция - Табличная часть.
//  ЭлементФормы - ТаблицаФормы - Элемент формы.
//  ОповещениеПослеРазбиения - ОписаниеОповещения - Оповещение после разбиения строки ТЧ.
//  ПараметрыРазбиенияСтроки - (См. ОбщегоНазначенияУТКлиент.ПараметрыРазбиенияСтроки).
Процедура РазбитьСтрокуТабличнойЧасти(ТЧ, ЭлементФормы, ОповещениеПослеРазбиения = Неопределено, ПараметрыРазбиенияСтроки = Неопределено) Экспорт
	
	ИнтеграцияВЕТИСУНФКлиент.РазбитьСтрокуТабличнойЧасти(ТЧ, ЭлементФормы, ОповещениеПослеРазбиения, ПараметрыРазбиенияСтроки);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти


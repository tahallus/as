﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	// регистр _МедиапланФактическиеДанные
	Движения._МедиапланФактическиеДанные.Записывать = Истина;
	Для Каждого ТекСтрокаСтрокиМедиапланаРасшифровка Из СтрокиМедиапланаРасшифровка Цикл
		Движение = Движения._МедиапланФактическиеДанные.Добавить();
		Движение.Период = НачалоМесяца(Дата);
		Движение.Медиаплан = Медиаплан;
		Движение.КлючСвязи = ТекСтрокаСтрокиМедиапланаРасшифровка.КлючСвязи;
		Движение.ДатаНачала = ТекСтрокаСтрокиМедиапланаРасшифровка.ДатаНачала;
		Движение.ДатаОкончания = ТекСтрокаСтрокиМедиапланаРасшифровка.ДатаОкончания;
		Движение.Количество = ТекСтрокаСтрокиМедиапланаРасшифровка.Количество;
	КонецЦикла;

КонецПроцедуры

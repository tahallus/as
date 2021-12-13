﻿
#Область СлужебныеПроцедурыИФункции

Функция ТегНачалоСертификата() Экспорт
	
	Возврат "-----BEGIN CERTIFICATE-----";
	
КонецФункции

Функция ТегКонецСертификата() Экспорт
	
	Возврат "-----END CERTIFICATE-----";
	
КонецФункции

Функция НайтиСертификатПодписавшейСтороныРекурсивно(СертификатыПодписи) Экспорт
	
	КоличествоСертификатовПодписи = СертификатыПодписи.Количество();
	Если КоличествоСертификатовПодписи = 1 Тогда
		Возврат СертификатыПодписи[0];
	ИначеЕсли КоличествоСертификатовПодписи = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Пока СертификатыПодписи.Количество() Цикл
		ТекущийСертификат = СертификатыПодписи[0];
		ДочернийСертификат = ДочернийСертификат(СертификатыПодписи, ТекущийСертификат.Субъект.CN);
		Если ДочернийСертификат = Неопределено Тогда
			Возврат ТекущийСертификат;
		Иначе 
			СертификатыПодписи.Удалить(0);
			Возврат НайтиСертификатПодписавшейСтороныРекурсивно(СертификатыПодписи);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции 

Функция ДочернийСертификат(МассивСертификатов, Субъект) 
	
	Для каждого Сертификат Из МассивСертификатов Цикл
		Если Сертификат.Издатель.CN = Субъект Тогда
			Возврат Сертификат; 
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

#Область ОбработкаНеисправностей

// Возвращает вид ошибки, описывающий ситуацию, когда сертификатом нельзя подписать документ данного вида
// (в списке "Подписываемые виды документов" нет данного вида документа).
// Возвращаемое значение:
// 	См. ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки
Функция ВидОшибкиДляСертификатаНетПодписываемогоВидаДокумента() Экспорт
	
	ВидОшибки = ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки();
	ВидОшибки.Идентификатор = "ДляСертификатаНетПодписываемогоВидаДокумента";
	ВидОшибки.ЗаголовокПроблемы = НСтр("ru = 'Отсутствует доступный сертификат для подписания документов'");
	ВидОшибки.ОписаниеПроблемы = НСтр("ru = 'Для сертификата в списке ""Подписываемые виды документов"" нет данного вида документа'");
	ВидОшибки.ОписаниеРешения = НСтр("ru = '<a href = ""Проверьте"">Проверьте</a> подписываемые виды документов в сертификате'");
	ВидОшибки.ОбработчикиНажатия.Вставить("Проверьте", "КриптографияБЭДКлиент.ОткрытьСписокОшибокПоСертификатам");
	
	Возврат ВидОшибки;
	
КонецФункции

#КонецОбласти

#КонецОбласти
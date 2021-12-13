﻿
#Область ОбработчикиМетодовHTTP

#Область PING

Функция ОбработатьPING(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.УстановитьТелоИзСтроки("ok");
	Возврат Ответ;
	
КонецФункции

Функция pingGET(Запрос)
	
	Возврат ОбработатьPING(Запрос);
	
КонецФункции

#КонецОбласти

#Область Itoolabs

Функция EventPOST(Запрос)
	
	ИмяСобытияДляЖурналаРегистрации = "/event";
	
	ТелоЗапроса = РаскодироватьСтроку(Запрос.ПолучитьТелоКакСтроку(), СпособКодированияСтроки.КодировкаURL);
	ТелефонияСервер.ЗаписатьЗапросВЖурналРегистрации(ИмяСобытияДляЖурналаРегистрации, ТелоЗапроса);
	
	ПараметрыТела = ПолучитьПараметрыИзСтроки(ТелоЗапроса, "&");
	
	Если НЕ ТелефонияСервер.КорректнаяПодписьЗапроса(Перечисления.ДоступныеАТС.ДомRu, ПараметрыТела.crm_token) Тогда
		Возврат СообщениеОбОшибке(
			400,
			ИмяСобытияДляЖурналаРегистрации,
			НСтр("ru='Некорректный ключ'"));
	КонецЕсли;
	
	ОбязательныеПараметры = "cmd";
	Если НЕ ЕстьОбязательныеПараметры(ПараметрыТела,ОбязательныеПараметры) Тогда
		Возврат СообщениеОбОшибке(
			400,
			ИмяСобытияДляЖурналаРегистрации,
			СтрШаблон(НСтр("ru='Отсутствует обязательные параметры: %1'"), ОбязательныеПараметры));
	КонецЕсли;
	
	ТипОперации = ПараметрыТела.cmd;
	Ответ = Неопределено;
	
	Попытка
		
		Если ТипОперации = "contact" Тогда
			
			ОбязательныеПараметры = "phone";
			Если НЕ ЕстьОбязательныеПараметры(ПараметрыТела, ОбязательныеПараметры) Тогда
				Возврат СообщениеОбОшибке(
					400,
					ИмяСобытияДляЖурналаРегистрации,
					СтрШаблон(НСтр("ru='Отсутствует обязательные параметры: %1'"), ОбязательныеПараметры));
			КонецЕсли;
			
			ДанныеАбонента = ТелефонияСервер.ПолучитьДанныеКлиента(ПараметрыТела.phone);
			
			ЗаписьJSON = Неопределено;
			Если ДанныеАбонента <> Неопределено Тогда
				
				ЗаписьJSON = Новый ЗаписьJSON;
				ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет));
				ЗаписьJSON.ЗаписатьНачалоОбъекта();
				
				ЗаписьJSON.ЗаписатьИмяСвойства("contact_name");
				ЗаписьJSON.ЗаписатьЗначение(ДанныеАбонента.Представление);
				
				Если ЗначениеЗаполнено(ДанныеАбонента.ВнутреннийНомерОтветственного) Тогда
					ЗаписьJSON.ЗаписатьИмяСвойства("responsible");
					ЗаписьJSON.ЗаписатьЗначение(ДанныеАбонента.ВнутреннийНомерОтветственного);
				КонецЕсли;
				
				ЗаписьJSON.ЗаписатьКонецОбъекта();
				ПараметрыОтвета = ЗаписьJSON.Закрыть();
				
			КонецЕсли;
			
			Ответ = Новый HTTPСервисОтвет(200);
			Если ЗаписьJSON <> Неопределено Тогда
				Ответ.УстановитьТелоИзСтроки(ПараметрыОтвета);
			КонецЕсли;
			
		ИначеЕсли ТипОперации = "history" Тогда
			
			ОбязательныеПараметры = "callid,status";
			Если НЕ ЕстьОбязательныеПараметры(ПараметрыТела, ОбязательныеПараметры) Тогда
				Возврат СообщениеОбОшибке(
					400,
					ИмяСобытияДляЖурналаРегистрации,
					СтрШаблон(НСтр("ru='Отсутствует обязательные параметры: %1'"), ОбязательныеПараметры));
			КонецЕсли;
			
			ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
			ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыТела.callid;
			ДанныеЗвонка.ЗаписьРазговора.Ссылка = ?(ПараметрыТела.Свойство("link"), ПараметрыТела.link, "");
			ДанныеЗвонка.ДлительностьРазговора = Число(ПараметрыТела.duration);
			Если НРег(ПараметрыТела.status) <> НРег("Success") Тогда
				ДанныеЗвонка.Неотвеченный = Истина;
			КонецЕсли;
			
			ТелефонияСервер.ОбработатьЗавершениеЗвонка(ДанныеЗвонка);
			
		ИначеЕсли ТипОперации = "event" Тогда
			
			ОбязательныеПараметры = "type,callid,phone,ext";
			Если НЕ ЕстьОбязательныеПараметры(ПараметрыТела, ОбязательныеПараметры) Тогда
				Возврат СообщениеОбОшибке(
					400,
					ИмяСобытияДляЖурналаРегистрации,
					СтрШаблон(НСтр("ru='Отсутствует обязательные параметры: %1'"), ОбязательныеПараметры));
			КонецЕсли;
			
			Если НРег(ПараметрыТела.type) = "incoming" Тогда
				
				ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
				ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыТела.callid;
				ДанныеЗвонка.ДатаНачалаЗвонка = ТекущаяДатаСеанса();
				ДанныеЗвонка.НомерКонтакта = ПараметрыТела.phone;
				ПараметрыТела.Свойство("diversion", ДанныеЗвонка.НомерОрганизации);
				ДанныеЗвонка.Пользователь.ВнутреннийНомер = ПараметрыТела.ext;
				
				ТелефонияСервер.ОбработатьВходящийЗвонок(ДанныеЗвонка, Истина);
				
			ИначеЕсли НРег(ПараметрыТела.type) = "outgoing" Тогда
				
				ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
				ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыТела.callid;
				ДанныеЗвонка.ДатаНачалаЗвонка = ТекущаяДатаСеанса();
				ДанныеЗвонка.НомерКонтакта = ПараметрыТела.phone;
				ДанныеЗвонка.Пользователь.ВнутреннийНомер = ПараметрыТела.ext;
				
				ТелефонияСервер.ОбработатьИсходящийЗвонок(ДанныеЗвонка);
				
			ИначеЕсли НРег(ПараметрыТела.type) = "accepted" Тогда
				
				ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
				ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыТела.callid;
				ДанныеЗвонка.ДатаНачалаРазговора = ТекущаяДатаСеанса();
				ДанныеЗвонка.Пользователь.ВнутреннийНомер = ПараметрыТела.ext;
				
				ТелефонияСервер.ОбработатьИзменениеЗвонка(ДанныеЗвонка);
				
			ИначеЕсли НРег(ПараметрыТела.type) = "completed" Тогда
				
				ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
				ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыТела.callid;
				ДанныеЗвонка.Пользователь.ВнутреннийНомер = ПараметрыТела.ext;
				ДанныеЗвонка.Неотвеченный = Ложь;
				
				ТелефонияСервер.ОбработатьЗавершениеЗвонка(ДанныеЗвонка);
				
			ИначеЕсли НРег(ПараметрыТела.type) = "cancelled" Тогда
				
				ДанныеЗвонка = ТелефонияСервер.НовыйДанныеЗвонка();
				ДанныеЗвонка.ИдентификаторЗвонкаВАТС = ПараметрыТела.callid;
				ДанныеЗвонка.Пользователь.ВнутреннийНомер = ПараметрыТела.ext;
				ДанныеЗвонка.Неотвеченный = Истина;
				
				ТелефонияСервер.ОбработатьЗавершениеЗвонка(ДанныеЗвонка);
				
			КонецЕсли;
			
		Иначе
			
			Возврат СообщениеОбОшибке(501, ИмяСобытияДляЖурналаРегистрации); // Not implemented
			
		КонецЕсли;
		
	Исключение
		
		Возврат СообщениеОбОшибке(
			500,
			ИмяСобытияДляЖурналаРегистрации,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
	Если Ответ = Неопределено Тогда
		Ответ = Новый HTTPСервисОтвет(200);
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьПараметрыИзСтроки(Знач СтрокаПараметров, Знач Разделитель = ";") Экспорт
	Результат = Новый Структура;
	
	ОписаниеПараметра = "";
	НайденоНачалоСтроки = Ложь;
	НомерПоследнегоСимвола = СтрДлина(СтрокаПараметров);
	Для НомерСимвола = 1 По НомерПоследнегоСимвола Цикл
		Символ =Сред(СтрокаПараметров, НомерСимвола, 1);
		Если Символ = """" Тогда
			НайденоНачалоСтроки = Не НайденоНачалоСтроки;
		КонецЕсли;
		Если Символ <> Разделитель Или НайденоНачалоСтроки Тогда
			ОписаниеПараметра = ОписаниеПараметра + Символ;
		КонецЕсли;
		Если Символ = Разделитель И Не НайденоНачалоСтроки Или НомерСимвола = НомерПоследнегоСимвола Тогда
			Позиция = СтрНайти(ОписаниеПараметра, "=");
			Если Позиция > 0 Тогда
				ИмяПараметра = СокрЛП(Лев(ОписаниеПараметра, Позиция - 1));
				ЗначениеПараметра = СокрЛП(Сред(ОписаниеПараметра, Позиция + 1));
				ЗначениеПараметра = СтроковыеФункцииКлиентСервер.СократитьДвойныеКавычки(ЗначениеПараметра);
				Попытка
					Результат.Вставить(ИмяПараметра, ЗначениеПараметра);
				Исключение
				КонецПопытки;
			КонецЕсли;
			ОписаниеПараметра = "";
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

Функция ЕстьОбязательныеПараметры(ПараметрыТела, ОбязательныеПараметры, ОтсутствующиеПараметры = "")
	
	ОтсутствующиеПараметрыМассив = Новый Массив;
	
	Если ТипЗнч(ОбязательныеПараметры) = Тип("Строка") Тогда
		МассивПараметров = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ОбязательныеПараметры);
	Иначе
		МассивПараметров = ОбязательныеПараметры;
	КонецЕсли;
	
	Для Каждого ОбязательныйПараметр Из МассивПараметров Цикл
		Если НЕ ПараметрыТела.Свойство(ОбязательныйПараметр) Тогда
			ОтсутствующиеПараметрыМассив.Добавить(ОбязательныйПараметр);
		КонецЕсли;
	КонецЦикла;
	
	Если ОтсутствующиеПараметрыМассив.Количество() = 0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	ОтсутствующиеПараметры = СтрСоединить(ОтсутствующиеПараметрыМассив, ",");
	
	Возврат Ложь;
	
КонецФункции

Функция СообщениеОбОшибке(КодСостояния, ВложенноеИмяСобытия, Комментарий = Неопределено, Заголовки = Неопределено)
	
	ЗаписьЖурналаРегистрации(
		ТелефонияСервер.СобытиеЖурналаРегистрации() + "." + ВложенноеИмяСобытия,
		УровеньЖурналаРегистрации.Ошибка,,,
		Комментарий);
	
	Возврат НовыйHTTPСервисОтвет(КодСостояния, Заголовки);
	
КонецФункции

Функция НовыйHTTPСервисОтвет(КодСостояния, Заголовки = Неопределено)
	
	Ответ = Новый HTTPСервисОтвет(КодСостояния);
	
	Если Заголовки <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСоответствие(Ответ.Заголовки, Заголовки);
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

#КонецОбласти
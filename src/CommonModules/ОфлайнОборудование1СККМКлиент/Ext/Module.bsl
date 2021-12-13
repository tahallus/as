﻿
#Область ПрограммныйИнтерфейс

// Функция возвращает возможность работы модуля в асинхронном режиме.
// Стандартные команды модуля:
// - ПодключитьУстройство
// - ОтключитьУстройство
// - ВыполнитьКоманду
// Команды модуля для работы асинхронном режиме (должны быть определены):
// - НачатьПодключениеУстройства
// - НачатьОтключениеУстройства
// - НачатьВыполнениеКоманды
//
Функция ПоддержкаАсинхронногоРежима() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Функция осуществляет подключение устройства.
//
// Параметры:
//  ОбъектДрайвера - СправочникСсылка.ДрайверыОборудования - ОбъектДрайвера драйвера торгового оборудования.
//
// Возвращаемое значение:
//  Булево - Результат работы функции.
//
Функция ПодключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт
	
	Результат = Истина;
	ВыходныеПараметры = Новый Массив();
	ОбъектДрайвера = Неопределено;
	
	Если НЕ Параметры.Свойство("ВерсияФорматаОбмена") Тогда
		// Если обновление прошло штатно, то такой ситуации не должно быть
		ТекстИсключения = НСтр("ru='Не определена версия формата обмена. Перезапишите настройки ККМ Офлайн.'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ВерсияФорматаОбмена = Параметры.ВерсияФорматаОбмена;
	
	Если ВерсияФорматаОбмена < 2000 Тогда // 100Х
		
		КаталогВыгрузки = Неопределено;
		ИмяФайлаПрайсЛиста = Неопределено;
		КаталогЗагрузки = Неопределено;
		ИмяЗагружаемогоФайла = Неопределено;
		КоличествоЭлементовВПакете = Неопределено;
		
		Параметры.Свойство("КаталогВыгрузки",  КаталогВыгрузки);
		Параметры.Свойство("ИмяФайлаПрайсЛиста",	ИмяФайлаПрайсЛиста);
		Параметры.Свойство("КаталогЗагрузки",   КаталогЗагрузки);
		Параметры.Свойство("ИмяЗагружаемогоФайла",  ИмяЗагружаемогоФайла);
		Параметры.Свойство("КоличествоЭлементовВПакете",  КоличествоЭлементовВПакете);
		
		Если КаталогВыгрузки = Неопределено
			Или КаталогЗагрузки = Неопределено
			Или ИмяФайлаПрайсЛиста = Неопределено
			Или ИмяЗагружаемогоФайла = Неопределено
			Или КоличествоЭлементовВПакете = Неопределено Тогда
			
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить(НСтр("ru='Не настроены параметры устройства.
			|Для корректной работы устройства необходимо задать параметры его работы.'"));
			Результат = Ложь;
			
		Иначе
			ОбъектДрайвера = Новый Структура("Параметры", Параметры);
		КонецЕсли;
		
	ИначеЕсли ВерсияФорматаОбмена >= 2000 Тогда // 200Х
		
		КаталогОбмена = Неопределено;
		ИмяФайлаВыгрузки = Неопределено;
		ИмяФайлаЗагрузки = Неопределено;
		
		Параметры.Свойство("КаталогОбмена", 	КаталогОбмена);
		Параметры.Свойство("ИмяФайлаВыгрузки", 	ИмяФайлаВыгрузки);
		Параметры.Свойство("ИмяФайлаЗагрузки", 	ИмяФайлаЗагрузки);
		
		Если КаталогОбмена = Неопределено
			Или ИмяФайлаВыгрузки = Неопределено
			Или ИмяФайлаЗагрузки = Неопределено Тогда
			
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить(НСтр("ru='Не настроены параметры устройства.
			|Для корректной работы устройства необходимо задать параметры его работы.'"));
			Результат = Ложь;
			
		Иначе
			ОбъектДрайвера = Новый Структура("Параметры", Параметры);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Функция начинает подключения устройства.
//
Процедура НачатьПодключениеУстройства(ОповещениеПриЗавершении, ОбъектДрайвера, Параметры, ПараметрыПодключения, ДополнительныеПараметры) Экспорт
	
	ВыходныеПараметры = Неопределено;
	Результат = ПодключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
	
	РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Результат, ВыходныеПараметры);
	ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, РезультатВыполнения);
	
КонецПроцедуры

// Функция осуществляет отключение устройства.
//
// Параметры:
//  ОбъектДрайвера - СправочникСсылка.ДрайверыОборудования - ОбъектДрайвера драйвера торгового оборудования.
//
// Возвращаемое значение:
//  Булево - Результат работы функции.
//
Функция ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;
	Возврат Результат;

КонецФункции

// Функция начинает отключение устройства.
//
Процедура НачатьОтключениеУстройства(ОповещениеПриЗавершении, ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт
	
	Результат = ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
	
	РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Результат, ВыходныеПараметры);
	ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, РезультатВыполнения);
	
КонецПроцедуры

// Функция получает, обрабатывает и перенаправляет на исполнение команду к драйверу
Функция ВыполнитьКоманду(Команда, ВходныеПараметры = Неопределено, ВыходныеПараметры = Неопределено,
							ОбъектДрайвера, Параметры, ПараметрыПодключения) Экспорт
	
	Результат = Истина;
	
	ВыходныеПараметры = Новый Массив();
	
	Если Команда = "ТестУстройства" ИЛИ Команда = "CheckHealth" Тогда
		
		Если ПараметрыПодключения.Свойство("ВерсияФорматаОбмена") Тогда
			ВерсияФорматаОбмена = ПараметрыПодключения.ВерсияФорматаОбмена;
		Иначе
			ВерсияФорматаОбмена = 1005;
		КонецЕсли;
		
		Результат = ТестУстройства(Параметры, ВыходныеПараметры);
		
	// Указанная команда не поддерживается данным драйвером
	Иначе
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Команда ""%Команда%"" не поддерживается данным драйвером.'"));
		ВыходныеПараметры[1] = СтрЗаменить(ВыходныеПараметры[1], "%Команда%", Команда);

		Результат = Ложь;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Процедура начинает выполнение команды, обрабатывает и перенаправляет на исполнение команду к драйверу.
//
Процедура НачатьВыполнениеКоманды(ОповещениеПриЗавершении, Команда, ВходныеПараметры = Неопределено, ОбъектДрайвера, Параметры, ПараметрыПодключения) Экспорт
	
	ВыходныеПараметры = Новый Массив();
	
	// Тестирование устройства
	Если Команда = "ТестУстройства" ИЛИ Команда = "CheckHealth" Тогда
		НачатьТестУстройства(ОповещениеПриЗавершении, ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Выгрузка данных на ККМ
	ИначеЕсли Команда = "ВыгрузитьДанные" Тогда
		
		НачатьВыгрузкуДанных(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры);
		
	ИначеЕсли Команда = "ЗагрузитьДанные" Тогда
		
		НачатьЗагрузкуДанных(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры);
		
	ИначеЕсли Команда = "УстановитьФлагДанныеЗагружены" Тогда
		
		НачатьУстановкуФлагаДанныеЗагружены(ОповещениеПриЗавершении, Параметры, ВыходныеПараметры);
		
	// Выгрузка настроек в ККМ Offline
	ИначеЕсли Команда = "ВыгрузитьНастройки" Тогда
		
		НачатьВыгрузкуНастроек(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры);
		
	Иначе
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Команда ""%Команда%"" не поддерживается данным драйвером.'"));
		ВыходныеПараметры[1] = СтрЗаменить(ВыходныеПараметры[1], "%Команда%", Команда);
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ВыходныеПараметры);
		Если ОповещениеПриЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, РезультатВыполнения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область КомандыДрайвера

#Область КомандаВыгрузкаДанных

Процедура НачатьВыгрузкуДанных(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры)
	
	Если Параметры.ВерсияФорматаОбмена > 2000 Тогда
		
		Каталог = ДополнитьИмяКаталогаСлешем(Параметры.КаталогОбмена);
		ИмяФайла = Параметры.ИмяФайлаВыгрузки;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
		ДополнительныеПараметры.Вставить("ВыходныеПараметры", ВыходныеПараметры);
		ДополнительныеПараметры.Вставить("Параметры", Параметры);
		ДополнительныеПараметры.Вставить("ВходныеПараметры", ВходныеПараметры);
		
		Описание = Новый ОписаниеОповещения("ОповещениеПоискФайловВыгрузкиДанных", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПоискФайлов(Описание, Каталог, ИмяФайла + "*.*", Ложь);
		
	Иначе // 100Х
		
		НачатьВыгрузкуТоваров(
			ОповещениеПриЗавершении,
			Параметры,
			ВыходныеПараметры,
			ВходныеПараметры,
			Истина,
			Параметры.ВерсияФорматаОбмена
		);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОповещениеПоискФайловВыгрузкиДанных(НайденныеФайлы, ДополнительныеПараметры) Экспорт
	
	ИменаФайлов = Новый Массив;
	
	Для Каждого ТекФайл Из НайденныеФайлы Цикл
		ИменаФайлов.Добавить(ТекФайл.ПолноеИмя);
	КонецЦикла;
	
	ОписаниеЗавершенияПолученияСодержания = Новый ОписаниеОповещения("НачатьВыгрузкуДанныхПродолжение", ЭтотОбъект, ДополнительныеПараметры);
	МенеджерОборудованияКлиент.ПолучитьСодержаниеТекстовыхФайлов(ИменаФайлов, ОписаниеЗавершенияПолученияСодержания);
	
КонецПроцедуры

// Выгружает данные на офлайн оборудование.
// Параметры:
// Результат - Структура - структура результат.
// ДополнительныеПараметры - Структура - где:
//  *Параметры - Структура - .
Процедура НачатьВыгрузкуДанныхПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Отказ = Ложь;
	
	ВыходныеПараметры = ДополнительныеПараметры.ВыходныеПараметры;
	Параметры = ДополнительныеПараметры.Параметры;
	ВерсияФорматаОбмена = Параметры.ВерсияФорматаОбмена;
	
	Если Результат.Успешно Тогда
		
		МассивФайлов = Новый Массив;
		Для Каждого СодержаниеФайла Из Результат.СодержаниеФайлов Цикл
			МассивФайлов.Добавить(СодержаниеФайла.ТекстСодержания);
		КонецЦикла;
		
		ПакетыОбработаны = Ложь;
		ОфлайнОборудование1СККМВызовСервера.ПакетыОбработаны(Отказ, ПакетыОбработаны, Истина, МассивФайлов, ВыходныеПараметры, ВерсияФорматаОбмена);
		
		Если НЕ Отказ И НЕ ПакетыОбработаны Тогда
			СоздатьСообщениеОбОшибке(ВыходныеПараметры, НСтр("ru='Файл предыдущей выгрузки не обработан (загружен)'"));
			Отказ = Истина;
		КонецЕсли;
		
	Иначе
		
		СоздатьСообщениеОбОшибке(ВыходныеПараметры, Результат.ТекстОшибки);
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		Если НЕ Результат.СодержаниеФайлов.Количество() = 0 Тогда
			
			ОповещениеУдалениеФайлов = Новый ОписаниеОповещения("ОповещениеУдалениеФайловВыгрузкиДанных", ЭтотОбъект, ДополнительныеПараметры);
			
			Каталог = ДополнитьИмяКаталогаСлешем(Параметры.КаталогОбмена);
			
			НачатьУдалениеФайлов(ОповещениеУдалениеФайлов,
				Каталог,
				Параметры.ИмяФайлаВыгрузки + "*.xml");
			
		Иначе
			
			ОповещениеЗавершение = Новый ОписаниеОповещения("НачатьВыгрузкуДанныхЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			ВыполнитьОбработкуОповещения(ОповещениеЗавершение);
			
		КонецЕсли;
	Иначе
		
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОповещениеУдалениеФайловВыгрузкиДанных(ДополнительныеПараметры) Экспорт
	
	ОповещениеЗавершение = Новый ОписаниеОповещения("НачатьВыгрузкуДанныхЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОповещениеЗавершение);
	
КонецПроцедуры

// Выгружает данные на офлайн оборудование.
// Параметры:
// Результат - Структура - структура результат.
// ДополнительныеПараметры - Структура - где:
//  *Параметры - Структура - .
Процедура НачатьВыгрузкуДанныхЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВходныеПараметры 	= ДополнительныеПараметры.ВходныеПараметры;
	ВыходныеПараметры 	= ДополнительныеПараметры.ВыходныеПараметры;
	Параметры 			= ДополнительныеПараметры.Параметры;
	Каталог 			= ДополнитьИмяКаталогаСлешем(Параметры.КаталогОбмена);
	
	ИмяФайла = Параметры.ИмяФайлаВыгрузки;
	
	Результат = Истина;
	
	МассивИменФайлов = Новый Массив;
	
	ИмяФайла = Каталог + ИмяФайла + ".txml";
	МассивИменФайлов.Добавить(СтрЗаменить(ИмяФайла, ".txml", ""));
	
	ЗаписатьДанныеВыгрузкиВФайл(
		ИмяФайла,
		ВходныеПараметры.ДанныеДляВыгрузки,
		Результат,
		ВыходныеПараметры,
		Параметры.ВерсияФорматаОбмена
	);
	
	Если Результат Тогда
		
		ДополнительныеПараметры.Вставить("МассивИменФайлов", МассивИменФайлов);
		ДополнительныеПараметры.Вставить("ТекущийИндексФайла", -1);
		ОповещениеПеремещениеФайловВыгрузки(Истина, ДополнительныеПараметры);
		
	Иначе
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОповещениеПеремещениеФайловВыгрузки(Результат, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.ТекущийИндексФайла = ДополнительныеПараметры.ТекущийИндексФайла + 1;
	
	Если ДополнительныеПараметры.ТекущийИндексФайла=ДополнительныеПараметры.МассивИменФайлов.Количество() Тогда
		
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Истина, ДополнительныеПараметры.ВыходныеПараметры);
		ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеПеремещениеФайлов", ЭтотОбъект, ДополнительныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		
	Иначе
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеПеремещениеФайловВыгрузки", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПеремещениеФайла(ОписаниеОповещения, ДополнительныеПараметры.МассивИменФайлов[ДополнительныеПараметры.ТекущийИндексФайла] + ".txml", ДополнительныеПараметры.МассивИменФайлов[ДополнительныеПараметры.ТекущийИндексФайла] + ".xml");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьДанныеВыгрузкиВФайл(ИмяФайла, ДанныеДляВыгрузки, Результат, ВыходныеПараметры, ВерсияФорматаОбмена)
	
	ТекстXML = ОфлайнОборудование1СККМВызовСервера.ПолучитьТекстXMLДанныхВыгрузки(ДанныеДляВыгрузки, ВерсияФорматаОбмена);
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(ТекстXML);
	
	Результат = МенеджерОфлайнОборудованияКлиент.ЗаписатьТекстовыйФайл(ТекстовыйДокумент, ИмяФайла);
	
	Если Не Результат Тогда
		СоздатьСообщениеОбОшибке(ВыходныеПараметры, НСтр("ru = 'Не удалось записать файл.'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область КомандаЗагрузкаДанных

Процедура НачатьЗагрузкуДанных(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры)
	
	Если Параметры.ВерсияФорматаОбмена > 2000 Тогда
		Каталог = ДополнитьИмяКаталогаСлешем(Параметры.КаталогОбмена);
		ИмяФайла = Параметры.ИмяФайлаЗагрузки;
	Иначе // 100Х
		Каталог = ДополнитьИмяКаталогаСлешем(Параметры.КаталогЗагрузки);
		ИмяФайла = Параметры.ИмяЗагружаемогоФайла;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ВыходныеПараметры", 		ВыходныеПараметры);
	ДополнительныеПараметры.Вставить("Параметры", 				Параметры);
	ДополнительныеПараметры.Вставить("ВходныеПараметры", 		ВходныеПараметры);
	ДополнительныеПараметры.Вставить("ВерсияФорматаОбмена", 	Параметры.ВерсияФорматаОбмена);
	
	Описание = Новый ОписаниеОповещения("ОповещениеПоискФайловЗагрузкиДанных", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПоискФайлов(Описание, Каталог, ИмяФайла + "*.*", Ложь);
	
КонецПроцедуры

Процедура ОповещениеПоискФайловЗагрузкиДанных(НайденныеФайлы, ДополнительныеПараметры) Экспорт
	
	Отказ = Ложь;
	
	ВыходныеПараметры = ДополнительныеПараметры.ВыходныеПараметры;
	
	Если НайденныеФайлы.Количество()= 0 Тогда
		СоздатьСообщениеОбОшибке(ВыходныеПараметры, НСтр("ru='Файл загрузки не найден'"));
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		Возврат;
	КонецЕсли;
	
	ФайлЗагрузки = НайденныеФайлы[0];
	ПолноеИмяФайла = ФайлЗагрузки.ПолноеИмя;
	
	ОписаниеЗавершенияПолученияСодержания = Новый ОписаниеОповещения("НачатьЗагрузкуДанныхПродолжение", ЭтотОбъект, ДополнительныеПараметры);
	МенеджерОборудованияКлиент.ПолучитьСодержаниеТекстовыхФайлов(ПолноеИмяФайла, ОписаниеЗавершенияПолученияСодержания);
	
КонецПроцедуры

// Загружает данные на офлайн оборудование.
// Параметры:
// Результат - Структура - структура результат.
// ДополнительныеПараметры - Структура - где:
//  *Параметры - Структура - .
Процедура НачатьЗагрузкуДанныхПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Отказ = Ложь;
	
	ВыходныеПараметры = ДополнительныеПараметры.ВыходныеПараметры;
	Параметры = ДополнительныеПараметры.Параметры;
	ВерсияФорматаОбмена = Параметры.ВерсияФорматаОбмена;
	
	Если Результат.Успешно Тогда
		
		МассивФайлов = Новый Массив;
		Для Каждого СодержаниеФайла Из Результат.СодержаниеФайлов Цикл
			МассивФайлов.Добавить(СодержаниеФайла.ТекстСодержания);
		КонецЦикла;
		
		ПакетыОбработаны = Ложь;
		
		ОфлайнОборудование1СККМВызовСервера.ПакетыОбработаны(Отказ, ПакетыОбработаны, Ложь, МассивФайлов, ВыходныеПараметры, ВерсияФорматаОбмена);
		
		Если ПакетыОбработаны Тогда
			СоздатьСообщениеОбОшибке(ВыходныеПараметры, НСтр("ru='Файл загрузки был обработан ранее.'"));
			Отказ = Истина;
		КонецЕсли;
		
	Иначе
		
		СоздатьСообщениеОбОшибке(ВыходныеПараметры, Результат.ТекстОшибки);
		Отказ = Истина;
		
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		НачатьЗагрузкуДанныхЗавершение(Результат, ДополнительныеПараметры);
		
	Иначе
		
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		
	КонецЕсли;
	
КонецПроцедуры

// Загружает данные на офлайн оборудование.
// Параметры:
// Результат - Структура - структура результат.
// ДополнительныеПараметры - Структура - где:
//  *Параметры - Структура - .
//  *ВыходныеПараметры - Массив - .
Процедура НачатьЗагрузкуДанныхЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыходныеПараметры = ДополнительныеПараметры.ВыходныеПараметры;
	
	ВерсияФорматаОбмена = ДополнительныеПараметры.ВерсияФорматаОбмена;
	Отказ = Ложь;
	РезультатЗагрузки = Истина;
	ДанныеИзККМ = Неопределено;
	
	Если Результат.Успешно И НЕ Результат.СодержаниеФайлов = Неопределено Тогда
		
		Если Результат.СодержаниеФайлов.Количество() Тогда
			
			XMLТекст = Результат.СодержаниеФайлов[0].ТекстСодержания;
			
			ДанныеИзККМ = ОфлайнОборудование1СККМВызовСервера.ОбработатьЗагружаемыеДанныеИзККМ(
				Отказ,
				XMLТекст,
				ВыходныеПараметры,
				ВерсияФорматаОбмена
			);
			
			Если НЕ Отказ Тогда
				ВыходныеПараметры.Добавить(ДанныеИзККМ);
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		
		СоздатьСообщениеОбОшибке(ВыходныеПараметры, Результат.ТекстОшибки);
		Отказ = Истина;
		
	КонецЕсли;
	
	Если Отказ Тогда
		
		РезультатЗагрузки = Ложь;
		
	КонецЕсли;
	
	РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", РезультатЗагрузки, ВыходныеПараметры);
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

#Область КомандаВыгрузкаНастроек

Процедура НачатьВыгрузкуНастроек(ОповещениеПриЗавершении, Параметры, ВходныеПараметры, ВыходныеПараметры)
	
	Если Параметры.ВерсияФорматаОбмена > 2000 Тогда
		
		Каталог = ДополнитьИмяКаталогаСлешем(Параметры.КаталогОбмена);
		ИмяФайла = Параметры.ИмяФайлаВыгрузки;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
		ДополнительныеПараметры.Вставить("ВыходныеПараметры", ВыходныеПараметры);
		ДополнительныеПараметры.Вставить("Параметры", Параметры);
		ДополнительныеПараметры.Вставить("ВходныеПараметры", ВходныеПараметры);
		
		Описание = Новый ОписаниеОповещения("ОповещениеПоискФайловВыгрузкиДанных", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПоискФайлов(Описание, Каталог, ИмяФайла + "*.*", Ложь);
		
	Иначе // 100Х
		
		СтруктураНастроек   = ВходныеПараметры.ДанныеДляВыгрузки.НастройкиККМ;
		ВерсияФорматаОбмена = Параметры.ВерсияФорматаОбмена;
		
		Результат = ВыгрузитьНастройкиФормат1000(Параметры, ВыходныеПараметры, СтруктураНастроек, ВерсияФорматаОбмена);
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Результат, ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, РезультатВыполнения);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ВыгрузитьНастройкиФормат1000(Параметры, ВыходныеПараметры, СтруктураНастроек, ВерсияФорматаОбмена)
	
	Результат = Истина;
	Каталог = ДополнитьИмяКаталогаСлешем(Параметры.КаталогВыгрузки);
	ИмяФайла = Параметры.ИмяФайлаНастроек;
	
	ИмяФайла = Каталог + ИмяФайла + ".xml";
	
	ТекстXML = ОфлайнОборудование1СККМВызовСервера.ПолучитьТекстXMLНастроек(СтруктураНастроек, ВерсияФорматаОбмена);
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(ТекстXML);
	
	Результат = МенеджерОфлайнОборудованияКлиент.ЗаписатьТекстовыйФайл(ТекстовыйДокумент, ИмяФайла);
	
	Если Не Результат Тогда
		СоздатьСообщениеОбОшибке(ВыходныеПараметры, НСтр("ru = 'Не удалось записать файл.'"));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область КомандаУстановитьФлагДанныеЗагружены

Процедура НачатьУстановкуФлагаДанныеЗагружены(ОповещениеПриЗавершении, Параметры, ВыходныеПараметры)
	
	Если Параметры.ВерсияФорматаОбмена > 2000 Тогда
		
		Каталог = ДополнитьИмяКаталогаСлешем(Параметры.КаталогОбмена);
		ИмяФайла = Параметры.ИмяФайлаЗагрузки;
		
	Иначе // 100Х
		
		Каталог = Параметры.КаталогЗагрузки;
		ИмяФайла = Параметры.ИмяЗагружаемогоФайла;
	КонецЕсли;
	
	ИмяФайла = ИмяФайла + ".*";
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ВыходныеПараметры", ВыходныеПараметры);
	ДополнительныеПараметры.Вставить("Параметры", Параметры);
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	
	Описание = Новый ОписаниеОповещения("ОповещениеПоискФайловУстановкаФлагаДанныеЗагружены", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПоискФайлов(Описание, Каталог, ИмяФайла, Ложь);
	
КонецПроцедуры

// Оповещает о поиске файлов загруженных данных.
// Параметры:
// Результат - Структура - структура результат.
// ДополнительныеПараметры - Структура - где:
//  *Параметры - Структура - .
Процедура ОповещениеПоискФайловУстановкаФлагаДанныеЗагружены(НайденныеФайлы, ДополнительныеПараметры) Экспорт
	
	ИменаФайлов = Новый Массив;
	
	Для Каждого ТекФайл Из НайденныеФайлы Цикл
		ИменаФайлов.Добавить(ТекФайл.ПолноеИмя);
	КонецЦикла;
	
	ВыходныеПараметры = ДополнительныеПараметры.ВыходныеПараметры;
	Параметры = ДополнительныеПараметры.Параметры;
	
	Успешно = УстановитьФлагДанныеЗагружены(ИменаФайлов, ВыходныеПараметры, Параметры.ВерсияФорматаОбмена);
	
	РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Успешно, ВыходныеПараметры);
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
	
КонецПроцедуры

Функция УстановитьФлагДанныеЗагружены(ИменаФайлов, ВыходныеПараметры, ВерсияФорматаОбмена)
	
	Для Каждого ИмяФайла Из ИменаФайлов Цикл
		
		ТекстXML = ОфлайнОборудование1СККМВызовСервера.ПолучитьТекстXMLДанныеЗагружены(ВерсияФорматаОбмена);
		
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.УстановитьТекст(ТекстXML);
		
		
		Результат = МенеджерОфлайнОборудованияКлиент.ЗаписатьТекстовыйФайл(ТекстовыйДокумент, ИмяФайла);
	
		Если Не Результат Тогда
			СоздатьСообщениеОбОшибке(ВыходныеПараметры, НСтр("ru = 'Не удалось записать файл.'"));
			Возврат Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

// Асинхронно
Процедура НачатьВыгрузкуТоваров(ОповещениеПриЗавершении, Параметры, ВыходныеПараметры, ВходныеПараметры, ЧастичнаяВыгрузка, ВерсияФорматаОбмена)
	
	Каталог = ДополнитьИмяКаталогаСлешем(Параметры.КаталогВыгрузки);
	ИмяФайла = Параметры.ИмяФайлаПрайсЛиста;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ВыходныеПараметры", ВыходныеПараметры);
	ДополнительныеПараметры.Вставить("Каталог", Каталог);
	ДополнительныеПараметры.Вставить("Параметры", Параметры);
	ДополнительныеПараметры.Вставить("ВходныеПараметры", ВходныеПараметры);
	ДополнительныеПараметры.Вставить("ЧастичнаяВыгрузка", ЧастичнаяВыгрузка);
	ДополнительныеПараметры.Вставить("ВерсияФорматаОбмена", ВерсияФорматаОбмена);
	
	Если ЧастичнаяВыгрузка Тогда
		
		Описание = Новый ОписаниеОповещения("ОповещениеПоискФайлов", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПоискФайлов(Описание, Каталог, ИмяФайла + "*.*", Ложь);
		
	Иначе // Полная выгрузка, поиск файлов пропускается
		
		РезультатЧтенияФайлов = Новый Структура;
		РезультатЧтенияФайлов.Вставить("СодержаниеФайлов", Новый Массив);
		РезультатЧтенияФайлов.Вставить("Успешно", Истина);
		РезультатЧтенияФайлов.Вставить("ТекстОшибки", "");
		
		ОповещениеПродолжения = Новый ОписаниеОповещения("НачатьВыгрузкуТоваровПродолжение", ЭтотОбъект, ДополнительныеПараметры);
		ВыполнитьОбработкуОповещения(ОповещениеПродолжения, РезультатЧтенияФайлов);
		
	КонецЕсли;
	
КонецПроцедуры

// Оповещение о поиске файлов.
// Параметры:
// НайденныеФайлы - Массив - структура результат.
// ДополнительныеПараметры - Структура - где:
//  *Параметры - Структура - .
Процедура ОповещениеПоискФайлов(НайденныеФайлы, ДополнительныеПараметры) Экспорт
	
	ОписаниеЗавершенияПолученияСодержания = Новый ОписаниеОповещения("НачатьВыгрузкуТоваровПродолжение", ЭтотОбъект, ДополнительныеПараметры);
	
	ИменаФайлов = Новый Массив;
	
	Для Каждого ТекФайл Из НайденныеФайлы Цикл
		ИменаФайлов.Добавить(ТекФайл.ПолноеИмя);
	КонецЦикла;
	
	ОписаниеЗавершенияПолученияСодержания = Новый ОписаниеОповещения("НачатьВыгрузкуТоваровПродолжение", ЭтотОбъект, ДополнительныеПараметры);
	МенеджерОборудованияКлиент.ПолучитьСодержаниеТекстовыхФайлов(ИменаФайлов, ОписаниеЗавершенияПолученияСодержания);
	
КонецПроцедуры

// Выгружает товары на оборудование.
// Параметры:
// Результат - Структура - структура результат.
// ДополнительныеПараметры - Структура - где:
//  *Параметры - Структура - .
Процедура НачатьВыгрузкуТоваровПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Отказ = Ложь;
	
	ВыходныеПараметры = ДополнительныеПараметры.ВыходныеПараметры;
	ВерсияФорматаОбмена = ДополнительныеПараметры.ВерсияФорматаОбмена;
	
	Если ДополнительныеПараметры.ЧастичнаяВыгрузка Тогда
		
		Если Результат.Успешно Тогда
			
			МассивФайлов = Новый Массив;
			Для Каждого СодержаниеФайла Из Результат.СодержаниеФайлов Цикл
				МассивФайлов.Добавить(СодержаниеФайла.ТекстСодержания);
			КонецЦикла;
			
			ПакетыОбработаны = Ложь;
			ОфлайнОборудование1СККМВызовСервера.ПакетыОбработаны(Отказ, ПакетыОбработаны, Истина, МассивФайлов, ВыходныеПараметры, ВерсияФорматаОбмена);
			
			Если НЕ Отказ И НЕ ПакетыОбработаны Тогда
				СоздатьСообщениеОбОшибке(ВыходныеПараметры, НСтр("ru='Не все файлы предыдущей выгрузки обработаны'"));
				Отказ = Истина;
			КонецЕсли;
			
		Иначе
			
			СоздатьСообщениеОбОшибке(ВыходныеПараметры, Результат.ТекстОшибки);
			Отказ = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		Если НЕ ДополнительныеПараметры.ЧастичнаяВыгрузка
			ИЛИ (ДополнительныеПараметры.ЧастичнаяВыгрузка И НЕ Результат.СодержаниеФайлов.Количество() = 0) Тогда
			
			ОповещениеУдалениеФайлов = Новый ОписаниеОповещения("ОповещениеУдалениеФайлов", ЭтотОбъект, ДополнительныеПараметры);
			
			НачатьУдалениеФайлов(ОповещениеУдалениеФайлов,
				ДополнительныеПараметры.Каталог,
				ДополнительныеПараметры.Параметры.ИмяФайлаПрайсЛиста + "*.xml");
			
		Иначе
			
			ОповещениеЗавершение = Новый ОписаниеОповещения("НачатьВыгрузкуТоваровЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			ВыполнитьОбработкуОповещения(ОповещениеЗавершение);
			
		КонецЕсли;
	Иначе
		
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОповещениеУдалениеФайлов(ДополнительныеПараметры) Экспорт
	
	ОповещениеЗавершение = Новый ОписаниеОповещения("НачатьВыгрузкуТоваровЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОповещениеЗавершение);
	
КонецПроцедуры

// Выгружает товары на оборудование.
// Параметры:
// Результат - Структура - структура результат.
// ДополнительныеПараметры - Структура - где:
//  *Параметры - Структура - .
Процедура НачатьВыгрузкуТоваровЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыходныеПараметры = ДополнительныеПараметры.ВыходныеПараметры;
	Каталог = ДополнительныеПараметры.Каталог;
	Параметры = ДополнительныеПараметры.Параметры;
	ВходныеПараметры = ДополнительныеПараметры.ВходныеПараметры;
	КоличествоЭлементовВПакете = Параметры.КоличествоЭлементовВПакете;
	ИмяФайла = Параметры.ИмяФайлаПрайсЛиста;
	ВерсияФорматаОбмена = ДополнительныеПараметры.ВерсияФорматаОбмена;
	
	СтруктураПрайсЛиста = ВходныеПараметры.ДанныеДляВыгрузки.ПрайсЛист;
	Результат = Истина;
	
	МассивИменФайлов = Новый Массив;
	
	Если Параметры.КоличествоЭлементовВПакете = 0 Тогда
		
		ИмяФайла = Каталог + ИмяФайла + ".txml";
		МассивИменФайлов.Добавить(СтрЗаменить(ИмяФайла, ".txml", ""));
		
		ЗаписатьПрайсЛист(ИмяФайла, ВходныеПараметры, Результат, ВыходныеПараметры, ВерсияФорматаОбмена);
		
	Иначе
		
		МассивПакетов = ОфлайнОборудование1СККМВызовСервера.РазбитьПрайсЛистПоПакетам(СтруктураПрайсЛиста, КоличествоЭлементовВПакете);
		НомерПакета = 1;
		
		Для Каждого Пакет Из МассивПакетов Цикл
			
			Если НЕ Результат Тогда
				Прервать;
			КонецЕсли;
			
			
			ОберткаДляПакета = Новый Структура;
			ОберткаДляПакета.Вставить("ДанныеДляВыгрузки", Новый Структура("ПрайсЛист", Пакет));
			
			ИмяФайлаНумерованный = Каталог + ИмяФайла + Формат(НомерПакета, "ЧЦ=4; ЧДЦ=; ЧВН=; ЧГ=0")+".txml";
			МассивИменФайлов.Добавить(СтрЗаменить(ИмяФайлаНумерованный, ".txml", ""));
			ЗаписатьПрайсЛист(ИмяФайлаНумерованный, ОберткаДляПакета, Результат, ВыходныеПараметры, ВерсияФорматаОбмена);
			НомерПакета = НомерПакета + 1;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если Результат Тогда
		
		ДополнительныеПараметры.Вставить("МассивИменФайлов", МассивИменФайлов);
		ДополнительныеПараметры.Вставить("ТекущийИндексФайла", -1);
		ОповещениеПеремещениеФайлов(Истина, ДополнительныеПараметры);
		
	Иначе
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОповещениеПеремещениеФайлов(Результат, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.ТекущийИндексФайла = ДополнительныеПараметры.ТекущийИндексФайла + 1;
	
	Если ДополнительныеПараметры.ТекущийИндексФайла=ДополнительныеПараметры.МассивИменФайлов.Количество() Тогда
		
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Истина, ДополнительныеПараметры.ВыходныеПараметры);
		ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеПеремещениеФайлов", ЭтотОбъект, ДополнительныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		
	Иначе
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеПеремещениеФайлов", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПеремещениеФайла(ОписаниеОповещения, ДополнительныеПараметры.МассивИменФайлов[ДополнительныеПараметры.ТекущийИндексФайла] + ".txml", ДополнительныеПараметры.МассивИменФайлов[ДополнительныеПараметры.ТекущийИндексФайла] + ".xml");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьПрайсЛист(ИмяФайла, ВходныеПараметры, Результат, ВыходныеПараметры, ВерсияФорматаОбмена)
	
	СтруктураПрайсЛиста = ВходныеПараметры.ДанныеДляВыгрузки.ПрайсЛист;
	ТекстXML = ОфлайнОборудование1СККМВызовСервера.ПолучитьТекстXMLПрайсЛиста(СтруктураПрайсЛиста, ВерсияФорматаОбмена);
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(ТекстXML);
	
	Результат = МенеджерОфлайнОборудованияКлиент.ЗаписатьТекстовыйФайл(ТекстовыйДокумент, ИмяФайла);
	
	Если Не Результат Тогда
		СоздатьСообщениеОбОшибке(ВыходныеПараметры, НСтр("ru = 'Не удалось записать файл.'"));
	КонецЕсли;
	
КонецПроцедуры

///////

// Функция проверяет корректность заполнения параметров драйвера.
//	При успешном прохождении проверки вернет "Истина", иначе "Ложь".
//	Параметры:
//		- ОбъектДрайвера.
//		- Параметры.
//		- ПараметрыПодключения.
//		- ВыходныеПараметры.
Функция ТестУстройства(Параметры, ВыходныеПараметры)
	
	Результат = Истина;
	
	ТекстОшибкиОбщий = "";
	ВремПараметр = "";
	ВерсияФорматаОбмена = 0;
	ВидОбмена = Неопределено;
	
	Параметры.Свойство("ВерсияФорматаОбмена", ВремПараметр);
	Если ПустаяСтрока(ВремПараметр) Тогда
		Результат = Ложь;
		ТекстОшибкиОбщий = НСтр("ru='Версия формата обмена не указана'");
	Иначе
		ВерсияФорматаОбмена = ВремПараметр;
	КонецЕсли;
	
	Параметры.Свойство("ВидОбмена", ВремПараметр);
	Если ПустаяСтрока(ВремПараметр) Тогда
		Результат = Ложь;
		ТекстОшибкиОбщий = НСтр("ru='Вид обмена не указан'");
	Иначе
		ВидОбмена = Параметры.ВидОбмена;
	КонецЕсли;
	
	Если ВидОбмена = ПредопределенноеЗначение("Перечисление.ВидыТранспортаОфлайнОбмена.FILE") Тогда
		
		Если ВерсияФорматаОбмена > 1000 И ВерсияФорматаОбмена < 2000 Тогда
			
			Параметры.Свойство("КаталогВыгрузки", ВремПараметр);
			Если ПустаяСтрока(ВремПараметр) Тогда
				Результат = Ложь;
				ТекстОшибкиОбщий = НСтр("ru='Каталог выгрузки не указан'");
			КонецЕсли;
			
			Параметры.Свойство("ИмяФайлаПрайсЛиста", ВремПараметр);
			Если ПустаяСтрока(ВремПараметр) Тогда
				Результат = Ложь;
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС); 
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru='Имя файла прайс-листа не указано'") 
			КонецЕсли;
			
			Параметры.Свойство("КаталогЗагрузки", ВремПараметр);
			Если ПустаяСтрока(ВремПараметр) Тогда
				Результат = Ложь;
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС); 
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru='Каталог загрузки не указан'") 
			КонецЕсли;
			
			Параметры.Свойство("ИмяЗагружаемогоФайла", ВремПараметр);
			Если ПустаяСтрока(ВремПараметр) Тогда
				Результат = Ложь;
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС); 
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru='Имя файла отчета не указано'") 
			КонецЕсли;
			
			Параметры.Свойство("КоличествоЭлементовВПакете", ВремПараметр);
			Если ВремПараметр=Неопределено Тогда
				Результат = Ложь;
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС); 
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru='Не указано количество элементов в пакете'") 
			КонецЕсли;
			
			Если Результат Тогда
				Если Лев(Параметры.ИмяЗагружаемогоФайла, СтрДлина(Параметры.ИмяФайлаПрайсЛиста)) = Параметры.ИмяФайлаПрайсЛиста Тогда
					Результат = Ложь;
					ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС); 
					ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru='Имена выгружаемого и загружаемого файлов не должны пересекаться.'"); 
				КонецЕсли;
			КонецЕсли;
			
		ИначеЕсли ВерсияФорматаОбмена > 2000 Тогда
			
			Параметры.Свойство("КаталогОбмена", ВремПараметр);
			Если ПустаяСтрока(ВремПараметр) Тогда
				Результат = Ложь;
				ТекстОшибкиОбщий = НСтр("ru='Каталог обмена не указан'");
			КонецЕсли;
			
			Параметры.Свойство("ИмяФайлаЗагрузки", ВремПараметр);
			Если ПустаяСтрока(ВремПараметр) Тогда
				Результат = Ложь;
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС); 
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru='Имя файла выгрузки не указано'");
			КонецЕсли;
			
			Параметры.Свойство("ИмяФайлаВыгрузки", ВремПараметр);
			Если ПустаяСтрока(ВремПараметр) Тогда
				Результат = Ложь;
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС);
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru='Имя файла загрузки не указано'");
			КонецЕсли;
			
			Если Результат Тогда
				Если НРег(Параметры.ИмяФайлаВыгрузки) = НРег(Параметры.ИмяФайлаЗагрузки) Тогда
					Результат = Ложь;
					ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС); 
					ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru='Имена файлов загрузки и выгрузки не должны совпадать'");
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ВидОбмена = ПредопределенноеЗначение("Перечисление.ВидыТранспортаОфлайнОбмена.WS") Тогда
		
		Параметры.Свойство("ИдентификаторWebСервисОборудования", ВремПараметр);
		Если ПустаяСтрока(ВремПараметр) Тогда
			Результат = Ложь;
			ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС);
			ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru='Идентификатор оборудования не указан'");
			
		Иначе
			
			Уникален = ОфлайнОборудование1СККМВызовСервера.ПроверитьУникальностьИдентификатораWebСервисОборудования(Параметры.ИдентификаторУстройства, ВремПараметр);
			
			Если НЕ Уникален Тогда
				Результат = Ложь;
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС);
				ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru='Указан неуникальный идентификатор оборудования'");
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ВыходныеПараметры.Добавить(?(Результат, 0, 999));
	Если НЕ ПустаяСтрока(ТекстОшибкиОбщий) Тогда
		ВыходныеПараметры.Добавить(ТекстОшибкиОбщий);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Процедура осуществляет тестирование устройства.
//
Процедура НачатьТестУстройства(ОповещениеПриЗавершении, ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)
	
	Результат = ТестУстройства(Параметры, ВыходныеПараметры);
	РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Результат, ВыходныеПараметры);
	ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбщиеПроцедурыИФункции

Функция ДополнитьИмяКаталогаСлешем(Знач ИмяКаталога)
	
	Если Найти(ИмяКаталога, "ftp") > 0 Тогда
		Слеш = "/";
	Иначе
		Слеш = "\";
	КонецЕсли;
	
	Если НЕ Прав(ИмяКаталога,1) = Слеш Тогда
		ИмяКаталога = ИмяКаталога + Слеш;
	КонецЕсли;
	
	Возврат ИмяКаталога;
	
КонецФункции

// Процедура добавляет в массив выходных параметров сообщение об ошибке.
//		Параметры:
//			- ВыходныеПараметры - массив, в который будет помещено сообщение об ошибке.
//			- ТекстСообщения - текст сообщения, содержащий информация об ошибке.
Процедура СоздатьСообщениеОбОшибке(ВыходныеПараметры, ТекстСообщения)
	
	ВыходныеПараметры.Добавить(999);
	ВыходныеПараметры.Добавить(ТекстСообщения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
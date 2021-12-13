﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ПодарочныйСертификат") Тогда
		ПодарочныйСертификат = Параметры.ПодарочныйСертификат;
	КонецЕсли;
	
	Если Параметры.Свойство("НомерСертификата") Тогда
		НомерСертификата = Параметры.НомерСертификата;
	КонецЕсли;
	
	Если Параметры.Свойство("Документ") Тогда
		Документ = Параметры.Документ;
	КонецЕсли;
	
	Если Параметры.Свойство("КОплате") Тогда
		КОплате = Параметры.КОплате;
	КонецЕсли;
	
	Если Параметры.Свойство("Сумма") Тогда
		Сумма = Параметры.Сумма;
	КонецЕсли;
	
	ОбновитьДанныеСертификата();
	УправлениеДоступностьюИВидимостью();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = "ПодключаемоеОборудование"
		И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" Тогда
			Если Параметр[1] = Неопределено Тогда
				Результат = Параметр[0]; // Достаем штрихкод из основных данных
			Иначе
				Результат = Параметр[1][1]; // Достаем штрихкод из дополнительных данных
			КонецЕсли;
			
			ПоискПоНомеруЗавершение(Результат, Новый Структура("ТекНомер", Результат));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидСертификатаПриИзменении(Элемент)
	
	ОбновитьДанныеСертификата();
	УправлениеДоступностьюИВидимостью();
	
КонецПроцедуры

&НаКлиенте
Процедура НомерСертификатаПриИзменении(Элемент)
	
	ОбновитьДанныеСертификата();
	УправлениеДоступностьюИВидимостью();
	
КонецПроцедуры

&НаКлиенте
Процедура НомерСертификатаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ПодборДляОплаты", Истина);
	СтруктураПараметров.Вставить("Отбор", Новый Структура("Владелец", ПодарочныйСертификат));
	ОткрытьФорму("Справочник.СерииНоменклатуры.ФормаВыбора", СтруктураПараметров, Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Элементы.НомерСертификата.Доступность И НомерСертификата.Пустая() Тогда
		ТекстСообщения = НСтр("ru = 'Не указан номер сертификата!'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "НомерСертификата", "НомерСертфиката");
		Возврат;
	КонецЕсли;
	
	Если Сумма > КОплате Тогда
		ТекстСообщения = НСтр("ru = 'Сумма оплаты не может превышать сумму документа!'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Сумма", "Сумма");
		Возврат;
	КонецЕсли;
	
	Если ИспользоватьСерииНоменклатуры Тогда
	
		Если Сумма > Остаток Тогда
			ТекстСообщения = НСтр("ru = 'Превышен остаток средств по сертификату!'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Сумма", "Сумма");
			Возврат;
		КонецЕсли;
		
	Иначе
		
		Если Сумма > Номинал Тогда
			ТекстСообщения = НСтр("ru = 'Превышен номинал сертификата!'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Сумма", "Сумма");
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЧастичноеПогашение Тогда
		СуммаПогашенияСертификата = Сумма;
	ИначеЕсли ИспользоватьСерииНоменклатуры Тогда
		СуммаПогашенияСертификата = Остаток;
	Иначе
		СуммаПогашенияСертификата = Номинал;
	КонецЕсли;
	
	Если Сумма = 0 Тогда
		ПараметрыЗакрытия = Неопределено;
	Иначе
		ПараметрыЗакрытия = Новый Структура("ПодарочныйСертификат, НомерСертификата, Сумма, СуммаПогашенияСертификата, ВидОплаты",
			ПодарочныйСертификат, НомерСертификата, Сумма, СуммаПогашенияСертификата, ПредопределенноеЗначение("Перечисление.ВидыБезналичныхОплат.ПодарочныйСертификат"));
	КонецЕсли;
		
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоНомеру(Команда)
	
	ТекНомер = "";
	ПоказатьВводЗначения(Новый ОписаниеОповещения("ПоискПоНомеруЗавершение", ЭтотОбъект, Новый Структура("ТекНомер", ТекНомер)), ТекНомер, НСтр("ru = 'Введите номер'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоНомеруЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ТекНомер = ?(Результат = Неопределено, ДополнительныеПараметры.ТекНомер, Результат);
	
	НуженВыборИзСписка = Ложь;
	
	Если Не ПустаяСтрока(ТекНомер) Тогда
		НуженВыборИзСписка = ВыполнитьПоискСертификатаПоНомеру(ТекНомер);
	КонецЕсли;
	
	Если НуженВыборИзСписка Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьВыбранныйСертификат", ЭтаФорма);
		СтруктураПараметров = Новый Структура("Адрес", АдресВХранилище);
		ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаВыбораСертификата", СтруктураПараметров,,,,, ОписаниеОповещения);
	Иначе
		УправлениеДоступностьюИВидимостью();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВыбранныйСертификат(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Результат);
	СтруктураРеквизитовСертификата = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПодарочныйСертификат, "ИспользоватьСерииНоменклатуры, Номинал");
	ЗаполнитьЗначенияСвойств(ЭтаФорма, СтруктураРеквизитовСертификата);
	Сумма = Мин(КОплате, Результат.Остаток);
	
	УправлениеДоступностьюИВидимостью();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеДоступностьюИВидимостью()
	
	Элементы.НомерСертификата.Доступность = ПодарочныйСертификат.ИспользоватьСерииНоменклатуры;
	
	Элементы.Сумма.СписокВыбора.Очистить();
	Если ЗначениеЗаполнено(КОплате) Тогда
		Элементы.Сумма.СписокВыбора.Добавить(КОплате, ""+КОплате+НСтр("ru = ' (к оплате)'"));
	КонецЕсли;
	Если ПодарочныйСертификат.ИспользоватьСерииНоменклатуры Тогда
		Если ЗначениеЗаполнено(Остаток) Тогда
			Элементы.Сумма.СписокВыбора.Добавить(Остаток, ""+Остаток+НСтр("ru = ' (остаток)'"));
		КонецЕсли;
	Иначе
		Элементы.Сумма.СписокВыбора.Добавить(ПодарочныйСертификат.Номинал, ""+ПодарочныйСертификат.Номинал+НСтр("ru = ' (номинал)'"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеСертификата()
	
	СтруктураСертификата = РаботаСПодарочнымиСертификатами.ПолучитьСтруктуруДанныхСертификата(ПодарочныйСертификат, НомерСертификата, Документ);
	ЗаполнитьЗначенияСвойств(ЭтаФорма, СтруктураСертификата);
	
	СтруктураРеквизитовСертификата = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПодарочныйСертификат, "ИспользоватьСерииНоменклатуры, Номинал, ЧастичноеПогашение");
	ЗаполнитьЗначенияСвойств(ЭтаФорма, СтруктураРеквизитовСертификата);
	
КонецПроцедуры

&НаСервере
Функция ВыполнитьПоискСертификатаПоНомеру(Номер)
	
	Результат = РаботаСПодарочнымиСертификатами.ВыполнитьПоискСертификатаПоНомеру(Номер);
	
	Если Результат.Количество() = 0 Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не найден сертификат по номеру: '") + Номер);
		Возврат Ложь;
	ИначеЕсли Результат.Количество() = 1 Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, Результат[0]);
		СтруктураРеквизитовСертификата = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПодарочныйСертификат, "ИспользоватьСерииНоменклатуры, Номинал");
		ЗаполнитьЗначенияСвойств(ЭтаФорма, СтруктураРеквизитовСертификата);
		Сумма = Мин(КОплате, Результат[0].Остаток);
		Возврат Ложь;
	Иначе
		АдресВХранилище = ПоместитьВоВременноеХранилище(Результат);
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

#КонецОбласти
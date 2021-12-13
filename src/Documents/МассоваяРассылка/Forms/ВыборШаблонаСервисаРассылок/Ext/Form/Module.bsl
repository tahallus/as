﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ШаблонДляАктивизации = Параметры.ШаблонДляАктивизации;
	ТекстПодсказки = СтрШаблон(
		НСтр("ru='Загружаем шаблоны %1'"),
		МассовыеРассылкиИнтеграция.ПредставлениеСервиса());
	
	Элементы.ДекорацияПодсказка.Заголовок = ТекстПодсказки;
	
	НачатьПолучениеШаблоновСервиса();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	НачатьОжиданиеПолученияШаблоновСервиса();
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыШаблоныСервиса

&НаКлиенте
Процедура ШаблоныСервисаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбратьШаблонИЗакрытьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныСервисаПриАктивизацииСтроки(Элемент)
	
	ДанныеШаблона = Элементы.ШаблоныСервиса.ТекущиеДанные;
	Если ДанныеШаблона = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПредпросмотрШаблона = НовыйПредпросмотр(ДанныеШаблона.СсылкаНаПредпросмотр, ДанныеШаблона.Наименование);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбратьШаблонИЗакрытьФорму();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НачатьПолучениеШаблоновСервиса()
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = Ложь;
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, "МассовыеРассылкиИнтеграция.ПолучитьШаблоныСервиса");
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьОжиданиеПолученияШаблоновСервиса()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗагрузкиШаблоновСервиса", ЭтотОбъект);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗагрузкиШаблоновСервиса(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ШаблоныЗагружены = Истина;
	УправлениеФормой();
	
	Если Результат.Статус = "Ошибка" Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.ПодробноеПредставлениеОшибки);
		Возврат;
	КонецЕсли;
	
	ЗаполнитьШаблоныСервисаВФорме(Результат.АдресРезультата);
	ВыделитьШаблонВТаблице();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьШаблоныСервисаВФорме(АдресРезультатаЗагрузки)
	
	ШаблоныСервиса.Загрузить(ПолучитьИзВременногоХранилища(АдресРезультатаЗагрузки));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьШаблонВТаблице()
	
	Если Не ЗначениеЗаполнено(ШаблонДляАктивизации) Тогда
		Возврат;
	КонецЕсли;
	
	Строки = ШаблоныСервиса.НайтиСтроки(Новый Структура("Идентификатор", ШаблонДляАктивизации));
	
	Если Строки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ШаблоныСервиса.ТекущаяСтрока = Строки[0].ПолучитьИдентификатор();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция НовыйПредпросмотр(Url, НаименованиеШаблона)
	
	НовыйПредпросмотр =
	"<html>
	|<body style=""margin: 0; width: 100%%; height: 100%%;"">
	|<img style=""width: 100%%;"" src=""%1"" alt=""%2"">
	|</body>
	|</html>";
	
	ТекстПодсказки = СтрШаблон(НСтр("ru='Предпросмотр шаблона %1'"), НаименованиеШаблона);
	Возврат СтрШаблон(НовыйПредпросмотр, Url, ТекстПодсказки);
	
КонецФункции

&НаКлиенте
Процедура УправлениеФормой()
	
	Если ШаблоныЗагружены Тогда
		ТекущаяСтраница = Элементы.ВыборШаблона;
	Иначе
		ТекущаяСтраница = Элементы.Ожидание;
	КонецЕсли;
	
	Элементы.Страницы.ТекущаяСтраница = ТекущаяСтраница;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьШаблонИЗакрытьФорму()
	
	ДанныеШаблона = Элементы.ШаблоныСервиса.ТекущиеДанные;
	
	Если ДанныеШаблона <> Неопределено Тогда
		Результат = Новый Структура;
		Результат.Вставить("Наименование", ДанныеШаблона.Наименование);
		Результат.Вставить("ТемаПисьма", ДанныеШаблона.ТемаПисьма);
		Результат.Вставить("Идентификатор", ДанныеШаблона.Идентификатор);
	Иначе
		Результат = Неопределено;
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти
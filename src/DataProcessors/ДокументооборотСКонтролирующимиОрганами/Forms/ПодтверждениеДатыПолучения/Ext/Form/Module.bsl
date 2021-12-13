﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Параметры.Сообщение) Тогда
		Отказ = Истина;
		Возврат;
	Иначе 
		Сообщение = Параметры.Сообщение;
	КонецЕсли;
	
	// инициализируем контекст ЭДО - модуль обработки
	КонтекстЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	
	
	// извлекаем файл подтверждения даты получения из содержимого сообщения
	ТипыДИВ = Новый Массив;
	ТипыДИВ.Добавить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ПодтверждениеДатыПолучения);
	ТипыДИВ.Добавить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ПодтверждениеОператораФСГС);
	СтрПодтверждения = КонтекстЭДО.ПолучитьВложенияТранспортногоСообщения(Сообщение, Истина, ТипыДИВ, ИмяФайлаПодтверждения);
	Если СтрПодтверждения.Количество() = 0 Тогда
		ТекстПредупреждения = "Подтверждение даты получения не обнаружено среди содержимого сообщения.";
		Возврат;
	КонецЕсли;
	СтрПодтверждение = СтрПодтверждения[0];
	
	// записываем вложение во временный файл
	ФайлПодтверждения = ПолучитьИмяВременногоФайла("xml");
	Попытка
		СтрПодтверждение.Данные.Получить().Записать(ФайлПодтверждения);
	Исключение
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Ошибка выгрузки подтверждения даты получения во временный файл: %1'"), Символы.ПС + ИнформацияОбОшибке().Описание);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
		Возврат;
	КонецПопытки;
	
	// считываем подтверждение из файла в дерево XML
	ОписаниеОшибки = "";
	ДеревоXML = КонтекстЭДО.ЗагрузитьXMLВДеревоЗначений(ФайлПодтверждения, , ОписаниеОшибки);
	ОперацииСФайламиЭДКО.УдалитьВременныйФайл(ФайлПодтверждения);
	Если НЕ ЗначениеЗаполнено(ДеревоXML) Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Ошибка чтения XML из файла подтверждения даты получения: %1'"), Символы.ПС + ИнформацияОбОшибке().Описание);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если СтрПодтверждение.Тип = Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ПодтверждениеОператораФСГС Тогда
		
		УзелПодтверждениеОператора = ДеревоXML.Строки.Найти("подтверждениеОператора", "Имя");
		Если НЕ ЗначениеЗаполнено(УзелПодтверждениеОператора) Тогда
			ТекстСообщения = НСтр("ru='Некорректная структура XML подтверждения: не обнаружен узел ""ПодтверждениеОператора"".'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		УзелПосылка = УзелПодтверждениеОператора.Строки.Найти("посылка", "Имя");
		Если НЕ ЗначениеЗаполнено(УзелПосылка) Тогда
			ТекстСообщения = НСтр("ru='Некорректная структура XML подтверждения: не обнаружен узел ""Посылка"".'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		УзелОтправитель = УзелПосылка.Строки.Найти("отправитель", "Имя");
		Если НЕ ЗначениеЗаполнено(УзелОтправитель) Тогда
			ТекстСообщения = НСтр("ru='Некорректная структура XML подтверждения: не обнаружен узел ""Отправитель"".'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		УзелДокументы = УзелПосылка.Строки.Найти("документы", "Имя");
		Если НЕ ЗначениеЗаполнено(УзелДокументы) Тогда
			ТекстСообщения = НСтр("ru='Некорректная структура XML подтверждения: не обнаружен узел ""Документы"".'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		// получаем идентификаторы поступивших файлов
		ИдентификаторыДокументов = "";
		Для каждого УзелДокумент Из УзелДокументы.Строки Цикл
			ИдентификаторДокумента = УзелДокумент.Строки.Найти("идентификаторДокумента", "Имя");
			Если ЗначениеЗаполнено(ИдентификаторДокумента) Тогда
				ИдентификаторыДокументов = ИдентификаторыДокументов + ?(ПустаяСтрока(ИдентификаторыДокументов), "", ",") + СокрЛП(ИдентификаторДокумента.Значение);
			КонецЕсли;
		КонецЦикла;
		
		// извлекаем имена поступивших файлов из сообщений цикла обмена по идентификаторам
		ИмяПоступившегоФайла = "";
		Если НЕ ПустаяСтрока(ИдентификаторыДокументов) Тогда
			
			СообщенияЦиклаОбмена = КонтекстЭДО.ПолучитьСообщенияЦиклаОбмена(Сообщение.ЦиклОбмена).ВыгрузитьКолонку("Ссылка");
			ТипыДИВ = Новый Массив;
			ТипыДИВ.Добавить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ПисьмоФСГС);
			ТипыДИВ.Добавить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ПриложениеПисьмаФСГС);
			ТипыДИВ.Добавить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ФайлОтчетностиФСГС);
			ДокументыЦиклаОбмена = КонтекстЭДО.ПолучитьВложенияТранспортногоСообщения(СообщенияЦиклаОбмена,, ТипыДИВ);
			
			Для каждого СтрДокументЦиклаОбмена Из ДокументыЦиклаОбмена Цикл
				Если СтрНайти(ИдентификаторыДокументов, СокрЛП(СтрДокументЦиклаОбмена.Идентификатор)) > 0 Тогда
					ИмяПоступившегоФайла = ИмяПоступившегоФайла + ?(ПустаяСтрока(ИмяПоступившегоФайла), "", ", ") + СокрЛП(СтрДокументЦиклаОбмена.ИмяФайла);
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
		// получаем сведения о дате и времени поступившего файла
		УзелДатаВремяОтправки = УзелПодтверждениеОператора.Строки.Найти("датаВремяОтправки", "Имя");
		Если ЗначениеЗаполнено(УзелДатаВремяОтправки) Тогда
			ДатаВремяОтправки = СокрЛП(XMLЗначение(Тип("Дата"), УзелДатаВремяОтправки.Значение));
			ДатаОтправки = Сокрлп(ДатаВремяОтправки);
		КонецЕсли;
		
		// сведения о подтвердившей организации
		УзелИдентификаторОтправителя = УзелОтправитель.Строки.Найти("идентификатор", "Имя");
		Если ЗначениеЗаполнено(УзелИдентификаторОтправителя) Тогда
			ИдентификаторОтправителя = СокрЛП(УзелИдентификаторОтправителя.Значение);
		Иначе
			ИдентификаторОтправителя = "";
		КонецЕсли;
		ИдентификаторСпецоператора = Лев(ИдентификаторОтправителя, СтрНайти(ИдентификаторОтправителя, ".") - 1);
		ОрганизацияСтр = "Оператор электронного документооборота" + ?(ПустаяСтрока(ИдентификаторСпецоператора), "", ": " + ИдентификаторСпецоператора);
	
	Иначе
		
		УзелФайл = ДеревоXML.Строки.Найти("Файл", "Имя");
		Если НЕ ЗначениеЗаполнено(УзелФайл) Тогда
			ТекстСообщения = НСтр("ru='Некорректная структура XML подтверждения: не обнаружен узел ""Файл"".'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		УзелДокумент = УзелФайл.Строки.Найти("Документ", "Имя");
		Если НЕ ЗначениеЗаполнено(УзелДокумент) Тогда
			ТекстСообщения = НСтр("ru='Некорректная структура XML подтверждения: не обнаружен узел ""Документ"".'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		УзелСвОтпр = УзелДокумент.Строки.Найти("СвОтпр", "Имя");
		Если НЕ ЗначениеЗаполнено(УзелСвОтпр) Тогда
			ТекстСообщения = НСтр("ru='Некорректная структура XML подтверждения: отсутствуют сведения о налоговом органе - отправителе подтверждения.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		УзелКодНО = УзелСвОтпр.Строки.Найти("КодНО", "Имя");
		Если УзелКодНО = Неопределено Тогда
			ТекстСообщения = НСтр("ru='Некорректная структура XML подтверждения: отсутствуют сведения о налоговом органе - отправителе подтверждения.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		ОрганизацияСтр = "Налоговый орган " + СокрЛП(УзелКодНО.Значение);
		
		// получаем сведения подтверждения
		УзелСведПодтв = УзелДокумент.Строки.Найти("СведПодтв", "Имя");
		Если НЕ ЗначениеЗаполнено(УзелСведПодтв) Тогда
			ТекстСообщения = НСтр("ru='Некорректная структура XML подтверждения: отсутствуют сведения подтверждения.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		// получаем сведения об имени поступившего файла
		УзелИдФайлПол = УзелСведПодтв.Строки.Найти("ИдФайлПол", "Имя", Истина);
		Если ЗначениеЗаполнено(УзелИдФайлПол) Тогда
			ИмяПоступившегоФайла = СокрЛП(УзелИдФайлПол.Значение);
		КонецЕсли;
		
		// получаем сведения о дате и времени поступившего файла
		УзелДатаОтпр = УзелСведПодтв.Строки.Найти("ДатаОтпр", "Имя");
		УзелВремяОтпр = УзелСведПодтв.Строки.Найти("ВремяОтпр", "Имя");
		Если ЗначениеЗаполнено(УзелДатаОтпр) Тогда
			ДатаОтправки = СокрЛП(УзелДатаОтпр.Значение);
		КонецЕсли;
		Если ЗначениеЗаполнено(УзелВремяОтпр) Тогда
			ДатаОтправки = СокрЛП(ДатаОтправки + " " + СокрЛП(УзелВремяОтпр.Значение));
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.Печать.Видимость = Параметры.ПечатьВозможна;
	Если Параметры.ПечатьВозможна Тогда
		ЦиклОбмена = Параметры.ЦиклОбмена;
		ФорматДокументооборота = Параметры.ЦиклОбмена.ФорматДокументооборота;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда 
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПолеВводаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПечатьЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПечатьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	РезультатНастройки = Новый Структура("ПечататьПодтверждениеОтправки, ФорматДокументооборота", Истина, ФорматДокументооборота);
	КонтекстЭДОКлиент.СформироватьИПоказатьПечатныеДокументы(ЦиклОбмена, РезультатНастройки);
	
КонецПроцедуры

#КонецОбласти
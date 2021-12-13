﻿#Область ОписаниеПеременных

&НаКлиенте
Перем Таймер, ФоновоеЗадание, МожноЗакрытьФорму;

&НаКлиенте
Перем КонтекстЭДОКлиент Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьСтатус();
	
	Если Параметры.Свойство("НомерТелефона") Тогда 
		НомерТелефона = Параметры.НомерТелефона;
	КонецЕсли;
	Если Параметры.Свойство("Фио") Тогда 
		Фио = Параметры.Фио;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НомерТелефонаПриИзменении(Элемент)
	
	Представление = ЭлектроннаяПодписьВМоделиСервисаКлиентСервер.ПолучитьПредставлениеТелефона(НомерТелефона);	
	Если ЗначениеЗаполнено(Представление) Тогда
		НомерТелефона = Представление;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Вариант2ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтернетПоддержкаПользователейКлиент.ОткрытьСтраницуИнтегрированногоСайта("https://its.1c.ru/bmk/elreps/new_connection");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заказать(Команда)
	
	Если МожноЗакрытьФорму Тогда 
		Закрыть(Истина);
	КонецЕсли;
		
	Если ФоновоеЗадание <> Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Телефон = НормализованныйНомерТелефона(НомерТелефона);
	Если СтрДлина(Телефон) <> 12 Тогда // Ожидается +79012345678
		
		ТекстОшибки = НСтр("ru = 'Для продолжения необходимо указать номер телефона в формате +7 901 234-56-78'");
		ОбновитьСтатус(0);
		Возврат;
		
	КонецЕсли;
					
	ЗаданиеВыполнено = ЗапуститьЗадание();	
	ОбработкаРезультатаВыполненияЗадания(ЗаданиеВыполнено);
			
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьЭлектронноеПисьмо(Команда)
	УправлениеКонтактнойИнформациейКлиент.СоздатьЭлектронноеПисьмо(
		"",
		"1c@astralnalog.ru", 
		ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты"));
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
	ФоновоеЗадание = Неопределено;
	МожноЗакрытьФорму = Ложь;
	НомерТелефонаПриИзменении(Элементы.НомерТелефона)
	
КонецПроцедуры

#Область ОбратныйЗвонок

// Взято из формы ЗаказОбратногоЗвонка

&НаКлиенте
Процедура ОбработкаРезультатаВыполненияЗадания(Знач ЗаданиеВыполнено, Знач ОтложенноеЗавершение = Ложь)
	
	Если ТипЗнч(ЗаданиеВыполнено) = Тип("Булево") И ЗаданиеВыполнено Тогда 		
		
		ТекстОшибки = НСтр("ru = '
                            |Спасибо!
                            |Мы свяжемся с вами в ближайшее время'");
		
		ОбновитьСтатус(2);
		МожноЗакрытьФорму = Истина;
		
	ИначеЕсли ТипЗнч(ЗаданиеВыполнено) = Тип("Булево") И Не ЗаданиеВыполнено Тогда 
		
		ОбновитьСтатус(0);
		
	ИначеЕсли ТипЗнч(ЗаданиеВыполнено) = Тип("Структура") И ОтложенноеЗавершение Тогда 
		
		Результат = ПолучитьИзВременногоХранилища(ЗаданиеВыполнено.АдресРезультата);		
		Если Результат = Неопределено Тогда
			ТекстОшибки = НСтр("ru = 'Извините, не удалось заказать обратный звонок, попробуйте снова через несколько минут.'");
			ОбновитьСтатус(0);
		ИначеЕсли Результат.Успешно Тогда			
			ОбработкаРезультатаВыполненияЗадания(Истина);
		Иначе
			Если Результат.Свойство("КодОшибкиСервиса") И Результат.КодОшибкиСервиса = "259" Тогда 
				ТекстОшибки = "";
				ОбработкаРезультатаВыполненияЗадания(Истина);
				Возврат;
			ИначеЕсли Результат.Свойство("Код") И Результат.Код < 9 Тогда 
				ТекстОшибки = НСтр("ru = 'Извините, не удалось заказать обратный звонок из-за неполадок в интернет соединении.'");
				ОбновитьСтатус(0);
			КонецЕсли;
			Если Результат.ОписаниеОшибки <> "" Тогда 
				ТекстОшибки = Результат.ОписаниеОшибки;
			КонецЕсли;			
			ОбновитьСтатус(0);
		КонецЕсли;
		
		ФоновоеЗадание = Неопределено;
		
	ИначеЕсли ТипЗнч(ЗаданиеВыполнено) = Тип("Структура") Тогда 
		
		ФоновоеЗадание = ЗаданиеВыполнено;
		ОбновитьСтатус(1);
		
		Таймер = 60 * 2; // 2 x 500 ms
		ПодключитьОбработчикОжидания("Подключаемый_ОбработчикОбратногоОтсчета", 0.5, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтатус(ВПроцессе = 0)
	
	Если ВПроцессе = 1 Тогда 
		
		Элементы.ЗаказатьЗакрыть.Заголовок = "Минуточку...";
		Элементы.ЗаказатьЗакрыть.Отображение = ОтображениеКнопки.КартинкаИТекст;
		Элементы.ТекстОшибки.ЦветТекста = Новый Цвет(128, 0, 0);
		
		Элементы.ЗаказатьЗакрыть.Видимость = Истина;
		
	ИначеЕсли ВПроцессе = 0 Тогда 
		
		Элементы.ЗаказатьЗакрыть.Заголовок = "Перезвоните мне";
		Элементы.ЗаказатьЗакрыть.Отображение = ОтображениеКнопки.Текст;
		Элементы.ТекстОшибки.ЦветТекста = Новый Цвет(128, 0, 0);
		
		Элементы.ЗаказатьЗакрыть.Видимость = Истина;
		
	ИначеЕсли ВПроцессе = 2 Тогда 
		
		Элементы.ЗаказатьЗакрыть.Видимость = Ложь;
		Элементы.ТекстОшибки.ЦветТекста = Новый Цвет(0, 128, 0);
		
		Элементы.ГруппаРеквизиты.Видимость = Ложь;
		Элементы.ГруппаСТекстом.Видимость = Истина;
		
		ТекстЗавершения = ТекстОшибки;
		ТекстОшибки = "";
		
	КонецЕсли;
	
	Элементы.ТекстОшибки.Видимость = (СокрЛП(ТекстОшибки) <> "");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОбратногоОтсчета()
	
	Таймер = Таймер - 1;
	
	Если ЗаданиеВыполнено(ФоновоеЗадание) Тогда 		
		Таймер = 0;
		ОбработкаРезультатаВыполненияЗадания(ФоновоеЗадание, Истина);		
	КонецЕсли;
	
	Если Таймер > 0 Тогда		
		ПодключитьОбработчикОжидания("Подключаемый_ОбработчикОбратногоОтсчета", 0.5, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ФоновоеЗаданиеК)
	
	Если ФоновоеЗаданиеК = Неопределено Тогда 
		Возврат Истина;
	КонецЕсли;
	
	Если ТипЗнч(ФоновоеЗаданиеК) <> Тип("Структура") Тогда 
		Возврат Истина;
	КонецЕсли;
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ФоновоеЗаданиеК.ИдентификаторЗадания);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция НормализованныйНомерТелефона(Знач Телефон)
	
	НомерТелефона = СокрЛП(Телефон);
	НомерТелефона = СтрЗаменить(НомерТелефона, " ", "");
	НомерТелефона = СтрЗаменить(НомерТелефона, "-", "");
			
	Если СтрНачинаетсяС(НомерТелефона, "8") Тогда 
		Возврат "+7" + Сред(НомерТелефона, 2);
	Иначе
		Возврат НомерТелефона;
	КонецЕсли;
	
КонецФункции
	
&НаСервере
Функция ЗапуститьЗадание()
	
	НормализованныйТелефон = НормализованныйНомерТелефона(НомерТелефона);
	
	ПараметрыЗапуска = Новый Структура;
	ПараметрыЗапуска.Вставить("Телефон", НормализованныйТелефон);
	ПараметрыЗапуска.Вставить("Имя", Фио);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ЭтотОбъект.УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = "Заказ обратного звонка в Калуге-Астрал";
	ПараметрыВыполнения.ОжидатьЗавершение = Ложь;
	ПараметрыВыполнения.АдресРезультата = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор);
	
	Задание = ДлительныеОперации.ВыполнитьВФоне(
					"Обработки.ДокументооборотСКонтролирующимиОрганами.ВыполнитьЗапросКСервису", 
					ПараметрыЗапуска, 
					ПараметрыВыполнения);
	
	Если Задание.Статус = "Выполнено" Тогда
		Результат = ПолучитьИзВременногоХранилища(ПараметрыВыполнения.АдресРезультата);		
		Если Результат = Неопределено Тогда
			ТекстОшибки = 
				НСтр("ru = 'Извините, не удалось заказать обратный звонок, попробуйте снова через несколько минут.'");
			Возврат Ложь;			
		ИначеЕсли Результат.Успешно Тогда			
			ТекстОшибки = "";
			Возврат Истина;
		Иначе
			Если Результат.Свойство("КодОшибкиСервиса") И Результат.КодОшибкиСервиса = "259" Тогда 
				ТекстОшибки = "";
				Возврат Истина;
			ИначеЕсли Результат.Свойство("Код") И Результат.Код < 9 Тогда 
				ТекстОшибки = 
					НСтр("ru = 'Извините, не удалось заказать обратный звонок из-за неполадок в интернет соединении.'");
				Возврат Ложь;
			КонецЕсли;
			Если Результат.ОписаниеОшибки <> "" Тогда 
				ТекстОшибки = Результат.ОписаниеОшибки;
			КонецЕсли;
			Возврат Ложь;
		КонецЕсли;			
	КонецЕсли;
	
	Возврат Новый Структура(
					"ИдентификаторЗадания, АдресРезультата", 
					Задание.ИдентификаторЗадания, ПараметрыВыполнения.АдресРезультата);

КонецФункции

#КонецОбласти

#КонецОбласти
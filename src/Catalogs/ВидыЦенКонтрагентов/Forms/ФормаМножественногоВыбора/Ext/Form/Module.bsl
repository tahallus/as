﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ВидыЦен") Тогда
		ВидыЦен = Параметры.ВидыЦен;
	Иначе
		ВидыЦен = Новый Массив;
	КонецЕсли;
	ЗаполнитьДерево(ВидыЦен);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Для каждого СтрокаДерева Из ДеревоВидовЦен.ПолучитьЭлементы() Цикл
		Элементы.ДеревоВидовЦен.Развернуть(СтрокаДерева.ПолучитьИдентификатор());
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДеревоВидовЦенПометкаПриИзменении(Элемент)
	
	СтрокаДерева = Элементы.ДеревоВидовЦен.ТекущиеДанные;
	Если СтрокаДерева=Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если СтрокаДерева.ПолучитьЭлементы().Количество()>0 Тогда
		Для каждого Подстрока Из СтрокаДерева.ПолучитьЭлементы()  Цикл
			Подстрока.Пометка = СтрокаДерева.Пометка;
		КонецЦикла; 
	КонецЕсли;
	СтрокаРодителя = СтрокаДерева.ПолучитьРодителя();
	Если СтрокаРодителя<>Неопределено Тогда
		Значение = СтрокаДерева.Пометка;
		Если СтрокаРодителя.Пометка И НЕ Значение Тогда
			СтрокаРодителя.Пометка = Ложь;
		КонецЕсли; 
		Для каждого ДругаяСтрока Из СтрокаРодителя.ПолучитьЭлементы() Цикл
			Если Значение<>ДругаяСтрока.Пометка Тогда
				Возврат;
			КонецЕсли; 
		КонецЦикла; 
		СтрокаРодителя.Пометка = Значение;
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ОповеститьОВыборе(ВыбранныеВидыЦен());	
	
КонецПроцедуры
 
&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	Для каждого СтрокаДерева Из ДеревоВидовЦен.ПолучитьЭлементы() Цикл
		СтрокаДерева.Пометка = Истина;
		Для каждого ПодСтрокаДерева Из СтрокаДерева.ПолучитьЭлементы() Цикл
			ПодСтрокаДерева.Пометка = Истина;
		КонецЦикла; 
	КонецЦикла; 	
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	
	Для каждого СтрокаДерева Из ДеревоВидовЦен.ПолучитьЭлементы() Цикл
		СтрокаДерева.Пометка = Ложь;
		Для каждого ПодСтрокаДерева Из СтрокаДерева.ПолучитьЭлементы() Цикл
			ПодСтрокаДерева.Пометка = Ложь;
		КонецЦикла; 
	КонецЦикла; 	
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДерево(ВидыЦен)
	
	ДеревоВидовЦен.ПолучитьЭлементы().Очистить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидыЦен", ВидыЦен);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВидыЦенКонтрагентов.Ссылка КАК ВидЦен,
	|	ВидыЦенКонтрагентов.Наименование КАК Наименование,
	|	ВидыЦенКонтрагентов.Владелец КАК Контрагент,
	|	ВидыЦенКонтрагентов.Владелец.Наименование КАК Представление,
	|	ВЫБОР
	|		КОГДА ВидыЦенКонтрагентов.Ссылка В (&ВидыЦен)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Пометка
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыЦенКонтрагентов КАК ВидыЦенКонтрагентов
	|		ПО Контрагенты.Ссылка = ВидыЦенКонтрагентов.Владелец
	|ГДЕ
	|	Контрагенты.Поставщик
	|	И НЕ ВидыЦенКонтрагентов.Ссылка ЕСТЬ NULL
	|
	|УПОРЯДОЧИТЬ ПО
	|	Пометка УБЫВ,
	|	Представление,
	|	Наименование
	|ИТОГИ
	|	МАКСИМУМ(Наименование),
	|	МАКСИМУМ(Представление),
	|	МИНИМУМ(Пометка)
	|ПО
	|	Контрагент";
	ВыборкаКонтрагент = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаКонтрагент.Следующий() Цикл
		СтрокаКонтрагент = ДеревоВидовЦен.ПолучитьЭлементы().Добавить();
		СтрокаКонтрагент.Представление = ВыборкаКонтрагент.Представление;
		ЗаполнитьЗначенияСвойств(СтрокаКонтрагент, ВыборкаКонтрагент, "Контрагент, Пометка");
		ВыборкаВидЦен = ВыборкаКонтрагент.Выбрать();
		Если ВыборкаВидЦен.Количество()>1 Тогда
			Пока ВыборкаВидЦен.Следующий() Цикл
				СтрокаВидЦен = СтрокаКонтрагент.ПолучитьЭлементы().Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаВидЦен, ВыборкаВидЦен, "ВидЦен, Пометка");
				СтрокаВидЦен.Представление = Строка(СтрокаВидЦен.ВидЦен);
			КонецЦикла; 
		Иначе
			ВыборкаВидЦен.Следующий();
			ЗаполнитьЗначенияСвойств(СтрокаКонтрагент, ВыборкаВидЦен, "ВидЦен, Пометка");
			Если Найти(ВыборкаВидЦен.Наименование, ВыборкаВидЦен.Представление)=0 Тогда
				СтрокаКонтрагент.Представление = ВыборкаВидЦен.Представление+", "+ВыборкаВидЦен.Наименование;
			Иначе
				СтрокаКонтрагент.Представление = ВыборкаВидЦен.Наименование;
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ВыбранныеВидыЦен()
	
	Результат = Новый Массив;
	Для каждого СтрокаКонтрагент Из ДеревоВидовЦен.ПолучитьЭлементы() Цикл
		Для каждого СтрокаВидЦен Из СтрокаКонтрагент.ПолучитьЭлементы() Цикл
			Если НЕ СтрокаВидЦен.Пометка Тогда
				Продолжить;
			КонецЕсли; 
			Результат.Добавить(СтрокаВидЦен.ВидЦен);
		КонецЦикла;
		Если ЗначениеЗаполнено(СтрокаКонтрагент.ВидЦен) И СтрокаКонтрагент.Пометка Тогда
			Результат.Добавить(СтрокаКонтрагент.ВидЦен);
		КонецЕсли; 
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

#КонецОбласти
 

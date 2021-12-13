﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ТекстФормулы") Тогда
		
		ТекстФормулы = Параметры.ТекстФормулы;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НЕ ЗавершениеРаботы И Модифицированность И НЕ ПустаяСтрока(ТекстФормулы) Тогда
		Отказ = Истина;
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПроверкаМодифицированности", ЭтотОбъект);
		СписокКнопок = Новый СписокЗначений;
		СписокКнопок.Добавить(КодВозвратаДиалога.Отмена);
		СписокКнопок.Добавить(КодВозвратаДиалога.ОК, НСтр("ru = 'Закрыть'"));
		Текст = НСтр("ru = 'Формула была изменена. Закрыть редактор без сохранения изменений?'");
		ПоказатьВопрос(ОповещениеОЗакрытии, Текст, СписокКнопок, , КодВозвратаДиалога.Отмена);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаМодифицированности(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СобытияЭлементовФормы

&НаКлиенте
Процедура ТекстФормулыПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовТаблицыФормыПараметрыРасчетов

&НаКлиенте
Процедура ПараметрыРасчетовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	СтруктураДанных = Новый Структура("ВыбраннаяСтрока", ВыбраннаяСтрока);

	ТекстВФормулу = ПолучитьИдентификаторПоказателя(СтруктураДанных);
	ВставитьТекстВФормулу(ТекстВФормулу);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Модифицированность = Ложь;
	Закрыть(ТекстФормулы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВставитьТекстВФормулу(Показатель)
	
	ТекстФормулы = СтрШаблон("%1 [%2]", ТекстФормулы, СокрЛП(Показатель));
	Модифицированность = Истина;
			
КонецПроцедуры	

&НаСервереБезКонтекста
Функция ПолучитьИдентификаторПоказателя(СтруктураДанных)
	
	Возврат СокрЛП(СтруктураДанных.ВыбраннаяСтрока.Идентификатор);

КонецФункции

#КонецОбласти

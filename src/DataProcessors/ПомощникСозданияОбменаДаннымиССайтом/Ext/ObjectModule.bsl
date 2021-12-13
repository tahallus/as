﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ВыполнитьДействияПоСозданиюНовогоОбменаДанными(Отказ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	
	Попытка
		
		НовыйУзел = ПланыОбмена.ОбменУправлениеНебольшойФирмойСайт.СоздатьУзел();
		НовыйУзел.УстановитьНовыйКод();
		
		ЗаполнитьЗначенияСвойств(НовыйУзел, ЭтотОбъект);
		
		Для каждого СтрокаТаблицы Из ВидыЦен Цикл
			
			НоваяСтрока = НовыйУзел.ВидыЦен.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
			
		КонецЦикла;
		
		Если НЕ ВыгружатьНаСайт Тогда 
			
			НовыйУзел.ФайлЗагрузки = СокрЛП(КаталогЗагрузки) + "\Orders.xml";
			
		КонецЕсли;
		
		Если ОбменТоварами И ОбменЗаказами Тогда
			
			НаименованиеОбмена = "Обмен товарами и заказами с WEB - сайтом";
			
		ИначеЕсли ОбменТоварами Тогда
			
			НаименованиеОбмена = "Выгрузка товаров на WEB - сайт";
			
		Иначе
			
			НаименованиеОбмена = "Обмен заказами с WEB - сайтом";
			
		КонецЕсли;
		
		НовыйУзел.Наименование = НаименованиеОбмена + " (" + СокрЛП(НовыйУзел.Код) + ")";
		
		Если ИспользоватьРегламентныеЗадания
			И РасписаниеРегламентногоЗадания <> Неопределено Тогда 
			
			ИдентификаторЗадания = ОбменССайтомРегламентныеЗадания.СоздатьНовоеЗадание(НовыйУзел.Код, НовыйУзел.Наименование, РасписаниеРегламентногоЗадания);
			НовыйУзел.ИдентификаторРегламентногоЗадания = ИдентификаторЗадания;
			
		КонецЕсли;
		
		НовыйУзел.ОтборГруппыКатегорииНоменклатуры = Перечисления.ВидыОтборовНоменклатуры.ГруппыНоменклатуры;
		НовыйУзел.ВыполнятьПолнуюВыгрузкуПринудительно = Истина;
		НовыйУзел.НастройкиПоискаКонтрагентов = ОбменССайтом.ЗаписьJSONВСтруктуру(ОбменССайтом.ПоляПоискаКонтрагентовПоУмолчанию());
		
		НовыйУзел.ПереходАдресСайта = "<Введите адрес перехода на сайт>";
		НовыйУзел.ПереходURLАдминЗоны = "<Введите адрес перехода в админзону сайта>";
		
		НовыйУзел.Записать();
		
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(НовыйУзел.Ссылка, Пароль);
		
		ОбменССайтом.ОбновитьПараметрыСеанса();
		
		СсылкаНаУзелОбмена = НовыйУзел.Ссылка;
		
	Исключение
		
		ТекстСообщения = НСтр("ru = 'При сохранении настроек обмена данными возникла ошибка: '");
		
		ОбменДаннымиСервер.СообщитьОбОшибке(ТекстСообщения + ОписаниеОшибки(), Отказ);
		ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка,,, ОписаниеОшибки());
		
	КонецПопытки;
	
	Если Отказ Тогда
		
		ОтменитьТранзакцию();
		
	Иначе
		
		ЗафиксироватьТранзакцию();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
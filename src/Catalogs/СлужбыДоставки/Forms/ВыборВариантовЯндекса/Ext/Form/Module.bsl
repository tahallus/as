﻿
#Область ОписаниеПеременных

// Используется для однократного заполнения параметров при активизации строки
&НаКлиенте
Перем ТекущийВариантДоставки;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ПараметрыПоискаСпособаДоставки", ПараметрыПоискаСпособаДоставки);
	Параметры.Свойство("ТекущаяСтрока", ТекущаяСтрока);
	Параметры.Свойство("ПунктВыдачиЗаказа", ПунктВыдачиЗаказа);
	
	Элементы.СтраницыВариантыДоставки.ТекущаяСтраница = Элементы.СтраницаДлительнаяОперация;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("НайтиВариантыДоставки", 0.1, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьСортировкуВариантовДоставки(РежимСортировки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПунктСамовывозаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ДанныеВыбора = Новый СписокЗначений;
		Для Каждого ТекЭлемент Из Элементы.ВариантыДоставки.ТекущиеДанные.ПунктыВыдачиЗаказа Цикл
			Если СтрНайти(НРег(ТекЭлемент.Представление), НРег(Текст)) Тогда
				ДанныеВыбора.Добавить(ТекЭлемент.Значение, ТекЭлемент.Представление);
			КонецЕсли;
		КонецЦикла;
	Иначе
		ДанныеВыбора = Элементы.ВариантыДоставки.ТекущиеДанные.ПунктыВыдачиЗаказа;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыВариантыДоставки

&НаКлиенте
Процедура ВариантыДоставкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОповеститьОВыбореВариантаДоставки();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантыДоставкиПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ЗаполнитьПараметрыВарианта", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ОповеститьОВыбореВариантаДоставки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоСтоимостиДляПолучателя(Команда)
	
	УстановитьСортировкуВариантовДоставки(Команда.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоСтоимостиДляМагазина(Команда)
	
	УстановитьСортировкуВариантовДоставки(Команда.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоСрокуДоставки(Команда)
	
	УстановитьСортировкуВариантовДоставки(Команда.Имя);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НайтиВариантыДоставки()
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	Задание = ЗаданиеПоискаВариантовДоставки(УникальныйИдентификатор, ПараметрыПоискаСпособаДоставки);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
	Задание,
	Новый ОписаниеОповещения("ОбработатьЗавершениеЗадания", ЭтотОбъект),
	ПараметрыОжидания);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеПоискаВариантовДоставки(ИдентификаторФормы, ПараметрыПоискаСпособаДоставки)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ИдентификаторФормы);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	Результат = ДлительныеОперации.ВыполнитьВФоне(
	"ЯндексДоставка.ЗаданиеПоискаВариантов",
	ПараметрыПоискаСпособаДоставки,
	ПараметрыВыполнения);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьЗавершениеЗадания(Результат, Параметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		ОбработатьЗавершениеЗаданияНаСервере(Результат.АдресРезультата);
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ОтобразитьОшибку(Результат.ПодробноеПредставлениеОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьЗавершениеЗаданияНаСервере(АдресХранилища)
	
	ТаблицаВариантов = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если ТипЗнч(ТаблицаВариантов) <> Тип("ТаблицаЗначений") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекСтрокаТаблицаВариантов Из ТаблицаВариантов Цикл
		
		НоваяСтрокаВариантыДоставки = ВариантыДоставки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаВариантыДоставки, ТекСтрокаТаблицаВариантов);
		
		НоваяСтрокаВариантыДоставки.СтоимостьДляПолучателяПредставление = СтрШаблон(НСтр("ru = '%1 р.'"), ТекСтрокаТаблицаВариантов.СтоимостьДляПолучателя);
		
		РасчетСтоимостиДляМагазина = ЯндексДоставка.РассчитатьСтоимостьДляМагазина(
		ТекСтрокаТаблицаВариантов,
		ПараметрыПоискаСпособаДоставки.СуммаЗаказа,
		ПараметрыПоискаСпособаДоставки.ОбъявленнаяЦенность);
		
		ЗаполнитьЗначенияСвойств(НоваяСтрокаВариантыДоставки, РасчетСтоимостиДляМагазина);
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ВариантыДоставки) Тогда
		Элементы.СтраницыВариантыДоставки.ТекущаяСтраница = Элементы.СтраницаВариантыДоставки;
		НастроитьКолонкиВариантовДоставки();
		УстановитьСортировкуВариантовДоставки(РежимСортировки);
		УстановитьТекущуюСтроку();
	Иначе
		Элементы.СтраницыВариантыДоставки.ТекущаяСтраница = Элементы.СтраницаВариантыНеНайдены;
		Заголовок = НСтр("ru = 'Яндекс не может предложить подходящего варианта.'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьОшибку(ТекстОшибки)
	
	Элементы.СтраницыВариантыДоставки.ТекущаяСтраница = Элементы.СтраницаОшибка;
	Элементы.ОписаниеОшибки.Заголовок = ТекстОшибки;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОВыбореВариантаДоставки()
	
	Если Элементы.ВариантыДоставки.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗначениеВыбора = Новый Структура;
	ЗначениеВыбора.Вставить("СпособДоставки", Элементы.ВариантыДоставки.ТекущиеДанные.СпособДоставки);
	ЗначениеВыбора.Вставить("СлужбаДоставки", Элементы.ВариантыДоставки.ТекущиеДанные.СлужбаДоставки);
	ЗначениеВыбора.Вставить("ЗонаТариф", Элементы.ВариантыДоставки.ТекущиеДанные.ЗонаТариф);
	ЗначениеВыбора.Вставить("ИдентификаторНаправленияДоставки", Элементы.ВариантыДоставки.ТекущиеДанные.ИдентификаторНаправленияДоставки);
	ЗначениеВыбора.Вставить("МинСрок", Элементы.ВариантыДоставки.ТекущиеДанные.МинСрок);
	ЗначениеВыбора.Вставить("МаксСрок", Элементы.ВариантыДоставки.ТекущиеДанные.МаксСрок);
	ЗначениеВыбора.Вставить("СтоимостьДляПолучателя", Элементы.ВариантыДоставки.ТекущиеДанные.СтоимостьДляПолучателя);
	ЗначениеВыбора.Вставить("СтоимостьДляМагазина", Элементы.ВариантыДоставки.ТекущиеДанные.СтоимостьДляМагазина);
	ЗначениеВыбора.Вставить("ДоступныеСпособыОтгрузки", Элементы.ВариантыДоставки.ТекущиеДанные.ДоступныеСпособыОтгрузки);
	
	ЗаполнитьИнтервалДоставки(ЗначениеВыбора);
	
	Если ЗначениеЗаполнено(ПунктВыдачиЗаказа) Тогда
		ЗначениеВыбора.Вставить("ПунктВыдачиЗаказа", ПунктВыдачиЗаказа);
	КонецЕсли;
	
	ОповеститьОВыборе(ЗначениеВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИнтервалДоставки(Знач ЗначениеВыбора)
	
	Если Не ЗначениеЗаполнено(ИнтервалДоставки) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекЭлемент Из Элементы.ВариантыДоставки.ТекущиеДанные.ИнтервалыДоставки Цикл
		Если ТекЭлемент["id"] = ИнтервалДоставки Тогда
			ЗначениеВыбора.Вставить("ВремяДоставкиС", СтрокаВоВремя(ТекЭлемент["from"]));
			ЗначениеВыбора.Вставить("ВремяДоставкиПо", СтрокаВоВремя(ТекЭлемент["to"]));
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекущуюСтроку()
	
	Если Не ЗначениеЗаполнено(ТекущаяСтрока) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура("СлужбаДоставки", ТекущаяСтрока);
	НайденныеСтроки = ВариантыДоставки.НайтиСтроки(ПараметрыОтбора);
	Если ЗначениеЗаполнено(НайденныеСтроки) Тогда
		Элементы.ВариантыДоставки.ТекущаяСтрока = НайденныеСтроки[0].ПолучитьИдентификатор();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПараметрыВарианта()
	
	Если ТекущийВариантДоставки = Элементы.ВариантыДоставки.ТекущаяСтрока Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийВариантДоставки = Элементы.ВариантыДоставки.ТекущаяСтрока;
	
	ПараметрыВарианта = Новый Структура;
	ПараметрыВарианта.Вставить("СлужбаДоставки");
	ПараметрыВарианта.Вставить("ПредставлениеСлужбыДоставки");
	ПараметрыВарианта.Вставить("СтоимостьДляМагазина");
	ПараметрыВарианта.Вставить("СтоимостьДляПолучателя");
	ПараметрыВарианта.Вставить("СтоимостьДляМагазинаРасшифровка");
	ПараметрыВарианта.Вставить("ИнтервалыДоставки");
	
	ЗаполнитьЗначенияСвойств(ПараметрыВарианта, Элементы.ВариантыДоставки.ТекущиеДанные);
	
	ЗаполнитьПараметрыВариантаНаСервере(ПараметрыВарианта);
	
	Элементы.ПунктВыдачиЗаказа.Видимость = ЗначениеЗаполнено(Элементы.ВариантыДоставки.ТекущиеДанные.ПунктыВыдачиЗаказа);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыВариантаНаСервере(Знач ПараметрыВарианта)
	
	ЗаполнитьРасчетСтоимостиДоставки(ПараметрыВарианта);
	ЗаполнитьСписокВыбораИнтервалыДоставки(ПараметрыВарианта.ИнтервалыДоставки);
	ИнтервалДоставки = ИнтервалДоставкиПоУмолчанию(ПараметрыВарианта.ИнтервалыДоставки);
	Если ЗначениеЗаполнено(ПунктВыдачиЗаказа)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПунктВыдачиЗаказа, "Владелец") <> ПараметрыВарианта.СлужбаДоставки Тогда
		ПунктВыдачиЗаказа = Справочники.ПунктыВыдачиЗаказа.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРасчетСтоимостиДоставки(Знач ПараметрыВарианта)
	
	Элементы.ЗаголовокРасчетСтоимостиДоставки.Заголовок = СтрШаблон(
	НСтр("ru = 'Расчет для ""%1""'"),
	ПараметрыВарианта.ПредставлениеСлужбыДоставки);
	
	РасчетСтоимостиДоставки.Очистить();
	
	Макет = Справочники.СлужбыДоставки.ПолучитьМакет("РасчетСтоимостиДоставки");
	
	ВывестиНаименованиеИСумму(
	НСтр("ru = 'Стоимость доставки для вашего магазина'"),
	ПараметрыВарианта.СтоимостьДляМагазина,
	Макет);
	
	ВывестиОтступ(Макет);
	
	ВывестиЗаголовок(НСтр("ru = 'Включено:'"), Макет);
	
	ВывестиНаименованиеИСумму(НСтр("ru = 'Тариф доставки'"), ПараметрыВарианта.СтоимостьДляПолучателя, Макет);
	
	Для Каждого ТекСтрокаОбязательныеУслуги Из ПараметрыВарианта.СтоимостьДляМагазинаРасшифровка.ОбязательныеУслуги Цикл
		ВывестиНаименованиеИСумму(ТекСтрокаОбязательныеУслуги.Наименование, ТекСтрокаОбязательныеУслуги.Сумма, Макет);
	КонецЦикла;
	
	ВывестиОтступ(Макет);
	
	ВывестиЗаголовок(НСтр("ru = 'Не включено:'"), Макет);
	
	Для Каждого ТекСтрокаОпциональныеУслуги Из ПараметрыВарианта.СтоимостьДляМагазинаРасшифровка.ОпциональныеУслуги Цикл
		ВывестиНаименованиеИСумму(ТекСтрокаОпциональныеУслуги.Наименование, ТекСтрокаОпциональныеУслуги.Сумма, Макет);
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораИнтервалыДоставки(Знач ИнтервалыДоставки)
	
	Элементы.ИнтервалДоставки.СписокВыбора.Очистить();
	
	Для Каждого ТекЭлемент Из ИнтервалыДоставки Цикл
		
		ВремяДоставкиС = СтрокаВоВремя(ТекЭлемент["from"]);
		ВремяДоставкиПо = СтрокаВоВремя(ТекЭлемент["to"]);
		
		Элементы.ИнтервалДоставки.СписокВыбора.Добавить(
		ТекЭлемент["id"],
		СтрШаблон("%1 - %2", 
		Формат(ВремяДоставкиС, "ДФ=ЧЧ:мм"), 
		Формат(ВремяДоставкиПо, "ДФ=ЧЧ:мм")));
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СтрокаВоВремя(СтрокаВремя)
	
	ЧастиВремени = СтрРазделить(СтрокаВремя, ":");
	
	Возврат Дата(1,1,1, ЧастиВремени[0], ЧастиВремени[1], ЧастиВремени[2]);
	
КонецФункции

&НаСервере
Функция ИнтервалДоставкиПоУмолчанию(Знач ИнтервалыДоставки)
	
	Результат = "";
	МаксИнтервал = 0;
	
	Для Каждого ТекЭлемент Из ИнтервалыДоставки Цикл
		
		ВремяДоставкиС = СтрокаВоВремя(ТекЭлемент["from"]);
		ВремяДоставкиПо = СтрокаВоВремя(ТекЭлемент["to"]);
		
		Если ВремяДоставкиПо - ВремяДоставкиС > МаксИнтервал Тогда
			Результат = ТекЭлемент["id"];
			МаксИнтервал = ВремяДоставкиПо - ВремяДоставкиС;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ВывестиЗаголовок(Знач Заголовок, Знач Макет)
	
	Область = Макет.ПолучитьОбласть("Заголовок");
	Область.Параметры.Заголовок = Заголовок;
	РасчетСтоимостиДоставки.Вывести(Область);
	
КонецПроцедуры

&НаСервере
Процедура ВывестиНаименованиеИСумму(Знач Наименование, Знач Сумма, Знач Макет)
	
	Область = Макет.ПолучитьОбласть("Строка");
	Область.Параметры.Наименование = Наименование;
	Область.Параметры.Сумма = Формат(Сумма, "ЧЦ=15; ЧДЦ=2; ЧН=0,00");
	РасчетСтоимостиДоставки.Вывести(Область);
	
КонецПроцедуры

&НаСервере
Процедура ВывестиОтступ(Знач Макет)
	
	Область = Макет.ПолучитьОбласть("Отступ");
	РасчетСтоимостиДоставки.Вывести(Область);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьКолонкиВариантовДоставки()
	
	Если ЗначениеЗаполнено(ПараметрыПоискаСпособаДоставки.СпособДоставки) Тогда
		Элементы.СлужбаИСпособДоставки.Заголовок = НСтр("ru = 'Служба доставки'");
		Элементы.ВариантыДоставкиСпособДоставки.Видимость = Ложь;
	Иначе
		Элементы.СлужбаИСпособДоставки.Заголовок = НСтр("ru = 'Служба и способ доставки'");
		Элементы.ВариантыДоставкиСпособДоставки.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСортировкуВариантовДоставки(ВыбранныйВариантСортировки)
	
	Если Не ЗначениеЗаполнено(ВыбранныйВариантСортировки) Тогда
		ВыбранныйВариантСортировки = "ПоСтоимостиДляПолучателя";
	КонецЕсли;
	
	Если Не ВариантыСортировки().Свойство(ВыбранныйВариантСортировки) Тогда
		ВыбранныйВариантСортировки = "ПоСтоимостиДляПолучателя";
	КонецЕсли;
	
	ВариантыДоставки.Сортировать(ВариантыСортировки()[ВыбранныйВариантСортировки]);
	Элементы.Сортировать.Заголовок = Команды[ВыбранныйВариантСортировки].Заголовок;
	
	Для Каждого ТекВариант Из ВариантыСортировки() Цикл
		Элементы[ТекВариант.Ключ].Пометка = ТекВариант.Ключ = ВыбранныйВариантСортировки;
	КонецЦикла;
	
	РежимСортировки = ВыбранныйВариантСортировки;
	
КонецПроцедуры

&НаСервере
Функция ВариантыСортировки()
	
	Результат = Новый Структура;
	Результат.Вставить("ПоСтоимостиДляПолучателя", "СтоимостьДляПолучателя");
	Результат.Вставить("ПоСтоимостиДляМагазина", "СтоимостьДляМагазина");
	Результат.Вставить("ПоСрокуДоставки", "МинСрок, МаксСрок");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
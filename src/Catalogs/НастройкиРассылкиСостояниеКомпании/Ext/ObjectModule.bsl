﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Наименование = СостояниеКомпании.АвтоНаименованиеНастройки();
	
	Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
	
	НоваяСтрокаПолучатели = Получатели.Добавить();
	
	АдресЭлектроннойПочтыПользователя = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
	Пользователи.ТекущийПользователь(),
	Перечисления["ТипыКонтактнойИнформации"].АдресЭлектроннойПочты);
	Если ЗначениеЗаполнено(АдресЭлектроннойПочтыПользователя) Тогда
		НоваяСтрокаПолучатели.Получатель = АдресЭлектроннойПочтыПользователя;
	КонецЕсли;
	
	УчетнаяЗапись = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
	Пользователи.ТекущийПользователь(),
	"ОсновнаяУчетнаяЗаписьЭлектроннойПочты");
	
	Расписание = Новый ХранилищеЗначения(СостояниеКомпании.РасписаниеПоУмолчанию());
	
	ЗаполнитьНастройкиСекцийПоУмолчанию();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если ПометкаУдаления Тогда
		Использование = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если РаботаВМоделиСервиса.РазделениеВключено() Тогда
		
		УстановитьПараметрыРазделенногоЗадания();
		
	Иначе
		
		УстановитьПараметрыНеразделенногоЗадания();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если РаботаВМоделиСервиса.РазделениеВключено() Тогда
		
		УдалитьРазделенноеЗадание();
		
	Иначе
		
		УдалитьНеразделенноеЗадание();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьНастройкиСекцийПоУмолчанию()
	
	Для Каждого ТекСекция Из СостояниеКомпанииКлиентСервер.ОписанияВсехСекций() Цикл
		
		НоваяНастройка = НастройкиСекций.Добавить();
		НоваяНастройка.Использование = Истина;
		НоваяНастройка.ИдентификаторСекции = Новый УникальныйИдентификатор;
		НоваяНастройка.ТипСекции = ТекСекция.Ключ;
		НоваяНастройка.ЗаголовокСекции = ТекСекция.Значение.ЗаголовокСекции;
		
		Если ТекСекция.Ключ = "Товары" Тогда
			НоваяНастройка.ВидЦенПродажи = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
			Пользователи.ТекущийПользователь(),
			"ОсновнойВидЦенПродажи");
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьПараметрыРазделенногоЗадания();
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Использование", Использование);
	ПараметрыЗадания.Вставить("ИмяМетода" , Метаданные.РегламентныеЗадания.СостояниеКомпании.ИмяМетода);
	ПараметрыЗадания.Вставить("Ключ" , Строка(Ссылка.УникальныйИдентификатор()));
	ПараметрыЗадания.Вставить("Параметры", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПараметрыЗадания.Ключ));
	ПараметрыЗадания.Вставить("Расписание", Расписание.Получить());
	
	Задание = Неопределено;
	
	ТаблицаЗаданий = ОчередьЗаданий.ПолучитьЗадания(Новый Структура("Ключ", ПараметрыЗадания.Ключ));
	Если ТаблицаЗаданий.Количество() <> 0 Тогда
		Задание = ТаблицаЗаданий[0].Идентификатор;
	КонецЕсли;
	
	Если Задание = Неопределено Тогда
		Задание = ОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
	Иначе
		ОчередьЗаданий.ИзменитьЗадание(Задание, ПараметрыЗадания);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьПараметрыНеразделенногоЗадания();
	
	Задание = Неопределено;
	
	НайденныеЗадания = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Новый Структура("Ключ", Строка(Ссылка.УникальныйИдентификатор())));
	Если ЗначениеЗаполнено(НайденныеЗадания) Тогда
		Задание = НайденныеЗадания[0];
	КонецЕсли;
	
	Если Задание = Неопределено Тогда
		Задание = РегламентныеЗадания.СоздатьРегламентноеЗадание(Метаданные.РегламентныеЗадания.СостояниеКомпании);
	КонецЕсли;
	
	Задание.Использование = Использование;
	Задание.Ключ = Строка(Ссылка.УникальныйИдентификатор());
	Задание.Параметры = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Задание.Ключ);
	Задание.Наименование = СтрШаблон("%1 - %2", Метаданные.РегламентныеЗадания.СостояниеКомпании.Наименование, Наименование);
	Задание.Расписание = Расписание.Получить();
	Задание.Записать();
	
КонецПроцедуры

Процедура УдалитьРазделенноеЗадание()
	
	ОтборЗаданий = Новый Структура;
	ОтборЗаданий.Вставить("Ключ", Строка(Ссылка.УникальныйИдентификатор()));
	ТаблицаЗаданий = ОчередьЗаданий.ПолучитьЗадания(ОтборЗаданий);
	
	Для Каждого ТекСтрока Из ТаблицаЗаданий Цикл
		ОчередьЗаданий.УдалитьЗадание(ТекСтрока.Идентификатор);
	КонецЦикла;
	
КонецПроцедуры

Процедура УдалитьНеразделенноеЗадание()
	
	ОтборЗаданий = Новый Структура;
	ОтборЗаданий.Вставить("Ключ", Строка(Ссылка.УникальныйИдентификатор()));
	НайденныеЗадания = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Новый Структура("Ключ", Строка(Ссылка.УникальныйИдентификатор())));
	
	Для Каждого ТекЗадание Из НайденныеЗадания Цикл
		ТекЗадание.Удалить();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
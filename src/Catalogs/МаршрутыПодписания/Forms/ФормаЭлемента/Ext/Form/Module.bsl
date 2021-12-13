﻿#Область ОписаниеПеременных

&НаКлиенте
Перем СтрокаРодителя, РазрешитьДобавлениеНовойСтроки;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Объект.Ссылка.Пустая() Тогда
		Если Объект.ТаблицаТребований.Количество() = 0 Тогда
			ИнициализироватьДерево();
		Иначе 
			МаршрутыПодписанияБЭД.ЗаполнитьДеревоМаршрутаНаФорме(ЭтотОбъект, Объект.ТаблицаТребований); 
		КонецЕсли;
	КонецЕсли;
	
	МаршрутыПодписанияБЭД.УстановитьУсловноеОформлениеДереваМаршрута(ЭтотОбъект,, 
		ЗначениеЗаполнено(Объект.КлючАвтоматическойНастройки));
	УстановитьТекстПояснения();
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	МаршрутыПодписанияБЭД.ЗаполнитьДеревоМаршрутаНаФорме(ЭтотОбъект, ТекущийОбъект.ТаблицаТребований); 
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	КэшироватьОрганизацию();
	УстановитьДоступностьЭлементов();
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Объект.Предопределенный Тогда
		НепроверяемыеРеквизиты = Новый Массив;
		НепроверяемыеРеквизиты.Добавить("Организация");
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	КонецЕсли;
	
	ПроверитьДерево(Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.ВидПодписи = Перечисления.ВидыЭлектронныхПодписей.Простая Тогда
		Дерево = РеквизитФормыВЗначение("ДеревоТребований");
		Для Каждого СтрокаТаблицы Из ТекущийОбъект.ТаблицаТребований Цикл
			ОтборСтрокДерева = Новый Структура("Сертификат", СтрокаТаблицы.Сертификат);
			СтрокиДерева = Дерево.Строки.НайтиСтроки(ОтборСтрокДерева, Истина);
			Для каждого Строка Из СтрокиДерева Цикл
				Строка.Сертификат = Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования.ПустаяСсылка();
			КонецЦикла;
			СтрокаТаблицы.Сертификат = Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования.ПустаяСсылка();
		КонецЦикла;
		ЗначениеВРеквизитФормы(Дерево, "ДеревоТребований");
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.Свойство("ЗакрытьПослеЗаписи") 
			И ПараметрыЗаписи.ЗакрытьПослеЗаписи Тогда
				
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)	

	Если Объект.Организация <> ТекущаяОрганизация Тогда
		Оповещение = Новый ОписаниеОповещения("ОрганизацияПриИзмененииЗавершение", ЭтотОбъект);
		
		// Если в дереве есть элементы второго уровня, его надо очистить
		ТребуетсяОчистка = Ложь;
		КорневыеЭлементы = ДеревоТребований.ПолучитьЭлементы();
		Если КорневыеЭлементы.Количество() Тогда
			ЭлементыВторогоУровня = КорневыеЭлементы[0].ПолучитьЭлементы();
			ТребуетсяОчистка = ЭлементыВторогоУровня.Количество() > 0;
		КонецЕсли;
		
		Если ТребуетсяОчистка Тогда
			ПоказатьВопрос(Оповещение, НСтр("ru = 'При изменении организации таблица требований будет очищена. Продолжить?'"), 
				РежимДиалогаВопрос.ДаНет);
		Иначе
		    ВыполнитьОбработкуОповещения(Оповещение, КодВозвратаДиалога.Да);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзмененииЗавершение(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		КэшироватьОрганизацию();
		
		// Оставим только корневой элемент дерева
		КорневыеЭлементы = ДеревоТребований.ПолучитьЭлементы();
		Если КорневыеЭлементы.Количество() Тогда
			ЭлементыВторогоУровня = КорневыеЭлементы[0].ПолучитьЭлементы();
			Если ЭлементыВторогоУровня.Количество() Тогда
				ЭлементыВторогоУровня.Очистить();
			КонецЕсли;
		КонецЕсли;
		
		УстановитьДоступностьЭлементов();
	Иначе 
		Объект.Организация = ТекущаяОрганизация;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияВключитьВозможностьИзмененияНажатие(Элемент)
	
	Объект.КлючАвтоматическойНастройки = "";
	Объект.Наименование = "";
	Модифицированность = Истина;
	
	ТекущийЭлемент = Элементы.Наименование;
	
	ПриВключенииВозможностиИзмененияНаСервере();
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоТребований

&НаКлиенте
Процедура ДеревоТребованийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не Копирование И Не РазрешитьДобавлениеНовойСтроки Тогда
		Отказ = Истина;
	Иначе
		РазрешитьДобавлениеНовойСтроки = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоТребованийПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Не НоваяСтрока ИЛИ Копирование Тогда
		УстановитьТипОсновногоЗначения();
		
		Если Копирование Тогда
			Элемент.ТекущиеДанные.Идентификатор = "";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоТребованийПередУдалением(Элемент, Отказ)
	
	// Корневой узел удалять нельзя: дерево всегда должно начинаться с требования
	Если Элементы.ДеревоТребований.ТекущиеДанные.ПолучитьРодителя() = Неопределено Тогда
		Отказ = Истина;
	Иначе
		СтрокаРодителя = Элементы.ДеревоТребований.ТекущиеДанные.ПолучитьРодителя();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоТребованийПослеУдаления(Элемент)
	
	Если СтрокаРодителя <> Неопределено Тогда
		МаршрутыПодписанияБЭДКлиентСервер.ЗаполнитьСлужебныеРеквизитыСтрокиДерева(СтрокаРодителя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоТребованийПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НоваяСтрока И Не ОтменаРедактирования Тогда
		СтрокаРодителя = Элементы.ДеревоТребований.ТекущиеДанные.ПолучитьРодителя();
		Если СтрокаРодителя <> Неопределено Тогда
			МаршрутыПодписанияБЭДКлиентСервер.ЗаполнитьСлужебныеРеквизитыСтрокиДерева(СтрокаРодителя);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоТребованийОсновноеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекДанные = Элементы.ДеревоТребований.ТекущиеДанные;
	Если ТекДанные.ЭтоСтрокаУсловия Тогда
		СтандартнаяОбработка = Ложь;
		ОписаниеОповещения = Новый ОписаниеОповещения("ДеревоТребованийОсновноеЗначениеНачалоВыбораЗавершение", ЭтотОбъект);
		СоответствиеПредставленийТребованиям = МаршрутыПодписанияБЭДКлиентСервер.СоответствиеПредставленийТребованиям(ТекДанные);
		
		СписокВыбора = Новый СписокЗначений;
		Для Каждого КлючИЗначение Из СоответствиеПредставленийТребованиям Цикл
			СписокВыбора.Добавить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
		
		ПоказатьВыборИзСписка(ОписаниеОповещения, СписокВыбора, Элемент, СписокВыбора.НайтиПоЗначению(ТекДанные.Требование));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоТребованийОсновноеЗначениеНачалоВыбораЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт 
	
	Если РезультатВыбора <> Неопределено Тогда
		СтрокаДерева = ДеревоТребований.НайтиПоИдентификатору(Элементы.ДеревоТребований.ТекущаяСтрока);
		
		Если ТипЗнч(РезультатВыбора) = Тип("ЭлементСпискаЗначений") Тогда // это был выбор требования
			СтрокаДерева.Требование = РезультатВыбора.Значение;
		Иначе //это был выбор подписанта
			СтрокаДерева.Подписант = РезультатВыбора;
			
			СписокПодписантовДляОтбора = Новый СписокЗначений;
			СписокПодписантовДляОтбора.Добавить(ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка"));
			Если ЗначениеЗаполнено(РезультатВыбора) Тогда
				СписокПодписантовДляОтбора.Добавить(РезультатВыбора);
			КонецЕсли;
			СтрокаДерева.ОтборСертификатов = СписокПодписантовДляОтбора;
			
			Если Не ОтборСертификатовКорректный(СтрокаДерева.Сертификат, СписокПодписантовДляОтбора, Объект.Организация) Тогда
				СтрокаДерева.Сертификат = Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		МаршрутыПодписанияБЭДКлиентСервер.ЗаполнитьСлужебныеРеквизитыСтрокиДерева(СтрокаДерева);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоТребованийОсновноеЗначениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ДеревоТребованийОсновноеЗначениеНачалоВыбораЗавершение(ВыбранноеЗначение, Новый Структура);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоТребованийОсновноеЗначениеПриИзменении(Элемент)
	
	ТекДанные = Элементы.ДеревоТребований.ТекущиеДанные;
	Если ТекДанные <> Неопределено И НЕ ТекДанные.ЭтоСтрокаУсловия Тогда
		ДеревоТребованийОсновноеЗначениеНачалоВыбораЗавершение(ТекДанные.ОсновноеЗначение, Новый Структура);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоТребованийСертификатПриИзменении(Элемент)
	
	СтрокаДерева = ДеревоТребований.НайтиПоИдентификатору(Элементы.ДеревоТребований.ТекущаяСтрока);
	МаршрутыПодписанияБЭДКлиентСервер.ЗаполнитьСлужебныеРеквизитыСтрокиДерева(СтрокаДерева);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоТребованийУдалить(Команда)
	
	ТекущиеДанныеДерева = Элементы.ДеревоТребований.ТекущиеДанные;
	
	Если ТекущиеДанныеДерева <> Неопределено Тогда
		СтрокаРодителя = ТекущиеДанныеДерева.ПолучитьРодителя();
		
		// Корневой узел удалять нельзя: дерево всегда должно начинаться с требования
		Если СтрокаРодителя <> Неопределено Тогда
			ЭлементыТекущегоУровня = СтрокаРодителя.ПолучитьЭлементы();
			ИндексТекущейСтроки = ЭлементыТекущегоУровня.Индекс(ТекущиеДанныеДерева);
			ЭлементыТекущегоУровня.Удалить(ИндексТекущейСтроки);
			
			МаршрутыПодписанияБЭДКлиентСервер.ЗаполнитьСлужебныеРеквизитыСтрокиДерева(СтрокаРодителя);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	ЗаписатьМаршрут(Истина);	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДанные(Команда)
	ЗаписатьМаршрут(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьМаршрут(ЗакрытьФормуПослеЗаписи)
	
	ОчиститьСообщения();
	
	ЕстьОшибкиЗаполнения = Ложь;
	Если Не МаршрутВалидирован(ЕстьОшибкиЗаполнения) Тогда
		
		Если Не ЕстьОшибкиЗаполнения Тогда
			
			ПараметрыЗаписи = Новый Структура("ЗакрытьПослеЗаписи", ЗакрытьФормуПослеЗаписи);
		
			ОписаниеОповещения = Новый ОписаниеОповещения("ВопросОЗаписиПолученОтвет", ЭтотОбъект, ПараметрыЗаписи);
			ТекстВопроса = НСтр("ru = 'Обнаружены возможные ошибки в настройке маршрута. Продолжить запись?'");
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, НСтр(
				"ru = 'Настройка некорректна'"));
		КонецЕсли;
		
	Иначе
		
		ПараметрыЗаписи = Новый Структура("ЗакрытьПослеЗаписи", ЗакрытьФормуПослеЗаписи);
		Записать(ПараметрыЗаписи);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьТребование(Команда)
	
	ТипТребования = СтрЗаменить(Команда.Имя, "ДобавитьГруппу", "");
	ДобавитьНовуюСтрокуВДерево(Истина, ПредопределенноеЗначение("Перечисление.ТребованияКПодписаниюЭД." + ТипТребования));
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПодписанта(Команда)
	
	ДобавитьНовуюСтрокуВДерево();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	
	Элементы.ДекорацияПоясняющийТекст.Видимость = Объект.Предопределенный;
	
	МаршрутСозданАвтоматически = ЗначениеЗаполнено(Объект.КлючАвтоматическойНастройки);
	Элементы.ГруппаПодсказкаБлокировки.Видимость = МаршрутСозданАвтоматически;
	Элементы.ДеревоТребованийОсновноеЗначение.АвтоОтметкаНезаполненного = Не МаршрутСозданАвтоматически;
	Элементы.ДеревоТребованийСертификат.Видимость = Объект.ВидПодписи <> Перечисления.ВидыЭлектронныхПодписей.Простая;	
	Элементы.Правила.Видимость 	   = Не Объект.Предопределенный;
	Элементы.Организация.Видимость = Не Объект.Предопределенный;
	Элементы.Родитель.Видимость    = Не Объект.Предопределенный;
	Элементы.ВидПодписи.Видимость = Не Объект.Предопределенный;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЭлементов()

	Элементы.Правила.Доступность = ЗначениеЗаполнено(Объект.Организация);
	ТолькоПросмотр = Объект.Предопределенный ИЛИ ЗначениеЗаполнено(Объект.КлючАвтоматическойНастройки);

КонецПроцедуры

&НаКлиенте
Процедура КэшироватьОрганизацию()
	
	ТекущаяОрганизация = Объект.Организация;

КонецПроцедуры

&НаСервере
Процедура УстановитьТекстПояснения()
	
	ТекстПояснения = "";
	Если Объект.Ссылка = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.МаршрутыПодписания.ОднойДоступнойПодписью") Тогда
		ТекстПояснения = НСтр("ru = 'По данному правилу устанавливается одна подпись из числа доступных по организации и используемому сервису.'");
	ИначеЕсли Объект.Ссылка = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.МаршрутыПодписания.УказыватьПриСоздании") Тогда
		ТекстПояснения = НСтр("ru = 'Правила подписания будут задаваться при отправке документа на подпись.'");
	КонецЕсли;

	Элементы.ДекорацияПоясняющийТекст.Заголовок = ТекстПояснения;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОтборСертификатовКорректный(Сертификат, СписокПодписантовДляОтбора, Организация)

	Возврат СписокПодписантовДляОтбора.НайтиПоЗначению(Сертификат.Пользователь) <> Неопределено
		И Сертификат.Организация = Организация;

КонецФункции 

#Область ПроверкиПередЗаписью

&НаКлиенте
Процедура ВопросОЗаписиПолученОтвет(Ответ, ПараметрыЗаписи) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		Записать(ПараметрыЗаписи);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция МаршрутВалидирован(ЕстьОшибкиЗаполнения = Ложь)
	ЕстьОшибкиЗаполнения = НЕ ПроверитьЗаполнение();
	ЕстьОшибкиВЗависимыхНастройках = Ложь;
	
	Если Не ЕстьОшибкиЗаполнения Тогда
		ЗаписатьДеревоТребований();
		
		Если Не Объект.Предопределенный И Не Объект.Ссылка.Пустая() Тогда
			ПараметрыПроверки = МаршрутыПодписанияБЭД.НовыеПараметрыПроверкиВалидностиМаршрута();
			ЗаполнитьЗначенияСвойств(ПараметрыПроверки, Объект); 
			ПараметрыПроверки.Маршрут = Объект.Ссылка;
			ПараметрыПроверки.ТаблицаТребований = Объект.ТаблицаТребований.Выгрузить();
			
			ЕстьОшибкиВЗависимыхНастройках = Не МаршрутыПодписанияБЭД.МаршрутПоВсемЗависимымНастройкамВалиден(ПараметрыПроверки);
		КонецЕсли;
	КонецЕсли;
	
	Возврат НЕ ЕстьОшибкиЗаполнения И Не ЕстьОшибкиВЗависимыхНастройках;

КонецФункции

#КонецОбласти

#Область РаботаСДеревом

&НаСервере
Процедура ИнициализироватьДерево()

	КорневыеЭлементы = ДеревоТребований.ПолучитьЭлементы();
	КорневыеЭлементы.Очистить();
	
	КорневаяСтрокаДерева = КорневыеЭлементы.Добавить();
	КорневаяСтрокаДерева.Требование		= Перечисления.ТребованияКПодписаниюЭД.ИЛИ;
	МаршрутыПодписанияБЭДКлиентСервер.ЗаполнитьСлужебныеРеквизитыСтрокиДерева(КорневаяСтрокаДерева);
	Элементы.ДеревоТребований.ТекущаяСтрока = КорневаяСтрокаДерева.ПолучитьИдентификатор();
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьДерево(Отказ)

	ЕстьПустыеЗначения = Ложь;
	ЕстьТребованияБезПодписантов = Ложь;
	ДублиСертификатов = Новый Массив;
	ДублиПодписантов = Новый Массив;
	Для Каждого СтрокаДерева Из ДеревоТребований.ПолучитьЭлементы() Цикл
		ПроверитьСтрокуДерева(СтрокаДерева, ЕстьПустыеЗначения, ЕстьТребованияБезПодписантов, ДублиПодписантов, 
			ДублиСертификатов);
	КонецЦикла;
	
	Ошибки = Неопределено;
	
	Если ЕстьПустыеЗначения Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ДеревоТребований", 
			НСтр("ru = 'В составе маршрута есть неуказанные пользователи'"), Неопределено);
	КонецЕсли;
		
	Если ЕстьТребованияБезПодписантов Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ДеревоТребований", 
			НСтр("ru = 'В составе маршрута есть группы, не содержащие подписантов'"), Неопределено);
	КонецЕсли;
		
	Для Каждого Подписант Из ДублиПодписантов Цикл
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Подписант ""%1"" задублирован в некоторых ветках маршрута'"), Подписант);
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ДеревоТребований", ТекстОшибки, Неопределено);
	КонецЦикла;
	
	Для Каждого Сертификат Из ДублиСертификатов Цикл
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Сертификат ""%1"" задублирован в некоторых ветках маршрута'"), Сертификат);
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ДеревоТребований", ТекстОшибки, Неопределено);
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);

КонецПроцедуры

&НаСервере
Процедура ПроверитьСтрокуДерева(СтрокаДерева, ЕстьПустыеЗначения, ЕстьТребованияБезПодписантов, ДублиПодписантов, 
	ДублиСертификатов)

	Если Не ЗначениеЗаполнено(СтрокаДерева.Требование) И Не ЗначениеЗаполнено(СтрокаДерева.Подписант) Тогда
		ЕстьПустыеЗначения = Истина;
	КонецЕсли;
		
	СписокПодписантов = Новый Массив;
	СписокСертификатов = Новый Массив;
	
	ПодчиненныеСтроки = СтрокаДерева.ПолучитьЭлементы();
	Если ПодчиненныеСтроки.Количество() = 0 И СтрокаДерева.ЭтоСтрокаУсловия Тогда
		ЕстьТребованияБезПодписантов = Истина;
	Иначе
		Для Каждого ПодчиненнаяСтрокаДерева Из ПодчиненныеСтроки Цикл
			ПроверитьСтрокуДерева(ПодчиненнаяСтрокаДерева, ЕстьПустыеЗначения, ЕстьТребованияБезПодписантов, ДублиПодписантов,
				ДублиСертификатов);
			
			Если ЗначениеЗаполнено(ПодчиненнаяСтрокаДерева.Подписант) Тогда
				Если СписокПодписантов.Найти(ПодчиненнаяСтрокаДерева.Подписант) <> Неопределено Тогда
					Если ДублиПодписантов.Найти(ПодчиненнаяСтрокаДерева.Подписант) = Неопределено Тогда
						ДублиПодписантов.Добавить(ПодчиненнаяСтрокаДерева.Подписант);
					КонецЕсли;
				Иначе
					СписокПодписантов.Добавить(ПодчиненнаяСтрокаДерева.Подписант);	
				КонецЕсли;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ПодчиненнаяСтрокаДерева.Сертификат) Тогда
				Если СписокСертификатов.Найти(ПодчиненнаяСтрокаДерева.Сертификат) <> Неопределено Тогда
					Если ДублиСертификатов.Найти(ПодчиненнаяСтрокаДерева.Сертификат) = Неопределено Тогда
						ДублиСертификатов.Добавить(ПодчиненнаяСтрокаДерева.Сертификат);
					КонецЕсли;
				Иначе
					СписокСертификатов.Добавить(ПодчиненнаяСтрокаДерева.Сертификат);	
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаписатьДеревоТребований(ТекущийОбъект = Неопределено)
	
	Если ТекущийОбъект = Неопределено Тогда
		ТаблицаТребований = Неопределено;
	Иначе
		ТаблицаТребований = ТекущийОбъект.ТаблицаТребований;
		ТаблицаТребований.Очистить();
	КонецЕсли;
	
	Дерево = РеквизитФормыВЗначение("ДеревоТребований");
	МаршрутыПодписанияБЭД.ЗаполнитьТаблицуТребованийКПодписаниюПоДереву(ТаблицаТребований, Дерево);
	
	Если ТекущийОбъект = Неопределено Тогда
		Объект.ТаблицаТребований.Загрузить(ТаблицаТребований);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьНовуюСтрокуВДерево(ЭтоУсловие = Ложь, Требование = Неопределено)
	
	ТекущаяСтрока = Элементы.ДеревоТребований.ТекущаяСтрока;
	
	ЕстьУсловия 	= Ложь;
	ЕстьПодписанты 	= Ложь;
	МаршрутыПодписанияБЭДКлиентСервер.ОпределитьПараметрыПодчиненныхСтрокДерева(
		Элементы.ДеревоТребований.ТекущиеДанные, ЕстьУсловия, ЕстьПодписанты);
	
	// Внутри одной группы для простоты понимания дерева не будем смешивать элементы разных типов.
	Если ЕстьУсловия И Не ЭтоУсловие Или ЕстьПодписанты И ЭтоУсловие Тогда
		ЗначениеПодстановки = ?(ЕстьУсловия И Не ЭтоУсловие, НСтр("ru = 'требования'"), НСтр("ru = 'подписи'"));
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Каждая группа может содержать элементы одного типа. В эту группу можно добавить только %1.'"),
			ЗначениеПодстановки);
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(СтрокаСообщения, Объект.Ссылка, "ДеревоТребований"); 
	// Дочерние строки добавляются только у требований.
	Иначе
		
		Если Не Элементы.ДеревоТребований.ТекущиеДанные.ЭтоСтрокаУсловия Тогда
			РодительЭлемента = ДеревоТребований.НайтиПоИдентификатору(ТекущаяСтрока).ПолучитьРодителя();
			ТекущаяСтрока = РодительЭлемента.ПолучитьИдентификатор();
			Элементы.ДеревоТребований.ТекущаяСтрока = ТекущаяСтрока;
		КонецЕсли;
		
		Если ТекущаяСтрока = Неопределено Или Элементы.ДеревоТребований.ТекущиеДанные.ЭтоСтрокаУсловия Тогда
			ОчиститьСообщения();

			УстановитьТипОсновногоЗначения(ЭтоУсловие);

			Если ЭтоУсловие И ЗначениеЗаполнено(Требование) Тогда
				НоваяСтрока = ДеревоТребований.НайтиПоИдентификатору(ТекущаяСтрока).ПолучитьЭлементы().Добавить();
				НоваяСтрока.Требование = Требование;
				НоваяСтрока.ЭтоСтрокаУсловия = Истина;

				МаршрутыПодписанияБЭДКлиентСервер.ЗаполнитьСлужебныеРеквизитыСтрокиДерева(
					НоваяСтрока.ПолучитьРодителя());
				Элементы.ДеревоТребований.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
			Иначе
				РазрешитьДобавлениеНовойСтроки = Истина;
				Элементы.ДеревоТребований.ДобавитьСтроку();
			КонецЕсли;

			ТекущаяСтрока = Элементы.ДеревоТребований.ТекущаяСтрока;
			СтрокаДерева = ДеревоТребований.НайтиПоИдентификатору(ТекущаяСтрока);
			СтрокаДерева.ЭтоСтрокаУсловия = ЭтоУсловие;

			МаршрутыПодписанияБЭДКлиентСервер.ЗаполнитьСлужебныеРеквизитыСтрокиДерева(СтрокаДерева);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТипОсновногоЗначения(ЭтоУсловие = Неопределено)
	
	Если ЭтоУсловие = Неопределено Тогда
		ЭтоУсловие = Элементы.ДеревоТребований.ТекущиеДанные.ЭтоСтрокаУсловия;
	КонецЕсли;
	
	ТипСтрока = Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(0));
	ТипПользователи = Новый ОписаниеТипов("СправочникСсылка.Пользователи");
	Элементы.ДеревоТребованийОсновноеЗначение.ОграничениеТипа = ?(ЭтоУсловие, ТипСтрока, ТипПользователи);

КонецПроцедуры

&НаСервере
Процедура ПриВключенииВозможностиИзмененияНаСервере()
	
	УстановитьВидимостьЭлементов();
	УсловноеОформление.Элементы.Очистить();
	МаршрутыПодписанияБЭД.УстановитьУсловноеОформлениеДереваМаршрута(ЭтотОбъект,, 
		ЗначениеЗаполнено(Объект.КлючАвтоматическойНастройки));

КонецПроцедуры

&НаКлиенте
Процедура ВидПодписиПриИзменении(Элемент)
	Элементы.ДеревоТребованийСертификат.Видимость = Объект.ВидПодписи <> ПредопределенноеЗначение(
		"Перечисление.ВидыЭлектронныхПодписей.Простая");
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область Инициализация

РазрешитьДобавлениеНовойСтроки = Ложь;

#КонецОбласти











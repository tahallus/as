﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает данные отправленной рассылки сервиса из объекта.
// 
// Возвращаемое значение:
//  Структура - См. МассовыеРассылкиИнтеграция.НовыйДанныеРассылки() - Данные рассылки.
//
Функция ДанныеРассылкиСервиса() Экспорт
	
	ДанныеРассылки = МассовыеРассылкиИнтеграция.НовыйДанныеРассылки();
	ДанныеРассылки.ТемаПисьма                 = Тема;
	ДанныеРассылки.Сервис                     = СервисМассовойРассылки;
	ДанныеРассылки.Отправитель                = СервисРассылкиАдресОтправителя;
	ДанныеРассылки.ИмяОтправителя             = СервисРассылкиИмяОтправителя;
	ДанныеРассылки.Идентификатор              = СервисРассылкиИдентификатор;
	ДанныеРассылки.ИдентификаторШаблона       = СервисРассылкиИдентификаторШаблона;
	ДанныеРассылки.ИдентификаторАдреснойКниги = СервисРассылкиИдентификаторАдреснойКниги;
	ДанныеРассылки.Наименование               = СервисРассылкиИмяКампании;
	Если ДанныеРассылки.Свойство("ИдентификаторПисьмаОснования") Тогда
		ДанныеРассылки.ИдентификаторПисьмаОснования = СервисРассылкиИдентификаторПисьмаОснования;
	КонецЕсли;
	Если ЗначениеЗаполнено(СервисРассылкиПланируемаяДатаОтправки) Тогда
		ДанныеРассылки.ПлановаяДатаОтправки = СервисРассылкиПланируемаяДатаОтправки;
	КонецЕсли;
	ДанныеРассылки.КоличествоПолучателейПлан = Получатели.Количество();
	
	Для каждого Получатель Из Получатели Цикл
		НоваяСтрока = ДанныеРассылки.Получатели.Добавить();
		НоваяСтрока.Контакт = Получатель.Контакт;
		НоваяСтрока.Email = Получатель.КакСвязаться;
	КонецЦикла;
	
	Для каждого Вложение Из ВложенияРассылки() Цикл
		ДанныеРассылки.Вложения.Вставить(Вложение.Представление, Вложение.АдресВоВременномХранилище);
	КонецЦикла;
	
	МассовыеРассылкиИнтеграция.ИнициализироватьДанныеРассылки(ДанныеРассылки);
	
	Возврат ДанныеРассылки;
	
КонецФункции

// Заполняет объект статическими данными рассылки сервиса, которые необходимо хранить в информационной базе.
//
// Параметры:
//  ДанныеРассылки - Структура - См. МассовыеРассылкиИнтеграция.НовыйДанныеРассылки().
//
Процедура ЗаполнитьДаннымиРассылкиСервиса(ДанныеРассылки) Экспорт
	
	Тема                                       = ДанныеРассылки.ТемаПисьма;
	СервисМассовойРассылки                     = ДанныеРассылки.Сервис;
	СервисРассылкиАдресОтправителя             = ДанныеРассылки.Отправитель;
	СервисРассылкиИмяОтправителя               = ДанныеРассылки.ИмяОтправителя;
	СервисРассылкиИдентификатор                = ДанныеРассылки.Идентификатор;
	СервисРассылкиИдентификаторШаблона         = ДанныеРассылки.ИдентификаторШаблона;
	СервисРассылкиИдентификаторАдреснойКниги   = ДанныеРассылки.ИдентификаторАдреснойКниги;
	СервисРассылкиИмяКампании                  = ДанныеРассылки.Наименование;
	СервисРассылкиПланируемаяДатаОтправки      = ДанныеРассылки.ПлановаяДатаОтправки;
	Если ДанныеРассылки.Свойство("ИдентификаторПисьмаОснования") Тогда
		СервисРассылкиИдентификаторПисьмаОснования = ДанныеРассылки.ИдентификаторПисьмаОснования;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	ДатаРассылки = Неопределено;
	СервисРассылкиИдентификатор = Неопределено;
	СервисРассылкиИдентификаторПисьмаОснования = Неопределено;
	СервисРассылкиИмяНовойАдреснойКниги = Неопределено;
	СервисРассылкиПланируемаяДатаОтправки = Неопределено;
	
	Если ЭтоРассылкаСервиса() Тогда
		Получатели.Очистить();
	КонецЕсли;
	
	Состояние = Перечисления.СостоянияОтправкиРассылки.Черновик;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если СпособОтправки = Перечисления.ВидыКаналовСвязи.SMS Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("УчетнаяЗапись"));
	КонецЕсли;
	
	Если СпособОтправки = Перечисления.ВидыКаналовСвязи.Email Тогда
		ПроверитьЗаполненияЭлектронныхАдресов(Отказ);
	КонецЕсли;
	
	Если ЭтоРассылкаСервиса() Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Получатели.Контакт"));
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("УчетнаяЗапись"));
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.НачислениеСписаниеБонусныхБаллов")] = "ЗаполнитьПоНачислениюСписаниюБонусов";
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("СоздаватьСобытия")
		И ДополнительныеСвойства.СоздаватьСобытия
		И СоздаватьСобытия Тогда
		СоздатьПодчиненныеСобытияМассовойРассылкиСервиса();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПометкаУдаления И Не ЭтоРассылкаСервиса() Тогда
		ОбнулитьКоличествоПопытокВОчередиРассылки();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыЗаполненияДокументов

Процедура ЗаполнитьПоНачислениюСписаниюБонусов(НачислениеСписаниеСсылка) Экспорт
	
	СпособОтправки = Перечисления.ВидыКаналовСвязи.SMS;
	
	Контрагенты = Новый Массив;
	ТипыКИ = Новый СписокЗначений;
	ТипыКИ.Добавить(Перечисления.ТипыКонтактнойИнформации.Телефон);
	
	Для Каждого СтрокаНачисления Из НачислениеСписаниеСсылка.НачисленияБонусов Цикл
		Если ЗначениеЗаполнено(СтрокаНачисления.БонуснаяКарта.ВладелецКарты) Тогда
			Контрагенты.Добавить(СтрокаНачисления.БонуснаяКарта.ВладелецКарты);
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КонтрагентыКонтактнаяИнформация.Ссылка КАК Ссылка,
	|	КонтрагентыКонтактнаяИнформация.Вид КАК Вид,
	|	КонтрагентыКонтактнаяИнформация.Представление КАК Представление,
	|	ВЫБОР
	|		КОГДА КонтрагентыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
	|			ТОГДА 0
	|		КОГДА КонтрагентыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон)
	|			ТОГДА 3
	|		КОГДА КонтрагентыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес)
	|			ТОГДА 0
	|	КОНЕЦ КАК ИндексКартинки,
	|	КонтрагентыКонтактнаяИнформация.Вид.РеквизитДопУпорядочивания КАК Порядок
	|ПОМЕСТИТЬ втКИКонтрагентов
	|ИЗ
	|	Справочник.Контрагенты.КонтактнаяИнформация КАК КонтрагентыКонтактнаяИнформация
	|ГДЕ
	|	КонтрагентыКонтактнаяИнформация.Ссылка В ИЕРАРХИИ(&Контрагенты)
	|	И КонтрагентыКонтактнаяИнформация.Тип В(&ТипыКИ)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Контрагенты.Ссылка КАК Контрагент,
	|	Контрагенты.Представление КАК КонтрагентПредставление,
	|	Контрагенты.КонтактноеЛицо КАК ОсновноеКонтактноеЛицо,
	|	ЕСТЬNULL(втКИКонтрагентов.Вид, НЕОПРЕДЕЛЕНО) КАК ВидКИ,
	|	ЕСТЬNULL(втКИКонтрагентов.Представление, """""""") КАК ЗначениеКИ,
	|	втКИКонтрагентов.ИндексКартинки КАК ИндексКартинки,
	|	Контрагенты.ДатаСоздания КАК ДатаСоздания
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|		ЛЕВОЕ СОЕДИНЕНИЕ втКИКонтрагентов КАК втКИКонтрагентов
	|		ПО Контрагенты.Ссылка = втКИКонтрагентов.Ссылка
	|ГДЕ
	|	Контрагенты.Ссылка В ИЕРАРХИИ(&Контрагенты)
	|	И Контрагенты.ЭтоГруппа = ЛОЖЬ
	|
	|УПОРЯДОЧИТЬ ПО
	|	КонтрагентПредставление,
	|	втКИКонтрагентов.Порядок";
	Запрос.УстановитьПараметр("Контрагенты", Контрагенты);
	Запрос.УстановитьПараметр("ТипыКИ", ТипыКИ);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Получатели.Добавить();
		НоваяСтрока.Контакт = Выборка.Контрагент;
		НоваяСтрока.КакСвязаться = Выборка.ЗначениеКИ;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭтоРассылкаСервиса()
	
	Возврат ЗначениеЗаполнено(СервисМассовойРассылки);
	
КонецФункции

Процедура ПроверитьЗаполненияЭлектронныхАдресов(Отказ)
	
	Для Индекс = 0 По Получатели.Количество() - 1 Цикл
		
		Если ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(
			Получатели[Индекс].КакСвязаться,
			Истина) Тогда
			Продолжить;
		КонецЕсли;
		
		ТекстСообщенияПользователю = СтрШаблон(
		НСтр("ru = 'Некорректный адрес электронной почты ""%1""'"),
		Получатели[Индекс].КакСвязаться);
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщенияПользователю,,
		СтрШаблон("Объект.Получатели[%1].КакСвязаться", Формат(Индекс, "ЧН=; ЧГ=")),,
		Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбнулитьКоличествоПопытокВОчередиРассылки()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого ТекСтрокаПолучатели Из Получатели Цикл
		
		РегистрыСведений.ОчередьРассылок.Зарегистрировать(
		Ссылка,
		ТекСтрокаПолучатели.КакСвязаться,
		СпособОтправки,
		ИнтервалМеждуПопытками,
		0);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СоздатьПодчиненныеСобытияМассовойРассылкиСервиса()
	
	ДатаОтправки = ТекущаяДатаСеанса();
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Дата", ДатаОтправки);
	ЗначенияЗаполнения.Вставить("НачалоСобытия", ДатаОтправки);
	ЗначенияЗаполнения.Вставить("ОкончаниеСобытия", ДатаОтправки);
	ЗначенияЗаполнения.Вставить("ТипСобытия", Перечисления.ТипыСобытий.ЭлектронноеПисьмо);
	ЗначенияЗаполнения.Вставить("Состояние", Справочники.СостоянияСобытий.Завершено);
	ЗначенияЗаполнения.Вставить("Важность", Перечисления.ВариантыВажности.Обычная);
	ЗначенияЗаполнения.Вставить("Тема", Тема);
	ЗначенияЗаполнения.Вставить("Ответственный", Ответственный);
	ЗначенияЗаполнения.Вставить("Автор", Автор);
	ЗначенияЗаполнения.Вставить("ИсточникПривлечения", ИсточникПривлечения);
	
	Для каждого Получатель Из Получатели Цикл
		Если Не ЗначениеЗаполнено(Получатель.Контакт) Тогда
			Продолжить;
		КонецЕсли;
		Если Не ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Получатель.Контакт)) Тогда
			Продолжить;
		КонецЕсли;
		НовоеСобытие = Документы.Событие.СоздатьДокумент();
		НовоеСобытие.Заполнить(ЗначенияЗаполнения);
		НовоеСобытие.УстановитьНовыйНомер();
		
		СтрокаОснования = НовоеСобытие.ДокументыОснования.Добавить();
		СтрокаОснования.ДокументОснование = Ссылка;
		
		СтрокаУчастники = НовоеСобытие.Участники.Добавить();
		СтрокаУчастники.Контакт = Получатель.Контакт;
		СтрокаУчастники.КакСвязаться = Получатель.КакСвязаться;
		
		НовоеСобытие.Записать();
	КонецЦикла;
	
КонецПроцедуры

Функция ВложенияРассылки()
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МассоваяРассылкаПрисоединенныеФайлы.Ссылка,
	|	МассоваяРассылкаПрисоединенныеФайлы.Наименование,
	|	МассоваяРассылкаПрисоединенныеФайлы.Расширение,
	|	МассоваяРассылкаПрисоединенныеФайлы.ИндексКартинки
	|ИЗ
	|	Справочник.МассоваяРассылкаПрисоединенныеФайлы КАК МассоваяРассылкаПрисоединенныеФайлы
	|ГДЕ
	|	МассоваяРассылкаПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла
	|	И МассоваяРассылкаПрисоединенныеФайлы.ПометкаУдаления = ЛОЖЬ");
	Запрос.УстановитьПараметр("ВладелецФайла", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Результат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ПредставлениеВложения = Выборка.Наименование;
		Если ЗначениеЗаполнено(Выборка.Расширение) Тогда
			ПредставлениеВложения = ПредставлениеВложения + "." + Выборка.Расширение;
		КонецЕсли;
		
		ОписаниеВложения = Новый Структура;
		ОписаниеВложения.Вставить("Ссылка", Выборка.Ссылка);
		ОписаниеВложения.Вставить("Представление", ПредставлениеВложения);
		ОписаниеВложения.Вставить("ИндексКартинки", Выборка.ИндексКартинки);
		ОписаниеВложения.Вставить("Данные", РаботаСФайлами.ДвоичныеДанныеФайла(Выборка.Ссылка));
		ОписаниеВложения.Вставить("АдресВоВременномХранилище", ПоместитьВоВременноеХранилище(ОписаниеВложения.Данные, Новый УникальныйИдентификатор));
		
		Результат.Добавить(ОписаниеВложения);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
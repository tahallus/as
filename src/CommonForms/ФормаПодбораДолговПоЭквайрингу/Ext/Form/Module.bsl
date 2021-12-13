﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Период = Параметры.Дата;
	Компания = Параметры.Компания;
	Контрагент = Параметры.Контрагент;
	ВалютаДенежныхСредств = Параметры.ВалютаДенежныхСредств;
	Ссылка = Параметры.Ссылка;
	ВидОперации = Параметры.ВидОперации;
	СуммаДокумента = Параметры.СуммаДокумента;
	БанковскийСчет = Параметры.БанковскийСчет;
	
	Если Параметры.Свойство("ЭквайринговыйТерминал") Тогда
		ЭквайринговыйТерминал = Параметры.ЭквайринговыйТерминал;
		Элементы.СписокДолговЭквайринговыйТерминал.Видимость = Ложь;
		Элементы.ОтобранныеДолгиЭквайринговыйТерминал.Видимость = Ложь;
	КонецЕсли; 
	
	ВалютаУчета = Константы.ВалютаУчета.Получить();
	УчетВалютныхОпераций = Константы.ФункциональнаяУчетВалютныхОпераций.Получить();
	
	АдресЭквайринговыеОперацииВХранилище = Параметры.АдресЭквайринговыеОперацииВХранилище;
	ОтобранныеДолги.Загрузить(ПолучитьИзВременногоХранилища(АдресЭквайринговыеОперацииВХранилище));
	
	// Удаление строк с незаполненной суммой.
	МассивСтрокДляУдаления = Новый Массив;
	Для каждого ТекСтрока Из ОтобранныеДолги Цикл
		Если ТекСтрока.СуммаРасчетов = 0 И ТекСтрока.СуммаРасчетовВозврата = 0 Тогда
			МассивСтрокДляУдаления.Добавить(ТекСтрока);
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ТекЭлемент Из МассивСтрокДляУдаления Цикл
		ОтобранныеДолги.Удалить(ТекЭлемент);
	КонецЦикла;
	
	ФункциональнаяУчетВалютныхОпераций = Константы.ФункциональнаяУчетВалютныхОпераций.Получить();
	Элементы.СписокДолговКурс.Видимость = ФункциональнаяУчетВалютныхОпераций;
	Элементы.СписокДолговКратность.Видимость = ФункциональнаяУчетВалютныхОпераций;
	
	Элементы.Итоги.Видимость = НЕ УчетВалютныхОпераций;
	
	ЗаполнитьДолги();
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РассчитатьСуммаИтог();
	
КонецПроцедуры // ПриОткрытии()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОтобранныеДолги

// Процедура - обработчик события ПередНачаломДобавления списка ОтобранныеДолги.
//
&НаКлиенте
Процедура ОтобранныеДолгиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры // ОтобранныеДолгиПередНачаломДобавления()

// Процедура - обработчик события ПроверкаПеретаскивания списка ОтобранныеДолги.
//
&НаКлиенте
Процедура ОтобранныеДолгиПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Копирование;
	
КонецПроцедуры // ОтобранныеДолгиПроверкаПеретаскивания()

// Процедура - обработчик события ПроверкаПеретаскивания списка ОтобранныеДолги.
//
&НаКлиенте
Процедура ОтобранныеДолгиПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	МассивИдентификаторов = ПараметрыПеретаскивания.Значение;
	Для Каждого ТекущиеДанные Из МассивИдентификаторов Цикл
		СтруктураПоиска = Новый Структура("Документ, Заказ, ДатаПлатежа, ВидПлатежнойКарты, НомерПлатежнойКарты, ВидОперацииЭквайринга", 
			ТекущиеДанные.Документ, ТекущиеДанные.Заказ, ТекущиеДанные.ДатаПлатежа, ТекущиеДанные.ВидПлатежнойКарты, ТекущиеДанные.НомерПлатежнойКарты, ТекущиеДанные.ВидОперацииЭквайринга);
		Строки = ОтобранныеДолги.НайтиСтроки(СтруктураПоиска);
		
		Если Строки.Количество() > 0 Тогда
			НоваяСтрока = Строки[0];
			НоваяСтрока.СуммаРасчетов = НоваяСтрока.СуммаРасчетов + ТекущиеДанные.СуммаРасчетов;
			НоваяСтрока.СуммаРасчетовВозврата = НоваяСтрока.СуммаРасчетовВозврата + ТекущиеДанные.СуммаРасчетовВозврата;
			НоваяСтрока.СуммаРасчетовКомиссии = НоваяСтрока.СуммаРасчетовКомиссии + ТекущиеДанные.СуммаРасчетовКомиссии;
			НоваяСтрока.СуммаРасчетовКомиссииВозврата = НоваяСтрока.СуммаРасчетовКомиссииВозврата + ТекущиеДанные.СуммаРасчетовКомиссииВозврата;
		Иначе
			НоваяСтрока = ОтобранныеДолги.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущиеДанные);
		КонецЕсли;
		
		СписокДолгов.Удалить(ТекущиеДанные);
	КонецЦикла;
	
	Если МассивИдентификаторов.Количество() <> 0 Тогда
		Элементы.ОтобранныеДолги.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	КонецЕсли;
	
	РассчитатьСуммаИтог();
	ЗаполнитьДолги();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении списка ОтобранныеДолги.
//
&НаКлиенте
Процедура ОтобранныеДолгиПриИзменении(Элемент)
	
	РассчитатьСуммаИтог();
	ЗаполнитьДолги();
	
КонецПроцедуры // ОтобранныеДолгиПриИзменении()

// Процедура - обработчик события ПриНачалеРедактирования списка ОтобранныеДолги.
//
&НаКлиенте
Процедура ОтобранныеДолгиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Копирование Тогда
		РассчитатьСуммаИтог();
		ЗаполнитьДолги();
	КонецЕсли;
	
КонецПроцедуры // ОтобранныеАвансыПриНачалеРедактирования()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокДолгов

// Процедура помещает результаты выбора в подбор.
//
&НаКлиенте
Процедура СписокДолговВыборЗначения(Элемент, СтандартнаяОбработка, Значение)
	
	СтандартнаяОбработка = Ложь;
	ТекущаяСтрока = Элемент.ТекущиеДанные;
	
	СтруктураПоиска = Новый Структура("Документ, Заказ, ДатаПлатежа, ВидПлатежнойКарты, НомерПлатежнойКарты, ВидОперацииЭквайринга", 
		ТекущаяСтрока.Документ, ТекущаяСтрока.Заказ, ТекущаяСтрока.ДатаПлатежа, ТекущаяСтрока.ВидПлатежнойКарты, ТекущаяСтрока.НомерПлатежнойКарты, ТекущаяСтрока.ВидОперацииЭквайринга);
	Строки = ОтобранныеДолги.НайтиСтроки(СтруктураПоиска);
	
	Если Строки.Количество() > 0 Тогда
		НоваяСтрока = Строки[0];
		НоваяСтрока.СуммаРасчетов = НоваяСтрока.СуммаРасчетов + ТекущаяСтрока.СуммаРасчетов;
		НоваяСтрока.СуммаРасчетовВозврата = НоваяСтрока.СуммаРасчетовВозврата + ТекущаяСтрока.СуммаРасчетовВозврата;
		НоваяСтрока.СуммаРасчетовКомиссии = НоваяСтрока.СуммаРасчетовКомиссии + ТекущаяСтрока.СуммаРасчетовКомиссии;
		НоваяСтрока.СуммаРасчетовКомиссииВозврата = НоваяСтрока.СуммаРасчетовКомиссииВозврата + ТекущаяСтрока.СуммаРасчетовКомиссииВозврата;
	Иначе
		НоваяСтрока = ОтобранныеДолги.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
	КонецЕсли;
	
	СписокДолгов.Удалить(ТекущаяСтрока);
	
	Элементы.ОтобранныеДолги.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	
	РассчитатьСуммаИтог();
	ЗаполнитьДолги();

КонецПроцедуры

// Процедура - обработчик события НачалоПеретаскивания списка СписокДолгов.
//
&НаКлиенте
Процедура СписокДолговНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	ПараметрыПеретаскивания.Значение = ПараметрыПеретаскивания.Значение;
	ПараметрыПеретаскивания.ДопустимыеДействия = ДопустимыеДействияПеретаскивания.Копирование;
	
КонецПроцедуры // СписокДолговНачалоПеретаскивания()

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик нажатия кнопки ОК.
//
&НаКлиенте
Процедура ОК(Команда)
	
	ЗаписатьПодборВХранилище();
	Закрыть(КодВозвратаДиалога.OK);
	
КонецПроцедуры // ОК()

// Процедура - обработчик нажатия кнопки Обновить.
//
&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьДолги();
	
КонецПроцедуры // Обновить()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура рассчитывает итоговую сумму.
//
&НаКлиенте
Процедура РассчитатьСуммаИтог()
	
	СуммаИтог = 0;
	СуммаИтогКомиссия = 0;
	
	Для каждого ТекСтрока Из ОтобранныеДолги Цикл
		СуммаИтог = СуммаИтог + ТекСтрока.СуммаРасчетов;
		СуммаИтогКомиссия = СуммаИтогКомиссия + ТекСтрока.СуммаРасчетовКомиссии + ТекСтрока.СуммаРасчетовКомиссииВозврата;
	КонецЦикла;
	
КонецПроцедуры // РассчитатьСуммаИтог()

// Процедура помещает результаты подбора в хранилище.
//
&НаСервере
Процедура ЗаписатьПодборВХранилище()
	
	ТаблицаОтобранныеДолги = ОтобранныеДолги.Выгрузить();
	ПоместитьВоВременноеХранилище(ТаблицаОтобранныеДолги, АдресЭквайринговыеОперацииВХранилище);
	
КонецПроцедуры // ЗаписатьПодборВХранилище()

// Процедура заполняет список долгов.
//
&НаСервере
Процедура ЗаполнитьДолги()
	
	ТипДокумента = ТипЗнч(Ссылка);
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Организация", Компания);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Период", Период);
	Запрос.УстановитьПараметр("ПериодРасчетовДатаНачала", ПериодРасчетовДатаНачала);
	Запрос.УстановитьПараметр("ПериодРасчетовДатаОкончания", ПериодРасчетовДатаОкончания);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("ТаблицаОтобранныеДолги", ОтобранныеДолги.Выгрузить());
	Запрос.УстановитьПараметр("Валюта", ВалютаДенежныхСредств);
	Запрос.УстановитьПараметр("ЭквайринговыйТерминал", ЭквайринговыйТерминал);
	Запрос.УстановитьПараметр("ОперацияПоступления", Перечисления.ВидыОперацийЭквайринга.ПоступлениеОплатыОтПокупателя);
	Запрос.УстановитьПараметр("НалогообложениеНДС", Ссылка.НалогообложениеНДС);
	Запрос.УстановитьПараметр("УчитыватьВНУ", Ссылка.УчитыватьВНУ);
	
	Если ТипДокумента = Тип("ДокументСсылка.ПоступлениеНаСчет") Тогда
		Запрос.УстановитьПараметр("Патент", Ссылка.Патент);
	Иначе //РасходСоСчета 
		Запрос.УстановитьПараметр("Патент", Справочники.Патенты.ПустаяСсылка());
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыПоЭквайрингуОстатки.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	РасчетыПоЭквайрингуОстатки.Документ КАК Документ,
	|	РасчетыПоЭквайрингуОстатки.СуммаОстаток КАК СуммаОстаток,
	|	РасчетыПоЭквайрингуОстатки.СуммаВалОстаток КАК СуммаВалОстаток,
	|	РасчетыПоЭквайрингуОстатки.КомиссияОстаток КАК КомиссияОстаток,
	|	РасчетыПоЭквайрингуОстатки.КомиссияВалОстаток КАК КомиссияВалОстаток,
	|	РасчетыПоЭквайрингуОстатки.ВидОперацииЭквайринга КАК ВидОперацииЭквайринга,
	|	РасчетыПоЭквайрингуОстатки.ДатаПлатежа КАК ДатаПлатежа,
	|	РасчетыПоЭквайрингуОстатки.Заказ КАК Заказ,
	|	РасчетыПоЭквайрингуОстатки.ВидПлатежнойКарты КАК ВидПлатежнойКарты,
	|	РасчетыПоЭквайрингуОстатки.НомерПлатежнойКарты КАК НомерПлатежнойКарты
	|ПОМЕСТИТЬ ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента
	|ИЗ
	|	РегистрНакопления.РасчетыПоЭквайрингу.Остатки(
	|			,
	|			Организация = &Организация
	|				И ДатаПлатежа >= &ПериодРасчетовДатаНачала
	|				И (&ПериодРасчетовДатаОкончания = ДАТАВРЕМЯ(1, 1, 1)
	|					ИЛИ ДатаПлатежа <= &ПериодРасчетовДатаОкончания)
	|				И ЭквайринговыйТерминал.Эквайрер = &Контрагент
	|				И ЭквайринговыйТерминал = &ЭквайринговыйТерминал) КАК РасчетыПоЭквайрингуОстатки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РасчетыПоЭквайрингу.ЭквайринговыйТерминал,
	|	РасчетыПоЭквайрингу.Документ,
	|	ВЫБОР
	|		КОГДА РасчетыПоЭквайрингу.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА -ЕСТЬNULL(РасчетыПоЭквайрингу.Сумма, 0)
	|		ИНАЧЕ ЕСТЬNULL(РасчетыПоЭквайрингу.Сумма, 0)
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА РасчетыПоЭквайрингу.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА -ЕСТЬNULL(РасчетыПоЭквайрингу.СуммаВал, 0)
	|		ИНАЧЕ ЕСТЬNULL(РасчетыПоЭквайрингу.СуммаВал, 0)
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА РасчетыПоЭквайрингу.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА -ЕСТЬNULL(РасчетыПоЭквайрингу.Комиссия, 0)
	|		ИНАЧЕ ЕСТЬNULL(РасчетыПоЭквайрингу.Комиссия, 0)
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА РасчетыПоЭквайрингу.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА -ЕСТЬNULL(РасчетыПоЭквайрингу.КомиссияВал, 0)
	|		ИНАЧЕ ЕСТЬNULL(РасчетыПоЭквайрингу.КомиссияВал, 0)
	|	КОНЕЦ,
	|	РасчетыПоЭквайрингу.ВидОперацииЭквайринга,
	|	РасчетыПоЭквайрингу.ДатаПлатежа,
	|	РасчетыПоЭквайрингу.Заказ,
	|	РасчетыПоЭквайрингу.ВидПлатежнойКарты,
	|	РасчетыПоЭквайрингу.НомерПлатежнойКарты
	|ИЗ
	|	РегистрНакопления.РасчетыПоЭквайрингу КАК РасчетыПоЭквайрингу
	|ГДЕ
	|	РасчетыПоЭквайрингу.Регистратор = &Ссылка
	|	И РасчетыПоЭквайрингу.Организация = &Организация
	|	И РасчетыПоЭквайрингу.ДатаПлатежа >= &ПериодРасчетовДатаНачала
	|	И (&ПериодРасчетовДатаОкончания = ДАТАВРЕМЯ(1, 1, 1)
	|			ИЛИ РасчетыПоЭквайрингу.ДатаПлатежа <= &ПериодРасчетовДатаОкончания)
	|	И РасчетыПоЭквайрингу.ЭквайринговыйТерминал.Эквайрер = &Контрагент
	|	И РасчетыПоЭквайрингу.ЭквайринговыйТерминал = &ЭквайринговыйТерминал
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента.Документ КАК Документ,
	|	ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	СУММА(ВЫБОР
	|			КОГДА ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента.ВидОперацииЭквайринга = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийЭквайринга.ВозвратОплатыПокупателю)
	|				ТОГДА ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента.СуммаВалОстаток
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК СуммаРасчетовВозврата,
	|	СУММА(ВЫБОР
	|			КОГДА ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента.ВидОперацииЭквайринга = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийЭквайринга.ПоступлениеОплатыОтПокупателя)
	|				ТОГДА ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента.СуммаВалОстаток
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК СуммаРасчетов,
	|	СУММА(ВЫБОР
	|			КОГДА ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента.ВидОперацииЭквайринга = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийЭквайринга.ВозвратОплатыПокупателю)
	|				ТОГДА ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента.КомиссияВалОстаток
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК СуммаРасчетовКомиссииВозврата,
	|	СУММА(ВЫБОР
	|			КОГДА ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента.ВидОперацииЭквайринга = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийЭквайринга.ПоступлениеОплатыОтПокупателя)
	|				ТОГДА ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента.КомиссияВалОстаток
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК СуммаРасчетовКомиссии,
	|	ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента.ДатаПлатежа КАК ДатаПлатежа,
	|	ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента.ВидОперацииЭквайринга КАК ВидОперацииЭквайринга,
	|	ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента.Заказ КАК Заказ,
	|	ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента.ВидПлатежнойКарты КАК ВидПлатежнойКарты,
	|	ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента.НомерПлатежнойКарты КАК НомерПлатежнойКарты
	|ПОМЕСТИТЬ ВременнаяТаблицаРасчетыПоЭквайрингуОстатки
	|ИЗ
	|	ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента КАК ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента
	|
	|СГРУППИРОВАТЬ ПО
	|	ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента.Документ,
	|	ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента.ЭквайринговыйТерминал,
	|	ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента.ДатаПлатежа,
	|	ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента.ВидОперацииЭквайринга,
	|	ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента.Заказ,
	|	ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента.ВидПлатежнойКарты,
	|	ВременнаяТаблицаРасчетыПоЭквайрингуОстаткиМинусДвиженияДокумента.НомерПлатежнойКарты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОтобранныеДолги.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	ОтобранныеДолги.Документ КАК Документ,
	|	ОтобранныеДолги.СуммаРасчетовКомиссии КАК СуммаРасчетовКомиссии,
	|	ОтобранныеДолги.СуммаРасчетов КАК СуммаРасчетов,
	|	ОтобранныеДолги.СуммаРасчетовВозврата КАК СуммаРасчетовВозврата,
	|	ОтобранныеДолги.СуммаРасчетовКомиссииВозврата КАК СуммаРасчетовКомиссииВозврата,
	|	ОтобранныеДолги.ДатаПлатежа КАК ДатаПлатежа,
	|	ОтобранныеДолги.Заказ КАК Заказ,
	|	ОтобранныеДолги.ВидПлатежнойКарты КАК ВидПлатежнойКарты,
	|	ОтобранныеДолги.НомерПлатежнойКарты КАК НомерПлатежнойКарты,
	|	ОтобранныеДолги.ВидОперацииЭквайринга КАК ВидОперацииЭквайринга
	|ПОМЕСТИТЬ ТаблицаОтобранныеДолги
	|ИЗ
	|	&ТаблицаОтобранныеДолги КАК ОтобранныеДолги
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВременнаяТаблицаРасчетыПоЭквайрингуОстатки.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	ВременнаяТаблицаРасчетыПоЭквайрингуОстатки.Документ КАК Документ,
	|	ВЫБОР
	|		КОГДА ВременнаяТаблицаРасчетыПоЭквайрингуОстатки.ВидОперацииЭквайринга = &ОперацияПоступления
	|			ТОГДА ВременнаяТаблицаРасчетыПоЭквайрингуОстатки.СуммаРасчетов
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаРасчетов,
	|	ВЫБОР
	|		КОГДА ВременнаяТаблицаРасчетыПоЭквайрингуОстатки.ВидОперацииЭквайринга = &ОперацияПоступления
	|			ТОГДА ВременнаяТаблицаРасчетыПоЭквайрингуОстатки.СуммаРасчетовКомиссии
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаРасчетовКомиссии,
	|	ВременнаяТаблицаРасчетыПоЭквайрингуОстатки.ДатаПлатежа КАК ДатаПлатежа,
	|	ВЫБОР
	|		КОГДА ВременнаяТаблицаРасчетыПоЭквайрингуОстатки.ВидОперацииЭквайринга = &ОперацияПоступления
	|			ТОГДА 0
	|		ИНАЧЕ ВременнаяТаблицаРасчетыПоЭквайрингуОстатки.СуммаРасчетовВозврата
	|	КОНЕЦ КАК СуммаРасчетовВозврата,
	|	ВЫБОР
	|		КОГДА ВременнаяТаблицаРасчетыПоЭквайрингуОстатки.ВидОперацииЭквайринга = &ОперацияПоступления
	|			ТОГДА 0
	|		ИНАЧЕ ВременнаяТаблицаРасчетыПоЭквайрингуОстатки.СуммаРасчетовКомиссииВозврата
	|	КОНЕЦ КАК СуммаРасчетовКомиссииВозврата,
	|	ВременнаяТаблицаРасчетыПоЭквайрингуОстатки.Заказ КАК Заказ,
	|	ВременнаяТаблицаРасчетыПоЭквайрингуОстатки.ВидПлатежнойКарты КАК ВидПлатежнойКарты,
	|	ВременнаяТаблицаРасчетыПоЭквайрингуОстатки.НомерПлатежнойКарты КАК НомерПлатежнойКарты,
	|	ВременнаяТаблицаРасчетыПоЭквайрингуОстатки.ВидОперацииЭквайринга КАК ВидОперацииЭквайринга
	|ПОМЕСТИТЬ РасчетыПоЭквайрингуОстатки
	|ИЗ
	|	ВременнаяТаблицаРасчетыПоЭквайрингуОстатки КАК ВременнаяТаблицаРасчетыПоЭквайрингуОстатки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаОтобранныеДолги.ЭквайринговыйТерминал,
	|	ТаблицаОтобранныеДолги.Документ,
	|	СУММА(-ТаблицаОтобранныеДолги.СуммаРасчетов),
	|	СУММА(-ТаблицаОтобранныеДолги.СуммаРасчетовКомиссии),
	|	ТаблицаОтобранныеДолги.ДатаПлатежа,
	|	СУММА(-ТаблицаОтобранныеДолги.СуммаРасчетовВозврата),
	|	СУММА(-ТаблицаОтобранныеДолги.СуммаРасчетовКомиссииВозврата),
	|	ТаблицаОтобранныеДолги.Заказ,
	|	ТаблицаОтобранныеДолги.ВидПлатежнойКарты,
	|	ТаблицаОтобранныеДолги.НомерПлатежнойКарты,
	|	ТаблицаОтобранныеДолги.ВидОперацииЭквайринга
	|ИЗ
	|	ТаблицаОтобранныеДолги КАК ТаблицаОтобранныеДолги
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаОтобранныеДолги.ЭквайринговыйТерминал,
	|	ТаблицаОтобранныеДолги.Документ,
	|	ТаблицаОтобранныеДолги.ДатаПлатежа,
	|	ТаблицаОтобранныеДолги.Заказ,
	|	ТаблицаОтобранныеДолги.ВидПлатежнойКарты,
	|	ТаблицаОтобранныеДолги.НомерПлатежнойКарты,
	|	ТаблицаОтобранныеДолги.ВидОперацииЭквайринга
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыПоЭквайрингуОстатки.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	РасчетыПоЭквайрингуОстатки.Документ КАК Документ,
	|	СУММА(РасчетыПоЭквайрингуОстатки.СуммаРасчетов) КАК СуммаРасчетов,
	|	СУММА(РасчетыПоЭквайрингуОстатки.СуммаРасчетовКомиссии) КАК СуммаРасчетовКомиссии,
	|	КурсыВалютРасчетов.Курс КАК Курс,
	|	КурсыВалютРасчетов.Кратность КАК Кратность,
	|	РасчетыПоЭквайрингуОстатки.ДатаПлатежа КАК ДатаПлатежа,
	|	СУММА(РасчетыПоЭквайрингуОстатки.СуммаРасчетовВозврата) КАК СуммаРасчетовВозврата,
	|	СУММА(РасчетыПоЭквайрингуОстатки.СуммаРасчетовКомиссииВозврата) КАК СуммаРасчетовКомиссииВозврата,
	|	РасчетыПоЭквайрингуОстатки.Заказ КАК Заказ,
	|	РасчетыПоЭквайрингуОстатки.ВидПлатежнойКарты КАК ВидПлатежнойКарты,
	|	РасчетыПоЭквайрингуОстатки.НомерПлатежнойКарты КАК НомерПлатежнойКарты,
	|	РасчетыПоЭквайрингуОстатки.ВидОперацииЭквайринга КАК ВидОперацииЭквайринга,
	|	ВЫБОР
	|		КОГДА РасчетыПоЭквайрингуОстатки.ЭквайринговыйТерминал.СобственныеНастройкиНалоговогоУчета
	|			ТОГДА РасчетыПоЭквайрингуОстатки.ЭквайринговыйТерминал.НалогообложениеНДС
	|		ИНАЧЕ &НалогообложениеНДС
	|	КОНЕЦ КАК НалогообложениеНДС,
	|	ВЫБОР
	|		КОГДА РасчетыПоЭквайрингуОстатки.ЭквайринговыйТерминал.СобственныеНастройкиНалоговогоУчета
	|			ТОГДА РасчетыПоЭквайрингуОстатки.ЭквайринговыйТерминал.УчитыватьВНУ
	|		ИНАЧЕ &УчитыватьВНУ
	|	КОНЕЦ КАК УчитыватьВНУ,
	|	ВЫБОР
	|		КОГДА РасчетыПоЭквайрингуОстатки.ЭквайринговыйТерминал.СобственныеНастройкиНалоговогоУчета
	|			ТОГДА РасчетыПоЭквайрингуОстатки.ЭквайринговыйТерминал.Патент
	|		ИНАЧЕ &Патент
	|	КОНЕЦ КАК Патент
	|ИЗ
	|	РасчетыПоЭквайрингуОстатки КАК РасчетыПоЭквайрингуОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Период, ) КАК КурсыВалютРасчетов
	|		ПО (&Валюта = КурсыВалютРасчетов.Валюта)
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыПоЭквайрингуОстатки.ЭквайринговыйТерминал,
	|	РасчетыПоЭквайрингуОстатки.Документ,
	|	КурсыВалютРасчетов.Курс,
	|	КурсыВалютРасчетов.Кратность,
	|	РасчетыПоЭквайрингуОстатки.ДатаПлатежа,
	|	РасчетыПоЭквайрингуОстатки.Заказ,
	|	РасчетыПоЭквайрингуОстатки.ВидПлатежнойКарты,
	|	РасчетыПоЭквайрингуОстатки.НомерПлатежнойКарты,
	|	РасчетыПоЭквайрингуОстатки.ВидОперацииЭквайринга,
	|	ВЫБОР
	|		КОГДА РасчетыПоЭквайрингуОстатки.ЭквайринговыйТерминал.СобственныеНастройкиНалоговогоУчета
	|			ТОГДА РасчетыПоЭквайрингуОстатки.ЭквайринговыйТерминал.НалогообложениеНДС
	|		ИНАЧЕ &НалогообложениеНДС
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА РасчетыПоЭквайрингуОстатки.ЭквайринговыйТерминал.СобственныеНастройкиНалоговогоУчета
	|			ТОГДА РасчетыПоЭквайрингуОстатки.ЭквайринговыйТерминал.УчитыватьВНУ
	|		ИНАЧЕ &УчитыватьВНУ
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА РасчетыПоЭквайрингуОстатки.ЭквайринговыйТерминал.СобственныеНастройкиНалоговогоУчета
	|			ТОГДА РасчетыПоЭквайрингуОстатки.ЭквайринговыйТерминал.Патент
	|		ИНАЧЕ &Патент
	|	КОНЕЦ
	|
	|ИМЕЮЩИЕ
	|	(СУММА(РасчетыПоЭквайрингуОстатки.СуммаРасчетов) > 0
	|		ИЛИ СУММА(РасчетыПоЭквайрингуОстатки.СуммаРасчетовВозврата) > 0)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Документ
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	// Если Терминал не заполнен, значит подбор был вызван из документа, в котором Терминал указывается в ТЧ
	Если НЕ ЗначениеЗаполнено(ЭквайринговыйТерминал) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И ЭквайринговыйТерминал = &ЭквайринговыйТерминал", "И ЭквайринговыйТерминал.БанковскийСчетЭквайринг = &БанковскийСчетЭквайринг");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И РасчетыПоЭквайрингу.ЭквайринговыйТерминал = &ЭквайринговыйТерминал", "И РасчетыПоЭквайрингу.ЭквайринговыйТерминал.БанковскийСчетЭквайринг = &БанковскийСчетЭквайринг");
		Запрос.УстановитьПараметр("БанковскийСчетЭквайринг", БанковскийСчет);
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	СписокДолгов.Загрузить(РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // ЗаполнитьДолги()

#КонецОбласти




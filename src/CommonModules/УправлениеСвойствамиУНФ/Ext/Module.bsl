#Область ПрограммныйИнтерфейс

// Заполняет дополнительные параметры
// 
// Параметры:
// 	Объект - Произвольный
// 	ИмяЭлементаДляРазмещения - Строка
// 	ПроизвольныйОбъект - Объект
// 	ИмяЭлементаКоманднойПанели - Строка
// 	СкрытьУдаленные - Булево
// Возвращаемое значение:
// 	см. УправлениеСвойствами.ПриСозданииНаСервере.ДополнительныеПараметры
Функция ЗаполнитьДополнительныеПараметры(Объект, ИмяЭлементаДляРазмещения, ПроизвольныйОбъект = Неопределено,
	ИмяЭлементаКоманднойПанели = Неопределено, СкрытьУдаленные = Неопределено) Экспорт

	ДополнительныеПараметры = Новый Структура;

	Если Объект <> Неопределено Тогда

		ДополнительныеПараметры.Вставить("Объект", Объект);

	КонецЕсли;

	Если ИмяЭлементаДляРазмещения <> Неопределено Тогда

		ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", ИмяЭлементаДляРазмещения);

	КонецЕсли;

	Если ПроизвольныйОбъект <> Неопределено Тогда

		ДополнительныеПараметры.Вставить("ПроизвольныйОбъект", ПроизвольныйОбъект);

	КонецЕсли;

	Если ИмяЭлементаКоманднойПанели <> Неопределено Тогда

		ДополнительныеПараметры.Вставить("ИмяЭлементаКоманднойПанели", ИмяЭлементаКоманднойПанели);

	КонецЕсли;

	Если СкрытьУдаленные <> Неопределено Тогда

		ДополнительныеПараметры.Вставить("СкрытьУдаленные", СкрытьУдаленные);

	КонецЕсли;

	Возврат ДополнительныеПараметры;

КонецФункции

// Заполняет таблицу свойств характеристик при открытии формы.
//
// Параметры:
//  Форма - Форма объекта с таблицей свойств,
//  Объект - Объект формы с таблицей свойств,
//  ВладелецСвойств - Ссылка на владельца свойств,
//  ЗаполнитьОписаниеЗависимостей - Признак заполнения описания зависимостей.
//
Процедура ТаблицаСвойствПриСозданииНаСервере(Форма, Объект = Неопределено, ВладелецСвойств = Неопределено,
	ЗаполнитьОписаниеЗависимостей = Истина) Экспорт

	Реквизиты = Новый Массив;
	
	// Проверка значения функциональной опции "Использование свойств".
	ОпцияИспользоватьСвойства = Форма.ПолучитьФункциональнуюОпциюФормы("ИспользоватьДополнительныеРеквизитыИСведения");
	РеквизитИспользоватьСвойства = Новый РеквизитФормы("Свойства_ИспользоватьСвойства", Новый ОписаниеТипов("Булево"));
	Реквизиты.Добавить(РеквизитИспользоватьСвойства);

	Если ОпцияИспользоватьСвойства Тогда
		
		// Добавление реквизита содержащего используемые наборы дополнительных реквизитов.
		Реквизиты.Добавить(Новый РеквизитФормы("Свойства_НаборыДополнительныхРеквизитовОбъекта",
			Новый ОписаниеТипов("СписокЗначений")));
		
		// Добавление реквизита описания зависимых реквизитов.
		ТаблицаЗависимыхРеквизитов = "Свойства_ОписаниеЗависимыхДополнительныхРеквизитов";

		Реквизиты.Добавить(Новый РеквизитФормы(ТаблицаЗависимыхРеквизитов, Новый ОписаниеТипов("ТаблицаЗначений")));

		Реквизиты.Добавить(Новый РеквизитФормы("ИмяРеквизитаЗначение", Новый ОписаниеТипов("Строка"),
			ТаблицаЗависимыхРеквизитов));

		Реквизиты.Добавить(Новый РеквизитФормы("Свойство",
			Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения"),
			ТаблицаЗависимыхРеквизитов));

		Реквизиты.Добавить(Новый РеквизитФормы("Доступен", Новый ОписаниеТипов("Булево"), ТаблицаЗависимыхРеквизитов));

		Реквизиты.Добавить(Новый РеквизитФормы("УсловиеДоступности", Новый ОписаниеТипов, ТаблицаЗависимыхРеквизитов));

		Реквизиты.Добавить(Новый РеквизитФормы("Виден", Новый ОписаниеТипов("Булево"), ТаблицаЗависимыхРеквизитов));

		Реквизиты.Добавить(Новый РеквизитФормы("УсловиеВидимости", Новый ОписаниеТипов, ТаблицаЗависимыхРеквизитов));

		Реквизиты.Добавить(Новый РеквизитФормы("ЗаполнятьОбязательно", Новый ОписаниеТипов("Булево"),
			ТаблицаЗависимыхРеквизитов));

		Реквизиты.Добавить(Новый РеквизитФормы("УсловиеОбязательностиЗаполнения", Новый ОписаниеТипов,
			ТаблицаЗависимыхРеквизитов));
		
		// Добавление команды формы, если установлена роль "ДобавлениеИзменениеДополнительныхРеквизитовИСведений" или это
		// полноправный пользователь.
		Если Пользователи.РолиДоступны("ДобавлениеИзменениеДополнительныхРеквизитовИСведений") Тогда
			// Добавление команды.
			Команда = Форма.Команды.Добавить("РедактироватьСоставДополнительныхРеквизитов");
			Команда.Заголовок = НСтр("ru = 'Изменить состав дополнительных реквизитов'");
			Команда.Действие = "Подключаемый_РедактироватьСоставСвойств";
			Команда.Подсказка = НСтр("ru = 'Изменить состав дополнительных реквизитов'");
			Команда.Картинка = БиблиотекаКартинок.НастройкаСписка;

			Кнопка = Форма.Элементы.Добавить("РедактироватьСоставДополнительныхРеквизитов", Тип("КнопкаФормы"),
				Форма.КоманднаяПанель);

			Кнопка.ТолькоВоВсехДействиях = Истина;
			Кнопка.ИмяКоманды = "РедактироватьСоставДополнительныхРеквизитов";
		КонецЕсли;

	КонецЕсли;

	Форма.ИзменитьРеквизиты(Реквизиты);

	Форма.Свойства_ИспользоватьСвойства = ОпцияИспользоватьСвойства;

	ЗаполнитьДополнительныеРеквизитыВФорме(Форма, Объект, ВладелецСвойств, ЗаполнитьОписаниеЗависимостей);

КонецПроцедуры

// Таблица свойств обработка проверки заполнения на сервере
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения
// 	Объект - Произвольный
// 	Отказ - Булево
Процедура ТаблицаСвойствОбработкаПроверкиЗаполненияНаСервере(Форма, Объект, Отказ) Экспорт

	ПараметрыСеанса.ИнтерактивнаяПроверкаЗаполненияСвойств = Истина;

	Ошибки = Неопределено;

	Итератор = 0;
	Для Каждого Строка Из Форма.Свойства_ТаблицаСвойстваИЗначения Цикл

		Если Строка.ЗаполнятьОбязательно Тогда

			Результат = Истина;

			Если Объект = Неопределено Тогда
				//@skip-warning
				ОписаниеОбъекта = Форма.Объект;
			Иначе
				ОписаниеОбъекта = Объект;
			КонецЕсли;

			Для Каждого ЗависимыйРеквизит Из Форма.Свойства_ОписаниеЗависимыхДополнительныхРеквизитов Цикл

				Если ЗависимыйРеквизит.Свойство = Строка.Свойство И ЗависимыйРеквизит.УсловиеОбязательностиЗаполнения
					<> Неопределено Тогда
					
					//@skip-warning
					ЗначенияПараметров = ЗависимыйРеквизит.УсловиеОбязательностиЗаполнения.ЗначенияПараметров;
					КодУсловия         = ЗависимыйРеквизит.УсловиеОбязательностиЗаполнения.КодУсловия;
					ОбщегоНазначения.ВыполнитьВБезопасномРежиме("Результат = (" + КодУсловия + ")");
					Прервать;
				КонецЕсли;

			КонецЦикла;

			Если Не Результат Тогда
				Продолжить;
			КонецЕсли;

			Если Не ЗначениеЗаполнено(Строка.Значение) Тогда

				ТекстОшибки = СтрШаблон(НСтр("ru = 'Поле ""%1"" не заполнено.'"), Строка.Наименование);
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
					Форма.Свойства_ТаблицаСвойстваИЗначения[Итератор].Значение, ТекстОшибки, "");
			КонецЕсли;

		КонецЕсли;

	КонецЦикла;

	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);

КонецПроцедуры

// Таблица свойств перед записью на сервере
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения
// 	Объект - Произвольный
Процедура ТаблицаСвойствПередЗаписьюНаСервере(Форма, Объект) Экспорт

	Объект.ДополнительныеРеквизиты.Очистить();

	Для Каждого Стр Из Форма.Свойства_ТаблицаСвойстваИЗначения Цикл

		Если Не ЗначениеЗаполнено(Стр.Значение) Тогда
			Продолжить;
		КонецЕсли;

		НоваяСтрока = Объект.ДополнительныеРеквизиты.Добавить();
		НоваяСтрока.Свойство = Стр.Свойство;
		НоваяСтрока.Значение = Стр.Значение;

	КонецЦикла;

КонецПроцедуры

// Заполнить дополнительные реквизиты в форме
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения
// 	Объект - Произвольный
// 	ВладелецСвойств - ЛюбаяСсылка
// 	ЗаполнитьОписаниеЗависимостей - Булево
Процедура ЗаполнитьДополнительныеРеквизитыВФорме(Форма, Объект = Неопределено, ВладелецСвойств = Неопределено,
	ЗаполнитьОписаниеЗависимостей = Истина) Экспорт

	Если Не Форма.Свойства_ИспользоватьСвойства Тогда
		Возврат;
	КонецЕсли;

	Если Объект = Неопределено Тогда
		ОписаниеОбъекта = Форма.Объект;
	Иначе
		ОписаниеОбъекта = Объект;
	КонецЕсли;

	Форма.Свойства_НаборыДополнительныхРеквизитовОбъекта = Новый СписокЗначений;

	Если ОписаниеОбъекта = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка() Тогда

		ОписаниеОбъектаПустаяСсылка = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
		ТипСсылки = ТипЗнч(ОписаниеОбъекта);

		НаборыСвойствОбъекта = Новый ТаблицаЗначений;
		НаборыСвойствОбъекта.Колонки.Добавить("Набор");
		НаборыСвойствОбъекта.Колонки.Добавить("Заголовок");

		ЗаполнитьНаборСвойствХарактеристикиПоКатегории(ОписаниеОбъектаПустаяСсылка, ТипСсылки, НаборыСвойствОбъекта,
			ВладелецСвойств);

	Иначе

		НаборыСвойствОбъекта = УправлениеСвойствамиСлужебный.ПолучитьНаборыСвойствОбъекта(ОписаниеОбъекта);

	КонецЕсли;

	Для Каждого Строка Из НаборыСвойствОбъекта Цикл
		Если УправлениеСвойствамиСлужебный.ВидыСвойствНабора(Строка.Набор).ДополнительныеРеквизиты Тогда

			Форма.Свойства_НаборыДополнительныхРеквизитовОбъекта.Добавить(
				Строка.Набор, Строка.Заголовок);
		КонецЕсли;
	КонецЦикла;

	ОписаниеСвойств = УправлениеСвойствамиСлужебный.ЗначенияСвойств(
		ОписаниеОбъекта.ДополнительныеРеквизиты.Выгрузить(), Форма.Свойства_НаборыДополнительныхРеквизитовОбъекта, Ложь);

	Для Каждого ОписаниеСвойства Из ОписаниеСвойств Цикл
		ОписаниеСвойства.Виден = Истина;
	КонецЦикла;

	Форма.Свойства_ТаблицаСвойстваИЗначения.Загрузить(ОписаниеСвойств);
	Для Каждого Эл Из Форма.Свойства_ТаблицаСвойстваИЗначения Цикл
		Эл.ФорматСвойства = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Эл.Свойство, "ФорматСвойства");
	КонецЦикла;

	Итератор = 0;
	Для Каждого ОписаниеСвойства Из ОписаниеСвойств Цикл

		Если Не ЗаполнитьОписаниеЗависимостей Тогда
			Продолжить;
		КонецЕсли;
		
		// Заполнение таблицы зависимых дополнительных реквизитов.
		Если ОписаниеСвойства.ЗависимостиДополнительныхРеквизитов.Количество() > 0 Тогда
			ОписаниеЗависимогоРеквизита = Форма.Свойства_ОписаниеЗависимыхДополнительныхРеквизитов.Добавить();
			ЗаполнитьЗначенияСвойств(ОписаниеЗависимогоРеквизита, ОписаниеСвойства);
		КонецЕсли;

		Для Каждого СтрокаТаблицы Из ОписаниеСвойства.ЗависимостиДополнительныхРеквизитов Цикл

			Если Не ЗначениеЗаполнено(СтрокаТаблицы.ЗависимоеСвойство) И Не ЗначениеЗаполнено(СтрокаТаблицы.Условие)
				И СтрокаТаблицы.Реквизит = Неопределено Тогда

				Продолжить;
			КонецЕсли;

			Если ТипЗнч(СтрокаТаблицы.Реквизит) = Тип("Строка") Тогда
				ПутьКРеквизиту = "ОписаниеОбъекта." + СтрокаТаблицы.Реквизит;
			Иначе
				Строки = Форма.Свойства_ТаблицаСвойстваИЗначения.НайтиСтроки(Новый Структура("Свойство",
					СтрокаТаблицы.Реквизит));
				Если Строки.Количество() = 0 Тогда
					Продолжить;
				КонецЕсли;
				Для Каждого Стр Из Строки Цикл
					ПутьКРеквизиту = "Форма.Свойства_ТаблицаСвойстваИЗначения" + "[" + Стр.ПолучитьИдентификатор()
						+ "]" + ".Значение";
				КонецЦикла;
			КонецЕсли;

			ШаблонУсловия = "";
			Если СтрокаТаблицы.Условие = "Равно" Тогда
				ШаблонУсловия = "%1 = %2";
			ИначеЕсли СтрокаТаблицы.Условие = "НеРавно" Тогда
				ШаблонУсловия = "%1 <> %2";
			КонецЕсли;

			Если СтрокаТаблицы.Условие = "ВСписке" Тогда
				ШаблонУсловия = "%2.НайтиПоЗначению(%1) <> Неопределено";
			ИначеЕсли СтрокаТаблицы.Условие = "НеВСписке" Тогда
				ШаблонУсловия = "%2.НайтиПоЗначению(%1) = Неопределено";
			КонецЕсли;

			ПравоеЗначение = "";
			Если ЗначениеЗаполнено(ШаблонУсловия) Тогда
				ПравоеЗначение = "ЗначенияПараметров[""" + ПутьКРеквизиту + """]";
			КонецЕсли;

			Если СтрокаТаблицы.Условие = "Заполнено" Тогда
				ШаблонУсловия = "ЗначениеЗаполнено(%1)";
			ИначеЕсли СтрокаТаблицы.Условие = "НеЗаполнено" Тогда
				ШаблонУсловия = "Не ЗначениеЗаполнено(%1)";
			КонецЕсли;

			Если ЗначениеЗаполнено(ШаблонУсловия) Тогда
				Если ЗначениеЗаполнено(ПравоеЗначение) Тогда
					КодУсловия = СтрШаблон(ШаблонУсловия, ПутьКРеквизиту, ПравоеЗначение);
				Иначе
					КодУсловия = СтрШаблон(ШаблонУсловия, ПутьКРеквизиту);
				КонецЕсли;
			КонецЕсли;

			Если СтрокаТаблицы.ЗависимоеСвойство = "Доступен" Тогда
				УстановитьУсловиеЗависимости(ОписаниеЗависимогоРеквизита.УсловиеДоступности, ПутьКРеквизиту,
					СтрокаТаблицы, КодУсловия, СтрокаТаблицы.Условие);
			ИначеЕсли СтрокаТаблицы.ЗависимоеСвойство = "Виден" Тогда
				УстановитьУсловиеЗависимости(ОписаниеЗависимогоРеквизита.УсловиеВидимости, ПутьКРеквизиту,
					СтрокаТаблицы, КодУсловия, СтрокаТаблицы.Условие);
			Иначе
				УстановитьУсловиеЗависимости(ОписаниеЗависимогоРеквизита.УсловиеОбязательностиЗаполнения,
					ПутьКРеквизиту, СтрокаТаблицы, КодУсловия, СтрокаТаблицы.Условие);
			КонецЕсли;
		КонецЦикла;

		Итератор = Итератор + 1;

	КонецЦикла;

КонецПроцедуры

// Заполнить набор свойств номенклатуры по категории
// 
// Параметры:
// 	Объект - Произвольный
// 	ТипСсылки - Тип
// 	НаборыСвойств - см. УправлениеСвойствамиПереопределяемый.ЗаполнитьНаборыСвойствОбъекта.НаборыСвойств
Процедура ЗаполнитьНаборСвойствНоменклатурыПоКатегории(Объект, ТипСсылки, НаборыСвойств) Экспорт

	Строка = НаборыСвойств.Добавить();
	Строка.Набор = Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Номенклатура_Общие;

	Если ТипЗнч(Объект) = ТипСсылки Тогда

		Номенклатура = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект, "ЭтоГруппа, КатегорияНоменклатуры");

	Иначе

		Номенклатура = Объект;

	КонецЕсли;

	Если Номенклатура.ЭтоГруппа = Ложь Тогда

		Строка = НаборыСвойств.Добавить();
		Строка.Набор = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура.КатегорияНоменклатуры, "НаборСвойств");

	КонецЕсли;

КонецПроцедуры

// Заполнить набор свойств характеристики по категории
// 
// Параметры:
// 	Характеристика - СправочникСсылка.ХарактеристикиНоменклатуры
// 	ТипСсылки - Тип
// 	НаборыСвойств - см. УправлениеСвойствамиПереопределяемый.ЗаполнитьНаборыСвойствОбъекта.НаборыСвойств
// 	Категория - СправочникСсылка.КатегорииНоменклатуры
Процедура ЗаполнитьНаборСвойствХарактеристикиПоКатегории(Характеристика, ТипСсылки, НаборыСвойств,
	Категория = Неопределено) Экспорт

	Если Категория = Неопределено Тогда
		Если ТипЗнч(Характеристика) = ТипСсылки Тогда
			Характеристика = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
				Характеристика, "Владелец");
		КонецЕсли;

		Категория = Справочники.КатегорииНоменклатуры.ПустаяСсылка();
		Если ТипЗнч(Характеристика.Владелец) = Тип("СправочникСсылка.КатегорииНоменклатуры") Тогда
			Категория = Характеристика.Владелец;
		ИначеЕсли ТипЗнч(Характеристика.Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
			Категория = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Характеристика.Владелец, "КатегорияНоменклатуры");
		КонецЕсли;
	КонецЕсли;

	Если ЗначениеЗаполнено(Категория) Тогда
		Строка = НаборыСвойств.Добавить();
		Строка.Набор = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Категория, "НаборСвойствХарактеристики");
	КонецЕсли;

КонецПроцедуры

// Заполнить набор свойств спецификации по категории
// 
// Параметры:
// 	Объект - Произвольный
// 	ТипСсылки - Тип
// 	НаборыСвойств - см. УправлениеСвойствамиПереопределяемый.ЗаполнитьНаборыСвойствОбъекта.НаборыСвойств
// 	Категория - СправочникСсылка.КатегорииНоменклатуры
Процедура ЗаполнитьНаборСвойствСпецификацииПоКатегории(Объект, ТипСсылки, НаборыСвойств, Категория = Неопределено) Экспорт

	Строка = НаборыСвойств.Добавить();
	Строка.Набор = Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Спецификации_Общие;

	Если Категория = Неопределено Тогда
		Если ТипЗнч(Объект) = ТипСсылки Тогда
			Объект = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
				Объект, "Владелец");
		КонецЕсли;
		Категория = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Владелец, "КатегорияНоменклатуры");
	КонецЕсли;

	Если ЗначениеЗаполнено(Категория) Тогда
		Строка = НаборыСвойств.Добавить();
		Строка.Набор = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Категория, "НаборСвойствСпецификации");
	КонецЕсли;

КонецПроцедуры

// Заполнить набор свойств комплектации по категории
// 
// Параметры:
// 	Объект - Произвольный
// 	ТипСсылки - Тип
// 	НаборыСвойств - см. УправлениеСвойствамиПереопределяемый.ЗаполнитьНаборыСвойствОбъекта.НаборыСвойств
// 	Категория - СправочникСсылка.КатегорииНоменклатуры
Процедура ЗаполнитьНаборСвойствКомплектацииПоКатегории(Объект, ТипСсылки, НаборыСвойств, Категория = Неопределено) Экспорт

	Строка = НаборыСвойств.Добавить();
	Строка.Набор = Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_КомплектацииНоменклатуры_Общие;

	Если Категория = Неопределено Тогда
		Если ТипЗнч(Объект) = ТипСсылки Тогда
			Объект = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
				Объект, "Владелец");
		КонецЕсли;
		Категория = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Владелец, "КатегорияНоменклатуры");
	КонецЕсли;

	Если ЗначениеЗаполнено(Категория) Тогда
		Строка = НаборыСвойств.Добавить();
		Строка.Набор = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Категория, "НаборСвойствКомплектацииНоменклатуры");
	КонецЕсли;

КонецПроцедуры

// Возвращает список всех свойств для объекта метаданных.
//
// Параметры:
//  ВидОбъектов - Строка - полное имя объекта метаданных;
//  ВидСвойств  - Строка - "ДополнительныеРеквизиты" или "ДополнительныеСведения".
//
// Возвращаемое значение:
//  ТаблицаЗначений - свойство, Наименование, ТипЗначения.
//  Неопределено    - для указанного вида объекта нет набора свойств.
//
Функция СписокСвойствДляВидаОбъектов(ВидОбъектов, Знач ВидСвойств) Экспорт
	Возврат УправлениеСвойствамиСлужебный.СписокСвойствДляВидаОбъектов(ВидОбъектов, ВидСвойств);
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьУсловиеЗависимости(СтруктураЗависимостей, ПутьКРеквизиту, СтрокаТаблицы, КодУсловия, Условие)
	Если СтруктураЗависимостей = Неопределено Тогда
		ЗначенияПараметров = Новый Соответствие;
		Если Условие = "ВСписке" Или Условие = "НеВСписке" Тогда
			Значение = Новый СписокЗначений;
			Значение.Добавить(СтрокаТаблицы.Значение);
		Иначе
			Значение = СтрокаТаблицы.Значение;
		КонецЕсли;
		ЗначенияПараметров.Вставить(ПутьКРеквизиту, Значение);
		СтруктураЗависимостей = Новый Структура;
		СтруктураЗависимостей.Вставить("КодУсловия", КодУсловия);
		СтруктураЗависимостей.Вставить("ЗначенияПараметров", ЗначенияПараметров);
	ИначеЕсли (Условие = "ВСписке" Или Условие = "НеВСписке") И ТипЗнч(
		СтруктураЗависимостей.ЗначенияПараметров[ПутьКРеквизиту]) = Тип("СписокЗначений") Тогда
		СтруктураЗависимостей.ЗначенияПараметров[ПутьКРеквизиту].Добавить(СтрокаТаблицы.Значение);
	Иначе
		СтруктураЗависимостей.КодУсловия = СтруктураЗависимостей.КодУсловия + " И " + КодУсловия;
		Если Условие = "ВСписке" Или Условие = "НеВСписке" Тогда
			Значение = Новый СписокЗначений;
			Значение.Добавить(СтрокаТаблицы.Значение);
		Иначе
			Значение = СтрокаТаблицы.Значение;
		КонецЕсли;
		СтруктураЗависимостей.ЗначенияПараметров.Вставить(ПутьКРеквизиту, Значение);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
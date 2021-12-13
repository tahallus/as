﻿#Область ПроцедурыИФункцииОбщегоНазначения

// В процедуре можно установить или сбросить флаг "Действует".
//
// Параметры:
//  НовоеЗначение  - Булево - Новое значение флага "Действует".
//  МассивВыделенныхСтрок  - Массив - Массив строк, которые выделены в списке автоматических скидок.
//
&НаСервере
Процедура ИзменитьФлагДействуетСервер(НовоеЗначение, Знач МассивВыделенныхСтрок)

	НужноОбновлятьСписок = Ложь;
	Для Каждого СтрокаАвтоСкидок Из МассивВыделенныхСтрок Цикл
		Если СтрокаАвтоСкидок.Действует <> НовоеЗначение Тогда
			Если СтрокаАвтоСкидок.Ссылка.Пустая() Или СтрокаАвтоСкидок.ЭтоГруппа Тогда
				Продолжить;
			КонецЕсли;
			ОбъектАвтоСкидка = СтрокаАвтоСкидок.Ссылка.ПолучитьОбъект();
			ОбъектАвтоСкидка.Действует = НовоеЗначение;
			Попытка
				ОбъектАвтоСкидка.Записать();
				НужноОбновлятьСписок = Истина;
			Исключение
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтрШаблон(НСтр(
					"ru = 'Не удалось изменить флаг ""Действует"" для автоматической скидки (наценки) ""%1"".'"),
					СтрокаАвтоСкидок.Ссылка);
				Сообщение.Поле = "Действует";
				Сообщение.УстановитьДанные(СтрокаАвтоСкидок.Ссылка);
				Сообщение.Сообщить();
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	
	Если НужноОбновлятьСписок Тогда
		Элементы.АвтоматическиеСкидки.Обновить();
	КонецЕсли;

КонецПроцедуры // ИзменитьФлагДействуетСервер()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура проверяет установленную сортировку по реквизиту "РеквизитДопУпорядочивания" и предлагает
// установить такую сортировку.
//
&НаКлиенте
Процедура ПроверитьСортировкуСписка()
	
	ПараметрыУстановкиСортировки = Новый Структура;
	ПараметрыУстановкиСортировки.Вставить("СписокРеквизит", АвтоматическиеСкидки);
	ПараметрыУстановкиСортировки.Вставить("СписокЭлемент", Элементы.АвтоматическиеСкидки);
	
	Если Не СортировкаВСпискеУстановленаПравильно() Тогда
		ТекстВопроса = НСтр("ru = 'Сортировку списка рекомендуется установить
								|по полю ""Порядок"". Настроить необходимую сортировку?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьСписокПередОперациейОтветПоСортировкеПолучен", ЭтотОбъект, ПараметрыУстановкиСортировки);
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Настроить'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Не настраивать'"));
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки, , КодВозвратаДиалога.Да);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Функция проверяет, что в списке установлена сортировка по реквизиту РеквизитДопУпорядочивания.
//
&НаКлиенте
Функция СортировкаВСпискеУстановленаПравильно()
	
	ПользовательскиеНастройкиПорядка = Неопределено;
	Для Каждого Элемент Из АвтоматическиеСкидки.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ПорядокКомпоновкиДанных") Тогда
			ПользовательскиеНастройкиПорядка = Элемент;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПользовательскиеНастройкиПорядка = Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	
	ЭлементыПорядка = ПользовательскиеНастройкиПорядка.Элементы;
	
	// Найдем первый используемый элемент порядка
	Элемент = Неопределено;
	Для Каждого ЭлементПорядка Из ЭлементыПорядка Цикл
		Если ЭлементПорядка.Использование Тогда
			Элемент = ЭлементПорядка;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Элемент = Неопределено Тогда
		// Не установлена никакая сортировка
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Элемент) = Тип("ЭлементПорядкаКомпоновкиДанных") Тогда
		Если Элемент.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр Тогда
			ПолеРеквизита = Новый ПолеКомпоновкиДанных("РеквизитДопУпорядочивания");
			Если Элемент.Поле = ПолеРеквизита Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Процедура обрабатывает ответ пользователя на вопрос об установке сортировки по реквизиту РеквизитДопУпорядочивания.
//
&НаКлиенте
Процедура ПроверитьСписокПередОперациейОтветПоСортировкеПолучен(РезультатОтвета, ДополнительныеПараметры) Экспорт
	
	Если РезультатОтвета <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьСортировкуСпискаПоПолюПорядокНаКлиенте();
	
КонецПроцедуры

// Процедура устанавливает сортировку по полю РеквизитДопУпорядочивания.
//
&НаКлиенте
Процедура УстановитьСортировкуСпискаПоПолюПорядокНаКлиенте()
	
	СписокРеквизит = АвтоматическиеСкидки;
	
	ПользовательскиеНастройкиПорядка = Неопределено;
	Для Каждого Элемент Из СписокРеквизит.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ПорядокКомпоновкиДанных") Тогда
			ПользовательскиеНастройкиПорядка = Элемент;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.Проверить(ПользовательскиеНастройкиПорядка <> Неопределено, НСтр(
		"ru = 'Пользовательская настройка порядка не найдена.'"));
	
	ПользовательскиеНастройкиПорядка.Элементы.Очистить();
	Элемент = ПользовательскиеНастройкиПорядка.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	Элемент.Использование = Истина;
	Элемент.Поле = Новый ПолеКомпоновкиДанных("РеквизитДопУпорядочивания");
	Элемент.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	
КонецПроцедуры

// Процедура устанавливает сортировку по полю РеквизитДопУпорядочивания.
//
&НаСервере
Процедура УстановитьСортировкуСпискаПоПолюПорядокНаСервере()
	
	СписокРеквизит = АвтоматическиеСкидки;
	
	ПользовательскиеНастройкиПорядка = Неопределено;
	Для Каждого Элемент Из СписокРеквизит.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ПорядокКомпоновкиДанных") Тогда
			ПользовательскиеНастройкиПорядка = Элемент;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.Проверить(ПользовательскиеНастройкиПорядка <> Неопределено, НСтр(
		"ru = 'Пользовательская настройка порядка не найдена.'"));
	
	ПользовательскиеНастройкиПорядка.Элементы.Очистить();
	Элемент = ПользовательскиеНастройкиПорядка.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	Элемент.Использование = Истина;
	Элемент.Поле = Новый ПолеКомпоновкиДанных("РеквизитДопУпорядочивания");
	Элемент.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.ВидыСкидокНаценок);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.ВидыСкидокНаценок, Результат);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.ВидыСкидокНаценок);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ПроцедурыОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка доступности цен для редактирования.
	РазрешеноРедактированиеЦенДокументов = УправлениеДоступомУНФ.РазрешеноРедактированиеЦенДокументов();
	
	Элементы.ВидыСкидокНаценок.ТолькоПросмотр = НЕ РазрешеноРедактированиеЦенДокументов;
	Элементы.АвтоматическиеСкидки.ТолькоПросмотр = НЕ РазрешеноРедактированиеЦенДокументов;
	Элементы.АвтоматическиеСкидкиСоздатьГруппуСовместногоПрименения.Доступность = РазрешеноРедактированиеЦенДокументов;
	Элементы.АвтоматическиеОкругления.ТолькоПросмотр = НЕ РазрешеноРедактированиеЦенДокументов;
	
	// АвтоматическиеСкидки
	ИспользоватьАвтоматическиеСкидкиНаценки = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиНаценки");
	Если ИспользоватьАвтоматическиеСкидкиНаценки Тогда
		Вытеснение = ПредопределенноеЗначение("Перечисление.ВариантыСовместногоПримененияСкидокНаценок.Вытеснение");
		Умножение = ПредопределенноеЗначение("Перечисление.ВариантыСовместногоПримененияСкидокНаценок.Умножение");
		
		ВариантСовместногоПримененияСкидок = Константы.ВариантыСовместногоПримененияСкидокНаценок.Получить();
		Если ВариантСовместногоПримененияСкидок.Пустая() Тогда
			Если РазрешеноРедактированиеЦенДокументов Тогда
				ВариантСовместногоПримененияСкидок = Перечисления.ВариантыСовместногоПримененияСкидокНаценок.Сложение;
				УстановитьПривилегированныйРежим(Истина);
				Константы.ВариантыСовместногоПримененияСкидокНаценок.Установить(ВариантСовместногоПримененияСкидок);
				УстановитьПривилегированныйРежим(Ложь);
			Иначе
				Отказ = Истина;
				ОбщегоНазначения.СообщитьПользователю(НСтр(
					"ru = 'Автоматические скидки не настроены. Обратитесь к пользователю с правом редактирования цен в документах.'"));
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Не РазрешеноРедактированиеЦенДокументов Тогда
		Элементы.ВариантСовместногоПримененияСкидок.Видимость = Ложь;
		
		Элементы.НадписьВариантСовместногоПрименения.Заголовок = СтрШаблон(НСтр("ru = 'Совместное применение: %1'"),
			Константы.ВариантыСовместногоПримененияСкидокНаценок.Получить());
		Элементы.НадписьВариантСовместногоПрименения.Видимость = Истина;
	КонецЕсли;
	// Конец АвтоматическиеСкидки
	
	УправлениеВидимостьюСервер();
	
	Если ВариантСовместногоПримененияСкидок = Вытеснение
		ИЛИ ВариантСовместногоПримененияСкидок = Умножение Тогда
		УстановитьСортировкуСпискаПоПолюПорядокНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = ВидыСкидокНаценок.Отбор.ДоступныеПоляОтбора.НайтиПоле(
		Новый ПолеКомпоновкиДанных("Ссылка")).ТипЗначения;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Параметры.Свойство("Округления") И Параметры.Округления=Истина Тогда
		Элементы.ГруппаРучныеИАвтоматическиеСкидки.ТекущаяСтраница = Элементы.ГруппаАвтоматическоеОкругление;
	КонецЕсли;
	
	Если Параметры.Свойство("ДисконтныеКарты") И Параметры.ДисконтныеКарты Тогда
		Элементы.ГруппаРучныеИАвтоматическиеСкидки.ТекущаяСтраница = Элементы.ГруппаАвтоматическиеСкидки;
		Элементы.ГруппаРучныеИАвтоматическиеСкидки.ПодчиненныеЭлементы.ГруппаРучныеСкидки.Видимость = Ложь;
		Элементы.ГруппаРучныеИАвтоматическиеСкидки.ПодчиненныеЭлементы.ГруппаАвтоматическоеОкругление.Видимость = Ложь;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(АвтоматическиеСкидки,
			"ЕстьУсловияПоДК", Истина);
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события ОбработкаОповещения формы.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = "ФункциональнаяОпцияИспользоватьАвтоматическиеСкидкиНаценки"
		Или Источник = "ФункциональнаяОпцияИспользоватьРучныеСкидкиНаценкиПродажи" Тогда
		УправлениеВидимостьюСервер();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииДляУправленияВнешнимВидомФормы

// Процедура управляет видимостью и заголовками в зависимости от ФО 
// ИспользоватьСкидкиНаценки и ИспользоватьАвтоматическиеСкидкиНаценки.
//
&НаСервере
Процедура УправлениеВидимостьюСервер()
	
	ИспользоватьАвтоматическиеСкидкиНаценки = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиНаценки");
	ИспользоватьСкидкиНаценки = ПолучитьФункциональнуюОпцию("ИспользоватьРучныеСкидкиНаценкиПродажи");
	Если ИспользоватьАвтоматическиеСкидкиНаценки И Не ИспользоватьСкидкиНаценки Тогда
		Элементы.ГруппаРучныеСкидки.Видимость = Ложь;
		Заголовок = НСтр("ru = 'Виды автоматических скидок, наценок'");
	ИначеЕсли Не ИспользоватьАвтоматическиеСкидкиНаценки И ИспользоватьСкидкиНаценки Тогда
		Элементы.ГруппаАвтоматическиеСкидки.Видимость = Ложь;
		Элементы.ГруппаАвтоматическоеОкругление.Видимость = Ложь;
		Заголовок = НСтр("ru = 'Виды скидок, наценок'");
	Иначе
		// Эта ветка будет использоваться при обработке оповещений от формы настроек учета.
		Элементы.ГруппаРучныеСкидки.Видимость = Истина;
		Элементы.ГруппаАвтоматическиеСкидки.Видимость = Истина;
		Элементы.ГруппаРучныеИАвтоматическиеСкидки.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
		Заголовок = НСтр("ru = 'Скидки и наценки'");
	КонецЕсли;
	
КонецПроцедуры
	
#КонецОбласти

#Область ПроцедурыОбработчикиСобытийЭлементовФормы

// Процедура - обработчик события ПриИзменении элемента ВариантСовместногоПримененияСкидок формы.
//
&НаКлиенте
Процедура ВариантСовместногоПримененияСкидокПриИзменении(Элемент)
	
	ВариантСовместногоПримененияСкидокПриИзмененииНаСервере(ВариантСовместногоПримененияСкидок);
	Если ВариантСовместногоПримененияСкидок = Вытеснение
		ИЛИ ВариантСовместногоПримененияСкидок = Умножение Тогда
		ПроверитьСортировкуСписка();
	КонецЕсли;
	Элементы.АвтоматическиеСкидки.Обновить();
	
КонецПроцедуры

// Серверная часть процедуры ВариантСовместногоПримененияСкидокПриИзменении.
//
&НаСервереБезКонтекста
Процедура ВариантСовместногоПримененияСкидокПриИзмененииНаСервере(ВариантСовместногоПримененияСкидок)
	
	УстановитьПривилегированныйРежим(Истина);
	Константы.ВариантыСовместногоПримененияСкидокНаценок.Установить(ВариантСовместногоПримененияСкидок);
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Процедура - обработчик события Нажатие элемента ГиперссылкаКакРаботатьСАвтоматическимиСкидкамиВПрограмме формы.
//
&НаКлиенте
Процедура ГиперссылкаКакРаботатьСАвтоматическимиСкидкамиВПрограммеНажатие(Элемент)
	
	ПараметрыОткрытия = Новый Структура("Заголовок, КлючПодсказки", 
		"Как работать с автоматическими скидками",
		"АвтоматическиеСкидки_КакРаботатьСАвтоматическимиСкидками");
	
	ОткрытьФорму("Обработка.МенеджерПодсказок.Форма", ПараметрыОткрытия,, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаКакРаботатьСОкруглениямиВПрограммеНажатие(Элемент)
	
	ПараметрыОткрытия = Новый Структура("Заголовок, КлючПодсказки", 
		"Как настроить с округления сумм",
		"АвтоматическиеСкидки_КакНастроитьОкругления");
	
	ОткрытьФорму("Обработка.МенеджерПодсказок.Форма", ПараметрыОткрытия,, УникальныйИдентификатор);
	
КонецПроцедуры

// Процедура - обработчик события Нажатие элемента ГиперссылкаНаВидеоурокНажатие формы.
//
&НаКлиенте
Процедура ГиперссылкаНаВидеоурокНажатие(Элемент)
	
	АдресСтраницы = "http://youtu.be/87rZk6iFzKQ";
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(АдресСтраницы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик команды СоздатьГруппуСовместногоПрименения формы.
&НаКлиенте
Процедура СоздатьГруппуСовместногоПрименения(Команда)
	
	ПараметрыДляФормыГруппы = Новый Структура("ЭтоГруппа", Истина);
	ОткрытьФорму("Справочник.АвтоматическиеСкидки.ФормаГруппы", ПараметрыДляФормыГруппы);
	
КонецПроцедуры

// Процедура - обработчик команды УстановитьФлагДействует формы.
//
&НаКлиенте
Процедура УстановитьФлагДействует(Команда)
	
	Если ЗначениеЗаполнено(Элементы.АвтоматическиеСкидки.ВыделенныеСтроки) Тогда
		ИзменитьФлагДействуетСервер(Истина, Элементы.АвтоматическиеСкидки.ВыделенныеСтроки);
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик команды СброситьФлагДействует формы.
//
&НаКлиенте
Процедура СброситьФлагДействует(Команда)
	
	Если ЗначениеЗаполнено(Элементы.АвтоматическиеСкидки.ВыделенныеСтроки) Тогда
		ИзменитьФлагДействуетСервер(Ложь, Элементы.АвтоматическиеСкидки.ВыделенныеСтроки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыОбработчикиСобытийДинамическихСписоков

// Процедура - обработчик события ПриИзменении динамического списка АвтоматическиеСкидки.
//
&НаКлиенте
Процедура АвтоматическиеСкидкиПриИзменении(Элемент)
	
	Элемент.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВидыСкидокНаценок

&НаКлиенте
Процедура ВидыСкидокНаценокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоматическиеОкругленияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ЗначенияЗаполнения = Новый Структура("СпособПредоставления", ПредопределенноеЗначение(
		"Перечисление.СпособыПредоставленияСкидокНаценок.Округление"));
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ОткрытьФорму("Справочник.АвтоматическиеСкидки.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

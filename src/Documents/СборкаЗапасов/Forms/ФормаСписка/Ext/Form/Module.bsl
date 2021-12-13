﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеОтмененногоЗаказа(
		СписокЗаказыНаПроизводство.КомпоновщикНастроек.Настройки.УсловноеОформление);
	
	УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
	
	Если НЕ Константы.ФункциональнаяОпцияУчетПоНесколькимПодразделениям.Получить()
		И НЕ Константы.ФункциональнаяОпцияУчетПоНесколькимСкладам.Получить() Тогда
		
		Элементы.ОтборПодразделение.РежимВыбораИзСписка = Истина;
		Элементы.ОтборПодразделение.СписокВыбора.Добавить(Справочники.СтруктурныеЕдиницы.ОсновноеПодразделение);
		Элементы.ОтборПодразделение.СписокВыбора.Добавить(Справочники.СтруктурныеЕдиницы.ОсновнойСклад);
		
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("РезервированиеЗапасов") Тогда
		Элементы.ДокументОснование.Видимость = Ложь;
		Элементы.ЗаказПокупателя.Видимость = Истина;
	Иначе
		Элементы.ДокументОснование.Видимость = Истина;
		Элементы.ЗаказПокупателя.Видимость = Ложь;
		Элементы.ОтборЗаказПокупателя.Видимость = Ложь;
		Элементы.ГруппаОтборЗаказПокупателя.Видимость = Элементы.ОтборЗаказПокупателя.Видимость;
	КонецЕсли;
	
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(Список);
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(СписокЗаказыНаПроизводство);
	
	//УНФ.ОтборыСписка
	УстановитьВидимостьОтборов();
	РаботаСОтборами.ОпределитьПорядокПредопределенныхОтборов(ЭтотОбъект);
	РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список);
	ВыполнитьЗагрузкуНестандартныхОтборов();
	//Конец УНФ.ОтборыСписка
	
	// МобильноеПриложение
	Если МобильноеПриложениеВызовСервера.НужноОграничитьФункциональность() Тогда
		Элементы.ГруппаГлобальныеКоманды.Видимость = Ложь;
		Элементы.ПраваяПанель.Видимость = Ложь;
		Элементы.ФормаСоздатьПоШаблону.Видимость = Ложь;
		Элементы.СтруктурнаяЕдиница.Видимость = Ложь;
		Элементы.Ячейка.Видимость = Ложь;
		Элементы.ВидОперации.Видимость = Ложь;
		Элементы.ДокументОснование.Видимость = Ложь;
		Элементы.СтраницаЗаказыНаПроизводство.Видимость = Ложь;
		Элементы.СтруктурнаяЕдиницаПродукции.Видимость = Ложь;
		Элементы.СтруктурнаяЕдиницаЗапасов.Видимость = Ложь;
		Элементы.СтруктурнаяЕдиницаОтходов.Видимость = Ложь;
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	// Конец МобильноеПриложение
	
	// ИнтернетПоддержкаПользователей.Новости
	ОбработкаНовостей.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтотОбъект,
		"УНФ.Документ.СборкаЗапасов",
		"ФормаСписка",
		Неопределено,
		НСтр("ru='Новости: Производство'"),
		Ложь,
		Новый Структура("ПолучатьНовостиНаСервере, ХранитьМассивНовостейТолькоНаСервере", Истина, Истина),
		"ПриОткрытии"
	);
	// Конец ИнтернетПоддержкаПользователей.Новости
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПечатьДокументовУНФ.УстановитьОтображениеПодменюПечати(Элементы.ПодменюПечать);
	
	// ПодключаемоеОборудование
	ИспользоватьПодключаемоеОборудование = УправлениеНебольшойФирмойПовтИсп.ИспользоватьПодключаемоеОборудование();
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.Новости
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект,
		"СканерШтрихкода");
	// Конец ПодключаемоеОборудование 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_СостоянияЗаказовНаПроизводство" Тогда
		УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_СборкаЗапасов"
		И Элементы.Страницы.ТекущаяСтраница=Элементы.СтраницаЗаказыНаПроизводство Тогда
		Элементы.СписокЗаказыНаПроизводство.Обновить();
	КонецЕсли;
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУНФКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУНФКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы Тогда
		//УНФ.ОтборыСписка
		СохранитьНастройкиОтборов();
		//Конец УНФ.ОтборыСписка
	КонецЕсли;
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОтборПодразделениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("СтруктурнаяЕдиница", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;

КонецПроцедуры

&НаКлиенте
Процедура ОтборОперацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("ВидОперации", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборЗаказНаПроизводствоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеДокумента = СтрЗаменить(ВыбранноеЗначение, "Заказ на производство", "Заказ");
	УстановитьМеткуИОтборСписка("ЗаказНаПроизводство", Элемент.Родитель.Имя, ВыбранноеЗначение, ПредставлениеДокумента);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборЗаказПокупателяОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьНестандартныеОтборы("ЗаказПокупателя", ВыбранноеЗначение, Элемент.Родитель.Имя);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Организация", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСкладОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьНестандартныеОтборы("СтруктурнаяЕдиницаЗапасов", ВыбранноеЗначение, Элемент.Родитель.Имя);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборЭтапОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("ВыполненныеЭтапы.Этап", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ИнтернетПоддержкаПользователей.Новости
// @skip-warning
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()
	
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтотОбъект, "ПриОткрытии");
	
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.Новости

&НаКлиенте
Процедура СоздатьПроизводство(Команда)
	
	МассивЗаказов = Элементы.СписокЗаказыНаПроизводство.ВыделенныеСтроки;
	
	Если МассивЗаказов.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	
	Если МассивЗаказов.Количество() = 1 Тогда
		
		ПараметрыОткрытия = Новый Структура("Основание", МассивЗаказов[0]);
		ОткрытьФорму("Документ.СборкаЗапасов.ФормаОбъекта", ПараметрыОткрытия);
		
	Иначе
		
		МассивПроизводство = СформироватьДокументыПроизводствоИЗаписать(МассивЗаказов);
		Текст = НСтр("ru='Создание:'");
		Для Каждого СтрокаПроизводство Из МассивПроизводство Цикл
			
			ПоказатьОповещениеПользователя(Текст, ПолучитьНавигационнуюСсылку(СтрокаПроизводство), СтрокаПроизводство,
				БиблиотекаКартинок.Информация32);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоШаблону(Команда)

	ЗаполнениеОбъектовУНФКлиент.ПоказатьВыборШаблонаДляСозданияДокументаИзСписка(
	"Документ.СборкаЗапасов", Список.КомпоновщикНастроек.Настройки.Отбор.Элементы, Элементы.Список.ТекущаяСтрока);

КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	
	ТекШтрихкод = "";
	
	ОбработкаЗавершения = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект,
		Новый Структура("ТекШтрихкод", ТекШтрихкод));
	
	#Если МобильныйКлиент Тогда
		ОткрытьФорму("ОбщаяФорма.ФормаПоискаПоШтрихкоду", , , , , , ОбработкаЗавершения);
	#Иначе
	ПоказатьВводЗначения(ОбработкаЗавершения, ТекШтрихкод, НСтр("ru = 'Введите штрихкод'"));
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СформироватьДокументыПроизводствоИЗаписать(МассивЗаказов)
	
	МассивПроизводство = Новый Массив();
	Для каждого СтрокаЗНП Из МассивЗаказов Цикл
		
		НовыйДокументПроизводство = Документы.СборкаЗапасов.СоздатьДокумент();
		
		НовыйДокументПроизводство.Дата = ТекущаяДата();
		НовыйДокументПроизводство.Заполнить(СтрокаЗНП);
		
		НовыйДокументПроизводство.Записать();
		МассивПроизводство.Добавить(НовыйДокументПроизводство.Ссылка);
		
	КонецЦикла;
	
	Элементы.Список.Обновить();
	
	Возврат МассивПроизводство;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеПоЦветамСостоянийСервер()
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеПоЦветамСостояний(
		СписокЗаказыНаПроизводство.КомпоновщикНастроек.Настройки.УсловноеОформление,
		Метаданные.Справочники.СостоянияЗаказовНаПроизводство.ПолноеИмя()
	);
	
КонецПроцедуры

#Область Отборы

&НаСервере
Процедура УстановитьМеткуИОтборСписка(ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения="")
	
	Если ПредставлениеЗначения="" Тогда
		ПредставлениеЗначения=Строка(ВыбранноеЗначение);
	КонецЕсли; 
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения);
	РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, Список, ИмяПоляОтбораСписка);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗагрузкуНестандартныхОтборов()
	
	ИменаНестандартныхПолей = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("ЗаказПокупателя, СтруктурнаяЕдиницаЗапасов");
	Для каждого ИмяПоляКД Из ИменаНестандартныхПолей Цикл
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.КомпоновщикНастроек.Настройки.Отбор, СокрЛП(ИмяПоляКД));
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, СокрЛП(ИмяПоляКД));
		ОбновитьНестандартныеОтборы(СокрЛП(ИмяПоляКД));
	КонецЦикла; 
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНестандартныеОтборы(ИмяПоляОтбора, ВыбранноеЗначение = Неопределено, ИмяГруппы = "")
	
	Если ВыбранноеЗначение<>Неопределено Тогда
		ПредставлениеЗначения = Строка(ВыбранноеЗначение);
		Если ИмяПоляОтбора="ЗаказПокупателя" Тогда
			ПредставлениеЗначения = СтрЗаменить(ПредставлениеЗначения, "Заказ покупателя", "Заказ");
		КонецЕсли; 
		РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбора, ИмяГруппы, ВыбранноеЗначение, ПредставлениеЗначения);
	КонецЕсли; 
	
	Значения = Новый СписокЗначений;
	Для каждого стр Из ДанныеМеток Цикл
		Если стр.ИмяПоляОтбора = ИмяПоляОтбора Тогда
			Если ТипЗнч(стр.Метка)=Тип("СписокЗначений") Тогда
				Для каждого значениеСписка Из стр.Метка Цикл
				    Значения.Добавить(значениеСписка.Значение);
				КонецЦикла; 
			Иначе	
				Значения.Добавить(стр.Метка);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	ИспользованиеОтбора = Значения.Количество()>0;
	
	ГруппаОтборов = Неопределено; 
	Для каждого ЭлементОтбора Из Список.КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
		Если ТипЗнч(ЭлементОтбора)=Тип("ГруппаЭлементовОтбораКомпоновкиДанных") И ЭлементОтбора.Представление=ИмяПоляОтбора Тогда
			ГруппаОтборов = ЭлементОтбора;
			Прервать;
		КонецЕсли; 
	КонецЦикла;
	Если ГруппаОтборов=Неопределено Тогда
		ГруппаОтборов = Список.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтборов.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		ГруппаОтборов.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ГруппаОтборов.Представление = ИмяПоляОтбора;
		Если ИмяПоляОтбора="ЗаказПокупателя" Тогда
			ИменаПолей = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("ЗаказПокупателя,Продукция.ЗаказПокупателя,Запасы.ЗаказПокупателя");
		ИначеЕсли ИмяПоляОтбора="СтруктурнаяЕдиницаЗапасов" Тогда
			ИменаПолей = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("СтруктурнаяЕдиницаЗапасов,Продукция.СтруктурнаяЕдиница,Запасы.СтруктурнаяЕдиница");
		Иначе
			Возврат;
		КонецЕсли; 
		Для каждого ИмяПоля Из ИменаПолей Цикл
			ЭлементОтбора = ГруппаОтборов.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПоля);
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
			ЭлементОтбора.Использование = Истина;
		КонецЦикла;
	КонецЕсли;
	ГруппаОтборов.Использование = ИспользованиеОтбора;
	Для каждого ЭлементОтбора Из ГруппаОтборов.Элементы Цикл
		ЭлементОтбора.ПравоеЗначение = Значения;
	КонецЦикла; 
	
	// МобильныйКлиент
	Если ВыбранноеЗначение=Неопределено Тогда
		РаботаСОтборами.УстановитьЗаголовокПравойПанелиМобильныйКлиент(ЭтотОбъект);
	КонецЕсли; 
	// Конец МобильныйКлиент
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_") + 1);
	УдалитьМеткуОтбора(МеткаИД);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД)
	
	СтрокаМеток = ДанныеМеток[Число(МеткаИД)];
	ИмяПоляОтбора = СтрокаМеток.ИмяПоляОтбора;
	Если ИмяПоляОтбора="ЗаказПокупателя" ИЛИ ИмяПоляОтбора="СтруктурнаяЕдиницаЗапасов" Тогда
		СписокГруппФормыДляУдаленияДобавленныхЭлементов = РаботаСОтборами.ПолучитьСписокИмяГруппыРодителя(ДанныеМеток);
		ДанныеМеток.Удалить(СтрокаМеток);
		РаботаСОтборами.ОбновитьЭлементыМеток(ЭтотОбъект, СписокГруппФормыДляУдаленияДобавленныхЭлементов);
		ОбновитьНестандартныеОтборы(ИмяПоляОтбора);
	Иначе
		РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, Список, МеткаИД);
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтборов()
	
	РаботаСОтборами.СохранитьНастройкиОтборов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьРазвернутьПанельОтборов(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
		
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтборы(Команда)
	
	ИмяРеквизитаСписка = "Список";
	ИмяТЧДанныеМеток = "ДанныеМеток";
	ИмяТЧДанныеОтборов = "ДанныеОтборов";
	ИмяГруппыОтборов = "ГруппаОтборы";
	ИмяПредопределенныеОтборыПоУмолчанию = "ПредопределенныеОтборыПоУмолчанию";
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяРеквизитаСписка", ИмяРеквизитаСписка);
	ДополнительныеПараметры.Вставить("ИмяТЧДанныеМеток", ИмяТЧДанныеМеток);
	ДополнительныеПараметры.Вставить("ИмяТЧДанныеОтборов", ИмяТЧДанныеОтборов);
	ДополнительныеПараметры.Вставить("ИмяГруппыОтборов", ИмяГруппыОтборов);
	ДополнительныеПараметры.Вставить("ИмяПредопределенныеОтборыПоУмолчанию", ИмяПредопределенныеОтборыПоУмолчанию);
	
	РаботаСОтборамиКлиент.НастроитьОтборыНажатие(ЭтотОбъект, ПараметрыОткрытияФормыСНастройкамиОтборов(ДополнительныеПараметры), ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыОткрытияФормыСНастройкамиОтборов(ДополнительныеПараметры)
	
	Возврат РаботаСОтборами.ПараметрыДляОткрытияФормыСНастройкамиОтборов(ЭтотОбъект, ДополнительныеПараметры);
	
КонецФункции

&НаКлиенте
Процедура НастройкаОтборовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НастройкаОтборовЗавершениеНаСервере(Результат.АдресВыбранныеОтборы, Результат.АдресУдаленныеОтборы, ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Процедура НастройкаОтборовЗавершениеНаСервере(АдресВыбранныеОтборы, АдресУдаленныеОтборы, ДополнительныеПараметры)
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ИмяРеквизитаСписка = "Список";
		ИмяТЧДанныеМеток = "ДанныеМеток";
		ИмяТЧДанныеОтборов = "ДанныеОтборов";
	Иначе
		ИмяРеквизитаСписка = ДополнительныеПараметры.ИмяРеквизитаСписка;
		ИмяТЧДанныеМеток = ДополнительныеПараметры.ИмяТЧДанныеМеток;
		ИмяТЧДанныеОтборов = ДополнительныеПараметры.ИмяТЧДанныеОтборов;
	КонецЕсли;
	
	РаботаСОтборами.НастройкаОтборовЗавершение(ЭтотОбъект, АдресВыбранныеОтборы, АдресУдаленныеОтборы, ДополнительныеПараметры);
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ОтборПриИзменении(Элемент)
	
	Подключаемый_ОтборПриИзмененииНаСервере(Элемент.Имя, Элемент.Родитель.Имя)
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОтборПриИзмененииНаСервере(ЭлементИмя, ЭлементРодительИмя)
	
	РаботаСОтборами.Подключаемый_ОтборПриИзменении(ЭтотОбъект, ЭлементИмя, ЭлементРодительИмя);
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ОтборОчистка(Элемент)
	
	Подключаемый_ОтборОчисткаНаСервере(Элемент.Имя, Элемент.Родитель.Имя)
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОтборОчисткаНаСервере(ЭлементИмя, ЭлементРодительИмя)
	
	РаботаСОтборами.Подключаемый_ОтборОчистка(ЭтотОбъект, ЭлементИмя);

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьОтборов()
	
	Если НЕ ПолучитьФункциональнуюОпцию("УчетПоНесколькимСкладам") Тогда
		Элементы.ОтборСклад.Видимость = Ложь;
		Элементы.ГруппаОтборСклад.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(Результат, Параметры) Экспорт

	Если Результат = Неопределено Тогда
		ТекШтрихкод = СокрЛП(Параметры.ТекШтрихкод);
	Иначе
		ТекШтрихкод = СокрЛП(Результат);
	КонецЕсли;
		
	Если ПустаяСтрока(ТекШтрихкод) Тогда
		Возврат;
	КонецЕсли;
	
	Данные = Новый Структура;
	Данные.Вставить("Штрихкод", ТекШтрихкод);
	Данные.Вставить("Количество", 1);
	
	ОбработатьШтрихкоды(Данные);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если ЗначениеЗаполнено(МассивСсылок)  Тогда
		Элементы.Список.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(Неопределено, МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив;
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.СборкаЗапасов.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

#КонецОбласти

#Область ЗамерыПроизводительности

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("СозданиеФормы"
		+ РаботаСФормойДокументаКлиентСервер.ПолучитьИмяФормыСтрокой(ЭтотОбъект.ИмяФормы));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("ОткрытиеФормы"
		+ РаботаСФормойДокументаКлиентСервер.ПолучитьИмяФормыСтрокой(ЭтотОбъект.ИмяФормы));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
// @skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

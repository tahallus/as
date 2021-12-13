﻿
#Область ПрограммныйИнтерфейс

// Процедура выполняет добавление настроек в СКД
//
// Параметры:
//  КомпоновщикНастроек			 - 	 КомпоновщикНастроекКомпоновкиДанных  - Компоновщик настроек
//									 содержащий настройки СКД
//  АдресСхемыКомпоновкиДанных	 - 	 Строка - Адрес СКД в которую необходимо добавить настройки
//  АдресСКДРезультат			 - 	 Строка - Адрес СКД после помещения настроек
//
Процедура ПоместитьНастройкиВСхемуКомпоновкиДанных(КомпоновщикНастроек, АдресСхемыКомпоновкиДанных, 
	АдресСКДРезультат = "") Экспорт

	Для Каждого ПараметрОтбора Из КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
		
		Если ТипЗнч(ПараметрОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаголовокПараметра = Строка(ПараметрОтбора.ЛевоеЗначение);
		Если СтрНайти(ЗаголовокПараметра, "ПараметрыДанных") > 0 Тогда
			ПараметрОтбора.Использование = Ложь;	
			ИмяПараметра = Прав(ЗаголовокПараметра, СтрДлина(ЗаголовокПараметра) - СтрНайти(ЗаголовокПараметра, "."));
			КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра(ИмяПараметра, 
				ПараметрОтбора.ПравоеЗначение);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ПараметрДанныхОтбора Из КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы Цикл
		
		Если НЕ ПараметрДанныхОтбора.Использование Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаголовокПараметра = Строка(ПараметрДанныхОтбора.Параметр);
		ОтборИспользуется  = Ложь;
		
		Для Каждого ПараметрОтбора Из КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
			
			Если ТипЗнч(ПараметрОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
				Продолжить;
			КонецЕсли;
			
			Если Строка(ПараметрОтбора.ЛевоеЗначение) = СтрШаблон("ПараметрыДанных.%1", ЗаголовокПараметра) Тогда
				ОтборИспользуется = Истина;
			КонецЕсли; 
			
		КонецЦикла;
		
		Если НЕ ОтборИспользуется Тогда
			ПараметрДанныхОтбора.Использование = Ложь;
			ПараметрДанныхОтбора.Значение = Неопределено;
		КонецЕсли;
		
	КонецЦикла;

	КомпоновщикНастроек.Восстановить();
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
	
	ОчиститьНастройкиКомпоновкиДанных(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	СкопироватьНастройкиКомпоновкиДанных(СхемаКомпоновкиДанных.НастройкиПоУмолчанию, КомпоновщикНастроек.Настройки);
	
	Если АдресСКДРезультат <> "" Тогда
		ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, АдресСКДРезультат);
	Иначе
		ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, АдресСхемыКомпоновкиДанных);
	КонецЕсли;
	
КонецПроцедуры

// Процедура выполняет очистку настроек компоновки данных
//
// Параметры:
//  Настройки	 - КомпоновщикНастроекКомпоновкиДанных	 - настройки, которые необходимо очистить
//
Процедура ОчиститьНастройкиКомпоновкиДанных(Настройки) Экспорт
	
	Если Настройки = Неопределено Или ТипЗнч(Настройки) <> Тип("НастройкиКомпоновкиДанных") Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Параметр Из Настройки.ПараметрыДанных.Элементы Цикл
		Параметр.Значение = Неопределено;
		Параметр.Использование = Ложь;
	КонецЦикла;
	
	Для каждого Параметр Из Настройки.ПараметрыВывода.Элементы Цикл
		Параметр.Использование = Ложь;
	КонецЦикла;
	
	Настройки.ПользовательскиеПоля.Элементы.Очистить();
	Настройки.Отбор.Элементы.Очистить();
	Настройки.Порядок.Элементы.Очистить();
	Настройки.Выбор.Элементы.Очистить();
	Настройки.Структура.Очистить();
	
КонецПроцедуры

// Копирование настроек компоновки данных
//
// Параметры:
//  НастройкиПриемник	 - 	КомпоновщикНастроекКомпоновкиДанных - компоновщик, 
//  						в который необходимо скопировать настройки
//  НастройкиИсточник	 - 	КомпоновщикНастроекКомпоновкиДанных - компоновщик из которого копируются настройки
//
Процедура СкопироватьНастройкиКомпоновкиДанных(НастройкиПриемник, НастройкиИсточник) Экспорт
	
	Если НастройкиИсточник = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(НастройкиПриемник) = Тип("НастройкиКомпоновкиДанных") Тогда
		Для Каждого Параметр Из НастройкиИсточник.ПараметрыДанных.Элементы Цикл
			НовыйПараметр = НастройкиПриемник.ПараметрыДанных.Элементы.Добавить();
			ЗаполнитьЗначенияСвойств(НовыйПараметр,Параметр);
		КонецЦикла;
	КонецЕсли;
	
	Если ТипЗнч(НастройкиИсточник) = Тип("НастройкиВложенногоОбъектаКомпоновкиДанных") Тогда
		ЗаполнитьЗначенияСвойств(НастройкиПриемник, НастройкиИсточник);
		СкопироватьНастройкиКомпоновкиДанных(НастройкиПриемник.Настройки, НастройкиИсточник.Настройки);
		Возврат;
	КонецЕсли;
	
	// Копирование настроек
	Если ТипЗнч(НастройкиИсточник) = Тип("НастройкиКомпоновкиДанных") Тогда
		
		ЗаполнитьЭлементы(НастройкиПриемник.ПараметрыДанных, НастройкиИсточник.ПараметрыДанных);
		СкопироватьЭлементы(НастройкиПриемник.ПользовательскиеПоля, НастройкиИсточник.ПользовательскиеПоля);
		СкопироватьЭлементы(НастройкиПриемник.Отбор,         НастройкиИсточник.Отбор);
		СкопироватьЭлементы(НастройкиПриемник.Порядок,       НастройкиИсточник.Порядок);
		
	КонецЕсли;
	
	Если ТипЗнч(НастройкиИсточник) = Тип("ГруппировкаКомпоновкиДанных")
	 Или ТипЗнч(НастройкиИсточник) = Тип("ГруппировкаТаблицыКомпоновкиДанных")
	 Или ТипЗнч(НастройкиИсточник) = Тип("ГруппировкаДиаграммыКомпоновкиДанных") Тогда
		
		СкопироватьЭлементы(НастройкиПриемник.ПоляГруппировки, НастройкиИсточник.ПоляГруппировки);
		СкопироватьЭлементы(НастройкиПриемник.Отбор,           НастройкиИсточник.Отбор);
		СкопироватьЭлементы(НастройкиПриемник.Порядок,         НастройкиИсточник.Порядок);
		ЗаполнитьЗначенияСвойств(НастройкиПриемник, НастройкиИсточник);
		
	КонецЕсли;
	
	СкопироватьЭлементы(НастройкиПриемник.Выбор,              НастройкиИсточник.Выбор);
	СкопироватьЭлементы(НастройкиПриемник.УсловноеОформление, НастройкиИсточник.УсловноеОформление);
	ЗаполнитьЭлементы(НастройкиПриемник.ПараметрыВывода,      НастройкиИсточник.ПараметрыВывода);
	
	// Копирование структуры
	Если ТипЗнч(НастройкиИсточник) = Тип("НастройкиКомпоновкиДанных")
	 Или ТипЗнч(НастройкиИсточник) = Тип("ГруппировкаКомпоновкиДанных") Тогда
		
		Для каждого ЭлементСтруктурыИсточник Из НастройкиИсточник.Структура Цикл
			ЭлементСтруктурыПриемник = НастройкиПриемник.Структура.Добавить(ТипЗнч(ЭлементСтруктурыИсточник));
			СкопироватьНастройкиКомпоновкиДанных(ЭлементСтруктурыПриемник, ЭлементСтруктурыИсточник);
		КонецЦикла;
		
	КонецЕсли;
	
	Если ТипЗнч(НастройкиИсточник) = Тип("ГруппировкаТаблицыКомпоновкиДанных")
	 Или ТипЗнч(НастройкиИсточник) = Тип("ГруппировкаДиаграммыКомпоновкиДанных") Тогда
		
		Для каждого ЭлементСтруктурыИсточник Из НастройкиИсточник.Структура Цикл
			ЭлементСтруктурыПриемник = НастройкиПриемник.Структура.Добавить();
			СкопироватьНастройкиКомпоновкиДанных(ЭлементСтруктурыПриемник, ЭлементСтруктурыИсточник);
		КонецЦикла;
		
	КонецЕсли;
	
	Если ТипЗнч(НастройкиИсточник) = Тип("ТаблицаКомпоновкиДанных") Тогда
		
		Для каждого ЭлементСтруктурыИсточник Из НастройкиИсточник.Строки Цикл
			ЭлементСтруктурыПриемник = НастройкиПриемник.Строки.Добавить();
			СкопироватьНастройкиКомпоновкиДанных(ЭлементСтруктурыПриемник, ЭлементСтруктурыИсточник);
		КонецЦикла;
		
		Для каждого ЭлементСтруктурыИсточник Из НастройкиИсточник.Колонки Цикл
			ЭлементСтруктурыПриемник = НастройкиПриемник.Колонки.Добавить();
			СкопироватьНастройкиКомпоновкиДанных(ЭлементСтруктурыПриемник, ЭлементСтруктурыИсточник);
		КонецЦикла;
		
	КонецЕсли;
	
	Если ТипЗнч(НастройкиИсточник) = Тип("ДиаграммаКомпоновкиДанных") Тогда
		
		Для каждого ЭлементСтруктурыИсточник Из НастройкиИсточник.Серии Цикл
			ЭлементСтруктурыПриемник = НастройкиПриемник.Серии.Добавить();
			СкопироватьНастройкиКомпоновкиДанных(ЭлементСтруктурыПриемник, ЭлементСтруктурыИсточник);
		КонецЦикла;
		
		Для каждого ЭлементСтруктурыИсточник Из НастройкиИсточник.Точки Цикл
			ЭлементСтруктурыПриемник = НастройкиПриемник.Точки.Добавить();
			СкопироватьНастройкиКомпоновкиДанных(ЭлементСтруктурыПриемник, ЭлементСтруктурыИсточник);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Инициализировать компоновщик настроек
//
// Параметры:
//  КомпоновщикНастроек			 - 	КомпоновщикНастроекКомпоновкиДанных - компоновщик,
//									который необходимо инициализировать
//  АдресСхемыКомпоновкиДанных	 - 	Строка - Адрес СКД
//  СозданиеСегмента			 - 	Булево - Признак создания нового сегмента, для очистки настроек по умолчанию
//
Процедура ИнициализироватьКомпоновщикНастроек(КомпоновщикНастроек, АдресСхемыКомпоновкиДанных, 
	СозданиеСегмента = Ложь) Экспорт
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
	
	Попытка
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных));
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	Если СозданиеСегмента Тогда
		СхемаКомпоновкиДанных.НастройкиПоУмолчанию.Отбор.Элементы.Очистить();
	КонецЕсли;
	
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КомпоновщикНастроек.Восстановить();

КонецПроцедуры

// Процедура копирует схему компоновки данных
//
// Параметры:
//  АдресПриемник	 - 	Строка - Адрес скопированной СКД
//  АдресИсточник	 - 	Строка - Адрес копируемой СКД
//
Процедура СкопироватьСхемуКомпоновкиДанных(АдресПриемник, АдресИсточник) Экспорт
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресИсточник);
	
	Если ТипЗнч(СхемаКомпоновкиДанных) = Тип("СхемаКомпоновкиДанных") Тогда
		
		СхемаКомпоновкиДанных = СериализаторXDTO.ПрочитатьXDTO(СериализаторXDTO.ЗаписатьXDTO(СхемаКомпоновкиДанных));
		
	Иначе
		
		СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
		
	КонецЕсли;
	
	Если ЭтоАдресВременногоХранилища(АдресПриемник) Тогда
		
		ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, АдресПриемник);
		
	Иначе
		
		АдресПриемник = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура формирует состав сегмента в фоне
//
// Параметры:
//  Параметры		 - 	Структура - структура данных сегмента:
//						Сегмент - СправочникСсылка.СегментыКонтрагентов, СправочникСсылка.СегментыНоменклатуры	
//  АдресХранилища	 - 	Строка 
//
Процедура СформироватьСоставСегментаВФоне(Параметры, АдресХранилища) Экспорт
	Если ТипЗнч(Параметры.Сегмент) = Тип("СправочникСсылка.СегментыКонтрагентов") Тогда
		Справочники.СегментыКонтрагентов.ОбновитьСоставСегментаПоПравилам(Параметры.Сегмент);
	Иначе
		Справочники.СегментыНоменклатуры.ОбновитьСоставСегментаПоПравилам(Параметры.Сегмент);
	КонецЕсли;
КонецПроцедуры

// Процедура обработчик регламентного задания ФормированиеСоставаСегментовКонтрагентов
//
Процедура ФормированиеСоставаСегментовКонтрагентов() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.ФормированиеСоставаСегментовКонтрагентов);
		
	РегламентноеЗадание = Метаданные.РегламентныеЗадания.ФормированиеСоставаСегментовКонтрагентов;
	ЗаписьЖРПриНачалеРегламентногоЗадания(РегламентноеЗадание);
	
	СформироватьСоставыОбновляемыхСегментовКонтрагентов();
	
	ЗаписьЖРПослеВыполненияРегламентногоЗадания(РегламентноеЗадание);
	
КонецПроцедуры

// Процедура обработчик регламентного задания ФормированиеСоставаСегментовНоменклатуры
//
Процедура ФормированиеСоставаСегментовНоменклатуры() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.ФормированиеСоставаСегментовНоменклатуры);
	РегламентноеЗадание = Метаданные.РегламентныеЗадания.ФормированиеСоставаСегментовНоменклатуры;
	ЗаписьЖРПриНачалеРегламентногоЗадания(РегламентноеЗадание);
	
	СформироватьСоставыОбновляемыхСегментовНоменклатуры();
	
	ЗаписьЖРПослеВыполненияРегламентногоЗадания(РегламентноеЗадание);
	
КонецПроцедуры

// Выполняет сериализацию объекта в XML
//
// Параметры:
//  Значение  - Произвольный - объект, который необходимо сериализовать в XML.
//
// Возвращаемое значение:
//   Строка   - объект, сериализованный в XML.
//
Функция ПолучитьXML(Значение) Экспорт
	
	Запись = Новый ЗаписьXML();
	Запись.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(Запись, Значение);
	Возврат Запись.Закрыть();
	
КонецФункции

// Признак возможности редактирования сегмента контрагентов
//
// Параметры:
//  Сегмент	 - 	СправочникСсылка.СегментыКонтрагентов - проверяемый сегмент
// 
// Возвращаемое значение:
//   Булево - возможность редактирования сегмента контрагентов
//
Функция РазрешеноРедактированиеСегментаКонтрагентов(Сегмент) Экспорт
	
	Если Не ЗначениеЗаполнено(Сегмент) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
	|	АвтоматическиеСкидкиПолучателиСкидкиСегменты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.АвтоматическиеСкидки.ПолучателиСкидкиСегменты КАК АвтоматическиеСкидкиПолучателиСкидкиСегменты
	|ГДЕ
	|	АвтоматическиеСкидкиПолучателиСкидкиСегменты.Получатель = &Сегмент";
	
	Запрос.УстановитьПараметр("Сегмент", Сегмент);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Возврат Ложь;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Признак возможности редактирования сегмента контрагентов
//
// Параметры:
//  Сегмент	 - 	СправочникСсылка.СегментыНоменклатуры - проверяемый сегмент
// 
// Возвращаемое значение:
//   Булево - возможность редактирования сегмента контрагентов
//
Функция РазрешеноРедактированиеСегментаНоменклатуры(Сегмент) Экспорт
	
	Если Не ЗначениеЗаполнено(Сегмент) Тогда
		Возврат Истина;
	КонецЕсли;
		
	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		Возврат Истина;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
	|	АвтоматическиеСкидкиНоменклатураГруппыЦеновыеГруппы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.АвтоматическиеСкидки.НоменклатураГруппыЦеновыеГруппы КАК АвтоматическиеСкидкиНоменклатураГруппыЦеновыеГруппы
	|ГДЕ
	|	АвтоматическиеСкидкиНоменклатураГруппыЦеновыеГруппы.ЗначениеУточнения = &Сегмент
	|	И АвтоматическиеСкидкиНоменклатураГруппыЦеновыеГруппы.ЗначениеУточнения ССЫЛКА Справочник.СегментыНоменклатуры
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
	|	АвтоматическиеСкидкиУсловияПредоставления.Ссылка
	|ИЗ
	|	Справочник.АвтоматическиеСкидки.УсловияПредоставления КАК АвтоматическиеСкидкиУсловияПредоставления
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УсловияПредоставленияСкидокНаценок.ОтборПродажПоСегменту КАК ОтборПродажПоСегменту
	|		ПО АвтоматическиеСкидкиУсловияПредоставления.УсловиеПредоставления = ОтборПродажПоСегменту.Ссылка
	|ГДЕ
	|	ОтборПродажПоСегменту.СегментНоменклатуры = &Сегмент";
	
	Запрос.УстановитьПараметр("Сегмент", Сегмент);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Возврат Ложь;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Процедура определяет видимость отбора по сегменту в быстрых отборах в отчете
//
// Параметры:
//  Форма	 - 	ФормаКлиентскогоПриложения - форма отчета
//
Процедура ОпределитьВидимостьОтбораПоСегментуВОтчете(Форма) Экспорт
	
	НастройкиКД = Форма.Отчет.КомпоновщикНастроек.Настройки;
	ИспользоватьСегментыНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьСегментыНоменклатуры");
	ПараметрСегмент = НастройкиКД.ПараметрыДанных.Элементы.Найти("СегментНоменклатуры");
	
	Если ПараметрСегмент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ИспользоватьСегментыНоменклатуры Тогда
		ПараметрСегмент.ИдентификаторПользовательскойНастройки = "";
		ПараметрСегмент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрСегмент.ИдентификаторПользовательскойНастройки) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрСегмент.ИдентификаторПользовательскойНастройки = Новый УникальныйИдентификатор;
	ПараметрСегмент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписьЖРПриНачалеРегламентногоЗадания(РегламентноеЗадание)
	
	ИмяСобытия = НСтр("ru='СтартРегламентногоЗадания'", ОбщегоНазначения.КодОсновногоЯзыка());
	Комментарий = НСтр("ru='Начало выполнения регламентного задания'");
	ОтразитьХодВыполнения(Комментарий, ИмяСобытия, РегламентноеЗадание);
	
КонецПроцедуры

Процедура СформироватьСоставыОбновляемыхСегментовКонтрагентов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Сегменты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СегментыКонтрагентов КАК Сегменты
	|ГДЕ
	|	Сегменты.Обновляемый";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Попытка
			Справочники.СегментыКонтрагентов.ОбновитьСоставСегментаПоПравилам(Выборка.Ссылка);
		Исключение
			ИмяСобытия = НСтр("ru='Ошибка при формировании состава сегмента контрагентов'", 
				ОбщегоНазначения.КодОсновногоЯзыка());
			Комментарий = НСтр("ru='Формирование сегмента в регламентном задании'");
			УровеньЖР = УровеньЖурналаРегистрации.Ошибка;
			ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖР, Выборка.Ссылка, Выборка.Ссылка, Комментарий);
		КонецПопытки;
	КонецЦикла;
		
КонецПроцедуры

Процедура СформироватьСоставыОбновляемыхСегментовНоменклатуры()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Сегменты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СегментыНоменклатуры КАК Сегменты
	|ГДЕ
	|	Сегменты.Обновляемый";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Попытка
			Справочники.СегментыНоменклатуры.ОбновитьСоставСегментаПоПравилам(Выборка.Ссылка);
		Исключение
			ИмяСобытия = НСтр("ru='Ошибка при формировании состава сегмента номенклатуры'", 
				ОбщегоНазначения.КодОсновногоЯзыка());
			Комментарий = НСтр("ru='Формирование сегмента в регламентном задании'");
			УровеньЖР = УровеньЖурналаРегистрации.Ошибка;
			ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖР, Выборка.Ссылка, Выборка.Ссылка, Комментарий);
		КонецПопытки;
	КонецЦикла;
		
КонецПроцедуры

Процедура ОтразитьХодВыполнения(Комментарий, Знач ВложенноеИмяСобытия = "", 
	ОбъектМетаданных = Неопределено)
	
	Если ВложенноеИмяСобытия = "" Тогда
		ВложенноеИмяСобытия = ИмяСобытияЖР();
	Иначе
		ВложенноеИмяСобытия = ИмяСобытияЖР() + "." + ВложенноеИмяСобытия;
	КонецЕсли;
	
	УровеньЖР = УровеньЖурналаРегистрации.Примечание;
	ЗаписьЖурналаРегистрации(ВложенноеИмяСобытия, УровеньЖР, ОбъектМетаданных, Неопределено, Комментарий);
	
КонецПроцедуры

Функция ИмяСобытияЖР() Экспорт
	
	Возврат НСтр("ru='СегментыКонтрагентов'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

Процедура ЗаписьЖРПослеВыполненияРегламентногоЗадания(РегламентноеЗадание)
	
	ИмяСобытия = НСтр("ru='КонецОбработки'", ОбщегоНазначения.КодОсновногоЯзыка());
	Комментарий = НСтр("ru='Завершение выполнения регламентного задания'");
	ОтразитьХодВыполнения(Комментарий, ИмяСобытия, РегламентноеЗадание);
	
КонецПроцедуры

Процедура СкопироватьЭлементы(ПриемникЗначения, ИсточникЗначения, ПроверятьДоступность = Ложь, 
	ОчищатьПриемник = Истина) Экспорт
	
	Если ТипЗнч(ИсточникЗначения) = Тип("УсловноеОформлениеКомпоновкиДанных")
		ИЛИ ТипЗнч(ИсточникЗначения) = Тип("ВариантыПользовательскогоПоляВыборКомпоновкиДанных")
		ИЛИ ТипЗнч(ИсточникЗначения) = Тип("ОформляемыеПоляКомпоновкиДанных")
		ИЛИ ТипЗнч(ИсточникЗначения) = Тип("ЗначенияПараметровДанныхКомпоновкиДанных") Тогда
		СоздаватьПоТипу = Ложь;
	Иначе
		СоздаватьПоТипу = Истина;
	КонецЕсли;
	ПриемникЭлементов = ПриемникЗначения.Элементы;
	ИсточникЭлементов = ИсточникЗначения.Элементы;
	Если ОчищатьПриемник Тогда
		ПриемникЭлементов.Очистить();
	КонецЕсли;
	
	Для каждого ЭлементИсточник Из ИсточникЭлементов Цикл
		
		Если ТипЗнч(ЭлементИсточник) = Тип("ЭлементПорядкаКомпоновкиДанных") Тогда
			// Элементы порядка добавляем в начало.
			Индекс = ИсточникЭлементов.Индекс(ЭлементИсточник);
			ЭлементПриемник = ПриемникЭлементов.Вставить(Индекс, ТипЗнч(ЭлементИсточник));
		Иначе
			Если СоздаватьПоТипу Тогда
				ЭлементПриемник = ПриемникЭлементов.Добавить(ТипЗнч(ЭлементИсточник));
			Иначе
				ЭлементПриемник = ПриемникЭлементов.Добавить();
			КонецЕсли;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭлементПриемник, ЭлементИсточник);
		// В некоторых коллекциях необходимо заполнить другие коллекции.
		Если ТипЗнч(ИсточникЭлементов) = Тип("КоллекцияЭлементовУсловногоОформленияКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник.Поля, ЭлементИсточник.Поля);
			СкопироватьЭлементы(ЭлементПриемник.Отбор, ЭлементИсточник.Отбор);
			ЗаполнитьЭлементы(ЭлементПриемник.Оформление, ЭлементИсточник.Оформление); 
		ИначеЕсли ТипЗнч(ИсточникЭлементов)	= Тип("КоллекцияВариантовПользовательскогоПоляВыборКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник.Отбор, ЭлементИсточник.Отбор);
		КонецЕсли;
		
		// В некоторых элементах коллекции необходимо заполнить другие коллекции.
		Если ТипЗнч(ЭлементИсточник) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник, ЭлементИсточник);
		ИначеЕсли ТипЗнч(ЭлементИсточник) = Тип("ГруппаВыбранныхПолейКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник, ЭлементИсточник);
		ИначеЕсли ТипЗнч(ЭлементИсточник) = Тип("ПользовательскоеПолеВыборКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник.Варианты, ЭлементИсточник.Варианты);
		ИначеЕсли ТипЗнч(ЭлементИсточник) = Тип("ПользовательскоеПолеВыражениеКомпоновкиДанных") Тогда
			ЭлементПриемник.УстановитьВыражениеДетальныхЗаписей(ЭлементИсточник.ПолучитьВыражениеДетальныхЗаписей());
			ЭлементПриемник.УстановитьВыражениеИтоговыхЗаписей(ЭлементИсточник.ПолучитьВыражениеИтоговыхЗаписей());
			ЭлементПриемник.УстановитьПредставлениеВыраженияДетальныхЗаписей(
				ЭлементИсточник.ПолучитьПредставлениеВыраженияДетальныхЗаписей ());
			ЭлементПриемник.УстановитьПредставлениеВыраженияИтоговыхЗаписей(
				ЭлементИсточник.ПолучитьПредставлениеВыраженияИтоговыхЗаписей ());
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьЭлементы(ПриемникЗначения, ИсточникЗначения, ПервыйУровень = Неопределено)
	
	Если ТипЗнч(ПриемникЗначения) = Тип("КоллекцияЗначенийПараметровКомпоновкиДанных") Тогда
		КоллекцияЗначений = ИсточникЗначения;
	Иначе
		КоллекцияЗначений = ИсточникЗначения.Элементы;
	КонецЕсли;
	
	Для каждого ЭлементИсточник Из КоллекцияЗначений Цикл
		Если ПервыйУровень = Неопределено Тогда
			ЭлементПриемник = ПриемникЗначения.НайтиЗначениеПараметра(ЭлементИсточник.Параметр);
		Иначе
			ЭлементПриемник = ПервыйУровень.НайтиЗначениеПараметра(ЭлементИсточник.Параметр);
		КонецЕсли;
		Если ЭлементПриемник = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭлементПриемник, ЭлементИсточник);
		Если ТипЗнч(ЭлементИсточник) = Тип("ЗначениеПараметраКомпоновкиДанных") Тогда
			Если ЭлементИсточник.ЗначенияВложенныхПараметров.Количество() <> 0 Тогда
				ЗаполнитьЭлементы(ЭлементПриемник.ЗначенияВложенныхПараметров, 
					ЭлементИсточник.ЗначенияВложенныхПараметров, ПриемникЗначения);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

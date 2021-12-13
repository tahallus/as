﻿#Область ПрограммныйИнтерфейс

// Устарела. См. СерииНоменклатурыУНФ.ПолучитьСерииНоменклатурыИзХранилища
// Добавляет Серии номенклатуры в таблицу из хранилища
//
// Параметры:
//  Объект - Данные объекта
//  АдресЗапасовВХранилище - Адрес запасов в хранилище
//  КлючСвязи - Ключ связи строк таблиц
//  ПараметрыИменаПолей - Параметры имен полей таблиц
//
// Возвращаемое значение:
//  Число - Количество измененных полей
//
Функция ПолучитьСерииНоменклатурыИзХранилища(Объект, АдресЗапасовВХранилище, КлючСвязи, ПараметрыИменаПолей=Неопределено) Экспорт
	
	Возврат СерииНоменклатурыУНФ.ПолучитьСерииНоменклатурыИзХранилища(Объект, АдресЗапасовВХранилище, КлючСвязи, ПараметрыИменаПолей);
	
КонецФункции // ПолучитьСерииНоменклатурыИзХранилища()

// Устарела. См. СерииНоменклатурыУНФ.ПолучитьСерииНоменклатурыИзХранилищаДляПоляВвода
// Получает Серии номенклатуры из хранилища для поля ввода
//
// Параметры:
//  Объект - Данные объекта
//  АдресЗапасовВХранилище - Адрес запасов в хранилище
//
// Возвращаемое значение:
//  Число - Количество измененных полей
//
Функция ПолучитьСерииНоменклатурыИзХранилищаДляПоляВвода(Объект, АдресЗапасовВХранилище) Экспорт
	
	Возврат СерииНоменклатурыУНФ.ПолучитьСерииНоменклатурыИзХранилищаДляПоляВвода(Объект, АдресЗапасовВХранилище);
	
КонецФункции // ПолучитьСерииНоменклатурыИзХранилища()

// Устарела. См. СерииНоменклатурыУНФ.ПолучитьСерияИзХранилища
// Получает Серии номенклатуры из хранилища
//
// Параметры:
//  Объект - Данные объекта
//  АдресЗапасовВХранилище - Адрес запасов в хранилище
//
Процедура ПолучитьСерияИзХранилища(Объект, АдресЗапасовВХранилище) Экспорт
	
	СерииНоменклатурыУНФ.ПолучитьСерияИзХранилища(Объект, АдресЗапасовВХранилище);
	
КонецПроцедуры // ПолучитьСерииНоменклатурыИзХранилища()

// Устарела. См. СерииНоменклатурыУНФ.ПараметрыПодбораСерийНоменклатуры
// Определяет параметры подбора серийных номеров
//
// Параметры:
//  ДокОбъект - Данные объекта
//  УИДФормы - Уникальный идентификатор формы
//  ИДСтроки - Идентификатор строки
//  РежимПодбора - режим подбора серийных номеров
//  ИмяТЧ - Имя таблицы подбора
//  ИмяТЧСерийНоменклатуры - Имя таблицы серийных номеров
//  ИмяПоляКлючСвязи - Имя поля ключа связи
//
// Возвращаемое значение:
//  Структура - Параметры подбора
//
Функция ПараметрыПодбораСерийНоменклатуры(ДокОбъект, УИДФормы, ИДСтроки, РежимПодбора = Неопределено, ИмяТЧ = "Запасы", ИмяТЧСерийНоменклатуры = "СерииНоменклатуры", ИмяПоляКлючСвязи = "КлючСвязи",
	ЭтоОприходование = Ложь) Экспорт
	
	Возврат СерииНоменклатурыУНФ.ПараметрыПодбораСерийНоменклатуры(ДокОбъект, УИДФормы, ИДСтроки, РежимПодбора, ИмяТЧ, ИмяТЧСерийНоменклатуры, ИмяПоляКлючСвязи, ЭтоОприходование);
	
КонецФункции

// Устарела. См. СерииНоменклатурыУНФ.ПодготовитьПараметрыСерийНоменклатуры
// Подготавливает параметры серийных номеров
//
// Параметры:
//  ДокОбъект - Данные объекта
//  УИДФормы - Уникальный идентификатор формы
//  ТекСтрокаДанные - Данные текущей строки
//  ИмяТЧ - Имя таблицы подбора
//  ИмяТЧСерийНоменклатуры - Имя таблицы серийных номеров
//  ИмяПоляКлючСвязи - Имя поля ключа связи
//  ЭтоОприходование - Признак операции оприходования
//
// Возвращаемое значение:
//  Структура - Параметры открытия
//
Функция ПодготовитьПараметрыСерийНоменклатуры(ДокОбъект, ТекСтрокаДанные, УИДФормы, ИмяТЧ = "Запасы", ИмяТЧСерийНоменклатуры = "СерииНоменклатуры", ИмяПоляКлючСвязи = "КлючСвязи",
	ЭтоОприходование = Ложь) Экспорт
	
	Возврат СерииНоменклатурыУНФ.ПодготовитьПараметрыСерийНоменклатуры(ДокОбъект, ТекСтрокаДанные, УИДФормы, ИмяТЧ, ИмяТЧСерийНоменклатуры, ИмяПоляКлючСвязи, ЭтоОприходование);
	
КонецФункции

// Устарела. См. СерииНоменклатурыУНФ.ПараметрыПодбораСерийНоменклатурыВПолеВвода
// Параметры подбора серийных номеров для поля ввода
//
// Параметры:
//  ДокОбъект - Данные объекта
//  УИДФормы - Уникальный идентификатор формы
//  РежимПодбора - режим подбора серийных номеров
//
// Возвращаемое значение:
//  Структура - Параметры серийных номеров
//
Функция ПараметрыПодбораСерийНоменклатурыВПолеВвода(ДокОбъект, УИДФормы, РежимПодбора = Неопределено) Экспорт
	
	Возврат СерииНоменклатурыУНФ.ПараметрыПодбораСерийНоменклатурыВПолеВвода(ДокОбъект, УИДФормы, РежимПодбора);
	
КонецФункции

// Устарела. См. СерииНоменклатурыУНФ.ПараметрыПодбораСерийНоменклатурыДляРемонтов
// Параметры подбора серийных номеров для поля ввода
//
// Параметры:
// ДокОбъект - Данные объекта
// УИДФормы - Уникальный идентификатор формы
// РежимПодбора - режим подбора серийных номеров
// 
// Возвращаемое значение:
// Структура - Параметры серийных номеров для ремонтов
Функция ПараметрыПодбораСерийНоменклатурыДляРемонтов(ДокОбъект, УИДФормы, РежимПодбора = Неопределено) Экспорт
	
	Возврат СерииНоменклатурыУНФ.ПараметрыПодбораСерийНоменклатурыДляРемонтов(ДокОбъект, УИДФормы, РежимПодбора);
	
КонецФункции

// Устарела. См. СерииНоменклатурыУНФ.ПолучитьДанныеНоменклатураПриИзменении
// Возвращает структуру данных номенклатуры
//
// Параметры:
//  СтруктураДанные - Заполняемая структура данных
//
// Возвращаемое значение:
//  Структура - Структура данных 
//
Функция ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные) Экспорт

	Возврат СерииНоменклатурыУНФ.ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);
	
КонецФункции

// Устарела. См. СерииНоменклатурыУНФ.РассчитатьСуммуВСтрокеТабличнойЧасти
// Рассчитывает суммы в строке табличной части
//
// Параметры:
//  СтрокаТабличнойЧасти - Строка табличной части
//  СуммаВключаетНДС - Признак включения НДС в сумму строки
//
Процедура РассчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТабличнойЧасти, СуммаВключаетНДС) Экспорт
	
	СерииНоменклатурыУНФ.РассчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТабличнойЧасти, СуммаВключаетНДС);
	
КонецПроцедуры // РассчитатьСуммуВСтрокеТабличнойЧасти()

// Устарела. См. СерииНоменклатурыУНФ.ЗаполнитьКлючиСвязи
// Заполняет ключ связи в строках
//
// Параметры:
//  Объект - Объект данных
//  ИмяТЧ - Имя табличной части
//  ИмяПоляКлючСвязи - Имя поля ключа связи
//
Процедура ЗаполнитьКлючиСвязи(Объект, ИмяТЧ, ИмяПоляКлючСвязи = "КлючСвязи") Экспорт
	
	СерииНоменклатурыУНФ.ЗаполнитьКлючиСвязи(Объект, ИмяТЧ, ИмяПоляКлючСвязи);
	
КонецПроцедуры // ЗаполнитьКлючиСвязиВТабличнойЧастиТовары()

#КонецОбласти

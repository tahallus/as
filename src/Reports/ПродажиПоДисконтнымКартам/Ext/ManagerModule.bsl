﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Вызывается при работе в модели сервиса для получения сведений о предопределенных вариантах отчета.
//
// Возвращаемое значение:
//  Массив из Структура:
//    * Имя           - Строка - имя варианта отчета; например, "Основной";
//    * Представление - Строка - имя варианта отчета; например, НСтр("ru = 'Динамика изменений файлов'").
//
Функция ВариантыНастроек() Экспорт 
	
	Результат = Новый Массив;
	Результат.Добавить(Новый Структура("Имя, Представление", "ПродажиПоДисконтнымКартам", 
		НСтр("ru = 'Продажи по дисконтным картам'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "ПродажиПоДисконтнойКарте", 
		НСтр("ru = 'Продажи по дисконтной карте'")));
	Возврат Результат;
	
КонецФункции

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ПродажиПоДисконтнымКартам, "ПродажиПоДисконтнымКартам");
	Вариант.Описание = НСтр("ru = 'Отчет отображает сведения о продажах по дисконтным картам в суммовом выражении за определенный период времени.'");	
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ПродажиПоДисконтнымКартам, "ПродажиПоДисконтнойКарте");
	Вариант.Описание = НСтр("ru = 'Отчет вызывается из обработки ""Дисконтные карты"" и отображает сведения о продажах по дисконтной карте в суммовом выражении за определенный период времени.'");	
	Вариант.Включен = Ложь;
	Вариант.ВидимостьПоУмолчанию = Ложь;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли
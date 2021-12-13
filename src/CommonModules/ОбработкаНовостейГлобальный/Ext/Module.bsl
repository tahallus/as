﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Новости".
// ОбщийМодуль.ОбработкаНовостейГлобальный.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область РегулярнаяПроверкаНовостейТребующихПрочтения

// Процедура выполняет проверку новостей (Справочник.Новости) при запуске программы
//  на предмет наличия важных и очень важных новостей, требующих особого внимания (прочтения).
//
Процедура ПроверитьВажныеНовостиСВключеннымиНапоминаниями_ПервыйЗапуск() Экспорт

	ПроверитьВажныеНовостиСВключеннымиНапоминаниями();

	ОбработкаНовостейКлиент.ПодключитьОбработчикОповещенияОВажныхИОченьВажныхНовостях();

КонецПроцедуры

// Процедура выполняет регулярную проверку новостей (Справочник.Новости)
//  на предмет наличия глобальных важных и очень важных новостей, требующих особого внимания (прочтения),
//  для дальнейшего показа этих новостей пользователю.
//
Процедура ПроверитьВажныеНовостиСВключеннымиНапоминаниями() Экспорт

	Перем ОченьВажныеНовостиСВключеннымиНапоминаниями, ВажныеНовостиСВключеннымиНапоминаниями, ДополнительныеПараметры, СтандартнаяОбработка;

	Если НЕ ОбработкаНовостейКлиент.РазрешенаРаботаСНовостямиТекущемуПользователю() Тогда
		Возврат;
	КонецЕсли;

	ДополнительныеПараметры = Неопределено;
	СтандартнаяОбработка    = Истина;

	// Возможна ситуация, когда файловую информационную базу долго не открывали и долго не запускались регламентные задачи пересчета отборов.
	// В этом случае подсистема Новости переходит из состояния "Активна" в "ТребуетсяПересчетОтборовПослеДлительногоОжидания".
	// Все подключенные обработчики должны оставаться подключенными, но им поступают пустые списки новостей до тех пор,
	//  пока состояние подсистемы Новости не вернется в "Активна", или пока не пройдет достаточное время.

	// Подготовить список новостей.
	ОбработкаНовостейВызовСервера.ПолучитьНовостиСНапоминаниями(
		ОченьВажныеНовостиСВключеннымиНапоминаниями,
		ВажныеНовостиСВключеннымиНапоминаниями,
		ДополнительныеПараметры,
		СтандартнаяОбработка);

	// Показать новости.
	ОбработкаНовостейКлиентПереопределяемый.ПоказатьВажныеНовостиСВключеннымиНапоминаниями(
		ОченьВажныеНовостиСВключеннымиНапоминаниями,
		ВажныеНовостиСВключеннымиНапоминаниями,
		ДополнительныеПараметры,
		СтандартнаяОбработка);

	Если СтандартнаяОбработка <> Ложь Тогда

		// При просмотре глобальных очень важных новостей, открывать каждую в отдельной форме.
		// При просмотре контекстных очень важных новостей, их можно открывать в одной форме.
		Для каждого ТекущаяНовость Из ОченьВажныеНовостиСВключеннымиНапоминаниями Цикл
			Если НЕ ТекущаяНовость.Новость.Пустая() Тогда
				// Возможна ситуация, когда очень важная новость является ссылкой или на интернет-ресурс или на раздел помощи.
				// Необходимо сбросить признак оповещения в форме новости сразу, т.к. по-другому сбросить этот признак не получится.
				ПараметрыОткрытияФормы = Новый Структура;
				ПараметрыОткрытияФормы.Вставить("ИнициаторОткрытияНовости", "ОченьВажнаяНовость"); // Идентификатор.
				ПараметрыОткрытияФормы.Вставить("НовостьНаименование", ТекущаяНовость.НовостьНаименование); // Заголовок новости.
				ПараметрыОткрытияФормы.Вставить("НовостьКодЛентыНовостей", ТекущаяНовость.НовостьКодЛентыНовостей); // Код ленты новостей.
				ОбработкаНовостейКлиент.ПоказатьНовость(
					ТекущаяНовость.Новость, // НовостьСсылка
					ПараметрыОткрытияФормы, // ПараметрыОткрытияФормы. БлокироватьОкноВладельца не нужно, т.к. неизвестно что будет за владелец
					       // и блокировать первое попавшееся окно неправильно.
					, // ФормаВладелец
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='Автопроверка новостей: %1'"),
						ТекущаяНовость.НовостьУникальныйИдентификатор)); // Отдельная уникальность, не зависит от новостей, открытых из формы списка
			КонецЕсли;
		КонецЦикла;

		Если ВажныеНовостиСВключеннымиНапоминаниями.Количество() > 0 Тогда
			ОбработкаНовостейКлиент.НачатьПоследовательныйПоказВажныхНовостей(ВажныеНовостиСВключеннымиНапоминаниями);
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область КонтекстныеНовости

// Процедура запускает оптимизацию кэша контекстных новостей
//  (глобальной переменной ПараметрыПриложения["ИнтернетПоддержкаПользователей.Новости.КэшКонтекстныхНовостей"])).
//
Процедура ОптимизацияВременногоХранилищаКонтекстныхНовостей() Экспорт

	ОбработкаНовостейКлиент.ОптимизацияКонтекстныхНовостейВКэшеПриложения();

КонецПроцедуры

#КонецОбласти

#Область ПанельКонтекстныхНовостей

// Процедура регулярно оповещает открытые формы о том, что надо "перелистнуть" новость в панели контекстных новостей.
//
Процедура АвтолистаниеВПанелиКонтекстныхНовостей() Экспорт

	ОбработкаНовостейКлиент.ПанельКонтекстныхНовостей_Автолистание();

КонецПроцедуры

// Процедура регулярно оповещает открытые формы о том, что надо заменить анимированную иконку
//  на статичную в панели контекстных новостей.
//
Процедура ВыключениеАнимированныхИконокВПанелиКонтекстныхНовостей() Экспорт

	ОбработкаНовостейКлиент.ПанельКонтекстныхНовостей_ВыключениеАнимированныхИконок();

КонецПроцедуры

// Процедура регулярно проверяет открытые формы и очищает глобальные переменные
//  ПараметрыПриложения["ИнтернетПоддержкаПользователей.Новости.АвтолистаниеДляПанелейКонтекстныхНовостей"]
//  ПараметрыПриложения["ИнтернетПоддержкаПользователей.Новости.АнимированныеИконкиДляПанелейКонтекстныхНовостей"]
//  от устаревших (закрытых форм).
//
Процедура ОптимизацияОбработчиковПанелейКонтекстныхНовостей() Экспорт

	ОбработкаНовостейКлиент.ПанельКонтекстныхНовостей_ОптимизацияОбработчиков();

КонецПроцедуры

#КонецОбласти

#КонецОбласти

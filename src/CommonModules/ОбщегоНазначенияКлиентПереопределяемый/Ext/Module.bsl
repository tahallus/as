﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняется перед интерактивным началом работы пользователя с областью данных или в локальном режиме.
// Соответствует обработчику ПередНачаломРаботыСистемы.
//
// Параметры:
//  Параметры - Структура:
//   * Отказ         - Булево - возвращаемое значение. Если установить Истина, то работа программы будет прекращена.
//   * Перезапустить - Булево - возвращаемое значение. Если установить Истина, и параметр Отказ тоже установлен
//                              в Истина, то выполняется перезапуск программы.
// 
//   * ДополнительныеПараметрыКоманднойСтроки - Строка - возвращаемое значение. Имеет смысл, когда Отказ
//                              и Перезапустить установлены Истина.
//
//   * ИнтерактивнаяОбработка - ОписаниеОповещения - возвращаемое значение. Для открытия окна, блокирующего вход в
//                              программу, следует присвоить в этот параметр описание обработчика
//                              оповещения, который открывает окно. Смотри пример ниже.
//
//   * ОбработкаПродолжения   - ОписаниеОповещения - если открывается окно, блокирующее вход в программу, то в обработке
//                              закрытия этого окна необходимо выполнить оповещение ОбработкаПродолжения. Смотри пример ниже.
//
//   * Модули                 - Массив - ссылки на модули, в которых нужно вызвать эту же процедуру после возврата.
//                              Модули можно добавлять только в рамках вызова в процедуру переопределяемого модуля.
//                              Используется для упрощения реализации нескольких последовательных асинхронных вызовов
//                              в разные подсистемы. См. пример ИнтеграцияПодсистемБСПКлиент.ПередНачаломРаботыСистемы.
//
// Пример:
//  Следующий код открывает окно, блокирующее вход в программу.
//
//		Если ОткрытьОкноПриЗапуске Тогда
//			Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения("ОткрытьОкно", ЭтотОбъект);
//		КонецЕсли;
//
//	Процедура ОткрытьОкно(Параметры, ДополнительныеПараметры) Экспорт
//		// Показываем окно, по закрытию которого вызывается обработчик оповещения ОткрытьОкноЗавершение.
//		Оповещение = Новый ОписаниеОповещения("ОткрытьОкноЗавершение", ЭтотОбъект, Параметры);
//		Форма = ОткрытьФорму(... ,,, ... Оповещение);
//		Если Не Форма.Открыта() Тогда // Если ПриСозданииНаСервере Отказ установлен Истина.
//			ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
//		КонецЕсли;
//	КонецПроцедуры
//
//	Процедура ОткрытьОкноЗавершение(Результат, Параметры) Экспорт
//		...
//		ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
//		
//	КонецПроцедуры
//
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	Возврат;
КонецПроцедуры

// Выполняется при интерактивном начале работы пользователя с областью данных или в локальном режиме.
// Соответствует обработчику ПриНачалеРаботыСистемы.
//
// Параметры:
//  Параметры - Структура:
//   * Отказ         - Булево - возвращаемое значение. Если установить Истина, то работа программы будет прекращена.
//   * Перезапустить - Булево - возвращаемое значение. Если установить Истина и параметр Отказ тоже установлен
//                              в Истина, то выполняется перезапуск программы.
//
//   * ДополнительныеПараметрыКоманднойСтроки - Строка - возвращаемое значение. Имеет смысл
//                              когда Отказ и Перезапустить установлены Истина.
//
//   * ИнтерактивнаяОбработка - ОписаниеОповещения - возвращаемое значение. Для открытия окна, блокирующего вход
//                              в программу, следует присвоить в этот параметр описание обработчика оповещения,
//                              который открывает окно. См. пример в ПередНачаломРаботыСистемы.
//
//   * ОбработкаПродолжения   - ОписаниеОповещения - если открывается окно, блокирующее вход в программу, то в
//                              обработке закрытия этого окна необходимо выполнить оповещение ОбработкаПродолжения.
//                              См. пример в ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы.
//
//   * Модули                 - Массив - ссылки на модули, в которых нужно вызвать эту же процедуру после возврата.
//                              Модули можно добавлять только в рамках вызова в процедуру переопределяемого модуля.
//                              Используется для упрощения реализации нескольких последовательных асинхронных вызовов
//                              в разные подсистемы. См. пример ИнтеграцияПодсистемБСПКлиент.ПередНачаломРаботыСистемы.
//
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыРаботыКлиента.Свойство("ПоказатьОкноНачалоРаботыСПрограммой")
		И ПараметрыРаботыКлиента.ПоказатьОкноНачалоРаботыСПрограммой = Истина Тогда
		
		НачалоРаботыСПрограммойСервер.УстановитьИнтерфейсНачалаРаботы();
		ОбновитьИнтерфейс();
		
	Иначе
		
		Если ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
			
			#Если Не ТолстыйКлиентОбычноеПриложение Тогда
			// Установка заголовка приложения с курсами валют.
			ПодключитьОбработчикОповещения("ИзменениеДанныхДляЗаголовкаПриложенияОбработкаОповещения");
			ПодключитьОбработчикОповещения("ПодключаемоеОборудованиеОбработкаОповещения");
			#КонецЕсли
			
			// Установка состава форм рабочего стола по умолчанию
			ТребуетсяОбновлениеИнтерфейса = Ложь;
			Если ПараметрыРаботыКлиента.ТребуетсяУстановитьРабочийСтолПользователяУНФ Тогда
				РабочийСтолУНФВызовСервера.УстановитьРабочийСтолПользователя(ТребуетсяОбновлениеИнтерфейса);
			КонецЕсли;
			//МобильноеПриложениеВызовСервера.ПередНачаломРаботыКлиента(ТребуетсяОбновлениеИнтерфейса);
			Если ПараметрыРаботыКлиента.Свойство("УстановленСоставФормТребуетсяОбновлениеИнтерфейса")
				И ПараметрыРаботыКлиента.УстановленСоставФормТребуетсяОбновлениеИнтерфейса = Истина Тогда
				ТребуетсяОбновлениеИнтерфейса = Истина;
			КонецЕсли;
			Если ТребуетсяОбновлениеИнтерфейса Тогда
				ОбновитьИнтерфейс();
			КонецЕсли;
		КонецЕсли;
		
		РабочееМестоКассираКлиент.ПриНачалеРаботыСистемы(Параметры);
		
		// ИнтернетПоддержкаПользователей
		ИнтернетПоддержкаПользователейКлиент.ПриНачалеРаботыСистемы(Параметры);
		// Конец ИнтернетПоддержкаПользователей
		
		// Маг1С
		Маг1СКлиент.ПриНачалеРаботыСистемы();
		// Конец Маг1С
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается для обработки собственных параметров запуска программы,
// передаваемых с помощью ключа командной строки /C, например: 1cv8.exe ... /CРежимОтладки;ОткрытьИЗакрыть.
//
// Параметры:
//  ПараметрыЗапуска  - Массив - массив строк разделенных символом ";" в параметре запуска,
//                      переданным в конфигурацию с помощью ключа командной строки /C.
//  Отказ             - Булево - если установить Истина, то запуск будет прерван.
//
Процедура ПриОбработкеПараметровЗапуска(ПараметрыЗапуска, Отказ) Экспорт
	Возврат;
КонецПроцедуры

// Выполняется при интерактивном начале работы пользователя с областью данных или в локальном режиме.
// Вызывается после завершения действий ПриНачалеРаботыСистемы.
// Используется для подключения обработчиков ожидания, которые не должны вызываться
// в случае интерактивных действий перед и при начале работы системы.
//
// Начальная страница (рабочий стол) в этот момент еще не открыта, поэтому запрещено открывать
// формы напрямую, а следует использовать для этих целей обработчик ожидания.
// Запрещено использовать это событие для интерактивного взаимодействия с пользователем
// (ПоказатьВопрос и аналогичные действия). Для этих целей следует размещать код в процедуре ПриНачалеРаботыСистемы.
//
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		
		Если НЕ ПараметрыРаботыКлиента.ПоказатьОкноНачалоРаботыСПрограммой Тогда
			
			// Регламентированная отчетность
			ДокументооборотСКОКлиент.ПослеЗапускаСистемы();
			// Конец Регламентированная отчетность
			
			// ЕГАИС
			ИнтеграцияЕГАИСКлиент.ПодключитьОбработчикВыполненияОбменаНаКлиентеПоРасписанию();
			// Конец ЕГАИС
			
			// ЭлектронноеВзаимодействие
			ЭлектронноеВзаимодействиеКлиент.ПослеНачалаРаботыСистемы();
			// Конец ЭлектронноеВзаимодействие
			
			#Если НЕ ТолстыйКлиентОбычноеПриложение Тогда
				
				ТелефонияКлиент.ПослеНачалаРаботыСистемы(ПараметрыРаботыКлиента);
				АссистентУправленияКлиент.ПослеНачалаРаботыСистемы(ПараметрыРаботыКлиента);
				ГлобальныйПоискКлиент.ПослеНачалаРаботыСистемы();
				ЗадачиСотрудникаКлиент.ПослеНачалаРаботыСистемы();
				
			#КонецЕсли
			
			// Кабинет клиента
			НастройкиПубликацииМЛККлиент.ПослеНачалаРаботыСистемы();
			// Конец Кабинет клиента
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняется перед интерактивном завершении работы пользователя с областью данных или в локальном режиме.
// Соответствует обработчику ПередЗавершениемРаботыСистемы.
// Позволяет определить список предупреждений, выводимых пользователю перед завершением работы.
//
// Параметры:
//  Отказ          - Булево - если установить данному параметру значение Истина, то работа с программой не будет 
//                            завершена.
//  Предупреждения - Массив из см. СтандартныеПодсистемыКлиент.ПредупреждениеПриЗавершенииРаботы - 
//                            можно добавить сведения о внешнем виде предупреждения и дальнейших действиях.
//
Процедура ПередЗавершениемРаботыСистемы(Отказ, Предупреждения) Экспорт
	
	Если НЕ Отказ Тогда
		// ПодключаемоеОборудование
		МенеджерОборудованияКлиент.ПередЗавершениемРаботыСистемы();
		// Конец ПодключаемоеОборудование
	КонецЕсли;
	
КонецПроцедуры

// Позволяет переопределить заголовок программы.
//
// Параметры:
//  ЗаголовокПриложения - Строка - текст заголовка программы;
//  ПриЗапуске          - Булево - Истина, если вызывается при начале работы программы.
//                                 В этом случае недопустимо вызывать те серверные функции конфигурации,
//                                 которые рассчитывают на то, что запуск уже полностью завершен. 
//                                 Например, вместо СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента
//                                 следует вызывать СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске. 
//
// Пример:
//  Для того чтобы в начале заголовка программы вывести название текущего проекта, следует определить параметр 
//  ТекущийПроект в процедуре ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиента и вписать код:
//
//  Если ПриЗапуске Тогда
//    Возврат;
//  КонецЕсли;
//  ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента();
//  ТекущийПроект = Неопределено;	
//  Если ПараметрыКлиента.ДоступноИспользованиеРазделенныхДанных И ПараметрыКлиента.Свойство("ТекущийПроект", ТекущийПроект) 
//	  И Не ПараметрыКлиента.ТекущийПроект.Пустая() Тогда
//	  ЗаголовокПриложения = Строка(ПараметрыКлиента.ТекущийПроект) + " / " + ЗаголовокПриложения;
//  КонецЕсли;
//
Процедура ПриУстановкеЗаголовкаКлиентскогоПриложения(ЗаголовокПриложения, ПриЗапуске) Экспорт
	ВалютыУНФКлиент.ПриУстановкеЗаголовкаКлиентскогоПриложения(ЗаголовокПриложения, ПриЗапуске);
КонецПроцедуры

#КонецОбласти

#Область СлужебныйИнтерфейсУНФ

// Устарела. Будет удалена в следующей версии программы.
// См. ОбщегоНазначенияУНФКлиент.ПоказатьФормуРедактированияРеквизита
//
Процедура ПоказатьФормуРедактированияРеквизита(Знач МногострочныйТекст, Знач ФормаВладелец, Знач ПоляРеквизита, 
	Знач Заголовок) Экспорт
	
	ДополнительныеПараметры = Новый Структура("ФормаВладелец, ПоляРеквизита", ФормаВладелец, ПоляРеквизита);
	Оповещение = Новый ОписаниеОповещения("РеквизитЗавершениеВвода", ЭтотОбъект, ДополнительныеПараметры);
	ПоказатьФормуРедактированияМногострочногоТекста(Оповещение, МногострочныйТекст, Заголовок);
	
КонецПроцедуры

// Устарела. Будет удалена в следующей версии программы.
//
Процедура ПоказатьФормуРедактированияМногострочногоТекста(Знач ОповещениеОЗакрытии, 
	Знач МногострочныйТекст, Знач Заголовок = Неопределено) Экспорт
	
	ПоказатьВводСтроки(ОповещениеОЗакрытии, МногострочныйТекст, Заголовок,, Истина);
	
КонецПроцедуры

// Устарела. Будет удалена в следующей версии программы.
//
Процедура РеквизитЗавершениеВвода(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
	
	Если ВведенныйТекст = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ПутьКРеквизитуФормыПоТипам = ДополнительныеПараметры.ПоляРеквизита;
	ДополнительныеПараметры.ФормаВладелец[ПутьКРеквизитуФормыПоТипам.Объект][ПутьКРеквизитуФормыПоТипам.ТабЧасть][ПутьКРеквизитуФормыПоТипам.НомерСтроки][ПутьКРеквизитуФормыПоТипам.ИмяРеквизита] = ВведенныйТекст;
	ДополнительныеПараметры.ФормаВладелец.Модифицированность = Истина;
	#Если ВебКлиент ИЛИ МобильныйКлиент Тогда
	ДополнительныеПараметры.ФормаВладелец.ОбновитьОтображениеДанных();
	#КонецЕсли 
	
КонецПроцедуры

#КонецОбласти
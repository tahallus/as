﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Параметры.Свойство("Идентификатор", Идентификатор);
	Параметры.Свойство("ДрайверОборудования", ДрайверОборудования);
	
	Заголовок = НСтр("ru='Оборудование:'") + Символы.НПП  + Строка(Идентификатор);
	
	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветОшибки = ЦветаСтиля.ЦветОтрицательногоЧисла;

	СписокПорт = Элементы.Порт.СписокВыбора;
	СписокПорт.Добавить(0, НСтр("ru='<Клавиатура>'"));
	Для Номер = 1 По 64 Цикл
		СписокПорт.Добавить(Номер, "COM" + Формат(Номер, "ЧЦ=2; ЧДЦ=0; ЧН=0; ЧГ=0"));
	КонецЦикла;

	СписокСкорость = Элементы.Скорость.СписокВыбора;
	СписокСкорость.Добавить(110,    "110");
	СписокСкорость.Добавить(300,    "300");
	СписокСкорость.Добавить(600,    "600");
	СписокСкорость.Добавить(1200,   "1200");
	СписокСкорость.Добавить(2400,   "2400");
	СписокСкорость.Добавить(4800,   "4800");
	СписокСкорость.Добавить(9600,   "9600");
	СписокСкорость.Добавить(14400,  "14400");
	СписокСкорость.Добавить(19200,  "19200");
	СписокСкорость.Добавить(38400,  "38400");
	СписокСкорость.Добавить(56000,  "56000");
	СписокСкорость.Добавить(57600,  "57600");
	СписокСкорость.Добавить(115200, "115200");
	СписокСкорость.Добавить(128000, "128000");
	СписокСкорость.Добавить(256000, "256000");

	СписокБитДанных = Элементы.БитДанных.СписокВыбора;
	Для Индекс = 1 По 8 Цикл
		СписокБитДанных.Добавить(Индекс, СокрЛП(Индекс));
	КонецЦикла;

	СписокСтопБит = Элементы.СтопБит.СписокВыбора;
	СписокСтопБит.Добавить(0, НСтр("ru='1 стоп-бит'"));
	СписокСтопБит.Добавить(1, НСтр("ru='1.5 стоп-бита'"));
	СписокСтопБит.Добавить(2, НСтр("ru='2 стоп-бита'"));
	
	СписокКодировка = Элементы.COMКодировка.СписокВыбора;
	СписокКодировка.Добавить("UTF-8");
	СписокКодировка.Добавить("Windows-1251");

	времПорт      = Неопределено;
	времСкорость  = Неопределено;
	времБитДанных = Неопределено;
	времСтопБит   = Неопределено;
	времПрефикс   = Неопределено;
	времСуффикс   = Неопределено;
	времТаймаут   = Неопределено;
	времТаймаутCOM   = Неопределено;
	времCOMКодировка = Неопределено;
	
	Параметры.ПараметрыОборудования.Свойство("Порт",      времПорт);
	Параметры.ПараметрыОборудования.Свойство("Скорость",  времСкорость);
	Параметры.ПараметрыОборудования.Свойство("БитДанных", времБитДанных);
	Параметры.ПараметрыОборудования.Свойство("СтопБит",   времСтопБит);
	Параметры.ПараметрыОборудования.Свойство("Префикс",   времПрефикс);
	Параметры.ПараметрыОборудования.Свойство("Суффикс",   времСуффикс);
	Параметры.ПараметрыОборудования.Свойство("Таймаут",   времТаймаут);
	Параметры.ПараметрыОборудования.Свойство("ТаймаутCOM",   времТаймаутCOM);
	Параметры.ПараметрыОборудования.Свойство("COMКодировка", времCOMКодировка);
	
	Порт        = ?(времПорт      = Неопределено,         1, времПорт);
	Скорость    = ?(времСкорость  = Неопределено,      9600, времСкорость);
	БитДанных   = ?(времБитДанных = Неопределено,         8, времБитДанных);
	СтопБит     = ?(времСтопБит   = Неопределено,         0, времСтопБит);
	Префикс	    = ?(времПрефикс   = Неопределено,         "", времПрефикс);
	Суффикс     = ?(времСуффикс   = Неопределено,      "#13", времСуффикс);
	Таймаут     = ?(времТаймаут   = Неопределено,        75, времТаймаут);
	ТаймаутCOM   = ?(времТаймаутCOM   = Неопределено,       5, времТаймаутCOM);
	COMКодировка = ?(времCOMКодировка = Неопределено, "UTF-8", времCOMКодировка);
	
	Элементы.ТестУстройства.Видимость = (ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто);
	Элементы.УстановитьДрайвер.Видимость = (ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьИнформациюОДрайвере();
	
	НастроитьЭлементыУправления();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПортПриИзменении()
	
	НастроитьЭлементыУправления();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокВыбора(ЭлементУправления, Реквизит)
	
	СписокВыбора = ЭлементУправления.СписокВыбора;
	СписокВыбора.Очистить();
    РеквизитВСписке = Ложь;
	Для КодЭлемента = 0 По 127 Цикл
		Символ = "";
		Если КодЭлемента > 32 Тогда
			Символ = " ( " + Символ(КодЭлемента) + " )";
		ИначеЕсли КодЭлемента = 8 Тогда
			Символ = " (BACKSPACE)";
		ИначеЕсли КодЭлемента = 9 Тогда
			Символ = " (TAB)";
		ИначеЕсли КодЭлемента = 10 Тогда
			Символ = " (LF)";
		ИначеЕсли КодЭлемента = 13 Тогда
			Символ = " (CR)";
		ИначеЕсли КодЭлемента = 16 Тогда
			Символ = " (SHIFT)";
		ИначеЕсли КодЭлемента = 17 Тогда
			Символ = " (CONTROL)";
		ИначеЕсли КодЭлемента = 18 Тогда
			Символ = " (ALT)";
		ИначеЕсли КодЭлемента = 27 Тогда
			Символ = " (ESCAPE)";
		ИначеЕсли КодЭлемента = 32 Тогда
			Символ = " (SPACE)";
		КонецЕсли;
		СписокВыбора.Добавить("#" + СокрЛП(КодЭлемента), "#" + СокрЛП(КодЭлемента) + Символ);
		Если Реквизит = "#" + СокрЛП(КодЭлемента) Тогда
			РеквизитВСписке = Истина;
		КонецЕсли;
	КонецЦикла;
	Если Не РеквизитВСписке Тогда
		СписокВыбора.Добавить(Реквизит);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокСуффиксов()
	
	Элементы.Суффикс.СписокВыбора.Очистить();
	Элементы.Суффикс.СписокВыбора.Добавить("8", "(8) BS");
	Элементы.Суффикс.СписокВыбора.Добавить("9", "(9) TAB");
	Элементы.Суффикс.СписокВыбора.Добавить("10","(10) LF");
	Элементы.Суффикс.СписокВыбора.Добавить("13","(13) CR");
	
КонецПроцедуры

&НаКлиенте
Процедура ПрефиксОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Порт=0 Тогда
		СтандартнаяОбработка = Ложь;
		Если ВыбранноеЗначение <> Неопределено Тогда
			Элемент.СписокВыбора.Добавить(Префикс + ВыбранноеЗначение);
			Префикс = Префикс + ВыбранноеЗначение;
		КонецЕсли;
	Иначе
		СтандартнаяОбработка = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СуффиксОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Порт=0  Тогда
		СтандартнаяОбработка = Ложь;
		Если ВыбранноеЗначение <> Неопределено Тогда
			Элемент.СписокВыбора.Добавить(Суффикс + ВыбранноеЗначение);
			Суффикс = Суффикс + ВыбранноеЗначение;
		КонецЕсли;
	Иначе
		СтандартнаяОбработка = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	НовыеЗначениеПараметров = Новый Структура;
	НовыеЗначениеПараметров.Вставить("Порт"      , Порт);
	НовыеЗначениеПараметров.Вставить("Скорость"  , Скорость);
	НовыеЗначениеПараметров.Вставить("БитДанных" , БитДанных);
	НовыеЗначениеПараметров.Вставить("СтопБит"   , СтопБит);
	НовыеЗначениеПараметров.Вставить("Префикс"   , Префикс);
	НовыеЗначениеПараметров.Вставить("Суффикс"   , Суффикс);
	НовыеЗначениеПараметров.Вставить("Таймаут"   , Таймаут);
	НовыеЗначениеПараметров.Вставить("ТаймаутCOM"   , ТаймаутCOM);
	НовыеЗначениеПараметров.Вставить("COMКодировка" , COMКодировка);
	
	Результат = Новый Структура;
	Результат.Вставить("Идентификатор", Идентификатор);
	Результат.Вставить("ПараметрыОборудования", НовыеЗначениеПараметров);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)
	
	ОчиститьСообщения();
	
	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"     , Порт);
	времПараметрыУстройства.Вставить("Скорость" , Скорость);
	времПараметрыУстройства.Вставить("БитДанных", БитДанных);
	времПараметрыУстройства.Вставить("СтопБит"  , СтопБит);
	времПараметрыУстройства.Вставить("Префикс"  , Префикс);
	времПараметрыУстройства.Вставить("Суффикс"  , Суффикс);
	времПараметрыУстройства.Вставить("Таймаут"  , Таймаут);
	времПараметрыУстройства.Вставить("ТаймаутCOM"   , ТаймаутCOM);
	времПараметрыУстройства.Вставить("COMКодировка" , COMКодировка);
	
	Результат = МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("CheckHealth",
	                                                                      ВходныеПараметры,
	                                                                      ВыходныеПараметры,
	                                                                      Идентификатор,
	                                                                      времПараметрыУстройства);
	  
	времПараметрыУстройства.Свойство("Таймаут"    , Таймаут);
	времПараметрыУстройства.Свойство("ТаймаутCOM" , ТаймаутCOM);
 
	Если Не Результат Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ВыходныеПараметры[1] + "(" + НСтр("ru='Код ошибки:'") + ВыходныеПараметры[0] + ")");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьДрайверИзАрхиваПриЗавершении(Результат) Экспорт 
	
	ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Установка драйвера завершена.'")); 
	ОбновитьИнформациюОДрайвере();
	
КонецПроцедуры 

&НаКлиенте
Процедура УстановитьДрайверИзДистрибутиваПриЗавершении(Результат, Параметры) Экспорт 
	
	Если Результат Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Установка драйвера завершена.'")); 
		ОбновитьИнформациюОДрайвере();
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='При установке драйвера из дистрибутива произошла ошибка.'")); 
	КонецЕсли;

КонецПроцедуры 

&НаКлиенте
Процедура УстановитьДрайвер(Команда)

	ОчиститьСообщения();
	ОповещенияДрайверИзДистрибутиваПриЗавершении = Новый ОписаниеОповещения("УстановитьДрайверИзДистрибутиваПриЗавершении", ЭтотОбъект);
	ОповещенияДрайверИзАрхиваПриЗавершении = Новый ОписаниеОповещения("УстановитьДрайверИзАрхиваПриЗавершении", ЭтотОбъект);
	МенеджерОборудованияКлиент.УстановитьДрайвер(ДрайверОборудования, ОповещенияДрайверИзДистрибутиваПриЗавершении, ОповещенияДрайверИзАрхиваПриЗавершении);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НастроитьЭлементыУправления()
	
	// Настроить элементы управления согласно версии драйвера.
	Если Порт = 0 Тогда
		Элементы.Скорость.Доступность  = Ложь;
		Элементы.БитДанных.Доступность = Ложь;
		Элементы.СтопБит.Доступность   = Ложь;
		Элементы.ТаймаутCOM.Доступность   = Ложь;
		Элементы.COMКодировка.Доступность   = Ложь;
		Если Порт = 0 Тогда
			Элементы.Таймаут.Доступность   = Истина;
			Элементы.Префикс.Доступность   = Истина;
			Элементы.Префикс.КнопкаОчистки = Истина;
			Префикс = СПВНомер(Префикс);
			ЗаполнитьСписокВыбора(Элементы.Префикс, Префикс);
			Элементы.Суффикс.КнопкаОчистки = Истина;
			Суффикс = СПВНомер(Суффикс);
			ЗаполнитьСписокВыбора(Элементы.Суффикс, Суффикс);
		Иначе	
			Элементы.Таймаут.Доступность   = Ложь;
		    Элементы.Префикс.КнопкаОчистки = Ложь;
			Элементы.Префикс.Доступность = Ложь;
			Элементы.Суффикс.КнопкаОчистки = Ложь;
			Суффикс = СПВТекст(Суффикс);
			ЗаполнитьСписокСуффиксов();
		КонецЕсли;
	Иначе
		Элементы.Скорость.Доступность  = Истина;
		Элементы.БитДанных.Доступность = Истина;
		Элементы.СтопБит.Доступность   = Истина;
		Элементы.ТаймаутCOM.Доступность   = Истина;
		Элементы.COMКодировка.Доступность = Истина;
		Элементы.Таймаут.Доступность   = Ложь;
		Элементы.Таймаут.Доступность   = Ложь;
	    Элементы.Префикс.КнопкаОчистки = Ложь;
		Элементы.Префикс.Доступность   = Ложь;
		Элементы.Суффикс.КнопкаОчистки = Ложь;
		Суффикс = СПВТекст(Суффикс);
		ЗаполнитьСписокСуффиксов();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере()

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"     , Порт);
	времПараметрыУстройства.Вставить("Скорость" , Скорость);
	времПараметрыУстройства.Вставить("БитДанных", БитДанных);
	времПараметрыУстройства.Вставить("СтопБит"  , СтопБит);
	времПараметрыУстройства.Вставить("Префикс"  , Префикс);
	времПараметрыУстройства.Вставить("Суффикс"  , Суффикс);
	времПараметрыУстройства.Вставить("Таймаут"  , Таймаут);
	
	Если МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("ПолучитьВерсиюДрайвера",
	                                                               ВходныеПараметры,
	                                                               ВыходныеПараметры,
	                                                               Идентификатор,
	                                                               времПараметрыУстройства) Тогда
		Драйвер        = ВыходныеПараметры[0];
		Версия         = ВыходныеПараметры[1];
		ВерсияИзБПО    = ВыходныеПараметры[2];
		ВерсияСтр      = ВыходныеПараметры[3];
		ВерсияИзБПОСтр = ВыходныеПараметры[4];
		
		// Проверка на соответствие номера версии драйвера в БПО и номера, который сообщает сам драйвер.
		Если ВерсияИзБПОСтр > ВерсияСтр Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Установленная на компьютере версия драйвера устарела. Необходимо обновление до версии:'") + Символы.НПП + ВерсияИзБПО);
		КонецЕсли;
		
	Иначе
		Драйвер        = ВыходныеПараметры[2];
		Версия         = НСтр("ru='Не определена'");
		ВерсияСтр      = 8000000;
		ВерсияИзБПОСтр = 8000000;
	КонецЕсли;

	Элементы.Драйвер.ЦветТекста = ?(Драйвер = НСтр("ru='Не установлен'"), ЦветОшибки, ЦветТекста);
	Элементы.Версия.ЦветТекста  = ?(Версия  = НСтр("ru='Не определена'"), ЦветОшибки, ЦветТекста);
	
	Элементы.ТестУстройства.Доступность = (Драйвер = НСтр("ru='Установлен'"));
	Элементы.УстановитьДрайвер.Доступность = Не (Драйвер = НСтр("ru='Установлен'"));
	
КонецПроцедуры

// Функция преобразует суффикс/префикс из нового формата #13#10 в старый формат #10
// старый формат передается без изменений.
//
&НаКлиенте
Функция СПВТекст(Номер) 
	Результат = Номер;	
	ПервоеВхождение = Найти(Результат, "#");
	Если ПервоеВхождение = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	Врем = Сред(Результат, ПервоеВхождение+1);
	ВтороеВхождение = Найти(Врем, "#") + ПервоеВхождение;
	
	Если ВтороеВхождение > ПервоеВхождение Тогда
		Результат = Сред(Результат, ВтороеВхождение);
	КонецЕсли;
	
	Если Результат = "#8" Тогда
		Результат = "8";
	ИначеЕсли Результат = "#9" Тогда
		Результат = "9";
	ИначеЕсли Результат = "#10" Тогда
		Результат = "10";
	ИначеЕсли Результат = "#13" Тогда
		Результат = "13";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Функция преобразует единичный суффикс/префикс из формата "9" в формат "#9"
// для преобразования значений из старых конфигураций, и оставляет, как есть для новых конфигураций.
//
&НаКлиенте
Функция СПВНомер(КодСимвола) 
	Результат=КодСимвола;	
	Если КодСимвола = "8" Тогда
		Результат = "#8";
	ИначеЕсли КодСимвола = "9" Тогда
		Результат = "#9";
	ИначеЕсли КодСимвола = "10" Тогда
		Результат = "#10";
	ИначеЕсли КодСимвола = "13" Тогда
		Результат = "#13";
	КонецЕсли;
	Возврат Результат;
КонецФункции

#КонецОбласти
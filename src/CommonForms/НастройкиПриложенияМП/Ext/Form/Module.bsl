﻿
#Область ВспомогательныеПроцедурыИФункции

&НаСервере
Процедура ПрочитатьКонстанты()
	
	Набор = Константы.СоздатьНабор("НазваниеОрганизацииМП, ТелефонОрганизацииМП, АдресЭПОрганизацииМП, АдресОрганизацииМП, ПлатежныеРеквизитыМП, ИННМП, КППМП, ФИОРуководителяМП, ФИОБухгалтераМП, СистемаНалогообложенияМП, ВариантРазделителяCSVМП");
	Набор.Прочитать();
	ЗначениеВРеквизитФормы(Набор, "НаборКонстант");
	
	Если НЕ ЗначениеЗаполнено(НаборКонстант.ВариантРазделителяCSVМП) Тогда
		НаборКонстант.ВариантРазделителяCSVМП = Перечисления.ВариантыРазделителейCSVМП.Авто;
	КонецЕсли;
	
	#Если МобильноеПриложениеСервер Тогда
		
		КодДоступаВключен = ЗначениеЗаполнено(ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьЗначениеКонстанты("КодДоступа"));
		КонтактнаяКнига =  ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьЗначениеКонстанты("ИспользоватьСинхронизациюСКонтактнойКнигой");
		КонтролироватьОстатки = НЕ ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьЗначениеКонстанты("НеКонтролироватьОстаткиМП");
		БыстрыйПодборТоваров = ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьЗначениеКонстанты("ИспользоватьБыстрыйПодборТоваровМП");
		РежимРаботы = ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьЗначениеКонстанты("РежимРаботыПриложения");
		НалоговыйКалендарь = ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьЗначениеКонстанты("ИспользоватьНалоговыйКалендарь");
		
	#Иначе
		КонтролироватьОстатки = НЕ ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьЗначениеКонстанты("НеКонтролироватьОстаткиМП");
		БыстрыйПодборТоваров = ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьЗначениеКонстанты("ИспользоватьБыстрыйПодборТоваровМП");
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьКонстанты()
	
	УстановитьПривилегированныйРежим(Истина);
	Набор = РеквизитФормыВЗначение("НаборКонстант");
	Набор.Записать();
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеАвторизации()
	
	#Если МобильноеПриложениеСервер Тогда
		
		ИмяПользователя = ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("ПользовательЦентральнойБазы");
		СоединениеСЦБУстановлено = ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("СоединениеСЦБУстановлено");
		Если СоединениеСЦБУстановлено Тогда
			Элементы.ПодключитьсяОтключиться.Заголовок = НСтр("ru='Настройки подключения';en='Synchronization Settings'");
		Иначе
			ИмяПользователя = НСтр("ru='Не подключен';en='Not sync'");
			Элементы.ПодключитьсяОтключиться.Заголовок = НСтр("ru='Подключиться к сервису';en='Synchronize'");
		КонецЕсли;
		
		// АПК:488-выкл методы безопасного запуска обеспечиваются этой функцией
		МодульОбменМобильноеПриложениеВызовСервера = Вычислить("ОбменМобильноеПриложениеВызовСервера");
		// АПК:488-вкл
		Если ТипЗнч(МодульОбменМобильноеПриложениеВызовСервера) = Тип("ОбщийМодуль") Тогда
			
			Если МодульОбменМобильноеПриложениеВызовСервера.ЕстьПолныеПрава() Тогда
				Элементы.ГруппаПользователи.Видимость = СоединениеСЦБУстановлено;
			Иначе
				Элементы.ГруппаПользователи.Видимость = Ложь;
			КонецЕсли;
		КонецЕсли;
	#КонецЕсли

КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЗадатьКодДоступа()
	
	Элементы.ГруппаНастройкаКодДоступа.Видимость = КодДоступаВключен;
	
КонецПроцедуры

&НаСервере
Процедура РезервноеКопированиеУстановитьСтрокуПодключения()
	
	СтрокаПодключения = ЭтаФорма.ЯндексДискСтрокаПодключения + НаборКонстант.ЯндексДискРабочаяПапка;
	ЯндексДискЛогин = СтрЗаменить(НаборКонстант.ЯндексДискЛогин, "@yandex.ru", "");
	СтрокаПодключения = СтрЗаменить(СтрокаПодключения, "%user%", СокрЛП(ЯндексДискЛогин));
	СтрокаПодключения = СтрЗаменить(СтрокаПодключения, "%password%", КодироватьСтроку(НаборКонстант.ЯндексДискПароль, СпособКодированияСтроки.КодировкаURL));
	Если Прав(СтрокаПодключения, 1) <> "/" Тогда 
		СтрокаПодключения = СтрокаПодключения + "/";
	КонецЕсли;
	ЭтаФорма.РезервноеКопированиеСтрокаПодключения = СтрокаПодключения;
	ЭтаФорма.РезервноеКопированиеФайлИнформацииОВыгрузках = СтрокаПодключения + "informationBases.xml";
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьБыстрыйПодбор(Значение)
	
	Константы.ИспользоватьБыстрыйПодборТоваровМП.Установить(Значение);
	
КонецПроцедуры

&НаСервере
Функция РезервноеКопированиеВыгрузитьБазуНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	ЗаписатьКонстанты();
	
	#Если МобильноеПриложениеКлиент Тогда
		// АПК:488-выкл методы безопасного запуска обеспечиваются этой функцией
		МодульРезервноеКопирование = Вычислить("РезервноеКопирование");
		// АПК:488-вкл
		Если ТипЗнч(МодульРезервноеКопирование) = Тип("ОбщийМодуль") Тогда
			Результат = МодульРезервноеКопирование.ВыгрузитьБазу();
		КонецЕсли;
	#Иначе
		Результат = Новый Структура("ЕстьОшибки, Описание", Ложь, "");
	#КонецЕсли
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция РезервноеКопированиеЗагрузитьБазуНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗаписатьКонстанты();
	
	#Если МобильноеПриложениеКлиент Тогда
		// АПК:488-выкл методы безопасного запуска обеспечиваются этой функцией
		МодульРезервноеКопирование = Вычислить("РезервноеКопирование");
		// АПК:488-вкл
		Если ТипЗнч(МодульРезервноеКопирование) = Тип("ОбщийМодуль") Тогда
			Результат = МодульРезервноеКопирование.ЗагрузитьБазу();
		КонецЕсли;
	#Иначе
		Результат = Новый Структура("ЕстьОшибки, Описание, АдресВыгруженныеБазы, СтрокаПодключения", Ложь, "", Неопределено, "");
	#КонецЕсли
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОбновитьДанныеПослеВосстановленияБазы()
	
	НовыйНаборКонстант = Константы.СоздатьНабор();
	НовыйНаборКонстант.Прочитать();
	ЗначениеВДанныеФормы(НовыйНаборКонстант, ЭтаФорма.НаборКонстант);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьКонтактнаяКнига(Значение)
	
	#Если МобильноеПриложениеСервер Тогда
		ОбщегоНазначенияМПВызовСервера.УстановитьЗначениеКонстанты("ИспользоватьСинхронизациюСКонтактнойКнигой", Значение);
	#КонецЕсли
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьНалоговыйКалендарь(Значение)
	
	#Если МобильноеПриложениеСервер Тогда
		ОбщегоНазначенияМПВызовСервера.УстановитьЗначениеКонстанты("ИспользоватьНалоговыйКалендарь", Значение);
	#КонецЕсли
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьКонтрольОстатков(Значение)
	
	Константы.НеКонтролироватьОстаткиМП.Установить(Значение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьОткрытиеЭкранаВGA(ЭтаФорма.ИмяФормы);
	// Конец Сбор статистики
	
	ПрочитатьКонстанты();
	
	#Если МобильноеПриложениеСервер Тогда
		
		УстановитьДоступностьЗадатьКодДоступа();
		
		ЭтаФорма.НаименованиеПриложения = "SmallBusiness";
		ЭтаФорма.ЯндексДискСтрокаПодключения = "https://%user%:%password%@webdav.yandex.ru/";
		РезервноеКопированиеУстановитьСтрокуПодключения();
		УстановитьСостояниеАвторизации();
		
		Если НЕ ОбменМобильноеПриложениеВызовСервера.ЕстьПолныеПрава() Тогда
			Элементы.ГруппаПользователи.Видимость = Ложь;
			Элементы.ГруппаРезервноеКопирование.Видимость = Ложь;
		КонецЕсли;
		
		Если НСтр("ru='ru';en='en'") = "ru" Тогда
			Элементы.ГруппаНалоговыйКалендарь.Видимость = Истина;
		Иначе
			Элементы.ГруппаНалоговыйКалендарь.Видимость = Ложь;
		КонецЕсли;
		
		Если ОбщегоНазначенияМПВызовСервера.ВерсияОС() = "iOS" Тогда
			Элементы.ГруппаОборудование.Видимость = Ложь;
			Элементы.ГруппаАвторизация.Видимость = Ложь;
		КонецЕсли;
		
		НастроитьКнопкиПодключаемогоОборудования();
	#Иначе
		Элементы.ГруппаОборудование.Видимость = Ложь;
		Элементы.ГруппаНалоговыйКалендарь.Видимость = Ложь;
		Элементы.ГруппаАвторизация.Видимость = Ложь;
		Элементы.ГруппаКонтактнаяКнига.Видимость = Ложь;
		Элементы.ГруппаБезопасность.Видимость = Ложь;
		Элементы.ГруппаПользователи.Видимость = Истина;
		Элементы.НаборКонстантТелефонОрганизацииМП.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.НаборКонстантАдресЭПОрганизацииМП.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		//Элементы.ДекорацияОтступ17.АвтоМаксимальнаяШирина = Ложь;
		//Элементы.ДекорацияОтступ17.МаксимальнаяШирина = 13;
		Элементы.ДекорацияОтступ17.Видимость = Ложь;
		КоманднаяПанель.Видимость = Ложь;
		Элементы.ГруппаПользователи.РастягиватьПоВертикали = Ложь;
		Элементы.ГруппаКонтрольОстатковПраво.РастягиватьПоВертикали = Ложь;
		Элементы.НовыеВозможности.Видимость = Ложь;
		Элементы.ГруппаПользователи.Видимость = Ложь;
		Элементы.ПечатьСсылка.РастягиватьПоГоризонтали = Ложь;
		Элементы.ПечатьДобавить.РастягиватьПоГоризонтали = Ложь;
		Элементы.ЛоготипСсылка.РастягиватьПоГоризонтали = Ложь;
		Элементы.ЛоготипДобавить.РастягиватьПоГоризонтали = Ложь;
		Элементы.ПечатьСсылка.ГоризонтальноеПоложениеВГруппе = ГоризонтальноеПоложениеЭлемента.Лево;
		Элементы.ПечатьДобавить.ГоризонтальноеПоложениеВГруппе = ГоризонтальноеПоложениеЭлемента.Лево;
		Элементы.ЛоготипСсылка.ГоризонтальноеПоложениеВГруппе = ГоризонтальноеПоложениеЭлемента.Лево;
		Элементы.ЛоготипДобавить.ГоризонтальноеПоложениеВГруппе = ГоризонтальноеПоложениеЭлемента.Лево; 
		Элементы.ПечатьУдалить.Ширина = 2;
		Элементы.ЛоготипУдалить.Ширина = 2;
	#КонецЕсли
	
	ОбновитьКартинки();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКартинки()
	
	ЛоготипДвоичныеДанные = Константы.ЛоготипМП.Получить().Получить();
	
	Если ЛоготипДвоичныеДанные <> Неопределено Тогда
		ЛоготипСсылка = ПоместитьВоВременноеХранилище(ЛоготипДвоичныеДанные);
	Иначе
		ЛоготипСсылка = "";
	КонецЕсли;
	
	ПечатьДвоичныеДанные = Константы.ПечатьМП.Получить().Получить();
	
	Если ПечатьДвоичныеДанные <> Неопределено Тогда
		ПечатьСсылка = ПоместитьВоВременноеХранилище(ПечатьДвоичныеДанные);
	Иначе
		ПечатьСсылка = "";
	КонецЕсли;
	
	УстановитьПараметрыЛого();
	УстановитьПараметрыПечать();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ВыполненоВосстановлениеИнформационнойБазы" Тогда
		ОбновитьДанныеПослеВосстановленияБазы()
	ИначеЕсли ИмяСобытия = "ПрошелОбмен" Тогда
		УстановитьСостояниеАвторизации();
		ПеречитатьНаборКонстант();
	ИначеЕсли ИмяСобытия = "ИзмененыПараметрыОборудования" Тогда
		НастроитьКнопкиПодключаемогоОборудования()
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПеречитатьНаборКонстант()
	
	НК = ДанныеФормыВЗначение(НаборКонстант, Тип("КонстантыНабор"));
	НК.Прочитать();
	ЗначениеВДанныеФормы(НК, НаборКонстант);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КонтролироватьОстаткиПереключательПриИзменении(Элемент)
	
	УстановитьКонтрольОстатков(НЕ КонтролироватьОстатки);
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыйПодборТоваровПереключательПриИзменении(Элемент)
	
	УстановитьБыстрыйПодбор(БыстрыйПодборТоваров);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантЯндексДискЛогинПриИзменении(Элемент)
	
	ЭтаФорма.РезервноеКопированиеМодифицированность = Истина;

КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантЯндексДискПарольПриИзменении(Элемент)
	
	ЭтаФорма.РезервноеКопированиеМодифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантЯндексДискРабочаяПапкаПриИзменении(Элемент)
	
	ЭтаФорма.РезервноеКопированиеМодифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КодДоступаПереключательПриИзменении(Элемент)
	
	#Если МобильноеПриложениеКлиент Тогда
		Если КодДоступаВключен Тогда
			НаименованиеФормыВМП = "ОбщаяФорма.УстановкаКодаДоступаВПриложение";
			// АПК:565-выкл методы безопасного запуска обеспечиваются этой функцией
			Результат = ОткрытьФормуМодально(НаименованиеФормыВМП);
			// АПК:565-вкл
			Если Результат = Неопределено Тогда
				КодДоступаВключен = НЕ КодДоступаВключен;
			ИначеЕсли Результат <> Неопределено И НЕ Результат Тогда
				КодДоступаВключен = Ложь;
			КонецЕсли;
		Иначе
			НаименованиеФормыВМП = "ОбщаяФорма.ВводКодаДоступаВПриложение";
			// АПК:565-выкл методы безопасного запуска обеспечиваются этой функцией
			Результат = ОткрытьФормуМодально(НаименованиеФормыВМП);
			// АПК:565-вкл
			Если Результат = Неопределено Тогда
				КодДоступаВключен = НЕ КодДоступаВключен;
			ИначеЕсли Результат <> Неопределено И Результат Тогда
				КодДоступаВключен = Ложь;
				ОбщегоНазначенияМПВызовСервера.УстановитьЗначениеКонстанты("КодДоступа", "");
			КонецЕсли;
		КонецЕсли;
		
		УстановитьДоступностьЗадатьКодДоступа();
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактнаяКнигаПереключательПриИзменении(Элемент)
	
	УстановитьКонтактнаяКнига(КонтактнаяКнига);
	
КонецПроцедуры

&НаКлиенте
Процедура НалоговыйКалендарьПереключательПриИзменении(Элемент)
	
	УстановитьНалоговыйКалендарь(НалоговыйКалендарь);
	ОбновитьИнтерфейс();
	
КонецПроцедуры

&НаКлиенте
Процедура ЛоготипДобавитьНажатие(Элемент)
	
	ОповещениеОДобавлении = Новый ОписаниеОповещения("ДобавитьЛого", ЭтотОбъект);
	ОбщегоНазначенияМПКлиент.ДобавитьФото(ОповещениеОДобавлении);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьДобавитьНажатие(Элемент)
	
	ОповещениеОДобавлении = Новый ОписаниеОповещения("ДобавитьПечать", ЭтотОбъект);
	ОбщегоНазначенияМПКлиент.ДобавитьФото(ОповещениеОДобавлении);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СписокПользователей(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики
	
	#Если МобильноеПриложениеКлиент Тогда
		НаименованиеФормыВМП = "Справочник.ПользователиМП.ФормаСписка";
		ОткрытьФорму(НаименованиеФормыВМП);
	#Иначе
		НаименованиеФормыВМП = "Справочник.Пользователи.ФормаСписка";
		ОткрытьФорму(НаименованиеФормыВМП);
	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура НастройкиСинхронизации(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики
	
	#Если МобильноеПриложениеКлиент Тогда
		НаименованиеФормыВМП = "ОбщаяФорма.НастройкиСинхронизации";
		ОткрытьФорму(НаименованиеФормыВМП);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьКодДоступа(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики
	
	#Если МобильноеПриложениеКлиент Тогда
		НаименованиеФормыВМП = "ОбщаяФорма.УстановкаКодаДоступаВПриложение";
		// АПК:565-выкл методы безопасного запуска обеспечиваются этой функцией
		ОткрытьФормуМодально(НаименованиеФормыВМП);
		// АПК:565-вкл
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура РезервноеКопированиеВыгрузитьБазу(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	Если ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("СоединениеСЦБУстановлено") Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Для выгрузки информационной базы необходимо выключить синхронизацию с сервисом.'; en='To unload the information base necessary to disable synchronization with the cloud.'"),,ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьСинонимКонфигурации());
		Возврат;
	КонецЕсли;
	
	Результат = РезервноеКопированиеВыгрузитьБазуНаСервере();
	
	Если Результат.ЕстьОшибки Тогда 
		ПоказатьПредупреждение(Неопределено, Результат.Описание,,ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьСинонимКонфигурации());
	Иначе
		ПоказатьВопрос(Неопределено, НСтр("ru='Резервное копирование информационной базы выполнено успешно!';en='Backup database was successful!'"), РежимДиалогаВопрос.ОК,,,ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьСинонимКонфигурации());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезервноеКопированиеЗагрузитьБазу(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	Если ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("СоединениеСЦБУстановлено") Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Для восстановления информационной базы необходимо выключить синхронизацию с сервисом.'; en='To restore the information base necessary to disable synchronization with the cloud.'"),,ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьСинонимКонфигурации());
		Возврат;
	КонецЕсли;
	
	Результат = РезервноеКопированиеЗагрузитьБазуНаСервере();
	
	Если Результат.ЕстьОшибки Тогда
		ПоказатьПредупреждение(Неопределено, Результат.Описание,,ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьСинонимКонфигурации());
	Иначе
		#Если МобильноеПриложениеКлиент Тогда
			НаименованиеФормыВМП = "ОбщаяФорма.ЗагрузкаИнформационнойБазы";
			Форма = ПолучитьФорму(НаименованиеФормыВМП, Результат);
			Форма.Открыть();
		#КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьБазу(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	СисИнфо = Новый СистемнаяИнформация;
	
	ТемаПисьма = НСтр("ru='Выгрузка информационной базы';en='Base'");
	ТелоПисьма = 
		""
		+ Символы.ПС
		+ Символы.ПС
		+ "---"
		+ Символы.ПС
		+  НСтр("ru='Сформировано в мобильном приложении 1С:Управление нашей фирмой';en='Created in a mobile application 1C:Small Business Mobile'")
		+ Символы.ПС
		+ ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("ИдентификаторЭкземпляраМП") + "|" + ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("ТекущаяВерсияПриложения") + "|" + СисИнфо.ВерсияОС + ?(ЗначениеЗаполнено(СисИнфо.ТипПлатформы), "|" + СисИнфо.ТипПлатформы, "") 
	;
		
	
	#Если МобильноеПриложениеКлиент Тогда
		ВыгрузкаБазы = ОтправитьБазуНаСервере();
	#Иначе
		ВыгрузкаБазы = "";
	#КонецЕсли
	
	#Если МобильноеПриложениеКлиент Тогда
	ОбщегоНазначенияМПКлиент.ПослатьПисьмо(
		"", 
		ТемаПисьма, 
		ТелоПисьма, 
		ВыгрузкаБазы, 
		НСтр("ru='выгрузка базы.xml';en='base.xml'")
	);
	#Иначе
	ПоказатьВводСтроки(Неопределено, 
		ВыгрузкаБазы + ТелоПисьма,
		ТемаПисьма,
		,
		Истина
	);
	#КонецЕсли

КонецПроцедуры

&НаСервере
Функция ОтправитьБазуНаСервере()
	
	#Если МобильноеПриложениеКлиент Тогда
		Возврат РезервноеКопирование.ВыгрузитьБазуВXML();
	#КонецЕсли
	
КонецФункции

&НаКлиенте
Процедура ДобавитьККТ(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	#Если МобильноеПриложениеКлиент Тогда
		НаименованиеФормыВМП = "ОбщаяФорма.ПодключаемоеОборудованиеУстройствоПечати";
		ОткрытьФорму(НаименованиеФормыВМП,,ЭтаФорма);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЭквайринговыйТерминал(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики
	
	#Если МобильноеПриложениеКлиент Тогда
		НаименованиеФормыВМП = "ОбщаяФорма.ПодключаемоеОборудованиеПлатежнаяСистема";
		ОткрытьФорму(НаименованиеФормыВМП, , ЭтаФорма);
	#КонецЕсли

КонецПроцедуры

&НаСервере
Процедура НастроитьКнопкиПодключаемогоОборудования()
	
	#Если МобильноеПриложениеСервер Тогда
		
		Если ЗначениеЗаполнено(ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьЗначениеКонстанты("ОборудованиеПечати")) Тогда
			Элементы.ДобавитьККТ.Отображение = ОтображениеКнопки.КартинкаИТекст;
			Элементы.ДобавитьККТ.Заголовок = НСтр("ru = 'ККТ'");
		Иначе
			Элементы.ДобавитьККТ.Отображение = ОтображениеКнопки.Авто;
			Элементы.ДобавитьККТ.Заголовок = НСтр("ru = '+ ККТ'");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьЗначениеКонстанты("ОборудованиеПлатежнойСистемы")) Тогда
			Элементы.ДобавитьЭквайринговыйТерминал.Отображение = ОтображениеКнопки.КартинкаИТекст;
			Элементы.ДобавитьЭквайринговыйТерминал.Заголовок = НСтр("ru = 'Платежная система'");
		Иначе
			Элементы.ДобавитьЭквайринговыйТерминал.Отображение = ОтображениеКнопки.Авто;
			Элементы.ДобавитьЭквайринговыйТерминал.Заголовок = НСтр("ru = '+ Платежная система'");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьЗначениеКонстанты("ОборудованиеСканирования")) Тогда
			Элементы.ДобавитьСканер.Отображение = ОтображениеКнопки.КартинкаИТекст;
			Элементы.ДобавитьСканер.Заголовок = НСтр("ru = 'Сканер штрих-кодов'");
		Иначе
			Элементы.ДобавитьСканер.Отображение = ОтображениеКнопки.Авто;
			Элементы.ДобавитьСканер.Заголовок = НСтр("ru = '+ Сканер штрих-кодов'");
		КонецЕсли;
	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ПолныеПрава(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	ОбработкаКомандыПолныеПраваНаСервере();
	ЗавершитьРаботуСистемы(Ложь, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаКомандыПолныеПраваНаСервере()
	
		// ******Временно закомментировано
		
		//УстановитьПривилегированныйРежим(Истина);
		//ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
		//ТекущийПользователь.Роли.Очистить();
		//ТекущийПользователь.Роли.Добавить(Метаданные.Роли.БазовыеПрава);
		//ТекущийПользователь.Роли.Добавить(Метаданные.Роли.ПолныеПрава);
		//ТекущийПользователь.Записать();
		
КонецПроцедуры

&НаКлиенте
Процедура ТолькоРозница(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики

	ОбработкаКомандыТолькоРозницаНаСервере();
	ЗавершитьРаботуСистемы(Ложь, Истина);

КонецПроцедуры

&НаСервере
Процедура ОбработкаКомандыТолькоРозницаНаСервере()
	
	// ******Временно закомментировано
	
	//УстановитьПривилегированныйРежим(Истина);
	//ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
	//ТекущийПользователь.Роли.Очистить();
	//ТекущийПользователь.Роли.Добавить(Метаданные.Роли.БазовыеПрава);
	//ТекущийПользователь.Роли.Добавить(Метаданные.Роли.РозницаПросмотрИРедактирование);
	//ТекущийПользователь.Роли.Добавить(Метаданные.Роли.ЧтениеОстатокТоваров);
	////ТекущийПользователь.Роли.Добавить(Метаданные.Роли.НоменклатураТолькоПросмотр);
	//ТекущийПользователь.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСканер(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики
	
	#Если МобильноеПриложениеКлиент Тогда
		НаименованиеФормыВМП = "ОбщаяФорма.ПодключаемоеОборудованиеСканерШтрихкодов";
		ОткрытьФорму(НаименованиеФормыВМП, , ЭтаФорма);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Закрытие",,,ЗавершениеРаботы);
	// Конец Сбор статистики
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьКонстанты();
	Оповестить("ИзменилисьНастройки");
	
КонецПроцедуры

&НаКлиенте
Процедура ПредложитьВозможность(Команда)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Команда." + Команда.Имя);
	// Конец Сбор статистики
	
	#Если МобильноеПриложениеКлиент Тогда
		
		Если ПустаяСтрока(НовыеВозможности) Тогда
			ПоказатьПредупреждение(, НСтр("ru='Вначале опишите те возможности, которые вам нужны';en='First, describe the opportunities that you need'"), ,ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьСинонимКонфигурации());
			Возврат;
		КонецЕсли;
		
	#КонецЕсли

	СисИнфо = Новый СистемнаяИнформация;
	
	ТемаПисьма = НСтр("ru='Хочу эти возможности в будущей версии мобильного приложения УНФ';en='I want these features in a future version of the mobile application SBM'");
	#Если МобильноеПриложениеКлиент Тогда
	ТелоПисьма = 
		""
		+ НовыеВозможности
		+ Символы.ПС
		+ "---"
		+ Символы.ПС
		+  НСтр("ru='Сформировано в мобильном приложении 1С:Управление нашей фирмой';en='Created in a mobile application 1C:Small Business Mobile'")
		+ Символы.ПС
		+ ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("ИдентификаторЭкземпляраМП") + "|" + ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("ТекущаяВерсияПриложения") + "|" + СисИнфо.ВерсияОС + ?(ЗначениеЗаполнено(СисИнфо.ТипПлатформы), "|" + СисИнфо.ТипПлатформы, "");
	#Иначе
		ТелоПисьма = 
		""
		+ НовыеВозможности
		+ Символы.ПС
		+ "---"
		+ Символы.ПС
		+  НСтр("ru='Сформировано в мобильном приложении 1С:Управление нашей фирмой';en='Created in a mobile application 1C:Small Business Mobile'")
		+ Символы.ПС
		+ ОбщегоНазначенияМПВызовСервера.ТекущаяВерсия();
	#КонецЕсли

	
	#Если МобильноеПриложениеКлиент Тогда
	ОбщегоНазначенияМПКлиент.ПослатьПисьмо(
		"sbm@1c.ru", 
		ТемаПисьма, 
		ТелоПисьма
	);
	#Иначе
	НачатьЗапускПриложения(Новый ОписаниеОповещения("ПослеЗапускаПриложения", ЭтотОбъект), "mailto:" + "sbm@1c.ru");
	#КонецЕсли

	
КонецПроцедуры

&НаКлиенте
Процедура ПредложитьВозможностьЗавершение(Строка, ДополнительныеПараметры) Экспорт
	
	ТелоПисьма = ?(Строка = Неопределено, ДополнительныеПараметры.ТелоПисьма, Строка);
	
КонецПроцедуры

Процедура ПослеЗапускаПриложения(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	Возврат; // Процедура заглушка, т.к. НачатьЗапускПриложения требуется наличие обработчика оповещения.
КонецПроцедуры

#КонецОбласти

#Область Логотип

&НаКлиенте
Процедура ДобавитьЛого(Результат, Адрес, ИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат = Истина Тогда
		
		АдресВременногоХранилища= Адрес;
		ИмяВыбранногоФайла 		= ИмяФайла;
		Расширение 				= ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ИмяВыбранногоФайла));
		
		Если Расширение = "bmp"
			ИЛИ Расширение = "gif"
			ИЛИ Расширение = "png"
			ИЛИ Расширение = "jpeg"
			ИЛИ Расширение = "dib"
			ИЛИ Расширение = "rle"
			ИЛИ Расширение = "tif"
			ИЛИ Расширение = "jpg"
			ИЛИ Расширение = "ico"
			ИЛИ Расширение = "wmf"
			ИЛИ Расширение = "emf" Тогда
			
			Если ПолучитьИзВременногоХранилища(АдресВременногоХранилища).Размер() > 5000000 Тогда
				ТекстПредупреждения = НСтр("ru ='Размер не должен превышать 5 МБ.'");
				ПоказатьПредупреждение(, ТекстПредупреждения); 
				Возврат;
			КонецЕсли;
			
			ДобавитьЛогоНаСервере(АдресВременногоХранилища)
			
		Иначе
			
			ТекстПредупреждения = НСтр("ru ='Данный формат не поддерживается.'");
			ПоказатьПредупреждение(, ТекстПредупреждения); 
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьЛогоНаСервере(ПутьКХранилищу)
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(ПутьКХранилищу);
	Константы.ЛоготипМП.Установить(Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных(9)));
	
	ОбновитьКартинки();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПечать(Результат, Адрес, ИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат = Истина Тогда
		
		АдресВременногоХранилища= Адрес;
		ИмяВыбранногоФайла 		= ИмяФайла;
		Расширение 				= ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ИмяВыбранногоФайла));
		
		Если Расширение = "bmp"
			ИЛИ Расширение = "gif"
			ИЛИ Расширение = "png"
			ИЛИ Расширение = "jpeg"
			ИЛИ Расширение = "dib"
			ИЛИ Расширение = "rle"
			ИЛИ Расширение = "tif"
			ИЛИ Расширение = "jpg"
			ИЛИ Расширение = "ico"
			ИЛИ Расширение = "wmf"
			ИЛИ Расширение = "emf" Тогда
			
			Если ПолучитьИзВременногоХранилища(АдресВременногоХранилища).Размер() > 5000000 Тогда
				ТекстПредупреждения = НСтр("ru ='Размер не должен превышать 5 МБ.'");
				ПоказатьПредупреждение(, ТекстПредупреждения); 
				Возврат;
			КонецЕсли;
			
			ДобавитьПечатьНаСервере(АдресВременногоХранилища)
			
		Иначе
			
			ТекстПредупреждения = НСтр("ru ='Данный формат не поддерживается.'");
			ПоказатьПредупреждение(, ТекстПредупреждения); 
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПечатьНаСервере(ПутьКХранилищу)
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(ПутьКХранилищу);
	Константы.ПечатьМП.Установить(Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных(9)));
	
	ОбновитьКартинки();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьЛогоНаСервере()
	
	Константы.ЛоготипМП.Установить(Неопределено);
	ОбновитьКартинки();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьПечатьНаСервере()
	
	Константы.ПечатьМП.Установить(Неопределено);
	ОбновитьКартинки();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыЛого()
	
	Если ЗначениеЗаполнено(ЛоготипСсылка) Тогда
		Элементы.ГруппаЛоготипСсылка.Видимость = Истина;
		Элементы.ЛоготипДобавить.Видимость = Ложь;
	Иначе
		Элементы.ГруппаЛоготипСсылка.Видимость = Ложь;
		Элементы.ЛоготипДобавить.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыПечать()
	
	Если ЗначениеЗаполнено(ПечатьСсылка) Тогда
		Элементы.ГруппаПечатьСсылка.Видимость = Истина;
		Элементы.ПечатьДобавить.Видимость = Ложь;
	Иначе
		Элементы.ГруппаПечатьСсылка.Видимость = Ложь;
		Элементы.ПечатьДобавить.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛоготипУдалитьНажатие(Элемент)
	
	УдалитьЛогоНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьУдалитьНажатие(Элемент)
	
	УдалитьПечатьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантФИОРуководителяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("ОбщаяФорма.ДобавлениеКартинкиМП", Новый Структура("ТипКартинки", "ФаксимилеРуководителя"),,,,,,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантФИОБухгалтераНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("ОбщаяФорма.ДобавлениеКартинкиМП", Новый Структура("ТипКартинки", "ФаксимилеБухгалтера"),,,,,,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры


#КонецОбласти

﻿#Область СлужебныйПрограммныйИнтерфейс

// Отправляет информацию о запуске приложения.
//
Процедура ОтправитьИнформациюОЗапускеПриложения() Экспорт
	
	СисИнфо = Новый СистемнаяИнформация;
	
	КоличествоККТ = Справочники.ПодключаемоеОборудование.ОборудованиеПоПараметрам("ККТ").Количество();
	КоличествоСканеров = Справочники.ПодключаемоеОборудование.ОборудованиеПоПараметрам("УстройствоВвода").Количество();
	КоличествоЭТ = Справочники.ПодключаемоеОборудование.ОборудованиеПоПараметрам("ПлатежнаяСистема").Количество();
	
	ДопДанные = "<data><os>{os}</os><platform>{platform}</platform><versionApp>{versionApp}</versionApp><mode>{mode}</mode><adressType>{adressType}</adressType><users>{users}</users><adress>{adress}</adress><countKKT>{countKKT}</countKKT><countBarCodeScaner>{countBarCodeScaner}</countBarCodeScaner><countET>{countET}</countET></data>";
	ДопДанные = СтрЗаменить(ДопДанные, "{os}", СисИнфо.ВерсияОС);
	ДопДанные = СтрЗаменить(ДопДанные, "{platform}", СисИнфо.ТипПлатформы);
	ДопДанные = СтрЗаменить(ДопДанные, "{versionApp}", ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("ТекущаяВерсияПриложения"));
	ДопДанные = СтрЗаменить(ДопДанные, "{mode}", ?(ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("ИспользоватьСинхронизациюДанных"), "sync", "local"));
	ДопДанные = СтрЗаменить(ДопДанные, "{countKKT}", КоличествоККТ);
	ДопДанные = СтрЗаменить(ДопДанные, "{countBarCodeScaner}", КоличествоСканеров);
	ДопДанные = СтрЗаменить(ДопДанные, "{countET}", КоличествоЭТ);
	
	АдресЦентральнойБазы = ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("АдресЦентральнойБазы");
	Если ПустаяСтрока(АдресЦентральнойБазы) Тогда
		ТипАдреса = "";
	ИначеЕсли Найти(НРег(АдресЦентральнойБазы), "1cfresh.com") Тогда
		ТипАдреса = "isFresh";
	Иначе
		ТипАдреса = "isNoFresh";
	КонецЕсли;
	ДопДанные = СтрЗаменить(ДопДанные, "{adressType}", ТипАдреса);
	ДопДанные = СтрЗаменить(ДопДанные, "{adress}", АдресЦентральнойБазы);
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(ПользователиМП.Ссылка) КАК Количество
	|ИЗ
	|	Справочник.ПользователиМП КАК ПользователиМП";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ДопДанные = СтрЗаменить(ДопДанные, "{users}", Строка(Выборка.Количество));
	Иначе
		ДопДанные = СтрЗаменить(ДопДанные, "{users}", "0");
	КонецЕсли;
	
	СборСтатистикиМПСервер.ОтправитьСобытиеСДопДаннымиВФоне("Запуск приложения", ДопДанные);
	
КонецПроцедуры // ОтправитьИнформациюОЗапускеПриложения()

Процедура ОтправитьСобытиеStartВGA() Экспорт
	
	СобытиеСтатистики = "&sc=start&t=event&cd=Старт приложения&ea=Старт приложения&ec=Поведение пользователя";
	СборСтатистикиМПСервер.ОтправитьСобытиеGAВФоне(СобытиеСтатистики);
	
КонецПроцедуры

Процедура ОтправитьОткрытиеЭкранаВGA(Экран) Экспорт
	
	ПараметрыСтатистики = "&cd=" + Экран;
	ОтправитьСтатистикуВGA("screenview", ПараметрыСтатистики);
	
КонецПроцедуры

Процедура ОтправитьОшибкуВGA(ТекстОшибки) Экспорт
	
	ПараметрыСтатистики = "&exd=" + ТекстОшибки;
	ОтправитьСтатистикуВGA("exception", ПараметрыСтатистики);
	
КонецПроцедуры

Процедура ОтправитьДействиеВGA(Действие, Категория = "Поведение пользователя", ПараметрыПокупки = Неопределено) Экспорт
	
	ПараметрыСтатистики = "&cd=" + Действие + "&ea=" + Действие + "&ec=" + Категория;
	ОтправитьСтатистикуВGA("event", ПараметрыСтатистики);
	
КонецПроцедуры

Процедура ОтправитьСтатистикуВGA(ТипСобытия, ПараметрыСтатистики) 
	
	СобытиеСтатистики = "&t=" + ТипСобытия + ПараметрыСтатистики;
	СборСтатистикиМПСервер.ОтправитьСобытиеGAВФоне(СобытиеСтатистики);
	
КонецПроцедуры

#КонецОбласти

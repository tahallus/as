﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ОрганизацииВЕТИС <> Неопределено Тогда
		ИнтеграцияВЕТИСКлиентСервер.ПеренестиДеревоРекурсивно(Параметры.ОрганизацииВЕТИС, ОрганизацииВЕТИС);
	ИначеЕсли Параметры.Документ <> Неопределено Тогда
		Документ = Параметры.Документ;
		
		ХозяйствующийСубъект = Неопределено;
		Предприятие          = Неопределено;
		
		Если ТипЗнч(Документ) = Тип("ДокументСсылка.ИсходящаяТранспортнаяОперацияВЕТИС") Тогда
			Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Документ, "ГрузоотправительХозяйствующийСубъект, ГрузоотправительПредприятие");
			ХозяйствующийСубъект = Реквизиты.ГрузоотправительХозяйствующийСубъект;
			Предприятие          = Реквизиты.ГрузоотправительПредприятие;
		ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.ВходящаяТранспортнаяОперацияВЕТИС") Тогда
			Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Документ, "ГрузополучательХозяйствующийСубъект, ГрузополучательПредприятие");
			ХозяйствующийСубъект = Реквизиты.ГрузополучательХозяйствующийСубъект;
			Предприятие          = Реквизиты.ГрузополучательПредприятие;
		Иначе
			Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Документ, "ХозяйствующийСубъект, Предприятие");
			ХозяйствующийСубъект = Реквизиты.ХозяйствующийСубъект;
			Предприятие          = Реквизиты.Предприятие;
		КонецЕсли;
		
		СтрокаДерева = ОрганизацииВЕТИС.ПолучитьЭлементы().Добавить();
		СтрокаДерева.ХозяйствующийСубъектПредприятиеВЕТИС = ХозяйствующийСубъект;
		
		СтрокаДерева = СтрокаДерева.ПолучитьЭлементы().Добавить();
		СтрокаДерева.ХозяйствующийСубъектПредприятиеВЕТИС = Предприятие;
		
	КонецЕсли;
	
	Если Параметры.ИзмененныеВСД <> Неопределено Тогда
		ИзмененныеВСД.ЗагрузитьЗначения(Параметры.ИзмененныеВСД);
	КонецЕсли;
	
	Если Параметры.ИзмененныеЗаписиСкладскогоЖурнала <> Неопределено Тогда
		ИзмененныеЗаписиСкладскогоЖурнала.ЗагрузитьЗначения(Параметры.ИзмененныеЗаписиСкладскогоЖурнала);
	КонецЕсли;
	
	ОтобржатьГруппуСмТакже = Параметры.ЕстьОшибкиСервисаПриПолученииСписковВСД
		Или Параметры.ЕстьОшибкиСервисаПриПолученииСписковЗаписейСкладскогоЖурнала
		Или Параметры.ЕстьОшибкиСервисаПриОформленииДокументов И ЗначениеЗаполнено(Параметры.Документ);
	
	Элементы.ГруппаСмТакже.ОтображатьЗаголовок = ОтобржатьГруппуСмТакже;
	Элементы.ГруппаИнформацияОбОшибке.Видимость = ОтобржатьГруппуСмТакже;
	
	Если Элементы.ГруппаИнформацияОбОшибке.Видимость Тогда
		
		НадписьСообщениеОбОшибкеПоОбъектуЗаголовок = Новый Массив;
		Если Параметры.ЕстьОшибкиСервисаПриПолученииСписковВСД
			Или Параметры.ЕстьОшибкиСервисаПриПолученииСписковЗаписейСкладскогоЖурнала Тогда
			
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(
				Новый ФорматированнаяСтрока(
					НСтр("ru='API-шлюз ФГИС Меркурий перегружен, попытки получения ВСД и записей 
					         |складского журнала приводят к ошибке'")));
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(" ");
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(
				Новый ФорматированнаяСтрока(
					"APLM0012",
					Новый Шрифт(Элементы.ГруппаИнформацияОбОшибке.ШрифтЗаголовка,,, Истина)));
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(", ");
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(Новый ФорматированнаяСтрока(
				НСтр("ru='за последнюю сессию обмена
				         |загружено'")));
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(" ");
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(
				Новый ФорматированнаяСтрока(
					СтрШаблон(
						НСтр("ru='%1 ВСД'"),
						ИзмененныеВСД.Количество()),,,,
				"ИзмененныеВСД"));
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(" ");
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(НСтр("ru = 'и'"));
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(" ");
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(
				Новый ФорматированнаяСтрока(
					СтрШаблон(
						НСтр("ru='%1 записей складского журнала'"),
						ИзмененныеЗаписиСкладскогоЖурнала.Количество()),,,,
				"ИзмененныеЗаписиСкладскогоЖурнала"));
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(".");
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(Символы.ПС);
			
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(
				Новый ФорматированнаяСтрока(
					НСтр("ru='Загрузите'")));
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(" ");
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(
				Новый ФорматированнаяСтрока(
					НСтр("ru='ВСД по идентификаторам'"),,,,
				"ЗагрузитьВСДПоИдентификаторам"));
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(" ");
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(
				Новый ФорматированнаяСтрока(
					НСтр("ru='в ручном режиме с помощью сканера штрихкодов (внешнего файла)
					         |или попробуйте загрузить'")));
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(" ");
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(
				Новый ФорматированнаяСтрока(
					НСтр("ru='непогашенные ВСД за период'"),,,,
				"ЗагрузитьНепогашенныеВСДЗаПериод"));
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(".");
			
		ИначеЕсли Параметры.ЕстьОшибкиСервисаПриОформленииДокументов
			И ЗначениеЗаполнено(Параметры.Документ) Тогда
			
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(
				Новый ФорматированнаяСтрока(
					НСтр("ru='При передаче запроса по документу'")));
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(" ");
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(
				Новый ФорматированнаяСтрока(
					Строка(Параметры.Документ),,,,
				ПолучитьНавигационнуюСсылку(Параметры.Документ)));
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(Символы.ПС);
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(
				Новый ФорматированнаяСтрока(
					СтрШаблон(
						НСтр("ru='в API-интерфейс ФГИС Меркурий произошла фатальная ошибка:
						     |%1'"), Параметры.ДокументТекстОшибки)));
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(Символы.ПС);
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(
				Новый ФорматированнаяСтрока(
					НСтр("ru='Проверьте корректность данных'"),,,,
				"ПроверитьКорректностьДанных"));
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(" ");
			НадписьСообщениеОбОшибкеПоОбъектуЗаголовок.Добавить(
				Новый ФорматированнаяСтрока(
					НСтр("ru='для устранения проблемы рассинхронизации ВСД и записей складского журнала.'")));
			
		КонецЕсли;
		
		Элементы.НадписьСообщениеОбОшибкеПоОбъекту.Заголовок = Новый ФорматированнаяСтрока(НадписьСообщениеОбОшибкеПоОбъектуЗаголовок);
		
		Элементы.НадписьСообщениеОбОшибкеПоОбъекту.Высота = СтрРазделить(Элементы.НадписьСообщениеОбОшибкеПоОбъекту.Заголовок, Символы.ПС).Количество();
		
	КонецЕсли;
	
	ОбновитьСписокОшибок();
	
	СброситьРазмерыИПоложениеОкна();
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СинонимыОбъектов = Новый СписокЗначений;
	СинонимыОбъектов.Добавить("ВходящаяТранспортнаяОперацияВЕТИС",
	                          "Документ.ВходящаяТранспортнаяОперацияВЕТИС.Форма.ФормаСпискаДокументов");
	СинонимыОбъектов.Добавить("ИнвентаризацияПродукцииВЕТИС",
	                          "Документ.ИнвентаризацияПродукцииВЕТИС.Форма.ФормаСпискаДокументов");
	СинонимыОбъектов.Добавить("ИсходящаяТранспортнаяОперацияВЕТИС",
	                          "Документ.ИсходящаяТранспортнаяОперацияВЕТИС.Форма.ФормаСпискаДокументов");
	СинонимыОбъектов.Добавить("ОбъединениеЗаписейСкладскогоЖурналаВЕТИС",
	                          "Документ.ОбъединениеЗаписейСкладскогоЖурналаВЕТИС.Форма.ФормаСпискаДокументов");
	СинонимыОбъектов.Добавить("ПроизводственнаяОперацияВЕТИС",
	                          "Документ.ПроизводственнаяОперацияВЕТИС.Форма.ФормаСпискаДокументов");
	СинонимыОбъектов.Добавить("ПродукцияВЕТИС",
	                          "Справочник.ПродукцияВЕТИС.Форма.ФормаСписка");
	СинонимыОбъектов.Добавить("ХозяйствующиеСубъектыВЕТИС",
	                          "Справочник.ХозяйствующиеСубъектыВЕТИС.Форма.ФормаСписка");
	СинонимыОбъектов.Добавить("ПредприятияВЕТИС",
	                          "Справочник.ПредприятияВЕТИС.Форма.ФормаСписка");
	СинонимыОбъектов.Добавить("ЦелиВЕТИС",
	                          "Справочник.ЦелиВЕТИС.Форма.ФормаСписка");
	
	ИмяФормыОбъекта = СинонимыОбъектов.НайтиПоЗначению(НавигационнаяСсылкаФорматированнойСтроки);
	
	Если ИмяФормыОбъекта <> Неопределено Тогда
		
		СтруктураБыстрогоОтбора = Новый Структура;
		СтруктураБыстрогоОтбора.Вставить("ОрганизацииВЕТИС",              ОрганизацииВЕТИС);
		СтруктураБыстрогоОтбора.Вставить("ОрганизацияВЕТИС",              Неопределено);
		СтруктураБыстрогоОтбора.Вставить("ОрганизацииВЕТИСПредставление", "");
		СтруктураБыстрогоОтбора.Вставить("ДальнейшееДействиеВЕТИС",
			ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПроверьтеКорректностьДанных"));
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
		
		ОткрытьФорму(ИмяФормыОбъекта.Представление, ПараметрыОткрытияФормы);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПараметрыОптимизации" Тогда
		
		ОткрытьФорму("Обработка.ПанельАдминистрированияВЕТИС.Форма.ПараметрыОптимизации");
	
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ИзмененныеЗаписиСкладскогоЖурнала" Тогда
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Ссылка", ИзмененныеЗаписиСкладскогоЖурнала.ВыгрузитьЗначения());
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("Отбор", ПараметрыОтбора);
		
		ОткрытьФорму(
			"Справочник.ЗаписиСкладскогоЖурналаВЕТИС.Форма.ФормаСписка",
			ПараметрыОткрытияФормы, ЭтотОбъект,,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ИзмененныеВСД" Тогда
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Ссылка", ИзмененныеВСД.ВыгрузитьЗначения());
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("Отбор", ПараметрыОтбора);
		
		ОткрытьФорму(
			"Справочник.ВетеринарноСопроводительныйДокументВЕТИС.Форма.ФормаСписка",
			ПараметрыОткрытияФормы, ЭтотОбъект);
	
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ЗагрузитьНепогашенныеВСДЗаПериод" Тогда
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("ВидЗапроса", 2);
		
		ОткрытьФорму(
			"Справочник.ВетеринарноСопроводительныйДокументВЕТИС.Форма.ЗапросВСД",
			ПараметрыОткрытияФормы, ЭтотОбъект);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ЗагрузитьВСДПоИдентификаторам" Тогда
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("ВидЗапроса", 1);
		
		ОткрытьФорму(
			"Справочник.ВетеринарноСопроводительныйДокументВЕТИС.Форма.ЗапросВСД",
			ПараметрыОткрытияФормы, ЭтотОбъект);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ЕстьСообщенияОжидающиеОтправки" Тогда
		
		СтруктураБыстрогоОтбора = Новый Структура;
		СтруктураБыстрогоОтбора.Вставить("ОрганизацииВЕТИС",              ОрганизацииВЕТИС);
		СтруктураБыстрогоОтбора.Вставить("ОрганизацияВЕТИС",              Неопределено);
		СтруктураБыстрогоОтбора.Вставить("ОрганизацииВЕТИСПредставление", "");
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
		
		ОткрытьФорму(
			"РегистрСведений.ОчередьСообщенийВЕТИС.Форма.ФормаСписка", ПараметрыОткрытияФормы,
			ЭтотОбъект,,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "АвтоматическийОбмен" Тогда
		
		ОткрытьФорму("Обработка.ПанельАдминистрированияВЕТИС.Форма.НастройкиВЕТИС");
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ДлительноеОтсутствиеОбмена"
		Или НавигационнаяСсылкаФорматированнойСтроки = "ЕстьПроблемыAPLM0012ПриСинхронизацииВСД"
		Или НавигационнаяСсылкаФорматированнойСтроки = "ЕстьПроблемыAPLM0012ПриСинхронизацииЗаписейСкладскогоЖурнала"
		Или НавигационнаяСсылкаФорматированнойСтроки = "ЕстьРасхожденияДатыСинхронизацииИДатыОбменаПоВСД"
		Или НавигационнаяСсылкаФорматированнойСтроки = "ЕстьРасхожденияДатыСинхронизацииИДатыОбменаПоЗаписямСкладскогоЖурнала"
		Или НавигационнаяСсылкаФорматированнойСтроки = "ЕстьРасхожденияМеждуДатамиСинхронизацииЗаписейСкладскогоЖурналаИВСД"
		Или НавигационнаяСсылкаФорматированнойСтроки = "НеАктуальныеВСД"
		Или НавигационнаяСсылкаФорматированнойСтроки = "НеАктуальныеЗаписиСкладскогоЖурнала" Тогда
		
		ЗаполнитьСтруктуруБыстрогоОтбора(НавигационнаяСсылкаФорматированнойСтроки);
		
		СтруктураБыстрогоОтбора = Новый Структура;
		СтруктураБыстрогоОтбора.Вставить("ОрганизацииВЕТИС",              ОрганизацииВЕТИСОтбор);
		СтруктураБыстрогоОтбора.Вставить("ОрганизацияВЕТИС",              Неопределено);
		СтруктураБыстрогоОтбора.Вставить("ОрганизацииВЕТИСПредставление", "");
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
		ОткрытьФорму(
			"РегистрСведений.СинхронизацияКлассификаторовВЕТИС.ФормаСписка", ПараметрыОткрытияФормы,
			ЭтотОбъект);
	
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ВыполнитьОбмен" Тогда
		
		ИнтеграцияВЕТИСКлиент.ВыполнитьОбмен(
			ВладелецФормы, ИнтеграцияВЕТИСКлиент.ОрганизацииВЕТИСДляОбмена(ВладелецФормы));
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ЗапроситьОстаткиИНепогашенныеВСД" Тогда
		
		ОрганизацииПредприятия = УдалитьЗаписиСинхронизации();
		
		ИнтеграцияВЕТИСКлиент.ВыполнитьОбмен(
			ВладелецФормы, ОрганизацииПредприятия);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПроверитьКорректностьДанных" Тогда
		
		ПараметрыПередачи = ИнтеграцияВЕТИСКлиентСервер.СтруктураПараметрыПередачи();
		ПараметрыПередачи.ДальнейшееДействие = ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПроверьтеКорректностьДанных");
		
		ИнтеграцияВЕТИСКлиент.ПодготовитьКПередаче(ВладелецФормы, ПараметрыПередачи);
		
		Закрыть(Неопределено);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ЗаполнитьСлужебныеРегистры" Тогда
		
		ЗаполнитьСлужебныеРегистрыНаСервере();
		
		Закрыть(Неопределено);
		
	ИначеЕсли ОбщегоНазначенияСлужебныйКлиент.ЭтоНавигационнаяСсылка(НавигационнаяСсылкаФорматированнойСтроки) Тогда
		
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(НавигационнаяСсылкаФорматированнойСтроки);
		
	Иначе
		
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Неизвестная ссылка: %1'"),
			НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруБыстрогоОтбора(ИдентификаторПроблемы)
	
	РезультатыЗапроса = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	
	ОрганизацииВЕТИСОтбор.ПолучитьЭлементы().Очистить();
	СоответствиеСтрокДерева = Новый Соответствие;
	
	Выборка = РезультатыЗапроса[ИдентификаторПроблемы].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокаДерева = СоответствиеСтрокДерева.Получить(Выборка.ХозяйствующийСубъект);
		Если СтрокаДерева = Неопределено Тогда
			
			СтрокаДерева = ОрганизацииВЕТИСОтбор.ПолучитьЭлементы().Добавить();
			СтрокаДерева.ХозяйствующийСубъектПредприятиеВЕТИС = Выборка.ХозяйствующийСубъект;
			
			СоответствиеСтрокДерева.Вставить(Выборка.ХозяйствующийСубъект, СтрокаДерева);
			
		КонецЕсли;
		
		СтрокаДереваПредприятие = СтрокаДерева.ПолучитьЭлементы().Добавить();
		СтрокаДереваПредприятие.ХозяйствующийСубъектПредприятиеВЕТИС = Выборка.Предприятие;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписокОшибок();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСписокОшибок()
	
	РезультатыЗапроса = ИнтеграцияВЕТИС.СостояниеОбмена(ОрганизацииВЕТИС, Документ);
	
	Если ПустаяСтрока(АдресВоВременномХранилище) Тогда
		АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(РезультатыЗапроса, УникальныйИдентификатор);
	Иначе
		ПоместитьВоВременноеХранилище(РезультатыЗапроса, АдресВоВременномХранилище);
	КонецЕсли;
	
	ОтобразитьСостояниеОбмена(РезультатыЗапроса);
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьСостояниеОбмена(РезультатыЗапроса)
	
	НеЗаполненыСлужебныеРегистры(РезультатыЗапроса);
	
	// Расхождения при синхронизации классификаторов ВетИС:
	// 1. Критичное расхождение
	ПроблемыДлительногоОтсутствияОбмена(РезультатыЗапроса);
	// 2. Слабое расхождение
	ЕстьРасхожденияМеждуДатамиСинхронизацииЗаписейСкладскогоЖурналаИВСД(РезультатыЗапроса);
	
	// Причины расхождений:
	// 1. APLM
	ПроблемыAPLM0012ПриСинхронизацииВСД(РезультатыЗапроса);
	ПроблемыAPLM0012ПриСинхронизацииЗаписейСкладскогоЖурнала(РезультатыЗапроса);
	// 2. Прочие проблемы
	РасхожденияДатыСинхронизацииИДатыОбменаПоВСД(РезультатыЗапроса);
	РасхожденияДатыСинхронизацииИДатыОбменаПоЗаписямСкладскогоЖурнала(РезультатыЗапроса);
	
	// Рекомендуется выполнить обмен...
	ПроблемыАктуальностиВСД(РезультатыЗапроса);
	ПроблемыАктуальностиЗаписейСкладскогоЖурнала(РезультатыЗапроса);
	
	// Прочее
	ПроблемыССинхронизациейДокументов(РезультатыЗапроса);
	ПроблемыССинхронизациейСправочников(РезультатыЗапроса);
	
	ПроверитьСообщенияОжидающиеОтправки(РезультатыЗапроса);
	ПроверитьНастройкиРегламентногоЗадания();
	
КонецПроцедуры

&НаСервере
Процедура ПроблемыССинхронизациейДокументов(РезультатыЗапроса)
	
	Элементы["ВходящаяТранспортнаяОперацияВЕТИС"].Видимость        = Ложь;
	Элементы["ИнвентаризацияПродукцииВЕТИС"].Видимость             = Ложь;
	Элементы["ИсходящаяТранспортнаяОперацияВЕТИС"].Видимость       = Ложь;
	Элементы["ОбъединениеЗаписейСкладскогоЖурналаВЕТИС"].Видимость = Ложь;
	Элементы["ПроизводственнаяОперацияВЕТИС"].Видимость            = Ложь;
	
	СинонимыДокументов = Новый Соответствие;
	СинонимыДокументов.Вставить("ВходящаяТранспортнаяОперацияВЕТИС",        НСтр("ru = 'Входящие транспортные операции ВетИС'"));
	СинонимыДокументов.Вставить("ИнвентаризацияПродукцииВЕТИС",             НСтр("ru = 'Инвентаризации продукции ВетИС'"));
	СинонимыДокументов.Вставить("ИсходящаяТранспортнаяОперацияВЕТИС",       НСтр("ru = 'Исходящие транспортные операции ВетИС'"));
	СинонимыДокументов.Вставить("ОбъединениеЗаписейСкладскогоЖурналаВЕТИС", НСтр("ru = 'Объединения записей складского журнала ВетИС'"));
	СинонимыДокументов.Вставить("ПроизводственнаяОперацияВЕТИС",            НСтр("ru = 'Производственные операции ВетИС'"));
	
	ОбщееКоличество = 0;
	
	Выборка = РезультатыЗапроса["ЕстьПроблемыСОтправкойДокументов"].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если ТипЗнч(Выборка.Классификатор) = Тип("ДокументСсылка.ВходящаяТранспортнаяОперацияВЕТИС") Тогда
			ТипДокумента = "ВходящаяТранспортнаяОперацияВЕТИС";
		ИначеЕсли ТипЗнч(Выборка.Классификатор) = Тип("ДокументСсылка.ИнвентаризацияПродукцииВЕТИС") Тогда
			ТипДокумента = "ИнвентаризацияПродукцииВЕТИС";
		ИначеЕсли ТипЗнч(Выборка.Классификатор) = Тип("ДокументСсылка.ИсходящаяТранспортнаяОперацияВЕТИС") Тогда
			ТипДокумента = "ИсходящаяТранспортнаяОперацияВЕТИС";
		ИначеЕсли ТипЗнч(Выборка.Классификатор) = Тип("ДокументСсылка.ОбъединениеЗаписейСкладскогоЖурналаВЕТИС") Тогда
			ТипДокумента = "ОбъединениеЗаписейСкладскогоЖурналаВЕТИС";
		ИначеЕсли ТипЗнч(Выборка.Классификатор) = Тип("ДокументСсылка.ПроизводственнаяОперацияВЕТИС") Тогда
			ТипДокумента = "ПроизводственнаяОперацияВЕТИС";
		КонецЕсли;
		
		Элементы[ТипДокумента].Видимость = Выборка.Количество > 0;
		
		Если Элементы[ТипДокумента].Видимость Тогда
			
			ОбщееКоличество = ОбщееКоличество + Выборка.Количество;
			ТекстЗаголовка = Новый ФорматированнаяСтрока(
				СтрШаблон("%1 (%2)", СинонимыДокументов[ТипДокумента], Выборка.Количество),,,,
				ТипДокумента);
			Элементы[ТипДокумента].Заголовок = Новый ФорматированнаяСтрока(ТекстЗаголовка);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.ГруппаПроблемыСОтправкойДокументов.Видимость = ОбщееКоличество > 0;
	
КонецПроцедуры

#Область ЗаполнениеСтрокОшибок

&НаСервере
Процедура ПроблемыAPLM0012ПриСинхронизацииВСД(РезультатыЗапроса)
	
	ИдентификаторПроблемы = "ЕстьПроблемыAPLM0012ПриСинхронизацииВСД";
	ИмяЭлемента           = "ПроблемыAPLM0012ПриСинхронизацииВСД";
	
	Выборка = РезультатыЗапроса[ИдентификаторПроблемы].Выгрузить();
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Выборка.Количество() > 0;
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			СтрШаблон(
				НСтр("ru='Есть ошибки APLM0012 при синхронизации ветеринарно-сопроводительных документов (%1)'"),
				Выборка.Количество()),,,,
			ИдентификаторПроблемы);
		
		Элементы[ИмяЭлемента + "РасширеннаяПодсказка"].Заголовок = ИнтеграцияВЕТИСКлиентСервер.ПодсказкаКСостояниюОбмена(
			ИдентификаторПроблемы, Элементы[ИмяЭлемента + "РасширеннаяПодсказка"]);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроблемыAPLM0012ПриСинхронизацииЗаписейСкладскогоЖурнала(РезультатыЗапроса)
	
	ИдентификаторПроблемы = "ЕстьПроблемыAPLM0012ПриСинхронизацииЗаписейСкладскогоЖурнала";
	ИмяЭлемента           = "ПроблемыAPLM0012ПриСинхронизацииЗаписейСкладскогоЖурнала";
	
	Выборка = РезультатыЗапроса[ИдентификаторПроблемы].Выбрать();
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Выборка.Количество() > 0;
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			СтрШаблон(
				НСтр("ru='Есть ошибки APLM0012 при синхронизации записей складского журнала (%1)'"),
				Выборка.Количество()),,,,
			ИдентификаторПроблемы);
		
		Элементы[ИмяЭлемента + "РасширеннаяПодсказка"].Заголовок = ИнтеграцияВЕТИСКлиентСервер.ПодсказкаКСостояниюОбмена(
			ИдентификаторПроблемы, Элементы[ИмяЭлемента + "РасширеннаяПодсказка"]);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьСообщенияОжидающиеОтправки(РезультатыЗапроса)
	
	ИдентификаторПроблемы = "ЕстьСообщенияОжидающиеОтправки";
	ИмяЭлемента           = "ЕстьСообщенияОжидающиеОтправки";
	
	Выборка = РезультатыЗапроса[ИдентификаторПроблемы].Выбрать();
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Выборка.Следующий() И Выборка.Количество > 0;
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			СтрШаблон(
				НСтр("ru='Есть сообщения ожидающие отправки (%1)'"),
				Выборка.Количество),,,,
			ИдентификаторПроблемы);
		
		Элементы[ИмяЭлемента + "РасширеннаяПодсказка"].Заголовок = ИнтеграцияВЕТИСКлиентСервер.ПодсказкаКСостояниюОбмена(
			ИдентификаторПроблемы,
			Элементы[ИмяЭлемента]);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьНастройкиРегламентногоЗадания()
	
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	
	// ОтправкаПолучениеДанныхВЕТИС
	Отбор = Новый Структура;
	Отбор.Вставить("Метаданные",    "ОтправкаПолучениеДанныхВЕТИС");
	Отбор.Вставить("Использование", Истина);
	
	УстановитьПривилегированныйРежим(Истина);
	ЗаданиеВключено = РегламентныеЗаданияСервер.НайтиЗадания(Отбор).Количество() > 0;
	УстановитьПривилегированныйРежим(Ложь);
	
	Элементы.ГруппаРегламентноеЗадание.Видимость = (Не ЗаданиеВключено И Не РазделениеВключено);
	
	Если Элементы.ГруппаРегламентноеЗадание.Видимость Тогда
		
		ТекстЗаголовка = Новый ФорматированнаяСтрока(
			НСтр("ru='Рекомендуется настроить автоматический обмен с ВетИС'"),,,,
			"АвтоматическийОбмен");
		Элементы.РекомендуетсяНастроитьРегламентноеЗадание.Заголовок = ТекстЗаголовка;
		
	КонецЕсли;
	
	// СверткаРегистраСоответствиеНоменклатурыВЕТИС
	Если ИнтеграцияИС.СерииИспользуются() Тогда
		
		Отбор = Новый Структура;
		Отбор.Вставить("Метаданные",    "СверткаРегистраСоответствиеНоменклатурыВЕТИС");
		Отбор.Вставить("Использование", Истина);
		
		УстановитьПривилегированныйРежим(Истина);
		ЗаданиеВключено = РегламентныеЗаданияСервер.НайтиЗадания(Отбор).Количество() > 0;
		УстановитьПривилегированныйРежим(Ложь);
		
		Элементы.ГруппаРегламентноеЗаданиеСверткаРегистраСоответствиеНоменклатурыВЕТИС.Видимость = (Не ЗаданиеВключено
			И Не РазделениеВключено);
		
		Если Элементы.ГруппаРегламентноеЗаданиеСверткаРегистраСоответствиеНоменклатурыВЕТИС.Видимость Тогда
			
			ТекстЗаголовка = Новый ФорматированнаяСтрока(
				НСтр("ru='Рекомендуется настроить автоматическую свертку регистра соответствия номенклатуры ВетИС'"),,,,
				"АвтоматическийОбмен");
			Элементы.РекомендуетсяНастроитьСверткаРегистраСоответствиеНоменклатурыВЕТИС.Заголовок = ТекстЗаголовка;
			
		КонецЕсли;
	
	Иначе
		Элементы.ГруппаРегламентноеЗаданиеСверткаРегистраСоответствиеНоменклатурыВЕТИС.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РасхожденияДатыСинхронизацииИДатыОбменаПоВСД(РезультатыЗапроса)
	
	ИдентификаторПроблемы = "ЕстьРасхожденияДатыСинхронизацииИДатыОбменаПоВСД";
	ИмяЭлемента           = "ЕстьРасхожденияДатыСинхронизацииИДатыОбменаПоВСД";
	
	Выборка = РезультатыЗапроса[ИдентификаторПроблемы].Выбрать();
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Выборка.Количество() > 0;
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			СтрШаблон(
				НСтр("ru='Есть проблемы с синхронизацией ветеринарно-сопроводительных документов (%1)'"),
				Выборка.Количество()),,,,
			ИдентификаторПроблемы);
		
		Элементы[ИмяЭлемента + "РасширеннаяПодсказка"].Заголовок = ИнтеграцияВЕТИСКлиентСервер.ПодсказкаКСостояниюОбмена(
			ИдентификаторПроблемы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РасхожденияДатыСинхронизацииИДатыОбменаПоЗаписямСкладскогоЖурнала(РезультатыЗапроса)
	
	ИдентификаторПроблемы = "ЕстьРасхожденияДатыСинхронизацииИДатыОбменаПоЗаписямСкладскогоЖурнала";
	ИмяЭлемента           = "ЕстьРасхожденияДатыСинхронизацииИДатыОбменаПоЗаписямСкладскогоЖурнала";
	
	Выборка = РезультатыЗапроса[ИдентификаторПроблемы].Выбрать();
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Выборка.Количество() > 0;
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			СтрШаблон(
				НСтр("ru='Есть проблемы с синхронизацией записей складского журнала (%1)'"),
				Выборка.Количество()),,,,
			ИдентификаторПроблемы);
		
		Элементы[ИмяЭлемента + "РасширеннаяПодсказка"].Заголовок = ИнтеграцияВЕТИСКлиентСервер.ПодсказкаКСостояниюОбмена(
			ИдентификаторПроблемы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроблемыАктуальностиВСД(РезультатыЗапроса)
	
	ИдентификаторПроблемы = "НеАктуальныеВСД";
	ИмяЭлемента           = "ВСДНеАктуальны";
	
	Выборка = РезультатыЗапроса[ИдентификаторПроблемы].Выбрать();
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Выборка.Количество() > 0;
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			СтрШаблон(
				НСтр("ru='Ветеринарно-сопроводительные документы не актуальны (%1)'"),
				Выборка.Количество()),,,,
			ИдентификаторПроблемы);
		
		Элементы[ИмяЭлемента + "РасширеннаяПодсказка"].Заголовок = ИнтеграцияВЕТИСКлиентСервер.ПодсказкаКСостояниюОбмена(
			ИдентификаторПроблемы,
			Элементы[ИмяЭлемента]);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроблемыАктуальностиЗаписейСкладскогоЖурнала(РезультатыЗапроса)
	
	ИдентификаторПроблемы = "НеАктуальныеЗаписиСкладскогоЖурнала";
	ИмяЭлемента           = "ЗаписиСкладскогоЖурналаНеАктуальны";
	
	Выборка = РезультатыЗапроса[ИдентификаторПроблемы].Выбрать();
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Выборка.Количество() > 0;
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			СтрШаблон(
				НСтр("ru='Записи складского журнала не актуальны (%1)'"),
				Выборка.Количество()),,,,
			ИдентификаторПроблемы);
		
		Элементы[ИмяЭлемента + "РасширеннаяПодсказка"].Заголовок = ИнтеграцияВЕТИСКлиентСервер.ПодсказкаКСостояниюОбмена(
			ИдентификаторПроблемы,
			Элементы[ИмяЭлемента]);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроблемыССинхронизациейСправочников(РезультатыЗапроса)
	
	Элементы["ПродукцияВЕТИС"].Видимость             = Ложь;
	Элементы["ХозяйствующиеСубъектыВЕТИС"].Видимость = Ложь;
	Элементы["ПредприятияВЕТИС"].Видимость           = Ложь;
	Элементы["ЦелиВЕТИС"].Видимость                  = Ложь;
	
	СинонимыДокументов = Новый Соответствие;
	СинонимыДокументов.Вставить("ПродукцияВЕТИС",             НСтр("ru = 'Продукция ВетИС'"));
	СинонимыДокументов.Вставить("ХозяйствующиеСубъектыВЕТИС", НСтр("ru = 'Хозяйствующие субъекты'"));
	СинонимыДокументов.Вставить("ПредприятияВЕТИС",           НСтр("ru = 'Предприятия ВетИС'"));
	СинонимыДокументов.Вставить("ЦелиВЕТИС",                  НСтр("ru = 'Цели ВетИС'"));
	
	ОбщееКоличество = 0;
	
	Выборка = РезультатыЗапроса["ТребуетсяЗагрузкаЭлементовКлассификаторов"].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если ТипЗнч(Выборка.Классификатор) = Тип("СправочникСсылка.ПродукцияВЕТИС") Тогда
			ТипДокумента = "ПродукцияВЕТИС";
		ИначеЕсли ТипЗнч(Выборка.Классификатор) = Тип("СправочникСсылка.ХозяйствующиеСубъектыВЕТИС") Тогда
			ТипДокумента = "ХозяйствующиеСубъектыВЕТИС";
		ИначеЕсли ТипЗнч(Выборка.Классификатор) = Тип("СправочникСсылка.ПредприятияВЕТИС") Тогда
			ТипДокумента = "ПредприятияВЕТИС";
		ИначеЕсли ТипЗнч(Выборка.Классификатор) = Тип("СправочникСсылка.ЦелиВЕТИС") Тогда
			ТипДокумента = "ЦелиВЕТИС";
		КонецЕсли;
		
		Элементы[ТипДокумента].Видимость = Выборка.Количество > 0;
		
		Если Элементы[ТипДокумента].Видимость Тогда
			
			ОбщееКоличество = ОбщееКоличество + Выборка.Количество;
			ТекстЗаголовка = Новый ФорматированнаяСтрока(
				СтрШаблон("%1 (%2)", СинонимыДокументов[ТипДокумента], Выборка.Количество),,,,
				ТипДокумента);
			
			Элементы[ТипДокумента].Заголовок = Новый ФорматированнаяСтрока(ТекстЗаголовка);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.ГруппаТребуетсяЗагрузкаЭлементовКлассификаторов.Видимость = ОбщееКоличество > 0;
	
КонецПроцедуры

&НаСервере
Функция ПроблемыДлительногоОтсутствияОбмена(РезультатыЗапроса)
	
	ИдентификаторПроблемы = "ДлительноеОтсутствиеОбмена";
	ИмяЭлемента           = "ДлительноеОтсутствиеОбменов";
	
	Выборка = РезультатыЗапроса[ИдентификаторПроблемы].Выбрать();
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Выборка.Количество() > 0;
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		СтрокаЗаголовка = Новый ФорматированнаяСтрока(
			СтрШаблон(
				НСтр("ru='Обмен не выполнялся длительное время (%1)'"),
				Выборка.Количество()),,,,
			ИдентификаторПроблемы);
		
		Элементы[ИмяЭлемента].Заголовок = СтрокаЗаголовка;
		
		Элементы[ИмяЭлемента + "РасширеннаяПодсказка"].Заголовок = ИнтеграцияВЕТИСКлиентСервер.ПодсказкаКСостояниюОбмена(
			ИдентификаторПроблемы);
		
		Элементы[ИмяЭлемента + "РасширеннаяПодсказка"].Высота = СтрРазделить(Элементы[ИмяЭлемента + "РасширеннаяПодсказка"].Заголовок, Символы.ПС).Количество();
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Процедура ЕстьРасхожденияМеждуДатамиСинхронизацииЗаписейСкладскогоЖурналаИВСД(РезультатыЗапроса)
	
	ИдентификаторПроблемы = "ЕстьРасхожденияМеждуДатамиСинхронизацииЗаписейСкладскогоЖурналаИВСД";
	ИмяЭлемента           = "ЕстьРасхожденияМеждуДатамиСинхронизацииЗаписейСкладскогоЖурналаИВСД";
	
	Выборка = РезультатыЗапроса[ИдентификаторПроблемы].Выбрать();
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Выборка.Количество() > 0;
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			СтрШаблон(
				НСтр("ru='Рассинхронизация обмена по записям складского журнала и ветеринарно-сопроводительным документам (%1)'"),
				Выборка.Количество()),,,,
			ИдентификаторПроблемы);
		
		Элементы[ИмяЭлемента + "РасширеннаяПодсказка"].Заголовок = ИнтеграцияВЕТИСКлиентСервер.ПодсказкаКСостояниюОбмена(
			ИдентификаторПроблемы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НеЗаполненыСлужебныеРегистры(РезультатыЗапроса)
	
	ИдентификаторПроблемы = "НеЗаполненыСлужебныеРегистры";
	ИмяЭлемента           = "НеЗаполненыСлужебныеРегистры";
	
	НеЗаполненРегистрВидыПродукцииПоГруппамВЕТИС = РезультатыЗапроса["НеЗаполненРегистрВидыПродукцииПоГруппамВЕТИС"].Выбрать().Количество() > 0;
	НеЗаполненРегистрДопустимыеЦелиПоГруппамВЕТИС = РезультатыЗапроса["НеЗаполненРегистрДопустимыеЦелиПоГруппамВЕТИС"].Выбрать().Количество() > 0;
	
	Элементы["Группа" + ИмяЭлемента].Видимость = НеЗаполненРегистрВидыПродукцииПоГруппамВЕТИС
	                                         Или НеЗаполненРегистрДопустимыеЦелиПоГруппамВЕТИС;
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = НСтр("ru='Не заполнены служебные регистры'");
		
		Элементы[ИмяЭлемента + "РасширеннаяПодсказка"].Заголовок = ИнтеграцияВЕТИСКлиентСервер.ПодсказкаКСостояниюОбмена(
			ИдентификаторПроблемы,
			Элементы[ИмяЭлемента]);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция УдалитьЗаписиСинхронизации()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ХозяйствующиеСубъекты = Новый Массив;
	
	РезультатыЗапроса = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	Выборка = РезультатыЗапроса["ДлительноеОтсутствиеОбмена"].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей = РегистрыСведений.СинхронизацияКлассификаторовВЕТИС.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ХозяйствующийСубъект.Установить(Выборка.ХозяйствующийСубъект);
		НаборЗаписей.Отбор.Предприятие.Установить(Выборка.Предприятие);
		
		НаборЗаписей.Записать(Истина);
		
		ЗаписьДобавленаВОтбор = Ложь;
		Для Каждого ЭлементДанных Из ХозяйствующиеСубъекты Цикл
			Если ЭлементДанных.Организация = Выборка.ХозяйствующийСубъект Тогда
				Если ЭлементДанных.Предприятия.Найти(Выборка.Предприятие) = Неопределено Тогда
					ЭлементДанных.Предприятия.Добавить(Выборка.Предприятие);
					ЗаписьДобавленаВОтбор = Истина;
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Если Не ЗаписьДобавленаВОтбор Тогда
			Предприятия = Новый Массив;
			Предприятия.Добавить(Выборка.Предприятие);
			ОрганизацияПредприятие = Новый Структура(
				"Организация, Предприятия, ВсеПредприятияВыбраны",
				Выборка.ХозяйствующийСубъект,
				Предприятия,
				Ложь);
			ХозяйствующиеСубъекты.Добавить(ОрганизацияПредприятие);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ХозяйствующиеСубъекты;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСлужебныеРегистрыНаСервере()
	
	ДопустимыеЦелиВетИС.ЗаполнитьДанныеВРегистреВидыПродукцииПоГруппамПриказаВЕТИС();
	ДопустимыеЦелиВетИС.ЗаполнитьДанныеВРегистреДопустимыеЦелиПоГруппамПриказаВЕТИС();
	
КонецПроцедуры

&НаСервере
Процедура СброситьРазмерыИПоложениеОкна()
	
	ИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		ХранилищеСистемныхНастроек.Удалить("Обработка.ПанельОбменВЕТИС.Форма.СостояниеОбмена", "", ИмяПользователя);
	КонецЕсли;
	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
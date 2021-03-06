
#Область ОбработчикиСобытийФормы     

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)    
	
	Организация = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.ТекущийПользователь(),	"ОсновнаяОрганизация");  
	РабочееМесто =  МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();        
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТипПодключаемогоОборудования", Перечисления.ТипыПодключаемогоОборудования.ККМОфлайн);
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПравилаОбменаСПодключаемымОборудованиемOffline.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПравилаОбменаСПодключаемымОборудованиемOffline КАК ПравилаОбменаСПодключаемымОборудованиемOffline
	|ГДЕ
	|	ПравилаОбменаСПодключаемымОборудованиемOffline.ТипПодключаемогоОборудования = &ТипПодключаемогоОборудования";
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		ПравилоОбмена = Выборка.Ссылка;
	КонецЕсли; 
	
	РаботаетВМоделиСервиса = ОбщегоНазначения.РазделениеВключено(); 
	ПроверитьАдресПубликацииНаСервере();
	
КонецПроцедуры  

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)     
	
	Если ИмяСобытия = "Запись_НаборКонстант" Тогда 
		ПроверитьАдресПубликацииНаСервере();
	КонецЕсли;                 
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательПриИзменении(Элемент)
	
	ЗаполнитьКодыПодключения();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьНайтиОборудование(Команда)    
	
	Отказ = Ложь;
	ПроверитьЗаполнениеРеквизитов(Отказ, Истина);
	Если Не Отказ Тогда 
		
		СоздатьНайтиОборудованиеНаСервере(); 
		ДоступностьЭлементовФормы();	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьШтрихкод(Команда)    
	
	Отказ = Ложь;
	ПроверитьЗаполнениеРеквизитов(Отказ);
	Если Не Отказ Тогда 
		
		ЗаполнитьКодыПодключения();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоПочте(Команда)
	
	ОчиститьСообщения();
	ОтправитьПоПочтеСервер();
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции     

&НаКлиенте
Процедура ПроверитьЗаполнениеРеквизитов(Отказ, СозданиеОборудования = Ложь)
	
	ОчиститьСообщения();
	
	ШаблонСообщения = НСтр("ru = 'Поле %1 не заполнено'");
	
	Если НЕ ЗначениеЗаполнено(РабочееМесто)  Тогда
		ТекстСообщения = СтрШаблон(ШаблонСообщения, НСтр("ru='Рабочее место'"));
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"РабочееМесто",,Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация)  Тогда
		ТекстСообщения = СтрШаблон(ШаблонСообщения, НСтр("ru='Организация'"));
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"Организация",,Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторWebСервисОборудования)  Тогда
		ТекстСообщения = СтрШаблон(ШаблонСообщения, НСтр("ru='Идентификатор оборудования'"));
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"ИдентификаторWebСервисОборудования",,Отказ);
	КонецЕсли;      
	
	Если НЕ ЗначениеЗаполнено(ПравилоОбмена)  Тогда
		ТекстСообщения = СтрШаблон(ШаблонСообщения, НСтр("ru='Правило обмена'"));
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"ПравилоОбмена",,Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПодключаемоеОборудование) И НЕ СозданиеОборудования Тогда
		ТекстСообщения = НСтр("ru='Не создано/не найдено подключаемое оборудование'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"ПодключаемоеОборудование",,Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(АдресПубликации)  И НЕ СозданиеОборудования Тогда
		ТекстСообщения = НСтр("ru='Адрес публикации в Интернете не заполнен'");  
		Если РаботаетВМоделиСервиса Тогда
			ИмяРеквизита = "АдресПубликацииВМоделиСервиса";
		Иначе
			ИмяРеквизита = "АдресПубликации";
		КонецЕсли; 
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,ИмяРеквизита,,Отказ);
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(Пользователь) И НЕ СозданиеОборудования  Тогда
		ТекстСообщения = СтрШаблон(ШаблонСообщения, НСтр("ru='Пользователь приложения'"));
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"Пользователь",,Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьНайтиОборудованиеНаСервере()     
	
	Элементы.ДекорацияNEW.Видимость = Ложь;   
	СтруктураКлючевыхПараметров = Новый Структура;  
	СтруктураКлючевыхПараметров.Вставить("ДрайверОборудования", Справочники.ДрайверыОборудования.Драйвер1СККМOffline);				
	СтруктураКлючевыхПараметров.Вставить("ТипОборудования", Перечисления.ТипыПодключаемогоОборудования.ККМОфлайн);				
	СтруктураКлючевыхПараметров.Вставить("РабочееМесто", РабочееМесто);				
	СтруктураКлючевыхПараметров.Вставить("ИдентификаторWebСервисОборудования", ИдентификаторWebСервисОборудования);				
	
	НачатьТранзакцию();
	Попытка
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("Справочник.ПодключаемоеОборудование");
		ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Разделяемый;
		БлокировкаДанных.Заблокировать();
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ПодключаемоеОборудование.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|ГДЕ
		|	ПодключаемоеОборудование.ДрайверОборудования = &ДрайверОборудования
		|	И ПодключаемоеОборудование.ИдентификаторWebСервисОборудования = &ИдентификаторWebСервисОборудования
		|	И ПодключаемоеОборудование.ТипОборудования = &ТипОборудования
		|	И ПодключаемоеОборудование.РабочееМесто = &РабочееМесто";  
		Для Каждого Параметр Из СтруктураКлючевыхПараметров Цикл
			Запрос.УстановитьПараметр(Параметр.Ключ, Параметр.Значение);
		КонецЦикла;
		РезультатЗапроса = Запрос.Выполнить();   
		Если НЕ РезультатЗапроса.Пустой() Тогда  
			
			Выборка = РезультатЗапроса.Выбрать();   
			Выборка.Следующий();  
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник.ПодключаемоеОборудование");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			ПодключаемоеОборудованиеОбъект = Выборка.Ссылка.ПолучитьОбъект();  
			
			ЭтоНовыйЭлемент = Ложь;
			Элементы.ГруппаОборудованиеНиз.Видимость = Истина;    
		Иначе
			ПодключаемоеОборудованиеОбъект = Справочники.ПодключаемоеОборудование.СоздатьЭлемент(); 
			ЭтоНовыйЭлемент = Истина;
		КонецЕсли;   
		
		ЗаполнитьЗначенияСвойств(ПодключаемоеОборудованиеОбъект, СтруктураКлючевыхПараметров);     
		ПодключаемоеОборудованиеОбъект.Организация = Организация;    
		Наименование = НСтр("ru='Проверка ценников (%1)'");
		ПодключаемоеОборудованиеОбъект.Наименование = СтрШаблон(Наименование,  ИдентификаторWebСервисОборудования);
		ПодключаемоеОборудованиеОбъект.УстройствоИспользуется = Истина;
		ПодключаемоеОборудованиеОбъект.ПравилоОбмена = ПравилоОбмена;
		ПодключаемоеОборудованиеОбъект.Записать();     
		
		ПараметрыОборудования = Новый Структура;
		ПараметрыОборудования.Вставить("ВерсияФорматаОбмена", 1007);
		ПараметрыОборудования.Вставить("ВидТранспортаОфлайнОбмена", Перечисления.ВидыТранспортаОфлайнОбмена.WS);
		ПараметрыОборудования.Вставить("ИдентификаторWebСервисОборудования", ИдентификаторWebСервисОборудования);
		ПараметрыОборудования.Вставить("КоличествоЭлементовВПакете", КоличествоЭлементовВПакете);
		
		РезультатЗаписиНастроек = МенеджерОборудованияВызовСервера.СохранитьПараметрыУстройства(ПодключаемоеОборудованиеОбъект.Ссылка, ПараметрыОборудования);
		
		Если НЕ РезультатЗаписиНастроек Тогда 
			СообщениеОбОшибке = НСтр("ru='Не удалось сохранить параметры устройства.'");
			ВызватьИсключение СообщениеОбОшибке;
		КонецЕсли;
		
  		ЗафиксироватьТранзакцию();		
	Исключение   
		ОтменитьТранзакцию();
		ОбщегоНазначения.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));    
		Возврат;
	КонецПопытки;   
	
	ПодключаемоеОборудование = ПодключаемоеОборудованиеОбъект.Ссылка;
	Элементы.ДекорацияNEW.Видимость = ЭтоНовыйЭлемент;   
	Элементы.ГруппаОборудованиеНиз.Видимость = Истина;
	ЗаполнитьКодыПодключения();
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьАдресПубликацииНаСервере()  
	
	Если НЕ РаботаетВМоделиСервиса Тогда 
		АдресПубликации = Константы.АдресПубликацииИнформационнойБазыВИнтернете.Получить();
		Если ПустаяСтрока(АдресПубликации)
			И Не ОбщегоНазначения.РазделениеВключено() Тогда
			Элементы.ДекорацияQRКодНадпись.Заголовок = 
			НСтр("ru = 'Не заполнен адрес публикации информационной базы в интернете:
			|Настройки - Общие настройки - Публикация информационной базы'");
			Элементы.АдресПубликации.Видимость = Ложь;
			Элементы.ГруппаQRПредупреждение.Видимость = Истина;
		Иначе
			Элементы.ГруппаQRПредупреждение.Видимость = Ложь;
			Элементы.АдресПубликации.Видимость = Истина;
			ЗаполнитьКодыПодключения();
		КонецЕсли; 
		Элементы.ГруппаСтраницыПубликация.ТекущаяСтраница = Элементы.СтраницаРаботаИзКоробки;
	Иначе
		Элементы.ГруппаСтраницыПубликация.ТекущаяСтраница = Элементы.СтраницаРаботаВМоделиСервиса;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПерейтиНажатие(Элемент)  
	
	ОткрытьФорму(
	"Обработка.ПанельАдминистрированияБСП.Форма.ОбщиеНастройки",
	Новый Структура,
	,
	"Обработка.ПанельАдминистрированияБСП.Форма.ОбщиеНастройки.ОтдельноеОкно",	);
	
	
КонецПроцедуры   

&НаСервере
Процедура ЗаполнитьКодыПодключения()     
	
	ТабличныйДокумент.Очистить();
	
	Если Не ЗначениеЗаполнено(ИдентификаторWebСервисОборудования)
		ИЛИ  Не ЗначениеЗаполнено(ПодключаемоеОборудование) 
		ИЛИ  Не ЗначениеЗаполнено(АдресПубликации)
		ИЛИ  Не ЗначениеЗаполнено(Пользователь) Тогда
		Возврат;
	КонецЕсли;
	
	МассивПользователей = Новый Массив;
	МассивПользователей.Добавить(Пользователь);   
	
	СтруктураНастроекПриложения = Новый Структура("Код, Наименование, АдресПубликации",
	ИдентификаторWebСервисОборудования,
	ПодключаемоеОборудование.Наименование,
	АдресПубликации);
	УправлениеМобильнымиПриложениями.ЗаполнитьКодыПодключения(
	КодыПодключения, СтруктураНастроекПриложения, МассивПользователей, ТабличныйДокумент);   
	
КонецПроцедуры   

&НаСервере
Процедура ОтправитьПоПочтеСервер()
	
	СтруктураНастроекПриложения = Новый Структура("МобильноеПриложение, Наименование",
	ПодключаемоеОборудование.Наименование,
	ПодключаемоеОборудование.Наименование);
	ОтправкаЗавершенаУспешно = УправлениеМобильнымиПриложениями.ОтправитьКодыПодключения(КодыПодключения, СтруктураНастроекПриложения);
	Если Не ОтправкаЗавершенаУспешно Тогда
		Возврат;
	КонецЕсли;
	Для Каждого Строка Из КодыПодключения Цикл
		Если Строка.ПисьмоОтправлено Тогда
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Отправка завершена'"));
		Иначе
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не указан адрес электронной почты пользователя %1.'"), Строка.Пользователь);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры        

&НаКлиенте
Процедура ДоступностьЭлементовФормы()     
	
	Элементы.РабочееМесто.Доступность =							НЕ ЗначениеЗаполнено(ПодключаемоеОборудование) ;
	Элементы.Организация.Доступность = 							НЕ ЗначениеЗаполнено(ПодключаемоеОборудование) ;
	Элементы.КоличествоЭлементовВПакете.Доступность =			НЕ ЗначениеЗаполнено(ПодключаемоеОборудование) ;
	Элементы.ПравилоОбмена.Доступность =						НЕ ЗначениеЗаполнено(ПодключаемоеОборудование) ;      
	Элементы.ИдентификаторWebСервисОборудования.Доступность =	НЕ ЗначениеЗаполнено(ПодключаемоеОборудование) ;      
	Элементы.СоздатьОбновитьОборудование.Доступность =			НЕ ЗначениеЗаполнено(ПодключаемоеОборудование) ;      
КонецПроцедуры

#КонецОбласти


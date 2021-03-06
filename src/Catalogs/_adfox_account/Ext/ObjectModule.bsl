
Процедура Синхронизировать() Экспорт

	Синхронизировать_adfox_advertiser();
	Синхронизировать_adfox_position();
	Синхронизировать_adfox_bannerType();
	Синхронизировать_adfox_category();
	Синхронизировать_adfox_website();
	Синхронизировать_adfox_zone();
	Синхронизировать_adfox_place();
	
КонецПроцедуры

Процедура СинхронизироватьКампании() Экспорт
	
	Синхронизировать_adfox_campaign();
	Синхронизировать_adfox_banner();
	
КонецПроцедуры







Функция ПолучитьДанные_adfox_account_list(actionObject, limit = 10, offset = 0, ДополнительныеПараметры = Неопределено)
	
	Соединение = Новый HTTPСоединение("adfox.yandex.ru", 443,,,,,Новый ЗащищенноеСоединениеOpenSSL(),Ложь);
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("X-Yandex-API-Key", X_Yandex_API_Key); 
	//Заголовки.Вставить("Accept-Encoding", "gzip"); 
	
	Параметры = Новый Структура("object, action, actionObject, limit, offset", "account", "list", actionObject, limit, offset);
	
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") Тогда 
		Для Каждого Параметр Из ДополнительныеПараметры Цикл
			Параметры.Вставить(Параметр.Ключ, Параметр.Значение);
		КонецЦикла;
	КонецЕсли;
	
	СтрокаПараметров = "?encoding=UTF8";
	
	Для каждого Параметр из Параметры Цикл 
		СтрокаПараметров = СтрокаПараметров + "&" + Параметр.Ключ  + "=" + Параметр.Значение;
	КонецЦикла;
    
	Запрос = Новый HTTPЗапрос("/api/v1" + СтрокаПараметров, Заголовки);

	Ответ = Соединение.Получить(Запрос);
	
	Если Ответ.КодСостояния <> 200 Тогда 
		Возврат Неопределено;
	Иначе
		Результат = ПрочитатьXMLВСтруктуру(Ответ.ПолучитьТелоКакСтроку());
		Если Результат.status.code <> "0" Тогда
			Возврат Неопределено;
		Иначе
			Возврат Результат
		КонецЕсли;
	КонецЕсли;
КонецФункции

Функция ПрочитатьXMLВСтруктуру(Строка)
	
	Попытка 
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.УстановитьСтроку(Строка);
		ЧтениеXML.ПерейтиКСодержимому();
		ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
		ЧтениеXML.Закрыть();
	Исключение
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Ошибка: " + ОписаниеОшибки();
		Сообщение.Сообщить();
	КонецПопытки;
	
	Результат = ОбъектXDTO_в_Структуру(ОбъектXDTO);

	Возврат Результат;
                
КонецФункции

Функция ОбъектXDTO_в_Структуру(ОбъектXDTO)

	Структура = Новый Структура;
	
	Для Каждого Свойство Из ОбъектXDTO.Свойства() Цикл
		Имя = Свойство.Имя;
		Структура.Вставить(Имя);
		Если ТипЗнч(ОбъектXDTO[Имя]) = Тип("Строка") Тогда
			Структура[Имя] = ОбъектXDTO[Имя];
		ИначеЕсли ТипЗнч(ОбъектXDTO[Имя]) = Тип("ОбъектXDTO") Тогда 
			Структура[Имя] = ОбъектXDTO_в_Структуру(ОбъектXDTO[Имя]);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Структура;

КонецФункции


Функция ПолучитьДату(YYYY_DD_MM)
	
	Если ТипЗнч(YYYY_DD_MM) = Тип("Структура") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	YYYY = Лев(YYYY_DD_MM, 4);
	MM = Сред(YYYY_DD_MM, 6, 2);
	DD = Сред(YYYY_DD_MM, 9, 2);
	
	Попытка 
		Результат = Дата(Число(YYYY),Число(MM),Число(DD));
	Исключение
		Результат = Неопределено;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции


Процедура Синхронизировать_adfox_list_actionObject(actionObject, СправочникМенеджер, СправочникМенеджерРодитель = Неопределено, actionObject_РодительID = "", СвойствоНаименование = "name", ДополнительныеПараметры = Неопределено);

	Загружать = Истина;
	limit = 20;
	offset = 0;
	Пока Загружать Цикл 
		Данные = ПолучитьДанные_adfox_account_list(actionObject, limit, offset, ДополнительныеПараметры);
		Если Данные = Неопределено Тогда
			Возврат;
		КонецЕсли;                                            
		Если НЕ (Данные.Свойство("result") И Данные.result.Свойство("data")) Тогда
			Возврат;
		КонецЕсли;                                            
		
		Для Каждого ЭлементСтруктура Из Данные.result.data Цикл
			Элемент = ЭлементСтруктура.Значение;
			Если Элемент.Свойство("ID") Тогда 
				
				Если СправочникМенеджерРодитель = Неопределено Тогда 
					ВладелецСсылка = Ссылка;
				Иначе
					Если Элемент.Свойство(actionObject_РодительID) Тогда
						ВладелецСсылка = СправочникМенеджерРодитель.НайтиПоКоду(Число(Элемент[actionObject_РодительID]));
						Если ВладелецСсылка.Пустая() Тогда
							Продолжить;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
				Код = Элемент.ID;
				НовыйЭлементСсылка = СправочникМенеджер.НайтиПоКоду(Код,Ложь,,ВладелецСсылка);
				Если НовыйЭлементСсылка.Пустая() Тогда 
					НовыйЭлементОбъект = СправочникМенеджер.СоздатьЭлемент();
				Иначе
					НовыйЭлементОбъект = НовыйЭлементСсылка.ПолучитьОбъект();
				КонецЕсли;
				НовыйЭлементОбъект.Код = Код;
				Если Не Элемент.Свойство(СвойствоНаименование, НовыйЭлементОбъект.Наименование) Тогда 
					НовыйЭлементОбъект.Наименование = "<Нет>";
				КонецЕсли;
				ЗаполнитьЗначенияСвойств(НовыйЭлементОбъект, Элемент);
				
				МассивЭлементовСТипомДата = Новый Массив;                            
				МассивЭлементовСТипомДата.Добавить("dateAdded");
				МассивЭлементовСТипомДата.Добавить("dateStart");
				МассивЭлементовСТипомДата.Добавить("dateEnd");
				МассивЭлементовСТипомДата.Добавить("dateFinished");
				
				Для Каждого ИмяРеквизита Из МассивЭлементовСТипомДата Цикл 
					
					Если (НовыйЭлементОбъект.Метаданные().Реквизиты.Найти(ИмяРеквизита) <> Неопределено) и Элемент.Свойство(ИмяРеквизита) Тогда 
						НовыйЭлементОбъект[ИмяРеквизита] = ПолучитьДату(Элемент[ИмяРеквизита]);
					КонецЕсли;
					
				КонецЦикла;
				
				НовыйЭлементОбъект.Владелец = ВладелецСсылка;
				НовыйЭлементОбъект.Записать();
			КонецЕсли;
		КонецЦикла;
		Если (Данные.result.Свойство("page") и Данные.result.Свойство("total_pages")) и (Число(Данные.result.page) < Число(Данные.result.total_pages)) Тогда 
			Если Данные.result.Свойство("limit") и Данные.result.limit <> limit Тогда 
				limit = Данные.result.limit;
			КонецЕсли;
			offset = offset + limit;
		Иначе 
			Загружать = Ложь;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Процедура Синхронизировать_adfox_advertiser()

	Синхронизировать_adfox_list_actionObject("advertiser", Справочники._adfox_advertiser,,,"account");

КонецПроцедуры

Процедура Синхронизировать_adfox_position()

	Синхронизировать_adfox_list_actionObject("position", Справочники._adfox_position);

КонецПроцедуры

Процедура Синхронизировать_adfox_bannerType()

	Синхронизировать_adfox_list_actionObject("bannerType", Справочники._adfox_bannerType);

КонецПроцедуры

Процедура Синхронизировать_adfox_category()

	Синхронизировать_adfox_list_actionObject("actionObject", Справочники._adfox_category);

КонецПроцедуры

Процедура Синхронизировать_adfox_website()

	Синхронизировать_adfox_list_actionObject("website", Справочники._adfox_website);

КонецПроцедуры

Процедура Синхронизировать_adfox_campaign()
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("dateAddedFrom", Формат(dateAddedFrom, "ДФ=yyyy-MM-dd"));
	ДополнительныеПараметры.Вставить("dateAddedTo", Формат(dateAddedTo, "ДФ=yyyy-MM-dd"));
	
	Синхронизировать_adfox_list_actionObject("campaign", Справочники._adfox_campaign,,,,ДополнительныеПараметры);

КонецПроцедуры

Процедура Синхронизировать_adfox_banner()
	
	listCampaignIDs = "";

	Запрос = Новый Запрос;
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	_adfox_campaign.Код КАК Код
		|ИЗ
		|	Справочник._adfox_campaign КАК _adfox_campaign
		|ГДЕ
		|	_adfox_campaign.dateAdded МЕЖДУ &dateAddedFrom И &dateAddedTo";
	
	Запрос.УстановитьПараметр("dateAddedFrom", dateAddedFrom);
	Запрос.УстановитьПараметр("dateAddedTo", dateAddedTo);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		listCampaignIDs = listCampaignIDs + ?(listCampaignIDs = "","",",") + ВыборкаДетальныеЗаписи.Код;
	КонецЦикла;
	
	listCampaignIDs = СтрЗаменить(listCampaignIDs, " ", "");
	listCampaignIDs = СтрЗаменить(listCampaignIDs, Символы.НПП, "");
	
	ДополнительныеПараметры = Новый Структура("listCampaignIDs", listCampaignIDs);
	
	Синхронизировать_adfox_list_actionObject("banner", Справочники._adfox_banner, Справочники._adfox_campaign, "campaignID",,ДополнительныеПараметры);

КонецПроцедуры

Процедура Синхронизировать_adfox_zone()

	Синхронизировать_adfox_list_actionObject("zone", Справочники._adfox_zone, Справочники._adfox_website, "siteID");

КонецПроцедуры

Процедура Синхронизировать_adfox_place()

	Синхронизировать_adfox_list_actionObject("place", Справочники._adfox_place, Справочники._adfox_zone, "zoneID");

КонецПроцедуры





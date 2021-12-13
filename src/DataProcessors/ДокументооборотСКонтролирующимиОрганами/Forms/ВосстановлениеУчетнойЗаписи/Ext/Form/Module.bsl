﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		
		Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		
			Модуль = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации");
			Организация = Модуль.ОрганизацияПоУмолчанию();
			
		Иначе
			Организация = ЭлектронныйДокументооборотСКонтролирующимиОрганамиПереопределяемый.ОсновнаяОрганизация();
		КонецЕсли;
	КонецЕсли;
	
	НастройкаПользователей();
		
	УправлениеФормой(ЭтаФорма);
	
	УправлениеКнопкамиНавигации(ЭтаФорма);
	
	ЗаполнитьДанныеСлужбыПоддержки(ЭтаФорма);
	
	Элементы.ПояснениеПоЭПВМоделиСервиса.Видимость = ЭлектроннаяПодписьВМоделиСервисаКлиентСервер.ИспользованиеВозможно();
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КоманднаяПанельМастерНазад(Команда)
	
	ПоказатьПредыдущуюСтраницу();
	
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельМастерДалее(Команда)
	
	ТекущаяСтраница = Элементы.ОсновнаяПанель.ТекущаяСтраница;
	ОчиститьСообщения();
	МастерДалее = Истина;
	
	Если ТекущаяСтраница = Элементы.СтраницаВыборОрганизации Тогда
		
		МастерДалее = Истина;
		
		Если Не ЗначениеЗаполнено(ИдентификаторАбонента) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Укажите идентификатор абонента'"), ,"ИдентификаторАбонента");
			МастерДалее = Ложь;
		ИначеЕсли СтрДлина(ИдентификаторАбонента) <> 36 И СтрДлина(ИдентификаторАбонента) <> 39 Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Указан некорректный идентификатор абонента'"), ,"ИдентификаторАбонента");
			МастерДалее = Ложь;
		КонецЕсли;
		
		Элементы.ПодсказкаПоРезультатамШаг2.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выберите пользователей, которые будут иметь право использовать 1С-Отчетность по %1'"),
			Организация);
			
		Элементы.ПодсказкаКонечныйРезультат.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Поздравляем!
                  |Учетная запись по %1 успешно восстановлена'"),
			Организация);
			
			
		Если МастерДалее Тогда
			ВыполнитьНастройкуУчетнойЗаписи();		
		КонецЕсли;
		
	ИначеЕсли ТекущаяСтраница = Элементы.ОсновнаяПанель.ПодчиненныеЭлементы.СтраницаНастройкаПрограммы Тогда
		МастерДалее = Истина;
		ОбновитьПользователейУчетнойЗаписи(Истина);
		
		Если МастерДалее Тогда
			ПоказатьСледующуюСтраницу();
		КонецЕсли;
		
	Иначе
		
		Если МастерДалее Тогда			
			ПоказатьСледующуюСтраницу();
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастройкаПользователей()
	
	СписокПользователей.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫБОР
	|		КОГДА Настройки.УчетнаяЗапись ЕСТЬ NULL 
	|			ТОГДА Ложь
	|		ИНАЧЕ Истина
	|	КОНЕЦ КАК Пометка,
	|	Пользователи.Ссылка КАК Пользователь
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ПользователиУчетныхЗаписейДокументооборота.УчетнаяЗапись КАК УчетнаяЗапись,
	|			ПользователиУчетныхЗаписейДокументооборота.Пользователь КАК Пользователь
	|		ИЗ
	|			РегистрСведений.ПользователиУчетныхЗаписейДокументооборота КАК ПользователиУчетныхЗаписейДокументооборота
	|		ГДЕ
	|			ПользователиУчетныхЗаписейДокументооборота.УчетнаяЗапись = &УчетнаяЗапись) КАК Настройки
	|		ПО Пользователи.Ссылка = Настройки.Пользователь
	|ГДЕ
	|	НЕ Пользователи.ПометкаУдаления
	|	И НЕ Пользователи.Недействителен
	|	И НЕ Пользователи.Служебный
	|	И Пользователи.ИдентификаторПользователяИБ <> &ПустойИдентификаторПользователяИБ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Пользователи.Наименование";
	Запрос.УстановитьПараметр("УчетнаяЗапись", Справочники.УчетныеЗаписиДокументооборота.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустойИдентификаторПользователяИБ", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	Выборка = Запрос.Выполнить().Выбрать();
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	Пока Выборка.Следующий() Цикл 
		Если Выборка.Пользователь = ТекущийПользователь Тогда 
			Картинка = БиблиотекаКартинок.Пользователь;
		Иначе 
			Картинка = Неопределено;
		КонецЕсли;
		СписокПользователей.Добавить(Выборка.Пользователь, Выборка.Пользователь.Наименование, Выборка.Пометка, Картинка);
	КонецЦикла;

	СтрокаПользователь = СписокПользователей.НайтиПоЗначению(ТекущийПользователь);
	Если СтрокаПользователь <> Неопределено Тогда 
		СтрокаПользователь.Пометка = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		Элементы.Организация.ТолькоПросмотр = Истина; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеКнопкамиНавигации(Форма)
	
	Элементы = Форма.Элементы;
	
	ТекущаяСтраница 		= Элементы.ОсновнаяПанель.ТекущаяСтраница;
	ИндексТекущейСтраницы 	= Элементы.ОсновнаяПанель.ПодчиненныеЭлементы.Индекс(ТекущаяСтраница);
	ВсегоСтраниц 			= Элементы.ОсновнаяПанель.ПодчиненныеЭлементы.Количество();
		
	КнопкаДалее	  = Элементы.Далее;
	КнопкаНазад   = Элементы.Назад;
	КнопкаЗакрыть = Элементы.Закрыть;
	
	КнопкаДалее.Заголовок = НСтр("ru = 'Далее>'");
	КнопкаДалее.Видимость = Истина;
	КнопкаНазад.Заголовок = НСтр("ru = '<Назад'");
	КнопкаНазад.Видимость = Истина;
	
	Если ИндексТекущейСтраницы = 0 Тогда
		КнопкаЗакрыть.Заголовок 			= НСтр("ru = 'Отмена'");
		КнопкаДалее.Видимость 				= Истина;
		КнопкаНазад.Видимость 				= Ложь;
		КнопкаДалее.КнопкаПоУмолчанию 		= Истина;
		
	ИначеЕсли ИндексТекущейСтраницы = ВсегоСтраниц - 1 Тогда
		//последняя закладка
		КнопкаДалее.Видимость 				= Ложь;
		КнопкаНазад.Видимость 				= Ложь;
		КнопкаЗакрыть.Заголовок 			= НСтр("ru = 'Закрыть'");
		КнопкаЗакрыть.КнопкаПоУмолчанию 	= Истина;
	Иначе	
		//все остальные закладки
		КнопкаЗакрыть.Заголовок 			= НСтр("ru = 'Отмена'");
		КнопкаНазад.Видимость 				= Истина;
		КнопкаДалее.Видимость 				= Истина;
		КнопкаДалее.КнопкаПоУмолчанию 		= Истина;	
	КонецЕсли;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьДанныеСлужбыПоддержки(Форма)

	Форма.ТелефонСлужбыПоддержки = "";
	Форма.АдресЭлектроннойПочтыСлужбыПоддержки = "";

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьНастройкуУчетнойЗаписи()
	
	ДатаПолученияОтвета = КонтекстЭДОКлиент.ТекущаяДатаНаСервере();
	// Создание учетной записи 
	ПараметрыОбработатьОбновление = КонтекстЭДОКлиент.ПараметрыОбработатьОбновление();
	
	ПараметрыОбработатьОбновление.ИдентификаторАбонента          = ?(СтрДлина(ИдентификаторАбонента) = 36, ИдентификаторАбонента, Сред(ИдентификаторАбонента, 4));
	ПараметрыОбработатьОбновление.СпецОператорСвязи              = ПредопределенноеЗначение("Перечисление.СпецоператорыСвязи.КалугаАстрал");
	ПараметрыОбработатьОбновление.ПутьКонтейнерЗакрытогоКлюча    = ПутьКонтейнерЗакрытогоКлюча;
	ПараметрыОбработатьОбновление.Организация                    = Организация;
	
	ПараметрыОбработатьОбновление.ВызовИзМастераПодключенияК1СОтчетности = Истина;
	
	ДополнительныеПараметры = Новый Структура("ПараметрыОбработатьОбновление", ПараметрыОбработатьОбновление);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьНастройкуУчетнойЗаписиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	КонтекстЭДОКлиент.ОбработатьОбновление(ПараметрыОбработатьОбновление, ОписаниеОповещения);
		
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьНастройкуУчетнойЗаписиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ПараметрыОбработатьОбновление = Результат.ПараметрыФункции;
	РезультатОбновления = Результат.РезультатОбновления;
	
	Если РезультатОбновления <> Истина Тогда
		ПодробноеОписаниеОшибки = ПараметрыОбработатьОбновление.ТекстОшибокДляМастераПодключенияК1СОтчетности;
	КонецЕсли;

	МастерДалее = Истина;	
	Если РезультатОбновления = Истина Тогда
		ОбновитьПользователейУчетнойЗаписи();
		СохранитьСостояниеПФР();
		МастерДалее = Ложь;
	ИначеЕсли РезультатОбновления = Ложь Тогда
		Элементы.ОсновнаяПанель.ТекущаяСтраница = Элементы.СтраницаРезультат;
		Элементы.СтраницыРезультата.ТекущаяСтраница = Элементы.СтраницаРезультатОшибка;
	КонецЕсли;
	
	Если МастерДалее Тогда
		ПоказатьСледующуюСтраницу();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьСостояниеПФР()
	
	// Если восстановили учетную запись, то считаем, что заявление и сертификат были 
	// отправлены из другой базы, а поэтому не предлагаем в этой базе.
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	
	УчетнаяЗапись = КонтекстЭДОСервер.УчетнаяЗаписьОрганизации(Организация);
	КонтекстЭДОСервер.УстановитьПризнакПередачиСертификатаВПФР(УчетнаяЗапись.СертификатРуководителя, Истина);
	КонтекстЭДОСервер.УстановитьСостояниеПодключенияКЭДОсПФР(Организация, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПользователейУчетнойЗаписи(НепосредственноОбновить = Ложь)
	
	Если СписокПользователей.Количество() <= 1 ИЛИ НепосредственноОбновить Тогда
		Если Не НепосредственноОбновить Тогда
			Для Каждого Пользователь Из СписокПользователей Цикл
				Пользователь.Пометка = Истина;
			КонецЦикла;
		КонецЕсли;
		
		// Записываем выбранных пользователей в регистр сведений
		ЗаписатьПользователейУчетныхЗаписейДокументооборота(КонтекстЭДОКлиент.НоваяУчетнаяЗапись);
		
		СтруктураДляОповещения = Новый Структура("Организация, УчетнаяЗапись", Организация, КонтекстЭДОКлиент.НоваяУчетнаяЗапись);
		Оповестить("ПривязатьУчетнуюЗаписьКОрганизации", СтруктураДляОповещения);
		
		Если НЕ СтруктураДляОповещения.Свойство("ОповещениеОтработано") ИЛИ СтруктураДляОповещения.ОповещениеОтработано = Ложь Тогда
			КонтекстЭДОКлиент.УстановитьУчетнуюЗаписьОрганизации(Организация, КонтекстЭДОКлиент.НоваяУчетнаяЗапись);
		КонецЕсли;
		ОповеститьОбИзменении(КонтекстЭДОКлиент.НоваяУчетнаяЗапись);
		Если НЕ СтруктураДляОповещения.Свойство("ОповещениеОтработано") ИЛИ СтруктураДляОповещения.ОповещениеОтработано = Ложь Тогда
			Оповестить("ОбновитьУчетнуюЗапись", КонтекстЭДОКлиент.НоваяУчетнаяЗапись);
		КонецЕсли;
		
		Элементы.ОсновнаяПанель.ТекущаяСтраница = Элементы.СтраницаРезультат;
		Элементы.СтраницыРезультата.ТекущаяСтраница = Элементы.СтраницаРезультатУспех;
		
		УправлениеКнопкамиНавигации(ЭтаФорма);
	Иначе 
		Элементы.ОсновнаяПанель.ТекущаяСтраница = Элементы.СтраницаНастройкаПрограммы;
		УправлениеКнопкамиНавигации(ЭтаФорма);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСледующуюСтраницу()
	
	ТекущаяСтраница = Элементы.ОсновнаяПанель.ТекущаяСтраница;
	ИндексТекущейСтраницы = Элементы.ОсновнаяПанель.ПодчиненныеЭлементы.Индекс(ТекущаяСтраница);
	
	Пока Элементы.ОсновнаяПанель.ПодчиненныеЭлементы.Индекс(ТекущаяСтраница) < Элементы.ОсновнаяПанель.ПодчиненныеЭлементы.Количество() - 1 Цикл
		
		Страница = Элементы.ОсновнаяПанель.ПодчиненныеЭлементы.Получить(Элементы.ОсновнаяПанель.ПодчиненныеЭлементы.Индекс(ТекущаяСтраница) + 1);
		
		Если Страница.Видимость Тогда
			Элементы.ОсновнаяПанель.ТекущаяСтраница = Страница;
			Прервать;
		Иначе
			ТекущаяСтраница = Страница;
		КонецЕсли;
		
	КонецЦикла;	
	УправлениеКнопкамиНавигации(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПредыдущуюСтраницу()
	
	ТекущаяСтраница 		= Элементы.ОсновнаяПанель.ТекущаяСтраница;
	ИндексТекущейСтраницы 	= Элементы.ОсновнаяПанель.ПодчиненныеЭлементы.Индекс(ТекущаяСтраница);
	
	Если ИндексТекущейСтраницы > 0 Тогда
		
		Индекс = ИндексТекущейСтраницы;
		Пока Индекс > 0 Цикл
			Индекс = Индекс - 1;
			Страница = Элементы.ОсновнаяПанель.ПодчиненныеЭлементы.Получить(Индекс);
			Если Страница.Видимость Тогда		
				Элементы.ОсновнаяПанель.ТекущаяСтраница = Страница;
				Прервать;
			КонецЕсли;
		КонецЦикла;
										 
	КонецЕсли;
	УправлениеКнопкамиНавигации(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьПользователейУчетныхЗаписейДокументооборота(СсылкаУчетнаяЗапись)
	
	НаборЗаписей = РегистрыСведений.ПользователиУчетныхЗаписейДокументооборота.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.УчетнаяЗапись.Установить(СсылкаУчетнаяЗапись.Ссылка);
	ФлагОтметки = Ложь;
	
	Для Каждого СтрокаСписка Из СписокПользователей Цикл
		Если СтрокаСписка.Пометка Тогда
			НоваяСтрока = НаборЗаписей.Добавить();
			НоваяСтрока.УчетнаяЗапись = СсылкаУчетнаяЗапись.Ссылка;
			НоваяСтрока.Пользователь = СтрокаСписка.Значение;
			ФлагОтметки = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		НаборЗаписей.Записать();
	Исключение
		РегламентированнаяОтчетностьКлиентСервер.СообщитьОбОшибке(ОписаниеОшибки(), Ложь,
			"Не удалось обновить список пользователей по учетной записи налогоплательщика """ + СокрЛП(СсылкаУчетнаяЗапись.Ссылка) + """.");
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти
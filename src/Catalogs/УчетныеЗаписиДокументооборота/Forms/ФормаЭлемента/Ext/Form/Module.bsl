﻿&НаКлиенте
Перем КонтекстЭДО;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтоНовый = Параметры.Ключ.Пустая() И НЕ ЗначениеЗаполнено(Параметры.ЗначениеКопирования);
	ИнициализацияТаблицыНастроекПользователей(ЭтоНовый);
	СписокОрганизаций = СписокОрганизаций();
	
	Если ЭтоНовый Тогда
		
		Объект.ДатаПодключения = ТекущаяДатаСеанса();
		
		ПортPOP3 = 110;
		ПортSMTP = 25;
		
		Если НЕ ЗначениеЗаполнено(Объект.РежимАвтонастройки) Тогда
			РежимАвтонастройки = Перечисления.РежимыАвтонастройкиУчетнойЗаписиНалогоплательщика.Отключена;
			ИспользоватьСервисОнлайнПроверкиОтчетов = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьСтруктуруСсылочныхДанных();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// инициализируем контекст формы - контейнера клиентских методов
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
    ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПустаяСтрока(Объект.Наименование) Тогда
		Объект.Наименование = Объект.АдресЭлектроннойПочты;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбменНапрямуюПриИзменении(Элемент)
	
	ОбновитьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредназначенаДляДокументооборотаСФНСПриИзменении(Элемент)
	
	ОбновитьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатРуководителяПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения(
		"СертификатРуководителяПредставлениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент));

	КриптографияЭДКОКлиент.ВыбратьСертификат(
		Оповещение, Объект.ЭлектроннаяПодписьВМоделиСервиса, Объект.СертификатРуководителя, "My");
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатРуководителяПредставлениеНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элемент = ДополнительныеПараметры.Элемент;
	
	Если Результат.Выполнено Тогда
		Объект.СертификатРуководителя = Результат.ВыбранноеЗначение.Отпечаток;
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			Объект.ЭлектроннаяПодписьВМоделиСервиса, 
			Элементы.СертификатРуководителяПредставление, 
			Объект.СертификатРуководителя, 
			ЭтотОбъект,
			"СертификатРуководителяПредставление");
		
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатРуководителяПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	Объект.СертификатРуководителя = "";
	
	КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
		Объект.ЭлектроннаяПодписьВМоделиСервиса, 
		Элементы.СертификатРуководителяПредставление, 
		Объект.СертификатРуководителя, 
		ЭтотОбъект,
		"СертификатРуководителяПредставление");
		
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатРуководителяПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Объект.СертификатРуководителя) Тогда
		КриптографияЭДКОКлиент.ПоказатьСертификат(
			Новый Структура("ЭлектроннаяПодписьВМоделиСервиса, Отпечаток", 
				Объект.ЭлектроннаяПодписьВМоделиСервиса, Объект.СертификатРуководителя));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатГлавногоБухгалтераПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения(
		"СертификатГлавногоБухгалтераПредставлениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент));

	КриптографияЭДКОКлиент.ВыбратьСертификат(
		Оповещение, Объект.ЭлектроннаяПодписьВМоделиСервиса, Объект.СертификатГлавногоБухгалтера, "My");
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатГлавногоБухгалтераПредставлениеНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элемент = ДополнительныеПараметры.Элемент;
	
	Если Результат.Выполнено Тогда
		Объект.СертификатГлавногоБухгалтера = Результат.ВыбранноеЗначение.Отпечаток;
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			Объект.ЭлектроннаяПодписьВМоделиСервиса, 
			Элементы.СертификатГлавногоБухгалтераПредставление, 
			Объект.СертификатГлавногоБухгалтера, 
			ЭтотОбъект,
			"СертификатГлавногоБухгалтераПредставление");
		
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатГлавногоБухгалтераПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	Объект.СертификатГлавногоБухгалтера = "";
	
	КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
		Объект.ЭлектроннаяПодписьВМоделиСервиса, 
		Элементы.СертификатГлавногоБухгалтераПредставление, 
		Объект.СертификатГлавногоБухгалтера, 
		ЭтотОбъект,
		"СертификатГлавногоБухгалтераПредставление");
		
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатГлавногоБухгалтераПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Объект.СертификатГлавногоБухгалтера) Тогда
		КриптографияЭДКОКлиент.ПоказатьСертификат(
			Новый Структура("ЭлектроннаяПодписьВМоделиСервиса, Отпечаток", 
				Объект.ЭлектроннаяПодписьВМоделиСервиса, Объект.СертификатГлавногоБухгалтера));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатШифрованиеПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения(
		"СертификатШифрованиеПредставлениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент));

	КриптографияЭДКОКлиент.ВыбратьСертификат(
		Оповещение, Объект.ЭлектроннаяПодписьВМоделиСервиса, Объект.СертификатДляШифрования, "My");
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатШифрованиеПредставлениеНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элемент = ДополнительныеПараметры.Элемент;
	
	Если Результат.Выполнено Тогда
		Объект.СертификатДляШифрования = Результат.ВыбранноеЗначение.Отпечаток;
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			Объект.ЭлектроннаяПодписьВМоделиСервиса, 
			Элементы.СертификатШифрованиеПредставление, 
			Объект.СертификатДляШифрования, 
			ЭтотОбъект,
			"СертификатШифрованиеПредставление");
		
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатШифрованиеПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	Объект.СертификатДляШифрования = "";
	
	КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
		Объект.ЭлектроннаяПодписьВМоделиСервиса, 
		Элементы.СертификатШифрованиеПредставление, 
		Объект.СертификатДляШифрования, 
		ЭтотОбъект,
		"СертификатШифрованиеПредставление");
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатШифрованиеПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Объект.СертификатДляШифрования) Тогда
		КриптографияЭДКОКлиент.ПоказатьСертификат(
			Новый Структура("ЭлектроннаяПодписьВМоделиСервиса, Отпечаток", 
				Объект.ЭлектроннаяПодписьВМоделиСервиса, Объект.СертификатДляШифрования));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредназначенаДляДокументооборотаСПФРПриИзменении(Элемент)
	
	ОбновитьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторСпецоператораСвязиПриИзменении(Элемент)
	
	ОбновитьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредназначенаДляДокументооборотаСФСГСПриИзменении(Элемент)
	
	ОбновитьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура СерверДокументооборотаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.СерверДокументооборота)
	И (ПустаяСтрока(Объект.СерверSMTP) ИЛИ ПустаяСтрока(Объект.СерверPOP3)) Тогда
		АдресСервера = ПолучитьДоменноеИмяПоСерверуДокументооборота(Объект.СерверДокументооборота);
		Если НЕ ПустаяСтрока(АдресСервера) Тогда
			Если ПустаяСтрока(Объект.СерверSMTP) Тогда
				Объект.СерверSMTP = АдресСервера;
			КонецЕсли;
			Если ПустаяСтрока(Объект.СерверPOP3) Тогда
				Объект.СерверPOP3 = АдресСервера;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СерверSMTPПриИзменении(Элемент)
	
	Если ПустаяСтрока(Объект.СерверPOP3) Тогда
		Объект.СерверPOP3 = Объект.СерверSMTP;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИмяПользователяSMTPПриИзменении(Элемент)
	
	Если ПустаяСтрока(Объект.ИмяПользователяPOP3) Тогда
		Объект.ИмяПользователяPOP3 = Объект.ИмяПользователяSMTP;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СерверPOP3ПриИзменении(Элемент)
	
	Если ПустаяСтрока(Объект.СерверSMTP) Тогда
		Объект.СерверSMTP = Объект.СерверPOP3;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИмяПользователяPOP3ПриИзменении(Элемент)
	
	Если ПустаяСтрока(Объект.ИмяПользователяSMTP) И Объект.ТребуетсяSMTPАутентификация Тогда
		Объект.ИмяПользователяSMTP = Объект.ИмяПользователяPOP3;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура АдресЭлектроннойПочтыПриИзменении(Элемент)
	
	Если ПустаяСтрока(Объект.Наименование) Тогда
		Объект.Наименование = Объект.АдресЭлектроннойПочты;
	КонецЕсли;
	
	ВхождениеРазделителя = СтрНайти(Объект.АдресЭлектроннойПочты, "@");
	Если ВхождениеРазделителя = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ИмяПользователяИзАдреса = СокрЛП(Лев(Объект.АдресЭлектроннойПочты, ВхождениеРазделителя - 1));
	Если ПустаяСтрока(Объект.СерверPOP3) Тогда
		Объект.ИмяПользователяPOP3 = ИмяПользователяИзАдреса;
	КонецЕсли;
	Если Объект.ТребуетсяSMTPАутентификация И ПустаяСтрока(Объект.СерверSMTP) Тогда
		Объект.ИмяПользователяSMTP = ИмяПользователяИзАдреса;
	КонецЕсли;
	
	АдресСервера = СокрЛП(Сред(Объект.АдресЭлектроннойПочты, ВхождениеРазделителя + 1));
	Если ПустаяСтрока(Объект.СерверSMTP) Тогда
		Объект.СерверSMTP = АдресСервера;
	КонецЕсли;
	Если ПустаяСтрока(Объект.СерверPOP3) Тогда
		Объект.СерверPOP3 = АдресСервера;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторАбонентаПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.ИдентификаторСпецоператора) И СтрДлина(СокрЛП(Объект.ИдентификаторАбонента)) > 3 Тогда
		Объект.ИдентификаторСпецоператора = Лев(СокрЛП(Объект.ИдентификаторАбонента), 3);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПользователейНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗакрытьФорму = Ложь;
	
	ДополнительныеПараметры = Новый Структура("ЗакрытьФорму", ЗакрытьФорму);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОтметитьПользователейЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	СписокПользователей.ПоказатьОтметкуЭлементов(ОписаниеОповещения, "Выберите пользователей");
	
КонецПроцедуры

&НаКлиенте
Процедура ТребуетсяSMTPАутентификацияПриИзменении(Элемент)
	
	УправлениеДоступностьюНастроекSMTP();
	ОписаниеОповещения = Новый ОписаниеОповещения("ТребуетсяSMTPАутентификацияПриИзмененииЗавершение", ЭтотОбъект);
	ТекстВопроса = "Параметры авторизации SMTP-сервера совпадают с параметрами авторизации POP3-сервера?";
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьАвтоматическиСейчас(Команда)
	
	Если ЭтаФорма.Модифицированность Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьАвтоматическиСейчасЗавершение", ЭтотОбъект);
		ТекстВопроса = "В текущей форме были произведены изменения, которые необходимо применить перед настройкой.
			|Применить изменения?";
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		НастроитьАвтоматическиСейчасПослеСохранения();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьРасширенныеНастройки(Команда)
	
	СтруктураПараметров = Новый Структура("СправочникОбъект", Объект);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПоказатьРасширенныеНастройкиЗавершение", ЭтотОбъект);
	ОткрытьФорму(КонтекстЭДО.ПутьКОбъекту + ".Форма.РасширенныеНастройкиУчетнойЗаписи", СтруктураПараметров,,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьПараметрыДоступа(Команда)
	
	Если ПараметрыДоступаВерны() Тогда
		ПоказатьПредупреждение(, "Проверка параметров доступа успешно пройдена.");
	Иначе
		ПоказатьПредупреждение(, "Проверка параметров доступа НЕ пройдена!");
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьСведенияОЛицензии(Команда)
	
	ПараметрыФормы = Новый Структура("Ключ", Объект.Ссылка);
	ОткрытьФорму(КонтекстЭДО.ПутьКОбъекту + ".Форма.ДанныеПоЛицензииНа1СОтчетность", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайлАвтонастройки(Команда)
	КонтекстЭДО.СохранитьФайлАвтонастройки(Объект.Ссылка);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НастроитьАвтоматическиСейчасЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	РезультатЗаписи = Записать();
	Если НЕ РезультатЗаписи Тогда
		ПоказатьПредупреждение(, "Не удалось сохранить информацию об учетной записи!");
		Возврат;
	КонецЕсли;
	НастроитьАвтоматическиСейчасПослеСохранения();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьАвтоматическиСейчасПослеСохранения()
	
	Организация = КонтекстЭДО.ОпределитьОрганизациюПоУчетнойЗаписиКлиент(Объект.Ссылка);
	Если Организация = Неопределено Тогда
		Если Объект.СпецоператорСвязи = СтруктураСсылочныхДанных.Перечисления_СпецоператорыСвязи_Такском Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьАвтоматическиСейчасПослеСохраненияЗавершение", ЭтотОбъект);
			ОткрытьФорму(КонтекстЭДО.ПутьКОбъекту + ".Форма.РОКИПараметрыАвтонастройкиНовойУчетнойЗаписи",,,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Иначе
			ПоказатьПредупреждение(, НСтр("ru = 'Учетная запись не привязана ни к какой организации. Настройка невозможна.'"));
		КонецЕсли;
	Иначе
		ЭтоЮридическоеЛицо = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ЭтоЮрЛицо(Организация);
		
		// Получаем ИНН и КПП
		СтруктураДанныхОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Организация);	
		Если ЭтоЮридическоеЛицо Тогда
			ПараметрыОрганизации = Новый Структура("ИНН, КПП",
			СокрЛП(СтруктураДанныхОрганизации["ИННЮЛ"]),
			СокрЛП(СтруктураДанныхОрганизации["КППЮЛ"]));
		Иначе
			ПараметрыОрганизации = Новый Структура("ИНН, КПП",
			СокрЛП(СтруктураДанныхОрганизации["ИННФЛ"]), "");
		КонецЕсли;
		
		НастроитьАвтоматическиСейчасПослеПолученияПараметровОрганизации(ПараметрыОрганизации);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьАвтоматическиСейчасПослеСохраненияЗавершение(ПараметрыОрганизации, ДополнительныеПараметры) Экспорт
	
	НастроитьАвтоматическиСейчасПослеПолученияПараметровОрганизации(ПараметрыОрганизации);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьАвтоматическиСейчасПослеПолученияПараметровОрганизации(ПараметрыОрганизации)
	
	Если ПараметрыОрганизации = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьАвтоматическиСейчасПослеПолученияПараметровОрганизацииЗавершение", ЭтотОбъект);
	КонтекстЭДО.АвтоматическаяНастройкаУчетнойЗаписи(Объект.Ссылка, ПараметрыОрганизации, ОписаниеОповещения, , Истина, , Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьАвтоматическиСейчасПослеПолученияПараметровОрганизацииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Свойство("РезультатНастройки") Тогда
		РезультатНастройки = Результат.РезультатНастройки;
	ИначеЕсли Результат.Свойство("РезультатПрименения") Тогда
		РезультатНастройки = Результат.РезультатПрименения;
	Иначе
		РезультатНастройки = Неопределено;
	КонецЕсли;
	
	Если РезультатНастройки = Истина Тогда
		Прочитать();
		ОбновитьФорму();
		ПоказатьПредупреждение(, "Автоматическая настройка успешно завершена.");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Получение контекста ЭДО" И КонтекстЭДО <> Неопределено И ТипЗнч(Параметр) = Тип("Структура") Тогда
		Параметр.КонтекстЭДО = КонтекстЭДО;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФорму()
	
	Если КонтекстЭДО = Неопределено Тогда
		ОбновитьФормуПослеОтображенияСертификатов(Неопределено, Неопределено);
	Иначе
		ОбновитьПредставленияСертификатов();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПредставленияСертификатов()
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОбновитьФормуПослеОтображенияСертификатов", 
		ЭтотОбъект);
	
	ПараметрыОтображенияСертификатов = Новый Массив;
	
	ПараметрыОтображенияСертификата = Новый Структура;
	ПараметрыОтображенияСертификата.Вставить("ПолеВвода", 								Элементы.СертификатРуководителяПредставление);
	ПараметрыОтображенияСертификата.Вставить("Сертификат", 								Объект.СертификатРуководителя);
	ПараметрыОтображенияСертификата.Вставить("ИмяРеквизитаПредставлениеСертификата", 	"СертификатРуководителяПредставление");
	
	ПараметрыОтображенияСертификатов.Добавить(ПараметрыОтображенияСертификата);
	
	ПараметрыОтображенияСертификата = Новый Структура;
	ПараметрыОтображенияСертификата.Вставить("ПолеВвода", 								Элементы.СертификатГлавногоБухгалтераПредставление);
	ПараметрыОтображенияСертификата.Вставить("Сертификат", 								Объект.СертификатГлавногоБухгалтера);
	ПараметрыОтображенияСертификата.Вставить("ИмяРеквизитаПредставлениеСертификата", 	"СертификатГлавногоБухгалтераПредставление");
	
	ПараметрыОтображенияСертификатов.Добавить(ПараметрыОтображенияСертификата);
	
	ПараметрыОтображенияСертификата = Новый Структура;
	ПараметрыОтображенияСертификата.Вставить("ПолеВвода", 								Элементы.СертификатШифрованиеПредставление);
	ПараметрыОтображенияСертификата.Вставить("Сертификат", 								Объект.СертификатДляШифрования);
	ПараметрыОтображенияСертификата.Вставить("ИмяРеквизитаПредставлениеСертификата", 	"СертификатШифрованиеПредставление");
	
	ПараметрыОтображенияСертификатов.Добавить(ПараметрыОтображенияСертификата);
		
	КриптографияЭДКОКлиент.ОтобразитьПредставленияСертификатов(
		ПараметрыОтображенияСертификатов, 
		ЭтотОбъект, 
		Объект.ЭлектроннаяПодписьВМоделиСервиса, 
		ОписаниеОповещения);
	
КонецПроцедуры
	
&НаКлиенте
Процедура ОбновитьФормуПослеОтображенияСертификатов(Результат, ВходящийКонтекст) Экспорт
	
	Элементы.ИдентификаторСпецоператора.Доступность = НЕ Объект.ОбменНапрямую;
	
	Если НЕ Объект.ПредназначенаДляДокументооборотаСФНС Тогда
		Если Объект.ПредназначенаДляДокументооборотаСФСГС Тогда
			Объект.ПредназначенаДляДокументооборотаСФСГС = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.ПредназначенаДляДокументооборотаСФСГС Тогда
		Объект.ОбменНапрямую = Ложь;
		Если НЕ Объект.ПредназначенаДляДокументооборотаСФНС Тогда
			Объект.ПредназначенаДляДокументооборотаСФНС = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.ПредназначенаДляДокументооборотаСФНС И Объект.ПредназначенаДляДокументооборотаСПФР Тогда
		Элементы.НалоговыйОрган.Доступность = Истина;
		Элементы.СертификатГлавногоБухгалтераПредставление.Доступность = Истина;
		Элементы.ГруппаИдентификаторы.Доступность = Истина;
		Элементы.ОбменНапрямую.Доступность = Ложь;
		Элементы.ПредназначенаДляДокументооборотаСФСГС.Доступность = Истина;
	ИначеЕсли НЕ Объект.ПредназначенаДляДокументооборотаСФНС И Объект.ПредназначенаДляДокументооборотаСПФР Тогда
		Элементы.НалоговыйОрган.Доступность = Ложь;
		Элементы.СертификатГлавногоБухгалтераПредставление.Доступность = Ложь;
		Элементы.ГруппаИдентификаторы.Доступность = Ложь;
		Элементы.ОбменНапрямую.Доступность = Ложь;
		Элементы.ПредназначенаДляДокументооборотаСФСГС.Доступность = Ложь;
	ИначеЕсли Объект.ПредназначенаДляДокументооборотаСФНС И НЕ Объект.ПредназначенаДляДокументооборотаСПФР Тогда
		Элементы.НалоговыйОрган.Доступность = Истина;
		Элементы.СертификатГлавногоБухгалтераПредставление.Доступность = Истина;
		Элементы.ГруппаИдентификаторы.Доступность = Истина;
		Элементы.ОбменНапрямую.Доступность = Истина;
		Элементы.ПредназначенаДляДокументооборотаСФСГС.Доступность = Истина;
	Иначе
		Элементы.НалоговыйОрган.Доступность = Ложь;
		Элементы.СертификатГлавногоБухгалтераПредставление.Доступность = Ложь;
		Элементы.ГруппаИдентификаторы.Доступность = Ложь;
		Элементы.ОбменНапрямую.Доступность = Истина;
		Элементы.ПредназначенаДляДокументооборотаСФСГС.Доступность = Ложь;
	КонецЕсли;
	
	Если Объект.ПредназначенаДляДокументооборотаСФСГС Тогда
		Элементы.ОбменНапрямую.Доступность = Ложь;
	КонецЕсли;
	Элементы.ГруппаАвтоматическаяНастройка.Доступность = НЕ (Объект.ОбменНапрямую) И СпецоператорСвязиПоддерживаетАвтонастройку(Объект.СпецоператорСвязи);
	
	Если НЕ Элементы.ГруппаАвтоматическаяНастройка.Доступность Тогда
		 РежимАвтонастройки = СтруктураСсылочныхДанных.Перечисления_РежимыАвтонастройкиУчетнойЗаписиНалогоплательщика_Отключена;
	КонецЕсли;
		
	Элементы.СпецоператорСвязи.Доступность = НЕ Объект.ОбменНапрямую;
		
	УправлениеДоступностьюНастроекSMTP();
	УстановитьВидимостьКнопкиЛицензия();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьКнопкиЛицензия()
	
	СпецоператорПоддерживаетВторичныеЗаявления = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ПолучитьПараметрСпецоператора(Объект.СпецоператорСвязи, "ПоддерживаетсяОтправкаВторичногоЗаявления") = "Истина";
	Элементы.ПоказатьСведенияОЛицензии.Видимость = СпецоператорПоддерживаетВторичныеЗаявления;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруСсылочныхДанных()
	
	СтруктураСсылочныхДанных = Новый Структура;
	СтруктураСсылочныхДанных.Вставить("Перечисления_РежимыАвтонастройкиУчетнойЗаписиНалогоплательщика_Отключена", Перечисления.РежимыАвтонастройкиУчетнойЗаписиНалогоплательщика.Отключена);
	СтруктураСсылочныхДанных.Вставить("Перечисления_СпецоператорыСвязи_Прочие", Перечисления.СпецоператорыСвязи.Прочие);
	СтруктураСсылочныхДанных.Вставить("Перечисления_СпецоператорыСвязи_Такском", Перечисления.СпецоператорыСвязи.Такском);
	
КонецПроцедуры

&НаКлиенте
Функция СпецоператорСвязиПоддерживаетАвтонастройку(СпецоператорСвязи)
	
	Если НЕ ЗначениеЗаполнено(СпецоператорСвязи) ИЛИ СпецоператорСвязи = СтруктураСсылочныхДанных.Перечисления_СпецоператорыСвязи_Прочие Тогда
		 Возврат Ложь;
	ИначеЕсли СпецоператорСвязи = СтруктураСсылочныхДанных.Перечисления_СпецоператорыСвязи_Такском Тогда
		Возврат Истина;
	Иначе
		
		СтруктураПараметра = Новый Структура("ОбновленияПризнак");
		Значение = КонтекстЭДО.ПолучитьПараметрСпецоператораКлиент(Спецоператорсвязи,СтруктураПараметра).ОбновленияПризнак;
		Если Значение = Неопределено Тогда
			 Возврат Ложь;
		Иначе
			 Возврат Значение;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДО = Результат.КонтекстЭДО;
	ОбновитьФорму();	
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеДоступностьюНастроекSMTP()
	
	Элементы.ИмяПользователяSMTP.АвтоВыборНезаполненного = Объект.ТребуетсяSMTPАутентификация;
	Элементы.ИмяПользователяSMTP.АвтоОтметкаНезаполненного = Объект.ТребуетсяSMTPАутентификация;
	Элементы.ПарольSMTP.АвтоВыборНезаполненного = Объект.ТребуетсяSMTPАутентификация;
	Элементы.ПарольSMTP.АвтоОтметкаНезаполненного = Объект.ТребуетсяSMTPАутентификация;
	Элементы.ИмяПользователяSMTP.Доступность = Объект.ТребуетсяSMTPАутентификация;
	Элементы.ПарольSMTP.Доступность = Объект.ТребуетсяSMTPАутентификация;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьРасширенныеНастройкиЗавершение(НастройкиОтвета, ДополнительныеПараметры) Экспорт
	
	Если НастройкиОтвета <> Неопределено И ТипЗнч(НастройкиОтвета) = Тип("Структура") Тогда 
		Модифицированность = Истина;
		Для Каждого ЭлементНастройки Из НастройкиОтвета Цикл 
			Объект[ЭлементНастройки.Ключ] = ЭлементНастройки.Значение;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПараметрыДоступаВерны()
	
	ПочтовыйПрофиль = Новый ИнтернетПочтовыйПрофиль;
	ПочтовыйПрофиль.POP3ПередSMTP = Истина;
	
	ПочтовыйПрофиль.АдресСервераSMTP = Объект.СерверSMTP;
	ПочтовыйПрофиль.ПортSMTP = Объект.ПортSMTP;
	Если Объект.ТребуетсяSMTPАутентификация Тогда
		ПочтовыйПрофиль.АутентификацияSMTP = СпособSMTPАутентификации.Login;
		ПочтовыйПрофиль.ПользовательSMTP = Объект.ИмяПользователяSMTP;
		ПочтовыйПрофиль.ПарольSMTP = Объект.ПарольSMTP;
	КонецЕсли;
	
	ПочтовыйПрофиль.АутентификацияPOP3 = СпособPOP3Аутентификации.Обычная;
	ПочтовыйПрофиль.АдресСервераPOP3 = Объект.СерверPOP3;
	ПочтовыйПрофиль.ПортPOP3 = Объект.ПортPOP3;
	ПочтовыйПрофиль.Пользователь = Объект.ИмяПользователяPOP3;
	ПочтовыйПрофиль.Пароль = Объект.ПарольPOP3;
	
	ПочтовыйПрофиль.ВремяОжидания = ?(ЗначениеЗаполнено(Объект.СерверДокументооборота.ДлительностьОжиданияСервера), Объект.СерверДокументооборота.ДлительностьОжиданияСервера, 60);
	
	Почта = Новый ИнтернетПочта;
	Попытка
		Почта.Подключиться(ПочтовыйПрофиль);
		Почта.Отключиться();
	Исключение
		Инф = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Электронный документооборот с КО.Проверка параметров подключения'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(Инф));
			
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'При проверке настроек учетной записи произошли ошибки:
                 |%1'"), КраткоеПредставлениеОшибки(Инф));
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ТребуетсяSMTPАутентификацияПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
	Если Объект.ТребуетсяSMTPАутентификация И НЕ ПустаяСтрока(Объект.ИмяПользователяPOP3) И ПустаяСтрока(Объект.ИмяПользователяSMTP) И ПустаяСтрока(Объект.ПарольSMTP)
		И РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.ИмяПользователяSMTP = Объект.ИмяПользователяPOP3;
		Объект.ПарольSMTP = Объект.ПарольPOP3;
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДоменноеИмяПоСерверуДокументооборота(СерверДокументооборота)
	
	АдресЭлектроннойПочтыСервера = СерверДокументооборота.АдресЭлектроннойПочтыФНС;
	АдресСервера = СокрЛП(Сред(АдресЭлектроннойПочтыСервера, СтрНайти(АдресЭлектроннойПочтыСервера, "@") + 1));
	Если ПустаяСтрока(АдресСервера) Тогда
		АдресЭлектроннойПочтыСервера = СерверДокументооборота.АдресЭлектроннойПочтыПФР;
		АдресСервера = СокрЛП(Сред(АдресЭлектроннойПочтыСервера, СтрНайти(АдресЭлектроннойПочтыСервера, "@") + 1));
	КонецЕсли;
	
	Возврат АдресСервера;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьГиперссылку()
	
	СписокПользователейСтрокой = "";
	Элементы.ГиперссылкаПользователей.Подсказка = "";
	Для Каждого ЭлементСписка Из СписокПользователей Цикл
		Если ЭлементСписка.Пометка Тогда 
			СписокПользователейСтрокой = СписокПользователейСтрокой + ЭлементСписка.Представление + ", ";
		КонецЕсли;
	КонецЦикла;
	Если ЗначениеЗаполнено(СписокПользователейСтрокой) Тогда 
		СписокПользователейСтрокой = Лев(СписокПользователейСтрокой, СтрДлина(СписокПользователейСтрокой)-2);
		Элементы.ГиперссылкаПользователей.ЦветТекста = Новый Цвет(0, 0, 192); // синий
	Иначе 
		СписокПользователейСтрокой = "<не выбраны>";
		Элементы.ГиперссылкаПользователей.ЦветТекста = Новый Цвет(255, 0, 0); // красный
		Элементы.ГиперссылкаПользователей.Подсказка = "Пользователи учетной записи налогоплательщика не установлены";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализацияТаблицыНастроекПользователей(ЭтоНовый = Ложь)
	
	СписокПользователей.Очистить();
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	ВЫБОР
	                      |		КОГДА Настройки.УчетнаяЗапись ЕСТЬ NULL 
	                      |			ТОГДА ЛОЖЬ
	                      |		ИНАЧЕ ИСТИНА
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
	                      |	Пользователи.Наименование");
	Запрос.УстановитьПараметр("УчетнаяЗапись", Объект.Ссылка);
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
	
	Если ЭтоНовый Тогда 
		СтрокаПользователь = СписокПользователей.НайтиПоЗначению(ТекущийПользователь);
		Если СтрокаПользователь <> Неопределено Тогда 
			СтрокаПользователь.Пометка = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьГиперссылку();
	
КонецПроцедуры

&НаСервере
Функция СписокОрганизаций()
	СписокОрганизацийУчетнойЗаписи = "";	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Организации.Наименование КАК НаименованиеОрганизации
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.УчетнаяЗаписьОбмена = &УчетнаяЗаписьОбмена
		|	И Организации.ПометкаУдаления = ЛОЖЬ
		|	И Организации.ВидОбменаСКонтролирующимиОрганами = ЗНАЧЕНИЕ(Перечисление.ВидыОбменаСКонтролирующимиОрганами.ОбменВУниверсальномФормате)";

	Запрос.УстановитьПараметр("УчетнаяЗаписьОбмена", Объект.Ссылка);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СписокОрганизацийУчетнойЗаписи = СписокОрганизацийУчетнойЗаписи + ?(ПустаяСтрока(СписокОрганизацийУчетнойЗаписи),"",", ")+ ВыборкаДетальныеЗаписи.НаименованиеОрганизации;
	КонецЦикла;
	
	Возврат СписокОрганизацийУчетнойЗаписи;
	
КонецФункции

&НаКлиенте
Процедура ОтметитьПользователейЗавершение(Список, ДополнительныеПараметры) Экспорт
	
	ЗакрытьФорму = ДополнительныеПараметры.ЗакрытьФорму;
	
	Если Список = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	СохраненноеЗначение = СписокПользователейСтрокой;
	ЗаполнитьГиперссылку();
	
	Если СохраненноеЗначение = СписокПользователейСтрокой Тогда 
		Возврат;
	КонецЕсли;
	
	ТекущийПользователь = ПользователиКлиент.ТекущийПользователь();
	ТекущийПользовательВСписке = СписокПользователей.НайтиПоЗначению(ТекущийПользователь);
	
	Если ТекущийПользовательВСписке <> Неопределено И НЕ ТекущийПользовательВСписке.Пометка Тогда 
		ТекстВопроса = НСтр("ru = 'Текущий пользователь был удален из списка пользователей учетных записей.
			|Форма учетной записи будет закрыта.
			|
			|Продолжить?'");
		
		ДополнительныеПараметры = Новый Структура("ЗакрытьФорму", ЗакрытьФорму);
		ОписаниеОповещения = Новый ОписаниеОповещения("ГиперссылкаПользователейНажатиеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, "Внимание!");
		
	Иначе
		ЗаписатьПользователейУчетныхЗаписейДокументооборота();
		
		Если ЗакрытьФорму Тогда 
			Закрыть();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПользователейНажатиеЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	ЗакрытьФорму = ДополнительныеПараметры.ЗакрытьФорму;
	
	Если РезультатВыбора = КодВозвратаДиалога.Нет Тогда 
		ИнициализацияТаблицыНастроекПользователей();
		Возврат;
	Иначе
		ЗакрытьФорму = Истина;
	КонецЕсли;
	
	ЗаписатьПользователейУчетныхЗаписейДокументооборота();
	
	Если ЗакрытьФорму Тогда 
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьПользователейУчетныхЗаписейДокументооборота()
	
	НаборЗаписей = РегистрыСведений.ПользователиУчетныхЗаписейДокументооборота.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.УчетнаяЗапись.Установить(Объект.Ссылка);
	
	Для Каждого СтрокаСписка Из СписокПользователей Цикл
		Если СтрокаСписка.Пометка Тогда
			НоваяСтрока = НаборЗаписей.Добавить();
			НоваяСтрока.УчетнаяЗапись = Объект.Ссылка;
			НоваяСтрока.Пользователь = СтрокаСписка.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		НаборЗаписей.Записать();
	Исключение
		РегламентированнаяОтчетностьКлиентСервер.СообщитьОбОшибке(ОписаниеОшибки(), Ложь,
			"Не удалось обновить список пользователей по учетной записи налогоплательщика """ + СокрЛП(Объект.Ссылка) + """.");
	КонецПопытки;
	
	ИнициализацияТаблицыНастроекПользователей();
	ДокументооборотСКОВызовСервера.УстановитьПараметрСеансаТекущиеУчетныеЗаписиНалогоплательщика();
	
КонецПроцедуры

&НаСервере
Функция ИнформацияОЛичныхСертификатах()

	ОбъектУчетнойЗаписи = Объект.Ссылка.ПолучитьОбъект();
	
	СписокСертификатов = Новый СписокЗначений;
	Для Каждого Личный Из ОбъектУчетнойЗаписи.СертификатыЛичные Цикл 		
		
		ДанныеСертификата = Личный.Содержимое.Получить();
		Адрес = ПоместитьВоВременноеХранилище(ДанныеСертификата, УникальныйИдентификатор);		
		СвойстваСертификата = Новый СертификатКриптографии(ДанныеСертификата);
		ОписаниеСертификата = СтрШаблон("%1, %2 - %3, серийный номер: %4, отпечаток: %5, %6", 
			СвойстваСертификата.Субъект.CN,
			СвойстваСертификата.ДатаНачала,
			СвойстваСертификата.ДатаОкончания,
			Личный.СерийныйНомер,
			Личный.Отпечаток,
			Личный.Криптопровайдер);
		СписокСертификатов.Добавить(Адрес + Символы.Таб + Личный.Отпечаток, ОписаниеСертификата);
		
	КонецЦикла;
		
	Возврат СписокСертификатов;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьИнформациюОСертификатах(Команда)
	СписокСертификатов = ИнформацияОЛичныхСертификатах();
	
	ОО = Новый ОписаниеОповещения("ПослеВыбораЭлемента", ЭтотОбъект, Неопределено);
	СписокСертификатов.ПоказатьВыборЭлемента(ОО, "Все личные сертификаты учетной записи");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораЭлемента(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда		
		ЭлементыСтроки = СтрРазделить(ВыбранныйЭлемент.Значение, Символы.Таб);
		ПолучитьФайл(ЭлементыСтроки[0], ЭлементыСтроки[1] + ".cer", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

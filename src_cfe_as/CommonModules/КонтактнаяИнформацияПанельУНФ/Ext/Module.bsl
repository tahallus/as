﻿
&ИзменениеИКонтроль("ПроверитьСоздатьРеквизитыПанели")
Процедура _ПроверитьСоздатьРеквизитыПанели(Форма, ИмяГруппыРазмещения, СписокКонтекстноеМеню)

	Если ОбщегоНазначения.ЭтоМобильныйКлиент()
		И СписокКонтекстноеМеню <> Неопределено
		И НЕ ЕстьКомандаФормы(Форма.Команды, "СписокПоказатьКонтактнуюИнформациюТекущегоОбъекта") Тогда

		СоздатьКонтекстнуюКомандуПросмотраКИ(Форма, СписокКонтекстноеМеню);
	КонецЕсли;

	Если ЕстьРеквизитФормы(Форма.ПолучитьРеквизиты(), "ЕстьТаблицаДанныеПанелиКонтактнойИнформации") Тогда
		Возврат;
	КонецЕсли;

	НужноСоздатьТаблицуФормы = НЕ (ОбщегоНазначения.ЭтоМобильныйКлиент() И СписокКонтекстноеМеню <> Неопределено);

	ДобавляемыеРеквизиты = Новый Массив;

	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ЕстьТаблицаДанныеПанелиКонтактнойИнформации", Новый ОписаниеТипов("Булево")));

	Если НужноСоздатьТаблицуФормы Тогда
		// Создадим таблицу значений
		ИмяТаблицы = "ДанныеПанелиКонтактнойИнформации";
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(ИмяТаблицы, Новый ОписаниеТипов("ТаблицаЗначений")));
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("Отображение", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(150)), ИмяТаблицы));
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ИндексПиктограммы", Новый ОписаниеТипов("Число"), ИмяТаблицы));
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ТипОтображаемыхДанных", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(20)), ИмяТаблицы));
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ВладелецКИ", Новый ОписаниеТипов("СправочникСсылка.Контрагенты, СправочникСсылка.КонтактныеЛица, СправочникСсылка.Лиды,СправочникСсылка.КонтактыЛидов, Строка"), ИмяТаблицы));
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("Родитель", Новый ОписаниеТипов("СправочникСсылка.Контрагенты, СправочникСсылка.КонтактныеЛица, СправочникСсылка.Лиды,СправочникСсылка.КонтактыЛидов"), ИмяТаблицы));
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ПредставлениеКИ", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(500)), ИмяТаблицы));
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ТипКИ", Новый ОписаниеТипов("ПеречислениеСсылка.ТипыКонтактнойИнформации"), ИмяТаблицы));
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("СписокПодразделенийГоловногоКонтрагента", Новый ОписаниеТипов("СписокЗначений"), ИмяТаблицы));
	КонецЕсли;

	Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);

	Если НужноСоздатьТаблицуФормы Тогда

		// Создадим элементы
		ТаблицаФормы = Форма.Элементы.Добавить(ИмяТаблицы, Тип("ТаблицаФормы"), Форма.Элементы[ИмяГруппыРазмещения]);
		ТаблицаФормы.ПутьКДанным = ИмяТаблицы;
		ТаблицаФормы.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
		ТаблицаФормы.ИзменятьСоставСтрок = Ложь;
		ТаблицаФормы.ИзменятьПорядокСтрок = Ложь;
		ТаблицаФормы.РежимВыделенияСтроки = РежимВыделенияСтрокиТаблицы.Строка;
		ТаблицаФормы.Шапка = Ложь;
		ТаблицаФормы.АвтоВводНовойСтроки = Ложь;
		ТаблицаФормы.РазрешитьНачалоПеретаскивания = Ложь;
		ТаблицаФормы.РазрешитьПеретаскивание = Ложь;
		ТаблицаФормы.ГоризонтальнаяПолосаПрокрутки = ИспользованиеПолосыПрокрутки.НеИспользовать;
		ТаблицаФормы.ВертикальнаяПолосаПрокрутки = ИспользованиеПолосыПрокрутки.НеИспользовать;
		ТаблицаФормы.ГоризонтальныеЛинии = Ложь;
		ТаблицаФормы.ВертикальныеЛинии = Ложь;
		ТаблицаФормы.ЦветРамки = ЦветаСтиля.ЦветФонаФормы;
		#Удаление
		ТаблицаФормы.Высота = 10;
		#КонецУдаления
		#Вставка
		ТаблицаФормы.Высота = 0;
		#КонецВставки
		ТаблицаФормы.РастягиватьПоГоризонтали = Ложь;
		Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
			ТаблицаФормы.ИспользованиеТекущейСтроки = ИспользованиеТекущейСтрокиТаблицы.ОтображениеВыделения;
		КонецЕсли;
		ТаблицаФормы.УстановитьДействие("Выбор",				"Подключаемый_ДанныеПанелиКонтактнойИнформацииВыбор");
		ТаблицаФормы.УстановитьДействие("ПриАктивизацииСтроки",	"Подключаемый_ДанныеПанелиКонтактнойИнформацииПриАктивизацииСтроки");

		Отображение = Форма.Элементы.Добавить(ИмяТаблицы + "Отображение", Тип("ПолеФормы"), ТаблицаФормы);
		Отображение.ПутьКДанным = ИмяТаблицы + ".Отображение";
		Отображение.Вид = ВидПоляФормы.ПолеНадписи;
		Отображение.РежимРедактирования = РежимРедактированияКолонки.Вход;
		Отображение.АвтоВысотаЯчейки = Истина;
		Отображение.Ширина = 23;

		Пиктограмма = Форма.Элементы.Добавить(ИмяТаблицы + "Пиктограмма", Тип("ПолеФормы"), ТаблицаФормы);
		Пиктограмма.ПутьКДанным = ИмяТаблицы + ".ИндексПиктограммы";
		Пиктограмма.Вид = ВидПоляФормы.ПолеКартинки;
		Пиктограмма.КартинкаЗначений = БиблиотекаКартинок.ВидыКонтактнойИнформации;
		Пиктограмма.АвтоВысотаЯчейки = Истина;
		Пиктограмма.ГиперссылкаЯчейки = Истина;
		Пиктограмма.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.БезРамки, -1);
		Пиктограмма.Ширина = 1;
		Пиктограмма.РастягиватьПоГоризонтали = Ложь;
		Пиктограмма.РастягиватьПоВертикали = Ложь;

		КартинкаГоловного = Форма.Элементы.Добавить(ИмяТаблицы + "КартинкаГоловного", Тип("ПолеФормы"), ТаблицаФормы);
		КартинкаГоловного.ПутьКДанным = ИмяТаблицы + ".ИндексПиктограммы";
		КартинкаГоловного.Вид = ВидПоляФормы.ПолеКартинки;
		КартинкаГоловного.КартинкаЗначений = БиблиотекаКартинок.ИерархияГоловнойСписок;
		КартинкаГоловного.АвтоВысотаЯчейки = Истина;
		КартинкаГоловного.ГиперссылкаЯчейки = Истина;
		КартинкаГоловного.Ширина = 1;
		КартинкаГоловного.РастягиватьПоГоризонтали = Ложь;
		КартинкаГоловного.РастягиватьПоВертикали = Ложь;

		ДобавитьКомандуКонтекстногоМеню(
		Форма,
		"КонтекстноеМенюПанелиКартаЯндекс",
		НСтр("ru = 'Адрес на Яндекс.Картах'"),
		НСтр("ru = 'Показывает адрес на картах Яндекс.Карты'"),
		ТаблицаФормы.КонтекстноеМеню,
		БиблиотекаКартинок.ЯндексКарты
		);

		ДобавитьКомандуКонтекстногоМеню(
		Форма,
		"КонтекстноеМенюПанелиКартаGoogle",
		НСтр("ru = 'Адрес на Google Maps'"),
		НСтр("ru = 'Показывает адрес на карте Google Maps'"),
		ТаблицаФормы.КонтекстноеМеню,
		БиблиотекаКартинок.GoogleMaps
		);

		Форма.ЕстьТаблицаДанныеПанелиКонтактнойИнформации = Истина;

	КонецЕсли;

КонецПроцедуры

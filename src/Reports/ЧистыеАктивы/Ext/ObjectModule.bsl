﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Задать настройки формы отчета.
//
// Параметры:
//  Форма		 - ФормаКлиентскогоПриложения	 - Форма отчета
//  КлючВарианта - Строка						 - Ключ загружаемого варианта
//  Настройки	 - Структура					 - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт

	Настройки.РазрешеноИзменятьВарианты = Ложь;
	Настройки.РазрешеноИзменятьСтруктуру = Ложь;
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПриЗагрузкеВариантаНаСервере = Истина;
	Настройки.События.ПриЗагрузкеПользовательскихНастроекНаСервере = Истина;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

// Процедура - Обработчик заполнения настроек отчета и варианта
//
// Параметры:
//  НастройкиОтчета		 - Структура - Настройки отчета, подробнее см. процедуру ОтчетыУНФ.ИнициализироватьНастройкиОтчета 
//  НастройкиВариантов	 - Структура - Настройки варианта отчета, подробнее см. процедуру ОтчетыУНФ.ИнициализироватьНастройкиВарианта
//
Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиВариантов["ЧистыеАктивы"].Теги = НСтр("ru = 'Главное'");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	ОтчетыУНФ.ФормаОтчетаПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

// Обработчик события ПриЗагрузкеВариантаНаСервере
//
// Параметры:
//  Форма			 - ФормаКлиентскогоПриложения	 - Форма отчета
//  НовыеНастройкиКД - НастройкиКомпоновкиДанных	 - Загружаемые настройки КД
//
Процедура ПриЗагрузкеВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	
	ОтчетыУНФ.ПреобразоватьСтарыеНастройки(Форма, НовыеНастройкиКД);	
	ОтчетыУНФ.ОбновитьВидимостьОтбораОрганизация(Форма.Отчет.КомпоновщикНастроек);	
	ОтчетыУНФ.ФормаОтчетаПриЗагрузкеВариантаНаСервере(Форма, НовыеНастройкиКД);
	
КонецПроцедуры

// Обработчик события ПриЗагрузкеПользовательскихНастроекНаСервере
//
// Параметры:
//  Форма							 - ФормаКлиентскогоПриложения				 - Форма отчета
//  НовыеПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных - Загружаемые пользовательские настройки КД
//
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Форма, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ОтчетыУНФ.ПеренестиПараметрыЗаголовкаВНастройки(КомпоновщикНастроек.Настройки, НовыеПользовательскиеНастройкиКД);	
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОтчетыУНФ.ОбъединитьСПользовательскимиНастройками(КомпоновщикНастроек);
	
	НастройкиОтчета = КомпоновщикНастроек.Настройки;
	
	ПараметрыОтчета = ОтчетыУНФ.ПараметрыФормированияОтчета(НастройкиОтчета);
	УправлениеНебольшойФирмойОтчеты.ВывестиЗаголовокОтчета(ПараметрыОтчета, ДокументРезультат);
	
	ОтчетыУНФ.СтандартизироватьСхему(СхемаКомпоновкиДанных);
	
	УправлениеНебольшойФирмойОтчеты.УстановитьМакетОформленияОтчета(НастройкиОтчета);
	ДополнительныеСвойства = КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
	
	ПараметрыФормирования = Новый Структура;
	ПараметрыФормирования.Вставить("ЭтоОтчетУНФ", Ложь);
	ПараметрыФормирования.Вставить("Сравнивать", Ложь);
	ПараметрыФормирования.Вставить("ПоказыватьАбсолютноеИзменение", Ложь);
	ПараметрыФормирования.Вставить("ПоказыватьОтносительноеИзменение", Ложь);
	ПараметрыФормирования.Вставить("ПоляРесурсов", Новый Массив);
	ПараметрыФормирования.Вставить("ПоляСравнения", Новый Массив);
	ПараметрВывода = НастройкиОтчета.ПараметрыВывода.Элементы.Найти("ГоризонтальноеРасположениеОбщихИтогов");
	Если ПараметрВывода.Использование И (ПараметрВывода.Значение = РасположениеИтоговКомпоновкиДанных.Начало 
		ИЛИ ПараметрВывода.Значение = РасположениеИтоговКомпоновкиДанных.Нет) Тогда
		ПараметрыФормирования.Вставить("ОбщиеИтогиПоГоризонтали", Ложь);
	Иначе
		ПараметрыФормирования.Вставить("ОбщиеИтогиПоГоризонтали", Истина);
	КонецЕсли;
	ПараметрыФормирования.Вставить("Период", ОтчетыУНФ.ПериодИзПараметровОтчета(НастройкиОтчета.ПараметрыДанных.Элементы));
	
	Периодичность = ОтчетыУНФ.ЗначениеПараметраДанных(НастройкиОтчета, "Периодичность", Неопределено, Истина);
	Если ЗначениеЗаполнено(Периодичность) Тогда
		ПараметрыФормирования.Вставить("Сравнение", Периодичность);
	КонецЕсли;                                      
	ОтчетыУНФ.ОбновитьПоляСравнения(СхемаКомпоновкиДанных, НастройкиОтчета, ПараметрыФормирования);
	
	ВнешниеНаборыДанных = Новый Структура;
	Если НЕ СхемаКомпоновкиДанных.НаборыДанных.Найти("ТаблицаПериодов")=Неопределено Тогда
		ПериодОтчета = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("СтПериод");
		ТаблицаДанных = Новый ТаблицаЗначений;
		ТаблицаДанных.Колонки.Добавить("ДатаПериода",Новый ОписаниеТипов("Дата",Новый КвалификаторыДаты(ЧастиДаты.Дата)));
		КонецПериода = ?(ЗначениеЗаполнено(ПериодОтчета.Значение.ДатаОкончания),КонецДня(ПериодОтчета.Значение.ДатаОкончания), КонецДня(ТекущаяДатаСеанса()));
		НачалоПериода = НачалоДня(ПериодОтчета.Значение.ДатаНачала);
		Если НЕ ЗначениеЗаполнено(НачалоПериода) Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
			               |	Управленческий.Период КАК Период
			               |ИЗ
			               |	РегистрБухгалтерии.Управленческий КАК Управленческий
			               |
			               |УПОРЯДОЧИТЬ ПО
			               |	Период";
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				НачалоПериода = НачалоДня(Выборка.Период);
			Иначе
				НачалоПериода = НачалоДня(ДобавитьМесяц(ТекущаяДатаСеанса(), -12));
			КонецЕсли; 
		КонецЕсли; 
		ПолеСхемы = СхемаКомпоновкиДанных.НаборыДанных[0].Поля.Найти("ДинамическийПериод");
		Если НЕ ЗначениеЗаполнено(ПараметрыФормирования.Сравнение) Тогда
			ТаблицаДанных.Добавить().ДатаПериода = КонецПериода;
			Если ПолеСхемы <> Неопределено Тогда
				ПолеСхемы.Заголовок = НСтр("ru = 'Баланс'");
				ПараметрОформленияФормат = ПолеСхемы.Оформление.Элементы.Найти("Формат");
				ПараметрОформленияФормат.Значение = "ДЛФ=D";
				ПараметрОформленияФормат.Использование = Истина;
			КонецЕсли; 
		Иначе
			Позиция = НачалоПериода;
			Пока Позиция < КонецПериода Цикл
				Позиция = СледующаяПозиция(Позиция, ПараметрыФормирования.Сравнение);
				ТаблицаДанных.Добавить().ДатаПериода = Позиция;
			КонецЦикла;
			Если ПолеСхемы <> Неопределено Тогда
				СтрокаДлительностьПериода = ОбщегоНазначения.ИмяЗначенияПеречисления(ПараметрыФормирования.Сравнение);
				ПолеСхемы.Заголовок = СтрокаДлительностьПериода;
				ПараметрОформленияФормат = ПолеСхемы.Оформление.Элементы.Найти("Формат");
				ПараметрОформленияФормат.Значение = УправлениеНебольшойФирмойОтчеты.ФорматнаяСтрокаДинамическогоПериода(ПараметрыФормирования.Сравнение);
				ПараметрОформленияФормат.Использование = Истина;
				Если ПараметрыФормирования.Сравнение <> Перечисления.Периодичность.Месяц Тогда
					ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.Получить(0).Запрос;
					ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "НАЧАЛОПЕРИОДА(&ДатаПериода, МЕСЯЦ)", СтрШаблон("НАЧАЛОПЕРИОДА(&ДатаПериода, %1)", ВРЕГ(СтрокаДлительностьПериода)));
					СхемаКомпоновкиДанных.НаборыДанных.Получить(0).Запрос = ТекстЗапроса;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли; 
		ВнешниеНаборыДанных.Вставить("ТаблицаПериодов", ТаблицаДанных);
	КонецЕсли;
	
	ОтчетыУНФ.ДобавитьСимволВалютыКЗаголовкамПолей(СхемаКомпоновкиДанных, "СуммаОстаток");
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	// Создадим и инициализируем процессор компоновки
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);

	// Создадим и инициализируем процессор вывода результата
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);

	// Обозначим начало вывода
	ПроцессорВывода.НачатьВывод();
	ТаблицаЗафиксирована = Ложь;

	ДокументРезультат.ФиксацияСверху = 0;
	
	// Основной цикл вывода отчета
	ПараметрыФормирования.Вставить("НомераУдаляемыхКолонок", Новый Массив);
	ПараметрыФормирования.Вставить("ПорядокРесурсов", Новый Массив);
	ПараметрыФормирования.Вставить("ПерваяКолонкаВГруппе", Истина);
	ПараметрыФормирования.Вставить("ПорядокРесурсовЗаполнен", Ложь);
	ПараметрыФормирования.Вставить("ВысотаШапки", 0);
	ПараметрыФормирования.Вставить("ЕстьЗаголовок", Ложь);
	СтекВысот = Новый Массив;
	Пока Истина Цикл
		// Получим следующий элемент результата компоновки
		ЭлементРезультата = ПроцессорКомпоновки.Следующий();

		Если ЭлементРезультата = Неопределено Тогда
			// Следующий элемент не получен - заканчиваем цикл вывода
			Прервать;
		Иначе
			// Зафиксируем шапку
			Если  Не ТаблицаЗафиксирована 
				  И ЭлементРезультата.ЗначенияПараметров.Количество() > 0 
				  И ТипЗнч(КомпоновщикНастроек.Настройки.Структура[0]) <> Тип("ДиаграммаКомпоновкиДанных") Тогда

				ТаблицаЗафиксирована = Истина;
				ДокументРезультат.ФиксацияСверху = ДокументРезультат.ВысотаТаблицы;
				Индекс = СтекВысот.Количество() - 1;
				ПредыдущаяВысота = ДокументРезультат.ВысотаТаблицы;
				Пока Индекс >= 0 И ПредыдущаяВысота = ДокументРезультат.ВысотаТаблицы Цикл
					ПредыдущаяВысота = СтекВысот[Индекс];
					Индекс = Индекс - 1;
				КонецЦикла;
				Если ДокументРезультат.ВысотаТаблицы <> ПредыдущаяВысота Тогда
					ПараметрыФормирования.Вставить("ВысотаШапки", ДокументРезультат.ВысотаТаблицы - ПредыдущаяВысота);
					ПараметрыФормирования.Вставить("ЕстьЗаголовок", ПредыдущаяВысота > 0);
				КонецЕсли;

			КонецЕсли;
			
			Если ДокументРезультат.ФиксацияСверху = 0 Тогда
				СтекВысот.Добавить(ДокументРезультат.ВысотаТаблицы);
			КонецЕсли;
			
			// Элемент получен - выведем его при помощи процессора вывода
			ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
			
			Если ПараметрыФормирования.ПоляСравнения.Количество() > 0 Тогда
				ОтчетыУНФ.ВывестиЭлементРезультатаСравнения(ЭлементРезультата, ДанныеРасшифровки, ДокументРезультат, ПараметрыФормирования); 
			КонецЕсли; 
			
		КонецЕсли;
	КонецЦикла;

	ПроцессорВывода.ЗакончитьВывод();
	
	Если ДокументРезультат.ФиксацияСверху > 10 Тогда
		// При отображении фильтров и параметров заголовок может быть очень большой,
		// требуется ограничить максимальную высоту фиксирования 
		ДокументРезультат.ФиксацияСверху = 0;
	ИначеЕсли ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		// Для мобильного клиента фиксация не позволяет корректно работать с табличным документом 
		ДокументРезультат.ФиксацияСлева = 0;
		ДокументРезультат.ФиксацияСверху = 0;
	ИначеЕсли (ДополнительныеСвойства.Свойство("ФиксироватьКолонки") И ДополнительныеСвойства.ФиксироватьКолонки) Тогда
		ДокументРезультат.ФиксацияСлева = ОтчетыУНФ.СтрокФиксироватьСлева(КомпоновщикНастроек);
	КонецЕсли;
	
	ОтчетыУНФ.ВыполнитьОперацииПослеФормирования(ДокументРезультат, ПараметрыФормирования, ДанныеРасшифровки);
	
КонецПроцедуры

Функция СледующаяПозиция(Позиция, Периодичность)
	
	Если Периодичность = Перечисления.Периодичность.День Тогда
		Возврат ?(Позиция = КонецДня(Позиция), КонецДня(Позиция + 24 * 3600), КонецДня(Позиция));
	ИначеЕсли Периодичность = Перечисления.Периодичность.Неделя Тогда
		Возврат ?(Позиция = КонецНедели(Позиция), КонецНедели(Позиция + 7 * 24 * 3600), КонецНедели(Позиция));
	ИначеЕсли Периодичность = Перечисления.Периодичность.Декада Тогда
		Возврат ?(Позиция = КонецДня(Позиция), КонецДня(Позиция + 10 * 24 * 3600), КонецДня(Позиция));
	ИначеЕсли Периодичность = Перечисления.Периодичность.Месяц Тогда
		Возврат ?(Позиция = КонецМесяца(Позиция), КонецМесяца(ДобавитьМесяц(Позиция, 1)), КонецМесяца(Позиция));
	ИначеЕсли Периодичность = Перечисления.Периодичность.Квартал Тогда
		Возврат ?(Позиция = КонецКвартала(Позиция), КонецКвартала(ДобавитьМесяц(Позиция, 3)), КонецКвартала(Позиция));
	ИначеЕсли Периодичность = Перечисления.Периодичность.Полугодие Тогда
		Возврат ?(Позиция = КонецМесяца(Позиция), КонецМесяца(ДобавитьМесяц(Позиция, 6)), КонецМесяца(Позиция));
	ИначеЕсли Периодичность = Перечисления.Периодичность.Год Тогда
		Возврат ?(Позиция = КонецГода(Позиция), КонецГода(ДобавитьМесяц(Позиция, 12)), КонецГода(Позиция));
	КонецЕсли; 
	
КонецФункции
 
#КонецОбласти

#Область Инициализация

ЭтоОтчетУНФ = Истина;

#КонецОбласти 

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
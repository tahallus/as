﻿&НаСервере
Функция ПолучитьСписокЗаказовВРасшифровкеПлатежа(Источник) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПоступлениеВКассуРасшифровкаПлатежа.Заказ
		|ИЗ
		|	Документ.ПоступлениеВКассу.РасшифровкаПлатежа КАК ПоступлениеВКассуРасшифровкаПлатежа
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(ПоступлениеВКассуРасшифровкаПлатежа.Заказ) = ТИП(Документ.ЗаказПокупателя)
		|	И ПоступлениеВКассуРасшифровкаПлатежа.Заказ <> ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)
		|	И ПоступлениеВКассуРасшифровкаПлатежа.Ссылка = &Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПоступлениеНаСчетРасшифровкаПлатежа.Заказ
		|ИЗ
		|	Документ.ПоступлениеНаСчет.РасшифровкаПлатежа КАК ПоступлениеНаСчетРасшифровкаПлатежа
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(ПоступлениеНаСчетРасшифровкаПлатежа.Заказ) = ТИП(Документ.ЗаказПокупателя)
		|	И ПоступлениеНаСчетРасшифровкаПлатежа.Заказ <> ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)
		|	И ПоступлениеНаСчетРасшифровкаПлатежа.Ссылка = &Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ОперацияПоПлатежнымКартамРасшифровкаПлатежа.Заказ
		|ИЗ
		|	Документ.ОперацияПоПлатежнымКартам.РасшифровкаПлатежа КАК ОперацияПоПлатежнымКартамРасшифровкаПлатежа
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(ОперацияПоПлатежнымКартамРасшифровкаПлатежа.Заказ) = ТИП(Документ.ЗаказПокупателя)
		|	И ОперацияПоПлатежнымКартамРасшифровкаПлатежа.Заказ <> ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)
		|	И ОперацияПоПлатежнымКартамРасшифровкаПлатежа.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Источник.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Заказ");
	
КонецФункции

&НаСервере
Функция СравнитьМассивыБезУчетаПорядкаЭлементов(Массив1, Массив2) Экспорт
	
	Если (НЕ ЗначениеЗаполнено(Массив1) И ЗначениеЗаполнено(Массив2))
	ИЛИ (НЕ ЗначениеЗаполнено(Массив2) И ЗначениеЗаполнено(Массив1)) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// обходим элементы первого массива и ищем их во втором
	Для Каждого Эл Из Массив1 Цикл
		Если Массив2.Найти(Эл) = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	// обходим элементы второго массива и ищем их в первом
	Для Каждого Эл Из Массив2 Цикл
		Если Массив1.Найти(Эл) = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ЭтоДокументОплатыОбъект(Источник) Экспорт
	
	Возврат (ТипЗнч(Источник) = Тип("ДокументОбъект.ПоступлениеВКассу")
		ИЛИ ТипЗнч(Источник) = Тип("ДокументОбъект.ПоступлениеНаСчет")
		ИЛИ ТипЗнч(Источник) = Тип("ДокументОбъект.ОперацияПоПлатежнымКартам")
	);
	
КонецФункции

&НаСервере
Функция ПолучитьПустуюТаблицуДвижений(ИмяРегистра, ДокументСсылка) Экспорт
	
	ПустаяТаблицаДвижений = Новый ТаблицаЗначений;
	
	Для Каждого Реквизит Из Метаданные.РегистрыНакопления[ИмяРегистра].Реквизиты Цикл
		ПустаяТаблицаДвижений.Колонки.Добавить(Реквизит.Имя, Реквизит.Тип);
	КонецЦикла;
	
	Для Каждого Измерение Из Метаданные.РегистрыНакопления[ИмяРегистра].Измерения Цикл
		ПустаяТаблицаДвижений.Колонки.Добавить(Измерение.Имя, Измерение.Тип);
	КонецЦикла;
	
	Для Каждого Ресурс Из Метаданные.РегистрыНакопления[ИмяРегистра].Ресурсы Цикл
		ПустаяТаблицаДвижений.Колонки.Добавить(Ресурс.Имя, Ресурс.Тип);
	КонецЦикла;
	
	Если Метаданные.РегистрыНакопления[ИмяРегистра].ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки Тогда
		ВидДвижения = Метаданные.РегистрыНакопления[ИмяРегистра].СтандартныеРеквизиты.ВидДвижения;
		ПустаяТаблицаДвижений.Колонки.Добавить(ВидДвижения.Имя, ВидДвижения.Тип);
	КонецЕсли;
	
	Период = Метаданные.РегистрыНакопления[ИмяРегистра].СтандартныеРеквизиты.Период;
	ПустаяТаблицаДвижений.Колонки.Добавить(Период.Имя, Период.Тип);
	
	НомерСтроки = Метаданные.РегистрыНакопления[ИмяРегистра].СтандартныеРеквизиты.НомерСтроки;
	ПустаяТаблицаДвижений.Колонки.Добавить(НомерСтроки.Имя, НомерСтроки.Тип);
	
	// Для получения реквизитов шапки будем хранить в таблице ссылку на документ движения.
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(ТипЗнч(ДокументСсылка));
	ПустаяТаблицаДвижений.Колонки.Добавить("СсылкаНаДокумент", Новый ОписаниеТипов(МассивТипов));
	
	Возврат ПустаяТаблицаДвижений;
	
КонецФункции

&НаСервере
Функция УчестьОплатуДругимиДокументами(МассивРезультатов, НомерЗапросаДанныеОплаты, ВыборкаПоРеквизитамШапки = Неопределено) Экспорт
	
	// Учтём оплату другими документами
	ОплаченоВалДок = 0;
	ВыборкаОплата = МассивРезультатов[НомерЗапросаДанныеОплаты].Выбрать();
	Пока ВыборкаОплата.Следующий() Цикл
		ОплаченоВалДок = ОплаченоВалДок + ВыборкаОплата.ОплаченоВалДок;
	КонецЦикла;
	
	Если ВыборкаПоРеквизитамШапки <> Неопределено
		И ВыборкаПоРеквизитамШапки.ВалютаДокумента <> ВыборкаПоРеквизитамШапки.ВалютаДенежныхСредств
		И ВыборкаПоРеквизитамШапки.КурсСчета <> 0
		И ВыборкаПоРеквизитамШапки.КратностьДокумента <> 0 Тогда
		
		ОплаченоВалДок = ОплаченоВалДок * ВыборкаПоРеквизитамШапки.КурсДокумента * ВыборкаПоРеквизитамШапки.КратностьСчета
			/ 
		(ВыборкаПоРеквизитамШапки.КурсСчета * ВыборкаПоРеквизитамШапки.КратностьДокумента);
		
	КонецЕсли;
	
	ТаблицаДанных = МассивРезультатов[0].Выгрузить();
	
	Если ЗначениеЗаполнено(ОплаченоВалДок) Тогда
	
		// Уменьшим сумму платежа на уже оплаченную по документу сумму.
		// Требуется распределение, т.к. в документе может быть номенклатура с разными ставками НДС!
		МассивСтрокДляУдаления = Новый Массив;
		Для Каждого СтрокаТаблицы Из ТаблицаДанных Цикл
			
			ВВалютеРасчетов = СтрокаТаблицы.ВалютаДенежныхСредств = СтрокаТаблицы.Договор.ВалютаРасчетов;
			ИсходнаяСумма = ?(ВВалютеРасчетов, СтрокаТаблицы.СуммаПлатежа, СтрокаТаблицы.СуммаРасчетов);
			
			Если НЕ ЗначениеЗаполнено(ИсходнаяСумма) Тогда
				МассивСтрокДляУдаления.Добавить(СтрокаТаблицы);
			ИначеЕсли ИсходнаяСумма <= ОплаченоВалДок Тогда
				ОплаченоВалДок = ОплаченоВалДок - ИсходнаяСумма;
				МассивСтрокДляУдаления.Добавить(СтрокаТаблицы);
			Иначе
				СуммаПлатежаНач = ИсходнаяСумма;
				Если ВВалютеРасчетов Тогда
					СтрокаТаблицы.СуммаПлатежа = СтрокаТаблицы.СуммаПлатежа - ОплаченоВалДок;
				Иначе
					СтрокаТаблицы.СуммаРасчетов = СтрокаТаблицы.СуммаРасчетов - ОплаченоВалДок;
				КонецЕсли;
				
				Если СтрокаТаблицы.ВалютаДенежныхСредств = СтрокаТаблицы.Договор.ВалютаРасчетов Тогда
					СтрокаТаблицы.СуммаРасчетов = СтрокаТаблицы.СуммаПлатежа;
				Иначе
					СтрокаТаблицы.СуммаПлатежа = СтрокаТаблицы.СуммаРасчетов * СтрокаТаблицы.СуммаПлатежа / СуммаПлатежаНач;
				КонецЕсли;
				
				СтрокаТаблицы.СуммаНДС = СтрокаТаблицы.СуммаПлатежа * (1 - 1 / ((?(ЗначениеЗаполнено(СтрокаТаблицы.СтавкаНДС), СтрокаТаблицы.СтавкаНДС.Ставка, 0) + 100) / 100));
				
				ОплаченоВалДок = 0;
			КонецЕсли;
			
		КонецЦикла;
		
		СчСтрок = МассивСтрокДляУдаления.Количество() - 1;
		Пока СчСтрок >= 0 Цикл
			СтрокаТаблицы = ТаблицаДанных[СчСтрок];
			
			ТаблицаДанных.Удалить(СтрокаТаблицы);
			
			СчСтрок = СчСтрок - 1;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ТаблицаДанных;
	
КонецФункции

#Область РаботаСУникальнымИдентификаторомПлатежа

// Возвращает уникальный идентификатор платежа с префиксом типа объекта
//
&НаСервере
Функция ПолучитьУникальныйИдентификаторПлатежа(Объект) Экспорт
	
	Префикс = ПолучитьПрефиксДляУИП(Объект.Ссылка);
	Дата = Формат(Объект.Дата, "ДФ=yyMM");
	Номер = СтрЗаменить(Объект.Номер, "-", "");
	Код = Строка(Префикс) + Строка(Дата) + Строка(Номер);
	УИП = ПолучитьУникальныйИдентификаторПлатежаСКонтрольнымРазрядом(Код);
	
	Возврат УИП;
	
КонецФункции

// Возвращает префикс типа объекта для формирования уникального идентификатора платежа
//
&НаСервере
Функция ПолучитьПрефиксДляУИП(Ссылка)

	Соответствие = Новый Соответствие();
	Соответствие.Вставить("РасходнаяНакладная",		"РНА");
	Соответствие.Вставить("АктВыполненныхРабот",	"АВР");
	Соответствие.Вставить("ЗаказПокупателя",		"ЗКП");
	Соответствие.Вставить("СчетНаОплату",			"СНО");
	Соответствие.Вставить("ПриемИПередачаВРемонт",	"ППР");
	
	Возврат Соответствие[Ссылка.Метаданные().Имя];
	
КонецФункции

// Возвращает сгенерированный уникальный идентификатор платежа по коду объекта
//
&НаСервере
Функция ПолучитьУникальныйИдентификаторПлатежаСКонтрольнымРазрядом(Код,Сдвиг = Неопределено)
	
	Если Сдвиг = Неопределено Тогда
		Сдвиг = 0;
	КонецЕсли;
	
	СтруктураСоответствий = Новый Структура("А ,Б ,В ,Г ,Д ,Е ,Ж ,З ,И ,К ,Л ,М ,Н ,О ,П ,Р ,С ,Т ,У ,Ф ,Х ,Ц ,Ч ,Ш ,Щ ,Э ,Ю ,Я ,Ъ ,Ы ,Ь,
											|A ,B ,C ,D ,E ,F ,G ,H ,I ,J ,K ,L ,M ,N ,O ,P ,Q ,R ,S ,T ,U ,V ,W ,X ,Y ,Z",
											 1 ,2 ,3 ,4 ,5 ,6 ,7 ,8 ,9 ,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,33,36,42,
											 1 ,3 ,17,29,6 ,30,31,13,32,33,10,34,12,35,14,16,36,37,38,18,39,40,41,21,19,42);
	СтрокаЦифр = "0123456789";	
	ВесРазряда = 1+Сдвиг;
	Результат = 0;
	// Замена служебных символов в коде.
	СтрокаБукв = "АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЩЭЮЯЪЫЬABCDEFGHIJKLMNOPQRSTUVWXYZ";
	НовКод = "";
	Для Инд = 1 По СтрДлина(Код) Цикл
		Попытка
			СимволКода = ВРЕГ(Сред(Код,Инд,1));
		Исключение
			СимволКода = Сред(Код,Инд,1);
		КонецПопытки;
		Если СтрНайти(СтрокаЦифр,СимволКода)=0 И СтрНайти(СтрокаБукв,СимволКода)=0 Тогда
			НовКод = НовКод + "0";
		Иначе
			НовКод = НовКод + СимволКода;
		КонецЕсли;
	КонецЦикла;
	Код = НовКод;
	//Конец замены
	Если СтрДлина(Код)<19 Тогда
		СтрокаКода = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(Код,19,"0","Справа");
	Иначе
		СтрокаКода = Лев(Код,19);
	КонецЕсли;
	
	Для Инд = 1 По 19 Цикл 
		СимволКода = Сред(СтрокаКода,Инд,1);
		Если СтрНайти(СтрокаЦифр,СимволКода)>0 Тогда
			Значение = Число(СимволКода);
		ИначеЕсли СтруктураСоответствий.Свойство(ВРег(СимволКода)) Тогда
			Значение = СтруктураСоответствий[СимволКода]%10;			
		КонецЕсли;		
		Результат = Результат + ВесРазряда*Значение;
		
		ВесРазряда = ВесРазряда + 1;
		Если ВесРазряда = 11 Тогда
			ВесРазряда = 1;
		КонецЕсли;
	КонецЦикла;
	
	КонтрольныйРазряд = Результат % 11;
	
	Если КонтрольныйРазряд = 10 Тогда
		Если Сдвиг = 0 Тогда
			Возврат ПолучитьУникальныйИдентификаторПлатежаСКонтрольнымРазрядом(Код,2);
		Иначе
			КонтрольныйРазряд = 0;
		КонецЕсли;
	КонецЕсли;
	
	ПолныйКод = СтрокаКода+Строка(КонтрольныйРазряд);
	
	Возврат ПолныйКод;
	
КонецФункции

// Возвращает ссылку на объект по уникальному идентификатору платежа
// Если объект не найден - возвращает Неопределено
//
&НаСервере
Функция ПолучитьСсылкуПоУникальномуИдентификаторуПлатежа(ИдентификаторПлатежа) Экспорт
	
	Запрос = Новый Запрос;
	
	ТипыОбъектов = ПолучитьТипыОбъектовСИдентификаторомПлатежа();
	
	Для каждого ТипОбъекта Из ТипыОбъектов Цикл
		
		Если ПравоДоступа("Чтение", Метаданные.Документы[ТипОбъекта]) Тогда
			
			Если ЗначениеЗаполнено(Запрос.Текст) Тогда
				Запрос.Текст = Запрос.Текст + " ОБЪЕДИНИТЬ ВСЕ ";	
			КонецЕсли;
			
			Запрос.Текст = Запрос.Текст +
				"
				|ВЫБРАТЬ
				|	ОснованиеПлатежа.Ссылка КАК Ссылка
				|ИЗ
				|	Документ." + ТипОбъекта + " КАК ОснованиеПлатежа
				|ГДЕ
				|	ОснованиеПлатежа.ИдентификаторПлатежа = &ИдентификаторПлатежа";
		
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ИдентификаторПлатежа", ИдентификаторПлатежа);
	
	ВыборкаОснование = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаОснование.Следующий() Тогда
		Возврат ВыборкаОснование.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли; 
	
КонецФункции // ПолучитьСсылкуПоУникальномуИдентификаторуПлатежа()

// Возвращает массив имен типов документов, у которых есть реквизит ИдентификаторПлатежа
//
&НаСервере
Функция ПолучитьТипыОбъектовСИдентификаторомПлатежа()
	
	ТипыОбъектов = Новый Массив;
	
	ТипыОбъектов.Добавить("РасходнаяНакладная");
	ТипыОбъектов.Добавить("АктВыполненныхРабот");
	ТипыОбъектов.Добавить("ЗаказПокупателя");
	ТипыОбъектов.Добавить("СчетНаОплату");
	ТипыОбъектов.Добавить("ПриемИПередачаВРемонт");
	
	Возврат ТипыОбъектов;
	
КонецФункции // ПолучитьТипыДокументовСИдентификаторомПлатежа()

#КонецОбласти 
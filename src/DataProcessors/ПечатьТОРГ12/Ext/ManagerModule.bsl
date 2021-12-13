﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ИдентификаторПечатнойФормы(ВключаяУслуги = Ложь, ИспользоватьФаксимиле = Ложь) Экспорт

	Возврат ?(ВключаяУслуги, "ТОРГ12СУслугами", "ТОРГ12") + ?(ИспользоватьФаксимиле, "Факсимиле", "");

КонецФункции

Функция КлючПараметровПечати() Экспорт

	Возврат "ПАРАМЕТРЫ_ПЕЧАТИ_Универсальные_ТОРГ12";

КонецФункции

Функция ПолныйПутьКМакету() Экспорт

	Возврат "Обработка.ПечатьТОРГ12.ПФ_MXL_ТОРГ12";

КонецФункции

Функция ПредставлениеПФ(ВключаяУслуги = Ложь, ИспользоватьФаксимиле = Ложь) Экспорт

	ПредставлениеПФ = НСтр("ru ='ТОРГ-12'");

	ДополнительноеПредставление = НСтр("ru ='Товарная накладная'");
	
	Если ВключаяУслуги Тогда

		ДополнительноеПредставление = ДополнительноеПредставление + НСтр("ru =' с услугами'");

	КонецЕсли;

	Если ИспользоватьФаксимиле Тогда

		ДополнительноеПредставление = ДополнительноеПредставление + НСтр("ru =', факсимиле'");

	КонецЕсли;

	ДополнительноеПредставление = НСтр("ru =' ('") + ДополнительноеПредставление + НСтр("ru =')'");

	Возврат ПредставлениеПФ + ДополнительноеПредставление;

КонецФункции

Функция СформироватьПФ(ОписаниеПечатнойФормы, ДанныеОбъектовПечати, ОбъектыПечати, ВключаяРаботыУслуги) Экспорт
	Перем Ошибки, ПервыйДокумент, НомерСтрокиНачало;

	Макет = УправлениеПечатью.МакетПечатнойФормы(ОписаниеПечатнойФормы.ПолныйПутьКМакету);
	ТабличныйДокумент = ОписаниеПечатнойФормы.ТабличныйДокумент;
	ДанныеПечати = Новый Структура;
	ЕстьТЧЗапасы = (ДанныеОбъектовПечати.Колонки.Найти("ТаблицаЗапасы") <> Неопределено);
	ЕстьТЧПродукция = (ДанныеОбъектовПечати.Колонки.Найти("ТаблицаПродукция") <> Неопределено);
	ЕстьТЧОтходы = (ДанныеОбъектовПечати.Колонки.Найти("ТаблицаОтходы") <> Неопределено);
	ЕстьТЧРаботыУслуги = (ДанныеОбъектовПечати.Колонки.Найти("ТаблицаРаботыУслуги") <> Неопределено);
	НациональнаяВалюта = Константы.НациональнаяВалюта.Получить();

	ОбластиМакета = Новый Структура;
	ОбластиМакета.Вставить("ОбластьМакетаШапка", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Шапка", "",
		Ошибки));
	ОбластиМакета.Вставить("ОбластьМакетаЗаголовокТаблицы", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет,
		"ЗаголовокТаб", НСтр("ru ='Заголовок таблицы'"), Ошибки));
	ОбластиМакета.Вставить("ОбластьМакетаСтрока", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Строка", "",
		Ошибки));
	ОбластиМакета.Вставить("ОбластьМакетаИтогоПоСтранице", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет,
		"ИтогоПоСтранице", НСтр("ru ='Итоги по странице'"), Ошибки));
	ОбластиМакета.Вставить("ОбластьМакетаВсего", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет, "Всего", "",
		Ошибки));
	ОбластиМакета.Вставить("ОбластьМакетаПодвалБезФаксимиле", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет,
		"ПодвалБезФаксимиле", "", Ошибки));
	ОбластиМакета.Вставить("ОбластьМакетаПодвалСФаксимиле", ПечатьДокументовУНФ.ПолучитьОбластьБезопасно(Макет,
		"ПодвалСФаксимиле", "", Ошибки));

	Для Каждого ДанныеОбъекта Из ДанныеОбъектовПечати Цикл

		ПечатьДокументовУНФ.ПередНачаломФормированияДокумента(ТабличныйДокумент, ПервыйДокумент, НомерСтрокиНачало,
			ДанныеПечати);

		Если ОбластиМакета.ОбластьМакетаШапка <> Неопределено Тогда

			НомерДокумента = ПечатьДокументовУНФ.ПолучитьНомерНаПечатьСУчетомДатыДокумента(ДанныеОбъекта.ДатаДокумента,
				ДанныеОбъекта.Номер, ДанныеОбъекта.Префикс);

			ДанныеПечати.Вставить("НомерДокумента", НомерДокумента);
			ДанныеПечати.Вставить("ДатаДокумента", ДанныеОбъекта.ДатаДокумента);

			БанковскийСчетГрузоотправителя = ?(ДанныеОбъекта.Организация = ДанныеОбъекта.Грузоотправитель,
				ДанныеОбъекта.БанковскийСчет, Неопределено);

			СведенияОГрузоотправителе = ПечатьДокументовУНФ.СведенияОЮрФизЛице(
				ДанныеОбъекта.Грузоотправитель, ДанныеОбъекта.ДатаДокумента, , БанковскийСчетГрузоотправителя);
			СведенияОГрузополучателе = ПечатьДокументовУНФ.СведенияОЮрФизЛице(
				ДанныеОбъекта.Грузополучатель, ДанныеОбъекта.ДатаДокумента, , );
			СведенияОПоставщике = ПечатьДокументовУНФ.СведенияОЮрФизЛице(ДанныеОбъекта.Организация,
				ДанныеОбъекта.ДатаДокумента, , ДанныеОбъекта.БанковскийСчет);
			СведенияОПокупателе = ПечатьДокументовУНФ.СведенияОЮрФизЛице(ДанныеОбъекта.Контрагент,
				ДанныеОбъекта.ДатаДокумента, , ДанныеОбъекта.БанковскийСчетКонтрагента);

			ДанныеПечати.Вставить("ПредставлениеПоставщика", ПечатьДокументовУНФ.ОписаниеОрганизации(
				СведенияОПоставщике,
				"ПолноеНаименование,ИНН,Свидетельство,ЮридическийАдрес,Телефоны,Факс,НомерСчета,Банк,БИК,КоррСчет"));
			ДанныеПечати.Вставить("ПредставлениеПлательщика", ПечатьДокументовУНФ.ОписаниеОрганизации(
				СведенияОПокупателе,
				"ПолноеНаименование,ИНН,Свидетельство,ЮридическийАдрес,Телефоны,Факс,НомерСчета,Банк,БИК,КоррСчет"));
			ДанныеПечати.Вставить("ПредставлениеГрузоотправителя", ПечатьДокументовУНФ.ОписаниеОрганизации(
				СведенияОГрузоотправителе,
				"ПолноеНаименование,ИНН,ФактическийАдрес,Телефоны,Факс,НомерСчета,Банк,БИК,КоррСчет"));

			Если ПустаяСтрока(ДанныеОбъекта.АдресДоставки) Тогда

				ДанныеПечати.Вставить("ПредставлениеГрузополучателя",
					ПечатьДокументовУНФ.ОписаниеОрганизации(СведенияОГрузополучателе,
					"ПолноеНаименование,ИНН,ФактическийАдрес,Телефоны,Факс,НомерСчета,Банк,БИК,КоррСчет"));

			Иначе

				ПерваяЧастьКИ = ПечатьДокументовУНФ.ОписаниеОрганизации(СведенияОГрузополучателе,
					"ПолноеНаименование,ИНН");
				ВтораяЧастьКИ = ПечатьДокументовУНФ.ОписаниеОрганизации(СведенияОГрузополучателе,
					"Телефоны,НомерСчета,Банк,БИК,КоррСчет");

				ДанныеПечати.Вставить("ПредставлениеГрузополучателя", СтрШаблон("%1, %2, %3", ПерваяЧастьКИ,
					ДанныеОбъекта.АдресДоставки, ВтораяЧастьКИ));

			КонецЕсли;

			ДанныеПечати.Вставить("ГрузоотправительПоОКПО", СведенияОГрузоотправителе.КодПоОКПО);
			ДанныеПечати.Вставить("ПредставлениеПодразделения", ДанныеОбъекта.ПредставлениеСкладаСписания);
			ДанныеПечати.Вставить("ВидДеятельностиПоОКДП", Неопределено);
			ДанныеПечати.Вставить("ГрузополучательПоОКПО", СведенияОГрузополучателе.КодПоОКПО);
			ДанныеПечати.Вставить("ПоставщикПоОКПО", СведенияОПоставщике.КодПоОКПО);
			ДанныеПечати.Вставить("ПлательщикПоОКПО", СведенияОПокупателе.КодПоОКПО);
			ДанныеПечати.Вставить("ПредставлениеОснования", ДанныеОбъекта.ПредставлениеОснования);

			ОснованиеНомер = Строка(ДанныеОбъекта.ОснованиеНомер);
			Если Не ПустаяСтрока(ОснованиеНомер) Тогда

				ОснованиеНомер = ПечатьДокументовУНФ.ПолучитьНомерНаПечатьСУчетомДатыДокумента(
					ДанныеОбъекта.ДатаДокумента, ОснованиеНомер, ДанныеОбъекта.Префикс);

			КонецЕсли;

			ДанныеПечати.Вставить("ОснованиеНомер", ОснованиеНомер);
			ДанныеПечати.Вставить("ОснованиеДата", ДанныеОбъекта.ОснованиеДата);
			ДанныеПечати.Вставить("ТранспортнаяНакладнаяНомер", ДанныеОбъекта.ТранспортнаяНакладнаяНомер);
			ДанныеПечати.Вставить("ТранспортнаяНакладнаяДата", ДанныеОбъекта.ТранспортнаяНакладнаяДата);

			ОбластиМакета.ОбластьМакетаШапка.Параметры.Заполнить(ДанныеПечати);
			ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет,
				ОбластиМакета.ОбластьМакетаШапка, ДанныеОбъекта.Ссылка);
			ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаШапка);

		КонецЕсли;

		Итоги = Новый Структура;
		Итоги.Вставить("ИтогоМестНаСтранице", 0);
		Итоги.Вставить("ИтогоМассаБруттоПоСтранице", 0);
		Итоги.Вставить("ИтогоКоличествоНаСтранице", 0);
		Итоги.Вставить("ИтогоСуммаНаСтранице", 0);
		Итоги.Вставить("ИтогоНДСНаСтранице", 0);
		Итоги.Вставить("ИтогоСуммаСНДСНаСтранице", 0);
		Итоги.Вставить("НомерСтроки", 0);
		Итоги.Вставить("КоличествоСтрок", 0);
		Итоги.Вставить("ИтогоМест", 0);
		Итоги.Вставить("ИтогоМассаБрутто", 0);
		Итоги.Вставить("ИтогоКоличество", 0);
		Итоги.Вставить("ИтогоСумма", 0);
		Итоги.Вставить("ИтогоНДС", 0);
		Итоги.Вставить("ИтогоСуммаСНДС", 0);
		Итоги.Вставить("НомерСтраницы", 1);
		Итоги.Вставить("ИспользоватьФаксимиле", ДанныеОбъекта.ИспользоватьФаксимиле);

		Если ОбластиМакета.ОбластьМакетаЗаголовокТаблицы <> Неопределено Тогда

			ДанныеПечати.Вставить("НомерСтраницы", "Страница " + Итоги.НомерСтраницы);

			ОбластиМакета.ОбластьМакетаЗаголовокТаблицы.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаЗаголовокТаблицы);

		КонецЕсли;

		Итоги.КоличествоСтрок = КоличествоСтрокКВыводуНаПечать(ДанныеОбъекта, ВключаяРаботыУслуги,
			ЕстьТЧЗапасы, ЕстьТЧРаботыУслуги, ЕстьТЧПродукция, ЕстьТЧОтходы);

		Если ОбластиМакета.ОбластьМакетаСтрока <> Неопределено Тогда

			ПараметрыНоменклатуры = Новый Структура;

			Если ЕстьТЧЗапасы Тогда
				
				// Наборы
				Итоги.Вставить("ЕстьНаборы", ДанныеОбъекта.ТаблицаЗапасы.Колонки.Найти(
					"НоменклатураНабора") <> Неопределено);

				Для Каждого СтрокаЗапаса Из ДанныеОбъекта.ТаблицаЗапасы Цикл

					Если Не ВключаяРаботыУслуги
						 И СтрокаЗапаса.ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.Запас
						 И СтрокаЗапаса.ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.ПодарочныйСертификат Тогда

						Продолжить;

					КонецЕсли;

					Если СтрокаЗапаса.Количество = 0 Тогда

						Продолжить;

					КонецЕсли;

					Если Итоги.НомерСтроки <> 0 И СтрокаКорректноРазмещаетсяНаСтранице(ТабличныйДокумент,
						ОбластиМакета, Итоги) = Ложь Тогда

						ДобавитьНовуюСтраницуДокумента(ТабличныйДокумент, ОбластиМакета, Итоги);

					КонецЕсли;

					ЗаполнитьДанныеПечатиПоСтрокеТабличнойЧасти(СтрокаЗапаса, ДанныеПечати, ПараметрыНоменклатуры,
						Итоги, ДанныеОбъекта.СуммаВключаетНДС);
					ОбластиМакета.ОбластьМакетаСтрока.Параметры.Заполнить(ДанныеПечати);
					ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаСтрока);
					
					// Наборы
					Если Итоги.ЕстьНаборы Тогда
						НаборыСервер.УчестьОформлениеСтрокиНабора(ТабличныйДокумент, ОбластиМакета.ОбластьМакетаСтрока,
							СтрокаЗапаса);
					КонецЕсли;
					// Конец Наборы

				КонецЦикла;

			КонецЕсли;

			Если ВключаяРаботыУслуги И ЕстьТЧРаботыУслуги Тогда
				
				// Наборы
				Итоги.Вставить("ЕстьНаборы", ДанныеОбъекта.ТаблицаРаботыУслуги.Колонки.Найти(
					"НоменклатураНабора") <> Неопределено);

				Для Каждого СтрокаРаботУслуг Из ДанныеОбъекта.ТаблицаРаботыУслуги Цикл

					Если Итоги.НомерСтроки <> 0 И СтрокаКорректноРазмещаетсяНаСтранице(ТабличныйДокумент,
						ОбластиМакета, Итоги) = Ложь Тогда

						ДобавитьНовуюСтраницуДокумента(ТабличныйДокумент, ОбластиМакета, Итоги);

					КонецЕсли;

					Если СтрокаРаботУслуг.Количество = 0 Тогда

						Продолжить;

					КонецЕсли;

					ЗаполнитьДанныеПечатиПоСтрокеТабличнойЧасти(СтрокаРаботУслуг, ДанныеПечати, ПараметрыНоменклатуры,
						Итоги, ДанныеОбъекта.СуммаВключаетНДС);
					ОбластиМакета.ОбластьМакетаСтрока.Параметры.Заполнить(ДанныеПечати);
					ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаСтрока);
					
					// Наборы
					Если Итоги.ЕстьНаборы Тогда
						НаборыСервер.УчестьОформлениеСтрокиНабора(ТабличныйДокумент, ОбластиМакета.ОбластьМакетаСтрока,
							СтрокаРаботУслуг);
					КонецЕсли;
					// Конец Наборы

				КонецЦикла;

			КонецЕсли;
			
			// Наборы
			Итоги.Вставить("ЕстьНаборы", Ложь);

			Если ЕстьТЧПродукция Тогда

				Для Каждого СтрокаПродукция Из ДанныеОбъекта.ТаблицаПродукция Цикл

					Если Не ВключаяРаботыУслуги
						 И СтрокаПродукция.ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.Запас Тогда

						Продолжить;

					КонецЕсли;

					Если СтрокаПродукция.Количество = 0 Тогда

						Продолжить;

					КонецЕсли;

					Если Итоги.НомерСтроки <> 0 И СтрокаКорректноРазмещаетсяНаСтранице(ТабличныйДокумент,
						ОбластиМакета, Итоги) = Ложь Тогда

						ДобавитьНовуюСтраницуДокумента(ТабличныйДокумент, ОбластиМакета, Итоги);

					КонецЕсли;

					ЗаполнитьДанныеПечатиПоСтрокеТабличнойЧасти(СтрокаПродукция, ДанныеПечати, ПараметрыНоменклатуры,
						Итоги, ДанныеОбъекта.СуммаВключаетНДС);

					ОбластиМакета.ОбластьМакетаСтрока.Параметры.Заполнить(ДанныеПечати);
					ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаСтрока);

				КонецЦикла;

			КонецЕсли;

			Если ЕстьТЧОтходы Тогда

				Для Каждого СтрокаОтходы Из ДанныеОбъекта.ТаблицаОтходы Цикл

					Если Не ВключаяРаботыУслуги И СтрокаОтходы.ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.Запас Тогда

						Продолжить;

					КонецЕсли;

					Если СтрокаОтходы.Количество = 0 Тогда

						Продолжить;

					КонецЕсли;

					Если Итоги.НомерСтроки <> 0 И СтрокаКорректноРазмещаетсяНаСтранице(ТабличныйДокумент,
						ОбластиМакета, Итоги) = Ложь Тогда

						ДобавитьНовуюСтраницуДокумента(ТабличныйДокумент, ОбластиМакета, Итоги);

					КонецЕсли;

					ЗаполнитьДанныеПечатиПоСтрокеТабличнойЧасти(СтрокаОтходы, ДанныеПечати, ПараметрыНоменклатуры,
						Итоги, ДанныеОбъекта.СуммаВключаетНДС);

					ОбластиМакета.ОбластьМакетаСтрока.Параметры.Заполнить(ДанныеПечати);
					ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаСтрока);

				КонецЦикла;

			КонецЕсли;

		КонецЕсли;

		Если ОбластиМакета.ОбластьМакетаИтогоПоСтранице <> Неопределено Тогда

			ОбластиМакета.ОбластьМакетаИтогоПоСтранице.Параметры.Заполнить(Итоги);
			ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаИтогоПоСтранице);

		КонецЕсли;

		Если ОбластиМакета.ОбластьМакетаВсего <> Неопределено Тогда

			ОбластиМакета.ОбластьМакетаВсего.Параметры.Заполнить(Итоги);
			ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаВсего);

		КонецЕсли;

		ОбластьМакета = ?(ДанныеОбъекта.ИспользоватьФаксимиле = Перечисления.ДаНет.Да,
			ОбластиМакета.ОбластьМакетаПодвалСФаксимиле, ОбластиМакета.ОбластьМакетаПодвалБезФаксимиле);
		Если ОбластьМакета <> Неопределено Тогда

			ПоследняяЦифра = Прав(Строка(Итоги.НомерСтраницы), 1);
			Суффикс = ?(ПоследняяЦифра = "1", НСтр("ru =' листе'"), НСтр("ru =' листах'"));
			ДанныеПечати.Вставить("КоличествоЛистовВПриложении", Строка(Итоги.НомерСтраницы) + Суффикс);

			ДанныеПечати.Вставить("ДолжностьРуководителя", ДанныеОбъекта.ДолжностьРуководителя);
			ДанныеПечати.Вставить("РасшифровкаПодписиРуководителя", ДанныеОбъекта.РасшифровкаПодписиРуководителя);
			ДанныеПечати.Вставить("РасшифровкаПодписиГлавногоБухгалтера",
				ДанныеОбъекта.РасшифровкаПодписиГлавногоБухгалтера);
			ДанныеПечати.Вставить("ДолжностьКладовщика", ДанныеОбъекта.ДолжностьКладовщика);
			ДанныеПечати.Вставить("РасшифровкаПодписиКладовщика", ДанныеОбъекта.РасшифровкаПодписиКладовщика);
			ДанныеПечати.Вставить("КоличествоПорядковыхНомеровЗаписейПрописью", ЧислоПрописью(
				Итоги.КоличествоСтрок, , ",,,,,,,,0"));
			ДанныеПечати.Вставить("ВсегоМестПрописью", ?(Итоги.ИтогоМест = 0, "", ЧислоПрописью(
				Итоги.ИтогоМест, , ",,,С,,,,,0")));
			ДанныеПечати.Вставить("МассаГрузаПрописью", МассаГрузаПрописью(Итоги.ИтогоМассаБрутто,
				ДанныеОбъекта));
			ДанныеПечати.Вставить("СуммаПрописью", РаботаСКурсамиВалют.СформироватьСуммуПрописью(
				Итоги.ИтогоСуммаСНДС, НациональнаяВалюта));
			ДанныеПечати.Вставить("ДоверенностьНомер", ДанныеОбъекта.ДоверенностьНомер);
			ДанныеПечати.Вставить("ДоверенностьДата", ДанныеОбъекта.ДоверенностьДата);
			ДанныеПечати.Вставить("ДоверенностьВыдана", ДанныеОбъекта.ДоверенностьВыдана);
			ДанныеПечати.Вставить("ДоверенностьЧерезКого", ДанныеОбъекта.ДоверенностьЛицо);
			ДанныеПечати.Вставить("ДоверенностьЧерезКого", ДанныеОбъекта.ДоверенностьЛицо);
			ДанныеПечати.Вставить("РасшифровкаПодписиКонтрагента", ДанныеОбъекта.РасшифровкаПодписиКонтрагента);

			ПолнаяДатаДокумента = Формат(ДанныеОбъекта.ДатаДокумента, "ДФ=""дд ММММ гггг """"года""""""");
			ДлинаСтроки = СтрДлина(ПолнаяДатаДокумента);
			ПервыйРазделитель = СтрНайти(ПолнаяДатаДокумента, " ");
			ВторойРазделитель = СтрНайти(Прав(ПолнаяДатаДокумента, ДлинаСтроки - ПервыйРазделитель), " ")
								+ ПервыйРазделитель;

			ДанныеПечати.Вставить("ДатаДокументаДень", """" + Лев(ПолнаяДатаДокумента, ПервыйРазделитель - 1) + """");
			ДанныеПечати.Вставить("ДатаДокументаМесяц", Сред(ПолнаяДатаДокумента, ПервыйРазделитель + 1,
				ВторойРазделитель - ПервыйРазделитель - 1));
			ДанныеПечати.Вставить("ДатаДокументаГод", Прав(ПолнаяДатаДокумента, ДлинаСтроки - ВторойРазделитель));

			Если ДанныеОбъекта.ИспользоватьФаксимиле = Перечисления.ДаНет.Да Тогда

				ПодписиИФаксимиле = Новый Соответствие; // Ключ - имя картинки в области, Значение - имя реквизита
				ПодписиИФаксимиле.Вставить("ПодписьРуководителя", "ФаксимилеРуководителя");
				ПодписиИФаксимиле.Вставить("ПодписьГлавногоБухгалтера", "ФаксимилеГлавногоБухгалтера");
				ПодписиИФаксимиле.Вставить("ПодписьКладовщика", "ФаксимилеКладовщика");
				ПодписиИФаксимиле.Вставить("ПечатьОрганизации", "ФаксимилеПечати");

				ПодписьДокументовУНФ.ЗаполнитьФаксимилеВОбластиМакета(ОбластьМакета, ДанныеОбъекта, ПодписиИФаксимиле,
					Ошибки);

			КонецЕсли;

			ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластьМакета);

		КонецЕсли;

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати,
			ДанныеОбъекта.Ссылка);

	КонецЦикла;

	Возврат ТабличныйДокумент;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьДанныеПечатиПоСтрокеТабличнойЧасти(СтрокаТабличнойЧасти, ДанныеПечати, ПараметрыНоменклатуры,
	Итоги, СуммаВключаетНДС)

	ДанныеПечати.Очистить();

	Если Не Итоги.ЕстьНаборы Или Не СтрокаТабличнойЧасти.ЭтоНабор Тогда
		Итоги.НомерСтроки = Итоги.НомерСтроки + 1;
		НомерСтроки = Итоги.НомерСтроки;
	Иначе
		НомерСтроки = 0;
	КонецЕсли;
	ДанныеПечати.Вставить("НомерСтроки", НомерСтроки);

	ПараметрыНоменклатуры.Очистить();
	ПараметрыНоменклатуры.Вставить("Содержание", СтрокаТабличнойЧасти.Содержание);
	ПараметрыНоменклатуры.Вставить("ПредставлениеНоменклатуры", СтрокаТабличнойЧасти.ПредставлениеНоменклатуры);
	ПараметрыНоменклатуры.Вставить("ПредставлениеХарактеристики", СтрокаТабличнойЧасти.Характеристика);
	// Наборы
	Если Итоги.ЕстьНаборы Тогда
		ПараметрыНоменклатуры.Вставить("НеобходимоВыделитьКакСоставНабора",
			СтрокаТабличнойЧасти.НеобходимоВыделитьКакСоставНабора);
	КонецЕсли;

	ДанныеПечати.Вставить("ПредставлениеНоменклатуры", ПечатьДокументовУНФ.ПредставлениеНоменклатуры(
		ПараметрыНоменклатуры));
	ДанныеПечати.Вставить("ПредставлениеКодаНоменклатуры", ПечатьДокументовУНФ.ПредставлениеКодаНоменклатуры(
		СтрокаТабличнойЧасти));
	ДанныеПечати.Вставить("ЕдиницаИзмеренияПоОКЕИ_Наименование",
		СтрокаТабличнойЧасти.ЕдиницаИзмеренияПоОКЕИ_Наименование);
	ДанныеПечати.Вставить("ЕдиницаИзмеренияПоОКЕИ_Код", СтрокаТабличнойЧасти.ЕдиницаИзмеренияПоОКЕИ_Код);
	
	Если ТипЗнч(СтрокаТабличнойЧасти.ВидУпаковки) = Тип("СправочникСсылка.ЕдиницыИзмерения")
		Или ТипЗнч(СтрокаТабличнойЧасти.ВидУпаковки) = Тип("СправочникСсылка.КлассификаторЕдиницИзмерения") Тогда
		ДанныеПечати.Вставить("ВидУпаковки", СтрокаТабличнойЧасти.ВидУпаковки.Наименование);
	Иначе
		ДанныеПечати.Вставить("ВидУпаковки", СтрокаТабличнойЧасти.ВидУпаковки);
	КонецЕсли;
	
	ДанныеПечати.Вставить("КоличествоВОдномМесте", СтрокаТабличнойЧасти.КоличествоВОдномМесте);
	ДанныеПечати.Вставить("КоличествоМест", СтрокаТабличнойЧасти.КоличествоМест);
	ДанныеПечати.Вставить("Количество", Окр(СтрокаТабличнойЧасти.Количество
											* СтрокаТабличнойЧасти.КоэффициентЕдиницыИзмерения, 3));

	ЗаполнитьПолеМассаБрутто(ДанныеПечати, СтрокаТабличнойЧасти);

	ДанныеПечати.Вставить("СтавкаНДС", СтрокаТабличнойЧасти.СтавкаНДС);
	ДанныеПечати.Вставить("СуммаСНДС", СтрокаТабличнойЧасти.Всего);
	ДанныеПечати.Вставить("СуммаНДС", СтрокаТабличнойЧасти.СуммаНДС);

	СуммаБезНДС = СтрокаТабличнойЧасти.Сумма - ?(СуммаВключаетНДС, СтрокаТабличнойЧасти.СуммаНДС, 0);

	Если ТипЗнч(ДанныеПечати.Количество) <> Тип("Число") Тогда

		Цена = Неопределено; //При реализации услуг количество (и цена) могут не указываться

	ИначеЕсли СуммаВключаетНДС = Ложь
			  И СтрокаТабличнойЧасти.КоэффициентЕдиницыИзмерения = 1
			  И СтрокаТабличнойЧасти.Владелец().Колонки.Найти("СуммаСкидкиПоСтроке") <> Неопределено
			  И СтрокаТабличнойЧасти.СуммаСкидкиПоСтроке = 0 Тогда

		Цена = СтрокаТабличнойЧасти.Цена;

	Иначе

		Цена = ОКР(СуммаБезНДС / ?(ДанныеПечати.Количество = 0, 1, ДанныеПечати.Количество), 2);

	КонецЕсли;

	ДанныеПечати.Вставить("СуммаБезНДС", СуммаБезНДС);
	ДанныеПечати.Вставить("Цена", Цена);

	Если Не Итоги.ЕстьНаборы Или Не СтрокаТабличнойЧасти.ЭтоНабор Тогда
		Итоги.ИтогоМестНаСтранице = Итоги.ИтогоМестНаСтранице + ?(
			ДанныеПечати.КоличествоМест = Неопределено, 0, ДанныеПечати.КоличествоМест);
		Итоги.ИтогоКоличествоНаСтранице = Итоги.ИтогоКоличествоНаСтранице + ДанныеПечати.Количество;
		Итоги.ИтогоМассаБруттоПоСтранице = Итоги.ИтогоМассаБруттоПоСтранице
													 + ДанныеПечати.МассаБрутто;
		Итоги.ИтогоСуммаНаСтранице = Итоги.ИтогоСуммаНаСтранице + ДанныеПечати.СуммаБезНДС;
		Итоги.ИтогоНДСНаСтранице = Итоги.ИтогоНДСНаСтранице + ДанныеПечати.СуммаНДС;
		Итоги.ИтогоСуммаСНДСНаСтранице = Итоги.ИтогоСуммаСНДСНаСтранице + ДанныеПечати.СуммаСНДС;

		Итоги.ИтогоМест = Итоги.ИтогоМест + ?(ДанныеПечати.КоличествоМест = Неопределено, 0,
			ДанныеПечати.КоличествоМест);
		Итоги.ИтогоКоличество = Итоги.ИтогоКоличество + ДанныеПечати.Количество;
		Итоги.ИтогоМассаБрутто = Итоги.ИтогоМассаБрутто + ДанныеПечати.МассаБрутто;
		Итоги.ИтогоСумма = Итоги.ИтогоСумма + ДанныеПечати.СуммаБезНДС;
		Итоги.ИтогоНДС = Итоги.ИтогоНДС + ДанныеПечати.СуммаНДС;
		Итоги.ИтогоСуммаСНДС = Итоги.ИтогоСуммаСНДС + ДанныеПечати.СуммаСНДС;
	КонецЕсли;

КонецПроцедуры

Функция СтрокаКорректноРазмещаетсяНаСтранице(ТабличныйДокумент, СтруктураОбластейМакета, Итоги)

	ЕстьВсеОбласти = Истина;
	Для Каждого ЭлементСтруктуры Из СтруктураОбластейМакета Цикл

		Если ЭлементСтруктуры.Значение = Неопределено Тогда

			ЕстьВсеОбласти = Ложь;
			Прервать;

		КонецЕсли;

	КонецЦикла;

	Если Не ЕстьВсеОбласти Тогда

		Возврат Неопределено;

	КонецЕсли;

	МассивОбластейМакета = Новый Массив;

	МассивОбластейМакета.Добавить(СтруктураОбластейМакета.ОбластьМакетаСтрока);
	МассивОбластейМакета.Добавить(СтруктураОбластейМакета.ОбластьМакетаИтогоПоСтранице);

	Если Итоги.НомерСтроки = Итоги.КоличествоСтрок - 1 Тогда

		МассивОбластейМакета.Добавить(СтруктураОбластейМакета.ОбластьМакетаВсего);

		ИмяСекции = ?(Итоги.ИспользоватьФаксимиле = Перечисления.ДаНет.Нет,
			"ОбластьМакетаПодвалБезФаксимиле", "ОбластьМакетаПодвалСФаксимиле");
		МассивОбластейМакета.Добавить(СтруктураОбластейМакета[ИмяСекции]);

	КонецЕсли;

	Возврат ТабличныйДокумент.ПроверитьВывод(МассивОбластейМакета)

КонецФункции

Процедура ДобавитьНовуюСтраницуДокумента(ТабличныйДокумент, ОбластиМакета, Итоги)

	ОбластиМакета.ОбластьМакетаИтогоПоСтранице.Параметры.Заполнить(Итоги);
	ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаИтогоПоСтранице);

	ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();

	Итоги.ИтогоМестНаСтранице = 0;
	Итоги.ИтогоКоличествоНаСтранице = 0;
	Итоги.ИтогоМассаБруттоПоСтранице = 0;
	Итоги.ИтогоСуммаНаСтранице = 0;
	Итоги.ИтогоНДСНаСтранице = 0;
	Итоги.ИтогоСуммаСНДСНаСтранице = 0;
	
	// Выведем заголовок таблицы
	Итоги.НомерСтраницы = Итоги.НомерСтраницы + 1;
	ПредставлениеСтраницы = СтрШаблон(НСтр("ru ='Страница %1'"), Итоги.НомерСтраницы);
	ОбластиМакета.ОбластьМакетаЗаголовокТаблицы.Параметры.Заполнить(Новый Структура("НомерСтраницы",
		ПредставлениеСтраницы));
	ТабличныйДокумент.Вывести(ОбластиМакета.ОбластьМакетаЗаголовокТаблицы);

КонецПроцедуры

Функция МассаГрузаПрописью(Знач ИтогоМассаБрутто, Знач ДанныеОбъекта)

	ЗначениеДляПечати = ИтогоМассаБрутто;

	Если Не ЗначениеЗаполнено(ЗначениеДляПечати) Тогда
		ЗначениеДляЗаполнения = Новый Структура("Вес");
		ЗаполнитьЗначенияСвойств(ЗначениеДляЗаполнения, ДанныеОбъекта);
		ЗначениеДляПечати = ЗначениеДляЗаполнения.Вес;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ЗначениеДляПечати) Тогда
		Возврат "";
	КонецЕсли;

	Возврат ЧислоПрописью(
	ЗначениеДляПечати, "ДП=Истина", "килограмм,килограмма,килограммов,м,грамм,грамма,граммов,м,3");

КонецФункции

Процедура ЗаполнитьПолеМассаБрутто(Знач ДанныеПечати, Знач СтрокаТабличнойЧасти)

	ЗначениеДляЗаполнения = Новый Структура("МассаБрутто", 0);
	ЗаполнитьЗначенияСвойств(ЗначениеДляЗаполнения, СтрокаТабличнойЧасти);
	ДанныеПечати.Вставить("МассаБрутто", ЗначениеДляЗаполнения.МассаБрутто);

КонецПроцедуры

Функция КоличествоСтрокКВыводуНаПечать(ДанныеОбъекта, ВключаяРаботыУслуги, ЕстьТЧЗапасы, ЕстьТЧРаботыУслуги,
	ЕстьТЧПродукция, ЕстьТЧОтходы)

	КоличествоРезультирующихСтрок = 0;

	Если ЕстьТЧЗапасы Тогда

		КоличествоРезультирующихСтрок = КоличествоРезультирующихСтрок + ПросуммироватьСтрокиТаблицы(
			ДанныеОбъекта.ТаблицаЗапасы, ВключаяРаботыУслуги);

	КонецЕсли;

	Если ВключаяРаботыУслуги И ЕстьТЧРаботыУслуги Тогда

		КоличествоРезультирующихСтрок = КоличествоРезультирующихСтрок + ПросуммироватьСтрокиТаблицы(
			ДанныеОбъекта.ТаблицаРаботыУслуги, Истина);

	КонецЕсли;

	Если ЕстьТЧПродукция Тогда

		КоличествоРезультирующихСтрок = КоличествоРезультирующихСтрок + ПросуммироватьСтрокиТаблицы(
			ДанныеОбъекта.ТаблицаПродукция, ВключаяРаботыУслуги);

	КонецЕсли;

	Если ЕстьТЧОтходы Тогда

		КоличествоРезультирующихСтрок = КоличествоРезультирующихСтрок + ПросуммироватьСтрокиТаблицы(
			ДанныеОбъекта.ТаблицаОтходы, ВключаяРаботыУслуги);

	КонецЕсли;

	Возврат КоличествоРезультирующихСтрок;

КонецФункции

Функция ПросуммироватьСтрокиТаблицы(ТаблицаДокумента, ВключаяРаботыУслуги)

	КоличествоРезультирующихСтрок = 0;

	ЕстьНаборы = ТаблицаДокумента.Колонки.Найти("ЭтоНабор") <> Неопределено;

	Для Каждого СтрокаТаблицы Из ТаблицаДокумента Цикл

		Если Не ВключаяРаботыУслуги
			 И СтрокаТаблицы.ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.Запас
			 И СтрокаТаблицы.ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.ПодарочныйСертификат Тогда

			Продолжить;

		КонецЕсли;

		Если СтрокаТаблицы.Количество = 0 Тогда

			Продолжить;

		КонецЕсли;

		Если ЕстьНаборы И СтрокаТаблицы.ЭтоНабор Тогда

			Продолжить;

		КонецЕсли;

		КоличествоРезультирующихСтрок = КоличествоРезультирующихСтрок + 1;

	КонецЦикла;

	Возврат КоличествоРезультирующихСтрок;

КонецФункции

Функция МатрицаВозможныхВариантов() Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЛОЖЬ КАК ВключаяУслуги,
	|	ЛОЖЬ КАК ИспользоватьФаксимиле
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ЛОЖЬ,
	|	ИСТИНА
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ИСТИНА,
	|	ЛОЖЬ
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ИСТИНА,
	|	ИСТИНА");

	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

#КонецОбласти

#КонецЕсли

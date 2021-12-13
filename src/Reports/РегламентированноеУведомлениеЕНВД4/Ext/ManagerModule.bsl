﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Ложь;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Истина;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "Отчет.РегламентированноеУведомлениеЕНВД4.Форма.Форма2014_1";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2014_1";
	Стр.ОписаниеФормы = "ЕНВД-4/приказ ФНС от 11 декабря 2012 г. N ММВ-7-6/941@";
	
	Возврат Результат;
КонецФункции

Функция ПечатьСразу(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат ПечатьСразу_Форма2014_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция СформироватьМакет(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат СформироватьМакет_Форма2014_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2014_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Попытка
			Данные = Объект.ДанныеУведомления.Получить();
			Проверить_Форма2014_1(Данные, УникальныйИдентификатор);
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Проверка уведомления прошла успешно.", УникальныйИдентификатор);
		Исключение
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("При проверке уведомления обнаружены ошибки.", УникальныйИдентификатор);
		КонецПопытки;
	КонецЕсли;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт 
	Если ИмяФормы = "Форма2014_1" Тогда 
		Возврат ПроверитьДокументСВыводомВТаблицу_Форма2014_1(УведомлениеОСпецрежимахНалогообложения.ДанныеУведомленияДляВыгрузки(Объект), УникальныйИдентификатор);
	КонецЕсли;
КонецФункции

Функция СформироватьМакет_Форма2014_1(Объект)
	ПечатнаяФорма = Новый ТабличныйДокумент;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УведомлениеОСпецрежимах_"+Объект.ВидУведомления.Метаданные().Имя;
	
	МакетУведомления = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Печать_MXL_Форма2014_1");
	ОбластьТитульный = МакетУведомления.ПолучитьОбласть("Титульный");
	ОбластьОграничители = МакетУведомления.ПолучитьОбласть("Ограничители");
	ОбластьПустаяСтрока = МакетУведомления.ПолучитьОбласть("ПустаяСтрока");
	МассивДляПроверки = Новый Массив;
	МассивДляПроверки.Добавить(ОбластьПустаяСтрока);
	МассивДляПроверки.Добавить(ОбластьОграничители);
	
	СтруктураПараметров = Объект.ДанныеУведомления.Получить();
	Титульный = СтруктураПараметров.ТитульныйЛист[0];
	
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.П_ИНН, "ИНН1_", ОбластьТитульный.Области, 12);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.КОД_НО, "КОД_НО_", ОбластьТитульный.Области, 4);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.КОД_ПРИЧИНЫ, "КОД_ПРИЧИНЫ_", ОбластьТитульный.Области, 1);
	
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.Фамилия_ИП, "Фамилия_", ОбластьТитульный.Области, 40);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.Имя_ИП, "Имя_", ОбластьТитульный.Области, 40);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.Отчество_ИП, "Отчество_", ОбластьТитульный.Области, 40);
	
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.П_ОГРНИП, "ОГРН_", ОбластьТитульный.Области, 15);
	Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВОбластиМакета(Титульный.ДАТА_ПРЕКРАЩЕНИЯ_ЕНВД, "ДАТА_ПРИМЕНЕНЕНИ_ЕНВД_", ОбластьТитульный.Области);	
	
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета("000", "ПРИЛОЖЕНО_СТРАНИЦ_", ОбластьТитульный.Области, 3);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета("000", "ПРИЛОЖЕНО_ЛИСТОВ_", ОбластьТитульный.Области, 3);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВОбластиМакета(Титульный.ПРИЛОЖЕНО_СТРАНИЦ, "ПРИЛОЖЕНО_СТРАНИЦ_", ОбластьТитульный.Области, 3);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВОбластиМакета(Титульный.ПРИЛОЖЕНО_ЛИСТОВ, "ПРИЛОЖЕНО_ЛИСТОВ_", ОбластьТитульный.Области, 3);
	
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.ПРИЗНАК_НП_ПОДВАЛ, "ПРИЗНАК_НП_ПОДВАЛ_", ОбластьТитульный.Области, 1);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Объект.ПодписантФамилия, "ОргПодписантФамилия_", ОбластьТитульный.Области, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Объект.ПодписантИмя, "ОргПодписантИмя_", ОбластьТитульный.Области, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Объект.ПодписантОтчество, "ОргПодписантОтчество_", ОбластьТитульный.Области, 20);
	
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.ИНН_ПРЕДСТАВИТЕЛЯ, "ИНН_ПРЕДСТАВИТЕЛЯ_", ОбластьТитульный.Области, 12);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.ТЕЛЕФОН, "Телефон_", ОбластьТитульный.Области, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ, "ДокУпПред_", ОбластьТитульный.Области, 40);
	Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВОбластиМакета(Титульный.ДАТА_ПОДПИСИ, "ДатаПодписи_", ОбластьТитульный.Области);
	
	ПечатнаяФорма.Вывести(ОбластьТитульный);
	ПечатнаяФорма.Вывести(ОбластьОграничители);
	ПечатнаяФорма.ВывестиГоризонтальныйРазделительСтраниц();
	
	ОбластьПодвалДопЛист = МакетУведомления.ПолучитьОбласть("ПустаяСтрока");
	МассивДляПроверки[1] = ОбластьПодвалДопЛист;
	
	Страница = 1;
	Для Каждого ДопЛист Из СтруктураПараметров.Лист2 Цикл 
		
		ОбластьДопЛист = МакетУведомления.ПолучитьОбласть("Приложение");
		ОбластиМакета = ОбластьДопЛист.Области;
		Страница = Страница + 1;
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.П_ИНН, "ИНН2_", ОбластиМакета, 12);
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета("000", "НомСтр1_", ОбластиМакета, 3);
		Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВОбластиМакета(Страница, "НомСтр1_", ОбластиМакета, 3);
		
		Для Инд = 1 по 3 Цикл
			Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(ДопЛист["КОД_ВИДА_ДЕЯТЕЛЬНОСТИ" + Инд], "КОД_ВИДА_ДЕЯТЕЛЬНОСТИ" + Инд + "_", ОбластиМакета, 2); 
			Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(ДопЛист["ИНДЕКС" + Инд], "ИНДЕКС" + Инд + "_", ОбластиМакета, 6); 
			Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(ДопЛист["РЕГИОН" + Инд], "РЕГИОН" + Инд + "_", ОбластиМакета, 2); 
			Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(ДопЛист["РАЙОН" + Инд], "РАЙОН" + Инд + "_", ОбластиМакета, 34); 
			Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(ДопЛист["ГОРОД" + Инд], "ГОРОД" + Инд + "_", ОбластиМакета, 34); 
			Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(ДопЛист["НаселенныйПункт" + Инд], "НаселенныйПункт" + Инд + "_", ОбластиМакета, 34); 
			Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(ДопЛист["Улица" + Инд], "Улица" + Инд + "_", ОбластиМакета, 34); 
			Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(ДопЛист["Дом" + Инд], "Дом" + Инд + "_", ОбластиМакета, 8); 
			Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(ДопЛист["Корпус" + Инд], "Корпус" + Инд + "_", ОбластиМакета, 8); 
			Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(ДопЛист["Квартира" + Инд], "Квартира" + Инд + "_", ОбластиМакета, 8); 
		КонецЦикла;
		
		ПечатнаяФорма.Вывести(ОбластьДопЛист);
		
		ПечатнаяФорма.Вывести(ОбластьОграничители);
		ПечатнаяФорма.ВывестиГоризонтальныйРазделительСтраниц();
		
	КонецЦикла;
	
	Возврат ПечатнаяФорма;
КонецФункции

Функция ПечатьСразу_Форма2014_1(Объект)
	
	ПечатнаяФорма = СформироватьМакет_Форма2014_1(Объект);
	
	ПечатнаяФорма.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.ОбластьПечати = ПечатнаяФорма.Область();
	
	Возврат ПечатнаяФорма;
	
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2014_1(СведенияОтправки)
	Префикс = "UT_ENVD4";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Процедура Проверить_Форма2014_1(Данные, УникальныйИдентификатор)
	Титульный = Данные.ТитульныйЛист[0];
	
	Ошибок = 0;
	Если Не ЗначениеЗаполнено(Титульный.ДАТА_ПОДПИСИ) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указана дата подписи", УникальныйИдентификатор);
		Ошибок = Ошибок + 1;
	КонецЕсли;
	
	Если РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(Титульный.П_ИНН, Ложь, "") Тогда 
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Неправильно заполнен ИНН/КПП на титульном листе", УникальныйИдентификатор);
		Ошибок = Ошибок + 1;
	КонецЕсли;
	
	Если Титульный.КОД_ПРИЧИНЫ <> "3" И (Не ЗначениеЗаполнено(Титульный.ДАТА_ПРЕКРАЩЕНИЯ_ЕНВД)) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не прекращения дата начала применения ЕНВД", УникальныйИдентификатор);
		Ошибок = Ошибок + 1;
	КонецЕсли;
	
	Если Титульный.КОД_ПРИЧИНЫ = "3" И ЗначениеЗаполнено(Титульный.ДАТА_ПРЕКРАЩЕНИЯ_ЕНВД) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("При подаче заявления с кодом 3 дата прекращения применения ЕНВД не указывается", УникальныйИдентификатор);
		Ошибок = Ошибок + 1;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.КОД_ПРИЧИНЫ) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указана дата начала применения ЕНВД", УникальныйИдентификатор);
		Ошибок = Ошибок + 1;
	КонецЕсли;
	
	Страница = 0;
	Заполнено = Ложь;
	Для Каждого ДопЛист Из Данные.Лист2 Цикл
		Страница = Страница + 1;
		
		Для Инд = 1 По 3 Цикл 
			Если ЗначениеЗаполнено(ДопЛист["КОД_ВИДА_ДЕЯТЕЛЬНОСТИ" + Инд])
				И (Не ЗначениеЗаполнено(ДопЛист["РЕГИОН" + Инд])) Тогда
				
					РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указан адрес (доп. лист " + Страница + ")", УникальныйИдентификатор);
					Ошибок = Ошибок + 1;
			КонецЕсли;
				
			Если ЗначениеЗаполнено(ДопЛист["КОД_ВИДА_ДЕЯТЕЛЬНОСТИ" + Инд])
				Или ЗначениеЗаполнено(ДопЛист["РЕГИОН" + Инд]) Тогда
				
					Заполнено = Истина;
			КонецЕсли;
		КонецЦикла;
		
		Если Ошибок > 3 Тогда
			ВызватьИсключение "";
		КонецЕсли;
	КонецЦикла;
	
	Если Титульный.КОД_ПРИЧИНЫ = "4" И Не Заполнено Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не заполнены сведения о видах деятельности на доп. страницах", УникальныйИдентификатор);
		ВызватьИсключение "";
	КонецЕсли;
	
	Если Ошибок > 0 Тогда
		ВызватьИсключение "";
	КонецЕсли;
КонецПроцедуры

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2014_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Документы.УведомлениеОСпецрежимахНалогообложения.НачальнаяИнициализацияОбщихРеквизитовВыгрузки(Объект);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьОбщиеДанные(Объект, ОсновныеСведения);
	
	Данные = Объект.ДанныеУведомления.Получить();
	Титульный = Данные.ТитульныйЛист[0];
	
	ОсновныеСведения.Вставить("ДатаПрекрЕНВД", Формат(Титульный.ДАТА_ПРЕКРАЩЕНИЯ_ЕНВД, "ДФ=dd.MM.yyyy"));
	ОсновныеСведения.Вставить("ПрПодп", 	Титульный.ПРИЗНАК_НП_ПОДВАЛ);
	ОсновныеСведения.Вставить("ИННФЛПред", 	Титульный.ИНН_ПРЕДСТАВИТЕЛЯ);
	ОсновныеСведения.Вставить("Телефон",	Титульный.ТЕЛЕФОН);
	ОсновныеСведения.Вставить("ОГРНФЛ", 	Титульный.П_ОГРНИП);
	ОсновныеСведения.Вставить("НаимДок", 	Титульный.ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ);
	ОсновныеСведения.Вставить("ПричЗаяв", 	Титульный.КОД_ПРИЧИНЫ);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2014_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2014_1(Объект, УникальныйИдентификатор)
	СведенияЭлектронногоПредставления = УведомлениеОСпецрежимахНалогообложения.СведенияЭлектронногоПредставления();
	
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	Ошибки = ПроверитьДокументСВыводомВТаблицу_Форма2014_1(ДанныеУведомления, УникальныйИдентификатор);
	УведомлениеОСпецрежимахНалогообложения.СообщитьОшибкиПриПроверкеВыгрузки(Объект, Ошибки, ДанныеУведомления);
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2014_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2014_1");
	ЗаполнитьДанными_Форма2014_1(Объект, ОсновныеСведения, СтруктураВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ОтсечьНезаполненныеНеобязательныеУзлы(СтруктураВыгрузки);
	УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВТаблицу(СтруктураВыгрузки, ОсновныеСведения, СведенияЭлектронногоПредставления);
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Процедура ЗаполнитьДанными_Форма2014_1(Объект, Параметры, ДеревоВыгрузки)
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(Параметры, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметры(Параметры, ДеревоВыгрузки);
	
	Данные = Объект.ДанныеУведомления.Получить();
	ДопЛисты = Данные.Лист2;
	
	Узел_Документ = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(ДеревоВыгрузки, "Документ");
	Узел_ЕНВД4 = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_Документ, "ЕНВД4");
	Узел_СвПредДеят = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_ЕНВД4, "СвПредДеят");
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанными_ЕНВДх(ДопЛисты, Узел_СвПредДеят);
КонецПроцедуры

Функция ПроверитьДокументСВыводомВТаблицу_Форма2014_1(Данные, УникальныйИдентификатор)
	ТаблицаОшибок = Новый СписокЗначений;
	Титульный = Данные.ТитульныйЛист[0];
	
	Если Не ЗначениеЗаполнено(Титульный.П_ОГРНИП) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан ОГРН на титульном листе", "ТитульныйЛист", "П_ОГРНИП", Титульный.UID));
	ИначеЕсли Не РегламентированныеДанныеКлиентСервер.ОГРНСоответствуетТребованиям(Титульный.П_ОГРНИП, Ложь, "") Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан ОГРН на титульном листе", "ТитульныйЛист", "П_ОГРНИП", Титульный.UID));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.П_ИНН) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан ИНН на титульном листе", "ТитульныйЛист", "П_ИНН", Титульный.UID));
	ИначеЕсли Не РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(Титульный.П_ИНН, Ложь, "") Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан ИНН на титульном листе", "ТитульныйЛист", "П_ИНН", Титульный.UID));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.ДАТА_ПОДПИСИ) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата подписи", "ТитульныйЛист", "ДАТА_ПОДПИСИ", Титульный.UID));
	КонецЕсли;
	
	Если Титульный.КОД_ПРИЧИНЫ <> "3" И (Не ЗначениеЗаполнено(Титульный.ДАТА_ПРЕКРАЩЕНИЯ_ЕНВД)) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не прекращения дата начала применения ЕНВД", "ТитульныйЛист", "ДАТА_ПРЕКРАЩЕНИЯ_ЕНВД", Титульный.UID));
	КонецЕсли;
	
	Если Титульный.КОД_ПРИЧИНЫ = "3" И ЗначениеЗаполнено(Титульный.ДАТА_ПРЕКРАЩЕНИЯ_ЕНВД) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("При подаче заявления с кодом 3 дата прекращения применения ЕНВД не указывается", "ТитульныйЛист", "ДАТА_ПРЕКРАЩЕНИЯ_ЕНВД", Титульный.UID));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.ФАМИЛИЯ_ИП) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана фамилия", "ТитульныйЛист", "ФАМИЛИЯ_ИП", Титульный.UID));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.ИМЯ_ИП) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано имя", "ТитульныйЛист", "ИМЯ_ИП", Титульный.UID));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.КОД_ПРИЧИНЫ) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан код причины снятия с учета", "ТитульныйЛист", "КОД_ПРИЧИНЫ", Титульный.UID));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.КОД_НО) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан налоговый орган", "ТитульныйЛист", "КОД_НО", Титульный.UID));
	КонецЕсли;
	
	Заполнено = Ложь;
	Для Каждого ДопЛист Из Данные.Лист2 Цикл
		Для Инд = 1 По 3 Цикл 
			Если ЗначениеЗаполнено(ДопЛист["КОД_ВИДА_ДЕЯТЕЛЬНОСТИ" + Инд])
				И (Не ЗначениеЗаполнено(ДопЛист["РЕГИОН" + Инд])) Тогда
				
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан адрес", "Лист2", "РЕГИОН" + Инд, ДопЛист.UID));
			КонецЕсли;
				
			Если ЗначениеЗаполнено(ДопЛист["КОД_ВИДА_ДЕЯТЕЛЬНОСТИ" + Инд])
				Или ЗначениеЗаполнено(ДопЛист["РЕГИОН" + Инд]) Тогда
					Заполнено = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Если Титульный.КОД_ПРИЧИНЫ = "4" И Не Заполнено Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнены адреса/виды деятельности", "Лист2", "РЕГИОН1", Данные.Лист2[0].UID));
	КонецЕсли;
	
	Возврат ТаблицаОшибок;
КонецФункции

#КонецОбласти
#КонецЕсли
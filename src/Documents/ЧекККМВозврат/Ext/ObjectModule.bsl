﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура заполнения документа на основании расходного кассового ордера.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа
//	
Процедура ЗаполнитьПоЧекуККМ(ДанныеЗаполнения) Экспорт
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("ДокументСсылка.ЧекККМ") Тогда
		
		ВызватьИсключение НСтр("ru = 'Чеки ККМ на возврат должны вводиться на основании чеков ККМ'");
		
	КонецЕсли;
	
	// Заполним данные шапки документа.
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЧекККМ.ВалютаДокумента КАК ВалютаДокумента,
	|	ЧекККМ.Ссылка КАК ЧекККМ,
	|	ЧекККМ.ВидЦен КАК ВидЦен,
	|	ЧекККМ.ВидСкидкиНаценки КАК ВидСкидкиНаценки,
	|	ЧекККМ.Организация КАК Организация,
	|	ЧекККМ.НалогообложениеНДС КАК НалогообложениеНДС,
	|	ЧекККМ.КассаККМ КАК КассаККМ,
	|	ЧекККМ.КассоваяСмена КАК КассоваяСмена,
	|	ЧекККМ.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ЧекККМ.Ячейка КАК Ячейка,
	|	ЧекККМ.Подразделение КАК Подразделение,
	|	ЧекККМ.Ответственный КАК Ответственный,
	|	ЧекККМ.Организация.ПодписьРуководителя КАК ПодписьРуководителя,
	|	ЧекККМ.ПодписьКассира КАК ПодписьКассира,
	|	ЧекККМ.КонтактноеЛицоПодписант КАК КонтактноеЛицоПодписант,
	|	ЧекККМ.СуммаДокумента КАК СуммаДокумента,
	|	ЧекККМ.СуммаВключаетНДС КАК СуммаВключаетНДС,
	|	ЧекККМ.НДСВключатьВСтоимость КАК НДСВключатьВСтоимость,
	|	ЧекККМ.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	ЧекККМ.ДисконтнаяКарта КАК ДисконтнаяКарта,
	|	ЧекККМ.ПроцентСкидкиПоДисконтнойКарте КАК ПроцентСкидкиПоДисконтнойКарте,
	|	ЧекККМ.СпециальныйНалоговыйРежим КАК СпециальныйНалоговыйРежим,
	|	ЧекККМ.Запасы.(
	|		Номенклатура КАК Номенклатура,
	|		Характеристика КАК Характеристика,
	|		Партия КАК Партия,
	|		Количество КАК Количество,
	|		ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		Цена КАК Цена,
	|		ПроцентСкидкиНаценки КАК ПроцентСкидкиНаценки,
	|		СуммаСкидкиНаценки КАК СуммаСкидкиНаценки,
	|		Сумма КАК Сумма,
	|		СтавкаНДС КАК СтавкаНДС,
	|		СуммаНДС КАК СуммаНДС,
	|		Всего КАК Всего,
	|		ПроцентАвтоматическойСкидки КАК ПроцентАвтоматическойСкидки,
	|		СуммаАвтоматическойСкидки КАК СуммаАвтоматическойСкидки,
	|		КлючСвязи КАК КлючСвязи,
	|		Заказ КАК Заказ,
	|		СерииНоменклатуры КАК СерииНоменклатуры,
	|		НоменклатураНабора КАК НоменклатураНабора,
	|		ХарактеристикаНабора КАК ХарактеристикаНабора,
	|		ДоляСтоимости КАК ДоляСтоимости,
	|		НеобходимостьВводаАкцизнойМарки КАК НеобходимостьВводаАкцизнойМарки,
	|		НоменклатураЕГАИС КАК НоменклатураЕГАИС,
	|		Штрихкод КАК Штрихкод,
	|		СуммаСкидкиОплатыБонусом КАК СуммаСкидкиОплатыБонусом,
	|		КодМаркировки КАК КодМаркировки,
	|		СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|		Ячейка КАК Ячейка,
	|		ДоговорПлатежногоАгента КАК ДоговорПлатежногоАгента,
	|		МРЦ КАК МРЦ
	|	) КАК Запасы,
	|	ЧекККМ.ДобавленныеНаборы.(
	|		НоменклатураНабора КАК НоменклатураНабора,
	|		ХарактеристикаНабора КАК ХарактеристикаНабора,
	|		Количество КАК Количество
	|	) КАК ДобавленныеНаборы,
	|	ЧекККМ.БезналичнаяОплата.(
	|		ВидПлатежнойКарты КАК ВидПлатежнойКарты,
	|		НомерПлатежнойКарты КАК НомерПлатежнойКарты,
	|		Сумма КАК Сумма,
	|		СсылочныйНомер КАК СсылочныйНомер,
	|		НомерЧекаЭТ КАК НомерЧекаЭТ,
	|		ВидОплаты КАК ВидОплаты,
	|		ПодарочныйСертификат КАК ПодарочныйСертификат,
	|		НомерСертификата КАК НомерСертификата,
	|		ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|		БонуснаяКарта КАК БонуснаяКарта,
	|		СуммаБонусов КАК СуммаБонусов
	|	) КАК БезналичнаяОплата,
	|	ЧекККМ.НомерЧекаККМ КАК НомерЧекаККМ,
	|	ЧекККМ.Проведен КАК Проведен,
	|	ЧекККМ.СкидкиНаценки.(
	|		Ссылка КАК Ссылка,
	|		НомерСтроки КАК НомерСтроки,
	|		КлючСвязи КАК КлючСвязи,
	|		СкидкаНаценка КАК СкидкаНаценка,
	|		Сумма КАК Сумма
	|	) КАК СкидкиНаценки,
	|	ЧекККМ.СкидкиРассчитаны КАК СкидкиРассчитаны,
	|	ЧекККМ.АкцизныеМарки.(
	|		Ссылка КАК Ссылка,
	|		НомерСтроки КАК НомерСтроки,
	|		КлючСвязи КАК КлючСвязи,
	|		КодАкцизнойМарки КАК КодАкцизнойМарки,
	|		АкцизнаяМарка КАК АкцизнаяМарка,
	|		Справка2 КАК Справка2,
	|		ШтрихкодУпаковки КАК ШтрихкодУпаковки
	|	) КАК АкцизныеМарки,
	|	ЧекККМ.ПоложениеЗаказаПокупателя КАК ПоложениеЗаказаПокупателя,
	|	ЧекККМ.Заказ КАК Заказ,
	|	ЧекККМ.Контрагент КАК Контрагент,
	|	ЧекККМ.БонусныеБаллыКНачислению.(
	|		Ссылка КАК Ссылка,
	|		НомерСтроки КАК НомерСтроки,
	|		КлючСвязи КАК КлючСвязи,
	|		СкидкаНаценка КАК СкидкаНаценка,
	|		ДатаНачисления КАК ДатаНачисления,
	|		ДатаСписания КАК ДатаСписания,
	|		КоличествоБонусныхБаллов КАК КоличествоБонусныхБаллов
	|	) КАК БонусныеБаллыКНачислению,
	|	ЧекККМ.Договор КАК Договор,
	|	ЧекККМ.СпособЗачетаПредоплаты КАК СпособЗачетаПредоплаты,
	|	ЧекККМ.Кратность КАК Кратность,
	|	ЧекККМ.Курс КАК Курс,
	|	ЧекККМ.ОперацияСДенежнымиСредствами КАК ОперацияСДенежнымиСредствами,
	|	ЧекККМ.Предоплата.(
	|		Ссылка КАК Ссылка,
	|		НомерСтроки КАК НомерСтроки,
	|		Документ КАК Документ,
	|		Заказ КАК Заказ,
	|		СуммаРасчетов КАК СуммаРасчетов,
	|		Курс КАК Курс,
	|		Кратность КАК Кратность,
	|		СуммаПлатежа КАК СуммаПлатежа
	|	) КАК Предоплата,
	|	ЧекККМ.ПоложениеСклада КАК ПоложениеСклада
	|ИЗ
	|	Документ.ЧекККМ КАК ЧекККМ
	|ГДЕ
	|	ЧекККМ.Ссылка = &Ссылка";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка, ,"НомерЧекаККМ, Проведен, КассоваяСмена");
	
	ТекстОшибки = "";
	
	Если НЕ Выборка.Проведен Тогда
		
		ТекстОшибки = НСтр("ru='Чек ККМ не проведен. Ввод на основании невозможен'");
		
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Выборка.НомерЧекаККМ) Тогда
		
		ТекстОшибки = НСтр("ru='Чек ККМ не пробит. Ввод на основании невозможен'");
	
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
	Если РозничныеПродажиСервер.СменаОткрыта(Выборка.КассоваяСмена, ТекущаяДата(), ТекстОшибки) Тогда
		
		КассоваяСмена = Выборка.КассоваяСмена;
		
	Иначе
		
		СостояниеКассовойСмены = РозничныеПродажиСервер.ПолучитьСостояниеКассовойСмены(Выборка.КассаККМ);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеКассовойСмены,, "Ответственный");
		КассоваяСмена = СостояниеКассовойСмены.ОтчетОРозничныхПродажах;
		
	КонецЕсли;
	
	Запасы.Загрузить(Выборка.Запасы.Выгрузить());
	ДобавленныеНаборы.Загрузить(Выборка.ДобавленныеНаборы.Выгрузить());
	БезналичнаяОплата.Загрузить(Выборка.БезналичнаяОплата.Выгрузить());
	ЗаполнитьКомиссиюЭквайрера();
	БонусныеБаллыКНачислению.Загрузить(Выборка.БонусныеБаллыКНачислению.Выгрузить());
	Предоплата.Загрузить(Выборка.Предоплата.Выгрузить());
	
	УдалитьОдноразовыеСертификаты(БезналичнаяОплата);
	УдалитьОплатуБонусами(БезналичнаяОплата);
	
	СерииНоменклатурыУНФ.ЗаполнитьТЧСерииНоменклатурыПоКлючуСвязи(ЭтотОбъект, ДанныеЗаполнения);
	
	// АвтоматическиеСкидки
	Если ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиНаценки") Тогда
		СкидкиНаценки.Загрузить(Выборка.СкидкиНаценки.Выгрузить());
	КонецЕсли;
	// Конец АвтоматическиеСкидки
	
	АкцизныеМарки.Загрузить(Выборка.АкцизныеМарки.Выгрузить());
	
	// Отмена ЕНВД
	Если ТекущаяДатаСеанса() >= УправлениеНебольшойФирмойСервер.ДатаОтменыЕНВД()
		И СпециальныйНалоговыйРежим = Перечисления.СпециальныеНалоговыеРежимы.ЕНВД Тогда
		СпециальныйНалоговыйРежим = НалогиУНФ.СпециальныйНалоговыйРежим(Организация, СтруктурнаяЕдиница, ТекущаяДатаСеанса());
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьПоРасходномуКассовомуОрдеру()

// Добавляет дополнительные реквизиты, необходимые для проведения документа в
// переданную структуру.
//
// Параметры:
//  СтруктураДополнительныеСвойства - Структура дополнительных свойств документа.
//
Процедура ДобавитьРеквизитыВДополнительныеСвойстваДляПроведения(СтруктураДополнительныеСвойства)
	
	Если КассаККМ.ТипКассы = Перечисления.ТипыКассККМ.АвтономнаяККМ Тогда
		Если ПодключаемоеОборудованиеУНФ.ЕстьККТСАвтоматическойФискализацией(Организация) Тогда
			СтруктураДополнительныеСвойства.ДляПроведения.Вставить("ЧекПробит", ЗначениеЗаполнено(НомерЧекаККМ));
		Иначе
			СтруктураДополнительныеСвойства.ДляПроведения.Вставить("ЧекПробит", Истина);
		КонецЕсли;    
	Иначе
		СтруктураДополнительныеСвойства.ДляПроведения.Вставить("ЧекПробит", ЗначениеЗаполнено(НомерЧекаККМ));
	КонецЕсли;
	
	СтруктураДополнительныеСвойства.ДляПроведения.Вставить("Архивный", Архивный);
	СтруктураДополнительныеСвойства.ДляПроведения.Вставить("ДвиженияПоЗапасамУдалять", ДвиженияПоЗапасамУдалять);
	СтруктураДополнительныеСвойства.ДляПроведения.Вставить("ОперацияСДенежнымиСредствами", ОперацияСДенежнымиСредствами);
	СтруктураДополнительныеСвойства.ДляПроведения.Вставить(
		"КомиссияОбработана",
		УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеКонстанты("ОбработкаКомиссииЗавершена"));
	
КонецПроцедуры // ДобавитьРеквизитыВДополнительныеСвойстваДляПроведения()

Процедура УдалитьОдноразовыеСертификаты(ТабличнаяЧасть)
	
	Для Индекс = 1 - ТабличнаяЧасть.Количество() По 0 Цикл
		Строка = ТабличнаяЧасть.Получить(-Индекс);
		Если Строка.ВидОплаты = Перечисления.ВидыБезналичныхОплат.ПодарочныйСертификат Тогда
			Если ЗначениеЗаполнено(Строка.ПодарочныйСертификат) Тогда
				Если Не Строка.ПодарочныйСертификат.ЧастичноеПогашение Тогда
					ТабличнаяЧасть.Удалить(Строка);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура УдалитьОплатуБонусами(ТабличнаяЧасть)
	
	Для Индекс = 1 - ТабличнаяЧасть.Количество() По 0 Цикл
		Строка = ТабличнаяЧасть.Получить(-Индекс);
		Если Строка.ВидОплаты = Перечисления.ВидыБезналичныхОплат.Бонусы Тогда
			Если ЗначениеЗаполнено(Строка.БонуснаяКарта) Тогда
				РеквизитыБонуснойПрограммы = РаботаСБонусами.РеквизитыБонуснойПрограммы(Строка.БонуснаяКарта);
				Если Не РеквизитыБонуснойПрограммы.НачислятьБонусыПриВозврате Тогда
					ТабличнаяЧасть.Удалить(Строка);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура АссистентУправленияПриСрабатыванииСобытия()
	
	Если Не ДополнительныеСвойства.ДляПроведения.ЧекПробит Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДисконтнаяКарта) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСообщения = Новый Структура;
	ПараметрыСообщения.Вставить("Начислено", -БонусныеБаллыКНачислению.Итог("КоличествоБонусныхБаллов"));
	ПараметрыСообщения.Вставить("Списано", -БезналичнаяОплата.Итог("СуммаБонусов"));
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПараметрыСообщения", ПараметрыСообщения);
	
	ЕстьНачисление = ДополнительныеПараметры.ПараметрыСообщения.Начислено <> 0;
	ЕстьСписание = ДополнительныеПараметры.ПараметрыСообщения.Списано <> 0;
	
	Событие = Неопределено;
	Если ЕстьНачисление И ЕстьСписание Тогда
		Событие = "СписаниеНачислениеБонусовПриПродаже";
	ИначеЕсли ЕстьНачисление Тогда
		Событие = "НачислениеБонусовПриПродаже";
	ИначеЕсли ЕстьСписание Тогда
		Событие = "СписаниеБонусовПриПродаже";
	КонецЕсли;
	
	Если Событие = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	АссистентУправления.ПриСрабатыванииСобытия(ДисконтнаяКарта, Событие, Ссылка, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ЗаполнитьКомиссиюЭквайрера()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЧекККМБезналичнаяОплата.НомерСтроки КАК НомерСтроки,
	|	ЧекККМБезналичнаяОплата.Сумма * ВЫБОР
	|		КОГДА &ЭтоОтмена
	|			ТОГДА ЭквайринговыеТерминалыВидыПлатежныхКарт.ПроцентКомиссииПриОтмене / 100
	|		ИНАЧЕ ЭквайринговыеТерминалыВидыПлатежныхКарт.ПроцентКомиссииПриВозврате / 100
	|	КОНЕЦ КАК СуммаКомиссии
	|ИЗ
	|	Документ.ЧекККМ.БезналичнаяОплата КАК ЧекККМБезналичнаяОплата
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЭквайринговыеТерминалы.ВидыПлатежныхКарт КАК ЭквайринговыеТерминалыВидыПлатежныхКарт
	|		ПО ЧекККМБезналичнаяОплата.ЭквайринговыйТерминал = ЭквайринговыеТерминалыВидыПлатежныхКарт.Ссылка
	|			И ЧекККМБезналичнаяОплата.ВидПлатежнойКарты = ЭквайринговыеТерминалыВидыПлатежныхКарт.ВидПлатежнойКарты
	|ГДЕ
	|	ЧекККМБезналичнаяОплата.Ссылка = &Ссылка
	|	И ЧекККМБезналичнаяОплата.ВидОплаты = ЗНАЧЕНИЕ(Перечисление.ВидыБезналичныхОплат.БанковскаяКарта)");
	Запрос.УстановитьПараметр("Ссылка", ЧекККМ);
	Запрос.УстановитьПараметр("ЭтоОтмена", КассоваяСмена = ЧекККМ.КассоваяСмена);
	ТаблицаСумм = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаОплаты Из БезналичнаяОплата Цикл
		
		Если СтрокаОплаты.ВидОплаты <> Перечисления.ВидыБезналичныхОплат.БанковскаяКарта Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаКомиссии = ТаблицаСумм.Найти(СтрокаОплаты.НомерСтроки, "НомерСтроки");
		Если СтрокаКомиссии = Неопределено Тогда
			СтрокаОплаты.СуммаКомиссии = 0;
		Иначе
			СтрокаОплаты.СуммаКомиссии = СтрокаКомиссии.СуммаКомиссии;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события "При копировании".
//
Процедура ПриКопировании(ОбъектКопирования)
	
	ВызватьИсключение НСтр("ru = 'Чек на возврат вводится только на основании'");
	
КонецПроцедуры // ПриКопировании()

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, "ЗаполнитьПоЧекуККМ", "Контрагент");
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события "Обработка проверки заполнения".
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ КассаККМ.ТипКассы = Перечисления.ТипыКассККМ.АвтономнаяККМ Тогда   
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЧекККМ.КассоваяСмена КАК КассоваяСмена,
		|	ЧекККМ.Дата КАК Дата,
		|	ЧекККМ.Проведен КАК Проведен,
		|	ЧекККМ.НомерЧекаККМ КАК НомерЧекаККМ
		|ИЗ
		|	Документ.ЧекККМ КАК ЧекККМ
		|ГДЕ
		|	ЧекККМ.Ссылка = &ЧекККМ";
		
		Запрос.УстановитьПараметр("ЧекККМ", ЧекККМ);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Если Не Выборка.Проведен Тогда
				ТекстСообщения = НСтр("ru='Чек ККМ не проведен.'");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ЧекККМ", , Отказ);
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Выборка.НомерЧекаККМ) Тогда
				ТекстСообщения = НСтр("ru='Чек ККМ продажи не пробит.'");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ЧекККМ", , Отказ);
			КонецЕсли;
			
			ТекстСообщения = НСтр("ru = 'Кассовая смена не открыта.'");
			Если Не РозничныеПродажиСервер.СменаОткрыта(КассоваяСмена, Дата, ТекстСообщения) Тогда
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "КассоваяСмена", , Отказ);
			КонецЕсли;
		КонецЦикла;
	Иначе     
		
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "КассоваяСмена");
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ЧекККМ");
	КонецЕсли;
	
	// Скидка 100%.
	ЕстьРучныеСкидки = ПолучитьФункциональнуюОпцию("ИспользоватьРучныеСкидкиНаценкиПродажи");
	ЕстьАвтоматическиеСкидки = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиНаценки"); // АвтоматическиеСкидки
	Если ЕстьРучныеСкидки ИЛИ ЕстьАвтоматическиеСкидки Тогда
		Для каждого СтрокаЗапасы Из Запасы Цикл
			// АвтоматическиеСкидки
			ТекСумма = Окр(СтрокаЗапасы.Цена * СтрокаЗапасы.Количество, 2);
			ТекСуммаРучнойСкидки = ?(ЕстьРучныеСкидки, СтрокаЗапасы.СуммаСкидкиНаценки, 0);
			ТекСуммаАвтоматическойСкидки = ?(ЕстьАвтоматическиеСкидки, СтрокаЗапасы.СуммаАвтоматическойСкидки, 0);
			ТекСуммаСкидки = ТекСуммаРучнойСкидки + ТекСуммаАвтоматическойСкидки;
			Если СтрокаЗапасы.ПроцентСкидкиНаценки <> 100 И ТекСуммаСкидки < ТекСумма
				И НЕ ЗначениеЗаполнено(СтрокаЗапасы.Сумма) Тогда
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Не заполнена колонка ""Сумма"" в строке %1 списка ""Запасы"".'"),
					СтрокаЗапасы.НомерСтроки);
				КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Запасы", СтрокаЗапасы.НомерСтроки,
					"Сумма");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Серии номенклатуры
	Если Не ОперацияСДенежнымиСредствами Тогда
		СерииНоменклатурыУНФ.ПроверкаЗаполненияСерийНоменклатуры(Отказ, Запасы, СерииНоменклатуры, СтруктурнаяЕдиница, ЭтотОбъект);
	КонецЕсли;
	
	// Наборы
	НаборыСервер.ПроверитьТабличнуюЧасть(ЭтотОбъект, "Запасы", Отказ);
	// КонецНаборы
	
	// ПодарочныеCертификаты
	Если Константы.ФункциональнаяОпцияИспользоватьПодарочныеСертификаты.Получить() Тогда
		
		Если Не РаботаСПодарочнымиСертификатами.УказанКонтрагентДляПредоплаты() Тогда
			ТекстСообщения = НСтр("ru = 'Не заполнена константа ""Служебный контрагент для подарочных сертификатов"".
								  |Необходимо указать контрагента: Продажи - Еще больше возможностей.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, , , Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	РаботаСПодарочнымиСертификатами.ПроверитьСрокДействия(ЭтотОбъект, "Запасы", Отказ);
	// Конец ПодарочныеСертификаты
	
	// Контроль сумм в табличных частях
	Если ОперацияСДенежнымиСредствами Тогда
		СуммаДляКонтроля = СуммаДокумента;
	Иначе
		СуммаДляКонтроля = Запасы.Итог("Всего");
	КонецЕсли;
	Если СуммаДляКонтроля < БезналичнаяОплата.Итог("Сумма") Тогда
		ТекстСообщения = НСтр("ru = 'Сумма безналичной оплаты больше суммы документа.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, , , Отказ);
	КонецЕсли;
	// Конец Контроль сумм в табличных частях
	
	// Бонусы
	Если ПолучитьФункциональнуюОпцию("ИспользоватьБонусныеПрограммы") Тогда
		Если Не БезналичнаяОплата.Найти(Перечисления.ВидыБезналичныхОплат.Бонусы, "ВидОплаты") = Неопределено Тогда
			
			ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("БезналичнаяОплата.Сумма"));
			
			Для Каждого СтрокаОплаты Из БезналичнаяОплата Цикл
				
				Если СтрокаОплаты.ВидОплаты = Перечисления.ВидыБезналичныхОплат.Бонусы Тогда
					Если Не ЗначениеЗаполнено(СтрокаОплаты.СуммаБонусов) Тогда
						ТекстСообщения = СтрШаблон(НСтр("ru = 'В строке №%1 не указана сумма оплаты.'"),
							СтрокаОплаты.НомерСтроки);
						КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("БезналичнаяОплата",
							СтрокаОплаты.НомерСтроки, "СуммаБонусов");
						ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
					КонецЕсли;
				Иначе
					Если Не ЗначениеЗаполнено(СтрокаОплаты.Сумма) Тогда
						ТекстСообщения = СтрШаблон(НСтр("ru = 'В строке №%1 не указана сумма оплаты.'"),
							СтрокаОплаты.НомерСтроки);
						КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("БезналичнаяОплата",
							СтрокаОплаты.НомерСтроки, "Сумма");
						ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
					КонецЕсли;
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
	КонецЕсли;
	// Конец Бонусы
	
	Если Не ОперацияСДенежнымиСредствами Тогда
		Если Предоплата.Количество() = 0 Тогда
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Курс");
			ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Кратность");
		КонецЕсли;
	КонецЕсли;
	
	// ИнтеграцияГосИС
	Если ИнтеграцияИСМПВызовСервера.ВестиУчетМаркируемойПродукции(Перечисления.ВидыПродукцииИС.Обувь)
		И КассаККМ.ТипКассы <> Перечисления.ТипыКассККМ.ККМED Тогда
		ИнтеграцияИСУНФ.ПроверитьЗаполнениеАкцизныхМарок(ЭтотОбъект, Отказ);
	КонецЕсли;
	// Конец ИнтеграцияГосИС   
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НомерЧекаККМ)
	   И РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения
	   И НЕ КассаККМ.ИспользоватьБезПодключенияОборудования Тогда
		
		Отказ = Истина;
		
		ТекстОшибки = НСтр("ru='Чек ККМ на возврат пробит на фискальном регистраторе. Отмена проведения невозможна'");
		
		ОбщегоНазначения.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект);
			
		Возврат;
		
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения
	   И КассаККМ.ИспользоватьБезПодключенияОборудования
	   И КассоваяСмена.Проведен
	   И КассоваяСмена.СтатусКассовойСмены = Перечисления.СтатусыОтчетаОРозничныхПродажах.Закрыта Тогда
		
		ТекстСообщения = НСтр("ru='Кассовая смена закрыта. Отмена проведения невозможна.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, , , Отказ);
		Возврат;
		
	КонецЕсли;
	
	// Заказы покупателей в розничной торговле
	Если ПоложениеЗаказаПокупателя <> Перечисления.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти Тогда
		ЕстьЗаказы = НЕ Заказ.Пустая();
		Для каждого СтрокаТабличнойЧасти Из Запасы Цикл
			СтрокаТабличнойЧасти.Заказ = ?(ЗначениеЗаполнено(Заказ), Заказ, Неопределено);
		КонецЦикла;
	Иначе
		ЕстьЗаказы = Ложь;
		Заказ = ЗаполнениеОбъектовУНФ.ЗначениеДляШапки(Запасы, "Заказ");
	КонецЕсли;
	
	Если НЕ ЕстьЗаказы Тогда
		Для каждого СтрокаТабличнойЧасти Из Запасы Цикл
			Если НЕ СтрокаТабличнойЧасти.Заказ.Пустая() Тогда
				ЕстьЗаказы = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	// Конец Заказы покупателей в розничной торговле
	
	// Заполнение безналичной оплаты для старых документов
	Если БезналичнаяОплата.Количество() > 0 Тогда
		РаботаСПодарочнымиСертификатами.ПроверитьЗаполнитьБезналичнуюОплатуДокумента(ЭтотОбъект);
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	// До включения автоматических скидок будем считать, что скидки рассчитаны.
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиНаценки") Тогда
		СкидкиРассчитаны = Истина;
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	// Взаиморасчеты
	РасчетыПроведениеДокументов.ИнициализироватьДополнительныеСвойстваДляПроведения(ЭтотОбъект, ДополнительныеСвойства, Отказ, Ложь);
	
	ДобавитьРеквизитыВДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ЧекККМВозврат.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ПроведениеДокументовУНФ.ОтразитьДвижения("Запасы", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ЗапасыНаСкладах", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДенежныеСредстваВКассахККМ", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДоходыИРасходы", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДоходыИРасходыКассовыйМетод", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДоходыИРасходыНераспределенные", ТаблицыДляДвижений, Движения, Отказ);
	
	ПроведениеДокументовУНФ.ОтразитьДвижения("Продажи", ТаблицыДляДвижений, Движения, Отказ);
	
	// ДисконтныеКарты
	ПроведениеДокументовУНФ.ОтразитьДвижения("ПродажиПоДисконтнымКартам", ТаблицыДляДвижений, Движения, Отказ);
	// АвтоматическиеСкидки
	ПроведениеДокументовУНФ.ОтразитьДвижения("ПредоставленныеСкидки", ТаблицыДляДвижений, Движения, Отказ);
	// Эквайринг
	ПроведениеДокументовУНФ.ОтразитьДвижения("ОплатаПлатежнымиКартами", ТаблицыДляДвижений, Движения, Отказ);
	// Заказы покупателей в розничной торговле
	ПроведениеДокументовУНФ.ОтразитьДвижения("ЗаказыПокупателей", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ПлатежныйКалендарь", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ОплатаСчетовИЗаказов", ТаблицыДляДвижений, Движения, Отказ);
	
	ПроведениеДокументовУНФ.ОтразитьУправленческий(ДополнительныеСвойства, Движения, Отказ);
	
	// СерииНоменклатуры
	ПроведениеДокументовУНФ.ОтразитьДвижения("СерииНоменклатурыГарантии", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДвиженияСерииНоменклатуры", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("СерииНоменклатуры", ТаблицыДляДвижений, Движения, Отказ);
	
	// Подарочные сертификаты
	ПроведениеДокументовУНФ.ОтразитьДвижения("ПодарочныеСертификаты", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ОплатаПодарочнымиСертификатами", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("РасчетыСПокупателями", ТаблицыДляДвижений, Движения, Отказ);
	
	// Бонусы
	ПроведениеДокументовУНФ.ОтразитьДвижения("БонусныеБаллы", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("НачисленияБонусныхБаллов", ТаблицыДляДвижений, Движения, Отказ);
	
	АссистентУправленияПриСрабатыванииСобытия();
	
	// Акцизные марки
	ПроведениеДокументовУНФ.ОтразитьДвижения("ОстаткиАлкогольнойПродукцииЕГАИС", ТаблицыДляДвижений, Движения, Отказ);
	
	// Запись наборов записей.
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Если КассаККМ.ТипКассы <> Перечисления.ТипыКассККМ.ККМED Тогда
		Документы.ЧекККМВозврат.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события "ОбработкаУдаленияПроведения".
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Если КассаККМ.ТипКассы <> Перечисления.ТипыКассККМ.ККМED Тогда
		Документы.ЧекККМВозврат.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	КонецЕсли;
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
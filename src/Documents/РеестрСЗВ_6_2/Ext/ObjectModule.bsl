﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Проверка заполнения документа
// 
// Параметры:
// 	ПроверяемыеРеквизиты - Строка - .
// 	НеПроверяемыеРеквизиты - Строка - .
// 	Отказ - Булево - .
Процедура ПроверкаЗаполненияДокумента(ПроверяемыеРеквизиты, НеПроверяемыеРеквизиты, Отказ) Экспорт

	ОкончаниеПериода = УчетСтраховыхВзносов.ОкончаниеОтчетногоПериодаПерсУчета(?(ТипСведенийСЗВ
		= Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ, ОтчетныйПериод, КорректируемыйПериод));

	ВыборкаЗаписиОСтаже = СформироватьЗапросПоСтажуДляПроверкиЗаполнения().Выбрать();

	Если ЗаписиОСтаже.Количество() > 200 Тогда
		ТекстОшибки = НСтр("ru = 'В документе должно быть не более 200 сотрудников'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, , , Отказ);
	КонецЕсли;

	Пока ВыборкаЗаписиОСтаже.СледующийПоЗначениюПоля("НомерСтрокиСотрудник") Цикл

		Если ЗначениеЗаполнено(ВыборкаЗаписиОСтаже.Сотрудник) Тогда
			Если ВыборкаЗаписиОСтаже.КонфликтующаяСтрока <> Null Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
					"ru = 'Информация о сотруднике %2 была введена в документе ранее'"),
					ВыборкаЗаписиОСтаже.НомерСтрокиСотрудник, ВыборкаЗаписиОСтаже.СотрудникНаименование);
				СообщитьОбОшибкеВСтроке(ТекстОшибки, "Сотрудник", ВыборкаЗаписиОСтаже.НомерСтрокиСотрудник, Отказ);
			ИначеЕсли ВыборкаЗаписиОСтаже.КонфликтующаяСтрокаСтраховойНомер <> Null Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
					"ru = 'Сотрудник %2: информация о сотруднике с таким же страховым номером была введена в документе ранее'"),
					ВыборкаЗаписиОСтаже.НомерСтрокиСотрудник, ВыборкаЗаписиОСтаже.СотрудникНаименование);
				СообщитьОбОшибкеВСтроке(ТекстОшибки, "Сотрудник", ВыборкаЗаписиОСтаже.НомерСтрокиСотрудник, Отказ);
			КонецЕсли;

			НомерСтроки = 0;

			Если ЗначениеЗаполнено(ВыборкаЗаписиОСтаже.НомерСтрокиСтаж) Тогда

				Пока ВыборкаЗаписиОСтаже.СледующийПоЗначениюПоля("НомерСтрокиСтаж") Цикл

					НомерСтроки = НомерСтроки + 1;
					
					// ПРОВЕРКА КОРРЕКТНОГО ЗАПОЛНЕНИЯ ДАТ НАЧАЛА И ОКОНЧАНИЯ ПЕРИОДА

					// Проверка заполнения реквизитов "ДатаНачалаПериода" и "ДатаОкончанияПериода" 
					Если ЗначениеЗаполнено(ВыборкаЗаписиОСтаже.ДатаНачалаПериода) И ЗначениеЗаполнено(
						ВыборкаЗаписиОСтаже.ДатаОкончанияПериода) Тогда
									
						// Дата начала периода не должна быть ранее начала периода
						Если ВыборкаЗаписиОСтаже.ДатаНачалаПериода < ?(ТипСведенийСЗВ
							= Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ, ОтчетныйПериод, КорректируемыйПериод) Тогда
							ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
								"ru = 'Сотрудник %2: дата начала периода должна быть не ранее начала периода'"),
								НомерСтроки, ВыборкаЗаписиОСтаже.СотрудникНаименование);
							СообщитьОбОшибкеВСтроке(ТекстОшибки, "ПериодыСтажаСтрока",
								ВыборкаЗаписиОСтаже.НомерСтрокиСотрудник, Отказ);

						КонецЕсли;
						
						// Дата окончания периода не должна быть позднее окончания периода
						Если ВыборкаЗаписиОСтаже.ДатаОкончанияПериода > ОкончаниеПериода Тогда
							ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
								"ru = 'Сотрудник %2: дата окончания периода должна быть не позднее окончания периода'"),
								НомерСтроки, ВыборкаЗаписиОСтаже.СотрудникНаименование);
							СообщитьОбОшибкеВСтроке(ТекстОшибки, "ПериодыСтажаСтрока",
								ВыборкаЗаписиОСтаже.НомерСтрокиСотрудник, Отказ);
						КонецЕсли;	 
						
						// Начало периода не должно быть позже окончания периода 
						Если ВыборкаЗаписиОСтаже.ДатаНачалаПериода > ВыборкаЗаписиОСтаже.ДатаОкончанияПериода Тогда
							ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
								"ru = 'Сотрудник %2: дата начала периода не должна превышать дату окончания периода'"),
								НомерСтроки, ВыборкаЗаписиОСтаже.СотрудникНаименование);
							СообщитьОбОшибкеВСтроке(ТекстОшибки, "ПериодыСтажаСтрока",
								ВыборкаЗаписиОСтаже.НомерСтрокиСотрудник, Отказ);
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьЗапросПоСтажуДляПроверкиЗаполнения()
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТаблицаЗаписиОСтаже", ЗаписиОСтаже);
	Запрос.УстановитьПараметр("ТаблицаСотрудники", Сотрудники);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТаблицаСотрудники.НомерСтроки,
	               |	ТаблицаСотрудники.Сотрудник,
				   |	ТаблицаСотрудники.Фамилия,
				   |	ТаблицаСотрудники.Имя,
	               |	ТаблицаСотрудники.АдресДляИнформирования,
	               |	ТаблицаСотрудники.СтраховойНомерПФР
	               |ПОМЕСТИТЬ ВТСотрудники
	               |ИЗ
	               |	&ТаблицаСотрудники КАК ТаблицаСотрудники";
				   
	Запрос.Выполнить();
	
	НачалоПериода = НачалоМесяца(ОтчетныйПериод);
	ОкончаниеПериода = УчетСтраховыхВзносов.ОкончаниеОтчетногоПериодаПерсУчета(ОтчетныйПериод);
	
	УчетСтраховыхВзносов.СформироватьТаблицуВТФизическиеЛицаРаботавшиеВОрганизации(Запрос.МенеджерВременныхТаблиц,
		Организация, НачалоПериода, ОкончаниеПериода);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	СотрудникиДокумента.НомерСтроки,
	               |	СотрудникиДокумента.Сотрудник КАК Сотрудник,
	               |	СотрудникиДокумента.Фамилия,
	               |	СотрудникиДокумента.Имя,
	               |	СотрудникиДокумента.Сотрудник.Наименование КАК СотрудникНаименование,
	               |	СотрудникиДокумента.АдресДляИнформирования,
	               |	СотрудникиДокумента.СтраховойНомерПФР,
	               |	МИНИМУМ(ДублиСтрок.НомерСтроки) КАК КонфликтующаяСтрока,
	               |	ВЫБОР
	               |		КОГДА АктуальныеСотрудники.ФизическоеЛицо ЕСТЬ NULL 
	               |			ТОГДА ЛОЖЬ
	               |		ИНАЧЕ ИСТИНА
	               |	КОНЕЦ КАК СотрудникРаботаетВОрганизации,
	               |	МИНИМУМ(ДублиСтрокСтраховыеНомера.НомерСтроки) КАК КонфликтующаяСтрокаСтраховойНомер
	               |ПОМЕСТИТЬ ВТСотрудникиДокумента
	               |ИЗ
	               |	ВТСотрудники КАК СотрудникиДокумента
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТСотрудники КАК ДублиСтрок
	               |		ПО СотрудникиДокумента.НомерСтроки > ДублиСтрок.НомерСтроки
	               |			И СотрудникиДокумента.Сотрудник = ДублиСтрок.Сотрудник
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТФизическиеЛицаРаботавшиеВОрганизации КАК АктуальныеСотрудники
	               |		ПО СотрудникиДокумента.Сотрудник = АктуальныеСотрудники.ФизическоеЛицо
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТСотрудники КАК ДублиСтрокСтраховыеНомера
	               |		ПО СотрудникиДокумента.НомерСтроки > ДублиСтрокСтраховыеНомера.НомерСтроки
	               |			И СотрудникиДокумента.СтраховойНомерПФР = ДублиСтрокСтраховыеНомера.СтраховойНомерПФР
	               |			И СотрудникиДокумента.Сотрудник <> ДублиСтрокСтраховыеНомера.Сотрудник
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	СотрудникиДокумента.НомерСтроки,
	               |	СотрудникиДокумента.Сотрудник,
	               |	СотрудникиДокумента.Фамилия,
	               |	СотрудникиДокумента.Имя,
	               |	СотрудникиДокумента.Сотрудник.Наименование,
	               |	СотрудникиДокумента.АдресДляИнформирования,
	               |	СотрудникиДокумента.СтраховойНомерПФР,
	               |	ВЫБОР
	               |		КОГДА АктуальныеСотрудники.ФизическоеЛицо ЕСТЬ NULL 
	               |			ТОГДА ЛОЖЬ
	               |		ИНАЧЕ ИСТИНА
	               |	КОНЕЦ
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	Сотрудник
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ТаблицаЗаписиОСтаже.Сотрудник,
	               |	ТаблицаЗаписиОСтаже.НомерСтроки,
	               |	ТаблицаЗаписиОСтаже.ДатаНачалаПериода,
	               |	ТаблицаЗаписиОСтаже.ДатаОкончанияПериода
	               |ПОМЕСТИТЬ ВТЗаписиОСтаже
	               |ИЗ
	               |	&ТаблицаЗаписиОСтаже КАК ТаблицаЗаписиОСтаже
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТЗаписиОСтаже.НомерСтроки КАК НомерСтроки,
	               |	ВТЗаписиОСтаже.Сотрудник,
	               |	ВТЗаписиОСтаже.ДатаНачалаПериода,
	               |	ВТЗаписиОСтаже.ДатаОкончанияПериода,
	               |	ЗНАЧЕНИЕ(Справочник.ОсобыеУсловияТрудаПФР.ПустаяСсылка) КАК ОсобыеУсловияТруда,
	               |	ЗНАЧЕНИЕ(Справочник.СпискиПрофессийДолжностейЛьготногоПенсионногоОбеспечения.ПустаяСсылка) КАК КодПозицииСписка,
	               |	ЗНАЧЕНИЕ(Справочник.ОснованияИсчисляемогоСтраховогоСтажа.ПустаяСсылка) КАК ОснованиеИсчисляемогоСтажа,
	               |	0 КАК ПервыйПараметрИсчисляемогоСтажа,
	               |	0 КАК ВторойПараметрИсчисляемогоСтажа,
	               |	ЗНАЧЕНИЕ(Справочник.ПараметрыИсчисляемогоСтраховогоСтажа.ПустаяСсылка) КАК ТретийПараметрИсчисляемогоСтажа,
	               |	ЗНАЧЕНИЕ(Справочник.ОснованияДосрочногоНазначенияПенсии.ПустаяСсылка) КАК ОснованиеВыслугиЛет,
	               |	0 КАК ПервыйПараметрВыслугиЛет,
	               |	0 КАК ВторойПараметрВыслугиЛет,
	               |	0 КАК ТретийПараметрВыслугиЛет,
	               |	ЗНАЧЕНИЕ(Справочник.ТерриториальныеУсловияПФР.ПустаяССылка) КАК ТерриториальныеУсловия,
	               |	0 КАК ПараметрТерриториальныхУсловий,
	               |	ЛОЖЬ КАК ФиксСтаж
	               |ПОМЕСТИТЬ ВТТаблицаСтажа
	               |ИЗ
	               |	ВТЗаписиОСтаже КАК ВТЗаписиОСтаже
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	ВТЗаписиОСтаже.Сотрудник
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ТаблицаСтажа.НомерСтроки КАК НомерСтрокиСтаж,
	               |	СотрудникиДокумента.НомерСтроки КАК НомерСтрокиСотрудник,
	               |	СотрудникиДокумента.Сотрудник КАК Сотрудник,
	               |	СотрудникиДокумента.СотрудникНаименование,
	               |	СотрудникиДокумента.АдресДляИнформирования,
	               |	СотрудникиДокумента.СтраховойНомерПФР,
	               |	СотрудникиДокумента.СотрудникРаботаетВОрганизации,
	               |	СотрудникиДокумента.КонфликтующаяСтрока,
	               |	СотрудникиДокумента.Фамилия,
	               |	СотрудникиДокумента.Имя,
	               |	ТаблицаСтажа.ДатаНачалаПериода,
	               |	ТаблицаСтажа.ДатаОкончанияПериода,
	               |	СотрудникиДокумента.КонфликтующаяСтрокаСтраховойНомер
	               |ИЗ
	               |	ВТСотрудникиДокумента КАК СотрудникиДокумента
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаСтажа КАК ТаблицаСтажа
	               |		ПО СотрудникиДокумента.Сотрудник = ТаблицаСтажа.Сотрудник
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НомерСтрокиСотрудник,
	               |	НомерСтрокиСтаж";
	
	Возврат Запрос.Выполнить();
  
КонецФункции	

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
КонецПроцедуры

Процедура СообщитьОбОшибкеВСтроке(ТекстСообщения, Поле, НомерСтроки, Отказ)
	ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка, СтрШаблон(
		"Объект.Сотрудники[%1].%2", Поле, XMLСтрока(НомерСтроки - 1)), , Отказ);
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
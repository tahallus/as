#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыЗаполненияДокумента

// Осуществляет проверку возможности ввода на основании.
//
Процедура ПроверитьВозможностьВводаНаОсновании(ДанныеЗаполнения, ЗначенияРеквизитов)
	
	Если ЗначенияРеквизитов.Свойство("ВидОперации") Тогда
		Если ЗначениеЗаполнено(ЗначенияРеквизитов.ВидОперации)
			И НЕ ДанныеЗаполнения.ВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаряд Тогда
				ТекстИсключения = НСтр("ru = 'Расходный ордер можно ввести только на основании заказ-наряда.'");
				ВызватьИсключение ТекстИсключения;
		КонецЕсли;
	КонецЕсли;
	
	Отказ = Ложь;
	Если ЗначенияРеквизитов.Свойство("СтруктурнаяЕдиница") Тогда
		Если ЗначениеЗаполнено(ЗначенияРеквизитов.СтруктурнаяЕдиница)
			И НЕ ЗначенияРеквизитов.СтруктурнаяЕдиница.ОрдерныйСклад Тогда
			Отказ = Истина;
		КонецЕсли;
	ИначеЕсли ЗначенияРеквизитов.Свойство("СтруктурнаяЕдиницаРезерв") Тогда
		Если ЗначениеЗаполнено(ЗначенияРеквизитов.СтруктурнаяЕдиницаРезерв)
			И НЕ ЗначенияРеквизитов.СтруктурнаяЕдиницаРезерв.ОрдерныйСклад Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Отказ Тогда
		ВызватьИсключениеВводНаОсновании(ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьВозможностьВводаНаОсновании()

Процедура ВызватьИсключениеВводНаОсновании(ДанныеЗаполнения)
	
	ТекстИсключения = НСтр("ru = 'Невозможен ввод операции ""Расход с ордерного склада"".
							|Документ ""%1"" не имеет ордерного склада.'");
	ТекстИсключения = СтрШаблон(ТекстИсключения, ДанныеЗаполнения.Ссылка);
	ВызватьИсключение ТекстИсключения;
	
КонецПроцедуры

// АПК:299-выкл процедуры вызываются см. ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент

// Обработчик заполнения на основании документа ОтчетОПереработке.
//
// Параметры:
//  ДокументСсылкаОтчетОПереработке - ДокументСсылка.ОтчетОПереработке.
//
Процедура ЗаполнитьПоОтчетОПереработке(ДокументСсылкаОтчетОПереработке) Экспорт
	
	// Заполнение шапки.
	ДокументОснование = ДокументСсылкаОтчетОПереработке;
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылкаОтчетОПереработке, Новый Структура("Организация, СтруктурнаяЕдиница, Ячейка"));
	
	ПроверитьВозможностьВводаНаОсновании(ДокументСсылкаОтчетОПереработке, ЗначенияРеквизитов);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
	
	// Заполнение табличной части.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МИНИМУМ(ОтчетОПереработке.НомерСтроки) КАК НомерСтроки,
	|	ОтчетОПереработке.Номенклатура КАК Номенклатура,
	|	ОтчетОПереработке.Характеристика КАК Характеристика,
	|	ОтчетОПереработке.Партия КАК Партия,
	|	ОтчетОПереработке.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	СУММА(ОтчетОПереработке.Количество) КАК Количество,
	|	ОтчетОПереработке.СерииНоменклатуры,
	|	ОтчетОПереработке.КлючСвязи
	|ИЗ
	|	(ВЫБРАТЬ
	|		ОтчетОПереработкеПродукция.НомерСтроки КАК НомерСтроки,
	|		ОтчетОПереработкеПродукция.Номенклатура КАК Номенклатура,
	|		ОтчетОПереработкеПродукция.Характеристика КАК Характеристика,
	|		ОтчетОПереработкеПродукция.Партия КАК Партия,
	|		ОтчетОПереработкеПродукция.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		ОтчетОПереработкеПродукция.Количество КАК Количество,
	|		ОтчетОПереработкеПродукция.СерииНоменклатуры КАК СерииНоменклатуры,
	|		ОтчетОПереработкеПродукция.КлючСвязи КАК КлючСвязи
	|	ИЗ
	|		Документ.ОтчетОПереработке.Продукция КАК ОтчетОПереработкеПродукция
	|	ГДЕ
	|		ОтчетОПереработкеПродукция.Ссылка = &ДокументОснование
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ОтчетОПереработкеОтходы.НомерСтроки,
	|		ОтчетОПереработкеОтходы.Номенклатура,
	|		ОтчетОПереработкеОтходы.Характеристика,
	|		ОтчетОПереработкеОтходы.Партия,
	|		ОтчетОПереработкеОтходы.ЕдиницаИзмерения,
	|		ОтчетОПереработкеОтходы.Количество,
	|		NULL,
	|		NULL
	|	ИЗ
	|		Документ.ОтчетОПереработке.Отходы КАК ОтчетОПереработкеОтходы
	|	ГДЕ
	|		ОтчетОПереработкеОтходы.Ссылка = &ДокументОснование) КАК ОтчетОПереработке
	|
	|СГРУППИРОВАТЬ ПО
	|	ОтчетОПереработке.Номенклатура,
	|	ОтчетОПереработке.Характеристика,
	|	ОтчетОПереработке.Партия,
	|	ОтчетОПереработке.ЕдиницаИзмерения,
	|	ОтчетОПереработке.СерииНоменклатуры,
	|	ОтчетОПереработке.КлючСвязи
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументСсылкаОтчетОПереработке);
	
	Запасы.Очистить();
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = Запасы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		КонецЦикла;
	КонецЕсли;
	
	СерииНоменклатурыУНФ.ЗаполнитьТЧСерииНоменклатурыПоКлючуСвязи(ЭтотОбъект, ДокументСсылкаОтчетОПереработке, "Продукция");
	СерииНоменклатурыУНФ.УдалитьСерииНоменклатурыВТабличнойЧастиВЗависимостиОтПолитики(ЭтотОбъект);
	
КонецПроцедуры // ЗаполнитьПоОтчетОПереработке()

// Обработчик заполнения на основании документа РасходнаяНакладная.
//
// Параметры:
//  ДокументСсылкаРасходнаяНакладная - ДокументСсылка.РасходнаяНакладная.
//
Процедура ЗаполнитьПоРасходнаяНакладная(ДокументСсылкаРасходнаяНакладная) Экспорт
	
	// Заполнение шапки.
	ДокументОснование = ДокументСсылкаРасходнаяНакладная;
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылкаРасходнаяНакладная, Новый Структура("Организация, СтруктурнаяЕдиница, Ячейка, ПоложениеСклада"));
	
	Если ЗначенияРеквизитов.ПоложениеСклада = ПредопределенноеЗначение("Перечисление.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти") Тогда
		
		ЗначенияРеквизитовСкладТЧ = ДокументСсылкаРасходнаяНакладная.Запасы.ВыгрузитьКолонку("СтруктурнаяЕдиница");
		ЗначенияОрдерныйСклад = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(ЗначенияРеквизитовСкладТЧ, "ОрдерныйСклад");
		
		ЕстьОрдерныйСклад = Ложь;
		Для каждого складТЧ Из ЗначенияОрдерныйСклад Цикл
			Если СкладТЧ.Значение = Истина Тогда
				ЕстьОрдерныйСклад = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если НЕ ЕстьОрдерныйСклад Тогда
			ВызватьИсключениеВводНаОсновании(ДокументСсылкаРасходнаяНакладная);
		КонецЕсли;
	Иначе
		ПроверитьВозможностьВводаНаОсновании(ДокументСсылкаРасходнаяНакладная, ЗначенияРеквизитов);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
	
	// Заполнение табличной части.
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	МИНИМУМ(РасходнаяНакладнаяЗапасы.НомерСтроки) КАК НомерСтроки,
	|	РасходнаяНакладнаяЗапасы.Номенклатура КАК Номенклатура,
	|	РасходнаяНакладнаяЗапасы.Характеристика КАК Характеристика,
	|	РасходнаяНакладнаяЗапасы.Партия КАК Партия,
	|	РасходнаяНакладнаяЗапасы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	РасходнаяНакладнаяЗапасы.СерииНоменклатуры КАК СерииНоменклатуры,
	|	РасходнаяНакладнаяЗапасы.КлючСвязи КАК КлючСвязи,
	|	РасходнаяНакладнаяЗапасы.Количество
	|ПОМЕСТИТЬ ВТ_РасходнаяНакладнаяЗапасы
	|ИЗ
	|	Документ.РасходнаяНакладная.Запасы КАК РасходнаяНакладнаяЗапасы
	|ГДЕ
	|	РасходнаяНакладнаяЗапасы.Ссылка = &ДокументОснование
	|	И (РасходнаяНакладнаяЗапасы.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Запас)
	|	ИЛИ
	|		РасходнаяНакладнаяЗапасы.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.ПодарочныйСертификат))
	|	И ВЫБОР
	|		КОГДА
	|			РасходнаяНакладнаяЗапасы.Ссылка.ПоложениеСклада = ЗНАЧЕНИЕ(Перечисление.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти)
	|			ТОГДА РасходнаяНакладнаяЗапасы.СтруктурнаяЕдиница.ОрдерныйСклад
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ
	|СГРУППИРОВАТЬ ПО
	|	РасходнаяНакладнаяЗапасы.Номенклатура,
	|	РасходнаяНакладнаяЗапасы.Характеристика,
	|	РасходнаяНакладнаяЗапасы.Партия,
	|	РасходнаяНакладнаяЗапасы.ЕдиницаИзмерения,
	|	РасходнаяНакладнаяЗапасы.СерииНоменклатуры,
	|	РасходнаяНакладнаяЗапасы.КлючСвязи,
	|	РасходнаяНакладнаяЗапасы.Количество
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_РасходнаяНакладнаяЗапасы.НомерСтроки,
	|	ВТ_РасходнаяНакладнаяЗапасы.Номенклатура КАК Номенклатура,
	|	ВТ_РасходнаяНакладнаяЗапасы.Характеристика,
	|	ВТ_РасходнаяНакладнаяЗапасы.Партия,
	|	ВТ_РасходнаяНакладнаяЗапасы.ЕдиницаИзмерения,
	|	ВТ_РасходнаяНакладнаяЗапасы.СерииНоменклатуры,
	|	ВТ_РасходнаяНакладнаяЗапасы.КлючСвязи,
	|	ВТ_РасходнаяНакладнаяЗапасы.Количество,
	|	ВЫБОР
	|		КОГДА ЗапасыКРасходуСоСкладовОстатки.КоличествоОстаток < 0
	|			ТОГДА -ЗапасыКРасходуСоСкладовОстатки.КоличествоОстаток
	|		ИНАЧЕ ЗапасыКРасходуСоСкладовОстатки.КоличествоОстаток
	|	КОНЕЦ КАК КоличествоОстаток
	|ИЗ
	|	ВТ_РасходнаяНакладнаяЗапасы КАК ВТ_РасходнаяНакладнаяЗапасы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗапасыКРасходуСоСкладов.Остатки(, Организация = &Организация
	|		И СтруктурнаяЕдиница = &СтруктурнаяЕдиница) КАК ЗапасыКРасходуСоСкладовОстатки
	|		ПО ВТ_РасходнаяНакладнаяЗапасы.Номенклатура = ЗапасыКРасходуСоСкладовОстатки.Номенклатура
	|		И ВТ_РасходнаяНакладнаяЗапасы.Характеристика = ЗапасыКРасходуСоСкладовОстатки.Характеристика
	|		И ВТ_РасходнаяНакладнаяЗапасы.Партия = ЗапасыКРасходуСоСкладовОстатки.Партия
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РасходнаяНакладнаяЗапасы.Номенклатура КАК Номенклатура,
	|	РасходнаяНакладнаяЗапасы.Характеристика КАК Характеристика,
	|	РасходнаяНакладнаяЗапасы.Партия КАК Партия,
	|	РасходнаяНакладнаяСерииНоменклатуры.Серия КАК Серия,
	|	РасходнаяНакладнаяЗапасы.КлючСвязи КАК КлючСвязи
	|ПОМЕСТИТЬ ВТ_РасходнаяНакладнаяСерииНоменклатуры
	|ИЗ
	|	Документ.РасходнаяНакладная.СерииНоменклатуры КАК РасходнаяНакладнаяСерииНоменклатуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РасходнаяНакладная.Запасы КАК РасходнаяНакладнаяЗапасы
	|		ПО РасходнаяНакладнаяСерииНоменклатуры.Ссылка = &ДокументОснование
	|		И РасходнаяНакладнаяЗапасы.Ссылка = &ДокументОснование
	|		И РасходнаяНакладнаяЗапасы.КлючСвязи = РасходнаяНакладнаяСерииНоменклатуры.КлючСвязи
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_РасходнаяНакладнаяСерииНоменклатуры.Серия,
	|	ВТ_РасходнаяНакладнаяСерииНоменклатуры.КлючСвязи
	|ИЗ
	|	ВТ_РасходнаяНакладнаяСерииНоменклатуры КАК ВТ_РасходнаяНакладнаяСерииНоменклатуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.СерииНоменклатурыКРасходу.Остатки(, Организация = &Организация
	|		И СтруктурнаяЕдиница = &СтруктурнаяЕдиница) КАК СерииНоменклатурыКРасходуОстатки
	|		ПО ВТ_РасходнаяНакладнаяСерииНоменклатуры.Номенклатура = СерииНоменклатурыКРасходуОстатки.Номенклатура
	|		И ВТ_РасходнаяНакладнаяСерииНоменклатуры.Характеристика = СерииНоменклатурыКРасходуОстатки.Характеристика
	|		И ВТ_РасходнаяНакладнаяСерииНоменклатуры.Партия = СерииНоменклатурыКРасходуОстатки.Партия
	|		И ВТ_РасходнаяНакладнаяСерииНоменклатуры.Серия = СерииНоменклатурыКРасходуОстатки.Серия");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументСсылкаРасходнаяНакладная);
	Запрос.УстановитьПараметр("Организация", Константы.УчетПоКомпании.Компания(Организация));
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", СтруктурнаяЕдиница);
		
	Запасы.Очистить();
	СерииНоменклатуры.Очистить();
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	Если РезультатыЗапроса[1].Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаСерииНоменклатуры = РезультатыЗапроса[3].Выгрузить();
	ТаблицаСерииНоменклатуры.Индексы.Добавить("КлючСвязи");
	
	ВыборкаЗапасы = РезультатыЗапроса[1].Выбрать();
	Пока ВыборкаЗапасы.Следующий() Цикл
		Если Не ЗначениеЗаполнено(ВыборкаЗапасы.Количество) Тогда
			Продолжить;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ВыборкаЗапасы.КоличествоОстаток) Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрокаЗапасы = Запасы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаЗапасы, ВыборкаЗапасы);
		НоваяСтрокаЗапасы.Количество = Мин(ВыборкаЗапасы.Количество, ВыборкаЗапасы.КоличествоОстаток);
		Если СерииНоменклатурыУНФ.ИспользоватьСерииНоменклатурыОстатки() = Истина Тогда
			НоваяСтрокаЗапасы.СерииНоменклатуры = СерииНоменклатурыУНФ.ПредставлениеСерийНоменклатуры(
				ТаблицаСерииНоменклатуры, НоваяСтрокаЗапасы.КлючСвязи);
		КонецЕсли;
	КонецЦикла;
	
	Если СерииНоменклатурыУНФ.ИспользоватьСерииНоменклатурыОстатки() = Истина Тогда
		СерииНоменклатуры.Загрузить(ТаблицаСерииНоменклатуры);
	Иначе
		СерииНоменклатурыУНФ.ЗаполнитьТЧСерииНоменклатурыПоКлючуСвязи(ЭтотОбъект, ДокументСсылкаРасходнаяНакладная);
		СерииНоменклатурыУНФ.УдалитьСерииНоменклатурыВТабличнойЧастиВЗависимостиОтПолитики(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьПоРасходнаяНакладная()

// Обработчик заполнения на основании документа ЗаказПокупателя.
//
// Параметры:
//  ДокументСсылкаЗаказПокупателя	 - ДокументСсылка.ЗаказПокупателя.
//
Процедура ЗаполнитьПоЗаказПокупателя(ДокументСсылкаЗаказПокупателя) Экспорт
	
	// Заполнение шапки.
	ДокументОснование = ДокументСсылкаЗаказПокупателя;
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылкаЗаказПокупателя, Новый Структура("Организация, ВидОперации, СтруктурнаяЕдиницаРезерв, Ячейка"));
	
	ПроверитьВозможностьВводаНаОсновании(ДокументСсылкаЗаказПокупателя, ЗначенияРеквизитов);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
	СтруктурнаяЕдиница = ЗначенияРеквизитов.СтруктурнаяЕдиницаРезерв;
	
	// Заполнение табличной части.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МИНИМУМ(ЗаказПокупателяЗапасы.НомерСтроки) КАК НомерСтроки,
	|	ЗаказПокупателяЗапасы.Номенклатура КАК Номенклатура,
	|	ЗаказПокупателяЗапасы.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	|	ЗаказПокупателяЗапасы.Характеристика КАК Характеристика,
	|	ЗаказПокупателяЗапасы.Партия КАК Партия,
	|	ЗаказПокупателяЗапасы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	СУММА(ЗаказПокупателяЗапасы.Количество) КАК Количество,
	|	ЗаказПокупателяЗапасы.КлючСвязи КАК КлючСвязи
	|ИЗ
	|	ВТЗаказПокупателяЗапасы КАК ЗаказПокупателяЗапасы
	|ГДЕ
	|	(ЗаказПокупателяЗапасы.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Запас)
	|			ИЛИ ЗаказПокупателяЗапасы.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.ПодарочныйСертификат))
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаказПокупателяЗапасы.Номенклатура,
	|	ЗаказПокупателяЗапасы.Характеристика,
	|	ЗаказПокупателяЗапасы.Партия,
	|	ЗаказПокупателяЗапасы.ЕдиницаИзмерения,
	|	ЗаказПокупателяЗапасы.Номенклатура.ТипНоменклатуры,
	|	ЗаказПокупателяЗапасы.КлючСвязи
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказПокупателяЗапасы.Серия КАК Серия,
	|	ЗаказПокупателяЗапасы.КлючСвязи КАК КлючСвязи
	|ИЗ
	|	Документ.ЗаказПокупателя.СерииНоменклатуры КАК ЗаказПокупателяЗапасы
	|ГДЕ
	|	ЗаказПокупателяЗапасы.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(ЗаказПокупателяЗапасы.НомерСтроки) КАК НомерСтроки,
	|	ЗаказПокупателяЗапасы.Номенклатура КАК Номенклатура,
	|	ЗаказПокупателяЗапасы.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	|	ЗаказПокупателяЗапасы.Характеристика КАК Характеристика,
	|	ЗаказПокупателяЗапасы.Партия КАК Партия,
	|	ЗаказПокупателяЗапасы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	СУММА(ЗаказПокупателяЗапасы.Количество) КАК Количество,
	|	ЗаказПокупателяЗапасы.КлючСвязиСерииНоменклатуры КАК КлючСвязи
	|ИЗ
	|	Документ.ЗаказПокупателя.Материалы КАК ЗаказПокупателяЗапасы
	|ГДЕ
	|	ЗаказПокупателяЗапасы.Ссылка = &ДокументОснование
	|	И (ЗаказПокупателяЗапасы.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Запас)
	|			ИЛИ ЗаказПокупателяЗапасы.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.ПодарочныйСертификат))
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаказПокупателяЗапасы.Номенклатура,
	|	ЗаказПокупателяЗапасы.Характеристика,
	|	ЗаказПокупателяЗапасы.Партия,
	|	ЗаказПокупателяЗапасы.ЕдиницаИзмерения,
	|	ЗаказПокупателяЗапасы.Номенклатура.ТипНоменклатуры,
	|	ЗаказПокупателяЗапасы.КлючСвязиСерииНоменклатуры
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказПокупателяЗапасы.Серия КАК Серия,
	|	ЗаказПокупателяЗапасы.КлючСвязи КАК КлючСвязи
	|ИЗ
	|	Документ.ЗаказПокупателя.СерииНоменклатурыМатериалы КАК ЗаказПокупателяЗапасы
	|ГДЕ
	|	ЗаказПокупателяЗапасы.Ссылка = &ДокументОснование";
	
	Документы.ЗаказПокупателя.ДобавитьТаблицуЗапасыВМенеджерВременныхТаблиц(ДокументСсылкаЗаказПокупателя, Запрос.МенеджерВременныхТаблиц, Истина);
	Запрос.УстановитьПараметр("ДокументОснование", ДокументСсылкаЗаказПокупателя);
	
	Запасы.Очистить();
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	//Запасы
	Если НЕ РезультатЗапроса[0].Пустой() Тогда
		Выборка = РезультатЗапроса[0].Выбрать();
		ВыборкаСерииНоменклатуры = РезультатЗапроса[1].Выбрать();
		
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = Запасы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			
			НоваяСтрока.СерииНоменклатуры = СерииНоменклатурыУНФ.СтрокаСерииНоменклатурыИзВыборки(ВыборкаСерииНоменклатуры, НоваяСтрока.КлючСвязи);
		КонецЦикла;
		
		СерииНоменклатуры.Загрузить(РезультатЗапроса[1].Выгрузить());
		
	КонецЕсли;
	
	СписокЗначений = Новый СписокЗначений;
	Для каждого СтрокаТЧ Из Запасы Цикл
        СписокЗначений.Добавить(СтрокаТЧ.КлючСвязи);
	КонецЦикла;
    Если СписокЗначений.Количество() = 0 Тогда
		МаксимальныйКлючСвязи = 1;
	Иначе
		СписокЗначений.СортироватьПоЗначению();
		МаксимальныйКлючСвязи = СписокЗначений.Получить(СписокЗначений.Количество() - 1).Значение + 1;
	КонецЕсли;
	
	//Материалы
	Если НЕ РезультатЗапроса[2].Пустой() Тогда
		Выборка = РезультатЗапроса[2].Выбрать();
		ВыборкаСерииНоменклатуры = РезультатЗапроса[3].Выбрать();
		
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = Запасы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			
			СтарыйКлючСвязи = Выборка.КлючСвязи;
			НоваяСтрока.КлючСвязи = МаксимальныйКлючСвязи;
			
			НоваяСтрока.СерииНоменклатуры = СерииНоменклатурыУНФ.СтрокаСерииНоменклатурыИзВыборки(ВыборкаСерииНоменклатуры, СтарыйКлючСвязи);
			
			СтруктураПоиска = Новый Структура("КлючСвязи", СтарыйКлючСвязи);
			Пока ВыборкаСерииНоменклатуры.НайтиСледующий(СтруктураПоиска) Цикл
				НоваяСтрокаСерииНоменклатуры = СерииНоменклатуры.Добавить();
				НоваяСтрокаСерииНоменклатуры.КлючСвязи = НоваяСтрока.КлючСвязи;
				НоваяСтрокаСерииНоменклатуры.Серия = ВыборкаСерииНоменклатуры.Серия;
			КонецЦикла;
			
			МаксимальныйКлючСвязи = МаксимальныйКлючСвязи+1;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьПоЗаказПокупателя()

// Обработчик заполнения на основании документа СписаниеЗапасов.
//
// Параметры:
//  ДокументСсылкаСписаниеЗапасов	 - ДокументСсылка.СписаниеЗапасов.
//
Процедура ЗаполнитьПоСписаниеЗапасов(ДокументСсылкаСписаниеЗапасов) Экспорт
	
	// Заполнение шапки.
	ДокументОснование = ДокументСсылкаСписаниеЗапасов;
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылкаСписаниеЗапасов, Новый Структура("Организация, СтруктурнаяЕдиница, Ячейка"));
	
	ПроверитьВозможностьВводаНаОсновании(ДокументСсылкаСписаниеЗапасов, ЗначенияРеквизитов);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
	
	// Заполнение табличной части.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МИНИМУМ(СписаниеЗапасовЗапасы.НомерСтроки) КАК НомерСтроки,
	|	СписаниеЗапасовЗапасы.Номенклатура КАК Номенклатура,
	|	СписаниеЗапасовЗапасы.Характеристика КАК Характеристика,
	|	СписаниеЗапасовЗапасы.Партия КАК Партия,
	|	СписаниеЗапасовЗапасы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	СУММА(СписаниеЗапасовЗапасы.Количество) КАК Количество,
	|	СписаниеЗапасовЗапасы.СерииНоменклатуры,
	|	СписаниеЗапасовЗапасы.КлючСвязи
	|ИЗ
	|	Документ.СписаниеЗапасов.Запасы КАК СписаниеЗапасовЗапасы
	|ГДЕ
	|	СписаниеЗапасовЗапасы.Ссылка = &ДокументОснование
	|
	|СГРУППИРОВАТЬ ПО
	|	СписаниеЗапасовЗапасы.Номенклатура,
	|	СписаниеЗапасовЗапасы.Характеристика,
	|	СписаниеЗапасовЗапасы.Партия,
	|	СписаниеЗапасовЗапасы.ЕдиницаИзмерения,
	|	СписаниеЗапасовЗапасы.СерииНоменклатуры,
	|	СписаниеЗапасовЗапасы.КлючСвязи
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументСсылкаСписаниеЗапасов);
	
	Запасы.Очистить();
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = Запасы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		КонецЦикла;
	КонецЕсли;
	
	СерииНоменклатурыУНФ.ЗаполнитьТЧСерииНоменклатурыПоКлючуСвязи(ЭтотОбъект, ДокументСсылкаСписаниеЗапасов);
	СерииНоменклатурыУНФ.УдалитьСерииНоменклатурыВТабличнойЧастиВЗависимостиОтПолитики(ЭтотОбъект);
	
КонецПроцедуры // ЗаполнитьПоСписаниеЗапасов()

// Обработчик заполнения на основании документа СписаниеЗапасов.
//
// Параметры:
//  ДокументСсылкаСписаниеЗапасов	 - ДокументСсылка.СписаниеЗапасов.
//
Процедура ЗаполнитьПоПересортицаЗапасов(ДокументСсылкаПересортицаЗапасов) Экспорт
	
	// Заполнение шапки.
	ДокументОснование = ДокументСсылкаПересортицаЗапасов;
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылкаПересортицаЗапасов, Новый Структура("Организация, СтруктурнаяЕдиница, Ячейка"));
	
	ПроверитьВозможностьВводаНаОсновании(ДокументСсылкаПересортицаЗапасов, ЗначенияРеквизитов);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
	
	// Заполнение табличной части.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МИНИМУМ(ПересортицаЗапасовЗапасы.НомерСтроки) КАК НомерСтроки,
	|	ПересортицаЗапасовЗапасы.Номенклатура КАК Номенклатура,
	|	ПересортицаЗапасовЗапасы.Характеристика КАК Характеристика,
	|	ПересортицаЗапасовЗапасы.Партия КАК Партия,
	|	ПересортицаЗапасовЗапасы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	СУММА(ПересортицаЗапасовЗапасы.Количество) КАК Количество,
	|	ПересортицаЗапасовЗапасы.СерииНоменклатуры,
	|	ПересортицаЗапасовЗапасы.КлючСвязи
	|ИЗ
	|	Документ.ПересортицаЗапасов.Запасы КАК ПересортицаЗапасовЗапасы
	|ГДЕ
	|	ПересортицаЗапасовЗапасы.Ссылка = &ДокументОснование
	|
	|СГРУППИРОВАТЬ ПО
	|	ПересортицаЗапасовЗапасы.Номенклатура,
	|	ПересортицаЗапасовЗапасы.Характеристика,
	|	ПересортицаЗапасовЗапасы.Партия,
	|	ПересортицаЗапасовЗапасы.ЕдиницаИзмерения,
	|	ПересортицаЗапасовЗапасы.СерииНоменклатуры,
	|	ПересортицаЗапасовЗапасы.КлючСвязи
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументСсылкаПересортицаЗапасов);
	
	Запасы.Очистить();
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = Запасы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		КонецЦикла;
	КонецЕсли;
	
	СерииНоменклатурыУНФ.ЗаполнитьТЧСерииНоменклатурыПоКлючуСвязи(ЭтотОбъект, ДокументСсылкаПересортицаЗапасов);
	СерииНоменклатурыУНФ.УдалитьСерииНоменклатурыВТабличнойЧастиВЗависимостиОтПолитики(ЭтотОбъект);
	
КонецПроцедуры // ЗаполнитьПоПересортицаЗапасов()

// Обработчик заполнения на основании документа ПеремещениеЗапасов.
//
// Параметры:
//  ДокументСсылкаПеремещениеЗапасов - ДокументСсылка.ПеремещениеЗапасов.
//
Процедура ЗаполнитьПоПеремещениеЗапасов(ДокументСсылкаПеремещениеЗапасов) Экспорт
	
	// Заполнение шапки.
	ДокументОснование = ДокументСсылкаПеремещениеЗапасов;
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
	ДокументСсылкаПеремещениеЗапасов,
	Новый Структура("Организация, СтруктурнаяЕдиница, Ячейка"));
	
	ПроверитьВозможностьВводаНаОсновании(ДокументСсылкаПеремещениеЗапасов, ЗначенияРеквизитов);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
	
	// Заполнение табличной части.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МИНИМУМ(ПеремещениеЗапасовЗапасы.НомерСтроки) КАК НомерСтроки,
	|	ПеремещениеЗапасовЗапасы.Номенклатура КАК Номенклатура,
	|	ПеремещениеЗапасовЗапасы.Характеристика КАК Характеристика,
	|	ПеремещениеЗапасовЗапасы.Партия КАК Партия,
	|	ПеремещениеЗапасовЗапасы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	СУММА(ПеремещениеЗапасовЗапасы.Количество) КАК Количество,
	|	ПеремещениеЗапасовЗапасы.СерииНоменклатуры,
	|	ПеремещениеЗапасовЗапасы.КлючСвязи
	|ИЗ
	|	Документ.ПеремещениеЗапасов.Запасы КАК ПеремещениеЗапасовЗапасы
	|ГДЕ
	|	ПеремещениеЗапасовЗапасы.Ссылка = &ДокументОснование
	|
	|СГРУППИРОВАТЬ ПО
	|	ПеремещениеЗапасовЗапасы.Номенклатура,
	|	ПеремещениеЗапасовЗапасы.Характеристика,
	|	ПеремещениеЗапасовЗапасы.Партия,
	|	ПеремещениеЗапасовЗапасы.ЕдиницаИзмерения,
	|	ПеремещениеЗапасовЗапасы.СерииНоменклатуры,
	|	ПеремещениеЗапасовЗапасы.КлючСвязи
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументСсылкаПеремещениеЗапасов);
	
	Запасы.Очистить();
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = Запасы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		КонецЦикла;
	КонецЕсли;
	
	СерииНоменклатурыУНФ.ЗаполнитьТЧСерииНоменклатурыПоКлючуСвязи(ЭтотОбъект, ДокументСсылкаПеремещениеЗапасов);
	СерииНоменклатурыУНФ.УдалитьСерииНоменклатурыВТабличнойЧастиВЗависимостиОтПолитики(ЭтотОбъект);
	
КонецПроцедуры // ЗаполнитьПоПеремещениеЗапасов()

// Обработчик заполнения на основании документа ПриходныйОрдер.
//
// Параметры:
//  ДокументСсылкаПриходныйОрдер - ДокументСсылка.ПриходныйОрдер.
//
Процедура ЗаполнитьПоПриходныйОрдер(ДокументСсылкаПриходныйОрдер) Экспорт
	
	// Заполнение шапки.
	ДокументОснование = ДокументСсылкаПриходныйОрдер;
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылкаПриходныйОрдер,
		"Организация, СтруктурнаяЕдиница, Ячейка");
	
	ПроверитьВозможностьВводаНаОсновании(ДокументСсылкаПриходныйОрдер, ЗначенияРеквизитов);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
	
	// Заполнение табличной части.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МИНИМУМ(ПриходныйОрдерЗапасы.НомерСтроки) КАК НомерСтроки,
	|	ПриходныйОрдерЗапасы.Номенклатура КАК Номенклатура,
	|	ПриходныйОрдерЗапасы.Характеристика КАК Характеристика,
	|	ПриходныйОрдерЗапасы.Партия КАК Партия,
	|	ПриходныйОрдерЗапасы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	СУММА(ПриходныйОрдерЗапасы.Количество) КАК Количество,
	|	ПриходныйОрдерЗапасы.СерииНоменклатуры,
	|	ПриходныйОрдерЗапасы.КлючСвязи
	|ИЗ
	|	Документ.ПриходныйОрдер.Запасы КАК ПриходныйОрдерЗапасы
	|ГДЕ
	|	ПриходныйОрдерЗапасы.Ссылка = &ДокументОснование
	|
	|СГРУППИРОВАТЬ ПО
	|	ПриходныйОрдерЗапасы.Номенклатура,
	|	ПриходныйОрдерЗапасы.Характеристика,
	|	ПриходныйОрдерЗапасы.Партия,
	|	ПриходныйОрдерЗапасы.ЕдиницаИзмерения,
	|	ПриходныйОрдерЗапасы.СерииНоменклатуры,
	|	ПриходныйОрдерЗапасы.КлючСвязи
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументСсылкаПриходныйОрдер);
	
	Запасы.Очистить();
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = Запасы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		КонецЦикла;
	КонецЕсли;
	
	СерииНоменклатурыУНФ.ЗаполнитьТЧСерииНоменклатурыПоКлючуСвязи(ЭтотОбъект, ДокументСсылкаПриходныйОрдер);
	СерииНоменклатурыУНФ.УдалитьСерииНоменклатурыВТабличнойЧастиВЗависимостиОтПолитики(ЭтотОбъект);
	
КонецПроцедуры // ЗаполнитьПоПриходныйОрдер()

// Обработчик заполнения на основании документа ПринятиеКУчетуВА.
//
// Параметры:
//  ДокументСсылкаПринятиеКУчетуВА	 - ДокументСсылка.ПринятиеКУчетуВА.
//
Процедура ЗаполнитьПоПринятиеКУчетуВА(ДокументСсылкаПринятиеКУчетуВА) Экспорт
	
	// Заполнение шапки.
	ДокументОснование = ДокументСсылкаПринятиеКУчетуВА;
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылкаПринятиеКУчетуВА,
		"Организация, СтруктурнаяЕдиница, Ячейка");
	
	ПроверитьВозможностьВводаНаОсновании(ДокументСсылкаПринятиеКУчетуВА, ЗначенияРеквизитов);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
	
	// Заполнение табличной части.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПринятиеКУчетуВА.Номенклатура КАК Номенклатура,
	|	ПринятиеКУчетуВА.Партия КАК Партия,
	|	ПринятиеКУчетуВА.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ПринятиеКУчетуВА.Количество КАК Количество
	|ИЗ
	|	Документ.ПринятиеКУчетуВА КАК ПринятиеКУчетуВА
	|ГДЕ
	|	ПринятиеКУчетуВА.Ссылка = &ДокументОснование";
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументСсылкаПринятиеКУчетуВА);
	
	Запасы.Очистить();
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = Запасы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьПоПринятиеКУчетуВА()

// Обработчик заполнения на основании документа СборкаЗапасов.
//
// Параметры:
//  ДокументСсылкаСборкаЗапасов	 - ДокументСсылка.СборкаЗапасов.
//
Процедура ЗаполнитьПоСборкаЗапасов(ДокументСсылкаСборкаЗапасов) Экспорт
	
	// Заполнение шапки.
	ДокументОснование = ДокументСсылкаСборкаЗапасов;
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылкаСборкаЗапасов,
			Новый Структура("Организация, ВидОперации, СтруктурнаяЕдиница, Ячейка, СтруктурнаяЕдиницаЗапасов, ЯчейкаЗапасов, СтруктурнаяЕдиницаОтходов, ЯчейкаОтходов, ПоложениеСклада"));
		
	Организация = ЗначенияРеквизитов.Организация;
	ИмяТЧ = "";
	
	Если ЗначенияРеквизитов.ПоложениеСклада = ПредопределенноеЗначение("Перечисление.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти") Тогда
		
		Если ЗначенияРеквизитов.ВидОперации = Перечисления.ВидыОперацийСборкаЗапасов.Разборка И ЕстьОрдерныйСкладВТабЧасти(ДокументСсылкаСборкаЗапасов.Продукция) Тогда
			ИмяТЧ = "Продукция";
		ИначеЕсли ЗначенияРеквизитов.ВидОперации <> Перечисления.ВидыОперацийСборкаЗапасов.Разборка И ЕстьОрдерныйСкладВТабЧасти(ДокументСсылкаСборкаЗапасов.Запасы) Тогда
			ИмяТЧ = "Запасы";
		КонецЕсли;
		
	Иначе
		
		Если ЗначенияРеквизитов.СтруктурнаяЕдиница.ОрдерныйСклад Тогда
			
			Если ЗначенияРеквизитов.ВидОперации = Перечисления.ВидыОперацийСборкаЗапасов.Разборка Тогда
				ИмяТЧ = "Продукция";
			Иначе
				ИмяТЧ = "Запасы";
			КонецЕсли;
			
			СтруктурнаяЕдиница = ЗначенияРеквизитов.СтруктурнаяЕдиница;
			Ячейка = ЗначенияРеквизитов.Ячейка;
			
		Иначе
			
			Если ЗначенияРеквизитов.СтруктурнаяЕдиницаЗапасов.ОрдерныйСклад Тогда
				
				Если ЗначенияРеквизитов.ВидОперации = Перечисления.ВидыОперацийСборкаЗапасов.Разборка Тогда
					ИмяТЧ = "Продукция";
				Иначе
					ИмяТЧ = "Запасы";
				КонецЕсли;
				
				СтруктурнаяЕдиница = ЗначенияРеквизитов.СтруктурнаяЕдиницаЗапасов;
				Ячейка = ЗначенияРеквизитов.ЯчейкаЗапасов;
								
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПустаяСтрока(ИмяТЧ) Тогда
		ТекстИсключения = НСтр("ru = 'Невозможен ввод операции ""Отгрузка с ордерного склада"".
								|Документ ""%1"" не имеет ордерного склада.'");
		ТекстИсключения = СтрШаблон(ТекстИсключения, ДокументСсылкаСборкаЗапасов.Ссылка);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	// Заполнение табличной части.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТабличнаяЧасть.Номенклатура КАК Номенклатура,
	|	ТабличнаяЧасть.Характеристика КАК Характеристика,
	|	ТабличнаяЧасть.Партия КАК Партия,
	|	ТабличнаяЧасть.Количество КАК Количество,
	|	ТабличнаяЧасть.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ТабличнаяЧасть.СерииНоменклатуры КАК СерииНоменклатуры,
	|	ТабличнаяЧасть.СтруктурнаяЕдиница.ОрдерныйСклад КАК ОрдерныйСклад,
	|	ТабличнаяЧасть.КлючСвязи КАК КлючСвязи
	|ИЗ
	|	Документ.СборкаЗапасов.Запасы КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка = &ДокументОснование";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "СборкаЗапасов.Запасы", "СборкаЗапасов." + ИмяТЧ);
	Запрос.УстановитьПараметр("ДокументОснование", ДокументСсылкаСборкаЗапасов);
	
	Запасы.Очистить();
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	Пока Выборка.Следующий() Цикл
		Если ЗначенияРеквизитов.ПоложениеСклада = ПредопределенноеЗначение("Перечисление.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти")
				И НЕ Выборка.ОрдерныйСклад Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = Запасы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	КонецЦикла; 
	
	Если ЗначенияРеквизитов.ВидОперации = Перечисления.ВидыОперацийСборкаЗапасов.Разборка Тогда
		СерииНоменклатурыУНФ.ЗаполнитьТЧСерииНоменклатурыПоКлючуСвязи(ЭтотОбъект, ДокументСсылкаСборкаЗапасов, "Продукция", "СерииНоменклатурыПродукция");
	Иначе
		СерииНоменклатурыУНФ.ЗаполнитьТЧСерииНоменклатурыПоКлючуСвязи(ЭтотОбъект, ДокументСсылкаСборкаЗапасов);
	КонецЕсли;
	
	СерииНоменклатурыУНФ.УдалитьСерииНоменклатурыВТабличнойЧастиВЗависимостиОтПолитики(ЭтотОбъект);
	
КонецПроцедуры // ЗаполнитьПоСборкаЗапасов()

// Обработчик заполнения на основании документа КомплектацияЗапасов.
//
// Параметры:
//  ДокументСсылкаКомплектацияЗапасов	 - ДокументСсылка.КомплектацияЗапасов.
//
Процедура ЗаполнитьПоКомплектацияЗапасов(ДокументСсылкаКомплектацияЗапасов) Экспорт
	
	// Заполнение шапки.
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылкаКомплектацияЗапасов,
			"Организация, ВидОперации, СтруктурнаяЕдиница, СтруктурнаяЕдиница.ОрдерныйСклад, Ячейка");
		
	Если НЕ ЗначенияРеквизитов.СтруктурнаяЕдиницаОрдерныйСклад Тогда
		ТекстИсключения = НСтр("ru = 'Невозможен ввод операции ""Отгрузка с ордерного склада"".
								|Документ ""%1"" не имеет ордерного склада.'");
		ТекстИсключения = СтрШаблон(ТекстИсключения, ДокументСсылкаКомплектацияЗапасов);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ДокументОснование = ДокументСсылкаКомплектацияЗапасов;
	Организация = ЗначенияРеквизитов.Организация;
	СтруктурнаяЕдиница = ЗначенияРеквизитов.СтруктурнаяЕдиница;
	Ячейка = ЗначенияРеквизитов.Ячейка;
	
	Если ЗначенияРеквизитов.ВидОперации = Перечисления.ВидыОперацийКомплектацияЗапасов.Разборка Тогда
		
		ЗначенияРеквизитовЗапасы = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылкаКомплектацияЗапасов,
				"Номенклатура, Характеристика, Партия, Количество, ЕдиницаИзмерения, СерииНоменклатурыПредставление");
		
		Запасы.Очистить();
		НоваяСтрока = Запасы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ЗначенияРеквизитовЗапасы);
		НоваяСтрока.СерииНоменклатуры = ЗначенияРеквизитовЗапасы.СерииНоменклатурыПредставление;
		ТабличныеЧастиУНФКлиентСервер.ЗаполнитьКлючСвязи(Запасы, НоваяСтрока, "КлючСвязи");
		
		СерииНоменклатуры.Загрузить(ДокументСсылкаКомплектацияЗапасов.СерииНоменклатуры.Выгрузить());
		Для каждого СтрокаТЧ Из СерииНоменклатуры Цикл
			СтрокаТЧ.КлючСвязи = НоваяСтрока.КлючСвязи;
		КонецЦикла; 
		
	Иначе
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТабличнаяЧасть.Номенклатура КАК Номенклатура,
		|	ТабличнаяЧасть.Характеристика КАК Характеристика,
		|	ТабличнаяЧасть.Партия КАК Партия,
		|	ТабличнаяЧасть.Количество КАК Количество,
		|	ТабличнаяЧасть.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ТабличнаяЧасть.СерииНоменклатуры КАК СерииНоменклатуры,
		|	ТабличнаяЧасть.КлючСвязи КАК КлючСвязи
		|ИЗ
		|	Документ.КомплектацияЗапасов.Запасы КАК ТабличнаяЧасть
		|ГДЕ
		|	ТабличнаяЧасть.Ссылка = &ДокументОснование";
		Запрос.УстановитьПараметр("ДокументОснование", ДокументСсылкаКомплектацияЗапасов);
		
		Запасы.Загрузить(Запрос.Выполнить().Выгрузить());
		СерииНоменклатурыУНФ.ЗаполнитьТЧСерииНоменклатурыПоКлючуСвязи(ЭтотОбъект, 
			ДокументСсылкаКомплектацияЗапасов, , "СерииНоменклатурыЗапасы");
			
		СерииНоменклатурыУНФ.УдалитьСерииНоменклатурыВТабличнойЧастиВЗависимостиОтПолитики(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьПоКомплектацияЗапасов()

// АПК:299-вкл

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.ОтчетОПереработке")] = "ЗаполнитьПоОтчетОПереработке";
	СтратегияЗаполнения[Тип("ДокументСсылка.РасходнаяНакладная")] = "ЗаполнитьПоРасходнаяНакладная";
	СтратегияЗаполнения[Тип("ДокументСсылка.ЗаказПокупателя")] = "ЗаполнитьПоЗаказПокупателя";
	СтратегияЗаполнения[Тип("ДокументСсылка.СписаниеЗапасов")] = "ЗаполнитьПоСписаниеЗапасов";
	СтратегияЗаполнения[Тип("ДокументСсылка.ПересортицаЗапасов")] = "ЗаполнитьПоПересортицаЗапасов";
	СтратегияЗаполнения[Тип("ДокументСсылка.ПеремещениеЗапасов")] = "ЗаполнитьПоПеремещениеЗапасов";
	СтратегияЗаполнения[Тип("ДокументСсылка.ПриходныйОрдер")] = "ЗаполнитьПоПриходныйОрдер";
	СтратегияЗаполнения[Тип("ДокументСсылка.ПринятиеКУчетуВА")] = "ЗаполнитьПоПринятиеКУчетуВА";
	СтратегияЗаполнения[Тип("ДокументСсылка.СборкаЗапасов")] = "ЗаполнитьПоСборкаЗапасов";
	СтратегияЗаполнения[Тип("ДокументСсылка.КомплектацияЗапасов")] = "ЗаполнитьПоКомплектацияЗапасов";
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа
	Документы.РасходныйОрдер.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ПроведениеДокументовУНФ.ОтразитьДвижения("ЗапасыКРасходуСоСкладов", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ЗапасыНаСкладах", ТаблицыДляДвижений, Движения, Отказ);

	// СерииНоменклатуры
	ПроведениеДокументовУНФ.ОтразитьДвижения("СерииНоменклатурыГарантии", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДвиженияСерииНоменклатуры", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("СерииНоменклатуры", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("СерииНоменклатурыКРасходу", ТаблицыДляДвижений, Движения, Отказ);
	
	// Запись наборов записей
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	// Контроль
	Документы.РасходныйОрдер.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	// Контроль
	Документы.РасходныйОрдер.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Серии номенклатуры
	СерииНоменклатурыУНФ.ПроверкаЗаполненияСерийНоменклатуры(Отказ, Запасы, СерииНоменклатуры, СтруктурнаяЕдиница, ЭтотОбъект);
	
	НоменклатураВДокументахСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, Отказ, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЕстьОрдерныйСкладВТабЧасти(ТабЧасть)
	
	ЗначенияРеквизитовСкладТЧ = ТабЧасть.ВыгрузитьКолонку("СтруктурнаяЕдиница");
	ЗначенияОрдерныйСклад = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(ЗначенияРеквизитовСкладТЧ, "ОрдерныйСклад");
	
	Для каждого складТЧ Из ЗначенияОрдерныйСклад Цикл
		Если СкладТЧ.Значение = Истина Тогда
			
			Возврат Истина;
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти 

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
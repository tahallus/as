#Область ПрограммныйИнтерфейс

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиентаПриЗапуске.
//
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() И Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 3
	|	ПРЕДСТАВЛЕНИЕ(КурсыВалютСрезПоследних.Валюта) КАК ПредставлениеВалюты,
	|	ВЫБОР
	|		КОГДА КурсыВалютСрезПоследних.Кратность <> 0
	|			ТОГДА КурсыВалютСрезПоследних.Курс / КурсыВалютСрезПоследних.Кратность
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК КурсКратность
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&Период,
	|	НЕ Валюта.ПометкаУдаления
	|	И Валюта <> &НациональнаяВалюта) КАК КурсыВалютСрезПоследних";
	
	Запрос.УстановитьПараметр("НациональнаяВалюта", Константы.НациональнаяВалюта.Получить());
	Запрос.УстановитьПараметр("Период", НачалоДня(ТекущаяДатаСеанса()));
	
	ПодстрокиЗаголовка = Новый Массив;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.КурсКратность = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ПредставлениеКурса = Формат(Выборка.КурсКратность, "ЧДЦ=2");
		ПредставлениеКурсаВалюты = СтрШаблон("%1 %2", Выборка.ПредставлениеВалюты, ПредставлениеКурса);
		ПодстрокиЗаголовка.Добавить(ПредставлениеКурсаВалюты);
	КонецЦикла;
	
	Если ПодстрокиЗаголовка.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЗаголовокКурсыВалют = СтрСоединить(ПодстрокиЗаголовка, " / ");
	Параметры.Вставить("ЗаголовокПриложенияВалютыУНФ", ЗаголовокКурсыВалют);
	
КонецПроцедуры

// Устарела. Будет удалена в следующей версии программы.
// Добавляет в конец заголовка приложения текущие курсы валют.
//
// Параметры:
//  ЗаголовокПриложения - Строка - текст заголовка приложения;
Процедура ДополнитьЗаголовокКлиентскогоПриложения(ЗаголовокПриложения) Экспорт

	Если ОбщегоНазначения.РазделениеВключено() И Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;

	КомпонентыЗаголовка = Новый Массив;
	КомпонентыЗаголовка.Добавить(ЗаголовокПриложения);

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 3
	|	ПРЕДСТАВЛЕНИЕ(КурсыВалютСрезПоследних.Валюта) КАК ПредставлениеВалюты,
	|	ВЫБОР
	|		КОГДА КурсыВалютСрезПоследних.Кратность <> 0
	|			ТОГДА КурсыВалютСрезПоследних.Курс / КурсыВалютСрезПоследних.Кратность
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК КурсКратность
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&Период,
	|	НЕ Валюта.ПометкаУдаления
	|	И Валюта <> &НациональнаяВалюта) КАК КурсыВалютСрезПоследних";

	Запрос.УстановитьПараметр("НациональнаяВалюта", Константы.НациональнаяВалюта.Получить());
	Запрос.УстановитьПараметр("Период", НачалоДня(ТекущаяДатаСеанса()));

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл

		Если Выборка.КурсКратность = Неопределено Тогда
			Продолжить;
		КонецЕсли;

		ПредставлениеКурсаВалюты = СтрШаблон("%1 %2", Выборка.ПредставлениеВалюты, Формат(Выборка.КурсКратность,
			"ЧДЦ=2"));
		КомпонентыЗаголовка.Добавить(ПредставлениеКурсаВалюты);

	КонецЦикла;

	ЗаголовокПриложения = СтрСоединить(КомпонентыЗаголовка, " / ");

КонецПроцедуры

#КонецОбласти
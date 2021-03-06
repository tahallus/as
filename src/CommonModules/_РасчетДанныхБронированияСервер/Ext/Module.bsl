Функция ПолучитьРасшифровкуБронированияПоНоменклатуре(Номенклатура, ДатаНачала, ДатаОкончания, Показы, ИсключаемыйРегистратор) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Номенклатура_Состав.Площадка КАК Площадка,
		|	Номенклатура_Состав.Коэффициент / 1000 * &Показы КАК Показы
		|ПОМЕСТИТЬ ВТ_ПлощадкаПоказы
		|ИЗ
		|	Справочник.Номенклатура._Состав КАК Номенклатура_Состав
		|ГДЕ
		|	Номенклатура_Состав.Ссылка = &Номенклатура
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Площадка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	_ОжидаемыеСуточныеПоказателиТрафика.Площадка КАК Площадка,
		|	_ОжидаемыеСуточныеПоказателиТрафика.Показы * (РАЗНОСТЬДАТ(&ДатаНачала, &ДатаОкончания, ДЕНЬ) + 1) КАК Показы,
		|	РАЗНОСТЬДАТ(&ДатаНачала, &ДатаОкончания, ДЕНЬ) + 1 КАК КоличествоДней
		|ПОМЕСТИТЬ ВТ_ОбщийТрафик
		|ИЗ
		|	РегистрСведений._ОжидаемыеСуточныеПоказателиТрафика КАК _ОжидаемыеСуточныеПоказателиТрафика
		|ГДЕ
		|	_ОжидаемыеСуточныеПоказателиТрафика.Площадка В
		|			(ВЫБРАТЬ
		|				ВТ_ПлощадкаПоказы.Площадка КАК Площадка
		|			ИЗ
		|				ВТ_ПлощадкаПоказы КАК ВТ_ПлощадкаПоказы)
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Площадка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	_ДанныеБронированияПлощадокОбороты.Площадка КАК Площадка,
		|	СУММА(_ДанныеБронированияПлощадокОбороты.ПоказыОборот) КАК Показы
		|ПОМЕСТИТЬ ВТ_ДанныеПоБронированию
		|ИЗ
		|	РегистрНакопления._ДанныеБронированияПлощадок.Обороты(
		|			&ДатаНачала,
		|			&ДатаОкончания,
		|			Регистратор,
		|			Площадка В
		|				(ВЫБРАТЬ
		|					ВТ_ПлощадкаПоказы.Площадка КАК Площадка
		|				ИЗ
		|					ВТ_ПлощадкаПоказы КАК ВТ_ПлощадкаПоказы)) КАК _ДанныеБронированияПлощадокОбороты
		|ГДЕ
		|	_ДанныеБронированияПлощадокОбороты.Регистратор <> &ИсключаемыйРегистратор
		|
		|СГРУППИРОВАТЬ ПО
		|	_ДанныеБронированияПлощадокОбороты.Площадка
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Площадка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	_ДанныеПредварительногоБронированияПлощадокОбороты.Площадка КАК Площадка,
		|	СУММА(_ДанныеПредварительногоБронированияПлощадокОбороты.ПоказыОборот) КАК Показы
		|ПОМЕСТИТЬ ВТ_ДанныеПоПредварительномуБронированию
		|ИЗ
		|	РегистрНакопления._ДанныеПредварительногоБронированияПлощадок.Обороты(
		|			&ДатаНачала,
		|			&ДатаОкончания,
		|			Регистратор,
		|			Площадка В
		|				(ВЫБРАТЬ
		|					ВТ_ПлощадкаПоказы.Площадка КАК Площадка
		|				ИЗ
		|					ВТ_ПлощадкаПоказы КАК ВТ_ПлощадкаПоказы)) КАК _ДанныеПредварительногоБронированияПлощадокОбороты
		|ГДЕ
		|	_ДанныеПредварительногоБронированияПлощадокОбороты.Регистратор <> &ИсключаемыйРегистратор
		|
		|СГРУППИРОВАТЬ ПО
		|	_ДанныеПредварительногоБронированияПлощадокОбороты.Площадка
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Площадка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ПлощадкаПоказы.Площадка КАК Площадка,
		|	ВТ_ПлощадкаПоказы.Показы КАК ПланируемыеПоказы,
		|	ЕСТЬNULL(ВТ_ОбщийТрафик.Показы, 0) КАК ОбщийТрафик,
		|	ЕСТЬNULL(ВТ_ДанныеПоБронированию.Показы, 0) КАК ЗабронированныйТрафик,
		|	ЕСТЬNULL(ВТ_ДанныеПоПредварительномуБронированию.Показы, 0) КАК ТрафикНаПредварительномБронировании
		|ПОМЕСТИТЬ ВТ_Итоги
		|ИЗ
		|	ВТ_ПлощадкаПоказы КАК ВТ_ПлощадкаПоказы
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ОбщийТрафик КАК ВТ_ОбщийТрафик
		|		ПО ВТ_ПлощадкаПоказы.Площадка = ВТ_ОбщийТрафик.Площадка
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДанныеПоБронированию КАК ВТ_ДанныеПоБронированию
		|		ПО ВТ_ПлощадкаПоказы.Площадка = ВТ_ДанныеПоБронированию.Площадка
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДанныеПоПредварительномуБронированию КАК ВТ_ДанныеПоПредварительномуБронированию
		|		ПО ВТ_ПлощадкаПоказы.Площадка = ВТ_ДанныеПоПредварительномуБронированию.Площадка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Итоги.Площадка КАК Площадка,
		|	ВТ_Итоги.ПланируемыеПоказы КАК ПланируемыеПоказы,
		|	ВТ_Итоги.ОбщийТрафик КАК ОбщийТрафик,
		|	ВТ_Итоги.ЗабронированныйТрафик КАК ЗабронированныйТрафик,
		|	ВТ_Итоги.ТрафикНаПредварительномБронировании КАК ТрафикНаПредварительномБронировании,
		|	ВТ_Итоги.ПланируемыеПоказы + ВТ_Итоги.ЗабронированныйТрафик КАК ИтогоСУчетомБрони,
		|	ВТ_Итоги.ПланируемыеПоказы + ВТ_Итоги.ЗабронированныйТрафик + ВТ_Итоги.ТрафикНаПредварительномБронировании КАК ИтогоСУчетомПредброни,
		|	ВЫБОР
		|		КОГДА ВТ_Итоги.ПланируемыеПоказы + ВТ_Итоги.ЗабронированныйТрафик - ВТ_Итоги.ОбщийТрафик < 0
		|			ТОГДА 0
		|		ИНАЧЕ ВТ_Итоги.ПланируемыеПоказы + ВТ_Итоги.ЗабронированныйТрафик - ВТ_Итоги.ОбщийТрафик
		|	КОНЕЦ КАК ОвербукингСУчетомБрони,
		|	ВЫБОР
		|		КОГДА ВТ_Итоги.ПланируемыеПоказы + ВТ_Итоги.ЗабронированныйТрафик + ВТ_Итоги.ТрафикНаПредварительномБронировании - ВТ_Итоги.ОбщийТрафик < 0
		|			ТОГДА 0
		|		ИНАЧЕ ВТ_Итоги.ПланируемыеПоказы + ВТ_Итоги.ЗабронированныйТрафик + ВТ_Итоги.ТрафикНаПредварительномБронировании - ВТ_Итоги.ОбщийТрафик
		|	КОНЕЦ КАК ОвербукингСУчетомПреброни
		|ИЗ
		|	ВТ_Итоги КАК ВТ_Итоги";
	
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	Запрос.УстановитьПараметр("Показы", Показы);
	Запрос.УстановитьПараметр("ИсключаемыйРегистратор", ИсключаемыйРегистратор);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат
	
КонецФункции



//Процедура ОбработкаПроведения(Отказ, Режим)
//	
//	Движения.ASDO001_ПрайсЛист.Записывать = Истина;
//	Для Каждого ТекСтрокаЦеныПозиций Из ЦеныПозиций Цикл
//		Движение = Движения.ASDO001_ПрайсЛист.Добавить();
//		Движение.Период = Дата;
//		Движение.Организация = Организация;
//		Движение.Проект = Проект;
//		Движение.ФорматРазмещения = ТекСтрокаЦеныПозиций.ФорматРазмещения;
//		Движение.Количество = ТекСтрокаЦеныПозиций.Количество;
//		Движение.ЕдиницаИзмерения = ТекСтрокаЦеныПозиций.ЕдиницаИзмерения;
//		Движение.Журнал = Журнал;
//		Движение.МестоРазмещения = ТекСтрокаЦеныПозиций.МестоРазмещения;
//		Движение.Категория = Категория;
//		Движение.Цена = ТекСтрокаЦеныПозиций.Цена;
//		Движение.Описание = ТекСтрокаЦеныПозиций.Описание;
//		Движение.Пользователь = Отвественный;
//	КонецЦикла;
//	
//КонецПроцедуры

//Процедура ПередУдалением(Отказ)
//	Если Не РольДоступна ("ПолныеПрава") Тогда
//		Отказ = Истина;
//	КонецЕсли;
//КонецПроцедуры

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбновлениеИнформационнойБазы

Процедура ЗаполнитьПоставляемыеПричиныНеуспешногоЗавершенияРаботыСЛидом() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ПричиныНеуспешногоЗавершенияРаботыСЛидом.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ПричиныНеуспешногоЗавершенияРаботыСЛидом КАК ПричиныНеуспешногоЗавершенияРаботыСЛидом";
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		// 1. Причина "Пропала потребность"
		Причина = Справочники.ПричиныНеуспешногоЗавершенияРаботыСЛидом.СоздатьЭлемент();
		Причина.Наименование	= НСтр("ru='Не устроили условия'");
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Причина);
		
		// 2. Причина "Выбрали других"
		Причина = Справочники.ПричиныНеуспешногоЗавершенияРаботыСЛидом.СоздатьЭлемент();
		Причина.Наименование	= НСтр("ru='Выбрали другую компанию'");
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Причина);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось заполнить справочник ""Причины неуспешного завершения работы с лидом"" по умолчанию по причине:
				|%1'"), 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
		);
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Справочники.ПричиныНеуспешногоЗавершенияРаботыСЛидом, , ТекстСообщения);
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

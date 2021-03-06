
#Область ПечатьMSWord

Функция ПечатьДоговораПриложенияMSWord(ОписаниеКоманды) Экспорт
	
	Состояние(НСтр("ru = 'Выполняется формирование печатных форм'"));
	
	ПараметрыФормирования = _УправлениеПечатьюВызовСервера.ПечатьДоговораПриложенияMSWord(ОписаниеКоманды.Идентификатор, ОписаниеКоманды.ОбъектыПечати);
	Если НЕ ЗначениеЗаполнено(ПараметрыФормирования) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(ПараметрыФормирования.АдресХранилищаПечатнойФормы);
	Если ЗначениеЗаполнено(ПараметрыФормирования.ИмяФайла) Тогда
		ИмяФайла = ПараметрыФормирования.ИмяФайла;
	Иначе
		ИмяФайла = ПолучитьИмяВременногоФайла("docx");
	КонецЕсли;
	ДвоичныеДанные.Записать(ИмяФайла);
	ЗапуститьПриложение(ИмяФайла);

	Состояние(НСтр("ru = 'Формирование печатных форм завершено'"));
	
КонецФункции

#КонецОбласти
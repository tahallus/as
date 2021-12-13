﻿
#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьЦелевоеВремяОперацийПроизводительности() Экспорт
	
	КлючевыеОперации = Новый Структура;
	ЗаполнитьЦелевоеВремяКлючевыхОпераций(КлючевыеОперации);
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.КлючевыеОперации");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Для каждого стрОперация Из КлючевыеОперации Цикл
			СоздатьИЗаполнитьЦелевоеВремяКлючевойОперации(стрОперация.Ключ, стрОперация.Значение);
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ТекстОшибки = ОписаниеОшибки();
		ОтменитьТранзакцию();
	КонецПопытки;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьЦелевоеВремяКлючевыхОпераций(КлючевыеОперации)

	///////////////////////
	// Общие команды и формы
		
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ДокументСобытиеЗапись", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СправочникБанковскиеСчетаЗапись", 1);  
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СправочникВидЦенЗапись", 1);  
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СправочникВидЦенКонтрагентовЗапись", 1);  
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СправочникКонтрагентыЗапись", 1.5);  
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СправочникНоменклатураЗапись", 1.5);  
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СправочникНомераГТДЗапись", 1);  
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СправочникФизическиеЛицаЗапись", 1);  
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ВремяОткрытияИнформацииПриЗапуске", 5);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОбщееВремяЗапускаПриложения", 5);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОбщаяФормаФормаПодбора", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОбщаяФормаФормаПодбораОстаткиРезервыЦены", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыОбработкаБанкИКасса", 2);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "РасчетАвтоматическихСкидок", 0.5);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "РегистрСведенийЦеныНоменклатурыЗаписьИнтерактивно", 5);
		
	///////////////////////
	// Отборы
	
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СписокДисконтныхКартОтборВидКарты", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СписокДисконтныхКартОтборВидКарты", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СписокДисконтныхКартОтборВидКарты", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СписокДисконтныхКартОтборВладелецКарты", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СписокДисконтныхКартОтборМагнитныйКод", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СписокДисконтныхКартОтборМагнитныйКод", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СписокДисконтныхКартОтборШтрихКод", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СписокДисконтныхКартОтборШтрихКод", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СписокДокументовЗаказПокупателяОтборОтветственный", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СписокИсторииРаботыСКлиентомБанка", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СписокИсторииРаботыСКлиентомБанка", 1);
	
	///////////////////////
	// Справочники
	
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыСправочникБанковскиеСчета", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыСправочникБанковскиеСчета", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыСправочникВидыЦен", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыСправочникВидыЦен", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыСправочникДисконтныеКарты", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыСправочникДисконтныеКарты", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыСправочникДоговорыКонтрагентов", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыСправочникДоговорыКонтрагентов", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыСправочникКатегорииНоменклатуры", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыСправочникКатегорииНоменклатуры", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыСправочникНоменклатура", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыСправочникНоменклатура", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыСправочникОрганизации", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыСправочникОрганизации", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ЗаписьСправочникОрганизации", 2);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыСправочникПрайсЛисты", 2);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыСправочникПрайсЛисты", 2);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыСправочникСотрудники", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыСправочникСотрудники", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ЗаписьСправочникСотрудники", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыСправочникСтруктурныеЕдиницы", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыСправочникСтруктурныеЕдиницы", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыСправочникФизическиеЛица", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыСправочникФизическиеЛица", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыСправочникХарактеристикиНоменклатуры", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыСправочникХарактеристикиНоменклатуры", 1);
	
	///////////////////////
	// Журналы документов
	
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ЖурналДокументыПоБанку", 1.5);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ЖурналДокументыПоВнеоборотнымАктивам", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ЖурналДокументыПоЗакупкам", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ЖурналДокументыПоЗапасам", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ЖурналДокументыПоЗарплате", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ЖурналДокументыПоКадрам", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ЖурналДокументыПоКассе", 1.5);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ЖурналДокументыПоКонтрагенту", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ЖурналДокументыПоПродажам", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ЖурналДокументыПоПроизводству", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ЖурналДокументыПоСкладу", 1);
	
	///////////////////////
	// Документы
	                             
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументАвансовыйОтчет", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументАвансовыйОтчет", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументАвансовыйОтчет", 2);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументАктВыполненныхРабот", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументАктВыполненныхРабот", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументАктВыполненныхРабот", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументДополнительныеРасходы", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументДополнительныеРасходы", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументДополнительныеРасходы", 2);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументЗаданиеНаРаботу", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументЗаданиеНаРаботу", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументЗаданиеНаРаботу", 2);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументЗаказНаПроизводство", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументЗаказНаПроизводство", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументЗаказНаПроизводство", 2);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументЗаказПокупателя", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументЗаказПокупателя", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументЗаказПокупателя", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументЗаказНаряд", 3);
	
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыЗаказНаряда", 1.5);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыЗаказНаряда", 2);
	
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументЗаказПоставщику", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументЗаказПоставщику", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументЗаказПоставщику", 2);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументЗакрытиеМесяца", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументЗакрытиеМесяца", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументЗакрытиеМесяца", 3600);
	
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументИнвентаризацияЗапасов", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументИнвентаризацияЗапасов", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументИнвентаризацияЗапасов", 3);
	
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументКорректировкаПриходнаяНакладная", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументКорректировкаПриходнаяНакладная", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументКорректировкаПриходнаяНакладная", 3);
	
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументКорректировкаРасходнаяНакладная", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументКорректировкаРасходнаяНакладная", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументКорректировкаРасходнаяНакладная", 3);
	
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументОперацияПоПлатежнымКартам", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументОперацияПоПлатежнымКартам", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументОперацияПоПлатежнымКартам", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументОприходованиеЗапасов", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументОприходованиеЗапасов", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументОприходованиеЗапасов", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументОтчетКомиссионера", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументОтчетКомиссионера", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументОтчетКомиссионера", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументОтчетКомитенту", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументОтчетКомитенту", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументОтчетКомитенту", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументОтчетОПереработке", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументОтчетОПереработке", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументОтчетОПереработке", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументОтчетОРозничныхПродажах", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументОтчетОРозничныхПродажах", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументОтчетОРозничныхПродажах", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументОтчетПереработчика", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументОтчетПереработчика", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументОтчетПереработчика", 3);
	
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументПеремещениеДС", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументПеремещениеДС", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументПеремещениеДС", 3);
	
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументПеремещениеЗапасов", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументПеремещениеЗапасов", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументПеремещениеЗапасов", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументПеремещениеПоЯчейкам", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументПеремещениеПоЯчейкам", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументПеремещениеПоЯчейкам", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументПлатежноеПоручение", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументПлатежноеПоручение", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументПлатежноеПоручение", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументПоступлениеВКассу", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументПоступлениеВКассу", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументПоступлениеВКассу", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументПоступлениеНаСчет", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументПоступлениеНаСчет", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументПоступлениеНаСчет", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументПриходнаяНакладная", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументПриходнаяНакладная", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументПриходнаяНакладная", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументПриходныйОрдер", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументПриходныйОрдер", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументПриходныйОрдер", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументРаспределениеЗатрат", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументРаспределениеЗатрат", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументРаспределениеЗатрат", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументРасходИзКассы", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументРасходИзКассы", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументРасходИзКассы", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументРасходнаяНакладная", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументРасходнаяНакладная", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументРасходнаяНакладная", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументРасходныйОрдер", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументРасходныйОрдер", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументРасходныйОрдер", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументРасходСоСчета", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументРасходСоСчета", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументРасходСоСчета", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументРезервированиеЗапасов", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументРезервированиеЗапасов", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументРезервированиеЗапасов", 3);
	
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументСверкаВзаиморасчетов", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументСверкаВзаиморасчетов", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументСверкаВзаиморасчетов", 2);
	
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументСборкаЗапасов", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументСборкаЗапасов", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументСборкаЗапасов", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументСдельныйНаряд", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументСдельныйНаряд", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументСдельныйНаряд", 2);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументСобытие", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументСобытие", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументСписаниеЗапасов", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументСписаниеЗапасов", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументСписаниеЗапасов", 2);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументСчетНаОплату", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументСчетНаОплату", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументСчетНаОплату", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументСчетНаОплатуПоставщика", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументСчетНаОплатуПоставщика", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументСчетНаОплатуПоставщика", 2);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументСчетФактура", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументСчетФактура", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументСчетФактура", 2);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументСчетФактураПолученный", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументСчетФактураПолученный", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументСчетФактураПолученный", 2);
	
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументУчетВремени", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументУчетВремени", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументУчетВремени", 3);	
	
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументЧекККМ", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументЧекККМ", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументЧекККМ", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПробитьЧекДокументЧекККМ", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПробитьЧекДокументЧекККМ_РМК", 3);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ОткрытиеФормыДокументЧекККМВозврат", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "СозданиеФормыДокументЧекККМВозврат", 1);
	ДобавитьЦелевоеВремя(КлючевыеОперации, "ПроведениеДокументЧекККМВозврат", 3);	

	///////////////////////
	// Отчеты - автоматически по 1 сек
	///////////////////////
	
КонецПроцедуры

Процедура ДобавитьЦелевоеВремя(КлючевыеОперации, ИмяКлючевойОперации, ЦелевоеВремя)

	КлючевыеОперации.Вставить(ИмяКлючевойОперации, ЦелевоеВремя);

КонецПроцедуры 

Функция СоздатьИЗаполнитьЦелевоеВремяКлючевойОперации(ИмяКлючевойОперации, ЦелевоеВремя = 1, ВыполненаСОшибкой = Ложь)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КлючевыеОперации.Ссылка КАК Ссылка,
	|	КлючевыеОперации.ЦелевоеВремя КАК ЦелевоеВремя
	|ИЗ
	|	Справочник.КлючевыеОперации КАК КлючевыеОперации
	|ГДЕ
	|	КлючевыеОперации.ИмяХеш = &ИмяХеш
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка";
	
	ХешMD5 = Новый ХешированиеДанных(ХешФункция.MD5);
	ХешMD5.Добавить(ИмяКлючевойОперации);
	ИмяХеш = ХешMD5.ХешСумма;
	ИмяХеш = СтрЗаменить(Строка(ИмяХеш), " ", "");			   
	
	Запрос.УстановитьПараметр("ИмяХеш", ИмяХеш);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Наименование = РазложитьСтрокуПоСловам(ИмяКлючевойОперации);
		
		НовыйЭлемент = Справочники.КлючевыеОперации.СоздатьЭлемент();
		НовыйЭлемент.Имя = ИмяКлючевойОперации;
		НовыйЭлемент.Наименование = Наименование;
		НовыйЭлемент.ЦелевоеВремя = ЦелевоеВремя;
		НовыйЭлемент.ВыполненаСОшибкой = ВыполненаСОшибкой;
		
		НовыйЭлемент.Записать();
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		Если Выборка.ЦелевоеВремя <> ЦелевоеВремя Тогда
			ОперацияОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ОперацияОбъект.ЦелевоеВремя = ЦелевоеВремя;
			
			ОперацияОбъект.Записать();
		КонецЕсли; 
	КонецЕсли;
	
КонецФункции

Функция РазложитьСтрокуПоСловам(Знач Строка)
	
	МассивСлов = Новый Массив;
	
	ПозицииСлов = Новый Массив;
	Для ПозицияСимвола = 1 По СтрДлина(Строка) Цикл
		ТекСимвол = Сред(Строка, ПозицияСимвола, 1);
		Если ТекСимвол = ВРег(ТекСимвол) 
			И (ОценкаПроизводительностиКлиентСервер.ТолькоКириллицаВСтроке(ТекСимвол) 
				Или ОценкаПроизводительностиКлиентСервер.ТолькоЛатиницаВСтроке(ТекСимвол)) Тогда
			ПозицииСлов.Добавить(ПозицияСимвола);
		КонецЕсли;
	КонецЦикла;
	
	Если ПозицииСлов.Количество() > 0 Тогда
		ПредыдущаяПозиция = 0;
		Для Каждого Позиция Из ПозицииСлов Цикл
			Если ПредыдущаяПозиция > 0 Тогда
				Подстрока = Сред(Строка, ПредыдущаяПозиция, Позиция - ПредыдущаяПозиция);
				Если Не ПустаяСтрока(Подстрока) Тогда
					МассивСлов.Добавить(СокрЛП(Подстрока));
				КонецЕсли;
			КонецЕсли;
			ПредыдущаяПозиция = Позиция;
		КонецЦикла;
		
		Подстрока = Сред(Строка, Позиция);
		Если Не ПустаяСтрока(Подстрока) Тогда
			МассивСлов.Добавить(СокрЛП(Подстрока));
		КонецЕсли;
	КонецЕсли;
	
	Для Индекс = 1 По МассивСлов.ВГраница() Цикл
		МассивСлов[Индекс] = НРег(МассивСлов[Индекс]);
	КонецЦикла;
	
	Если МассивСлов.Количество() <> 0 Тогда
		Результат = СтрСоединить(МассивСлов, " ");
	Иначе
		Результат = Строка;
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

#КонецОбласти
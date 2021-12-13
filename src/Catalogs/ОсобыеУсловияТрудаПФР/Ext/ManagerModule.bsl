﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ВписатьКоды2015Года() Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОсобыеУсловияТрудаПФР.Ссылка,
	|	ОсобыеУсловияТрудаПФР.Код КАК КодДляОтчетности2002,
	|	ОсобыеУсловияТрудаПФР.Код КАК КодДляОтчетности2010,
	|	ОсобыеУсловияТрудаПФР.Код КАК КодДляОтчетности2015
	|ИЗ
	|	Справочник.ОсобыеУсловияТрудаПФР КАК ОсобыеУсловияТрудаПФР
	|ГДЕ
	|	ОсобыеУсловияТрудаПФР.КодДляОтчетности2010 = """"";
	Выборка = Запрос.Выполнить().Выбрать();
	Коды2002Года = КодыОсобыхУсловийТруда2002();
	Пока Выборка.Следующий() Цикл
	    Объект = Выборка.Ссылка.ПолучитьОбъект();
		Объект.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных", Истина);
		ЗаполнитьЗначенияСвойств(Объект, Выборка);
		Объект.КодДляОтчетности2015 = СтрЗаменить(Объект.КодДляОтчетности2015, "27", "30");
		Объект.КодДляОтчетности2015 = СтрЗаменить(Объект.КодДляОтчетности2015, "28", "32");
		Объект.КодДляОтчетности2002 = СокрЛП(Выборка.КодДляОтчетности2002);
		Если Коды2002Года[Объект.КодДляОтчетности2002] <> Неопределено Тогда 
			Объект.КодДляОтчетности2002 = Коды2002Года[Объект.КодДляОтчетности2002];
		КонецЕсли;
		Объект.Записать();
	КонецЦикла;
		
КонецПроцедуры	

Функция КодыОсобыхУсловийТруда2002() 
	
	КодыОсобыхУсловийТруда = Новый Соответствие;
	КодыОсобыхУсловийТруда.Вставить("27-ОС", "28-ОС");
	КодыОсобыхУсловийТруда.Вставить("27-ПЖ", "28-ПЖ");
	
	Возврат КодыОсобыхУсловийТруда;
	
КонецФункции

Процедура ЗаполнитьКоды2002Года() Экспорт 
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОсобыеУсловияТруда.Ссылка,
	               |	ОсобыеУсловияТруда.Код
	               |ИЗ
	               |	Справочник.ОсобыеУсловияТрудаПФР КАК ОсобыеУсловияТруда
	               |ГДЕ
	               |	ОсобыеУсловияТруда.КодДляОтчетности2002 = """"";
	
	РезультатЗапроса = Запрос.Выполнить();			   
				   
	Если РезультатЗапроса.Пустой() Тогда 
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Коды2002Года = КодыОсобыхУсловийТруда2002();
	
	Пока Выборка.Следующий() Цикл
		СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
		СправочникОбъект.КодДляОтчетности2002 = СокрЛП(Выборка.Код);
		Если Коды2002Года[СправочникОбъект.КодДляОтчетности2002] <> Неопределено Тогда 
			СправочникОбъект.КодДляОтчетности2002 = Коды2002Года[СправочникОбъект.КодДляОтчетности2002];
		КонецЕсли;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(СправочникОбъект);
	КонецЦикла;
		
КонецПроцедуры

Процедура ЗаполнитьКоды() Экспорт 
	ЗаполнитьКоды2002Года();
	ВписатьКоды2015Года();
КонецПроцедуры
#КонецОбласти

#КонецЕсли
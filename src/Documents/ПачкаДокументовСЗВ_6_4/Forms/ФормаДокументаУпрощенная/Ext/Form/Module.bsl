


#Область ОписаниеПеременных

&НаКлиенте
Перем НомерТекущейСтроиЗаписиОСтаже;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	ЗаписиОСтажеТекст = НСтр("ru = 'Записи о стаже:'");
	
	ОтчетныйПериодСтрока = УчетСтраховыхВзносов.ПредставлениеОтчетногоПериода(Объект.ОтчетныйПериод);
	
КонецПроцедуры


&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ДанныеФормыВОбъект(ТекущийОбъект);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбъектВДанныеФормы(ТекущийОбъект);
	
	УстановитьПредставлениеМесяцевЗаработкаСЗВ64(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КорректируемыйПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	УстановитьПредставлениеМесяцевЗаработкаСЗВ64(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ТипСведенийПриИзменении(Элемент)
	УстановитьПредставлениеМесяцевЗаработкаСЗВ64(ЭтаФорма);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ "СОТРУДНИКИ"

&НаКлиенте
Процедура СотрудникПриАктивизацииСтроки(Элемент)
	ДокументыСЗВСотрудникиПриАктивацииСтроки(Элементы.Сотрудники, ТекущийСотрудник, Элементы.ЗаписиОСтаже);
	УстановитьПредставлениеМесяцевЗаработкаСЗВ64(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Не ТолькоПросмотр И Поле.Имя = "СотрудникиФизическоеЛицо" Тогда
		ТекущиеДанныеСтроки = Элементы.Сотрудники.ТекущиеДанные;
		Если ТекущиеДанныеСтроки <> Неопределено Тогда
			ПоказатьЗначение(, ТекущиеДанныеСтроки.Сотрудник);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Если Копирование Тогда
		Отказ = Истина;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписиОСтажеПередНачаломИзменения(Элемент, Отказ)
	НомерТекущейСтроиЗаписиОСтаже = Элементы.ЗаписиОСтаже.ТекущиеДанные.НомерСтроки;
КонецПроцедуры

&НаКлиенте
Процедура ЗаписиОСтажеПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ДанныеТекущейСтроки = Элементы.Сотрудники.ТекущиеДанные;
		Если ДанныеТекущейСтроки <> Неопределено Тогда
			Элементы.ЗаписиОСтаже.ТекущиеДанные.Сотрудник = ДанныеТекущейСтроки.Сотрудник;
			СтруктураПоиска = Новый Структура("Сотрудник", ДанныеТекущейСтроки.Сотрудник);
			
			СтрокиСтажаПоСотруднику = Объект.ЗаписиОСтаже.НайтиСтроки(СтруктураПоиска); 
			НомерОсновнойЗаписи =0;
			
			Для Каждого СтрокаСтажа Из СтрокиСтажаПоСотруднику Цикл
				НомерОсновнойЗаписи = НомерОсновнойЗаписи +1;
				СтрокаСтажа.НомерОсновнойЗаписи = НомерОсновнойЗаписи;
			КонецЦикла;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ЗаписиОСтажеПослеУдаления(Элемент)
	ДанныеТекущейСтроки = Элементы.Сотрудники.ТекущиеДанные;
	Если ДанныеТекущейСтроки <> Неопределено Тогда
		Элементы.ЗаписиОСтаже.ТекущиеДанные.Сотрудник = ДанныеТекущейСтроки.Сотрудник;
		СтруктураПоиска = Новый Структура("Сотрудник", ДанныеТекущейСтроки.Сотрудник);
		
		СтрокиСтажаПоСотруднику = Объект.ЗаписиОСтаже.НайтиСтроки(СтруктураПоиска); 
		НомерОсновнойЗаписи =0;
		
		Для Каждого СтрокаСтажа Из СтрокиСтажаПоСотруднику Цикл
			НомерОсновнойЗаписи = НомерОсновнойЗаписи +1;
			СтрокаСтажа.НомерОсновнойЗаписи = НомерОсновнойЗаписи;
		КонецЦикла;
		
	КонецЕсли;
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПредставлениеМесяцевЗаработкаСЗВ64(Форма)
	
	Если Форма.Объект.ТипСведенийСЗВ = ПредопределенноеЗначение("Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ") Тогда
		ПериодДокумента = Форма.Объект.ОтчетныйПериод;
	Иначе
		ПериодДокумента = Форма.Объект.КорректируемыйПериод;
	КонецЕсли;
	
	Если Форма.Элементы.Сотрудники.ТекущаяСтрока <> Неопределено Тогда 
		ДанныеТекущейСтрокиСотрудник = Форма.Объект.Сотрудники.НайтиПоИдентификатору(Форма.Элементы.Сотрудники.ТекущаяСтрока);
	КонецЕсли;	
	
	Если ДанныеТекущейСтрокиСотрудник <> Неопределено Тогда
		Для Каждого СтрокаЗаработок Из ДанныеТекущейСтрокиСотрудник.СведенияОЗаработке Цикл
			СтрокаЗаработок.МесяцПредставление = Формат(Дата(2013, СтрокаЗаработок.Месяц + Месяц(ПериодДокумента) - 1, 1), "ДФ=ММММ");	
		КонецЦикла;
	КонецЕсли;	
КонецПроцедуры	

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)	
	
	ОбъектВДанныеФормы(ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбъектВДанныеФормы(ТекущийОбъект)
	СтрокиПоСотрудникам = Новый Соответствие;
	
	Для Каждого СтрокаСотрудник Из Объект.Сотрудники Цикл
		СтрокаСотрудник.СведенияОЗаработке.Очистить();
		
		СтрокиПоСотрудникам.Вставить(СтрокаСотрудник.Сотрудник, СтрокаСотрудник);	
		
		Для НомерМесяца = 1 По 3 Цикл
			СтрокаЗаработок = СтрокаСотрудник.СведенияОЗаработке.Вставить(НомерМесяца - 1);
			СтрокаЗаработок.Месяц = НомерМесяца;	
		КонецЦикла;	
	КонецЦикла;	
	
	Для Каждого СтрокаЗаработок Из Объект.СведенияОЗаработке Цикл
		Если СтрокаЗаработок.Месяц > 0
			И СтрокаЗаработок.Месяц < 4 Тогда
		
			СтрокаПоСотруднику = СтрокиПоСотрудникам[СтрокаЗаработок.Сотрудник];	
			Если СтрокаПоСотруднику <> Неопределено Тогда
				СтрокаЗаработокПоСотруднику = СтрокаПоСотруднику.СведенияОЗаработке[СтрокаЗаработок.Месяц - 1];
				ЗаполнитьЗначенияСвойств(СтрокаЗаработокПоСотруднику, СтрокаЗаработок);
			КонецЕсли;	
		КонецЕсли;	
	КонецЦикла;		
КонецПроцедуры	

&НаСервере
Процедура ДанныеФормыВОбъект(ТекущийОбъект)
	ТекущийОбъект.СведенияОЗаработке.Очистить();
	
	Для Каждого СтрокаСотрудник Из Объект.Сотрудники Цикл
		Для Каждого СтрокаЗаработокПоСотруднику Из СтрокаСотрудник.СведенияОЗаработке Цикл
			Если СтрокаСведенийОЗаработкеЗаполнена(СтрокаЗаработокПоСотруднику) Тогда
				СтрокаЗаработок = ТекущийОбъект.СведенияОЗаработке.Добавить();	
				ЗаполнитьЗначенияСвойств(СтрокаЗаработок, СтрокаЗаработокПоСотруднику);
				СтрокаЗаработок.Сотрудник = СтрокаСотрудник.Сотрудник;
			КонецЕсли;	
		КонецЦикла;	
	КонецЦикла;	
КонецПроцедуры	

&НаСервере 
Функция СтрокаСведенийОЗаработкеЗаполнена(СтрокаЗаработок)
	Если СтрокаЗаработок.Заработок <> 0
		Или СтрокаЗаработок.ОблагаетсяВзносамиДоПредельнойВеличины <> 0
		Или СтрокаЗаработок.ОблагаетсяВзносамиСвышеПредельнойВеличины <> 0
        Или СтрокаЗаработок.ОблагаетсяВзносамиЗаЗанятыхНаПодземныхИВредныхРаботах <> 0
		Или СтрокаЗаработок.ОблагаетсяВзносамиЗаЗанятыхНаТяжелыхИПрочихРаботах <> 0 Тогда
		
		Возврат Истина;
	КонецЕсли;	

	Возврат Ложь;		
КонецФункции	


&НаКлиенте
Процедура ПосмотретьСЗВ64(Команда)
	
	Если Модифицированность И Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	МассивОбъектов = Новый Массив;
	МассивОбъектов.Добавить(Объект.Ссылка);
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.ПачкаДокументовСЗВ_6_4", "ФормаСЗВ_6_4", МассивОбъектов, ЭтаФорма, Новый Структура());
	
КонецПроцедуры

&НаКлиенте
Процедура ПосмотретьАДВВ65(Команда)
	
	Если Модифицированность И Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	МассивОбъектов = Новый Массив;
	МассивОбъектов.Добавить(Объект.Ссылка);
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.ПачкаДокументовСЗВ_6_4", "ФормаАДВ_6_5", МассивОбъектов, ЭтаФорма, Новый Структура());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если Записать(Новый Структура("РежимЗаписи ",РежимЗаписиДокумента.Проведение)) Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ДокументыСЗВСотрудникиПриАктивацииСтроки(ЭлементФормыСотрудники, ТекущийСотрудник, ЭлементФормыЗаписиОСтаже = Неопределено) 
	
	ТекущиеДанныеСтроки =  ЭлементФормыСотрудники.ТекущиеДанные;
	
	Если ТекущиеДанныеСтроки <> Неопределено Тогда
		ТекущийСотрудник = ТекущиеДанныеСтроки.Сотрудник;
		Если ЭлементФормыЗаписиОСтаже <> Неопределено Тогда
			СтруктураОтбора = Новый ФиксированнаяСтруктура("Сотрудник", ТекущиеДанныеСтроки.Сотрудник);
			ЭлементФормыЗаписиОСтаже.ОтборСтрок = СтруктураОтбора;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры



#КонецОбласти

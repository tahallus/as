﻿#Область ПрограммныйИнтерфейс

Процедура ДокументОснованиеНадписьОбработкаНавигационнойСсылки(Форма, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "удалить" Тогда
		
		Форма.Объект.ДокументОснование = Неопределено;
		Форма.Элементы.ДокументОснованиеНадпись.Заголовок = РаботаСФормойДокументаКлиентСервер.СформироватьНадписьДокументОснование(Неопределено);
		Форма.Модифицированность = Истина;
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "заполнить" Тогда
		
		ЗаполнитьПоОснованиюНачало(Форма);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "выбрать" Тогда
		
		//Выбрать основание
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыборТипаОснованияЗавершение", Форма);
		ДополнительныеПараметры = Новый Структура;
		Если ФормыДокументовДеньгиКлиентСервер.ЭтоПоступлениеВКассу(Форма) Тогда
			ДополнительныеПараметры.Вставить("НовыйМеханизмИнкассации", Форма.Объект.НовыйМеханизмИнкассации);
			ДополнительныеПараметры.Вставить("КассаККМ", Форма.Объект.КассаККМ);
		КонецЕсли;
		
		СписокОснований = ФормыДокументовДеньгиВызовСервера.ПолучитьСписокДляВыбораДокументаОснования(Форма.ИмяФормы, Форма.Объект.ВидОперации, ДополнительныеПараметры);
		
		Форма.ПоказатьВыборИзМеню(ОписаниеОповещения, СписокОснований, Элемент);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "открыть" Тогда
		
		РаботаСФормойДокументаКлиент.ОткрытьФормуДокументаПоСсылке(Форма.Объект.ДокументОснование);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоОснованиюНачало(Форма) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьПоОснованиюЗавершение", Форма);
	ПоказатьВопрос(
		ОписаниеОповещения, 
		НСтр("ru = 'Заполнить документ по выбранному основанию?'"), 
		РежимДиалогаВопрос.ДаНет, 0);
	
КонецПроцедуры

Процедура ШапкаТабличнаяЧасть(Форма) Экспорт
	
	Объект = Форма.Объект;
	ПараметрыДиалога = Новый Структура;
	ПараметрыФормы = Новый Структура;
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеНаСчет.ПоступлениеОплатыПоКартам")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходСоСчета.ВозвратОплатыНаПлатежныеКарты") Тогда
		
		ПараметрыФормы.Вставить("ПоложениеНастроекНалоговогоУчета", Объект.ПоложениеНастроекНалоговогоУчета);
		ПараметрыФормы.Вставить("ПоложениеЭквайринговогоТерминала", Объект.ПоложениеЭквайринговогоТерминала);
		ПараметрыФормы.Вставить("ДоговорЭквайринга", 				Форма.ДоговорЭквайринга);
		
	КонецЕсли;
	
	ПараметрыФормы.Вставить("ПоложениеСтатьи", Объект.ПоложениеСтатьи);
	ПараметрыФормы.Вставить("ПоложениеПроекта", Объект.ПоложениеПроекта);
	ПараметрыФормы.Вставить("ПоложениеПодразделения", Объект.ПоложениеПодразделения);
	
	// Для данных видов операций пока не поддерживается переключение положения статьи
	Если    Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеНаСчет.ПоступлениеОплатыПоКартам")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеНаСчет.ПоступлениеОплатыПоКредитам")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходСоСчета.ВозвратОплатыНаПлатежныеКарты")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходСоСчета.ВозвратПродажиВКредит")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходСоСчета.Зарплата")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходИзКассы.Зарплата")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПлатежноеПоручение.Зарплата")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПлатежноеПоручение.ПеречислениеНалога") Тогда
		
		ПараметрыФормы.Удалить("ПоложениеСтатьи");
		
	КонецЕсли;
	
	ФормыДокументовДеньгиВызовСервера.ЗаполнитьПараметрыДиалогаШапкаТабличнаяЧасть(ПараметрыФормы, ПараметрыДиалога);
	
	ОткрытьФорму(
	"ОбщаяФорма.ШапкаТабличнаяЧасть",
	ПараметрыДиалога,,,,,
	Новый ОписаниеОповещения("ШапкаТабличнаяЧастьЗавершение", Форма));
	
КонецПроцедуры

Процедура СтатьяПриИзменении(Форма) Экспорт
	
	Объект = Форма.Объект;
	
	Если ЗначениеЗаполнено(Объект.Статья) Тогда
		Объект.УчитыватьВНУ = ФормыДокументовДеньгиВызовСервера.СтатьяУчитываетсяВНУ(Объект.Статья, Объект.Организация, Объект.Дата, Объект.ВидОперации);
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#КонецОбласти
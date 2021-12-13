﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура СоздатьИзменитьНовость(СсылкаНаНовость, Заголовок, Сообщение, Получатели, Страница, ДатаИВремяОтправкиPushУведомления, ПодробнаяНовость) Экспорт
	
	Если СсылкаНаНовость = Неопределено Тогда
		Новость = Справочники.НовостиМЛК.СоздатьЭлемент();
	Иначе
		Новость = СсылкаНаНовость.ПолучитьОбъект();
	КонецЕсли;
	
	ТекущаяДата = ТекущаяДатаСеанса();
	
	Новость.Наименование = Заголовок;
	Новость.Сообщение = Сообщение;
	Новость.СтраницаДляМЛК = Новый ХранилищеЗначения(Страница, Новый СжатиеДанных(9));
	Новость.Получатели = Новый ХранилищеЗначения(Получатели, Новый СжатиеДанных(9));
	Новость.ДатаИВремяОтправкиPushУведомления = ДатаИВремяОтправкиPushУведомления;
	Новость.ПодробнаяНовость = Новый ХранилищеЗначения(ПодробнаяНовость, Новый СжатиеДанных(9));
	Новость.ДатаИзменения = ТекущаяДата;
	
	Новость.Записать();
	
	РегистрыСведений.НовостиМЛКДляОтправки.ЗаписатьНовостьДляОтправки(Новость.Ссылка.УникальныйИдентификатор(), ТекущаяДата);
	
КонецПроцедуры


Процедура ПометитьНаУдалениеНовость(Ссылка) Экспорт

	Новость = Ссылка.ПолучитьОбъект();
	Новость.ПометкаУдаления = Истина;
	Новость.Записать();
	
	РегистрыСведений.НовостиМЛКДляОтправки.ЗаписатьНовостьДляОтправки(Новость.Ссылка.УникальныйИдентификатор(), ТекущаяДатаСеанса());
	
КонецПроцедуры


Процедура ОтметитьОтправленныеНовости() Экспорт

	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//	"ВЫБРАТЬ
	//	|	НовостиМЛК.Ссылка КАК Ссылка
	//	|ИЗ
	//	|	Справочник.НовостиМЛК КАК НовостиМЛК
	//	|ГДЕ
	//	|	НЕ НовостиМЛК.ОтправленоВШину";
	//
	//РезультатЗапроса = Запрос.Выполнить();
	//
	//ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	//
	//Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	//	Новость = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
	//	Новость.ОтправленоВШину = Истина;
	//	Новость.Записать();
	//КонецЦикла;
	
	

КонецПроцедуры


#КонецОбласти

#КонецЕсли
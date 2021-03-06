
#Область ПрограммныйИнтерфейс

Функция ПолучитьСписокДляВыбораДокументаОснования(ИмяФормы, ВидОперации, ДополнительныеПараметры = Неопределено) Экспорт
	
	Возврат ФормыДокументовДеньги.ПолучитьСписокДляВыбораДокументаОснования(ИмяФормы, ВидОперации, ДополнительныеПараметры);
	
КонецФункции

Процедура ЗаполнитьПараметрыДиалогаШапкаТабличнаяЧасть(ПараметрыФормы, ПараметрыДиалога) Экспорт
	
	ФормыДокументовДеньги.ЗаполнитьПараметрыДиалогаШапкаТабличнаяЧасть(ПараметрыФормы, ПараметрыДиалога);
	
КонецПроцедуры

Функция СтатьяУчитываетсяВНУ(Статья, Организация, Дата, ВидОперации) Экспорт
	
	Возврат РегламентированнаяОтчетностьУСН.НужноУчитыватьВНУ(Статья, ВидОперации, Организация, Дата);
	
КонецФункции

#КонецОбласти
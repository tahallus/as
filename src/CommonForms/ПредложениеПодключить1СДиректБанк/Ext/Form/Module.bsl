﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Организация", Организация);
	Параметры.Свойство("Банк", Банк);
	
	Если НЕ ЗначениеЗаполнено(Организация) И НЕ ЗначениеЗаполнено(Банк) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
		
	ТекстЗаголовка = НСтр("ru = 'С банком %1 можно обмениваться платежными документами в электронном виде.'");
	Элементы.ДекорацияПроверка.Заголовок = СтрШаблон(ТекстЗаголовка, Строка(Банк));
	
	Элементы.ГруппаГоризонтальныйБаннерДиректБанк.Видимость = Ложь;
	Элементы.ГруппаВертикальныйБаннерДиректБанк.Видимость   = Ложь;
	Элементы.ГруппаДиректБанкВФормеБанковскиеСчетаОрганизации.Видимость = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияЗаголовокНажатие(Элемент)
	
	ПерейтиПоНавигационнойСсылке("http://www.v8.1c.ru/edi/edi_app/bank/?utm_source=led&utm_campaign=2017&utm_medium=appadv");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодключитьсяК1СДиректБанк(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", Организация);
	ПараметрыФормы.Вставить("Банк", Банк);
	
	ОткрытьФорму("Справочник.НастройкиОбменСБанками.Форма.ПомощникСозданияНастройкиОбмена", ПараметрыФормы);
	Закрыть();
	
КонецПроцедуры

#КонецОбласти


﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	Если ПараметрыВыполненияКоманды.Источник=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыВыполненияКоманды.Источник.ИмяФормы = "Справочник.Номенклатура.Форма.ФормаСписка"
		ИЛИ ПараметрыВыполненияКоманды.Источник.ИмяФормы = "Справочник.Номенклатура.Форма.ФормаКорзина" Тогда
		НоменклатураВДокументахКлиент.ОформитьДокументСТоварамиИзКорзины(ПараметрыВыполненияКоманды.Источник, "РасходнаяНакладная");
	ИначеЕсли Лев(ПараметрыВыполненияКоманды.Источник.ИмяФормы,17) = "ЖурналДокументов." Тогда
		СтруктураПараметров = Новый Структура();
		РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ПараметрыВыполненияКоманды.Источник.ДанныеМеток, СтруктураПараметров, "Контрагент");
		РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ПараметрыВыполненияКоманды.Источник.ДанныеМеток, СтруктураПараметров, "СтруктурнаяЕдиница");
		РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ПараметрыВыполненияКоманды.Источник.ДанныеМеток, СтруктураПараметров, "ВидОперации");
		РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ПараметрыВыполненияКоманды.Источник.ДанныеМеток, СтруктураПараметров, "Организация");
			
		ОткрытьФорму("Документ.РасходнаяНакладная.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения",СтруктураПараметров));
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти 


﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	РазделительНомераСтроки = "___";
	УведомлениеЗаполненоВПомощнике = Ложь;
	Данные = Неопределено;
	Параметры.Свойство("Данные", Данные);
	
	Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УменьшениеНалогаНаСтраховыеВзносы;
	УведомлениеОСпецрежимахНалогообложения.НачальныеОперацииПриСозданииНаСервере(ЭтотОбъект);
	УведомлениеОСпецрежимахНалогообложения.СформироватьСпискиВыбора(ЭтотОбъект, "СпискиВыбора2021_1");
	
	Если ТипЗнч(Данные) = Тип("Структура") Тогда
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
		УведомлениеОСпецрежимахНалогообложения.ЗагрузитьДанныеПростогоУведомления(ЭтотОбъект, Данные, ПредставлениеУведомления)
	ИначеЕсли Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Организация = Параметры.Ключ.Организация;
		ЗагрузитьДанные(Параметры.Ключ);
	ИначеЕсли Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		Объект.Организация = Параметры.ЗначениеКопирования.Организация;
		ЗагрузитьДанные(Параметры.ЗначениеКопирования);
	ИначеЕсли Параметры.Свойство("ПредставлениеXML") Тогда 
		Параметры.Свойство("РегистрацияВНалоговомОргане", Объект.РегистрацияВИФНС);
		Параметры.Свойство("Организация", Объект.Организация);
		ЗагрузитьИзXMLНаСервере(Новый Структура("Организация, РегистрацияВНалоговомОргане, ПредставлениеXML", 
								Объект.Организация, Объект.РегистрацияВИФНС, Параметры.ПредставлениеXML));
	ИначеЕсли Параметры.Свойство("ДанныеПомощника") Тогда
		Параметры.ДанныеПомощника.Свойство("Организация", Объект.Организация);
		Параметры.ДанныеПомощника.Свойство("РегистрацияВИФНС", Объект.РегистрацияВИФНС);
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
		ЗаполнитьНачальныеДанные();
		ЗаполнитьУведомлениеДаннымиПомощника(Параметры.ДанныеПомощника.ДанныеЗаполнения);
		Модифицированность = Истина;
	Иначе
		Параметры.Свойство("Организация", Объект.Организация);
		Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Объект.Организация);
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
		ЗаполнитьНачальныеДанные();
	КонецЕсли;
	
	ДанныеУведомления.ЛистБ.ОбщСумСВУменУчт = ОТЧ.ПривестиЗначение(ДанныеУведомления.ЛистБ.ОбщСумСВУменУчт);
	ДанныеУведомления.ЛистБ.СумСВОст = ОТЧ.ПривестиЗначение(ДанныеУведомления.ЛистБ.СумСВОст);
	
	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтотОбъект);
	Заголовок = УведомлениеОСпецрежимахНалогообложения.ДополнитьЗаголовокУведомления(Заголовок, Объект.Организация);
	ИдДляСвор = УведомлениеОСпецрежимахНалогообложения.ПолучитьИдентификаторыДляСворачивания(ЭтотОбъект);
	СворачиваемыеЭлементы = ПоместитьВоВременноеХранилище(ИдДляСвор);
	РучнойВвод = Ложь;
	ОТЧ = Новый ОписаниеТипов("Число");
	
	УправлениеФормой(ЭтотОбъект);
	УведомлениеОСпецрежимахНалогообложения.СпрятатьКнопкиВыгрузкиОтправкиУНеактуальныхФорм(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ПриЗакрытииНаСервере();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	РегламентированнаяОтчетностьКлиент.ПередЗакрытиемРегламентированногоОтчета(ЭтаФорма, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.ФормаРучнойВвод.Пометка = РучнойВвод;
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ЗаполнитьУведомлениеДаннымиПомощника(ДанныеПомощника)
	
	Для Каждого Элемент Из ДанныеПомощника.ЛистБ Цикл
		ДанныеУведомления.ЛистБ[Элемент.Ключ] = Элемент.Значение;
	КонецЦикла;
	
	ДанныеЛистовА = ПолучитьИзВременногоХранилища(ДанныеПомощника.ЛистА);
	
	Если ДанныеЛистовА.Количество() > 0 Тогда 
		ПрототипЛистаА = ДанныеМногостраничныхРазделов.ЛистА[0].Значение;
		СтрокиДерева = ДеревоСтраниц.ПолучитьЭлементы()[1].ПолучитьЭлементы();
		Пока СтрокиДерева.Количество() < ДанныеЛистовА.Количество() Цикл 
			ЗаполнитьЗначенияСвойств(СтрокиДерева.Добавить(), СтрокиДерева[0]);
			ДанныеМногостраничныхРазделов.ЛистА.Добавить(ОбщегоНазначения.СкопироватьРекурсивно(ПрототипЛистаА));
		КонецЦикла;
		
		Для Инд = 0 По ДанныеЛистовА.Количество() - 1 Цикл  
			УИД = Новый УникальныйИдентификатор;
			ЗаполнитьЗначенияСвойств(ДанныеМногостраничныхРазделов.ЛистА[Инд].Значение, ДанныеЛистовА[Инд]);
			ДанныеМногостраничныхРазделов.ЛистА[Инд].Значение.УИД = УИД;
			СтрокиДерева[Инд].УИД = УИД;
			СтрокиДерева[Инд].Наименование = "Стр. " + Формат((Инд + 1), "ЧГ=");
		КонецЦикла;
	КонецЕсли;
	
	ДанныеУведомления.Титульная.ГодДействПат = ДанныеПомощника.Титульная.ГодДействПат;
	ДанныеУведомления.Вставить("ДанныеПомощника", ДанныеПомощника);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНачальныеДанные() Экспорт
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная"];
	ДанныеУведомленияТитульный.Вставить("КодНО", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РегистрацияВИФНС, "Код"));
	Объект.ДатаПодписи = ТекущаяДатаСеанса();
	ДанныеУведомленияТитульный.Вставить("ДАТА_ПОДПИСИ", Объект.ДатаПодписи);
	
	СтрокаСведений = "ИННФЛ,ФИО,ТелДом,ФамилияИП,ИмяИП,ОтчествоИП";
	СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
	ДанныеУведомленияТитульный.Вставить("ИНН", СведенияОбОрганизации.ИННФЛ);
	ДанныеУведомленияТитульный.Вставить("Фамилия", СведенияОбОрганизации.ФамилияИП);
	ДанныеУведомленияТитульный.Вставить("Имя", СведенияОбОрганизации.ИмяИП);
	ДанныеУведомленияТитульный.Вставить("Отчество", СведенияОбОрганизации.ОтчествоИП);
	ДанныеУведомленияТитульный.Вставить("Тлф", СведенияОбОрганизации.ТелДом);
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.РегистрацияВИФНС, "Код,Представитель,ДокументПредставителя");
	ДанныеУведомленияТитульный.Вставить("КодНО", Реквизиты.Код);
	
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		УстановитьПредставителяПоФизЛицу(Реквизиты.Представитель);
		ДанныеУведомленияТитульный.Вставить("ПРИЗНАК_НП_ПОДВАЛ", "2");
		ДанныеУведомленияТитульный.Вставить("НаимДок", Реквизиты.ДокументПредставителя);
	Иначе
		ЕстьОбласть = (Неопределено <> ПредставлениеУведомления.Области.Найти("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
		Объект.ПодписантФамилия = СокрЛП(СведенияОбОрганизации.ФамилияИП);
		Объект.ПодписантИмя = СокрЛП(СведенияОбОрганизации.ИмяИП);
		Объект.ПодписантОтчество = СокрЛП(СведенияОбОрганизации.ОтчествоИП);
		ПодписантСтр = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
		ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ПодписантСтр);
		Если ЕстьОбласть Тогда 
			ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = ПодписантСтр;
		КонецЕсли;
		ДанныеУведомленияТитульный.Вставить("ПРИЗНАК_НП_ПОДВАЛ", "1");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоСтраниц() Экспорт
	ДеревоСтраниц.ПолучитьЭлементы().Очистить();
	КорневойУровень = ДеревоСтраниц.ПолучитьЭлементы();
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Титульная страница";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Титульная_2021";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Титульная";
	Стр001.МакетыПФ = "Печать_Форма2021_1_Титульная";
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Сведения о патентах";
	Стр001.ИндексКартинки = 1;
	Стр001.Многостраничность = Истина;
	Стр001.Многострочность = Истина;
	
	Стр0001 = Стр001.ПолучитьЭлементы().Добавить();
	Стр0001.Наименование = "Стр. 1";
	Стр0001.ИндексКартинки = 1;
	Стр0001.ИмяМакета = "ЛистА_2021";
	Стр0001.Многостраничность = Истина;
	Стр0001.Многострочность = Ложь;
	Стр0001.УИД = Новый УникальныйИдентификатор;
	Стр0001.ИДНаименования = "ЛистА";
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Лист Б";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "ЛистБ_2021";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "ЛистБ";
	Стр001.МакетыПФ = "Печать_Форма2021_1_ЛистБ";
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСтраницПриАктивизацииСтроки(Элемент)
	Если УИДТекущаяСтраница <> Элемент.ТекущиеДанные.УИД Тогда 
		ПредУИД = УИДТекущаяСтраница;
		
		УИДТекущаяСтраница = Элемент.ТекущиеДанные.УИД;
		ТекущееИДНаименования = Элемент.ТекущиеДанные.ИДНаименования;
		Если Не ЗначениеЗаполнено(ТекущееИДНаименования) Тогда 
			ТекущееИДНаименования = Элемент.ТекущиеДанные.ПолучитьЭлементы()[0].ИДНаименования;
			УИДТекущаяСтраница = Элемент.ТекущиеДанные.ПолучитьЭлементы()[0].УИД;
		КонецЕсли;
		
		Если Элемент.ТекущиеДанные.Многостраничность Тогда 
			ИмяМакета = УведомлениеОСпецрежимахНалогообложенияКлиент.ПолучитьИмяВыводимогоМакета(Элемент.ТекущиеДанные);
			ПоказатьТекущуюМногостраничнуюСтраницу(ИмяМакета, ПредУИД);
		Иначе 
			ПоказатьТекущуюСтраницу(Элемент.ТекущиеДанные.ИмяМакета, ПредУИД);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекущуюМногостраничнуюСтраницу(ИмяМакета, ПредУИД)
	ПредставлениеУведомления.Очистить();
	ТекущийМакет = ИмяМакета;
	Макет = Отчеты[Объект.ИмяОтчета].ПолучитьМакет(ИмяМакета);
	ПредставлениеУведомления.Вывести(Макет.ПолучитьОбласть("УправлениеСтраницами"));
	ПредставлениеУведомления.Вывести(Макет.ПолучитьОбласть("ОсновнаяЧасть"));
	УведомлениеОСпецрежимахНалогообложения.УстановитьФорматыВПолях(ЭтотОбъект);
	СтрДанных = Неопределено;
	Для Каждого Элт Из ДанныеМногостраничныхРазделов[ТекущееИДНаименования] Цикл 
		Если Элт.Значение.УИД = УИДТекущаяСтраница Тогда 
			СтрДанных = Элт.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Обл Из ПредставлениеУведомления.Области Цикл 
		Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник
			И Обл.СодержитЗначение Тогда 
			
			СтрДанных.Свойство(Обл.Имя, Обл.Значение);
		КонецЕсли;
	КонецЦикла;
	
	НайденнаяСтрока = УведомлениеОСпецрежимахНалогообложения.НайтиСтрокуВДеревеПоУИД(ДеревоСтраниц.ПолучитьЭлементы(), УИДТекущаяСтраница);
	Если НайденнаяСтрока <> Неопределено
		И НайденнаяСтрока.ПолучитьРодителя().ПолучитьЭлементы().Количество() = 1 Тогда 
		
		ПредставлениеУведомления.Области.УдалитьСтраницуЗначок.Текст = "";
		ПредставлениеУведомления.Области.УдалитьСтраницу.Текст = "";
		ПредставлениеУведомления.Области.УдалитьСтраницуЗначок.Гиперссылка = Ложь;
		ПредставлениеУведомления.Области.УдалитьСтраницуЗначок.Гиперссылка = Ложь;
		Элементы.ДеревоСтраницКонтекстноеМенюУдалитьСтраницу.Доступность = Ложь;
	Иначе
		Элементы.ДеревоСтраницКонтекстноеМенюУдалитьСтраницу.Доступность = Истина;
	КонецЕсли;
	
	Элементы.ДеревоСтраницКонтекстноеМенюДобавитьСтраницу.Видимость = Истина;
	Элементы.ДеревоСтраницКонтекстноеМенюУдалитьСтраницу.Видимость = Истина;
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекущуюСтраницу(ИмяМакета, ПредУИД)
	УведомлениеОСпецрежимахНалогообложения.ПоказатьТекущуюСтраницу(ЭтотОбъект, ИмяМакета, ПредУИД);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элемент, Область)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область, Истина);
	
	Если Область.Имя = "ДАТА_ПОДПИСИ" Тогда
		Объект.ДатаПодписи = Область.Значение;
		УстановитьДанныеПоРегистрацииВИФНС();
	ИначеЕсли Область.Имя = "ОбщСумУплСВ"
		Или Область.Имя = "СумСВУмНал"
		Или Область.Имя = "СумСВУменУчт" Тогда 
		
		Расчет();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Расчет()
	Сум50 = 0;
	Сум60 = 0;
	Для Каждого ЛистА Из ДанныеМногостраничныхРазделов.ЛистА Цикл 
		Сум50 = Сум50 + ОТЧ.ПривестиЗначение(ЛистА.Значение.СумСВУмНал);
		Сум60 = Сум60 + ОТЧ.ПривестиЗначение(ЛистА.Значение.СумСВУменУчт);
	КонецЦикла;
	
	ДанныеУведомления.ЛистБ.ОбщСумСВУмен = Сум50;
	ДанныеУведомления.ЛистБ.ОбщСумСВУменУчт = Сум60;
	ДанныеУведомления.ЛистБ.СумСВОст = ОТЧ.ПривестиЗначение(ДанныеУведомления.ЛистБ.ОбщСумУплСВ)
										- ОТЧ.ПривестиЗначение(ДанныеУведомления.ЛистБ.ОбщСумСВУмен)
										- ОТЧ.ПривестиЗначение(ДанныеУведомления.ЛистБ.ОбщСумСВУменУчт);
	
	Если ТекущееИДНаименования = "ЛистБ" Тогда 
		ПредставлениеУведомления.Области.ОбщСумСВУмен.Значение = ДанныеУведомления.ЛистБ.ОбщСумСВУмен;
		ПредставлениеУведомления.Области.ОбщСумСВУменУчт.Значение = ДанныеУведомления.ЛистБ.ОбщСумСВУменУчт;
		ПредставлениеУведомления.Области.СумСВОст.Значение = ДанныеУведомления.ЛистБ.СумСВОст;
	КонецЕсли;
	
	Модифицированность = Истина;
КонецПроцедуры

&НаСервере
Процедура УстановитьДанныеПоРегистрацииВИФНС()
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.РегистрацияВИФНС, "Код,Представитель,ДокументПредставителя");
	ПредставлениеУведомления.Области["КодНО"].Значение = Реквизиты.Код;
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		УстановитьПредставителяПоФизЛицу(Реквизиты.Представитель);
		ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение = "2";
		ПредставлениеУведомления.Области["НаимДок"].Значение = Реквизиты.ДокументПредставителя;
	Иначе
		Руководитель = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, "ФамилияИП,ИмяИП,ОтчествоИП");
		Объект.ПодписантФамилия = Руководитель.ФамилияИП;
		Объект.ПодписантИмя = Руководитель.ИмяИП;
		Объект.ПодписантОтчество = Руководитель.ОтчествоИП;
		
		УстановитьПредставителяПоОрганизации();
		ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение = "1";
		ПредставлениеУведомления.Области["НаимДок"].Значение = "";
	КонецЕсли;
	
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная"];
	ДанныеУведомленияТитульный.Вставить("ПРИЗНАК_НП_ПОДВАЛ", ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение);
	ДанныеУведомленияТитульный.Вставить("НаимДок", ПредставлениеУведомления.Области["НаимДок"].Значение);
	ДанныеУведомленияТитульный.Вставить("ДАТА_ПОДПИСИ", ПредставлениеУведомления.Области["ДАТА_ПОДПИСИ"].Значение);
	ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение);
	ДанныеУведомленияТитульный.Вставить("КодНО", ПредставлениеУведомления.Области["КодНО"].Значение);
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоФизЛицу(Физлицо)
	ЕстьОбласть = (Неопределено <> ПредставлениеУведомления.Области.Найти("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная"];
	Если ЗначениеЗаполнено(Физлицо) Тогда
		СведенияОПредставителе = РегламентированнаяОтчетностьВызовСервера.ПолучитьПоКодамСведенияОПредставителе(
			Объект.Организация, ДанныеУведомленияТитульный["КодНО"], "");
			
		Если ЗначениеЗаполнено(СведенияОПредставителе.НаименованиеОрганизацииПредставителя) Тогда 
			ПодписантСтр = СведенияОПредставителе.ФИОПредставителя;
			ФИО = РегламентированнаяОтчетность.РазложитьФИО(СведенияОПредставителе.ФИОПредставителя);
			Объект.ПодписантФамилия = СокрЛП(ФИО.Фамилия);
			Объект.ПодписантИмя = СокрЛП(ФИО.Имя);
			Объект.ПодписантОтчество = СокрЛП(ФИО.Отчество);
		Иначе
			ДанныеПредставителя = РегламентированнаяОтчетностьПереопределяемый.ПолучитьСведенияОФизЛице(Физлицо, , Объект.ДатаПодписи);
			Объект.ПодписантФамилия = СокрЛП(ДанныеПредставителя.Фамилия);
			Объект.ПодписантИмя = СокрЛП(ДанныеПредставителя.Имя);
			Объект.ПодписантОтчество = СокрЛП(ДанныеПредставителя.Отчество);
			ПодписантСтр = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
		КонецЕсли;
		ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ПодписантСтр);
		Если ЕстьОбласть Тогда 
			ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = ПодписантСтр;
		КонецЕсли;
	Иначе
		СтрокаСведений = "ФамилияИП,ИмяИП,ОтчествоИП";
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
		Объект.ПодписантФамилия = СведенияОбОрганизации.ФамилияИП;
		Объект.ПодписантИмя = СведенияОбОрганизации.ИмяИП;
		Объект.ПодписантОтчество = СведенияОбОрганизации.ОтчествоИП;
		ПодписантСтр = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
		ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ПодписантСтр);
		Если ЕстьОбласть Тогда 
			ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = ПодписантСтр;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоОрганизации()
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная"];
	ЕстьОбласть = (Неопределено <> ПредставлениеУведомления.Области.Найти("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
	ПодписантСтр = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
	ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ПодписантСтр);
	Если ЕстьОбласть Тогда 
		ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = ПодписантСтр;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СохранитьДанные() Экспорт
	Если ЗначениеЗаполнено(Объект.Ссылка) И Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Дата = ТекущаяДатаСеанса() 
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ИдентификаторыОбычныхСтраниц", ИдентификаторыОбычныхСтраниц);
	СтруктураПараметров.Вставить("ДеревоСтраниц", РеквизитФормыВЗначение("ДеревоСтраниц"));
	СтруктураПараметров.Вставить("ДанныеМногостраничныхРазделов", ДанныеМногостраничныхРазделов);
	СтруктураПараметров.Вставить("ДанныеУведомления", ДанныеУведомления);
	СтруктураПараметров.Вставить("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
	Документ.Записать();
	ЗначениеВДанныеФормы(Документ, Объект);
	Модифицированность = Ложь;
	ЭтотОбъект.Заголовок = СтрЗаменить(ЭтотОбъект.Заголовок, " (создание)", "");
	
	УведомлениеОСпецрежимахНалогообложения.СохранитьНастройкиРучногоВвода(ЭтотОбъект);
	РегламентированнаяОтчетность.СохранитьСтатусОтправкиУведомления(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыОповещенияОЗаписи(), Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанные(СсылкаНаДанные)
	
	СтруктураПараметров = СсылкаНаДанные.Ссылка.ДанныеУведомления.Получить();
	ДанныеУведомления = СтруктураПараметров.ДанныеУведомления;
	ДанныеМногостраничныхРазделов = СтруктураПараметров.ДанныеМногостраничныхРазделов;
	ЗначениеВРеквизитФормы(СтруктураПараметров.ДеревоСтраниц, "ДеревоСтраниц");
	СтруктураПараметров.Свойство("ИдентификаторыОбычныхСтраниц", ИдентификаторыОбычныхСтраниц);
	СтруктураПараметров.Свойство("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
	
	Попытка
		ФормаПомощника = "";
		Если ДанныеУведомления.Свойство("ДанныеПомощника") Тогда
			ФормаПомощника = СтрШаблон("Обработка.%1.Форма", ДанныеУведомления.ДанныеПомощника.ИмяПомощника);
			УведомлениеЗаполненоВПомощнике = Истина;
		КонецЕсли;
	Исключение
		Если Метаданные.Обработки.Найти("ПомощникЗаполненияУведомленияОбУменьшенииНалогаПоПатенту") <> Неопределено  Тогда
			ФормаПомощника = "Обработка.ПомощникЗаполненияУведомленияОбУменьшенииНалогаПоПатенту.Форма";
			УведомлениеЗаполненоВПомощнике = Истина;
		КонецЕсли;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтраницу(Команда)
	ДобавитьСтраницуНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтраницуНаСервере()
	НовИд = УведомлениеОСпецрежимахНалогообложения.ДобавитьСтраницуУведомления(ЭтотОбъект);
	Если НовИд <> Неопределено Тогда 
		Элементы.ДеревоСтраниц.ТекущаяСтрока = НовИд;
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтраницу(Команда = Неопределено) Экспорт
	УдалениеСтраницы = Истина;
	УдалитьСтраницуНаСервере();
	Расчет();
	УдалениеСтраницы = Ложь;
КонецПроцедуры

&НаСервере
Процедура УдалитьСтраницуНаСервере()
	НовИд = УведомлениеОСпецрежимахНалогообложения.УдалитьСтраницуНаСервере(ЭтотОбъект);
	Если НовИд <> Неопределено Тогда 
		Элементы.ДеревоСтраниц.ТекущаяСтрока = НовИд;
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры

&НаСервере
Процедура СкопироватьСтраницуНаСервере()
	НовИд = УведомлениеОСпецрежимахНалогообложения.КопироватьСтраницуУведомления(ЭтотОбъект, Истина);
	Если НовИд <> Неопределено Тогда 
		Элементы.ДеревоСтраниц.ТекущаяСтрока = НовИд;
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияВыбор(Элемент, Область, СтандартнаяОбработка)
	Если СтрЧислоВхождений(Область.Имя, "ДобавитьСтраницу") > 0 Тогда
		ДобавитьСтраницу(Неопределено);
		СтандартнаяОбработка = Ложь;
		Возврат;
	ИначеЕсли СтрЧислоВхождений(Область.Имя, "СкопироватьСтраницу") > 0 Тогда
		СкопироватьСтраницуНаСервере();
		Расчет();
		СтандартнаяОбработка = Ложь;
		Возврат;
	ИначеЕсли СтрЧислоВхождений(Область.Имя, "УдалитьСтраницу") > 0 Тогда
		УведомлениеОСпецрежимахНалогообложенияКлиент.УдалитьСтраницу(ЭтотОбъект);
		СтандартнаяОбработка = Ложь;
		Возврат;
	ИначеЕсли Область.Имя = "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ" Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуВыбораПодписантаЗавершение", ЭтотОбъект, Неопределено);
		РегламентированнаяОтчетностьКлиент.ОткрытьФормуВыбораФИО(ЭтотОбъект, СтандартнаяОбработка, "ПредставлениеУведомления",
																	"ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ОписаниеОповещения);
		Возврат;
	КонецЕсли;
	
	Если РучнойВвод Тогда 
		Возврат;
	КонецЕсли;
	
	Если СтандартнаяОбработка Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ПредставлениеУведомленияВыбор(ЭтотОбъект, Область, СтандартнаяОбработка, Истина);
	КонецЕсли;
	
	Если Область.Имя = "КодНО" Тогда 
		СтандартнаяОбработка = Ложь;
		ОбработкаКодаНО(Область.Имя);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКодаНО(Инфо)
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуВыбораРегистрацииВИФНС(ЭтотОбъект, Инфо);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКодаНОЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Инфо = ДополнительныеПараметры.Инфо;
	
	Если Результат <> Неопределено Тогда 
		Объект.РегистрацияВИФНС = Результат;
		УстановитьДанныеПоРегистрацииВИФНС();
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораПодписантаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено И Результат <> КодВозвратаДиалога.Нет Тогда
		Результат.Свойство("Фамилия", Объект.ПодписантФамилия);
		Результат.Свойство("Имя", Объект.ПодписантИмя);
		Результат.Свойство("Отчество", Объект.ПодписантОтчество);
		Представление = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
		Область = ПредставлениеУведомления.Области.Найти("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ");
		Область.Значение = Представление;
		УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область, Истина);
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	Если Модифицированность Тогда 
		СохранитьДанные();
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		УведомлениеОбъект = Объект.Ссылка.ПолучитьОбъект();
		Если УведомлениеОбъект.Заблокирован() Тогда 
			УведомлениеОбъект.Разблокировать();
		КонецЕсли;
		РазблокироватьДанныеДляРедактирования(Объект.Ссылка, УникальныйИдентификатор);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СформироватьXMLНаСервере(УникальныйИдентификатор)
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ВыгрузитьДокумент(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура СформироватьXML(Команда)
	
	ВыгружаемыеДанные = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если ВыгружаемыеДанные <> Неопределено Тогда 
		РегламентированнаяОтчетностьКлиент.ВыгрузитьФайлы(ВыгружаемыеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСДвухмернымШтрихкодомPDF417(Команда)
	РегламентированнаяОтчетностьКлиент.ВывестиМашиночитаемуюФормуУведомленияОСпецрежимах(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Функция СформироватьВыгрузкуИПолучитьДанные() Экспорт 
	Выгрузка = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если Выгрузка = Неопределено Тогда 
		Возврат Неопределено;
	КонецЕсли;
	Выгрузка = Выгрузка[0];
	СтруктураВыгрузки = Новый Структура("ТестВыгрузки,КодировкаВыгрузки", 
			Выгрузка.ТестВыгрузки, Выгрузка.КодировкаВыгрузки);
	СтруктураВыгрузки.Вставить("Данные", Отчеты[Объект.ИмяОтчета].ПолучитьМакет("TIFF_2021_1"));
	СтруктураВыгрузки.Вставить("ИмяФайла", "1112021_5.02000_02.tif");
	Возврат СтруктураВыгрузки;
КонецФункции

&НаКлиенте
Процедура СохранитьНаКлиенте(Автосохранение = Ложь,ВыполняемоеОповещение = Неопределено) Экспорт 
	
	СохранитьДанные();
	Если ВыполняемоеОповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыОповещенияОЗаписи(), Объект.Ссылка);
	Закрыть(Объект.Ссылка);
КонецПроцедуры

#Область ОтправкаВФНС
////////////////////////////////////////////////////////////////////////////////
// Отправка в ФНС
&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтотОбъект);
	
КонецПроцедуры
#КонецОбласти

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНаименованиеЭтапаНажатие(Элемент)
	
	ПараметрыИзменения = Новый Структура;
	ПараметрыИзменения.Вставить("Форма", ЭтаФорма);
	ПараметрыИзменения.Вставить("Организация", Объект.Организация);
	ПараметрыИзменения.Вставить("КонтролирующийОрган",
		ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФНС"));
	ПараметрыИзменения.Вставить("ТекстВопроса", НСтр("ru='Вы уверены, что уведомление уже сдано?'"));
	
	РегламентированнаяОтчетностьКлиент.ИзменитьСтатусОтправки(ПараметрыИзменения);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Функция ПроверитьВыгрузкуНаСервере()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ПроверитьДокументСВыводомВТаблицу(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура ПроверитьВыгрузку(Команда)
	ТаблицаОшибок = ПроверитьВыгрузкуНаСервере();
	Если ТаблицаОшибок.Количество() = 0 Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибок не обнаружено");
	Иначе
		ОткрытьФорму("Документ.УведомлениеОСпецрежимахНалогообложения.Форма.НавигацияПоОшибкам", Новый Структура("ТаблицаОшибок", ТаблицаОшибок), ЭтотОбъект, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьПрисоединенныеФайлы(Команда)
	
	РегламентированнаяОтчетностьКлиент.СохранитьУведомлениеИОткрытьФормуПрисоединенныеФайлы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьБРО(Команда)
	ПечатьБРОНаСервере();
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуПредварительногоПросмотра(ЭтотОбъект, "Открыть", Ложь, СтруктураРеквизитовУведомления.СписокПечатаемыхЛистов);
КонецПроцедуры

&НаСервере
Процедура ПечатьБРОНаСервере()
	УведомлениеОСпецрежимахНалогообложения.ПечатьУведомленияБРО(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура РучнойВвод(Команда)
	РучнойВвод = Не РучнойВвод;
	Элементы.ФормаРучнойВвод.Пометка = РучнойВвод;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "УведомлениеОСпецрежимахНалогообложения_НавигацияПоОшибкам" Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ОбработкаОповещенияНавигацииПоОшибкам(ЭтотОбъект, Параметр, Источник);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьВыгружатьСОшибками(Команда)
	РазрешитьВыгружатьСОшибками = Не РазрешитьВыгружатьСОшибками;
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзXML(ПараметрыЗагрузкиXML) Экспорт
	ЗагрузитьИзXMLНаСервере(ПараметрыЗагрузкиXML);
	Элементы.ДеревоСтраниц.ТекущаяСтрока = ДеревоСтраниц.ПолучитьЭлементы()[0].ПолучитьИдентификатор();
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьИзXMLНаСервере(ПараметрыЗагрузкиXML)
	ДеревоЗагрузки = УведомлениеОСпецрежимахНалогообложения.СформироватьДеревоЗагрузки(ПараметрыЗагрузкиXML.ПредставлениеXML);
	СхемаВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2021_1");
	УведомлениеОСпецрежимахНалогообложения.УстановитьОрганизациюПоПараметрамЗагрузки(ЭтотОбъект, ПараметрыЗагрузкиXML);
	ДеревоСтраниц.ПолучитьЭлементы().Очистить();
	СформироватьДеревоСтраниц();
	УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
	
	ДополнительныеПараметры = Новый Структура;
	УведомлениеОСпецрежимахНалогообложения.ЗагрузитьОбычныеСтраницы(ЭтотОбъект, ДеревоЗагрузки, СхемаВыгрузки, ДополнительныеПараметры);
	УведомлениеОСпецрежимахНалогообложения.ЗагрузитьМногостраничныеСтраницы(ЭтотОбъект, ДеревоЗагрузки, СхемаВыгрузки, ДополнительныеПараметры);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайлаВФормуУведомление(Команда)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ЗагрузитьИзФайлаУведомление(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Функция ПараметрыОповещенияОЗаписи()
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Организация", Объект.Организация);
	ПараметрыОповещения.Вставить("РегистрацияВИФНС", Объект.РегистрацияВИФНС);
	ПараметрыОповещения.Вставить("ВидУведомления", Объект.ВидУведомления);
	ПараметрыОповещения.Вставить("ВладелецФормы", ВладелецФормы);
	
	Возврат ПараметрыОповещения;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Форма.Элементы.ГруппаУведомлениеИзПомощника.Видимость = Форма.УведомлениеЗаполненоВПомощнике;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьУведомлениеЗаполненоВПомощникеНажатие(Элемент)
	
	УведомлениеЗаполненоВПомощнике = Ложь;
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УведомлениеЗаполненоВПомощникеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПомощникЗаполнения" Тогда
		ОткрытьФорму(ФормаПомощника, Новый Структура("Ключ", Объект.Ссылка), ВладелецФормы);
		Закрыть();
	КонецЕсли;
КонецПроцедуры


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ИдентификаторОбъекта = Параметры.ИдентификаторОбъекта;
	ИдентификаторПравила = Параметры.ИдентификаторПравила;
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОжидание;
	СвойстваВерсии = ПрограммныйИнтерфейсСервиса.СвойстваВерсииИнтерфейса();
	ВерсияИнтерфейса = СвойстваВерсии.Версия;

	СтруктураОплатТарифа = ОплатаСервисаУНФ.ПолучитьСтруктуруОплатТарифа();
	ЗаполнитьСпособыОплаты(ЭтаФорма);
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    ПодключитьОбработчикОжидания("ПолучитьДанныеПоОбъекту", 1, Истина);
    
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СсылкиНаФайлыОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
    
    СтандартнаяОбработка = Ложь;
    Файл = Файлы.НайтиПоИдентификатору(Число(НавигационнаяСсылкаФорматированнойСтроки));
    ПолучитьФайл(Файл.Адрес, Файл.Имя, Истина);
    
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьВыбранныйТариф(Команда)
	ОплатаСервисаУНФКлиент.ОбработатьКомандуОплаты(СпособОплаты, СчетПоставщика, ПечатнаяФормаСчетаПоставщика, Абонент);
КонецПроцедуры

&НаКлиенте
Процедура СпособОплатыПриИзменении(Элемент)
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	СтруктураВариантаОплаты = Форма.СтруктураОплатТарифа[Форма.СпособОплаты];
	Элементы.ОплатитьВыбранныйТариф.Заголовок = СтруктураВариантаОплаты.НазваниеКоманды;
	Элементы.ОплатаКомментарии.Заголовок = СтруктураВариантаОплаты.ОплатаКомментарии;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСпособыОплаты(Форма)
	
	СписокВыбора = Форма.Элементы.СпособОплаты.СписокВыбора;
	
	СписокВыбора.Очистить();
	
	Для Каждого ВариантОплаты Из Форма.СтруктураОплатТарифа Цикл
		Если Не ЗначениеЗаполнено(Форма.СчетПоставщика) И (ВариантОплаты.Ключ <> "ОплатаНаличными") Тогда
			Продолжить;
		КонецЕсли;
		СписокВыбора.Добавить(ВариантОплаты.Ключ, ВариантОплаты.Значение.Представление);
	КонецЦикла;
	
	Форма.СпособОплаты = СписокВыбора[0].Значение;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФайлыПоДаннымХранилища(ДанныеХранилища, ПолеФайлы, ПолеИдентификаторФайла, ПолеИмяФайла)

	Файлы.Очистить();
	Для Каждого Файл Из ДанныеХранилища[ПолеФайлы] Цикл
		УстановитьПривилегированныйРежим(Истина);
		ИмяФайла = РаботаВМоделиСервиса.ПолучитьФайлИзХранилищаМенеджераСервиса(Файл[ПолеИдентификаторФайла]);
		УстановитьПривилегированныйРежим(Ложь);
		ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ИмяФайла);
		АдресФайла = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла, УникальныйИдентификатор);
		Попытка
			УдалитьФайлы(ИмяФайла);
		Исключение
			Комментарий = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(КорневоеСобытие(), УровеньЖурналаРегистрации.Ошибка, , , Комментарий);
		КонецПопытки;
		СтрокаФайла = Файлы.Добавить();
		СтрокаФайла.Адрес = АдресФайла;
		СтрокаФайла.Имя = Файл[ПолеИмяФайла];
	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция КорневоеСобытие()

	КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	Возврат НСтр("ru = 'Универсальная интеграция'", КодЯзыка);

КонецФункции

&НаКлиенте
Процедура ПолучитьДанныеПоОбъекту()
	
    ПовторитьЗапрос = ПолучитьДанныеПоОбъектуНаСервере();
    Если ПовторитьЗапрос Тогда
        ПодключитьОбработчикОжидания("ПолучитьДанныеПоОбъекту", 1, Истина);
	Иначе
       
    КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеПоОбъектуНаСервере()

	Если ВерсияИнтерфейса < 13 Тогда
	    ПолученныеДанныеОбъекта = УниверсальнаяИнтеграция.ПрочитатьПолученныеДанныеОбъекта(ИдентификаторПравила, ИдентификаторОбъекта);
	    Если ТипЗнч(ПолученныеДанныеОбъекта) = Тип("Структура") Тогда
	        Если ПолученныеДанныеОбъекта.Свойство(ПолеОшибкаОбработки()) И ПолученныеДанныеОбъекта[ПолеОшибкаОбработки()] Тогда
	            Предупреждение = ПолученныеДанныеОбъекта[ПолеСообщениеОбОшибке()];
	            Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОшибка;
			ИначеЕсли ПолученныеДанныеОбъекта.Свойство(ПолеФайлы()) И ПолученныеДанныеОбъекта[ПолеФайлы()].Количество() > 0 Тогда
				Попытка
					ЗаполнитьФайлыПоДаннымХранилища(ПолученныеДанныеОбъекта, ПолеФайлы(), ПолеИдентификаторФайла(), ПолеИмяФайла());
				Исключение
					Предупреждение = ОписаниеОшибки();
					Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОшибка;
					
					Возврат Ложь;
				КонецПопытки;
				Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаРезультат;
	        Иначе
	            Возврат Истина;
	        КонецЕсли;
	        УниверсальнаяИнтеграция.ОтписатьсяОтОповещенийНаИзменения(ИдентификаторПравила, Строка(ИдентификаторОбъекта));
	        Возврат Ложь;
	    Иначе
	        Возврат Истина;
	    КонецЕсли; 
	Иначе
		ПолученоОповещение = УниверсальнаяИнтеграция.ПолученоОповещениеОбИзмененииОбъекта("bill", Строка(ИдентификаторОбъекта));
		Если ПолученоОповещение Тогда
			Данные = ПрограммныйИнтерфейсСервиса.ДанныеСчетаНаОплату(ИдентификаторОбъекта, , Ложь, , , Предупреждение);
			Если ЗначениеЗаполнено(Предупреждение) Тогда
	            Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОшибка;
			ИначеЕсли Данные.Состояние.Ошибка Тогда
				Предупреждение = Данные.Состояние.Описание;
	            Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОшибка;
			ИначеЕсли Данные.Файлы.Количество() > 0 Тогда
	            ЗаполнитьФайлыПоДаннымХранилища(Данные, "Файлы", "Идентификатор", "Описание");
	            Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаРезультат;
			Иначе
				Возврат Истина;
			КонецЕсли;
			УниверсальнаяИнтеграция.ОтписатьсяОтОповещенияОбИзмененииОбъекта("bill", Строка(ИдентификаторОбъекта));
			Возврат Ложь;
		Иначе
			Возврат Истина;
		КонецЕсли; 
	КонецЕсли; 
КонецФункции

&НаСервере
Функция ПолеИдентификаторФайла()
	
	Возврат "id";
	
КонецФункции
 
&НаСервере
Функция ПолеИмяФайла()
	
	Возврат "name";
	
КонецФункции

&НаСервере
Функция ПолеОшибкаОбработки()
	
	Возврат "error";
	
КонецФункции

&НаСервере
Функция ПолеСообщениеОбОшибке()
	
	Возврат "message";
	
КонецФункции

&НаСервере
Функция ПолеФайлы()
	
	Возврат "files";
	
КонецФункции

#КонецОбласти 

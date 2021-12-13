﻿
#Область Опрос

&НаКлиенте
Процедура ДекорацияЗакрытьНажатие(Элемент)
	
	ЗакрытьОпрос();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияМнеНеИнтересноНажатие(Элемент)
	
	Закрыть();
	
	УстановитьНастройкиОпросаПоКК(Ложь, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьОпрос()
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОпросПройти(Команда)
	Элементы.СтраницыОпрос.ТекущаяСтраница = Элементы.СтраницаВопрос1;
КонецПроцедуры

&НаКлиенте
Процедура ОпросПолучилосьЛиСобратьМППриИзменении(Элемент)
	
	Если ОпросПолучилосьЛиОпубликоватьМП = "Да" Тогда
		//Элементы.ОпросДалее.Доступность = Истина;
		Элементы.ОпросОписаниеПроблемПриПубликации.Видимость = Ложь;
		Элементы.ДекорацияОпросОписаниеПроблемПриПубликации.Видимость = Ложь;
		Элементы.ДекорацияШаг1.Заголовок = НСтр("ru = 'Шаг 1/3'")
	Иначе
		Элементы.ОпросОписаниеПроблемПриПубликации.Видимость = Истина;
		Элементы.ДекорацияОпросОписаниеПроблемПриПубликации.Видимость = Истина;
		Элементы.ДекорацияШаг1.Заголовок = НСтр("ru = 'Шаг 1/2'")
		//ОпросОписаниеТрудностейПриИзмененииФрагмент();
	КонецЕсли;
	
	УстановитьДоступностьКнопкиДалее();
	
КонецПроцедуры

&НаКлиенте
Процедура ОпросОписаниеТрудностейПриИзменении(Элемент)
	
	//ОпросОписаниеТрудностейПриИзмененииФрагмент();
	УстановитьДоступностьКнопкиДалее();
	
КонецПроцедуры

&НаКлиенте
Процедура ОпросДалее(Команда)
	
	НомерСтраницы = Число(Прав(Элементы.СтраницыОпрос.ТекущаяСтраница.Имя, 1));
	НовыйНомерСтраницы = 1 + НомерСтраницы;
	
	Если НовыйНомерСтраницы = 2 И ОпросПолучилосьЛиОпубликоватьМП = "Нет" Тогда
		НовыйНомерСтраницы = 3;
	КонецЕсли;
	
	Если НовыйНомерСтраницы = 3 Тогда
		Если ОпросПолучилосьЛиОпубликоватьМП = "Нет" Тогда
			Элементы.ДекорацияШаг5.Заголовок = НСтр("ru = 'Шаг 2/2'");
		Иначе
			Элементы.ДекорацияШаг5.Заголовок = НСтр("ru = 'Шаг 3/3'");
		КонецЕсли;
	КонецЕсли;
	
	Если НомерСтраницы = 3 Тогда
		// Отправка данных
		СообщениеОбОшибке = Неопределено;
		ДопДанные = ПолучитьXMLСОтветами();
		ИмяСобытия = "Опрос по мобильному приложению ""Кабинет клиента"" 2";
		СборСтатистикиУНФВызовСервера.ОтправитьСобытиеСДопДанными(ИмяСобытия, ДопДанные, СообщениеОбОшибке);
		Если СообщениеОбОшибке = Неопределено Тогда
			Элементы.ГруппаПроблема.Видимость = Ложь;
			УстановитьНастройкиОпросаПоКК(Ложь, Истина);
		Иначе
			Элементы.ГруппаУспех.Видимость = Ложь;
			УстановитьНастройкиОпросаПоКК(Ложь, Ложь, Истина);
		КонецЕсли;
		ОпросЗакрыт = Истина;
		Элементы.СтраницыОпрос.ТекущаяСтраница = Элементы.СтраницаОпросРезультат;
		Возврат;
	КонецЕсли;
	
	Элементы.СтраницыОпрос.ТекущаяСтраница = Элементы["СтраницаВопрос" + Строка(НовыйНомерСтраницы)];
	
КонецПроцедуры

&НаСервере
Процедура НеПоказыватьОпросИстина()
	
	Константы.НеПоказыватьОпросМЛК.Установить(Истина);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьXMLСОтветами()
	
	СтруктураСОтветами = Новый Структура;
	СтруктураСОтветами.Вставить("ПолучилосьЛиОпубликоватьМП", ОпросПолучилосьЛиОпубликоватьМП);
	СтруктураСОтветами.Вставить("ОписаниеПроблемПриПубликации", ОпросОписаниеПроблемПриПубликации);
	
	СтруктураСОтветами.Вставить("РаспространялиЛиПриложение", ОпросРаспространялиЛиПриложение);
	СтруктураСОтветами.Вставить("СпособыРаспространения", ОпросСпособыРаспространения);
	СтруктураСОтветами.Вставить("КоличествоКлиентов", ОпросКоличествоКлиентов);
	СтруктураСОтветами.Вставить("ПочемуНеРаспространяли", ОпросПочемуНеРаспространяли);
	СтруктураСОтветами.Вставить("ЧегоНеХватаетДляЗапуска", ОпросЧегоНеХватаетДляЗапуска);
	
	СтруктураСОтветами.Вставить("НазваниеОрганизации", ОпросНазваниеОрганизации);
	СтруктураСОтветами.Вставить("Имя", ОпросИмя);
	СтруктураСОтветами.Вставить("Телефон", ОпросТелефон);
	СтруктураСОтветами.Вставить("Почта", ОпросПочта);
	СтруктураСОтветами.Вставить("КодКомпании", ОпросКодКомпании);
	
	Возврат СформироватьСтрокуОтправки(СтруктураСОтветами);
	
КонецФункции

&НаСервере
Функция СформироватьСтрокуОтправки(СтруктураСОтветами)
	
	ЗаписьXML = Новый ЗаписьXML();
	ЗаписьXML.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, СтруктураСОтветами, НазначениеТипаXML.Явное);
	СтрокаОтправки = ЗаписьXML.Закрыть();
	
	Возврат СтрокаОтправки
	
КонецФункции

&НаКлиенте
Процедура ОпросНазад(Команда)
	
	Номер = Число(Прав(Элементы.СтраницыОпрос.ТекущаяСтраница.Имя, 1)) - 1;
	
	Если Номер = 2 И ОпросПолучилосьЛиОпубликоватьМП = "Нет" Тогда
		Номер = 1;
		Элементы.ДекорацияШаг1.Заголовок = НСтр("ru = 'Шаг 1/2'");
	КонецЕсли;
	
	Элементы.СтраницыОпрос.ТекущаяСтраница = Элементы["СтраницаВопрос" + Строка(Номер)];
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКомандыОтправить()
	
	Если ЗначениеЗаполнено(ОпросНазваниеОрганизации) И ЗначениеЗаполнено(ОпросИмя) И ЗначениеЗаполнено(ОпросТелефон) И ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(ОпросПочта, Истина) Тогда
		Элементы.ОпросДалее4.Доступность = Истина;
	Иначе
		Элементы.ОпросДалее4.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОпросНазваниеОрганизацииИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) И ЗначениеЗаполнено(ОпросИмя) И ЗначениеЗаполнено(ОпросТелефон) И ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(ОпросПочта, Истина) Тогда
		Элементы.ОпросДалее4.Доступность = Истина;
	Иначе
		Элементы.ОпросДалее4.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОпросИмяИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
		Если ЗначениеЗаполнено(ОпросНазваниеОрганизации) И ЗначениеЗаполнено(Текст) И ЗначениеЗаполнено(ОпросТелефон) И ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(ОпросПочта, Истина) Тогда
		Элементы.ОпросДалее4.Доступность = Истина;
	Иначе
		Элементы.ОпросДалее4.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОпросТелефонИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ОпросНазваниеОрганизации) И ЗначениеЗаполнено(ОпросИмя) И ЗначениеЗаполнено(Текст) И ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(ОпросПочта, Истина) Тогда
		Элементы.ОпросДалее4.Доступность = Истина;
	Иначе
		Элементы.ОпросДалее4.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОпросПочтаИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ОпросНазваниеОрганизации) И ЗначениеЗаполнено(ОпросИмя) И ЗначениеЗаполнено(ОпросТелефон) И ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(Текст, Истина) Тогда
		Элементы.ОпросДалее4.Доступность = Истина;
	Иначе
		Элементы.ОпросДалее4.Доступность = Ложь;
	КонецЕсли;
	
	Элементы.ДекорацияПочтаНеКорректная.Видимость = НЕ ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(Текст, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОпросНазваниеОрганизацииПриИзменении(Элемент)
	УстановитьДоступностьКомандыОтправить();
	//Элементы.ДекорацияНазваниеНеКорректное.Видимость = НЕ ЗначениеЗаполнено(ОпросНазваниеОрганизации);
КонецПроцедуры

&НаКлиенте
Процедура ОпросИмяПриИзменении(Элемент)
	УстановитьДоступностьКомандыОтправить();
	//Элементы.ДекорацияИмяНеКорректное.Видимость = НЕ ЗначениеЗаполнено(ОпросИмя);
КонецПроцедуры

&НаКлиенте
Процедура ОпросТелефонПриИзменении(Элемент)
	УстановитьДоступностьКомандыОтправить();
	// Элементы.ДекорацияТелефонНеКорректный.Видимость = СтрДлина(СокрЛП(ОпросТелефон)) <> 11;
КонецПроцедуры

&НаКлиенте
Процедура ОпросПочтаПриИзменении(Элемент)
	УстановитьДоступностьКомандыОтправить();
	Элементы.ДекорацияПочтаНеКорректная.Видимость = НЕ ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(ОпросПочта, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОпросЗакрыть(Команда)
	ЗакрытьОпрос();
КонецПроцедуры

&НаКлиенте
Процедура ВопросПроОпросЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ОпросЗакрыт = Истина;
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Элементы.СтраницыОпрос.ТекущаяСтраница = Элементы.СтраницаВопрос1;
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Закрыть();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Закрыть();
		НеПоказыватьОпросИстина();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОпросЧегоНеХватаетДляЗапускаПриИзменении(Элемент)
	УстановитьДоступностьКнопкиДалее();
КонецПроцедуры

&НаКлиенте
Процедура ОпросСпособыРаспространенияПриИзменении(Элемент)
	УстановитьДоступностьКнопкиДалее();
КонецПроцедуры

&НаКлиенте
Процедура ОпросСпособыРаспространенияИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		Элементы.ОпросДалее1.Доступность = Истина;
	Иначе
		Элементы.ОпросДалее1.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОпросПочемуНеРаспространялиИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) И ЗначениеЗаполнено(ОпросЧегоНеХватаетДляЗапуска) Тогда
		Элементы.ОпросДалее1.Доступность = Истина;
	Иначе
		Элементы.ОпросДалее1.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОпросЧегоНеХватаетДляЗапускаИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) И ЗначениеЗаполнено(ОпросПочемуНеРаспространяли) Тогда
		Элементы.ОпросДалее1.Доступность = Истина;
	Иначе
		Элементы.ОпросДалее1.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОпросОписаниеПроблемПриПубликацииИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	Элементы.ОпросДалее.Доступность = ЗначениеЗаполнено(Текст);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьНастройкиОпросаПоКК(Истина, Ложь);
	
	Элементы.ДекорацияПочтаНеКорректная.Видимость = Ложь;
	Элементы.ДекорацияТелефонНеКорректный.Видимость = Ложь;
	Элементы.ДекорацияИмяНеКорректное.Видимость = Ложь;
	Элементы.ДекорацияНазваниеНеКорректное.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОпросПочемуНеРаспространялиПриИзменении(Элемент)
	УстановитьДоступностьКнопкиДалее();
КонецПроцедуры

&НаКлиенте
Процедура ОпросРаспространялиЛиПриложениеПриИзменении(Элемент)
	
	Если ОпросРаспространялиЛиПриложение = "Да" Тогда
		Элементы.Вопрос2ЕслиНет.Видимость = Ложь;
		Элементы.Вопрос2ЕслиДа.Видимость = Истина;
	Иначе
		Элементы.Вопрос2ЕслиНет.Видимость = Истина;
		Элементы.Вопрос2ЕслиДа.Видимость = Ложь;
	КонецЕсли;
	
	УстановитьДоступностьКнопкиДалее();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКнопкиДалее()
	
	Если Элементы.СтраницыОпрос.ТекущаяСтраница = Элементы.СтраницаВопрос1 Тогда
		Если ОпросПолучилосьЛиОпубликоватьМП = "Да" Тогда
			Элементы.ОпросДалее.Доступность = Истина;
		Иначе
			Элементы.ОпросДалее.Доступность = ЗначениеЗаполнено(ОпросОписаниеПроблемПриПубликации);
		КонецЕсли;
	ИначеЕсли Элементы.СтраницыОпрос.ТекущаяСтраница = Элементы.СтраницаВопрос2 Тогда
		Если ОпросРаспространялиЛиПриложение = "Да" Тогда
			Элементы.ОпросДалее1.Доступность = ЗначениеЗаполнено(ОпросСпособыРаспространения);
		Иначе
			Элементы.ОпросДалее1.Доступность = (ЗначениеЗаполнено(ОпросПочемуНеРаспространяли) И ЗначениеЗаполнено(ОпросЧегоНеХватаетДляЗапуска));
		КонецЕсли;
	ИначеЕсли Элементы.СтраницыОпрос.ТекущаяСтраница = Элементы.СтраницаВопрос3 Тогда
		
		
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкиОпросаПоКК(ПрибавитьКоличествоОткрытий, ОпросЗавершен, ОтнятьКоличествоОткрытий = Ложь)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НастройкиОпросаПоМЛК = Константы.НастройкиОпросаПоМЛК.Получить().Получить();
	
	Если НастройкиОпросаПоМЛК = Неопределено Тогда
		НастройкиОпросаПоМЛК = Новый Структура;
		НастройкиОпросаПоМЛК.Вставить("ОпросЗавершен", Ложь);
		НастройкиОпросаПоМЛК.Вставить("КоличествоОткрытийОпроса", 0);
	КонецЕсли;
	
	Если ПрибавитьКоличествоОткрытий Тогда
		НастройкиОпросаПоМЛК.КоличествоОткрытийОпроса = НастройкиОпросаПоМЛК.КоличествоОткрытийОпроса + 1;
	КонецЕсли;
	
	Если ОтнятьКоличествоОткрытий Тогда
		НастройкиОпросаПоМЛК.КоличествоОткрытийОпроса = НастройкиОпросаПоМЛК.КоличествоОткрытийОпроса - 1;
	КонецЕсли;
	
	Если ОпросЗавершен Тогда
		НастройкиОпросаПоМЛК.ОпросЗавершен = ОпросЗавершен;
	КонецЕсли;
	
	Константы.НастройкиОпросаПоМЛК.Установить(Новый ХранилищеЗначения(НастройкиОпросаПоМЛК, Новый СжатиеДанных(9)));
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти


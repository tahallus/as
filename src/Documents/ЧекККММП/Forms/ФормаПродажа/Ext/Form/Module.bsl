﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьОткрытиеЭкранаВGA(ЭтаФорма.ИмяФормы);
	// Конец Сбор статистики

	УстановитьВидимостьЭлементов();
	ОбщегоНазначенияМПСервер.УстановитьЗаголовокФормы(ЭтаФорма, НСтр("ru='Чек ККТ';en='Retail Sales'"));
	ОбновитьЗаписиПоСтрокамТЧ();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	// Сбор статистики
	СборСтатистикиМПКлиентПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + ".Закрытие",,,ЗавершениеРаботы);
	// Конец Сбор статистики
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ДобавитьТоварВТаблицу(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	#Если МобильноеПриложениеКлиент Тогда
		
		// АПК:488-выкл методы безопасного запуска обеспечиваются этой функцией
		МодульПодключаемоеОборудованиеКлиент = Вычислить("ПодключаемоеОборудованиеКлиент");
		// АПК:488-вкл
		Если ТипЗнч(МодульПодключаемоеОборудованиеКлиент) = Тип("ОбщийМодуль") Тогда
			
			Если МодульПодключаемоеОборудованиеКлиент.ЭтоОповещениеСканераШтрихкода(ИмяСобытия) И ВводДоступен() Тогда
				
				Товар = ОбщегоНазначенияМПСервер.ПолучитьНоменклатуруПоШтрихкоду(Параметр);
				ДобавитьТоварВТаблицу(Товар);
				
			КонецЕсли;
		КонецЕсли;
		
	#КонецЕсли

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура Декорация2Нажатие(Элемент)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + "." + Элемент.Имя + ".Нажатие");
	// Конец Сбор статистики

	ОткрытьФорму("Справочник.ТоварыМП.ФормаВыбора", Новый Структура("РежимВыбора, ТекущаяСтрока", Истина, ВыбранныйТовар), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация1Нажатие(Элемент)
	
	// Сбор статистики
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(ЭтаФорма.ИмяФормы + "." + Элемент.Имя + ".Нажатие");
	// Конец Сбор статистики

	ОбщегоНазначенияМПКлиент.ОтсканироватьШтрихкод(Новый ОписаниеОповещения("ОбработатьШтрихкод", ЭтаФорма), ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Оплатить(Команда)
	
	РозничныеПродажиМПКлиент.Оплатить(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДобавитьТоварВТаблицу(Товар)
	
	Если НЕ ЗначениеЗаполнено(Товар) Тогда
		Возврат;
	КонецЕсли;
	ВыбранныйТовар = Товар;
	НайденныеСтроки = Объект.Товары.НайтиСтроки(Новый Структура("Товар", Товар));
	Если НайденныеСтроки.Количество() > 0 Тогда
		НайденныеСтроки[0].Количество = НайденныеСтроки[0].Количество + 1;
		РассчитатьСуммуВСтроке(НайденныеСтроки[0]);
	Иначе
		НоваяСтрока = Объект.Товары.Добавить();
		НоваяСтрока.Количество = 1;
		НоваяСтрока.Товар = Товар;
		СтруктураДанных = Новый Структура("Товар, ПриходТовара", Товар, Ложь);
		ПолучитьДанныеТоварПриИзменении(СтруктураДанных);
		Если СтруктураДанных.Цена <> 0 Тогда
			НоваяСтрока.Цена = СтруктураДанных.Цена;
		КонецЕсли;
		Если НоваяСтрока.Количество = 0 Тогда
			НоваяСтрока.Количество = 1;
		КонецЕсли;
		РассчитатьСуммуВСтроке(НоваяСтрока);
	КонецЕсли;
	СкорректироватьСуммуСкидкиЕслиНужно();
	СкорректироватьСуммуОплатыЕслиНужно();
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммуВСтроке(ТекущаяСтрока)
	
	ТекущаяСтрока.Сумма = ТекущаяСтрока.Количество * ТекущаяСтрока.Цена;
	
КонецПроцедуры

&НаКлиенте
Процедура СкорректироватьСуммуОплатыЕслиНужно(СПредупреждением = Ложь)
	
	Если Объект.СуммаОплаты > (Объект.Товары.Итог("Сумма") - Объект.СуммаСкидки) Тогда
		Если СПредупреждением Тогда
			ПоказатьПредупреждение(Новый ОписаниеОповещения("СкорректироватьСуммуОплатыЕслиНужноЗавершение", ЭтаФорма), НСтр("ru='Сумма оплаты не может быть больше суммы документа со скидкой!';en='Payment amount cannot be greater than the sum of the document at a discount!'"),,ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьСинонимКонфигурации());
			Возврат;
		КонецЕсли;
		Объект.СуммаОплаты = Объект.Товары.Итог("Сумма") - Объект.СуммаСкидки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкорректироватьСуммуОплатыЕслиНужноЗавершение(ДополнительныеПараметры) Экспорт
	
	Объект.СуммаОплаты = Объект.Товары.Итог("Сумма") - Объект.СуммаСкидки;
	
КонецПроцедуры

&НаКлиенте
Процедура СкорректироватьСуммуСкидкиЕслиНужно(СПредупреждением = Ложь)
	
	Если Объект.СуммаСкидки > Объект.Товары.Итог("Сумма")Тогда
		Если СПредупреждением Тогда
			ПоказатьПредупреждение(Новый ОписаниеОповещения("СкорректироватьСуммуСкидкиЕслиНужноЗавершение", ЭтаФорма), НСтр("ru='Сумма скидки не может быть больше суммы документа!';en='Discount amount cannot be greater than the sum of the document!'"),,ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьСинонимКонфигурации());
			Возврат;
		КонецЕсли;
		Объект.СуммаСкидки = Объект.Товары.Итог("Сумма");
	КонецЕсли;
	
	УстановитьПроцентСкидки();
	
КонецПроцедуры

&НаКлиенте
Процедура СкорректироватьСуммуСкидкиЕслиНужноЗавершение(ДополнительныеПараметры) Экспорт
	
	Объект.СуммаСкидки = Объект.Товары.Итог("Сумма");
	УстановитьПроцентСкидки();
	
КонецПроцедуры


&НаКлиенте
Процедура РассчитатьСуммуДокумента()
	
	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма") - Объект.СуммаСкидки;
	УстановитьВидимостьЭлементов();
	ОбновитьЗаписиПоСтрокамТЧ();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	
	Если Объект.Товары.Количество() = 0 И Объект.СуммаДокумента = 0 Тогда
		Элементы.ГруппаНиз.Видимость = Ложь;
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаНовыйЧек;
	Иначе
		Если Объект.СуммаДокумента = 0 Тогда
			Элементы.ПринятьОплатуБезСуммы.Видимость = Истина;
			Элементы.ПринятьОплатуССуммой.Видимость = Ложь;
		Иначе
			Элементы.ПринятьОплатуБезСуммы.Видимость = Ложь;
			ФорматированнаяСумма = Формат(Объект.СуммаДокумента, "ЧДЦ=2; ЧРГ=' '; ЧН=0.00; ЧГ=3,0");
			Элементы.ПринятьОплатуССуммой.Видимость = Истина;
			Элементы.ПринятьОплатуССуммой.Заголовок = НСтр("ru='  К оплате: '") + Строка(ФорматированнаяСумма) + "  ";
		КонецЕсли;
		Элементы.ГруппаНиз.Видимость = Истина;
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтроки;
	КонецЕсли;
	
	//#Если НЕ МобильноеПриложениеСервер Тогда
	//	элементы.ДекорацияОтступ2.Видимость = Ложь;
	//	Элементы.ДекорацияОтступ3.Видимость = Ложь;
	//	Элементы.ПриемОплаты.ГоризонтальноеПоложениеПодчиненных = ГоризонтальноеПоложениеЭлемента.Центр;
	//#КонецЕсли

	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПроцентСкидки()
	
	ТоварыИтог = Объект.Товары.Итог("Сумма");
	Если ТоварыИтог <> 0 Тогда
		Скидка = Окр(Объект.СуммаСкидки / ТоварыИтог * 100, 0);
		ПроцентСкидки = Строка(Скидка) + "%";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьДанныеТоварПриИзменении(СтруктураДанных)
	
	ТоварСсылка = СтруктураДанных.Товар;
	
	Если ЗначениеЗаполнено(ТоварСсылка) Тогда
		ТоварОбъект = ТоварСсылка.ПолучитьОбъект();
		ТоварЦена = ?(СтруктураДанных.ПриходТовара, ТоварОбъект.ПолучитьЦенуПоставщиков(), ТоварОбъект.ПолучитьЦенуПродажи());
	Иначе
		ТоварОбъект = Неопределено;
		ТоварЦена = 0;
	КонецЕсли;
	
	СтруктураДанных.Вставить("Цена", ТоварЦена);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНовыйНомер() Экспорт
	
	ЧекОбъект = РеквизитФормыВЗначение("Объект");
	ЧекОбъект.УстановитьНовыйНомер();
	ЗначениеВРеквизитФормы(ЧекОбъект, "Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьЧек(Отказ = Ложь) Экспорт
	
	МассивСтрокСНулевымиСуммами = Новый Массив();
	
	Для каждого ТекСтрока Из Объект.Товары Цикл
		Если ТекСтрока.Количество = 0 ИЛИ ТекСтрока.Сумма = 0 Тогда
			МассивСтрокСНулевымиСуммами.Добавить(ТекСтрока);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивСтрокСНулевымиСуммами.Количество() > 0 Тогда
		
		Отказ = Истина;
		ТекстВопроса = НСтр("ru='Очистить строки с нулевыми суммами?'");
		//Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет,,,ОбщегоНазначенияМП20ВызовСервераПовтИсп.ПолучитьСинонимКонфигурации());
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("МассивСтрокСНулевымиСуммами", МассивСтрокСНулевымиСуммами);
		Оповещение = Новый ОписаниеОповещения("ЗаписатьЧекЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
		
		//Если Ответ = КодВозвратаДиалога.Да Тогда
		//	Для каждого ТекУдСтрока Из МассивСтрокСНулевымиСуммами Цикл
		//		ИндексСтроки = Объект.Товары.Индекс(ТекУдСтрока);
		//		Объект.Товары.Удалить(ИндексСтроки);
		//	КонецЦикла;
		//	РассчитатьСуммуДокумента();
		//Иначе
		//	ПоказатьПредупреждение(,НСтр("ru='Нельзя принять оплату по чеку с нулевыми суммами!'"),,ОбщегоНазначенияМП20ВызовСервераПовтИсп.ПолучитьСинонимКонфигурации());
		//	Отказ = Истина;
		//КонецЕсли;
		
	КонецЕсли;

	ЗаписатьЧекФрагмент(Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьЧекФрагмент(Отказ)
	
	Перем НужноДозаписатьРеквизиты, СтруктураСДанными;
	
	Если НЕ Отказ Тогда
		РозничныеПродажиМПКлиент.ВыполнитьЗакрытиеИОткрытиеСменыЕслиНужно(ЭтаФорма, Отказ);
	КонецЕсли;
	Если НЕ Отказ Тогда
		СтруктураСДанными = Неопределено;
		Если НужноОбновитьФормуДокумента() Тогда
			СтруктураСДанными = Новый Структура ("Статус, СуммаДокумента, СуммаКартой, СуммаОплаты, СуммаСкидки, Телефон, АдресЭП", Объект.Статус, Объект.СуммаДокумента, Объект.СуммаКартой, Объект.СуммаОплаты ,Объект.СуммаСкидки, Объект.Телефон, Объект.АдресЭП);
			ЭтаФорма.Прочитать();
			НужноДозаписатьРеквизиты = Истина;
		КонецЕсли;
		ЗаписатьЧекНаСервере(СтруктураСДанными);
		ОбновитьЗаписиПоСтрокамТЧ();
		Оповестить("ЗаписанЧек");
	КонецЕсли;
	
	Если Отказ Тогда
		
		ЗаписатьЧек();
		РозничныеПродажиМПКлиент.Оплатить(ЭтаФорма, Неопределено);
	КонецЕсли;
	

КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьЧекЗавершение(Результат, Параметры) Экспорт
	
	Отказ = Истина;
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Для каждого ТекУдСтрока Из Параметры.МассивСтрокСНулевымиСуммами Цикл
			ИндексСтроки = Объект.Товары.Индекс(ТекУдСтрока);
			Объект.Товары.Удалить(ИндексСтроки);
		КонецЦикла;
		РассчитатьСуммуДокумента();
		ЗаписатьЧекФрагмент(Отказ);
	Иначе
		ПоказатьПредупреждение(,НСтр("ru='Нельзя принять оплату по чеку с нулевыми суммами!'"),,ОбщегоНазначенияМПВызовСервераПовтИсп.ПолучитьСинонимКонфигурации());
		Отказ = Истина;
		//Возврат;
	КонецЕсли;
	
	//ЗаписатьЧекФрагмент(Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьЧекНаСервере(СтруктураСДанными)
	
	ЧекОбъект = РеквизитФормыВЗначение("Объект");
	ЧекОбъект.Дата = ТекущаяДата();
	Если СтруктураСДанными <> Неопределено Тогда
		ЧекОбъект.Статус = СтруктураСДанными.Статус;
		ЧекОбъект.СуммаДокумента = СтруктураСДанными.СуммаДокумента;
		ЧекОбъект.СуммаКартой = СтруктураСДанными.СуммаКартой;
		ЧекОбъект.СуммаОплаты = СтруктураСДанными.СуммаОплаты;
		ЧекОбъект.СуммаСкидки = СтруктураСДанными.СуммаСкидки;
		ЧекОбъект.Телефон = СтруктураСДанными.Телефон;
		ЧекОбъект.АдресЭП = СтруктураСДанными.АдресЭП;
	КонецЕсли;
	ЧекОбъект.Записать();
	ЗначениеВРеквизитФормы(ЧекОбъект, "Объект");
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСсылочныйНомер() Экспорт
	
	Возврат Объект.СсылочныйНомер;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуОплатыЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатЗакрытия) = Тип("Структура")
		И РезультатЗакрытия.Успешно Тогда
		Если РезультатЗакрытия.ВвестиНовуюПродажу Тогда
			ОткрытьФорму("Документ.ЧекККММП.Форма.ФормаПродажа");
		КонецЕсли;
		Закрыть();
	КонецЕсли;
	
	Если РезультатЗакрытия = Неопределено
		И ЗакрыватьПоЗавершенииОплаты Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаписьПоСтроке(Знач Строка, ИдентификаторСтроки = Неопределено)
	
	Если ИдентификаторСтроки = Неопределено Тогда
		СтрокаТЧ = Строка;
	Иначе
		СтрокаТЧ = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтроки);
	КонецЕсли;
	
	ЗаписьПоСтроке = "%Цена% x %Количество%";
	
	ЗаписьПоСтроке = СтрЗаменить(ЗаписьПоСтроке, "%Количество%", Формат(СтрокаТЧ.Количество, "ЧЦ=15; ЧДЦ=%ТочностьОтображенияКоличества%; ЧН=0; ЧРД=.; ЧГ=0"));
	ЗаписьПоСтроке = СтрЗаменить(ЗаписьПоСтроке, "%Цена%",       Формат(СтрокаТЧ.Цена, "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧН=0.00; ЧГ=0"));
	СтрокаТЧ.ЗаписьПоСтроке = ЗаписьПоСтроке;
	
	СуммаПоСтроке = "=%Сумма%";
	СуммаПоСтроке = СтрЗаменить(СуммаПоСтроке, "%Сумма%",      Формат(СтрокаТЧ.Сумма, "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧН=0.00; ЧГ=0"));
	СтрокаТЧ.СуммаПоСтроке = СуммаПоСтроке;
	
	НомерПоСтроке = "#%НомерСтроки%";
	НомерПоСтроке = СтрЗаменить(НомерПоСтроке, "%НомерСтроки%", Формат(СтрокаТЧ.НомерСтроки, "ЧЦ=15; ЧДЦ=%ТочностьОтображенияКоличества%; ЧН=0; ЧРД=.; ЧГ=0"));
	СтрокаТЧ.НомерПоСтроке = НомерПоСтроке;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаписиПоСтрокамТЧ()
	
	Для каждого СтрокаТЧ Из Объект.Товары Цикл
		ОбновитьЗаписьПоСтроке(СтрокаТЧ);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолученШтрихкод(Штрихкод) Экспорт
	
	ОбработатьШтрихкод(Штрихкод, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкод(Штрихкод, Результат, Сообщение = "", ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат Тогда
		#Если МобильноеПриложениеКлиент Тогда
			СредстваМультимедиа.ЗакрытьСканированиеШтрихКодов();
		#КонецЕсли
		Товар = ОбщегоНазначенияМПСервер.ПолучитьНоменклатуруПоШтрихкоду(Штрихкод);
		ДобавитьТоварВТаблицу(Товар);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолучениеРезультатаПоПлатежнойСистеме(Сумма, РезультатОперацииПоПлатежнойСистеме) Экспорт
	
	Если НЕ РезультатОперацииПоПлатежнойСистеме.Успешно Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаписатьЧек();
	КонецЕсли;
	
	Если РезультатОперацииПоПлатежнойСистеме.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПлатежнойСистемыМП.Оплата")
		ИЛИ РезультатОперацииПоПлатежнойСистеме.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПлатежнойСистемыМП.ВозвратОплаты") Тогда
		
		ДобавитьОперациюПоПлатежнойСистеме(РезультатОперацииПоПлатежнойСистеме);
		Оповестить("ЗаписанЧек", Объект.Ссылка);
		
	ИначеЕсли РезультатОперацииПоПлатежнойСистеме.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПлатежнойСистемыМП.ОтменаОплаты") Тогда
		
		ДобавитьОперациюПоПлатежнойСистеме(РезультатОперацииПоПлатежнойСистеме);
		УдалитьОплатуПоПлатежнойКарте();
		Оповестить("ЗаписанЧек", Объект.Ссылка)
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьОперациюПоПлатежнойСистеме(РезультатОперации)
	
	ЧекОбъект = ДанныеФормыВЗначение(Объект, Тип("ДокументОбъект.ЧекККММП"));
	
	ЧекОбъект.КодАвторизации = РезультатОперации.КодАвторизации;
	ЧекОбъект.СсылочныйНомер = РезультатОперации.НомерСсылкиОперации;
	ЧекОбъект.НомерПлатежнойКарты = РезультатОперации.НомерКарты;
	ЧекОбъект.ДатаОперацииЭТ = РезультатОперации.ДатаОперации;
	ЧекОбъект.СлипЧек = Новый ХранилищеЗначения(РезультатОперации.СлипЧек, Новый СжатиеДанных(9));
	
	ЧекОбъект.Записать();
	ЭтаФорма.Прочитать();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьОплатуПоПлатежнойКарте()
	
	Объект.КодАвторизации = Неопределено;
	Объект.СсылочныйНомер = Неопределено;
	Объект.НомерПлатежнойКарты = Неопределено;
	Объект.ДатаОперацииЭТ = Неопределено;
	Объект.СлипЧек = Неопределено;
	Объект.СуммаКартой = Неопределено;
	
	ЗаписатьЧек();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыСтроки = ПолучитьПараметрыСтроки();
	
	Если ПараметрыСтроки <> Неопределено Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ИдентификаторСтроки", ПараметрыСтроки.ИдентификаторСтроки);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеИзменитьСтроку", ЭтотОбъект, ДополнительныеПараметры);
		ОткрытьФорму("ОбщаяФорма.РедактированиеСтрокиМП", ПараметрыСтроки, ЭтаФорма,,,,ОписаниеОповещения);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыСтроки()
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;

	Если ТекущиеДанные = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("ИдентификаторСтроки", ТекущиеДанные.ПолучитьИдентификатор());
	СтруктураПараметров.Вставить("НомерСтроки",         ТекущиеДанные.НомерСтроки);
	СтруктураПараметров.Вставить("Товар",               ТекущиеДанные.Товар);
	СтруктураПараметров.Вставить("Количество",          ТекущиеДанные.Количество);
	СтруктураПараметров.Вставить("Цена",                ТекущиеДанные.Цена);
	СтруктураПараметров.Вставить("Сумма",               ТекущиеДанные.Сумма);
	СтруктураПараметров.Вставить("Чек",                 Объект.Ссылка);
	СтруктураПараметров.Вставить("ТолькоПросмотрФормы", ЭтаФорма.ТолькоПросмотр);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаКлиенте
Процедура ОповещениеИзменитьСтроку(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Неопределено 
	 ИЛИ Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторСтроки = ДополнительныеПараметры.ИдентификаторСтроки;
	СтрокаТаблицы = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	Если Результат.Свойство("УдалитьСтроку") Тогда
		ИндексСтроки = Объект.Товары.Индекс(СтрокаТаблицы);
		Объект.Товары.Удалить(ИндексСтроки);
		Модифицированность = Истина;
	ИначеЕсли Результат.Свойство("Сохранить") Тогда
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Результат);
		Модифицированность = Истина;
	КонецЕсли;
	
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПослеУдаления(Элемент)
	
	СкорректироватьСуммуСкидкиЕслиНужно();
	СкорректироватьСуммуОплатыЕслиНужно();
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаСервере
Функция НужноОбновитьФормуДокумента()
	
	СсылкаНаОбновленныйДокумент = Документы.ЧекККММП.ПолучитьСсылку(Объект.Ссылка.УникальныйИдентификатор());
	Если СсылкаНаОбновленныйДокумент <> Неопределено Тогда
		Если СсылкаНаОбновленныйДокумент.НомерПодтвержден <> Объект.НомерПодтвержден Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Если НЕ ЗначениеЗаполнено(Объект.Ссылка) И НЕ ВстроенныеПокупкиКлиент.ЕстьПодписка() Then
	// 	Отказ = Истина;
	Возврат;
	// КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


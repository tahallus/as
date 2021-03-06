
&ИзменениеИКонтроль("ОбработкаЗаполнения")
Процедура _ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("ВидОперации")
		И ДанныеЗаполнения.ВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаряд
		И ДанныеЗаполнения.Свойство("Номенклатура") Тогда

		Номенклатура = ДанныеЗаполнения.Номенклатура;
		ТабличнаяЧасть = Новый ТаблицаЗначений;
		ТабличнаяЧасть.Колонки.Добавить("Номенклатура");
		НоваяСтрока = ТабличнаяЧасть.Добавить();
		НоваяСтрока.Номенклатура = Номенклатура;

		Если Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Запас Тогда
			ИмяТЧ = "Запасы";
		ИначеЕсли Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга
			ИЛИ Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Работа Тогда
			ИмяТЧ = "Работы";
		Иначе
			ИмяТЧ = "";
		КонецЕсли;

		ДанныеЗаполнения = Новый Структура;
		Если ЗначениеЗаполнено(ИмяТЧ) Тогда
			ДанныеЗаполнения.Вставить(ИмяТЧ, ТабличнаяЧасть);
		КонецЕсли;
		Если Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.ВидРабот Тогда
			ДанныеЗаполнения.Вставить("ВидРабот", Номенклатура);
		КонецЕсли;
		ДанныеЗаполнения.Вставить("ВидОперации", Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаряд);

	КонецЕсли;

	// Перенос количества в колонку кратности при подборе через корзину
	Если ТипЗнч(ДанныеЗаполнения)=Тип("Структура") 
		И ДанныеЗаполнения.Свойство("Работы")
		И ТипЗнч(ДанныеЗаполнения.Работы)=Тип("Массив") Тогда
		Для каждого СтрокаРабот Из ДанныеЗаполнения.Работы Цикл
			Если ТипЗнч(СтрокаРабот)<>Тип("Структура")
				ИЛИ НЕ СтрокаРабот.Свойство("Количество")
				ИЛИ СтрокаРабот.Свойство("Кратность") Тогда
				Продолжить;
			КонецЕсли; 
			СтрокаРабот.Вставить("Кратность", СтрокаРабот.Количество);
			СтрокаРабот.Вставить("Количество", 1);
		КонецЦикла;
	КонецЕсли;

	// Ресурсы на основании события "Запись"
	Если ТипЗнч(ДанныеЗаполнения)=Тип("Структура")
		И ДанныеЗаполнения.Свойство("Событие")
		И ЗначениеЗаполнено(ДанныеЗаполнения.Событие)
		И ДанныеЗаполнения.Событие.ТипСобытия = Перечисления.ТипыСобытий.Запись Тогда
		РесурсыПредприятияСобытие = ДанныеЗаполнения.Событие.РесурсыПредприятия;
		Для каждого СтрокаРесурсов Из РесурсыПредприятияСобытие Цикл
			НоваяСтрока = РесурсыПредприятия.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаРесурсов);
		КонецЦикла;
		Старт = ДанныеЗаполнения.Событие.НачалоСобытия;
		Финиш = ДанныеЗаполнения.Событие.ОкончаниеСобытия;
	КонецЕсли;

	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПриемИПередачаВРемонт") Тогда
		ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, "ЗаполнитьПоПриемуВРемонт");
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
		ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, "ЗаполнитьПоДоговоруКонтрагента");
	#Вставка
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка._Медиаплан") Тогда
		ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, "_ЗаполнитьПоДаннымМедиаплана");
	#КонецВставки
	ИначеЕсли ОбщегоНазначения.ЗначениеСсылочногоТипа(ДанныеЗаполнения) Тогда
		ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, "ОбработчикЗаполнения",
		"Грузоотправитель, Грузополучатель");
	Иначе
		ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, ,
		"СостояниеЗаказа, ВариантЗавершения, ПричинаОтмены");
	КонецЕсли;

	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Событие")
		И ДанныеЗаполнения.ТипСобытия = Перечисления.ТипыСобытий.ЭлектронноеПисьмо Тогда
		ЗаполнитьДанныеЗапасовПоДаннымФормы(ДанныеЗаполнения, "ЗаказПокупателя");
	КонецЕсли;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("Событие")
		И ЗначениеЗаполнено(ДанныеЗаполнения.Событие)
		И ДанныеЗаполнения.Событие.ТипСобытия = Перечисления.ТипыСобытий.ЭлектронноеПисьмо Тогда
		ЗаполнитьДанныеЗапасовПоДаннымФормы(ДанныеЗаполнения.Событие, "ЗаказНаряд", ДанныеЗаполнения);
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(УсловияСчетаЗаказа) Тогда
		УсловияСчетаЗаказа = Справочники.ДополнительныеУсловия.ПолучитьТиповыеУсловия();
	КонецЕсли;

	ЗаполнитьДоставку(ДанныеЗаполнения);

	ДозаполнитьПоУмолчанию();

	ПечатьДокументовУНФ.ОбработкаЗаполненияОснованияПечати(ЭтотОбъект);

	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		НоменклатураВДокументахСервер.ПроверитьПереопределитьПоложениеСклада(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

Процедура _ЗаполнитьПоДаннымМедиаплана(ДанныеЗаполнения) Экспорт
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,, "Номер");
	
	Для Каждого СтрокаРаботыУслугиМедиаплан Из ДанныеЗаполнения.РаботыИУслуги Цикл 
		СтрокаЗапасы = ЭтотОбъект.Запасы.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаЗапасы, СтрокаРаботыУслугиМедиаплан);
		СтрокаЗапасы._КодСтроки = СтрокаРаботыУслугиМедиаплан.КлючСвязи;
		СтрокаЗапасы._ДатаНачала = ДанныеЗаполнения.ДатаНачала;
		СтрокаЗапасы._ДатаОкончания = ДанныеЗаполнения.ДатаОкончания;
	КонецЦикла;
	
КонецПроцедуры
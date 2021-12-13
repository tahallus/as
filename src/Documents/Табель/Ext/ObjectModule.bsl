﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ЗначениеЗаполнено(СтруктурнаяЕдиница) Тогда
		
		ПодписьОтветственного = СтруктурнаяЕдиница.ПодписьМОЛ;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.Табель.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	ПроведениеДокументовУНФ.ОтразитьДвижения("Табель", ДополнительныеСвойства.ТаблицыДляДвижений, Движения, Отказ);
	
	// Запись наборов записей.
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивИсключений = Новый Массив;
	МассивИсключений.Добавить(Справочники.ВидыРабочегоВремени.ВыходныеДни);
	МассивИсключений.Добавить(Справочники.ВидыРабочегоВремени.ОсновнойОтпуск);
	МассивИсключений.Добавить(Справочники.ВидыРабочегоВремени.НеоплачиваемыйОтпускПоРазрешениюРаботодателя);
	МассивИсключений.Добавить(Справочники.ВидыРабочегоВремени.Болезнь);
	
	Если СпособВводаДанных = Перечисления.СпособыВводаДанныхОВремени.ПоДням Тогда
		
		Для каждого СтрокаТЧ Из ОтработанноеВремяПоДням Цикл
			
			Для Счетчик = 1 По 31 Цикл
			
				НеУказаноКоличествоЧасов = НСтр("ru = 'Не указано количество часов по виду времени.'");
				
				Если ЗначениеЗаполнено(СтрокаТЧ["ПервыйВидВремени" + Счетчик])
					И НЕ ЗначениеЗаполнено(СтрокаТЧ["ПервыйЧасы" + Счетчик]) Тогда
					
					Если МассивИсключений.Найти(СтрокаТЧ["ПервыйВидВремени" + Счетчик]) = Неопределено Тогда 
						КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОтработанноеВремяПоДням",
							СтрокаТЧ.НомерСтроки, "ПервыйЧасы" + Счетчик);
						ОбщегоНазначения.СообщитьПользователю(НеУказаноКоличествоЧасов, ЭтотОбъект, КонтекстноеПоле, ,
							Отказ);
					КонецЕсли;
					
				КонецЕсли;
				
				Если ЗначениеЗаполнено(СтрокаТЧ["ВторойВидВремени" + Счетчик])
					И НЕ ЗначениеЗаполнено(СтрокаТЧ["ВторойЧасы" + Счетчик]) Тогда
					
					Если МассивИсключений.Найти(СтрокаТЧ["ВторойВидВремени" + Счетчик]) = Неопределено Тогда 
						КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОтработанноеВремяПоДням",
							СтрокаТЧ.НомерСтроки, "ВторойЧасы" + Счетчик);
						ОбщегоНазначения.СообщитьПользователю(НеУказаноКоличествоЧасов, ЭтотОбъект, КонтекстноеПоле, ,
							Отказ);
					КонецЕсли;
					
				КонецЕсли;
				
				Если ЗначениеЗаполнено(СтрокаТЧ["ТретийВидВремени" + Счетчик])
					И НЕ ЗначениеЗаполнено(СтрокаТЧ["ТретийЧасы" + Счетчик]) Тогда
					Если МассивИсключений.Найти(СтрокаТЧ["ТретийВидВремени" + Счетчик]) = Неопределено Тогда 
						КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОтработанноеВремяПоДням",
							СтрокаТЧ.НомерСтроки, "ТретийЧасы" + Счетчик);
						ОбщегоНазначения.СообщитьПользователю(НеУказаноКоличествоЧасов, ЭтотОбъект, КонтекстноеПоле, ,
							Отказ);
					КонецЕсли;
				КонецЕсли;
			
			КонецЦикла;
			
		КонецЦикла; 
		
	Иначе	
		
		Для Каждого СтрокаТЧ Из ОтработанноеВремяЗаПериод Цикл
			Для Счетчик = 1 По 6 Цикл
				
				Если ЗначениеЗаполнено(СтрокаТЧ["ВидВремени" + Счетчик])
					И Не ЗначениеЗаполнено(СтрокаТЧ["Дней" + Счетчик])
					И Не ЗначениеЗаполнено(СтрокаТЧ["Часов" + Счетчик]) Тогда
					НеУказаноКоличествоДнейИЧасов = НСтр("ru = 'Не указано количество дней и часов по виду времени.'");
					КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОтработанноеВремяЗаПериод",
						СтрокаТЧ.НомерСтроки, "ВидВремени" + Счетчик);
					ОбщегоНазначения.СообщитьПользователю(НеУказаноКоличествоДнейИЧасов, ЭтотОбъект, КонтекстноеПоле, ,
						Отказ);
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
		
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
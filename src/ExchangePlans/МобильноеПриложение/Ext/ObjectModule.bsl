﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	ДополнительныеСвойства.Вставить("Загрузка");
	
	Если Роли.Найти(Перечисления.РолиМобильногоПриложения.ПолныеПрава, "Роль") <> Неопределено Тогда
		Роли.Очистить();
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.БазовыеПрава);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ДвиженияДенегПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ДвиженияТоваровПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ПроизводствоПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ЗаказыПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.КонтрагентыПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.НоменклатураПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ОтчетДвиженияДенегПросмотр);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ОтчетОстаткиТоваровНаСкладахПросмотр);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ОтчетДолгиПросмотр);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ОтчетПродажиПросмотр);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ЧтениеОстатокВзаиморасчетов);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ЧтениеОстатокТоваров);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.РозницаПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ИнформацияОКомпанииПросмотрИРедактирование);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ДобавитьРольВТаблицу(Роль) Экспорт
	
	НоваяСтрока = Роли.Добавить();
	НоваяСтрока.Роль = Роль;
	
КонецПроцедуры

Процедура УстановитьРолиПоПрофилю(ПрофильДляУстановки) Экспорт
	
	Профиль = ПрофильДляУстановки;
	
	Роли.Очистить();
	ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.БазовыеПрава);
	
	Если ПрофильДляУстановки = Перечисления.ПрофилиМобильногоПриложения.Собственник Тогда
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.КонтрагентыПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.НоменклатураПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ЗаказыПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ДвиженияДенегПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ДвиженияТоваровПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ПроизводствоПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ОтчетДвиженияДенегПросмотр);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ОтчетОстаткиТоваровНаСкладахПросмотр);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ОтчетПродажиПросмотр);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ОтчетДолгиПросмотр);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.РозницаПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ИнформацияОКомпанииПросмотрИРедактирование);
	ИначеЕсли ПрофильДляУстановки = Перечисления.ПрофилиМобильногоПриложения.Продавец Тогда
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.КонтрагентыПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.НоменклатураТолькоПросмотр);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ЗаказыПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ДвиженияДенегПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ДвиженияТоваровПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ОтчетДвиженияДенегПросмотр);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ОтчетОстаткиТоваровНаСкладахПросмотр);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ОтчетПродажиПросмотр);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ИнформацияОКомпанииТолькоПросмотр);
	ИначеЕсли ПрофильДляУстановки = Перечисления.ПрофилиМобильногоПриложения.ТорговыйПредставитель Тогда
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.КонтрагентыПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.НоменклатураТолькоПросмотр);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ЗаказыПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ДвиженияДенегПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ДвиженияТоваровПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ОтчетДвиженияДенегПросмотр);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ОтчетОстаткиТоваровНаСкладахПросмотр);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ОтчетДолгиПросмотр);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ИнформацияОКомпанииТолькоПросмотр);
	ИначеЕсли ПрофильДляУстановки = Перечисления.ПрофилиМобильногоПриложения.СервисныйИнженер Тогда
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.КонтрагентыТолькоПросмотр);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.НоменклатураТолькоПросмотр);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ЗаказыПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ДвиженияДенегПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ДвиженияТоваровПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ОтчетДвиженияДенегПросмотр);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ОтчетОстаткиТоваровНаСкладахПросмотр);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ИнформацияОКомпанииТолькоПросмотр);
	ИначеЕсли ПрофильДляУстановки = Перечисления.ПрофилиМобильногоПриложения.РозничнаяТочка Тогда
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.НоменклатураТолькоПросмотр);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ОтчетПродажиПросмотр);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.РозницаПросмотрИРедактирование);
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.ИнформацияОКомпанииТолькоПросмотр);
	ИначеЕсли ПрофильДляУстановки = Перечисления.ПрофилиМобильногоПриложения.МобильнаяТелефония Тогда
		ДобавитьРольВТаблицу(Перечисления.РолиМобильногоПриложения.КонтрагентыТолькоПросмотр);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
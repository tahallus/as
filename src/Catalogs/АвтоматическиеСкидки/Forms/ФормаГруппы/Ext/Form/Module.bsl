﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РазрешеноРедактированиеЦенДокументов = УправлениеДоступомУНФ.РазрешеноРедактированиеЦенДокументов();
	ЭтаФорма.ТолькоПросмотр = НЕ РазрешеноРедактированиеЦенДокументов;
	
	Если Параметры.Ключ = Неопределено Или Параметры.Ключ.Пустая() Тогда
		
		Если Объект.ВариантСовместногоПрименения.Пустая() Тогда
			Объект.ВариантСовместногоПрименения = Перечисления.ВариантыСовместногоПримененияСкидокНаценок.Максимум;
		КонецЕсли;
		Объект.Наименование = Строка(Объект.ВариантСовместногоПрименения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

// Процедура - обработчик события ПриИзменении элемента ВариантСовместногоПримененияСкидок.
//
&НаКлиенте
Процедура ВариантСовместногоПримененияСкидокНаценокПриИзменении(Элемент)
	
	Если ПустаяСтрока(Объект.Наименование) Тогда
		Объект.Наименование = Строка(Объект.ВариантСовместногоПрименения);
	Иначе
		Для Каждого ЭлементСписка Из Элементы.ВариантСовместногоПримененияСкидокНаценок.СписокВыбора Цикл
			Если Строка(ЭлементСписка.Значение) = Объект.Наименование Тогда
				Объект.Наименование = Строка(Объект.ВариантСовместногоПрименения);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

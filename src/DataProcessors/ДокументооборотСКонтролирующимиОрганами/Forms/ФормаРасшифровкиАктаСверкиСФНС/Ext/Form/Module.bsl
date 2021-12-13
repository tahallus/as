﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ПолучитьИзВременногоХранилища(Параметры.АдресДанныхСверки);
	Если Результат.Количество() > 0 Тогда
		
		Расшифровка = СтрРазделить(Параметры.НомерСтрокиСверки, ";");
		
		ДанныеАктаСверки = Результат[Число(Расшифровка[0])]; // выбор акта сверки из таблицы сверок
		
		// Передаем строку сверки, по которой нужно вывести расшифровку.
		КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
		РасшифровкаАктаСверки.Вывести(
			КонтекстЭДОСервер.СформироватьРасшифровку(ДанныеАктаСверки, Число(Расшифровка[1])));
		
	Иначе
		
		ВызватьИсключение НСтр("ru = 'Данные для расшифровки отсутствуют'");
		
	КонецЕсли;
	
КонецПроцедуры

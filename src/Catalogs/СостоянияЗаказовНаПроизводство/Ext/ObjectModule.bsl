﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	Цвет = Новый ХранилищеЗначения(ОбъектКопирования.Цвет.Получить());
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитДопУпорядочивания = НовыйРеквизитДопУпорядочивания();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НовыйРеквизитДопУпорядочивания()
	
	Если Ссылка = Справочники.СостоянияЗаказовНаПроизводство.Завершен Тогда
		Возврат 99999; // Всегда последним.
	КонецЕсли;
	
	Если НЕ ЭтоНовый() И РеквизитДопУпорядочивания <> 0 И РеквизитДопУпорядочивания <> 99999 Тогда
		Возврат РеквизитДопУпорядочивания;
	КонецЕсли;
	
	СтарыйРеквизитДопУпорядочивания = Неопределено;
	Если ЗначениеЗаполнено(Ссылка) Тогда
		СтарыйРеквизитДопУпорядочивания = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "РеквизитДопУпорядочивания");
	КонецЕсли;
	
	Если РеквизитДопУпорядочивания = 99999 И СтарыйРеквизитДопУпорядочивания <> Неопределено Тогда
		Возврат СтарыйРеквизитДопУпорядочивания;
	КонецЕсли;
	
	Возврат НовыйМаксимальныйРеквизитДопУпорядочивания(СтарыйРеквизитДопУпорядочивания);
	
КонецФункции

Функция НовыйМаксимальныйРеквизитДопУпорядочивания(СтарыйРеквизитДопУпорядочивания)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СостоянияЗаказовНаПроизводство.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания
	|ИЗ
	|	Справочник.СостоянияЗаказовНаПроизводство КАК СостоянияЗаказовНаПроизводство
	|ГДЕ
	|	СостоянияЗаказовНаПроизводство.Ссылка <> ЗНАЧЕНИЕ(Справочник.СостоянияЗаказовНаПроизводство.Завершен)
	|	И СостоянияЗаказовНаПроизводство.Ссылка <> &СтарыйРеквизитДопУпорядочивания
	|	И СостоянияЗаказовНаПроизводство.РеквизитДопУпорядочивания < (ВЫРАЗИТЬ(99998 КАК ЧИСЛО(5, 0)))
	|
	|УПОРЯДОЧИТЬ ПО
	|	РеквизитДопУпорядочивания УБЫВ";
	
	Запрос.УстановитьПараметр("СтарыйРеквизитДопУпорядочивания", СтарыйРеквизитДопУпорядочивания);
	Выборка = Запрос.Выполнить().Выбрать();
	
	НовыйМаксимальныйРеквизитДопУпорядочивания = 0;
	Если Выборка.Следующий() Тогда
		НовыйМаксимальныйРеквизитДопУпорядочивания = Выборка.РеквизитДопУпорядочивания;
	КонецЕсли;
	
	НовыйМаксимальныйРеквизитДопУпорядочивания = НовыйМаксимальныйРеквизитДопУпорядочивания + 1;
	
	Если НовыйМаксимальныйРеквизитДопУпорядочивания = 99999 Тогда
		НовыйМаксимальныйРеквизитДопУпорядочивания = 1;
	КонецЕсли;
	
	Возврат НовыйМаксимальныйРеквизитДопУпорядочивания;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
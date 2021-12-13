﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Патент = Параметры.Патент;
	СпециальныйНалоговыйРежим = Параметры.СпециальныйНалоговыйРежим;
	Комментарий = Параметры.Комментарий;
	Контрагент = Параметры.Контрагент;
	Ответственный = Параметры.Ответственный;
	Подразделение = Параметры.Подразделение;
	ДисконтнаяКарта = Параметры.ДисконтнаяКарта;
	
	НастроитьВидимостьЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпециальныйНалоговыйРежимПриИзменении(Элемент)
	СпециальныйНалоговыйРежимПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	СтруктураДляВозврата = Новый Структура;
	
	СтруктураДляВозврата.Вставить("Патент", Патент);
	СтруктураДляВозврата.Вставить("СпециальныйНалоговыйРежим", СпециальныйНалоговыйРежим);
	СтруктураДляВозврата.Вставить("Комментарий", Комментарий);
	СтруктураДляВозврата.Вставить("Контрагент", Контрагент);
	СтруктураДляВозврата.Вставить("Ответственный", Ответственный);
	СтруктураДляВозврата.Вставить("Подразделение", Подразделение);
	СтруктураДляВозврата.Вставить("ДисконтнаяКарта", ДисконтнаяКарта);
	
	Закрыть(СтруктураДляВозврата);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьВидимостьЭлементов()
	Элементы.Патент.Видимость = (СпециальныйНалоговыйРежим = Перечисления.СпециальныеНалоговыеРежимы.ПСН);
КонецПроцедуры

&НаСервере
Процедура СпециальныйНалоговыйРежимПриИзмененииНаСервере()
	НастроитьВидимостьЭлементов();
КонецПроцедуры

#КонецОбласти

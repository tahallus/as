﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если СокрЛП(Объект.Наименование)="" Тогда
	    Отказ = Истина;
		
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Шаблон не заполнен!'");
		Сообщение.Сообщить();
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

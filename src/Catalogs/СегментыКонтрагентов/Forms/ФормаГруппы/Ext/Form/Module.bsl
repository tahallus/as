﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_СегментКонтрагентовГруппа", Объект.Ссылка, ЭтотОбъект);
КонецПроцедуры

#КонецОбласти
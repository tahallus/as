﻿
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СформироватьНаименование()
	
	Объект.Наименование = НСтр("ru = 'Серия '") + Объект.СерияЛицензионнойКарты + НСтр("ru = ' № '") + Объект.НомерЛицензионнойКарты + НСтр("ru = ' от '") + Формат(Объект.ДатаВыдачиЛицензионнойКарты, "ДФ=dd.MM.yyyy");
	
	Если ЗначениеЗаполнено(Объект.ВладелецЛицензии) Тогда
		
		Объект.Наименование = Объект.Наименование + НСтр("ru = '. Владелец: '") + Объект.ВладелецЛицензии;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СерияЛицензионнойКартыПриИзменении(Элемент)
	
	СформироватьНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура НомерЛицензионнойКартыПриИзменении(Элемент)
	
	СформироватьНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаВыдачиЛицензионнойКартыПриИзменении(Элемент)
	
	СформироватьНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецЛицензииПриИзменении(Элемент)
	
	СформироватьНаименование();
	
КонецПроцедуры

#КонецОбласти
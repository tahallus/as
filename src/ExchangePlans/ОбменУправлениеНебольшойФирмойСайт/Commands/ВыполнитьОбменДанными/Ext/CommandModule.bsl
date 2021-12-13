﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	УзелОбмена = ПараметрКоманды;

	Если УзелОбмена = ОбменССайтомПовтИсп.ПолучитьЭтотУзелПланаОбмена("ОбменУправлениеНебольшойФирмойСайт") Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр(
			"ru = 'Узел соответствует этой информационной базе и не может использоваться в обмене с сайтом. Используйте другой узел обмена или создайте новый.'"));
		Возврат;
	КонецЕсли;

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УзелОбмена", УзелОбмена);
	ПараметрыФормы.Вставить("ВыгружатьТолькоИзменения", Истина);

	ОткрытьФорму("ПланОбмена.ОбменУправлениеНебольшойФирмойСайт.Форма.ФормаВыполнениеОбмена", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник, УзелОбмена);

КонецПроцедуры

#КонецОбласти

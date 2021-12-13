﻿// См. ТарификацияПереопределяемый.ПриФормированииСпискаУслуг
Процедура ПриФормированииСпискаУслуг(ПоставщикиУслуг) Экспорт
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		МодульОбменСКонтрагентами = ОбщегоНазначения.ОбщийМодуль("ОбменСКонтрагентамиИнтеграцияСобытия");
		МодульОбменСКонтрагентами.ПриФормированииСпискаУслуг(ПоставщикиУслуг);
	КонецЕсли;
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	// ЭлектронноеВзаимодействие.БизнесСеть
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.БизнесСеть") Тогда
		МодульОбменБизнесСеть = ОбщегоНазначения.ОбщийМодуль("БизнесСеть");
		МодульОбменБизнесСеть.ПриФормированииСпискаУслуг(ПоставщикиУслуг);
	КонецЕсли;
	// Конец ЭлектронноеВзаимодействие.БизнесСеть
	
КонецПроцедуры

// Конец ТехнологияСервиса.УправлениеТарифами
﻿#Область ПрограммныйИнтерфейс

// Может использоваться для корректировки параметра ПараметрыСканирования.ККТФФД12ИСМП, например,
// в том случае, когда в процессе сканирования уточнена номенклатура, и эта номенклатура должна фискализироваться на 
// устройстве, отличном от установленно ранее в параметре ПараметрыСканирования.ККТФФД12ИСМП.
// 
// Параметры:
//  ДанныеОписания        - Структура - Может быть двих разновидностей:
//                                      1. Данные штрихкода - в случае обработке на сервере.
//                                      2. Данные выбора    - при сканировании неизвестного года и уточннения
//                                                            номенклатуры (при обработке на клиенте).
//                                      В обоих случаях в данных присутствуют поля описания: Номенклатура, Характеристика, Серия.
//  ПараметрыСканирования - (См. ШтрихкодированиеИСКлиент.ПараметрыСканирования).
Процедура УстановитьККТФФД12ПоДаннымОписанияТовара(ДанныеОписания, ПараметрыСканирования) Экспорт
	
	ТипОборудования = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("ККТ");
	
	СписокДоступныхУстройств =  МенеджерОборудованияВызовСервера.ОборудованиеПоПараметрам(ТипОборудования);
	Если СписокДоступныхУстройств.Количество() = 1 Тогда
		ИдентификаторУстройства = СписокДоступныхУстройств[0].Ссылка;
		
		Если МенеджерОборудованияВызовСервера.ФискальноеУстройствоПоддерживаетПроверкуКодовМаркировки(ИдентификаторУстройства) Тогда
			ПараметрыСканирования.ТребуетсяПроверкаСредствамиККТ = Истина;
			ПараметрыСканирования.ККТФФД12ИСМП                   = ИдентификаторУстройства;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
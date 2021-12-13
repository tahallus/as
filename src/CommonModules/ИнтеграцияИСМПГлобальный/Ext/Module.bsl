﻿#Область СлужебныеПроцедурыИФункции

// Выполняет обновление настроек ответственного за актуализацию токенов авторизации ИСМП.
// Настройки содержатся в глобальной переменной ПараметрыПриложения.
//
Процедура ОбработчикОжиданияВыполнитьОбновлениеНастроекОтветственногоЗаАктуализациюТокеновАвторизации() Экспорт
	
	ИнтеграцияИСМПКлиент.ВыполнитьОбновлениеНастроекОтветственногоЗаАктуализациюТокеновАвторизации();
	
КонецПроцедуры

// Проверяет наличие напоминаний для ответственного за актуализацию токенов авторизации ИСМП.
// При необходимости, открывает форму актуализации токенов авторизации ИС МП.
//
Процедура ОбработчикОжиданияПроверитьНапоминанияОтветственномуЗаАктуализациюТокеновАвторизации() Экспорт
	
	ИнтеграцияИСМПКлиент.ПроверитьНапоминанияОтветственномуЗаАктуализациюТокеновАвторизации();
	
КонецПроцедуры

#КонецОбласти
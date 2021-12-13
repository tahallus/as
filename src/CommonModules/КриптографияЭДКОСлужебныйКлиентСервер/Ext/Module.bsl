﻿#Область СлужебныйПрограммныйИнтерфейс

#Область ОписанияОшибок

Функция ОшибкаНеУдалосьПодключитьВнешнююКомпоненту() Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "НеУдалосьПодключитьВнешнююКомпоненту";
	Ошибка.Описание = НСтр("ru = 'Не удалось подключить внешнюю компоненту для работы с криптографией'");
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаНеУстановленКриптопровайдерCryptoPro() Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "НеУстановленКриптопровайдерCryptoPro";
	Ошибка.Описание = СтрШаблон(
		НСтр("ru = 'Не установлен криптопровайдер %1'"),
		КриптографияЭДКОКлиентСервер.КриптопровайдерCryptoPro().Представление);
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаНеУстановленКриптопровайдерViPNet() Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "НеУстановленКриптопровайдерViPNet";
	Ошибка.Описание = СтрШаблон(
		НСтр("ru = 'Не установлен криптопровайдер %1'"),
		КриптографияЭДКОКлиентСервер.КриптопровайдерViPNet().Представление);
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаНедоступенЗакрытыйКлюч() Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "НедоступенЗакрытыйКлюч";
	Ошибка.Описание = НСтр("ru = 'Недоступен закрытый ключ'");
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаНеклассифицированнаяОшибкаВыполнения(ОписаниеОшибки) Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "НеклассифицированнаяОшибкаВыполнения";	
	Ошибка.Описание = ОписаниеОшибки;
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаСервисКриптографииНеДоступенДляИспользования() Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "СервисКриптографииНеДоступенДляИспользования";
	Ошибка.Описание = НСтр("ru = 'Сервис криптографии недоступен для использования'");
	
	Возврат Ошибка;

КонецФункции

Функция ОшибкаНекорректныйФорматФайлаДляРасшифровки(ОписаниеФайла) Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "НекорректныйФорматФайлаДляРасшифровки";
	
	Если ЗначениеЗаполнено(ОписаниеФайла) Тогда
		Ошибка.Описание = СтрШаблон(НСтр("ru = 'Некорректный формат файла для расшифровки: %1'"), ОписаниеФайла);
	Иначе
		Ошибка.Описание = НСтр("ru = 'Некорректный формат файла для расшифровки'");
	КонецЕсли;
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаПустойФайлДляРасшифровки(ОписаниеФайла) Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "ПустойФайлДляРасшифровки";
	
	Если ЗначениеЗаполнено(ОписаниеФайла) Тогда
		Ошибка.Описание = СтрШаблон(НСтр("ru = 'Для расшифровки передан пустой файл: %1'"), ОписаниеФайла);
	Иначе
		Ошибка.Описание = НСтр("ru = 'Некорректный формат файла для расшифровки'");
	КонецЕсли;
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаВнешняяКомпонентаПодключенаНоНеУдалосьСоздатьAddIn() Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "ВнешняяКомпонентаПодключенаНоНеУдалосьСоздатьAddIn";
	Ошибка.Описание = НСтр("ru = 'Не удалось создать объект для работы с криптографией'");
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаНеУдалосьПодключитьРасширениеДляРаботыСФайлами() Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "НеУдалосьПодключитьРасширениеДляРаботыСФайлами";
	Ошибка.Описание = НСтр("ru = 'Не удалось подключить расширение для работы с файлами'");
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаОтсутствуетКомпонентаДляИспользуемогоКлиентскогоПриложения() Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "ОтсутствуетКомпонентаДляИспользуемогоКлиентскогоПриложения";
	Ошибка.Описание = НСтр("ru = 'Отсутствует компонента для используемого клиентского приложения'");
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаНеУстановленКриптопровайдер(Криптопровайдер) Экспорт
	
	Если ЗначениеЗаполнено(Криптопровайдер) Тогда
		Если Криптопровайдер.ТипКриптопровайдера = ПредопределенноеЗначение("Перечисление.ТипыКриптоПровайдеров.CryptoPro") Тогда
			Возврат	КриптографияЭДКОСлужебныйКлиентСервер.ОшибкаНеУстановленКриптопровайдерCryptoPro();
		ИначеЕсли Криптопровайдер.ТипКриптопровайдера = ПредопределенноеЗначение("Перечисление.ТипыКриптоПровайдеров.VipNet") Тогда
			Возврат КриптографияЭДКОСлужебныйКлиентСервер.ОшибкаНеУстановленКриптопровайдерViPNet();	
		Иначе
			ВызватьИсключение(СтрШаблон(НСтр("ru = 'Криптопровайдер %1 не поддерживается'"), Криптопровайдер.Имя));
		КонецЕсли;
	Иначе
		Возврат ОшибкаНеУстановленНиОдинИзПоддерживаемыхКриптопровайдеров();
	КонецЕсли;
	
КонецФункции

Функция ОшибкаВведенНеправильныйPINКод() Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "ВведенНеправильныйPINКод";
	Ошибка.Описание = НСтр("ru = 'Введен неправильный PIN-код'");
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаТокенЗаблокирован() Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "ТокенЗаблокирован";
	Ошибка.Описание = НСтр("ru = 'Число попыток ввести правильный PIN-код исчерпано. Токен заблокирован'");
	
	Возврат Ошибка;

КонецФункции

Функция ОшибкаОперацияБылаОтмененаПользователем() Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "ОперацияБылаОтмененаПользователем";
	Ошибка.Описание = НСтр("ru = 'Операция была отменена пользователем'");
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаНеУстановленНиОдинИзПоддерживаемыхКриптопровайдеров() Экспорт
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		ЭтоLinux = ОбщегоНазначения.ЭтоLinuxКлиент();
	#Иначе
		ЭтоLinux = ОбщегоНазначенияКлиент.ЭтоLinuxКлиент();
	#КонецЕсли
	
	ПоддерживаемыеКриптопровайдеры = Новый Массив;
	ИнформацияОПоддерживаемыхКриптопровайдерах = КриптографияЭДКОКлиентСервер.ПоддерживаемыеКриптопровайдеры(, ЭтоLinux);
	Для Каждого ПоддерживаемыйКриптопровайдер Из ИнформацияОПоддерживаемыхКриптопровайдерах Цикл
		Если ПоддерживаемыеКриптопровайдеры.Найти(ИнформацияОПоддерживаемыхКриптопровайдерах.Представление) = Неопределено Тогда
			ПоддерживаемыеКриптопровайдеры.Добавить(ПоддерживаемыйКриптопровайдер.Представление);
		КонецЕсли;
	КонецЦикла;
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "НеУстановленНиОдинИзПоддерживаемыхКриптопровайдеров";
	Ошибка.Описание = СтрШаблон(
		НСтр("ru = 'Не установлен ни один из поддерживаемых криптопровайдеров: %1'"),
		СтрСоединить(ПоддерживаемыеКриптопровайдеры, ", "));
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаНеУдалосьИнициализироватьМенеджерКриптографии(Криптопровайдер, КодОшибки) Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "НеУдалосьИнициализироватьМенеджерКриптографии";
	
	Ошибка.Описание = СтрШаблон(
		НСтр("ru = 'Не удалось инициализировать менеджер криптографии по причине:
              |%1: код ошибки %2'"),
		Криптопровайдер.Представление, КодОшибки);
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаСертификатНеУстановленВСистемноеХранилище() Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "СертификатНеУстановленВСистемноеХранилище";
	Ошибка.Описание = НСтр("ru = 'Сертификат не установлен в системное хранилище'");
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаСертификатИлиЗакрытыйКлючНеНайдены() Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "СертификатИлиЗакрытыйКлючНеНайдены";
	Ошибка.Описание = НСтр("ru = 'Сертификат и/или закрытый ключ не найдены'");
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаСертификатНеСвязанСЗакрытымКлючом() Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "СертификатНеСвязанСЗакрытымКлючом";
	Ошибка.Описание = НСтр("ru = 'Сертификат не связан с закрытым ключом'");
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаСертификатОтключен() Экспорт
	            
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "СертификатОтключен";
	Ошибка.Описание = НСтр("ru = 'Сертификат отключен'");
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаСертификатОтключенНаВремяСеанса() Экспорт
	            
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "СертификатОтключенНаВремяСеанса";
	Ошибка.Описание = НСтр("ru = 'Сертификат отключен на время сеанса'");
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаРасшифровкиСервисомКриптографии(ИнформацияОбОшибке) Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "ОшибкаРасшифровкиСервисомКриптографии";
	Ошибка.Описание = СтрШаблон(НСтр("ru = 'Сервис криптографии: %1'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаViPNetCSPНеЗарегистрирован() Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "ViPNetCSPНеЗарегистрирован";
	Ошибка.Описание = НСтр("ru = 'Закончился демонстрационный период использования программы ViPNet CSP'");
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаРасшифровкиЛокальнымКриптопровайдером(Криптопровайдер = Неопределено, КодОшибки = Неопределено, ОписаниеОшибки = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(КодОшибки) Тогда
		КодыОшибок = Новый Соответствие;
		КодыОшибок.Вставить(-2146885628, ОшибкаСертификатИлиЗакрытыйКлючНеНайдены()); // 0x80092004 Объект или свойство не найдено
		
		// КриптоПро CSP: Введен неверный PIN
		КодыОшибок.Вставить(-2146434965, КриптографияЭДКОСлужебныйКлиентСервер.ОшибкаВведенНеправильныйPINКод()); // 0x8010006b Нет доступа к карте. Введен неправильный PIN-код
		
		// КриптоПро CSP: Пользователь отказался от ввода пароля.
		КодыОшибок.Вставить(-2146434962, КриптографияЭДКОСлужебныйКлиентСервер.ОшибкаОперацияБылаОтмененаПользователем()); // 0x8010006e Действие было отменено пользователем 0x8010006e
		
		// ViPNet CSP: Операция была отменена пользователем.
		КодыОшибок.Вставить(1223, КриптографияЭДКОСлужебныйКлиентСервер.ОшибкаОперацияБылаОтмененаПользователем()); // 0x000004c7 Операция была отменена пользователем
		
		// ViPNet CSP: Закончился демонстрационный период использования
		КодыОшибок.Вставить(8344, КриптографияЭДКОСлужебныйКлиентСервер.ОшибкаViPNetCSPНеЗарегистрирован()); // 0x00002098 Для выполнения операции права недостаточны
		
		// КриптоПро CSP: Введен неверный PIN при хранении ключа на токене
		КодыОшибок.Вставить(-2146885621, КриптографияЭДКОСлужебныйКлиентСервер.ОшибкаВведенНеправильныйPINКод()); // 0x8009200b Не удается найти сертификат и закрытый ключ для расшифровки
		
		// КриптоПро CSP: Превышено количество неверных попыток ввода PIN-код
		КодыОшибок.Вставить(-2146434964, КриптографияЭДКОСлужебныйКлиентСервер.ОшибкаТокенЗаблокирован()); // 0x8010006c Нет доступа к карте. Число попыток ввести правильный PIN-код исчерпано       
		
		Ошибка = КодыОшибок.Получить(КодОшибки);
		Если Ошибка = Неопределено Тогда		
			Ошибка = Новый Структура("Код, Описание");
			Ошибка.Код = "ОшибкаРасшифровкиЛокальнымКриптопровайдером";
			Ошибка.Описание = СтрШаблон("%1: %2 (%3)", Криптопровайдер.Представление, СокрЛП(ОписаниеОшибки), Формат(КодОшибки, "ЧРГ=; ЧГ="));
		КонецЕсли;
	Иначе
		Ошибка = Новый Структура("Код, Описание");
		Ошибка.Код = "ОшибкаРасшифровкиЛокальнымКриптопровайдером";
		Ошибка.Описание = НСтр("ru = 'Ошибка при расшифровке локальным криптопровайдером'");
	КонецЕсли;
	
	Возврат Ошибка;

КонецФункции

Функция ОшибкаУстановленоБолееОдногоКриптопровайдера(УстановленныеКриптопровайдеры = Неопределено) Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "УстановленоБолееОдногоКриптопровайдера";
	Если Не ЗначениеЗаполнено(УстановленныеКриптопровайдеры) Тогда
		Ошибка.Описание = НСтр("ru = 'На вашем компьютере установлено более одного криптопровайдера'");
	Иначе
		Криптопровайдеры = Новый Массив;
		Для Каждого УстановленныйКриптопровайдер ИЗ УстановленныеКриптопровайдеры Цикл
			Криптопровайдеры.Добавить(УстановленныйКриптопровайдер.Представление);
		КонецЦикла;
		
		Ошибка.Описание = СтрШаблон(НСтр("ru = 'На вашем компьютере установлено более одного криптопровайдера: %1'"), СтрСоединить(Криптопровайдеры, ", "));		
	КонецЕсли;
	
	Возврат Ошибка;

КонецФункции

Функция ОшибкаНеУдалосьРасшифроватьФайл(ОписаниеФайла) Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "НеУдалосьРасшифроватьФайл";
	
	Если ЗначениеЗаполнено(ОписаниеФайла) Тогда
		Ошибка.Описание = СтрШаблон(НСтр("ru = 'Не удалось расшифровать файл: %1'"), ОписаниеФайла);
	Иначе
		Ошибка.Описание = НСтр("ru = 'Не удалось расшифровать файл'");
	КонецЕсли;
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаНетАктивныхСертификатовДляРасшифровкиФайла(ОписаниеФайла = Неопределено) Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "НетАктивныхСертификатовДляРасшифровкиФайла";
	
	Если ЗначениеЗаполнено(ОписаниеФайла) Тогда
		Ошибка.Описание = СтрШаблон(НСтр("ru = 'Нет активных сертификатов для расшифровки файла: %1'"), ОписаниеФайла);
	Иначе
		Ошибка.Описание = НСтр("ru = 'Нет активных сертификатов для расшифровки файла'");
	КонецЕсли;
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаНеУдалосьПолучитьСсылкуНаЗакрытыйКлюч(Сертификат) Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "НеУдалосьПолучитьСсылкуНаЗакрытыйКлюч";
	Ошибка.Описание = СтрШаблон(НСтр("ru = 'Ошибка при получении ссылки на закрытый ключ сертификата %1'"), ПредставлениеСертификатаДляОшибки(Сертификат));
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаНеУдалосьВыгрузитьСертификат(Сертификат) Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "НеУдалосьВыгрузитьСертификат";
	Ошибка.Описание = СтрШаблон(НСтр("ru = 'Не удалось выгрузить сертификат %1'"), ПредставлениеСертификатаДляОшибки(Сертификат));
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаНеУдалосьПолучитьСписокКлючевыхКонтейнеров(Криптопровайдер) Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "НеУдалосьПолучитьСписокКлючевыхКонтейнеров";
	Ошибка.Описание = СтрШаблон(НСтр("ru = 'Не удалось получить список ключевых контейнеров криптопровайдера ""%1""'"), Криптопровайдер.Представление);
	
	Возврат Ошибка;

КонецФункции

Функция ОшибкаУдостоверяющийЦентрНеАвторизованФирмой1С(УдостоверяющийЦентр) Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "УдостоверяющийЦентрНеАвторизованФирмой1С";
	Ошибка.Описание = СтрШаблон(НСтр("ru = 'Удостоверяющий центр ""%1"" не авторизован фирмой 1С'"), УдостоверяющийЦентр);
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаУстановкиСертификатаСервисомКриптографии(ИнформацияОбОшибке) Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "ОшибкаУстановкиСертификатаСервисомКриптографии";
	Ошибка.Описание = СтрШаблон(НСтр("ru = 'Сервис криптографии: %1'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаНеУдалосьУстановитьСертификатВКонтейнерЗакрытогоКлюча(Сертификат, Код = 0, Описание = "") Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "НеУдалосьУстановитьСертификатВКонтейнерЗакрытогоКлюча";
	Если ЗначениеЗаполнено(Код) Тогда
		Ошибка.Описание = СтрШаблон(
			НСтр("ru = 'Не удалось установить сертификат %1 в контейнер закрытого ключа %2.
                  |%3 (%4)'"),
			ПредставлениеСертификатаДляОшибки(Сертификат.Сертификат),
			Сертификат.КонтейнерЗакрытогоКлюча,
			Описание,
			Формат(Код, "ЧРГ=; ЧГ="));
	Иначе
		Ошибка.Описание = СтрШаблон(
			НСтр("ru = 'Не удалось установить сертификат %1 в контейнер закрытого ключа %2'"),
			ПредставлениеСертификатаДляОшибки(Сертификат.Сертификат),
			Сертификат.КонтейнерЗакрытогоКлюча);
	КонецЕсли;
	
	Возврат Ошибка;
	
КонецФункции

Функция ОшибкаНеУдалосьУстановитьСертификатВСистемноеХранилище(Сертификат, Код = 0, Описание = "") Экспорт
	
	Ошибка = Новый Структура("Код, Описание");
	Ошибка.Код = "НеУдалосьУстановитьСертификатВСистемноеХранилище";
	Если ЗначениеЗаполнено(Код) Тогда
		Ошибка.Описание = СтрШаблон(
			НСтр("ru = 'Не удалось установить сертификат %1 в системное хранилище %2.
                  |%3 (%4)'"),
			ПредставлениеСертификатаДляОшибки(Сертификат.Сертификат),
			Сертификат.Хранилище,
			Описание,
			Формат(Код, "ЧРГ=; ЧГ="));
	Иначе
		Ошибка.Описание = СтрШаблон(
			НСтр("ru = 'Не удалось установить сертификат %1 в системное хранилище %2'"),
			ПредставлениеСертификатаДляОшибки(Сертификат.Сертификат),
			Сертификат.Хранилище);
	КонецЕсли;
		
	Возврат Ошибка;
	
КонецФункции

#КонецОбласти

Функция ЕстьОшибка(МассивОшибок, Ошибка) Экспорт
	
	Для Каждого ОшибкаСертификата Из МассивОшибок Цикл
		Если ОшибкаСертификата.Код = Ошибка.Код Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Процедура УдалитьОшибку(Ошибки, УдаляемаяОшибка) Экспорт
	
	ОшибкаБылаЗаменена = Ложь;
	Для Индекс = 0 По Ошибки.ВГраница() Цикл
		Если Ошибки[Индекс].Код = УдаляемаяОшибка.Код Тогда
			Ошибки.Удалить(Индекс);
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Возвращает описания авторизованных фирмой 1С удостоверяющих центров.
//
// Возвращаемое значение:
//	ФиксированныйМассив - массив с описаниями удостоверяющих центров.
//  * Наименование - Строка - наименование УЦ.
//  * Идентификаторы - Массив  - идентификаторы УЦ. Составляющая 'O' из издателя сертификата.
//
Функция АвторизованныеУдостоверяющиеЦентры() Экспорт
	
	УдостоверяющиеЦентры = Новый Массив;
	УдостоверяющиеЦентры.Добавить(
		УдостоверяющийЦентр(
			"ООО ""Гарант-Телеком""",
			"Garant Telecom Ltd|Garant-Telecom Ltd"));
	
	УдостоверяющиеЦентры.Добавить(
		УдостоверяющийЦентр(
			"ООО ""Такском""",
			"OOO Taxcom|ООО ""Такском""|Общество с ограниченной ответственностью ""Такском""|ООО ""ТАКСКОМ"""));
	
	УдостоверяющиеЦентры.Добавить(
		УдостоверяющийЦентр(
			"ООО ""Мостинфо-Екатеринбург""",
			"ООО Мостинфо-Екатеринбург|ООО ""МОСТИНФО""|ООО 'МОСТИНФО'|Общество с ограниченной ответственностью ""Мостинфо-Екатеринбург"""));
	
	УдостоверяющиеЦентры.Добавить(
		УдостоверяющийЦентр(
			"ФГУП ГНИВЦ ФНС в СФО",
			"ФГУП ГНИВЦ ФНС России|АО ГНИВЦ|АО ""ГНИВЦ""|АО «ГНИВЦ»"));
	
	УдостоверяющиеЦентры.Добавить(
		УдостоверяющийЦентр(
			"ЗАО ""Удостоверяющий центр"" ekey.ru",
			"ЗАО Удостоверяющий центр|ЗАО 'Удостоверяющий Центр'|ООО «Екей УЦ»|ООО ""Екей УЦ"""));
	
	УдостоверяющиеЦентры.Добавить(
		УдостоверяющийЦентр(
			"ООО ""Линк-сервис""",
			"Link Service Ltd|ООО Линк-сервис|ООО ""Линк-сервис""|ООО «Линк-сервис»"));
	
	УдостоверяющиеЦентры.Добавить(
		УдостоверяющийЦентр(
			"ООО ""Компания Раздолье""",
			"ООО Компания Раздолье|ООО ""Компания ""Раздолье"""));
	
	УдостоверяющиеЦентры.Добавить(
		УдостоверяющийЦентр(
			"АО ""Калуга Астрал""",
			"ЗАО Калуга Астрал|ЗАО ""Калуга Астрал""|ЗАО ""КАЛУГА АСТРАЛ""|АО ""Калуга Астрал""|АО ""КАЛУГА АСТРАЛ""|ООО ""Астрал-М""|ООО ""АСТРАЛ-М"""));
	
	УдостоверяющиеЦентры.Добавить(
		УдостоверяющийЦентр(
			"ООО НПФ ""Форус""",
			"ООО НПФ Форус|ООО НПФ «Форус»|ООО НПФ ""Форус"""));
	
	УдостоверяющиеЦентры.Добавить(
		УдостоверяющийЦентр(
			"ООО ""НПЦ ""1С""""",
			"Фирма 1С|НПЦ 1С|ООО ""НПЦ ""1С""|ООО ""НПЦ ""1С"""""));
	
	УдостоверяющиеЦентры.Добавить(
		УдостоверяющийЦентр(
			"CA TechnoKad",
			"ООО ТехноКад|ООО ""ТехноКад"""));
	
	УдостоверяющиеЦентры.Добавить(
		УдостоверяющийЦентр(
			"ЗАО ""ЦЭК""",
			"ЗАО ""ЦЭК"""));
	
	УдостоверяющиеЦентры.Добавить(
		УдостоверяющийЦентр(
			"ООО «ЛИССИ-Софт»",
			"ООО «ЛИССИ-Софт»"));
	
	УдостоверяющиеЦентры.Добавить(
		УдостоверяющийЦентр(
			"CA OOO UC Belinfonalog",
			"ООО УЦ Белинфоналог|ООО ""УЦ ""Белинфоналог""|ООО «УЦ «Белинфоналог»"));
	
	УдостоверяющиеЦентры.Добавить(
		УдостоверяющийЦентр(
			"АО ""Электронная Москва""",
			"АО ""Электронная Москва""|АО «Электронная Москва»|Акционерное общество ""Электронная Москва"""));
	
	УдостоверяющиеЦентры.Добавить(
		УдостоверяющийЦентр(
			"Федеральное казначейство",
			"Федеральное казначейство|Корневой тестовый УЦ ФК ГОСТ-2012|Подчинённый тестовый УЦ ФК ГОСТ-2012"));
	
	УдостоверяющиеЦентры.Добавить(
		УдостоверяющийЦентр(
			"АО ""ТАНДЕР""",
			"АО ""ТАНДЕР""|АО Тандер|АО ""Тандер"""));
	
	УдостоверяющиеЦентры.Добавить(
		УдостоверяющийЦентр(
			"Федеральная налоговая служба",
			"Федеральная налоговая служба"));
	
	УдостоверяющиеЦентры.Добавить(
		УдостоверяющийЦентр(
			"АО ""ЕЭТП""",
			"АО ""ЕЭТП"""));
	
	УдостоверяющиеЦентры.Добавить(
		УдостоверяющийЦентр(
			"ЗАО ""Национальный удостоверяющий центр""",
			"ЗАО «Национальный удостоверяющий центр»|ЗАО ""Национальный удостоверяющий центр""|БАНК РОССИИ"));
	
	УдостоверяющиеЦентры.Добавить(
		УдостоверяющийЦентр(
			"АО ""Аналитический Центр""",
			"Акционерное общество ""Аналитический Центр""|АО ""Аналитический Центр"""));
	
	Возврат Новый ФиксированныйМассив(УдостоверяющиеЦентры);
	
КонецФункции

Функция ТипКриптосообщенияЗашифрованныеДанные() Экспорт
	
	Возврат "EnvelopedData";
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПредставлениеСертификатаДляОшибки(Сертификат)
	
	Возврат СтрШаблон("Издатель: %1, Серийный номер: %2", Сертификат.Поставщик, Сертификат.СерийныйНомер);
	
КонецФункции

Функция УдостоверяющийЦентр(Наименование, Идентификаторы)
	
	УЦ = Новый Структура;
	УЦ.Вставить("Наименование", Наименование);
	УЦ.Вставить("Идентификаторы", Новый ФиксированныйМассив(СтрРазделить(Идентификаторы, "|")));
	
	Возврат УЦ;
			
КонецФункции

#КонецОбласти
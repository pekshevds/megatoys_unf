///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Подключение 1С-Такском".
// ОбщийМодуль.Подключение1СТакскомПереопределяемый.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяет разрешение использовать функции сервиса 1С-Такском
// (получение уникального идентификатора абонента, открытие личного кабинета).
// Если необходимо запретить использование функций подключения 1С-Такском,
// тогда параметру Отказ необходимо присвоить значение Истина;
//
// Параметры:
//	Отказ - Булево - Истина, если использование функций 1С-Такском запрещено;
//		Ложь - в противном случае;
//		Значение по умолчанию - Ложь;
//
// Пример:
//	Если <Выражение> Тогда
//		Отказ = Истина;
//	КонецЕсли;
//
//@skip-warning
Процедура ИспользоватьСервис1СТакском(Отказ) Экспорт
	
	
	
КонецПроцедуры

// Процедура возвращает данные для заполнения заявки на получение уникального
// идентификатора абонента, добавления сертификата абонента.
//
// Параметры:
//	Организация - Произвольный - ссылка на элемент справочника Организации;
//	ДанныеОрганизации - Структура - данные об организации:
//		* Индекс - Строка - почтовый индекс организации;
//		* Регион - Строка - код региона организации;
//		* Район - Строка - Район;
//		* Город - Строка - Город;
//		* НаселенныйПункт - Строка - населенный пункт расположения организации;
//		* Улица - Строка - Улица;
//		* Дом - Строка - Дом;
//		* Корпус - Строка - Корпус;
//		* Квартира - Строка - Квартира;
//		* Телефон - Строка - телефон организации;
//		* Наименование - Строка - наименование организации;
//		* ИНН - Строка - ИНН организации;
//		* КПП - Строка - КПП организации;
//		* ОГРН - Строка - ОГРН организации;
//		* КодИМНС - Строка - код ИМНС организации;
//		* ЮрФизЛицо - Строка - вид лица, возможные значения: "ЮрЛицо" или "ФизЛицо";
//		* Фамилия - Строка - фамилия руководителя;
//		* Имя - Строка - имя руководителя;
//		* Отчество - Строка - отчество руководителя;
//
//@skip-warning
Процедура ЗаполнитьРегистрационныеДанныеОрганизации(Организация, ДанныеОрганизации) Экспорт

	Подключение1СТакскомУНФ.ЗаполнитьРегистрационныеДанныеОрганизации(Организация, ДанныеОрганизации);
	
КонецПроцедуры

#КонецОбласти

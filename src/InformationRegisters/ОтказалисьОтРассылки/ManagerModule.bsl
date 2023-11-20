#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Регистрирует отказ от рассылки адрес отправителя.
// Адреса при регистрации приводятся к нижнему регистру.
//
// Параметры:
//  ТемаПисьма	 - Строка - тема письма, по которой определяется, что пользователь отказывается от рассылки.
//  Отправитель	 - Строка, ИнтернетПочтовыйАдрес - адрес отправителя, который пожелал отписаться от рассылки.
//
Процедура ЗарегистрироватьОтказОтРассылкиЕслиТребуется(ТемаПисьма, Отправитель) Экспорт
	
	Если НРег(СокрЛП(ТемаПисьма)) <> "unsubscribe" Тогда
		Возврат;
	КонецЕсли;
	
	КакСвязаться = КакСвязаться(Отправитель);
	Если Не ЗначениеЗаполнено(КакСвязаться) Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.КакСвязаться = НРег(СокрЛП(КакСвязаться));
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Возвращает всех адреса, отписавшиеся от рассылки.
// 
// Возвращаемое значение:
//  Соответствие - здесь ключ - эл. адрес в нижнем регистре.
//
Функция ЭтиАдреса() Экспорт
	
	Результат = Новый Соответствие;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ОтказалисьОтРассылки.КакСвязаться КАК КакСвязаться
	|ИЗ
	|	РегистрСведений.ОтказалисьОтРассылки КАК ОтказалисьОтРассылки");
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Результат;
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Результат[Выборка.КакСвязаться] = Истина;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КакСвязаться(Отправитель)
	
	Если ТипЗнч(Отправитель) = Тип("Строка") Тогда
		Возврат Отправитель;
	КонецЕсли;
	
	Если ТипЗнч(Отправитель) = Тип("ИнтернетПочтовыйАдрес") Тогда
		Возврат Отправитель.Адрес;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

#КонецОбласти

#КонецЕсли
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Обработчик обновления БРО 1.2.1.120
Процедура РасширитьРеестрИзмерений(ПараметрыОбновления = Неопределено) Экспорт
	
	НаборЗаписей = РегистрыСведений.НастройкиОбменаСервисаПодписи.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();
	
	ВсегоЗаписей = НаборЗаписей.Количество();
	НашлиЭлементы = Новый Массив;
	
	Пока ВсегоЗаписей > 0 Цикл
		ТекущаяСтрока = НаборЗаписей[ВсегоЗаписей - 1];
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.УчетнаяЗапись) ИЛИ ТипЗнч(ТекущаяСтрока.УчетнаяЗапись) = Тип("Строка") Тогда
			ТекущийИдентификатор = Неопределено;
		Иначе
			ТекущийИдентификатор = ТекущаяСтрока.УчетнаяЗапись.УникальныйИдентификатор();
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТекущийИдентификатор) И НашлиЭлементы.Найти(ТекущийИдентификатор) = Неопределено Тогда
			ТекущаяСтрока.Идентификатор = ТекущаяСтрока.УчетнаяЗапись.УникальныйИдентификатор();
			НашлиЭлементы.Добавить(ТекущийИдентификатор);
		Иначе
			НаборЗаписей.Удалить(ВсегоЗаписей - 1);
		КонецЕсли;
		ВсегоЗаписей = ВсегоЗаписей - 1;
	КонецЦикла;
	
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	// инициализируем контекст ЭДО - модуль обработки
	ТекстСообщения = "";
	КонтекстЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО(ТекстСообщения);
	Если КонтекстЭДО = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЭДО.ОбработкаПолученияФормы("РегистрСведений", "НастройкиОбменаСервисаПодписи", ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли


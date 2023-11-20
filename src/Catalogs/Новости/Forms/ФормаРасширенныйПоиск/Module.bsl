///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ЭтотОбъект.НастройкиПоиска = Параметры.НастройкиПоиска.Скопировать();
	Для каждого ТекущийЭлементСписка Из ЭтотОбъект.НастройкиПоиска Цикл
		Если ТекущийЭлементСписка.Представление = "СтрокаПоиска" Тогда
			ЭтотОбъект.СтрокаПоиска = ТекущийЭлементСписка.Значение;
		ИначеЕсли ТекущийЭлементСписка.Представление = "ПоискДатаОТ" Тогда
			ЭтотОбъект.ПоискДатаОТ = ТекущийЭлементСписка.Значение;
		ИначеЕсли ТекущийЭлементСписка.Представление = "ПоискДатаДО" Тогда
			ЭтотОбъект.ПоискДатаДО = ТекущийЭлементСписка.Значение;
		КонецЕсли;
	КонецЦикла;

	Если ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() = РежимПолнотекстовогоПоиска.Разрешить Тогда
		Элементы.СтрокаПоиска.Подсказка = НСтр("ru='Полнотекстовый поиск включен.
			|Можно использовать символы подстановки * и ?'");
	Иначе
		Элементы.СтрокаПоиска.Подсказка = НСтр("ru='Полнотекстовый поиск отключен.
			|Доступен поиск только точных фраз'");
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)

	Если ПустаяСтрока(ЭтотОбъект.СтрокаПоиска) Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Строка поиска пустая'");
		Сообщение.Поле = "СтрокаПоиска";
		Сообщение.ПутьКДанным = "";
		Сообщение.Сообщить();
	КонецЕсли;

	Если (ЭтотОбъект.ПоискДатаОТ <> '00010101') И (ЭтотОбъект.ПоискДатаДО <> '00010101') Тогда
		Если (ЭтотОбъект.ПоискДатаОТ > ЭтотОбъект.ПоискДатаДО) Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru='Неверно задан интервал поиска по датам: дата начала позже даты окончания'");
			Сообщение.Поле = "ПоискДатаОТ";
			Сообщение.ПутьКДанным = "";
			Сообщение.Сообщить();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПоиск(Команда)

	ТипМассив = Тип("Массив");

	Если ПроверитьЗаполнение() Тогда
		МассивНайденныхНовостей = ОбработкаНовостейКлиент.НайтиНовости(
			Новый Структура("СтрокаПоиска, ПоискДатаОТ, ПоискДатаДО",
				ЭтотОбъект.СтрокаПоиска,
				ЭтотОбъект.ПоискДатаОТ,
				ЭтотОбъект.ПоискДатаДО));
		Если ТипЗнч(МассивНайденныхНовостей) = ТипМассив Тогда
			ЭтотОбъект.НастройкиПоиска.Очистить();
			ЭтотОбъект.НастройкиПоиска.Добавить(ЭтотОбъект.СтрокаПоиска, "СтрокаПоиска");
			ЭтотОбъект.НастройкиПоиска.Добавить(НачалоДня(ЭтотОбъект.ПоискДатаОТ), "ПоискДатаОТ");
			ЭтотОбъект.НастройкиПоиска.Добавить(?(ЭтотОбъект.ПоискДатаДО = '00010101', '00010101', КонецДня(ЭтотОбъект.ПоискДатаДО)), "ПоискДатаДО");
			Результат = Новый Структура("МассивНайденныхНовостей, НастройкиПоиска",
				МассивНайденныхНовостей,
				ЭтотОбъект.НастройкиПоиска);
			ЭтотОбъект.Закрыть(Результат);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

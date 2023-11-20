////////////////////////////////////////////////////////////////////////////////
// ОбменСБанкамиКлиентПереопределяемый: механизм обмена электронными документами с банками.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму разбора банковской выписки.
//
// Параметры:
//   СообщениеОбмена - ДокументСсылка.СообщениеОбменСБанками - сообщение с выпиской банка.
//
Процедура РазобратьВыпискуБанка(СообщениеОбмена) Экспорт
	
	Перем СсылкаНаХранилище, Организация, НастройкаОбмена, МассивСчетов;

	УправлениеНебольшойФирмойЭлектронныеДокументыВызовСервера.ПолучитьДанныеВыпискиБанкаТекстовыйФормат(
		СообщениеОбмена, СсылкаНаХранилище, МассивСчетов, Организация, НастройкаОбмена);
	Если НЕ ЗначениеЗаполнено(СсылкаНаХранилище) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Организация",             Организация);
	ПараметрыОткрытия.Вставить("ЭлектроннаяВыпискаБанка", СообщениеОбмена);
	ПараметрыОткрытия.Вставить("СоглашениеПрямогоОбменаСБанками", НастройкаОбмена);
	ПараметрыОткрытия.Вставить("РежимПоУмолчанию", "ГруппаЗагрузка");
	Если МассивСчетов.Количество() > 0 Тогда
		ПараметрыОткрытия.Вставить("БанковскийСчетОрганизации", МассивСчетов[0]);
	КонецЕсли;
	
	Если РасчетыРаботаСФормамиВызовСервера.ПроверитьИспользованиеКлиентБанкаБП() Тогда
		ОткрытьФорму("Обработка.КлиентБанк.Форма.Форма", ПараметрыОткрытия);
	Иначе
		ОткрытьФорму("Обработка.КлиентБанкУНФ.Форма.ФормаЗагрузка", ПараметрыОткрытия);
	КонецЕсли;

КонецПроцедуры

// Событие возникает при формировании электронных документов.
// Если для какого-либо объекта невозможно формирование электронного документа,
// тогда нужно присвоить СтандартнаяОбработка = Ложь.
// (например, в ЗУП есть документ ВедомостьНаВыплатуЗарплатыВБанк,
// который может быть отправлен в банк только для вида "ПоЗарплатномуПроекту")
//   Затем можно реализовать следующие сценарии обработки данной ситуации
//    1. Вывести сообщение
//    2. Вывести подробную инструкцию в отдельном окне, в котором описан порядок обработки таких документов.
//    3. Запустить помощник, который позволит создать "правильные" документы для отправки в банк.
//   Итоговый массив (сокращенный и дополненный) вернуть через ОбработчикОповещения.
//
// Параметры:
//  ОбработчикОповещения - ОписаниеОповещения - Обработчик, который нужно вызвать, если СтандартнаяОбработка = Ложь;
//     * Результат - Массив - массив ссылок на объекты, для которых возможно формирование электронных документов.
//                            Может быть дополнен новыми документами.
//  МассивДокументов - Массив - Массив ссылок на документы, для которых пользователь собирается сформировать
//                              электронные документы для отправки в банк.
//  СтандартнаяОбработка - Булево - необходимо присвоить Ложь, если в МассивДокументов есть документы,
//                                  для которых не формируются электронные документы.
//
// @skip-warning
Процедура ПриФормированииЭлектронныхДокументов(
	ОбработчикОповещения,
	МассивДокументов,
	ПараметрыВыполненияКоманды,
	СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

#КонецОбласти
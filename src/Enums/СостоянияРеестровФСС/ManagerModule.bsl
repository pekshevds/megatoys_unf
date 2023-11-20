#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений;
	ДанныеВыбора.Добавить(ПринятФСС, Строка(ПринятФСС));
	ДанныеВыбора.Добавить(ЧастичноПринятФСС, Строка(ЧастичноПринятФСС));
	ДанныеВыбора.Добавить(НеПринятФСС, Строка(НеПринятФСС));
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Превращает состояние отправки регламентированного отчета в состояние реестра.
//
// Параметры:
//   СтатусОтправки - ПеречислениеСсылка.СтатусыОтправки
//
// Возвращаемое значение:
//   ПеречислениеСсылка.СтатусыЗаявленийИРеестровНаВыплатуПособий
//
Функция ИзСтатусаОтправки(СтатусОтправки) Экспорт
	СостоянияБРО = Перечисления.СтатусыОтправки;
	Если СтатусОтправки = СостоянияБРО.Доставлен Тогда
		Возврат Подготовлен;
	ИначеЕсли СтатусОтправки = СостоянияБРО.Отправлен Тогда
		Возврат Подготовлен;
	ИначеЕсли СтатусОтправки = СостоянияБРО.Сдан Тогда
		Возврат ПринятФСС;
	ИначеЕсли СтатусОтправки = СостоянияБРО.НеПринят Тогда
		Возврат НеПринятФСС;
	ИначеЕсли СтатусОтправки = СостоянияБРО.ПринятЕстьОшибки Тогда
		Возврат ЧастичноПринятФСС;
	Иначе
		Возврат ВРаботе;
	КонецЕсли;
КонецФункции

#КонецОбласти

#КонецЕсли
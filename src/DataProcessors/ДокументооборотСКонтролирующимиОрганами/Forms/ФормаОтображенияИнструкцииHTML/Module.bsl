#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("МакетИнструкцииДляПоказа") Тогда
		МакетИнструкцииДляПоказа = Параметры.МакетИнструкцииДляПоказа;
	КонецЕсли;
	Если Параметры.Свойство("Заголовок") Тогда
		ЭтаФорма.Заголовок = Параметры.Заголовок;
	КонецЕсли;
	Если СтрДлина(МакетИнструкцииДляПоказа) > 0 Тогда
		ШаблонМакета = ПолучитьМакетОбработки(МакетИнструкцииДляПоказа);
		Макет = ШаблонМакета.ПолучитьТекст();
		ФормаОтображенияИнструкцииHTML = Макет;
	Иначе
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не задана инструкция для показа пользователю'"));
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РаспечататьИнструкцию(Команда)
	Элементы.ФормаОтображенияИнструкцииHTML.Документ.execCommand("Print");
КонецПроцедуры

&НаКлиенте
Процедура ДействиеОк(Команда)
	ЭтаФорма.Закрыть(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ДействиеОтмена(Команда)
	ФлагПростоОтмены = Истина;
	ЭтаФорма.Закрыть(Ложь);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьМакетОбработки(ИмяМакета)
	ОбработкаЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	Возврат ОбработкаЭДО.ПолучитьМакет(ИмяМакета);
КонецФункции

#КонецОбласти

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.ЕстьОшибки Тогда
		Элементы.СтраницаОшибка.Картинка = БиблиотекаКартинок.Остановить;
	КонецЕсли;
КонецПроцедуры

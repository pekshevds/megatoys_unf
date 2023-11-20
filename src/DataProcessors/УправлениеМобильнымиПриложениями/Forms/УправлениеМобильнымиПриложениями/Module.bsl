#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользоватьОбменСМобильнымиПриложениями =
		УправлениеМобильнымиПриложениями.ИспользоватьОбменСМобильнымиПриложениями();
	УстановитьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьОбменСМобильнымиПриложениямиПриИзменении(Элемент)
	
	ИспользоватьОбменСМобильнымиПриложениямиПриИзмененииСервер();

КонецПроцедуры

&НаКлиенте
Процедура МобильныеПриложенияНажатие(Элемент)
	
	ОткрытьФорму("Обработка.УправлениеМобильнымиПриложениями.Форма.КаталогМобильныхПриложений");
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиОбменаНажатие(Элемент)
	
	ИмяПланаОбмена = УправлениеМобильнымиПриложениямиКлиентСервер.ИмяПланаОбмена();
	ОткрытьФорму("ПланОбмена." + ИмяПланаОбмена + ".Форма.ФормаСписка");

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИспользоватьОбменСМобильнымиПриложениямиПриИзмененииСервер()
	
	Константы.ИспользоватьОбменСМобильнымиПриложениями.Установить(ИспользоватьОбменСМобильнымиПриложениями);
	Если ИспользоватьОбменСМобильнымиПриложениями Тогда
		Справочники.МобильныеПриложения.ОбновитьПоставляемыеПриложения();
	КонецЕсли;
	УстановитьДоступность();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность()
	
	Элементы.ГруппаНастроек.Доступность = ИспользоватьОбменСМобильнымиПриложениями;
	
КонецПроцедуры

#КонецОбласти




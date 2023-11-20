
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПериодОтчета = Параметры.ПериодОтчета;
	УчетнаяЗапись = Параметры.УчетнаяЗапись;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Настройки = Новый Структура;
	Настройки.Вставить("ПериодОтчета", ПериодОтчета);
	Настройки.Вставить("УчетнаяЗапись", УчетнаяЗапись);
	
	Оповестить("СохранениеНастройки", Настройки);
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
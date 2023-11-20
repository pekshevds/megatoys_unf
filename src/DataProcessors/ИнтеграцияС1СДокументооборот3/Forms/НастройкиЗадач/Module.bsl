#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтображениеКарточкиЗадачи = Параметры.ОтображениеКарточкиЗадачи;
	РазмерСтраницыДинамическогоСписка = Параметры.РазмерСтраницыДинамическогоСписка;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Результат = Новый Структура;
	Результат.Вставить("ОтображениеКарточкиЗадачи", ОтображениеКарточкиЗадачи);
	Результат.Вставить("РазмерСтраницыДинамическогоСписка", Число(РазмерСтраницыДинамическогоСписка));
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти
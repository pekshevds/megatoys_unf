#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Настройки = ТекущийОбъект.Данные.Получить();
	Если ТипЗнч(Настройки) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Настройки.Вложение);
		ТемаМаска = Настройки.Тема.Маска;		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Настройки = Новый Структура;
	НастройкиВложение = Новый Структура;
	НастройкиТема = Новый Структура;
	
	НастройкиТема.Вставить("Маска", СокрЛП(ТемаМаска));
	
	НастройкиВложение.Вставить("ДопустимыеТипы", СокрЛП(ДопустимыеТипы));
	НастройкиВложение.Вставить("МаксимальныйРазмерВложения", МаксимальныйРазмерВложения);
	НастройкиВложение.Вставить("МаксимальныйРазмерФайла", МаксимальныйРазмерФайла);
	НастройкиВложение.Вставить("ТребуетсяАрхивирование", ТребуетсяАрхивирование);
	НастройкиВложение.Вставить("Маска", СокрЛП(Маска));
	
	Настройки.Вставить("Вложение", НастройкиВложение);
	Настройки.Вставить("Тема", НастройкиТема);
	
	ТекущийОбъект.Данные = Новый ХранилищеЗначения(Настройки);	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтключенныеОбластиДоступа = РегистрыСведений.СеансовыеДанныеGoogle.ОтключенныеОбластиДоступа(
		Пользователи.АвторизованныйПользователь());
	СинхронизацияКалендаряGoogle = ОтключенныеОбластиДоступа.Найти(
		Перечисления.ОбластиДоступаGoogle.Календарь) = Неопределено;
	
	ИдентификацияПриложенияGoogle = Константы.ИдентификацияПриложенияGoogle.Получить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИдентификацияПриложенияGoogleПриИзменении(Элемент)
	
	ПроверитьОбновитьИдентификацияПриложенияGoogle();
	
КонецПроцедуры

&НаКлиенте
Процедура СинхронизацияКалендаряGoogleПриИзменении(Элемент)
	
	ОбновитьИспользованиеОбластиДоступаПриложениеGoogle();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СинхронизироватьКалендарьGoogle(Команда)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(
		"e1cib/command/Обработка.ОбменСGoogle.Команда.СинхронизироватьКалендарьGoogle");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПроверитьОбновитьИдентификацияПриложенияGoogle()
	
	ЗначениеКорректно = Истина;
	
	Если Не ПустаяСтрока(ИдентификацияПриложенияGoogle) Тогда
		ТекстОшибки = ОбменСGoogle.ИдентификацияПриложенияGoogleКорректна(ИдентификацияПриложенияGoogle);
		ЗначениеКорректно = ПустаяСтрока(ТекстОшибки);
	КонецЕсли;
	
	Если ЗначениеКорректно Тогда
		Константы.ИдентификацияПриложенияGoogle.Установить(ИдентификацияПриложенияGoogle);
	Иначе
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Элементы.ИдентификацияПриложенияGoogle.Имя);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИспользованиеОбластиДоступаПриложениеGoogle()
	
	РегистрыСведений.СеансовыеДанныеGoogle.ОтключитьОбластьДоступа(
		Пользователи.АвторизованныйПользователь(),
		Перечисления.ОбластиДоступаGoogle.Календарь,
		Не СинхронизацияКалендаряGoogle);
	
КонецПроцедуры

#КонецОбласти

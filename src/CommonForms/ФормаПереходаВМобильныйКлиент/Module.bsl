#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СборСтатистикиУНФ.ОтправитьСобытиеСДопДанными(НСтр("ru='Показана форма перехода в МК'"), "");
	Если ОбщегоНазначенияУНФ.ЭтоРозница() Тогда
		Элементы.ДекорацияИконка.Видимость = Ложь;
		Элементы.ДекорацияИконкаРозница.Видимость = Истина;
		Элементы.ДекорацияЗаголовок2.Заголовок = НСтр("ru='Бесплатное мобильное приложение
		|1С:Розница''");
	Иначе
		Элементы.ДекорацияИконка.Видимость = Истина;
		Элементы.ДекорацияИконкаРозница.Видимость = Ложь;
		Элементы.ДекорацияЗаголовок2.Заголовок = НСтр("ru='Бесплатное приложение
		|1С:УНФ в облаке'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Декорация1Нажатие(Элемент)
	
	НачалоРаботыСПрограммойВызовСервера.УстановитьСтандартныйИнтерфейс();
	ОбновитьИнтерфейс();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Установить(Команда)
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ИнформацияПрограммыПросмотра = НРег(СистемнаяИнформация.ИнформацияПрограммыПросмотра);
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента();
	
	АдресСтраницы = "";
	
	Если СтрНайти(ИнформацияПрограммыПросмотра, "iphone") <> 0
		ИЛИ СтрНайти(ИнформацияПрограммыПросмотра, "ipod") <> 0 Тогда 
		АдресСтраницы = МобильныйКлиентУНФКлиентСервер.АдресПубликацииВAppStore(Истина, ПараметрыРаботыКлиента.ЭтоРозница);
	ИначеЕсли СтрНайти(ИнформацияПрограммыПросмотра, "android") <> 0 Тогда
		АдресСтраницы = МобильныйКлиентУНФКлиентСервер.АдресПубликацииВGooglePlay(Истина, ПараметрыРаботыКлиента.ЭтоРозница);
	КонецЕсли;
	
	// АПК:534-выкл методы безопасного запуска обеспечиваются этой функцией
	ПерейтиПоНавигационнойСсылке(АдресСтраницы);
	// АПК:534-вкл
	
КонецПроцедуры

#КонецОбласти

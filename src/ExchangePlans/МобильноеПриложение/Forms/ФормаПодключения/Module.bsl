#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресДляПодключенияКЦентральнойБазеСМобильногоУстройства = ПолучитьНавигационнуюСсылкуИнформационнойБазы();
	
	Если Найти(АдресДляПодключенияКЦентральнойБазеСМобильногоУстройства, "e1c://") = Истина Тогда
		Элементы.ДекорацияШаг2Заголовок.Заголовок = НСтр("ru='Посетите страницу с описанием настройки синхронизации с мобильным приложением'");
		Элементы.ДекорацияСсылка.Видимость = Истина;
		Элементы.QRКод.Видимость = Ложь;
	Иначе
		Элементы.ДекорацияШаг2Заголовок.Заголовок = НСтр("ru='После загрузки мобильного приложения используйте этот QR-код для установки соединения'");
		Элементы.ДекорацияСсылка.Видимость = Ложь;
		Элементы.QRКод.Видимость = Истина;
	КонецЕсли;
		
	Если Параметры.Свойство("Пользователь") Тогда
		Пользователь = Параметры.Пользователь;
	Иначе
		УстановитьПривилегированныйРежим(Истина);
		ТекПользователь = Пользователи.ТекущийПользователь();
		Если ТекПользователь.Наименование= "<Не указан>" Тогда
			Пользователь = "";
		Иначе
			Пользователь = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
		КонецЕсли;
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	Сценарий = "Директор";
	СформироватьQR();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Оповестить("НастройкаМобильногоПриложенияГотово");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияQRAndroidНажатие(Элемент)
	
	АдресСтраницы = "https://play.google.com/store/apps/details?id=com.e1c.MobileSmallBusiness";
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(АдресСтраницы);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияКнопкаAndroidНажатие(Элемент)
	
	АдресСтраницы = "https://play.google.com/store/apps/details?id=com.e1c.MobileSmallBusiness";
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(АдресСтраницы);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияQRiOSНажатие(Элемент)
	
	АдресСтраницы = "https://itunes.apple.com/ru/app/1s-unf/id590223043?mt=8";
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(АдресСтраницы);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияКнопкаiOSНажатие(Элемент)
	
	АдресСтраницы = "https://itunes.apple.com/ru/app/1s-unf/id590223043?mt=8";
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(АдресСтраницы);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСсылкаНажатие(Элемент)
	
	АдресСтраницы = "http://sbm.1c.ru/about/nastroyka-mekhanizma-sinkhronizatsii/";
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(АдресСтраницы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьQR()
	
	АдресДляПодключенияКЦентральнойБазеСМобильногоУстройства = ПолучитьНавигационнуюСсылкуИнформационнойБазы();
	QRСтрока = "sbmcs" + ";" + АдресДляПодключенияКЦентральнойБазеСМобильногоУстройства + ";" + Пользователь; 
	ДанныеQRКода = ГенерацияШтрихкода.ДанныеQRКода(QRСтрока, 0, 190);
	QRКод = ПоместитьВоВременноеХранилище(ДанныеQRКода, УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти




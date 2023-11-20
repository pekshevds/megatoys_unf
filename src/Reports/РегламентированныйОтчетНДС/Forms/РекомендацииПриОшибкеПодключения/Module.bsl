
&НаКлиенте
Процедура ДекорацияРекомендацииПриОшибкеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("ОбщаяФорма.ПараметрыПроксиСервера", Новый Структура("НастройкаПроксиНаКлиенте", Истина), ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОткрытьЖурналРегистрацииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", Новый Структура("Пользователь", ИмяПользователя()));
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНаписатьВТехПоддержкуОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	АдресПолучателя = "webIts";
	Тема = НСтр("ru = 'Сервис проверки контрагентов ФНС'");
	Вложения = Неопределено;
	Сообщение = НСтр("ru = 'Не удалось подключиться к сервису проверки контрагентов ФНС.'");
	
	ДанныеСообщения = Новый Структура;
	ДанныеСообщения.Вставить("Тема", Тема);
	ДанныеСообщения.Вставить("Сообщение", Сообщение);
	ДанныеСообщения.Вставить("Получатель", АдресПолучателя);
	СообщенияВСлужбуТехническойПоддержкиКлиент.ОтправитьСообщение(ДанныеСообщения, Вложения, Неопределено, Неопределено);

КонецПроцедуры


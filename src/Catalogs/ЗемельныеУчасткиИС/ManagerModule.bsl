Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеПредставления = Новый Массив();
	
	Если ЗначениеЗаполнено(Данные.АдресСтрокой) Тогда
		ДанныеПредставления.Добавить(Данные.АдресСтрокой);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Данные.ПлощадьЗемельногоУчастка) Тогда
		ДанныеПредставления.Добавить(
			СтрШаблон(
				НСтр("ru = '%1 га'"),
				Данные.ПлощадьЗемельногоУчастка));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Данные.КадастровыйНомер) Тогда
		ДанныеПредставления.Добавить(Данные.КадастровыйНомер);
	КонецЕсли;
	
	Если ДанныеПредставления.Количество() = 0 Тогда
		ДанныеПредставления.Добавить(НСтр("ru = '<не заполнено>'"));
	КонецЕсли;
	
	Представление = СтрСоединить(ДанныеПредставления, ", ");
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Поля.Добавить("АдресСтрокой");
	Поля.Добавить("ПлощадьЗемельногоУчастка");
	Поля.Добавить("КадастровыйНомер");
	
КонецПроцедуры

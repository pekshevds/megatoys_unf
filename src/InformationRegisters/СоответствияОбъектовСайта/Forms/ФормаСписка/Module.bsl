#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СнятьОтметкуВыгружен(Команда)
	СнятьОтметкуВыгруженНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СнятьОтметкуВыгруженНаСервере()

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	СоответствияОбъектовСайта.УзелИнформационнойБазы,
				   |	СоответствияОбъектовСайта.УникальныйИдентификаторСайта,
				   |	СоответствияОбъектовСайта.СсылкаНаОбъект,
				   |	СоответствияОбъектовСайта.УникальныйИдентификаторИнформационнойБазы,
				   |	ЛОЖЬ КАК ОбъектВыгружен,
				   |	СоответствияОбъектовСайта.ТипОбъекта
				   |ИЗ
				   |	РегистрСведений.СоответствияОбъектовСайта КАК СоответствияОбъектовСайта";

	Результат = Запрос.Выполнить().Выгрузить();

	НЗ = РегистрыСведений.СоответствияОбъектовСайта.СоздатьНаборЗаписей();
	НЗ.Загрузить(Результат);
	НЗ.Записать();

КонецПроцедуры

#КонецОбласти

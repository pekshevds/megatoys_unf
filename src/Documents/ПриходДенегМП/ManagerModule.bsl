#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Представление = НСтр("en='Payment Receipt of';ru='Приход денег от '") + Формат(Данные.Дата, "ДФ=dd.MM.yyyy");
	
КонецПроцедуры

#КонецОбласти
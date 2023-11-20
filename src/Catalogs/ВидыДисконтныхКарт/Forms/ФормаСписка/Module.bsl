#Область ПроцедурыОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка доступности цен для редактирования.
	РазрешеноРедактированиеЦенДокументов = УправлениеДоступомУНФ.РазрешеноРедактированиеЦенДокументов();
	
	Элементы.Список.ТолькоПросмотр = НЕ РазрешеноРедактированиеЦенДокументов;
	
	УправлениеВидимостью();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УправлениеВидимостью()
	
	Элементы.Список.ПодчиненныеЭлементы.БонуснаяПрограмма.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьБонусныеПрограммы");
	
КонецПроцедуры

#КонецОбласти
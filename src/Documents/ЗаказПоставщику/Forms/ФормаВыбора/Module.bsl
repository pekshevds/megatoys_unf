#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеОтмененногоЗаказа(
		Список.КомпоновщикНастроек.Настройки.УсловноеОформление);
	
	УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
	
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(Список);
	ЭлектроннаяПочтаУНФ.УстановитьОтображениеКомандОтправкиСообщений(Элементы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_СостоянияЗаказовПоставщикам" Тогда
		УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеПоЦветамСостоянийСервер()
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеПоЦветамСостояний(
		Список.КомпоновщикНастроек.Настройки.УсловноеОформление,
		Метаданные.Справочники.СостоянияЗаказовПоставщикам.ПолноеИмя());
	
КонецПроцедуры

#КонецОбласти

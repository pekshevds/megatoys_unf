
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	Инструкция = КонтекстЭДОСервер.ПолучитьМакетОбработки("ЧтоОзначаетПодписьНедействительнаВВыпискеЕГРЮЛ").ПолучитьТекст();
	
КонецПроцедуры

#КонецОбласти
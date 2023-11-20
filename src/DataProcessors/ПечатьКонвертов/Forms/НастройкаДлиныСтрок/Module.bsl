
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("ОперацияВыполнена", Истина);
	ПараметрыЗакрытия.Вставить("ДлиныСтрок", КэшЗначений.ДлиныСтрок);
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура СтандартныеЗначения(Команда)
	
	ТиповаяДлинаСтрокКонвертов();
	
КонецПроцедуры

#КонецОбласти

#Область ЭлементыФормы

&НаКлиенте
Процедура ФорматКонвертаПриИзменении(Элемент)
	
	НастройкиДлиныСтрокПоФорматуКонверта();
	
КонецПроцедуры

&НаКлиенте
Процедура ДлинаПервойСтрокиОтКогоПриИзменении(Элемент)
	
	ЗаписатьНовоеЗначение(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДлинаВторойСтрокиОтКогоПриИзменении(Элемент)
	
	ЗаписатьНовоеЗначение(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДлинаПервойСтрокиОткудаПриИзменении(Элемент)
	
	ЗаписатьНовоеЗначение(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДлинаВторойСтрокиОткудаПриИзменении(Элемент)
	
	ЗаписатьНовоеЗначение(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДлинаПервойСтрокиКомуПриИзменении(Элемент)
	
	ЗаписатьНовоеЗначение(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДлинаВторойСтрокиКомуПриИзменении(Элемент)
	
	ЗаписатьНовоеЗначение(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДлинаПервойСтрокиКудаПриИзменении(Элемент)
	
	ЗаписатьНовоеЗначение(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДлинаВторойСтрокиКудаПриИзменении(Элемент)
	
	ЗаписатьНовоеЗначение(Элемент.Имя);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ФорматКонверта", ФорматКонверта);
	
	КэшЗначений = Новый Структура("ДлиныСтрок, ФорматыПочтовыхКонвертов");
	Параметры.Свойство("ДлиныСтрок", КэшЗначений.ДлиныСтрок);
	Параметры.Свойство("ФорматыПочтовыхКонвертов", КэшЗначений.ФорматыПочтовыхКонвертов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	НастройкиДлиныСтрокПоФорматуКонверта();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ТиповаяДлинаСтрокКонвертов()
	
	ПараметрыДлиныСтрокиC4 = Новый Структура;
	ПараметрыДлиныСтрокиC4.Вставить("ДлинаПервойСтрокиОтКого",	36);
	ПараметрыДлиныСтрокиC4.Вставить("ДлинаВторойСтрокиОтКого",	42);
	ПараметрыДлиныСтрокиC4.Вставить("ДлинаПервойСтрокиОткуда",	36);
	ПараметрыДлиныСтрокиC4.Вставить("ДлинаВторойСтрокиОткуда",	42);
	ПараметрыДлиныСтрокиC4.Вставить("ДлинаПервойСтрокиКому",	39);
	ПараметрыДлиныСтрокиC4.Вставить("ДлинаВторойСтрокиКому",	47);
	ПараметрыДлиныСтрокиC4.Вставить("ДлинаПервойСтрокиКуда",	39);
	ПараметрыДлиныСтрокиC4.Вставить("ДлинаВторойСтрокиКуда",	47);
	КэшЗначений.ДлиныСтрок[КэшЗначений.ФорматыПочтовыхКонвертов.C4] = ПараметрыДлиныСтрокиC4;
	
	ПараметрыДлиныСтрокиC5 = Новый Структура;
	ПараметрыДлиныСтрокиC5.Вставить("ДлинаПервойСтрокиОтКого",	26);
	ПараметрыДлиныСтрокиC5.Вставить("ДлинаВторойСтрокиОтКого",	32);
	ПараметрыДлиныСтрокиC5.Вставить("ДлинаПервойСтрокиОткуда",	26);
	ПараметрыДлиныСтрокиC5.Вставить("ДлинаВторойСтрокиОткуда",	32);
	ПараметрыДлиныСтрокиC5.Вставить("ДлинаПервойСтрокиКому",	31);
	ПараметрыДлиныСтрокиC5.Вставить("ДлинаВторойСтрокиКому",	47);
	ПараметрыДлиныСтрокиC5.Вставить("ДлинаПервойСтрокиКуда",	31);
	ПараметрыДлиныСтрокиC5.Вставить("ДлинаВторойСтрокиКуда",	47);
	КэшЗначений.ДлиныСтрок[КэшЗначений.ФорматыПочтовыхКонвертов.C5] = ПараметрыДлиныСтрокиC5;
	
	ПараметрыДлиныСтрокиDL = Новый Структура;
	ПараметрыДлиныСтрокиDL.Вставить("ДлинаПервойСтрокиОтКого",	33);
	ПараметрыДлиныСтрокиDL.Вставить("ДлинаВторойСтрокиОтКого",	41);
	ПараметрыДлиныСтрокиDL.Вставить("ДлинаПервойСтрокиОткуда", 33);
	ПараметрыДлиныСтрокиDL.Вставить("ДлинаВторойСтрокиОткуда", 41);
	ПараметрыДлиныСтрокиDL.Вставить("ДлинаПервойСтрокиКому",	43);
	ПараметрыДлиныСтрокиDL.Вставить("ДлинаВторойСтрокиКому",	47);
	ПараметрыДлиныСтрокиDL.Вставить("ДлинаПервойСтрокиКуда",	43);
	ПараметрыДлиныСтрокиDL.Вставить("ДлинаВторойСтрокиКуда",	47);
	КэшЗначений.ДлиныСтрок[КэшЗначений.ФорматыПочтовыхКонвертов.DL] = ПараметрыДлиныСтрокиDL;
	
	НастройкиДлиныСтрокПоФорматуКонверта()
	
КонецФункции

&НаКлиенте
Процедура НастройкиДлиныСтрокПоФорматуКонверта()
	
	Если НЕ ЗначениеЗаполнено(ФорматКонверта) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, КэшЗначений.ДлиныСтрок[ФорматКонверта]);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНовоеЗначение(ИмяСтроки)
	
	КэшЗначений.ДлиныСтрок[ФорматКонверта][ИмяСтроки] = ЭтотОбъект[ИмяСтроки];
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КоличествоЭкземпляров = 1;
	
	Если ЭтоАдресВременногоХранилища(Параметры.АдресВХранилище) Тогда
		
		ТаблицаШтрихкодов = ПолучитьИзВременногоХранилища(Параметры.АдресВХранилище);
		
		ШтрихкодыУпаковок.Загрузить(ТаблицаШтрихкодов);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрКоманды = Новый Массив;
	ПараметрКоманды.Добавить(ПредопределенноеЗначение("Справочник.ШтрихкодыУпаковокТоваров.ПустаяСсылка"));
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Обработка.ПечатьЭтикетокИЦенников",
		"ЭтикеткаШтрихкодыУпаковки",
		ПараметрКоманды,
		ВладелецФормы,
		ПолучитьПараметрыДляШтрихкодовУпаковок(ВладелецФормы.УникальныйИдентификатор));
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьПараметрыДляШтрихкодовУпаковок(ИдентификаторВладельца)
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("ИсходныеДанные",         ЗначениеВСтрокуВнутр(ШтрихкодыУпаковок.Выгрузить()));
	ПараметрыПечати.Вставить("ШаблонЭтикетки",         ШаблонЭтикетки);
	ПараметрыПечати.Вставить("КоличествоЭкземпляров",  КоличествоЭкземпляров);
	ПараметрыПечати.Вставить("СтруктураМакетаШаблона", Неопределено);
	ПараметрыПечати.Вставить("РежимПечати",            "ЭтикеткаКодМаркировкиИСМП");
	
	Возврат ПараметрыПечати;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СтруктураЗаполнения = Новый Структура();
	СтруктураЗаполнения.Вставить("Организация", ПараметрыВыполненияКоманды.Источник.Объект.Организация);
	СтруктураЗаполнения.Вставить("ВидЦен", ПараметрыВыполненияКоманды.Источник.Объект.ВидЦен);
	Если ПараметрыВыполненияКоманды.Источник.Объект.Свойство("ВидРабот") Тогда
		СтруктураЗаполнения.Вставить("ВидРабот", ПараметрыВыполненияКоманды.Источник.Объект.ВидРабот);
	КонецЕсли;
	
	СтруктураЗаполнения.Вставить("СтруктурнаяЕдиница", ПараметрыВыполненияКоманды.Источник.Объект.СтруктурнаяЕдиницаПродажи);
	
	РаботыТекущаяСтрока = Неопределено;
	ЗапасыТекущаяСтрока = Неопределено;
	Если ПараметрыВыполненияКоманды.Источник.Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийЗаказПокупателя.ЗаказНаряд") Тогда
		РаботыТекущаяСтрока = ПараметрыВыполненияКоманды.Источник.Элементы.Работы.ТекущиеДанные;
		СтруктураЗаполнения.Вставить("ВидРабот", ПараметрыВыполненияКоманды.Источник.Объект.ВидРабот);
	Иначе
		ЗапасыТекущаяСтрока = ПараметрыВыполненияКоманды.Источник.Элементы.Запасы.ТекущиеДанные;
	КонецЕсли;
	
	Если ЗапасыТекущаяСтрока <> Неопределено И НЕ ЗапасыТекущаяСтрока.ТипНоменклатурыЗапас Тогда
		
		СтруктураСтрока = Новый Структура;
		СтруктураСтрока.Вставить("Номенклатура", ЗапасыТекущаяСтрока.Номенклатура);
		СтруктураСтрока.Вставить("Характеристика", ЗапасыТекущаяСтрока.Характеристика);
		СтруктураСтрока.Вставить("День", ЗапасыТекущаяСтрока.ДатаОтгрузки);
		СтруктураСтрока.Вставить("Цена", ЗапасыТекущаяСтрока.Цена);
		СтруктураСтрока.Вставить("Сумма", ЗапасыТекущаяСтрока.Сумма);
		СтруктураСтрока.Вставить("Заказчик", ПараметрыВыполненияКоманды.Источник.Объект.Ссылка);
		
		Массив = Новый Массив;
		Массив.Добавить(СтруктураСтрока);
		
		СтруктураЗаполнения.Вставить("Работы", Массив);
		
	ИначеЕсли РаботыТекущаяСтрока <> Неопределено Тогда
		
		СтруктураСтрока = Новый Структура;
		СтруктураСтрока.Вставить("ВидРабот", РаботыТекущаяСтрока.ВидРабот);
		СтруктураСтрока.Вставить("Номенклатура", РаботыТекущаяСтрока.Номенклатура);
		СтруктураСтрока.Вставить("Характеристика", РаботыТекущаяСтрока.Характеристика);
		СтруктураСтрока.Вставить("День", ПараметрыВыполненияКоманды.Источник.Объект.Старт);
		
		ДлительностьВЧасах = РаботыТекущаяСтрока.Количество * РаботыТекущаяСтрока.Кратность * РаботыТекущаяСтрока.Коэффициент;
		Если ДлительностьВЧасах >= 24 Тогда
			ДлительностьВЧасах = (КонецДня(ПараметрыВыполненияКоманды.Источник.Объект.Старт) - ПараметрыВыполненияКоманды.Источник.Объект.Старт) / 3600;
		КонецЕсли;  
		
		СтруктураСтрока.Вставить("ДлительностьВЧасах", ДлительностьВЧасах);
		
		ДлительностьВСекундах = ДлительностьВЧасах * 3600;
		Часы = Цел(ДлительностьВСекундах / 3600);
		Минуты = (ДлительностьВСекундах - Часы * 3600) / 60;
		Длительность = Дата(0001, 01, 01, Часы, Минуты, 0);
		СтруктураСтрока.Вставить("Длительность", Длительность);
		
		Старт = Дата(0001, 01, 01, Час(ПараметрыВыполненияКоманды.Источник.Объект.Старт), Минута(ПараметрыВыполненияКоманды.Источник.Объект.Старт), 0);
		СтруктураСтрока.Вставить("ВремяНачала", Старт);
		СтруктураСтрока.Вставить("ВремяОкончания", Старт + ДлительностьВЧасах * 3600);
		
		СтруктураСтрока.Вставить("Цена", РаботыТекущаяСтрока.Цена);
		СтруктураСтрока.Вставить("Сумма", РаботыТекущаяСтрока.Сумма);
		СтруктураСтрока.Вставить("Заказчик", ПараметрыВыполненияКоманды.Источник.Объект.Ссылка);
		
		Массив = Новый Массив;
		Массив.Добавить(СтруктураСтрока);
		
		СтруктураЗаполнения.Вставить("Работы", Массив);
		
		МассивСтрокИсполнители = ПараметрыВыполненияКоманды.Источник.Объект.Исполнители.НайтиСтроки(Новый Структура("КлючСвязи", РаботыТекущаяСтрока.КлючСвязи));
		Для каждого СтрокаИсполнители Из МассивСтрокИсполнители Цикл
			СтруктураЗаполнения.Вставить("Сотрудник", СтрокаИсполнители.Сотрудник);
			Прервать;
		КонецЦикла;
		
	Иначе
		
		СтруктураСтрока = Новый Структура;
		СтруктураСтрока.Вставить("Заказчик", ПараметрыВыполненияКоманды.Источник.Объект.Ссылка);
		
		Массив = Новый Массив;
		Массив.Добавить(СтруктураСтрока);
		
		СтруктураЗаполнения.Вставить("Работы", Массив);
		
	КонецЕсли;
	
	ОткрытьФорму("Документ.ЗаданиеНаРаботу.ФормаОбъекта", Новый Структура("Основание", СтруктураЗаполнения));
	
	СтатистикаИспользованияФормКлиент.ПроверитьЗаписатьСтатистикуКоманды(
		"СоздатьНаОсновании.КомандаЗаданиеНаРаботуСоздатьНаОсновании",
		ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры

#КонецОбласти 


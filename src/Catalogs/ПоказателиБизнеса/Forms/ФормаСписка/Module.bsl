
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПоказателиБизнесаФормы.ИнициализироватьСлужебныеРеквизитыФормы(ЭтаФорма);
	УстановитьУсловноеОформление();
	
	ПереключитьСтраницу(Элементы, ВидыОтчетов, "ДекорацияДоходыРасходы");
	Список.Параметры.УстановитьЗначениеПараметра("ВидОтчета", ВыбранныйОтчет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область ПереключениеСтраниц

&НаКлиенте
Процедура ДекорацияВидОтчетаНажатие(Элемент)
	
	Если Элемент.Имя = "ДекорацияДоходыРасходы" Тогда
		ВыбранныйОтчет = ПредопределенноеЗначение("Перечисление.ВидыФинансовыхОтчетов.ДоходыРасходы");
	ИначеЕсли Элемент.Имя = "ДекорацияДенежныйПоток" Тогда
		ВыбранныйОтчет = ПредопределенноеЗначение("Перечисление.ВидыФинансовыхОтчетов.ДенежныйПоток");
	Иначе // Баланс
		ВыбранныйОтчет =  ПредопределенноеЗначение("Перечисление.ВидыФинансовыхОтчетов.Баланс");
	КонецЕсли;
	
	ПереключитьСтраницу(Элементы, ВидыОтчетов, Элемент.Имя);
	Список.Параметры.УстановитьЗначениеПараметра("ВидОтчета", ВыбранныйОтчет);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПереключитьСтраницу(Элементы, ВидыОтчетов, АктивнаяСтраница)
	
	Для каждого ВидОтчета Из ВидыОтчетов Цикл
		
		ИмяДекорации = "Декорация" + ВидОтчета.Представление;
		
		Если ИмяДекорации = АктивнаяСтраница Тогда
			Элементы[ИмяДекорации].Шрифт = Новый Шрифт(Элементы[ИмяДекорации].Шрифт,,,Истина);
		Иначе
			Элементы[ИмяДекорации].Шрифт = Новый Шрифт(Элементы[ИмяДекорации].Шрифт,,,Ложь);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		ПараметрыОткрытия = Новый Структура("ВидОтчета", ВыбранныйОтчет);
	Иначе
		ПараметрыОткрытия = Новый Структура("ТекущийЭлемент", ТекущиеДанные.Ссылка);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ПоказателиБизнеса.Форма.ФормаЭлемента", ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСтандартныйНаборПоказателей(Команда)
	
	ТекстВопроса = НСтр("ru = 'Загрузить стандартные показатели из шаблона? Текущие показатели будут помечены на удаление.'");
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузкаСтандартныхПоказателейПродолжение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	
	НовоеУсловноеОформление = Список.УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "ТипПоказателя", Перечисления.ТипыПоказателейБизнеса.Доход, ВидСравненияКомпоновкиДанных.Равно);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ЦветФона", Новый Цвет(238,255,240));
	
	НовоеУсловноеОформление = Список.УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "ТипПоказателя", Перечисления.ТипыПоказателейБизнеса.Расход, ВидСравненияКомпоновкиДанных.Равно);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ЦветФона", Новый Цвет(255,238,240));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаСтандартныхПоказателейПродолжение(Выбор, ДополнительныеПараметры) Экспорт
	
	Если Выбор = КодВозвратаДиалога.Да Тогда
		ЗагрузитьСтандартныйНаборПоказателейНаСервере(ВыбранныйОтчет);
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗагрузитьСтандартныйНаборПоказателейНаСервере(ВыбранныйОтчет)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПоказателиБизнеса.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ПоказателиБизнеса КАК ПоказателиБизнеса
		|ГДЕ
		|	ПоказателиБизнеса.ВидОтчета = &ВидОтчета
		|	И НЕ ПоказателиБизнеса.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("ВидОтчета", ВыбранныйОтчет);
	
	ВыборкаПоказатели = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаПоказатели.Следующий() Цикл
		ПоказательОбъект = ВыборкаПоказатели.Ссылка.ПолучитьОбъект();
		ПоказательОбъект.УстановитьПометкуУдаления(Истина);
	КонецЦикла;
	
	Если ВыбранныйОтчет = Перечисления.ВидыФинансовыхОтчетов.ДоходыРасходы Тогда
		Справочники.ПоказателиБизнеса.СформироватьПоказателиБизнесаДоходыРасходыПоШаблону();
	ИначеЕсли ВыбранныйОтчет = Перечисления.ВидыФинансовыхОтчетов.ДенежныйПоток Тогда
		Справочники.ПоказателиБизнеса.СформироватьПоказателиБизнесаДенежныйПотокПоШаблону();
	Иначе // Баланс
		Справочники.ПоказателиБизнеса.СформироватьПоказателиБизнесаБалансПоШаблону();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДеревоСертификатовЗначение = РеквизитФормыВЗначение("ДеревоСертификатов", Тип("ДеревоЗначений"));
	
	КодыТоваровТРУ = Новый ТаблицаЗначений;
	КодыТоваровТРУ.Колонки.Добавить("Сертификат", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(128)));
	КодыТоваровТРУ.Колонки.Добавить("КодТРУ", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(255)));
	КодыТоваровТРУ.Колонки.Добавить("Количество", Новый ОписаниеТипов("Число"));
	Для Каждого Сертификат Из Параметры.ДоступныеСертификаты Цикл // Структура
		Для Каждого Товар Из Сертификат.КодыТоваровТРУ Цикл
			СтрокаСертификата = КодыТоваровТРУ.Добавить();
			СтрокаСертификата.Сертификат = Сертификат.Идентификатор;
			СтрокаСертификата.КодТРУ = Товар.КодТовараТРУ;
			СтрокаСертификата.Количество = Товар.БалансКоличество;
		КонецЦикла;
	КонецЦикла;
	
	МенеджерОборудованияВызовСервераПереопределяемый.ЗаполнитьДеревоТоваровПоКодамТРУ(ДеревоСертификатовЗначение, КодыТоваровТРУ);
	ЗначениеВРеквизитФормы(ДеревоСертификатовЗначение, "ДеревоСертификатов");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДеревоСертификатовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработатьВыборНоменклатуры(СтандартнаяОбработка, ВыбраннаяСтрока); 
	
КонецПроцедуры 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьВыборНоменклатуры(СтандартнаяОбработка, ВыбраннаяСтрока)
	
	СтрокаДерева = ДеревоСертификатов.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если НЕ ЗначениеЗаполнено(СтрокаДерева.Номенклатура) Тогда
		Возврат;
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
	СтруктураОтвета = Новый Структура;
	СтруктураОтвета.Вставить("ИмяДействия" , НСтр("ru = 'Подбор номенклатуры НСПК'"));
	СтруктураОтвета.Вставить("Номенклатура" , СтрокаДерева.Номенклатура);
	
	ОповеститьОВыборе(СтруктураОтвета);
	
КонецПроцедуры

#КонецОбласти


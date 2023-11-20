
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ПравоДоступа("ИнтерактивноеДобавление", Метаданные.Справочники.КлассификаторУпаковкиЭПД) Тогда
		Элементы.ФормаПодборИзКлассификатора.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПодборИзКлассификатора(Команда)
	
	ОткрытьФорму("Справочник.КлассификаторУпаковкиЭПД.Форма.ДобавлениеЭлементовВКлассификатор", , ЭтаФорма, , , , ,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры


&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	ТекДанные = Элементы.Список.ТекущиеДанные;
	ДополнительныеПараметры = Новый Структура;
	Если Копирование Тогда
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Код", Элемент.ТекущиеДанные.Код);
		ЗначенияЗаполнения.Вставить("Наименование", Элемент.ТекущиеДанные.Наименование);
		ДополнительныеПараметры.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВопросЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ТекстВопроса = НСтр("ru = 'Есть возможность подобрать упаковку из классификатора.
		|Подобрать?'");
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		ПодборИзКлассификатора(Неопределено);
	Иначе
		ОткрытьФорму("Справочник.КлассификаторУпаковкиЭПД.ФормаОбъекта", ДополнительныеПараметры, ЭтаФорма);
	КонецЕсли;

КонецПроцедуры


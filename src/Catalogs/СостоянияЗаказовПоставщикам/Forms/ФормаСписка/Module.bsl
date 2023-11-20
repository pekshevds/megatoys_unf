
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеСостоянияЗавершен(Список.КомпоновщикНастроек.Настройки.УсловноеОформление,
		ПредопределенноеЗначение("Справочник.СостоянияЗаказовПоставщикам.Завершен"));
	
	УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
	
	Элементы.ГруппаПодсказка.Видимость = ОбщегоНазначенияУНФ.ЭтоУНФ();
	
	Список.Порядок.Элементы.Очистить();
	
	Порядок = Список.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	Порядок.Использование = Истина;
	Порядок.Поле = Новый ПолеКомпоновкиДанных("РеквизитДопУпорядочивания");
	Порядок.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	
	Порядок = Список.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	Порядок.Использование = Истина;
	Порядок.Поле = Новый ПолеКомпоновкиДанных("ЗавершенПоследним");
	Порядок.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	
	// Установим настройки формы для случая открытия в режиме выбора
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	Элементы.Список.МножественныйВыбор = ?(Параметры.ЗакрыватьПриВыборе = Неопределено, Ложь, Не Параметры.ЗакрыватьПриВыборе);
	Если Параметры.РежимВыбора Тогда
		КлючНазначенияИспользования = КлючНазначенияИспользования + "ВыборПодбор";
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Иначе
		КлючНазначенияИспользования = КлючНазначенияИспользования + "Список";
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_СостоянияЗаказовПоставщикам" Тогда
		УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ГруппаКоманд = Элементы.Найти("НастройкаПорядкаЭлементов");
	Если ГруппаКоманд <> Неопределено Тогда
		ГруппаКоманд.Доступность =
			Элементы.Список.ТекущаяСтрока <> ПредопределенноеЗначение("Справочник.СостоянияЗаказовПоставщикам.Завершен");
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКНастройкеПроцессов(Команда) 
	ПараметрыПроцессов = Новый Структура;
	ПараметрыПроцессов.Вставить("НастройкаПроцессов", Истина);
	ОткрытьФорму("Справочник.СостоянияЗаказовПоставщикам.Форма.ФормаСпискаПроцессов", ПараметрыПроцессов);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеПоЦветамСостоянийСервер()
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеПоЦветамСостояний(Список.КомпоновщикНастроек.Настройки.УсловноеОформление,
		Метаданные.Справочники.СостоянияЗаказовПоставщикам.ПолноеИмя(),
		"Ссылка");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

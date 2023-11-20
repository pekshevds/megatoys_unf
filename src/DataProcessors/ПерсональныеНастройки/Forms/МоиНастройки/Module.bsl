
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ПользовательскиеМакетыПечати) Тогда
		Элементы.ЗадатьДействиеПриВыбореМакетаПечатнойФормы.Видимость = Ложь;
	КонецЕсли;
	
	ЭтоВебКлиент = ОбщегоНазначения.ЭтоВебКлиент();
	
	ВыполнитьПроверкуПравДоступа("СохранениеДанныхПользователя", Метаданные);
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	Если Не ЭтоВебКлиент Тогда
		Элементы.РаботаВВебКлиенте.Видимость = Ложь;
	КонецЕсли;
	ЗапрашиватьПодтверждениеПриЗавершенииПрограммы = СтандартныеПодсистемыСервер.ЗапрашиватьПодтверждениеПриЗавершенииПрограммы();
	ПоказыватьПредупреждениеОбУстановленныхОбновленияхПрограммы = СтандартныеПодсистемыСервер.ПоказыватьПредупреждениеОбУстановленныхОбновленияхПрограммы();
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.Пользователи
	АвторизованныйПользователь = Пользователи.АвторизованныйПользователь();
	Если ПравоДоступа("Просмотр", Метаданные.НайтиПоТипу(ТипЗнч(АвторизованныйПользователь))) Тогда
		Элементы.СведенияОПользователе.Заголовок = АвторизованныйПользователь;
	Иначе
		Элементы.ГруппаУчетнаяЗапись.Видимость = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Пользователи
	
	// СтандартныеПодсистемы.ЭлектроннаяПодпись
	Элементы.НастройкиЭлектроннойПодписиИШифрования.Видимость =
		ПравоДоступа("СохранениеДанныхПользователя", Метаданные);
	// Конец СтандартныеПодсистемы.ЭлектроннаяПодпись
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
#Если ВебКлиент Тогда
	ОбновитьГруппуРаботыВВебКлиенте();
#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьОповещение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СведенияОПользователе(Команда)
	
	ПоказатьЗначение(, АвторизованныйПользователь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерсональнаяНастройкаПроксиСервера(Команда)
	
	ПолучениеФайловИзИнтернетаКлиент.ОткрытьФормуПараметровПроксиСервера(Новый Структура("НастройкаПроксиНаКлиенте", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширениеРаботыСФайламиНаКлиенте(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УстановитьРасширениеРаботыСФайламиНаКлиентеЗавершение", ЭтотОбъект);
	НачатьУстановкуРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьГруппуРаботыВВебКлиенте()
	
	Оповещение = Новый ОписаниеОповещения("ОбновитьГруппуРаботыВВебКлиентеЗавершение", ЭтотОбъект);
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьГруппуРаботыВВебКлиентеЗавершение(Подключено, ДополнительныеПараметры) Экспорт
	Элементы.ГруппаСтраницы.ТекущаяСтраница = ?(Подключено, Элементы.ГруппаРасширениеУстановлено, 
		Элементы.ГруппаРасширениеНеУстановлено);
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьДействиеПриВыбореМакетаПечатнойФормы(Команда)
	
	УправлениеПечатьюКлиент.ЗадатьДействиеПриВыбореМакетаПечатнойФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерсональныеНастройкиРаботыСФайлами(Команда)
	ОткрытьФорму("Обработка.ПерсональныеНастройки.Форма.РаботаСФайлами");
КонецПроцедуры

&НаКлиенте
Процедура НастройкиЭлектроннойПодписиИШифрования(Команда)
	
	ЭлектроннаяПодписьКлиент.ОткрытьНастройкиЭлектроннойПодписиИШифрования();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширениеРаботыСКриптографиейНаКлиенте(Команда)
	НачатьУстановкуРасширенияРаботыСКриптографией(Неопределено);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СохранитьНастройкиИЗакрытьФорму()
	
	Настройки = Новый Структура;
	Настройки.Вставить("НапоминатьОбУстановкеРасширенияРаботыСФайлами", НапоминатьОбУстановкеРасширенияРаботыСФайлами);
	Настройки.Вставить("ЗапрашиватьПодтверждениеПриЗавершенииПрограммы", ЗапрашиватьПодтверждениеПриЗавершенииПрограммы);
	Настройки.Вставить("ПоказыватьПредупреждениеОбУстановленныхОбновленияхПрограммы", ПоказыватьПредупреждениеОбУстановленныхОбновленияхПрограммы);
	
	УстановитьНастройкиНаСервере(Настройки);
	
	ОбщегоНазначенияКлиент.СохранитьПерсональныеНастройки(Настройки);
	
	ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьОповещение(Результат, Контекст) Экспорт
	СохранитьНастройкиИЗакрытьФорму();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширениеРаботыСФайламиНаКлиентеЗавершение(ДополнительныеПараметры) Экспорт
	
	ОбновитьГруппуРаботыВВебКлиенте();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкиНаСервере(Настройки)
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	ОбщегоНазначения.СохранитьПерсональныеНастройки(Настройки);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	СохранитьСвойстваКоллекции("ОбщиеНастройкиПользователя", ЭтотОбъект,
		"ПредлагатьПерейтиНаСайтПриЗапуске");
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьСвойстваКоллекции(КлючОбъекта, Коллекция, ИменаРеквизитов)
	СтруктураРеквизитов = Новый Структура(ИменаРеквизитов);
	ЗаполнитьЗначенияСвойств(СтруктураРеквизитов, Коллекция);
	Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

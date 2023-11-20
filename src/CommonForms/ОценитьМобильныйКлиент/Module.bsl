#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Оценка = 0;
	
	Если Параметры.Свойство("ПоказатьНеСпрашивать") Тогда
		Элементы.СпроситьПозже.Видимость = Истина;
		СпроситьПозже = Истина;
	Иначе
		Элементы.СпроситьПозже.Видимость = Ложь;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект, 0);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	
	//Константы.ПоказатьФормуОценитьПриложение.Установить(СпроситьПозже И Оценка = 0);
	Если Оценка = 0 Тогда
		Если СпроситьПозже Тогда
			РегистрыСведений.СчетчикДляОткрытияФормыОценкиМобильногоКлиента.УстановитьЗначение(0);
		Иначе
			РегистрыСведений.СчетчикДляОткрытияФормыОценкиМобильногоКлиента.УстановитьЗначение(-1);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Декорация1Нажатие(Элемент)
	
	Оценка = 1;
	УправлениеФормой(ЭтотОбъект, 1);
	Элементы.Декорация9.Заголовок = НСтр("ru = 'Жаль, что наше приложение не было полезно. Сообщите, пожалуйста, почему.'");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация2Нажатие(Элемент)
	
	Оценка = 2;
	УправлениеФормой(ЭтотОбъект, 2);
	Элементы.Декорация9.Заголовок = НСтр("ru = 'Не понравилась наше приложение? Расскажите, что можно сделать лучше.'");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация3Нажатие(Элемент)
	
	Оценка = 3;
	УправлениеФормой(ЭтотОбъект, 3);
	Элементы.Декорация9.Заголовок = НСтр("ru = 'Напишите, пожалуйста, с какими трудностями вы столкнулись:'");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация4Нажатие(Элемент)
	
	Оценка = 4;
	УправлениеФормой(ЭтотОбъект, 4);
	Элементы.Декорация9.Заголовок = НСтр("ru = 'Напишите, что мы можем сделать, чтобы приложение стало полезнее.'");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация5Нажатие(Элемент)
	
	Оценка = 5;
	УправлениеФормой(ЭтотОбъект, 5);
	Элементы.Декорация16.Заголовок = НСтр(
		"ru = 'Мы рады, что приложение понравилось.
		|Расскажите о нас друзьям.'");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьПисьмо(Команда = Неопределено)
	
	Получатель = Новый СписокЗначений;
	Получатель.Добавить("sbm@1c.ru", "Фирма 1С");
	
	ПараметрыПисьма = Новый Структура;
	ПараметрыПисьма.Вставить("Получатель", Получатель);
	ПараметрыПисьма.Вставить("Тема", "Трудности мобильного клиента");
	ПараметрыПисьма.Вставить("Текст", ТекстПисьма);
	РаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыПисьма);
	СчетчикДляОткрытияФормыОценкиМобильногоКлиентаУстановитьЗначение(-1);
	
	ТекстПисьма = "";
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВМагазин(Команда)
	
	СчетчикДляОткрытияФормыОценкиМобильногоКлиентаУстановитьЗначение(-1);
	
	// АПК:534-выкл методы безопасного запуска обеспечиваются этой функцией
	ЗапуститьПриложение(АдресМагазина);
	// АПК:534-вкл
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФормуЗавершение(КнопкаОтвет, ДопПараметры) Экспорт
	
	Если КнопкаОтвет = "Закрыть" Тогда
		ТекстПисьма = "";
		Закрыть();
	ИначеЕсли КнопкаОтвет = "Отправить" Тогда
		ОтправитьПисьмо();
	КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма, Номер)
	
	Элементы = Форма.Элементы;
	
	Элементы.ГруппаПисьмо.Видимость   = Номер > 0 И Номер < 4;
	Элементы.ГруппаОценка.Видимость   = Номер = 4 ИЛИ Номер = 5;
	Элементы.ГруппаОтложить.Видимость = Номер = 0;
	
	Элементы.Декорация1.Картинка = ?(Номер > 0, БиблиотекаКартинок.ЖелтаяЗвезда, БиблиотекаКартинок.СераяЗвезда);
	Элементы.Декорация2.Картинка = ?(Номер > 1, БиблиотекаКартинок.ЖелтаяЗвезда, БиблиотекаКартинок.СераяЗвезда);
	Элементы.Декорация3.Картинка = ?(Номер > 2, БиблиотекаКартинок.ЖелтаяЗвезда, БиблиотекаКартинок.СераяЗвезда);
	Элементы.Декорация4.Картинка = ?(Номер > 3, БиблиотекаКартинок.ЖелтаяЗвезда, БиблиотекаКартинок.СераяЗвезда);
	Элементы.Декорация5.Картинка = ?(Номер > 4, БиблиотекаКартинок.ЖелтаяЗвезда, БиблиотекаКартинок.СераяЗвезда);
	
	Элементы.ТекстПисьма.Видимость = Номер > 0;
	Элементы.ОбщаяКомандаСообщитьРазработчикам.Видимость = Номер > 0;
	Элементы.Декорация16.Видимость = Номер > 3;
	
	Элементы.ОбщаяКомандаСообщитьРазработчикам.Доступность = НЕ ПустаяСтрока(Форма.ТекстПисьма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СчетчикДляОткрытияФормыОценкиМобильногоКлиентаУстановитьЗначение(Значение)
	
	РегистрыСведений.СчетчикДляОткрытияФормыОценкиМобильногоКлиента.УстановитьЗначение(Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НЕ ПустаяСтрока(ТекстПисьма) Тогда
		Отказ = Истина;
		КнопкиДиалога = Новый СписокЗначений;
		КнопкиДиалога.Добавить("Закрыть", НСтр("ru = 'Закрыть форму'"));
		КнопкиДиалога.Добавить("Отправить", НСтр("ru = 'Отправить письмо'"));
		ОписаниеЗавершенияВопроса = Новый ОписаниеОповещения("ЗакрытьФормуЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'При закрытии формы текст письма будет потерян.'");
		ПоказатьВопрос(ОписаниеЗавершенияВопроса, "", КнопкиДиалога,,"Отправить",ТекстВопроса);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТекстПисьмаИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	Элементы.ОбщаяКомандаСообщитьРазработчикам.Доступность = НЕ ПустаяСтрока(Элементы.ТекстПисьма.ТекстРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента();
	
	Если МобильныйКлиентУНФКлиентСервер.ЭтоAndroid() Тогда
		Магазин = "Google Play";
		АдресМагазина = МобильныйКлиентУНФКлиентСервер.АдресПубликацииВGooglePlay(Ложь, ПараметрыРаботыКлиента.ЭтоРозница);
	ИначеЕсли МобильныйКлиентУНФКлиентСервер.ЭтоiOS() Тогда
		Магазин = "App Store";
		АдресМагазина = МобильныйКлиентУНФКлиентСервер.АдресПубликацииВAppStore(Ложь, ПараметрыРаботыКлиента.ЭтоРозница);
	КонецЕсли;

	Элементы.Декорация16.Заголовок = НСтр(
		"ru = 'Мы рады, что приложение понравилось.
		|Расскажите о нас друзьям.'");
	Элементы.Декорация13.Заголовок = СтрШаблон(Элементы.Декорация13.Заголовок, Магазин);
	
КонецПроцедуры

#КонецОбласти



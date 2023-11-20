
#Область ОписаниеПеременных

&НаКлиенте
Перем МассивИзмененныхРеквизитов;

&НаКлиенте
Перем ПодтвержденоЗакрытиеФормы; // Для подтверждения закрытия формы пользователем

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МассивОбъектовМетаданных = Новый Массив(1);
	МассивОбъектовМетаданных[0] = Параметры.КонтекстПечати.Ссылка.Метаданные();

	ИспользоватьНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");	
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = МассивОбъектовМетаданных;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	ПечатьДокументовУНФ.УстановитьОтображениеПодменюПечати(Элементы.ПодменюПечать);
	
	ЗаполнитьЗначенияСвойств(КонтекстПечати, Параметры.КонтекстПечати, "Организация, КассаККМ, СтруктурнаяЕдиница,
		|ПодписьКассира, Контрагент, КонтактноеЛицоПодписант, УсловияГарантийногоТалона,
		|ТекстУсловийГарантийногоТалона");
	
	УстановитьВидФормы();
	ЗаголовокФормы();
	ЗаполнитьПодсказкиПодписей();
	УстановитьКартинкиКнопок();
	
	ДоступностьКомандФормы();

	// Для отражения информации по новой схеме реквизитов печати
	РаботаСФормойДокумента.НастроитьВидимостьГруппыИнформации(ЭтотОбъект, "ГруппаИнформацияПоНовымРеквизитам",
							"ПоказыватьИнформациюПоНовойСхемеРеквизитовПечати", "ФормыОбработкиРеквизитыПечати");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МассивИзмененныхРеквизитов = Новый Массив;
	ПодтвержденоЗакрытиеФормы = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если Модифицированность И НЕ ЗавершениеРаботы И НЕ ПодтвержденоЗакрытиеФормы Тогда
		
		Отказ = Истина;
        ОписаниеОповещенияОЗавершении    = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);                
        ТекстВопроса        = НСтр("ru = 'Выполненные изменения будут отменены. Продолжить?'");                
        ПоказатьВопрос(ОписаниеОповещенияОЗавершении, ТекстВопроса, РежимДиалогаВопрос.ДаНет); 		
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры) Экспорт
    
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли;
    
    ПодтвержденоЗакрытиеФормы = Истина;
               
    Закрыть();
    
КонецПроцедуры // ПередЗакрытиемЗавершение()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодписьКассираПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	ЗаполнитьПодсказкиПодписей();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактноеЛицоПодписантПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура УсловияГарантийногоТалонаПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	КонтекстПечати.ТекстУсловийГарантийногоТалона = 
		ПолучитьТекстУсловийШаблона(КонтекстПечати.УсловияГарантийногоТалона);
	Элементы.ГруппаТекстУсловийГарантийногоТалона.Видимость = НЕ КонтекстПечати.УсловияГарантийногоТалона.Пустая();
	Элементы.ТекстУсловийГарантийногоТалона.Заголовок = НСтр("ru='Текст условий талона'");
	Элементы.ТекстУсловийГарантийногоТалона.Вид = ВидПоляФормы.ПолеНадписи;	
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстУсловийГарантийногоТалонаПриИзменении(Элемент)

	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИнформацияПоНовойСхемеЗакрытьНажатие(Элемент)

	Элементы.ГруппаИнформацияПоНовымРеквизитам.Видимость = Ложь;	
	СохранитьНастройкуПоказыватьИнформациюПоНовойСхеме();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ЗаписатьИзмененияИЗакрытьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьПодписиПоУмолчанию(Команда)
	
	ПредыдущиеЗначения = Новый Структура("ПодписьКассира");
	ЗаполнитьЗначенияСвойств(ПредыдущиеЗначения, КонтекстПечати);
	
	ПолучитьПодписиПоУмолчаниюНаСервере();
	
	Для каждого ЭлементСтруктуры Из ПредыдущиеЗначения Цикл
		
		Если ЭлементСтруктуры.Значение <> КонтекстПечати[ЭлементСтруктуры.Ключ] Тогда
			
			ЗафиксироватьИзменениеЗначенияРеквизита(ЭлементСтруктуры.Ключ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПодписьКассира(Команда)
	
	ЗаписатьНастройкуПользователя("ПодписьКассира", КонтекстПечати.ПодписьКассира);
	ЗаполнитьПодсказкиПодписей();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьУсловияГарантийногоТалонаНажатие(Команда)
	
	ЗаписатьНастройкуПользователя("УсловияГарантии", КонтекстПечати.УсловияГарантийногоТалона);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьУсловияГарантийногоТалона(Команда)

	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("ТекстУсловий", КонтекстПечати.ТекстУсловийГарантийногоТалона);
	ДопПараметры.Вставить("Условия", КонтекстПечати.УсловияГарантийногоТалона);	
	ДопПараметры.Вставить("Заголовок", НСтр("ru='Условия гарантийного талона'"));
	ДопПараметры.Вставить("ИмяРеквизитаУсловий", "ТекстУсловийГарантийногоТалона");
	Оповещение = Новый ОписаниеОповещения("ПослеВводаТекстаУсловий", ЭтотОбъект, ДопПараметры);	
	ОткрытьФорму("Обработка.РеквизитыПечати.Форма.РедакторУсловий", ДопПараметры, ЭтотОбъект, , , , Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗафиксироватьИзменениеЗначенияРеквизита(ИмяРеквизита)
	
	Если МассивИзмененныхРеквизитов.Найти(ИмяРеквизита) = Неопределено Тогда
		
		МассивИзмененныхРеквизитов.Добавить(ИмяРеквизита);
		
	КонецЕсли;

	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИзмененияИЗакрытьФорму(Команда = Неопределено)
	
	ПараметрыЗакрытия = Новый Структура;
	Если Команда <> Неопределено Тогда
		
		ПараметрыЗакрытия.Вставить("Команда", Команда);
		
	КонецЕсли;
	
	ИзмененныеРеквизиты = Новый Структура;
	Для каждого ЭлементМассива Из МассивИзмененныхРеквизитов Цикл
		
		ИзмененныеРеквизиты.Вставить(ЭлементМассива, КонтекстПечати[ЭлементМассива]);
		
	КонецЦикла;
	
	ДополнитьРеквизитыТекстамиУсловий(ИзмененныеРеквизиты);
	ПараметрыЗакрытия.Вставить("ИзмененныеРеквизиты", ИзмененныеРеквизиты);
	ПодтвержденоЗакрытиеФормы = Истина;		
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаСервере
Процедура ЗаголовокФормы()
	
	Заголовок = Обработки.РеквизитыПечати.ЗаголовокФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьПодписиПоУмолчаниюНаСервере()
	
	ПодписьКассира = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеНастройки("ПодписьКассира", КонтекстПечати.Организация);
	
	Если ЗначениеЗаполнено(ПодписьКассира) Тогда
		КонтекстПечати.ПодписьКассира = ПодписьКассира
	Иначе
		ДокументОбъект = ДанныеФормыВЗначение(КонтекстПечати, Тип("ДокументОбъект.ЧекККМ"));
		Обработки.РеквизитыПечати.ПодписиПоУмолчанию(ДокументОбъект);	
		ЗначениеВДанныеФормы(ДокументОбъект, КонтекстПечати);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДоступностьКомандФормы()
	
	Если НЕ ПравоДоступа("Изменение", КонтекстПечати.Ссылка.Метаданные()) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаВосстановитьПодписиПоУмолчанию", "Доступность", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодсказкиПодписей() 

	Если КонтекстПечати.ПодписьКассира = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КонтекстПечати.СтруктурнаяЕдиница, 
		"ПодписьМОЛ") Тогда
		Элементы.ПодписьКассира.Подсказка = НСтр("ru='Подпись из реквизитов структурной единицы'");		
	Иначе
		Элементы.ПодписьКассира.Подсказка = НСтр("ru='Подпись из настроек пользователя'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКартинкиКнопок()
	
	КартинкаСохранения = ОбщегоНазначенияУНФКлиентСервер.КартинкаСохраненияНастроек();
	Элементы.СохранитьПодписьКассира.Картинка = КартинкаСохранения;
	Элементы.СохранитьУсловияГарантийногоТалона.Картинка = КартинкаСохранения;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНастройкуПользователя(НазваниеНастройки, ЗначениеНастройки)
	
	ЗаписатьНастройкуПользователяСервер(НазваниеНастройки, ЗначениеНастройки);	
	
	СтрокаЗаголовка = НСтр("ru='Сохранение настроек пользователя'");
	ШаблонСообщения = НСтр("ru='Значение сохранено для использования в новых документах %1 %2'");
	
	ПараметрОрганизация = "";
	
	Если ИспользоватьНесколькоОрганизаций Тогда
		
		НаименованиеОрганизации = УправлениеНебольшойФирмойВызовСервера.ЗначениеРеквизитаОбъекта(
			КонтекстПечати.Организация, "Наименование");
		ПараметрОрганизация = СтрШаблон(НСтр("ru='по организации %1'"), НаименованиеОрганизации);
		
	КонецЕсли;
	
	ПараметрПользователь = СтрШаблон(НСтр("ru='пользователем %1'"), ПользователиКлиент.АвторизованныйПользователь());

	СтрокаТекста = СтрШаблон(ШаблонСообщения, ПараметрОрганизация, ПараметрПользователь);
	КартинкаСохранения = ОбщегоНазначенияУНФКлиентСервер.КартинкаСохраненияНастроек();
	
	ПоказатьОповещениеПользователя(СтрокаЗаголовка, , СтрокаТекста, КартинкаСохранения,
		СтатусОповещенияПользователя.Важное);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкуПользователяСервер(НазваниеНастройки, ЗначениеНастройки)

	РегистрыСведений.НастройкиПользователей.Установить(ЗначениеНастройки, НазваниеНастройки, ,
		КонтекстПечати.Организация);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкуПоказыватьИнформациюПоНовойСхеме()

	РаботаСФормойДокумента.СохранитьВидимостьГруппыИнформации(ИмяФормы,
			"ПоказыватьИнформациюПоНовойСхемеРеквизитовПечати", Ложь, "ФормыОбработкиРеквизитыПечати");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидФормы()
	
	Если Параметры.Свойство("РазвернутьГруппы") И Параметры.РазвернутьГруппы <> "" Тогда
		СписокГрупп = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Параметры.РазвернутьГруппы);
		Для каждого ЭлементФормы Из Элементы Цикл
			Если ЭлементФормы.Вид = ВидГруппыФормы.ОбычнаяГруппа Тогда
				Если СписокГрупп.Найти(ЭлементФормы.Имя) <> Неопределено Тогда
					ЭлементФормы.Показать();
				Иначе
					ЭлементФормы.Скрыть();
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ТекущийЭлемент") Тогда
		
		ТекущийЭлемент = Элементы[Параметры.ТекущийЭлемент];

	КонецЕсли;
	
	Элементы.ГруппаТекстУсловийГарантийногоТалона.Видимость = НЕ КонтекстПечати.УсловияГарантийногоТалона.Пустая();
	
	Если НЕ ПустаяСтрока(КонтекстПечати.ТекстУсловийГарантийногоТалона) Тогда
		УстановитьВидПолеВвода("ТекстУсловийГарантийногоТалона");
	Иначе
		КонтекстПечати.ТекстУсловийГарантийногоТалона =
			ПолучитьТекстУсловийШаблона(КонтекстПечати.УсловияГарантийногоТалона);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаТекстаУсловий(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		ЗафиксироватьИзменениеЗначенияРеквизита(ДополнительныеПараметры.ИмяРеквизитаУсловий);
		НастроитьПоляУсловий(ДополнительныеПараметры.ИмяРеквизитаУсловий, ДополнительныеПараметры.Условия,
			Результат);
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Процедура НастроитьПоляУсловий(ИмяРеквизита, Условия, ТекстУсловий)

	ТекстУсловийШаблона = ПолучитьТекстУсловийШаблона(Условия);
	ИмяРеквизитаУсловий = ИмяРеквизита;
	КонтекстПечати[ИмяРеквизитаУсловий] = ТекстУсловий;		
	Если ТекстУсловийШаблона <> ТекстУсловий Тогда
		УстановитьВидПолеВвода(ИмяРеквизитаУсловий);
	Иначе
		УстановитьВидПолеНадписи(ИмяРеквизитаУсловий);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидПолеВвода(ИмяРеквизитаУсловий)
	
	Элемент = Элементы[ИмяРеквизитаУсловий];
	Элемент.Вид = ВидПоляФормы.ПолеВвода;
	Элемент.МногострочныйРежим = Истина;
	Элемент.Высота = 1;
	Элемент.Заголовок = НСтр("ru='Измененный текст условий'");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидПолеНадписи(ИмяРеквизитаУсловий)
	
	Элемент = Элементы[ИмяРеквизитаУсловий];
	Элемент.Вид = ВидПоляФормы.ПолеНадписи;
	Если ИмяРеквизитаУсловий = "ТекстУсловийГарантийногоТалона" Тогда
		ТекстЗаголовка = НСтр("ru='Текст условий талона'");
	КонецЕсли;
	Элемент.Заголовок = ТекстЗаголовка;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТекстУсловийШаблона(Условия)
	
	ТекстУсловий = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Условия, "ТекстУсловий");
	Возврат ТекстУсловий;
	
КонецФункции

&НаСервере
Процедура ДополнитьРеквизитыТекстамиУсловий(ИзмененныеРеквизиты)
	
	Если КонтекстПечати.ТекстУсловийГарантийногоТалона <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		КонтекстПечати.УсловияГарантийногоТалона, "ТекстУсловий") Тогда
			ИзмененныеРеквизиты.Вставить("ТекстУсловийГарантийногоТалона", 
			КонтекстПечати.ТекстУсловийГарантийногоТалона);
	Иначе
		ИзмененныеРеквизиты.Вставить("ТекстУсловийГарантийногоТалона", "");			
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область Библиотеки

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	ЗаписатьИзмененияИЗакрытьФорму(Команда);
	
	Возврат; // работа типового метода не предусмотрена
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, КонтекстПечати);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	
	Возврат; // работа типового метода не предусмотрена
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, КонтекстПечати, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	Возврат; // работа типового метода не предусмотрена
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, КонтекстПечати);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

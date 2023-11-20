#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка доступности цен для редактирования.
	РазрешеноРедактированиеЦенДокументов = УправлениеДоступомУНФ.РазрешеноРедактированиеЦенДокументов();
	Элементы.Список.ТолькоПросмотр = НЕ РазрешеноРедактированиеЦенДокументов;

	СписокУсловий = Новый СписокЗначений;
	
	СписокУсловий = СкидкиНаценкиСерверПереопределяемый.ПолучитьСписокЗначенийУсловийПредоставленияСкидки();
	
	МетаданныеЗначенияПеречисления = Метаданные.Перечисления.УсловияПредоставленияСкидокНаценок.ЗначенияПеречисления;
	МенеджерПеречисления           = Перечисления.УсловияПредоставленияСкидокНаценок;
	
	Для каждого ЭлементСписка Из СписокУсловий Цикл
		
		ИмяПеречисления = МетаданныеЗначенияПеречисления[МенеджерПеречисления.Индекс(ЭлементСписка.Значение)].Имя;
		
		ЭлементУправления = Элементы.Найти("КомандаСоздать" + ИмяПеречисления);
		Если НЕ ЭлементУправления = Неопределено Тогда
		
			ЭлементУправления.Видимость = Истина;
		
		КонецЕсли;
		
	КонецЦикла;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик команды КомандаСоздатьЗаКомплектПокупки формы.
//
&НаКлиенте
Процедура КомандаСоздатьЗаКомплектПокупки(Команда)
	
	КомандаСоздатьУсловие(Команда)
	
КонецПроцедуры

// Процедура - обработчик команды КомандаСоздатьЗаРазовыйОбъемПродаж формы.
//
&НаКлиенте
Процедура КомандаСоздатьЗаРазовыйОбъемПродаж(Команда)
	
	КомандаСоздатьУсловие(Команда)
	
КонецПроцедуры

// Процедура - обработчик команд КомандаСоздатьЗаКомплектПокупки и КомандаСоздатьЗаРазовыйОбъемПродаж формы.
//
&НаКлиенте
Процедура КомандаСоздатьУсловие(Команда)

	ИмяКоманды      = Команда.Имя;
	ИмяПеречисления = СтрЗаменить(ИмяКоманды, "КомандаСоздать", "");
	
	СтруктураПараметры = Новый Структура;
	СтруктураОснования = Новый Структура;
	СтруктураОснования.Вставить("УсловиеПредоставления", ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок." + ИмяПеречисления));
	ТекущаяСтрокаСписка = Элементы.Список.ТекущиеДанные;
	Если ТекущаяСтрокаСписка <> Неопределено Тогда
		ТекущийРодитель = ТекущаяГруппаВСписке(ТекущаяСтрокаСписка.Ссылка);
		СтруктураОснования.Вставить("Родитель", ТекущийРодитель);
	КонецЕсли;
	СтруктураПараметры.Вставить("Основание", СтруктураОснования);
	ОткрытьФорму("Справочник.УсловияПредоставленияСкидокНаценок.Форма.ФормаЭлемента", СтруктураПараметры);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция определяет родителя нового условия. Если выбрана группа, то она передается в качестве родителя. Если элемент,
// то его родитель.
//
&НаСервере
Функция ТекущаяГруппаВСписке(ТекущаяСсылка)
	
	ТекущаяГруппа = Неопределено;
	
	РеквизитыТекущейСсылки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ТекущаяСсылка, Новый Структура("ЭтоГруппа, Родитель"));
	Если РеквизитыТекущейСсылки.ЭтоГруппа Тогда
		ТекущаяГруппа = ТекущаяСсылка;
	Иначе
		ТекущаяГруппа = РеквизитыТекущейСсылки.Родитель;
	КонецЕсли;
	
	Возврат ТекущаяГруппа;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаПолученияДанныхВыбора.
//
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("Рекурсия")
		И Параметры.Отбор.Свойство("Владелец") И ТипЗнч(Параметры.Отбор.Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
		// При первом входе, если задана связь параметров выбора по значению номенклатуры,
		// то дополним параметры выбора отбором по владельцу - номенклатурным группам по иерархии.
		
		СтандартнаяОбработка = Ложь;
		
		Номенклатура = Параметры.Отбор.Владелец;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Номенклатура.КатегорияНоменклатуры КАК КатегорияНоменклатуры,
		|	Номенклатура.НаборЕдиницИзмерения КАК НаборЕдиницИзмерения,
		|	Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	Номенклатура.ИспользоватьНаборыЕдиницИзмерения КАК ИспользоватьНаборыЕдиницИзмерения,
		|	ПРЕДСТАВЛЕНИЕ(Номенклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияПредставление
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.Ссылка = &Номенклатура";
		
		Результат = Запрос.Выполнить().Выбрать();
		
		Если Не Результат.Количество() Тогда
			Возврат
		КонецЕсли;
		
		Пока Результат.Следующий() Цикл
			КатегорияНоменклатуры = Результат.КатегорияНоменклатуры;
			ЕдиницаИзмеренияВладельца = Результат.ЕдиницаИзмерения;
			ЕдиницаИзмеренияВладельцаПредставление = Результат.ЕдиницаИзмеренияПредставление;
			НаборЕдиницИзмерения = Результат.НаборЕдиницИзмерения;
			ИспользоватьНаборыЕдиницИзмерения = Результат.ИспользоватьНаборыЕдиницИзмерения;
		КонецЦикла;
		
		МассивОтбора = Новый Массив;
		
		Если ИспользоватьНаборыЕдиницИзмерения И ЗначениеЗаполнено(НаборЕдиницИзмерения) Тогда
			МассивОтбора.Добавить(НаборЕдиницИзмерения);
		Иначе
			МассивОтбора.Добавить(Номенклатура);
		КонецЕсли;
		
		МассивОтбора.Добавить(КатегорияНоменклатуры);
		
		Родитель = КатегорияНоменклатуры.Родитель;
		Пока ЗначениеЗаполнено(Родитель) Цикл
			МассивОтбора.Добавить(Родитель);
			Родитель = Родитель.Родитель;
		КонецЦикла;
		
		Параметры.Отбор.Вставить("Владелец", МассивОтбора);
		
		// Признак повторного входа.
		Параметры.Вставить("Рекурсия");
		
		// Получим стандартный список выбора с учетом дополненного отбора.
		СтандартныйСписок = ПолучитьДанныеВыбора(Параметры);
		
		Если НЕ (Параметры.Свойство("НеИспользоватьКлассификатор") И Параметры.НеИспользоватьКлассификатор = Истина) Тогда
			Если ЗначениеЗаполнено(Номенклатура) Тогда
			// Дополним стандартный список базовой единицей измерения номенклатуры по классификатору.
				ПредставлениеЕдиницыИзмерения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (ед. хранения)'"),
					ЕдиницаИзмеренияВладельцаПредставление);
					
				ПредставлениеЕдиницыХранения = Новый ФорматированнаяСтрока(ПредставлениеЕдиницыИзмерения, Новый Шрифт(,,Истина));
				СтандартныйСписок.Вставить(0, ЕдиницаИзмеренияВладельца, ПредставлениеЕдиницыХранения);
			КонецЕсли;
		КонецЕсли;
		
		ДанныеВыбора = СтандартныйСписок;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	Если ТипЗнч(Данные) = Тип("Структура") И Данные.Свойство("Ссылка") Тогда
		
		Ссылка = Данные.Ссылка;
		
		Если Ссылка = Неопределено Тогда
			Возврат
		КонецЕсли;
		
		СтандартнаяОбработка = Ложь;
		
		ТекстШаблона = НСтр("ru = '%1 (%2 %3)'");
		
		Если ЗначениеЗаполнено(Ссылка.ЕдиницаИзмеренияПоКлассификатору) Тогда
			
			ПредставлениеЕдиницыИзмерения = СокрЛП(Ссылка.ЕдиницаИзмеренияПоКлассификатору);
			
		ИначеЕсли НЕ ПустаяСтрока(Ссылка.Наименование) Тогда
			
			ПредставлениеЕдиницыИзмерения = СокрЛП(Ссылка.Наименование);
			
		Иначе
			
			ПредставлениеЕдиницыИзмерения = НСтр("ru = '<ед.изм.>'");
			
		КонецЕсли;
		
		Если Ссылка.Коэффициент >= 1 Тогда
			
			Представление = СтрШаблон(ТекстШаблона, Ссылка.Наименование, Ссылка.Коэффициент, СокрЛП(Ссылка.ЕдиницаИзмеренияВладельца));
			
		ИначеЕсли Не Ссылка.Коэффициент = 0 Тогда
			
			Представление = СтрШаблон(ТекстШаблона, ПредставлениеЕдиницыИзмерения, ОКР(Ссылка.Коэффициент, 3), Ссылка.ЕдиницаИзмеренияВладельца);
			
		Иначе
			
			СтандартнаяОбработка = Истина;
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает единицу измерения для номенклатуры согласно коэффициенту.
//
// Параметры:
//  Номенклатура - СправочникСсылка.Номенклатура.
//  Коэффициент - Число - коэффициент единицы измерения.
//
// Возвращаемое значение:
//  СправочникСсылка.ЕдиницыИзмерения.
//
Функция ЕдиницаИзмеренияНоменклатуры(Номенклатура, Коэффициент) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК ВладелецЕдиницыИзмерения
	|ПОМЕСТИТЬ втВладельцыЕдиницыИзмерения
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка = &Номенклатура
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Номенклатура.НаборЕдиницИзмерения
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка = &Номенклатура
	|	И Номенклатура.ИспользоватьНаборыЕдиницИзмерения
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Номенклатура.КатегорияНоменклатуры
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка = &Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕдиницыИзмерения.Ссылка КАК Ссылка
	|ИЗ
	|	втВладельцыЕдиницыИзмерения КАК втВладельцыЕдиницыИзмерения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЕдиницыИзмерения КАК ЕдиницыИзмерения
	|		ПО втВладельцыЕдиницыИзмерения.ВладелецЕдиницыИзмерения = ЕдиницыИзмерения.Владелец
	|			И (ЕдиницыИзмерения.Коэффициент = &Коэффициент)";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Коэффициент", Коэффициент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.ЕдиницыИзмерения.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли

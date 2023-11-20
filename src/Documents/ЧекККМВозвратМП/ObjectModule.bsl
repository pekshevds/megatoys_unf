#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбщегоНазначения

Процедура ЗаполнитьПоЧекуККМ(ДанныеЗаполнения) Экспорт
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("ДокументСсылка.ЧекККММП") Тогда
		ВызватьИсключение НСтр("ru = 'Чеки ККМ на возврат должны вводиться на основании чеков ККМ'");
	КонецЕсли;
	
	// Заполним данные шапки документа.
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЧекККМ.Ссылка КАК ЧекККМ,
	|	//ЧекККМ.ВерсияДанных,
	|	ЧекККМ.ПометкаУдаления,
	|	//ЧекККМ.Номер,
	|	//ЧекККМ.Дата,
	|	ЧекККМ.Проведен,
	|	ЧекККМ.СуммаДокумента,
	|	ЧекККМ.Комментарий,
	|	ЧекККМ.СуммаОплаты,
	|	ЧекККМ.СуммаСкидки,
	|	ЧекККМ.ОтчетОРозничныхПродажах,
	|	ЧекККМ.НомерСменыККМ,
	|	ЧекККМ.НомерЧекаККМ,
	|	ЧекККМ.АдресЭП,
	|	ЧекККМ.Телефон,
	|	//ЧекККМ.Статус,
	|	ЧекККМ.РозничнаяТочка,
	|	ЧекККМ.КассаККМ,
	|	ЧекККМ.СуммаКартой,
	|	//ЧекККМ.КодАвторизации,
	|	//ЧекККМ.СсылочныйНомер,
	|	//ЧекККМ.НомерПлатежнойКарты,
	|	//ЧекККМ.ДатаОперацииЭТ,
	|	//ЧекККМ.СлипЧек,
	|	ЧекККМ.Товары.(
	|		Ссылка,
	|		НомерСтроки,
	|		Товар,
	|		Цена,
	|		Количество,
	|		Сумма
	|	)
	|ИЗ
	|	Документ.ЧекККММП КАК ЧекККМ
	|ГДЕ
	|	ЧекККМ.Ссылка = &Ссылка";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка,, "Проведен, НомерЧекаККМ");
	
	ТекстОшибки = "";
	
	Если НЕ Выборка.Проведен Тогда
		ТекстОшибки = НСтр("ru='Чек ККТ не проведен. Ввод на основании невозможен'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Выборка.НомерЧекаККМ) Тогда
		ТекстОшибки = НСтр("ru='Чек ККТ не пробит. Ввод на основании невозможен'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Товары.Загрузить(Выборка.Товары.Выгрузить());
	
КонецПроцедуры // ЗаполнитьПоРасходномуКассовомуОрдеру()

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.ОстаткиТоваровМП.Записывать = Истина;
	Движения.ПродажиМП.Записывать = Истина;
	
	// Движения по регистру ОстаткиТоваров Расход.
	Для каждого ТекСтрокаТовары Из Товары Цикл
		
		Если ТекСтрокаТовары.Товар.Вид = Перечисления.ВидыТоваровМП.Товар Тогда
			
			Движение = Движения.ОстаткиТоваровМП.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
			Движение.Период = Дата;
			Движение.Товар = ТекСтрокаТовары.Товар;
			Движение.Количество = -ТекСтрокаТовары.Количество;
			Движение.Сумма = -ТекСтрокаТовары.Сумма;
			Движение.Операция = Перечисления.ТоварныеОперацииМП.ВозвратОтПокупателя;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Движения по регистру ДенежныеСредства Приход.
	Движение = Движения.ДенежныеСредстваМП.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
	Движение.Период = Дата;
	Движение.Статья = Справочники.СтатьиМП.ОплатаОтПокупателя;
	Движение.Сумма = СуммаДокумента;
	
	Движения.Записать();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПометкаУдаления Тогда
		РежимЗаписи = РежимЗаписиДокумента.Проведение;
	КонецЕсли;
	
	СуммаДокумента = Товары.Итог("Сумма") - СуммаСкидки;
	
	#Если МобильноеПриложениеСервер Тогда
		ОборудованиеПечатиМП = ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("ОборудованиеПечати");
	#Иначе
		ОборудованиеПечатиМП = Неопределено;
	#КонецЕсли

	Если НЕ ЗначениеЗаполнено(ОборудованиеПечатиМП)
		И СуммаОплаты + СуммаКартой >= СуммаДокумента Тогда
		Статус = Перечисления.СтатусЧекаККММП.Пробит;
	КонецЕсли;
	
	Если Статус = Перечисления.СтатусЧекаККММП.Пробит 
		И (НомерЧекаККМ = "0"
		ИЛИ ПустаяСтрока(НомерЧекаККМ)) Тогда
		НомерЧекаККМ = "1";
	КонецЕсли;
	
	#Если МобильноеПриложениеСервер Тогда
		
		Если НЕ ЗначениеЗаполнено(КассаККМ) Тогда
			КассаККМ = ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("КассаККММобильногоПриложения");
		КонецЕсли;
		Если ЗначениеЗаполнено(КассаККМ)
			И НЕ ЗначениеЗаполнено(РозничнаяТочка) Тогда
			РозничнаяТочка = КассаККМ.РозничнаяТочка;
		КонецЕсли;
		
	#КонецЕсли

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ОтчетОРозничныхПродажах = Неопределено;
	Статус = Перечисления.СтатусЧекаККММП.НеПробит;
	Комментарий = "";
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЧекККММП") Тогда
		ЗаполнитьПоЧекуККМ(ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
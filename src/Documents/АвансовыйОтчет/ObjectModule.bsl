#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыЗаполненияДокумента

// Обработчик заполнения на основании документа ПриходныйОрдер.
//
// Параметры:
//	ДокументСсылкаПриходныйОрдер - ДокументСсылка.ПриходныйОрдер - Плановый платеж
//	
Процедура ЗаполнитьПоПриходномуОрдеру(ДокументСсылкаПриходныйОрдер) Экспорт
	
	Организация = ДокументСсылкаПриходныйОрдер.Организация;
	ДокументОснование = ДокументСсылкаПриходныйОрдер.Ссылка;
	СтруктурнаяЕдиница = ДокументОснование.СтруктурнаяЕдиница;
	НалогиУНФ.ЗаполнитьНДСВключенВСтоимостьВДокументе(ЭтотОбъект);
	
	Запасы.Очистить();
	Расходы.Очистить();
	
	УчетГТД = ПолучитьФункциональнуюОпцию("УчетГТД");
	
	ВидУчета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктурнаяЕдиница, "ВидУчетаОрдерныхСкладов");
	
	Если ВидУчета = Перечисления.ВидыУчетаОрдерныхСкладов.ПоСкладуВЦелом Тогда
		ЗаполнитьПоСкладскомуОрдеруБезУчетаОстатков(ДокументСсылкаПриходныйОрдер);
		Возврат;
	КонецЕсли;
	
	Если ВидУчета = Перечисления.ВидыУчетаОрдерныхСкладов.УчетОстатковПоПрочимДокументам Тогда
		ТекстИсключения = НСтр("ru = 'Вид учета остатков на ордерном складе - по Авансовым отчетам. Ввод Авансового отчета на основании Складского ордера недоступен.'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	УчетОстатковПоСкладскимОрдерам = СкладскойУчетСервер.УчетОстатковВРазрезеСкладскихОрдеров(СтруктурнаяЕдиница);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПриходныйОрдерЗапасы.НомерСтроки КАК НомерСтроки,
	|	ПриходныйОрдерЗапасы.Номенклатура КАК Номенклатура,
	|	ПриходныйОрдерЗапасы.Характеристика КАК Характеристика,
	|	ПриходныйОрдерЗапасы.Партия КАК Партия,
	|	ПриходныйОрдерЗапасы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ПриходныйОрдерЗапасы.Количество КАК Количество,
	|	ВЫБОР
	|		КОГДА &КонтролироватьОстаткиПоДокументам
	|			ТОГДА &ДокументОснование
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ДокументПоступления,
	|	ПриходныйОрдерЗапасы.Ячейка КАК Ячейка,
	|	&СтруктурнаяЕдиница КАК СтруктурнаяЕдиница
	|ИЗ
	|	Документ.ПриходныйОрдер.Запасы КАК ПриходныйОрдерЗапасы
	|ГДЕ
	|	ПриходныйОрдерЗапасы.Ссылка = &ДокументОснование
	|	И ПриходныйОрдерЗапасы.Номенклатура.ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Запас), ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.ПодарочныйСертификат))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗапасыКПоступлениюНаСкладыОстатки.Номенклатура КАК Номенклатура,
	|	ЗапасыКПоступлениюНаСкладыОстатки.Характеристика КАК Характеристика,
	|	ЗапасыКПоступлениюНаСкладыОстатки.Партия КАК Партия,
	|	ВЫБОР
	|		КОГДА ЗапасыКПоступлениюНаСкладыОстатки.КоличествоОстаток < 0
	|			ТОГДА -ЗапасыКПоступлениюНаСкладыОстатки.КоличествоОстаток
	|		ИНАЧЕ ЗапасыКПоступлениюНаСкладыОстатки.КоличествоОстаток
	|	КОНЕЦ КАК Количество,
	|	ВЫБОР
	|		КОГДА &КонтролироватьОстаткиПоДокументам
	|			ТОГДА &ДокументОснование
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ДокументПоступления,
	|	&СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ЗапасыКПоступлениюНаСкладыОстатки.Ячейка КАК Ячейка
	|ИЗ
	|	РегистрНакопления.ЗапасыКПоступлениюНаСклады.Остатки(
	|			,
	|			Организация = &Организация
	|				И СтруктурнаяЕдиница = &СтруктурнаяЕдиница
	|				И ДокументОснование = &ДокументОснование) КАК ЗапасыКПоступлениюНаСкладыОстатки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗапасыКПоступлениюНаСклады.Номенклатура,
	|	ЗапасыКПоступлениюНаСклады.Характеристика,
	|	ЗапасыКПоступлениюНаСклады.Партия,
	|	ВЫБОР
	|		КОГДА ЗапасыКПоступлениюНаСклады.Количество < 0
	|			ТОГДА -ЗапасыКПоступлениюНаСклады.Количество
	|		ИНАЧЕ ЗапасыКПоступлениюНаСклады.Количество
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА &КонтролироватьОстаткиПоДокументам
	|			ТОГДА &ДокументОснование
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	&СтруктурнаяЕдиница,
	|	ЗапасыКПоступлениюНаСклады.Ячейка
	|ИЗ
	|	РегистрНакопления.ЗапасыКПоступлениюНаСклады КАК ЗапасыКПоступлениюНаСклады
	|ГДЕ
	|	ЗапасыКПоступлениюНаСклады.Регистратор = &Ссылка
	|	И ЗапасыКПоступлениюНаСклады.ДокументОснование = &ДокументОснование");
	
	Компания = Константы.УчетПоКомпании.Компания(Организация);
	
	КонтролироватьОстаткиПоДокументам = ВидУчета = Перечисления.ВидыУчетаОрдерныхСкладов.УчетОстатковПоСкладскимОрдерам;
	Запрос.УстановитьПараметр("ДокументОснование", ?(КонтролироватьОстаткиПоДокументам, ДокументСсылкаПриходныйОрдер, Неопределено));
	
	Запрос.УстановитьПараметр("Организация", Компания);
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", СтруктурнаяЕдиница);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.УстановитьПараметр("КонтролироватьОстаткиПоДокументам", Истина);
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	Если РезультатыЗапроса[1].Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаОстаткиЗапасы = РезультатыЗапроса[1].Выгрузить();
	
	ВыборкаЗапасы = РезультатыЗапроса[0].Выбрать();
	
	Если СкладскойУчетСервер.КонтролироватьОстаткиПоЯчейкамКПоступлениюОтгрзуке(СтруктурнаяЕдиница) Тогда
		ПараметрыПоискаОстаткиЗапасы = Новый Структура("Номенклатура, Характеристика, Партия, Ячейка");
	Иначе
		ПараметрыПоискаОстаткиЗапасы = Новый Структура("Номенклатура, Характеристика, Партия");
	КонецЕсли;
	
	НалогообложениеНДС = НалогиУНФ.НалогообложениеНДС(Организация, , ТекущаяДатаСеанса());
	
	ОблагаетсяНДС = НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ОблагаетсяНДС;
	
	Пока ВыборкаЗапасы.Следующий() Цикл
		
		Если Не ЗначениеЗаполнено(ВыборкаЗапасы.Количество) Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ПараметрыПоискаОстаткиЗапасы, ВыборкаЗапасы);
		НайденныеОстаткиЗапасы = ТаблицаОстаткиЗапасы.НайтиСтроки(ПараметрыПоискаОстаткиЗапасы);
		
		Если Не НайденныеОстаткиЗапасы.Количество() Или (НайденныеОстаткиЗапасы.Количество() И НайденныеОстаткиЗапасы[0].Количество = 0) Тогда
			Продолжить
		КонецЕсли;
		
		ОстатокЗапасов = НайденныеОстаткиЗапасы[0];
		
		НоваяСтрокаЗапасы = Запасы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаЗапасы, ВыборкаЗапасы);
		
		Если ТипЗнч(НоваяСтрокаЗапасы.ЕдиницаИзмерения) = ТИП("СправочникСсылка.КлассификаторЕдиницИзмерения") Тогда
			
			КоличествоВСтрокеЗапасов = НоваяСтрокаЗапасы.Количество;
			
			Если КоличествоВСтрокеЗапасов >= ОстатокЗапасов.Количество Тогда
				КоличествоВСтрокеЗапасов = ОстатокЗапасов.Количество;
				ОстатокЗапасов.Количество = 0;
			Иначе
				ОстатокЗапасов.Количество = ОстатокЗапасов.Количество - КоличествоВСтрокеЗапасов;
			КонецЕсли;
			
			НоваяСтрокаЗапасы.Количество = КоличествоВСтрокеЗапасов;
			
		Иначе
			
			КоличествоВСтрокеЗапасов = НоваяСтрокаЗапасы.Количество * НоваяСтрокаЗапасы.ЕдиницаИзмерения.Коэффициент;
			
			Если КоличествоВСтрокеЗапасов >= ОстатокЗапасов.Количество Тогда
				КоличествоВСтрокеЗапасов = ОстатокЗапасов.Количество;
				ОстатокЗапасов.Количество = 0;
			Иначе
				ОстатокЗапасов.Количество = ОстатокЗапасов.Количество - КоличествоВСтрокеЗапасов;
			КонецЕсли;
			
			НоваяСтрокаЗапасы.Количество = КоличествоВСтрокеЗапасов/ НоваяСтрокаЗапасы.ЕдиницаИзмерения.Коэффициент;;
			
		КонецЕсли;
		
		Если ОблагаетсяНДС Тогда
			Партия = НоваяСтрокаЗапасы.Партия;
			Если ЗначениеЗаполнено(Партия) И Партия.Статус = Перечисления.СтатусыПартий.ТоварыНаКомиссии 
				И Партия.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.НеОблагаетсяНДС Тогда
				
				НоваяСтрокаЗапасы.СтавкаНДС = Справочники.СтавкиНДС.СтавкаНДС(Перечисления.ВидыСтавокНДС.БезНДС);;
			Иначе
				
				Если ЗначениеЗаполнено(НоваяСтрокаЗапасы.Номенклатура.ВидСтавкиНДС) Тогда
					НоваяСтрокаЗапасы.СтавкаНДС = Справочники.СтавкиНДС.СтавкаНДС(НоваяСтрокаЗапасы.Номенклатура.ВидСтавкиНДС, ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
				Иначе
					НоваяСтрокаЗапасы.СтавкаНДС = Справочники.СтавкиНДС.СтавкаНДС(Компания.ВидСтавкиНДСПоУмолчанию, ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
				КонецЕсли;
				
			КонецЕсли;
		Иначе
			
			Если НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.НеОблагаетсяНДС Тогда
				СтавкаНДСПоУмолчанию = УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДСБезНДС();
			Иначе
				СтавкаНДСПоУмолчанию = УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДСНоль();
			КонецЕсли;
			
			НоваяСтрокаЗапасы.СтавкаНДС = СтавкаНДСПоУмолчанию;
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры // ЗаполнитьПоПриходномуОрдеру()

// Обработчик заполнения на основании складского ордера без учета остатков.
//
// Параметры:
//	ДанныеЗаполнения - ДокументСсылка.ПриходныйОрдер Или ДокументСсылка.РасходныйОрдер.
//	Приходный - Признак вида ордера.
//
Процедура ЗаполнитьПоСкладскомуОрдеруБезУчетаОстатков(ДанныеЗаполнения, Приходный = Истина) Экспорт 
	
	Для каждого ТекСтрокаЗапасы Из ДанныеЗаполнения.Запасы Цикл
		
		НоваяСтрока = Запасы.Добавить();
		НоваяСтрока.ЕдиницаИзмерения = ТекСтрокаЗапасы.ЕдиницаИзмерения;
		НоваяСтрока.Количество = ТекСтрокаЗапасы.Количество;
		НоваяСтрока.Номенклатура = ТекСтрокаЗапасы.Номенклатура;
		НоваяСтрока.Партия = ТекСтрокаЗапасы.Партия;
		НоваяСтрока.Характеристика = ТекСтрокаЗапасы.Характеристика;
		НоваяСтрока.СтруктурнаяЕдиница = ДанныеЗаполнения.СтруктурнаяЕдиница;
		НоваяСтрока.Ячейка = ДанныеЗаполнения.Ячейка;
		НоваяСтрока.СтавкаНДС = Справочники.СтавкиНДС.СтавкаНДС(НоваяСтрока.Номенклатура.ВидСтавкиНДС, Дата);
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик ввода на основании документа РасходИзКассы.
//
// Параметры:
//	ДокументСсылкаРасходИзКассы - ДокументСсылка.РасходИзКассы.
//	
Процедура ЗаполнитьПоРасходуИзКассы(ДокументСсылкаРасходИзКассы) Экспорт
	
	Если ДокументСсылкаРасходИзКассы.ВидОперации <> Перечисления.ВидыОперацийРасходИзКассы.Подотчетнику Тогда
		ВызватьИсключение НСтр("ru = 'Нельзя ввести Авансовый отчет на основании расхода из кассы с этим видом операции!'");
	КонецЕсли;
	
	Организация = ДокументСсылкаРасходИзКассы.Организация;
	ДокументОснование = ДокументСсылкаРасходИзКассы.Ссылка;
	Сотрудник = ДокументСсылкаРасходИзКассы.Подотчетник;
	ВалютаДокумента = ДокументСсылкаРасходИзКассы.ВалютаДенежныхСредств;
	НалогиУНФ.ЗаполнитьНДСВключенВСтоимостьВДокументе(ЭтотОбъект);
	
	Если НЕ ЗначениеЗаполнено(ПодписьБухгалтера) Тогда
		
		ПодписьБухгалтера = ДокументСсылкаРасходИзКассы.Касса.ПодписьКассира;
		
	КонецЕсли;
	
	СтруктураПоВалюте = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Дата, Новый Структура("Валюта", ВалютаДокумента));
	Курс = ?(
		СтруктураПоВалюте.Курс = 0,
		1,
		СтруктураПоВалюте.Курс);
	Кратность = ?(
		СтруктураПоВалюте.Курс = 0,
		1,
		СтруктураПоВалюте.Кратность);
	
	ВыданныеАвансы.Очистить();
	НоваяСтрока = ВыданныеАвансы.Добавить();
	НоваяСтрока.Документ = ДокументСсылкаРасходИзКассы.Ссылка;
	НоваяСтрока.Сумма = ДокументСсылкаРасходИзКассы.СуммаДокумента;
	
	Проект = ДокументСсылкаРасходИзКассы.Проект;
	
КонецПроцедуры // ЗаполнитьПоРасходуИзКассы()

// Обработчик заполнения на основании документа РасходСоСчета.
//
// Параметры:
//	ДокументСсылкаРасходСоСчета - ДокументСсылка.РасходСоСчета.
//	
Процедура ЗаполнитьПоРасходуСоСчета(ДокументСсылкаРасходСоСчета) Экспорт
	
	Если ДокументСсылкаРасходСоСчета.ВидОперации <> Перечисления.ВидыОперацийРасходСоСчета.Подотчетнику Тогда
		ВызватьИсключение НСтр("ru = 'Нельзя ввести Авансовый отчет на основании расхода со счета с этим видом операции!'");
	КонецЕсли;
	
	Организация = ДокументСсылкаРасходСоСчета.Организация;
	ДокументОснование = ДокументСсылкаРасходСоСчета.Ссылка;
	Сотрудник = ДокументСсылкаРасходСоСчета.Подотчетник;
	ВалютаДокумента = ДокументСсылкаРасходСоСчета.ВалютаДенежныхСредств;
	НалогиУНФ.ЗаполнитьНДСВключенВСтоимостьВДокументе(ЭтотОбъект);
	
	СтруктураПоВалюте = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Дата, Новый Структура("Валюта", ВалютаДокумента));
	Курс = ?(
		СтруктураПоВалюте.Курс = 0,
		1,
		СтруктураПоВалюте.Курс);
	Кратность = ?(
		СтруктураПоВалюте.Курс = 0,
		1,
		СтруктураПоВалюте.Кратность);
	
	ВыданныеАвансы.Очистить();
	НоваяСтрока = ВыданныеАвансы.Добавить();
	НоваяСтрока.Документ = ДокументСсылкаРасходСоСчета.Ссылка;
	НоваяСтрока.Сумма = ДокументСсылкаРасходСоСчета.СуммаДокумента;
	
	Проект = ДокументСсылкаРасходСоСчета.Проект;
	
КонецПроцедуры // ЗаполнитьПоРасходуСоСчета()

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.ПриходныйОрдер")] = "ЗаполнитьПоПриходномуОрдеру";
	СтратегияЗаполнения[Тип("ДокументСсылка.РасходИзКассы")] = "ЗаполнитьПоРасходуИзКассы";
	СтратегияЗаполнения[Тип("ДокументСсылка.РасходСоСчета")] = "ЗаполнитьПоРасходуСоСчета";
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
	УчитыватьВНУ = Ложь;
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ИзрасходованоИтог = ВыданныеАвансы.Итог("Сумма");
	ЗапасыИтог = Запасы.Итог("Всего");
	РасходыИтог = Расходы.Итог("Всего");
	ОплатыИтог = Оплаты.Итог("СуммаПлатежа");
	
	Если ИзрасходованоИтог > ЗапасыИтог + РасходыИтог + ОплатыИтог Тогда
		ТекстСообщения = НСтр("ru = 'Израсходованная сумма авансов превышает сумму по документу.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ВыданныеАвансы[0].Сумма", , Отказ);
	КонецЕсли;
	
	Для Каждого СтрокаОплаты Из Оплаты Цикл
		Если СтрокаОплаты.Контрагент.ВестиРасчетыПоДокументам
			И Не СтрокаОплаты.ПризнакАванса
			И Не ЗначениеЗаполнено(СтрокаОплаты.Документ) Тогда
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'Не заполнена колонка ""Документ расчетов"" в строке %1 списка ""Оплаты"".'"),
				СтрокаОплаты.НомерСтроки);
			КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Оплаты", СтрокаОплаты.НомерСтроки,
				"Документ");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаРасходы Из Расходы Цикл
		
		Если ПолучитьФункциональнуюОпцию("УчетПоНесколькимПодразделениям")
			И (СтрокаРасходы.Номенклатура.СчетУчетаЗатрат.ТипСчета = Перечисления.ТипыСчетов.НезавершенноеПроизводство
			Или СтрокаРасходы.Номенклатура.СчетУчетаЗатрат.ТипСчета = Перечисления.ТипыСчетов.КосвенныеЗатраты
			Или СтрокаРасходы.Номенклатура.СчетУчетаЗатрат.ТипСчета = Перечисления.ТипыСчетов.Доходы
			Или СтрокаРасходы.Номенклатура.СчетУчетаЗатрат.ТипСчета = Перечисления.ТипыСчетов.Расходы)
			И Не ЗначениеЗаполнено(СтрокаРасходы.СтруктурнаяЕдиница) Тогда
			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'Для номенклатуры ""%1"" указанной в строке %2 списка ""Расходы"", должен быть заполнен реквизит ""Подразделение"".'"),
				СтрокаРасходы.Номенклатура, СтрокаРасходы.НомерСтроки);
			КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Расходы",
				СтрокаРасходы.НомерСтроки, "СтруктурнаяЕдиница");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
		КонецЕсли;
		
		Если СтрокаРасходы.ПредъявленСФ Тогда
			Если Не ЗначениеЗаполнено(СтрокаРасходы.ДатаСФ) Тогда
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Не заполнена дата счет-фактуры в строке %1 таблицы ""Расходы""'"),
				СтрокаРасходы.НомерСтроки);
				КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Расходы", СтрокаРасходы.НомерСтроки,
				"ДатаСФ");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
			КонецЕсли;
			Если Не ЗначениеЗаполнено(СтрокаРасходы.НомерСФ) Тогда
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Не заполнен номер счет-фактуры в строке %1 таблицы ""Расходы""'"),
				СтрокаРасходы.НомерСтроки);
				КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Расходы", СтрокаРасходы.НомерСтроки,
				"НомерСФ");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
			КонецЕсли;
			Если Не ЗначениеЗаполнено(СтрокаРасходы.Поставщик) Тогда
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Не заполнен поставщик в строке %1 таблицы ""Расходы""'"),
				СтрокаРасходы.НомерСтроки);
				КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Расходы", СтрокаРасходы.НомерСтроки,
				"Поставщик");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;

	Для Каждого СтрокаЗапасы Из Запасы Цикл
		Если СтрокаЗапасы.ПредъявленСФ Тогда
			Если Не ЗначениеЗаполнено(СтрокаЗапасы.ДатаСФ) Тогда
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Не заполнена дата счет-фактуры в строке %1 таблицы ""Запасы""'"),
				СтрокаЗапасы.НомерСтроки);
				КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Запасы", СтрокаЗапасы.НомерСтроки,
				"ДатаСФ");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
			КонецЕсли;
			Если Не ЗначениеЗаполнено(СтрокаЗапасы.НомерСФ) Тогда
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Не заполнен номер счет-фактуры в строке %1 таблицы ""Запасы""'"),
				СтрокаЗапасы.НомерСтроки);
				КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Запасы", СтрокаЗапасы.НомерСтроки,
				"НомерСФ");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
			КонецЕсли;
			Если Не ЗначениеЗаполнено(СтрокаЗапасы.Поставщик) Тогда
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Не заполнен поставщик в строке %1 таблицы ""Запасы""'"),
				СтрокаЗапасы.НомерСтроки);
				КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Запасы", СтрокаЗапасы.НомерСтроки,
				"Поставщик");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	НоменклатураВДокументахСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, Отказ, Истина);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОрдерныйСклад") Тогда
			Для Каждого СтрокаТабличнойЧасти Из Запасы Цикл
				УчетОстатковПоСкладскимОрдерам = СкладскойУчетСервер.УчетОстатковВРазрезеСкладскихОрдеров(СтрокаТабличнойЧасти.СтруктурнаяЕдиница);
				Если Не ЗначениеЗаполнено(СтрокаТабличнойЧасти.ДокументПоступления) И УчетОстатковПоСкладскимОрдерам Тогда
					ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Приходный ордер'"), СтрокаТабличнойЧасти.НомерСтроки, "Запасы");
					Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Запасы", СтрокаТабличнойЧасти.НомерСтроки, "ДокументПоступления");
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
					Прервать;
				КонецЕсли;
			КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СуммаДокумента = Запасы.Итог("Всего") + Расходы.Итог("Всего") + Оплаты.Итог("СуммаПлатежа");
	
	Если НЕ ПолучитьФункциональнуюОпцию("СебестоимостьБезНДС") Тогда
		НДСВключатьВСтоимость = Истина;
	КонецЕсли;
	
	Если НЕ Константы.ФункциональнаяОпцияУчетПоНесколькимНаправлениямДеятельности.Получить() Тогда
		
		Для каждого СтрокаРасходы Из Расходы Цикл
			
			Если СтрокаРасходы.Номенклатура.СчетУчетаЗатрат.ТипСчета = Перечисления.ТипыСчетов.Расходы Тогда
				
				СтрокаРасходы.НаправлениеДеятельности = Справочники.НаправленияДеятельности.ОсновноеНаправление;
				
			Иначе
				
				СтрокаРасходы.НаправлениеДеятельности = Неопределено;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Для каждого СтрокаТЧ Из Оплаты Цикл
		Если ЗначениеЗаполнено(СтрокаТЧ.Контрагент)
		И НЕ СтрокаТЧ.Контрагент.ВестиРасчетыПоДоговорам
		И НЕ ЗначениеЗаполнено(СтрокаТЧ.Договор) Тогда
			СтрокаТЧ.Договор = Справочники.ДоговорыКонтрагентов.ДоговорПоУмолчанию(СтрокаТЧ.Контрагент);
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ ПолучитьФункциональнуюОпцию("УчетПоНесколькимСкладам") Тогда
		ОсновнойСклад = Справочники.СтруктурныеЕдиницы.ОсновнойСклад;
		Для каждого СтрокаТабличнойЧасти Из Запасы Цикл
			Если СтрокаТабличнойЧасти.СтруктурнаяЕдиница = ОсновнойСклад Тогда
				Продолжить;
			КонецЕсли;
			СтрокаТабличнойЧасти.СтруктурнаяЕдиница = ОсновнойСклад;
		КонецЦикла; 
	КонецЕсли;
	
	Если НЕ ПометкаУдаления Тогда
		
		Если ЗначениеЗаполнено(Ссылка) Тогда
			СформироватьСчетаФактуры();
			СформироватьСчетаФактуры(,"Расходы");
		Иначе
			СсылкаНового = ПолучитьСсылкуНового();
			Если НЕ ЗначениеЗаполнено(СсылкаНового) Тогда
				СсылкаНового = Документы.АвансовыйОтчет.ПолучитьСсылку();
			КонецЕсли;
			СформироватьСчетаФактуры(СсылкаНового);
			СформироватьСчетаФактуры(СсылкаНового, "Расходы");
			УстановитьСсылкуНового(СсылкаНового);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОрдерныйСклад") Тогда
		МассивКонтроляПоЗапасамКПоступлениюПоСкладскимОрдерам = СкладскойУчетСервер.МассивКонтроляПоЗапасамКПоступлениюПоСкладскимОрдерам(Запасы.Выгрузить(,"СтруктурнаяЕдиница"));
	Иначе
		МассивКонтроляПоЗапасамКПоступлениюПоСкладскимОрдерам = Новый Массив;
	КонецЕсли;

	ДополнительныеСвойства.Вставить("МассивКонтроляПоЗапасамКПоступлениюПоСкладскимОрдерам", МассивКонтроляПоЗапасамКПоступлениюПоСкладскимОрдерам);
	
	// Инициализация данных документа.
	Документы.АвансовыйОтчет.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ПроведениеДокументовУНФ.ОтразитьДвижения("ЗапасыКПоступлениюНаСклады", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ЗапасыНаСкладах", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("Запасы", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("РасчетыСПодотчетниками", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("РасчетыСПоставщиками", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДоходыИРасходы", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДоходыИРасходыКассовыйМетод", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДоходыИРасходыНераспределенные", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ДоходыИРасходыОтложенные", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("Закупки", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ОплатаСчетовИЗаказов", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ПлатежныйКалендарь", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("Управленческий", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ОплатаДокументов", ТаблицыДляДвижений, Движения, Отказ);
	ПроведениеДокументовУНФ.ОтразитьДвижения("ЗакупкиДляКУДиР", ТаблицыДляДвижений, Движения, Отказ);
	// Запись наборов записей.
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.АвансовыйОтчет.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	
	ПроведениеДокументовУНФ.ЗакрытьМенеджерВременныхТаблиц(ЭтотОбъект);
	
	// Подчиненные счет-фактуры.
	Если НЕ Отказ Тогда
		ОбработкаПодчиненныхСчетФактур();
	КонецЕсли
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей.
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОрдерныйСклад") Тогда
		МассивКонтроляПоЗапасамКПоступлениюПоСкладскимОрдерам = СкладскойУчетСервер.МассивКонтроляПоЗапасамКПоступлениюПоСкладскимОрдерам(Запасы.Выгрузить(,"СтруктурнаяЕдиница"));
	Иначе
		МассивКонтроляПоЗапасамКПоступлениюПоСкладскимОрдерам = Новый Массив;
	КонецЕсли;

	ДополнительныеСвойства.Вставить("МассивКонтроляПоЗапасамКПоступлениюПоСкладскимОрдерам", МассивКонтроляПоЗапасамКПоступлениюПоСкладскимОрдерам);
	
	// Контроль возникновения отрицательного остатка.
	Документы.АвансовыйОтчет.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	
	// Подчиненный счет-фактура (полученный)
	Если НЕ Отказ Тогда
		
		Если СчетФактураВТабличнойЧастиДокумента Тогда
			ОбработкаПодчиненныхСчетФактур(Ложь);
		Иначе
			СчетаФактурыУНФ.ОтменитьПроведениеПодчиненногоСчетаФактуры(Ссылка, Номер, Дата, ДополнительныеСвойства, Истина);
		КонецЕсли;
		
	КонецЕсли;

	
КонецПроцедуры // ОбработкаУдаленияПроведения()

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если Не СчетФактураВТабличнойЧастиДокумента Тогда
		СчетаФактурыУНФ.ПриЗаписиДокументаОснованияСчетаФактуры(Ссылка, ДополнительныеСвойства, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура отмены / проведения у подчиненных счет-фактур.
//
Процедура ОбработкаПодчиненныхСчетФактур(Провести = Истина)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", Ссылка);
	Запрос.УстановитьПараметр("ПризнакПроведения", НЕ Провести);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СчетФактураДокументыОснования.Ссылка КАК Ссылка,
	|	СчетФактураДокументыОснования.Ссылка.Номер КАК Номер,
	|	СчетФактураДокументыОснования.Ссылка.Дата КАК Дата
	|ИЗ
	|	Документ.СчетФактураПолученный.ДокументыОснования КАК СчетФактураДокументыОснования
	|ГДЕ
	|	СчетФактураДокументыОснования.Ссылка.Проведен = &ПризнакПроведения
	|		И СчетФактураДокументыОснования.ДокументОснование = &ДокументОснование
	|		И (НЕ СчетФактураДокументыОснования.Ссылка.ПометкаУдаления)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	РезультатЗапроса = РезультатЗапроса.Выгрузить();
	Для каждого СтрокаРезультата Из РезультатЗапроса Цикл
		
		ТекущийДокумент = СтрокаРезультата.Ссылка.ПолучитьОбъект();
		Если Провести И НЕ ТекущийДокумент.ПроверитьЗаполнение() Тогда
			Продолжить;
		КонецЕсли;
		
		СостояниеПроведен = ТекущийДокумент.Проведен;
		
		ТекущийДокумент.Проведен = Провести;
		ТекущийДокумент.Записать();
		
		Если СостояниеПроведен И НЕ Провести Тогда
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Отменено проведение счета-фактуры (выданного) №%1 от %2'"),
				ТекущийДокумент.Номер, ТекущийДокумент.Дата);
			
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			
		ИначеЕсли Не СостояниеПроведен И Провести Тогда
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Проведен счет-фактура (выданный) №%1 от %2'"),
				ТекущийДокумент.Номер, ТекущийДокумент.Дата);
			
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ОбработкаПодчиненныхСчетФактур()

// Процедура формирует счет-фактуры для покупателей.
//
Процедура СформироватьСчетаФактуры(СсылкаНового = Неопределено, ИмяТабличнойЧасти = "Запасы")
	
	ТаблицаПодчиненныхСчетФактур = ПолучитьСписокПодчиненныхСчетФактур();
	
	ПараметрыОтбора = Новый Структура("Контрагент, Дата, Номер");
	ПараметрыОтбораПоДокументу = Новый Структура("Поставщик, ДатаСФ, НомерСФ");
	СтруктураВозвратаСуммСчетФактуры = Новый Структура("СуммаДокументаОснования, СуммаНДСДокументаОснования");
	
	Для Каждого СтрокаТабличнойЧасти Из ЭтотОбъект[ИмяТабличнойЧасти] Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаТабличнойЧасти.Поставщик) Тогда
			 СтрокаТабличнойЧасти.ПредъявленСФ = Ложь;
		КонецЕсли;
		
		Если Не СтрокаТабличнойЧасти.ПредъявленСФ
			ИЛИ Не ЗначениеЗаполнено(СтрокаТабличнойЧасти.ДатаСФ) Тогда
			СтрокаТабличнойЧасти.СчетФактура = Документы.СчетФактура.ПустаяСсылка();
			Продолжить;
		КонецЕсли;
		
		ПараметрыОтбора.Вставить("Контрагент", СтрокаТабличнойЧасти.Поставщик);
		ПараметрыОтбора.Вставить("Дата", СтрокаТабличнойЧасти.ДатаСФ);
		ПараметрыОтбора.Вставить("Номер", СтрокаТабличнойЧасти.НомерСФ);
		
		ПараметрыОтбораПоДокументу.Вставить("Поставщик", СтрокаТабличнойЧасти.Поставщик);
		ПараметрыОтбораПоДокументу.Вставить("ДатаСФ", СтрокаТабличнойЧасти.ДатаСФ);
		ПараметрыОтбораПоДокументу.Вставить("НомерСФ", СтрокаТабличнойЧасти.НомерСФ);
		
		СформированНовыйСчетФактура = Ложь;
		РезультатПоиска = ТаблицаПодчиненныхСчетФактур.НайтиСтроки(ПараметрыОтбора);
		
		Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетФактура) Тогда
			
			ДокСчетФактура = СтрокаТабличнойЧасти.СчетФактура.ПолучитьОбъект();
		
		ИначеЕсли РезультатПоиска.Количество() = 0 Тогда
			
			ДокСчетФактура = Документы.СчетФактураПолученный.СоздатьДокумент();
			СформированНовыйСчетФактура = Истина;
			
		Иначе
			
			Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетФактура) Тогда
				ИндексПоиска = 0;
				РезультатИндекс = Неопределено;
				Для каждого СтрокаПоиска Из РезультатПоиска Цикл
					Если СтрокаПоиска.Ссылка = СтрокаТабличнойЧасти.СчетФактура Тогда
						РезультатИндекс = ИндексПоиска;
					КонецЕсли;
					ИндексПоиска = ИндексПоиска + 1;
				КонецЦикла;
				Если РезультатИндекс = Неопределено Тогда
					НайденнаяСчФ = РезультатПоиска[0].Ссылка;
				Иначе
					НайденнаяСчФ = РезультатПоиска[РезультатИндекс].Ссылка;
				КонецЕсли;
			Иначе
				НайденнаяСчФ = РезультатПоиска[0].Ссылка;
			КонецЕсли;
			
			ДокСчетФактура = НайденнаяСчФ.ПолучитьОбъект();
			
		КонецЕсли;
		
		Если СсылкаНового = Неопределено Тогда
			СсылкаНаДокумент = Ссылка;
		Иначе
			СсылкаНаДокумент = СсылкаНового;
		КонецЕсли;
		
		ДокСчетФактура.ДатаВходящегоДокумента = СтрокаТабличнойЧасти.ДатаСФ;
		ДокСчетФактура.НомерВходящегоДокумента = СтрокаТабличнойЧасти.НомерСФ;
		ДокСчетФактура.Дата = СтрокаТабличнойЧасти.ДатаСФ;
		ДокСчетФактура.Автор = Пользователи.АвторизованныйПользователь();
		
		ДокСчетФактура.ВидОперации = Перечисления.ВидыОперацийСчетФактураПолученный.Поступление;
		ДокСчетФактура.Организация = Организация;
		ДокСчетФактура.Контрагент = СтрокаТабличнойЧасти.Поставщик;
		ДокСчетФактура.Договор = Справочники.ДоговорыКонтрагентов.ДоговорПоУмолчанию(СтрокаТабличнойЧасти.Поставщик);
		ДокСчетФактура.ВалютаДокумента= ВалютаДокумента;
		ДокСчетФактура.Курс	 = Курс;
		ДокСчетФактура.Кратность = Кратность;
		ДокСчетФактура.УдалитьОбновлениеЗавершено = Истина;
		
		Если ВалютаДокумента <> Константы.НациональнаяВалюта.Получить() Тогда
			
			ДокСчетФактура.ВалютаКурсКратность = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ДокСчетФактура.Договор.ВалютаРасчетов, СтрокаТабличнойЧасти.ДатаСФ);
			ДокСчетФактура.Курс = ДокСчетФактура.ВалютаКурсКратность.Курс;
			ДокСчетФактура.Кратность = ДокСчетФактура.ВалютаКурсКратность.Кратность;
			
		КонецЕсли;
		
		Если ДокСчетФактура.ДокументыОснования.Найти(СсылкаНаДокумент, "ДокументОснование") = Неопределено Тогда
			
			НоваяСтрока = ДокСчетФактура.ДокументыОснования.Добавить();
			НоваяСтрока.ДокументОснование = СсылкаНаДокумент;
			
		КонецЕсли;
		
		ПараметрыОтбораПоДокументу.Вставить("Поставщик", СтрокаТабличнойЧасти.Поставщик);
		ПараметрыОтбораПоДокументу.Вставить("ДатаСФ", СтрокаТабличнойЧасти.ДатаСФ);
		ПараметрыОтбораПоДокументу.Вставить("НомерСФ", СтрокаТабличнойЧасти.НомерСФ);
		
		СуммаСчетФактуры = РассчитатьСуммуСчетФактурыПоСтрокамСИдентичнымиРеквизитами(ПараметрыОтбораПоДокументу, СтруктураВозвратаСуммСчетФактуры);
		
		ДокСчетФактура.СуммаДокумента = СуммаСчетФактуры.СуммаДокументаОснования;
		ДокСчетФактура.СуммаНДСДокумента = СуммаСчетФактуры.СуммаНДСДокументаОснования; 
		
		Если СуммаВключаетНДС Тогда
			ДокСчетФактура.СуммаДокумента = ДокСчетФактура.СуммаДокумента - ДокСчетФактура.СуммаНДСДокумента;
		КонецЕсли;
		
		ДокСчетФактура.Записать();
		СтрокаТабличнойЧасти.СчетФактура = ДокСчетФактура.Ссылка;
		УстановитьСчетФактуруВСтрокиСИдентичнымиРеквизитами(ПараметрыОтбораПоДокументу, ДокСчетФактура.Ссылка, ИмяТабличнойЧасти);
		
		Если СформированНовыйСчетФактура Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Сформирован Счет-фактура (выданный) №%1 от %2'"),
			ДокСчетФактура.Номер, Формат(ДокСчетФактура.Дата, "ДЛФ=D;"));
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // СформироватьСчетаФактурыПокупатели()

Функция РассчитатьСуммуСчетФактурыПоСтрокамСИдентичнымиРеквизитами(ПараметрыОтбора, СтруктураВозвратаСуммСчетФактуры)
	
	МассивСтрокЗапасы = Запасы.НайтиСтроки(ПараметрыОтбора);
	МассивСтрокРасходы = Расходы.НайтиСтроки(ПараметрыОтбора);
	
	СуммаДокументаОснования = 0;
	СуммаНДСДокументаОснования = 0;
	
	Для Каждого НайденнаяСтрока Из МассивСтрокЗапасы Цикл
			СуммаДокументаОснования = СуммаДокументаОснования + НайденнаяСтрока.Сумма;
			СуммаНДСДокументаОснования = СуммаНДСДокументаОснования + НайденнаяСтрока.СуммаНДС;
	КонецЦикла;
	
	Для Каждого НайденнаяСтрока Из МассивСтрокРасходы Цикл
		СуммаДокументаОснования = СуммаДокументаОснования + НайденнаяСтрока.Сумма;
		СуммаНДСДокументаОснования = СуммаНДСДокументаОснования + НайденнаяСтрока.СуммаНДС;
	КонецЦикла;
	
	СтруктураВозвратаСуммСчетФактуры.СуммаДокументаОснования = СуммаДокументаОснования;
	СтруктураВозвратаСуммСчетФактуры.СуммаНДСДокументаОснования = СуммаНДСДокументаОснования;
	
	Возврат СтруктураВозвратаСуммСчетФактуры;
	
КонецФункции

Процедура УстановитьСчетФактуруВСтрокиСИдентичнымиРеквизитами(ПараметрыОтбора, СсылкаНаСчетФактуру, ИмяТабличнойЧасти)
	
	Если ИмяТабличнойЧасти = "Запасы" Тогда
		МассивСтрокЗапасы = Запасы.НайтиСтроки(ПараметрыОтбора);
		Для Каждого НайденнаяСтрока Из МассивСтрокЗапасы Цикл
			Если ЗначениеЗаполнено(НайденнаяСтрока.СчетФактура) Тогда
				Продолжить
			КонецЕсли;
			НайденнаяСтрока.СчетФактура = СсылкаНаСчетФактуру;
		КонецЦикла;
	КонецЕсли;
	
	МассивСтрокРасходы = Расходы.НайтиСтроки(ПараметрыОтбора);
	Для Каждого НайденнаяСтрока Из МассивСтрокРасходы Цикл
		Если ЗначениеЗаполнено(НайденнаяСтрока.СчетФактура) Тогда
			Продолжить
		КонецЕсли;
		НайденнаяСтрока.СчетФактура = СсылкаНаСчетФактуру;
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьСписокПодчиненныхСчетФактур()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", Ссылка);
	Запрос.УстановитьПараметр("СписокКонтрагентов", Запасы.ВыгрузитьКолонку("Поставщик"));
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТЧДокОснования.Ссылка КАК Ссылка,
	|	ТЧДокОснования.Ссылка.Контрагент КАК Контрагент,
	|	НАЧАЛОПЕРИОДА(ТЧДокОснования.Ссылка.ДатаВходящегоДокумента, ДЕНЬ) КАК Дата,
	|	ЛОЖЬ КАК Использован,
	|	ТЧДокОснования.Ссылка.НомерВходящегоДокумента КАК Номер
	|ИЗ
	|	Документ.СчетФактураПолученный.ДокументыОснования КАК ТЧДокОснования
	|ГДЕ
	|	ТЧДокОснования.ДокументОснование = &ДокументОснование
	|	И НЕ ТЧДокОснования.Ссылка.ПометкаУдаления";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции // ПолучитьСписокПодчиненныхСчетФактурПокупателей()

Процедура ПриКопировании(ОбъектКопирования)
	
	Если СчетФактураВТабличнойЧастиДокумента Тогда
		Для Каждого СтрокаТабличнойЧасти Из Запасы Цикл
			СтрокаТабличнойЧасти.СчетФактура = Неопределено;
			СтрокаТабличнойЧасти.ДатаСФ = Неопределено;
			СтрокаТабличнойЧасти.Поставщик = Неопределено;
			СтрокаТабличнойЧасти.НомерСФ = "";
		КонецЦикла;
		
		Для Каждого СтрокаТабличнойЧасти Из Расходы Цикл
			СтрокаТабличнойЧасти.СчетФактура = Неопределено;
			СтрокаТабличнойЧасти.ДатаСФ = Неопределено;
			СтрокаТабличнойЧасти.Поставщик = Неопределено;
			СтрокаТабличнойЧасти.НомерСФ = "";
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли

#Область ИнтеграцияВЕТИСКлиентСерверПереопределяемый

// Заполняет соответствие полей документов-оснований и исходящей транспортной операции
// 
// Возвращаемое значение:
//  Соответствие - соответствие со свойствами:
//   * ИмяДокумента - Соответствие - ключом свойства является имя документа, например "РеализацияТоваровУслуг",
//  	а значением - соответствие со свойствами:
//   ** ГрузоотправительХозяйствующийСубъект - Строка - имя поля документа, которое соответствует контрагенту
//  	хозяйствующего субъекта грузоотправителя
//   ** ГрузоотправительПредприятие - Строка - имя поля документа, которое соответствует предприятию грузоотправителя
//   ** ГрузополучательХозяйствующийСубъект - Строка - имя поля документа, которое соответствует контрагенту
//  	хозяйствующего субъекта грузополучателя
//   ** ГрузополучательПредприятие - Строка - имя поля документа, которое соответствует предприятию грузополучателя
//
Процедура ЗаполнитьСоответствиеПолейДокументовОснованийИИсходящейТранспортнойОперации(СоответствиеПолей) Экспорт
	
	СоответствиеПолей.Вставить("РасходнаяНакладная", Новый Соответствие);
	СоответствиеПолей["РасходнаяНакладная"].Вставить("ГрузоотправительХозяйствующийСубъект", "Организация");
	СоответствиеПолей["РасходнаяНакладная"].Вставить("ГрузоотправительПредприятие", "СтруктурнаяЕдиница");
	СоответствиеПолей["РасходнаяНакладная"].Вставить("ГрузополучательХозяйствующийСубъект", "Контрагент");
	СоответствиеПолей["РасходнаяНакладная"].Вставить("ГрузополучательПредприятие", "Грузополучатель");
	
	СоответствиеПолей.Вставить("ЗаказПокупателя", Новый Соответствие);
	СоответствиеПолей["ЗаказПокупателя"].Вставить("ГрузоотправительХозяйствующийСубъект", "Организация");
	СоответствиеПолей["ЗаказПокупателя"].Вставить("ГрузоотправительПредприятие", "СтруктурнаяЕдиницаПродажи");
	СоответствиеПолей["ЗаказПокупателя"].Вставить("ГрузополучательХозяйствующийСубъект", Неопределено);
	СоответствиеПолей["ЗаказПокупателя"].Вставить("ГрузополучательПредприятие", "Грузополучатель");
	
	СоответствиеПолей.Вставить("ПеремещениеЗапасов", Новый Соответствие);
	СоответствиеПолей["ПеремещениеЗапасов"].Вставить("ГрузоотправительХозяйствующийСубъект", "Организация");
	СоответствиеПолей["ПеремещениеЗапасов"].Вставить("ГрузоотправительПредприятие", "СтруктурнаяЕдиница");
	СоответствиеПолей["ПеремещениеЗапасов"].Вставить("ГрузополучательХозяйствующийСубъект", Неопределено);
	СоответствиеПолей["ПеремещениеЗапасов"].Вставить("ГрузополучательПредприятие", "СтруктурнаяЕдиницаПолучатель");
	
	СоответствиеПолей.Вставить("ОтчетОПереработке", Новый Соответствие);
	СоответствиеПолей["ОтчетОПереработке"].Вставить("ГрузоотправительХозяйствующийСубъект", "Организация");
	СоответствиеПолей["ОтчетОПереработке"].Вставить("ГрузоотправительПредприятие", "СтруктурнаяЕдиница");
	СоответствиеПолей["ОтчетОПереработке"].Вставить("ГрузополучательХозяйствующийСубъект", "Контрагент");
	СоответствиеПолей["ОтчетОПереработке"].Вставить("ГрузополучательПредприятие", "Грузополучатель");
	
КонецПроцедуры

// Заполняет соответствие полей документов-оснований и входящей транспортной операции
// 
// Возвращаемое значение:
//  Соответствие - соответствие со свойствами:
//   * ИмяДокумента - Соответствие - ключом свойства является имя документа, например "РеализацияТоваровУслуг",
//  	а значением - соответствие со свойствами:
//   ** ГрузоотправительХозяйствующийСубъект - Строка - имя поля документа, которое соответствует контрагенту
//  	хозяйствующего субъекта грузоотправителя
//   ** ГрузоотправительПредприятие - Строка - имя поля документа, которое соответствует предприятию грузоотправителя
//   ** ГрузополучательХозяйствующийСубъект - Строка - имя поля документа, которое соответствует контрагенту
//  	хозяйствующего субъекта грузополучателя
//   ** ГрузополучательПредприятие - Строка - имя поля документа, которое соответствует предприятию грузополучателя
//
Процедура ЗаполнитьСоответствиеПолейДокументовОснованийИВходящейТранспортнойОперации(СоответствиеПолей) Экспорт
	
	СоответствиеПолей.Вставить("ПриходнаяНакладная", Новый Соответствие);
	СоответствиеПолей["ПриходнаяНакладная"].Вставить("ГрузоотправительХозяйствующийСубъект", "Контрагент");
	СоответствиеПолей["ПриходнаяНакладная"].Вставить("ГрузополучательХозяйствующийСубъект", "Организация");
	СоответствиеПолей["ПриходнаяНакладная"].Вставить("ГрузополучательПредприятие", "СтруктурнаяЕдиница");
	
	СоответствиеПолей.Вставить("ПеремещениеЗапасов", Новый Соответствие);
	СоответствиеПолей["ПеремещениеЗапасов"].Вставить("ГрузоотправительПредприятие", "СтруктурнаяЕдиница");
	СоответствиеПолей["ПеремещениеЗапасов"].Вставить("ГрузополучательХозяйствующийСубъект", "Организация");
	СоответствиеПолей["ПеремещениеЗапасов"].Вставить("ГрузополучательПредприятие", "СтруктурнаяЕдиницаПолучатель");
	
КонецПроцедуры

// Заполняет соответствие полей документов-оснований и производственных операций
//
// Возвращаемое значение:
//  Соответствие - соответствие со свойствами:
//   * ИмяДокумента - Соответствие - ключом свойства является имя документа, например "СборкаТоваров",
//  	а значением - соответствие со свойствами:
//   ** ХозяйствующийСубъект - Строка - имя поля документа, которое соответствует хозяйствующему субъекту
//   ** Предприятие - Строка - имя поля документа, которое соответствует предприятию хозяйствующего субъекта
//
Процедура ЗаполнитьСоответствиеПолейДокументовОснованийИПроизводственнойОперации(СоответствиеПолей) Экспорт
	
	СоответствиеПолей.Вставить("СборкаЗапасов", Новый Соответствие);
	СоответствиеПолей["СборкаЗапасов"].Вставить("ХозяйствующийСубъект", "Организация");
	СоответствиеПолей["СборкаЗапасов"].Вставить("Предприятие", "СтруктурнаяЕдиница");
	
КонецПроцедуры

// Заполняет соответствие полей документов-оснований и инвентаризации продукции
// 
// Возвращаемое значение:
//  Соответствие - соответствие со свойствами:
//   * ИмяДокумента - Соответствие - ключом свойства является имя документа, например "СписаниеНедостачТоваров",
//  	а значением - соответствие со свойствами:
//   ** ХозяйствующийСубъект - Строка - имя поля документа, которое соответствует хозяйствующему субъекту
//   ** Предприятие - Строка - имя поля документа, которое соответствует предприятию хозяйствующего субъекта
//
Процедура ЗаполнитьСоответствиеПолейДокументовОснованийИИнвентаризацииПродукции(СоответствиеПолей) Экспорт
	
	СоответствиеПолей.Вставить("СписаниеЗапасов", Новый Соответствие);
	СоответствиеПолей["СписаниеЗапасов"].Вставить("ХозяйствующийСубъект", "Организация");
	СоответствиеПолей["СписаниеЗапасов"].Вставить("Предприятие", "СтруктурнаяЕдиница");
	
	СоответствиеПолей.Вставить("РаспределениеЗатрат", Новый Соответствие);
	СоответствиеПолей["РаспределениеЗатрат"].Вставить("ХозяйствующийСубъект", "Организация");
	СоответствиеПолей["РаспределениеЗатрат"].Вставить("Предприятие", "СтруктурнаяЕдиница");
	
	СоответствиеПолей.Вставить("ОприходованиеЗапасов", Новый Соответствие);
	СоответствиеПолей["ОприходованиеЗапасов"].Вставить("ХозяйствующийСубъект", "Организация");
	СоответствиеПолей["ОприходованиеЗапасов"].Вставить("Предприятие", "СтруктурнаяЕдиница");
	
	СоответствиеПолей.Вставить("ПересортицаЗапасов", Новый Соответствие);
	СоответствиеПолей["ПересортицаЗапасов"].Вставить("ХозяйствующийСубъект", "Организация");
	СоответствиеПолей["ПересортицаЗапасов"].Вставить("Предприятие", "СтруктурнаяЕдиница");
	
КонецПроцедуры

// Заполняет свойства (например, Видимость, Доступность и т. п.) отдельных элементов формы документа 
//   'ПроизводственнаяОперацияВЕТИС' в зависимости от документа-основания.
//
// Параметры:
//   ДокументОснование - ОпределяемыйТип.ОснованиеПроизводственнаяОперацияВЕТИС - Основание документа.
//   Свойства          - Структура                                              - Свойства элементов.
//
Процедура ЗаполнитьСвойстваЭлементовПроизводственнойТранзакцииПоДокументуОснованию(Свойства, ДокументОснование) Экспорт
	
	Свойства.Видимость      = Истина;
	Свойства.ТолькоПросмотр = Ложь;
	ДоступныеТипы = Новый Массив;
	ДоступныеТипы.Добавить(Тип("Строка"));
	Свойства.ОграничениеТипа = Новый ОписаниеТипов(ДоступныеТипы);
	
КонецПроцедуры

// Заполняет признак необходимости заполнения реквизита 'ТорговыйОбъект' документа 'ПроизводственнаяОперацияВЕТИС'.
//
// Параметры:
//   ДокументОснование - ОпределяемыйТип.ОснованиеПроизводственнаяОперацияВЕТИС - Основание документа.
//   Заполнять         - Булево                                                 - Необходимость заполнения.
//
Процедура ЗаполнятьТорговыйОбъектПоДокументуОснованию(ДокументОснование, Заполнять) Экспорт
	
	Если ЗначениеЗаполнено(ДокументОснование)
		И ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.СборкаЗапасов") Тогда
		
		Заполнять = Истина;
		
	Иначе
		
		Заполнять = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет структуру, содержащую поля кэшируемых значений.
// 
// Параметры:
//   КэшированныеЗначения - (см. ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения) - результат.
//
Процедура ЗаполнитьСтруктуруКэшируемыеЗначения(КэшированныеЗначения) Экспорт
	
	Если ТипЗнч(КэшированныеЗначения) <> Тип("Структура") Тогда
		КэшированныеЗначения = Новый Структура;
	КонецЕсли;
	
	КэшированныеЗначения.Вставить("КоэффициентыУпаковок",	Новый Соответствие);
	КэшированныеЗначения.Вставить("ОбъемУпаковок",			Новый Соответствие);
	КэшированныеЗначения.Вставить("ВесУпаковок",			Новый Соответствие);
	КэшированныеЗначения.Вставить("Штрихкоды",				Новый Соответствие);
	КэшированныеЗначения.Вставить("СвойстваНазначений",		Новый Соответствие);
	КэшированныеЗначения.Вставить("СвойстваСкладов",		Новый Соответствие);
	КэшированныеЗначения.Вставить("КонтролироватьЗаполнениеАналитикиРасходов",	Новый Соответствие);
	КэшированныеЗначения.Вставить("РаспределятьНДСпоСтатьеРасходов",			Новый Соответствие);
	КэшированныеЗначения.Вставить("КонтролироватьЗаполнениеАналитикиДоходов",	Новый Соответствие);
	КэшированныеЗначения.Вставить("ИспользоватьАналитикуАктивовПассивов",		Новый Соответствие);
	КэшированныеЗначения.Вставить("ИспользоватьРучныеСкидкиВПродажах",			Неопределено);
	КэшированныеЗначения.Вставить("ИспользоватьАвтоматическиеСкидкиВПродажах",	Неопределено);
	КэшированныеЗначения.Вставить("ИспользоватьРучныеСкидкиВЗакупках",			Неопределено);
	КэшированныеЗначения.Вставить("ПравоРегистрацииШтрихкодовНоменклатурыДоступно",	Неопределено);
	КэшированныеЗначения.Вставить("ПринимаетсяКНУ", Новый Соответствие);
	КэшированныеЗначения.Вставить("ОбработанныеСтроки", Новый Массив);
	
КонецПроцедуры

// Возвращает параметры формы подбора товаров.
//
// Параметры:
//	Форма					- УправляемаяФорма			- Форма, в которой вызывается команда открытия формы подбора товаров.
//	ПараметрыУказанияСерий	- Структура, Неопределено	- Состав полей определен в функции 
//															НоменклатураКлиентСервер.ПараметрыУказанияСерий.
//	ПараметрыПодбора - Структура - Структура со свойствами:
//		* СкрыватьКнопкуЗапрашиватьКоличество		- Булево - Признак необходимости сокрытия кнопки указания количества.
//		* РежимПодбораБезКоличественныхПараметров	- Булево - Признак работы формы подбора товаров с выключенным режимом 
//																использования количественных параметров.
//		* Склад										- ОпределяемыйТип.ТорговыйОбъектВЕТИС - Склад, на котором осуществляется подбор товаров.
//		* ПараметрыУказанияСерий					- ПараметрыУказанияСерий - Состав полей определен в функции 
//																			НоменклатураКлиентСервер.ПараметрыУказанияСерий.
//
Процедура ЗаполнитьПараметрыФормыПодбораТоваров(ПараметрыПодбора, Форма, ПараметрыУказанияСерий) Экспорт
	
	Если ТипЗнч(ПараметрыПодбора) <> Тип("Структура") Тогда
		ПараметрыПодбора = Новый Структура;
	КонецЕсли;
	
	ПараметрыПодбора.Вставить("РежимВыбора", Истина);
	
КонецПроцедуры

// Заполняет параметры оформления серии по данным строки (если использование условного оформления не возможно).
//
// Параметры:
//   ПараметрыОформленияСерии - Структура - поля, на основании которых можно оформить элемент формы.
//   ДанныеСтроки - Структура, ДанныеФормыЭлементКоллекции - данные, в которых содержится информация по оформлению серии.
//
Процедура ЗаполнитьПараметрыОформленияСерииПоДаннымСтроки(ПараметрыОформленияСерии, ДанныеСтроки) Экспорт
	
	// Значения по умолчанию:
	ПараметрыОформленияСерии.Вставить("ИмяЦветаТекста", "ЦветТекстаПоля");
	ПараметрыОформленияСерии.Вставить("ОтметкаНезаполненного", Ложь);
	ПараметрыОформленияСерии.Вставить("Текст", "");
	ПараметрыОформленияСерии.Вставить("ТолькоПросмотр", Ложь);
	ПараметрыОформленияСерии.Вставить("Видимость", Истина);
	
	СтруктураНоменклатуры = ИнтеграцияВЕТИСУНФВызовСервера.ПолучитьСтруктуруСлужебныхРеквизитовНоменклатуры(ДанныеСтроки.Номенклатура);
		
	Если СтруктураНоменклатуры.ИспользоватьПартии = Истина Тогда //СтруктураНоменклатуры.ИспользоватьПартии возвращает Неопределено, если номенклатура не заполнена
		ПараметрыОформленияСерии.ОтметкаНезаполненного = СтруктураНоменклатуры.ПроверятьЗаполнениеПартий;
	Иначе
		ПараметрыОформленияСерии.Видимость = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКомандыВЕТИСКлиентСерверПереопределяемый

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
// 	Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыИсходящейТранспортнойОперации(Команды) Экспорт
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"РасходнаяНакладная",	НСтр("ru = 'Расходную накладную'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ПеремещениеЗапасов",	НСтр("ru = 'Перемещение запасов'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ЗаказПокупателя",		НСтр("ru = 'Заказ-наряд'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ОтчетОПереработке",		НСтр("ru = 'Отчет о переработке'"));
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"РасходнаяНакладная",	НСтр("ru = 'Расходную накладную'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ПеремещениеЗапасов",	НСтр("ru = 'Перемещение запасов'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ЗаказПокупателя",		НСтр("ru = 'Заказ-наряд'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ОтчетОПереработке",		НСтр("ru = 'Отчет о переработке'"));
	
КонецПроцедуры

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
// 	Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыВходящейТранспортнойОперации(Команды) Экспорт
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ПриходнаяНакладная",	НСтр("ru = 'Приходную накладную'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ПеремещениеЗапасов",	НСтр("ru = 'Перемещение запасов'"));
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ПриходнаяНакладная",	НСтр("ru = 'Приходную накладную'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ПеремещениеЗапасов",	НСтр("ru = 'Перемещение запасов'"));
	
КонецПроцедуры

Процедура КомандыПроизводственнойОперации(Команды) Экспорт
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды, "СборкаЗапасов",         НСтр("ru = 'Оформить Производство'"), "ИспользоватьПодсистемуПроизводство");
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "СборкаЗапасов",         НСтр("ru = 'Выбрать Производство'"), "ИспользоватьПодсистемуПроизводство");
	
КонецПроцедуры

Процедура КомандыИнвентаризацииПродукции(Команды) Экспорт
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"СписаниеЗапасов",			НСтр("ru = 'Списание запасов'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ОприходованиеЗапасов",	НСтр("ru = 'Оприходование запасов'"));
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"СписаниеЗапасов",			НСтр("ru = 'Списание запасов'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"РаспределениеЗатрат",		НСтр("ru = 'Распределение затрат'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ОприходованиеЗапасов",		НСтр("ru = 'Оприходование запасов'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ПересортицаЗапасов",		НСтр("ru = 'Пересортицу запасов'"));
	
КонецПроцедуры

// Устанавливает видимость команд динамически формируемых для создания документов на основании.
// 
// Параметры:
// 	Форма   - УправляемаяФорма - Форма на которой находятся вызова команд.
// 	Команды - Структура - структура команд динамически формируемых для создания документов на основании.
//
Процедура УправлениеВидимостьюКомандИсходящейТранспортнойОперации(Форма, КомандыОбъекта) Экспорт
	
	Если ЗначениеЗаполнено(Форма.Объект.ДокументОснование)Тогда
		Форма.Элементы.ГруппаКомандыЗаполненияОснования.Видимость = Ложь;
		Возврат;
	Иначе 
		Форма.Элементы.ГруппаКомандыЗаполненияОснования.Видимость = Истина;
	КонецЕсли;
		
	ОднаОрганизация = (Форма.ГрузоотправительСопоставлениеХСДляОтбораОснований = Форма.ГрузополучательСопоставлениеХСДляОтбораОснований)
		И ЗначениеЗаполнено(Форма.ГрузоотправительСопоставлениеХСДляОтбораОснований);
		
	ПолучательОрганизация = ТипЗнч(Форма.ГрузополучательСопоставлениеХСДляОтбораОснований) = Тип("СправочникСсылка.Организации");
		
	Для Каждого КлючИЗначение Из Форма.ВидимостьПодключаемыхКоманд Цикл
		
		Если КлючИЗначение.Значение.ИмяМетаданных = "ПеремещениеЗапасов" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = ОднаОрганизация;
		Иначе 
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = НЕ ОднаОрганизация И НЕ ПолучательОрганизация;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Устанавливает видимость команд динамически формируемых для создания документов на основании.
// 
// Параметры:
// 	Форма   - УправляемаяФорма - Форма на которой находятся вызова команд.
// 	Команды - Структура - структура команд динамически формируемых для создания документов на основании.
//
Процедура УправлениеВидимостьюКомандВходящейТранспортнойОперации(Форма, КомандыОбъекта) Экспорт
	
	Если ЗначениеЗаполнено(Форма.Объект.ДокументОснование)Тогда
		Форма.Элементы.ГруппаКомандыЗаполненияОснования.Видимость = Ложь;
		Возврат;
	Иначе 
		Форма.Элементы.ГруппаКомандыЗаполненияОснования.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает видимость команд динамически формируемых для создания документов на основании.
// 
// Параметры:
// 	Форма   - УправляемаяФорма - Форма на которой находятся вызова команд.
// 	Команды - Структура - структура команд динамически формируемых для создания документов на основании.
//
Процедура УправлениеВидимостьюКомандПроизводственнойОперации(Форма, КомандыОбъекта) Экспорт
	
	Если ЗначениеЗаполнено(Форма.Объект.ДокументОснование)Тогда
		Форма.Элементы.ГруппаКомандыЗаполненияОснования.Видимость = Ложь;
		Возврат;
	Иначе 
		Форма.Элементы.ГруппаКомандыЗаполненияОснования.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает видимость команд динамически формируемых для создания документов на основании.
// 
// Параметры:
// 	Форма   - УправляемаяФорма - Форма на которой находятся вызова команд.
// 	Команды - Структура - структура команд динамически формируемых для создания документов на основании.
//
Процедура УправлениеВидимостьюКомандИнвентаризацииПродукции(Форма, КомандыОбъекта) Экспорт
	
	ЕстьРасход = Ложь;
	ЕстьПриход = Ложь;
	Для Каждого СтрокаТЧ Из Форма.Объект.Товары Цикл
		Если СтрокаТЧ.КоличествоИзменениеВЕТИС<0 Тогда 
			ЕстьРасход = Истина;
		ИначеЕсли СтрокаТЧ.КоличествоИзменениеВЕТИС>0 Тогда 
			ЕстьПриход = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из Форма.ВидимостьПодключаемыхКоманд Цикл 
		Если КлючИЗначение.Значение.ИмяМетаданных = "ПересортицаЗапасов" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = ЕстьПриход = ЕстьРасход;
		ИначеЕсли КлючИЗначение.Значение.ИмяМетаданных = "ОприходованиеЗапасов" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = НЕ ЕстьРасход;
		Иначе
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = НЕ ЕстьПриход;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

Процедура УстановитьВидимостьКомандыГенерацииСерии(Форма) Экспорт
	
	Если СтрНайти(Форма.ИмяФормы, "Документ.ВходящаяТранспортнаяОперацияВЕТИС.Форма.ФормаДокумента") <> 0
		И Форма.Элементы.Найти("СгенерироватьСерию") <> Неопределено
		И Форма.Объект.Товары.Количество() > 0 Тогда
		
		Форма.Элементы.СгенерироватьСерию.Видимость = Форма.Объект.Товары[0].СтатусУказанияСерий = 1;
		
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьСтруктуруПоСтроке(СтрокаТаблицы, Действие) Экспорт
	
	Если Действие = "ПроверитьСериюРассчитатьСтатус" Тогда
		
		СтруктураСтроки = Новый Структура("ХарактеристикиИспользуются,
										|Характеристика,
										|ТипНоменклатуры,
										|СтатусУказанияСерий,
										|СопоставленоКоличество,
										|Сопоставлено,
										|СопоставлениеХарактеристика,
										|СопоставлениеНоменклатура,
										|Серия,
										|НомерСтроки,
										|Номенклатура,
										|КоличествоВЕТИС,
										|Количество,
										|ИдентификаторПартии,
										|ЗаписьСкладскогоЖурнала,
										|ЕдиницаИзмерения,
										|Артикул");
		
	ИначеЕсли Действие = "ЗаполнитьПродукциюВЕТИС" Тогда
		
		СтруктураСтроки = Новый Структура("Продукция,
										|Номенклатура,
										|Характеристика,
										|Серия,
										|НоменклатураДляВыбора,
										|СопоставлениеТекст");
		
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(СтруктураСтроки, СтрокаТаблицы);
	
	Возврат СтруктураСтроки;
	
КонецФункции

#Область ПересчетКоличества

// Пересчитывает количество согласно параметров пересчета.
//
// Параметры:
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка для пересчета.
//  ПараметрыПересчетаКоличества - см. ИнтеграцияВЕТИСУНФКлиентСервер.ПараметрыПересчетаКоличества.
//  КэшированныеЗначения - Структура, Неопределено - коллекция кэшированных значений.
//  ТекстОшибки - Строка, Неопределено - возвращаемое значение, описание ошибки.
//
Процедура ПересчитатьКоличество(ТекущаяСтрока, ПараметрыПересчетаКоличества, КэшированныеЗначения, ТекстОшибки = Неопределено) Экспорт
	
	Если НЕ (ПараметрыПересчетаКоличества.ПересчитатьКоличествоЕдиницПоВЕТИС
		ИЛИ ПараметрыПересчетаКоличества.ПересчитатьКоличествоЕдиницВЕТИС) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "ЕдиницаИзмеренияВЕТИС") Тогда
		ЕдиницаИзмеренияВЕТИС = ТекущаяСтрока.ЕдиницаИзмеренияВЕТИС;
	Иначе
		ЕдиницаИзмеренияВЕТИС = ПараметрыПересчетаКоличества.ЕдиницаИзмеренияВЕТИС;
	КонецЕсли;
	
	ИмяКоличествоВЕТИС = "Количество" + ПараметрыПересчетаКоличества.Суффикс + "ВЕТИС";
	ИмяКоличество      = "Количество" + ПараметрыПересчетаКоличества.Суффикс;
	
	Если ПараметрыПересчетаКоличества.ПересчитатьКоличествоЕдиницПоВЕТИС Тогда
		ИмяКолонки = ИмяКоличество;
		Количество = КоличествоЕдиниц(
			ТекущаяСтрока[ИмяКоличествоВЕТИС],
			ТекущаяСтрока.Номенклатура,
			ЕдиницаИзмеренияВЕТИС,
			КэшированныеЗначения,
			ТекстОшибки);
		
	Иначе
		ИмяКолонки = ИмяКоличествоВЕТИС;
		Количество = КоличествоЕдиницВЕТИС(
			ТекущаяСтрока[ИмяКоличество],
			ТекущаяСтрока.Номенклатура,
			ЕдиницаИзмеренияВЕТИС,
			КэшированныеЗначения,
			ТекстОшибки);
	
	КонецЕсли;
	
	Если Количество <> Неопределено Тогда
		ТекущаяСтрока[ИмяКолонки] = Количество;
	КонецЕсли;
	
КонецПроцедуры

// Количество продукции в единицах хранения исходя из количества ВЕТИС.
//
// Параметры:
//  КоличествоВЕТИС - Число - количество для пересчета.
//  Номенклатура - СправочникСсылка.Номенклатура - Номенклатура для единицы хранения, которой осуществляется
//          получение коэффициента пересчета.
//  ЕдиницаИзмеренияВЕТИС - СправочникСсылка.ЕдиницыИзмеренияВЕТИС - Единица измерения ВЕТИС, коэффициент которой нужно
//          получить.
//  КэшированныеЗначения - Структура, Неопределено - коллекция кэшированных значений.
//  ТекстОшибки - Строка, Неопределено - возвращаемое значение, описание ошибки.
//
// Возвращаемое значение:
//   Неопределено, Число.
//
Функция КоличествоЕдиниц(КоличествоВЕТИС, Номенклатура, ЕдиницаИзмеренияВЕТИС, КэшированныеЗначения, ТекстОшибки = Неопределено) Экспорт
	
	НовоеКоличество = Неопределено;
	ТекстОшибки = Неопределено;
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		
		ДанныеЕдиницыИзмерения = КоэффициентЕдиницыИзмеренияВЕТИС(
									ЕдиницаИзмеренияВЕТИС,
									КэшированныеЗначения,
									Номенклатура);
		
		Если ЗначениеЗаполнено(ЕдиницаИзмеренияВЕТИС) Тогда
			
			Если ДанныеЕдиницыИзмерения.КодОшибки <> 0 Тогда
				
				ТекстОшибки = ТекстОшибкиПересчетаЕдиницыИзмеренияВЕТИС(
										ДанныеЕдиницыИзмерения.КодОшибки,
										Номенклатура,
										ЕдиницаИзмеренияВЕТИС,
										ДанныеЕдиницыИзмерения.ТипИзмеряемойВеличины,
										"ВЕТИС");
				
				Возврат Неопределено;
				
			КонецЕсли;
			
			НовоеКоличество = КоличествоВЕТИС * ДанныеЕдиницыИзмерения.Коэффициент;
			
			Если ДанныеЕдиницыИзмерения.НужноОкруглятьКоличество Тогда
				
				НовоеКоличество = Окр(НовоеКоличество, 0, РежимОкругления.Окр15как20);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат НовоеКоличество;
	
КонецФункции

// Количество ВЕТИС исходя из количества продукции в единицах хранения.
//
// Параметры:
//  Количество - Число - количество для пересчета.
//  Номенклатура - СправочникСсылка.Номенклатура - Номенклатура для единицы хранения, которой осуществляется
//          получение коэффициента пересчета.
//  ЕдиницаИзмеренияВЕТИС - СправочникСсылка.ЕдиницыИзмеренияВЕТИС - Единица измерения ВЕТИС, коэффициент которой нужно
//          получить.
//  КэшированныеЗначения - Структура, Неопределено - коллекция кэшированных значений.
//  ТекстОшибки - Строка, Неопределено - возвращаемое значение, описание ошибки.
//
// Возвращаемое значение:
//   Неопределено, Число.
//
Функция КоличествоЕдиницВЕТИС(Количество, Номенклатура, ЕдиницаИзмеренияВЕТИС, КэшированныеЗначения, ТекстОшибки = Неопределено) Экспорт
	
	НовоеКоличествоВЕТИС = Неопределено;
	ТекстОшибки = Неопределено;
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		
		ДанныеЕдиницыИзмерения = КоэффициентЕдиницыИзмеренияВЕТИС(
									ЕдиницаИзмеренияВЕТИС,
									КэшированныеЗначения,
									Номенклатура);
		
		Если ЗначениеЗаполнено(ЕдиницаИзмеренияВЕТИС) Тогда
			
			Если ДанныеЕдиницыИзмерения.КодОшибки <> 0 Тогда
				
				ТекстОшибки = ТекстОшибкиПересчетаЕдиницыИзмеренияВЕТИС(
										ДанныеЕдиницыИзмерения.КодОшибки,
										Номенклатура,
										ЕдиницаИзмеренияВЕТИС,
										ДанныеЕдиницыИзмерения.ТипИзмеряемойВеличины);
				
				Возврат Неопределено;
				
			КонецЕсли;
			
			НовоеКоличествоВЕТИС = Количество / ДанныеЕдиницыИзмерения.Коэффициент;
		
			Если ДанныеЕдиницыИзмерения.НужноОкруглятьКоличество Тогда
				
				НовоеКоличествоВЕТИС = Окр(НовоеКоличествоВЕТИС, 0, РежимОкругления.Окр15как20);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;

	Возврат НовоеКоличествоВЕТИС;
	
КонецФункции

// Возвращает сведения о коэффициенте пересчета единицы измерения ВЕТИС.
//
// Параметры:
//	ЕдиницаИзмеренияВЕТИС	- СправочникСсылка.ЕдиницыИзмеренияВЕТИС	- Единица измерения ВЕТИС, коэффициент которой нужно
//																		получить.
//	КэшированныеЗначения	- Структура									- Сохраненные значения параметров, используемых при обработке
//																		строки таблицы.
//	Номенклатура			- СправочникСсылка.Номенклатура				- Номенклатура для единицы хранения, которой осуществляется
//																		получение коэффициента пересчета.
//
// Возвращаемое значение:
//   Структура - См. ИнтеграцияВЕТИСУНФКлиентСервер.ШаблонДанныхКоэффициентаЕдиницыИзмеренияВЕТИС().
//
Функция КоэффициентЕдиницыИзмеренияВЕТИС(ЕдиницаИзмеренияВЕТИС, КэшированныеЗначения, Номенклатура = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(ЕдиницаИзмеренияВЕТИС) Тогда
		
		Если КэшированныеЗначения = Неопределено Тогда
			КэшированныеЗначения = СтруктураКэшируемыхЗначений();
		КонецЕсли;
		
		КлючКоэффициента = КлючКэшаУпаковки(Номенклатура, ЕдиницаИзмеренияВЕТИС);
		Кэш              = КэшированныеЗначения.КоэффициентыУпаковок[КлючКоэффициента];
		
		Если Кэш = Неопределено Тогда
			Результат = ИнтеграцияВЕТИСУНФВызовСервера.ДанныеЕдиницыИзмеренияВЕТИС(
									ЕдиницаИзмеренияВЕТИС,
									Номенклатура,
									КэшированныеЗначения);
		Иначе
			Результат = Кэш;
		КонецЕсли;
	Иначе
		Результат = ШаблонДанныхКоэффициентаЕдиницыИзмеренияВЕТИС();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция КлючКэшаУпаковки(Номенклатура, Упаковка) Экспорт
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		КлючНоменклатура = Строка(Номенклатура.УникальныйИдентификатор());
	Иначе
		КлючНоменклатура = "ПустоеЗначение";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Упаковка) Тогда
		КлючУпаковка = Строка(Упаковка.УникальныйИдентификатор());
	Иначе
		КлючУпаковка = "ПустоеЗначение";
	КонецЕсли;
	
	Возврат КлючНоменклатура + КлючУпаковка;
	
КонецФункции

Функция ШаблонДанныхКоэффициентаЕдиницыИзмеренияВЕТИС() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("КодОшибки",                     0);
	Результат.Вставить("Коэффициент",                   1);
	Результат.Вставить("КэшироватьДанные",              Ложь);
	Результат.Вставить("ТипИзмеряемойВеличины",         Неопределено);
	Результат.Вставить("НужноОкруглятьКоличество",      Ложь);
	Результат.Вставить("НужноОкруглятьКоличествоВЕТИС", Ложь);
	
	Возврат Результат;
	
КонецФункции

// Возвращает структуру кэшируемых значений.
//
// Возвращаемое значение:
//  Структура - структура кэшируемых значений.
//
Функция СтруктураКэшируемыхЗначений() Экспорт
	
	КэшированныеЗначения = Новый Структура;
	КэшированныеЗначения.Вставить("КоэффициентыУпаковок", Новый Соответствие);
	
	Возврат КэшированныеЗначения;
	
КонецФункции

Функция ПараметрыПересчетаКоличества() Экспорт
	
	ПараметрыПересчетаКоличества = Новый Структура("ЕдиницаИзмеренияВЕТИС, Суффикс");
	ПараметрыПересчетаКоличества.Вставить("ПересчитатьКоличествоЕдиницПоВЕТИС", Ложь);
	ПараметрыПересчетаКоличества.Вставить("ПересчитатьКоличествоЕдиницВЕТИС", Ложь);
	
	Возврат ПараметрыПересчетаКоличества;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстОшибкиПересчетаЕдиницыИзмеренияВЕТИС(КодОшибки, Номенклатура, ЕдиницаИзмеренияВЕТИС, ТипИзмеряемойВеличины, СуффиксКоличества = "")
	
	ПересчетВЕТИС        = СокрЛП(СуффиксКоличества) = "ВЕТИС";
	ТекстЕдиницыХранения = ?(ПересчетВЕТИС, НСтр("ru = 'в единицу хранения'"), НСтр("ru = 'количества (ВетИС)'"));
	
	ШаблонСообщенияНеЗаполненаЕдиницаИзмерения    = НСтр("ru = 'Не удалось выполнить пересчет %ЕдиницаХранения%, т.к. не заполнено поле ""Единица измерения"" в карточке единицы измерения ВетИС ""%ЕдиницаИзмеренияВЕТИС%""'");
	ШаблонСообщенияНеУказанТипИзмеряемойВеличины  = НСтр("ru = 'Не удалось выполнить пересчет %ЕдиницаХранения%, т.к. в карточке номенклатуры ""%Номенклатура%"" выключена возможность указания количества в единицах измерения %ТипИзмеряемойВеличины%'");
	ШаблонСообщенияНеСопоставленыЕдиницыИзмерения = НСтр("ru = 'Не удалось выполнить пересчет %ЕдиницаХранения%. Приведите в соответствие единицу измерения в карточке единицы измерения ВетИС ""%ЕдиницаИзмеренияВЕТИС%"" с единицей хранения номенклатуры ""%Номенклатура%"" или укажите %ТипКоличества% вручную'");
	
	Если КодОшибки = 1 Тогда
		ТекстСообщения = ШаблонСообщенияНеЗаполненаЕдиницаИзмерения;
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЕдиницаХранения%",       ТекстЕдиницыХранения);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЕдиницаИзмеренияВЕТИС%", Строка(ЕдиницаИзмеренияВЕТИС));
	ИначеЕсли КодОшибки = 2 Тогда
		
		ИмяТипаИзмеряемойВеличины = "";
		Если ТипИзмеряемойВеличины = ПредопределенноеЗначение("Перечисление.ТипыИзмеряемыхВеличин.Вес") Тогда
			ИмяТипаИзмеряемойВеличины = НСтр("ru = 'веса'");
		ИначеЕсли ТипИзмеряемойВеличины = ПредопределенноеЗначение("Перечисление.ТипыИзмеряемыхВеличин.Объем") Тогда
			ИмяТипаИзмеряемойВеличины = НСтр("ru = 'объема'");
		ИначеЕсли ТипИзмеряемойВеличины = ПредопределенноеЗначение("Перечисление.ТипыИзмеряемыхВеличин.Длина") Тогда
			ИмяТипаИзмеряемойВеличины = НСтр("ru = 'длины'");
		КонецЕсли;
		
		ТекстСообщения = ШаблонСообщенияНеУказанТипИзмеряемойВеличины;
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЕдиницаХранения%",       ТекстЕдиницыХранения);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номенклатура%",          Строка(Номенклатура));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТипИзмеряемойВеличины%", ИмяТипаИзмеряемойВеличины);
		
	ИначеЕсли КодОшибки = 3 Тогда
		ТекстТипаКоличества = ?(ПересчетВЕТИС, НСтр("ru = 'количество'"), НСтр("ru = 'количество (ВетИС)'"));
		
		ТекстСообщения = ШаблонСообщенияНеСопоставленыЕдиницыИзмерения;
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЕдиницаХранения%",       ТекстЕдиницыХранения);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЕдиницаИзмеренияВЕТИС%", Строка(ЕдиницаИзмеренияВЕТИС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номенклатура%",          Строка(Номенклатура));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТипКоличества%",          Строка(Номенклатура));
	Иначе
		ТекстСообщения = "";
	КонецЕсли;
	
	Возврат ТекстСообщения;
	
КонецФункции

#КонецОбласти
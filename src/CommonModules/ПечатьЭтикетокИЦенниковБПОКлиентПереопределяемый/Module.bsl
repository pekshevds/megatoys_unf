#Область ПрограммныйИнтерфейс

// Переопределяет открытие формы подбора товаров в обработке ПечатьЭтикетокИЦенников.
//
// Параметры:
//  ПараметрыОткрытия - Структура:
//   * ФормаВладелец - ФормаКлиентскогоПриложения - Форма владелец.
//   * ОбработчикЗакрытия - ОписаниеОповещения - оповещение о закрытии формы.
//   * РежимБлокировки - РежимОткрытияОкнаФормы - режим блокировки окна формы владельца.
//   * ТорговыйОбъект - ОпределяемыйТип.ТорговыйОбъектБПО - торговый объект для определения свойств товаров.
//
Процедура ОткрытьФормуПодбора(ПараметрыОткрытия) Экспорт
	ПечатьДокументовУНФКлиент.ОткрытьФормуПодбора(ПараметрыОткрытия);
КонецПроцедуры

// Переопределяет оповещение закрытие формы подбора и обработку результаты. Для работы обработки необходимо заполнить
// параметр МассивТоваровДляПечати.
//
// Параметры:
//  Результат - Структура - структура результата выполнения процедуры подбора товаров.
//  ПараметрыОперации - Структура - параметры выполнения процедуры подбора товаров.
//  МассивТоваровДляПечати - Массив Из см.ПечатьЭтикетокИЦенниковБПОКлиентСервер.ТоварДляПечати - массив товаров для заполнения.
//
Процедура ПодобратьТоварыЗавершение(Результат, ПараметрыОперации, МассивТоваровДляПечати) Экспорт
	ПечатьДокументовУНФВызовСервера.ОбработкаПодбораТоваровДляПечатиЭтикетокИЦенниковЗавершение(Результат, ПараметрыОперации, МассивТоваровДляПечати);
КонецПроцедуры

// Переопределяет оповещение закрытие формы подбора и обработку результаты. Для работы обработки необходимо заполнить
// параметр МассивТоваровДляПечати.
//
// Параметры:
//  ПараметрыОперации - Структура - параметры выполнения процедуры подбора товаров.
//  МассивТоваровДляПечати - Массив Из см.ПечатьЭтикетокИЦенниковБПОКлиентСервер.ТоварДляПечати - массив товаров для заполнения.
//
Процедура ЗаполнитьПоОтбору(ПараметрыОперации, МассивТоваровДляПечати) Экспорт
	ПечатьДокументовУНФКлиент.ЗаполнитьПоОтбору(ПараметрыОперации, МассивТоваровДляПечати);
КонецПроцедуры

// Переопределяет оповещение закрытие формы поиска по штрихкоду и обработку результаты. Для работы обработки необходимо
// заполнить параметр МассивТоваровДляПечати.
//
// Параметры:
//  Результат - Структура - структура результата выполнения процедуры подбора товаров.
//  ПараметрыОперации - Структура - параметры выполнения процедуры подбора товаров.
//  МассивТоваровДляПечати - Массив Из см.ПечатьЭтикетокИЦенниковБПОКлиентСервер.ТоварДляПечати - массив товаров для заполнения.
//
Процедура ОповещениеПоискаПоШтрихкодуЭтикетокИЦенниковБПО(Результат, ПараметрыОперации, МассивТоваровДляПечати) Экспорт
	ПечатьДокументовУНФКлиент.ОбработкаПодбораТоваровПоШтрихкодуДляПечатиЭтикетокИЦенниковЗавершение(Результат, ПараметрыОперации);
КонецПроцедуры

// Параметры команды открытия.
// 
// Параметры:
//  ПараметрыФормы - Структура - Параметры формы
//
Процедура ПараметрыКомандыОткрытия(ПараметрыФормы) Экспорт
	
	
КонецПроцедуры

// Переопределяет выгрузку данных на ТСД
// 
// Параметры:
//  Объект - ФормаКлиентскогоПриложения - форма владелец.
//  ПараметрыФормы - Структура - Параметры формы.
//
Процедура ВыгрузитьВТСД(Объект, ПараметрыФормы) Экспорт
	
	
КонецПроцедуры

// Переопределяет загрузку данных на ТСД
// 
// Параметры:
//  Объект - ФормаКлиентскогоПриложения - форма владелец.
//  ПараметрыФормы - Структура - Параметры формы.
//  ОписаниеОповещения - ОписаниеОповещения - оповещение для окончания загрузки данных.
//
Процедура ЗагрузитьИзТСД(Объект, ПараметрыФормы, ОписаниеОповещения) Экспорт
	
	
КонецПроцедуры

// Переопределяет оповещение загрузки данных из ТСД. Для работы обработки необходимо заполнить параметр МассивТоваровДляПечати.
//
// Параметры:
//  Объект - Структура - структура результата выполнения процедуры подбора товаров.
//  ПараметрыФормы - Структура - параметры выполнения процедуры подбора товаров.
//  МассивТоваровДляПечати - Массив Из см.ПечатьЭтикетокИЦенниковБПОКлиентСервер.ТоварДляПечати - массив товаров для заполнения.
//
Процедура ОповещениеЗагрузкиИзТСДЭтикетокИЦенниковБПО(Объект, ПараметрыФормы, МассивТоваровДляПечати) Экспорт
	
	
КонецПроцедуры

// Параметры выгрузки и загрузки в ТСД.
// 
// Параметры:
//  ДополнительныеПараметры - Любое - будет передано в процедуру ВыгрузитьВТСД
Процедура ПараметрыВыгрузкиИЗагрузкиВТСД(ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

// Вызывается при создании формы элемента ШаблоныЭтикетокИЦенниковБПО.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма обработки
//
Процедура ПриИзмененииВидаЦены(Форма) Экспорт
	ПечатьДокументовУНФВызовСервера.ПриИзмененииВидаЦены(Форма.Объект);
КонецПроцедуры

// Переопределяет открытие формы редактирования скд.
//
// Параметры:
//  ПараметрыОткрытия - Структура
//
Процедура РедактироватьСКД(ПараметрыОткрытия) Экспорт
	ПечатьДокументовУНФКлиент.РедактироватьСКД(ПараметрыОткрытия);
КонецПроцедуры

// Переопределяет оповещение редактирования СКД.
//
// Параметры:
//  Результат - Структура - структура результата выполнения процедуры подбора товаров.
//  ПараметрыОперации - Структура - параметры выполнения процедуры подбора товаров.
//
Процедура ОбработкаОткрытияНастройкиСКД(Результат, ПараметрыОперации) Экспорт

КонецПроцедуры

// Переопределяет оповещение редактирования СКД.
//
// Параметры:
//  ВыделенныеТовары - Массив
//  Товары - ТаблицаЗначений - товары для установки штрихкодов.
//  Штрихкоды - Соответствие
//
Процедура УстановитьШтрихкодыНоменклатуры(ВыделенныеТовары, Товары, Штрихкоды) Экспорт
	ПечатьДокументовУНФВызовСервера.УстановитьШтрихкодыНоменклатуры( ВыделенныеТовары, Товары, Штрихкоды);
КонецПроцедуры

#КонецОбласти
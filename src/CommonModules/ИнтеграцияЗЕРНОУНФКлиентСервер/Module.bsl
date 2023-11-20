#Область ПодключаемыеКомандыИСКлиентСерверПереопределяемый

Процедура КомандыФормированиеПартийЗЕРНО(Команды) Экспорт
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ОприходованиеЗапасов", НСтр("ru = 'Оприходование запасов'"));
	
КонецПроцедуры

Процедура КомандыОформлениеСДИЗЗЕРНО(Команды) Экспорт
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ПередачаТоваровМеждуОрганизациями", НСтр("ru = 'Передачу товаров между организациями'"), "ПередачаТоваровМеждуОрганизациями");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ПеремещениеЗапасов", НСтр("ru = 'Перемещение запасов'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "РасходнаяНакладная", НСтр("ru = 'Расходную накладную'"));
	
КонецПроцедуры

Процедура КомандыВнесениеСведенийОСобранномУрожаеЗЕРНО(Команды) Экспорт
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ОприходованиеЗапасов", НСтр("ru = 'Оприходование запасов'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "СборкаЗапасов",        НСтр("ru = 'Производство'"), "ИспользоватьПодсистемуПроизводство");
	
КонецПроцедуры

Процедура КомандыСписаниеПартийЗЕРНО(Команды) Экспорт
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "КомплектацияЗапасов", НСтр("ru = 'Комплектацию запасов'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "СборкаЗапасов",       НСтр("ru = 'Производство'"), "ИспользоватьПодсистемуПроизводство");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "СписаниеЗапасов",     НСтр("ru = 'Списание запасов'"));
	
КонецПроцедуры

Процедура КомандыПогашениеСДИЗЗЕРНО(Команды) Экспорт
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ПередачаТоваровМеждуОрганизациями", НСтр("ru = 'Передачу товаров между организациями'"), "ПередачаТоваровМеждуОрганизациями");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ПеремещениеЗапасов", НСтр("ru = 'Перемещение запасов'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ПриходнаяНакладная", НСтр("ru = 'Приходную накладную'"));
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды, "ПриходнаяНакладная", НСтр("ru = 'Приходную накладную'"));
	
КонецПроцедуры

Процедура КомандыФормированиеПартийПриПроизводствеЗЕРНО(Команды) Экспорт
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ОприходованиеЗапасов", НСтр("ru = 'Оприходование запасов'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "СборкаЗапасов",        НСтр("ru = 'Производство'"), "ИспользоватьПодсистемуПроизводство");
	
КонецПроцедуры

Процедура УправлениеВидимостьюКомандФормированиеПартийЗЕРНО(Форма, КомандыОбъекта) Экспорт
	
	Если ПодключаемыеКомандыИСКлиентСервер.УправлениеВидимостьюПоУмолчанию(Форма) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура УправлениеВидимостьюКомандОформлениеСДИЗЗЕРНО(Форма, КомандыОбъекта) Экспорт
	
	Если ПодключаемыеКомандыИСКлиентСервер.УправлениеВидимостьюПоУмолчанию(Форма) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура УправлениеВидимостьюКомандВнесениеСведенийОСобранномУрожаеЗЕРНО(Форма, КомандыОбъекта) Экспорт
	
	Если ПодключаемыеКомандыИСКлиентСервер.УправлениеВидимостьюПоУмолчанию(Форма) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура УправлениеВидимостьюКомандСписаниеПартийЗЕРНО(Форма, КомандыОбъекта) Экспорт
	
	Если ПодключаемыеКомандыИСКлиентСервер.УправлениеВидимостьюПоУмолчанию(Форма) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура УправлениеВидимостьюКомандПогашениеСДИЗЗЕРНО(Форма, КомандыОбъекта) Экспорт
	
	Если ПодключаемыеКомандыИСКлиентСервер.УправлениеВидимостьюПоУмолчанию(Форма) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура УправлениеВидимостьюКомандФормированиеПартийПриПроизводствеЗЕРНО(Форма, КомандыОбъекта) Экспорт
	
	Если ПодключаемыеКомандыИСКлиентСервер.УправлениеВидимостьюПоУмолчанию(Форма) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
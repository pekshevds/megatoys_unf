
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	GUIDРегиона = Параметры.GUIDРегиона;
	
	ЗагрузитьСписок(Неопределено, 1);
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	ТекущиеДанные = Элементы.Районы.ТекущиеДанные;
	
	Данные = Новый Структура;
	Данные.Вставить("Активность",    ТекущиеДанные.Активность);
	Данные.Вставить("Актуальность",  ТекущиеДанные.Актуальность);
	Данные.Вставить("GUID",          ТекущиеДанные.GUID);
	Данные.Вставить("UUID",          ТекущиеДанные.UUID);
	Данные.Вставить("Статус",        ТекущиеДанные.Статус);
	Данные.Вставить("Наименование",  ТекущиеДанные.Наименование);
	Данные.Вставить("НаименованиеПолное",  ТекущиеДанные.НаименованиеПолное);
	Данные.Вставить("ДатаСоздания",  ТекущиеДанные.ДатаСоздания);
	Данные.Вставить("ДатаИзменения", ТекущиеДанные.ДатаИзменения);
	
	Закрыть(Данные);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСписок(ПараметрыПоиска, НомерСтраницы)
	
	Результат = ИкарВЕТИСВызовСервера.СписокРайоновРегиона(GUIDРегиона, НомерСтраницы);
	
	Если ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	Районы.Очистить();
	Для Каждого СтрокаТЧ Из Результат.Список Цикл
		
		НоваяСтрока = Районы.Добавить();
		НоваяСтрока.Активность    = СтрокаТЧ.active;
		НоваяСтрока.Актуальность  = СтрокаТЧ.last;
		НоваяСтрока.GUID          = СтрокаТЧ.GUID;
		НоваяСтрока.UUID          = СтрокаТЧ.UUID;
		НоваяСтрока.Наименование  = СтрокаТЧ.Name;
		НоваяСтрока.ДатаСоздания  = СтрокаТЧ.createDate;
		НоваяСтрока.ДатаИзменения = СтрокаТЧ.updateDate;
		
		НоваяСтрока.Статус = ИнтеграцияВЕТИСПовтИсп.СтатусВерсионногоОбъекта(СтрокаТЧ.status);
		
		НоваяСтрока.Тип                = СтрокаТЧ.type;
		НоваяСтрока.НаименованиеПолное = СтрокаТЧ.view;
		
	КонецЦикла;
	
	РайоныОбщееКоличество = Результат.ОбщееКоличество;
	РайоныНомерСтраницы   = НомерСтраницы;
	РайоныПараметрыПоиска = ПараметрыПоиска;
	
	КоличествоСтраниц = РайоныОбщееКоличество / ИнтеграцияВЕТИСКлиентСервер.РазмерСтраницы();
	Если Цел(КоличествоСтраниц) <> КоличествоСтраниц Тогда
		КоличествоСтраниц = Цел(КоличествоСтраниц) + 1;
	КонецЕсли;
	Если КоличествоСтраниц = 0 Тогда
		КоличествоСтраниц = 1;
	КонецЕсли;
	
	Команды["НавигацияСтраницаТекущаяСтраница"].Заголовок =
		СтрШаблон(
			НСтр("ru = 'Страница %1 из %2'"),
			РайоныНомерСтраницы, КоличествоСтраниц);
	
	Элементы.СтраницаСледующая.Доступность  = (РайоныНомерСтраницы < КоличествоСтраниц);
	Элементы.СтраницаПредыдущая.Доступность = (РайоныНомерСтраницы > 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаПервая(Команда)
	
	ОчиститьСообщения();
	
	ЗагрузитьСписок(РайоныПараметрыПоиска, 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаПоследняя(Команда)
	
	ОчиститьСообщения();
	
	КоличествоСтраниц = РайоныОбщееКоличество / ИнтеграцияВЕТИСКлиентСервер.РазмерСтраницы();
	Если Цел(КоличествоСтраниц) <> КоличествоСтраниц Тогда
		КоличествоСтраниц = Цел(КоличествоСтраниц) + 1;
	КонецЕсли;
	Если КоличествоСтраниц = 0 Тогда
		КоличествоСтраниц = 1;
	КонецЕсли;
	
	ЗагрузитьСписок(РайоныПараметрыПоиска, КоличествоСтраниц);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаПредыдущая(Команда)
	
	ОчиститьСообщения();
	
	ЗагрузитьСписок(РайоныПараметрыПоиска, РайоныНомерСтраницы - 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаСледующая(Команда)
	
	ОчиститьСообщения();
	
	ЗагрузитьСписок(РайоныПараметрыПоиска, РайоныНомерСтраницы + 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаТекущаяСтраница(Команда)
	
	ОчиститьСообщения();
	
КонецПроцедуры

&НаКлиенте
Процедура РайоныВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Выбрать(Неопределено);
	
КонецПроцедуры

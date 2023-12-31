#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда
		
		НаборЗаписейФИО = РегистрыСведений.ФИОФизическихЛиц.СоздатьНаборЗаписей();
		
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	ФИОФизЛицСрезПоследних.Фамилия КАК Фамилия,
		                      |	ФИОФизЛицСрезПоследних.Имя КАК Имя,
		                      |	ФИОФизЛицСрезПоследних.Отчество КАК Отчество
		                      |ИЗ
		                      |	РегистрСведений.ФИОФизическихЛиц.СрезПоследних(, ФизическоеЛицо = &ФизЛицо) КАК ФИОФизЛицСрезПоследних");
							  
		Запрос.УстановитьПараметр("ФизЛицо", Ссылка);
		РезультатЗапроса = Запрос.Выполнить();
		
		// набор уже записан
		Если Не РезультатЗапроса.Пустой() Тогда
			Возврат;
		КонецЕсли;
		
		ФИО = Наименование;
		
		Фамилия  = ЗарплатаУНФВызовСервера.ВыделитьСлово(ФИО);
		Имя      = ЗарплатаУНФВызовСервера.ВыделитьСлово(ФИО);
		Отчество = ЗарплатаУНФВызовСервера.ВыделитьСлово(ФИО);

		ЗаписьНабора = НаборЗаписейФИО.Добавить();
		ЗаписьНабора.Период = ?(ЗначениеЗаполнено(ДатаРождения), ДатаРождения, '19000101');
		ЗаписьНабора.Фамилия = Фамилия;
		ЗаписьНабора.Имя = Имя;
		ЗаписьНабора.Отчество = Отчество;
		
		Если НаборЗаписейФИО.Количество() > 0 И ЗначениеЗаполнено(НаборЗаписейФИО[0].Период) Тогда
			
			НаборЗаписейФИО[0].ФизическоеЛицо = Ссылка;
			
			НаборЗаписейФИО.Отбор.ФизическоеЛицо.Использование = Истина;
			НаборЗаписейФИО.Отбор.ФизическоеЛицо.Значение = НаборЗаписейФИО[0].ФизическоеЛицо;
			НаборЗаписейФИО.Отбор.Период.Использование = Истина;
			НаборЗаписейФИО.Отбор.Период.Значение = НаборЗаписейФИО[0].Период;
			Если Не ЗначениеЗаполнено(ЗаписьНабора.Фамилия + ЗаписьНабора.Имя + ЗаписьНабора.Отчество) Тогда
				ЗаписьНабора.Фамилия = Фамилия;
				ЗаписьНабора.Имя = Имя;
				ЗаписьНабора.Отчество = Отчество;
			КонецЕсли;
			
			НаборЗаписейФИО.Записать(Истина);
			
		КонецЕсли;	
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "ФИО");
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
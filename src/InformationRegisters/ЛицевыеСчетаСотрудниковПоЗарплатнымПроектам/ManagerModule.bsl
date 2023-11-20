#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьЛицевыеСчета() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ЗарплатныйПроект КАК ЗарплатныйПроект,
		|	ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.НомерЛицевогоСчета КАК НомерЛицевогоСчета
		|ИЗ
		|	РегистрСведений.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам КАК ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам";
	
	ТекущиеДанныеРегистра = Запрос.Выполнить().Выгрузить();
	
	Если ТекущиеДанныеРегистра.Количество() > 0 Тогда
		
		ТекущиеДанныеРегистра.Индексы.Добавить("ФизическоеЛицо,ЗарплатныйПроект");
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ФизическоеЛицо КАК ФизическоеЛицо,
			|	УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ЗарплатныйПроект КАК ЗарплатныйПроект,
			|	УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.НомерЛицевогоСчета КАК НомерЛицевогоСчета
			|ИЗ
			|	РегистрСведений.УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам КАК УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам";
		
		ПрежниеДанныеРегистра = Запрос.Выполнить().Выгрузить();
		ПрежниеДанныеРегистра.Индексы.Добавить("ФизическоеЛицо,ЗарплатныйПроект");
		
	КонецЕсли;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ФизическоеЛицо КАК ФизическоеЛицо,
		|	УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Организация КАК Организация,
		|	УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ЗарплатныйПроект КАК ЗарплатныйПроект,
		|	МАКСИМУМ(УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Период) КАК Период
		|ПОМЕСТИТЬ ВТПериодыЛицевыхСчетов
		|ИЗ
		|	РегистрСведений.УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам КАК УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам
		|ГДЕ
		|	УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ЗарплатныйПроект <> ЗНАЧЕНИЕ(Справочник.ЗарплатныеПроекты.ПустаяСсылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ФизическоеЛицо,
		|	УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Организация,
		|	УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ЗарплатныйПроект
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПериодыЛицевыхСчетов.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ПериодыЛицевыхСчетов.ЗарплатныйПроект КАК ЗарплатныйПроект,
		|	ПериодыЛицевыхСчетов.Организация КАК Организация,
		|	ПериодыЛицевыхСчетов.Период КАК ДатаОткрытияЛицевогоСчета,
		|	УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.НомерЛицевогоСчета КАК НомерЛицевогоСчета,
		|	УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ДокументОснование КАК ДокументОснование
		|ИЗ
		|	ВТПериодыЛицевыхСчетов КАК ПериодыЛицевыхСчетов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам КАК УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам
		|		ПО ПериодыЛицевыхСчетов.ФизическоеЛицо = УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ФизическоеЛицо
		|			И ПериодыЛицевыхСчетов.Организация = УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Организация
		|			И ПериодыЛицевыхСчетов.ЗарплатныйПроект = УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.ЗарплатныйПроект
		|			И ПериодыЛицевыхСчетов.Период = УдалитьЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.Период
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаОткрытияЛицевогоСчета УБЫВ";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ДобавитьЗапись = Ложь;
			Если ТекущиеДанныеРегистра.Количество() = 0 Тогда
				ДобавитьЗапись = Истина;
			Иначе
				
				СтруктураПоиска = Новый Структура;
				СтруктураПоиска.Вставить("ФизическоеЛицо", Выборка.ФизическоеЛицо);
				СтруктураПоиска.Вставить("ЗарплатныйПроект", Выборка.ЗарплатныйПроект);
				
				СтрокиТекущихДанных = ТекущиеДанныеРегистра.НайтиСтроки(СтруктураПоиска);
				Если СтрокиТекущихДанных.Количество() > 0 Тогда
					
					ТекущийНомерЛицевогоСчета = СтрокиТекущихДанных[0].НомерЛицевогоСчета;
					Если Выборка.НомерЛицевогоСчета <> ТекущийНомерЛицевогоСчета Тогда
						
						СтрокиПрежнегоРегистра = ПрежниеДанныеРегистра.НайтиСтроки(СтруктураПоиска);
						Если СтрокиПрежнегоРегистра.Количество() > 0 Тогда
							
							Для Каждого СтрокаПрежнегоОбновления Из СтрокиПрежнегоРегистра Цикл
								
								Если СтрокаПрежнегоОбновления.НомерЛицевогоСчета = ТекущийНомерЛицевогоСчета Тогда
									
									ДобавитьЗапись = Истина;
									Прервать;
									
								КонецЕсли;
								
							КонецЦикла;
							
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
			Если ДобавитьЗапись Тогда
				
				НаборЗаписей = РегистрыСведений.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.ФизическоеЛицо.Установить(Выборка.ФизическоеЛицо);
				НаборЗаписей.Отбор.ЗарплатныйПроект.Установить(Выборка.ЗарплатныйПроект);
				НаборЗаписей.Отбор.Организация.Установить(Выборка.Организация);
				
				Запись = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(Запись, Выборка);
				
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
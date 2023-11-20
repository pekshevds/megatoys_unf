#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ТребуетсяУтверждениеДокумента = Документы.ОтражениеЗарплатыВБухучете.ТребуетсяУтверждениеДокументаБухгалтером(Организация);
	
	Если Не ТребуетсяУтверждениеДокумента Или ЗарплатаОтраженаВБухучете Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОценочныеОбязательстваЗарплатаКадры") Тогда
			
			МодульРезервОтпусков = ОбщегоНазначения.ОбщийМодуль("РезервОтпусков");
			НастройкиРезервовОтпусков = МодульРезервОтпусков.НастройкиРезервовОтпусков(Организация, ПериодРегистрации);
			Если НастройкиРезервовОтпусков.ФормироватьРезервБУ Тогда
				ТаблицаВыплатаЗаСчетРезерва = ВыплатаЗаСчетРезерва.Выгрузить();
				МодульРезервОтпусков.СформироватьДвиженияВыплатаОтпусковЗаСчетРезерва(Движения, Отказ, Организация, ПериодРегистрации, ТаблицаВыплатаЗаСчетРезерва);
				ДвиженияВыплатаЗаСчетРезерва = Движения.ОценочныеОбязательстваПоСотрудникам.Выгрузить();
				МодульРезервОтпусков.СформироватьДвиженияСписаниеРезерваОтпусков(Движения, Отказ, Организация, ПериодРегистрации, ДвиженияВыплатаЗаСчетРезерва);
			КонецЕсли;
			
			Модуль = ОбщегоНазначения.ОбщийМодуль("РезервыПоОплатеТруда");
			Если Модуль.ФормируютсяРезервыВОрганизации(Организация, ПериодРегистрации)
				Или Модуль.ФормируютсяРезервыВОрганизации(Организация, ДобавитьМесяц(ПериодРегистрации, -12)) Тогда
				ТаблицаВыплатаЗаСчетРезерва = ВыплатаЗаСчетРезерва.Выгрузить();
				Модуль.СформироватьДвиженияВыплатаЗаСчетРезерва(Движения, Отказ, Организация, ПериодРегистрации, ТаблицаВыплатаЗаСчетРезерва);
				ДвиженияВыплатаЗаСчетРезерва = Движения.ОценочныеОбязательстваПоСотрудникам.Выгрузить();
				Модуль.СформироватьДвиженияСписаниеРезерва(Движения, Отказ, Организация, ПериодРегистрации, ДвиженияВыплатаЗаСчетРезерва);
			КонецЕсли;
			
		КонецЕсли;
		
		ТаблицаНачисленныйНДФЛ = НачисленныйНДФЛ.Выгрузить();
		ОтражениеЗарплатыВБухучете.ЗаполнитьРегистрациюВНалоговомОрганеВКоллекцииСтрок(Организация, ПериодРегистрации, ТаблицаНачисленныйНДФЛ);
		
		ДанныеДляОтражения = Новый Структура;
		ДанныеДляОтражения.Вставить("НачисленнаяЗарплатаИВзносы", НачисленнаяЗарплатаИВзносы.Выгрузить());
		ДанныеДляОтражения.Вставить("НачисленныйНДФЛ", ТаблицаНачисленныйНДФЛ);
		ДанныеДляОтражения.Вставить("УдержаннаяЗарплата", УдержаннаяЗарплата.Выгрузить());
		ОтражениеЗарплатыВБухучетеПереопределяемый.СформироватьДвижения(Движения, Отказ, Организация, ПериодРегистрации, ДанныеДляОтражения);
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.КонфигурацииЗарплатаКадрыРасширенная.ОтражениеРасчетовЗарплатыВБухучете") Тогда
			ДанныеДляОтражения.Вставить("ВыплатаЗаСчетРезерва", ВыплатаЗаСчетРезерва.Выгрузить());
			Модуль = ОбщегоНазначения.ОбщийМодуль("ОтражениеРасчетовЗарплатыВБухучете");
			Модуль.СформироватьДвижения(Движения, Отказ, Организация, ПериодРегистрации, ДанныеДляОтражения);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		ЗарплатаОтраженаВБухучете = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗарплатаОтраженаВБухучете = Ложь;
	Бухгалтер = Справочники.Пользователи.ПустаяСсылка();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОценочныеОбязательстваЗарплатаКадры") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("РезервыПоОплатеТруда");
		Модуль.ОбработкаПроверкиЗаполненияОтраженияВУчете(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти


#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
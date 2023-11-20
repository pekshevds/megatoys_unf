#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Процедура запускается на выполнение из формы помощника содания нового подключения к Ветис.API.
// Выполнение происходит в фоновом задании.
//
// Параметры:
//  СтруктураПараметров - Структура - Параметры выполнения процедуры.
//  -  НастройкаПодключения - Структура - Данные для подключения к Ветис.API
//  -  АдресХранилищаОбмена - Строка    - Адрес хранилища, созданного в форме помощника подключения для выполнения заявок Ветис.API
//  АдресВоВременномХранилище - Строка - Адрес хранилища формы помощника, в которое будет помещен результат выполнения процедуры.
//
Процедура ПолучитьСведенияХозяйствующегоСубъекта(СтруктураПараметров, АдресВоВременномХранилище) Экспорт
	
	СтруктураДанных = Новый Структура();
	СтруктураДанных.Вставить("ХозяйствующийСубъект", ИнтеграцияВЕТИСКлиентСервер.СтруктураДанныеХозяйствующегоСубъекта());
	СтруктураДанных.Вставить("Предприятия",          Новый Массив());
	
	Отказ = Ложь;
	
	Если ТребуетсяЗагрузкаКлассификатораЕдиницИзмерения() Тогда
		ПолучитьЗаписатьЕдиницыИзмерения(СтруктураПараметров, Отказ);
	КонецЕсли;
	
	Если Не Отказ Тогда
		ПроверитьОбновитьКлассификаторы(Отказ);
	КонецЕсли;
	
	Если Не Отказ Тогда
		ПолучитьХозяйствующийСубъект(СтруктураПараметров, СтруктураДанных, Отказ);
	КонецЕсли;
	
	Если Не Отказ Тогда
		ПолучитьПредприятия(СтруктураПараметров, СтруктураДанных, Отказ);
	КонецЕсли;
		
	Если Не Отказ Тогда
		ЗаписатьСведенияХозяйствующегоСубъекта(СтруктураДанных, Отказ);
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(СтруктураДанных, АдресВоВременномХранилище);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьОбновитьКлассификаторы(Отказ)
	
	Если РаботаВМоделиСервисаПовтИсп.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИдентификаторыКлассификаторов    = ИнтеграцияВЕТИС.ИдентификаторыКлассификаторов();
	ВсеИдентификаторыКлассификаторов = Новый Массив();
	ИдентификаторыДляЗагрузки        = Новый Массив();
	ЗаголовокОшибки                  = НСтр("ru='Не удалось загрузить классификаторы ВетИС'");
	
	Для Каждого КлючИЗначение Из ИдентификаторыКлассификаторов Цикл
		ИдентификаторКлассификатора = КлючИЗначение.Ключ;
		ВсеИдентификаторыКлассификаторов.Добавить(ИдентификаторКлассификатора);
	КонецЦикла;
	
	ДоступныеОбновления = РаботаСКлассификаторами.ДоступныеОбновленияКлассификаторов(ВсеИдентификаторыКлассификаторов);
	
	Если ЗначениеЗаполнено(ДоступныеОбновления.КодОшибки)
		И ДоступныеОбновления.КодОшибки <> "ОбновлениеНеТребуется" Тогда
		ТекстОшибки = ЗаголовокОшибки;
		Если ПустаяСтрока(ЗаголовокОшибки) Тогда
			ТекстОшибки = ТекстОшибки + ".";
		Иначе
			ТекстОшибки = ТекстОшибки + " " + НСтр("ru='по причине:'") + Символы.ПС + ДоступныеОбновления.СообщениеОбОшибке;
		КонецЕсли;
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	Если ДоступныеОбновления.ДоступныеВерсии.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из ДоступныеОбновления.ДоступныеВерсии Цикл
		ИдентификаторыДляЗагрузки.Добавить(СтрокаТаблицы.Идентификатор);
		РаботаСКлассификаторами.ВерсияКлассификатора(СтрокаТаблицы.Идентификатор);
	КонецЦикла;
	
	КлассификаторыОбновлены = Истина;
	
	НачатьТранзакцию();
	
	Попытка
		РезультатОбновления = РаботаСКлассификаторами.ОбновитьКлассификаторы(ИдентификаторыДляЗагрузки);
		Если ЗначениеЗаполнено(РезультатОбновления.КодОшибки)
			И РезультатОбновления.КодОшибки <> "ОбновлениеНеТребуется" Тогда
			ТекстОшибки = ЗаголовокОшибки;
			Если ПустаяСтрока(ЗаголовокОшибки) Тогда
				ТекстОшибки = ТекстОшибки + ".";
			Иначе
				ТекстОшибки = ТекстОшибки + " " + НСтр("ru='по причине:'") + Символы.ПС + РезультатОбновления.СообщениеОбОшибке;
			КонецЕсли;
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
		КонецЕсли;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		КлассификаторыОбновлены = Ложь;
		ТекстОшибки = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		СообщитьОбОшибке(ЗаголовокОшибки, ТекстОшибки);
	КонецПопытки;
	
	Если КлассификаторыОбновлены Тогда
		ДлительныеОперации.СообщитьПрогресс(,"ВыполненоЗаполнениеКлассификаторов");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолучитьХозяйствующийСубъект(СтруктураПараметров, СтруктураДанных, Отказ)
	
	ЗаголовокОшибки = НСтр("ru='Не удалось получить сведения о хозяйствующем субъекте'");
	ОкончаниеОшибки = СообщениеПроверьтеПравильностьЗаполненияПолей();
	
	НастройкаПодключения = СтруктураПараметров.НастройкаПодключения;
	
	Попытка
		РезультатПолучения = ЦерберВЕТИСВызовСервера.ХозяйствующийСубъектПоGUID(НастройкаПодключения.Идентификатор, Истина, НастройкаПодключения);
		
		Если ЗначениеЗаполнено(РезультатПолучения.ТекстОшибки) Тогда
			Отказ = Истина;
			ТекстОшибки = РезультатПолучения.ТекстОшибки;
		Иначе
			ЗаполнитьЗначенияСвойств(СтруктураДанных.ХозяйствующийСубъект, РезультатПолучения.Элемент);
			СтруктураДанных.ХозяйствующийСубъект.СоответствуетОрганизации = СтруктураПараметров.ЭтоСобственнаяОрганизация;
		КонецЕсли;
	Исключение
		Отказ = Истина;
		ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	Если Отказ Тогда
		СообщитьОбОшибке(ЗаголовокОшибки, ТекстОшибки, ОкончаниеОшибки);
	Иначе
		ДлительныеОперации.СообщитьПрогресс(,"ПолученХозяйствующийСубъект");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолучитьПредприятия(СтруктураПараметров, СтруктураДанных, Отказ)
	
	ЗаголовокОшибки = НСтр("ru='Не удалось получить сведения о предприятиях (поднадзорных объектах) хозяйствующего субъекта'");
	ОкончаниеОшибки = СообщениеПроверьтеПравильностьЗаполненияПолей();
	
	НастройкаПодключения = СтруктураПараметров.НастройкаПодключения;
	
	Попытка
		РезультатПолучения = ЦерберВЕТИСВызовСервера.СписокПредприятийХозяйствующегоСубъекта(НастройкаПодключения.Идентификатор,, НастройкаПодключения);
		
		Если ЗначениеЗаполнено(РезультатПолучения.ТекстОшибки) Тогда
			Отказ = Истина;
			ТекстОшибки = РезультатПолучения.ТекстОшибки;
		Иначе
			Для Каждого ПредприятиеЭлемент Из РезультатПолучения.Список Цикл
				ДанныеПредприятия = ИнтеграцияВЕТИС.ДанныеПредприятия(ПредприятиеЭлемент.enterprise);
				ДанныеПредприятия.GLN = ПредприятиеЭлемент.globalID;
				СтруктураДанных.Предприятия.Добавить(ДанныеПредприятия);
			КонецЦикла;
		КонецЕсли;
	Исключение
		Отказ = Истина;
		ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	Если Отказ Тогда
		СообщитьОбОшибке(ЗаголовокОшибки, ТекстОшибки, ОкончаниеОшибки);
	Иначе
		ДлительныеОперации.СообщитьПрогресс(,"ПолученыПредприятияХозяйствующегоСубъекта");
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьСведенияХозяйствующегоСубъекта(СтруктураДанных, Отказ)
	
	ЗаголовокОшибки = "";
	
	НачатьТранзакцию();
	
	Попытка
		ЗаписатьПредприятия(СтруктураДанных, ЗаголовокОшибки);
		ЗаписатьХозяйствующийСубъект(СтруктураДанных, ЗаголовокОшибки);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		СообщитьОбОшибке(ЗаголовокОшибки, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		СтруктураДанных.ХозяйствующийСубъект.Ссылка = Неопределено;
		Отказ = Истина;
	КонецПопытки; 
	
КонецПроцедуры

Процедура ЗаписатьПредприятия(СтруктураДанных, ЗаголовокОшибки)
	
	ЗаголовокОшибки = НСтр("ru='Не удалось записать сведения о предприятиях (поднадзорных объектах) хозяйствующего субъекта'");
	
	Для Каждого ДанныеПредприятия Из СтруктураДанных.Предприятия Цикл
		ДанныеПредприятия.Ссылка = ИнтеграцияВЕТИС.ЗагрузитьПредприятие(ДанныеПредприятия);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаписатьХозяйствующийСубъект(СтруктураДанных, ЗаголовокОшибки)
	
	ЗаголовокОшибки = НСтр("ru='Не удалось записать сведения о хозяйствующем субъекте'");
	
	ПредприятияGLN = ИнтеграцияВЕТИС.ТаблицаПредприятийGLN();
	
	Для Каждого ДанныеПредприятия Из СтруктураДанных.Предприятия Цикл
		НоваяСтрока = ПредприятияGLN.Добавить();
		НоваяСтрока.Предприятие = ДанныеПредприятия.Ссылка;
		Если ТипЗнч(ДанныеПредприятия.GLN) = Тип("Массив") Тогда
			Если ДанныеПредприятия.GLN.Количество() > 0 Тогда
				НоваяСтрока.GLN = ДанныеПредприятия.GLN[0];
			КонецЕсли;
		Иначе
			НоваяСтрока.GLN = ДанныеПредприятия.GLN;
		КонецЕсли;
	КонецЦикла;
	
	ХозяйствующийСубъектСсылка = ИнтеграцияВЕТИС.ЗагрузитьХозяйствующийСубъект(СтруктураДанных.ХозяйствующийСубъект,, ПредприятияGLN);
	СтруктураДанных.ХозяйствующийСубъект.Ссылка = ХозяйствующийСубъектСсылка;
	
КонецПроцедуры

Функция ТребуетсяЗагрузкаКлассификатораЕдиницИзмерения()
	
	Запрос = Новый Запрос();
	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЕдиницыИзмеренияВЕТИС.Идентификатор КАК Идентификатор
	|ИЗ
	|	Справочник.ЕдиницыИзмеренияВЕТИС КАК ЕдиницыИзмеренияВЕТИС
	|ГДЕ
	|	НЕ ЕдиницыИзмеренияВЕТИС.ПометкаУдаления
	|";
	Результат = Запрос.Выполнить();
	
	Возврат Результат.Пустой();
	
КонецФункции

Процедура ПолучитьЗаписатьЕдиницыИзмерения(СтруктураПараметров, Отказ)
	
	ЗаголовокОшибки = НСтр("ru='Не удалось получить данные классификатора единиц измерения'");
	ОкончаниеОшибки = СообщениеПроверьтеПравильностьЗаполненияПолей();
	
	НастройкаПодключения = СтруктураПараметров.НастройкаПодключения;
	
	НачатьТранзакцию();
	
	Попытка
		
		РезультатПолучения = ПрочиеКлассификаторыВЕТИСВызовСервера.СписокЕдиницИзмерения(, НастройкаПодключения);
		
		Если ЗначениеЗаполнено(РезультатПолучения.ТекстОшибки) Тогда
			
			Отказ = Истина;
			ТекстОшибки = РезультатПолучения.ТекстОшибки;
			СообщитьОбОшибке(ЗаголовокОшибки, ТекстОшибки, ОкончаниеОшибки);
			
		Иначе
			
			ЭлементыЕдиницИзмерения     = РезультатПолучения.Список;
			ЗагруженныеЕдиницыИзмерения = Новый Массив();
			
			Для НомерПовтора = 1 По 100 Цикл
				ИндексЭлемента = 0;
				Пока ИндексЭлемента < ЭлементыЕдиницИзмерения.Количество() Цикл
					ЭлементДанных = ЭлементыЕдиницИзмерения[ИндексЭлемента];
					Если (ЭлементДанных.commonUnitGuid = ЭлементДанных.guid)
					 ИЛИ (ЗагруженныеЕдиницыИзмерения.Найти(ЭлементДанных.commonUnitGuid) <> Неопределено) Тогда
						ИнтеграцияВЕТИС.ЗагрузитьЕдиницуИзмерения(ЭлементДанных);
						ЗагруженныеЕдиницыИзмерения.Добавить(ЭлементДанных.guid);
						ЭлементыЕдиницИзмерения.Удалить(ИндексЭлемента);
					Иначе
						ИндексЭлемента = ИндексЭлемента + 1;
					КонецЕсли;
				КонецЦикла;
				Если ЭлементыЕдиницИзмерения.Количество() = 0 Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		Отказ = Истина;
		ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		СообщитьОбОшибке(ЗаголовокОшибки, ТекстОшибки, ОкончаниеОшибки);
		
	КонецПопытки;
	
КонецПроцедуры

Процедура СообщитьОбОшибке(Заголовок, ОписаниеОшибки, Заключение = "")
	
	ТекстОшибки = Заголовок;
	
	Если НЕ ПустаяСтрока(ОписаниеОшибки) Тогда
		ТекстОшибки = ТекстОшибки + " " + НСтр("ru='по причине:'") + Символы.ПС + ОписаниеОшибки;
	Иначе
		ТекстОшибки = ТекстОшибки + ".";
	КонецЕсли;
	
	КодЯзыка = Метаданные.ОсновнойЯзык.КодЯзыка;
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Фоновая загрузка сведений хозяйствующего субъекта'", КодЯзыка),
	                         УровеньЖурналаРегистрации.Ошибка, , , ТекстОшибки);
	
	Если НЕ ПустаяСтрока(Заключение) Тогда
		ТекстОшибки = ТекстОшибки + Символы.ПС + Заключение;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	
КонецПроцедуры

Функция СообщениеПроверьтеПравильностьЗаполненияПолей()
	
	МассивСтрок = Новый Массив();
	МассивСтрок.Добавить(НСтр("ru='Проверьте правильность заполнения полей ""Login"", ""Password"" и ""IssuerID"".'"));
	МассивСтрок.Добавить(НСтр("ru='Убедитесь в правильной установке флажка ""Тестовый контур"" в настройках интеграции с ВетИС.'"));
	
	Возврат СтрСоединить(МассивСтрок, " ");
	
КонецФункции

#КонецОбласти

#КонецЕсли
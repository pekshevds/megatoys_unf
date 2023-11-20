////////////////////////////////////////////////////////////////////////////////
// Ведомости на выплату зарплаты.
// Клиентские процедуры и функции.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиСобытийФормы

Процедура ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ИмяСобытия = ВзаиморасчетыССотрудникамиКлиент.ИмяСобытияИзмененияОплатыВедомости() Тогда
		Форма.УстановитьДоступностьЭлементов();
		Форма.УстановитьПредставлениеОплаты();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицФормы

Процедура СоставВыбор(Форма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка) Экспорт

	ТекущиеДанные = Форма.Элементы.Состав.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.ИдентификаторСтроки) Тогда
		Если СтрНачинаетсяС(Поле.Имя, "СоставНДФЛ") Тогда
			Форма.РедактироватьНДФЛСтроки(ТекущиеДанные);
			СтандартнаяОбработка = Ложь;
		ИначеЕсли Поле.ГиперссылкаЯчейки Или Поле.Вид = ВидПоляФормы.ПолеНадписи Или Поле.ТолькоПросмотр Тогда
			Форма.РедактироватьЗарплатуСтроки(ТекущиеДанные);
			СтандартнаяОбработка = Ложь;
		КонецЕсли	
	КонецЕсли;
	
КонецПроцедуры

Процедура СоставПередУдалением(Форма, Элемент, Отказ) Экспорт
	
	ИдентификаторыСтрок = Новый Массив;
	
	Для Каждого ВыделеннаяСтрока Из Элемент.ВыделенныеСтроки Цикл
		
		Строка = Форма.Объект.Состав.НайтиПоИдентификатору(ВыделеннаяСтрока);
		
		Если Строка <> Неопределено Тогда
			ИдентификаторыСтрок.Добавить(Строка.ИдентификаторСтроки);
		КонецЕсли	
		
	КонецЦикла;	
	
	Форма.ИдентификаторыСтрок = Новый ФиксированныйМассив(ИдентификаторыСтрок);
	
КонецПроцедуры

Процедура СоставКВыплатеОткрытие(Форма, Элемент, СтандартнаяОбработка) Экспорт
	СтандартнаяОбработка = Ложь;
	Форма.РедактироватьЗарплатуСтроки(Форма.Элементы.Состав.ТекущиеДанные);	
КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиСобытийКомандФормы

Процедура Заполнить(Форма) Экспорт
	
	ОчиститьСообщения();
	Форма.ЗаполнитьНаСервере()
	
КонецПроцедуры	

Процедура Подобрать(Форма) Экспорт
	
	ПараметрыОткрытияФормы = Новый Структура;
	
	Если ЗначениеЗаполнено(Форма.Объект.Подразделение) Тогда
		Отбор = Новый Структура("Подразделение", Форма.Объект.Подразделение);
		ПараметрыОткрытияФормы.Вставить("Отбор", Отбор);
	КонецЕсли;
		
	КадровыйУчетКлиент.ПодобратьФизическихЛицОрганизации(
		Форма.Элементы.Состав, 
		Форма.Объект.Организация, 
		Форма.АдресСпискаПодобранныхСотрудников(),,
		ПараметрыОткрытияФормы);
	
КонецПроцедуры

Процедура ОбновитьНДФЛ(Форма) Экспорт
	
	Если Форма.Элементы.Состав.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат
	КонецЕсли;	
	
	ТекущаяСтрока = Форма.Элементы.Состав.ТекущаяСтрока;
	
	Форма.ОбновитьНДФЛНаСервере(Новый ФиксированныйМассив(Форма.Элементы.Состав.ВыделенныеСтроки));
	
	Форма.Элементы.Состав.ТекущаяСтрока = ТекущаяСтрока;
	
КонецПроцедуры

Процедура ОплатаПоказать(Форма, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если Форма.ОплатыСписок.Количество() = 0 Тогда
		Возврат
	ИначеЕсли Форма.ОплатыСписок.Количество() = 1 Тогда
		ПоказатьЗначение(, Форма.ОплатыСписок[0].Значение)
	Иначе
		Оповещение = Новый ОписаниеОповещения("ОплатаПоказатьОповещение", ЭтотОбъект, Форма);
		Форма.ПоказатьВыборИзМеню(Оповещение, Форма.ОплатыСписок, Элемент);
	КонецЕсли	
		
КонецПроцедуры

Процедура ОплатаПоказатьОповещение(ВыбранныйЭлемент, Форма) Экспорт
	Если ВыбранныйЭлемент <> Неопределено Тогда
		ПоказатьЗначение(, ВыбранныйЭлемент.Значение)
	КонецЕсли	
КонецПроцедуры

#КонецОбласти

Процедура РедактироватьЗарплатуСтроки(Форма, ДанныеСтроки) Экспорт
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	
	ПараметрыОткрытия.Вставить("Организация",
	                           ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка"));
	ПараметрыОткрытия.Вставить("Подразделение",			
	                           ПредопределенноеЗначение("Справочник.ПодразделенияОрганизаций.ПустаяСсылка"));
	ПараметрыОткрытия.Вставить("ПериодРегистрации",		
	                           Дата(1,1,1));
	ПараметрыОткрытия.Вставить("СтатьяФинансирования",	
	                           ПредопределенноеЗначение("Справочник.СтатьиФинансированияЗарплата.ПустаяСсылка"));
	ПараметрыОткрытия.Вставить("СтатьяРасходов",		
	                           ПредопределенноеЗначение("Справочник.СтатьиРасходовЗарплата.ПустаяСсылка"));
	ПараметрыОткрытия.Вставить("ВидДоходаИсполнительногоПроизводства",		
	                           Неопределено);
							   
	ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, Форма.Объект);
	
	ПараметрыОткрытия.Вставить("ДатаВыплаты", ВедомостьНаВыплатуЗарплатыКлиентСервер.ДатаВыплаты(Форма.Объект));
	
	ПараметрыОткрытия.Вставить("ИдентификаторСтроки", ДанныеСтроки.ИдентификаторСтроки);
	ПараметрыОткрытия.Вставить("ФизическоеЛицо",      ДанныеСтроки.ФизическоеЛицо);
	ПараметрыОткрытия.Вставить("АдресВХранилищеЗарплатыПоСтроке", 
	                           Форма.АдресВХранилищеЗарплатыПоСтроке(ДанныеСтроки.ИдентификаторСтроки));
	
	ПараметрыОткрытия.Вставить("ТолькоПросмотр", Форма.ТолькоПросмотр);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	Оповещение = Новый ОписаниеОповещения("РедактироватьЗарплатуСтрокиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму(
		"ОбщаяФорма.РедактированиеЗарплатыСтрокиВедомости", 
		ПараметрыОткрытия, Форма, , , , 
		Оповещение, 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура РедактироватьЗарплатуСтрокиЗавершение(РезультатыРедактирования, ДополнительныеПараметры) Экспорт
	
	Если РезультатыРедактирования <> Неопределено И РезультатыРедактирования.Модифицированность Тогда
		ДополнительныеПараметры.Форма.РедактироватьЗарплатуСтрокиЗавершениеНаСервере(РезультатыРедактирования)
	КонецЕсли;
	
КонецПроцедуры

Процедура РедактироватьНДФЛСтроки(Форма, ДанныеСтроки) Экспорт
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	
	ПараметрыОткрытия.Вставить("Организация",			
	                           ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка"));
	ПараметрыОткрытия.Вставить("Подразделение",			
	                           ПредопределенноеЗначение("Справочник.ПодразделенияОрганизаций.ПустаяСсылка"));
	ПараметрыОткрытия.Вставить("ПериодРегистрации",		
	                           Дата(1,1,1));
							   
	ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, Форма.Объект);
	
	ПараметрыОткрытия.Вставить("ДатаВыплаты", ВедомостьНаВыплатуЗарплатыКлиентСервер.ДатаВыплаты(Форма.Объект));
	
	ПараметрыОткрытия.Вставить("ИдентификаторСтроки", ДанныеСтроки.ИдентификаторСтроки);
	ПараметрыОткрытия.Вставить("ФизическоеЛицо",      ДанныеСтроки.ФизическоеЛицо);
	ПараметрыОткрытия.Вставить("АдресВХранилищеНДФЛПоСтроке", 
	                           Форма.АдресВХранилищеНДФЛПоСтроке(ДанныеСтроки.ИдентификаторСтроки));
	
	ПараметрыОткрытия.Вставить("ТолькоПросмотр", Форма.ТолькоПросмотр);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	Оповещение = Новый ОписаниеОповещения("РедактироватьНДФЛСтрокиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму(
		"ОбщаяФорма.РедактированиеНДФЛСтрокиВедомости", 
		ПараметрыОткрытия, 
		Форма, , , , 
		Оповещение, 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура РедактироватьНДФЛСтрокиЗавершение(РезультатыРедактирования, ДополнительныеПараметры) Экспорт
	
	Если РезультатыРедактирования <> Неопределено И РезультатыРедактирования.Модифицированность Тогда
		ДополнительныеПараметры.Форма.РедактироватьНДФЛСтрокиЗавершениеНаСервере(РезультатыРедактирования)
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Объект.Ссылка.Пустая() Тогда
		
		Если ЗначениеЗаполнено(Параметры.Сотрудник) Тогда
			Объект.Сотрудник = Параметры.Сотрудник;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Параметры.Организация) Тогда
			Объект.Организация = Параметры.Организация;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Объект.Сотрудник) И ЗначениеЗаполнено(Объект.Организация) Тогда
			СправкиПоНДФЛ.ЗаполнитьСправку2НДФЛПоСотруднику(Объект);
		КонецЕсли;
		
		ТекущаяДатаСеанса = ТекущаяДатаСеанса();
		Если Не ЗначениеЗаполнено(Объект.НалоговыйПериод) Тогда
			Если Месяц(ТекущаяДатаСеанса)> 1 Тогда
				Год = Год(ТекущаяДатаСеанса);
			Иначе
				Год = Год(ТекущаяДатаСеанса)-1;
			КонецЕсли;
			Объект.НалоговыйПериод = Год;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	СотрудникПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	Если ЗначениеЗаполнено(Объект.Сотрудник) И ЗначениеЗаполнено(Объект.Организация) Тогда
		ЗаполнитьНаСервере();
	Иначе
		Если НЕ ЗначениеЗаполнено(Объект.Сотрудник) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Не заполнен сотрудник'"));
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Не заполнена организация'"));
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		Объект.РегистрацияВНалоговомОргане = РегламентированнаяОтчетностьУСН.ПолучитьРегистрациюВИФНС(Объект.Организация);
		Объект.Телефон = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(Объект.Организация,
			Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации, , ТекущаяДатаСеанса());
		Объект.КодНалоговогоОрганаПолучателя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Организация, "КодНалоговогоОрганаПолучателя");
		ЗаполнитьЗначенияСвойств(Объект, СправкиПоНДФЛ.ДанныеПодписывающихЛиц(Объект.Организация, Объект.Дата));
	Иначе
		Объект.РегистрацияВНалоговомОргане = Неопределено;
		Объект.Телефон = "";
		Объект.СправкуПодписал = "";
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СотрудникПриИзмененииНаСервере()
	
	ТаблицаСотрудников = Новый ТаблицаЗначений;
	ТаблицаСотрудников.Колонки.Добавить("Сотрудник",Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ТаблицаСотрудников.Колонки.Добавить("Ставка",Новый ОписаниеТипов("ПеречислениеСсылка.НДФЛСтавкиУНФ"));
	СтрокаСотрудника = ТаблицаСотрудников.Добавить();
	СтрокаСотрудника.Сотрудник = Объект.Сотрудник;
	СтрокаСотрудника.Ставка = Перечисления.НДФЛСтавкиУНФ.Ставка13;
	ДанныеСотрудника = СправкиПоНДФЛ.ДанныеСотрудников(ТаблицаСотрудников, Объект.Дата, Объект.НалоговыйПериод);
	Если ДанныеСотрудника.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(Объект,	ДанныеСотрудника[0]);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	докСправка = ДанныеФормыВЗначение(Объект, Тип("ДокументОбъект.СправкаНДФЛУНФ"));
	СправкиПоНДФЛ.ЗаполнитьСправку2НДФЛПоСотруднику(докСправка);
	ЗначениеВДанныеФормы(докСправка, Объект);
	Модифицированность = Истина;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
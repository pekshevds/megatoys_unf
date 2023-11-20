
#Область ОписаниеПеременных

&НаКлиенте
Перем ОтветПередЗакрытием;

#КонецОбласти

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ИсточникЗаписи") Тогда
		ИсточникЗаписи = Параметры.ИсточникЗаписи;
	КонецЕсли;
	Если Параметры.Свойство("НовыйСайт") Тогда
		Элементы.НастройкаИнтеграции.Видимость =  НЕ Параметры.НовыйСайт;
	Иначе
		Элементы.НастройкаИнтеграции.Видимость = (ИсточникЗаписи = Перечисления.ЗаписьНаУслугиИсточник.Сайт);
	КонецЕсли;
	Если Параметры.Свойство("НастройкаИнтеграции") Тогда
		НастройкаИнтеграции = Параметры.НастройкаИнтеграции;
	КонецЕсли;
	Если Параметры.Свойство("Услуга") Тогда
		Услуга = Параметры.Услуга;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НастройкиЗаписьНаУслугиИнтернетМагазина.ИсточникЗаписи КАК ИсточникЗаписи,
		|	НастройкиЗаписьНаУслугиИнтернетМагазина.Услуга КАК Услуга,
		|	НастройкиЗаписьНаУслугиИнтернетМагазина.Ресурс КАК Ресурс,
		|	НастройкиЗаписьНаУслугиИнтернетМагазина.НастройкаИнтеграции КАК НастройкаИнтеграции,
		|	НастройкиЗаписьНаУслугиИнтернетМагазина.Длительность КАК Длительность
		|ИЗ
		|	РегистрСведений.НастройкиЗаписьНаУслугиИнтернетМагазина КАК НастройкиЗаписьНаУслугиИнтернетМагазина
		|ГДЕ
		|	НастройкиЗаписьНаУслугиИнтернетМагазина.Услуга = &Услуга
		|	И НастройкиЗаписьНаУслугиИнтернетМагазина.ИсточникЗаписи = &ИсточникЗаписи
		|	И НастройкиЗаписьНаУслугиИнтернетМагазина.Ресурс.Ссылка <> ЗНАЧЕНИЕ(Справочник.КлючевыеРесурсы.ПустаяСсылка)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НастройкиЗаписьНаУслугиИнтернетМагазина.Ресурс.Наименование";
		
		Если Параметры.Свойство("НастройкаИнтеграции") Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, 
				"// И НастройкиЗаписьНаУслугиИнтернетМагазина.НастройкаИнтеграции = &НастройкаИнтеграции", 
				" И НастройкиЗаписьНаУслугиИнтернетМагазина.НастройкаИнтеграции = &НастройкаИнтеграции");
			Запрос.УстановитьПараметр("НастройкаИнтеграции", НастройкаИнтеграции);
		КонецЕсли;

		Запрос.УстановитьПараметр("Услуга", Параметры.Услуга);
		Запрос.УстановитьПараметр("ИсточникЗаписи", ИсточникЗаписи);
		Результат = Запрос.Выполнить().Выгрузить();
		
		Если Результат.Количество() > 0 Тогда
			Ресурсы.ЗагрузитьЗначения(Результат.ВыгрузитьКолонку("Ресурс"));
			Длительность = Результат[0].Длительность;
			НастройкаИнтеграции = Результат[0].НастройкаИнтеграции;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	НЗ = РегистрыСведений.НастройкиЗаписьНаУслугиИнтернетМагазина.СоздатьНаборЗаписей();
	НЗ.Отбор.Услуга.Установить(Услуга);
	НЗ.Отбор.ИсточникЗаписи.Установить(ИсточникЗаписи);
	НЗ.Отбор.НастройкаИнтеграции.Установить(НастройкаИнтеграции);
	
	РесурсыМассив = ОбщегоНазначенияКлиентСервер.СвернутьМассив(Ресурсы.ВыгрузитьЗначения());
	
	Для каждого ресурс Из РесурсыМассив Цикл
		Если НЕ ЗначениеЗаполнено(ресурс) Тогда
			Продолжить;
		КонецЕсли;
		
		НовСтр = НЗ.Добавить();
		НовСтр.Услуга = Услуга;
		НовСтр.Длительность = Длительность;
		НовСтр.Ресурс = ресурс;
		НовСтр.ИсточникЗаписи = ИсточникЗаписи;
		НовСтр.НастройкаИнтеграции = НастройкаИнтеграции;
		
	КонецЦикла;
	
	НЗ.Записать(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Ок(Команда)
	
	Если НЕ ДлительностьЗаполнена() Тогда
		Возврат;
	КонецЕсли; 
	Если НЕ РесурсыЗаполнены() Тогда
		Возврат;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Услуга) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
		НСтр("ru = 'Услуга не выбрана'"));
		
		Возврат;
	КонецЕсли;
		
	ОтветПередЗакрытием = Истина;
	СохранитьНастройки();
	Закрыть(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ОтветПередЗакрытием = Ложь;
	Закрыть(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НЕ Модифицированность Тогда
		Возврат;
	КонецЕсли;
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ОтветПередЗакрытием = Неопределено Тогда
		Отказ = Истина;
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОповещениеОЗакрытии, "Сохранить изменения?", РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ДлительностьЗаполнена()
	
	Если Длительность < 10 Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
		НСтр("ru = 'Длительность услуги не должна быть меньше 10 минут, и должна быть кратной шагу планирования для ресурса (сотрудника, оборудования и т.д.). 
		|Например, шаг планирования - 30, длительность - 60: на услугу длительностью 60 минут можно записаться каждые 30 минут.'"));
		
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Функция РесурсыЗаполнены()
	
	СписокЗаполнен = Ложь;
	Для каждого ресурс Из Ресурсы Цикл
		Если ресурс.Значение <> ПредопределенноеЗначение("Справочник.КлючевыеРесурсы.ПустаяСсылка") Тогда
			СписокЗаполнен = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ СписокЗаполнен ИЛИ Ресурсы.Количество() = 0 Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
		НСтр("ru = 'Заполните ресурсы (сотрудников, оборудование и т.д.), которые задействованы в оказании услуги.'"));
		
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если НЕ ДлительностьЗаполнена() Тогда
			Возврат;
		КонецЕсли;
		Если НЕ РесурсыЗаполнены() Тогда
			Возврат;
		КонецЕсли;
		
		ОтветПередЗакрытием = Истина;
		СохранитьНастройки();
		РезультатЗакрытия = Истина;
	Иначе
		ОтветПередЗакрытием = Ложь;
		РезультатЗакрытия = Ложь;
	КонецЕсли;
	
	Закрыть(РезультатЗакрытия);
	
КонецПроцедуры

&НаСервере
Процедура УслугаПриИзмененииНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НастройкиЗаписьНаУслугиИнтернетМагазина.Ресурс КАК Ресурс
	|ИЗ
	|	РегистрСведений.НастройкиЗаписьНаУслугиИнтернетМагазина КАК НастройкиЗаписьНаУслугиИнтернетМагазина
	|ГДЕ
	|	НастройкиЗаписьНаУслугиИнтернетМагазина.Услуга = &Услуга";
	
	Запрос.УстановитьПараметр("Услуга", Услуга);
	
	Ресурсы.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ресурс"));
	
КонецПроцедуры

&НаКлиенте
Процедура УслугаПриИзменении(Элемент)
	УслугаПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ИсточникЗаписиПриИзменении(Элемент)
	
	Элементы.НастройкаИнтеграции.Видимость = (ИсточникЗаписи = ПредопределенноеЗначение("Перечисление.ЗаписьНаУслугиИсточник.Сайт"));
	
КонецПроцедуры

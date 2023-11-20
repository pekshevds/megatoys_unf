
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьУсловноеОформление();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьНастройкуДляТекущегоРабочегоМеста(Команда)
	УстановитьНастройкуДляТекущегоРабочегоМестаНаСервере(Элементы.Список.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьНастройкуДляТекущегоРабочегоМестаНаСервере(ИсходныеДанные)
	
	ЗначениеНастройки = Неопределено;
	
	Если НЕ ИсходныеДанные = Неопределено
		И ИсходныеДанные.Свойство("Ссылка", ЗначениеНастройки) 
		И ЗначениеЗаполнено(ЗначениеНастройки) Тогда
		
			ОбщегоНазначенияРМКВызовСервера.УстановитьНастройкуРМКДляТекущегоРабочегоМеста(ЗначениеНастройки);
			Элементы.Список.Обновить();
			
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	ЭлементыОформления = УсловноеОформление.Элементы;
	ЭлементыОформления.Очистить();
	
	Элемент = ЭлементыОформления.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);
	ПолеЭлемента.Использование = Истина;
	
	УсловиеЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	УсловиеЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокНастроек.РабочееМесто");
	УсловиеЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	УсловиеЭлемента.ПравоеЗначение = Справочники.РабочиеМеста.ПустаяСсылка();
	УсловиеЭлемента.Использование = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ИтогиФонГруппы);

КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыОткрытия = Новый Структура("НастройкаРабочегоМеста",ВыбраннаяСтрока);
	ОткрытьФорму("ОбщаяФорма.НастройкиРабочегоМестаКассира", ПараметрыОткрытия,
			ЭтаФорма, УникальныйИдентификатор,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "РабочееМестоКассираУспешноНастроено"
		И Параметр.ОткрытаФормаСписка Тогда
		Источник.Закрыть();
		Если Параметр.РабочееМестоКассираУспешноНастроено Тогда
			Элементы.Список.Обновить();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНастройку(Команда)
	СтандартнаяОбработка = Ложь;
	ПараметрыОткрытия = Новый Структура("НоваяНастройка",Истина);
	ОткрытьФорму("ОбщаяФорма.НастройкиРабочегоМестаКассира", ПараметрыОткрытия,
			ЭтаФорма, УникальныйИдентификатор,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьНастройку(Команда)
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	НастройкаЭлемента = ТекущиеДанные.Ссылка;
	ПараметрыОткрытия = Новый Структура("НоваяНастройка, НастройкаРабочегоМеста",Истина, НастройкаЭлемента);
	ОткрытьФорму("ОбщаяФорма.НастройкиРабочегоМестаКассира", ПараметрыОткрытия,
			ЭтаФорма, УникальныйИдентификатор,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

#КонецОбласти

#Область ВыгрузкаЗагрузкаВФайл
&НаКлиенте
Процедура ВыгрузитьВФайл(Команда)
	ВыбратьФайлНаКлиенте(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайла(Команда)
	ВыбратьФайлНаКлиенте(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайлНаКлиенте(ДляЗагрузки = Ложь)
	
	РежимДиалогаВыбора = ?(ДляЗагрузки, РежимДиалогаВыбораФайла.Открытие, РежимДиалогаВыбораФайла.Сохранение);
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбора);
	ДиалогОткрытияФайла.Фильтр = НСтр("ru = 'НастройкиРМК (*.xml)|*.xml'");
	ДиалогОткрытияФайла.ПолноеИмяФайла = НСтр("ru = 'НастройкиРМК'");
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ДляЗагрузки", ДляЗагрузки);
	
	ОповещениеВыбора = Новый ОписаниеОповещения("ВыбранФайл", ЭтотОбъект, ДополнительныеПараметры);
	
	ФайловаяСистемаКлиент.ПоказатьДиалогВыбора(ОповещениеВыбора, ДиалогОткрытияФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранФайл(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	ОбъектСсылка = ТекущиеДанные.Ссылка;
	ПутьКФайлу = ВыбранныеФайлы[0];
	
	Если ДополнительныеПараметры.Свойство("ДляЗагрузки") И ДополнительныеПараметры.ДляЗагрузки Тогда
		
		ПредыдущийСценарий = НастройкаРМК.СценарийИспользования;
		
		ЕстьОшибки = Ложь;
		ФайлXML = Новый ТекстовыйДокумент;
		ФайлXML.Прочитать(ПутьКФайлу);
		ТекстXML = ФайлXML.ПолучитьТекст();
		ЗагрузитьНастройкиИзXML(ТекстXML, ЕстьОшибки, ОбъектСсылка);
		
		Если ЕстьОшибки Тогда
			
			ПоказатьПредупреждение(, НСтр("ru='При загрузке настроек произошли ошибки.
				|Подробнее см. в журнале регистрации.'"));
			
		Иначе
			
			ПоказатьПредупреждение(, НСтр("ru='Настройки успешно загружены.'"));
			
		КонецЕсли;
		
	Иначе
		
		ТекстXML = НастройкиВФорматеXML(ОбъектСсылка);
		ФайлXML = Новый ТекстовыйДокумент;
		ФайлXML.УстановитьТекст(ТекстXML);
		ФайлXML.Записать(ПутьКФайлу);
		ПоказатьПредупреждение(, НСтр("ru='Настройки успешно выгружены.'"));
		
	КонецЕсли;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиИзXML(ТекстXML, ЕстьОшибки, ОбъектСсылка)
	Если ОбъектСсылка.Пустая() Тогда
		ТекущееРабочееМесто = МенеджерОборудованияВызовСервера.РабочееМестоКлиента();
		НастройкаОбъект = Справочники.НастройкиРабочегоМестаКассира.СоздатьЭлемент();
		НастройкаОбъект.РабочееМесто = ТекущееРабочееМесто;
	Иначе
		НастройкаОбъект = ОбъектСсылка.ПолучитьОбъект();
	КонецЕсли;
	Справочники.НастройкиРабочегоМестаКассира.ЗагрузитьНастройкиИзXML(ТекстXML, ЕстьОшибки, НастройкаОбъект);
КонецПроцедуры

&НаСервере
Функция НастройкиВФорматеXML(ОбъектСсылка)
	
	НастройкаОбъект = ОбъектСсылка.ПолучитьОбъект();
	ЗначениеВРеквизитФормы(НастройкаОбъект,"НастройкаРМК");
	
	СтруктураНастроек = Новый Структура;
	ОбщегоНазначенияРМКПереопределяемый.СформироватьСтруктуруНастроек(СтруктураНастроек, НастройкаРМК);
	
	ТекстXML = ОбщегоНазначения.ЗначениеВСтрокуXML(СтруктураНастроек);
	
	Возврат ТекстXML;
	
КонецФункции

#КонецОбласти


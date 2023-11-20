
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Объект.Ссылка.Пустая() Тогда
		
		ДанныеКарточки = Справочники.КарточкиАнализаБизнеса.ПолучитьДанныеКарточки(Объект.Ссылка);
		
		Если Объект.ВидКарточки = Перечисления.ВидыКарточекАнализаБизнеса.Цель Тогда
			
			Элементы.ПредставлениеПоказателяЦель.Заголовок = Строка(ДанныеКарточки.Показатель);
			Элементы.ПредставлениеЦельПлан.Заголовок = Справочники.КарточкиАнализаБизнеса.ПолучитьПредставлениеСуммы(ДанныеКарточки.СуммаПлан, ДанныеКарточки.ЭтоПроцент);
			Элементы.ПредставлениеЦельФакт.Заголовок = Справочники.КарточкиАнализаБизнеса.ПолучитьПредставлениеСуммы(ДанныеКарточки.СуммаФакт, ДанныеКарточки.ЭтоПроцент);
			Элементы.ПредставлениеЦельПериод.Заголовок = ПредставлениеПериода(ДанныеКарточки.ТекущийПериод, ДанныеКарточки.ПериодАнализа.ДатаОкончания);
			
			ЗаполнитьТаблицыРасшифровки(ДанныеКарточки);
			
		Иначе // Проверки
			
			Если Объект.ВариантПроверки = Перечисления.ВариантыПроверокАнализаБизнеса.Динамика Тогда
				
				ТаблицаДинамики = ДанныеКарточки.ТаблицаДинамики;
				
				СерияДиаграммы = ДиаграммаДинамика.УстановитьСерию(Объект.ПоказательБизнеса);
				ЛинияТренда = СерияДиаграммы.ЛинииТренда.Добавить();
				ЛинияТренда.Текст = НСтр("ru = 'Динамика'");
				
				Для каждого СтрокаТаблицы Из ТаблицаДинамики Цикл
					Точка = ДиаграммаДинамика.УстановитьТочку(СтрокаТаблицы.Период);
					Точка.Текст = Формат(Точка.Значение,  "ДФ='MMM yy'");
					ДиаграммаДинамика.УстановитьЗначение(Точка, СерияДиаграммы, СтрокаТаблицы.Сумма);
				КонецЦикла;
				
				Если Объект.ВидИзменения = Перечисления.ИзменениеЗначенияПоказателя.Увеличение Тогда
					ТекстДинамика = ?(ДанныеКарточки.ОценкаХорошо, НСтр("ru = 'Увеличение'"), НСтр("ru = 'Уменьшение'"));
				Иначе
					ТекстДинамика = ?(ДанныеКарточки.ОценкаХорошо, НСтр("ru = 'Уменьшение'"), НСтр("ru = 'Увеличение'"));
				КонецЕсли;
				
				Элементы.Периодичность.Заголовок = Строка(ДанныеКарточки.Периодичность);
				Элементы.Динамика.Заголовок = ТекстДинамика;
				
			КонецЕсли;
			
			Если Объект.ВариантПроверки = Перечисления.ВариантыПроверокАнализаБизнеса.СравнениеСФиксированнымЗначением
				ИЛИ Объект.ВариантПроверки = Перечисления.ВариантыПроверокАнализаБизнеса.СравнениеСПоказателем Тогда
				
				Элементы.ЗначениеПоказателя.Заголовок = Справочники.КарточкиАнализаБизнеса.ПолучитьПредставлениеСуммы(ДанныеКарточки.СуммаПоказателя, ДанныеКарточки.ЭтоПроцент);
				Элементы.КонтрольноеЗначение.Заголовок = Справочники.КарточкиАнализаБизнеса.ПолучитьПредставлениеСуммы(ДанныеКарточки.ЗначениеДляСравнения, ДанныеКарточки.ЭтоПроцент);
				
			КонецЕсли;
			
			Элементы.ПредставлениеПоказателя.Заголовок = Строка(ДанныеКарточки.Показатель);
			Элементы.ОписаниеУсловияСравнения.Заголовок = ОписаниеУсловияСравнения();
			Элементы.ПредставлениеПериода.Заголовок = ПредставлениеПериода(ДанныеКарточки.ПериодАнализа.ДатаНачала, ДанныеКарточки.ПериодАнализа.ДатаОкончания);
			
			ОценкаХорошо = ДанныеКарточки.ОценкаХорошо;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ВосстановитьФорматированныйТекстИзХранилища();
	НастроитьВидимостьЭлементовФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПлановыеДокументыПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ТекущиеДанные = Элементы.ПлановыеДокументы.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(, ТекущиеДанные.Документ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФактическиеДанныеПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ТекущиеДанные = Элементы.ФактическиеДанные.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(, ТекущиеДанные.Документ);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВосстановитьФорматированныйТекстИзХранилища()
	
	Если Объект.ВидКарточки <> Перечисления.ВидыКарточекАнализаБизнеса.КонтрольПоказателей Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектСправочника = РеквизитФормыВЗначение("Объект");
	МассивФорматированныхСтрок = Новый Массив;
	
	ТекстОписаниеПроверки = ОбъектСправочника.ТекстОписаниеПроверки.Получить();
	Если ТипЗнч(ТекстОписаниеПроверки) = Тип("ФорматированныйДокумент") Тогда
		ТекстОписаниеПроверки = ТекстОписаниеПроверки.ПолучитьФорматированнуюСтроку();
		Если ЗначениеЗаполнено(ТекстОписаниеПроверки) Тогда
			ЗаголовокТекста = НСтр("ru = 'Зачем контролировать этот показатель?'");
			МассивФорматированныхСтрок.Добавить(Новый ФорматированнаяСтрока(ЗаголовокТекста, ШрифтыСтиля.УвеличенныйПолужирныйШрифтБЭД));
			МассивФорматированныхСтрок.Добавить(Символы.ПС);
			МассивФорматированныхСтрок.Добавить(ТекстОписаниеПроверки);
		КонецЕсли;
	КонецЕсли;
	
	Если ОценкаХорошо Тогда
		ТекстОценки = ОбъектСправочника.ТекстПоложительныйРезультат.Получить();
	Иначе
		ТекстОценки = ОбъектСправочника.ТекстОтрицательныйРезультат.Получить();
	КонецЕсли;
	
	Если ТипЗнч(ТекстОценки) = Тип("ФорматированныйДокумент") Тогда
		ТекстОценки = ТекстОценки.ПолучитьФорматированнуюСтроку();
		Если ЗначениеЗаполнено(ТекстОценки) Тогда
			МассивФорматированныхСтрок.Добавить(Символы.ПС + Символы.ПС);
			ЗаголовокТекста = НСтр("ru = 'Что нужно сделать?'");
			МассивФорматированныхСтрок.Добавить(Новый ФорматированнаяСтрока(ЗаголовокТекста, ШрифтыСтиля.УвеличенныйПолужирныйШрифтБЭД));
			МассивФорматированныхСтрок.Добавить(Символы.ПС);
			МассивФорматированныхСтрок.Добавить(ТекстОценки);
		КонецЕсли;
	
	КонецЕсли;
	
	ОсновноеСодержимоеПроверки = Новый ФорматированнаяСтрока(МассивФорматированныхСтрок);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьВидимостьЭлементовФормы()
	
	Если Объект.ВидКарточки = Перечисления.ВидыКарточекАнализаБизнеса.КонтрольПоказателей Тогда
		
		Элементы.ГруппаОтображениеЦели.Видимость = Ложь;
		ТекущаяСтраница = Элементы.ГруппаОтображениеПроверки;
		Элементы.ГруппаТекстПроверки.Видимость = ЗначениеЗаполнено(ОсновноеСодержимоеПроверки);
		
		Если Объект.ВариантПроверки = Перечисления.ВариантыПроверокАнализаБизнеса.Динамика Тогда
			
			ТекстАссистента = НСтр("ru = 'Я проанализировала изменение суммы показателя за период.'");
			
			Элементы.ГруппаПроверкаДинамика.Видимость = Истина;
			Элементы.ГруппаПериодичность.Видимость = Истина;
			Элементы.ГруппаДинамика.Видимость = Истина;
			Элементы.ГруппаЗначениеПоказателя.Видимость = Ложь;
			Элементы.ГруппаКонтрольноеЗначение.Видимость = Ложь;
		КонецЕсли;
		
		Если Объект.ВариантПроверки = Перечисления.ВариантыПроверокАнализаБизнеса.СравнениеСФиксированнымЗначением Тогда
			
			ТекстАссистента = НСтр("ru = 'Я рассчитала сумму показателя и сравнила его с контрольным значением.'");
			
			Элементы.ГруппаПроверкаДинамика.Видимость = Ложь;
			Элементы.ГруппаПериодичность.Видимость = Ложь;
			Элементы.ГруппаДинамика.Видимость = Ложь;
			Элементы.ГруппаЗначениеПоказателя.Видимость = Истина;
			Элементы.ГруппаКонтрольноеЗначение.Видимость = Истина;

		КонецЕсли;
		
		Если Объект.ВариантПроверки = Перечисления.ВариантыПроверокАнализаБизнеса.СравнениеСПоказателем Тогда
			
			ТекстАссистента = НСтр("ru = 'Я рассчитала суммы показателей и сравнила их между собой.'");
			
			Элементы.ГруппаПроверкаДинамика.Видимость = Ложь;
			Элементы.ГруппаПериодичность.Видимость = Ложь;
			Элементы.ГруппаДинамика.Видимость = Ложь;
			Элементы.ГруппаЗначениеПоказателя.Видимость = Истина;
			
		КонецЕсли;
		
		Элементы.ТекстАссистента.Заголовок = ТекстАссистента;
		
		ТекстУсловиеВыполняется = НСтр("ru = 'Отлично, текущее значение соответствует условиям контроля'");
		ТекстУсловиеНеВыполняется = НСтр("ru = 'Текущее значение не соответствует условиям контроля'");
		Элементы.ТекстРезультатПроверки.Заголовок = ?(ОценкаХорошо, ТекстУсловиеВыполняется, ТекстУсловиеНеВыполняется);
		Элементы.ДекорацияХорошо.Видимость = 	  ОценкаХорошо;
		Элементы.ДекорацияПлохо.Видимость  = НЕ ОценкаХорошо;
		
	Иначе // Цели бизнеса
		Элементы.ГруппаОтображениеПроверки.Видимость = Ложь;
		ТекущаяСтраница = Элементы.ГруппаОтображениеЦели;
	КонецЕсли;
	
	Элементы.ГруппаВариантыОтображения.ТекущаяСтраница = ТекущаяСтраница;
	
КонецПроцедуры

&НаСервере
Функция ОписаниеУсловияСравнения()
	
	Если Объект.ВариантПроверки = Перечисления.ВариантыПроверокАнализаБизнеса.СравнениеСФиксированнымЗначением Тогда
		ТекстСравнения = НСтр("ru = 'Значение показателя должно быть <b>%1</b> контрольного значения.'");
		ТекстСравнения = СтрШаблон(ТекстСравнения, НРег(Строка(Объект.ВидСравненияЗначений)));
	ИначеЕсли Объект.ВариантПроверки = Перечисления.ВариантыПроверокАнализаБизнеса.СравнениеСПоказателем Тогда
		ТекстСравнения = НСтр("ru = 'Значение показателя <b>%1</b> должно быть <b>%2</b> значения показателя <b>%3</b>.'");
		ТекстСравнения = СтрШаблон(ТекстСравнения, Строка(Объект.ПоказательБизнеса), НРег(Строка(Объект.ВидСравненияЗначений)), Строка(Объект.ЗначениеДляСравнения));
	Иначе // Динамика
		Если Объект.ВидИзменения = Перечисления.ИзменениеЗначенияПоказателя.Увеличение Тогда
			ТекстСравнения = НСтр("ru = 'Значение показателя должно <b>увеличиваться</b> за выбранный период.'");
		Иначе
			ТекстСравнения = НСтр("ru = 'Значение показателя должно <b>уменьшаться</b> за выбранный период.'");
		КонецЕсли;
	КонецЕсли;
	
	Возврат СтроковыеФункции.ФорматированнаяСтрока(ТекстСравнения);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицыРасшифровки(ДанныеКарточки)
	
	ВидОтчета = ДанныеКарточки.Показатель.ВидОтчета;
	МассивПоказателей = Новый Массив;
	Справочники.ПоказателиБизнеса.ПолучитьЗависимыеПоказателиРекурсивно(ДанныеКарточки.Показатель, МассивПоказателей);
	МассивПоказателей = ОбщегоНазначенияКлиентСервер.СвернутьМассив(МассивПоказателей);
	
	ТекстЗапроса = ПоказателиБизнеса.ПолучитьТекстЗапросаРасшифровкаПоказателя(ВидОтчета, Справочники.СценарииПланирования.Фактический);
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("МассивПоказателей", МассивПоказателей);
	Запрос.УстановитьПараметр("СценарийПланирования", Справочники.СценарииПланирования.Фактический);
	Запрос.УстановитьПараметр("НачалоПериода", ДанныеКарточки.ТекущийПериод);
	Запрос.УстановитьПараметр("КонецПериода", ДанныеКарточки.ПериодАнализа.ДатаОкончания);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ФактическиеДанные.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	КонецЦикла;
	
	ТекстЗапроса = ПоказателиБизнеса.ПолучитьТекстЗапросаРасшифровкаПоказателя(ВидОтчета, ДанныеКарточки.СценарийПланирования);
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("МассивПоказателей", МассивПоказателей);
	Запрос.УстановитьПараметр("СценарийПланирования", ДанныеКарточки.СценарийПланирования);
	Запрос.УстановитьПараметр("НачалоПериода", ДанныеКарточки.ТекущийПериод);
	Запрос.УстановитьПараметр("КонецПериода", ДанныеКарточки.ПериодАнализа.ДатаОкончания);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ПлановыеДанные.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Организация", Организация);		
	Параметры.Свойство("Месяц", Месяц);
	
	Если НЕ ЗначениеЗаполнено(Организация) ИЛИ НЕ ЗначениеЗаполнено(Месяц) Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли; 
	
	ИмяМесяца = ЗакрытиеМесяца.ИмяМесяцаВПадеже(Месяц(Месяц), "Р");
	ГодСтрокой = Формат(Год(Месяц), "ЧГ=0");
	Элементы.СписокНоменклатурыГруппаНаКонецМесяца.Заголовок = СтрШаблон(НСтр("ru = 'На конец %1 %2 г.'"), ИмяМесяца, ГодСтрокой);
	Элементы.ГруппаНоменклатура.Заголовок = СтрШаблон(НСтр("ru = 'Запасы с отрицательными остатками на конец %1 %2 г.'"), ИмяМесяца, ГодСтрокой);
	ИмяМесяца = ЗакрытиеМесяца.ИмяМесяцаВПадеже(Месяц(Месяц), "П");
	Элементы.ГруппаЗаказы.Заголовок = СтрШаблон(НСтр("ru = 'Резервы в %1 %2 г. по выбранному запасу'"), ИмяМесяца, ГодСтрокой);
	
	ЗаполнитьДанные();
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокНоменклатуры

&НаКлиенте
Процедура СписокНоменклатурыПометкаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.СписокНоменклатуры.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Перенесено = 0;
	Для каждого СтрокаЗаказа Из Заказы Цикл
		Если СтрокаЗаказа.КлючСвязи <> ТекущаяСтрока.КлючСвязи Тогда
			Продолжить;
		КонецЕсли;
		СтрокаЗаказа.Пометка = ТекущаяСтрока.Пометка;
		СтрокаЗаказа.Перенести = ?(СтрокаЗаказа.Пометка, СтрокаЗаказа.Резерв, 0);
		Перенесено = Перенесено + СтрокаЗаказа.Перенести;
	КонецЦикла;
	ТекущаяСтрока.ПослеПереноса = ТекущаяСтрока.СвободныйОстаток + Перенесено;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПриАктивизацииСтроки(Элемент)
	
	ТекущаяСтрока = Элемент.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		КлючСвязи = 0;
	Иначе
		КлючСвязи = ТекущаяСтрока.КлючСвязи;
	КонецЕсли;
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("КлючСвязи", КлючСвязи);
	Элементы.Заказы.ОтборСтрок = Новый ФиксированнаяСтруктура(СтруктураОтбора);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗаказы

&НаКлиенте
Процедура ЗаказыПометкаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элемент.ТекущиеДанные;
	ТекущаяСтрока.Перенести = ?(ТекущаяСтрока.Пометка, ТекущаяСтрока.Резерв, 0);
	ОбновитьИтогПоЗапасу();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаказыПеренестиПриИзменении(Элемент)
	
	ТекущаяСтрока = Элемент.ТекущиеДанные;
	ТекущаяСтрока.Пометка = НЕ (ТекущаяСтрока.Перенести = 0);
	ОбновитьИтогПоЗапасу();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаказыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элемент.ТекущиеДанные;
	Если Поле = Элементы.ЗаказыДатыРезервированияПредставление Тогда
		СписокДокументов = Новый СписокЗначений;
		Для каждого КлючИЗначение Из ТекущаяСтрока.ДатыРезервирования Цикл
			Документ = КлючИЗначение.Значение.Документ;
			Если НЕ ЗначениеЗаполнено(Документ) Тогда
				Продолжить;
			КонецЕсли; 
			СписокДокументов.Добавить(Документ);
		КонецЦикла;
		Если СписокДокументов.Количество() > 1 Тогда
			Оповещение = Новый ОписаниеОповещения("ПриВыбореДокументаИзСписка", ЭтотОбъект);
			ПоказатьВыборИзМеню(Оповещение, СписокДокументов, Поле);
		ИначеЕсли СписокДокументов.Количество() = 1 Тогда
			ПоказатьЗначение(, СписокДокументов[0].Значение);
		КонецЕсли;
	ИначеЕсли Поле = Элементы.ЗаказыДатыПоступленияПредставление Тогда
		СписокДокументов = Новый СписокЗначений;
		Для каждого КлючИЗначение Из ТекущаяСтрока.ДатыПоступления Цикл
			Документ = КлючИЗначение.Значение.Документ;
			Если НЕ ЗначениеЗаполнено(Документ) Тогда
				Продолжить;
			КонецЕсли; 
			СписокДокументов.Добавить(Документ);
		КонецЦикла;
		Если СписокДокументов.Количество() > 1 Тогда
			Оповещение = Новый ОписаниеОповещения("ПриВыбореДокументаИзСписка", ЭтотОбъект);
			ПоказатьВыборИзМеню(Оповещение, СписокДокументов, Поле);
		ИначеЕсли СписокДокументов.Количество() = 1 Тогда
			ПоказатьЗначение(, СписокДокументов[0].Значение);
		КонецЕсли;
	ИначеЕсли Поле = Элементы.ЗаказыЗаказПокупателя Тогда
		ПоказатьЗначение(, ТекущаяСтрока.ЗаказПокупателя);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореДокументаИзСписка(КлючИЗначение, ДополнительныеПараметры) Экспорт
	
	Если КлючИЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ПоказатьЗначение(, КлючИЗначение.Значение);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиОтмеченные(Команда)
	
	ПеренестиОтмеченныеНаСервере();
	Если Выполнено Тогда
		Закрыть(Истина);
	КонецЕсли; 
	
КонецПроцедуры
 
&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьДанные();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	
	ИзменитьВсе(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	
	ИзменитьВсе(Ложь);
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДанные()
	
	Заказы.Очистить();
	СписокНоменклатуры.Очистить();
	
	ЗаполнитьТаблицы();
	ЗаполнитьДаты();
	
	Для каждого СтрокаНоменклатура Из СписокНоменклатуры Цикл
		СтрокаНоменклатура.Пометка = Истина;
		СтрокаНоменклатура.ПослеПереноса = 0;
	КонецЦикла;
	
	ЗаполнитьПредставления();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицы()
	
	ТекущаяСтрока = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Месяц));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(Месяц));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗапасыОстаткиИОбороты.Номенклатура КАК Номенклатура,
	|	ЗапасыОстаткиИОбороты.Характеристика КАК Характеристика,
	|	ЗапасыОстаткиИОбороты.Партия КАК Партия,
	|	ЗапасыОстаткиИОбороты.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ЗапасыОстаткиИОбороты.КоличествоКонечныйОстаток КАК Остаток
	|ПОМЕСТИТЬ ОтрицательныеОстатки
	|ИЗ
	|	РегистрНакопления.Запасы.ОстаткиИОбороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			Месяц,
	|			Движения,
	|			Организация = &Организация
	|				И ЗаказПокупателя = ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)) КАК ЗапасыОстаткиИОбороты
	|ГДЕ
	|	ЗапасыОстаткиИОбороты.КоличествоКонечныйОстаток < 0
	|	И ЗапасыОстаткиИОбороты.КоличествоНачальныйОстаток <> ЗапасыОстаткиИОбороты.КоличествоКонечныйОстаток
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗапасыРезервОстаткиИОбороты.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ЗапасыРезервОстаткиИОбороты.Номенклатура КАК Номенклатура,
	|	ЗапасыРезервОстаткиИОбороты.Характеристика КАК Характеристика,
	|	ЗапасыРезервОстаткиИОбороты.Партия КАК Партия,
	|	ЗапасыРезервОстаткиИОбороты.ЗаказПокупателя КАК ЗаказПокупателя,
	|	СУММА(ЗапасыРезервОстаткиИОбороты.КоличествоОборот) КАК УвеличениеРезерва
	|ПОМЕСТИТЬ Резервирования
	|ИЗ
	|	РегистрНакопления.Запасы.ОстаткиИОбороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			Регистратор,
	|			Движения,
	|			ЗаказПокупателя <> ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)
	|				И (Организация, СтруктурнаяЕдиница, Номенклатура, Характеристика, Партия) В
	|					(ВЫБРАТЬ
	|						&Организация,
	|						ОтрицательныеОстатки.СтруктурнаяЕдиница,
	|						ОтрицательныеОстатки.Номенклатура,
	|						ОтрицательныеОстатки.Характеристика,
	|						ОтрицательныеОстатки.Партия
	|					ИЗ
	|						ОтрицательныеОстатки)) КАК ЗапасыРезервОстаткиИОбороты
	|ГДЕ
	|	(ЗапасыРезервОстаткиИОбороты.Регистратор ССЫЛКА Документ.ЗаказПокупателя
	|			ИЛИ ЗапасыРезервОстаткиИОбороты.Регистратор ССЫЛКА Документ.ЗаказНаПроизводство
	|			ИЛИ ЗапасыРезервОстаткиИОбороты.Регистратор ССЫЛКА Документ.РезервированиеЗапасов)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗапасыРезервОстаткиИОбороты.СтруктурнаяЕдиница,
	|	ЗапасыРезервОстаткиИОбороты.Номенклатура,
	|	ЗапасыРезервОстаткиИОбороты.Характеристика,
	|	ЗапасыРезервОстаткиИОбороты.Партия,
	|	ЗапасыРезервОстаткиИОбороты.ЗаказПокупателя
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗапасыОстатки.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ЗапасыОстатки.Номенклатура КАК Номенклатура,
	|	ЗапасыОстатки.Характеристика КАК Характеристика,
	|	ЗапасыОстатки.Партия КАК Партия,
	|	ЗапасыОстатки.КоличествоОстаток КАК ТекущийОстаток
	|ПОМЕСТИТЬ СвободныеОстатки
	|ИЗ
	|	РегистрНакопления.Запасы.Остатки(
	|			&КонецПериода,
	|			(Организация, СтруктурнаяЕдиница, Номенклатура, Характеристика, Партия, ЗаказПокупателя) В
	|				(ВЫБРАТЬ
	|					&Организация,
	|					ОтрицательныеОстатки.СтруктурнаяЕдиница,
	|					ОтрицательныеОстатки.Номенклатура,
	|					ОтрицательныеОстатки.Характеристика,
	|					ОтрицательныеОстатки.Партия,
	|					ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)
	|				ИЗ
	|					ОтрицательныеОстатки)) КАК ЗапасыОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗапасыОстатки.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ЗапасыОстатки.Номенклатура КАК Номенклатура,
	|	ЗапасыОстатки.Характеристика КАК Характеристика,
	|	ЗапасыОстатки.Партия КАК Партия,
	|	ЗапасыОстатки.КоличествоОстаток КАК ТекущийОстаток
	|ПОМЕСТИТЬ ТекущиеОстатки
	|ИЗ
	|	РегистрНакопления.Запасы.Остатки(
	|			,
	|			(Организация, СтруктурнаяЕдиница, Номенклатура, Характеристика, Партия, ЗаказПокупателя) В
	|				(ВЫБРАТЬ
	|					&Организация,
	|					ОтрицательныеОстатки.СтруктурнаяЕдиница,
	|					ОтрицательныеОстатки.Номенклатура,
	|					ОтрицательныеОстатки.Характеристика,
	|					ОтрицательныеОстатки.Партия,
	|					ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)
	|				ИЗ
	|					ОтрицательныеОстатки)) КАК ЗапасыОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗапасыОстатки.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ЗапасыОстатки.Номенклатура КАК Номенклатура,
	|	ЗапасыОстатки.Характеристика КАК Характеристика,
	|	ЗапасыОстатки.Партия КАК Партия,
	|	ЗапасыОстатки.ЗаказПокупателя КАК ЗаказПокупателя,
	|	ЗапасыОстатки.КоличествоОстаток КАК Резерв
	|ПОМЕСТИТЬ ОстаткиРезервов
	|ИЗ
	|	РегистрНакопления.Запасы.Остатки(
	|			&КонецПериода,
	|			ЗаказПокупателя <> ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)
	|				И (Организация, СтруктурнаяЕдиница, Номенклатура, Характеристика, Партия) В
	|					(ВЫБРАТЬ
	|						&Организация,
	|						ОтрицательныеОстатки.СтруктурнаяЕдиница,
	|						ОтрицательныеОстатки.Номенклатура,
	|						ОтрицательныеОстатки.Характеристика,
	|						ОтрицательныеОстатки.Партия
	|					ИЗ
	|						ОтрицательныеОстатки)) КАК ЗапасыОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОтрицательныеОстатки.Номенклатура КАК Номенклатура,
	|	ОтрицательныеОстатки.Характеристика КАК Характеристика,
	|	ОтрицательныеОстатки.Партия КАК Партия,
	|	ОтрицательныеОстатки.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ОтрицательныеОстатки.Остаток КАК СвободныйОстаток,
	|	ЕСТЬNULL(Резервирования.УвеличениеРезерва, 0) КАК УвеличениеРезерва,
	|	ЕСТЬNULL(ОстаткиРезервов.ЗаказПокупателя, ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)) КАК ЗаказПокупателя,
	|	ЕСТЬNULL(ОстаткиРезервов.Резерв, 0) КАК Резерв
	|ИЗ
	|	ОтрицательныеОстатки КАК ОтрицательныеОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиРезервов КАК ОстаткиРезервов
	|			ЛЕВОЕ СОЕДИНЕНИЕ Резервирования КАК Резервирования
	|			ПО ОстаткиРезервов.СтруктурнаяЕдиница = Резервирования.СтруктурнаяЕдиница
	|				И ОстаткиРезервов.Номенклатура = Резервирования.Номенклатура
	|				И ОстаткиРезервов.Характеристика = Резервирования.Характеристика
	|				И ОстаткиРезервов.Партия = Резервирования.Партия
	|				И ОстаткиРезервов.ЗаказПокупателя = Резервирования.ЗаказПокупателя
	|		ПО ОтрицательныеОстатки.СтруктурнаяЕдиница = ОстаткиРезервов.СтруктурнаяЕдиница
	|			И ОтрицательныеОстатки.Номенклатура = ОстаткиРезервов.Номенклатура
	|			И ОтрицательныеОстатки.Характеристика = ОстаткиРезервов.Характеристика
	|			И ОтрицательныеОстатки.Партия = ОстаткиРезервов.Партия
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТекущиеОстатки КАК ТекущиеОстатки
	|		ПО ОтрицательныеОстатки.СтруктурнаяЕдиница = ТекущиеОстатки.СтруктурнаяЕдиница
	|			И ОтрицательныеОстатки.Номенклатура = ТекущиеОстатки.Номенклатура
	|			И ОтрицательныеОстатки.Характеристика = ТекущиеОстатки.Характеристика
	|			И ОтрицательныеОстатки.Партия = ТекущиеОстатки.Партия
	|ГДЕ
	|	ЕСТЬNULL(ТекущиеОстатки.ТекущийОстаток, 0) >= 0
	|ИТОГИ
	|	МАКСИМУМ(СвободныйОстаток),
	|	СУММА(УвеличениеРезерва),
	|	СУММА(Резерв)
	|ПО
	|	Номенклатура,
	|	Характеристика,
	|	Партия,
	|	СтруктурнаяЕдиница,
	|	ЗаказПокупателя";	
	ВыборкаНоменклатура = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаНоменклатура.Следующий() Цикл
		ВыборкаХарактеристика = ВыборкаНоменклатура.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаХарактеристика.Следующий() Цикл
			ВыборкаПартия = ВыборкаХарактеристика.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаПартия.Следующий() Цикл
				ВыборкаСтруктурнаяЕдиница = ВыборкаПартия.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока ВыборкаСтруктурнаяЕдиница.Следующий() Цикл
					Если ВыборкаСтруктурнаяЕдиница.Резерв - ВыборкаСтруктурнаяЕдиница.СвободныйОстаток < 0
						ИЛИ ВыборкаСтруктурнаяЕдиница.УвеличениеРезерва - ВыборкаСтруктурнаяЕдиница.СвободныйОстаток < 0 Тогда
						// Нет резервов для переноса
						Продолжить;
					КонецЕсли;
					ВыборкаЗаказПокупателя = ВыборкаСтруктурнаяЕдиница.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
					Пока ВыборкаЗаказПокупателя.Следующий() Цикл
						Если ТекущаяСтрока = Неопределено 
							ИЛИ ТекущаяСтрока.Номенклатура <> ВыборкаЗаказПокупателя.Номенклатура
							ИЛИ ТекущаяСтрока.Характеристика <> ВыборкаЗаказПокупателя.Характеристика
							ИЛИ ТекущаяСтрока.Партия <> ВыборкаЗаказПокупателя.Партия
							ИЛИ ТекущаяСтрока.СтруктурнаяЕдиница <> ВыборкаЗаказПокупателя.СтруктурнаяЕдиница Тогда
							ТекущаяСтрока = СписокНоменклатуры.Добавить();
							ЗаполнитьЗначенияСвойств(ТекущаяСтрока, ВыборкаСтруктурнаяЕдиница);
							ТекущаяСтрока.КлючСвязи = СписокНоменклатуры.Количество();
							ТекущаяСтрока.ПослеПереноса = - ТекущаяСтрока.СвободныйОстаток;
							ТекущаяСтрока.ЕдиницаИзмерения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущаяСтрока.Номенклатура, "ЕдиницаИзмерения");
						КонецЕсли; 
						НоваяСтрока = Заказы.Добавить();
						ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаЗаказПокупателя);
						НоваяСтрока.КлючСвязи = ТекущаяСтрока.КлючСвязи;
						НоваяСтрока.ДатыРезервирования = Новый СписокЗначений;
						НоваяСтрока.ДатыПоступления = Новый СписокЗначений;
					КонецЦикла; 
				КонецЦикла; 
			КонецЦикла; 
		КонецЦикла; 
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДаты()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Месяц));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(Месяц));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("СписокНоменклатуры", СписокНоменклатуры.Выгрузить(, "Номенклатура, Характеристика, Партия, СтруктурнаяЕдиница, КлючСвязи"));
	Запрос.УстановитьПараметр("Заказы", Заказы.Выгрузить(, "ЗаказПокупателя, КлючСвязи"));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписокНоменклатуры.Номенклатура КАК Номенклатура,
	|	СписокНоменклатуры.Характеристика КАК Характеристика,
	|	СписокНоменклатуры.Партия КАК Партия,
	|	СписокНоменклатуры.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	СписокНоменклатуры.КлючСвязи КАК КлючСвязи
	|ПОМЕСТИТЬ СписокНоменклатуры
	|ИЗ
	|	&СписокНоменклатуры КАК СписокНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Заказы.ЗаказПокупателя КАК ЗаказПокупателя,
	|	Заказы.КлючСвязи КАК КлючСвязи
	|ПОМЕСТИТЬ Заказы
	|ИЗ
	|	&Заказы КАК Заказы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокНоменклатуры.Номенклатура КАК Номенклатура,
	|	СписокНоменклатуры.Характеристика КАК Характеристика,
	|	СписокНоменклатуры.Партия КАК Партия,
	|	СписокНоменклатуры.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	СписокНоменклатуры.КлючСвязи КАК КлючСвязи,
	|	Заказы.ЗаказПокупателя КАК ЗаказПокупателя
	|ПОМЕСТИТЬ НоменклатураИЗаказы
	|ИЗ
	|	СписокНоменклатуры КАК СписокНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ Заказы КАК Заказы
	|		ПО СписокНоменклатуры.КлючСвязи = Заказы.КлючСвязи
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗапасыОбороты.Регистратор КАК Регистратор,
	|	ЗапасыОбороты.КоличествоПриход КАК Резерв,
	|	НоменклатураИЗаказы.КлючСвязи КАК КлючСвязи,
	|	НоменклатураИЗаказы.ЗаказПокупателя КАК ЗаказПокупателя,
	|	ЗапасыОбороты.Период КАК Период
	|ИЗ
	|	РегистрНакопления.Запасы.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			Регистратор,
	|			Организация = &Организация
	|				И (Номенклатура, Характеристика, Партия, СтруктурнаяЕдиница, ЗаказПокупателя) В
	|					(ВЫБРАТЬ
	|						НоменклатураИЗаказы.Номенклатура,
	|						НоменклатураИЗаказы.Характеристика,
	|						НоменклатураИЗаказы.Партия,
	|						НоменклатураИЗаказы.СтруктурнаяЕдиница,
	|						НоменклатураИЗаказы.ЗаказПокупателя
	|					ИЗ
	|						НоменклатураИЗаказы)) КАК ЗапасыОбороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ НоменклатураИЗаказы КАК НоменклатураИЗаказы
	|		ПО ЗапасыОбороты.СтруктурнаяЕдиница = НоменклатураИЗаказы.СтруктурнаяЕдиница
	|			И ЗапасыОбороты.Номенклатура = НоменклатураИЗаказы.Номенклатура
	|			И ЗапасыОбороты.Характеристика = НоменклатураИЗаказы.Характеристика
	|			И ЗапасыОбороты.Партия = НоменклатураИЗаказы.Партия
	|			И ЗапасыОбороты.ЗаказПокупателя = НоменклатураИЗаказы.ЗаказПокупателя
	|ГДЕ
	|	ЗапасыОбороты.КоличествоОборот > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗапасыОбороты.Регистратор КАК Регистратор,
	|	ЗапасыОбороты.КоличествоПриход КАК Поступление,
	|	СписокНоменклатуры.КлючСвязи КАК КлючСвязи,
	|	ЗапасыОбороты.Период КАК Период
	|ИЗ
	|	РегистрНакопления.Запасы.ОстаткиИОбороты(
	|			&НачалоПериода,
	|			,
	|			Регистратор,
	|			Движения,
	|			Организация = &Организация
	|				И (Номенклатура, Характеристика, Партия, СтруктурнаяЕдиница, ЗаказПокупателя) В
	|					(ВЫБРАТЬ
	|						НоменклатураИЗаказы.Номенклатура,
	|						НоменклатураИЗаказы.Характеристика,
	|						НоменклатураИЗаказы.Партия,
	|						НоменклатураИЗаказы.СтруктурнаяЕдиница,
	|						ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)
	|					ИЗ
	|						НоменклатураИЗаказы)) КАК ЗапасыОбороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ СписокНоменклатуры КАК СписокНоменклатуры
	|		ПО ЗапасыОбороты.СтруктурнаяЕдиница = СписокНоменклатуры.СтруктурнаяЕдиница
	|			И ЗапасыОбороты.Номенклатура = СписокНоменклатуры.Номенклатура
	|			И ЗапасыОбороты.Характеристика = СписокНоменклатуры.Характеристика
	|			И ЗапасыОбороты.Партия = СписокНоменклатуры.Партия
	|ГДЕ
	|	ЗапасыОбороты.КоличествоОборот > 0
	|	И ЗапасыОбороты.КоличествоНачальныйОстаток < 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период";
	Результат = Запрос.ВыполнитьПакет();
	ТаблицаРезервы = Результат[3].Выгрузить();
	ТаблицаПоступления = Результат[4].Выгрузить();
	СтруктураОтбора = Новый Структура;
	
	Для каждого СтрокаЗаказы Из Заказы Цикл
		СтрокаНоменклатура = СтрокаПоКлючуСвязи(СписокНоменклатуры, СтрокаЗаказы.КлючСвязи);
		Если СтрокаНоменклатура = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		СтруктураОтбора.Очистить();
		СтруктураОтбора.Вставить("КлючСвязи", СтрокаЗаказы.КлючСвязи);
		СтрокиПоступления = ТаблицаПоступления.НайтиСтроки(СтруктураОтбора);
		СтруктураОтбора.Вставить("ЗаказПокупателя", СтрокаЗаказы.ЗаказПокупателя);
		СтрокиРезервы = ТаблицаРезервы.НайтиСтроки(СтруктураОтбора);
		ОсталосьПеренести = СтрокаНоменклатура.ПослеПереноса;
		Для каждого СтрокаРезерв Из СтрокиРезервы Цикл
			Перенести = Мин(ОсталосьПеренести, СтрокаРезерв.Резерв);
			Если Перенести <= 0 Тогда
				Продолжить;
			КонецЕсли; 
			ОсталосьПеренести = ОсталосьПеренести - Перенести;
			СтрокаРезерв.Резерв = СтрокаРезерв.Резерв - Перенести;
			СтруктураРезерва = Новый Структура;
			СтруктураРезерва.Вставить("Документ", СтрокаРезерв.Регистратор);
			СтруктураРезерва.Вставить("Резерв", Перенести);
			СтруктураРезерва.Вставить("Дата", СтрокаРезерв.Период);
			Если СтрокаЗаказы.ДатыРезервирования.Количество() = 0 Тогда
				СтрокаЗаказы.ДатыРезервирования.Добавить(СтруктураРезерва);
			Иначе
				СтрокаЗаказы.ДатыРезервирования.Вставить(0, СтруктураРезерва);
			КонецЕсли;
			Если ОсталосьПеренести <= 0 Тогда
				Прервать;
			КонецЕсли; 
		КонецЦикла;
		ОсталосьПеренести = СтрокаНоменклатура.ПослеПереноса - ОсталосьПеренести;
		Для каждого СтрокаПоступление Из СтрокиПоступления Цикл
			Перенести = Мин(ОсталосьПеренести, СтрокаПоступление.Поступление);
			Если Перенести <= 0 Тогда
				Продолжить;
			КонецЕсли; 
			ОсталосьПеренести = ОсталосьПеренести - Перенести;
			СтрокаПоступление.Поступление = СтрокаПоступление.Поступление - Перенести;
			СтруктураПоступления = Новый Структура;
			СтруктураПоступления.Вставить("Документ", СтрокаПоступление.Регистратор);
			СтруктураПоступления.Вставить("Поступление", Перенести);
			СтруктураПоступления.Вставить("Дата", СтрокаПоступление.Период);
			СтрокаЗаказы.ДатыПоступления.Добавить(СтруктураПоступления);
			Если ОсталосьПеренести <= 0 Тогда
				Прервать;
			КонецЕсли; 
		КонецЦикла; 
	КонецЦикла; 
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПредставления()
	
	ПараметрыНоменклатуры = Новый Структура;
	
	Для каждого СтрокаНоменклатура Из СписокНоменклатуры Цикл
		ПараметрыНоменклатуры.Очистить();
		ПараметрыНоменклатуры.Вставить("ПредставлениеНоменклатуры", СтрокаНоменклатура.Номенклатура);
		ПараметрыНоменклатуры.Вставить("ПредставлениеХарактеристики", СтрокаНоменклатура.Характеристика);
		ПараметрыНоменклатуры.Вставить("ПредставлениеПартии", СтрокаНоменклатура.Партия);
		СтрокаНоменклатура.НоменклатураПредставление = ПечатьДокументовУНФ.ПредставлениеНоменклатуры(ПараметрыНоменклатуры);
	КонецЦикла; 
	
	Для каждого СтрокаЗаказы Из Заказы Цикл
		СтрокаНоменклатура = СтрокаПоКлючуСвязи(СписокНоменклатуры, СтрокаЗаказы.КлючСвязи);
		Если СтрокаНоменклатура = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		СтрокаЗаказы.Пометка = Истина;
		СтрокаЗаказы.Перенести = СтрокаЗаказы.Резерв;
		Составляющие = Новый Массив;
		Для каждого КлючИЗначение Из СтрокаЗаказы.ДатыРезервирования Цикл
			СтруктураРезерва = КлючИЗначение.Значение;
			Если СтрокаЗаказы.ДатыРезервирования.Количество() = 1 Тогда
				Представление = Формат(СтруктураРезерва.Дата, "ДЛФ=D");
			Иначе
				Представление = СтрШаблон(НСтр("ru = '%1 (%2 %3)'"), 
				Формат(СтруктураРезерва.Дата, "ДЛФ=D"), 
				Формат(СтруктураРезерва.Резерв, "ЧГ=0"), 
				СтрокаНоменклатура.ЕдиницаИзмерения);
			КонецЕсли; 
			Составляющие.Добавить(Представление);
		КонецЦикла;
		СтрокаЗаказы.ДатыРезервированияПредставление = СтрСоединить(Составляющие, Символы.ПС);
		Составляющие = Новый Массив;
		Для каждого КлючИЗначение Из СтрокаЗаказы.ДатыПоступления Цикл
			СтруктураПоступления = КлючИЗначение.Значение;
			Если СтрокаЗаказы.ДатыПоступления.Количество() = 1 Тогда
				Представление = Формат(СтруктураПоступления.Дата, "ДЛФ=D");
			Иначе
				Представление = СтрШаблон(НСтр("ru = '%1 (%2 %3)'"), 
				Формат(СтруктураПоступления.Дата, "ДЛФ=D"), 
				Формат(СтруктураПоступления.Поступление, "ЧГ=0"), 
				СтрокаНоменклатура.ЕдиницаИзмерения);
			КонецЕсли; 
			Составляющие.Добавить(Представление);
		КонецЦикла;
		СтрокаЗаказы.ДатыПоступленияПредставление = СтрСоединить(Составляющие, Символы.ПС);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПеренестиОтмеченныеНаСервере()
	
	Для каждого СтрокаЗаказы Из Заказы Цикл
		Если НЕ СтрокаЗаказы.Пометка ИЛИ СтрокаЗаказы.Перенести <= 0 Тогда
			Продолжить;
		КонецЕсли; 
		СтрокаНоменклатура = СтрокаПоКлючуСвязи(СписокНоменклатуры, СтрокаЗаказы.КлючСвязи);
		Если СтрокаНоменклатура = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Перенести = СтрокаЗаказы.Перенести;
		ДатыРезервирования = СтрокаЗаказы.ДатыРезервирования.ВыгрузитьЗначения();
		ДатыПоступления = СтрокаЗаказы.ДатыПоступления.ВыгрузитьЗначения();
		Для каждого СтруктураРезерва Из ДатыРезервирования Цикл
			Для каждого СтруктураПоступления Из ДатыПоступления Цикл
				КПереносу = Мин(Перенести, СтруктураРезерва.Резерв, СтруктураПоступления.Поступление);
				Если КПереносу <= 0 Тогда
					Продолжить;
				КонецЕсли; 
				СтруктураРезерва.Резерв = СтруктураРезерва.Резерв - КПереносу;
				СтруктураПоступления.Поступление = СтруктураПоступления.Поступление - КПереносу;
				Перенести = Перенести - КПереносу;
				ДокументРезерва = СтруктураРезерва.Документ;
				ДатаПереноса = КонецДня(СтруктураПоступления.Дата);
				НачатьТранзакцию();
				Попытка
					ВключитьКонтроль = Ложь;
					Если Константы.КонтролироватьОстаткиПриПроведении.Получить() Тогда
						Константы.КонтролироватьОстаткиПриПроведении.Установить(Ложь);
						ВключитьКонтроль = Истина;
					КонецЕсли; 
					СтруктураПараметров = Новый Структура;
					СтруктураПараметров.Вставить("Номенклатура", СтрокаНоменклатура.Номенклатура);
					СтруктураПараметров.Вставить("ЕдиницаИзмерения", СтрокаНоменклатура.ЕдиницаИзмерения);
					СтруктураПараметров.Вставить("Характеристика", СтрокаНоменклатура.Характеристика);
					СтруктураПараметров.Вставить("Партия", СтрокаНоменклатура.Партия);
					СтруктураПараметров.Вставить("СтруктурнаяЕдиница", СтрокаНоменклатура.СтруктурнаяЕдиница);
					СтруктураПараметров.Вставить("ЗаказПокупателя", СтрокаЗаказы.ЗаказПокупателя);
					СтруктураПараметров.Вставить("КПереносу", КПереносу);
					СтруктураПараметров.Вставить("ДокументРезерва", ДокументРезерва);
					СтруктураПараметров.Вставить("ДатаПереноса", ДатаПереноса);
					СнятьРезерв(СтруктураПараметров);
					ДобавитьРезервирование(СтруктураПараметров);
					Если ВключитьКонтроль Тогда
						Константы.КонтролироватьОстаткиПриПроведении.Установить(Истина);
					КонецЕсли;
					ЗафиксироватьТранзакцию();
				Исключение
				    ОтменитьТранзакцию();
					Шаблон = НСтР("ru = 'Не удалось выполнить перенос резерва для %1, %2, %3'");
					ОбщегоНазначения.СообщитьПользователю(СтрШаблон(Шаблон, СтрокаНоменклатура.НоменклатураПредставление, СтрокаЗаказы.ЗаказПокупателя, ДокументРезерва));
				КонецПопытки; 
			КонецЦикла; 
		КонецЦикла; 
	КонецЦикла;
	
	ЗаполнитьДанные();
	Выполнено = Истина;
	
КонецПроцедуры

&НаСервере
Процедура СнятьРезерв(СтруктураПараметров)
	
	Документ = СтруктураПараметров.ДокументРезерва.ПолучитьОбъект();
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Номенклатура", СтруктураПараметров.Номенклатура);
	СтруктураОтбора.Вставить("Характеристика", СтруктураПараметров.Характеристика);
	СтруктураОтбора.Вставить("Партия", СтруктураПараметров.Партия);
	КПереносу = СтруктураПараметров.КПереносу;
	Если ТипЗнч(Документ) = Тип("ДокументОбъект.ЗаказПокупателя") 
		И (Документ.ВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаПродажу 
		ИЛИ Документ.ВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаПереработку) Тогда
		// Заказ на продажу или заказ на переработку
		СтруктураОтбора.Вставить("СтруктурнаяЕдиницаРезерв", СтруктураПараметров.СтруктурнаяЕдиница);
		СтрокиТЧ = Документ.Запасы.НайтиСтроки(СтруктураОтбора);
		Для каждого СтрокаТабличнойЧасти Из СтрокиТЧ Цикл
			Перенести = Мин(КПереносу, СтрокаТабличнойЧасти.Резерв);
			Если Перенести <= 0 Тогда
				Продолжить;
			КонецЕсли; 
			СтрокаТабличнойЧасти.Резерв = СтрокаТабличнойЧасти.Резерв - Перенести;
			КПереносу = КПереносу - Перенести;
			Если КПереносу <= 0 Тогда
				Прервать;
			КонецЕсли; 
		КонецЦикла;
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументОбъект.ЗаказПокупателя") 
		И Документ.ВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаряд Тогда
		// Заказ-наряд
		СтруктураОтбора.Вставить("СтруктурнаяЕдиницаРезерв", СтруктураПараметров.СтруктурнаяЕдиница);
		СтрокиТЧ = Документ.Запасы.НайтиСтроки(СтруктураОтбора);
		Для каждого СтрокаТабличнойЧасти Из СтрокиТЧ Цикл
			Перенести = Мин(КПереносу, СтрокаТабличнойЧасти.Резерв - СтрокаТабличнойЧасти.РезервОтгрузка);
			Если Перенести <= 0 Тогда
				Продолжить;
			КонецЕсли; 
			СтрокаТабличнойЧасти.Резерв = СтрокаТабличнойЧасти.Резерв - Перенести;
			КПереносу = КПереносу - Перенести;
			Если КПереносу <= 0 Тогда
				Прервать;
			КонецЕсли; 
		КонецЦикла;
		Если КПереносу > 0 Тогда
			СтрокиТЧ = Документ.Материалы.НайтиСтроки(СтруктураОтбора);
			Для каждого СтрокаТабличнойЧасти Из СтрокиТЧ Цикл
				Перенести = Мин(КПереносу, СтрокаТабличнойЧасти.Резерв - СтрокаТабличнойЧасти.РезервОтгрузка);
				Если Перенести <= 0 Тогда
					Продолжить;
				КонецЕсли; 
				СтрокаТабличнойЧасти.Резерв = СтрокаТабличнойЧасти.Резерв - Перенести;
				КПереносу = КПереносу - Перенести;
				Если КПереносу <= 0 Тогда
					Прервать;
				КонецЕсли; 
			КонецЦикла;
		КонецЕсли; 
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументОбъект.ЗаказНаПроизводство") Тогда
		// Заказ на производство
		Если Документ.ВидОперации = Перечисления.ВидыОперацийЗаказНаПроизводство.Разборка Тогда
			ТабличнаяЧасть = Документ.Продукция;
		Иначе
			ТабличнаяЧасть = Документ.Запасы;
		КонецЕсли; 
		СтруктураОтбора.Вставить("СтруктурнаяЕдиница", СтруктураПараметров.СтруктурнаяЕдиница);
		СтруктураОтбора.Вставить("ЗаказПокупателя", СтруктураПараметров.ЗаказПокупателя);
		СтрокиТЧ = ТабличнаяЧасть.НайтиСтроки(СтруктураОтбора);
		Для каждого СтрокаТабличнойЧасти Из СтрокиТЧ Цикл
			Перенести = Мин(КПереносу, СтрокаТабличнойЧасти.Резерв);
			Если Перенести <= 0 Тогда
				Продолжить;
			КонецЕсли; 
			СтрокаТабличнойЧасти.Резерв = СтрокаТабличнойЧасти.Резерв - Перенести;
			КПереносу = КПереносу - Перенести;
			Если КПереносу <= 0 Тогда
				Прервать;
			КонецЕсли; 
		КонецЦикла;
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументОбъект.РезервированиеЗапасов") Тогда
		// Резервирование запасов
		СтруктураОтбора.Вставить("НовоеМестоРезерва", СтруктураПараметров.СтруктурнаяЕдиница);
		СтрокиКУдалению = Новый Массив;
		СтрокиТЧ = Документ.Запасы.НайтиСтроки(СтруктураОтбора);
		Для каждого СтрокаТабличнойЧасти Из СтрокиТЧ Цикл
			Перенести = Мин(КПереносу, СтрокаТабличнойЧасти.Количество);
			Если Перенести <= 0 Тогда
				Продолжить;
			КонецЕсли; 
			СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.Количество - Перенести;
			Если СтрокаТабличнойЧасти.Количество <= 0 Тогда
				СтрокиКУдалению.Добавить(СтрокаТабличнойЧасти);
			КонецЕсли; 
			КПереносу = КПереносу - Перенести;
			Если КПереносу <= 0 Тогда
				Прервать;
			КонецЕсли; 
		КонецЦикла;
		Для каждого СтрокаТабличнойЧасти Из СтрокиКУдалению Цикл
			Документ.Запасы.Удалить(СтрокаТабличнойЧасти);
		КонецЦикла; 
	Иначе
		Шаблон = НСтр("ru = 'Неподдерживаемый тип документа резервирования: %1'");
		ВызватьИсключение СтрШаблон(Шаблон, СтруктураПараметров.ДокументРезерва);
	КонецЕсли;
	Если КПереносу > 0 Тогда
		Шаблон = НСтр("ru = 'Автоматический перенос не выполнен или выполнен частично, не перенесено %1 %2: %3'");
		ВызватьИсключение СтрШаблон(Шаблон, КПереносу, СтруктураПараметров.ЕдиницаИзмерения, СтруктураПараметров.ДокументРезерва);
	КонецЕсли; 
	Документ.Записать(РежимЗаписиДокумента.Проведение);
	
КонецПроцедуры
 
&НаСервере
Процедура ДобавитьРезервирование(СтруктураПараметров)
	
	Документ = Документы.РезервированиеЗапасов.СоздатьДокумент();
	Документ.Дата = КонецДня(СтруктураПараметров.ДатаПереноса);
	Документ.Организация = Организация;
	Документ.ЗаказПокупателя = СтруктураПараметров.ЗаказПокупателя;
	Документ.Автор = Пользователи.ТекущийПользователь();
	Документ.Комментарий = НСтр("ru = 'Сформировано автоматически. Перенос резерва при закрытии месяца.'");
	НоваяСтрока = Документ.Запасы.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураПараметров);
	НоваяСтрока.Количество = СтруктураПараметров.КПереносу;
	НоваяСтрока.НовоеМестоРезерва = СтруктураПараметров.СтруктурнаяЕдиница;
	Документ.Записать(РежимЗаписиДокумента.Проведение);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СтрокаПоКлючуСвязи(Таблица, КлючСвязи)
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("КлючСвязи", КлючСвязи);
	НайденныеСтроки = Таблица.НайтиСтроки(СтруктураОтбора);
	Если НайденныеСтроки.Количество() = 0 Тогда
		Возврат Неопределено;
	Иначе
		Возврат НайденныеСтроки[0];
	КонецЕсли; 
	
КонецФункции 

&НаКлиенте
Процедура ОбновитьИтогПоЗапасу()
	
	ТекущаяСтрока = Элементы.СписокНоменклатуры.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Перенесено = 0;
	Для каждого СтрокаЗаказа Из Заказы Цикл
		Если СтрокаЗаказа.КлючСвязи <> ТекущаяСтрока.КлючСвязи Тогда
			Продолжить;
		КонецЕсли;
		Перенесено = Перенесено + СтрокаЗаказа.Перенести;
	КонецЦикла;
	ТекущаяСтрока.ПослеПереноса = ТекущаяСтрока.СвободныйОстаток + Перенесено;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВсе(Значение)
	
	Для каждого СтрокаНоменклатура Из СписокНоменклатуры Цикл
		СтрокаНоменклатура.Пометка = Значение;
		СтрокаНоменклатура.ПослеПереноса = ?(Значение, 0, СтрокаНоменклатура.СвободныйОстаток);
	КонецЦикла;
	Для каждого СтрокаЗаказа Из Заказы Цикл
		СтрокаЗаказа.Пометка = Значение;
		СтрокаЗаказа.Перенести = ?(Значение, СтрокаЗаказа.Резерв, 0);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
 


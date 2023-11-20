
#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжиданияАктуализации Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьНачальныеНастройки();
	
	РежимРасшифровки = Параметры.РежимРасшифровки;
	
	Если РежимРасшифровки Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	УправлениеФормой(ЭтаФорма);
	ПредставлениеПериода =ПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода);
	Если ЗначениеЗаполнено(Отчет.Организация) И ЗначениеЗаполнено(Отчет.НачалоПериода)
		И ЗначениеЗаполнено(Отчет.КонецПериода) Тогда
		РезультатВыполнения = СформироватьОтчетНаСервере();
		ЗаданиеВыполнилось = РезультатВыполнения.Статус = "Выполнено";
	Иначе
		ЗаданиеВыполнилось = Истина;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.Страницы.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	ОтчетОбъект = ЭтотОбъект.РеквизитФормыВЗначение("Отчет");
	
	ОтчетМетаданные = ОтчетОбъект.Метаданные();
	
	// Сохранение реквизитов отчета
	ДополнительныеСвойства = Новый Структура;
	Для Каждого Реквизит Из ОтчетМетаданные.Реквизиты Цикл
		Если Реквизит.Имя <> "РежимРасшифровки" Тогда
			ДополнительныеСвойства.Вставить(Реквизит.Имя, ОтчетОбъект[Реквизит.Имя]);
		КонецЕсли;
	КонецЦикла;
	Для Каждого Реквизит Из ОтчетМетаданные.ТабличныеЧасти Цикл
		ДополнительныеСвойства.Вставить(Реквизит.Имя, ОтчетОбъект[Реквизит.Имя].Выгрузить());
	КонецЦикла;  
	
	Настройки.ДополнительныеСвойства.Вставить("ДанныеОтчета", Новый ХранилищеЗначения(ДополнительныеСвойства));
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ЗаданиеВыполнилось Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		
		УстановитьСостояниеТабличныхПолей("ФормированиеОтчета", Элементы, НастройкиПечатныхФорм);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	Если Настройки.ДополнительныеСвойства.Количество() > 0 Тогда
		ДополнительныеСвойства = Настройки.ДополнительныеСвойства.ДанныеОтчета.Получить();
		
		// Восстановление реквизитов отчета.
		Для Каждого ЭлементСтруктуры Из ДополнительныеСвойства Цикл
			
			Если ЭтотОбъект.Отчет.Свойство(ЭлементСтруктуры.Ключ) Тогда
				
				ТипСохраненногоРеквизита = ТипЗнч(ЭлементСтруктуры.Значение);
				
				Если ТипСохраненногоРеквизита = Тип("ТаблицаЗначений") Тогда
					ЭтотОбъект.Отчет[ЭлементСтруктуры.Ключ].Очистить();
					ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ЭлементСтруктуры.Значение, ЭтотОбъект.Отчет[ЭлементСтруктуры.Ключ]);
					Продолжить;
				ИначеЕсли ЭлементСтруктуры.Ключ = "РежимРасшифровки" Тогда
					Продолжить;
				ИначеЕсли ОбщегоНазначения.ЭтоСсылка(ТипСохраненногоРеквизита)
					И Не ОбщегоНазначения.СсылкаСуществует(ЭлементСтруктуры.Значение) Тогда
					// Объект по ссылке был удален, такое значение настройки восстанавливать не нужно.
					Продолжить;
				КонецЕсли;
				
				ЭтотОбъект.Отчет[ЭлементСтруктуры.Ключ] = ЭлементСтруктуры.Значение;
				
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	ПредставлениеПериода =ПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания)
		И НЕ ЗавершениеРаботы Тогда
		
		ОтменитьВыполнениеЗадания();
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНастройкиПечатныхФорм

&НаКлиенте
Процедура НастройкиПечатныхФормПриАктивизацииСтроки(Элемент)
	УстановитьТекущуюСтраницу();
КонецПроцедуры

&НаКлиенте
Процедура НастройкиПечатныхФормПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Функция ТекущаяНастройкаПечатнойФормы()
	Результат = Элементы.НастройкиПечатныхФорм.ТекущиеДанные;
	Если Результат = Неопределено И НастройкиПечатныхФорм.Количество() > 0 Тогда
		Результат = НастройкиПечатныхФорм[0];
	КонецЕсли;
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура УстановитьТекущуюСтраницу()
	
	НастройкаПечатнойФормы = ТекущаяНастройкаПечатнойФормы();
	
	ТекущаяСтраница = Элементы.СтраницаПечатнаяФормаОбразец;
	ПечатнаяФормаДоступна = НастройкаПечатнойФормы <> Неопределено И ЭтотОбъект[НастройкаПечатнойФормы.ИмяРеквизита].ВысотаТаблицы > 0;
	#Если МобильныйКлиент Тогда
		
		Если ПечатнаяФормаДоступна Тогда
			ПараметрыОткрытия = Новый Структура;
			ПараметрыОткрытия.Вставить("Заголовок", НастройкаПечатнойФормы.Представление);
			ПараметрыОткрытия.Вставить("Результат", АдресХранилищаРезультата(НастройкаПечатнойФормы.ИмяРеквизита));
			ОткрытьФорму("ОбщаяФорма.ФормаПредпросмотраОтчета", ПараметрыОткрытия, ЭтаФорма);
			
		Иначе
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Печатная форма недоступна'"));
		КонецЕсли;
		
	#Иначе
		
		Если ПечатнаяФормаДоступна Тогда
			ТекущаяСтраница = Элементы[НастройкаПечатнойФормы.ИмяСтраницы];
		КонецЕсли;
		Элементы.Страницы.ТекущаяСтраница = ТекущаяСтраница;
		
	#КонецЕсли
	
		
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеПериодаПриИзменении(Элемент)
	
	Попытка
		Год = Число(Лев(ПредставлениеПериода, СтрДлина(ПредставлениеПериода)- 3));
		Отчет.НачалоПериода = Дата(Год,1,1);
		Отчет.КонецПериода = КонецГода(Отчет.НачалоПериода);
	Исключение
		
	КонецПопытки;
	
	ПредставлениеПериода =ПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода);
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Направление > 0 Тогда
		Отчет.НачалоПериода = ДобавитьМесяц(Отчет.НачалоПериода, 12);
		Отчет.КонецПериода = ДобавитьМесяц(Отчет.КонецПериода, 12);
	Иначе
		Отчет.НачалоПериода = ДобавитьМесяц(Отчет.НачалоПериода, -12);
		Отчет.КонецПериода = ДобавитьМесяц(Отчет.КонецПериода, -12);
	КонецЕсли;
	ОбновитьТекстЗаголовка(ЭтаФорма);
	ПредставлениеПериода =ПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		УстановитьСостояниеТабличныхПолей("НеАктуальность", Элементы, НастройкиПечатныхФорм);
	КонецЕсли;   
	
	Элементы.РежимПечатиНДС.Доступность = Отчет.ОбъектНалогообложенияУСН = ПредопределенноеЗначение("Перечисление.ВидыОбъектовНалогообложения.ДоходыМинусРасходы");
	
КонецПроцедуры 

&НаКлиенте
Процедура РежимПечатиГраф4и6ПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		
		УстановитьСостояниеТабличныхПолей("НеАктуальность", Элементы, НастройкиПечатныхФорм, Ложь);

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимПечатиНДСПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		
		УстановитьСостояниеТабличныхПолей("НеАктуальность", Элементы, НастройкиПечатныхФорм, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьРасшифровкиПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		
		УстановитьСостояниеТабличныхПолей("НеАктуальность", Элементы, НастройкиПечатныхФорм, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.Статус = "Выполнено" Тогда
		
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		
		УстановитьСостояниеТабличныхПолей("ФормированиеОтчета", Элементы, НастройкиПечатныхФорм);
	КонецЕсли;
	
	КнопкаДействия = ?(Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет, Элементы.Сформировать, Элементы.ПрименитьНастройки);
	КнопкаДействия.КнопкаПоУмолчанию = Истина; 
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
	
КонецПроцедуры 

&НаКлиенте
Процедура ЗакрытьНастройки()

	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	Отчет = Форма.Отчет;
	
	ЗаголовокОтчета = "Книга доходов и расходов за "
					+ ПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода);

	Если ЗначениеЗаполнено(Отчет.Организация) И Форма.ИспользуетсяНесколькоОрганизаций Тогда
		ЗаголовокОтчета = ЗаголовокОтчета 
						+ " "
						+ Отчет.Организация;
	КонецЕсли;
	
	ПредставлениеПериода =ПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода);
	Форма.Заголовок = ЗаголовокОтчета;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы	= Форма.Элементы;
	Отчет		= Форма.Отчет;
	Элементы.ПояснениеРасширенныйНалоговыйПериод.Видимость = ОтчетЗаРасширенныйНалоговыйПериод(Форма);	
	
	Элементы.РежимПечатиНДС.Доступность = Отчет.ОбъектНалогообложенияУСН = ПредопределенноеЗначение("Перечисление.ВидыОбъектовНалогообложения.ДоходыМинусРасходы");
	ЗаполнитьСведенияОНалоговомПериоде(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОтчетЗаРасширенныйНалоговыйПериод(Форма)
	
	Отчет = Форма.Отчет;
	
	Возврат Форма.НалоговыйПериодПропущен
		ИЛИ (Форма.НалоговыйПериодРасширен И Отчет.НачалоПериода = НачалоГода(Отчет.НачалоПериода));
	
КонецФункции

&НаСервере
Функция АдресХранилищаРезультата(ИмяТабличногоДокумента)
	
	Возврат ПоместитьВоВременноеХранилище(ЭтотОбъект[ИмяТабличногоДокумента], УникальныйИдентификатор);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаполнитьСведенияОНалоговомПериоде(Форма)
	
	Элементы	= Форма.Элементы;
	Отчет		= Форма.Отчет;
	Если НЕ ЗначениеЗаполнено(Отчет.Организация) Тогда
		ДатаРегистрации =  '00010101';
	Иначе
		ДатаРегистрации =  ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Отчет.Организация, "ДатаРегистрации");
	КонецЕсли;
	
	
	МинимальныйПериод = НачалоГода(ДатаРегистрации);
	
	Если Отчет.НачалоПериода < МинимальныйПериод Тогда
		// Если при смене организации, восстановлении периода из настроек или инициализации из рабочей даты
		// период отчета оказался в запрещенном интервале, нужно сдвинуть его вперед до ближайшего доступного.
		Отчет.НачалоПериода  = МинимальныйПериод;
		Отчет.КонецПериода   = КонецКвартала(Отчет.НачалоПериода);
	КонецЕсли;
	
	Форма.НалоговыйПериодРасширен = РегламентированнаяОтчетностьУСН.НалоговыйПериодРасширен(Отчет.Организация,
		Отчет.КонецПериода, ДатаРегистрации);
	Форма.НалоговыйПериодПропущен = РегламентированнаяОтчетностьУСН.НалоговыйПериодПропущен(Отчет.Организация,
		Отчет.КонецПериода, ДатаРегистрации);
	
	Если Форма.НалоговыйПериодПропущен Тогда
		Отчет.НачалоПериода = НачалоГода(Отчет.НачалоПериода);
	КонецЕсли;
	
	Форма.НачалоНалоговогоПериода = ?(Форма.НалоговыйПериодРасширен, НачалоДня(ДатаРегистрации), НачалоГода(Отчет.КонецПериода));
	
	Элементы.ПояснениеРасширенныйНалоговыйПериод.Заголовок = ПояснениеПереносНалоговогоПериода(Форма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПояснениеПереносНалоговогоПериода(Форма)
	
	Отчет		= Форма.Отчет;
	НачалоНалоговогоПериода = Форма.НачалоНалоговогоПериода;
	Если Форма.НалоговыйПериодПропущен Тогда
		
		ГодОтчета = Год(Отчет.КонецПериода);
		
		ШаблонПодсказки = НСтр("ru = 'Книгу доходов и расходов за %1 год формировать не нужно. Период с даты регистрации %2 по %3 включается в отчет за %4 год.'");
		
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонПодсказки,
			Формат(ГодОтчета, "ЧГ=0"),
			Формат(НачалоНалоговогоПериода, "ДФ=dd.MM.yyyy"),
			Формат(КонецГода(НачалоНалоговогоПериода), "ДФ=dd.MM.yyyy"),
			Формат(ГодОтчета + 1, "ЧГ=0"));
		
	ИначеЕсли Форма.НалоговыйПериодРасширен Тогда
		
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Период с даты регистрации %1 по %2 включается в отчет за %3'"),
				Формат(НачалоНалоговогоПериода, "ДФ=dd.MM.yyyy"),
				Формат(КонецГода(НачалоНалоговогоПериода), "ДФ=dd.MM.yyyy"),
				Форма.ПредставлениеПериода);
		
	Иначе
		
		Возврат "";
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура УстановитьНачальныеНастройки()
	
	Если ЗначениеЗаполнено(Параметры.Организация) Тогда
		Отчет.Организация = Параметры.Организация;
	Иначе
		Отчет.Организация = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.ТекущийПользователь(), "ОсновнаяОрганизация");
		Если Не ЗначениеЗаполнено(Отчет.Организация) Тогда
			Отчет.Организация = Справочники.Организации.ПредопределеннаяОрганизация();
		КонецЕсли;
	КонецЕсли;
	
	ВидПериода = Перечисления.ДоступныеПериодыОтчета.Год;
	
	Если ЗначениеЗаполнено(Параметры.НачалоПериода) И ЗначениеЗаполнено(Параметры.КонецПериода) Тогда
		Отчет.НачалоПериода = НачалоКвартала(Параметры.НачалоПериода);
		Отчет.КонецПериода  = КонецКвартала(Параметры.КонецПериода);
		// отчет может формироваться только за квартал, либо с начала года
		Если Отчет.НачалоПериода <> НачалоКвартала(Отчет.КонецПериода) Тогда
			Отчет.НачалоПериода = НачалоГода(Отчет.КонецПериода);
		КонецЕсли;
	Иначе
		ТекущаяДата = ТекущаяДатаСеанса();
		Отчет.НачалоПериода = НачалоГода(ТекущаяДата);
		Отчет.КонецПериода  = КонецГода(ТекущаяДата);
	КонецЕсли;
	
	Отчет.РежимПечатиГраф4и6	= 3;
	Отчет.РежимПечатиНДС		= 2;
	
	ПараметрыОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Отчет.Организация, Отчет.НачалоПериода, "ОбъектНалогообложенияУСН");
	Если ПараметрыОрганизации.ОбъектНалогообложенияУСН = 1 Тогда
		Отчет.ОбъектНалогообложенияУСН = Перечисления.ВидыОбъектовНалогообложения.Доходы;
	ИначеЕсли ПараметрыОрганизации.ОбъектНалогообложенияУСН = 2 Тогда
		Отчет.ОбъектНалогообложенияУСН		= Перечисления.ВидыОбъектовНалогообложения.ДоходыМинусРасходы;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПечатнаяФормаОбразец, "НеАктуальность");
	
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьПараметрыОтчета()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("ВыводитьРасшифровки"               , Отчет.ВыводитьРасшифровки);
	ПараметрыОтчета.Вставить("Организация"                       , Отчет.Организация);
	ПараметрыОтчета.Вставить("НачалоПериода"                     , Отчет.НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода"                      , Отчет.КонецПериода);
	ПараметрыОтчета.Вставить("Период"                            , Отчет.КонецПериода);
	ПараметрыОтчета.Вставить("ОбъектНалогообложенияУСН"          , Отчет.ОбъектНалогообложенияУСН);
	ПараметрыОтчета.Вставить("РежимПечатиГраф4и6"                , Отчет.РежимПечатиГраф4и6);
	ПараметрыОтчета.Вставить("РежимПечатиНДС"                    , Отчет.РежимПечатиНДС);
	ПараметрыОтчета.Вставить("СписокСформированныхЛистов"        , Отчет.СписокСформированныхЛистов);
	ПараметрыОтчета.Вставить("НалоговыйПериодРасширен",          НалоговыйПериодРасширен);
	ПараметрыОтчета.Вставить("НачалоНалоговогоПериода",          НачалоНалоговогоПериода);
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаСервере
Функция СформироватьОтчетНаСервере()
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	УстановитьСостояниеТабличныхПолей("НеИспользовать", Элементы, НастройкиПечатныхФорм);
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Отчеты.КнигаУчетаДоходовИРасходов.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("Статус", "Выполнено");
	Иначе
		НаименованиеЗадания = "КнигаУчетаДоходовИРасходов";
		ИмяПроцедуры = "Отчеты.КнигаУчетаДоходовИРасходов.СформироватьОтчет";
		
		ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
		ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
		ПараметрыВыполнения.ОжидатьЗавершение = 0;
		ПараметрыВыполнения.ЗапуститьВФоне = Истина;
		РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыОтчета, ПараметрыВыполнения);
		
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
		АдресХранилища       = РезультатВыполнения.АдресРезультата;
	КонецЕсли;
	
	Если РезультатВыполнения.Статус = "Выполнено" Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	// Очистить
	ДобавленныеРеквизитыФормы = Новый Массив;
	Для Каждого СтраницаОтчета Из НастройкиПечатныхФорм Цикл
		ИмяРеквизита = СтраницаОтчета.ИмяРеквизита;
		ДобавленныеРеквизитыФормы.Добавить(ИмяРеквизита);
		Элементы.Удалить(Элементы["Страница" + ИмяРеквизита]);
	КонецЦикла;
	ИзменитьРеквизиты(, ДобавленныеРеквизитыФормы);	
	
	НастройкиПечатныхФорм.Очистить();
		
	Отчет.СписокСформированныхЛистов = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	// Создание реквизитов для табличных документов.
	НовыеРеквизитыФормы = Новый Массив;
	Для НомерПечатнойФормы = 1 По Отчет.СписокСформированныхЛистов.Количество() Цикл
		ИмяРеквизита = "ПечатнаяФорма" + Формат(НомерПечатнойФормы,"ЧГ=0");
		РеквизитФормы = Новый РеквизитФормы(ИмяРеквизита, Новый ОписаниеТипов("ТабличныйДокумент"),,Отчет.СписокСформированныхЛистов[НомерПечатнойФормы - 1].Представление);
		НовыеРеквизитыФормы.Добавить(РеквизитФормы);
	КонецЦикла;
	ИзменитьРеквизиты(НовыеРеквизитыФормы);
	
	// Создание страниц с табличными документами на форме.
	НомерПечатнойФормы = 0;
	ДобавленныеНастройкиПечатныхФорм = Новый Соответствие;
	Для Каждого РеквизитФормы Из НовыеРеквизитыФормы Цикл
		ОписаниеПечатнойФормы = Отчет.СписокСформированныхЛистов[НомерПечатнойФормы];
		
		// Таблица настроек печатных форм (начало).
		НоваяНастройкаПечатнойФормы = НастройкиПечатныхФорм.Добавить();
		НоваяНастройкаПечатнойФормы.Представление = ОписаниеПечатнойФормы.Представление;
		НоваяНастройкаПечатнойФормы.Печатать = Истина;
		НоваяНастройкаПечатнойФормы.Количество = 1;
		НоваяНастройкаПечатнойФормы.ИмяМакета = ОписаниеПечатнойФормы.Представление;
		НоваяНастройкаПечатнойФормы.ПозицияПоУмолчанию = НомерПечатнойФормы;
		НоваяНастройкаПечатнойФормы.Название = ОписаниеПечатнойФормы.Представление;
		НоваяНастройкаПечатнойФормы.ПутьКМакету = "";
		НоваяНастройкаПечатнойФормы.ИмяФайлаПечатнойФормы = ОбщегоНазначения.ЗначениеВСтрокуXML(ОписаниеПечатнойФормы.Представление);
		
		РанееДобавленнаяНастройкаПечатнойФормы = ДобавленныеНастройкиПечатныхФорм[ОписаниеПечатнойФормы.Представление];
		Если РанееДобавленнаяНастройкаПечатнойФормы = Неопределено Тогда
			// Копирование табличного документа в реквизит формы.
			ИмяРеквизита = РеквизитФормы.Имя;
			ЭтотОбъект[ИмяРеквизита] = ОписаниеПечатнойФормы.Значение;
			
			// Создание страниц для табличных документов.
			ИмяСтраницы = "Страница" + ИмяРеквизита;
			Страница = Элементы.Добавить(ИмяСтраницы, Тип("ГруппаФормы"), Элементы.Страницы);
			Страница.Вид = ВидГруппыФормы.Страница;
			Страница.Картинка = БиблиотекаКартинок.ТабличныйДокументВставитьРазрывСтраницы;
			Страница.Заголовок = ОписаниеПечатнойФормы.Представление;
			Страница.Подсказка = ОписаниеПечатнойФормы.Представление;
			Страница.Видимость = ЭтотОбъект[ИмяРеквизита].ВысотаТаблицы > 0;
			
			// Создание элементов под табличные документы.
			НовыйЭлемент = Элементы.Добавить(ИмяРеквизита, Тип("ПолеФормы"), Страница);
			НовыйЭлемент.Вид = ВидПоляФормы.ПолеТабличногоДокумента;
			НовыйЭлемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
			НовыйЭлемент.ПутьКДанным = ИмяРеквизита;
			НовыйЭлемент.Редактирование = Не ОписаниеПечатнойФормы.Значение.ТолькоПросмотр;
			НовыйЭлемент.Защита = ОписаниеПечатнойФормы.Значение.Защита;
			
			// Таблица настроек печатных форм (продолжение).
			НоваяНастройкаПечатнойФормы.ИмяСтраницы = ИмяСтраницы;
			НоваяНастройкаПечатнойФормы.ИмяРеквизита = ИмяРеквизита;
			
			ДобавленныеНастройкиПечатныхФорм.Вставить(НоваяНастройкаПечатнойФормы.ИмяМакета, НоваяНастройкаПечатнойФормы);
		Иначе
			НоваяНастройкаПечатнойФормы.ИмяСтраницы = РанееДобавленнаяНастройкаПечатнойФормы.ИмяСтраницы;
			НоваяНастройкаПечатнойФормы.ИмяРеквизита = РанееДобавленнаяНастройкаПечатнойФормы.ИмяРеквизита;
		КонецЕсли;
		
		НомерПечатнойФормы = НомерПечатнойФормы + 1;
	КонецЦикла;
	
	ИдентификаторЗадания = Неопределено;
	
	УстановитьСостояниеТабличныхПолей("НеИспользовать", Элементы, НастройкиПечатныхФорм);
	
КонецПроцедуры

&НаСервере
Функция ПоместитьТабличныеДокументыВоВременноеХранилище(НастройкиСохранения)
	Перем ЗаписьZipФайла, ИмяАрхива;
	
	Результат = Новый Массив;
	
	// подготовка архива
	Если НастройкиСохранения.УпаковатьВАрхив Тогда
		ИмяАрхива = ПолучитьИмяВременногоФайла("zip");
		ЗаписьZipФайла = Новый ЗаписьZipФайла(ИмяАрхива);
	КонецЕсли;
	
	// подготовка временной папки
	ИмяВременнойПапки = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ИмяВременнойПапки);
	ИспользованныеИменаФайлов = Новый Соответствие;
	
	ВыбранныеФорматыСохранения = НастройкиСохранения.ФорматыСохранения;
	ТаблицаФорматов = УправлениеПечатью.НастройкиФорматовСохраненияТабличногоДокумента();
	
	ПрефиксИмени = НСтр("ru = 'КУДиР '") + Отчеты.КнигаУчетаДоходовИРасходов.ПолучитьПредставлениеПериода(КонецКвартала(Отчет.КонецПериода));
	ПрефиксИмени = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ПрефиксИмени);
	
	// сохранение печатных форм
	ОбработанныеПечатныеФормы = Новый Массив;
	Для Каждого НастройкаПечатнойФормы Из НастройкиПечатныхФорм Цикл
		
		Если Не НастройкаПечатнойФормы.Печатать Тогда
			Продолжить;
		КонецЕсли;
		
		ПечатнаяФорма = ЭтотОбъект[НастройкаПечатнойФормы.ИмяРеквизита];
		Если ОбработанныеПечатныеФормы.Найти(ПечатнаяФорма) = Неопределено Тогда
			ОбработанныеПечатныеФормы.Добавить(ПечатнаяФорма);
		Иначе
			Продолжить;
		КонецЕсли;
		
		Если ПечатнаяФорма.ВысотаТаблицы = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ТипФайла Из ВыбранныеФорматыСохранения Цикл
			НастройкиФормата = ТаблицаФорматов.НайтиСтроки(Новый Структура("ТипФайлаТабличногоДокумента", ТипФайлаТабличногоДокумента[ТипФайла]))[0];
			
			ИмяФайла = ПрефиксИмени + " " + НастройкаПечатнойФормы.ИмяМакета;
			ИмяФайла = ИмяФайла + "." + НастройкиФормата.Расширение;
			ИмяФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайла);
			
			ПолноеИмяФайла = УникальноеИмяФайла(ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяВременнойПапки) + ИмяФайла);
			ПечатнаяФорма.Записать(ПолноеИмяФайла, ТипФайла);
			
			Если ТипФайла = ТипФайлаТабличногоДокумента.HTML Тогда
				ВставитьКартинкиВHTML(ПолноеИмяФайла);
			КонецЕсли;
			
			Если ЗаписьZipФайла <> Неопределено Тогда 
				ЗаписьZipФайла.Добавить(ПолноеИмяФайла);
			Иначе
				ДвоичныеДанные = Новый ДвоичныеДанные(ПолноеИмяФайла);
				ПутьВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ЭтотОбъект.УникальныйИдентификатор);
				ОписаниеФайла = Новый Структура;
				ОписаниеФайла.Вставить("Представление", ИмяФайла);
				ОписаниеФайла.Вставить("АдресВоВременномХранилище", ПутьВоВременномХранилище);
				Если ТипФайла = ТипФайлаТабличногоДокумента.ANSITXT Тогда
					ОписаниеФайла.Вставить("Кодировка", "windows-1251");
				КонецЕсли;
				Результат.Добавить(ОписаниеФайла);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	// Если архив подготовлен, записываем и помещаем его во временное хранилище.
	Если ЗаписьZipФайла <> Неопределено Тогда 
		ЗаписьZipФайла.Записать();
		ФайлАрхива = Новый Файл(ИмяАрхива);
		ДвоичныеДанные = Новый ДвоичныеДанные(ИмяАрхива);
		ПутьВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ЭтотОбъект.УникальныйИдентификатор);
		ОписаниеФайла = Новый Структура;
		Если Прав(ПрефиксИмени, 1) = "." Тогда
			ИмяФайлаАрхива = ПрефиксИмени + "zip"
		Иначе
			ИмяФайлаАрхива = ПрефиксИмени + ".zip"
		КонецЕсли;
		ОписаниеФайла.Вставить("Представление", ИмяФайлаАрхива);
		ОписаниеФайла.Вставить("АдресВоВременномХранилище", ПутьВоВременномХранилище);
		Результат.Добавить(ОписаниеФайла);
	КонецЕсли;
	
	УдалитьФайлы(ИмяВременнойПапки);
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция УникальноеИмяФайла(ИмяФайла)
	
	Файл = Новый Файл(ИмяФайла);
	ИмяБезРасширения = Файл.ИмяБезРасширения;
	Расширение = Файл.Расширение;
	Папка = Файл.Путь;
	
	Счетчик = 1;
	Пока Файл.Существует() Цикл
		Счетчик = Счетчик + 1;
		Файл = Новый Файл(Папка + ИмяБезРасширения + " (" + Счетчик + ")" + Расширение);
	КонецЦикла;
	
	Возврат Файл.ПолноеИмя;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСостояниеТабличныхПолей(Состояние, Элементы, НастройкиПечатныхФорм = Неопределено, УстановитьДляОбразца = Истина)
	
	Если УстановитьДляОбразца Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПечатнаяФормаОбразец, Состояние);
	КонецЕсли;
	
	Если НастройкиПечатныхФорм <> Неопределено Тогда
		Для Каждого РазделОтчета Из НастройкиПечатныхФорм Цикл
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы[РазделОтчета.ИмяРеквизита], Состояние);
		КонецЦикла;	
	КонецЕсли;
	
КонецПроцедуры	
	
&НаСервере
Процедура ВставитьКартинкиВHTML(ИмяФайлаHTML)
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.Прочитать(ИмяФайлаHTML, КодировкаТекста.UTF8);
	ТекстHTML = ТекстовыйДокумент.ПолучитьТекст();
	
	ФайлHTML = Новый Файл(ИмяФайлаHTML);
	
	ИмяПапкиКартинок = ФайлHTML.ИмяБезРасширения + "_files";
	ПутьКПапкеКартинок = СтрЗаменить(ФайлHTML.ПолноеИмя, ФайлHTML.Имя, ИмяПапкиКартинок);
	
	// Ожидается, что в папке будут только картинки.
	ФайлыКартинок = НайтиФайлы(ПутьКПапкеКартинок, "*");
	
	Для Каждого ФайлКартинки Из ФайлыКартинок Цикл
		КартинкаТекстом = Base64Строка(Новый ДвоичныеДанные(ФайлКартинки.ПолноеИмя));
		КартинкаТекстом = "data:image/" + Сред(ФайлКартинки.Расширение,2) + ";base64," + Символы.ПС + КартинкаТекстом;
		
		ТекстHTML = СтрЗаменить(ТекстHTML, ИмяПапкиКартинок + "\" + ФайлКартинки.Имя, КартинкаТекстом);
	КонецЦикла;
		
	ТекстовыйДокумент.УстановитьТекст(ТекстHTML);
	ТекстовыйДокумент.Записать(ИмяФайлаHTML, КодировкаТекста.UTF8);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанные();
			
			УстановитьСостояниеТабличныхПолей("НеИспользовать", Элементы, НастройкиПечатныхФорм);
		Иначе
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				1, 
				Истина);
		КонецЕсли;
	Исключение
		
		УстановитьСостояниеТабличныхПолей("НеИспользовать", Элементы, НастройкиПечатныхФорм);
		
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ОтменитьВыполнениеЗадания()
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаСервере
Функция ТабличныеДокументыДляПечати(ВыбранноеЗначение = Неопределено)
	
	Если ВыбранноеЗначение = Неопределено Тогда
		ВыбранноеЗначение = НастройкиПечатныхФорм;
	КонецЕсли;
	
	ТабличныеДокументы = Новый СписокЗначений;
	
	Для Каждого НастройкаПечатнойФормы Из ВыбранноеЗначение Цикл
		Если НастройкаПечатнойФормы.Печатать Тогда
			ПечатнаяФорма = ЭтотОбъект[НастройкаПечатнойФормы.ИмяРеквизита];
			ТабличныйДокумент = Новый ТабличныйДокумент;
			ТабличныйДокумент.Вывести(ПечатнаяФорма);
			ЗаполнитьЗначенияСвойств(ТабличныйДокумент, ПечатнаяФорма, "АвтоМасштаб,Вывод,ВысотаСтраницы,ДвусторонняяПечать,Защита,ИмяПринтера,КодЯзыкаМакета,КоличествоЭкземпляров,МасштабПечати,ОриентацияСтраницы,ПолеСверху,ПолеСлева,ПолеСнизу,ПолеСправа,РазборПоКопиям,РазмерКолонтитулаСверху,РазмерКолонтитулаСнизу,РазмерСтраницы,ТочностьПечати,ЧерноБелаяПечать,ШиринаСтраницы,ЭкземпляровНаСтранице");
			ТабличныйДокумент.КоличествоЭкземпляров = НастройкаПечатнойФормы.Количество;
			ТабличныеДокументы.Добавить(ТабличныйДокумент, НастройкаПечатнойФормы.Представление);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТабличныеДокументы;
КонецФункции

&НаКлиенте
Процедура Печать(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НастройкиПечатныхФорм", НастройкиПечатныхФорм);
	ОткрытьФорму("Отчет.КнигаУчетаДоходовИРасходов.Форма.ФормаВыбораРазделов", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ПриПодключенииРасширения", ЭтотОбъект);
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПодключенииРасширения(РасширениеПодключено, ДополнительныеПараметры) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОбъектыПечати", Новый СписокЗначений);
	ПараметрыФормы.Вставить("РасширениеДляРаботыСФайламиПодключено", РасширениеПодключено);
	ОткрытьФорму("ОбщаяФорма.СохранениеПечатнойФормы", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.СохранениеПечатнойФормы") Тогда
		
		Если ВыбранноеЗначение <> Неопределено И ВыбранноеЗначение <> КодВозвратаДиалога.Отмена Тогда
			ФайлыВоВременномХранилище = ПоместитьТабличныеДокументыВоВременноеХранилище(ВыбранноеЗначение);
			СохранитьПечатныеФормыВПапку(ФайлыВоВременномХранилище, ВыбранноеЗначение.ПапкаДляСохранения);			
		КонецЕсли;
		
	ИначеЕсли ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Отчет.КнигаУчетаДоходовИРасходов.Форма.ФормаВыбораРазделов") Тогда
		
		Если ВыбранноеЗначение <> Неопределено И ВыбранноеЗначение <> КодВозвратаДиалога.Отмена Тогда
			
			ТабличныеДокументы = ТабличныеДокументыДляПечати(ВыбранноеЗначение);
	    	УправлениеПечатьюКлиент.РаспечататьТабличныеДокументы(ТабличныеДокументы, Новый СписокЗначений,
				ТабличныеДокументы.Количество() > 1);
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПечатныеФормыВПапку(СписокФайловВоВременномХранилище, Знач Папка = "")
	
	#Если ВебКлиент ИЛИ МобильныйКлиент Тогда
		Для Каждого ФайлДляЗаписи Из СписокФайловВоВременномХранилище Цикл
			ПолучитьФайл(ФайлДляЗаписи.АдресВоВременномХранилище, ФайлДляЗаписи.Представление);
		КонецЦикла;
		Возврат;
	#КонецЕсли
	
	Папка = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(Папка);
	Для Каждого ФайлДляЗаписи Из СписокФайловВоВременномХранилище Цикл
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ФайлДляЗаписи.АдресВоВременномХранилище);
		ДвоичныеДанные.Записать(УникальноеИмяФайла(Папка + ФайлДляЗаписи.Представление));
	КонецЦикла;
	
	Состояние(НСтр("ru = 'Сохранение успешно завершено'"), , НСтр("ru = 'в папку:'") + " " + Папка);
	
КонецПроцедуры

#КонецОбласти

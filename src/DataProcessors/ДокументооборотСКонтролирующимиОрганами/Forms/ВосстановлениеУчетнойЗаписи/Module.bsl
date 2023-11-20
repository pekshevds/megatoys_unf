&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		
		Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		
			Модуль = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации");
			Организация = Модуль.ОрганизацияПоУмолчанию();
			
		Иначе
			Организация = ЭлектронныйДокументооборотСКонтролирующимиОрганамиПереопределяемый.ОсновнаяОрганизация();
		КонецЕсли;
	КонецЕсли;
	
	НастройкаПользователей();
		
	УправлениеФормой(ЭтаФорма);
	
	УправлениеКнопкамиНавигации(ЭтаФорма);
	
	ЗаполнитьДанныеСлужбыПоддержки(ЭтаФорма);
	
	Элементы.ПояснениеПоЭПВМоделиСервиса.Видимость = 
		ЭлектроннаяПодписьВМоделиСервисаКлиентСервер.ИспользованиеВозможно()
		ИЛИ КриптографияЭДКО.ИспользованиеОблачнойПодписиВозможно();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ЭтоЗаписьФизЛица = СтрНайти(ИмяСобытия, "Запись_ФизическиеЛица");
	Если ЭтоЗаписьФизЛица Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("ФизическоеЛицо", Параметр);
		
		НайденныеСтроки = ПользователиМультирежима.НайтиСтроки(Отбор);
		Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			ПроверитьПользователяМультирежима(НайденнаяСтрока, Организация);
		КонецЦикла;
		
	КонецЕсли;
	
	ЭтоЗаписьПользователя = СтрНайти(ИмяСобытия, "Запись_Пользователи");
	Если ЭтоЗаписьПользователя Тогда
		
		ФизЛицо = МультирежимВызовСервера.ФизЛицоПоПользователюИзСправочникаПользователи(Источник);
		
		Отбор = Новый Структура();
		Отбор.Вставить("Пользователь", Источник);
		
		НайденныеСтроки = ПользователиМультирежима.НайтиСтроки(Отбор);
		Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			НайденнаяСтрока.ФизическоеЛицо = ФизЛицо;
			ПроверитьПользователяМультирежима(НайденнаяСтрока, Организация);
		КонецЦикла;
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ПользователиМультирежимаПользовательПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ПользователиМультирежима.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьПользователяМультирежима(ТекущиеДанные, Организация);

КонецПроцедуры

&НаКлиенте
Процедура ПользователиМультирежимаПользовательСоздание(Элемент, СтандартнаяОбработка)
	
	ДополнительныеПараметры = Новый Структура();
	
	ТекущиеДанные = Элементы.ПользователиМультирежима.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ДополнительныеПараметры.Вставить("Наименование", ТекущиеДанные.ФИО);
		ДополнительныеПараметры.Вставить("ФизическоеЛицо", ТекущиеДанные.ФизическоеЛицо);
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура("ЗначенияЗаполнения", ДополнительныеПараметры);
	
	ОткрытьФорму(
		"Справочник.Пользователи.ФормаОбъекта",
		ЗначенияЗаполнения,
		ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КоманднаяПанельМастерНазад(Команда)
	
	Элементы.ОсновнаяПанель.ТекущаяСтраница = Элементы.СтраницаВыборОрганизации;
	УправлениеКнопкамиНавигации(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Функция ИдентификаторАбонентаУказанКорректно()

	МастерДалее = Истина;
	
	Если Не ЗначениеЗаполнено(ИдентификаторАбонента) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Укажите идентификатор абонента'"), ,"ИдентификаторАбонента");
		МастерДалее = Ложь;
	ИначеЕсли СтрДлина(ИдентификаторАбонента) <> 36 И СтрДлина(ИдентификаторАбонента) <> 39 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Указан некорректный идентификатор абонента'"), ,"ИдентификаторАбонента");
		МастерДалее = Ложь;
	КонецЕсли;
	
	Возврат МастерДалее; 

КонецФункции

&НаКлиенте
Процедура КоманднаяПанельМастерДалее(Команда)
	
	ТекущаяСтраница = Элементы.ОсновнаяПанель.ТекущаяСтраница;
	ОчиститьСообщения();
	
	Если ТекущаяСтраница = Элементы.СтраницаВыборОрганизации Тогда
		
		Если НЕ ИдентификаторАбонентаУказанКорректно() Тогда
			Возврат;
		КонецЕсли;
		
		ЭтоМультиРежим = МультирежимВызовСервера.ЭтоМультиРежимПоИдентификаторуАбонента(ИдентификаторАбонента());
		
		Если ЭтоМультиРежим Тогда
			ЗаполнитьТаблицуПользователиМультирежима();
		Иначе
			ВыполнитьНастройкуУчетнойЗаписи();
		КонецЕсли;
		
	ИначеЕсли ТекущаяСтраница = Элементы.СтраницаВыборПользователей Тогда
		
		Если ЭтоМультиРежим Тогда
			
			Корректны = ПользователиМультирежимаУказаныКорректно(Истина);
			Если Корректны Тогда
				ВыполнитьНастройкуУчетнойЗаписи();
			КонецЕсли;
			
		Иначе
			ОбновитьПользователейУчетнойЗаписи1ПРежим(Истина);
		КонецЕсли;
				
	Иначе
		
		ПоказатьСледующуюСтраницу();
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастройкаПользователей()
	
	СписокПользователей.Очистить();
	СписокПользователей = Мультирежим.ПользователиУчетнойЗаписи(
		Справочники.УчетныеЗаписиДокументооборота.ПустаяСсылка(), 
		Истина);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		Элементы.Организация.ТолькоПросмотр = Истина; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеКнопкамиНавигации(Форма)
	
	Элементы = Форма.Элементы;
	
	ТекущаяСтраница 		= Элементы.ОсновнаяПанель.ТекущаяСтраница;
	ИндексТекущейСтраницы 	= Элементы.ОсновнаяПанель.ПодчиненныеЭлементы.Индекс(ТекущаяСтраница);
	ВсегоСтраниц 			= Элементы.ОсновнаяПанель.ПодчиненныеЭлементы.Количество();
		
	КнопкаДалее	  = Элементы.Далее;
	КнопкаНазад   = Элементы.Назад;
	КнопкаЗакрыть = Элементы.Закрыть;
	
	КнопкаДалее.Заголовок = НСтр("ru = 'Далее>'");
	КнопкаДалее.Видимость = Истина;
	КнопкаНазад.Заголовок = НСтр("ru = '<Назад'");
	КнопкаНазад.Видимость = Истина;
	КнопкаЗакрыть.Заголовок = НСтр("ru = 'Отмена'");
	
	Если ИндексТекущейСтраницы = 0 Тогда
		
		КнопкаДалее.Видимость 				= Истина;
		КнопкаНазад.Видимость 				= Ложь;
		КнопкаДалее.КнопкаПоУмолчанию 		= Истина;
		
	ИначеЕсли ИндексТекущейСтраницы = ВсегоСтраниц - 1 Тогда
		//последняя закладка
		
		ЕстьПроблема = Элементы.СтраницыРезультата.ТекущаяСтраница = Элементы.СтраницаРезультатОшибка;

		КнопкаДалее.Видимость = Ложь;
		КнопкаНазад.Видимость = ЕстьПроблема;
		
		Если НЕ ЕстьПроблема Тогда 
			КнопкаЗакрыть.Заголовок 			= НСтр("ru = 'Закрыть'");
			КнопкаЗакрыть.КнопкаПоУмолчанию 	= Истина;
		КонецЕсли;
		
	Иначе	
		//все остальные закладки
		КнопкаНазад.Видимость 				= Истина;
		КнопкаДалее.Видимость 				= Истина;
		КнопкаДалее.КнопкаПоУмолчанию 		= Истина;	
	КонецЕсли;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьДанныеСлужбыПоддержки(Форма)

	Форма.ТелефонСлужбыПоддержки = "";
	Форма.АдресЭлектроннойПочтыСлужбыПоддержки = "";

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьНастройкуУчетнойЗаписи()
	
	ДатаПолученияОтвета = КонтекстЭДОКлиент.ТекущаяДатаНаСервере();
	// Создание учетной записи 
	ПараметрыОбработатьОбновление = КонтекстЭДОКлиент.ПараметрыОбработатьОбновление();
	
	ПараметрыОбработатьОбновление.ИдентификаторАбонента          = ИдентификаторАбонента();
	ПараметрыОбработатьОбновление.СпецОператорСвязи              = ПредопределенноеЗначение("Перечисление.СпецоператорыСвязи.КалугаАстрал");
	ПараметрыОбработатьОбновление.ПутьКонтейнерЗакрытогоКлюча    = ПутьКонтейнерЗакрытогоКлюча;
	ПараметрыОбработатьОбновление.Организация                    = Организация;
	
	ПараметрыОбработатьОбновление.ВызовИзМастераПодключенияК1СОтчетности = Истина;
	
	Если ЭтоМультиРежим Тогда
		ДобавитьВПараметрыПользователейМультирежима(ПараметрыОбработатьОбновление);
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура("ПараметрыОбработатьОбновление", ПараметрыОбработатьОбновление);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьНастройкуУчетнойЗаписиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	КонтекстЭДОКлиент.ОбработатьОбновление(ПараметрыОбработатьОбновление, ОписаниеОповещения);
		
КонецПроцедуры

&НаСервере
Процедура ДобавитьВПараметрыПользователейМультирежима(ПараметрыОбработатьОбновление)
	
	Таблица = ПользователиМультирежима.Выгрузить(, "ВладелецЭЦПСНИЛС, Пользователь, ФизическоеЛицо");
	
	Отбор = Новый Структура();
	Отбор.Вставить("Пользователь", Справочники.Пользователи.ПустаяСсылка());
	
	ПустыеСтроки = Таблица.НайтиСтроки(Отбор);
		
	Для каждого ПустаяСтроки Из ПустыеСтроки Цикл
		Таблица.Удалить(ПустаяСтроки);
	КонецЦикла;
	
	Адрес = ПоместитьВоВременноеХранилище(Таблица, УникальныйИдентификатор);
	
	ПараметрыОбработатьОбновление.АдресПользователиМультирежима = Адрес;
	
КонецПроцедуры

&НаСервере
Функция ИдентификаторАбонента()

	Возврат ДокументооборотСКО.ИдентификаторАбонентаДляЗапросаРегФайла(ИдентификаторАбонента);

КонецФункции 

&НаКлиенте
Процедура ВыполнитьНастройкуУчетнойЗаписиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ПараметрыОбработатьОбновление = Результат.ПараметрыФункции;
	РезультатОбновления = Результат.РезультатОбновления;
	
	МастерДалее = Истина;
	Если РезультатОбновления = Истина Тогда
		
		УчетнаяЗапись = КонтекстЭДОКлиент.НоваяУчетнаяЗапись;
		
		Если ЭтоМультиРежим Тогда
			СоздатьПриглашенияПользователей1СОтчетности();
			ПоказатьСтраницуУспех();
		Иначе
			ОбновитьПользователейУчетнойЗаписи1ПРежим();
			МастерДалее = Ложь;
		КонецЕсли;
		
		СохранитьСостояниеПФР();
		
	ИначеЕсли РезультатОбновления = Ложь Тогда
		
		ПоказатьСтраницуОшибка(ПараметрыОбработатьОбновление.ТекстОшибокДляМастераПодключенияК1СОтчетности);
		МастерДалее = Ложь;
		
	КонецЕсли;
	
	Если МастерДалее Тогда
		ПоказатьСледующуюСтраницу();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьСостояниеПФР()
	
	// Если восстановили учетную запись, то считаем, что заявление и сертификат были 
	// отправлены из другой базы, а поэтому не предлагаем в этой базе.
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.УстановитьСостояниеПодключенияКЭДОсПФР(Организация, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПользователейУчетнойЗаписи1ПРежим(НепосредственноОбновить = Ложь)
	
	Если СписокПользователей.Количество() <= 1 ИЛИ НепосредственноОбновить Тогда
		ДействияПослеВыбораПользователей1ПРежим(НепосредственноОбновить);
		ПоказатьСледующуюСтраницу();
	Иначе 
		ПоказатьСтраницуВыбораПользователей1ПРежим();
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПоказатьСтраницуВыбораПользователейМультирежима()
	
	Элементы.ОсновнаяПанель.ТекущаяСтраница = Элементы.СтраницаВыборПользователей;
	Элементы.РежимОтчетности.ТекущаяСтраница = Элементы.Мульти;
	УправлениеКнопкамиНавигации(ЭтаФорма);
		
КонецПроцедуры

&НаСервере
Процедура ПоказатьСтраницуОшибка(ТекстОшибки = "")
	
	ПодробноеОписаниеОшибки = ТекстОшибки;
		
	Элементы.ОсновнаяПанель.ТекущаяСтраница = Элементы.СтраницаРезультат;
	Элементы.СтраницыРезультата.ТекущаяСтраница = Элементы.СтраницаРезультатОшибка;
	
	УправлениеКнопкамиНавигации(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьТаблицуПользователиМультирежима()
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	СпецоператорСвязи = Перечисления.СпецоператорыСвязи.КалугаАстрал;
	
	Результат = КонтекстЭДОСервер.ПолучитьФайлАвтонастройки(СпецоператорСвязи, ИдентификаторАбонента());
	Если НЕ Результат.Выполнено Тогда
		ТекстОшибки = НСтр("ru = 'Не удалось получить рег. файл учетной записи по идентификатору '") + ИдентификаторАбонента();
		ПоказатьСтраницуОшибка(ТекстОшибки);
		Возврат Ложь;
	КонецЕсли;
	
	АдресРегФайла = Результат.Настройки;
	
	ФайлDOM = КонтекстЭДОСервер.ФайлАвтонастрокиВФорматеDOMПоАдресу(АдресРегФайла);
	
	ПользователиМультирежима.Очистить();
	ПотенциальныеПользователи.Очистить();
	
	УзлыВладелецыЭЦП = ФайлDOM.ПолучитьЭлементыПоИмени("ВладелецЭЦП");
	Для каждого УзелДанныеВладельцаЭЦП Из УзлыВладелецыЭЦП Цикл
		
		ДанныеВладельца = КонтекстЭДОСервер.ДанныеВладельцаИзРегФайла(
			ФайлDOM, 
			УзелДанныеВладельцаЭЦП, 
			АдресРегФайла, 
			Организация);
		
		НоваяСтрока = ДобавитьСтрокуТаблицыПользователиМультирежима(
			ДанныеВладельца, 
			ПользователиМультирежима);
		
		ПроверитьПользователяМультирежима(НоваяСтрока, Организация);
		
	КонецЦикла;
	
	УзлыПотенциальныеВладелецыЭЦП = ФайлDOM.ПолучитьЭлементыПоИмени("ПотенциальныйПользователь");
	Для каждого УзелДанныеВладельцаЭЦП Из УзлыПотенциальныеВладелецыЭЦП Цикл
		
		ДанныеВладельца = КонтекстЭДОСервер.ДанныеПотенциальногоВладельцаИзРегФайла(УзелДанныеВладельцаЭЦП);
		Если ЗначениеЗаполнено(ДанныеВладельца.ФизическоеЛицо) Тогда 
			ДобавитьСтрокуТаблицыПользователиМультирежима(ДанныеВладельца, ПотенциальныеПользователи);
		КонецЕсли;
		
	КонецЦикла;
	
	ПоказатьСтраницуВыбораПользователейМультирежима();
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ДобавитьСтрокуТаблицыПользователиМультирежима(ДанныеВладельца, Таблица)
	
	НоваяСтрока = Таблица.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеВладельца);
	
	Если ЗначениеЗаполнено(ДанныеВладельца.ФизическоеЛицо) Тогда 
		НоваяСтрока.ФИО = Строка(ДанныеВладельца.ФизическоеЛицо);
		НоваяСтрока.Пользователь = Мультирежим.ПользовательПоФизЛицуИзСправочникаПользователи(ДанныеВладельца.ФизическоеЛицо);
	Иначе
		НоваяСтрока.ФИО = ОбработкаЗаявленийАбонентаКлиентСервер.ФИОВладельца(ДанныеВладельца);
	КонецЕсли;
	
	Возврат НоваяСтрока;
		
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПроверитьПользователяМультирежима(Строка, Организация)
	
	УказанКорректно = ПользовательМультирежимаУказаныКорректно(Строка, Организация);
	
	Если УказанКорректно Тогда
		Строка.Картинка = БиблиотекаКартинок.Пользователь;
	ИначеЕсли ЗначениеЗаполнено(Строка.Пользователь) Тогда
		Строка.Картинка = БиблиотекаКартинок.ПользовательБезНеобходимыхСвойств;
	КонецЕсли;
		
КонецФункции

&НаСервере
Функция ПользователиМультирежимаУказаныКорректно(ВыводитьПредупреждение = Ложь)
	
	УказаныКорректно = Истина;
	
	ЕстьХотяБыОдин = Ложь;
	ЕстьТекущий    = Ложь;
	
	Для каждого Строка Из ПользователиМультирежима Цикл
		
		Если ЗначениеЗаполнено(Строка.Пользователь) Тогда 
			ЕстьХотяБыОдин = Истина;
		КонецЕсли;
		
		Если Строка.Пользователь = ТекущийПользователь  Тогда 
			ЕстьТекущий = Истина;
		КонецЕсли;
		
		УказанКорректно = ПользовательМультирежимаУказаныКорректно(
			Строка,
			Организация,
			ВыводитьПредупреждение);
			
		Если НЕ УказанКорректно Тогда
			
			УказаныКорректно = Ложь;
			
			Если ВыводитьПредупреждение И ЗначениеЗаполнено(Строка.ТекстОшибки) Тогда
				ОбщегоНазначения.СообщитьПользователю(Строка.ТекстОшибки);
			КонецЕсли;
	
		КонецЕсли;
		
	КонецЦикла;
	
	Если ВыводитьПредупреждение И НЕ ЕстьХотяБыОдин Тогда
		ТекстОшибки = НСтр("ru = 'Заполните хотя бы одного пользователя'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
		УказаныКорректно = Ложь;
	КонецЕсли;
	
	Если ВыводитьПредупреждение И НЕ ЕстьТекущий Тогда
		ТекстОшибки = НСтр("ru = 'Текущий пользователь %1 должен присутствовать в колонке Пользователь программы.
                            |Восстанавливать учетную запись может только пользователь учетной записи, подключенный к 1С-Отчетности.'");
		ТекстОшибки = СтрШаблон(ТекстОшибки, ТекущийПользователь);
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
		УказаныКорректно = Ложь;
	КонецЕсли;
	
	Возврат УказаныКорректно;
		
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПользовательМультирежимаУказаныКорректно(Строка, Организация, ВыводитьПредупреждение = Ложь)
	
	УказанКорректно = Истина;
	
	Если ЗначениеЗаполнено(Строка.Пользователь) Тогда
		
		ФизическоеЛицо = МультирежимВызовСервера.ФизЛицоПоПользователюИзСправочникаПользователи(Строка.Пользователь);
		Если НЕ ЗначениеЗаполнено(ФизическоеЛицо) ИЛИ НЕ ЗначениеЗаполнено(Строка.ФизическоеЛицо) Тогда
			Строка.ТекстОшибки = НСтр("ru = 'Заполните поле ""Физическое лицо"" у пользователя '") + Строка(Строка.Пользователь);
			УказанКорректно = Ложь;
		КонецЕсли;
			
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Строка.Пользователь) И ЗначениеЗаполнено(Строка.ФизическоеЛицо) Тогда
		
		СНИЛС = МультирежимВызовСервера.СНИЛСФизЛица(Строка.ФизическоеЛицо, Организация);
		
		Если ЗначениеЗаполнено(СНИЛС) Тогда
			
			Если СНИЛС <> Строка.ВладелецЭЦПСНИЛС Тогда
				
				Строка.ТекстОшибки = НСтр("ru = 'СНИЛС %1 (по данным оператора) не совпадает со СНИЛС %2, указанным у физ. лица %3 пользователя %4'");
				Строка.ТекстОшибки = СтрШаблон(
					Строка.ТекстОшибки, 
					Строка.ВладелецЭЦПСНИЛС, 
					СНИЛС, 
					Строка.ФизическоеЛицо, 
					Строка.Пользователь);
					
				УказанКорректно = Ложь; 
				
			КонецЕсли;
			
		Иначе
			
			Строка.ТекстОшибки = НСтр("ru = 'У физ. лица %3 пользователя %4 не заполнен СНИЛС'");
				Строка.ТекстОшибки = СтрШаблон(
					Строка.ТекстОшибки, 
					Строка.ВладелецЭЦПСНИЛС, 
					СНИЛС, 
					Строка.ФизическоеЛицо, 
					Строка.Пользователь);
					
				УказанКорректно = Ложь; 
			
			КонецЕсли;
			
	КонецЕсли;
		
	Возврат УказанКорректно;
		
КонецФункции

&НаКлиенте
Процедура ПоказатьСтраницуВыбораПользователей1ПРежим()
	
	Элементы.ПодсказкаПоРезультатамШаг2.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выберите пользователей, которые будут иметь право использовать 1С-Отчетность по %1'"),
		Организация);
	
	Элементы.ОсновнаяПанель.ТекущаяСтраница = Элементы.СтраницаВыборПользователей;
	Элементы.РежимОтчетности.ТекущаяСтраница = Элементы.Однопользовательский;
	УправлениеКнопкамиНавигации(ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура ДействияПослеВыбораПользователей1ПРежим(НепосредственноОбновить)
	
	Если НЕ НепосредственноОбновить Тогда
		Для Каждого Пользователь Из СписокПользователей Цикл
			Пользователь.Пометка = Истина;
		КонецЦикла;
	КонецЕсли;
	
	// Записываем выбранных пользователей в регистр сведений
	ЗаписатьПользователейУчетныхЗаписейДокументооборота(КонтекстЭДОКлиент.НоваяУчетнаяЗапись);
	
	ПоказатьСтраницуУспех();
		
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСтраницуУспех()
	
	Элементы.ПодсказкаКонечныйРезультат.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Поздравляем!
              |Учетная запись по %1 успешно восстановлена'"),
		Организация);
	
	СтруктураДляОповещения = Новый Структура("Организация, УчетнаяЗапись", Организация, КонтекстЭДОКлиент.НоваяУчетнаяЗапись);
	Оповестить("ПривязатьУчетнуюЗаписьКОрганизации", СтруктураДляОповещения);
	
	Если НЕ СтруктураДляОповещения.Свойство("ОповещениеОтработано") ИЛИ СтруктураДляОповещения.ОповещениеОтработано = Ложь Тогда
		КонтекстЭДОКлиент.УстановитьУчетнуюЗаписьОрганизации(Организация, КонтекстЭДОКлиент.НоваяУчетнаяЗапись);
	КонецЕсли;
	ОповеститьОбИзменении(КонтекстЭДОКлиент.НоваяУчетнаяЗапись);
	Если НЕ СтруктураДляОповещения.Свойство("ОповещениеОтработано") ИЛИ СтруктураДляОповещения.ОповещениеОтработано = Ложь Тогда
		Оповестить("ОбновитьУчетнуюЗапись", КонтекстЭДОКлиент.НоваяУчетнаяЗапись);
	КонецЕсли;
	
	Элементы.ОсновнаяПанель.ТекущаяСтраница = Элементы.СтраницаРезультат;
	Элементы.СтраницыРезультата.ТекущаяСтраница = Элементы.СтраницаРезультатУспех;
	
	УправлениеКнопкамиНавигации(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСледующуюСтраницу()
	
	Страницы              = Элементы.ОсновнаяПанель.ПодчиненныеЭлементы;
	ТекущаяСтраница       = Элементы.ОсновнаяПанель.ТекущаяСтраница;
	ИндексТекущейСтраницы = Страницы.Индекс(ТекущаяСтраница);
	
	Пока ИндексТекущейСтраницы < Страницы.Количество() - 1 Цикл
		
		Страница = Страницы.Получить(ИндексТекущейСтраницы + 1);
		
		Если Страница.Видимость Тогда
			Элементы.ОсновнаяПанель.ТекущаяСтраница = Страница;
			Прервать;
		Иначе
			ИндексТекущейСтраницы = ИндексТекущейСтраницы + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	УстановитьПодстраницуВыбораПользователей();
	УправлениеКнопкамиНавигации(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПодстраницуВыбораПользователей()
	
	Если Элементы.ОсновнаяПанель.ТекущаяСтраница = Элементы.СтраницаВыборПользователей Тогда
		
		Если ЭтоМультиРежим Тогда
			ПоказатьСтраницуВыбораПользователейМультирежима();
		Иначе
			ПоказатьСтраницуВыбораПользователей1ПРежим();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьПользователейУчетныхЗаписейДокументооборота(СсылкаУчетнаяЗапись)
	
	НаборЗаписей = РегистрыСведений.ПользователиУчетныхЗаписейДокументооборота.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.УчетнаяЗапись.Установить(СсылкаУчетнаяЗапись.Ссылка);
	ФлагОтметки = Ложь;
	
	Для Каждого СтрокаСписка Из СписокПользователей Цикл
		Если СтрокаСписка.Пометка Тогда
			НоваяСтрока = НаборЗаписей.Добавить();
			НоваяСтрока.УчетнаяЗапись = СсылкаУчетнаяЗапись.Ссылка;
			НоваяСтрока.Пользователь = СтрокаСписка.Значение;
			ФлагОтметки = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		НаборЗаписей.Записать();
	Исключение
		РегламентированнаяОтчетностьКлиентСервер.СообщитьОбОшибке(ОписаниеОшибки(), Ложь,
			"Не удалось обновить список пользователей по учетной записи налогоплательщика """ + СокрЛП(СсылкаУчетнаяЗапись.Ссылка) + """.");
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьПриглашенияПользователей1СОтчетности()
	
	Приглашения = Новый Массив;;
	
	Для каждого Строка Из ПотенциальныеПользователи Цикл
		
		Если НЕ ЗначениеЗаполнено(Строка.Пользователь) Тогда
			Продолжить;
		КонецЕсли;
		
		ТекущееФизЛицо = Мультирежим.ФизЛицоПоПользователюИзСправочникаПользователи(ТекущийПользователь);
		Подстроки = Мультирежим.НачалоПриглашения(ТекущееФизЛицо, Организация, Истина, Ложь);
		Мультирежим.ДобавитьПриглашениеПриДобавлении(Подстроки, Организация);
		ТекстПриглашения = ДокументооборотСКОКлиентСервер.СтрСоединитьUPD(Подстроки);
		
		Приглашение = Мультирежим.ШаблонПриглашения();
		
		Приглашение.ЕстьИзменение    = Истина;
		Приглашение.ТекстПриглашения = ТекстПриглашения;
		Приглашение.ЭтоПодключение   = Истина;
		Приглашение.Пользователь     = Строка.Пользователь;
		Приглашение.Организация      = Организация;
		Приглашение.УчетнаяЗапись    = УчетнаяЗапись;
		Приглашение.Дата             = ТекущаяДатаСеанса();
		
		Приглашения.Добавить(Приглашение);
	
	КонецЦикла;
	
	Если Приглашения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Мультирежим.ЗаписатьВРегистрПриглашенияПользователей1СОтчетности(Приглашения);
	
КонецПроцедуры

#КонецОбласти
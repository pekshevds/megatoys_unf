#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ОнлайнЗаписьВключена() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	НастройкиПубликацииМЛК.ИспользоватьОнлайнЗапись КАК ИспользоватьОнлайнЗапись
		|ИЗ
		|	Справочник.НастройкиПубликацииМЛК КАК НастройкиПубликацииМЛК";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();
	Возврат ВыборкаДетальныеЗаписи.ИспользоватьОнлайнЗапись;
	
КонецФункции

// См. ОбменДаннымиПереопределяемый.РегистрацияИзмененийНачальнойВыгрузкиДанных.
//
Процедура РегистрацияИзмененийНачальнойВыгрузкиДанных(Получатель, СтандартнаяОбработка, Отбор) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Отбор = Новый Массив;
	Отбор.Добавить(Метаданные.Справочники.Организации);
	Отбор.Добавить(Метаданные.Справочники.ВидыЦен);
	Отбор.Добавить(Метаданные.Справочники.Валюты);
	Отбор.Добавить(Метаданные.Справочники.СтруктурныеЕдиницы);
	
	УзлыОбмена = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Получатель);
	Для каждого ОбъектМетаданных Из Отбор Цикл
		ПланыОбмена.ЗарегистрироватьИзменения(УзлыОбмена, ОбъектМетаданных);
	КонецЦикла;
	
КонецПроцедуры

// Возвращает ссылку на настройки Кабинета клиента
//
// Возвращаемое значение:
//   - СправочникСсылка.НастройкиПубликацииМЛК
//
Функция ПолучитьНастройкиПубликацииМЛК() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	НастройкиПубликацииМЛК.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.НастройкиПубликацииМЛК КАК НастройкиПубликацииМЛК";
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция НастройкиИнтеграцииКабинетКлиента(НастройкаПубликацииМЛК) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НастройкиИнтеграцииКабинетКлиента.НастройкаПубликации КАК НастройкаПубликации,
	|	НастройкиИнтеграцииКабинетКлиента.КодПриложения КАК КодПриложения,
	|	НастройкиИнтеграцииКабинетКлиента.АдресПриложения КАК АдресПриложения,
	|	НастройкиИнтеграцииКабинетКлиента.НомерОбласти КАК НомерОбласти,
	|	НастройкиИнтеграцииКабинетКлиента.КодУзлаОбмена КАК КодУзлаОбмена,
	|	НастройкиИнтеграцииКабинетКлиента.Пользователь КАК Пользователь,
	|	НастройкиИнтеграцииКабинетКлиента.EmailПриРегистрации КАК EmailПриРегистрации,
	|	НастройкиИнтеграцииКабинетКлиента.ТокенДоступа КАК ТокенДоступа
	|ИЗ
	|	РегистрСведений.НастройкиИнтеграцииКабинетКлиента КАК НастройкиИнтеграцииКабинетКлиента
	|ГДЕ
	|	НастройкиИнтеграцииКабинетКлиента.НастройкаПубликации = &НастройкаПубликации";
	Запрос.УстановитьПараметр("НастройкаПубликации", НастройкаПубликацииМЛК);
	
	Результат = Запрос.Выполнить().Выбрать();
	
	Если НЕ Результат.Следующий() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НастройкиПриложения = Новый Структура();
	НастройкиПриложения.Вставить("КодПриложения");
	НастройкиПриложения.Вставить("АдресПриложения");
	НастройкиПриложения.Вставить("НомерОбласти");
	НастройкиПриложения.Вставить("КодУзлаОбмена");
	НастройкиПриложения.Вставить("Пользователь");
	НастройкиПриложения.Вставить("EmailПриРегистрации");
	НастройкиПриложения.Вставить("ТокенДоступа");
	
	ЗаполнитьЗначенияСвойств(НастройкиПриложения, Результат);
	
	Если ПривилегированныйРежим() Тогда
		Пароль = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(НастройкаПубликацииМЛК,
			"ПарольПользователяИнтеграции");
		
		Если Пароль = Неопределено Тогда
			Пароль = "";
		КонецЕсли;
		НастройкиПриложения.Вставить("Пароль", Пароль);
	КонецЕсли;
	
	Возврат НастройкиПриложения;
	
КонецФункции

Процедура СохранитьНастройкиИнтеграцииКабинетКлиента(
		НастройкаПубликацииМЛК,
		ОписаниеПриложения = Неопределено,
		ДанныеАвторизации = Неопределено,
		УзелОбмена = Неопределено) Экспорт
	
	Если ОписаниеПриложения = Неопределено
		И ДанныеАвторизации = Неопределено
		И УзелОбмена = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.НастройкиИнтеграцииКабинетКлиента.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.НастройкаПубликации.Установить(НастройкаПубликацииМЛК);
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() <> 0 Тогда
		Запись = НаборЗаписей[0];
	Иначе
		Запись = НаборЗаписей.Добавить();
		Запись.ТокенДоступа = Строка(Новый УникальныйИдентификатор());
	КонецЕсли;
	
	Запись.НастройкаПубликации = НастройкаПубликацииМЛК;
	Если ОписаниеПриложения <> Неопределено Тогда
		Запись.КодПриложения = ОписаниеПриложения.Код;
		Запись.АдресПриложения = ОписаниеПриложения.АдресПриложения;
		Запись.НомерОбласти = ОписаниеПриложения.НомерОбласти;
	КонецЕсли;
	Если ДанныеАвторизации <> Неопределено Тогда
		Запись.Пользователь = ДанныеАвторизации.Логин;
		Запись.EmailПриРегистрации = ДанныеАвторизации.EmailПользователя;
		
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(НастройкаПубликацииМЛК, ДанныеАвторизации.Пароль, "ПарольПользователяИнтеграции");
	КонецЕсли;
	Если УзелОбмена <> Неопределено Тогда
		Запись.КодУзлаОбмена = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УзелОбмена, "Код");
	КонецЕсли;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Процедура УдалитьНастройкиИнтеграцииКабинетКлиента(НастройкаПубликацииМЛК) Экспорт
	
	НастройкиИнтеграции = НастройкиИнтеграцииКабинетКлиента(НастройкаПубликацииМЛК);
	
	Если НастройкиИнтеграции = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УзелОбмена = УзелПланаОбменаПоКоду(НастройкиИнтеграции.КодУзлаОбмена);
	
	НачатьТранзакцию();
	Попытка
		НаборЗаписей = РегистрыСведений.НастройкиИнтеграцииКабинетКлиента.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.НастройкаПубликации.Установить(НастройкаПубликацииМЛК);
		НаборЗаписей.Записать(Истина);
		
		ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(НастройкаПубликацииМЛК, "ПарольПользователяИнтеграции");
		
		Если ЗначениеЗаполнено(УзелОбмена) Тогда
			ОбменДаннымиСервер.УдалитьНастройкуСинхронизации(УзелОбмена);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#Область ПроцессПубликацииНастроек

Процедура ПодготовитьПриложениеКабинетКлиентаСуществующийАбонентРежимСервиса(НастройкаПубликацииМЛК) Экспорт
	
	АктивироватьПромокодЕслиНеобходимоРежимСервиса();
	
	ПараметрыСоздания = ПрограммныйИнтерфейсСервиса.НовыйПараметрыСозданияПриложения();
	ПараметрыСоздания.КодКонфигурации = КодПриложенияКабинетКлиента();
	ОписаниеНовогоПриложения = ПрограммныйИнтерфейсСервиса.СоздатьПриложение(ПараметрыСоздания);
	
	НомерОбласти = ОписаниеНовогоПриложения.Код;
	ОписаниеНовогоПриложения = ОжидатьГотовностьСозданногоПриложенияСуществующегоАбонентаРежимСервиса(НомерОбласти);
	
	ОписаниеПользователяИнтеграции = СоздатьСлужебногоПользователяИнтеграцииРежимСервиса(НомерОбласти);
	
	ДанныеАвторизации = Новый Структура;
	ДанныеАвторизации.Вставить("EmailПользователя", "");
	ДанныеАвторизации.Вставить("Логин",  ОписаниеПользователяИнтеграции.Логин);
	ДанныеАвторизации.Вставить("Пароль", ОписаниеПользователяИнтеграции.Пароль);
	
	ОписаниеПриложенияДляНастроек = Новый Структура;
	ОписаниеПриложенияДляНастроек.Вставить("Код",             ОписаниеНовогоПриложения.КодКонфигурации);
	ОписаниеПриложенияДляНастроек.Вставить("АдресПриложения", ОписаниеНовогоПриложения.АдресПриложения);
	ОписаниеПриложенияДляНастроек.Вставить("НомерОбласти",    ОписаниеНовогоПриложения.Код);
	
	СохранитьНастройкиИнтеграцииКабинетКлиента(НастройкаПубликацииМЛК, ОписаниеПриложенияДляНастроек, ДанныеАвторизации);
	
	ОтправкаЗапросов.Подождать(4);
	
КонецПроцедуры

Процедура ПодготовитьПриложениеКабинетКлиентаСуществующийАбонент(НастройкаПубликацииМЛК, Логин, Пароль, КодАбонентаВладельца) Экспорт
	
	АктивироватьПромокодЕслиНеобходимо(Логин, Пароль, КодАбонентаВладельца);
	
	ДанныеАвторизации = ИнтеграцияСервисФреш.НовыйДанныеАвторизации();
	ДанныеАвторизации.Логин = Логин;
	ДанныеАвторизации.Пароль = Пароль;
	ДанныеАвторизации.КодАбонента = КодАбонентаВладельца;
	
	ОписаниеНовогоПриложения = ИнтеграцияСервисФреш.НовыйОписаниеСозданияПриложения();
	ОписаниеНовогоПриложения.Код = КодПриложенияКабинетКлиента();
	
	ОписаниеСозданногоПриложения = ИнтеграцияСервисФреш.СоздатьПриложение(ДанныеАвторизации, ОписаниеНовогоПриложения);
	НомерОбласти = ОписаниеСозданногоПриложения.НомерОбласти;
	ОписаниеСозданногоПриложения = ОжидатьГотовностьСозданногоПриложенияСуществующегоАбонента(ДанныеАвторизации, НомерОбласти);
	ОписаниеПользователяИнтеграции = СоздатьСлужебногоПользователяИнтеграции(ДанныеАвторизации, НомерОбласти);
	
	ДанныеАвторизации = Новый Структура;
	ДанныеАвторизации.Вставить("EmailПользователя", Логин);
	ДанныеАвторизации.Вставить("Логин",  ОписаниеПользователяИнтеграции.Логин);
	ДанныеАвторизации.Вставить("Пароль", ОписаниеПользователяИнтеграции.Пароль);
	СохранитьНастройкиИнтеграцииКабинетКлиента(НастройкаПубликацииМЛК, ОписаниеСозданногоПриложения, ДанныеАвторизации);
	
	ОтправкаЗапросов.Подождать(4);
	
КонецПроцедуры

Процедура ПодготовитьПриложениеКабинетКлиентаНовыйАбонент(НастройкаПубликацииМЛК, Логин) Экспорт
	
	ИнтеграцияСервисФреш.СоздатьАбонента(Логин);
	ОписаниеПриложения = ОжидатьГотовностьСозданногоПриложенияНовогоАбонента(Логин);
	
	ОписаниеПользователяИнтеграции = ОписаниеПользователяИнтеграцииПоУмолчанию();
	
	ДанныеАвторизации = Новый Структура;
	ДанныеАвторизации.Вставить("EmailПользователя", Логин);
	ДанныеАвторизации.Вставить("Логин",  ОписаниеПользователяИнтеграции.Логин);
	ДанныеАвторизации.Вставить("Пароль", ОписаниеПользователяИнтеграции.Пароль);
	СохранитьНастройкиИнтеграцииКабинетКлиента(НастройкаПубликацииМЛК, ОписаниеПриложения, ДанныеАвторизации);
	
	ОтправкаЗапросов.Подождать(4);
	
КонецПроцедуры

Процедура ЗарегистрироватьДанныеДляНачальнойВыгрузки(НастройкаПубликацииМЛК) Экспорт
	
	НастройкиИнтеграции = НастройкиИнтеграцииКабинетКлиента(НастройкаПубликацииМЛК);
	УзелОбмена = УзелПланаОбменаПоКоду(НастройкиИнтеграции.КодУзлаОбмена);
	Если НЕ ЗначениеЗаполнено(УзелОбмена) Тогда
		ТекстОшибки = СтрШаблон(
			НСтр("ru='Не удалось найти узел обмена по коду ""%1""'"), НастройкиИнтеграции.КодУзлаОбмена);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	УзелОбменаОбъект = УзелОбмена.ПолучитьОбъект();
	УзелОбменаОбъект.ДатаНачалаВыгрузкиДокументов = ДатаНачалаВыгрузкиДокументов();
	УзелОбменаОбъект.Записать();
	
	ОбменДаннымиСервер.ЗарегистрироватьДанныеДляНачальнойВыгрузки(УзелОбмена);
	
КонецПроцедуры

Процедура АктуализироватьИзмененияПланаОбмена(НастройкаПубликацииМЛК, УзелОбмена) Экспорт
	
	ДанныеНастройки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НастройкаПубликацииМЛК,
		"ИспользоватьХарактеристики, НужноОпубликовать,НужноОпубликоватьКаталогТоваров,НужноОпубликоватьХарактеристики,ВидЦенТоваров,ОрганизацииСкладскихОстатков,Склады,ИспользоватьОстатки, ИндивидуальныеЦены, НужноОпубликоватьДоговоры");

	НеобходимоЗарегистрироватьЦены = Ложь;
	НеобходимоЗарегистрироватьОстатки = Ложь;
	
	УзелОбменаОбъект = УзелОбмена.ПолучитьОбъект();
	УзелОбменаОбъект.Заблокировать();
	УзелОбменаИзменен = Ложь;
	
	Если УзелОбменаОбъект.ИспользоватьОтборПоНоменклатуре <> Истина Тогда
		УзелОбменаОбъект.ИспользоватьОтборПоНоменклатуре = Истина;
		УзелОбменаИзменен = Истина;
	КонецЕсли;
	
	НоменклатураВыгружаемаяБыло = ОтборНоменклатурыУзлаОбмена(УзелОбменаОбъект);
	ДобавитьОтборНоменклатурыВУзелОбмена(УзелОбменаОбъект, НастройкаПубликацииМЛК);
	НоменклатураВыгружаемаяСтало = ОтборНоменклатурыУзлаОбмена(УзелОбменаОбъект);
	
	НоменклатураИзменилась = Не ОбщегоНазначенияКлиентСервер.СпискиЗначенийИдентичны(
		НоменклатураВыгружаемаяБыло, НоменклатураВыгружаемаяСтало);
	Если НоменклатураИзменилась Тогда
		УзелОбменаИзменен = Истина;
	КонецЕсли;
	
	ВидыЦенИзНастроек = Новый Массив;
	Договоры = Новый Массив;
	ТЗИндивидуальныеЦены = ДанныеНастройки.ИндивидуальныеЦены.Выгрузить();
	ОтборСтрок = Новый Структура("Используется", Истина);
	НайденныеСтрокиИндивидуальныеЦены = ТЗИндивидуальныеЦены.НайтиСтроки(ОтборСтрок);
	
	Для каждого СтрокаИЦ Из НайденныеСтрокиИндивидуальныеЦены Цикл
		
		Если ЗначениеЗаполнено(СтрокаИЦ.ВидЦен) Тогда
			Если ВидыЦенИзНастроек.Найти(СтрокаИЦ.ВидЦен) = Неопределено Тогда
				ВидыЦенИзНастроек.Добавить(СтрокаИЦ.ВидЦен);
			КонецЕсли;
		Иначе
			ВидЦенИзДоговора = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаИЦ.Договор, "ВидЦен");
			Если ЗначениеЗаполнено(ВидЦенИзДоговора) Тогда
				Если ВидыЦенИзНастроек.Найти(ВидЦенИзДоговора) = Неопределено Тогда
					ВидыЦенИзНастроек.Добавить(ВидЦенИзДоговора);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаИЦ.Договор) Тогда
			Договоры.Добавить(СтрокаИЦ.Договор);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ВидыЦенИзНастроек.Найти(ДанныеНастройки.ВидЦенТоваров) = Неопределено Тогда
		ВидыЦенИзНастроек.Добавить(ДанныеНастройки.ВидЦенТоваров);
	КонецЕсли;
	
	ВидыЦенИзУзла = УзелОбменаОбъект.ВидыЦен.Выгрузить().ВыгрузитьКолонку("ВидЦен");
	
	ВидыЦенИзменились = Не ОбщегоНазначенияКлиентСервер.СпискиЗначенийИдентичны(ВидыЦенИзНастроек, ВидыЦенИзУзла);
	
	НовыеВидыЦенДляВыгрузки = Новый Массив;
	Если ВидыЦенИзменились Тогда
		УзелОбменаОбъект.ИспользоватьОтборПоВидамЦен = Истина;
		УзелОбменаОбъект.ВидыЦен.Очистить();
		Для каждого ВидЦен Из ВидыЦенИзНастроек Цикл
			Строка = УзелОбменаОбъект.ВидыЦен.Добавить();
			Строка.ВидЦен = ВидЦен;
		КонецЦикла;
		УзелОбменаИзменен = Истина;
		НеобходимоЗарегистрироватьЦены = Истина;
		НовыеВидыЦенДляВыгрузки = ОбщегоНазначенияКлиентСервер.РазностьМассивов(
			ВидыЦенИзНастроек, ВидыЦенИзУзла);
	КонецЕсли;
	
	Если НоменклатураИзменилась Или ВидыЦенИзменились Тогда
		НоваяНоменклатураДляВыгрузки = ОбщегоНазначенияКлиентСервер.РазностьМассивов(
			НоменклатураВыгружаемаяСтало, НоменклатураВыгружаемаяБыло);
	Иначе
		НоваяНоменклатураДляВыгрузки = Новый Массив;
	КонецЕсли;
	
	СкладыНастройки = ДанныеНастройки.Склады.Выгрузить().ВыгрузитьКолонку("Склад");
	СкладыУзла = УзелОбменаОбъект.Склады.Выгрузить().ВыгрузитьКолонку("Склад");
	СкладыВНастройкеИУзлеСовпадают = ОбщегоНазначения.КоллекцииИдентичны(СкладыНастройки, СкладыУзла);
	Если ДанныеНастройки.ИспользоватьОстатки
		И НЕ СкладыВНастройкеИУзлеСовпадают Тогда
		УзелОбменаОбъект.ВыгружатьОстаткиНоменклатуры = Истина;
		УзелОбменаОбъект.Склады.Очистить();
		Для каждого Склад Из СкладыНастройки Цикл
			Строка = УзелОбменаОбъект.Склады.Добавить();
			Строка.Склад = Склад;
		КонецЦикла;
		УзелОбменаИзменен = Истина;
		НеобходимоЗарегистрироватьОстатки = Истина;
	КонецЕсли;
	
	ОрганизацииНастройки = ДанныеНастройки.ОрганизацииСкладскихОстатков.Выгрузить().ВыгрузитьКолонку("Организация");
	ОрганизацииУзла = УзелОбменаОбъект.ОрганизацииСкладскихОстатков.Выгрузить().ВыгрузитьКолонку("Организация");
	ОрганизацииВНастройкеИУзлеСовпадают = ОбщегоНазначения.КоллекцииИдентичны(ОрганизацииНастройки, ОрганизацииУзла);
	Если Не ОрганизацииВНастройкеИУзлеСовпадают Тогда
		УзелОбменаОбъект.ОрганизацииСкладскихОстатков.Очистить();
		Для каждого Организация Из ОрганизацииНастройки Цикл
			Строка = УзелОбменаОбъект.ОрганизацииСкладскихОстатков.Добавить();
			Строка.Организация = Организация;
		КонецЦикла;
		УзелОбменаИзменен = Истина;
		НеобходимоЗарегистрироватьОстатки = Истина;
	КонецЕсли;
	
	//ОрганизацияОстатковВНастройкеИУзлеСовпадают = УзелОбменаОбъект.ОрганизацииСкладскихОстатков.Найти(
	//	ДанныеНастройки.ОрганизацияДляОстатков, "Организация") <> Неопределено;
	//Если УзелОбменаОбъект.Склады.Количество() <> 0
	//	И ЗначениеЗаполнено(ДанныеНастройки.ОрганизацияДляОстатков)
	//	И Не ОрганизацияОстатковВНастройкеИУзлеСовпадают Тогда
	//	УзелОбменаОбъект.ОрганизацииСкладскихОстатков.Очистить();
	//	Строка = УзелОбменаОбъект.ОрганизацииСкладскихОстатков.Добавить();
	//	Строка.Организация = ДанныеНастройки.ОрганизацияДляОстатков;
	//	УзелОбменаИзменен = Истина;
	//КонецЕсли;
	
	Если НоменклатураИзменилась Тогда
		ЗарегистрироватьКартинкиНоменклатуры(УзелОбмена, НастройкаПубликацииМЛК, НоваяНоменклатураДляВыгрузки);
	КонецЕсли;
	
	Если НоменклатураИзменилась И НеобходимоЗарегистрироватьЦены Тогда
		ЗарегистрироватьЦеныНоменклатуры(УзелОбмена, НастройкаПубликацииМЛК, НоменклатураВыгружаемаяСтало, ВидыЦенИзНастроек);
	ИначеЕсли Не НоменклатураИзменилась И НеобходимоЗарегистрироватьЦены Тогда
		ЗарегистрироватьЦеныНоменклатуры(УзелОбмена, НастройкаПубликацииМЛК, НоменклатураВыгружаемаяСтало, НовыеВидыЦенДляВыгрузки);
	ИначеЕсли НоменклатураИзменилась И Не НеобходимоЗарегистрироватьЦены Тогда
		ЗарегистрироватьЦеныНоменклатуры(УзелОбмена, НастройкаПубликацииМЛК, НоваяНоменклатураДляВыгрузки, ВидыЦенИзНастроек);
	КонецЕсли;
	
	//Если ДанныеНастройки.ИспользоватьОстатки
	//	И (ДанныеНастройки.НужноОпубликоватьКаталогТоваров
	//	ИЛИ НеобходимоЗарегистрироватьОстатки) Тогда
	//	ЗарегистрироватьОстаткиНоменклатуры(УзелОбмена, НастройкаПубликацииМЛК, НоменклатураВыгружаемаяСтало);
	//КонецЕсли;
	
	Если ДанныеНастройки.ИспользоватьОстатки Тогда
		Если НеобходимоЗарегистрироватьОстатки Тогда
			ЗарегистрироватьОстаткиНоменклатуры(УзелОбмена, НастройкаПубликацииМЛК, НоменклатураВыгружаемаяСтало);
		ИначеЕсли ДанныеНастройки.НужноОпубликоватьКаталогТоваров Тогда
			ЗарегистрироватьОстаткиНоменклатуры(УзелОбмена, НастройкаПубликацииМЛК, НоваяНоменклатураДляВыгрузки);
		КонецЕсли;
	КонецЕсли;
	
	
	Если ДанныеНастройки.ИспользоватьХарактеристики И (НоменклатураИзменилась Или ДанныеНастройки.НужноОпубликоватьХарактеристики) Тогда
		ЗарегистрироватьХарактеристикиНоменклатуры(УзелОбмена, НастройкаПубликацииМЛК, НоваяНоменклатураДляВыгрузки);
	КонецЕсли;
	
	Если ДанныеНастройки.НужноОпубликоватьДоговоры Тогда
		ЗарегистрироватьДоговоры(УзелОбмена, Договоры);
	КонецЕсли;
	
	Если УзелОбменаИзменен Тогда
		УзелОбменаОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

Функция ЭтоСервис1СФреш() Экспорт
	
	ПодключениеВебСервер = "e1c://server/";
	
	СтрокаURI = ПолучитьНавигационнуюСсылкуИнформационнойБазы();
	Если СтрНачинаетсяС(СтрокаURI, ПодключениеВебСервер) Тогда
		СтрокаURI = Прав(СтрокаURI, СтрДлина(СтрокаURI) - СтрДлина(ПодключениеВебСервер));
	КонецЕсли;
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(СтрокаURI);
	Возврат СтрНайти(СтруктураURI.Хост, ИнтеграцияСервисФреш.НастройкиПодключения().Хост) <> 0;
	
КонецФункции

Функция СинхронизироватьУзелОбмена(УзелОбмена, РазрешитьДлительнуюОперацию) Экспорт
	
	ПараметрыОбмена = ОбменДаннымиСервер.ПараметрыОбмена();
	ПараметрыОбмена.ВидТранспортаСообщенийОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.WS;
	ПараметрыОбмена.ВыполнятьЗагрузку = Истина;
	ПараметрыОбмена.ВыполнятьВыгрузку = Истина;
	
	Если РазрешитьДлительнуюОперацию Тогда
		ПараметрыОбмена.ДлительнаяОперация = Истина;
		ПараметрыОбмена.ДлительнаяОперацияРазрешена = Истина;
	КонецЕсли;
	
	Отказ = Ложь;
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(УзелОбмена, ПараметрыОбмена, Отказ);
	
	Возврат Не Отказ;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КодПриложенияКабинетКлиента()
	
	Возврат "clients";
	
КонецФункции

Функция ПромокодАктивацииПриложенияКабинетКлиента()
	
	Возврат "kk_new";
	
КонецФункции

Функция ОписаниеПользователяИнтеграцииПоУмолчанию()
	
	ОписаниеПользователя = Новый Структура;
	ОписаниеПользователя.Вставить("Логин",  "kk_api");
	ОписаниеПользователя.Вставить("Пароль", "gm3NtMPQ");
	Возврат ОписаниеПользователя;
	
КонецФункции

Функция СоздатьСлужебногоПользователяИнтеграции(ДанныеАвторизации, НомерОбласти)
	
	ОписаниеПользователя = ИнтеграцияСервисФреш.ПараметрыСоздаваемогоПользователя();
	ОписаниеПользователя.Логин = НовыйЛогинСлужебногоПользователяИнтеграции(НомерОбласти);
	ОписаниеПользователя.ИмяПользователя = ОписаниеПользователя.Логин;
	ОписаниеПользователя.Пароль = Пользователи.СоздатьПароль();
	
	ИнтеграцияСервисФреш.СоздатьПользователя(ДанныеАвторизации, ОписаниеПользователя);
	ИнтеграцияСервисФреш.ДобавитьПользователяВПриложение(
		ДанныеАвторизации,
		НомерОбласти,
		ОписаниеПользователя.Логин,
		Перечисления.ПраваПользователяПриложения.ДоступКAPI);
		
	Возврат ОписаниеПользователя;
	
КонецФункции

Функция СоздатьСлужебногоПользователяИнтеграцииРежимСервиса(НомерОбласти)
	
	ПараметрыСоздания = ПрограммныйИнтерфейсСервиса.НовыйПараметрыСозданияПользователя();
	ПараметрыСоздания.Логин = НовыйЛогинСлужебногоПользователяИнтеграции(НомерОбласти);
	ПараметрыСоздания.ПолноеИмя = ПараметрыСоздания.Логин;
	ПараметрыСоздания.Пароль = Пользователи.СоздатьПароль();
	ПараметрыСоздания.ПочтаОбязательна = Ложь;
	ПараметрыСоздания.РольПользователя = Перечисления.РолиПользователейАбонентов.ПользовательАбонента;
	ОписаниеПользователя = ПрограммныйИнтерфейсСервиса.СоздатьПользователяАбонента(ПараметрыСоздания);
	
	ПараметрыДобавления = ПрограммныйИнтерфейсСервиса.НовыйПараметрыДобавленияПользователяВПриложение();
	ПараметрыДобавления.КодПриложения = НомерОбласти;
	ПараметрыДобавления.Логин = ПараметрыСоздания.Логин;
	ПараметрыДобавления.Право = Перечисления.ПраваПользователяПриложения.ДоступКAPI;
	ПрограммныйИнтерфейсСервиса.ДобавитьПользователяВПриложение(ПараметрыДобавления);
	
	Возврат ПараметрыСоздания;
	
КонецФункции

Функция НовыйЛогинСлужебногоПользователяИнтеграции(НомерОбласти)
	
	НомерОбластиСтрокой = Формат(НомерОбласти, "ЧГ=0");
	Возврат СтрШаблон("kk_api_%1", НомерОбластиСтрокой);
	
КонецФункции

Процедура АктивироватьПромокодЕслиНеобходимо(Логин, Пароль, КодАбонентаВладельца)
	
	НастройкиПодключенияСервиса = ИнтеграцияСервисФреш.НастройкиПодключения();
	Если НЕ СтрНачинаетсяС(НастройкиПодключенияСервиса.Сервер, "https://1cfresh.com") Тогда
		Возврат;
	КонецЕсли;
	
	ПромокодКабинетКлиента = ПромокодАктивацииПриложенияКабинетКлиента();
	
	ДанныеАвторизации = ИнтеграцияСервисФреш.НовыйДанныеАвторизации();
	ДанныеАвторизации.Логин = Логин;
	ДанныеАвторизации.Пароль = Пароль;
	ДанныеАвторизации.КодАбонента = КодАбонентаВладельца;
	
	ПриложениеКабинетКлиентаДоступно = Ложь;
	
	ДоступныеКонфигурации = ИнтеграцияСервисФреш.ДоступныеКонфигурации(ДанныеАвторизации);
	Для каждого ОписаниеКонфигурации Из ДоступныеКонфигурации Цикл
		Если ОписаниеКонфигурации.Код = КодПриложенияКабинетКлиента() Тогда
			ПриложениеКабинетКлиентаДоступно = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПриложениеКабинетКлиентаДоступно Тогда
		Возврат;
	КонецЕсли;
	
	АктивированныеПромокоды = ИнтеграцияСервисФреш.АктивированныеПромокоды(ДанныеАвторизации);
	
	КоличествоАктивированныхПромокодов = 0;
	Если ТипЗнч(АктивированныеПромокоды) = Тип("ТаблицаЗначений") Тогда
		КоличествоАктивированныхПромокодов = АктивированныеПромокоды.Количество();
	КонецЕсли;
	
	Если КоличествоАктивированныхПромокодов > 0 Тогда
		ПромокодКабинетКлиента = ПромокодКабинетКлиента + "_" + Строка(КоличествоАктивированныхПромокодов + 1);
	КонецЕсли;
	
	Попытка
		ИнтеграцияСервисФреш.АктивироватьПромокод(ДанныеАвторизации, ПромокодКабинетКлиента);
	Исключение
		КоличествоАктивированныхПромокодов = КоличествоАктивированныхПромокодов + 1;
		Если КоличествоАктивированныхПромокодов > 0 Тогда
			ПромокодКабинетКлиента = ПромокодКабинетКлиента + "_" + Строка(КоличествоАктивированныхПромокодов + 1);
		КонецЕсли;
		ИнтеграцияСервисФреш.АктивироватьПромокод(ДанныеАвторизации, ПромокодКабинетКлиента);
	КонецПопытки;
	
КонецПроцедуры

Процедура АктивироватьПромокодЕслиНеобходимоРежимСервиса()
	
	ПриложениеКабинетКлиентаДоступно = Ложь;
	
	ДоступныеКонфигурации = ПрограммныйИнтерфейсСервиса.Конфигурации();
	Для каждого ОписаниеКонфигурации Из ДоступныеКонфигурации Цикл
		Если ОписаниеКонфигурации.Код = КодПриложенияКабинетКлиента() Тогда
			ПриложениеКабинетКлиентаДоступно = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПриложениеКабинетКлиентаДоступно Тогда
		Возврат;
	КонецЕсли;
	
	ПромокодКабинетКлиента = ПромокодАктивацииПриложенияКабинетКлиента();
	
	АктивированныеПромокоды = АктивированныеПромокодыРежимСервиса();
	
	КоличествоАктивированныхПромокодов = 0;
	Если ТипЗнч(АктивированныеПромокоды) = Тип("ТаблицаЗначений") Тогда
		КоличествоАктивированныхПромокодов = АктивированныеПромокоды.Количество();
	КонецЕсли;
	
	Если КоличествоАктивированныхПромокодов > 0 Тогда
		ПромокодКабинетКлиента = ПромокодКабинетКлиента + "_" + Строка(КоличествоАктивированныхПромокодов + 1);
	КонецЕсли;
	
	Попытка
		ПрограммныйИнтерфейсСервиса.ИспользоватьПромокод(ПромокодКабинетКлиента);
	Исключение
		КоличествоАктивированныхПромокодов = КоличествоАктивированныхПромокодов + 1;
		Если КоличествоАктивированныхПромокодов > 0 Тогда
			ПромокодКабинетКлиента = ПромокодКабинетКлиента + "_" + Строка(КоличествоАктивированныхПромокодов + 1);
		КонецЕсли;
		ПрограммныйИнтерфейсСервиса.ИспользоватьПромокод(ПромокодКабинетКлиента);
	КонецПопытки;
	
КонецПроцедуры

Функция ОжидатьГотовностьСозданногоПриложенияНовогоАбонента(Логин)
	
	КоличествоПопыток = 6;
	Таймаут = 3;
	
	СозданиеНовыхПриложенийЗавершено = Ложь;
	
	НомерПопытки = 0;
	Пока НомерПопытки < КоличествоПопыток
		И НЕ СозданиеНовыхПриложенийЗавершено Цикл
		
		ОтправкаЗапросов.Подождать(Таймаут);
		Таймаут = Таймаут + НомерПопытки;
		НомерПопытки = НомерПопытки + 1;
		
		ОписаниеПриложения = ИнтеграцияСервисФреш.СозданныеПриложенияПриРегистрации(Логин);
		Если ОписаниеПриложения <> Неопределено Тогда
			СозданиеНовыхПриложенийЗавершено = ИнтеграцияСервисФреш.ПриложениеГотовоКИспользованию(ОписаниеПриложения);
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ СозданиеНовыхПриложенийЗавершено Тогда
		ТекстОшибки = НСтр("ru='При публикации возникла непредвиденная ошибка.
		|Попробуйте еще раз.'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Возврат ОписаниеПриложения;
	
КонецФункции

Функция ОжидатьГотовностьСозданногоПриложенияСуществующегоАбонента(ДанныеАвторизации, НомерОбласти)
	
	КоличествоПопыток = 7;
	Таймаут = 3;
	
	ПриложениеПодготовлено = Ложь;
	
	НомерПопытки = 0;
	Пока НомерПопытки < КоличествоПопыток
		И НЕ ПриложениеПодготовлено Цикл
		
		ОтправкаЗапросов.Подождать(Таймаут);
		Таймаут = Таймаут + НомерПопытки;
		НомерПопытки = НомерПопытки + 1;
		
		ОписаниеПриложения = ИнтеграцияСервисФреш.ИнформацияОПриложении(ДанныеАвторизации, НомерОбласти);
		ПриложениеПодготовлено = ИнтеграцияСервисФреш.ПриложениеГотовоКИспользованию(ОписаниеПриложения);
	КонецЦикла;
	
	Если НЕ ПриложениеПодготовлено Тогда
		ТекстОшибки = НСтр("ru='При публикации возникла непредвиденная ошибка.
		|Попробуйте еще раз.'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Возврат ОписаниеПриложения;
	
КонецФункции

Функция ОжидатьГотовностьСозданногоПриложенияСуществующегоАбонентаРежимСервиса(НомерОбласти)
	
	КоличествоПопыток = 7;
	Таймаут = 3;
	
	ПриложениеПодготовлено = Ложь;
	
	НомерПопытки = 0;
	Пока НомерПопытки < КоличествоПопыток
		И НЕ ПриложениеПодготовлено Цикл
		
		ОтправкаЗапросов.Подождать(Таймаут);
		Таймаут = Таймаут + НомерПопытки;
		НомерПопытки = НомерПопытки + 1;
		
		ОписаниеПриложения = ПрограммныйИнтерфейсСервиса.СвойстваПриложения(НомерОбласти);
		ПриложениеПодготовлено = ИнтеграцияСервисФреш.ПриложениеГотовоКИспользованию(ОписаниеПриложения);
	КонецЦикла;
	
	Если НЕ ПриложениеПодготовлено Тогда
		ТекстОшибки = НСтр("ru='При публикации возникла непредвиденная ошибка.
		|Попробуйте еще раз.'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Возврат ОписаниеПриложения;
	
КонецФункции

Функция УзелПланаОбменаПоКоду(КодУзла)
	
	Возврат ОбменДаннымиСервер.УзелПланаОбменаПоКоду(
		Метаданные.ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.Имя,
		КодУзла);
	
КонецФункции

Функция ОтборНоменклатурыУзлаОбмена(УзелОбмена)
	
	Результат = Новый Массив;
	Для каждого Строка Из УзелОбмена.Номенклатура Цикл
		Результат.Добавить(Строка.Номенклатура);
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

Процедура ДобавитьОтборНоменклатурыВУзелОбмена(УзелОбмена, НастройкаПубликацииМЛК)
	
	УзелОбмена.Номенклатура.Очистить();
	
	ДанныеНастройки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НастройкаПубликацииМЛК, "КаталогТоваров");
	КаталогТоваров = ДанныеНастройки.КаталогТоваров.Получить();
	
	Если КаталогТоваров = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Строка Из КаталогТоваров Цикл
		НоваяСтрока = УзелОбмена.Номенклатура.Добавить();
		НоваяСтрока.Номенклатура = Строка.Номенклатура;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗарегистрироватьКартинкиНоменклатуры(УзелОбмена, НастройкаПубликацииМЛК, Номенклатура)
	
	УзлыОбмена = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(УзелОбмена);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НоменклатураПрисоединенныеФайлы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.НоменклатураПрисоединенныеФайлы КАК НоменклатураПрисоединенныеФайлы
	|ГДЕ
	|	НоменклатураПрисоединенныеФайлы.ВладелецФайла В(&Номенклатура)";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	КартинкиНоменклатуры = Запрос.Выполнить().Выбрать();
	Пока КартинкиНоменклатуры.Следующий() Цикл
		ПланыОбмена.ЗарегистрироватьИзменения(УзлыОбмена, КартинкиНоменклатуры.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗарегистрироватьКартинкиХарактеристик(УзелОбмена, НастройкаПубликацииМЛК, ХарактеристикиНоменклатуры)
	
	УзлыОбмена = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(УзелОбмена);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ХарактеристикиНоменклатурыПрисоединенныеФайлы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатурыПрисоединенныеФайлы КАК ХарактеристикиНоменклатурыПрисоединенныеФайлы
	|ГДЕ
	|	ХарактеристикиНоменклатурыПрисоединенныеФайлы.ВладелецФайла В(&ХарактеристикиНоменклатуры)";
	
	Запрос.УстановитьПараметр("ХарактеристикиНоменклатуры", ХарактеристикиНоменклатуры);
	
	КартинкиХарактеристик = Запрос.Выполнить().Выбрать();
	Пока КартинкиХарактеристик.Следующий() Цикл
		ПланыОбмена.ЗарегистрироватьИзменения(УзлыОбмена, КартинкиХарактеристик.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗарегистрироватьЦеныНоменклатуры(УзелОбмена, НастройкаПубликацииМЛК, Номенклатура, ВидыЦен)
	
	ДанныеНастройки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НастройкаПубликацииМЛК,
		"КаталогТоваров,ВидЦенТоваров,ИспользоватьХарактеристики");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЦеныНоменклатурыСрезПоследних.ДокументУстановки КАК ДокументУстановки
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	|			&Период,
	|			ВидЦен В (&ВидыЦен)
	|				И Номенклатура В (&МассивНоменклатуры)
	|				И (&ИспользоватьХарактеристики
	|					ИЛИ Характеристика = &ХарактеристикаПустаяСсылка)
	|				И ДокументУстановки <> &ДокументУстановкиПустаяСсылка) КАК ЦеныНоменклатурыСрезПоследних";
	
	Запрос.УстановитьПараметр("Период", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ВидыЦен", ВидыЦен);
	Запрос.УстановитьПараметр("МассивНоменклатуры", Номенклатура);
	Запрос.УстановитьПараметр("ИспользоватьХарактеристики", ДанныеНастройки.ИспользоватьХарактеристики);
	Запрос.УстановитьПараметр("ХарактеристикаПустаяСсылка", Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка());
	Запрос.УстановитьПараметр("ДокументУстановкиПустаяСсылка", Документы.УстановкаЦенНоменклатуры.ПустаяСсылка());
	
	Результат = Запрос.Выполнить().Выбрать();
	
	УзлыОбмена = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(УзелОбмена);
	
	Пока Результат.Следующий() Цикл
		ПланыОбмена.ЗарегистрироватьИзменения(УзлыОбмена, Результат.ДокументУстановки);
	КонецЦикла;

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЦеныНоменклатурыСрезПоследних.Период КАК Период,
	|	ЦеныНоменклатурыСрезПоследних.ВидЦен КАК ВидЦен,
	|	ЦеныНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура,
	|	ЦеныНоменклатурыСрезПоследних.Характеристика КАК Характеристика,
	|	ЦеныНоменклатурыСрезПоследних.Цена КАК Цена,
	|	ЦеныНоменклатурыСрезПоследних.ДокументУстановки КАК ДокументУстановки
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	|			&Период,
	|			ВидЦен В (&ВидыЦен)
	|				И Номенклатура В (&МассивНоменклатуры)
	|				И (&ИспользоватьХарактеристики
	|					ИЛИ Характеристика = &ХарактеристикаПустаяСсылка)
	|				И ДокументУстановки = &ДокументУстановкиПустаяСсылка) КАК ЦеныНоменклатурыСрезПоследних";
	
	Запрос.УстановитьПараметр("Период", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ВидыЦен", ВидыЦен);
	Запрос.УстановитьПараметр("МассивНоменклатуры", Номенклатура);
	Запрос.УстановитьПараметр("ИспользоватьХарактеристики", ДанныеНастройки.ИспользоватьХарактеристики);
	Запрос.УстановитьПараметр("ХарактеристикаПустаяСсылка", Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка());
	Запрос.УстановитьПараметр("ДокументУстановкиПустаяСсылка", Документы.УстановкаЦенНоменклатуры.ПустаяСсылка());
	
	Результат = Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		НаборЗаписей = РегистрыСведений.ЦеныНоменклатуры.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Период.Установить(Результат.Период);
		НаборЗаписей.Отбор.ВидЦен.Установить(Результат.ВидЦен);
		НаборЗаписей.Отбор.Номенклатура.Установить(Результат.Номенклатура);
		НаборЗаписей.Отбор.Характеристика.Установить(Результат.Характеристика);
		ПланыОбмена.ЗарегистрироватьИзменения(УзлыОбмена, НаборЗаписей);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗарегистрироватьОстаткиНоменклатуры(УзелОбмена, НастройкаПубликацииМЛК, Номенклатура)
	
	ДанныеНастройки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НастройкаПубликацииМЛК,
		"КаталогТоваров,ОрганизацииСкладскихОстатков,Склады,ИспользоватьХарактеристики");

	КаталогТоваров = ДанныеНастройки.КаталогТоваров.Получить();
	
	Если КаталогТоваров = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Номенклатура = Неопределено Тогда
		Номенклатура = Новый Массив;
		Для каждого Строка Из КаталогТоваров Цикл
			Номенклатура.Добавить(Строка.Номенклатура);
		КонецЦикла;
	КонецЕсли;
	Склады = ДанныеНастройки.Склады.Выгрузить().ВыгрузитьКолонку("Склад");
	Организации = ДанныеНастройки.ОрганизацииСкладскихОстатков.Выгрузить().ВыгрузитьКолонку("Организация");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОстаткиТоваров.Организация КАК Организация,
	|	ОстаткиТоваров.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ОстаткиТоваров.Номенклатура КАК Номенклатура,
	|	ОстаткиТоваров.Характеристика КАК Характеристика,
	|	ОстаткиТоваров.Партия КАК Партия
	|ИЗ
	|	РегистрСведений.ОстаткиТоваров КАК ОстаткиТоваров
	|ГДЕ
	|	ОстаткиТоваров.Номенклатура В(&Номенклатура)
	|	И ОстаткиТоваров.СтруктурнаяЕдиница В(&Склады)
	|	И ОстаткиТоваров.Организация В (&Организации)
	|	И (&ИспользоватьХарактеристики
	|			ИЛИ ОстаткиТоваров.Характеристика = &ХарактеристикаПустаяСсылка)";
	
	Запрос.УстановитьПараметр("Организации", Организации);
	Запрос.УстановитьПараметр("Склады", Склады);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("ИспользоватьХарактеристики", ДанныеНастройки.ИспользоватьХарактеристики);
	Запрос.УстановитьПараметр("ХарактеристикаПустаяСсылка", Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка());
	
	Результат = Запрос.Выполнить().Выбрать();
	
	УзлыОбмена = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(УзелОбмена);
	
	Пока Результат.Следующий() Цикл
		НаборЗаписей = РегистрыСведений.ОстаткиТоваров.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Организация.Установить(Результат.Организация);
		НаборЗаписей.Отбор.СтруктурнаяЕдиница.Установить(Результат.СтруктурнаяЕдиница);
		НаборЗаписей.Отбор.Номенклатура.Установить(Результат.Номенклатура);
		НаборЗаписей.Отбор.Характеристика.Установить(Результат.Характеристика);
		НаборЗаписей.Отбор.Партия.Установить(Результат.Партия);
		ПланыОбмена.ЗарегистрироватьИзменения(УзлыОбмена, НаборЗаписей);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗарегистрироватьХарактеристикиНоменклатуры(УзелОбмена, НастройкаПубликацииМЛК, Номенклатура)
	
	ХарактеристикиНоменклатуры = Новый Массив;
	
	УзлыОбмена = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(УзелОбмена);
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ХарактеристикиНоменклатуры.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|ГДЕ
	|	ХарактеристикиНоменклатуры.Владелец В(&Номенклатура)";
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	Результат = Запрос.Выполнить().Выбрать();
	Пока Результат.Следующий() Цикл
		ПланыОбмена.ЗарегистрироватьИзменения(УзлыОбмена, Результат.Ссылка);
		ХарактеристикиНоменклатуры.Добавить(Результат.Ссылка);
	КонецЦикла;
	
	ЗарегистрироватьКартинкиХарактеристик(УзелОбмена, НастройкаПубликацииМЛК, ХарактеристикиНоменклатуры);
	
КонецПроцедуры

Процедура ЗарегистрироватьДоговоры(УзелОбмена, Договоры)
	
	УзлыОбмена = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(УзелОбмена);
	
	Для каждого Договор Из Договоры Цикл
		ПланыОбмена.ЗарегистрироватьИзменения(УзлыОбмена, Договор);
	КонецЦикла;
	
КонецПроцедуры

Функция ДатаНачалаВыгрузкиДокументов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЦеныНоменклатурыСрезПоследних.Период КАК ПоследняяДатаДокументаУстановкаЦенНоменклатуры
		|ИЗ
		|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних КАК ЦеныНоменклатурыСрезПоследних
		|ГДЕ
		|	ЦеныНоменклатурыСрезПоследних.ДокументУстановки <> ЗНАЧЕНИЕ(Документ.УстановкаЦенНоменклатуры.ПустаяСсылка)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЦеныНоменклатурыСрезПоследних.Период";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.ПоследняяДатаДокументаУстановкаЦенНоменклатуры;
	Иначе
		Возврат НачалоДня(ТекущаяДатаСеанса());
	КонецЕсли;
	
КонецФункции // ()

Функция АктивированныеПромокодыРежимСервиса(ВызыватьИсключениеПриОшибке = Истина,
		КодСостояния = 0, КодОтвета = 0, Сообщение = "") Экспорт

	Служебный = ПрограммныйИнтерфейсСервисаСлужебный;
	Метод = "promo_code/list";
	Абонент = ПрограммныйИнтерфейсСервиса.АбонентЭтогоПриложения();
	КодАбонента = Абонент.Код;
	ДанныеЗапроса = Служебный.ШаблонЗапроса(Метод);
	ДанныеЗапроса.Вставить("account", КодАбонента);

	Результат = Служебный.ОтправитьДанныеВМенеджерСервиса(ДанныеЗапроса, Метод);
	ДанныеОтвета = Служебный.РезультатВыполнения(Результат, ВызыватьИсключениеПриОшибке, КодСостояния, КодОтвета, Сообщение);

	Переименования = Новый Соответствие;
	Переименования.Вставить("activated", "ДатаАктивации");
	Переименования.Вставить("success",   "АктивированУспешно");
	Переименования.Вставить("id",        "Промокод");
	
	Если ДанныеОтвета <> Неопределено Тогда
		Значения = Служебный.МассивСтруктурВТаблицуЗначений(ДанныеОтвета.code, Переименования);
	Иначе 
		Значения = Новый ТаблицаЗначений;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли

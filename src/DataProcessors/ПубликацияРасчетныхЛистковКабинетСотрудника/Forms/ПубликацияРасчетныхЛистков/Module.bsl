
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ПодготовитьДанныеДляТехПоддержки", ПодготовитьДанныеДляТехПоддержки);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
				"ДекорацияПодготовитьДанныеДляТехПоддержки", "Видимость", ПодготовитьДанныеДляТехПоддержки);
	
	// Организация Месяц МесяцОпубликованных
	ЗначенияДляЗаполнения = Новый Структура("Организация,Месяц", "Объект.Организация", "Объект.Месяц");
	ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗначенияДляЗаполнения);
	Если Не ЗначениеЗаполнено(Объект.Месяц) Тогда
		Объект.Месяц = ТекущаяДатаСеанса();
	КонецЕсли;
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтотОбъект, "Объект.Месяц", "МесяцСтрокой");
	
	УстановитьПривилегированныйРежим(Истина);
	// Проверка доступности приложения по наличию ключей.
	ЕстьКлючиПриложения = КабинетСотрудника.ЕстьКлючиПриложения();
	КлючиПриложенияАктуальные = Ложь;
	Если ЕстьКлючиПриложения Тогда
		КлючиПриложенияАктуальные = КабинетСотрудника.КлючиПриложенияАктуальные();
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
	СервисДоступен = ЕстьКлючиПриложения И КлючиПриложенияАктуальные;
	Элементы.ГруппаПриложениеНедоступно.Видимость = Не СервисДоступен;
	Элементы.ГруппаПубликация.Доступность = СервисДоступен;
	
	РасчетныеЛистыЗаМесяц = Истина;
	РасчетныеЛисткиПервойПоловиныМесяцаДоступны = КабинетСотрудника.РасчетныеЛисткиПервойПоловиныМесяцаДоступны();
	
	ПрочитатьНастройкиИнтеграции();
	
	ИнициализироватьСписки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МесяцПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.Месяц", "МесяцСтрокой");
	ОбновитьСписокКПубликации();
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Оповещение = Новый ОписаниеОповещения("МесяцНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.Месяц", "МесяцСтрокой", Ложь, Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	ОбновитьСписокКПубликации();
КонецПроцедуры

&НаКлиенте
Процедура МесяцРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.Месяц", "МесяцСтрокой", Направление);
	ПодключитьОбработчикОжидания("ОбработчикОжиданияМесяцПриРегулировании", 0.3, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияМесяцПриРегулировании()
	ОбновитьСписокКПубликации();
КонецПроцедуры

&НаКлиенте
Процедура МесяцАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура МесяцОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура МесяцОпубликованногоПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.МесяцОпубликованных", "МесяцОпубликованногоСтрокой");
	ОбновитьСписокОпубликованных();
КонецПроцедуры

&НаКлиенте
Процедура МесяцОпубликованногоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Оповещение = Новый ОписаниеОповещения("МесяцОпубликованногоНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.МесяцОпубликованных", "МесяцОпубликованногоСтрокой", Ложь, Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура МесяцОпубликованногоНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	ОбновитьСписокОпубликованных();
КонецПроцедуры

&НаКлиенте
Процедура МесяцОпубликованногоРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.МесяцОпубликованных", "МесяцОпубликованногоСтрокой", Направление);
	ПодключитьОбработчикОжидания("ОбработчикОжиданияМесяцОпубликованногоПриРегулировании", 0.3, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияМесяцОпубликованногоПриРегулировании()
	ОбновитьСписокОпубликованных();
КонецПроцедуры

&НаКлиенте
Процедура МесяцОпубликованногоАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура МесяцОпубликованногоОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОбновитьСписокКПубликации();
	ОбновитьСписокОпубликованных();
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	ОбновитьСписокКПубликации();
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеОпубликованногоПриИзменении(Элемент)
	ОбновитьСписокОпубликованных();
КонецПроцедуры

&НаКлиенте
Процедура РасчетныеЛистыЗаМесяцПриИзменении(Элемент)
	
	ИнициализироватьСписки();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОтчетаПриИзменении(Элемент)
	Если РасчетныеЛистыЗаМесяц Тогда
		ВариантОтчетаРасчетныйЛисток = ВариантОтчета;
	Иначе
		ВариантОтчетаРасчетныйЛистокЗаПервуюПоловину = ВариантОтчета;
	КонецЕсли;
	ПодключитьОбработчикОжидания("ПриИзмененииВариантаОтчета", 0.1, Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыФизическиеЛицаКПубликации

&НаКлиенте
Процедура ФизическиеЛицаКПубликацииПубликуетсяПриИзменении(Элемент)
	
	ПубликуемыеСтроки = Объект.ФизическиеЛицаКПубликации.НайтиСтроки(Новый Структура("Публиковать", Истина));
	ЗаголовокНадписьКПубликации(ЭтотОбъект, ПубликуемыеСтроки.Количество());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыОпубликованные

&НаКлиенте
Процедура ОпубликованныеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.ДокументКадровогоЭДО) Тогда
		ПараметрыФормы = Новый Структура("Ключ", Элемент.ТекущиеДанные.ДокументКадровогоЭДО);
		ОткрытьФорму("Документ.ДокументКадровогоЭДО.Форма.ФормаДокумента", ПараметрыФормы);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОпубликованныеПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Опубликовать(Команда)
	
	Если ПубликацияНедоступна() Тогда
		Возврат;
	КонецЕсли;
	
	Если ПодготовитьДанныеДляТехПоддержки Тогда
		ПоказатьВопросПередПубликацией(Ложь, Ложь)
	Иначе
		ОпубликоватьРасчетныеЛистки(Ложь, Ложь);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОпубликоватьПовторно(Команда)
	
	Если ПубликацияНедоступна() Тогда
		Возврат;
	КонецЕсли;
	
	Если ПодготовитьДанныеДляТехПоддержки Тогда
		ПоказатьВопросПередПубликацией(Истина, Ложь)
	Иначе
		ОпубликоватьРасчетныеЛистки(Истина, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОпубликоватьПовторноВсе(Команда)
	
	Если ПубликацияНедоступна() Тогда
		Возврат;
	КонецЕсли;
	
	Если ПодготовитьДанныеДляТехПоддержки Тогда
		ПоказатьВопросПередПубликацией(Истина, Истина)
	Иначе
		ОпубликоватьРасчетныеЛистки(Истина, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	Для каждого СтрокаТЧ Из Объект.ФизическиеЛицаКПубликации Цикл
		СтрокаТЧ.Публиковать = Истина;
	КонецЦикла;
	
	ЗаголовокНадписьКПубликации(ЭтотОбъект, Объект.ФизическиеЛицаКПубликации.Количество());
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	
	Для каждого СтрокаТЧ Из Объект.ФизическиеЛицаКПубликации Цикл
		СтрокаТЧ.Публиковать = Ложь;
	КонецЦикла;
	
	ЗаголовокНадписьКПубликации(ЭтотОбъект, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьДанныеПоЗарплатеОтдельнымЗапросом(Команда)
	
	Элементы.ОпубликованныеФормироватьДанныеПоЗарплатеОтдельнымЗапросом.Пометка =
		Не Элементы.ОпубликованныеФормироватьДанныеПоЗарплатеОтдельнымЗапросом.Пометка;
	
	ФормироватьРасчетныеЛистыОтдельнымЗапросом = Элементы.ОпубликованныеФормироватьДанныеПоЗарплатеОтдельнымЗапросом.Пометка;
	ПодключитьОбработчикОжидания("СохранитьФормироватьРасчетныеЛистыОтдельнымЗапросом", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСписокКПубликации(ОбновитьСписокПубликации = Ложь);
	
	НеПубликуемые = Новый Соответствие;
	Если ОбновитьСписокПубликации Тогда
		Для каждого СтрокаТЧ Из Объект.ФизическиеЛицаКПубликации Цикл
			Если Не СтрокаТЧ.Публиковать Тогда
				НеПубликуемые.Вставить(СтрокаТЧ.ФизическоеЛицо, Истина);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Объект.ФизическиеЛицаКПубликации.Очистить();
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		
		ПараметрыПолученияСотрудников = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
		ПараметрыПолученияСотрудников.Организация = Объект.Организация;
		ПараметрыПолученияСотрудников.Подразделение = Объект.Подразделение;
		ПараметрыПолученияСотрудников.НачалоПериода = Объект.Месяц;
		ПараметрыПолученияСотрудников.ОкончаниеПериода = КонецМесяца(Объект.Месяц);
		ПараметрыПолученияСотрудников.КадровыеДанные = "Организация";
		КадровыйУчет.СоздатьВТСотрудникиОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, ПараметрыПолученияСотрудников);
		
		СостоянияПубликации = Новый Массив;
		СостоянияПубликации.Добавить(Перечисления.СостоянияРасчетныхЛистковКабинетСотрудника.Опубликован);
		СостоянияПубликации.Добавить(Перечисления.СостоянияРасчетныхЛистковКабинетСотрудника.СотрудникОзнакомился);
		Запрос.УстановитьПараметр("СостоянияПубликации", СостоянияПубликации);
		Запрос.УстановитьПараметр("МесяцПубликации", Объект.Месяц);
		Запрос.УстановитьПараметр("Организация", Объект.Организация);
		Запрос.УстановитьПараметр("ПерваяПоловинаМесяца", Не РасчетныеЛистыЗаМесяц);
		
		Если Не КабинетСотрудника.ИспользоватьФормат30396() Тогда
			Запрос.Текст = 
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо
			|ПОМЕСТИТЬ ВТФизическиеЛица
			|ИЗ
			|	ВТСотрудникиОрганизации КАК Сотрудники
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВыгружаемыеОбъектыКабинетСотрудника КАК ВыгружаемыеОбъекты
			|		ПО Сотрудники.Сотрудник = ВыгружаемыеОбъекты.Ссылка
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОшибкиЗаполненияОбъектовУправлениеПерсоналом КАК ОшибкиЗаполнения
			|		ПО Сотрудники.ФизическоеЛицо = ОшибкиЗаполнения.Ссылка
			|			И (ОшибкиЗаполнения.БлокирующаяОшибка)
			|			И (ОшибкиЗаполнения.Приложение = ЗНАЧЕНИЕ(Перечисление.ПриложенияДляИнтеграции.КабинетСотрудника))
			|ГДЕ
			|	ОшибкиЗаполнения.БлокирующаяОшибка ЕСТЬ NULL
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ТаблицаФизическиеЛица.ФизическоеЛицо КАК ФизическоеЛицо,
			|	ИСТИНА КАК Публиковать
			|ИЗ
			|	ВТФизическиеЛица КАК ТаблицаФизическиеЛица
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК ФизическиеЛица
			|		ПО ТаблицаФизическиеЛица.ФизическоеЛицо = ФизическиеЛица.Ссылка
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РасчетныеЛисткиКабинетСотрудника КАК РасчетныеЛисткиКабинетСотрудника
			|		ПО ТаблицаФизическиеЛица.ФизическоеЛицо = РасчетныеЛисткиКабинетСотрудника.ФизическоеЛицо
			|			И (РасчетныеЛисткиКабинетСотрудника.Организация = &Организация)
			|			И (РасчетныеЛисткиКабинетСотрудника.Месяц = &МесяцПубликации)
			|			И (РасчетныеЛисткиКабинетСотрудника.ПерваяПоловинаМесяца = &ПерваяПоловинаМесяца)
			|			И (РасчетныеЛисткиКабинетСотрудника.СостояниеПубликации В (&СостоянияПубликации))
			|ГДЕ
			|	РасчетныеЛисткиКабинетСотрудника.ФизическоеЛицо ЕСТЬ NULL
			|
			|УПОРЯДОЧИТЬ ПО
			|	ФизическиеЛица.Наименование";
		Иначе
			Запрос.Текст = 
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо
			|ПОМЕСТИТЬ ВТФизическиеЛица
			|ИЗ
			|	ВТСотрудникиОрганизации КАК Сотрудники
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВыгружаемыеОбъектыКабинетСотрудника КАК ФизическиеЛица
			|		ПО Сотрудники.ФизическоеЛицо = ФизическиеЛица.Ссылка
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОшибкиЗаполненияОбъектовУправлениеПерсоналом КАК ОшибкиЗаполнения
			|		ПО Сотрудники.ФизическоеЛицо = ОшибкиЗаполнения.Ссылка
			|			И (ОшибкиЗаполнения.БлокирующаяОшибка)
			|			И (ОшибкиЗаполнения.Приложение = ЗНАЧЕНИЕ(Перечисление.ПриложенияДляИнтеграции.КабинетСотрудника))
			|ГДЕ
			|	ОшибкиЗаполнения.БлокирующаяОшибка ЕСТЬ NULL
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ТаблицаФизическиеЛица.ФизическоеЛицо КАК ФизическоеЛицо,
			|	ИСТИНА КАК Публиковать
			|ИЗ
			|	ВТФизическиеЛица КАК ТаблицаФизическиеЛица
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК ФизическиеЛица
			|		ПО ТаблицаФизическиеЛица.ФизическоеЛицо = ФизическиеЛица.Ссылка
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РасчетныеЛисткиКабинетСотрудника КАК РасчетныеЛисткиКабинетСотрудника
			|		ПО ТаблицаФизическиеЛица.ФизическоеЛицо = РасчетныеЛисткиКабинетСотрудника.ФизическоеЛицо
			|			И (РасчетныеЛисткиКабинетСотрудника.Организация = &Организация)
			|			И (РасчетныеЛисткиКабинетСотрудника.Месяц = &МесяцПубликации)
			|			И (РасчетныеЛисткиКабинетСотрудника.ПерваяПоловинаМесяца = &ПерваяПоловинаМесяца)
			|			И (РасчетныеЛисткиКабинетСотрудника.СостояниеПубликации В (&СостоянияПубликации))
			|ГДЕ
			|	РасчетныеЛисткиКабинетСотрудника.ФизическоеЛицо ЕСТЬ NULL
			|
			|УПОРЯДОЧИТЬ ПО
			|	ФизическиеЛица.Наименование";
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Истина);
		// Привилегированный режим допустим, т.к. ВТСотрудникиОрганизации содержит только разрешенные данные.
		Выборка = Запрос.Выполнить().Выбрать();
		УстановитьПривилегированныйРежим(Ложь);
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = Объект.ФизическиеЛицаКПубликации.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			Если ОбновитьСписокПубликации Тогда
				Если НеПубликуемые[НоваяСтрока.ФизическоеЛицо] <> Неопределено Тогда
					НоваяСтрока.Публиковать = Ложь;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	ПубликуемыеСтроки = Объект.ФизическиеЛицаКПубликации.НайтиСтроки(Новый Структура("Публиковать", Истина));
	ЗаголовокНадписьКПубликации(ЭтотОбъект, ПубликуемыеСтроки.Количество());
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокОпубликованных();
	ОбновитьСписокОпубликованныхНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокОпубликованныхНаСервере()
	
	СостоянияПубликации = Новый Массив;
	СостоянияПубликации.Добавить(Перечисления.СостоянияРасчетныхЛистковКабинетСотрудника.Опубликован);
	СостоянияПубликации.Добавить(Перечисления.СостоянияРасчетныхЛистковКабинетСотрудника.СотрудникОзнакомился);
	
	ПараметрыЗапроса = Новый Структура("Организация,Месяц,СостоянияОпубликованы,ФизическиеЛица,ВсеФизическиеЛица,ПерваяПоловинаМесяца");
	ПараметрыЗапроса.Организация 			= Объект.Организация;
	ПараметрыЗапроса.Месяц 					= Объект.МесяцОпубликованных;
	ПараметрыЗапроса.СостоянияОпубликованы 	= СостоянияПубликации;
	ПараметрыЗапроса.ФизическиеЛица 		= Новый Массив;
	ПараметрыЗапроса.ВсеФизическиеЛица 		= Ложь;
	ПараметрыЗапроса.ПерваяПоловинаМесяца	= Не РасчетныеЛистыЗаМесяц;
	
	Если ЗначениеЗаполнено(Объект.Организация) И ЗначениеЗаполнено(Объект.ПодразделениеОпубликованных) Тогда
		
		ПараметрыПолученияСотрудников = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
		ПараметрыПолученияСотрудников.Организация = Объект.Организация;
		ПараметрыПолученияСотрудников.Подразделение = Объект.ПодразделениеОпубликованных;
		ПараметрыПолученияСотрудников.НачалоПериода = Объект.МесяцОпубликованных;
		ПараметрыПолученияСотрудников.ОкончаниеПериода = КонецМесяца(Объект.МесяцОпубликованных);
		
		СотрудникиОрганизации = КадровыйУчет.СотрудникиОрганизации(Истина, ПараметрыПолученияСотрудников);
		ПараметрыЗапроса.ФизическиеЛица = ОбщегоНазначения.ВыгрузитьКолонку(СотрудникиОрганизации, "ФизическоеЛицо", Истина);
		
	Иначе
		ПараметрыЗапроса.ВсеФизическиеЛица = Истина;
	КонецЕсли;
	
	ОпубликованныеРасчетныеЛистки.Параметры.УстановитьЗначениеПараметра("Месяц", 					ПараметрыЗапроса.Месяц);
	ОпубликованныеРасчетныеЛистки.Параметры.УстановитьЗначениеПараметра("Организация", 				ПараметрыЗапроса.Организация);
	ОпубликованныеРасчетныеЛистки.Параметры.УстановитьЗначениеПараметра("СостоянияОпубликованы", 	ПараметрыЗапроса.СостоянияОпубликованы);
	ОпубликованныеРасчетныеЛистки.Параметры.УстановитьЗначениеПараметра("ВсеФизическиеЛица", 		ПараметрыЗапроса.ВсеФизическиеЛица);
	ОпубликованныеРасчетныеЛистки.Параметры.УстановитьЗначениеПараметра("ФизическиеЛица", 			ПараметрыЗапроса.ФизическиеЛица);
	ОпубликованныеРасчетныеЛистки.Параметры.УстановитьЗначениеПараметра("ПерваяПоловинаМесяца", 	ПараметрыЗапроса.ПерваяПоловинаМесяца);
	
	Запрос = Новый Запрос();
	Для каждого ЭлементКоллекции Из ПараметрыЗапроса Цикл
		Запрос.УстановитьПараметр(ЭлементКоллекции.Ключ, ЭлементКоллекции.Значение);
	КонецЦикла;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(РасчетныеЛисткиКабинетСотрудника.ДатаПубликации) КАК Количество
	|ИЗ
	|	РегистрСведений.РасчетныеЛисткиКабинетСотрудника КАК РасчетныеЛисткиКабинетСотрудника
	|ГДЕ
	|	РасчетныеЛисткиКабинетСотрудника.Организация = &Организация
	|	И РасчетныеЛисткиКабинетСотрудника.Месяц = &Месяц
	|	И РасчетныеЛисткиКабинетСотрудника.СостояниеПубликации В(&СостоянияОпубликованы)
	|	И (&ВсеФизическиеЛица
	|			ИЛИ РасчетныеЛисткиКабинетСотрудника.ФизическоеЛицо В (&ФизическиеЛица))
	|	И РасчетныеЛисткиКабинетСотрудника.ПерваяПоловинаМесяца = &ПерваяПоловинаМесяца";
	РезультатЗапроса = Запрос.Выполнить();
	КоличествоОпубликованных = 0;
	Если Не РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		КоличествоОпубликованных = Выборка.Количество;
	КонецЕсли;
	
	Если РасчетныеЛисткиПервойПоловиныМесяцаДоступны Тогда
		Элементы.НадписьОпубликованныеКПубликации.Заголовок = СтрШаблон(
			НСтр("ru = 'Опубликовано расчетных листков (%1): %2'"),
			ВидРасчетногоЛистаСтрокой(РасчетныеЛистыЗаМесяц),
			КоличествоОпубликованных);
	Иначе
		Элементы.НадписьОпубликованныеКПубликации.Заголовок = СтрШаблон(НСтр("ru = 'Опубликовано расчетных листков: %1'"), КоличествоОпубликованных);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДлительнаяОперацияОпубликоватьНаСервере(ПараметрыПубликации)
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.Вставить("НаименованиеФоновогоЗадания",
		СтрШаблон(НСтр("ru = 'Выгрузка расчетных листов в 1С:Кабинет сотрудника'")));
	ПараметрыВыполненияВФоне.ОжидатьЗавершение = 0;
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне(
		"КабинетСотрудника.ОпубликоватьРасчетныеЛистыВФоне",
		ПараметрыПубликации,
		ПараметрыВыполненияВФоне);
		
	Возврат ДлительнаяОперация;
	
КонецФункции

&НаСервере
Процедура НачальноеЗаполнение()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПерваяПоловинаМесяца", Не РасчетныеЛистыЗаМесяц);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	РасчетныеЛисткиКабинетСотрудника.Месяц КАК Месяц
	|ИЗ
	|	РегистрСведений.РасчетныеЛисткиКабинетСотрудника КАК РасчетныеЛисткиКабинетСотрудника
	|ГДЕ
	|	РасчетныеЛисткиКабинетСотрудника.ПерваяПоловинаМесяца = &ПерваяПоловинаМесяца
	|
	|УПОРЯДОЧИТЬ ПО
	|	Месяц УБЫВ";
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Объект.МесяцОпубликованных = Объект.Месяц;
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Объект.МесяцОпубликованных = Выборка.Месяц;
	КонецЕсли;
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтотОбъект, "Объект.МесяцОпубликованных", "МесяцОпубликованногоСтрокой");
	
	ОбновитьСписокКПубликации();
	ОбновитьСписокОпубликованныхНаСервере();
	
КонецПроцедуры

&НаСервере
Функция ФизическиеЛицаСОпубликованнымиЛистками()
	
	ФизическиеЛица = Новый Массив;
	Если ЗначениеЗаполнено(Объект.ПодразделениеОпубликованных) Тогда
		
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		
		ПараметрыПолученияСотрудников = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
		ПараметрыПолученияСотрудников.Организация = Объект.Организация;
		ПараметрыПолученияСотрудников.Подразделение = Объект.ПодразделениеОпубликованных;
		ПараметрыПолученияСотрудников.НачалоПериода = Объект.МесяцОпубликованных;
		ПараметрыПолученияСотрудников.ОкончаниеПериода = КонецМесяца(Объект.МесяцОпубликованных);
		
		СотрудникиОрганизации = КадровыйУчет.СотрудникиОрганизации(Истина, ПараметрыПолученияСотрудников);
		ФизическиеЛица = ОбщегоНазначения.ВыгрузитьКолонку(СотрудникиОрганизации, "ФизическоеЛицо", Истина);
		
		Если ФизическиеЛица.Количество() = 0 Тогда
			Возврат ФизическиеЛица;
		КонецЕсли;
		
	КонецЕсли;
	
	СостоянияПубликации = Новый Массив;
	СостоянияПубликации.Добавить(Перечисления.СостоянияРасчетныхЛистковКабинетСотрудника.Опубликован);
	СостоянияПубликации.Добавить(Перечисления.СостоянияРасчетныхЛистковКабинетСотрудника.СотрудникОзнакомился);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Месяц", Объект.МесяцОпубликованных);
	Запрос.УстановитьПараметр("СостоянияОпубликованы", СостоянияПубликации);
	Запрос.УстановитьПараметр("ВсеФизическиеЛица", ФизическиеЛица.Количество() = 0);
	Запрос.УстановитьПараметр("ФизическиеЛица", ФизическиеЛица);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетныеЛисткиКабинетСотрудника.ФизическоеЛицо КАК ФизическоеЛицо
	|ИЗ
	|	РегистрСведений.РасчетныеЛисткиКабинетСотрудника КАК РасчетныеЛисткиКабинетСотрудника
	|ГДЕ
	|	РасчетныеЛисткиКабинетСотрудника.Организация = &Организация
	|	И РасчетныеЛисткиКабинетСотрудника.Месяц = &Месяц
	|	И РасчетныеЛисткиКабинетСотрудника.СостояниеПубликации В(&СостоянияОпубликованы)
	|	И (&ВсеФизическиеЛица
	|			ИЛИ РасчетныеЛисткиКабинетСотрудника.ФизическоеЛицо В (&ФизическиеЛица))";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ФизическоеЛицо");
	
КонецФункции

&НаКлиенте
Функция ОрганизацияЗаполнена()

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат Истина;
	Иначе	
		ТекстСообщения = НСтр("ru = 'Поле ""Организация"" не заполнено'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Организация");
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция СервисЗаблокирован()

	Возврат КабинетСотрудника.СервисЗаблокирован(); 

КонецФункции	

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаголовокНадписьКПубликации(УправляемаяФорма, КоличествоКПубликации)
	
	Элементы = УправляемаяФорма.Элементы;
	Если УправляемаяФорма.РасчетныеЛисткиПервойПоловиныМесяцаДоступны Тогда
		Элементы.НадписьКПубликации.Заголовок  = СтрШаблон(
			НСтр("ru = 'Количество сотрудников, по которым будут опубликованы расчетные листы (%1): %2'"),
			ВидРасчетногоЛистаСтрокой(УправляемаяФорма.РасчетныеЛистыЗаМесяц),
			КоличествоКПубликации);
	Иначе
		Элементы.НадписьКПубликации.Заголовок  = СтрШаблон(НСтр("ru = 'Количество сотрудников, по которым будут опубликованы расчетные листы: %1'"), КоличествоКПубликации);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПубликацияНедоступна()

	Если СервисЗаблокирован() Тогда
		ТекстСообщения = КабинетСотрудникаКлиент.ТекстСообщенияОБлокировкеСервиса();
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат Истина;
	КонецЕсли;
	
	Если Не ОрганизацияЗаполнена() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ПодготовитьДанныеДляТехПоддержки И ЕстьАктивныеФоновыеЗадания() Тогда
		ТекстСообщения = НСтр("ru = 'Публикация уже выполняется, повторите попытку позже.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;

КонецФункции

&НаКлиенте
Процедура ОпубликоватьЗавершение(ДлительнаяОперация, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДлительнаяОперация.Статус = "Ошибка" Тогда
		ПоказатьПредупреждение(, ДлительнаяОперация.КраткоеПредставлениеОшибки);
	ИначеЕсли ДлительнаяОперация.Статус = "Выполнено" Тогда
		
		ОбновитьСписокКПубликации(Истина);
		ОбновитьСписокОпубликованныхНаСервере();
		
		Результат = ПолучитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата);
		Если Результат.БылиОшибки Тогда
			СообщениеОбОшибке = НСтр("ru = 'Публикация расчетных листков завершена с ошибками.'");
			ПоказатьПредупреждение(, СообщениеОбОшибке);
		Иначе
			Если Не ЗначениеЗаполнено(Результат.КоличествоВыгружено) Тогда
				ТекстСообщения = НСтр("ru = 'У выбранных сотрудников нет данных для публикации расчетных листков.'");
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
			ИначеЕсли ЗначениеЗаполнено(Результат.НеОбработаны) Тогда
				ТекстСообщения = НСтр("ru = 'Нет данных для публикации расчетных листков:'");
				Для каждого ФизическоеЛицо Из Результат.НеОбработаны Цикл
					ТекстСообщения = СтрШаблон("%1%2%3",ТекстСообщения, Символы.ПС,Строка(ФизическоеЛицо));
				КонецЦикла;
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВопросПередПубликацией(ПовторнаяПубликация, ОбновитьВсе);

	ДополнительныеПараметры = Новый Структура("ПовторнаяПубликация,ОбновитьВсе", ПовторнаяПубликация, ОбновитьВсе);
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОпубликоватьПродолжение", ЭтаФорма, ДополнительныеПараметры);
	ЗаголовокВопроса = НСтр("ru = 'Подтверждение'");
	ПоказатьВопрос(
		ОповещениеОЗавершении,
		НСтр("ru = 'Подготовка данных для отправки в службу технической поддержки сервиса.
		|Публикация расчетных листков будет выполнена с записью событий в журнал регистрации и выгрузкой журнал в файл для отправки в службу технической поддержки.'"),
		ИнтеграцияУправлениеПерсоналомКлиента.ОписаниеКнопокВопроса(),,,ЗаголовокВопроса);

КонецПроцедуры

&НаКлиенте
Процедура ОпубликоватьПродолжение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		ОчиститьСообщения();
		ПараметрыПубликации = ПараметрыПубликации(ДополнительныеПараметры.ПовторнаяПубликация, ДополнительныеПараметры.ОбновитьВсе);
		ВыполнитьПубликациюСохранитьЖурнал(ПараметрыПубликации);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОпубликоватьРасчетныеЛистки(ПовторнаяПубликация, ОбновитьВсе)
	
	ОчиститьСообщения();
	
	ПараметрыПубликации = ПараметрыПубликации(ПовторнаяПубликация, ОбновитьВсе);
	
	Если ПараметрыПубликации.СписокФизическихЛиц.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Список сотрудников для публикации расчетных листков пустой.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ДлительнаяОперация = ДлительнаяОперацияОпубликоватьНаСервере(ПараметрыПубликации);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Истина;
	ПараметрыОжидания.ОповещениеПользователя.Текст = НСтр("ru = 'Публикация расчетных листков выполнена.'");
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОпубликоватьЗавершение", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьАктивныеФоновыеЗадания()

	Возврат КабинетСотрудника.ЕстьАктивныеФоновыеЗаданияОбменПубликация();

КонецФункции

&НаКлиенте
Функция ПараметрыПубликации(ПовторнаяПубликация, ОбновитьВсе)

	ПараметрыПубликации = Новый Структура;
	ПараметрыПубликации.Вставить("ПовторнаяПубликация", ПовторнаяПубликация);
	ПараметрыПубликации.Вставить("Организация", Объект.Организация);
	ПараметрыПубликации.Вставить("ПодготовитьДанныеДляТехПоддержки", Ложь);
	
	Если ПовторнаяПубликация Тогда
		ПараметрыПубликации.Вставить("МесяцРасчетныхЛистов", Объект.МесяцОпубликованных);
		Если ОбновитьВсе Тогда
			СписокФизическихЛиц = ФизическиеЛицаСОпубликованнымиЛистками();
		Иначе
			СписокФизическихЛиц = Новый Массив;
			Для Каждого ВыбраннаяСтрока Из Элементы.Опубликованные.ВыделенныеСтроки Цикл
				СписокФизическихЛиц.Добавить(Элементы.Опубликованные.ДанныеСтроки(ВыбраннаяСтрока).ФизическоеЛицо);
			КонецЦикла;
		КонецЕсли;
	Иначе
		ПараметрыПубликации.Вставить("МесяцРасчетныхЛистов", Объект.Месяц);
		СписокФизическихЛиц = Новый Массив;
		Для каждого СтрокаТЧ Из Объект.ФизическиеЛицаКПубликации Цикл
			Если СтрокаТЧ.Публиковать Тогда
				СписокФизическихЛиц.Добавить(СтрокаТЧ.ФизическоеЛицо);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	ПараметрыПубликации.Вставить("СписокФизическихЛиц", СписокФизическихЛиц);
	ПараметрыПубликации.Вставить("ВариантОтчета", ВариантОтчета);
	ПараметрыПубликации.Вставить("ПерваяПоловинаМесяца", Не РасчетныеЛистыЗаМесяц);
	ПараметрыПубликации.Вставить("ФормироватьРасчетныеЛистыОтдельнымЗапросом", ФормироватьРасчетныеЛистыОтдельнымЗапросом);
	
	Возврат ПараметрыПубликации;

КонецФункции

&НаКлиенте
Процедура ВыполнитьПубликациюСохранитьЖурнал(ПараметрыПубликации)

	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыполнитьПубликациюСохранитьЖурналЗавершение", ЭтотОбъект);
	ПараметрыОткрытия = ПараметрыОбменаССохранениемРезультата(ИдентификаторПриложения);
	ПараметрыОткрытия.Вставить("ПараметрыМетода", ПараметрыПубликации);
	ОткрытьФорму("Обработка.ИнтеграцияУправлениеПерсоналом.Форма.ВыполнитьОбменСохранитьРезультат", ПараметрыОткрытия, ЭтаФорма,,,,ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПараметрыОбменаССохранениемРезультата(ИдентификаторПриложения)
	
	ИмяФайла = СтрШаблон("%1_%2", "EventLogPayslips", ИдентификаторПриложения);
	
	ПараметрыОткрытия = Новый Структура();
	ПараметрыОткрытия.Вставить("СобытиеОбмена", 		Перечисления.ВидыСобытийОбменаУправлениеПерсоналом.ПубликацияРасчетныхЛистков);
	ПараметрыОткрытия.Вставить("Приложение", 			Перечисления.ПриложенияДляИнтеграции.КабинетСотрудника);
	ПараметрыОткрытия.Вставить("ИмяФайла", 				ИмяФайла);
	ПараметрыОткрытия.Вставить("ИмяМетода", 			"КабинетСотрудника.ОпубликоватьРасчетныеЛистыВФоне");
	ПараметрыОткрытия.Вставить("КлючФоновогоЗадания", 	ИнтеграцияКабинетСотрудника.КлючФоновогоЗаданияОбмен());
	
	Возврат ПараметрыОткрытия;

КонецФункции

&НаКлиенте
Процедура ВыполнитьПубликациюСохранитьЖурналЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.РезультатВыполненияОбмена = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьСписокКПубликации(Истина);
	ОбновитьСписокОпубликованныхНаСервере();
	
	Если Результат.РезультатВыполненияОбмена.БылиОшибки Тогда
		СообщениеОбОшибке = НСтр("ru = 'Публикация расчетных листков завершена с ошибками.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеОбОшибке);
	КонецЕсли;
	
	Если Не ПустаяСтрока(Результат.ПолноеИмяФайла) Тогда
		ТекстСообщения = СтрШаблон("%1: %2", НСтр("ru = 'Данные сохранены в'"), Результат.ПолноеИмяФайла);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройкиИнтеграции()
	
	УстановитьПривилегированныйРежим(Истина);
	Настройки = РегистрыСведений.НастройкиИнтеграцииКабинетСотрудника.НастройкиИнтеграции();
	УстановитьПривилегированныйРежим(Ложь);
	
	ВариантОтчетаРасчетныйЛисток = Настройки.ВариантОтчетаРасчетныйЛисток;
	ВариантОтчетаРасчетныйЛистокЗаПервуюПоловину = Настройки.ВариантОтчетаРасчетныйЛистокЗаПервуюПоловину;
	ФормироватьРасчетныеЛистыОтдельнымЗапросом = Настройки.ФормироватьРасчетныеЛистыОтдельнымЗапросом;
	
	УстановитьВариантОтчета();
	
	ДоступноИзменениеНастроек = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.НастройкиИнтеграцииКабинетСотрудника);
	
	Элементы.ОпубликованныеФормироватьДанныеПоЗарплатеОтдельнымЗапросом.Пометка = ФормироватьРасчетныеЛистыОтдельнымЗапросом;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ВариантОтчета",
		"ТолькоПросмотр",
		Не ДоступноИзменениеНастроек);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"РасчетныеЛистыЗаМесяц",
		"Видимость",
		РасчетныеЛисткиПервойПоловиныМесяцаДоступны);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВариантОтчета()
	
	Если РасчетныеЛистыЗаМесяц Тогда
		ВариантОтчета = ВариантОтчетаРасчетныйЛисток;
		ИдентификаторОбъектаОтчета = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			Метаданные.Отчеты.АнализНачисленийИУдержаний);
	Иначе
		ВариантОтчета = ВариантОтчетаРасчетныйЛистокЗаПервуюПоловину;
		ИдентификаторОбъектаОтчета = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			Метаданные.Отчеты.АнализНачисленийИУдержанийАвансом);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		ОпубликованныеРасчетныеЛистки, "ПерваяПоловинаМесяца", Не РасчетныеЛистыЗаМесяц, Истина);
	
	Если ЗначениеЗаполнено(ВариантОтчета) Тогда
		ВариантОтчетаДоступен = ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВариантОтчета, "Ссылка", Истина));
	Иначе
		ВариантОтчетаДоступен = Истина;
	КонецЕсли;
	
	Если ВариантОтчетаДоступен Тогда
		ТекстПодсказки = НСтр("ru = 'Если отчет не выбран, используются настройки варианта отчета ""%1"" по умолчанию.'");
		ЦветТекста = Новый Цвет;
	Иначе
		Если ДоступноИзменениеНастроек Тогда
			ТекстПодсказки = НСтр("ru = 'Нет прав на использование, выбранного в настройках варианта отчета ""%1"". Можно выбрать другой вариант отчета (из числа доступных) или обратиться за помощью к администратору базы данных.'");
		Иначе
			ТекстПодсказки = НСтр("ru = 'Нет прав на использование, выбранного в настройках варианта отчета ""%1"". Обратитесь за помощью к администратору базы данных.'");
		КонецЕсли;
		ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста;
	КонецЕсли;
	
	ТекстПодсказки = СтрШаблон(ТекстПодсказки, ВидРасчетногоЛистаПоУмолчаниюСтрокой(РасчетныеЛистыЗаМесяц));
	
	ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(
		ЭтотОбъект, "ВыборВариантаГруппа", ТекстПодсказки);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ВыборВариантаГруппаРасширеннаяПодсказка",
		"ЦветТекста",
		ЦветТекста);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ВариантОтчета",
		"КнопкаОткрытия",
		ВариантОтчетаДоступен);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Опубликовать",
		"Доступность",
		ВариантОтчетаДоступен);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОпубликоватьПовторно",
		"Доступность",
		ВариантОтчетаДоступен);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОпубликоватьПовторноВсе",
		"Доступность",
		ВариантОтчетаДоступен);
	
	Если РасчетныеЛисткиПервойПоловиныМесяцаДоступны Тогда
		Заголовок = СтрШаблон(
			НСтр("ru = 'Публикация расчетных листков (%1) в сервисе 1С:Кабинет сотрудника'"),
			ВидРасчетногоЛистаСтрокой(РасчетныеЛистыЗаМесяц));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииВариантаОтчета()
	
	ПриИзмененииВариантаОтчетаНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииВариантаОтчетаНаСервере()
	
	Если РасчетныеЛистыЗаМесяц Тогда
		СохранитьВариантОтчетаРасчетныйЛистокНаСервере();
	Иначе
		СохранитьВариантОтчетаРасчетныйЛистокЗаПервуюПоловинуНаСервере();
	КонецЕсли;
	УстановитьВариантОтчета();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФормироватьРасчетныеЛистыОтдельнымЗапросом()
	СохранитьФормироватьРасчетныеЛистыОтдельнымЗапросомНаСервере();
КонецПроцедуры

&НаСервере
Процедура СохранитьВариантОтчетаРасчетныйЛистокНаСервере()
	РегистрыСведений.НастройкиИнтеграцииКабинетСотрудника.
		СохранитьЗначениеВариантОтчетаРасчетныйЛисток(
			ВариантОтчетаРасчетныйЛисток);
КонецПроцедуры

&НаСервере
Процедура СохранитьВариантОтчетаРасчетныйЛистокЗаПервуюПоловинуНаСервере()
	РегистрыСведений.НастройкиИнтеграцииКабинетСотрудника.
		СохранитьЗначениеВариантОтчетаРасчетныйЛистокЗаПервуюПоловину(
			ВариантОтчетаРасчетныйЛистокЗаПервуюПоловину);
КонецПроцедуры

&НаСервере
Процедура СохранитьФормироватьРасчетныеЛистыОтдельнымЗапросомНаСервере()
	РегистрыСведений.НастройкиИнтеграцииКабинетСотрудника.
		СохранитьЗначениеФормироватьРасчетныеЛистыОтдельнымЗапросом(
			ФормироватьРасчетныеЛистыОтдельнымЗапросом);
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьСписки()
	
	УстановитьВариантОтчета();
	
	Если СервисДоступен Тогда
		НачальноеЗаполнение();
	Иначе
		ОпубликованныеРасчетныеЛистки.Параметры.УстановитьЗначениеПараметра("Месяц", 					Дата(1,1,1));
		ОпубликованныеРасчетныеЛистки.Параметры.УстановитьЗначениеПараметра("Организация", 				Справочники.Организации.ПустаяСсылка());
		ОпубликованныеРасчетныеЛистки.Параметры.УстановитьЗначениеПараметра("СостоянияОпубликованы", 	Новый Массив);
		ОпубликованныеРасчетныеЛистки.Параметры.УстановитьЗначениеПараметра("ВсеФизическиеЛица", 		Ложь);
		ОпубликованныеРасчетныеЛистки.Параметры.УстановитьЗначениеПараметра("ФизическиеЛица", 			Новый Массив);
	КонецЕсли;
	
	Элементы.ОпубликованныеОзнакомился.Видимость = КабинетСотрудника.ИспользоватьФормат303();
	Элементы.Опубликованные.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОтчетаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КлючиВариантаОтчета = Новый Массив;
	Если РасчетныеЛистыЗаМесяц Тогда
		КлючиВариантаОтчета.Добавить("РасчетныйЛисток");
		КлючиВариантаОтчета.Добавить("РасчетныйЛистокСРазбивкойПоИсточникамФинансирования");
		КлючиВариантаОтчета.Добавить("РасчетныйЛистокУправленческий");
	Иначе
		КлючиВариантаОтчета.Добавить("РасчетныйЛистокПерваяПоловинаМесяца");
		КлючиВариантаОтчета.Добавить("РасчетныйЛистокСРазбивкойПоИсточникамФинансированияПерваяПоловинаМесяца");
	КонецЕсли;
	
	ФиксированныеНастройки = Новый НастройкиКомпоновкиДанных;
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ФиксированныеНастройки.Отбор,
		"Отчет",
		ВидСравненияКомпоновкиДанных.Равно,
		ИдентификаторОбъектаОтчета);
	
	ГруппаЭлементовОтбора = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		ФиксированныеНастройки.Отбор.Элементы,
		"ВариантОтчетИлиЕгоПользовательскаяВерсия",
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ГруппаЭлементовОтбора,
		"КлючВарианта",
		ВидСравненияКомпоновкиДанных.ВСписке,
		КлючиВариантаОтчета);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ГруппаЭлементовОтбора,
		"Ссылка.Родитель.КлючВарианта",
		ВидСравненияКомпоновкиДанных.ВСписке,
		КлючиВариантаОтчета);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ФиксированныеНастройки", ФиксированныеНастройки);
	ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытия.Вставить("МножественныйВыбор", Ложь);
	
	ОткрытьФорму("Справочник.ВариантыОтчетов.ФормаВыбора", ПараметрыОткрытия, Элемент, Истина, , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ВидРасчетногоЛистаСтрокой(РасчетныеЛистыЗаМесяц)
	Если РасчетныеЛистыЗаМесяц Тогда
		Возврат НСтр("ru = 'окончательный расчет'");
	КонецЕсли;
	Возврат НСтр("ru = 'за первую половину месяца'");
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ВидРасчетногоЛистаПоУмолчаниюСтрокой(РасчетныеЛистыЗаМесяц)
	Если РасчетныеЛистыЗаМесяц Тогда
		Возврат НСтр("ru = 'Расчетный листок'");
	КонецЕсли;
	Возврат НСтр("ru = 'Расчетный листок (за первую половину месяца)'");
КонецФункции

#КонецОбласти

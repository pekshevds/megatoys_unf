#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИнициализироватьВспомогательныеРеквизитыФормы();
	ОбработатьПереданныеПараметры();
	
	УстановитьЗаголовокФормы();
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
	СброситьРазмерыИПоложениеОкна();
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ОткрытьВходящееСообщение") Тогда
		
		ПоказатьЗначение(, ВходящееСообщение);
		
	ИначеЕсли СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ОткрытьИсходящееСообщение") Тогда
		
		ПоказатьЗначение(, ИсходящееСообщение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Предприятие) Тогда
		НаименованиеПредприятия = НаименованиеПредприятия(Предприятие);
	Иначе
		НаименованиеПредприятия = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	Если СостояниеВыполненияОперации = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиСообщенийВЕТИС.КПередаче")
		Или СостояниеВыполненияОперации = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиСообщенийВЕТИС.Ошибка") Тогда
		
		Если Не ЗначениеЗаполнено(Предприятие) Тогда
			ТекстСообщения = НСтр("ru = 'Не указано предприятие'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"Предприятие");
			Возврат;
		КонецЕсли;
		
		Элементы.СтраницыОбменСВЕТИС.Видимость = Истина;
		
		Если ВариантИзменения = "Связывание"
			Или ВариантИзменения = "ИзменениеGLN" Тогда
			ВыполнитьЗапросНаСозданиеСвязиСПредприятием();
		ИначеЕсли ВариантИзменения = "РазрывСвязи" Тогда
			ВыполнитьЗапросНаРазрывСвязиСПредприятием();
		КонецЕсли;
		
	ИначеЕсли СостояниеВыполненияОперации = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиСообщенийВЕТИС.ЗаявкаОбрабатывается") Тогда
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ВыполнениеЗапросовКВЕТИС

&НаКлиенте
Процедура ВыполнитьЗапросНаСозданиеСвязиСПредприятием()
	
	Если ЗначениеЗаполнено(GLN) И СтрДлина(GLN) <> 13 Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Длина GLN должна быть ровно 13 символов!'"),,,"GLN");
		
	Иначе
		
		РезультатОбмена = ЗаявкиВЕТИСВызовСервера.ПодготовитьЗапросНаСозданиеУдалениеСвязиПредприятияИХозяйствующегоСубъекта(
			ХозяйствующийСубъект,
			Предприятие,
			ПредопределенноеЗначение("Перечисление.СпособыИзмененияВерсионныхОбъектовВЕТИС.Создать"),
			GLN,
			УникальныйИдентификатор);
		
		ОбработатьРезультатОбменаСВЕТИС(РезультатОбмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗапросНаРазрывСвязиСПредприятием()
	
	РезультатОбмена = ЗаявкиВЕТИСВызовСервера.ПодготовитьЗапросНаСозданиеУдалениеСвязиПредприятияИХозяйствующегоСубъекта(
	                      ХозяйствующийСубъект,
	                      Предприятие,
	                      ПредопределенноеЗначение("Перечисление.СпособыИзмененияВерсионныхОбъектовВЕТИС.Удалить"),
	                      GLN,
	                      УникальныйИдентификатор);
	
	ОбработатьРезультатОбменаСВЕТИС(РезультатОбмена);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаРезультатовЗапросов

&НаКлиенте
Процедура ОбработатьРезультатОбменаСВЕТИС(РезультатОбмена)
	
	ДанныеДляОбработки = Неопределено;
	
	КоличествоИзменений = РезультатОбмена.Изменения.Количество();

	Если КоличествоИзменений > 0 Тогда
		ДанныеДляОбработки = РезультатОбмена.Изменения[КоличествоИзменений - 1];
	КонецЕсли;
	
	Если ДанныеДляОбработки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если РезультатОбмена.Ожидать <> Неопределено Тогда
		ПереключитьНаСтраницуОжиданияРезультатаЗапроса(ДанныеДляОбработки);
	КонецЕсли;
	
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
	ИнтеграцияВЕТИСКлиент.ОбработатьРезультатОбмена(РезультатОбмена, ЭтотОбъект,, ОповещениеПриЗавершенииОбмена(), Ложь);
	
КонецПроцедуры

#Область Ожидание

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьОбменОбработкаОжидания()
	
	ИнтеграцияВЕТИСКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект,, ОповещениеПриЗавершенииОбмена(), Ложь);
	
КонецПроцедуры

&НаКлиенте
Функция ОповещениеПриЗавершенииОбмена()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПолученияРезультатОбработкиЗаявки", ЭтотОбъект);
	
	Возврат ОписаниеОповещения;
	
КонецФункции

&НаКлиенте
Процедура ПослеПолученияРезультатОбработкиЗаявки(Изменения, ДополнительныеПараметры) Экспорт
	
	ДанныеДляОбработки = Неопределено;
	
	Для Каждого ЭлементДанных Из Изменения Цикл
		ДанныеДляОбработки = ЭлементДанных;
	КонецЦикла;
	
	Если ДанныеДляОбработки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СостояниеВыполненияОперации = ДанныеДляОбработки.НовыйСтатус;
	
	Если ДанныеДляОбработки.НовыйСтатус = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиСообщенийВЕТИС.ЗаявкаОтклонена")
		ИЛИ НЕ ПустаяСтрока(ДанныеДляОбработки.ТекстОшибки) Тогда
		
		ВывестиИнформациюОбОшибке(ДанныеДляОбработки);
		
	ИначеЕсли ДанныеДляОбработки.НовыйСтатус = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиСообщенийВЕТИС.ЗаявкаВыполнена") Тогда
		
		ВывестиИнформациюОУспешномРезультатеОбмена(ДанныеДляОбработки);
		
	КонецЕсли;
	
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиИнформациюОбОшибке(ДанныеДляОбработки)
	
	ТекстОшибки = ДанныеДляОбработки.ТекстОшибки;
	
	Строки = Новый Массив;
	Строки.Добавить(
		Новый ФорматированнаяСтрока(
			НСтр("ru = 'Ошибка:'")));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(ТекстОшибки,, ЦветПроблема));
	
	ТекстОшибка = Новый ФорматированнаяСтрока(Строки);
	
	Элементы.СтраницыОбменСВЕТИС.ТекущаяСтраница = Элементы.СтраницаЗапросОшибка;
	СостояниеВыполненияОперации = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиСообщенийВЕТИС.Ошибка");
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиИнформациюОУспешномРезультатеОбмена(ДанныеДляОбработки)

	ВходящееСообщение = ДанныеДляОбработки.ВходящееСообщение;
	
	Строки = Новый Массив;
	Строки.Добавить(НСтр("ru = 'На'"));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'запрос'"),, ЦветГиперссылки,, "ОткрытьИсходящееСообщение"));
	Строки.Добавить(" ");
	
	Если ВариантИзменения = "Связывание" Тогда
		ТекстПолучения = НСтр("ru = 'о связывании предприятия ""%1""'");
		ТекстЗавершено = НСтр("ru = 'Выполнена связь с предприятием'");
	ИначеЕсли ВариантИзменения = "РазрывСвязи" Тогда
		ТекстПолучения = НСтр("ru = 'о разрыве связи с предприятием ""%1""'");
		ТекстЗавершено = НСтр("ru = 'Разорвана связь с предприятием'");
	ИначеЕсли ВариантИзменения = "ИзменениеGLN" Тогда
		ТекстПолучения = НСтр("ru = 'об изменении GLN предприятия ""%1""'");
		ТекстЗавершено = НСтр("ru = 'Изменен GLN предприятия'");
	КонецЕсли;
	
	Строки.Добавить(СтрШаблон(ТекстПолучения, НаименованиеПредприятия));
	
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'получен ответ'"),, ЦветГиперссылки,, "ОткрытьВходящееСообщение"));
	Строки.Добавить(".");
	Строки.Добавить(Символы.ПС);
	Строки.Добавить(ТекстЗавершено);
	Строки.Добавить(".");
	
	ТекстРезультат = Новый ФорматированнаяСтрока(Строки);
	
	Элементы.СтраницыОбменСВЕТИС.ТекущаяСтраница = Элементы.СтраницаЗапросРезультат;

КонецПроцедуры

&НаКлиенте
Процедура ПереключитьНаСтраницуОжиданияРезультатаЗапроса(ДанныеДляОбработки)
	
	ИсходящееСообщение                         = ДанныеДляОбработки.ИсходящееСообщение;
	СостояниеВыполненияОперации                = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиСообщенийВЕТИС.ЗаявкаОбрабатывается");
	СформироватьТекстОжиданиеРезультатаОбменаВЕТИС(ДанныеДляОбработки);
	
	Элементы.СтраницыОбменСВЕТИС.ТекущаяСтраница = Элементы.СтраницаЗапросОжидание;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьТекстОжиданиеРезультатаОбменаВЕТИС(ДанныеДляОбработки)
	
	Строки = Новый Массив;
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Запрос'"),, ЦветГиперссылки,, "ОткрытьИсходящееСообщение"));
	Строки.Добавить(" ");
	
	Если ВариантИзменения = "Связывание" Тогда
		ТекстОперации = НСтр("ru = 'на связывание предприятия ""%1""'");
	ИначеЕсли ВариантИзменения = "РазрывСвязи" Тогда
		ТекстОперации = НСтр("ru = 'на разрыв связи с предприятием ""%1""'");
	ИначеЕсли ВариантИзменения = "ИзменениеGLN" Тогда
		ТекстОперации = НСтр("ru = 'изменение GLN предприятия ""%1""'");
	КонецЕсли;
	
	Строки.Добавить(СтрШаблон(ТекстОперации, НаименованиеПредприятия));
	Строки.Добавить(Символы.ПС);
	Строки.Добавить(НСтр("ru = 'Получение ответа от сервера может занять продолжительное время.
	                           |Дождитесь ответа или закройте окно для продолжения
	                           |выполнения операции в фоновом режиме.'"));
	
	ТекстОжидание = Новый ФорматированнаяСтрока(Строки);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ИнициализацияФормы

&НаСервере
Процедура ОбработатьПереданныеПараметры()

	ХозяйствующийСубъект = Параметры.ХозяйствующийСубъект;
	Предприятие          = Параметры.Предприятие;
	ВариантИзменения     = Параметры.ВариантИзменения;
	GLN                  = Параметры.GLN;
	
	СостояниеВыполненияОперации = Перечисления.СтатусыОбработкиСообщенийВЕТИС.КПередаче;
	
	Если ЗначениеЗаполнено(Предприятие) Тогда
		НаименованиеПредприятия = НаименованиеПредприятия(Предприятие);
	Иначе
		НаименованиеПредприятия = "";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьВспомогательныеРеквизитыФормы()
	
	ЦветГиперссылки     = ЦветаСтиля.ЦветГиперссылкиГосИС;
	ЦветПроблема        = ЦветаСтиля.ЦветТекстаПроблемаГосИС;
	
КонецПроцедуры

&НаСервере
Процедура СброситьРазмерыИПоложениеОкна()
	
	ИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		ХранилищеСистемныхНастроек.Удалить("Справочник.ХозяйствующиеСубъектыВЕТИС.Форма.ИзменениеСвязиПредприятияХозяйствующегоСубъекта", "", ИмяПользователя);
	КонецЕсли;
	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УстановитьЗаголовокФормы()
	
	Если ВариантИзменения = "Связывание" Тогда
		Заголовок = НСтр("ru = 'Связывание с предприятием'");
	ИначеЕсли ВариантИзменения = "РазрывСвязи" Тогда
		Заголовок = НСтр("ru = 'Разрыв связи с предприятием'");
	ИначеЕсли ВариантИзменения = "ИзменениеGLN" Тогда
		Заголовок = НСтр("ru = 'Изменение GLN'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементамиФормы(Форма)
	
	Элементы                    = Форма.Элементы;
	СостояниеВыполненияОперации = Форма.СостояниеВыполненияОперации;
	ВариантИзменения            = Форма.ВариантИзменения;
	
	Если ВариантИзменения = "Связывание" Тогда
		
	ИначеЕсли ВариантИзменения = "РазрывСвязи" Тогда
		Элементы.Предприятие.ТолькоПросмотр = Истина;
		Элементы.GLN.ТолькоПросмотр         = Истина;
	ИначеЕсли ВариантИзменения = "ИзменениеGLN" Тогда
		Элементы.Предприятие.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если СостояниеВыполненияОперации = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиСообщенийВЕТИС.КПередаче")
		Или СостояниеВыполненияОперации = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиСообщенийВЕТИС.Ошибка") Тогда
		
		Если ВариантИзменения = "Связывание" Тогда
			Элементы.Далее.Заголовок = НСтр("ru = 'Связать'");
		ИначеЕсли ВариантИзменения = "РазрывСвязи" Тогда
			Элементы.Далее.Заголовок = НСтр("ru = 'Разорвать связь'");
		ИначеЕсли ВариантИзменения = "ИзменениеGLN" Тогда
			Элементы.Далее.Заголовок = НСтр("ru = 'Изменить GLN'");
		КонецЕсли;
		
	ИначеЕсли СостояниеВыполненияОперации = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиСообщенийВЕТИС.ЗаявкаОбрабатывается") Тогда
		
		Элементы.Далее.Заголовок = НСтр("ru = 'Продолжить в фоне'");
		
	ИначеЕсли СостояниеВыполненияОперации = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиСообщенийВЕТИС.ЗаявкаВыполнена") Тогда
		
		Элементы.Далее.Видимость = Ложь;
		Элементы.Отмена.Заголовок = НСтр("ru = 'Закрыть'")
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

&НаСервереБезКонтекста
Функция НаименованиеПредприятия(Предприятие)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Предприятие, "Наименование");
	
КонецФункции

#КонецОбласти

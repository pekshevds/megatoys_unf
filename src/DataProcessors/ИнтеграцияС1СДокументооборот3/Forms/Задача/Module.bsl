#Область ОписаниеПеременных

&НаКлиенте
Перем КлючСтрокиДереваПриложений;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтоТонкийWindowsКлиент = Не ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриложениеЯвляетсяВебКлиентом()
		И ОбщегоНазначения.ЭтоWindowsКлиент();
	СтраницыКомандСозданияНаОсновании = ПоместитьВоВременноеХранилище(Новый Соответствие, УникальныйИдентификатор);
	
	Параметры.Свойство("ID", ID);
	Параметры.Свойство("Тип", Тип);
	Параметры.Свойство("СохраненныйКомментарий", СохраненныйКомментарий);
	Параметры.Свойство("СостояниеДереваПриложений", СостояниеДереваПриложений);
	Параметры.Свойство("ОсновнойПредметID", ОсновнойПредметID);
	Параметры.Свойство("ОсновнойПредметТип", ОсновнойПредметТип);
	
	Если Параметры.Свойство("ДанныеПоЗадаче") Тогда
		
		ДействиеЗадачи = Параметры.ДанныеПоЗадаче.ДействиеЗадачи; // См. ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеСсылочногоОбъектаДО
		Заголовок = ДействиеЗадачи.Наименование;
		ОписаниеHTMLЗадачи = Параметры.ДанныеПоЗадаче.ПредставлениеHTML;
		
		ДополнительныеДанныеПоЗадаче = ПолучитьИзВременногоХранилища(Параметры.ДанныеПоЗадаче.АдресДополнительныхДанных);
		Если ДополнительныеДанныеПоЗадаче <> Неопределено Тогда
			АдресДополнительныхДанных = Параметры.ДанныеПоЗадаче.АдресДополнительныхДанных;
			ОтобразитьДополнительныеДанные(ДополнительныеДанныеПоЗадаче);
		КонецЕсли;
		
	Иначе
		
		Заголовок = НСтр("ru = 'Загрузка задачи из 1С:Документооборот'");
		
	КонецЕсли;
	
	Если Параметры.Свойство("ПодходящиеПравила") И ЭтоАдресВременногоХранилища(Параметры.ПодходящиеПравила) Тогда
		ПодходящиеПравила = ПолучитьИзВременногоХранилища(Параметры.ПодходящиеПравила);
		ОтобразитьКомандыСозданияНаОсновании(ПодходящиеПравила);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПроверитьПодключение();
	
	ИнтеграцияС1СДокументооборот3Клиент.РазвернутьДеревоПриложений(ЭтотОбъект, СостояниеДереваПриложений);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИнтеграцияС1СДокументооборотом_УспешноеПодключение" Тогда
		Если Источник <> ЭтотОбъект Тогда
			ПриПодключении();
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ИзмененРезультатДействияТекстом" Тогда
		Если Источник = ЭтотОбъект
				Или ТипЗнч(Параметр) <> Тип("Структура")
				Или Не Параметр.Свойство("Текст")
				Или Не Параметр.Свойство("ID")
				Или Не Параметр.Свойство("Тип") Тогда
			Возврат;
		КонецЕсли;
		Если Параметр.ID = ID И Параметр.Тип = Тип Тогда
			СохраненныйКомментарий = Параметр.Текст;
			РезультатДействияТекстом = Параметр.Текст;
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "Документооборот_ДействиеНадЗадачей" Тогда
		Если ТипЗнч(Параметр) = Тип("Структура")
				И Параметр.Свойство("ИмяОперации")
				И Параметр.Свойство("ID")
				И Параметр.Свойство("Тип")
				И Параметр.ID = ID
				И Параметр.Тип = Тип Тогда
			Если Параметр.ИмяОперации = "ВыполнитьДействиеЗадачи" Или Параметр.ИмяОперации = "Перенаправить" Тогда
				Закрыть();
			Иначе
				Если Источник = ЭтотОбъект Тогда
					Возврат;
				КонецЕсли;
				ОбновитьФорму(Ложь, Ложь, Истина);
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ПолученHTMLПредпросмотрОбъекта" Тогда
		Если ТипЗнч(Параметр) <> Тип("Структура")
				Или Не Параметр.Свойство("ПредставлениеHTML")
				Или Не Параметр.Свойство("ПредпросмотрУрезан")
				Или Не Параметр.Свойство("ID")
				Или Не Параметр.Свойство("Тип") Тогда
			Возврат;
		КонецЕсли;
		РеквизитыКОбновлению = Новый Структура("ПредставлениеHTML, ПредпросмотрУрезан, ОжиданиеПредпросмотра",
			Параметр.ПредставлениеHTML,
			Параметр.ПредпросмотрУрезан,
			Ложь);
		ОбновлениеВыполнено = ОбновитьПриложениеПоID(
			Параметр.ID,
			Параметр.Тип,
			РеквизитыКОбновлению);
		Если ОбновлениеВыполнено Тогда
			ОбновитьПредпросмотр();
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "Запись_ДокументооборотФайл" Тогда
		Если ТипЗнч(Параметр) <> Тип("Структура")
				Или Не Параметр.Свойство("ИдентификаторФайла")
				Или Не Параметр.Свойство("Событие")
				Или Не Параметр.Свойство("ВладелецФайла")
				Или Не Параметр.Свойство("ИмяФайла")
				Или Не Параметр.Свойство("УникальныйИдентификаторФормы") Тогда
			Возврат;
		КонецЕсли;
		НужноОбновление = Ложь;
		РеквизитыКЧтению = Новый Структура("Редактируется", Неопределено);
		ОбновлениеВыполнено = ОбновитьПриложениеПоID(
			Параметр.ИдентификаторФайла,
			"DMFile",,
			РеквизитыКЧтению);
		Если ОбновлениеВыполнено Тогда
			// Измененный файл есть в дереве приложений.
			НужноОбновление = Истина;
			Если Параметр.Событие = "РедактированиеФайла" Тогда
				Если РеквизитыКЧтению.Редактируется = Неопределено Тогда
					НужноОбновление = Ложь;
				Иначе
					НужноОбновление = Не РеквизитыКЧтению.Редактируется;
				КонецЕсли;
			КонецЕсли;
		Иначе
			// Возможно владелец файла есть в дереве приложений, но самого файла нет.
			// Например, когда был добавлен новый файл.
			НужноОбновление = ОбновитьПриложениеПоID(Параметр.ВладелецФайла);
		КонецЕсли;
		Если НужноОбновление Тогда
			СостояниеДереваПриложений = ИнтеграцияС1СДокументооборот3Клиент.СостояниеДереваПриложений(ЭтотОбъект);
			Если Параметр.Событие = "СозданиеФайла" Тогда
				СтрокаНовогоФайла = Новый Структура(
					"ПредставлениеПриложения, ПриложениеID, ПриложениеТип, ТипСтроки, РольФайлаID");
				СтрокаНовогоФайла.ПредставлениеПриложения = Параметр.ИмяФайла;
				СтрокаНовогоФайла.ПриложениеID = Параметр.ИдентификаторФайла;
				СтрокаНовогоФайла.ПриложениеТип = "DMFile";
				СостояниеДереваПриложений.КлючТекущейСтрокиДереваПриложений =
					ИнтеграцияС1СДокументооборот3Клиент.КлючСтрокиДереваПриложений(СтрокаНовогоФайла);
			КонецЕсли;
			Если Параметр.УникальныйИдентификаторФормы = Неопределено Тогда
				ВыводитьОкноОжидания = Истина;
			Иначе
				ВыводитьОкноОжидания = (УникальныйИдентификатор = Параметр.УникальныйИдентификаторФормы);
			КонецЕсли;
			ОбновитьФорму(ВыводитьОкноОжидания, Ложь, Истина);
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "Документооборот_ДобавлениеСвязи" Тогда
		Если ТипЗнч(Параметр) <> Тип("Структура")
				Или Не Параметр.Свойство("ID")
				Или Не Параметр.Свойство("Тип")
				Или Не Параметр.Свойство("Объект") Тогда
			Возврат;
		КонецЕсли;
		РеквизитыКОбновлению = Новый Структура("Ссылка, ПредставлениеПриложения",
			Параметр.Объект,
			ИнтеграцияС1СДокументооборот3ВызовСервера.ПредставлениеПриложенияОбъектаИС(Параметр.Объект));
		ОбновитьПриложениеПоID(
			Параметр.ID,
			Параметр.Тип,
			РеквизитыКОбновлению);
		ОтобразитьКомандыСозданияНаОсновании(Новый Массив);
		
	ИначеЕсли ИмяСобытия = "Документооборот_УдалениеСвязи" Тогда
		Если ТипЗнч(Параметр) <> Тип("Структура")
				Или Не Параметр.Свойство("ID")
				Или Не Параметр.Свойство("Тип")
				Или Не ОбновитьПриложениеПоID(Параметр.ID, Параметр.Тип) Тогда
			Возврат;
		КонецЕсли;
		ОбновитьФорму(Ложь, Ложь, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияНастройкиАвторизацииНажатие(Элемент)
	
	Оповещение = Новый ОписаниеОповещения("ДекорацияНастройкиАвторизацииНажатиеЗавершение", ЭтотОбъект);
	ИмяФормыПараметров = "Обработка.ИнтеграцияС1СДокументооборотБазоваяФункциональность.Форма.АвторизацияВ1СДокументооборот";
	
	ОткрытьФорму(ИмяФормыПараметров,, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНастройкиАвторизацииНажатиеЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ПриПодключении();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Найти(ДанныеСобытия.Href, "OpenForEdit") Тогда
		
		ИнтеграцияС1СДокументооборот3Клиент.ПриложенияЗадачиФайлыРедактировать(
			Элементы.ДеревоПриложений.ТекущиеДанные,
			УникальныйИдентификатор);
		
	ИначеЕсли Найти(ДанныеСобытия.Href, "OpenForView") Тогда
		
		ИнтеграцияС1СДокументооборот3Клиент.ОткрытьПриложение(
			Элементы.ДеревоПриложений.ТекущиеДанные,
			УникальныйИдентификатор);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатДействияТекстомОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	// Сохраним текст комментария при уходе фокуса.
	Если ПустаяСтрока(Текст) И СохраненныйКомментарий = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СохраненныйКомментарий = Текст;
	РезультатДействияТекстом = Текст;
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ID", ID);
	ПараметрыОповещения.Вставить("Тип", Тип);
	ПараметрыОповещения.Вставить("Текст", Текст);
	Оповестить("ИзмененРезультатДействияТекстом", ПараметрыОповещения, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПриложений

&НаКлиенте
Процедура ДеревоПриложенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияС1СДокументооборот3Клиент.ОткрытьПриложение(
		Элементы.ДеревоПриложений.ТекущиеДанные,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПриАктивизацииСтроки(Элемент)
	
	ИнтеграцияС1СДокументооборот3Клиент.УстановитьДоступностьКомандПриложений(
		Элемент.ТекущаяСтрока,
		КлючСтрокиДереваПриложений,
		ID,
		ЭтотОбъект,
		ЭтоТонкийWindowsКлиент);
	ПодключитьОбработчикОжидания("ОбновитьПредпросмотрПриАктивизацииСтроки", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПередНачаломИзменения(Элемент, Отказ)
	
	ИнтеграцияС1СДокументооборот3Клиент.ДеревоПриложенийПередНачаломИзменения(
		Элементы.ДеревоПриложений.ТекущиеДанные,
		Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьДействиеЗадачиВариант1(Команда)
	
	ДействиеНадЗадачей("ВыполнитьДействиеЗадачи", Новый Структура("РезультатВариантаНомер", "РезультатВарианта1"), Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДействиеЗадачиВариант2(Команда)
	
	ДействиеНадЗадачей("ВыполнитьДействиеЗадачи", Новый Структура("РезультатВариантаНомер", "РезультатВарианта2"), Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДействиеЗадачиВариант3(Команда)
	
	ДействиеНадЗадачей("ВыполнитьДействиеЗадачи", Новый Структура("РезультатВариантаНомер", "РезультатВарианта3"), Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПредпросмотрКоманда(Команда)
	
	ОбновитьПредпросмотр(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПриложение(Команда)
	
	ИнтеграцияС1СДокументооборот3Клиент.ОткрытьПриложение(
		Элементы.ДеревоПриложений.ТекущиеДанные,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	
	ИнтеграцияС1СДокументооборот3Клиент.ОткрытьКарточку(Элементы.ДеревоПриложений.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыВставитьКартинкуИзБуфера(Команда)
	
	ИнтеграцияС1СДокументооборот3Клиент.ПриложенияЗадачиФайлыВставитьКартинкуИзБуфера(
		Элементы.ДеревоПриложений.ТекущиеДанные,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыДобавить(Команда)
	
	ИнтеграцияС1СДокументооборот3Клиент.ПриложенияЗадачиФайлыДобавить(
		Элементы.ДеревоПриложений.ТекущиеДанные,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыРедактировать(Команда)
	
	ИнтеграцияС1СДокументооборот3Клиент.ПриложенияЗадачиФайлыРедактировать(
		Элементы.ДеревоПриложений.ТекущиеДанные,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыЗакончитьРедактирование(Команда)
	
	ИнтеграцияС1СДокументооборот3Клиент.ПриложенияЗадачиФайлыЗакончитьРедактирование(
		Элементы.ДеревоПриложений.ТекущиеДанные,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыОсвободить(Команда)
	
	ИнтеграцияС1СДокументооборот3Клиент.ПриложенияЗадачиФайлыОсвободить(
		Элементы.ДеревоПриложений.ТекущиеДанные,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыОбновитьИзФайлаНаДиске(Команда)
	
	ИнтеграцияС1СДокументооборот3Клиент.ПриложенияЗадачиФайлыОбновитьИзФайлаНаДиске(
		Элементы.ДеревоПриложений.ТекущиеДанные,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыУдалить(Команда)
	
	ИнтеграцияС1СДокументооборот3Клиент.ПриложенияЗадачиФайлыУдалить(
		Элементы.ДеревоПриложений.ТекущиеДанные,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыСохранитьКак(Команда)
	
	ИнтеграцияС1СДокументооборот3Клиент.ПриложенияЗадачиФайлыСохранитьКак(
		Элементы.ДеревоПриложений.ТекущиеДанные,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СоздатьСвязанныйОбъект(Команда)
	
	ИнтеграцияС1СДокументооборот3Клиент.Подключаемый_СоздатьСвязанныйОбъект(
		Команда,
		ОсновнойПредметID,
		ОсновнойПредметТип);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьФорму(Истина, Ложь, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВзятьВРаботу(Команда)
	
	ДействиеНадЗадачей("ВзятьВРаботу");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВзятиеВРаботу(Команда)
	
	ДействиеНадЗадачей("ОтменитьВзятиеВРаботу");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЖелтыйФлаг(Команда)
	
	ДействиеНадЗадачей("УстановитьФлаг", Новый Структура("Флаг", "Yellow"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗеленыйФлаг(Команда)
	
	ДействиеНадЗадачей("УстановитьФлаг", Новый Структура("Флаг", "Green"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКрасныйФлаг(Команда)
	
	ДействиеНадЗадачей("УстановитьФлаг", Новый Структура("Флаг", "Red"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЛиловыйФлаг(Команда)
	
	ДействиеНадЗадачей("УстановитьФлаг", Новый Структура("Флаг", "Purple"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОранжевыйФлаг(Команда)
	
	ДействиеНадЗадачей("УстановитьФлаг", Новый Структура("Флаг", "Orange"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСинийФлаг(Команда)
	
	ДействиеНадЗадачей("УстановитьФлаг", Новый Структура("Флаг", "Blue"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьФлаг(Команда)
	
	ДействиеНадЗадачей("УстановитьФлаг", Новый Структура("Флаг", ""));
	
КонецПроцедуры

&НаКлиенте
Процедура Перенаправить(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Задача", Заголовок);
	ПараметрыФормы.Вставить("ЗадачаID", ID);
	ПараметрыФормы.Вставить("ЗадачаТип", Тип);
	ПараметрыФормы.Вставить("ИспользоватьИнтеграциюДО3", Истина);
	ОткрытьФорму(
		"Обработка.ИнтеграцияС1СДокументооборотБазоваяФункциональность.Форма.ПеренаправлениеЗадачи",
		ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Клиент

&НаКлиенте
Процедура ОбновитьПредпросмотр(ОбновитьДанные = Ложь)
	
	Элементы.СтраницыПросмотра.ТекущаяСтраница = Элементы.СтраницаЗагрузкаПревью;
	
	РедактируетсяТекущимПользователем = Ложь;
	ПредпросмотрУрезан = Ложь;
	
	ТекущиеДанные = Элементы.ДеревоПриложений.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если ТекущиеДанные.ОжиданиеПредпросмотра Тогда
			Возврат;
		КонецЕсли;
		
		Если (ТекущиеДанные.ПриложениеТип = "DMFile"
					Или ИнтеграцияС1СДокументооборот3КлиентПовтИсп.ЭтоДокументДО3(ТекущиеДанные.ПриложениеТип))
				И (Не ЗначениеЗаполнено(ТекущиеДанные.ПредставлениеHTML) Или ОбновитьДанные) Тогда
			
			ТекущиеДанные.ОжиданиеПредпросмотра = Истина;
			ДлительнаяОперация = ИнтеграцияС1СДокументооборот3ВызовСервера.ПолучитьHTMLПредпросмотрОбъектаАсинхронно(
				УникальныйИдентификатор,
				ТекущиеДанные.ПриложениеID,
				ТекущиеДанные.ПриложениеТип);
			
			ОповещениеОЗавершении = Новый ОписаниеОповещения(
					"ОбновитьПредпросмотрЗавершение",
					ЭтотОбъект,
					Новый Структура("ТекущиеДанные", ТекущиеДанные));
			
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьЗапросАсинхронно(
				ЭтотОбъект,
				ДлительнаяОперация,
				ОповещениеОЗавершении,
				Ложь,,
				Ложь);
			
			Возврат;
			
		ИначеЕсли ТекущиеДанные.ТипСтроки = "task"
				И (Не ЗначениеЗаполнено(ТекущиеДанные.ПредставлениеHTML) Или ОбновитьДанные) Тогда
			
			Если ЗначениеЗаполнено(ОписаниеHTMLЗадачи) Тогда
				
				ТекущиеДанные.ПредставлениеHTML = ОписаниеHTMLЗадачи;
				ТекущиеДанные.ПредпросмотрУрезан = Ложь;
				
			Иначе
				
				ТекущиеДанные.ОжиданиеПредпросмотра = Истина;
				ДлительнаяОперация = ИнтеграцияС1СДокументооборот3ВызовСервера.ПолучитьHTMLПредпросмотрОбъектаАсинхронно(
					УникальныйИдентификатор,
					ID,
					Тип);
				
				ОповещениеОЗавершении = Новый ОписаниеОповещения(
						"ОбновитьПредпросмотрЗавершение",
						ЭтотОбъект,
						Новый Структура("ТекущиеДанные", ТекущиеДанные));
				
				ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьЗапросАсинхронно(
					ЭтотОбъект,
					ДлительнаяОперация,
					ОповещениеОЗавершении,
					Ложь,,
					Ложь);
				
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТекущиеДанные.ПредставлениеHTML) Тогда
			ПредставлениеHTML = ТекущиеДанные.ПредставлениеHTML;
		Иначе
			ПредставлениеHTML = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.СообщениеВПредпросмотр(
				НСтр("ru='Данные предпросмотра отсутствуют.'"),
				ЗаголовокСообщенияВОбластиПредпросмотра);
		КонецЕсли;
		
		РедактируетсяТекущимПользователем = ТекущиеДанные.РедактируетсяТекущимПользователем;
		ПредпросмотрУрезан = ТекущиеДанные.ПредпросмотрУрезан;
		
		Если ТекущиеДанные.ПриложениеТип = "DMFile" Тогда
			
			ОписаниеHTMLФайла = ПредставлениеHTML;
			ОбновитьЭлементыПредпросмотра(РедактируетсяТекущимПользователем, ПредпросмотрУрезан);
			Элементы.СтраницыПросмотра.ТекущаяСтраница = Элементы.СтраницаОбзорФайла;
			
		ИначеЕсли ИнтеграцияС1СДокументооборот3КлиентПовтИсп.ЭтоДокументДО3(ТекущиеДанные.ПриложениеТип) Тогда
			
			ОписаниеHTMLДокумента = ПредставлениеHTML;
			Элементы.СтраницыПросмотра.ТекущаяСтраница = Элементы.СтраницаОбзорДокумента;
			
		ИначеЕсли ТекущиеДанные.ТипСтроки = "task" Тогда
			
			ОписаниеHTMLЗадачи = ПредставлениеHTML;
			Элементы.СтраницыПросмотра.ТекущаяСтраница = Элементы.СтраницаОсновное;
			
		ИначеЕсли ТекущиеДанные.ТипСтроки = "instruction" Тогда
			
			Инструкция = ПредставлениеHTML;
			Элементы.СтраницыПросмотра.ТекущаяСтраница = Элементы.СтраницаИнструкция;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Элементы.СтраницыПросмотра.ТекущаяСтраница = Элементы.СтраницаЗагрузкаПревью Тогда
		
		Элементы.СтраницыПросмотра.ТекущаяСтраница = Элементы.СтраницаОсновное;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПредпросмотрЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		
		HTMLПредпросмотрОбъекта = Результат.РезультатДлительнойОперации;
		HTMLПредпросмотрОбъекта.Вставить("ID", ПараметрыОповещения.ТекущиеДанные.ПриложениеID);
		HTMLПредпросмотрОбъекта.Вставить("Тип", ПараметрыОповещения.ТекущиеДанные.ПриложениеТип);
		Оповестить("ПолученHTMLПредпросмотрОбъекта", HTMLПредпросмотрОбъекта, ЭтотОбъект);
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		
		ОбработатьИсключение(Результат.КраткоеПредставлениеОшибки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПредпросмотрПриАктивизацииСтроки()
	
	ОбновитьПредпросмотр();
	
	СостояниеДереваПриложений = ИнтеграцияС1СДокументооборот3Клиент.СостояниеДереваПриложений(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Функция ОбновитьПриложениеПоID(ПриложениеID, ПриложениеТип = Неопределено, РеквизитыКОбновлению = Неопределено,
		РеквизитыКЧтению = Неопределено)
	
	НайденнаяСтрока = ПриложениеВДеревеЗначений(
		ДеревоПриложений.ПолучитьЭлементы(),
		ПриложениеID,
		ПриложениеТип);
	
	Если НайденнаяСтрока <> Неопределено Тогда
		
		Если РеквизитыКОбновлению <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(НайденнаяСтрока, РеквизитыКОбновлению);
			ОбновитьДеревоВХранилище(ПриложениеID, ПриложениеТип, РеквизитыКОбновлению);
		КонецЕсли;
		
		Если РеквизитыКЧтению <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(РеквизитыКЧтению, НайденнаяСтрока);
		КонецЕсли;
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьЭлементыПредпросмотра(РедактируетсяТекущимПользователем = Ложь, ПредпросмотрУрезан = Ложь)
	
	Если РедактируетсяТекущимПользователем Тогда
		Элементы.ГруппаПредпросмотрУрезан.Видимость = Ложь;
	Иначе
		Элементы.ГруппаПредпросмотрУрезан.Видимость = ПредпросмотрУрезан;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПриложениеВДеревеЗначений(Строки, ПриложениеID, ПриложениеТип)
	
	Для Каждого Строка Из Строки Цикл
		
		Если Строка.ПриложениеID = ПриложениеID И Строка.ПриложениеТип = ПриложениеТип Тогда
			Возврат Строка;
			
		ИначеЕсли Строка.ПриложениеID = ПриложениеID И ПриложениеТип = Неопределено Тогда
			Возврат Строка;
			
		КонецЕсли;
		
		Если ТипЗнч(Строка) = Тип("ДанныеФормыЭлементДерева") Тогда
			ПодчиненныеСтроки = Строка.ПолучитьЭлементы();
		Иначе
			ПодчиненныеСтроки = Строка.Строки;
		КонецЕсли;
		НайденнаяСтрока = ПриложениеВДеревеЗначений(ПодчиненныеСтроки, ПриложениеID, ПриложениеТип);
		Если НайденнаяСтрока <> Неопределено Тогда
			Возврат НайденнаяСтрока;
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции

#КонецОбласти

#Область Сервер

&НаСервере
Процедура ОбработатьОтветВебСервисаНаПолучениеЗадачи(ЗадачаXDTO)
	
	Заголовок = ЗадачаXDTO.title;
	ОписаниеHTMLЗадачи = ЗадачаXDTO.htmlView;
	
	ДополнительныеДанныеПоЗадаче = ИнтеграцияС1СДокументооборот3.ДополнительныеДанныеПоЗадаче(ЗадачаXDTO);
	Если Не ПустаяСтрока(АдресДополнительныхДанных) Тогда
		ПоместитьВоВременноеХранилище(ДополнительныеДанныеПоЗадаче, АдресДополнительныхДанных);
	КонецЕсли;
	
	ОтобразитьДополнительныеДанные(ДополнительныеДанныеПоЗадаче);
	
	УжеЕстьСвязь = Ложь;
	Если ДополнительныеДанныеПоЗадаче <> Неопределено Тогда
		Для Каждого СтрокаДереваПриложений Из ДополнительныеДанныеПоЗадаче.ДеревоПриложений.Строки Цикл
			Если ЗначениеЗаполнено(СтрокаДереваПриложений.Ссылка) Тогда
				УжеЕстьСвязь = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Если Не УжеЕстьСвязь Тогда
		// Для построения списка команд создания на основании получим массив подходящих задаче правил интеграции,
		// также заполним данные идентификатор и тип основного предмета задачи.
		ПодходящиеПравила = ИнтеграцияС1СДокументооборот3ВызовСервера.ПодходящиеПравилаИнтеграцииПоОсновномуПредметуЗадачи(
			ЗадачаXDTO,
			ОсновнойПредметID,
			ОсновнойПредметТип);
		ОтобразитьКомандыСозданияНаОсновании(ПодходящиеПравила);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьДополнительныеДанные(ДополнительныеДанныеПоЗадаче)
	
	Если ДополнительныеДанныеПоЗадаче = Неопределено Тогда
		Элементы.СтраницыЗадачаОднаНесколькоНет.ТекущаяСтраница = Элементы.СтраницаОшибка;
		Возврат;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборот3.ОбновитьОбластьДействия(
		ЭтотОбъект,
		ДополнительныеДанныеПоЗадаче.ОбластьДействия,
		СохраненныйКомментарий,
		Ложь);
	
	Если Элементы.ВзятьВРаботу.Видимость Тогда
		Элементы.ГруппаКоманднаяПанель.Ширина = 17;
	Иначе
		Элементы.ГруппаКоманднаяПанель.Ширина = 3;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ДополнительныеДанныеПоЗадаче.ДеревоПриложений, "ДеревоПриложений");
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьКомандыСозданияНаОсновании(ПодходящиеПравила)
	
	КлючСтраницыКомандСозданияНаОсновании = "";
	Если ПодходящиеПравила.Количество() > 0 Тогда
		// Каждой уникальной комбинации правил - соответствует своя группа команд создания на основании.
		// Для оптимизации, если при перерисовке формы совпадают подходящие правила - не будем создавать на форме
		// новую группу команд, а будем использовать созданную ранее группу.
		// Соответствие имени станицы определенной комбинации подходящих правил хранится во временном
		// хранилище по адресу СтраницыКомандСозданияНаОсновании.
		СоответствиеСтраниц = ПолучитьИзВременногоХранилища(СтраницыКомандСозданияНаОсновании);
		КлючСоответствияСтраниц = ЗначениеВСтрокуВнутр(ПодходящиеПравила);
		КлючСтраницыКомандСозданияНаОсновании = СоответствиеСтраниц[КлючСоответствияСтраниц];
		Если Не ЗначениеЗаполнено(КлючСтраницыКомандСозданияНаОсновании) Тогда
			КлючСтраницыКомандСозданияНаОсновании =
				ИнтеграцияС1СДокументооборот3.НоваяСтраницаКомандСозданияНаОсновании(
					ЭтотОбъект,
					ПодходящиеПравила);
			СоответствиеСтраниц[КлючСоответствияСтраниц] = КлючСтраницыКомандСозданияНаОсновании;
			ПоместитьВоВременноеХранилище(СоответствиеСтраниц, СтраницыКомандСозданияНаОсновании);
		КонецЕсли;
	КонецЕсли;
	
	НоваяСтраница = Элементы["ГруппаСтраницаКоманд" + КлючСтраницыКомандСозданияНаОсновании];
	Если Элементы.ГруппаСтраницыКоманд.ТекущаяСтраница <> НоваяСтраница Тогда
		Элементы.ГруппаСтраницыКоманд.ТекущаяСтраница = НоваяСтраница;
		Элементы.ГруппаСтраницыКоманд.Видимость =
			(НоваяСтраница.ПодчиненныеЭлементы[0].ПодчиненныеЭлементы[0].ПодчиненныеЭлементы.Количество() > 0);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДеревоВХранилище(ПриложениеID, ПриложениеТип = Неопределено, РеквизитыКОбновлению = Неопределено)
	
	Если ПустаяСтрока(АдресДополнительныхДанных) Или РеквизитыКОбновлению = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеДанныеПоЗадаче = ПолучитьИзВременногоХранилища(АдресДополнительныхДанных);
	НайденнаяСтрока = ПриложениеВДеревеЗначений(
		ДополнительныеДанныеПоЗадаче.ДеревоПриложений.Строки,
		ПриложениеID,
		ПриложениеТип);
	ЗаполнитьЗначенияСвойств(НайденнаяСтрока, РеквизитыКОбновлению);
	ПоместитьВоВременноеХранилище(ДополнительныеДанныеПоЗадаче, АдресДополнительныхДанных);
	
КонецПроцедуры

#КонецОбласти

#Область Подключение

// Проверяет подключение к ДО, выводя окно авторизации, если необходимо, и изменяя форму согласно результату.
//
&НаКлиенте
Процедура ПроверитьПодключение()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьПодключениеЗавершение", ЭтотОбъект);
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ПроверитьПодключение(
		ОписаниеОповещения,
		ЭтотОбъект,,
		Ложь,
		Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ПриПодключении();
	Иначе // не удалось подключиться к ДО
		ОбработатьФормуСогласноВерсииСервиса();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПодключении()
	
	Если ОбработатьФормуСогласноВерсииСервиса() Тогда
		ОбновитьФорму();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбработатьФормуСогласноВерсииСервиса()
	
	ВерсияСервиса = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВерсияСервиса();
	
	Если Не ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.СервисДоступен(ВерсияСервиса) Тогда
		Элементы.ГруппаСтраницыПодключения.ТекущаяСтраница = Элементы.СтраницаДокументооборотНедоступен;
		Возврат Ложь;
	КонецЕсли;
	
	ФормаОбработанаУспешно = Истина;
	
	Попытка
		
		Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДоступенФункционалВерсииСервиса("3.0.10.20") Тогда
			
			Элементы.ГруппаСтраницыПодключения.ТекущаяСтраница = Элементы.СтраницаДокументооборотДоступен;
			
			НастройкиДокументооборота = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьНастройки();
			ЗаголовокСообщенияВОбластиПредпросмотра = НастройкиДокументооборота.ЗаголовокСообщенияВОбластиПредпросмотра;
			ДобавлятьРаботуВЕжедневныйОтчетПриВыполненииЗадачи =
				НастройкиДокументооборота.ДобавлятьРаботуВЕжедневныйОтчетПриВыполненииЗадачи;
			ФактическийИсполнительЗадач = НастройкиДокументооборота.ФактическийИсполнительЗадач;
			Если ФактическийИсполнительЗадач <> "taskPerformer" Тогда
				ТекущийПользовательИСотрудники =
					ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ТекущийПользовательДокументооборота();
				ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(
					ЭтотОбъект, ТекущийПользовательИСотрудники[0], "ТекущийПользователь");
			КонецЕсли;
			
		Иначе
			
			Элементы.ГруппаСтраницыПодключения.ТекущаяСтраница = Элементы.СтраницаВерсияНеПоддерживается;
			ФормаОбработанаУспешно = Ложь;
			
		КонецЕсли;
		
	Исключение
		
		ОбработатьИсключение(ИнформацияОбОшибке());
		
	КонецПопытки;
	
	Возврат ФормаОбработанаУспешно;
	
КонецФункции

&НаСервере
Процедура ОбработатьИсключение(ИнформацияОбОшибке)
	
	ВерсияСервиса = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВерсияСервиса();
	Если Не ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.СервисДоступен(ВерсияСервиса) Тогда
		ОбработатьФормуСогласноВерсииСервиса();
	Иначе
		Если ТипЗнч(ИнформацияОбОшибке) = Тип("Строка") Тогда
			ПредставлениеОшибки = ИнформацияОбОшибке;
		Иначе
			ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		КонецЕсли;
		ВызватьИсключение ПредставлениеОшибки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбновитьФорму

&НаКлиенте
Процедура ОбновитьФорму(ВыводитьОкноОжидания = Ложь, СкрыватьИнтерфейс = Истина, ОбновитьДанные = Ложь)
	
	Если ОбновитьДанные = Ложь И ДеревоПриложений.ПолучитьЭлементы().Количество() > 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ВыводитьОкноОжидания И Не СкрыватьИнтерфейс Тогда
		Элементы.СтраницаДокументооборотДоступен.Доступность = Ложь;
	КонецЕсли;
	
	ДлительнаяОперация = ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ПолучитьОбъектАсинхронно(
		УникальныйИдентификатор,
		Тип,
		ID,
		"htmlView");
	ПараметрыОповещения = Новый Структура("ВыводитьОкноОжидания, СкрыватьИнтерфейс",
		ВыводитьОкноОжидания,
		СкрыватьИнтерфейс);
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбновитьФормуЗавершение", ЭтотОбъект, ПараметрыОповещения);
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьЗапросАсинхронно(
		ЭтотОбъект,
		ДлительнаяОперация,
		ОповещениеОЗавершении,
		ВыводитьОкноОжидания,,
		СкрыватьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФормуЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Не ПараметрыОповещения.ВыводитьОкноОжидания И Не ПараметрыОповещения.СкрыватьИнтерфейс Тогда
		Элементы.СтраницаДокументооборотДоступен.Доступность = Истина;
	КонецЕсли;
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		
		ОбновлениеНаСервереЗавершение(Результат.РезультатДлительнойОперации);
		ИнтеграцияС1СДокументооборот3Клиент.РазвернутьДеревоПриложений(ЭтотОбъект, СостояниеДереваПриложений);
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		
		ОбработатьИсключение(Результат.КраткоеПредставлениеОшибки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновлениеНаСервереЗавершение(ЗадачаXDTOСтрока)
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	ЗадачаXDTO = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СтрокаВОбъектXDTO(Прокси, ЗадачаXDTOСтрока);
	ОбработатьОтветВебСервисаНаПолучениеЗадачи(ЗадачаXDTO);
	
КонецПроцедуры

#КонецОбласти

#Область ДействиеНадЗадачей

&НаКлиенте
Процедура ДействиеНадЗадачей(ИмяОперации, ПараметрыОперации = Неопределено, ТребуетсяОбновлениеДанных = Истина)
	
	ДанныеПоЗадаче = ИнтеграцияС1СДокументооборот3Клиент.ДанныеПоЗадаче(
		ЭтотОбъект,
		ID,
		Тип,
		Заголовок,
		ПараметрыОперации);
	
	Попытка
		ДлительнаяОперацияНадЗадачей = ИнтеграцияС1СДокументооборот3ВызовСервера.ДлительнаяОперацияНадЗадачей(
			ИмяОперации,
			ДанныеПоЗадаче,
			УникальныйИдентификатор,
			ТребуетсяОбновлениеДанных);
	Исключение
		ОбработатьИсключение(ИнформацияОбОшибке());
	КонецПопытки;
	
	ПараметрыОповещения = Новый Структура("ID, Тип, ИмяОперации", ID, Тип, ИмяОперации);
	ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"ДействиеНадЗадачейЗавершение",
		ЭтотОбъект,
		ПараметрыОповещения);
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьЗапросАсинхронно(
		ЭтотОбъект,
		ДлительнаяОперацияНадЗадачей,
		ОповещениеОЗавершении,
		Истина,
		НСтр("ru = 'Выполняется действие над задачей.'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ДействиеНадЗадачейЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		
		Результат = ДействиеНадЗадачейНаСервереЗавершение(Результат.РезультатДлительнойОперации);
		Если Результат.Успешно Тогда
			ИнтеграцияС1СДокументооборот3Клиент.РазвернутьДеревоПриложений(ЭтотОбъект, СостояниеДереваПриложений);
			Оповестить("Документооборот_ДействиеНадЗадачей", ПараметрыОповещения, ЭтотОбъект);
		Иначе
			ПоказатьПредупреждение(, Результат.ТекстПредупреждения);
		КонецЕсли;
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		
		ОбработатьИсключение(Результат.КраткоеПредставлениеОшибки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДействиеНадЗадачейНаСервереЗавершение(РезультатДействияСтрока)
	
	ДанныеДляОбновления = Неопределено;
	Результат = ИнтеграцияС1СДокументооборот3ВызовСервера.РезультатДействияНадЗадачей(
		РезультатДействияСтрока,
		ДанныеДляОбновления);
	
	Если Результат.Успешно И ДанныеДляОбновления <> Неопределено Тогда
		ЗадачаXDTO = ДанныеДляОбновления.objects[0];
		ОбработатьОтветВебСервисаНаПолучениеЗадачи(ЗадачаXDTO);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти
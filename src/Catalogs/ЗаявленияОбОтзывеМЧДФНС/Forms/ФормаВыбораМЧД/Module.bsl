
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Организация") Тогда
		Организация = Параметры.Организация;
	КонецЕсли;
	
	СинийЦвет 	= Новый Цвет(28, 85, 174);
	КрасныйЦвет = ЦветаСтиля.ЦветОшибкиПроверкиБРО;
	
	ЗапретитьИзменение 		= Ложь;
	СканированиеДоступно	= Ложь;
	
	СсылкаНаОтзыв = Параметры.СсылкаНаОтзыв;
	
	РежимЗаполненияЗаявления = "0";
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ЭтоXmlФайл = СтрНайти(ВРег(Элемент.Имя), "XML");
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "выберите" Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОбработкаНавигационнойСсылкиПослеВыбораФайла",
			ЭтотОбъект,
			Элемент.Имя);
		
		ДополнительныеПараметры = Новый Структура();
		ДополнительныеПараметры.Вставить("Фильтр", 					"XML-файл УПРУП ПФР (*.xml)|*.xml");
		ДополнительныеПараметры.Вставить("ВозвращатьРазмер", 		Истина);
		ДополнительныеПараметры.Вставить("МножественныйВыбор", 		Ложь);
		
		ОперацииСФайламиЭДКОКлиент.ДобавитьФайлы(
			ОписаниеОповещения, 
			Новый УникальныйИдентификатор,
			НСтр("ru = 'Выберите xml-файл'"),
			ДополнительныеПараметры);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "Файл" Тогда
		Если ЭтоXmlФайл Тогда
			ОперацииСФайламиЭДКОКлиент.ОткрытьФайл(XMLФайл.Адрес, XMLФайл.Имя);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьФайлНажатие(Элемент)
	
	ЭтоXmlФайл = СтрНайти(ВРег(Элемент.Имя), "XML");
	
	Если ЭтоXmlФайл Тогда
		XMLФайл = Неопределено;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	Если ЭтаФорма.РежимЗаполненияЗаявления = "0" Тогда
		
		Если НЕ ЗначениеЗаполнено(Доверенность) Тогда
			ОткрытьФорму("Справочник.ЗаявленияОбОтзывеМЧДФНС.ФормаОбъекта", , ЭтотОбъект);
		Иначе
			Если ЗначениеЗаполнено(ЭтотОбъект.Доверенность) Тогда
				ОткрытьФорму("Справочник.ЗаявленияОбОтзывеМЧДФНС.ФормаОбъекта", Новый Структура("Доверенность", Доверенность), ЭтотОбъект);
			Иначе
				Сообщить("Не указана доверенность.");
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтаФорма.РежимЗаполненияЗаявления = "1" Тогда
		
		Если НЕ ЗначениеЗаполнено(XMLФайл) ИЛИ НЕ ЗначениеЗаполнено(XMLФайл.Адрес) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не выбран файл заявления об отзыве доверенности'"));
			Возврат;
		КонецЕсли;
		
		РезультатЗагрузки = ДокументооборотСКОВызовСервера.ЗагрузитьЗаявлениеОбОтзывеМЧДФНС(
		XMLФайл.Адрес,
		СсылкаНаОтзыв,
		Неопределено);
		Если НЕ РезультатЗагрузки.Выполнено Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(РезультатЗагрузки.Ошибка);
			Возврат;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СсылкаНаОтзыв) Тогда
			ПоказатьЗначение(, РезультатЗагрузки.Ссылка);
		КонецЕсли;
		
	КонецЕсли;
		
	Если ЭтаФорма.РежимЗаполненияЗаявления = "2" Тогда
		
		ДополнительныеПараметры = Новый Структура();
		ДополнительныеПараметры.Вставить("Организация", Организация);
		
		ЗначенияЗаполнения = Новый Структура();
		ЗначенияЗаполнения.Вставить("Организация", Организация);
		
		ДополнительныеПараметры.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
			
		ОткрытьФорму("Справочник.ЗаявленияОбОтзывеМЧДФНС.ФормаОбъекта", ДополнительныеПараметры,,Новый УникальныйИдентификатор);
			
	КонецЕсли;
	
	Закрыть(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаНавигационнойСсылкиПослеВыбораФайла(Результат, ИмяЭлемента) Экспорт
	
	Если НЕ Результат.Выполнено ИЛИ Результат.ОписанияФайлов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	
	ОписаниеФайла = Результат.ОписанияФайлов[0];
	
	ЭтоXmlФайл = СтрНайти(ВРег(ИмяЭлемента), "XML");
	
	Если ЭтоXmlФайл Тогда
		Если НЕ СтрНайти(Врег(ОписаниеФайла.Имя), "ON_OFFDOVER") Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Имя файла заявления об отзыве машиночитаемой доверенности (ФНС) должно начинаться на ON_OFFDOVER'"));
			Возврат;
		КонецЕсли;
		
		Попытка
			КНД = ДокументооборотСКОВызовСервера.КНДФайлаПоАдресу(ОписаниеФайла.Адрес, "windows-1251");
			Если КНД <> "1110311" Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю(
					НСтр("ru = 'Выбран файл не заявления об отзыве машиночитаемой доверенности (ФНС) (КНД заявления об отзыве доверенности должен быть равен 1110311)'"));
				Возврат;
			КонецЕсли;
		Исключение
			ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Выбран файл не заявления об отзыве машиночитаемой доверенности (ФНС) (КНД заявления об отзыве доверенности должен быть равен 1110311)'"),,,, Истина);
			Возврат;
		КонецПопытки;
		
		XMLФайл = Новый ФиксированнаяСтруктура(ОписаниеФайла);
		
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	РазмерФайла = ?(ЗначениеЗаполнено(Форма.XMLФайл), Форма.XMLФайл.Размер, 0);
	КоличествоФайлов = ?(ЗначениеЗаполнено(Форма.XMLФайл) И ЗначениеЗаполнено(Форма.XMLФайл.Адрес), 1, 0);
	ИмяПервогоФайла = ?(ЗначениеЗаполнено(Форма.XMLФайл), Форма.XMLФайл.Имя, "");
	ДокументооборотСКОКлиентСервер.ИзменитьОформлениеДокумента(
		Форма,
		"XML",
		РазмерФайла,
		КоличествоФайлов,
		ИмяПервогоФайла);
		
	Форма.Элементы.ВыбратьИзБазы.Видимость = ?(Форма.РежимЗаполненияЗаявления = "0", Истина, Ложь);
	Форма.Элементы.XML.Видимость = ?(Форма.РежимЗаполненияЗаявления = "1", Истина, Ложь);
	Форма.Элементы.РучноеЗаполнение.Видимость = ?(Форма.РежимЗаполненияЗаявления = "2", Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура("Владелец", Организация);
	ОткрытьФорму(
		"Справочник.МашиночитаемыеДоверенностиФНС.ФормаВыбора",
		Новый Структура("Отбор", ПараметрыФормы),
		Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимЗаполненияЗаявленияПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

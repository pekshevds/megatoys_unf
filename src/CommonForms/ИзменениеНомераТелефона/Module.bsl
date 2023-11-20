#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	НовыйТелефон = Параметры.НовыйТелефон;
	Сертификат = Параметры.Сертификат;
		
	ИдентификаторЗаявления = Строка(Новый УникальныйИдентификатор);
	
	ЗаполнитьПеременныеДляПроверкиТелефона(ЭтотОбъект);
	Если Параметры.Свойство("ИдентификаторПроверки") Тогда
		ПроверкаТелефонДляПаролей.ИдентификаторПроверки = Параметры.ИдентификаторПроверки;
		ПроверкаТелефонДляПаролей.ПодтверждениеВыполнено = ЗначениеЗаполнено(ПроверкаТелефонДляПаролей.ИдентификаторПроверки);
		ПроверкаТелефонДляПаролей.ЗначениеВведено = ЗначениеЗаполнено(ПроверкаТелефонДляПаролей.ИдентификаторПроверки);
	КонецЕсли;

	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.НовыйТелефон.ОбновитьТекстРедактирования();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НовыйТелефонПриИзменении(Элемент)
	
	НовыйТелефонИзменениеТекстаРедактирования(Элемент, Элемент.ТекстРедактирования, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НовыйТелефонИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	Представление = ЭлектроннаяПодписьВМоделиСервисаКлиентСервер.ПолучитьПредставлениеТелефона(Текст);
	НовыйТелефон = Представление;
	
	ПроверкаТелефонДляПаролей.ЗначениеВведено = ЗначениеЗаполнено(Представление);
	Если Не ЗначениеЗаполнено(Представление) Тогда
		НовыйТелефон = Текст;
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_ОбработчикОбратногоОтсчета");
	ОтключитьОбработчикОжидания("Подключаемый_ОбновитьНовыйТелефон");
	ПодключитьОбработчикОжидания("Подключаемый_ОбновитьНовыйТелефон", 1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КодПодтвержденияПриИзменении(Элемент)
	
	КодПодтвержденияИзменениеТекстаРедактирования(Элемент, Элемент.ТекстРедактирования, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КодПодтвержденияИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	Если СтрДлина(СокрЛП(Текст)) = 6 Тогда
		КодПодтверждения = СокрЛП(Текст);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьКодПодтверждения", 0.5, Истина); 
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьНомер(Команда)
	
	ОтправитьКодПодтверждения();

КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПроверкуТелефонаНажатие(Элемент)
	
	ПроверкаТелефонДляПаролей = ПроверкаТелефонДляПаролей(Ложь, Ложь, "", Ложь, Ложь);
	НовыйТелефон = Неопределено;
	Таймер = 0;
	ОтключитьОбработчикОжидания("Подключаемый_ОбработчикОбратногоОтсчета");
	ПодключитьОбработчикОжидания("Подключаемый_ОбновитьТекстПоляНовыйТелефон", 0.1, Истина);
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьКодПовторно(Команда)
	
	ОтправитьКодПодтверждения();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьШаг1ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	Если НавигационнаяСсылка = "#НапечататьЗаявление" И ПроверитьПодтвержденностьТелефона() Тогда
		Результат = ПолучитьТабличныйДокументНаСервере(
			ИдентификаторЗаявления, ПроверкаТелефонДляПаролей.ИдентификаторПроверки, 
			СервисКриптографииСлужебныйКлиент.Идентификатор(Сертификат));
		Если Результат.Выполнено Тогда
			ЗаявлениеНапечатано = Истина;
			ИдентификаторПечатнойФормы = "ЗаявлениеНаИзменениеНомераТелефона";
			НазваниеПечатнойФормы = НСтр("ru = 'Заявление на смену абонентского номера подвижной (мобильной) связи'");
			
			Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
				ИмяМодуляУправлениеПечатьюКлиент = "УправлениеПечатьюКлиент"; 
				МодульУправлениеПечатьюКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(ИмяМодуляУправлениеПечатьюКлиент);
				
				КоллекцияПечатныхФорм = МодульУправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм(ИдентификаторПечатнойФормы);
				ПечатнаяФорма = МодульУправлениеПечатьюКлиент.ОписаниеПечатнойФормы(КоллекцияПечатныхФорм, ИдентификаторПечатнойФормы);
				ПечатнаяФорма.СинонимМакета = НазваниеПечатнойФормы;
				ПечатнаяФорма.ТабличныйДокумент = Результат.Файл;
				ПечатнаяФорма.ИмяФайлаПечатнойФормы = НазваниеПечатнойФормы;
				
				ОбластиОбъектов = Новый СписокЗначений;
				МодульУправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм, ОбластиОбъектов);
			Иначе
				Результат.Файл.Показать(НазваниеПечатнойФормы);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлЗаявленияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ПроверитьПодтвержденностьТелефона() Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ФайлЗаявлениеНажатиеПослеПомещенияФайла", ЭтотОбъект);
	НачатьПомещениеФайла(Оповещение,,, Истина, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлЗаявлениеНажатиеПослеПомещенияФайла(Результат, Адрес, ВыбранноеИмяФайла, ВходящийКонтекст) Экспорт
	
	Если Результат Тогда
		Файл = Новый Файл(ВыбранноеИмяФайла);
		ФайлЗаявления = Файл.Имя;
		АдресФайлаЗаявления = Адрес;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьЗаявление(Команда)
	
	Если Не ПроверитьПодтвержденностьТелефона() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(АдресФайлаЗаявления) Тогда
		ТекстСообщения = НСтр("ru = 'Выберите файл заявления'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "ФайлЗаявления");
		Возврат;
	КонецЕсли;
	
	ОповещениеСледующее = Новый ОписаниеОповещения("РезультатВыбораПользователя", ЭтотОбъект);
	СписокКоманд = Новый СписокЗначений;
	СписокКоманд.Добавить(КомандаОтправитьЗаявление(), НСтр("ru = 'Отправить заявление'"), Истина);
	СписокКоманд.Добавить(КомандаОтмена(),  НСтр("ru = 'Отмена'"));
	
	ТекстВопроса = СтроковыеФункцииКлиент.ФорматированнаяСтрока(
		НСтр("ru = 'Обратите внимание, прилагаемый сканированный документ должен быть заверен:
			|1. Печатью вашей организации и подписью владельца сертификата.
			|2. Печатью обслуживающей организации и подписью ее уполномоченного сотрудника.
			|
			|<b>Оба заверения обязательны, иначе заявление будет отклонено. </b>
			|'"));

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СписокКоманд", СписокКоманд);
	ПараметрыФормы.Вставить("ТекстВопроса", ТекстВопроса);
	ПараметрыФормы.Вставить("Заголовок",  НСтр("ru = 'Убедитесь, что заявление заверено верно'"));
	ПараметрыФормы.Вставить("ЗаголовокПодтверждения",  НСтр("ru = 'Подтверждаю, что заявление заверено обеими организациями'"));
	
	ОткрытьФорму("ОбщаяФорма.ПодтверждениеСменыТелефона", ПараметрыФормы, ЭтаФорма, , , , ОповещениеСледующее);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура РезультатВыбораПользователя(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = КомандаОтправитьЗаявление() Тогда
		Файл = Новый Структура("Имя,Адрес", ФайлЗаявления, АдресФайлаЗаявления);
		Результат = ПодготовкаЗаявления(Файл); 
		Если Результат.Выполнено Тогда
			ЗаявлениеОтправлено = Истина;
			УправлениеФормой(ЭтотОбъект);
		Иначе
			ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.ОписаниеОшибки); 
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция КомандаОтправитьЗаявление()
	
	Возврат "ОтправитьЗаявление";
	
КонецФункции

&НаКлиенте
Функция КомандаОтмена()
	
	Возврат "Отмена";
	
КонецФункции

&НаКлиенте
Процедура ОтправитьКодПодтверждения()
	
	ОтключитьОбработчикОжидания("Подключаемый_ОбновитьНовыйТелефон");
	ОчиститьСообщения();
	КодПодтверждения = Неопределено;
	
	Результат = ПроверитьНомерНаСервере(НовыйТелефон, ПроверкаТелефонДляПаролей.ИдентификаторПроверки);
	Если Результат.Выполнено Тогда
		Таймер = Результат.ЗадержкаПередПовторнойОтправкой;
		ПроверкаТелефонДляПаролей.ИдентификаторПроверки = Результат.Идентификатор;
		ЗапуститьОбратныйОтсчет();
		ПроверкаТелефонДляПаролей.ВыполняетсяПроверка = Истина;
		ПроверкаТелефонДляПаролей.КодОтправлен = Истина;
		
		ПодключитьОбработчикОжидания("Подключаемый_АктивироватьПолеКодПодтверждения", 0.1, Истина);	
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.ОписаниеОшибки,, "НовыйТелефон");
	КонецЕсли;
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьНомерНаСервере(Телефон, Идентификатор)
	
	Возврат МенеджерСервисаКриптографии.ПолучитьКодПроверкиТелефона(Телефон, Идентификатор);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_АктивироватьПолеКодПодтверждения()
	
	ТекущийЭлемент = Элементы.КодПодтверждения;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьОбратныйОтсчет()
	
	ПодключитьОбработчикОжидания("Подключаемый_ОбработчикОбратногоОтсчета", 1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОбратногоОтсчета()
	
	Таймер = Таймер - 1;
	Если Таймер >= 0 Тогда
		НадписьОбратногоОтсчета = СтрШаблон(НСтр("ru = 'Запросить код повторно можно будет через %1 сек.'"), Таймер);
		ПодключитьОбработчикОжидания("Подключаемый_ОбработчикОбратногоОтсчета", 1, Истина);		
	Иначе
		НадписьОбратногоОтсчета = "";
		ПроверкаТелефонДляПаролей.КодОтправлен = Ложь;
		УправлениеФормой(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

// Возвращаемое значение:
//  Булево - признак подтверждения.
&НаКлиенте
Функция ПроверитьПодтвержденностьТелефона()
	
	Если Не ПроверкаТелефонДляПаролей.ПодтверждениеВыполнено Тогда
		ТекстСообщения = НСтр("ru = 'Сначала необходимо подтвердить новый номер телефона'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "НовыйТелефон");		
	КонецЕсли;
	
	Возврат ПроверкаТелефонДляПаролей.ПодтверждениеВыполнено;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.КартинкаТелефонПроверен.Видимость = Форма.ПроверкаТелефонДляПаролей.ПодтверждениеВыполнено;
	Элементы.ПроверитьНомер.Видимость = 
		Форма.ПроверкаТелефонДляПаролей.ЗначениеВведено 
		И Не Форма.ПроверкаТелефонДляПаролей.ПодтверждениеВыполнено 
		И Не Форма.ПроверкаТелефонДляПаролей.ВыполняетсяПроверка;
	Элементы.НовыйТелефон.ТолькоПросмотр = ЗначениеЗаполнено(Форма.ПроверкаТелефонДляПаролей.ИдентификаторПроверки);
	Элементы.ГруппаКодПодтверждения.Видимость = 
		Форма.ПроверкаТелефонДляПаролей.ВыполняетсяПроверка 
		И Не Форма.ПроверкаТелефонДляПаролей.ПодтверждениеВыполнено;
		
	Элементы.ОтправитьКодПовторно.Видимость = Не Форма.ПроверкаТелефонДляПаролей.КодОтправлен;
	Элементы.НадписьОбратногоОтсчета.Видимость = Форма.ПроверкаТелефонДляПаролей.КодОтправлен;
	
	Форма.ФайлЗаявления = НСтр("ru = 'Выбрать'");
	
	Элементы.ГруппаИнструкция.Видимость = Не Форма.ЗаявлениеОтправлено;
	Элементы.Информация.Видимость = Форма.ЗаявлениеОтправлено;
	Элементы.Информация.Заголовок = СтрШаблон(НСтр("ru = 'Заявление принято к рассмотрению.
                                                    |По результатам рассмотрения заявления будет отправлено SMS на номер %1'"), Форма.НовыйТелефон);
													
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТабличныйДокументНаСервере(ИдентификаторЗаявления, ИдентификаторПроверки, ИдентификаторСертификата)
	
	Результат = МенеджерСервисаКриптографии.НапечататьЗаявление(ИдентификаторЗаявления, ИдентификаторПроверки, ИдентификаторСертификата);
	Если Не Результат.Выполнено Тогда
		ОбщегоНазначения.СообщитьПользователю(Результат.ОписаниеОшибки);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ОтправитьЗаявлениеНаСервере(ИдентификаторЗаявления, ФайлЗаявления)
	
	Результат = МенеджерСервисаКриптографии.ОтправитьЗаявление(ИдентификаторЗаявления, ФайлЗаявления);
	Если Не Результат.Выполнено Тогда
		ОбщегоНазначения.СообщитьПользователю(Результат.ОписаниеОшибки);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПодготовкаЗаявления(Файл)
	
	Результат	= Новый Структура();
	Результат.Вставить("Выполнено", Истина);
	
	Если НЕ ЗаявлениеНапечатано Тогда
		Результат = ПолучитьТабличныйДокументНаСервере(
			ИдентификаторЗаявления, ПроверкаТелефонДляПаролей.ИдентификаторПроверки, 
			СервисКриптографииСлужебный.Идентификатор(Сертификат));
	КонецЕсли;
	
	Если Результат.Выполнено Тогда
		Результат = ОтправитьЗаявлениеНаСервере(ИдентификаторЗаявления, Файл);
	КонецЕсли;	
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьКодПодтверждения()
	
	ОчиститьСообщения();
	
	КодПодтверждения = СокрЛП(КодПодтверждения);
	Если СтрДлина(КодПодтверждения) = 6 Тогда
		Результат = Неопределено;
		
		Если ПроверкаТелефонДляПаролей.ВыполняетсяПроверка Тогда
			Результат = ПроверитьТелефонПоКодуНаСервере(
				ПроверкаТелефонДляПаролей.ИдентификаторПроверки, КодПодтверждения);
			Если Результат.Выполнено Тогда
				ПроверкаТелефонДляПаролей.ВыполняетсяПроверка = Ложь;
				ПроверкаТелефонДляПаролей.ПодтверждениеВыполнено = Истина;				
			КонецЕсли;
		КонецЕсли;
		
		Если Результат <> Неопределено Тогда
			Если Результат.Выполнено Тогда
				ОтключитьОбработчикОжидания("Подключаемый_ОбработчикОбратногоОтсчета");
				УправлениеФормой(ЭтотОбъект);
			Иначе
				ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.ОписаниеОшибки,, "КодПодтверждения");
			КонецЕсли;
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьТелефонПоКодуНаСервере(Идентификатор, КодПодтверждения) 
	
	Возврат МенеджерСервисаКриптографии.ПроверитьТелефонПоКоду(Идентификатор, КодПодтверждения);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ОбновитьНовыйТелефон()
	
	Элементы.ПроверитьНомер.Видимость = ПроверкаТелефонДляПаролей.ЗначениеВведено;
	Если ПроверкаТелефонДляПаролей.ЗначениеВведено Тогда
		Элементы.НовыйТелефон.ОбновитьТекстРедактирования();
		ОтключитьОбработчикОжидания("Подключаемый_АктивироватьКнопкуПроверитьНомер");
		ПодключитьОбработчикОжидания("Подключаемый_АктивироватьКнопкуПроверитьНомер", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьТекстПоляНовыйТелефон()
	
	Элементы.НовыйТелефон.ОбновитьТекстРедактирования();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_АктивироватьКнопкуПроверитьНомер()
	
	ТекущийЭлемент = Элементы.ПроверитьНомер;	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьПеременныеДляПроверкиТелефона(Форма)
	
	Форма.ПроверкаТелефонДляПаролей = ПроверкаТелефонДляПаролей(Ложь, Ложь, "", Ложь, Ложь);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПроверкаТелефонДляПаролей(ЗначениеВведено, ВыполняетсяПроверка, ИдентификаторПроверки, ПодтверждениеВыполнено, КодОтправлен)
	
	ПроверкаТелефонДляПаролей = Новый Структура;
	
	ПроверкаТелефонДляПаролей.Вставить("ЗначениеВведено", ЗначениеВведено);
	ПроверкаТелефонДляПаролей.Вставить("ВыполняетсяПроверка", ВыполняетсяПроверка);
	ПроверкаТелефонДляПаролей.Вставить("ИдентификаторПроверки", ИдентификаторПроверки);
	ПроверкаТелефонДляПаролей.Вставить("ПодтверждениеВыполнено", ПодтверждениеВыполнено);
	ПроверкаТелефонДляПаролей.Вставить("КодОтправлен", КодОтправлен);
	
	Возврат ПроверкаТелефонДляПаролей;
	
КонецФункции

#КонецОбласти
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Для нового объекта выполняем код инициализации формы в ПриСозданииНаСервере.
	// Для существующего - в ПриЧтенииНаСервере.
	Ссылка = Объект.Ссылка;
	Если Ссылка.Пустая() Тогда
		ИнициализироватьФормуЗадачи();
	КонецЕсли;
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
			
	Если Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
		
	// СтандартныеПодсистемы.РаботаСФайлами
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайлами = ОбщегоНазначения.ОбщийМодуль("РаботаСФайлами");
		ПараметрыГиперссылки = МодульРаботаСФайлами.ГиперссылкаФайлов();
		ПараметрыГиперссылки.Размещение = "КоманднаяПанель";
		ПараметрыГиперссылки.Владелец = "Объект.БизнесПроцесс";
		МодульРаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыГиперссылки);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	БизнесПроцессыИЗадачиКлиент.ОбновитьДоступностьКомандПринятияКИсполнению(ЭтотОбъект);
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
		
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	БизнесПроцессыЗаявокСотрудниковФормы.ЗаписатьРеквизитыБизнесПроцесса(ЭтотОбъект, ТекущийОбъект);
	
	ВыполнитьЗадачу = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыЗаписи, "ВыполнитьЗадачу", Ложь);
	Если НЕ ВыполнитьЗадачу Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗаданиеВыполнено И НЕ ЗначениеЗаполнено(ТекущийОбъект.РезультатВыполнения) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Укажите причину, по которой задача отклоняется.'"),,
			"Объект.РезультатВыполнения",,
			Отказ);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	БизнесПроцессыИЗадачиКлиент.ФормаЗадачиОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	Если ИмяСобытия = "Запись_Задание" Тогда
		Если (Источник = Объект.БизнесПроцесс ИЛИ (ТипЗнч(Источник) = Тип("Массив") 
			И Источник.Найти(Объект.БизнесПроцесс) <> Неопределено)) Тогда
			Прочитать();
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "ЗаявкиСотрудниковЗаписанДокумент" Тогда
		Если (Источник = ЭтотОбъект) Тогда
			ЗаписанДокументБольничныйЛист(Параметр);
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "ШаблонОтветаЗаписанСправочник" Тогда
		Если (Источник = ЭтотОбъект) Тогда
			ШаблонОтвета = Параметр;
			Элементы.ШаблонОтвета.Видимость = Истина;
			ШаблонОтветаПриИзмененииНаСервере();
		КонецЕсли;
	КонецЕсли;
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ИнициализироватьФормуЗадачи();
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект);	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеФайлаОтветаНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьПрисоединенныйФайл(ФайлОтвета);	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьФайлНажатие(Элемент)
	УдалитьПрисоединенныйФайл();	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФайлНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьПрисоединенныйФайл(ЭтотОбъект[Элемент.Имя]);	
КонецПроцедуры

&НаКлиенте
Процедура ЗаданиеДокументБольничныйЛистПриИзменении(Элемент)
	ЗаписанДокументБольничныйЛист(Задание.БольничныйЛист);
КонецПроцедуры

&НаКлиенте
Процедура ШаблонОтветаПриИзменении(Элемент)
	ШаблонОтветаПриИзмененииНаСервере();	
КонецПроцедуры

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент,
			ПараметрыПеретаскивания, СтандартнаяОбработка);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент,
			ПараметрыПеретаскивания, СтандартнаяОбработка);
	КонецЕсли;	
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

&НаКлиенте
Процедура Подключаемый_СвязаннаяЗаявкаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НомерСсылки = Число(СтрЗаменить(Элемент.Имя, "СсылкаНаЗаявку", "")); 
	ВыбраннаяЗаявка = СвязанныеЗаявки[НомерСсылки].Ссылка;
	ФормаТекущейЗадачи =
		БизнесПроцессыЗаявокСотрудниковВызовСервера.ФормаОткрытияТекущейЗадачиБизнесПроцесса(ВыбраннаяЗаявка);
	ОткрытьФорму(ФормаТекущейЗадачи.ИмяФормы, ФормаТекущейЗадачи.ПараметрыФормы);	

КонецПроцедуры  

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполненоВыполнить(Команда)
	Если ПодписыватьЗаявкиСотрудника Тогда
		БизнесПроцессыЗаявокСотрудниковКлиент.ПодписатьЗаявкуЭП(ЭтотОбъект, "ВыполненоВыполнитьЗавершение");
	Иначе
		ВыполненоВыполнитьЗавершение(Неопределено, Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Отказать(Команда)
	Если ПодписыватьЗаявкиСотрудника Тогда
		БизнесПроцессыЗаявокСотрудниковКлиент.ПодписатьЗаявкуЭП(ЭтотОбъект, "ОтказатьЗавершение");
	Иначе
		ОтказатьЗавершение(Неопределено, Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокумент(Команда)
	ОткрытьФорму("Документ.БольничныйЛист.ФормаОбъекта", ПараметрыЗаполненияДокумента(), ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ЗаписанДокументБольничныйЛист(Результат) 
	
	СсылкаНаДокумент = Неопределено;
	Если Результат <> Неопределено Тогда
		СсылкаНаДокумент = Результат
	КонецЕсли;
	
	ЗаписанДокументБольничныйЛистНаСервере(СсылкаНаДокумент);
	УстановитьВидимостьКнопокДействий();
			
КонецПроцедуры

&НаКлиенте
Процедура Дополнительно(Команда)
	БизнесПроцессыИЗадачиКлиент.ОткрытьДопИнформациюОЗадаче(Объект.Ссылка);	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	БизнесПроцессыЗаявокСотрудниковКлиент.ПринятьЗадачуКИсполнению(ЭтотОбъект, ТекущийПользователь);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	БизнесПроцессыИЗадачиКлиент.ОтменитьПринятиеЗадачКИсполнению(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Ссылка));
	Прочитать();
	БизнесПроцессыИЗадачиКлиент.ОбновитьДоступностьКомандПринятияКИсполнению(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьЗадание(Команда)
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;	
	ПоказатьЗначение(,Объект.БизнесПроцесс);	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайлОтвета(Команда)
	
	Обработчик = Новый ОписаниеОповещения("ВыбратьФайлОтветаПослеПомещенияФайла", ЭтотОбъект);
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.Диалог.Фильтр = НСтр("ru = 'Файлы MS Word (*.doc;*.docx)|*.doc;*.docx|Файлы PDF(*.pdf;*.PDF)|*.pdf;*.PDF'");

	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;

	ФайловаяСистемаКлиент.ЗагрузитьФайл(Обработчик, ПараметрыЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьШаблонОтвета(Команда)
	БизнесПроцессыЗаявокСотрудниковКлиент.СохранитьШаблонОтвета(ЭтотОбъект);
КонецПроцедуры

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);
	КонецЕсли;
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СерверныеОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура ШаблонОтветаПриИзмененииНаСервере()
	БизнесПроцессыЗаявокСотрудниковФормы.ПослеВыбораШаблона(ЭтотОбъект, ШаблонОтвета, Неопределено);
КонецПроцедуры

#КонецОбласти

#Область СерверныеОбработчикиКомандФормы

&НаСервере
Процедура ЗаписанДокументБольничныйЛистНаСервере(СсылкаНаДокумент)
	ЗаданиеОбъект = РеквизитФормыВЗначение("Задание");
	Если ТипЗнч(СсылкаНаДокумент) = Тип("ДокументСсылка.БольничныйЛист") Тогда
		ЗаданиеОбъект.БольничныйЛист = СсылкаНаДокумент;
	КонецЕсли;
	ЗаданиеОбъект.Записать();
	ЗначениеВРеквизитФормы(ЗаданиеОбъект, "Задание");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОповещений

&НаКлиенте
Процедура ВыбратьФайлОтветаПослеПомещенияФайла(ПомещенныйФайл, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныйФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	БизнесПроцессыЗаявокСотрудниковКлиент.ВыбратьФайлОтветаПослеПомещенияФайла(ЭтотОбъект,
																			   ПомещенныйФайл,
																			   ДополнительныеПараметры);																		   
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполненоВыполнитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	БизнесПроцессыЗаявокСотрудниковКлиент.ВыполненоВыполнитьЗавершение(ЭтотОбъект, Результат, ДополнительныеПараметры);
КонецПроцедуры

&НаКлиенте
Процедура ОтказатьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	БизнесПроцессыЗаявокСотрудниковКлиент.ОтказатьЗавершение(ЭтотОбъект, Результат, ДополнительныеПараметры);
КонецПроцедуры	

#КонецОбласти

#Область ОткрытиеФормДокументов

&НаСервере
Функция ПараметрыЗаполненияДокумента()
	
	ПараметрыЗаполнения = Новый Структура;
	
	ЗаполнитьПараметрыЗаполненияБольничныйЛист(ПараметрыЗаполнения);
		
	Возврат ПараметрыЗаполнения;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПараметрыЗаполненияБольничныйЛист(ПараметрыЗаполнения)
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Действие", "ЗаполнитьПоПараметрамЗаполнения");
	ДанныеЗаполнения.Вставить("ДатаНачала", Задание.ДатаНачалаОтсутствия);
	ДанныеЗаполнения.Вставить("ДатаНачалаОплаты", Задание.ДатаНачалаОтсутствия);
	ДанныеЗаполнения.Вставить("ДатаОкончания", Задание.ДатаОкончанияОтсутствия);
	ДанныеЗаполнения.Вставить("ДатаОкончанияОплаты", Задание.ДатаОкончанияОтсутствия);
	
	ПериодРасчетаСреднего = УчетПособийСоциальногоСтрахованияКлиентСервер.ПериодРасчетаСреднегоЗаработкаФСС(Задание.ДатаНачалаОтсутствия);
	ДанныеЗаполнения.Вставить("ПериодРасчетаСреднегоЗаработкаПервыйГод", Год(ПериодРасчетаСреднего.ДатаНачала));
	ДанныеЗаполнения.Вставить("ПериодРасчетаСреднегоЗаработкаВторойГод", Год(ПериодРасчетаСреднего.ДатаОкончания));
	
	Если Задание.Организация.Пустая() Тогда
		ОсновныеСотрудники = КадровыйУчет.ОсновныеСотрудникиИнформационнойБазы(Истина, Задание.ФизическоеЛицо, Задание.ДатаНачалаОтсутствия);
		ОсновнойСотрудник = ОсновныеСотрудники[Задание.ФизическоеЛицо];
		ДанныеЗаполнения.Вставить("Сотрудник", ОсновнойСотрудник);
		КадровыеДанныеОсновногоСотрудника = КадровыйУчет.КадровыеДанныеСотрудников(Истина, ОсновнойСотрудник, "Организация", Задание.ДатаНачалаОтсутствия);
		Если КадровыеДанныеОсновногоСотрудника.Количество() = 0 Тогда
			ВызватьИсключение НСтр("ru = 'Сотрудник не принят на работу.'");	
		КонецЕсли;
		ОрганизацияОсновногоСотрудника = КадровыеДанныеОсновногоСотрудника.Найти(ОсновнойСотрудник).Организация;
		ДанныеЗаполнения.Вставить("Организация", ОрганизацияОсновногоСотрудника);
	Иначе
		ДанныеЗаполнения.Вставить("Организация", Задание.Организация);	
		ДанныеЗаполнения.Вставить("Сотрудник", КадровыйУчет.ОсновнойСотрудникФизическогоЛица(Задание.ФизическоеЛицо,
																							 Задание.Организация,
																							 Задание.ДатаНачалаОтсутствия));
	КонецЕсли;
	Если Задание.ПоБеременности Тогда																					 
		ДанныеЗаполнения.Вставить("ПричинаНетрудоспособности", Перечисления.ПричиныНетрудоспособности.ПоБеременностиИРодам);
	КонецЕсли;
		
	ПараметрыЗаполнения.Вставить("Основание", ДанныеЗаполнения); 		
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ИнициализироватьФормуЗадачи()
	
	БизнесПроцессыЗаявокСотрудниковФормы.ИнициализироватьФормуЗадачи(ЭтотОбъект, Элементы.ЗаданиеДокументБольничныйЛист);
	БизнесПроцессыЗаявокСотрудниковФормы.ВывестиСвязанныеЗаявкиСотрудника(ЭтотОбъект);
	УстановитьВидимостьКнопокДействий();
	
	Элементы.ГруппаОтсутствие.Заголовок = ?(Задание.ПоБеременности, НСтр("ru = 'Отпуск по беременности'"),
																	НСтр("ru = 'Отсутствие по болезни'"));
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПрисоединенныйФайл(ПрисоединенныйФайл)
	БизнесПроцессыЗаявокСотрудниковКлиент.ОткрытьПрисоединенныйФайл(ЭтотОбъект, ПрисоединенныйФайл);	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПрисоединенныйФайл()
	Модифицированность = Истина;
	ФайлОтвета = Неопределено;
	РасширениеФайлаОтветаБезТочки = "";
	ПредставлениеФайлаОтвета = "";
	АдресХранилищаФайлаОтвета = "";	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКнопокДействий()
	
	ПредметЗаполнен = ЗначениеЗаполнено(Задание.БольничныйЛист);
	
	Элементы.СоздатьДокумент.Видимость = НЕ ПредметЗаполнен;
	Элементы.Отказать.Доступность = НЕ ПредметЗаполнен И НЕ Объект.Выполнена;
	Элементы.Выполнено.Доступность = ПредметЗаполнен И НЕ Объект.Выполнена;
	
	Если Объект.Выполнена Тогда
		Возврат;
	КонецЕсли;
	
	ИспользоватьКадровыйУчетРасширенная = ПолучитьФункциональнуюОпцию("РасчетЗарплатыДляНебольшихОрганизаций");
	
	Элементы.СоздатьДокумент.Доступность = Элементы.СоздатьДокумент.Доступность И ИспользоватьКадровыйУчетРасширенная;
	Элементы.Выполнено.Доступность = (НЕ ИспользоватьКадровыйУчетРасширенная) ИЛИ Элементы.Выполнено.Доступность;	

	Для Каждого СтрокаТЗ Из СвязанныеЗаявки Цикл
		Если СтрокаТЗ.СостояниеЗаявки = Перечисления.СостоянияЗаявокКабинетСотрудника.Выполнена Тогда
			Элементы.Отказать.Доступность = Ложь;
			Элементы.ГруппаЕстьВыполненнаяЗаявка.Видимость = Истина;
			Прервать;
		КонецЕсли;
		Если СтрокаТЗ.СостояниеЗаявки = Перечисления.СостоянияЗаявокКабинетСотрудника.Отказ Тогда
			Элементы.Выполнено.Доступность = Ложь;
			Элементы.ГруппаЕстьОтказ.Видимость = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти



#Область ПрограммныйИнтерфейс

// Пересчитывает суммы в строке ТЧ
//
// Параметры:
//  СтрокаТабличнойЧасти - ДанныеФормыСтруктура	 - Данные строки таблицы формы
//  ПараметрыРасчета	 - Структура			 - Содержит данные данные документа, необходимые для пересчета
//
Процедура РассчитатьСуммыВСтрокеТЧ(СтрокаТабличнойЧасти, ПараметрыРасчета) Экспорт

	Если НЕ ПараметрыРасчета.Свойство("РассчитатьСуммуСкидки") И НЕ ПараметрыРасчета.Свойство("РассчитатьПроцентСкидки") Тогда
		ПараметрыРасчета.Вставить("РассчитатьСуммуСкидки", Истина);
	КонецЕсли;
	Если НЕ ПараметрыРасчета.Свойство("РассчитатьСумму") И НЕ ПараметрыРасчета.Свойство("РассчитатьЦену") Тогда
		ПараметрыРасчета.Вставить("РассчитатьСумму", Истина);
	КонецЕсли;

	Если СтрокаТабличнойЧасти.Свойство("Кратность") И СтрокаТабличнойЧасти.Свойство("Коэффициент") Тогда
		КоличествоСтроки = СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.Кратность * СтрокаТабличнойЧасти.Коэффициент;
	Иначе
		КоличествоСтроки = СтрокаТабличнойЧасти.Количество;
	КонецЕсли; 
	
	Если ПараметрыРасчета.Свойство("СброситьФлагСкидкиРассчитаны") И ПараметрыРасчета.СброситьФлагСкидкиРассчитаны
		И СтрокаТабличнойЧасти.Свойство("ПроцентАвтоматическойСкидки")
		Тогда
		СтрокаТабличнойЧасти.ПроцентАвтоматическойСкидки = 0;
		СтрокаТабличнойЧасти.СуммаАвтоматическойСкидки = 0;
	КонецЕсли;
	
	Если СтрокаТабличнойЧасти.Свойство("ПроцентСкидкиНаценки") Тогда
		
		ЕстьСкидкаБонусом = СтрокаТабличнойЧасти.Свойство("СуммаСкидкиОплатыБонусом");
		
		Если ПараметрыРасчета.Свойство("РассчитатьЦену") И ПараметрыРасчета.РассчитатьЦену=Истина Тогда //Введена сумма строки, нужно пересчитать цену и сумму скидки
			Если КоличествоСтроки <> 0 Тогда
				Если СтрокаТабличнойЧасти.ПроцентСкидкиНаценки >= 100 Тогда
					// Если введена сумма строки и скидка 100%, меняем процент скидки
					СтрокаТабличнойЧасти.ПроцентСкидкиНаценки = Окр(100* (1 - СтрокаТабличнойЧасти.Сумма / (КоличествоСтроки * СтрокаТабличнойЧасти.Цена - ?(ЕстьСкидкаБонусом, СтрокаТабличнойЧасти.СуммаСкидкиОплатыБонусом, 0))), 2);
					СтрокаТабличнойЧасти.СуммаСкидкиНаценки = Окр((КоличествоСтроки * СтрокаТабличнойЧасти.Цена - ?(ЕстьСкидкаБонусом, СтрокаТабличнойЧасти.СуммаСкидкиОплатыБонусом, 0)) * СтрокаТабличнойЧасти.ПроцентСкидкиНаценки / 100, 2);	
				Иначе
					СтрокаТабличнойЧасти.Цена = (СтрокаТабличнойЧасти.Сумма + ?(ЕстьСкидкаБонусом, СтрокаТабличнойЧасти.СуммаСкидкиОплатыБонусом, 0))/((1 - СтрокаТабличнойЧасти.ПроцентСкидкиНаценки/100)*КоличествоСтроки);	
					СтрокаТабличнойЧасти.СуммаСкидкиНаценки = Окр((КоличествоСтроки * СтрокаТабличнойЧасти.Цена - ?(ЕстьСкидкаБонусом, СтрокаТабличнойЧасти.СуммаСкидкиОплатыБонусом, 0)) * СтрокаТабличнойЧасти.ПроцентСкидкиНаценки / 100, 2);	
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли ПараметрыРасчета.Свойство("РассчитатьПроцентСкидки") И ПараметрыРасчета.РассчитатьПроцентСкидки И СтрокаТабличнойЧасти.Сумма > 0 Тогда //Введена сумма скидки, нужно пересчитать процент скидки
			
			Если СтрокаТабличнойЧасти.СуммаСкидкиНаценки >= КоличествоСтроки * СтрокаТабличнойЧасти.Цена - ?(ЕстьСкидкаБонусом, СтрокаТабличнойЧасти.СуммаСкидкиОплатыБонусом, 0) Тогда
				СтрокаТабличнойЧасти.СуммаСкидкиНаценки = КоличествоСтроки * СтрокаТабличнойЧасти.Цена - ?(ЕстьСкидкаБонусом, СтрокаТабличнойЧасти.СуммаСкидкиОплатыБонусом, 0);
				СтрокаТабличнойЧасти.Сумма = 0;
				СтрокаТабличнойЧасти.ПроцентСкидкиНаценки = 100;
			Иначе
				СтрокаТабличнойЧасти.ПроцентСкидкиНаценки = Окр(100*СтрокаТабличнойЧасти.СуммаСкидкиНаценки / (КоличествоСтроки * СтрокаТабличнойЧасти.Цена - ?(ЕстьСкидкаБонусом, СтрокаТабличнойЧасти.СуммаСкидкиОплатыБонусом, 0)), 2);
				СтрокаТабличнойЧасти.Сумма = КоличествоСтроки * СтрокаТабличнойЧасти.Цена - СтрокаТабличнойЧасти.СуммаСкидкиНаценки - ?(ЕстьСкидкаБонусом, СтрокаТабличнойЧасти.СуммаСкидкиОплатыБонусом, 0);
			КонецЕсли;
			
		Иначе  //Если введен процент скидки, или если указаны и процент, и сумма, пересчитываем сумму скидки из процента, указанного в строке
			СтрокаТабличнойЧасти.СуммаСкидкиНаценки = Окр((КоличествоСтроки * СтрокаТабличнойЧасти.Цена - ?(ЕстьСкидкаБонусом, СтрокаТабличнойЧасти.СуммаСкидкиОплатыБонусом, 0)) * СтрокаТабличнойЧасти.ПроцентСкидкиНаценки / 100, 2);
			СтрокаТабличнойЧасти.Сумма = КоличествоСтроки * СтрокаТабличнойЧасти.Цена - СтрокаТабличнойЧасти.СуммаСкидкиНаценки - ?(ЕстьСкидкаБонусом, СтрокаТабличнойЧасти.СуммаСкидкиОплатыБонусом, 0);  			
		КонецЕсли; 		
		
		Если СтрокаТабличнойЧасти.Сумма >= 0 Тогда
			
			ЦенообразованиеКлиентСервер.ПересчитатьСтрокуТЧПоМинимальнымЦенам(СтрокаТабличнойЧасти, КоличествоСтроки, ПараметрыРасчета);
			
		КонецЕсли;	
	Иначе 	
		Если ПараметрыРасчета.Свойство("РассчитатьЦену") И ПараметрыРасчета.РассчитатьЦену=Истина Тогда //Введена сумма строки, нужно пересчитать цену с сумму скидки
			СтрокаТабличнойЧасти.Цена = ?(КоличествоСтроки=0, 0, СтрокаТабличнойЧасти.Сумма / КоличествоСтроки);
		Иначе
			СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Цена * КоличествоСтроки;
		КонецЕсли;
	КонецЕсли;
	
	Если СтрокаТабличнойЧасти.Свойство("СуммаСкидки") Тогда
		СтрокаТабличнойЧасти.СуммаСкидки = СтрокаТабличнойЧасти.СуммаСкидкиНаценки;
	КонецЕсли; 
	
	РассчитатьСуммуНДСИВсего(СтрокаТабличнойЧасти, ПараметрыРасчета);
	
КонецПроцедуры

// Пересчитывает сумму НДС и Всего
//
// Параметры:
//  СтрокаТабличнойЧасти - ДанныеФормыСтруктура	 - Данные строки таблицы формы
//  ПараметрыРасчета	 - Структура			 - Содержит данные данные документа, необходимые для пересчета
//
Процедура РассчитатьСуммуНДСИВсего(СтрокаТабличнойЧасти, ПараметрыРасчета) Экспорт
	
	СтавкаНДС = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеСтавкиНДС(СтрокаТабличнойЧасти.СтавкаНДС);
	
	СтрокаТабличнойЧасти.СуммаНДС = ?(ПараметрыРасчета.СуммаВключаетНДС, 
									  СтрокаТабличнойЧасти.Сумма - (СтрокаТабличнойЧасти.Сумма) / ((СтавкаНДС + 100) / 100),
									  СтрокаТабличнойЧасти.Сумма * СтавкаНДС / 100);
									  
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТабличнойЧасти, "Всего") Тогда
		СтрокаТабличнойЧасти.Всего = СтрокаТабличнойЧасти.Сумма + ?(ПараметрыРасчета.СуммаВключаетНДС, 0, СтрокаТабличнойЧасти.СуммаНДС);
	ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТабличнойЧасти, "СуммаСНДС") Тогда // в документе ВыводИзОборотаИСМП
		СтрокаТабличнойЧасти.СуммаСНДС = СтрокаТабличнойЧасти.Сумма + ?(ПараметрыРасчета.СуммаВключаетНДС, 0, СтрокаТабличнойЧасти.СуммаНДС);
	КонецЕсли;
	
КонецПроцедуры

// Пересчитывает стоимость с учетом изменений по НДС от 2018 г.
//
// Параметры:
//  СтоимостьТекущая - Число - Стоимость до пересчета
//  СтавкаНДСТекущая - Число - Текущая ставка НДС
//  СтавкаНДСНовая	 - Число - Новая ставка НДС
// 
// Возвращаемое значение:
//  Число - Стоимость после пересчета
//
Функция НоваяСтоимостьСУчетомИзмененийПоНДС2018(СтоимостьТекущая, СтавкаНДСТекущая, СтавкаНДСНовая) Экспорт
	
	СтавкаНДСРасчетная = СтавкаНДСТекущая + 100;
	
	СтоимостьНовая = (СтоимостьТекущая - (СтоимостьТекущая*СтавкаНДСТекущая/СтавкаНДСРасчетная)) + (СтоимостьТекущая - (СтоимостьТекущая*СтавкаНДСТекущая/СтавкаНДСРасчетная)) * СтавкаНДСНовая / 100;
	
	Возврат СтоимостьНовая;
	
КонецФункции

// Добавляет ключ связи в табличную часть.
//
// Параметры:
//  ФормаДокумента	 - ФормаКлиентскогоПриложения	 - Форма документа, реквизиты которой обрабатываются процедурой
//  Строка			 - ДанныеФормыСтруктура			 - Данные текущей строки таблицы формы
//
Процедура ДобавитьКлючСвязиВСтрокуТабличнойЧасти(ФормаДокумента, Строка = Неопределено) Экспорт
	
	Если Строка <> Неопределено Тогда
		СтрокаТабличнойЧасти = Строка;
	Иначе
		СтрокаТабличнойЧасти = ФормаДокумента.Элементы[ФормаДокумента.ИмяТабличнойЧасти].ТекущиеДанные;
	КонецЕсли;
	
	СтрокаТабличнойЧасти.КлючСвязи = ТабличныеЧастиУНФКлиентСервер.СоздатьНовыйКлючСвязи(ФормаДокумента);
	
КонецПроцедуры

// Добавляет ключ связи в подчиненную табличную часть.
//
// Параметры:
//  ФормаДокумента				 - ФормаКлиентскогоПриложения	 - Форма документа, реквизиты которой обрабатываются процедурой
//	ИмяПодчиненнойТабличнойЧасти - Строка						 - Имя подчиненной табличной части
//  Строка						 - ДанныеФормыСтруктура			 - Данные текущей строки таблицы формы
//
Процедура ДобавитьКлючСвязиВСтрокуПодчиненнойТабличнойЧасти(ФормаДокумента, ИмяПодчиненнойТабличнойЧасти, Строка = Неопределено) Экспорт
	
	ПодчиненнаяТабличнаяЧасть = ФормаДокумента.Элементы[ИмяПодчиненнойТабличнойЧасти];
	
	Если Строка = Неопределено Тогда
		СтрокаПодчиненнойТабличнойЧасти = ПодчиненнаяТабличнаяЧасть.ТекущиеДанные;
	Иначе
		СтрокаПодчиненнойТабличнойЧасти = Строка;
	КонецЕсли;
	СтрокаПодчиненнойТабличнойЧасти.КлючСвязи = ПодчиненнаяТабличнаяЧасть.ОтборСтрок["КлючСвязи"];
	
	СтрОтбора = Новый ФиксированнаяСтруктура("КлючСвязи", ПодчиненнаяТабличнаяЧасть.ОтборСтрок["КлючСвязи"]);
	ФормаДокумента.Элементы[ИмяПодчиненнойТабличнойЧасти].ОтборСтрок = СтрОтбора;

КонецПроцедуры

// Проверка выбора основной строки перед операциями с подчиненной ТЧ.
//
// Параметры:
//  ФормаДокумента				 - ФормаКлиентскогоПриложения	 - Форма документа, реквизиты которой обрабатываются процедурой
//	ИмяПодчиненнойТабличнойЧасти - Строка						 - Имя подчиненной табличной части
//
// Возвращаемое значение:
//  Булево - Истина, если строка не выбрана
//
Функция НеВыбранаСтрокаОсновнойТЧ(ФормаДокумента, ИмяПодчиненнойТабличнойЧасти) Экспорт

	Если ФормаДокумента.Элементы[ФормаДокумента.ИмяТабличнойЧасти].ТекущиеДанные = Неопределено Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не выбрана строка основной табличной части.'");
		Сообщение.Сообщить();
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
		
КонецФункции

// Удаляет строки из подчиненной табличной части.
//
// Параметры:
//  ФормаДокумента				 - ФормаКлиентскогоПриложения	 - Форма документа, реквизиты которой обрабатываются процедурой
//	ИмяПодчиненнойТабличнойЧасти - Строка						 - Имя подчиненной табличной части
//
Процедура УдалитьСтрокиПодчиненнойТабличнойЧасти(ФормаДокумента, ИмяПодчиненнойТабличнойЧасти, ОтменаСтроки = Ложь, СтрокаТабличнойЧасти = Неопределено) Экспорт
	
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		СтрокаТабличнойЧасти = ФормаДокумента.Элементы[ФормаДокумента.ИмяТабличнойЧасти].ТекущиеДанные;
	КонецЕсли;
	
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПодчиненнаяТабличнаяЧасть = ФормаДокумента.Объект[ИмяПодчиненнойТабличнойЧасти];
	
	РезультатПоиска = ПодчиненнаяТабличнаяЧасть.НайтиСтроки(Новый Структура("КлючСвязи", СтрокаТабличнойЧасти.КлючСвязи));
	Для каждого СтрокаПоиска Из  РезультатПоиска Цикл
		
		ИндексУдаления = ПодчиненнаяТабличнаяЧасть.Индекс(СтрокаПоиска);
		Если НЕ ОтменаСтроки Тогда
			ПодчиненнаяТабличнаяЧасть.Удалить(ИндексУдаления);
		Иначе
			СтрокаПоиска.Отменен = СтрокаТабличнойЧасти.Отменен;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Устанавливает отбор на подчиненную табличную часть.
//
// Параметры:
//  ФормаДокумента				 - ФормаКлиентскогоПриложения	 - Форма документа, реквизиты которой обрабатываются процедурой
//	ИмяПодчиненнойТабличнойЧасти - Строка						 - Имя подчиненной табличной части
//  Строка						 - ДанныеФормыСтруктура			 - Данные текущей строки таблицы формы
//
Процедура УстановитьОтборНаПодчиненнуюТабличнуюЧасть(ФормаДокумента, ИмяПодчиненнойТабличнойЧасти, Строка = Неопределено) Экспорт
	
	Если Строка <> Неопределено Тогда
		СтрокаТабличнойЧасти = Строка;
	Иначе
		СтрокаТабличнойЧасти = ФормаДокумента.Элементы[ФормаДокумента.ИмяТабличнойЧасти].ТекущиеДанные;
	КонецЕсли;
	
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	СтрОтбора = Новый ФиксированнаяСтруктура("КлючСвязи", СтрокаТабличнойЧасти.КлючСвязи);
	ФормаДокумента.Элементы[ИмяПодчиненнойТабличнойЧасти].ОтборСтрок = СтрОтбора;
	
КонецПроцедуры

#КонецОбласти


 

#Область ПрограммныйИнтерфейс

// Дополняет структуру параметров получения данных номенклатуры параметром Структурная единица для получения минимальной
// цены
//
// Параметры:
//  Объект - ДокументОбъект - Документ объект.
//  СтрокаНабора - СтрокаТабличнойЧасти - текущая строка табличной части объекта.
//  СтруктураДанные - Структура - содержит параметры вызова формы ЦеныИВалюта.
//  СкладВШапке - Булево - если Истина, то будет выбран склад из шапки. По умолчанию Неопределено;
//  ПрименитьОбщийВидЦен - Булево - если Истина, то будет подобрана структурная единица независимо от объекта. По
//                                  умолчанию Ложь;
//
Процедура ДополнитьСтруктуруДанныхНоменклатурыПолямиЦенообразования(Объект, СтрокаНабора, СтруктураДанные, СкладВШапке = Неопределено, ПрименитьОбщийВидЦен = Ложь) Экспорт
	
	Если СкладВШапке = Неопределено Тогда
		СкладВШапке = ОпределитьПоложениеСкладаВОбъекте(Объект);
	КонецЕсли;
		
	Если ПрименитьОбщийВидЦен Тогда 		
		ИмяРеквизита = "";   		
	Иначе     		
		ИмяРеквизита = ОпределитьИмяРеквизитаСкладаВОбъекте(Объект); 		
	КонецЕсли;	
	
	СтруктурнаяЕдиница = ПолучитьЗначениеСкладаВОбъекте(Объект, СтрокаНабора, ИмяРеквизита, СкладВШапке);	   	 	
	
	СтруктураДанные.Вставить("СтруктурнаяЕдиница", СтруктурнаяЕдиница);
	СтруктураДанные.Вставить("ЭтоНовыйОбъект", НЕ ЗначениеЗаполнено(Объект.Ссылка));
	
КонецПроцедуры

// Определяет положение реквизита склада в объекте
//
// Параметры:
//	Объект - ДокументОбъект - Документ объект.
//
// Возвращаемое значение:
//  Булево - Истина, реквизит склад-структурная единица в шапке, Ложь если в табличной части
//
Функция ОпределитьПоложениеСкладаВОбъекте(Объект) Экспорт
	
	СкладВШапке = Истина;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "ПоложениеСклада") Тогда
		СкладВШапке = Объект.ПоложениеСклада = ПредопределенноеЗначение("Перечисление.ПоложениеРеквизитаНаФорме.ВШапке");
	КонецЕсли;
	
	Возврат СкладВШапке;
	
КонецФункции

// Определяет имя реквизита склада в объекте
//
// Параметры:
//	Объект - ДокументОбъект - Документ объект.
//
// Возвращаемое значение:
//  Строка - Имя реквизита склада-структурной
//
Функция ОпределитьИмяРеквизитаСкладаВОбъекте(Объект) Экспорт
	
	ИмяРеквизита = "";
	ВозможныеИменаРеквизитов = Новый Массив;
	ВозможныеИменаРеквизитов.Добавить("СтруктурнаяЕдиница");
	ВозможныеИменаРеквизитов.Добавить("СтруктурнаяЕдиницаРезерв");
	ВозможныеИменаРеквизитов.Добавить("ТорговыйОбъект");
	
	Для каждого ТекИмяРеквизита Из ВозможныеИменаРеквизитов Цикл
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, ТекИмяРеквизита) Тогда
			ИмяРеквизита = ТекИмяРеквизита;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ИмяРеквизита;
	
КонецФункции

// Определяет имя реквизита склада в объекте
//
// Параметры:
//	Объект - ДокументОбъект - Документ объект.
//  СтрокаНабора - СтрокаТабличнойЧасти - текущая строка табличной части объекта.
//	ИмяРеквизита - Строка - Имя реквизита склада в объекте или строке набора
//	СкладВШапке - Булево - Признак безусловного определения положения склада в шапке
//
// Возвращаемое значение:
//  СправочникСсылка.СтруктурныеЕдиницы - ссылка на структурную единицу объекта или строки табличной части
//
Функция ПолучитьЗначениеСкладаВОбъекте(Объект, СтрокаНабора, ИмяРеквизита, СкладВШапке) Экспорт
	
	СтруктурнаяЕдиница = Неопределено;  	
	
	Если ЗначениеЗаполнено(ИмяРеквизита) Тогда
		
		Если СкладВШапке Тогда
			
			СтруктурнаяЕдиница = Объект[ИмяРеквизита];
			
		Иначе
			Если НЕ СтрокаНабора = Неопределено 
				И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаНабора, ИмяРеквизита) Тогда	
				
				СтруктурнаяЕдиница = СтрокаНабора[ИмяРеквизита];
		
			КонецЕсли;		
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтруктурнаяЕдиница;
	
КонецФункции

// Пересчитывает строку табличной части по минимальным ценам, в конце расчета в структуру будет добавлен
// параметр "СообщениеПользователю", который позже будет отображен пользователю. 
//
// Параметры:
//	СтрокаТабличнойЧасти - СтрокаТабличнойЧасти - строка табличной части
//  КоличествоСтроки - Число - количество из строки табличной части
//	ПараметрыРасчета - Структура:
//		* ИспользоватьМинимальныеЦены - Булево - признак использования минимальных цен
//		* РассчитатьСуммуСкидки - Булево - признак расчета суммы скидки
//		* РассчитатьПроцентСкидки - Булево - признак расчета процента скидки
//
Процедура ПересчитатьСтрокуТЧПоМинимальнымЦенам(СтрокаТабличнойЧасти, КоличествоСтроки, ПараметрыРасчета) Экспорт
	
	ИспользоватьМинимальныеЦены = ПараметрыРасчета.Свойство("ИспользоватьМинимальныеЦены") 
		И ПараметрыРасчета.ИспользоватьМинимальныеЦены
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТабличнойЧасти, "МинимальнаяЦена") 
		И ЗначениеЗаполнено(СтрокаТабличнойЧасти.МинимальнаяЦена);
	
	ИзменитьСкидки = (ПараметрыРасчета.Свойство("РассчитатьСуммуСкидки") 
		И ПараметрыРасчета.РассчитатьСуммуСкидки
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТабличнойЧасти, "СуммаСкидкиНаценки"))
		ИЛИ (ПараметрыРасчета.Свойство("РассчитатьПроцентСкидки") 
		И ПараметрыРасчета.РассчитатьПроцентСкидки
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаТабличнойЧасти, "ПроцентСкидкиНаценки"));
		
	Если ИспользоватьМинимальныеЦены И ИзменитьСкидки Тогда
			
		МинимальнаяСумма = КоличествоСтроки * СтрокаТабличнойЧасти.МинимальнаяЦена;
		СуммаПоСтроке = КоличествоСтроки * СтрокаТабличнойЧасти.Цена;
		
		Если СтрокаТабличнойЧасти.Сумма < МинимальнаяСумма Тогда
			
			СуммаСкидкиНаценкиДоИзменения = СтрокаТабличнойЧасти.СуммаСкидкиНаценки;
			СтрокаТабличнойЧасти.СуммаСкидкиНаценки = Макс(СуммаПоСтроке - МинимальнаяСумма, 0);
			
			ЦенаДелитель = ?(СтрокаТабличнойЧасти.Цена = 0, 
					СтрокаТабличнойЧасти.МинимальнаяЦена, 
					СтрокаТабличнойЧасти.Цена);
			
			СтрокаТабличнойЧасти.ПроцентСкидкиНаценки = Окр(100*СтрокаТабличнойЧасти.СуммаСкидкиНаценки 
						/ (КоличествоСтроки * ЦенаДелитель), 2);
			
			СтрокаТабличнойЧасти.Сумма = КоличествоСтроки * СтрокаТабличнойЧасти.Цена - СтрокаТабличнойЧасти.СуммаСкидкиНаценки;
			
			Если СуммаСкидкиНаценкиДоИзменения > СтрокаТабличнойЧасти.СуммаСкидкиНаценки 
				И СтрокаТабличнойЧасти.Цена >= СтрокаТабличнойЧасти.МинимальнаяЦена Тогда
				
				ПараметрыРасчета.Вставить("СообщениеПользователю", НСтр("ru = 'Размер и сумма скидки были изменены по минимальной цене'"));
				
			КонецЕсли;
			
		КонецЕсли;
			
	КонецЕсли;
		
КонецПроцедуры

// Возвращает строку для описания способа округления цен, в строку подставляются от 2 до 4 параметров
//
// Параметры:
//	СтруктураВидаЦен - Структура:
//  	* ПервыйПараметр - Строка - первый параметр для подстановки
//  	* ВторойПараметр - Строка - второй параметр для подстановки
//  	* ПорядокОкругления - Число - значение порядка округления
//  	* ПсихологическоеОкругление - Число - значение психологического округления
//
// Возвращаемое значение:
//  Строка - результирующая строка
//
Функция ПолучитьКраткоеОписаниеСпособаОкругленияВидаЦены(СтруктураВидаЦен) Экспорт

	ИспользоватьРасширеннуюНастройкуОкругления = СтруктураВидаЦен.ИспользоватьРасширеннуюНастройкуОкругления;
	
	ПервыйПараметр 				= СтруктураВидаЦен.ПервыйПараметр;
	ВторойПараметр 				= СтруктураВидаЦен.ВторойПараметр;
	ПорядокОкругления 			= СтруктураВидаЦен.ПорядокОкругления;
	ПсихологическоеОкругление 	= СтруктураВидаЦен.ПсихологическоеОкругление;
	
	Если ИспользоватьРасширеннуюНастройкуОкругления Тогда                                                                       
		
		Результат = СтрШаблон(НСтр("ru ='Округление: %1 по правилам %2'"), ПервыйПараметр, ВторойПараметр); 
		
	Иначе
		
		ТретийПараметр = ПорядокОкругления;
		ЧетвертыйПараметр = ?(ЗначениеЗаполнено(ПсихологическоеОкругление), 
			СтрШаблон(" %1 ", НСтр("ru='и вычитать'")) + ПсихологическоеОкругление,
			"");
		Результат = СтрШаблон(НСтр("ru ='Округление: %1 по правилам %2 с точностью %3%4'"), ПервыйПараметр, ВторойПараметр, ТретийПараметр, ЧетвертыйПараметр); 
		
	КонецЕсли; 
	
	Возврат Результат;
	
КонецФункции

// Применяет "психологическое округление" к числу.
//
// Параметры:
//  Число                     - Число - к которому применяется округление.
//  ПсихологическоеОкругление - Число - значение "психологического округления".
//
// Возвращаемое значение:
//  Число - результат применения "психологического округления" к числу.
//
Функция ПрименитьПсихологическоеОкругление(Число, ПсихологическоеОкругление) Экспорт
	
	Если Число = 0 ИЛИ ПсихологическоеОкругление = 0 Тогда
		Возврат Число;
	Иначе
		РезультатОкругления = Число - ПсихологическоеОкругление;
		Возврат ?(РезультатОкругления < Число, РезультатОкругления, Число);
	КонецЕсли;
		
КонецФункции

// Процедура - Выбрать поля надписи видов цен для возвратов
//
// Параметры:
//  Результат	 - Структура - см. ЦеныИВалютаКлиентСервер.ПоляНадписи
//  Объект		 - ДанныеФормыСтруктура - данные формы структура объекта документа
//
Процедура ВыбратьПоляНадписиВидовЦенДляВозвратов(Результат, Знач Объект) Экспорт
	
	ЭтоПриходнаяНакладная = ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.ПриходнаяНакладная");
	ЭтоРасходнаяНакладная = ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.РасходнаяНакладная");
	
	Если ЭтоПриходнаяНакладная Тогда
		
		Результат.ВидЦен = Объект.ВидЦенВозврата;
		
		НовыйСпособВидовЦенДляВозвратовИспользуется = ЦенообразованиеВызовСервера.НовыйСпособВидовЦенДляВозвратовИспользуется();
		
		ОчиститьПоляВидовЦенПоПриходнойНакладной(Результат, Объект, НовыйСпособВидовЦенДляВозвратовИспользуется);
		
	КонецЕсли;
	
	Если ЭтоРасходнаяНакладная Тогда
		
		Результат.ВидЦенКонтрагента = Объект.ВидЦенВозврата;
		
		НовыйСпособВидовЦенДляВозвратовИспользуется = ЦенообразованиеВызовСервера.НовыйСпособВидовЦенДляВозвратовИспользуется();
		
		ОчиститьПоляВидовЦенПоРасходнойНакладной(Результат, Объект, НовыйСпособВидовЦенДляВозвратовИспользуется);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - Заполнить поля вида цен возврата
//
// Параметры:
//  СтруктураПолучения	 - Структура - см. ЦеныИВалютаКлиентСервер.НовыеПараметрыФормыЦеныИВалюта
//  Объект				 - ДанныеФормыСтруктура - данные формы структура объекта документа
//
Процедура ЗаполнитьПоляВидаЦенВозврата(СтруктураПолучения, Знач Объект) Экспорт
	
	Если ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.ПриходнаяНакладная") Тогда
		
		ИмяПоля = "ВидЦен";
		ИмяПоляКонтроля = "ВидЦенЕстьРеквизит";
		
	ИначеЕсли ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.РасходнаяНакладная") Тогда
		
		ИмяПоля = "ВидЦенКонтрагента";
		ИмяПоляКонтроля = "ВидЦенКонтрагентаЕстьРеквизит";
		
	Иначе
		
		Возврат;
		
	КонецЕсли;
	
	СтруктураПолучения[ИмяПоля] = Объект.ВидЦенВозврата;
	СтруктураПолучения[ИмяПоляКонтроля] = Истина;
	СтруктураПолучения.ИзменятьВидимостьВидовЦенВозвратов = Истина;
	
КонецПроцедуры

// Процедура - Выбрать вид цен для документа возврата
//
// Параметры:
//  ПараметрыФормыЦеныИВалюта	 - Структура - см. ЦеныИВалютаКлиентСервер.НовыеПараметрыФормыЦеныИВалюта
//  НовыйСпособВидовЦенДляВозвратовИспользуется - Булево - признак использования нового способа вида цен для возвратов
//
Процедура ИзменитьПараметрыФормыЦеныИВалютыДляВозвратов(ПараметрыФормыЦеныИВалюта, Знач НовыйСпособВидовЦенДляВозвратовИспользуется) Экспорт
	
	Если ПараметрыФормыЦеныИВалюта.ИзменятьВидимостьВидовЦенВозвратов Тогда
		
		Если ПараметрыФормыЦеныИВалюта.ТипОбъектаВладельца = "ПриходнаяНакладная" Тогда
			
			Если ПараметрыФормыЦеныИВалюта.ЭтоВозврат Тогда
				
				ПараметрыФормыЦеныИВалюта.ВидЦенКонтрагентаЕстьРеквизит = НЕ НовыйСпособВидовЦенДляВозвратовИспользуется;
				ПараметрыФормыЦеныИВалюта.ВидЦенЕстьРеквизит = НовыйСпособВидовЦенДляВозвратовИспользуется;
				
			Иначе
				
				ПараметрыФормыЦеныИВалюта.ВидЦенКонтрагентаЕстьРеквизит = Истина;
				ПараметрыФормыЦеныИВалюта.ВидЦенЕстьРеквизит = Ложь;
				
			КонецЕсли;
				
			ПараметрыФормыЦеныИВалюта.РегистрироватьЦеныПоставщикаЕстьРеквизит = НЕ ПараметрыФормыЦеныИВалюта.ЭтоВозврат;
			
		КонецЕсли;
		
		Если ПараметрыФормыЦеныИВалюта.ТипОбъектаВладельца = "РасходнаяНакладная" Тогда
			
			Если ПараметрыФормыЦеныИВалюта.ЭтоВозврат Тогда
				
				ПараметрыФормыЦеныИВалюта.ВидЦенКонтрагентаЕстьРеквизит = НовыйСпособВидовЦенДляВозвратовИспользуется;
				ПараметрыФормыЦеныИВалюта.ВидЦенЕстьРеквизит = НЕ НовыйСпособВидовЦенДляВозвратовИспользуется;
				
			Иначе
				
				ПараметрыФормыЦеныИВалюта.ВидЦенКонтрагентаЕстьРеквизит = Ложь;
				ПараметрыФормыЦеныИВалюта.ВидЦенЕстьРеквизит = Истина;
				
			КонецЕсли;
			
			ПараметрыФормыЦеныИВалюта.РегистрироватьЦеныПоставщикаЕстьРеквизит = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Округляет число по заданному порядку.
//
// Параметры:
//  Число        - Число - которое необходимо округлить
//  ПравилоОкругления - ПеречислениеСсылка.ПорядкиОкругления - порядок округления
//  ОкруглятьВБольшуюСторону - Булево - округления в большую сторону.
//
// Возвращаемое значение:
//  Число        - результат округления.
//
Функция ОкруглитьЦену(Число, ПравилоОкругления, ОкруглятьВБольшуюСторону) Экспорт
	
	Перем Результат; // Возвращаемый результат.
	
	// Преобразуем порядок округления числа.
	// Если передали пустое значение порядка, то округлим до копеек. 
	Если НЕ ЗначениеЗаполнено(ПравилоОкругления) Тогда
		ПорядокОкругления = ПредопределенноеЗначение("Перечисление.ПорядкиОкругления.Окр0_01"); 
	Иначе
		ПорядокОкругления = ПравилоОкругления;
	КонецЕсли;
	Порядок = Число(Строка(ПорядокОкругления));
	
	// вычислим количество интервалов, входящих в число
	КоличествоИнтервал	= Число / Порядок;
	
	// вычислим целое количество интервалов.
	КоличествоЦелыхИнтервалов = Цел(КоличествоИнтервал);
	
	Если КоличествоИнтервал = КоличествоЦелыхИнтервалов Тогда
		
		// Числа поделились нацело. Округлять не нужно.
		Результат	= Число;
	Иначе
		Если ОкруглятьВБольшуюСторону Тогда
			
			// При порядке округления "0.05" 0.371 должно округлиться до 0.4
			Результат = Порядок * (КоличествоЦелыхИнтервалов + 1);
		Иначе
			
			// При порядке округления "0.05" 0.371 должно округлиться до 0.35,
			// а 0.376 до 0.4
			Результат = Порядок * Окр(КоличествоИнтервал, 0, РежимОкругления.Окр15как20);
		КонецЕсли; 
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции // ОкруглитьЦену()
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОчиститьПоляВидовЦенПоПриходнойНакладной(Результат, Знач Объект, Знач НовыйСпособВидовЦенДляВозвратовИспользуется)
	
	ЭтоВозврат = (Объект.ВидОперации 
		= ПредопределенноеЗначение("Перечисление.ВидыОперацийПриходнаяНакладная.ВозвратОтПокупателя"));
		
	Если НовыйСпособВидовЦенДляВозвратовИспользуется Тогда
		
		Если ЭтоВозврат Тогда
			
			Результат.ВидЦенКонтрагента = ПредопределенноеЗначение("Справочник.ВидыЦенКонтрагентов.ПустаяСсылка");
			
		Иначе
			
			Результат.ВидЦен = ПредопределенноеЗначение("Справочник.ВидыЦен.ПустаяСсылка");
			
		КонецЕсли;
		
	Иначе
		
		Результат.ВидЦен = ПредопределенноеЗначение("Справочник.ВидыЦен.ПустаяСсылка");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьПоляВидовЦенПоРасходнойНакладной(Результат, Знач Объект, Знач НовыйСпособВидовЦенДляВозвратовИспользуется)
	
	ЭтоВозврат = (Объект.ВидОперации 
		= ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходнаяНакладная.ВозвратПоставщику"));
		
	Если НовыйСпособВидовЦенДляВозвратовИспользуется Тогда
		
		Если ЭтоВозврат Тогда
			
			Результат.ВидЦен = ПредопределенноеЗначение("Справочник.ВидыЦен.ПустаяСсылка");
			
		Иначе
			
			Результат.ВидЦенКонтрагента = ПредопределенноеЗначение("Справочник.ВидыЦенКонтрагентов.ПустаяСсылка");
			
		КонецЕсли;
		
	Иначе
		
		Результат.ВидЦенКонтрагента = ПредопределенноеЗначение("Справочник.ВидыЦенКонтрагентов.ПустаяСсылка");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
#Область ПрограммныйИнтерфейс

// Возвращает данные выбора справочника виды цен
// 
// Параметры:
//  Текст - Строка - строка, содержащая данные автоподбора
//  ПараметрыПолученияДанных - Структура - параметры данных выбора  
// Возвращаемое значение:
//  - ДанныеВыбора - Список значений данных выбора автоподбора
//
Функция ВидЦеныАвтоПодборДанныеВыбора(Текст, ПараметрыПолученияДанных) Экспорт
	    
    Возврат ПолучитьДанныеВыбора(Тип("СправочникСсылка.ВидыЦен"), ПараметрыПолученияДанных);	
	
КонецФункции

// Функция - Виды цен для продажи для возвратов используются
// 
// Возвращаемое значение:
//  Булево - признак использования цен продажи для возвратов
//
Функция НовыйСпособВидовЦенДляВозвратовИспользуется() Экспорт
	
	ИспользуютсяЦеныПродаж = ЦенообразованиеСерверПовтИсп.ПолучитьСпособИспользованияВидовЦенДляВозвратов()
		= Перечисления.СпособыИспользованияВидовЦенДляВозвратов.НовыйСпособ;
		
	НастройкаДляНовыхПользователей = ЦенообразованиеСерверПовтИсп.ПолучитьСпособИспользованияВидовЦенДляВозвратов()
		= Перечисления.СпособыИспользованияВидовЦенДляВозвратов.ДляНовыхПользователей;
		
	Возврат ИспользуютсяЦеныПродаж ИЛИ НастройкаДляНовыхПользователей;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

 // Проверяет заполненность обязательных параметров схемы компоновки данных
//
// Параметры:
//  ВыбранныеЦены - Ссылка на вид цены, для которого нужно получить адрес настроек компоновки данных
//  АдресХранилищаНастройкиКомпоновкиДанных - Адрес с настройками компоновки данных для вида цены
//  АдресХранилищаПараметровСхемКомпоновкиПоВидамЦен - Адрес с настройками параметров настроек компоновки данных для
//                                                     всех видов цен.
//
// Возвращаемое значение:
//  Массив описаний ошибок - Найденные ошибки.
//
Функция ПроверитьЗаполненностьОбязательныхПараметровСхемыКомпоновкиДанных(ВыбранныеЦены) Экспорт
	
	Ошибки = Новый Массив;
	
	Для Каждого ВидЦен Из ВыбранныеЦены Цикл

		ПараметрыСхемыКомпоновкиДанных = ПолучитьИзВременногоХранилища(ВидЦен.АдресНастроекСхемыКомпоновкиДанных);
		Если ПараметрыСхемыКомпоновкиДанных <> Неопределено Тогда
			
			ПроверкаВыполнена = Ложь;	
			Для каждого ПараметрДанных Из ПараметрыСхемыКомпоновкиДанных.ПараметрыДанных.Элементы Цикл
				
				Если НЕ ЗначениеЗаполнено(ПараметрДанных.Значение)
					И ПараметрДанных.Использование Тогда 
					
					Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Не заполнено значение параметра ""%1"" для вида цены ""%2""'"),
						Строка(ПараметрДанных.Параметр),
						Строка(ВидЦен.ВидЦен));
					Ошибки.Добавить(Новый Структура("ВидЦены, Описание", ВидЦен, Описание)); 
						
				КонецЕсли;
				ПроверкаВыполнена = Истина;
				Прервать;
				
			КонецЦикла;			
						
		КонецЕсли;

	КонецЦикла;
	
	Возврат Ошибки;
	
КонецФункции

#КонецОбласти

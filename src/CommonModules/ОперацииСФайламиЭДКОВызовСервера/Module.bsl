////////////////////////////////////////////////////////////////////////////////
// Подсистема "Операции с файлами".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Сохраняет текст в файл на сервере и помещает его во временное хранилище.
//
// Параметры:
//  Текст                 - Строка - текст, которую необходимо записать в файл.
//
//  ИмяФайлаИлиРасширение - Строка - адрес во временном хранилище, 
//                                   по которому необходимо сохранить файл с текстом.
//
// Возвращаемое значение:
// 	Адрес - адрес во временном хранилище, по которому сохранен файл с текстом.
//
Функция ТекстВФайл(Текст, Адрес = Неопределено) Экспорт
	
	ИмяФайла = ПолучитьИмяВременногоФайла("txt");
	
	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайла);
	ЗаписьТекста.Записать(Текст);
	ЗаписьТекста.Закрыть();
	
	Данные = Новый ДвоичныеДанные(ИмяФайла);
	УдалитьФайлы(ИмяФайла);
	
	Возврат ПоместитьВоВременноеХранилище(Данные, Адрес);
	
КонецФункции

// Упаковывает файлы на сервере и помещает архив во временное хранилище.
//
// Параметры:
//  Файлы - Массив - информация о файлах, которые необходимо упаковать.
//    * Адрес - Строка - адрес файла во временном хранилище.
//    * Имя   - Строка - имя файла.
//
//  АдресПакета - Строка - адрес во временном хранилище,
//                         в который необходимо поместить созданный архив.
//                         
// Возвращаемое значение:
// 	Адрес - адрес во временном хранилище, по которому сохранен файл архива.
//
Функция УпаковатьФайлы(Файлы, АдресПакета = Неопределено) Экспорт
	
	ВременныйКаталог = КаталогВременныхФайлов() + СтрЗаменить(Новый УникальныйИдентификатор, "-", "") + ПолучитьРазделительПути();
	СоздатьКаталог(ВременныйКаталог);
	
	ИмяФайлаПакета = ПолучитьИмяВременногоФайла("zip");
	ЗаписьZip = Новый ЗаписьZipФайла(ИмяФайлаПакета);
	
	Для Каждого Файл Из Файлы Цикл
		ИмяВложенногоФайла = ВременныйКаталог + Файл.Имя;
		Если Файл.Свойство("Данные") Тогда
			Файл.Данные.Записать(ИмяВложенногоФайла);
		Иначе
			ПолучитьИзВременногоХранилища(Файл.Адрес).Записать(ИмяВложенногоФайла);
		КонецЕсли;
		
		ЗаписьZip.Добавить(ИмяВложенногоФайла);
	КонецЦикла;
	
	ЗаписьZip.Записать();
	
	НовыйАдресПакета = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ИмяФайлаПакета), АдресПакета);
	
	УдалитьФайлы(ВременныйКаталог);
	УдалитьФайлы(ИмяФайлаПакета);
	
	Возврат НовыйАдресПакета;
	
КонецФункции

#Область ОбработкаКартинок

Функция РасширенияПоФорматам(Форматы) Экспорт
	
	Соотвествия = ОперацииСФайламиЭДКО.СоотвествиеРасширенийКартинокФорматам();
	
	Результат = Новый Массив;
	Для каждого Формат Из Форматы Цикл
		
		ЭтоРасширение = ТипЗнч(Формат) = Тип("Строка");
		
		Если ЭтоРасширение Тогда
			НовоеРасширение = Формат;
			ДобавитьРасширение(Результат, НовоеРасширение);
		Иначе
			Для каждого Соотвествие Из Соотвествия Цикл
				Если Формат = Соотвествие.Значение Тогда
					НовоеРасширение = Соотвествие.Ключ; 
					ДобавитьРасширение(Результат, НовоеРасширение);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла; 
	
	Возврат Результат;
	
КонецФункции

Процедура ДобавитьРасширение(Расширения, НовоеРасширение)
	
	НовоеРасширение = ВРЕГ(НовоеРасширение);
	
	Если Расширения.Найти(НовоеРасширение) = Неопределено Тогда
		Расширения.Добавить(НовоеРасширение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
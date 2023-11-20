
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ПараметрыКонтекст = Неопределено;
	Если ТипЗнч( ПараметрыВыполненияКоманды.Источник ) = Тип( "ФормаКлиентскогоПриложения" ) Тогда
		ПараметрыКонтекст = Новый Структура( "ФормаУникальныйИдентификатор", ПараметрыВыполненияКоманды.Источник.УникальныйИдентификатор );
	КонецЕсли;
	
	ФайлыОбменаДляОтправки = ИнтеграцияСИнтернетМагазиномВызовСервера.ПолучитьФайлыОбмена(
	ПараметрКоманды,
	Ложь,
	ПараметрыКонтекст
	);
	
	Если ФайлыОбменаДляОтправки.Количество() = 0 Тогда
		ПоказатьОповещение("Файлы обмена не обнаружены");
		Возврат;
	КонецЕсли;
	
	ТекстЗаголовок = СтрШаблон("Запись файлов обмена (%1)", ФайлыОбменаДляОтправки.Количество());
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗаписьФайлаЗавершение", ЭтотОбъект);
	
	ФайловаяСистемаКлиент.СохранитьФайлы(ОписаниеОповещения, ФайлыОбменаДляОтправки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаписьФайлаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Или Результат.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Файл = Новый Файл(Результат[0].ПолноеИмя);
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ПутьДоКаталога", Файл.Путь);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьКаталогПриНажатии", ЭтотОбъект, ПараметрыОповещения);
	
	ПоказатьОповещение("Запись файлов обмена заверешна",
	ПараметрыОповещения.ПутьДоКаталога,
	БиблиотекаКартинок.ВыполненоУспешно,
	ОписаниеОповещения
	);
	
	Для Каждого Стр Из Результат Цикл
		УдалитьИзВременногоХранилища(Стр.Хранение);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталогПриНажатии(ДополнительныеПараметры) Экспорт
	
	ФайловаяСистемаКлиент.ОткрытьПроводник(ДополнительныеПараметры.ПутьДоКаталога);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОповещение(ТекстЗаголовок, ТекстПояснение = "", КартинкаОповещения = Неопределено, ДействиеПриНажатии = Неопределено)
	
	Если КартинкаОповещения = Неопределено Тогда
		КартинкаОповещения = БиблиотекаКартинок.ОжидаемаяДлительнаяОперация48;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(ТекстЗаголовок,
	ДействиеПриНажатии,
	ТекстПояснение,
	КартинкаОповещения,
	СтатусОповещенияПользователя.Информация
	);
	
КонецПроцедуры

#КонецОбласти

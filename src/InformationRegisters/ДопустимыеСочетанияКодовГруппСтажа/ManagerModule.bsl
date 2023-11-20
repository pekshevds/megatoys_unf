#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура НачальноеЗаполнение() Экспорт
	
	Если ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПравилаПроверкиСочетанийСтажа();
	
КонецПроцедуры

Процедура ЗаполнитьПравилаПроверкиСочетанийСтажа()
	
	Если ОбменДаннымиСервер.ЭтоАвтономноеРабочееМесто() Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
	
	Для Каждого СтрокаТаблицыСочетаний Из СочетанияГруппСтажа() Цикл
		ЗаписьСочетания = НаборЗаписей.Добавить();
		
		ЗаписьСочетания.НомерПравила = СокрЛП(СтрокаТаблицыСочетаний.НомерПравила);
		ЗаписьСочетания.КодУсловийТруда = СокрЛП(СтрокаТаблицыСочетаний.КодУсловийТруда);
		ЗаписьСочетания.КодПозицииСписка = СокрЛП(СтрокаТаблицыСочетаний.КодПозицииСписка);
		ЗаписьСочетания.КодОснованияИсчисляемогоСтажа = СокрЛП(СтрокаТаблицыСочетаний.КодОснованияИсчисляемогоСтажа);
		ЗаписьСочетания.ФорматФОВ = СокрЛП(СтрокаТаблицыСочетаний.ФорматФОВ);
		ЗаписьСочетания.КодОснованияВыслугиЛет = СокрЛП(СтрокаТаблицыСочетаний.КодОснованияВыслугиЛет);
		ЗаписьСочетания.ТипШаблонаКПС = СокрЛП(СтрокаТаблицыСочетаний.ТипШаблонаКПС);
		
		ЗаписьСочетания.ПериодС = Число(СтрокаТаблицыСочетаний.ПериодС);
		ЗаписьСочетания.ПериодПо = Число(СтрокаТаблицыСочетаний.ПериодПо);
		
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Функция СочетанияГруппСтажа()
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	
	Макет = ПолучитьМакет("СочетанияГруппСтажа");
	Макет.Записать(ИмяВременногоФайла);
	
	СочетанияГруппСтажа = ЗначениеИзФайла(ИмяВременногоФайла);
	
	Попытка
		УдалитьФайлы(ИмяВременногоФайла);
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Допустимые сочетания кодов групп стажа.Заполнение правил проверки'", ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка, , , 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Возврат СочетанияГруппСтажа
	
КонецФункции

#КонецОбласти

#КонецЕсли
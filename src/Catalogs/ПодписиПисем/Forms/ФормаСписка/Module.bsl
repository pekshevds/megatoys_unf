
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьСписокПодписейНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСписокПодписейНаСервере()
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь(Пользователи.ТекущийПользователь()) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
		"ВладелецПодписи", Пользователи.ТекущийПользователь(), , , Истина);
		
		Элементы.ВладелецПодписи.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИспользоватьКакОсновнуюНаСервере(СтруктураПараметров)
	
	НЗ = РегистрыСведений.ОсновныеПодписиПисем.СоздатьНаборЗаписей();
	НЗ.Отбор.Пользователь.Установить(СтруктураПараметров.Пользователь);
	Запись = НЗ.Добавить();
	Запись.Пользователь = СтруктураПараметров.Пользователь;
	Запись.УчетнаяЗапись = СтруктураПараметров.УчетнаяЗапись;
	Запись.Подпись = СтруктураПараметров.Подпись;
	
	НЗ.Записать();
	
	Если ЗначениеЗаполнено(СтруктураПараметров.Подпись) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПодписиПисем.Ссылка КАК Ссылка,
		|	ПодписиПисем.ВключатьПодписьДляНовыхСообщений КАК ВключатьПодписьДляНовыхСообщений,
		|	ПодписиПисем.ВключатьПодписьПриОтветеИлиПересылке КАК ВключатьПодписьПриОтветеИлиПересылке
		|ИЗ
		|	Справочник.ПодписиПисем КАК ПодписиПисем
		|ГДЕ
		|	ПодписиПисем.Ссылка = &Ссылка
		|	И (НЕ ПодписиПисем.ВключатьПодписьДляНовыхСообщений
		|			ИЛИ НЕ ПодписиПисем.ВключатьПодписьПриОтветеИлиПересылке)";
		
		Запрос.УстановитьПараметр("Ссылка", СтруктураПараметров.Подпись);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			ВыбраннаяПодпись = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
			ВыбраннаяПодпись.Заблокировать();
			ВыбраннаяПодпись.ВключатьПодписьДляНовыхСообщений = Истина;
			ВыбраннаяПодпись.ВключатьПодписьПриОтветеИлиПересылке = Истина;
			ВыбраннаяПодпись.Записать();
			ВыбраннаяПодпись.Разблокировать();
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьКакОсновную(Команда)
	
	Если НЕ КомандаИспользоватьКакОсновнуюДоступна() Тогда
		Возврат;
	КонецЕсли;
	
	НовыйОсновнаяПодпись = Элементы.Список.ТекущиеДанные.Ссылка;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Пользователь", Элементы.Список.ТекущиеДанные.ВладелецПодписи);
	СтруктураПараметров.Вставить("УчетнаяЗапись", Элементы.Список.ТекущиеДанные.УчетнаяЗапись);
	СтруктураПараметров.Вставить("Подпись", НовыйОсновнаяПодпись);
	
	ИспользоватьКакОсновнуюНаСервере(СтруктураПараметров);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Функция КомандаИспользоватьКакОсновнуюДоступна()
	
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка")
		Или Элементы.Список.ТекущиеДанные = Неопределено
		//Или Элементы.Список.ТекущиеДанные.ЭтоОсновная
		Или Элементы.Список.ТекущиеДанные.ПометкаУдаления Тогда
		
		Возврат Ложь;
		
	КонецЕсли;

	Возврат Истина;
	
КонецФункции

#КонецОбласти

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	                                                           
	ОбменСГИСЭПД.ПриСозданииНаСервереПодчиненнойФормы(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
		
	ОбменСГИСЭПДКлиент.СохранитьПараметрыПодчиненнойФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбменСГИСЭПДКлиент.ПриОткрытииПодчиненнойФормы(ЭтотОбъект);
																		
КонецПроцедуры
			
&НаКлиенте
Функция ОписаниеРеквизитовФормы() Экспорт
	
	Возврат ОписаниеРеквизитовФормыСервер();
	
КонецФункции

&НаСервере
Функция ОписаниеРеквизитовФормыСервер()
	
	Возврат ОбменСГИСЭПД.ОписаниеРеквизитовФормы(ЭтаФорма);
		
КонецФункции

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ДобавлениеПоляВвода(Команда)
	
	ИмяТаблицыИПоля = СтрЗаменить(Команда.Имя, "ДобавлениеПоляВвода", "");
	МассивЧастей = ОбменСГИСЭПДКлиентСервер.РазделитьСтрокуСоСложнымРазделителем(ИмяТаблицыИПоля, "__");
	
	ДобавлениеПоляВводаСервер(МассивЧастей[0], МассивЧастей[1]);
	
КонецПроцедуры

&НаСервере
Процедура ДобавлениеПоляВводаСервер(ИмяТаблицы, ИмяПоля)
	
	ОбменСГИСЭПД.СоздатьЭлементыВводаЗначенийСписка(ЭтотОбъект, ИмяТаблицы, ИмяПоля, Истина);
	
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ПолеЗначенияСпискаИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	МассивЧастей = ОбменСГИСЭПДКлиентСервер.РазделитьСтрокуСоСложнымРазделителем(Элемент.Имя, "__");	
	УстановитьФорматированноеЗначениеПоляВвода(МассивЧастей[0], МассивЧастей[1], Число(МассивЧастей[2]), Текст);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФорматированноеЗначениеПоляВвода(ИмяТаблицы, ИмяПоля, НомерСтроки, Текст)
	
	ТекущиеДанные = ЭтотОбъект[ИмяТаблицы][НомерСтроки];	 
	ОбменСГИСЭПД.УстановитьФорматированноеЗначениеПоляВвода(ЭтотОбъект, ТекущиеДанные, ИмяПоля, Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура ТитулПеревозчикаОснованияВладенияПрицепомПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ИдентификаторСтроки = Неопределено;
		ТекущиеДанные.Свойство("ИдентификаторСтроки", ИдентификаторСтроки);
		ОбменСГИСЭПДКлиент.ОчиститьПодчиненныеТаблицы(ЭтотОбъект, Элемент.Имя, ИдентификаторСтроки, Отказ);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТитулПеревозчикаОснованияВладенияПрицепомРеквизитыСторонНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбменСГИСЭПДКлиент.ВывестиФормуВводаДанных(ЭтотОбъект, Элемент.Имя, Элементы.ТитулПеревозчикаОснованияВладенияПрицепом.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ТитулПеревозчикаОснованияВладенияПрицепомВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если Поле.Имя = "ЗаполнитьТитулПеревозчикаОснованияВладенияПрицепомРеквизитыСторон" Тогда
		ОбменСГИСЭПДКлиент.ВывестиФормуВводаДанных(ЭтотОбъект, Поле.Имя, Элемент.ТекущиеДанные);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТитулПеревозчикаОснованияВладенияПрицепомПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	ОбменСГИСЭПДКлиент.ТаблицаПриНачалеРедактирования(Элемент, ЭтотОбъект, НоваяСтрока, Копирование);

	ТекущиеДанные = Элемент.ТекущиеДанные;
	ТекущиеДанные.ЗаполнитьТитулПеревозчикаОснованияВладенияПрицепомРеквизитыСторон = "Заполнить";

КонецПроцедуры
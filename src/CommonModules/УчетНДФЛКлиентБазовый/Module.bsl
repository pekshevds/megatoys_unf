
#Область СлужебныйПрограммныйИнтерфейс

Процедура НДФЛПриАктивизацииСтроки(Форма) Экспорт
	
	ОписаниеПанелиВычеты = Форма.ОписаниеПанелиВычетыНаКлиенте();
	
	НДФЛТекущиеДанные = УчетНДФЛКлиентСервер.НДФЛТекущиеДанные(Форма, ОписаниеПанелиВычеты);
	ГруппаФормыПанельВычеты = Форма.Элементы.Найти(ОписаниеПанелиВычеты.ИмяГруппыФормыПанелиВычеты);
	
	Если ГруппаФормыПанельВычеты <> Неопределено Тогда
		
		Если ГруппаФормыПанельВычеты.ПодчиненныеЭлементы.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		ЕстьПанельВычетыНаДетейИИмущественные = ОписаниеПанелиВычеты.НастраиваемыеПанели.Получить("ВычетыНаДетейИИмущественные") <> Неопределено;
		ЕстьПанельВычетыЛичные = ОписаниеПанелиВычеты.НастраиваемыеПанели.Получить("ВычетыЛичные") <> Неопределено;
		ЕстьПанельВычетыКДоходам = ОписаниеПанелиВычеты.НастраиваемыеПанели.Получить("ВычетыКДоходам") <> Неопределено;
		
		Если НДФЛТекущиеДанные = Неопределено Тогда
			
			Форма[ГруппаФормыПанельВычеты.Имя + "Заголовок"] = НСтр("ru = 'Вычеты'");
			
			Если ЕстьПанельВычетыНаДетейИИмущественные Тогда
				Форма[ГруппаФормыПанельВычеты.Имя + "ПредставлениеВычетовНаДетейИИмущественных"] = "";
			КонецЕсли; 
			
			Если ЕстьПанельВычетыЛичные Тогда
				
				Форма[ГруппаФормыПанельВычеты.Имя + "ПредставлениеВычетовЛичных"] = "";
				
				ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
					Форма.Элементы,
					ГруппаФормыПанельВычеты.Имя + "ПримененныйВычетЛичный",
					"ТолькоПросмотр",
					Истина);
				
				ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
					Форма.Элементы,
					ГруппаФормыПанельВычеты.Имя + "ПримененныйВычетЛичныйКодВычета",
					"ТолькоПросмотр",
					Истина);
				
				ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
					Форма.Элементы,
					ГруппаФормыПанельВычеты.Имя + "ПримененныйВычетЛичныйКЗачетуВозврату",
					"ТолькоПросмотр",
					Истина);
				
				ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
					Форма.Элементы,
					ГруппаФормыПанельВычеты.Имя + "ПримененныйВычетЛичныйКЗачетуВозвратуКодВычета",
					"ТолькоПросмотр",
					Истина);
				
			КонецЕсли; 
			
			Если ЕстьПанельВычетыКДоходам Тогда
				Форма[ГруппаФормыПанельВычеты.Имя + "ПредставлениеВычетовКДоходам"] = "";
			КонецЕсли; 
			
		Иначе
			
			Форма[ГруппаФормыПанельВычеты.Имя + "Заголовок"] = НСтр("ru='Вычеты'") + " " + Строка(НДФЛТекущиеДанные[ОписаниеПанелиВычеты.ТабличнаяЧастьНДФЛ.ИмяПоляФизическоеЛицо]);
			Если НЕ ПустаяСтрока(ОписаниеПанелиВычеты.ТабличнаяЧастьНДФЛ.ИмяПоляПериод) Тогда
				Форма[ГруппаФормыПанельВычеты.Имя + "Заголовок"] = Форма[ГруппаФормыПанельВычеты.Имя + "Заголовок"]
					+ ", " + НДФЛТекущиеДанные[ОписаниеПанелиВычеты.ТабличнаяЧастьНДФЛ.ИмяПоляПериод + "Строкой"];
			КонецЕсли; 
			
			Если ЕстьПанельВычетыНаДетейИИмущественные Тогда
				Форма[ГруппаФормыПанельВычеты.Имя + "ПредставлениеВычетовНаДетейИИмущественных"] = НДФЛТекущиеДанные["ПредставлениеВычетовНаДетейИИмущественных"];
			КонецЕсли; 
			
			Если ЕстьПанельВычетыЛичные Тогда
				
				Форма[ГруппаФормыПанельВычеты.Имя + "ПредставлениеВычетовЛичных"] = НДФЛТекущиеДанные["ПредставлениеВычетовЛичных"];
				
				ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
					Форма.Элементы,
					ГруппаФормыПанельВычеты.Имя + "ПримененныйВычетЛичный",
					"ТолькоПросмотр",
					Ложь);
				
				ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
					Форма.Элементы,
					ГруппаФормыПанельВычеты.Имя + "ПримененныйВычетЛичныйКодВычета",
					"ТолькоПросмотр",
					Ложь);
				
				ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
					Форма.Элементы,
					ГруппаФормыПанельВычеты.Имя + "ПримененныйВычетЛичныйКЗачетуВозврату",
					"ТолькоПросмотр",
					Ложь);
				
				ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
					Форма.Элементы,
					ГруппаФормыПанельВычеты.Имя + "ПримененныйВычетЛичныйКЗачетуВозвратуКодВычета",
					"ТолькоПросмотр",
					Ложь);
				
				Форма[ГруппаФормыПанельВычеты.Имя + "ПримененныйВычетЛичный"] 							= НДФЛТекущиеДанные["ПримененныйВычетЛичный"];
				Форма[ГруппаФормыПанельВычеты.Имя + "ПримененныйВычетЛичныйКодВычета"] 					= НДФЛТекущиеДанные["ПримененныйВычетЛичныйКодВычета"];
				Форма[ГруппаФормыПанельВычеты.Имя + "ПримененныйВычетЛичныйКЗачетуВозврату"] 			= НДФЛТекущиеДанные["ПримененныйВычетЛичныйКЗачетуВозврату"];
				Форма[ГруппаФормыПанельВычеты.Имя + "ПримененныйВычетЛичныйКЗачетуВозвратуКодВычета"] 	= НДФЛТекущиеДанные["ПримененныйВычетЛичныйКЗачетуВозвратуКодВычета"];
				
			КонецЕсли;
			
			Если ЕстьПанельВычетыКДоходам Тогда
				Форма[ГруппаФормыПанельВычеты.Имя + "ПредставлениеВычетовКДоходам"] = НДФЛТекущиеДанные["ПредставлениеВычетовКДоходам"];
			КонецЕсли; 
			
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			ГруппаФормыПанельВычеты.Имя + "КнопкаНДФЛПодробнее",
			"Доступность",
			(НДФЛТекущиеДанные <> Неопределено));
		
	КонецЕсли;
	
	УчетНДФЛКлиент.УстановитьОтборыПримененныхВычетов(Форма, НДФЛТекущиеДанные);
	
КонецПроцедуры

Процедура НДФЛПередУдалением(Форма, НДФЛВыделенныеСтроки, Отказ) Экспорт
	
	ОписаниеПанелиВычеты = Форма.ОписаниеПанелиВычетыНаКлиенте();
	
	МассивВыделенныхСтрок = Новый ФиксированныйМассив(НДФЛВыделенныеСтроки);
	Форма[ОписаниеПанелиВычеты.ИмяГруппыФормыПанелиВычеты + "ИдентификаторыУдаляемыхСтрокСтрокиНДФЛ"] = МассивВыделенныхСтрок;
	
КонецПроцедуры

#КонецОбласти

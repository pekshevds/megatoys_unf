#Область ПрограммныйИнтерфейс

Процедура УстановитьНастройкиНачальногоИнтерфейса()Экспорт 
	
	НачальнаяСтраница = Новый НастройкиНачальнойСтраницы;
	СоставФорм = НачальнаяСтраница.ПолучитьСоставФорм();
	
	ИнфоормационныйЦентр = "Обработка.ИнформационныйЦентр.Форма.ИнформационныйЦентр";
	ИнфоормационныйЦентр = СоставФорм.ПраваяКолонка.Найти(ИнфоормационныйЦентр);
	Если ИнфоормационныйЦентр <> Неопределено Тогда 
		
		СоставФорм.ПраваяКолонка.Удалить(ИнфоормационныйЦентр);
		НачальнаяСтраница.УстановитьСоставФорм(СоставФорм);
		ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиНачальнойСтраницы", "", НачальнаяСтраница);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
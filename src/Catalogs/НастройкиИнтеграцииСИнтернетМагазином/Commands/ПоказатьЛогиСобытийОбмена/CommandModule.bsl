#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Данные", ПараметрКоманды);
	
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма",
	ПараметрыФормы,
	ПараметрыВыполненияКоманды.Источник,
	ПараметрыВыполненияКоманды.Уникальность,
	ПараметрыВыполненияКоманды.Окно,
	ПараметрыВыполненияКоманды.НавигационнаяСсылка
	);
	
КонецПроцедуры

#КонецОбласти

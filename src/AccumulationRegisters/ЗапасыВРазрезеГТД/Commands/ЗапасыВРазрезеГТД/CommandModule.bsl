#Область ОбработчикиСобытий
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ЗначенияОтбора = Новый Структура("НомерГТД", ПараметрКоманды);
	ПараметрыФормы = Новый Структура("Отбор", ЗначенияОтбора);
	
	ОткрытьФорму("РегистрНакопления.ЗапасыВРазрезеГТД.ФормаСписка", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти

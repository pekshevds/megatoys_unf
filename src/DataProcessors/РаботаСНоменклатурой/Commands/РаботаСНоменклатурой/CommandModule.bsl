
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму(
		"Обработка.РаботаСНоменклатурой.Форма.ПанельАдминистрирования",
		Новый Структура,
		ПараметрыВыполненияКоманды.Источник,
		"Обработка.РаботаСНоменклатурой.Форма.ПанельАдминистрирования" + ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ОткрытьФорму("ПланОбмена.ИнтеграцияСМагазинамиСоцСетей.ФормаСписка", ,
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры

#КонецОбласти

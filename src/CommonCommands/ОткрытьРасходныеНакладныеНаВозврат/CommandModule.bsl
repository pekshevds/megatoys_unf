
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Возврат", Истина);
	ОткрытьФорму("Документ.РасходнаяНакладная.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, "ВозвратыПоставщикам", ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти 


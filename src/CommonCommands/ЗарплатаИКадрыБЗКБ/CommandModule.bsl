#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ПараметрыФормы = Новый Структура("", );
	ОткрытьФорму("ОбщаяФорма.МенюФункцийБЗКБ", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры

#КонецОбласти

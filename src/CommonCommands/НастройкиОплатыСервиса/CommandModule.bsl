
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ПараметрыФормы = Новый Структура;
	ОткрытьФорму(
		"Обработка.ПанельАдминистрированияБТС.Форма.НастройкиОплатыСервиса", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		"Обработка.ПанельАдминистрированияБТС.Форма.НастройкиОплатыСервиса" 
			+ ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
		ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры

#КонецОбласти

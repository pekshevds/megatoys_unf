

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Текст = НСтр("ru = 'Для отправки заявления понадобится токен, на него будет записан закрытый ключ эл. подписи. 
                  |Токен нужно будет предъявить при получении сертификата.
                  |
                  |Для приобретения токена обратитесь в свою обслуживающую организацию.'");
	ПоказатьПредупреждение(, Текст);
	
КонецПроцедуры

#КонецОбласти
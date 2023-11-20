
#Область ПрограммныйИнтерфейс

Функция НомерДляОтправки(КакСвязаться) Экспорт
	
	Результат = "";
	Для ТекПозиция = 1 По СтрДлина(КакСвязаться) Цикл
		ТекСимвол = Сред(КакСвязаться, ТекПозиция, 1);
		Если СтрНайти("0123456789", ТекСимвол) > 0 Тогда
			Результат = Результат + ТекСимвол;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции


Функция ПараметрВремя() Экспорт
	
	Возврат "{Время}";
	
КонецФункции

Функция ПараметрДата() Экспорт
	
	Возврат "{Дата}";
	
КонецФункции

Функция ПараметрИмяПолучателяИменительныйПадеж() Экспорт
	
	Возврат "{Имя получателя (именительный)}";
	
КонецФункции

Функция ПараметрИмяПолучателяРодительныйПадеж() Экспорт
	
	Возврат "{Имя получателя (родительный)}";
	
КонецФункции

Функция ПараметрИмяПолучателяДательныйПадеж() Экспорт
	
	Возврат "{Имя получателя (дательный)}";
	
КонецФункции

Функция ПараметрИмяПолучателяВинительныйПадеж() Экспорт
	
	Возврат "{Имя получателя (винительный)}";
	
КонецФункции

Функция ПараметрИмяПолучателяТворительныйПадеж() Экспорт
	
	Возврат "{Имя получателя (творительный)}";
	
КонецФункции

Функция ПараметрИмяПолучателяПредложныйПадеж() Экспорт
	
	Возврат "{Имя получателя (предложный)}";
	
КонецФункции

Функция ПараметрКакОтписатьсяОтРассылки() Экспорт
	
	Возврат "{Как отписаться от рассылки}";
	
КонецФункции

Функция ПараметрПромокод() Экспорт
	
	Возврат "{Промокод}";
	
КонецФункции

Функция ПараметрКартинкаПромокода() Экспорт
	
	Возврат "{Картинка промокода}";
	
КонецФункции
#КонецОбласти
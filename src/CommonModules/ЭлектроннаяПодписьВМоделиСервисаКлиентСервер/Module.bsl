////////////////////////////////////////////////////////////////////////////////
// Подсистема "Электронная подпись в модели сервиса".
//  
////////////////////////////////////////////////////////////////////////////////


#Область ПрограммныйИнтерфейс

// Параметры:
// 	Телефон - Строка
// 	
// Возвращаемое значение:
// 	Строка
//
Функция ПолучитьПредставлениеТелефона(Телефон) Экспорт
		
	Представление = "";
	ТекстДляОбработки = СокрЛП(Телефон); 
	ТолькоЦифры = "";
	Для Индекс = 1 По СтрДлина(ТекстДляОбработки) Цикл
		ТекущийСимвол = Сред(ТекстДляОбработки, Индекс, 1);
		Если СтрНайти("0123456789", ТекущийСимвол) Тогда
			ТолькоЦифры = ТолькоЦифры + ТекущийСимвол;
		КонецЕсли;
	КонецЦикла;
	Если СтрДлина(ТолькоЦифры) = 11 Тогда
		ТолькоЦифры = Сред(ТолькоЦифры, 2);
	КонецЕсли;

	Если СтрДлина(ТолькоЦифры) = 10 Тогда
		Представление = СтрШаблон(
			"+7 %1 %2-%3-%4", 
			Сред(ТолькоЦифры, 1, 3), 
			Сред(ТолькоЦифры, 4, 3),
			Сред(ТолькоЦифры, 7, 2),
			Сред(ТолькоЦифры, 9));		
	КонецЕсли;
	
	Возврат Представление;	

КонецФункции

// Возвращаемое значение:
// 	Строка
//
Функция ПолучитьОписаниеСпособовПодтвержденияКриптоопераций() Экспорт
	
	Результат = НСтр(
	"ru = 'Признак подтверждения операций с ключом пользователя, хранящимся в программе.
	|Подтверждение предполагает ввод временного пароля, высылаемого в SMS или на эл. почту.'");
	
	Возврат Результат;
	
КонецФункции

#Область УстаревшиеПроцедурыИФункции

// Устарела.
// См. ЭлектроннаяПодписьВМоделиСервисаКлиент.ИспользованиеВозможно.
// См. ЭлектроннаяПодписьВМоделиСервиса.ИспользованиеВозможно.
//
// Возвращаемое значение:
// 	Булево
//
Функция ИспользованиеВозможно() Экспорт
	
	#Если Клиент Тогда
		Возврат СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента()["ИспользованиеЭлектроннойПодписиВМоделиСервисаВозможно"];
	#Иначе
		Возврат ЭлектроннаяПодписьВМоделиСервиса.ИспользованиеВозможно();		
	#КонецЕсли
	
КонецФункции

#КонецОбласти

#КонецОбласти	
#Область ПрограммныйИнтерфейс

// Устарела. Следует использовать новую см. ДисконтныеКартыУНФКлиент.ПоказатьПользователюИнформациюОбОчисткеДКИРучныхСкидок
//
Процедура ПоказатьПользователюИнформациюОбОчисткеДКИРучныхСкидок(ПоказыватьОповещение = Истина) Экспорт
	
	ДисконтныеКартыУНФКлиент.ПоказатьПользователюИнформациюОбОчисткеДКИРучныхСкидок(ПоказыватьОповещение);
	
КонецПроцедуры

#Область МетодыРаботыСоСканеромШтрихкодов

// Устарела. Следует использовать новую
// см. ДисконтныеКартыУНФКлиент.ПреобразоватьДанныеСоСканераВМассив
//
Функция ПреобразоватьДанныеСоСканераВМассив(Параметр) Экспорт
	
	Возврат ДисконтныеКартыУНФКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр);
	
КонецФункции

// Устарела. будет удалена в следующих версиях
//
Функция ПреобразоватьДанныеСоСканераВСтруктуру(Параметр) Экспорт
	
	Если Параметр[1] = Неопределено Тогда
		Данные = Новый Структура("Штрихкод, Количество", Параметр[0], 1); 	 // Достаем штрихкод из основных данных
	Иначе
		Данные = Новый Структура("Штрихкод, Количество", Параметр[1][1], 1); // Достаем штрихкод из дополнительных данных
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

#КонецОбласти

#КонецОбласти

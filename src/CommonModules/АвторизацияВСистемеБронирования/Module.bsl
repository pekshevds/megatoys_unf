#Область СлужебныйПрограммныйИнтерфейс

// См. БронированиеКомандировокПереопределяемый.ЗаполнитьНастройкиСистемыБронирования.
Процедура ЗаполнитьНастройкиСистемыБронирования(Настройки, СистемаБронирования) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Настройки.Логин = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Строка(СистемаБронирования), "Логин");
	Настройки.Пароль = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Строка(СистемаБронирования), "Пароль");
	УстановитьПривилегированныйРежим(Ложь);
	
	Настройки = ОбщегоНазначения.ФиксированныеДанные(Настройки);
	
КонецПроцедуры

// См. БронированиеКомандировокПереопределяемый.СохранитьНастройкиСистемыБронирования.
Процедура СохранитьНастройкиСистемыБронирования(Настройки, СистемаБронирования) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Строка(СистемаБронирования), Настройки.Логин, "Логин");
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Строка(СистемаБронирования), Настройки.Пароль, "Пароль");
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

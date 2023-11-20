
#Область СлужебныеПроцедурыИФункции

Функция ТипГрафикРаботыСсылка() Экспорт

	Возврат ИнтеграцияУправлениеПерсоналомБазовый.ТипГрафикРаботыСсылка();

КонецФункции

Функция ТипВидПредоставляемойСотрудникамСправкиСсылка() Экспорт

	Возврат ИнтеграцияУправлениеПерсоналомБазовый.ТипВидПредоставляемойСотрудникамСправкиСсылка();

КонецФункции

Функция ТипСборГрафиковОтпусковСсылка() Экспорт

	Возврат ИнтеграцияУправлениеПерсоналомБазовый.ТипСборГрафиковОтпусковСсылка();

КонецФункции

Функция ТипЗаявкаОстаткиОтпусковСсылка() Экспорт

	Возврат ИнтеграцияУправлениеПерсоналомБазовый.ТипЗаявкаОстаткиОтпусковСсылка();

КонецФункции 

Функция ТипЗаявкаСправкаСМестаРаботыСсылка() Экспорт

	Возврат ИнтеграцияУправлениеПерсоналомБазовый.ТипЗаявкаСправкаСМестаРаботыСсылка();

КонецФункции 

Функция ТипЗаявкаОтсутствиеСсылка() Экспорт

	Возврат ИнтеграцияУправлениеПерсоналомБазовый.ТипЗаявкаОтсутствиеСсылка();

КонецФункции

Функция ТипЗаявкаДСВСсылка() Экспорт

	Возврат ИнтеграцияУправлениеПерсоналомБазовый.ТипЗаявкаДСВСсылка();

КонецФункции

Функция МенеджерПеречисленияСостоянияСбораГрафиковОтпусков() Экспорт

	Возврат ИнтеграцияУправлениеПерсоналомБазовый.МенеджерПеречисленияСостоянияСбораГрафиковОтпусков();

КонецФункции

Процедура СоздатьВТШтатноеРасписание(МенеджерВТ, ИспользоватьШтатноеРасписание) Экспорт
	
	ИнтеграцияУправлениеПерсоналомБазовый.СоздатьВТШтатноеРасписание(МенеджерВТ, ИспользоватьШтатноеРасписание);
	
КонецПроцедуры

Функция ДанныеПодразделений(Подразделения, Приложение) Экспорт

	Возврат ИнтеграцияУправлениеПерсоналомБазовый.ДанныеПодразделений(Подразделения, Приложение);

КонецФункции

Функция ДанныеШтатногоРасписания(ПозицииШР) Экспорт
	
	Возврат ИнтеграцияУправлениеПерсоналомБазовый.ДанныеШтатногоРасписания(ПозицииШР);
	
КонецФункции 

Функция ДанныеСотрудников(Сотрудники) Экспорт

	Возврат ИнтеграцияУправлениеПерсоналомБазовый.ДанныеСотрудников(Сотрудники);

КонецФункции

Функция ПодразделениеВСтруктуреПредприятия(ПодразделениеОрганизации) Экспорт

	Возврат ИнтеграцияУправлениеПерсоналомБазовый.ПодразделениеВСтруктуреПредприятия(ПодразделениеОрганизации);

КонецФункции

Функция РассчитыватьПодразделенияРуководителей() Экспорт
	
	Возврат ИнтеграцияУправлениеПерсоналомБазовый.РассчитыватьПодразделенияРуководителей();
	
КонецФункции

Процедура ПроверитьОбновитьПозиции(Приложения, МенеджерВТ) Экспорт

	ИнтеграцияУправлениеПерсоналомБазовый.ПроверитьОбновитьПозиции(Приложения, МенеджерВТ);

КонецПроцедуры

Функция ПодразделенияПозицийРуководителей(Позиции) Экспорт
	
	Возврат ИнтеграцияУправлениеПерсоналомБазовый.ПодразделенияПозицийРуководителей(Позиции);
	
КонецФункции

Функция ДанныеГрафиковРаботы(ГрафикиРаботыСотрудников, Приложение) Экспорт

	Возврат ИнтеграцияУправлениеПерсоналомБазовый.ДанныеГрафиковРаботы(ГрафикиРаботыСотрудников, Приложение);

КонецФункции

Процедура ЗарегистрироватьИзмененияГрафиковРаботы(ТаблицаСотрудников, ПриложениеДляОбработки) Экспорт

	ИнтеграцияУправлениеПерсоналомБазовый.ЗарегистрироватьИзмененияГрафиковРаботы(ТаблицаСотрудников, ПриложениеДляОбработки);

КонецПроцедуры

Функция ПодразделенияПозиций(Позиции) Экспорт

	Возврат ИнтеграцияУправлениеПерсоналомБазовый.ПодразделенияПозиций(Позиции);

КонецФункции

Функция ПодразделенияДляПроверкиРуководителей(Организации) Экспорт

	Возврат ИнтеграцияУправлениеПерсоналомБазовый.ПодразделенияДляПроверкиРуководителей(Организации);

КонецФункции

Функция РуководителиПодразделенийОрганизаций(Подразделения, ВыгружаемыеФизическиеЛица) Экспорт

	Возврат ИнтеграцияУправлениеПерсоналомБазовый.РуководителиПодразделенийОрганизаций(Подразделения, ВыгружаемыеФизическиеЛица);

КонецФункции

Функция РуководителиПодразделений(Подразделения, ВыгружаемыеФизическиеЛица) Экспорт
	
	Возврат ИнтеграцияУправлениеПерсоналомБазовый.РуководителиПодразделений(Подразделения, ВыгружаемыеФизическиеЛица);

КонецФункции

Процедура ОбновитьСтруктуруПредприятия() Экспорт

	ИнтеграцияУправлениеПерсоналомБазовый.ОбновитьСтруктуруПредприятия();

КонецПроцедуры

#КонецОбласти

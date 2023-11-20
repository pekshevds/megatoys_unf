//////////////////////////////////////////////////////////////////////////////////////
//
//  Переопределение поведения подсистемы персонифицированного учета внутри библиотеки.
// 
//////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьВТЗаписиСтажаПоДаннымУчета(МенеджерВременныхТаблиц, Организация, ОтчетныйПериод, ОкончаниеОтчетногоПериода, ПараметрыПолученияДанных, ПараметрыОтбора) Экспорт
	ПерсонифицированныйУчетБазовый.СоздатьВТЗаписиСтажаПоДаннымУчета(МенеджерВременныхТаблиц, Организация, ОтчетныйПериод, ОкончаниеОтчетногоПериода, ПараметрыПолученияДанных, ПараметрыОтбора);
КонецПроцедуры	

Процедура СоздатьВТЗарегистрированныеКорректировкиСтажа(МенеджерВременныхТаблиц, Организация, ОтчетныйПериод) Экспорт
	ПерсонифицированныйУчетБазовый.СоздатьВТЗарегистрированныеКорректировкиСтажа(МенеджерВременныхТаблиц, Организация, ОтчетныйПериод);	
КонецПроцедуры	

Функция КвартальнаяОтчетностьПерераспределятьВзносыАвтоматически() Экспорт 
	Возврат ПерсонифицированныйУчетБазовый.КвартальнаяОтчетностьПерераспределятьВзносыАвтоматически()	
КонецФункции

Процедура КвартальнаяОтчетностьПФРДополнитьКомандыФормы(Форма) Экспорт
	ПерсонифицированныйУчетБазовый.КвартальнаяОтчетностьПФРДополнитьКомандыФормы(Форма);
КонецПроцедуры

Процедура КвартальнаяОтчетностьПФРОбновитьДанныеФормы(Форма) Экспорт
	ПерсонифицированныйУчетБазовый.КвартальнаяОтчетностьПФРОбновитьДанныеФормы(Форма);	
КонецПроцедуры	

Функция ПараметрыДляСоздатьВТСотрудникиОрганизации(МенеджерВременныхТаблиц, Организация, ОтчетныйПериод, СписокФизическихЛиц) Экспорт
	Возврат ПерсонифицированныйУчетБазовый.ПараметрыДляСоздатьВТСотрудникиОрганизации(МенеджерВременныхТаблиц, Организация, ОтчетныйПериод, СписокФизическихЛиц);
КонецФункции

Процедура СоздатьВТДосрочноеНазначениеПенсииДляСЗВ_СТАЖ(МенеджерВременныхТаблиц, Организация, Год, ЗаписиОСтаже) Экспорт
	
	ПерсонифицированныйУчетБазовый.СоздатьВТДосрочноеНазначениеПенсииДляСЗВ_СТАЖ(МенеджерВременныхТаблиц, Организация, Год, ЗаписиОСтаже);
	
КонецПроцедуры

Процедура СоздатьВТЗамещениеГосударственныхДолжностей(МенеджерВременныхТаблиц) Экспорт 
	
	ПерсонифицированныйУчетБазовый.СоздатьВТЗамещениеГосударственныхДолжностей(МенеджерВременныхТаблиц);
	
КонецПроцедуры

Процедура ЗаполнитьДанныеДосрочногоНазначенияПенсии(Объект, Организация, ОтчетныйПериод, ОкончаниеОтчетногоПериода) Экспорт 
	
	
	
КонецПроцедуры

Процедура УстановитьСвязиПараметровВыбораСотрудников(ЭлементФормы) Экспорт 
	
	
	
КонецПроцедуры

Процедура СоздатьВТКадровыеДанныеФизическихЛицДоНачалаЭксплуатации(МенеджерВременныхТаблиц, Организация, НачалоПериода, ОкончаниеПериода) Экспорт
	ПерсонифицированныйУчетБазовый.СоздатьВТКадровыеДанныеФизическихЛицДоНачалаЭксплуатации(МенеджерВременныхТаблиц, Организация, НачалоПериода, ОкончаниеПериода);
КонецПроцедуры

Процедура ЗаполнитьДанныеРуководителя(Объект) Экспорт
	
	ПерсонифицированныйУчетБазовый.ЗаполнитьДанныеРуководителя(Объект);
	
КонецПроцедуры

Процедура ЗаполнитьРазрядыКатегорииДокументовТрудовыхКнижек(ПараметрыОбновления) Экспорт
	
	ПерсонифицированныйУчетБазовый.ЗаполнитьРазрядыКатегорииДокументовТрудовыхКнижек(ПараметрыОбновления);
	
КонецПроцедуры

Процедура ЗаполнитьЗаписиОСтажеСЗВК(Объект, ФизическиеЛица) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

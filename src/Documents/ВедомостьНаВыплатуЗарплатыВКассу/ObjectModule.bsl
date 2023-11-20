#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ВедомостьНаВыплатуЗарплаты.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты)	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ВедомостьНаВыплатуЗарплаты.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи); 
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ПроверитьНаличиеВалютныхНерезидентов();
	ВедомостьНаВыплатуЗарплаты.ОбработкаПроведения(ЭтотОбъект, Отказ);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// АПК:299-выкл Используемость методов внутреннего API ведомостей не контролируется

#Область СценарииЗаполненияДокумента

Функция МожноЗаполнитьЗарплату() Экспорт
	Возврат ВедомостьНаВыплатуЗарплаты.МожноЗаполнитьЗарплату(ЭтотОбъект)
КонецФункции

#КонецОбласти

#Область МестоВыплаты

Функция МестоВыплаты() Экспорт
	Возврат ВедомостьНаВыплатуЗарплаты.МестоВыплатыКасса(ЭтотОбъект);
КонецФункции

Процедура УстановитьМестоВыплаты(Значение) Экспорт
	ВедомостьНаВыплатуЗарплаты.УстановитьМестоВыплатыКасса(ЭтотОбъект, Значение)
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеДокумента

Процедура ОчиститьВыплаты() Экспорт
	ВедомостьНаВыплатуЗарплаты.ОчиститьВыплаты(ЭтотОбъект);
КонецПроцедуры	

Процедура ЗагрузитьВыплаты(Зарплата, НДФЛ) Экспорт
	ВедомостьНаВыплатуЗарплаты.ЗагрузитьВыплаты(ЭтотОбъект, Зарплата, НДФЛ);
КонецПроцедуры

Процедура ДобавитьВыплаты(Зарплата, НДФЛ) Экспорт
	ВедомостьНаВыплатуЗарплаты.ДобавитьВыплаты(ЭтотОбъект, Зарплата, НДФЛ)
КонецПроцедуры

Процедура УстановитьНДФЛ(НДФЛ, Знач ФизическиеЛица = Неопределено) Экспорт
	ВедомостьНаВыплатуЗарплаты.УстановитьНДФЛ(ЭтотОбъект, НДФЛ, ФизическиеЛица)
КонецПроцедуры

#КонецОбласти

// АПК:299-вкл

Процедура ПроверитьНаличиеВалютныхНерезидентов()
	
	КадровыеДанные = КадровыйУчет.КадровыеДанныеФизическихЛиц(Истина, 
		ФизическиеЛица.ВыгрузитьКолонку("ФизическоеЛицо"),"ВидЗастрахованногоЛица",
		ВедомостьНаВыплатуЗарплатыКлиентСервер.ДатаВыплаты(ЭтотОбъект));
		
	ВалютныеРезиденты = Перечисления.ВидыЗастрахованныхЛицОбязательногоСтрахования.ВалютныеРезиденты();
	
	ФизическиеЛицаВалютныеНерезиденты = Новый Массив;
	
	Для Каждого КадровыеДанныеФизическогоЛица Из КадровыеДанные Цикл
		Если ВалютныеРезиденты.Найти(КадровыеДанныеФизическогоЛица.ВидЗастрахованногоЛица) = Неопределено Тогда
			ФизическиеЛицаВалютныеНерезиденты.Добавить(КадровыеДанныеФизическогоЛица.ФизическоеЛицо);
		КонецЕсли;
	КонецЦикла;
	
	Если ФизическиеЛицаВалютныеНерезиденты.Количество() > 0 Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Документ в нарушение норм валютного контроля ЦБ предполагает выплату наличных рублевых
			|сумм следующим иностранным гражданам:'") 
			+ Символы.ПС 
			+ СтрСоединить(ФизическиеЛицаВалютныеНерезиденты, ", ");
		Сообщение.Сообщить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
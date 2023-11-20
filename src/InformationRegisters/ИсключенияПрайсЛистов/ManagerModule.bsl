#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ДобавитьИсключение(Номенклатура, Характеристика, ПрайсЛист) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ПрайсЛист) Тогда
		
		Возврат;
		
	ИначеЕсли НЕ ЗначениеЗаполнено(Номенклатура) Тогда
		
		Если ЗначениеЗаполнено(Характеристика) Тогда
			
			Номенклатура = Характеристика.Владелец;
			
		Иначе
			
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.ИсключенияПрайсЛистов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Номенклатура		= Номенклатура;
	МенеджерЗаписи.Характеристика	= Характеристика;
	МенеджерЗаписи.ПрайсЛист		= ПрайсЛист;
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
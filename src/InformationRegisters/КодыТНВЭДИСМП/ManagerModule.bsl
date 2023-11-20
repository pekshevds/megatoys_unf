#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Записывает код ТН ВЭД из онлайн-классификатора.
// 
// Параметры:
//  ДанныеЗаписи - Структура - со свойствами:
//  * КодТНВЭД - Строка - Код ТН ВЭД.
//  * ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - вид продукции.
//  * НаименованиеПолное - Строка - наименование.
Процедура ЗаписатьДанныеКодаТНВЭД(ДанныеЗаписи) Экспорт
	
	Если Не ЗначениеЗаполнено(ДанныеЗаписи) Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.КодыТНВЭДИСМП.СоздатьМенеджерЗаписи();
	
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ДанныеЗаписи);
	
	Блокировка        = Новый БлокировкаДанных();
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.КодыТНВЭДИСМП");
	ЭлементБлокировки.УстановитьЗначение("КодТНВЭД", ДанныеЗаписи.КодТНВЭД);
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка.Заблокировать();
		
		УстановитьПривилегированныйРежим(Истина);
		МенеджерЗаписи.Записать();
		УстановитьПривилегированныйРежим(Ложь);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ТекстОшибки = СтрШаблон(
			НСтр("ru = 'Произошла ошибка сохранения кода ТН ВЭД %1:
				       |%2'"),
			ДанныеЗаписи.КодТНВЭД,
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ВызватьИсключение ТекстОшибки;
		
	КонецПопытки
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
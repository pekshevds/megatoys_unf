#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ЗафиксироватьВыполнениеПравила(Правило, СозданныйОбъект, Действие, ДатаВыполнения = Неопределено) Экспорт
	
	Набор = РегистрыСведений.ВыполнениеПравилРабочегоПроцесса.СоздатьНаборЗаписей();
	Набор.Отбор.Правило.Установить(Правило);
	Набор.Отбор.СозданныйОбъект.Установить(СозданныйОбъект);
	Набор.Отбор.Действие.Установить(Действие);
	
	Набор.Очистить();
	
	ЗаписьНабора = Набор.Добавить();
	ЗаписьНабора.Правило			= Правило;
	ЗаписьНабора.СозданныйОбъект	= СозданныйОбъект;
	ЗаписьНабора.Действие			= Действие;
	ЗаписьНабора.ДатаВыполнения		= ДатаВыполнения;
	
	Набор.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция Настройки() Экспорт
	
	Настройки = РегистрыСведений.ИспользуемаяФункциональностьСервисаКабинетСотрудника.СоздатьМенеджерЗаписи();
	Настройки.Прочитать();
	
	СтруктураНастроек = ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(
							Настройки, Метаданные.РегистрыСведений.ИспользуемаяФункциональностьСервисаКабинетСотрудника);
							
	Если Не ЗначениеЗаполнено(СтруктураНастроек.УровеньДоступаКИ) Тогда
		СтруктураНастроек.УровеньДоступаКИ = Перечисления.УровниДоступаКИнформацииОСотрудниках.Руководители;
	КонецЕсли;
	
	Возврат СтруктураНастроек;

КонецФункции

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

Процедура СохранитьНовыеНастройки(СохраняемыеНастройки) Экспорт

	НаборЗаписей = РегистрыСведений.ИспользуемаяФункциональностьСервисаКабинетСотрудника.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() = 0 Тогда
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), СохраняемыеНастройки);
	Иначе
		ЗаполнитьЗначенияСвойств(НаборЗаписей[0], СохраняемыеНастройки);
	КонецЕсли;
	НаборЗаписей.Записать();

КонецПроцедуры

#КонецОбласти

#КонецЕсли

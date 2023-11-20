#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция КоличествоЗадач() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(ОчередьЗадачАссистентаУправления.Задача) КАК Количество
	|ИЗ
	|	РегистрСведений.ОчередьЗадачАссистентаУправления КАК ОчередьЗадачАссистентаУправления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если НЕ Выборка.Следующий() Тогда
		Возврат 0;
	КонецЕсли;
	
	Возврат Выборка.Количество;
	
КонецФункции

Процедура УдалитьЗадачуИзОчереди(Задача) Экспорт
	
	НаборЗаписей = РегистрыСведений.ОчередьЗадачАссистентаУправления.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Задача.Установить(Задача);
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

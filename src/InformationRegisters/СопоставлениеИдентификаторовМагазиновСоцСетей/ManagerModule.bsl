///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура добавляет запись в регистр по переданным значениям структуры.
Процедура ДобавитьЗапись(СтруктураЗаписи, Загрузка = Ложь) Экспорт
	
	МЗ = РегистрыСведений.СопоставлениеИдентификаторовМагазиновСоцСетей.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МЗ, СтруктураЗаписи);
	МЗ.Записать();
	
КонецПроцедуры

// Процедура удаляет набор записей в регистре по переданным значениям структуры.
Процедура УдалитьЗапись(СтруктураЗаписи, Загрузка = Ложь) Экспорт
	
	МЗ = РегистрыСведений.СопоставлениеИдентификаторовМагазиновСоцСетей.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МЗ, СтруктураЗаписи);
	МЗ.Удалить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
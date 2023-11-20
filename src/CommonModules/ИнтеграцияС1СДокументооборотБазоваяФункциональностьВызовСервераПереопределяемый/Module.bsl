////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интеграция с 1С:Документооборотом"
// Модуль ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервераПереопределяемый: сервер, вызов сервера
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Создает правила интеграции для указанного типа объекта ИС.
//
// Параметры:
//   ИмяТипаОбъекта - Строка, ЛюбаяСсылка - полное имя типа объекта ИС, как в метаданных, или ссылка на объект ИС.
//   ПравилаИнтеграции - Массив из Структура:
//     * Ссылка - СправочникСсылка.ПравилаИнтеграцииС1СДокументооборотом
//     * ТипОбъектаИС - Строка
//     * ТипОбъектаДО - Строка
//     * ПредставлениеОбъектаИС - Строка
//     * ПредставлениеОбъектаДО - Строка
//     * ИдентификаторВидаДокумента - Строка
//     * ТипВидаДокумента - Строка
//
// Пример:
//   Если ИмяТипаОбъекта = "Документ.ПоступлениеТоваровУслуг" Тогда
//     // Создаем правила интеграции и добавляем в массив
//     ПравилаИнтеграции = НачатьАвтоматическуюНастройкуИнтеграцииПоступлениеТоваровУслуг();
//   ИначеЕсли ИмяТипаОбъекта = "Документ.ЗаявкаНаРасходованиеДенежныхСредств" Тогда
//     // Создаем правила интеграции и добавляем в массив
//     ПравилаИнтеграции = НачатьАвтоматическуюНастройкуИнтеграцииЗаявкаНаОперацию();
//   КонецЕсли;
//
Процедура ПриСозданииПравилИнтеграцииАвтоматически(Знач ИмяТипаОбъекта, ПравилаИнтеграции) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
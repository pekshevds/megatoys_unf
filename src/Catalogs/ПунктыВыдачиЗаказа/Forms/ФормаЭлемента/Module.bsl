
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	ПараметрыКонтактнойИнформации = УправлениеКонтактнойИнформацией.ПараметрыКонтактнойИнформации();
	ПараметрыКонтактнойИнформации.ИмяЭлементаДляРазмещения = Элементы.КонтактнаяИнформация.Имя;
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтотОбъект, Объект, ПараметрыКонтактнойИнформации);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Объект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция НастройкиПереопределенияКонтактнойИнформации()
	
	НастройкиПереопределения = УправлениеКонтактнойИнформациейУНФ.НастройкиПереопределения();
	НастройкиПереопределения.ИспользоватьСтандартнуюШирину = Ложь;
	Возврат НастройкиПереопределения;
	
КонецФункции

// СтандартныеПодсистемы.КонтактнаяИнформация
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	УправлениеКонтактнойИнформациейКлиент.НачатьИзменение(ЭтотОбъект, Элемент);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачатьВыбор(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачатьВыбор(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачатьОчистку(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	УправлениеКонтактнойИнформациейКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда.Имя);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.АвтоПодборАдреса(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, Элемент.Имя, СтандартнаяОбработка);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачатьОбработкуНавигационнойСсылки(ЭтотОбъект, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ПродолжитьОбновлениеКонтактнойИнформации(Результат, ДополнительныеПараметры) Экспорт
	ОбновитьКонтактнуюИнформацию(Результат);
КонецПроцедуры
&НаСервере
Процедура ОбновитьКонтактнуюИнформацию(Результат)
	УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
	УправлениеКонтактнойИнформациейУНФ.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, НастройкиПереопределенияКонтактнойИнформации(), Результат);
КонецПроцедуры
// Конец СтандартныеПодсистемы.КонтактнаяИнформация

#КонецОбласти

#КонецОбласти

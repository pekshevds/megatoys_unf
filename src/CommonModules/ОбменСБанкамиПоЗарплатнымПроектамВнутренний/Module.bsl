////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен с банками по зарплатным проектам".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьДоступностьСпособовЗачисленияПоЗарплатномуПроекту(СпособыЗачисления, ЗарплатныйПроект) Экспорт
	
	ЗарплатаКадрыДляНебольшихОрганизацийПереопределяемый.УстановитьДоступностьСпособовЗачисленияПоЗарплатномуПроекту(СпособыЗачисления, ЗарплатныйПроект);
	
КонецПроцедуры

Процедура ЗарегистрироватьИзмененияЛицевыхСчетов(ЛицевыеСчетаФизическихЛиц, Организация, ДатаНачала) Экспорт
	
КонецПроцедуры

Функция ДеньВыплатыЗарплатыВОрганизации(Организация) Экспорт
	Возврат 0;
КонецФункции

Процедура ДополнитьКадровыеДанные(КадровыеДанные, ТекстЗапроса) Экспорт
	
КонецПроцедуры

Функция ЗаявкаНаОткрытиеЛицевыхСчетовСотрудниковОписаниеФиксацииРеквизитов() Экспорт
	Возврат ОбменСБанкамиПоЗарплатнымПроектамБазовый.ЗаявкаНаОткрытиеЛицевыхСчетовСотрудниковОписаниеФиксацииРеквизитов()
КонецФункции

Процедура ДополнитьПараметрыПолученияСотрудников(ПараметрыПолученияСотрудников) Экспорт
	
КонецПроцедуры

Процедура ВыгрузитьФайлыОбменаСБанком(СтруктураПараметров, АдресХранилища) Экспорт
	ОбменСБанкамиПоЗарплатнымПроектамБазовый.ВыгрузитьФайлыОбменаСБанком(СтруктураПараметров, АдресХранилища);
КонецПроцедуры

Процедура ДополнитьСоставКомандЭДО(СоставКомандЭДО) Экспорт

КонецПроцедуры

Процедура ДополнитьСуммуПоДокументу(СуммаПоДокументу, МассивВедомостей) Экспорт

КонецПроцедуры

Процедура ДополнитьТаблицуВедомостей(ТаблицаВедомостей, МассивВедомостей) Экспорт

КонецПроцедуры

Процедура УточнитьТекстЗапросаДинамическогоСпискаЗачислениеЗарплаты(ЗачислениеЗарплаты) Экспорт
	
КонецПроцедуры

Функция ДополнительныеИсточникиДляВыгрузкиФайлов(Источники) Экспорт
	Возврат ОбменСБанкамиПоЗарплатнымПроектамБазовый.ДополнительныеИсточникиДляВыгрузкиФайлов(Источники);
КонецФункции

#КонецОбласти
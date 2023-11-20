
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	Если ПараметрыВыполненияКоманды.Источник=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыВыполненияКоманды.Источник.ИмяФормы = "Справочник.Номенклатура.Форма.ФормаСписка" 
		ИЛИ ПараметрыВыполненияКоманды.Источник.ИмяФормы = "Справочник.Номенклатура.Форма.ФормаКорзина" Тогда
		НоменклатураВДокументахКлиент.ОформитьДокументСТоварамиИзКорзины(ПараметрыВыполненияКоманды.Источник, "ЗаказПокупателя");
	ИначеЕсли Лев(ПараметрыВыполненияКоманды.Источник.ИмяФормы,17) = "ЖурналДокументов." Тогда
		СтруктураПараметров = Новый Структура();
		РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ПараметрыВыполненияКоманды.Источник.ДанныеМеток, СтруктураПараметров, "Контрагент");
		НайденныеСтрокиОтбора = ПараметрыВыполненияКоманды.Источник.ДанныеМеток.НайтиСтроки(Новый Структура("ИмяПоляОтбора","ВидОперации"));
		Если НайденныеСтрокиОтбора.Количество() > 0 Тогда
			ЗначениеОтбораВидОперации = НайденныеСтрокиОтбора[НайденныеСтрокиОтбора.Количество()-1].Метка;
			Если ЗначениеОтбораВидОперации=ПредопределенноеЗначение("Перечисление.ВидыОперацийЗаказПокупателя.ЗаказНаПереработку") Тогда
				СтруктураПараметров.Вставить("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийЗаказПокупателя.ЗаказНаПереработку"));
			Иначе
				СтруктураПараметров.Вставить("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийЗаказПокупателя.ЗаказНаПродажу"));
			КонецЕсли;
		КонецЕсли;
		РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ПараметрыВыполненияКоманды.Источник.ДанныеМеток, СтруктураПараметров, "Организация");
			
		ОткрытьФорму("Документ.ЗаказПокупателя.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения",СтруктураПараметров));
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти 


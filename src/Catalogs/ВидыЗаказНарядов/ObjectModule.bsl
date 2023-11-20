#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТЧ = ПорядокСостояний.Найти(Справочники.СостоянияЗаказНарядов.Завершен, "Состояние");
	Если СтрокаТЧ = Неопределено Тогда
		СтрокаТЧ = ПорядокСостояний.Добавить();
		СтрокаТЧ.Состояние = Справочники.СостоянияЗаказНарядов.Завершен;
	Иначе
		ПорядокСостояний.Сдвинуть(СтрокаТЧ, ПорядокСостояний.Количество() - СтрокаТЧ.НомерСтроки);
	КонецЕсли;
	
	НомерСостоянияВыполнения = ПорядокСостояний.Найти(СостояниеВыполнения).НомерСтроки;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Для НомерСтроки = 1 По ПорядокСостояний.Количество() Цикл
		Для НомерСтрокиОстатка = НомерСтроки+1 По ПорядокСостояний.Количество() Цикл
			Если ПорядокСостояний[НомерСтроки-1].Состояние = ПорядокСостояний[НомерСтрокиОстатка-1].Состояние Тогда
				ОбщегоНазначения.СообщитьПользователю(СтрШаблон(НСтр("ru='Дублируется состояние ""%1"" в строках %2 и %3'"), ПорядокСостояний[НомерСтроки-1].Состояние, НомерСтроки, НомерСтрокиОстатка),
					Ссылка,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ПорядокСостояний", НомерСтрокиОстатка, "Состояние"),
					,
					Отказ);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(СостояниеВыполнения) И ПорядокСостояний.Найти(СостояниеВыполнения, "Состояние") = Неопределено Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Выбранного состояния нет среди используемых в виде заказ-наряда.'"),
			,
			"СостояниеВыполнения",
			"Объект",
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
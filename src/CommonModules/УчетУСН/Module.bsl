
#Область ПрограммныйИнтерфейс

// Возвращает наиболее вероятный период (квартал), за который может уплачиваться налог УСН
// в заданный день по данной организации.
//
// Параметры:
//  ДеньПлатежа  - Дата - день фактического платежа
//  Организация  - СправочникСсылка.Организации - организация, от имени которой производится уплата
//
// Возвращаемое значение:
//   Дата   - начало квартала, за который с наибольшей вероятностью нужно заплатить налог
//            (иначе говоря, начало последнего квартала отчетного/налогового периода).
//
Функция РелевантныйПериодНалоговогоПлатежа(ДатаПлатежа, Организация) Экспорт
	
	ПредыдущийКвартал = НачалоКвартала(ДобавитьМесяц(ДатаПлатежа, -3));
	
	ПериодПоУмолчанию    = ПредыдущийКвартал; // По умолчанию платеж всегда за прошлый квартал.
	АльтернативныйПериод = Неопределено;
	
	// В течение года есть интервалы, на которых могут пересекаться сроки уплаты налога за прошлый год и авансового платежа.
	// Такие интервалы могут возникнуть в апреле (у всех плательщиков) и в мае (только у ИП).
	// Если дата платежа попадает в такой интервал - для определения наиболее вероятного оплачиваемого периода
	// потребуется уточнить крайние сроки оплаты налога и авансового платежа с учетом выходных/праздников.
	
	МесяцПлатежа = Месяц(ДатаПлатежа);
	
	Если МесяцПлатежа <> 4 И МесяцПлатежа <> 5 Тогда // Не требуется уточнять период.
		Возврат ПериодПоУмолчанию;
	КонецЕсли;
	
	ДеньПлатежа = День(ДатаПлатежа);
	
	Если ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ЭтоЮрЛицо(Организация) Тогда
		// Юрлица в начале апреля, если 31 марта выходной, могут еще 2 дня уплачивать налог за прошлый год.
		Если МесяцПлатежа = 4 И ДеньПлатежа <= КоличествоСтандартныхВыходныхДней() Тогда
			АльтернативныйПериод = ДобавитьМесяц(ПредыдущийКвартал, -3);
		КонецЕсли;
	Иначе
		// ИП в начале мая могут уплачивать налог за прошлый год, если 30 апреля выходной.
		// Уточнять срок необходимо за все время майских праздников - они могут быть непрерывными.
		Если МесяцПлатежа = 5 И ДеньПлатежа <= МаксимальноеКоличествоДнейМайскихПраздников() Тогда
			
			АльтернативныйПериод = ДобавитьМесяц(ПредыдущийКвартал, -3);
			
		// В апреле, кроме налога за год, ИП уплачивает авансовый платеж за 1 квартал.
		// Предполагаем, что в течение срока авансового платежа наиболее вероятен именно он.
		// За границами срока авансового платежа предполагаем, что это уплата налога за год.
		ИначеЕсли МесяцПлатежа = 4 И ДеньПлатежа > ДеньУплатыАвансовогоПлатежаПоУмолчанию() Тогда
			
			// Здесь основной и альтернативный периоды меняются местами.
			// Необходимо проверить срок авансового платежа. Если истек - платится налог за год.
			АльтернативныйПериод = ПредыдущийКвартал;
			ПериодПоУмолчанию    = ДобавитьМесяц(ПредыдущийКвартал, -3);
			
		Иначе
			// Считаем, что уплачивается авансовый платеж за предыдущий квартал.
			// Период уже задан в ПериодПоУмолчанию.
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АльтернативныйПериод) Тогда
		Возврат АльтернативныйПериод;
	КонецЕсли;
	
	Возврат ПериодПоУмолчанию;
	
КонецФункции

// Определяет периодичность налогового платежа в зависимости от оплачиваемого периода.
//
// Параметры:
//  НалоговыйПериод - Дата - оплачиваемый период
//
// Возвращаемое значение:
//   ПеречислениеСсылка.Периодичность, возможные значения:
//    * Год, если платеж за последний квартал (налог за год)
//    * Квартал, если платеж за все остальные кварталы (авансовый платеж).
Функция ПериодичностьНалоговогоПлатежа(НалоговыйПериод) Экспорт
	
	Если КонецКвартала(НалоговыйПериод) = КонецГода(НалоговыйПериод) Тогда
		// Платеж за последний квартал года - это налог за год.
		Возврат Перечисления.Периодичность.Год;
	Иначе
		// За периоды кроме последнего квартала года уплачивается ежеквартальный авансовый платеж.
		Возврат Перечисления.Периодичность.Квартал;
	КонецЕсли;
	
КонецФункции

// Определяет период, за который уплачивается налог, по данным платежного документа.
//
// Параметры:
//  ОписаниеПериода  - Структура - разобранный показатель периода (реквизит 107) платежного документа,
//                     см. ПлатежиВБюджетКлиентСервер.РазобратьНалоговыйПериод()
//  ДатаПлатежа      - Дата - дата платежного документа; используется, если не удалось определить налоговый период
//                     по реквизитам платежного документа.
//   Организация       - СправочникСсылка.Организации - организация платежа
//
// Возвращаемое значение:
//   Дата   - начало квартала, за который уплачивается налог;
//            для налога за год - начало последнего квартала в году.
//
Функция НалоговыйПериодПоДаннымПлатежногоДокумента(ОписаниеПериода, ДатаПлатежа, Организация) Экспорт
	
	НалоговыйПериод = '00010101';
	
	// Пытаемся определить из описания периода.
	
	Если ОписаниеПериода.Периодичность = ПлатежиВБюджетКлиентСервер.ПериодичностьГод() Тогда
		НалоговыйПериод = НачалоКвартала(КонецГода(ОписаниеПериода.Дата));
	ИначеЕсли ОписаниеПериода.Периодичность = ПлатежиВБюджетКлиентСервер.ПериодичностьПолугодие() Тогда
		НалоговыйПериод = НачалоКвартала(ДобавитьМесяц(ОписаниеПериода.Дата, 3));
	ИначеЕсли ОписаниеПериода.Периодичность = ПлатежиВБюджетКлиентСервер.ПериодичностьКвартал() Тогда
		НалоговыйПериод = НачалоКвартала(ОписаниеПериода.Дата);
	ИначеЕсли ОписаниеПериода.Периодичность = ПлатежиВБюджетКлиентСервер.ПериодичностьМесяц() Тогда
		НалоговыйПериод = НачалоКвартала(ОписаниеПериода.Дата);
	КонецЕсли;
	
	// Если из описания периода прочитать не удалось - определим наиболее вероятный для даты платежа.
	
	Если НЕ ЗначениеЗаполнено(НалоговыйПериод) Тогда
		НалоговыйПериод = РелевантныйПериодНалоговогоПлатежа(ДатаПлатежа, Организация);
	КонецЕсли;
	
	Возврат НалоговыйПериод;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДеньУплатыАвансовогоПлатежаПоУмолчанию()
	
	Возврат 25;
	
КонецФункции

Функция МаксимальноеКоличествоДнейМайскихПраздников()
	
	Возврат 11; // 9 мая - последний майский праздник, после него возможны 2 выходных дня.
	
КонецФункции

Функция КоличествоСтандартныхВыходныхДней()
	
	Возврат 2; // Суббота и воскресенье.
	
КонецФункции

#КонецОбласти

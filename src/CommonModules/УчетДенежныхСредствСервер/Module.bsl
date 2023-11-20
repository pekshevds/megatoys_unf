#Область СлужебныеПроцедурыИФункции

Функция ЕстьРасчетыПоНДС(ВидОперации) Экспорт
	
	Если ВидОперации = Перечисления.ВидыОперацийПоступлениеВКассу.ПолучениеНаличныхВБанке Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// РАБОТА С БАНКОВСКИМИ ДОКУМЕНТАМИ

//Функция НаименованиеДляПечатныхФормИП(ФИОИП, НаименованиеПолное)
//	
//	Если ПустаяСтрока(ФИОИП.Фамилия) Тогда
//		Возврат НаименованиеПолное;
//	КонецЕсли;
//	
//	НаименованиеДляПечатныхФормИП = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
//		НСтр("ru = 'ИП %1 %2 %3'"),
//		СокрЛП(ФИОИП.Фамилия),
//		СокрЛП(ФИОИП.Имя),
//		СокрЛП(ФИОИП.Отчество));
//	
//	Возврат НаименованиеДляПечатныхФормИП;
//	
//КонецФункции

Функция СвойстваВладельцаСчета(ВладелецСчета, Период = Неопределено)
	
	СвойстваВладельца = Новый Структура;
	СвойстваВладельца.Вставить("Наименование", "");
	СвойстваВладельца.Вставить("НаименованиеПолное", "");
	СвойстваВладельца.Вставить("НаименованиеДляПечатныхФорм", "");
	СвойстваВладельца.Вставить("НаименованиеПлательщикаПриПеречисленииВБюджет", "");
	
	Если ЗначениеЗаполнено(ВладелецСчета) Тогда
		Если ТипЗнч(ВладелецСчета) = Тип("СправочникСсылка.Организации") Тогда
			НаименованиеОрганизации = Справочники.Организации.НаименованиеНаДату(ВладелецСчета, Период);
			ПолноеНаименованиеОрганизации = Справочники.Организации.ПолноеНаименованиеНаДату(ВладелецСчета, Период);
			НаименованиеПлательщикаПриПеречисленииВБюджет = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
															ВладелецСчета, "НаименованиеПлательщикаПриПеречисленииНалогов");
			
			СвойстваВладельца.Наименование                = НаименованиеОрганизации;
			СвойстваВладельца.НаименованиеПолное          = ПолноеНаименованиеОрганизации;
			СвойстваВладельца.НаименованиеДляПечатныхФорм = НаименованиеОрганизации;
			СвойстваВладельца.НаименованиеПлательщикаПриПеречисленииВБюджет = НаименованиеПлательщикаПриПеречисленииВБюджет;
			//Если Не Справочники.Организации.ЭтоЮрЛицо(ВладелецСчета) Тогда
			//	СвойстваВладельца.НаименованиеДляПечатныхФорм =
			//		НаименованиеДляПечатныхФормИП(НаименованияОрганизации.ФИО, СвойстваВладельца.НаименованиеПолное);
			//КонецЕсли;
		ИначеЕсли ТипЗнч(ВладелецСчета) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
			РеквизитыВладельца = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВладелецСчета,
					"Наименование, ФИО");
			СвойстваВладельца.Наименование                = РеквизитыВладельца.Наименование;
			СвойстваВладельца.НаименованиеДляПечатныхФорм = РеквизитыВладельца.ФИО;
		ИначеЕсли ТипЗнч(ВладелецСчета) = Тип("СправочникСсылка.Контрагенты") Тогда
			//НаименованияКонтрагента = Справочники.Контрагенты.НаименованияНаДату(ВладелецСчета, Период);
			//СвойстваВладельца.Наименование                = НаименованияКонтрагента.СокращенноеНаименование;
			//СвойстваВладельца.НаименованиеДляПечатныхФорм = НаименованияКонтрагента.НаименованиеДляПечатныхФорм;
			СвойстваВладельца.Наименование                = ВладелецСчета.Наименование;
		КонецЕсли;
	КонецЕсли;
	
	Возврат СвойстваВладельца;
	
КонецФункции

Функция СвойстваБанковскогоСчета(БанковскийСчет)
	
	Если ЗначениеЗаполнено(БанковскийСчет) Тогда
		Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(БанковскийСчет,
			"Банк, НомерСчета, БанкРасчетов, ТекстКорреспондента");
	Иначе
		Возврат Новый Структура("Банк, НомерСчета, БанкРасчетов, ТекстКорреспондента",
			БанковскийСчет.Банк, "", БанковскийСчет.БанкРасчетов, "");
	КонецЕсли;
	
КонецФункции

Функция НаименованиеПлательщикаПолучателяПоУмолчанию(ВладелецСчета, БанковскийСчет, ПеречислениеВБюджет = Ложь, Период = Неопределено, Знач СвойстваВладельца = Неопределено, Знач СвойстваБанковскогоСчета = Неопределено) Экспорт
	
	ЭтоОрганизация = ТипЗнч(ВладелецСчета) = Тип("СправочникСсылка.Организации");
	Если СвойстваВладельца = Неопределено Тогда
		СвойстваВладельца = СвойстваВладельцаСчета(ВладелецСчета, Период);
	КонецЕсли;
	
	Если СвойстваБанковскогоСчета = Неопределено Тогда
		СвойстваБанковскогоСчета = СвойстваБанковскогоСчета(БанковскийСчет);
	КонецЕсли;
	
	Если ЭтоОрганизация И Не ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ЭтоЮрЛицо(ВладелецСчета) Тогда
		Если ПеречислениеВБюджет Тогда
			// 383-П:
			// Ф.И.О.  и  правовой  статус [//Адрес регистрации//] [счет в банке-корреспонденте]
			//ЮридическийАдрес =
			//	УправлениеНебольшойФирмойЭлектронныеДокументыСервер.ПолучитьАдресИзКонтактнойИнформации(ВладелецСчета, "Юр");
			//
			//Наименование = ПлатежиВБюджетКлиентСервер.НаименованиеПлательщикаИндивидуальногоПредпринимателя(
			//	Справочники.Организации.ФамилияИмяОтчествоПредпринимателя(ВладелецСчета, Период),
			//	ЮридическийАдрес,
			//	Период);
				
			Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВладелецСчета, "НаименованиеПлательщикаПриПеречисленииНалогов");
		Иначе
			// 383-П:
			// для физических лиц - полностью фамилия, имя, отчество (если иное не вытекает из закона или национального обычая)
			// (далее - Ф.И.О.); для индивидуальных предпринимателей - Ф.И.О. и правовой статус;
			Наименование = СвойстваВладельца.НаименованиеДляПечатныхФорм;
		КонецЕсли;
	Иначе
		Наименование = СокрЛП(СвойстваВладельца.НаименованиеДляПечатныхФорм);
	КонецЕсли;

	Если ПустаяСтрока(Наименование) Тогда
		Наименование = СокрЛП(СвойстваВладельца.Наименование);
	КонецЕсли;

	Если ЗначениеЗаполнено(СвойстваБанковскогоСчета.БанкРасчетов)
			И ЗначениеЗаполнено(СвойстваБанковскогоСчета.Банк) Тогда
			
		СвойстваБанка  = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СвойстваБанковскогоСчета.Банк, "Наименование, Город");
		
		Наименование = СокрЛП(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 р/с %2 в %3 %4'"),
			Наименование, СвойстваБанковскогоСчета.НомерСчета, СокрЛП(СвойстваБанка.Наименование), СвойстваБанка.Город));
			
	КонецЕсли;
		
	Возврат Наименование;
	
КонецФункции

// Формируется текст плательщика или получателя для печатной формы платежного документа
//
// Параметры
//  ТекстНаименования  	- <строка> - значение реквизита документа, если реквизит заполнен, он и выводится на печать
//  ВладелецСчета  		- <СправочникСсылка.Организации>/<СправочникСсылка.Контрагенты> - владелец банковского счета
//  БанковскийСчет		- <СправочникСсылка.БанковскиеСчета> - банковский счет плательщика или получателя
//  ПеречислениеВБюджет	- <Булево> - флаг перечисления в бюджет
//
// Возвращаемое значение:
//   <Строка>			- наименование плательщика или получателя, которое будет выводиться в печатной форме платежного документа
//
Функция СформироватьТекстНаименованияПлательщикаПолучателя(ТекстНаименования, ВладелецСчета, БанковскийСчет, ПеречислениеВБюджет = Ложь, Период = Неопределено) Экспорт
	
	ТекстРезультат = ТекстНаименования;
	Если ПустаяСтрока(ТекстРезультат) Тогда
		
		ЭтоОрганизация = ТипЗнч(ВладелецСчета) = Тип("СправочникСсылка.Организации");
		
		СвойстваВладельца = СвойстваВладельцаСчета(ВладелецСчета, Период);
		
		СвойстваБанковскогоСчета = СвойстваБанковскогоСчета(БанковскийСчет);
		
		Если ЭтоОрганизация И ПеречислениеВБюджет
			И НЕ ПустаяСтрока(СвойстваВладельца.НаименованиеПлательщикаПриПеречисленииВБюджет) Тогда
			
			ТекстРезультат = СокрЛП(СвойстваВладельца.НаименованиеПлательщикаПриПеречисленииВБюджет);
			
		ИначеЕсли ПустаяСтрока(СвойстваБанковскогоСчета.ТекстКорреспондента) Тогда
			
			ТекстРезультат = НаименованиеПлательщикаПолучателяПоУмолчанию(
				ВладелецСчета,
				БанковскийСчет,
				ПеречислениеВБюджет,
				Период,
				СвойстваВладельца,
				СвойстваБанковскогоСчета);
			
		Иначе
			
			ТекстРезультат = СокрЛП(СвойстваБанковскогоСчета.ТекстКорреспондента);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ТекстРезультат;
	
КонецФункции // СформироватьТекстНаименованияПлательщикаПолучателя

// Формирует значения по умолчанию реквизитов плательщика и получателя для банковских платежных документов
//
// Параметры
//  Плательщик  		- <СправочникСсылка.Организации>/<СправочникСсылка.Контрагенты> - плательщик, владелец банковского счета
//  СчетПлательщика		- <СправочникСсылка.БанковскиеСчета> - банковский счет плательщика
//  Получатель  		- <СправочникСсылка.Организации>/<СправочникСсылка.Контрагенты> - получатель, владелец банковского счета
//  СчетПолучателя		- <СправочникСсылка.БанковскиеСчета> - банковский счет получателя
//  ПеречислениеВБюджет	- <Булево> - флаг перечисления в бюджет
//
// Возвращаемое значение:
//   <Структура>		- структура строковых реквизитов плательщика и получателя
//						  ключи структуры: 
//							ТекстПлательщика, ИННПлательщика, КПППлательщика, 
//							ТекстПолучателя, ИННПолучателя, КПППолучателя
//							НаименованиеБанкаПлательщика, НомерСчетаПлательщика, БикБанкаПлательщика, СчетБанкаПлательщика 
//							НаименованиеБанкаПолучателя, НомерСчетаПолучателя, БикБанкаПолучателя, СчетБанкаПолучателя
//
Функция СформироватьАвтоЗначенияРеквизитовПлательщикаПолучателя(Плательщик, СчетПлательщика, Получатель, СчетПолучателя, ПеречислениеВБюджет = Ложь, Период = Неопределено, РегистрацияВНалоговомОргане = Неопределено, Должник = Неопределено) Экспорт
	
	ЗначенияРеквизитов = Новый Структура;
	
	Если ЗначениеЗаполнено(Плательщик) Тогда
		СвойстваПлательщика = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Плательщик,
			"ИНН");
		Если ТипЗнч(Плательщик) = Тип("СправочникСсылка.Контрагенты") Тогда
			СвойстваПлательщика.Вставить("ВидКонтрагента", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Плательщик, "ВидКонтрагента"));
			СвойстваПлательщика.Вставить("КПП", Справочники.Контрагенты.КППНаДату(Плательщик, Период));
		ИначеЕсли ТипЗнч(Плательщик) = Тип("СправочникСсылка.Организации") Тогда
			СвойстваПлательщика.Вставить("ВидКонтрагента", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Плательщик, "ЮридическоеФизическоеЛицо"));
			СвойстваПлательщика.Вставить("КПП", Справочники.Организации.КППНаДату(Плательщик, Период));
		Иначе
			СвойстваПлательщика.Вставить("КПП", ""); // физ.лицо или не поддерживаемый тип
		КонецЕсли;
	Иначе
		СвойстваПлательщика = Новый Структура("ВидКонтрагента, ИНН, КПП",
			Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо, "", "");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РегистрацияВНалоговомОргане) Тогда
		СвойстваПлательщика.Вставить("КПП", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РегистрацияВНалоговомОргане, "КПП"));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СчетПлательщика) Тогда
		СвойстваСчетаПлательщика = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СчетПлательщика,
			"Владелец, Банк, НомерСчета, БанкРасчетов, ВариантУказанияКПП");
	Иначе
		СвойстваСчетаПлательщика = Новый Структура("Владелец, Банк, НомерСчета, БанкРасчетов, ВариантУказанияКПП",
			Неопределено, СчетПлательщика.Банк, "", СчетПлательщика.БанкРасчетов, Ложь);
	КонецЕсли;
	
	ПолучательНерезидент = Ложь;
	ПолучательГосударственныйОрган = Ложь;
	Если ЗначениеЗаполнено(Получатель) Тогда
		Если ТипЗнч(Получатель) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
			СвойстваПолучателя = Новый Структура("ВидКонтрагента, ИНН, КПП",
				Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо, Получатель.ИНН, "");
		Иначе
			СвойстваПолучателя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Получатель,
				"ИНН");
			Если ТипЗнч(Получатель) = Тип("СправочникСсылка.Контрагенты") Тогда
				СвойстваПолучателя.Вставить("ВидКонтрагента", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Получатель, "ВидКонтрагента"));
				СвойстваПолучателя.Вставить("КПП", Справочники.Контрагенты.КППНаДату(Получатель, Период));
				РеквизитыПолучателя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Получатель, "СтранаРегистрации, КодГосударственногоОргана, ГоловнойКонтрагент");
				ПолучательНерезидент = РеквизитыПолучателя.СтранаРегистрации <> Справочники.СтраныМира.Россия;
				ПолучательГосударственныйОрган = ЗначениеЗаполнено(РеквизитыПолучателя.КодГосударственногоОргана);
				Если Не ПолучательГосударственныйОрган Тогда
					ПолучательГосударственныйОрган = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РеквизитыПолучателя.ГоловнойКонтрагент, "КодГосударственногоОргана");
				КонецЕсли;
			Иначе
				СвойстваПолучателя.Вставить("ВидКонтрагента", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Получатель, "ЮридическоеФизическоеЛицо"));
				СвойстваПолучателя.Вставить("КПП", Справочники.Организации.КППНаДату(Получатель, Период));
			КонецЕсли;
		КонецЕсли;
	Иначе
		СвойстваПолучателя = Новый Структура("ВидКонтрагента, ИНН, КПП",
			Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо, "", "");
	КонецЕсли;
	
	ПеречислениеПоИсполнительномуДокументу = Ложь;
	Если ЗначениеЗаполнено(Должник) Тогда
		ПеречислениеПоИсполнительномуДокументу = Истина;
		Если ПолучательГосударственныйОрган Тогда
			ИННДолжника = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Должник, "ИНН");
			Если ПустаяСтрока(ИННДолжника) Тогда
				СвойстваПлательщика.Вставить("ИНН", "0");
			Иначе
				СвойстваПлательщика.Вставить("ИНН", ИННДолжника);
			КонецЕсли;
			СвойстваПлательщика.Вставить("КПП", "0");
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СчетПолучателя) Тогда
		СвойстваСчетаПолучателя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СчетПолучателя,
			"Владелец, Банк, НомерСчета, БанкРасчетов, ВариантУказанияКПП, ТекстНазначения");
	Иначе
		СвойстваСчетаПолучателя = Новый Структура("Владелец, Банк, НомерСчета, БанкРасчетов, ВариантУказанияКПП, ТекстНазначения",
			Неопределено, СчетПолучателя.Банк, "", СчетПолучателя.БанкРасчетов, Ложь, "");
	КонецЕсли;
	
	УплатаНалогаЗаТретьихЛиц = ПеречислениеВБюджет И ТипЗнч(Плательщик) = Тип("СправочникСсылка.Контрагенты");
	
	ОрганизацияПлательщик = Плательщик;
	Если УплатаНалогаЗаТретьихЛиц Тогда
		ПлательщикВБюджетИП = СвойстваПлательщика.ВидКонтрагента = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
		ОрганизацияПлательщик = СвойстваСчетаПлательщика.Владелец;
	Иначе
		ПлательщикВБюджетИП = ТипЗнч(Плательщик) = Тип("СправочникСсылка.Организации") И
			СвойстваПлательщика.ВидКонтрагента = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
	КонецЕсли;
	
	ЗначенияРеквизитов.Вставить("ТекстПлательщика",
		СформироватьТекстНаименованияПлательщикаПолучателя(
			"",
			ОрганизацияПлательщик,
			СчетПлательщика,
			ПеречислениеВБюджет Или ПеречислениеПоИсполнительномуДокументу,
			Период));
	
	Если (ПеречислениеВБюджет И ПлательщикВБюджетИП И ПустаяСтрока(СвойстваПлательщика.ИНН))
		И Не ПеречислениеПоИсполнительномуДокументу Тогда
		// Если платеж в бюджет, то согласно Приказу Минфина РФ от 12.11.2013 N 107н если у ИП нет ИНН, проставляется "0"
		ЗначенияРеквизитов.Вставить("ИННПлательщика", "0");
	Иначе
		ЗначенияРеквизитов.Вставить("ИННПлательщика", СвойстваПлательщика.ИНН);
	КонецЕсли;
	
	ВариантУказанияКПППлательщика = ПеречислениеВБюджет ИЛИ СвойстваСчетаПлательщика.ВариантУказанияКПП И НЕ ПлательщикВБюджетИП;
	ЗначенияРеквизитов.Вставить("ВариантУказанияКПППлательщика", ВариантУказанияКПППлательщика);
	ЗначенияРеквизитов.Вставить("КПППлательщика",
		?(ВариантУказанияКПППлательщика,
		// Если платеж в бюджет, то согласно Приказу Минфина РФ от 12.11.2013 N 107н если это ИП, то в поле КПП проставляется "0"
		?(ПлательщикВБюджетИП, "0", СвойстваПлательщика.КПП),
		""));
	
	ПереводНаДругойСчет = ЗначениеЗаполнено(СчетПлательщика)
		И (СвойстваСчетаПолучателя.Владелец = СвойстваСчетаПлательщика.Владелец);
	Если ПереводНаДругойСчет Тогда
		ВладелецСчетаПолучателя = Плательщик;
		СвойстваВладельцаСчетаПолучателя = СвойстваПлательщика;
	Иначе
		ВладелецСчетаПолучателя = Получатель;
		СвойстваВладельцаСчетаПолучателя = СвойстваПолучателя;
	КонецЕсли;
	
	ЗначенияРеквизитов.Вставить("ТекстПолучателя",
		СформироватьТекстНаименованияПлательщикаПолучателя(
			"",
			ВладелецСчетаПолучателя,
			СчетПолучателя,
			ПеречислениеВБюджет Или ПеречислениеПоИсполнительномуДокументу,
			Период));
	
	ПолучательФизЛицо = СвойстваВладельцаСчетаПолучателя.ВидКонтрагента = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
	
	Если ПолучательФизЛицо И ПустаяСтрока(СвойстваВладельцаСчетаПолучателя.ИНН) Тогда
		// У получателя - физического лица (или ИП) может не быть ИНН,
		// в этом случае действуем так, как рекомендуется поступать в Приказу Минфина РФ от 12.11.2013 N 107н
		// когда у ИП отсутствует ИНН. Проставляем "0" - в этом случае проверка на заполенность ИНН не будет срабатывать.
		ЗначенияРеквизитов.Вставить("ИННПолучателя", "0");
	ИначеЕсли ПолучательНерезидент И ПустаяСтрока(СвойстваВладельцаСчетаПолучателя.ИНН) Тогда
		ЗначенияРеквизитов.Вставить("ИННПолучателя", "0");
	Иначе
		ЗначенияРеквизитов.Вставить("ИННПолучателя", СвойстваВладельцаСчетаПолучателя.ИНН);
	КонецЕсли;
	
	ВариантУказанияКПППолучателя = ПеречислениеВБюджет ИЛИ СвойстваСчетаПолучателя.ВариантУказанияКПП;
	ЗначенияРеквизитов.Вставить("ВариантУказанияКПППолучателя", ВариантУказанияКПППолучателя);
	ЗначенияРеквизитов.Вставить("КПППолучателя",
		?(ВариантУказанияКПППолучателя,
		?(НЕ ПустаяСтрока(СвойстваВладельцаСчетаПолучателя.КПП), СвойстваВладельцаСчетаПолучателя.КПП, "0"),
		""));
	
	НепрямыеРасчетыУПлательщика = ЗначениеЗаполнено(СвойстваСчетаПлательщика.БанкРасчетов);
	БанкПлательщика = ?(НепрямыеРасчетыУПлательщика, СвойстваСчетаПлательщика.БанкРасчетов, СвойстваСчетаПлательщика.Банк);
	Если ЗначениеЗаполнено(БанкПлательщика) Тогда
		ЗначенияРеквизитов.Вставить("НаименованиеБанкаПлательщика",
			СокрЛП(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 %2'"),
				БанкПлательщика.Наименование, БанкПлательщика.Город)));
		ЗначенияРеквизитов.Вставить("НомерСчетаПлательщика",
			?(НепрямыеРасчетыУПлательщика, СвойстваСчетаПлательщика.Банк.КоррСчет, СвойстваСчетаПлательщика.НомерСчета));
		ЗначенияРеквизитов.Вставить("БикБанкаПлательщика",  БанкПлательщика.Код);
		ЗначенияРеквизитов.Вставить("СчетБанкаПлательщика", БанкПлательщика.КоррСчет);
	Иначе
		ЗначенияРеквизитов.Вставить("НаименованиеБанкаПлательщика", "");
		ЗначенияРеквизитов.Вставить("НомерСчетаПлательщика",        "");
		ЗначенияРеквизитов.Вставить("БикБанкаПлательщика",          "");
		ЗначенияРеквизитов.Вставить("СчетБанкаПлательщика",         "");
	КонецЕсли;
	
	НепрямыеРасчетыУПолучателя = ЗначениеЗаполнено(СвойстваСчетаПолучателя.БанкРасчетов);
	БанкПолучателя = ?(НепрямыеРасчетыУПолучателя, СвойстваСчетаПолучателя.БанкРасчетов, СвойстваСчетаПолучателя.Банк);
	
	Если ЗначениеЗаполнено(БанкПолучателя) Тогда
		СвойстваБанкаПолучателя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(БанкПолучателя,
			"Код, Наименование, КоррСчет, Город");
	Иначе
		СвойстваБанкаПолучателя = Новый Структура("Код, Наименование, КоррСчет, Город", "", "", "", "");
	КонецЕсли;
	
	ЗначенияРеквизитов.Вставить("НаименованиеБанкаПолучателя",
		СокрЛП(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 %2'"),
			СвойстваБанкаПолучателя.Наименование, СвойстваБанкаПолучателя.Город)));
	ЗначенияРеквизитов.Вставить("НомерСчетаПолучателя",
		?(НепрямыеРасчетыУПолучателя, ?(ЗначениеЗаполнено(СвойстваСчетаПолучателя.Банк),
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СвойстваСчетаПолучателя.Банк, "КоррСчет"), ""),
			СвойстваСчетаПолучателя.НомерСчета));
	ЗначенияРеквизитов.Вставить("БикБанкаПолучателя",     СвойстваБанкаПолучателя.Код);
	ЗначенияРеквизитов.Вставить("СчетБанкаПолучателя",    СвойстваБанкаПолучателя.КоррСчет);
	ЗначенияРеквизитов.Вставить("ТекстНазначенияПлатежа", СвойстваСчетаПолучателя.ТекстНазначения);
	
	Возврат ЗначенияРеквизитов;
	
КонецФункции //СформироватьАвтоЗначенияРеквизитовПлательщикаПолучателя

// Устанавливает банковский счет по умолчанию. Возвращает состояние установлен/не установлен
//
// Параметры:
//  Счет             - СправочникСсылка.БанковскиеСчета - текущее значение счета.
//  ВладелецСчета    - СправочникСсылка.Контрагенты, СправочникСсылка.Организации, СправочникСсылка.ФизическиеЛица -
//                     Контрагент (Организация, Физлицо), счет которого нужно получить.
//  Валюта           - СправочникСсылка.Валюты - валюта счета.
//  СовпадениеВалюты - Булево - признак совпадения нужной валюты с указанной, либо исключения ее из поиска.
//                     По умолчанию ищем счет с указанной валютой.
//  УчитыватьВалюту -  Булево - признак необходмости учитывать валюту при поиске счета.
//                     По умолчанию при поиске учитываем валюту.
//  НомерСчета      -  Строка - Точный номер счета для поиска
//                     По умолчанию не учитывается.
//
// ВозвращаемоеЗначение:
//  Булево - установлен / не установлен счет по умолчанию
//
Функция УстановитьБанковскийСчет(Счет, ВладелецСчета, Валюта, СовпадениеВалюты = Истина, УчитыватьВалюту = Истина, НомерСчета = Неопределено) Экспорт
	
	Если ТипЗнч(Счет) <> Тип("СправочникСсылка.БанковскиеСчета") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	НовыйСчет = Справочники.БанковскиеСчета.ПустаяСсылка();
	Если НЕ ЗначениеЗаполнено(ВладелецСчета) Тогда
		ПолучитьНовыйСчет = Счет <> НовыйСчет;
		Счет = НовыйСчет;
		Возврат ПолучитьНовыйСчет;
	КонецЕсли;
	
	ПриведенныйНомерСчета = "";
	Если ЗначениеЗаполнено(НомерСчета) Тогда
		ТипСтрока = ОбщегоНазначения.ОписаниеТипаСтрока(БанковскиеПравила.МаксимальнаяДлинаМеждународногоНомераСчета());
		ПриведенныйНомерСчета = ТипСтрока.ПривестиЗначение(НомерСчета);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	БанковскиеСчета.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА СправочникВладелец.Ссылка ЕСТЬ НЕ NULL 
	|			ТОГДА 1
	|		ИНАЧЕ 2
	|	КОНЕЦ КАК Приоритет
	|ИЗ
	|	Справочник.БанковскиеСчета КАК БанковскиеСчета
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК СправочникВладелец
	|		ПО БанковскиеСчета.Владелец = СправочникВладелец.Ссылка
	|			И БанковскиеСчета.Ссылка = СправочникВладелец.БанковскийСчетПоУмолчанию
	|ГДЕ
	|	БанковскиеСчета.Владелец = &ВладелецСчета
	|	И БанковскиеСчета.ПометкаУдаления = ЛОЖЬ
	|	И (&УчитыватьВалюту = ЛОЖЬ
	|			ИЛИ (БанковскиеСчета.ВалютаДенежныхСредств = &Валюта
	|					И &СовпадениеВалюты = ИСТИНА
	|				ИЛИ НЕ БанковскиеСчета.ВалютаДенежныхСредств = &Валюта
	|					И &СовпадениеВалюты = ЛОЖЬ))
	|	И (&УчитыватьНомерСчета = ЛОЖЬ
	|			ИЛИ БанковскиеСчета.НомерСчета = &НомерСчета)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет";
	
	Запрос.УстановитьПараметр("ВладелецСчета",       ВладелецСчета);
	Запрос.УстановитьПараметр("Валюта",              Валюта);
	Запрос.УстановитьПараметр("СовпадениеВалюты",    СовпадениеВалюты);
	Запрос.УстановитьПараметр("УчитыватьВалюту",     УчитыватьВалюту);
	Запрос.УстановитьПараметр("УчитыватьНомерСчета", ЗначениеЗаполнено(ПриведенныйНомерСчета));
	Запрос.УстановитьПараметр("НомерСчета",          ПриведенныйНомерСчета);
	
	Если ТипЗнч(ВладелецСчета) = Тип("СправочникСсылка.Контрагенты") Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Справочник.Организации", "Справочник.Контрагенты");
	ИначеЕсли ТипЗнч(ВладелецСчета) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Справочник.Организации", "Справочник.ФизическиеЛица");
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	Результат    = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		НайденОсновнойСчет = Выборка.Приоритет = 1;
		НайденОдинСчет     = Выборка.Количество() = 1;
		
		Если НайденОсновнойСчет ИЛИ НайденОдинСчет Тогда
			НовыйСчет = Выборка.Ссылка;
		КонецЕсли;
		
	КонецЕсли;
	
	ПолучитьНовыйСчет = Счет <> НовыйСчет;
	Если ПолучитьНовыйСчет Тогда
		Если НЕ ЗначениеЗаполнено(Счет) Тогда
			Счет = НовыйСчет;
		Иначе
			СвойствоСчета = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Счет, "Владелец, ВалютаДенежныхСредств");
			Если СвойствоСчета.Владелец <> ВладелецСчета
				ИЛИ СовпадениеВалюты И СвойствоСчета.ВалютаДенежныхСредств <> Валюта Тогда
				Счет = НовыйСчет;
			Иначе
				ПолучитьНовыйСчет = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПолучитьНовыйСчет;
	
КонецФункции // УстановитьБанковскийСчет

// Возвращает список программ типа "Клиент банка", имеющих сертификат 1С:Совместимо
//
// Параметры
//  Нет
//
// Возвращаемое значение:
//   <СписокЗначений>   - список наименований программ
//
Функция СписокСовместимыхПрограммКлиентовБанка(ВернутьВМассиве = Истина) Экспорт

	Если ВернутьВМассиве Тогда
		СписокКБ = Новый Массив;
	Иначе
		СписокКБ = Новый СписокЗначений;
	КонецЕсли; 
	
	СписокКБ.Добавить("DiasoftCLIENT 4x4 for Windows ЗАО ""Диасофт""");
	СписокКБ.Добавить("iBank 2 компании ""БИФИТ""");
	СписокКБ.Добавить("isFront - Система дистанционного управления финансами");
	СписокКБ.Добавить("LanVisit DOS 4.90 Ланит");
	СписокКБ.Добавить("On-Soft Клиент-Банк КБ ""ЛОКО-Банк""");
	СписокКБ.Добавить("WinClient ЗАО ""МПИ-Банк""");
	СписокКБ.Добавить("Yugo-Vostok Online ОАО БАНК ""ЮГО-ВОСТОК""");
	СписокКБ.Добавить("АРМ ""Клиент"" АС ""Клиент-Сбербанк"" Сбербанка России");
	СписокКБ.Добавить("АРМ ""Электронный клиент"" от НОМОС-БАНК-Сибирь");
	СписокКБ.Добавить("ИНИСТ Банк-Клиент ЗАО ""ИНИСТ""");
	СписокКБ.Добавить("Клиент банка InterBank v.5.1 R-Style Software Lab");
	СписокКБ.Добавить("Клиент-банк ""BARS"" фирмы ""Оникс Капитал""");
	СписокКБ.Добавить("Клиент-банк АКБ ""Лефко-Банк""");
	СписокКБ.Добавить("Клиент-банк ""МИБ"" АКБ ""Московский Индустриальный банк""");
	СписокКБ.Добавить("Клиент-Банк ОАО ""Прио-Внешторгбанк""");	
	СписокКБ.Добавить("Клиент-Банк РФК");
	СписокКБ.Добавить("Клиент-ТЕЛЕБАНК ЗАО ""Степ Ап""");
	СписокКБ.Добавить("Комплекс обмена платежными документами ""Курьер"". ЗАО ""АстраСофт""");
	СписокКБ.Добавить("Система ""MailBank"" фирмы ""Системные технологии""");
	СписокКБ.Добавить("Система ""PSB On-Line"" ОАО ""ПРОМСВЯЗЬБАНК""");
	СписокКБ.Добавить("Система ""ВЕДАНА"" фирмы ""Анива""");
	СписокКБ.Добавить("Система ""ДБО BS-Client"" ООО ""Банк Софт Системс""");
	СписокКБ.Добавить("Система ""Клиент-Банк Плюс"" ОАО ""Уралвнешторгбанка""");
	СписокКБ.Добавить("Система ""Клиент-Банк"" ЗАО ""Банк ""Новый Символ""");
	СписокКБ.Добавить("Система ""Электронный Офис"" ЗАО ""Райффайзенбанк""");
	СписокКБ.Добавить("Система ""Электронный Офис"" ОАО ""ИМПЭКСБАНК""");
	СписокКБ.Добавить("Система Банк-Клиент АКБ ""София""");
	СписокКБ.Добавить("Система Клиент-Банк ""BClient""");
	СписокКБ.Добавить("Система клиент-банк ""TIVAL""");
	СписокКБ.Добавить("Система электронных расчетов QuickPay ЗАО ""АО Кворум""");
	СписокКБ.Добавить("ЦФТ - Интернет-банк (Faktura.ru) фирмы ""Центр финансовых технологий""");
	СписокКБ.Добавить("Электронный клиент АКБ ""Автобанк""");
	
	Возврат СписокКБ;
	
КонецФункции 

// Возвращает значение Статьи движения денежных средств по умолчанию, в зависимости от контекста операции
//
// Параметры
//  КонтекстОперации    - <Строка>/<ПеречисленияСсылка> - Вид операции документа или строковая константа, однозначно
//                                /                       идентифицирующая вид операции
//
// Возвращаемое значение:
//   <СправочникСсылка.СтатьиДвиженияДенежныхСредств>		- Ссылка на предопределенный элемент справочника или пустая ссылка
Функция СтатьяДДСПоУмолчанию(Знач КонтекстОперации) Экспорт
	
	Возврат Справочники.СтатьиДвиженияДенежныхСредств.ПустаяСсылка();

КонецФункции
#КонецОбласти
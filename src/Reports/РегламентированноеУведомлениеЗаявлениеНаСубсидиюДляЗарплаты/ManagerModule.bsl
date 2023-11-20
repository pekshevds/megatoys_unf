#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Истина;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Истина;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2020_1";
	Стр.ОписаниеФормы = "Уведомление об изменении порядка исчисления авансов по налогу на прибыль в соответствии с приказом письмом Минфина России от 27.04.2020 № БС-4-11/7080@.";
	Стр.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаСубсидиюДляЗарплаты;
	Стр.ПутьФормы = "Отчет.РегламентированноеУведомлениеЗаявлениеНаСубсидиюДляЗарплаты.Форма.Форма2020_1";
	
	Возврат Результат;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2020_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2020_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
КонецФункции

Функция СформироватьСписокЛистов(Объект) Экспорт
	Если Объект.ИмяФормы = "Форма2020_1" Тогда 
		Возврат СформироватьСписокЛистовФорма2020_1(Объект);
	КонецЕсли;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт 
	Если ИмяФормы = "Форма2020_1" Тогда 
		Возврат ПроверитьДокументСВыводомВТаблицу_Форма2020_1(Объект, УведомлениеОСпецрежимахНалогообложения.ДанныеУведомленияДляВыгрузки(Объект), УникальныйИдентификатор);
	КонецЕсли;
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2020_1(СведенияОтправки)
	Префикс = "NO_ZVSUBPP";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу_Форма2020_1(Объект, Данные, УникальныйИдентификатор)
	ТаблицаОшибок = Новый СписокЗначений;
	УведомлениеОСпецрежимахНалогообложения.ПроверкаАктуальностиФормыПриВыгрузке(
		Данные.Объект.ИмяФормы, ТаблицаОшибок, ПолучитьТаблицуФорм());
	
	Титульная = Данные.ДанныеУведомления.Титульная;
	УведомлениеОСпецрежимахНалогообложения.ПроверкаИННКПП(
		РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Данные.Организация), Титульная, ТаблицаОшибок);
	
	УведомлениеОСпецрежимахНалогообложения.ПроверкаКодаНО(Титульная.КодНО, ТаблицаОшибок, "Титульная");
	Если Не ЗначениеЗаполнено(Титульная.ДАТА_ПОДПИСИ) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указана дата подписи", "Титульная", "ДАТА_ПОДПИСИ"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.Наименование) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указано наименование организации / ФИО индивидуального предпринимателя", "Титульная", "Наименование"));
	КонецЕсли;
	Если (Титульная.ПРИЗНАК_НП_ПОДВАЛ = "2" Или ЗначениеЗаполнено(Титульная.НаимОрг)) И (Не ЗначениеЗаполнено(Титульная.НаимДок)) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Необходимо указать документ представителя", "Титульная", "НаимДок"));
	КонецЕсли;
	Если Титульная.ПРИЗНАК_НП_ПОДВАЛ <> "1" И Титульная.ПРИЗНАК_НП_ПОДВАЛ <> "2" Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Неправильно указан признак подписанта", "Титульная", "ПРИЗНАК_НП_ПОДВАЛ"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.НомерЗаяв) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указан номер заявления", "Титульная", "НомерЗаяв"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.КодМесяц) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указан код месяца", "Титульная", "КодМесяц"));
	ИначеЕсли Титульная.КодМесяц <> "04" И Титульная.КодМесяц <> "05" И Титульная.КодМесяц <> "0405" Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Неправильно указан код месяца", "Титульная", "КодМесяц"));
	КонецЕсли;
	Если (Титульная.ПРИЗНАК_НП_ПОДВАЛ = "2" Или РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Данные.Организация)) Тогда 
		УведомлениеОСпецрежимахНалогообложения.ПроверкаПодписантаНалоговойОтчетности(Данные, ТаблицаОшибок, "Титульная", Истина);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульная.НаимБанк) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указано наименование банка", "Титульная", "НаимБанк"));
	КонецЕсли;
	УведомлениеОСпецрежимахНалогообложения.ПроверкаИНН(Титульная, ТаблицаОшибок, "Титульная", "ИННЮЛ_Банк", Истина, Истина);
	УведомлениеОСпецрежимахНалогообложения.ПроверкаКПП(Титульная, ТаблицаОшибок, "Титульная", "КПП_Банк", Истина);
	Если Не ЗначениеЗаполнено(Титульная.БИК)
		Или СтрДлина(Титульная.БИК) <> 9
		Или Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Титульная.БИК) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Неправильно указан БИК банка", "Титульная", "БИК"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.НаимСчет) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указано наименование счета", "Титульная", "НаимСчет"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.КорСчет) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указано корреспондентский счет", "Титульная", "КорСчет"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.НомСчет) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указано номер счета", "Титульная", "НомСчет"));
	КонецЕсли;
	
	Если (Титульная.ФлОрг = Ложь Или Титульная.ФлОрг = Неопределено) И (Титульная.ФлИП = Ложь Или Титульная.ФлИП = Неопределено) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указан получатель", "Титульная", "ФлОрг"));
	ИначеЕсли Титульная.ФлОрг = Истина Тогда
		Если Не ЗначениеЗаполнено(Титульная.ПолучОрг) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указана организация-получатель", "Титульная", "ПолучОрг"));
		КонецЕсли;
	ИначеЕсли Титульная.ФлИП = Истина Тогда
		Если Не ЗначениеЗаполнено(Титульная.ФамилияПолучатель) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указана фамилия получателя", "Титульная", "ФамилияПолучатель"));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Титульная.ИмяПолучатель) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указано имя получателя", "Титульная", "ИмяПолучатель"));
		КонецЕсли;
	КонецЕсли;
	Возврат ТаблицаОшибок;
КонецФункции

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2020_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Документы.УведомлениеОСпецрежимахНалогообложения.НачальнаяИнициализацияОбщихРеквизитовВыгрузки(Объект);
	
	Данные = Объект.ДанныеУведомления.Получить();
	ОсновныеСведения.Вставить("ФлОрг", ?(Данные.ДанныеУведомления.Титульная.ФлОрг = Истина, Истина, Ложь));
	ОсновныеСведения.Вставить("ФлИП", ?(Данные.ДанныеУведомления.Титульная.ФлИП = Истина, Истина, Ложь));
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2020_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2020_1(Объект, УникальныйИдентификатор)
	СведенияЭлектронногоПредставления = УведомлениеОСпецрежимахНалогообложения.СведенияЭлектронногоПредставления();
	ДанныеУведомления = УведомлениеОСпецрежимахНалогообложения.ДанныеУведомленияДляВыгрузки(Объект);
	Ошибки = ПроверитьДокументСВыводомВТаблицу_Форма2020_1(Объект, ДанныеУведомления, УникальныйИдентификатор);
	УведомлениеОСпецрежимахНалогообложения.СообщитьОшибкиПриПроверкеВыгрузки(Объект, Ошибки, ДанныеУведомления);
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2020_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2020_1");
	УведомлениеОСпецрежимахНалогообложения.ТиповоеЗаполнениеДанными(ДанныеУведомления, ОсновныеСведения, СтруктураВыгрузки);
	УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВТаблицу(СтруктураВыгрузки, ОсновныеСведения, СведенияЭлектронногоПредставления);
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Функция СформироватьСписокЛистовФорма2020_1(Объект) Экспорт
	Листы = Новый СписокЗначений;
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	СтруктураПараметров = Объект.Ссылка.ДанныеУведомления.Получить();
	Титульная = СтруктураПараметров.ДанныеУведомления.Титульная;
	Титульная.Вставить("Наим1", Титульная.Наименование);
	Титульная.Вставить("Наим3", Титульная.Наименование);
	Если Титульная.ФлОрг = Истина Тогда 
		Титульная.Вставить("Наим4", Титульная.ПолучОрг);
	ИначеЕсли Титульная.ФлИП = Истина Тогда
		Титульная.Вставить("Наим4", Титульная.ФамилияПолучатель + " " + Титульная.ИмяПолучатель +  " " + Титульная.ОтчествоПолучатель);
	КонецЕсли;
	Титульная.Вставить("ДатаПодписи", Формат(Титульная.ДАТА_ПОДПИСИ, "ДЛФ=DD"));
	Титульная.Вставить("Рук", Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
	Титульная.Вставить("ИННКПП", Титульная.ИНН + ?(ЗначениеЗаполнено(Титульная.КПП), " / " + Титульная.КПП, ""));
	
	МакетПФ = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Печать_Форма2020_1");
	Инд = 0;
	НомСтр = 1;
	Пока Истина Цикл 
		Инд = Инд + 1;
		Если МакетПФ.Области.Найти("Часть" + Инд) = Неопределено Тогда 
			Прервать;
		КонецЕсли;
		ОблЧ = МакетПФ.ПолучитьОбласть("Часть" + Инд);
		Для Каждого ОблПодч Из ОблЧ.Области Цикл 
			Если ОблПодч.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник
				И ОблПодч.СодержитЗначение = Истина 
				И Титульная.Свойство(ОблПодч.Имя) Тогда 
				
				ОблПодч.Значение = Титульная[ОблПодч.Имя];
			КонецЕсли;
		КонецЦикла;
		
		ПечатнаяФорма.Вывести(ОблЧ);
	КонецЦикла;
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
	Возврат Листы;
КонецФункции

Процедура КонвертацияИзРегламентированногоОтчета(ВыборкаСтрока) Экспорт
	Попытка
		Если ВыборкаСтрока.ВыбраннаяФорма = "ФормаОтчета2020Кв1" Тогда
			КонвертироватьНаСервере_2020(ВыборкаСтрока.Ссылка);
		КонецЕсли;
	Исключение
		ЗаписьЖурналаРегистрации("КонвертацияЗаявлениеНаСубсидиюДляЗарплаты", УровеньЖурналаРегистрации.Предупреждение);
	КонецПопытки;
КонецПроцедуры

Функция СформироватьПустоеДеревоСтраниц_2020(Организация)
	Дерево = УведомлениеОСпецрежимахНалогообложения.ПустоеДеревоСтраницУведомления();
	
	Стр001 = Дерево.Строки.Добавить();
	Стр001.Наименование = "Титульная страница";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Титульная";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Титульная";
	Стр001.МакетыПФ = "Печать_Форма2020_1_Титульная";
	Стр001.МногострочныеЧасти = Новый СписокЗначений;
	
	Возврат Дерево;
КонецФункции

Процедура КонвертироватьНаСервере_2020(РегОтчет)
	Попытка
		РО = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РегОтчет, "КодНалоговогоОргана,ДанныеОтчета,ДатаПодписи,Организация,Дата");
		ДанныеОтчета = РО.ДанныеОтчета.Получить();
		
		Уведомление = Документы.УведомлениеОСпецрежимахНалогообложения.СоздатьДокумент();
		Уведомление.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаСубсидиюДляЗарплаты;
		Уведомление.Организация = РО.Организация;
		Уведомление.ИмяОтчета = "РегламентированноеУведомлениеЗаявлениеНаСубсидиюДляЗарплаты";
		Уведомление.ИмяФормы = "Форма2020_1";
		Уведомление.ПодписантФамилия = ДанныеОтчета.ПоказателиОтчета.ПолеТабличногоДокументаТитульный.ПодпФ;
		Уведомление.ПодписантИмя = ДанныеОтчета.ПоказателиОтчета.ПолеТабличногоДокументаТитульный.ПодпИ;
		Уведомление.ПодписантОтчество = ДанныеОтчета.ПоказателиОтчета.ПолеТабличногоДокументаТитульный.ПодпО;
		Уведомление.ДатаПодписи = РО.Дата;
		Уведомление.Дата = ТекущаяДатаСеанса();
		
		ДанныеУведомления = Новый Структура;
		Титульный = Новый Структура;
		Для Каждого КЗ Из ДанныеОтчета.ПоказателиОтчета.ПолеТабличногоДокументаТитульный Цикл 
			Титульный.Вставить(КЗ.Ключ, КЗ.Значение);
		КонецЦикла;
		Титульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", СокрЛП(Титульный.ПодпФ + " " + Титульный.ПодпИ + " " + Титульный.ПодпО));
		ДанныеУведомления.Вставить("Титульная", Титульный);
		
		Уведомление.РегистрацияВИФНС = УведомлениеОСпецрежимахНалогообложенияПовтИсп.ПолучитьРегистрациюВИФНСПоКоду(
											Титульный.КодНО, РО.Организация);
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("ДеревоСтраниц", СформироватьПустоеДеревоСтраниц_2020(РО.Организация));
		СтруктураПараметров.Вставить("ДанныеУведомления", ДанныеУведомления);
		СтруктураПараметров.Вставить("РазрешитьВыгружатьСОшибками", Ложь);
		Уведомление.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Уведомление);
		
		ЗаписьСоответствия = РегистрыСведений["СоответствиеРегОтчетовУведомлениям"].СоздатьМенеджерЗаписи();
		ЗаписьСоответствия.РегОтчет = РегОтчет.Ссылка;
		ЗаписьСоответствия.Прочитать();
		ЗаписьСоответствия.РегОтчет = РегОтчет.Ссылка;
		ЗаписьСоответствия.Уведомление = Уведомление.Ссылка;
		ЗаписьСоответствия.Записать(Истина);
	Исключение
		ЗаписьЖурналаРегистрации("КонвертацияЗаявлениеНаСубсидиюДляЗарплаты", УровеньЖурналаРегистрации.Предупреждение);
	КонецПопытки;
КонецПроцедуры

#КонецОбласти
#КонецЕсли

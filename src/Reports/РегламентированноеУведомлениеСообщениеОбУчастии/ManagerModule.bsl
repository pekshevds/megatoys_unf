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
	Стр.ИмяФормы = "Форма2014_1";
	Стр.ОписаниеФормы = "С-09-2/приказ ФНС от 09.06.2011 N ММВ-7-6/362@";
	
	Возврат Результат;
КонецФункции

Функция ПечатьСразу(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат ПечатьСразуПолучениеПатентаРекомендованнаяФорма_Форма2014_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция СформироватьМакет(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат СформироватьМакет_Форма2014_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2014_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция СформироватьМакет_Форма2014_1(Объект)
	
	ПечатнаяФорма = Новый ТабличныйДокумент;
	МакетУведомления = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Печать_MXL_Форма2014_1");
	ПараметрыМакета = МакетУведомления.Параметры;
	СтруктураПараметров = Объект.ДанныеУведомления.Получить();
	
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.П_ИНН, "ИНН_", ПараметрыМакета, 12);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.П_КПП, "КПП_", ПараметрыМакета, 9);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.КОД_НО, "КОД_НО_", ПараметрыМакета, 4);
	Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(СтруктураПараметров.ДАТА_СООБЩЕНИЯ, "ДатаСообщения_", ПараметрыМакета);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.ОРГАНИЗАЦИЯ, "ОрганизацияНазвание_", ПараметрыМакета, 160);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.П_ОГРН, "ОГРН_", ПараметрыМакета, 13);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.П_ОГРНИП, "ОГРНИП_", ПараметрыМакета, 15);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.НАИМЕНОВАНИЕ_ЗАВИСИМОЙ_ОРГАНИЗАЦИИ, "ОргУчНазвание_", ПараметрыМакета, 160);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.ИНН_ЗАВИСИМОЙ, "ИННУчОрг_", ПараметрыМакета, 10);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.КПП_ЗАВИСИМОЙ, "КППУчОрг_", ПараметрыМакета, 9);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.ОКСМ, "ОКСМ_", ПараметрыМакета, 3);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(СтруктураПараметров.ПРИЛОЖЕНО_ЛИСТОВ, "ПриложеноЛистов_", ПараметрыМакета, 3);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоСРазделителемВПараметрыМакета(СтруктураПараметров.ПРОЦЕНТ_УЧАСТИЯ, 3, 15, "ПроцентУчастия_", ПараметрыМакета);
	ПараметрыМакета.ПризнакСообщения = СтруктураПараметров.ПРИЗНАК_СООБЩЕНИЯ;
	
	ПараметрыМакета.ПризнакПодписанта = СтруктураПараметров.ПРИЗНАК_НП_ПОДВАЛ;
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантФамилия, "ОргПодписантФамилия_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантИмя, "ОргПодписантИмя_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантОтчество, "ОргПодписантОтчество_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ, "ДокументПредставителя_", ПараметрыМакета, 40);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.ТЕЛЕФОН, "Телефон_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.ИНН_ПОДПИСАНТА, "ИНН_ПОДПИСАНТ_", ПараметрыМакета, 12);
	Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(Объект.ДатаПодписи, "ДатаПодписи_", ПараметрыМакета);
	ПараметрыМакета.Email = СтруктураПараметров.EMAIL_ПОДПИСАНТА;
	
	ПечатнаяФорма.Вывести(МакетУведомления);
	Возврат ПечатнаяФорма;
КонецФункции

Функция ПечатьСразуПолучениеПатентаРекомендованнаяФорма_Форма2014_1(Объект)
	
	ПечатнаяФорма = СформироватьМакет_Форма2014_1(Объект);
	
	ПечатнаяФорма.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.ОбластьПечати = ПечатнаяФорма.Область();
	
	Возврат ПечатнаяФорма;
	
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2014_1(СведенияОтправки)
	Префикс = "UT_SBUOR";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Процедура Проверить_Форма2014_1(Данные, УникальныйИдентификатор)
	Титульный = Данные;
	
	Если Не ЗначениеЗаполнено(Титульный.ПРИЗНАК_СООБЩЕНИЯ) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не заполнен признак сообщения", УникальныйИдентификатор);
		ВызватьИсключение "";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.ДАТА_СООБЩЕНИЯ) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не заполнена дата сообщения", УникальныйИдентификатор);
		ВызватьИсключение "";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.НАИМЕНОВАНИЕ_ЗАВИСИМОЙ_ОРГАНИЗАЦИИ) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не заполнено наименование зависимой организации", УникальныйИдентификатор);
		ВызватьИсключение "";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.ПРОЦЕНТ_УЧАСТИЯ) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не заполнен процент участия", УникальныйИдентификатор);
		ВызватьИсключение "";
	КонецЕсли;
	
	Если (Не ЗначениеЗаполнено(Титульный.П_ОГРН))
		И Не ЗначениеЗаполнено(Титульный.П_ОГРНИП)Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не заполнен ОГРН", УникальныйИдентификатор);
		ВызватьИсключение "";
	КонецЕсли;
	
	Если (Не ЗначениеЗаполнено(Титульный.ИНН_ЗАВИСИМОЙ))
		И Не ЗначениеЗаполнено(Титульный.КПП_ЗАВИСИМОЙ)
		И Не ЗначениеЗаполнено(Титульный.ОКСМ) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не заполнеы реквизиты зависимой организации", УникальныйИдентификатор);
		ВызватьИсключение "";
	КонецЕсли;
КонецПроцедуры

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2014_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Документы.УведомлениеОСпецрежимахНалогообложения.НачальнаяИнициализацияОбщихРеквизитовВыгрузки(Объект);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьОбщиеДанные(Объект, ОсновныеСведения);
	
	Данные = Объект.ДанныеУведомления.Получить();
	Проверить_Форма2014_1(Данные, УникальныйИдентификатор);
	Титульный = Данные;
	
	ОсновныеСведения.Вставить("ПрПодп",  Данные.ПРИЗНАК_НП_ПОДВАЛ);
	ОсновныеСведения.Вставить("ИННФЛ",   Данные.ИНН_ПОДПИСАНТА);
	ОсновныеСведения.Вставить("Тлф",     Данные.ТЕЛЕФОН);
	ОсновныеСведения.Вставить("НаимДок", Данные.ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ);
	ОсновныеСведения.Вставить("ДатаДок", Формат(Данные.ДАТА_ПОДПИСИ, "ДФ=dd.MM.yyyy"));
	ОсновныеСведения.Вставить("email",   Данные.EMAIL_ПОДПИСАНТА);
	ОсновныеСведения.Вставить("ПризСообщ", Данные.ПРИЗНАК_СООБЩЕНИЯ);
	ОсновныеСведения.Вставить("ДатаСообщ", Формат(Данные.ДАТА_СООБЩЕНИЯ, "ДФ=dd.MM.yyyy"));
	ОсновныеСведения.Вставить("НаимУчОрг", Данные.НАИМЕНОВАНИЕ_ЗАВИСИМОЙ_ОРГАНИЗАЦИИ);
	ОсновныеСведения.Вставить("ДоляУчОрг", Данные.ПРОЦЕНТ_УЧАСТИЯ);
	ОсновныеСведения.Вставить("ИННУчОрг",  Данные.ИНН_ЗАВИСИМОЙ);
	ОсновныеСведения.Вставить("КППУчОрг",  Данные.КПП_ЗАВИСИМОЙ);
	ОсновныеСведения.Вставить("ОКСМУчОрг", Данные.ОКСМ);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2014_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2014_1(Объект, УникальныйИдентификатор)
	СведенияЭлектронногоПредставления = УведомлениеОСпецрежимахНалогообложения.СведенияЭлектронногоПредставления();
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2014_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2014_1");
	ЗаполнитьДанными_Форма2014_1(Объект, ОсновныеСведения, СтруктураВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ОтсечьНезаполненныеНеобязательныеУзлы(СтруктураВыгрузки);
	УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВТаблицу(СтруктураВыгрузки, ОсновныеСведения, СведенияЭлектронногоПредставления);
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Процедура ЗаполнитьДанными_Форма2014_1(Объект, Параметры, ДеревоВыгрузки)
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(Параметры, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметры(Параметры, ДеревоВыгрузки);
КонецПроцедуры

#КонецОбласти
#КонецЕсли
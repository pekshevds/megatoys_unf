#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиВариантов["Основной"].Теги = НСтр("ru = 'Главное,Компания,Анализ бизнеса,Доходы и расходы,Денежный Поток,Баланс,План факт'");
	ДобавитьОписанияСвязанныхПолей(НастройкиВариантов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеОтчета = ИнициализироватьДанныеОтчета();
	Отчеты.АнализБизнеса.СформироватьОтчет(ДокументРезультат, ДанныеОтчета);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)
	
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["Основной"].СвязанныеПоля, "", "Обработка.ЗакрытиеМесяца", , Истина);
	
КонецПроцедуры

Процедура ЗаполнитьНастройкиДляРассылки(ДанныеОтчета)
	
	Настройки = КомпоновщикНастроек.Настройки;
	
	Для каждого Настройка Из Настройки.ПараметрыДанных.Элементы Цикл
		
		ИмяПараметра = Строка(Настройка.Параметр);
		
		Если ДанныеОтчета.Свойство(ИмяПараметра) Тогда
			ДанныеОтчета[ИмяПараметра] = Настройка.Значение;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ИнициализироватьДанныеМеток()
	
	ДанныеМеток = Новый ТаблицаЗначений;
	ДанныеМеток.Колонки.Добавить("Метка");
	ДанныеМеток.Колонки.Добавить("ПредставлениеМетки");
	ДанныеМеток.Колонки.Добавить("ИмяПоляОтбора");
	ДанныеМеток.Колонки.Добавить("ИмяГруппыРодителя");
	
	Возврат ДанныеМеток;
	
КонецФункции 

Функция ИнициализироватьДанныеОтчета()
	
	ДанныеОтчета = Новый Структура("ВидОтчетаОтбор,ПериодОтчета,ПланФакт,Периодичность,СценарийПланирования");
	ДанныеОтчета.Вставить("ДанныеМеток", ИнициализироватьДанныеМеток());
	ОсновнойОтбор = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ВидОтчетаОтбор");
	Если ОсновнойОтбор <> Неопределено И ОсновнойОтбор.Использование Тогда
		ЗаполнитьНастройкиДляРассылки(ДанныеОтчета);
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ОтчетПустой", Ложь);
	Иначе
		НастройкиФормыОтчета = Отчеты.АнализБизнеса.ИнициализироватьНастройкиФормы();
		Отчеты.АнализБизнеса.ВосстановитьНастройкиОтборов(ЭтотОбъект, ДанныеОтчета.ДанныеМеток);
		Отчеты.АнализБизнеса.ВосстановитьНастройкиФормы(НастройкиФормыОтчета);
		Если НастройкиФормыОтчета.АктивнаяГиперссылка = "ДекорацияДоходыРасходы" Тогда
			ДанныеОтчета.Вставить("ВидОтчетаОтбор", Перечисления.ВидыФинансовыхОтчетов.ДоходыРасходы);
		ИначеЕсли НастройкиФормыОтчета.АктивнаяГиперссылка = "ДекорацияДенежныйПоток" Тогда
			ДанныеОтчета.Вставить("ВидОтчетаОтбор", Перечисления.ВидыФинансовыхОтчетов.ДенежныйПоток);
		ИначеЕсли НастройкиФормыОтчета.АктивнаяГиперссылка = "ДекорацияБаланс" Тогда
			ДанныеОтчета.Вставить("ВидОтчетаОтбор", Перечисления.ВидыФинансовыхОтчетов.Баланс);
		Иначе
			ДанныеОтчета.Вставить("ВидОтчетаОтбор", Перечисления.ВидыФинансовыхОтчетов.ДоходыРасходы);
		КонецЕсли;
		
		ДанныеОтчета.Вставить("СценарийПланирования", СценарийПланирования);
		ДанныеОтчета.Вставить("ПериодОтчета", ПериодОтчета);
		ДанныеОтчета.Вставить("ПланФакт", ПланФакт);
		ДанныеОтчета.Вставить("Периодичность", Периодичность);
		
	КонецЕсли;
	
	ДанныеОтчета.Вставить("АктивныйПериод", ПолучитьАктивныйПериод(ДанныеОтчета.Периодичность));
	
	ДанныеОтчета.Вставить("ПериодыПланирования", Новый Массив);
	ПоказателиБизнесаФормы.ЗаполнитьСписокПериодов(ДанныеОтчета.ПериодыПланирования, ДанныеОтчета.ПериодОтчета, ДанныеОтчета.Периодичность);
	
	ВидыОтчетов = Новый СписокЗначений;
	ВидыОтчетов.Добавить(Перечисления.ВидыФинансовыхОтчетов.ДоходыРасходы, "ДоходыРасходы");
	ВидыОтчетов.Добавить(Перечисления.ВидыФинансовыхОтчетов.ДенежныйПоток, "ДенежныйПоток");
	ВидыОтчетов.Добавить(Перечисления.ВидыФинансовыхОтчетов.Баланс, 		"Баланс");
	
	ДанныеОтчета.Вставить("ВидыОтчетов", ВидыОтчетов);
	
	ДанныеОтчета.Вставить("ИдентификаторыПоказателей", Новый Соответствие);
	ДанныеОтчета.Вставить("ИдентификаторыПоказателейДляФормул", Новый Соответствие);
	ДанныеОтчета.Вставить("ВременноеСоответствиеЗависимыхЭлементов", Новый Соответствие);
	ДанныеОтчета.Вставить("СоответствиеЗависимыхЭлементов", Новый Соответствие);
	
	ДанныеОтчета.Вставить("ЭтоВыводНаПечать", Истина);
	ДанныеОтчета.Вставить("ГруппировкаАнализаБизнеса", Группировка);
	ДанныеОтчета.Вставить("ПоказыватьПустыеСтроки", ПоказыватьПустыеСтроки);
	ДанныеОтчета.Вставить("ВыводитьОтклонение", ВыводитьОтклонение);
	
	ИнициализироватьДеревьяОтчета(ДанныеОтчета);
	
	Возврат ДанныеОтчета;
	
КонецФункции

Функция ПолучитьАктивныйПериод(Периодичность)
	
	Если Периодичность = Перечисления.Периодичность.Месяц Тогда
		АктивныйПериод = НачалоМесяца(ТекущаяДатаСеанса());
	ИначеЕсли Периодичность = Перечисления.Периодичность.Квартал Тогда
		АктивныйПериод = НачалоКвартала(ТекущаяДатаСеанса());
	ИначеЕсли Периодичность = Перечисления.Периодичность.Полугодие Тогда
		
		МесяцПериода = Месяц(ТекущаяДатаСеанса());
		АктивныйПериод = НачалоГода(ТекущаяДатаСеанса());
		Если МесяцПериода <= 6 Тогда
			АктивныйПериод = ДобавитьМесяц(АктивныйПериод, 6);
		КонецЕсли;
		
	Иначе // Год
		АктивныйПериод = НачалоГода(ТекущаяДатаСеанса());
	КонецЕсли;
	
	Возврат АктивныйПериод;
	
КонецФункции

Функция ЭтоАктивныйПериод(Период, АктивныйПериод, Периодичность)
	
	Если Периодичность = Перечисления.Периодичность.Месяц Тогда
		ПериодСУчетомПериодичности = НачалоМесяца(АктивныйПериод);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Квартал Тогда
		ПериодСУчетомПериодичности = НачалоКвартала(АктивныйПериод);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Полугодие Тогда
		
		МесяцПериода = Месяц(АктивныйПериод);
		ПериодСУчетомПериодичности = НачалоГода(АктивныйПериод);
		Если МесяцПериода > 6 Тогда
			ПериодСУчетомПериодичности = ДобавитьМесяц(ПериодСУчетомПериодичности, 6);
		КонецЕсли;
		
	ИначеЕсли Периодичность = Перечисления.Периодичность.Год Тогда
		ПериодСУчетомПериодичности = НачалоГода(АктивныйПериод);
	Иначе // Другая периодичность не поддерживаются
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Период = ПериодСУчетомПериодичности;
	
КонецФункции

Процедура ИнициализироватьДеревьяОтчета(ДанныеОтчета)
	
	МассивИменДеревьев = ПоказателиБизнесаФормы.ИменаДеревьевФормы();
	
	Для каждого ИмяДерева Из МассивИменДеревьев Цикл
		
		Дерево = Новый ДеревоЗначений;
		
		Дерево.Колонки.Добавить("Показатель");
		Дерево.Колонки.Добавить("Порядок");
		Дерево.Колонки.Добавить("Представление");
		Дерево.Колонки.Добавить("ЭтоВерхнийУровеньИерархии");
		Дерево.Колонки.Добавить("ТипПоказателя");
		Дерево.Колонки.Добавить("НомерКартинкиСтроки");
		Дерево.Колонки.Добавить("ИдентификаторПоказателя");
		Дерево.Колонки.Добавить("ОписаниеПоказателя");
		Дерево.Колонки.Добавить("СтрокаФормулы");
		Дерево.Колонки.Добавить("ЭтоПроцент");
		Дерево.Колонки.Добавить("Аналитика");
		
		Если ДанныеОтчета.ПланФакт = Перечисления.ПланФакт.ПланФакт Тогда
			Дерево.Колонки.Добавить("ИтогоПлан", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
			Дерево.Колонки.Добавить("ИтогоФакт", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
		Иначе
			Дерево.Колонки.Добавить("Итого", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
		КонецЕсли;
		
		Для каждого Период Из ДанныеОтчета.ПериодыПланирования Цикл
			ИмяКолонки = СформироватьИмяКолонкиПоПериоду(Период);
			Дерево.Колонки.Добавить(ИмяКолонки, Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
			Если ДанныеОтчета.ПланФакт = Перечисления.ПланФакт.ПланФакт И ЭтоАктивныйПериод(Период, ДанныеОтчета.АктивныйПериод, ДанныеОтчета.Периодичность) Тогда
				ИмяКолонки = ИмяКолонки + "План";
				Дерево.Колонки.Добавить(ИмяКолонки, Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
			КонецЕсли;
		КонецЦикла;
		
		ДанныеОтчета.Вставить(ИмяДерева, Дерево);
		
	КонецЦикла;
	
КонецПроцедуры

Функция СформироватьИмяКолонкиПоПериоду(Знач Период)
	
	Возврат Формат(Период,"ДФ=_ггггММдд");
	
КонецФункции

#КонецОбласти 

#Область Инициализация

ЭтоОтчетУНФ = Истина;

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
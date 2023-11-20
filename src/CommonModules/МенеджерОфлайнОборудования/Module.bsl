
#Область ПрограммныйИнтерфейс

#Область ВидыЭлектроннойОплаты

// Пустая структура для заполнения параметра "ВидыЭлектроннойОплаты" выгружаемых на ККМ настроек,
// настройки заполняются в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеНастроек.
//
// Возвращаемое значение:
// 	Структура - Описание:
//   * УникальныйИдентификатор - УникальныйИдентификатор - .
//   * ТипЭлектроннойОплаты - Число - .
//   * Наименование - Строка - .
//   * Код - Число - . 
//
Функция ЗаписьВидЭлектроннойОплаты() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	// обязательное
	СтруктураЗаписи.Вставить("Код");
	
	// обязательное
	СтруктураЗаписи.Вставить("Наименование");
	
	// Число, обязательное
	// ТипЭлектроннойОплатыПлатежнаяКарта()
	// ТипЭлектроннойОплатыБанковскийКредит()
	// ТипЭлектроннойОплатыПодарочныйСертификат()
	// ТипЭлектроннойОплатыБонусы()
	СтруктураЗаписи.Вставить("ТипЭлектроннойОплаты");
	
	// УникальныйИдентификатор, необязательное
	СтруктураЗаписи.Вставить("УникальныйИдентификатор");
	
	Возврат СтруктураЗаписи;
	
КонецФункции

// Константа для заполнения поля ТипЭлектроннойОплаты структуры ЗаписьВидЭлектроннойОплаты()
//
// Возвращаемое значение:
//  Число
Функция ТипЭлектроннойОплатыПлатежнаяКарта() Экспорт
	
	Возврат 1;
	
КонецФункции

// Константа для заполнения поля ТипЭлектроннойОплаты структуры ЗаписьВидЭлектроннойОплаты()
//
// Возвращаемое значение:
//  Число
Функция ТипЭлектроннойОплатыБанковскийКредит() Экспорт
	
	Возврат 2;
	
КонецФункции

// Константа для заполнения поля ТипЭлектроннойОплаты структуры ЗаписьВидЭлектроннойОплаты()
//
// Возвращаемое значение:
//  Число
Функция ТипЭлектроннойОплатыПодарочныйСертификат() Экспорт
	
	Возврат 3;
	
КонецФункции

// Константа для заполнения поля ТипЭлектроннойОплаты структуры ЗаписьВидЭлектроннойОплаты()
//
// Возвращаемое значение:
//  Число
Функция ТипЭлектроннойОплатыБонусы() Экспорт
	
	Возврат 4;
	
КонецФункции

#КонецОбласти

#Область ПрайсЛист

// Пустая структура для заполнения массива Товары прайс-листа выгружаемого на оборудование,
// прайс-лист заполняется в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеПрайсЛиста.
//
// Возвращаемое значение:
//  Структура:
//   * Наименование - Строка - .
//   * Описание - Строка - .
//   * Характеристики - Массив из см. ЗаписьХарактеристикиПрайсЛиста   
//   * Упаковки - Массив из см. ЗаписьУпаковкиПрайсЛиста   
//
Функция ЗаписьТовараПрайсЛиста() Экспорт
	
	ЗаписьТовара = Новый Структура;
	
	// Строка, обязательность - по условию*
	// Идентификатор товарной позиции**
	ЗаписьТовара.Вставить("Код");
	
	// Массив структур, обязательность - по условию*
	// структура - ЗаписьШтрихкодаПрайсЛиста()
	ЗаписьТовара.Вставить("Штрихкоды", Новый Массив);
	
	// Число, по условию*
	ЗаписьТовара.Вставить("Цена");
	
	// Число, по условию*
	ЗаписьТовара.Вставить("Остаток");
	
	// УникальныйИдентификатор, обязательное
	ЗаписьТовара.Вставить("УникальныйИдентификатор");
	
	// Ссылка Номенклатура, необязательное
	ЗаписьТовара.Вставить("СсылкаНоменклатура");
	
	// Строка, обязательное
	ЗаписьТовара.Вставить("Наименование");
	
	// Строка, обязательное
	// СтавкаНДС0()
	// СтавкаНДС10()
	// СтавкаНДС18()
	// СтавкаБезНДС()
	ЗаписьТовара.Вставить("СтавкаНДС");
	
	// Перечисление.ПризнакиПредметаРасчета, обязательное
	ЗаписьТовара.Вставить("ПризнакПредметаРасчета",
		Перечисления.ПризнакиПредметаРасчета.Товар);
	
	// Строка, необязательное
	// Идентификатор ЕИ, ключ связи с таблицей ЕдиницыИзмерения прайс-листа
	ЗаписьТовара.Вставить("КодЕдиницыИзмерения");
	
	// УникальныйИдентификатор, необязательное
	ЗаписьТовара.Вставить("УникальныйИдентификаторЕдиницыИзмерения");
	
	// Ссылка единица измерения, необязательное
	ЗаписьТовара.Вставить("СсылкаЕдиницаИзмерения");
	
	// Строка, необязательное
	// Идентификатор группы, ключ связи с таблицей ГруппыТоваров прайс-листа
	ЗаписьТовара.Вставить("КодГруппы");
	
	// УникальныйИдентификатор, необязательное
	ЗаписьТовара.Вставить("УникальныйИдентификаторГруппы");
	
	// Ссылка группа товаров, необязательное
	ЗаписьТовара.Вставить("СсылкаГруппаТоваров");
	
	// Строка, необязательное
	ЗаписьТовара.Вставить("Артикул");
	
	// Строка, необязательное
	ЗаписьТовара.Вставить("Описание");
	
	// Булево
	ЗаписьТовара.Вставить("ЭтоВесовойТовар", Ложь);
	
	// Число, необязательное
	ЗаписьТовара.Вставить("НомерСекции");
	
	// Строка, необязательное
	// Идентификатор данных агента, ключ связи с таблицей ДанныеАгентов прайс-листа
	ЗаписьТовара.Вставить("КодДанныхАгента");
	
	// УникальныйИдентификатор, необязательное
	ЗаписьТовара.Вставить("УникальныйИдентификаторДанныхАгента");
	
	// Строка, необязательное
	// Идентификатор данных поставщика, ключ связи с таблицей ДанныеПоставщиков прайс-листа
	ЗаписьТовара.Вставить("КодДанныхПоставщика");
	
	// УникальныйИдентификатор, необязательное
	ЗаписьТовара.Вставить("УникальныйИдентификаторДанныхПоставщика");
	
	// Булево
	ЗаписьТовара.Вставить("ИмеетХарактеристики", Ложь);
	
	// Строка, необязательное
	ЗаписьТовара.Вставить("КодВидаНоменклатурнойКлассификации");
	
	// Массив структур, обязательное если ИмеетХарактеристики = Истина
	// структура - ЗаписьХарактеристикиПрайсЛиста()
	ЗаписьТовара.Вставить("Характеристики", Новый Массив());
	
	// Булево, не может быть Истина, если ИмеетХарактеристики = Истина
	ЗаписьТовара.Вставить("ИмеетУпаковки", Ложь);
	
	// Массив структур, обязательное если ИмеетУпаковки = Истина
	// структура - ЗаписьХарактеристикиПрайсЛиста()
	ЗаписьТовара.Вставить("Упаковки", Новый Массив());
	
	
	// Алкоголь
	
	// Булево
	ЗаписьТовара.Вставить("ЭтоАлкоголь", Ложь);
	АлкогольныеРеквизиты = Новый Структура;
	
	// Булево
	АлкогольныеРеквизиты.Вставить("Маркируемый", Ложь);
	
	// Строка, обязательное
	АлкогольныеРеквизиты.Вставить("КодВидаАлкогольнойПродукции", "");
	
	// Число, обязательное, в литрах
	АлкогольныеРеквизиты.Вставить("ЕмкостьТары", 0);
	
	// Число, обязательное
	АлкогольныеРеквизиты.Вставить("Крепость", 0);
	
	// Строка, обязательное
	АлкогольныеРеквизиты.Вставить("ИННПроизводителя", "");
	
	// Строка, обязательное
	АлкогольныеРеквизиты.Вставить("КПППроизводителя", "");
	
	// Булево
	АлкогольныеРеквизиты.Вставить("ВРозлив", Ложь);
	
	ЗаписьТовара.Вставить("АлкогольныеРеквизиты", АлкогольныеРеквизиты);
	
	// Маркированная продукция
	// Булево
	ЗаписьТовара.Вставить("ЭтоМаркированнаяПродукция", Ложь);
	// Перечисление.ТипыМаркировкиККТ, необязательное
	ЗаписьТовара.Вставить("ТипМаркированнойПродукции", Перечисления.ТипыМаркировкиККТ.ПустаяСсылка());
	// Перечисление.ВидыМаркированнойПродукцииБПО, необязательное
	ЗаписьТовара.Вставить("ВидМаркированнойПродукции", Перечисления.ВидыМаркированнойПродукцииБПО.ПустаяСсылка());
	
	// * условие:
	// Если ИмеетХарактеристики = Ложь И ИмеетУпаковки = Ложь,
	// тогда поле "Код" - обязательное
	// Поля "Штрихкоды", "Цена", "Остаток" - заполняются в этой записи, но необязательные к заполнению	
	//
	// Если ИмеетХарактеристики = Ложь И ИмеетУпаковки = Истина, то поля "Код", "Штрихкоды", "Цена", "Остаток"
	// заполняются значениями для базовой единицы измерения.
	//
	// Если ИмеетХарактеристики = Истина И ИмеетУпаковки = Истина - ошибка, такой ситуации быть не должно.
	//
	// Если ИмеетХарактеристики = Истина И ИмеетУпаковки = Ложь
	// поля "Код", "Штрихкоды", "Цена", "Остаток" - не заполняются
	
	// ** товарная позиция - Номенклатура + Характеристика + Упаковка
	
	Возврат ЗаписьТовара;
	
КонецФункции

// Пустая структура для заполнения массива Характеристики прайс-листа выгружаемого на оборудование,
// прайс-лист заполняется в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеПрайсЛиста.
// 
// Возвращаемое значение:
//  Структура:
//   * Наименование - Строка - .
//   * Упаковки - Массив из см. ЗаписьУпаковкиПрайсЛиста   
// 
Функция ЗаписьХарактеристикиПрайсЛиста() Экспорт
	
	ЗаписьХарактеристики = Новый Структура;
	
	// Строка, обязательность - по условию*
	// Идентификатор товарной позиции**
	ЗаписьХарактеристики.Вставить("Код");
	
	// Массив структур, обязательность - по условию*
	// структура - ЗаписьШтрихкодаПрайсЛиста()
	ЗаписьХарактеристики.Вставить("Штрихкоды", Новый Массив);
	
	// Число, по условию*
	ЗаписьХарактеристики.Вставить("Цена");
	
	// Число, по условию*
	ЗаписьХарактеристики.Вставить("Остаток");
	
	// УникальныйИдентификатор, обязательное
	ЗаписьХарактеристики.Вставить("УникальныйИдентификатор");
	
	// Ссылка характеристика, необязательное
	ЗаписьХарактеристики.Вставить("СсылкаХарактеристика");
	
	// Строка, обязательное
	ЗаписьХарактеристики.Вставить("Наименование");
	
	// Булево
	ЗаписьХарактеристики.Вставить("ИмеетУпаковки", Ложь);
	
	// Массив структур, обязательное если ИмеетУпаковки = Истина
	ЗаписьХарактеристики.Вставить("Упаковки", Новый Массив());
	
	// Пояснение:
	//  Если ИмеетУпаковки = Ложь, тогда поле "Код" - обязательное
	//  Поля Штрихкоды, Цена, Остаток - заполняются в этой записи, но необязательные к заполнению
	//
	//  Если ИмеетУпаковки = Истина, то поля "Код", "Штрихкоды", "Цена", "Остаток"
	//  заполняются значениями для базовой единицы измерения.
	
	// ** товарная позиция - Номенклатура + Характеристика + Упаковка
	
	Возврат ЗаписьХарактеристики;
	
КонецФункции

// Пустая структура для заполнения массива Упаковки прайс-листа выгружаемого на оборудование,
// прайс-лист заполняется в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеПрайсЛиста.
//
// Возвращаемое значение:
// 	Структура:
//   * Наименование - Строка - .
// 
Функция ЗаписьУпаковкиПрайсЛиста() Экспорт
	
	ЗаписьУпаковки = Новый Структура;
	
	// Строка, обязательное
	// Идентификатор товарной позиции**
	ЗаписьУпаковки.Вставить("Код");
	
	// Строка, обязательное
	ЗаписьУпаковки.Вставить("Наименование");
	
	// Число, обязательное
	ЗаписьУпаковки.Вставить("Коэффициент", 0);
	
	// УникальныйИдентификатор, необязательное
	ЗаписьУпаковки.Вставить("УникальныйИдентификатор");
	
	// Ссылка упаковка, необязательное
	ЗаписьУпаковки.Вставить("СсылкаУпаковки");
	
	// Массив структур, необязательное
	// структура - ЗаписьШтрихкодаПрайсЛиста()
	ЗаписьУпаковки.Вставить("Штрихкоды", Новый Массив);
	
	// Число, необязательное
	ЗаписьУпаковки.Вставить("Цена");
	
	// Число, необязательное
	ЗаписьУпаковки.Вставить("Остаток");
	
	// ** товарная позиция - Номенклатура + Характеристика + Упаковка
	
	Возврат ЗаписьУпаковки;
	
КонецФункции

// Пустая структура для заполнения массива ГруппыТоваров прайс-листа выгружаемого на оборудование,
// прайс-лист заполняется в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеПрайсЛиста.
//
// Возвращаемое значение:
// 	Структура - Описание:
//   * УникальныйИдентификаторГруппы - УникальныйИдентификатор - .
//   * КодГруппы - Число - .
//   * УникальныйИдентификатор - УникальныйИдентификатор - .
//   * Наименование - Строка - .
//   * Код - Число - .
//
Функция ЗаписьГруппыТоваровПрайсЛиста() Экспорт
	
	ЗаписьГруппы = Новый Структура;
	
	// Строка, обязательное
	ЗаписьГруппы.Вставить("Код");
	
	// Строка, обязательное
	ЗаписьГруппы.Вставить("Наименование");
	
	// УникальныйИдентификатор, обязательное
	ЗаписьГруппы.Вставить("УникальныйИдентификатор");
	
	// Ссылка группа товаров, необязательное
	ЗаписьГруппы.Вставить("СсылкаГруппы");
	
	// Строка, необязательное
	ЗаписьГруппы.Вставить("КодГруппы");
	
	// УникальныйИдентификатор, необязательное
	ЗаписьГруппы.Вставить("УникальныйИдентификаторГруппы");
	
	Возврат ЗаписьГруппы;
	
КонецФункции

// Пустая структура для заполнения массива ЕдиницыИзмерения прайс-листа выгружаемого на оборудование,
// прайс-лист заполняется в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеПрайсЛиста.
//
// Возвращаемое значение:
// 	Структура - Описание:
//   * Код - Строка
//   * Наименование - Строка - .
//   * УникальныйИдентификатор - УникальныйИдентификатор -
//   * КодОКЕИ - Строка
Функция ЗаписьЕдиницыИзмеренияПрайсЛиста() Экспорт
	
	ЗаписьЕИ = Новый Структура;
	
	// Строка, обязательное
	// Идентификатор ЕИ, ключ связи с полем КодЕдиницыИзмерения товара
	ЗаписьЕИ.Вставить("Код");
	
	// Строка, обязательное
	ЗаписьЕИ.Вставить("Наименование");
	
	// УникальныйИдентификатор, необязательное
	ЗаписьЕИ.Вставить("УникальныйИдентификатор");
	
	// Ссылка единица измерения, необязательное
	ЗаписьЕИ.Вставить("СсылкаЕдиницыИзмерения");
	
	// Строка, необязательное
	ЗаписьЕИ.Вставить("КодОКЕИ");
	
	Возврат ЗаписьЕИ;
	
КонецФункции

// Пустая структура для заполнения массива ДанныеАгентов прайс-листа выгружаемого на оборудование,
// прайс-лист заполняется в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеПрайсЛиста.
//
// Возвращаемое значение:
//  Структура.
//
Функция ЗаписьДанныхАгентаПрайсЛиста() Экспорт
	
	ЗаписьДанныхАгента = Новый Структура;
	
	// Строка, обязательное
	// Идентификатор данных агента, ключ связи с полем КодДанныхАгента товара
	ЗаписьДанныхАгента.Вставить("Код");
	
	// УникальныйИдентификатор, необязательное
	ЗаписьДанныхАгента.Вставить("УникальныйИдентификатор");
	
	// Перечисление.ПризнакиАгента, необязательное
	ЗаписьДанныхАгента.Вставить("ПризнакАгента", Перечисления.ПризнакиАгента.ПустаяСсылка());
	
	
	// Платежный агент
	
	// Строка, необязательное
	ЗаписьДанныхАгента.Вставить("ОперацияПлатежногоАгента");
	// Строка, необязательное
	ЗаписьДанныхАгента.Вставить("ТелефонПлатежногоАгента");
	
	
	// Оператор перевода
	
	// Строка, необязательное
	ЗаписьДанныхАгента.Вставить("ТелефонОператораПеревода");
	
	// Строка, необязательное
	ЗаписьДанныхАгента.Вставить("НаименованиеОператораПеревода");
	
	// Строка, необязательное
	ЗаписьДанныхАгента.Вставить("АдресОператораПеревода");
	
	// Строка, необязательное
	ЗаписьДанныхАгента.Вставить("ИННОператораПеревода");
	
	
	// Оператор по приему платежей
	
	// Строка, необязательное
	ЗаписьДанныхАгента.Вставить("ТелефонОператораПоПриемуПлатежей");
	
	Возврат ЗаписьДанныхАгента;
	
КонецФункции

// Пустая структура для заполнения массива ДанныеПоставщиков прайс-листа выгружаемого на оборудование,
// прайс-лист заполняется в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеПрайсЛиста.
//
// Возвращаемое значение:
// 	Структура.
//
Функция ЗаписьДанныхПоставщикаПрайсЛиста() Экспорт
	
	ЗаписьДанныхПоставщика = Новый Структура;
	
	// Строка, обязательное
	// Идентификатор данных поставщика, ключ связи с полем КодДанныхПоставщика товара
	ЗаписьДанныхПоставщика.Вставить("Код");
	
	// УникальныйИдентификатор, необязательное
	ЗаписьДанныхПоставщика.Вставить("УникальныйИдентификатор");
	
	// Строка, необязательное
	ЗаписьДанныхПоставщика.Вставить("ТелефонПоставщика");
	
	// Строка, необязательное
	ЗаписьДанныхПоставщика.Вставить("НаименованиеПоставщика");
	
	// Строка, необязательное
	ЗаписьДанныхПоставщика.Вставить("ИННПоставщика");
	
	Возврат ЗаписьДанныхПоставщика;
	
КонецФункции

// Пустая структура для заполнения массива Штрихкоды товара прайс-листа выгружаемого на оборудование,
// прайс-лист заполняется в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеПрайсЛиста.
//
// Возвращаемое значение:
// 	Структура.
//
Функция ЗаписьШтрихкодаПрайсЛиста() Экспорт
	
	ЗаписьШтрихкода = Новый Структура;
	
	// Строка, обязательное
	ЗаписьШтрихкода.Вставить("Штрихкод");
	
	// Строка, необязательное
	// CODE128, CODE39, EAN128, EAN13, EAN8, ITF14, QR
	ЗаписьШтрихкода.Вставить("ТипШтрихкода");
	
	Возврат ЗаписьШтрихкода;
	
КонецФункции

// константы

// Возвращает значение ставки НДС 0
//
// Возвращаемое значение:
// 	Строка.
//
Функция СтавкаНДС0() Экспорт
	
	Возврат "0";
	
КонецФункции

// Возвращает значение ставки НДС 10
//
// Возвращаемое значение:
// 	Строка.
//
Функция СтавкаНДС10() Экспорт
	
	Возврат "10";
	
КонецФункции

// Возвращает значение ставки НДС 18
//
// Возвращаемое значение:
// 	Строка.
//
Функция СтавкаНДС18() Экспорт
	
	Возврат "18";
	
КонецФункции

// Возвращает значение ставки БЕЗ НДС
//
// Возвращаемое значение:
// 	Строка.
//
Функция СтавкаБезНДС() Экспорт
	
	Возврат "none";
	
КонецФункции

// Возвращает значение ставки 20
//
// Возвращаемое значение:
// 	Строка.
//
Функция СтавкаНДС20() Экспорт
	
	Возврат "20";
	
КонецФункции

// Возвращает значение ставки 10/110
//
// Возвращаемое значение:
// 	Строка.
//
Функция СтавкаНДС110() Экспорт
	
	Возврат "10/110";
	
КонецФункции

// Возвращает значение ставки 18/118
//
// Возвращаемое значение:
// 	Строка.
//
Функция СтавкаНДС118() Экспорт
	
	Возврат "18/118";
	
КонецФункции

// Возвращает значение ставки 20/120
//
// Возвращаемое значение:
// 	Строка.
//
Функция СтавкаНДС120() Экспорт
	
	Возврат "20/120";
	
КонецФункции

// Получить код типа маркировки ККТ по коду.
//
// Параметры:
//  ТипМаркировкиККТ - ПеречислениеСсылка.ТипыМаркировкиККТ
//
// Возвращаемое значение:
// 	Соответствие.
//
Функция КодТипаМаркировкиККТ(ТипМаркировкиККТ) Экспорт
	
	ТипыМаркировкиККТ = Новый Соответствие(); 
	
	ТипыМаркировкиККТ.Вставить(ПредопределенноеЗначение("Перечисление.ТипыМаркировкиККТ.ИзделияИзМеха")         , "1");
	ТипыМаркировкиККТ.Вставить(ПредопределенноеЗначение("Перечисление.ТипыМаркировкиККТ.ТабачнаяПродукция")     , "2");
	ТипыМаркировкиККТ.Вставить(ПредопределенноеЗначение("Перечисление.ТипыМаркировкиККТ.ОбувныеТовары")         , "3");
	
	Возврат ТипыМаркировкиККТ.Получить(ТипМаркировкиККТ);
	
КонецФункции

// Получить код вида маркировки ККТ по коду.
//
// Параметры:
//  ТипМаркировкиККТ - ПеречислениеСсылка.ВидыМаркированнойПродукцииБПО
//
// Возвращаемое значение:
// 	Соответствие.
//
Функция КодВидаМаркировкиККТ(ТипМаркировкиККТ) Экспорт
	
	ТипыМаркировкиККТ = Новый Соответствие(); 
	
	ТипыМаркировкиККТ.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМаркированнойПродукцииБПО.ИзделияИзМеха")               , "1");
	ТипыМаркировкиККТ.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМаркированнойПродукцииБПО.Табак")                       , "2");
	ТипыМаркировкиККТ.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМаркированнойПродукцииБПО.Обувь")                       , "3");
	ТипыМаркировкиККТ.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМаркированнойПродукцииБПО.ЛегкаяПромышленность")        , "4");
	ТипыМаркировкиККТ.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМаркированнойПродукцииБПО.МолочнаяПродукция")           , "6");
	ТипыМаркировкиККТ.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМаркированнойПродукцииБПО.Шины")                        , "5");
	ТипыМаркировкиККТ.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМаркированнойПродукцииБПО.Фотоаппараты")                , "7");
	ТипыМаркировкиККТ.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМаркированнойПродукцииБПО.Велосипеды")                  , "8");
	ТипыМаркировкиККТ.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМаркированнойПродукцииБПО.КреслаКоляски")               , "9");
	ТипыМаркировкиККТ.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМаркированнойПродукцииБПО.Духи")                        , "10");
	ТипыМаркировкиККТ.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМаркированнойПродукцииБПО.АльтернативныйТабак")         , "11");
	ТипыМаркировкиККТ.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМаркированнойПродукцииБПО.УпакованнаяВода")             , "12");
	ТипыМаркировкиККТ.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМаркированнойПродукцииБПО.Антисептики")                 , "13");
	ТипыМаркировкиККТ.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМаркированнойПродукцииБПО.БАДы")                        , "14");  // АПК:1036 - устоявшиеся сокращения
	ТипыМаркировкиККТ.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМаркированнойПродукцииБПО.НикотиносодержащаяПродукция") , "15");
	ТипыМаркировкиККТ.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМаркированнойПродукцииБПО.Пиво")                        , "16");
	ТипыМаркировкиККТ.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМаркированнойПродукцииБПО.СоковаяПродукция")            , "17");
	ТипыМаркировкиККТ.Вставить(ПредопределенноеЗначение("Перечисление.ВидыМаркированнойПродукцииБПО.БезалкогольноеПиво")          , "18");
	
	Возврат ТипыМаркировкиККТ.Получить(ТипМаркировкиККТ);
	
КонецФункции

#КонецОбласти

#Область Заказы

// Пустая структура для заполнения списка заказов, выгружаемых на оборудование,
// заказы заполняется в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеЗаказов.
//
//
// Возвращаемое значение:
// 	Структура.
//
Функция ЗаписьЗаказа() Экспорт
	
	ЗаписьЗаказа = Новый Структура;
	
	// Строка, обязательное
	ЗаписьЗаказа.Вставить("НомерЗаказа");
	
	// Дата, обязательное
	ЗаписьЗаказа.Вставить("ДатаЗаказа");
	
	// УникальныйИдентификатор, обязательное
	ЗаписьЗаказа.Вставить("УникальныйИдентификатор");
	
	// Ссылка заказа, необязательное
	ЗаписьЗаказа.Вставить("СсылкаЗаказа");
	
	// Строка, необязательное
	ЗаписьЗаказа.Вставить("ГородДоставки");
	
	// Строка, необязательное
	ЗаписьЗаказа.Вставить("УлицаДоставки");
	
	// Строка, необязательное
	ЗаписьЗаказа.Вставить("НомерДомаДоставки");
	
	// Строка, необязательное
	ЗаписьЗаказа.Вставить("НомерКвартирыДоставки");
	
	// Строка, необязательное
	ЗаписьЗаказа.Вставить("НомерПодъездаДоставки");
	
	// Строка, необязательное
	ЗаписьЗаказа.Вставить("НомерЭтажаДоставки");
	
	// Строка, необязательное
	ЗаписьЗаказа.Вставить("НомерТелефонаКлиента");
	
	// Строка, необязательное
	ЗаписьЗаказа.Вставить("EmailКлиента");
	
	// Дата, необязательное
	ЗаписьЗаказа.Вставить("ДатаДоставки");
	
	// Строка, необязательное
	// "НеСогласован", "Согласован", "Отменен"
	ЗаписьЗаказа.Вставить("СтатусЗаказа");
	
	// Строка, необязательное
	ЗаписьЗаказа.Вставить("Комментарий");
	
	// Строка, необязательное
	ЗаписьЗаказа.Вставить("ИмяКлиента");
	
	// Строка, необязательное
	ЗаписьЗаказа.Вставить("ФамилияКлиента");
	
	// Массив структур, необязательное
	// структура - ЗаписьТовараЗаказа()
	ЗаписьЗаказа.Вставить("Товары", Новый Массив);
	
	// Массив структур, необязательное
	// структура - ЗаписьОплатыЗаказа()
	ЗаписьЗаказа.Вставить("Оплаты", Новый Массив);
	
	Возврат ЗаписьЗаказа;
	
КонецФункции

// Пустая структура для заполнения массива Товары заказа выгружаемого на оборудование,
// заказы заполняется в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеЗаказов.
//
// Возвращаемое значение:
// 	Структура.
//
Функция ЗаписьТовараЗаказа() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	// Строка, обязательное
	// Идентификатор товарной позиции
	СтруктураЗаписи.Вставить("Код");
	
	// Число, обязательное
	СтруктураЗаписи.Вставить("Количество");
	
	// Число, обязательное
	СтруктураЗаписи.Вставить("Цена");
	
	// Число, обязательное
	СтруктураЗаписи.Вставить("Сумма");
	
	// Массив строк, необязательное
	СтруктураЗаписи.Вставить("ШтрихкодыМаркированнойПродукции", Новый Массив);
	
	// УникальныйИдентификатор, обязательное
	СтруктураЗаписи.Вставить("УникальныйИдентификаторТовара");
	
	// УникальныйИдентификатор, необязательное
	СтруктураЗаписи.Вставить("УникальныйИдентификаторХарактеристики");
	
	// УникальныйИдентификатор, необязательное
	СтруктураЗаписи.Вставить("УникальныйИдентификаторУпаковки");
	
	Возврат СтруктураЗаписи;
	
КонецФункции

// Пустая структура для заполнения массива Оплаты заказа выгружаемого на оборудование,
// заказы заполняется в МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеЗаказов.
//
// Возвращаемое значение:
// 	Структура.
//
Функция ЗаписьОплатыЗаказа() Экспорт
	
	СтруктураЗаписи = Новый Структура;
	
	// Число
	СтруктураЗаписи.Вставить("СуммаНаличнойОплаты", 0);
	
	// Число
	СтруктураЗаписи.Вставить("СуммаЭлектроннойОплаты", 0);
	
	// Число
	СтруктураЗаписи.Вставить("СуммаПредоплатой", 0);
	
	// Число
	СтруктураЗаписи.Вставить("СуммаПостоплатой", 0);
	
	// Число
	СтруктураЗаписи.Вставить("СуммаВстречнымПредоставлением", 0);
	
	// Строка, необязательное
	// ключ связи с таблицей ВидыЭлектроннойОплаты структуры настроек
	// см. ЗаписьВидЭлектроннойОплаты()
	СтруктураЗаписи.Вставить("КодВидаЭлектроннойОплаты");
	
	// УникальныйИдентификатор, необязательное
	// см. ЗаписьВидЭлектроннойОплаты()
	СтруктураЗаписи.Вставить("УникальныйИдентификаторВидаЭлектроннойОплаты");
	
	Возврат СтруктураЗаписи;
	
КонецФункции

#КонецОбласти

#КонецОбласти

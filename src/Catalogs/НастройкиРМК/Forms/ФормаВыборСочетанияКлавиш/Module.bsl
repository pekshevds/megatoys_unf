
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МассивКлавиши = Новый Массив;
	
	МассивКлавиши.Добавить(Клавиша.A);
	МассивКлавиши.Добавить(Клавиша.B);
	МассивКлавиши.Добавить(Клавиша.C);
	МассивКлавиши.Добавить(Клавиша.D);
	МассивКлавиши.Добавить(Клавиша.E);
	МассивКлавиши.Добавить(Клавиша.F);
	МассивКлавиши.Добавить(Клавиша.G);
	МассивКлавиши.Добавить(Клавиша.H);
	МассивКлавиши.Добавить(Клавиша.I);
	МассивКлавиши.Добавить(Клавиша.J);
	МассивКлавиши.Добавить(Клавиша.K);
	МассивКлавиши.Добавить(Клавиша.L);
	МассивКлавиши.Добавить(Клавиша.M);
	МассивКлавиши.Добавить(Клавиша.N);
	МассивКлавиши.Добавить(Клавиша.O);
	МассивКлавиши.Добавить(Клавиша.P);
	МассивКлавиши.Добавить(Клавиша.Q);
	МассивКлавиши.Добавить(Клавиша.R);
	МассивКлавиши.Добавить(Клавиша.S);
	МассивКлавиши.Добавить(Клавиша.T);
	МассивКлавиши.Добавить(Клавиша.U);
	МассивКлавиши.Добавить(Клавиша.V);
	МассивКлавиши.Добавить(Клавиша.W);
	МассивКлавиши.Добавить(Клавиша.X);
	МассивКлавиши.Добавить(Клавиша.Y);
	МассивКлавиши.Добавить(Клавиша.Z);
	
	МассивКлавиши.Добавить(Клавиша.F1);
	МассивКлавиши.Добавить(Клавиша.F2);
	МассивКлавиши.Добавить(Клавиша.F3);
	МассивКлавиши.Добавить(Клавиша.F4);
	МассивКлавиши.Добавить(Клавиша.F5);
	МассивКлавиши.Добавить(Клавиша.F6);
	МассивКлавиши.Добавить(Клавиша.F7);
	МассивКлавиши.Добавить(Клавиша.F8);
	МассивКлавиши.Добавить(Клавиша.F9);
	МассивКлавиши.Добавить(Клавиша.F10);
	МассивКлавиши.Добавить(Клавиша.F11);
	МассивКлавиши.Добавить(Клавиша.F12);
	
	МассивКлавиши.Добавить(Клавиша._1);
	МассивКлавиши.Добавить(Клавиша._2);
	МассивКлавиши.Добавить(Клавиша._3);
	МассивКлавиши.Добавить(Клавиша._4);
	МассивКлавиши.Добавить(Клавиша._5);
	МассивКлавиши.Добавить(Клавиша._6);
	МассивКлавиши.Добавить(Клавиша._7);
	МассивКлавиши.Добавить(Клавиша._8);
	МассивКлавиши.Добавить(Клавиша._9);
	
	МассивКлавиши.Добавить(Клавиша.Num0);
	МассивКлавиши.Добавить(Клавиша.Num1);
	МассивКлавиши.Добавить(Клавиша.Num2);
	МассивКлавиши.Добавить(Клавиша.Num3);
	МассивКлавиши.Добавить(Клавиша.Num4);
	МассивКлавиши.Добавить(Клавиша.Num5);
	МассивКлавиши.Добавить(Клавиша.Num6);
	МассивКлавиши.Добавить(Клавиша.Num7);
	МассивКлавиши.Добавить(Клавиша.Num8);
	МассивКлавиши.Добавить(Клавиша.Num9);
	МассивКлавиши.Добавить(Клавиша.NumAdd);
	МассивКлавиши.Добавить(Клавиша.NumDecimal);
	МассивКлавиши.Добавить(Клавиша.NumDivide);
	МассивКлавиши.Добавить(Клавиша.NumMultiply);
	МассивКлавиши.Добавить(Клавиша.NumSubtract);
	
	МассивКлавиши.Добавить(Клавиша.Space);
	МассивКлавиши.Добавить(Клавиша.BackSpace);
	МассивКлавиши.Добавить(Клавиша.Break);
	
	РабочееМесто = Параметры.РабочееМесто;
	
	Для Каждого ЭлементКлавиша Из МассивКлавиши Цикл
		
		НоваяСтрока = ТаблицаСочетанийКлавиш.Добавить();
		НоваяСтрока.ИмяКлавиши = Строка(ЭлементКлавиша);
		
		ПредставлениеСочетанияКлавиш(НоваяСтрока, "Клавиша",        Новый СочетаниеКлавиш(ЭлементКлавиша, Ложь,   Ложь,   Ложь));
		
		ПредставлениеСочетанияКлавиш(НоваяСтрока, "Ctrl",           Новый СочетаниеКлавиш(ЭлементКлавиша, Ложь,   Истина, Ложь));
		ПредставлениеСочетанияКлавиш(НоваяСтрока, "Alt",            Новый СочетаниеКлавиш(ЭлементКлавиша, Истина, Ложь,   Ложь));
		ПредставлениеСочетанияКлавиш(НоваяСтрока, "Shift",          Новый СочетаниеКлавиш(ЭлементКлавиша, Ложь,   Ложь,   Истина));
		
		ПредставлениеСочетанияКлавиш(НоваяСтрока, "Alt_Shift",      Новый СочетаниеКлавиш(ЭлементКлавиша, Истина, Ложь,   Истина));
		ПредставлениеСочетанияКлавиш(НоваяСтрока, "Ctrl_Shift",     Новый СочетаниеКлавиш(ЭлементКлавиша, Ложь,   Истина, Истина));
		ПредставлениеСочетанияКлавиш(НоваяСтрока, "Ctrl_Alt",       Новый СочетаниеКлавиш(ЭлементКлавиша, Истина, Истина, Ложь));
		ПредставлениеСочетанияКлавиш(НоваяСтрока, "Ctrl_Alt_Shift", Новый СочетаниеКлавиш(ЭлементКлавиша, Истина, Истина, Истина));
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриАктивизацииСтроки в таблице значений ТаблицаСочетанийКлавиш.
//
&НаКлиенте
Процедура ТаблицаСочетанийКлавишПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущийЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СочетаниеКлавиш = ВыбранноеСочетаниеКлавиш(Элемент.ТекущиеДанные, Элемент.ТекущийЭлемент);
	Представление = Представление(СочетаниеКлавиш);
	
КонецПроцедуры

// Процедура - обработчик события ПриАктивизацииПоля в таблице значений ТаблицаСочетанийКлавиш.
//
&НаКлиенте
Процедура ТаблицаСочетанийКлавишПриАктивизацииПоля(Элемент)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		СочетаниеКлавиш = ВыбранноеСочетаниеКлавиш(Элемент.ТекущиеДанные, Элемент.ТекущийЭлемент);
		Представление = Представление(СочетаниеКлавиш);
	Иначе
		Представление = "<выберите сочетание>";
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события Выбор в таблице значений ТаблицаСочетанийКлавиш.
//
&НаКлиенте
Процедура ТаблицаСочетанийКлавишВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = ТаблицаСочетанийКлавиш.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Закрыть(ВыбранноеСочетаниеКлавиш(ТекущиеДанные, Поле));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик команды Выбрать формы.
//
&НаКлиенте
Процедура Выбрать(Команда)
	
	Закрыть(СочетаниеКлавиш);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

// Функция возвращает выбранное (выделенное) сочетание клавиш.
//
&НаКлиенте
Функция ВыбранноеСочетаниеКлавиш(ТекущиеДанные, Поле)
	
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("Элемент,Alt,Ctrl,Shift", Элементы.ТаблицаСочетанийКлавишКлавиша,        Ложь,   Ложь,   Ложь));
	Массив.Добавить(Новый Структура("Элемент,Alt,Ctrl,Shift", Элементы.ТаблицаСочетанийКлавишAlt,            Истина, Ложь,   Ложь));
	Массив.Добавить(Новый Структура("Элемент,Alt,Ctrl,Shift", Элементы.ТаблицаСочетанийКлавишCtrl,           Ложь,   Истина, Ложь));
	Массив.Добавить(Новый Структура("Элемент,Alt,Ctrl,Shift", Элементы.ТаблицаСочетанийКлавишShift,          Ложь,   Ложь,   Истина));
	Массив.Добавить(Новый Структура("Элемент,Alt,Ctrl,Shift", Элементы.ТаблицаСочетанийКлавишAlt_Shift,      Истина, Ложь,   Истина));
	Массив.Добавить(Новый Структура("Элемент,Alt,Ctrl,Shift", Элементы.ТаблицаСочетанийКлавишCtrl_Alt,       Истина, Истина, Ложь));
	Массив.Добавить(Новый Структура("Элемент,Alt,Ctrl,Shift", Элементы.ТаблицаСочетанийКлавишCtrl_Shift,     Ложь,   Истина, Истина));
	Массив.Добавить(Новый Структура("Элемент,Alt,Ctrl,Shift", Элементы.ТаблицаСочетанийКлавишCtrl_Alt_Shift, Истина, Истина, Истина));
	
	Массив.Добавить(Новый Структура("Элемент,Alt,Ctrl,Shift", Элементы.ТаблицаСочетанийКлавишКлавиша_,        Ложь,   Ложь,   Ложь));
	Массив.Добавить(Новый Структура("Элемент,Alt,Ctrl,Shift", Элементы.ТаблицаСочетанийКлавишAlt_,            Истина, Ложь,   Ложь));
	Массив.Добавить(Новый Структура("Элемент,Alt,Ctrl,Shift", Элементы.ТаблицаСочетанийКлавишCtrl_,           Ложь,   Истина, Ложь));
	Массив.Добавить(Новый Структура("Элемент,Alt,Ctrl,Shift", Элементы.ТаблицаСочетанийКлавишShift_,          Ложь,   Ложь,   Истина));
	Массив.Добавить(Новый Структура("Элемент,Alt,Ctrl,Shift", Элементы.ТаблицаСочетанийКлавишAlt_Shift_,      Истина, Ложь,   Истина));
	Массив.Добавить(Новый Структура("Элемент,Alt,Ctrl,Shift", Элементы.ТаблицаСочетанийКлавишCtrl_Alt_,       Истина, Истина, Ложь));
	Массив.Добавить(Новый Структура("Элемент,Alt,Ctrl,Shift", Элементы.ТаблицаСочетанийКлавишCtrl_Shift_,     Ложь,   Истина, Истина));
	Массив.Добавить(Новый Структура("Элемент,Alt,Ctrl,Shift", Элементы.ТаблицаСочетанийКлавишCtrl_Alt_Shift_, Истина, Истина, Истина));
	
	Для Каждого ЭлементМассива Из Массив Цикл
		
		Если ЭлементМассива.Элемент = Поле Тогда
			
			ИмяКлавиши = ТекущиеДанные.ИмяКлавиши;
			Возврат Новый Структура("Клавиша,Alt,Ctrl,Shift", ИмяКлавиши, ЭлементМассива.Alt, ЭлементМассива.Ctrl, ЭлементМассива.Shift);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции

// Функция возвращает представление сочетания клавиш.
//
&НаСервереБезКонтекста
Функция Представление(СочетаниеКлавиш)
	
	Возврат ПредставлениеСочетанияКлавиш2(СочетаниеКлавиш, Истина);
	
КонецФункции

// Функция возвращает представление сочетания клавиш и устанавливает Имя+"_", 
// т.е. данные о номенклатуре или кнопке, которые уже заняли это сочетание.
// Параметры:
//	СочетаниеКлавиш						- Сочетание клавиш для которого нужно сформировать представление
//	БезСкобок							- Флаг, указывающий, что представление должно быть сформировано без скобок
//
// Возвращаемое значение
//	Строка - Представление сочетания клавиш
//
&НаСервере
Процедура ПредставлениеСочетанияКлавиш(НоваяСтрока, Имя, Сочетание)
	
	НоваяСтрока[Имя] = ПредставлениеСочетанияКлавиш2(Сочетание, Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	БыстрыеТовары.Номенклатура,
		|	БыстрыеТовары.Характеристика,
		|	БыстрыеТовары.Ctrl,
		|	БыстрыеТовары.Shift,
		|	БыстрыеТовары.Alt,
		|	БыстрыеТовары.СочетаниеКлавиш,
		|	БыстрыеТовары.Клавиша,
		|	БыстрыеТовары.Заголовок,
		|	БыстрыеТовары.ПолеСортировки,
		|	БыстрыеТовары.Номенклатура.Наименование КАК НоменклатураНаименование,
		|	БыстрыеТовары.Характеристика.Наименование КАК ХарактеристикаНаименование
		|ИЗ
		|	Справочник.НастройкиРМК.БыстрыеТовары КАК БыстрыеТовары
		|ГДЕ
		|	БыстрыеТовары.Ctrl = &Ctrl
		|	И БыстрыеТовары.Shift = &Shift
		|	И БыстрыеТовары.Alt = &Alt
		|	И БыстрыеТовары.Клавиша ПОДОБНО &Клавиша
		|	И БыстрыеТовары.Ссылка.РабочееМесто = &РабочееМесто
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	NULL,
		|	NULL,
		|	КнопкиНижнейПанели.Ctrl,
		|	КнопкиНижнейПанели.Shift,
		|	КнопкиНижнейПанели.Alt,
		|	КнопкиНижнейПанели.СочетаниеКлавиш,
		|	КнопкиНижнейПанели.Клавиша,
		|	КнопкиНижнейПанели.ЗаголовокКнопки,
		|	NULL,
		|	NULL,
		|	NULL
		|ИЗ
		|	Справочник.НастройкиРМК.КнопкиНижнейПанели КАК КнопкиНижнейПанели
		|ГДЕ
		|	КнопкиНижнейПанели.Ctrl = &Ctrl
		|	И КнопкиНижнейПанели.Shift = &Shift
		|	И КнопкиНижнейПанели.Alt = &Alt
		|	И КнопкиНижнейПанели.Клавиша ПОДОБНО &Клавиша
		|	И КнопкиНижнейПанели.Ссылка.РабочееМесто = &РабочееМесто";
	
	Запрос.УстановитьПараметр("Alt", Сочетание.Alt);
	Запрос.УстановитьПараметр("Ctrl", Сочетание.Ctrl);
	Запрос.УстановитьПараметр("Shift", Сочетание.Shift);
	Запрос.УстановитьПараметр("Клавиша", Строка(Сочетание.Клавиша));
	Запрос.УстановитьПараметр("РабочееМесто", РабочееМесто);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Заголовок) Тогда
			НоваяСтрока[Имя+"_"] = ВыборкаДетальныеЗаписи.Заголовок;
		Иначе
			НоваяСтрока[Имя+"_"] = ВыборкаДетальныеЗаписи.НоменклатураНаименование;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Функция возвращает представление клавиши
// Параметры:
//	ЗначениеКлавиша						- Клавиша
//
// Возвращаемое значение
//	Строка - Представление клавиши
//
&НаСервереБезКонтекста
Функция ПредставлениеКлавиши(ЗначениеКлавиша) Экспорт
	
	Если Строка(Клавиша._1) = Строка(ЗначениеКлавиша) Тогда
		Возврат "1";
	ИначеЕсли Строка(Клавиша._2) = Строка(ЗначениеКлавиша) Тогда
		Возврат "2";
	ИначеЕсли Строка(Клавиша._3) = Строка(ЗначениеКлавиша) Тогда
		Возврат "3";
	ИначеЕсли Строка(Клавиша._4) = Строка(ЗначениеКлавиша) Тогда
		Возврат "4";
	ИначеЕсли Строка(Клавиша._5) = Строка(ЗначениеКлавиша) Тогда
		Возврат "5";
	ИначеЕсли Строка(Клавиша._6) = Строка(ЗначениеКлавиша) Тогда
		Возврат "6";
	ИначеЕсли Строка(Клавиша._7) = Строка(ЗначениеКлавиша) Тогда
		Возврат "7";
	ИначеЕсли Строка(Клавиша._8) = Строка(ЗначениеКлавиша) Тогда
		Возврат "8";
	ИначеЕсли Строка(Клавиша._9) = Строка(ЗначениеКлавиша) Тогда
		Возврат "9";
	ИначеЕсли Строка(Клавиша.Num0) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num 0";
	ИначеЕсли Строка(Клавиша.Num1) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num 1";
	ИначеЕсли Строка(Клавиша.Num2) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num 2";
	ИначеЕсли Строка(Клавиша.Num3) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num 3";
	ИначеЕсли Строка(Клавиша.Num4) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num 4";
	ИначеЕсли Строка(Клавиша.Num5) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num 5";
	ИначеЕсли Строка(Клавиша.Num6) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num 6";
	ИначеЕсли Строка(Клавиша.Num7) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num 7";
	ИначеЕсли Строка(Клавиша.Num8) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num 8";
	ИначеЕсли Строка(Клавиша.Num9) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num 9";
	ИначеЕсли Строка(Клавиша.NumAdd) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num +";
	ИначеЕсли Строка(Клавиша.NumDecimal) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num .";
	ИначеЕсли Строка(Клавиша.NumDivide) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num /";
	ИначеЕсли Строка(Клавиша.NumMultiply) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num *";
	ИначеЕсли Строка(Клавиша.NumSubtract) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num -";
	Иначе
		Возврат Строка(ЗначениеКлавиша);
	КонецЕсли;
	
КонецФункции

// Функция возвращает представление клавиши
// Параметры:
//	СочетаниеКлавиш						- Сочетание клавиш для которого нужно сформировать представление
//	БезСкобок							- Флаг, указывающий, что представление должно быть сформировано без скобок
//
// Возвращаемое значение
//	Строка - Представление сочетания клавиш
//
&НаСервереБезКонтекста
Функция ПредставлениеСочетанияКлавиш2(СочетаниеКлавиш, БезСкобок = Ложь) Экспорт
	
	Если СочетаниеКлавиш.Клавиша = Клавиша.Нет Тогда
		Возврат "";
	КонецЕсли;
	
	Наименование = ?(БезСкобок, "", "(");
	Если СочетаниеКлавиш.Ctrl Тогда
		Наименование = Наименование + "Ctrl+"
	КонецЕсли;
	Если СочетаниеКлавиш.Alt Тогда
		Наименование = Наименование + "Alt+"
	КонецЕсли;
	Если СочетаниеКлавиш.Shift Тогда
		Наименование = Наименование + "Shift+"
	КонецЕсли;
	Наименование = Наименование + ПредставлениеКлавиши(СочетаниеКлавиш.Клавиша) + ?(БезСкобок, "", ")");
	
	Возврат Наименование;
	
КонецФункции

#КонецОбласти

#КонецОбласти


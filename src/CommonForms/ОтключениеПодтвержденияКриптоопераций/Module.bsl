#Область ОписаниеПеременных

&НаКлиенте
Перем ПрограммноеЗакрытие;

&НаКлиенте
Перем МассивРесурсов;

&НаКлиенте
Перем ИдентификаторСессии;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Сертификат 					= Параметры.Сертификат;
	ПараметрыПроцедуры 			= Новый Структура("ИдентификаторСертификата", СервисКриптографииСлужебный.Идентификатор(Сертификат));
	ДлительнаяОперация 			= СервисКриптографииСлужебный.ВыполнитьВФоне(
		"СервисКриптографииСлужебный.ПолучитьНастройкиПолученияВременныхПаролей", ПараметрыПроцедуры);
	
	ОтпечатокСертификата		= ЭлектроннаяПодписьВМоделиСервиса.НайтиСертификатПоИдентификатору(Сертификат);
	ДанныеПользователя			= ПолучитьДанныеТекущегоПользователя();
	
	СохраняемоеЗначениеПароля 	= ДанныеПользователя.СохраняемоеЗначениеПароля;
	Логин 						= ДанныеПользователя.Логин;
	ПарольПроверен				= НЕ ЗначениеЗаполнено(СохраняемоеЗначениеПароля);
	ШагАвторизации 				= 1;
	Элементы.ИндикаторДлительнойОперации.Картинка = ПолучитьКартинкуБиблиотеки("ДлительнаяОперация16");
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МассивРесурсов		= ПодготовитьМассивРесурсов();
	ТекущийЭлемент		= Элементы.Подтвердить;
	ПрограммноеЗакрытие	= Ложь;
	
	Если ДлительнаяОперация <> Неопределено Тогда
		ПоказатьСообщение(НСтр("ru = 'Получение настроек'"), Истина);
		Оповещение = Новый ОписаниеОповещения("ПолучитьНастройкиПолученияВременныхПаролейПослеВыполнения", ЭтотОбъект);
		СервисКриптографииСлужебныйКлиент.ОжидатьЗавершенияВыполненияВФоне(Оповещение, ДлительнаяОперация);
	КонецЕсли;	
	
	ИзменитьВидимостьПароля(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ПрограммноеЗакрытие <> Истина Тогда
		ПрограммноеЗакрытие = Истина;
		Отказ = Истина;
		
		ЗакрытьОткрытую(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПарольНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИзменитьВидимостьПароля();
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	ПарольПроверен = ПроверитьПарольПользователя(СохраняемоеЗначениеПароля, ПарольПользователя);
	Если ШагАвторизации = 2 Тогда
		ТекущийЭлемент = Элементы.КодТелефона;
	Иначе
		ТекущийЭлемент = Элементы.Подтвердить;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПользователяИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	СтатусПароля 	= "";
	
КонецПроцедуры

&НаКлиенте
Процедура КодТелефонаПриИзменении(Элемент)
	
	ПроверитьКодТелефона(КодТелефона);
	
КонецПроцедуры

&НаКлиенте
Процедура КодТелефонаИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если СтрДлина(Текст) = 6 Тогда
		КодТелефона = Текст;
		ПроверитьКодТелефона(Текст);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПовторитьКодНажатие(Элемент, СтандартнаяОбработка)
	
	ПоказатьСообщение(НСтр("ru = 'Выполняется отправка пароля в SMS-сообщении на номер'"), Истина);
	
	СтандартнаяОбработка 	= Ложь;
	КодТелефона 			= "";
	СтатусКода				= "";
	ОтключитьОбратныйОтсчет = 99;
	Оповещение 	= Новый ОписаниеОповещения("ПолучитьВременныйПарольПослеВыполнения", ЭтотОбъект);
		СервисКриптографииСлужебныйКлиент.ОжидатьЗавершенияВыполненияВФоне(Оповещение, ПолучитьПарольНаСервере(Истина, ИдентификаторСессии));
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьОткрытую(ПараметрыФормы)
	
	ПрограммноеЗакрытие = Истина;
	
	Если ПараметрыФормы = Неопределено Тогда
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("СпособПодтвержденияКриптоопераций", ПредопределенноеЗначение("Перечисление.СпособыПодтвержденияКриптоопераций.СессионныйТокен"));
		ПараметрыФормы.Вставить("Выполнено", Ложь);
		ПараметрыФормы.Вставить("Состояние", "ПродолжитьПолучениеМаркераБезопасности");
		ПараметрыФормы.Вставить("Сертификат", Сертификат);
	КонецЕсли;
	
	Если Открыта() Тогда 
		Закрыть(ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подтвердить(Команда)
	
	Если ШагАвторизации > 2 И ПарольПроверен Тогда
		Если Не ТолькоПроверка Тогда
			ОтразитьИзмененияСервер();
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("СпособПодтвержденияКриптоопераций", ПредопределенноеЗначение("Перечисление.СпособыПодтвержденияКриптоопераций.ДолговременныйТокен"));
		ПараметрыФормы.Вставить("Выполнено", Истина);
		ПараметрыФормы.Вставить("Состояние", "ПарольПринят");
		ПараметрыФормы.Вставить("Сертификат", Сертификат);
		
		ЗакрытьОткрытую(ПараметрыФормы);
		
	ИначеЕсли НЕ ПарольПроверен Тогда
		ПоказатьПредупреждение(, 
			НСтр("ru = 'В целях безопасности, для отключения подтверждения операций с ключом, 
			|следует правильно указать пароль пользователя 1С.'"), 30, 
			НСтр("ru = 'Процедура не закончена.'"));
		
	Иначе
		ПоказатьПредупреждение(, 
			НСтр("ru = 'В целях безопасности, для отключения подтверждения операций с ключом, 
			|следует полностью пройти процедуру идентификации по SMS.'"), 30, 
			НСтр("ru = 'Процедура не закончена.'"));
		
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОжидания

&НаКлиенте
Процедура ОбратныйОтсчетКодТелефона()
	
	Таймер		= ТаймерОкончание - ТекущаяДата();
	ТаймерОбший	= ТаймерСрока - ТекущаяДата();
	
	Если ШагАвторизации <> 2 Тогда
		ПовторитьКод 	= "";
		
	ИначеЕсли ОтключитьОбратныйОтсчет <> 99 Тогда
		Если Таймер > 0 Тогда
			ПовторитьКод = СтрШаблон(НСтр("ru = 'Запросить пароль повторно можно будет через %1 сек.'"), Таймер);
		ИначеЕсли Элементы.ПовторитьКод.Гиперссылка = Ложь Тогда
			ПовторитьКод = НСтр("ru = 'Отправить пароль повторно'");
			Элементы.ПовторитьКод.Гиперссылка = Истина;
		КонецЕсли;	
		
		Если ОтключитьОбратныйОтсчет > 0 Тогда
			ОтключитьОбратныйОтсчет = ОтключитьОбратныйОтсчет - 1;
		ИначеЕсли ТаймерОбший > 0 И Таймер > 0 Тогда
			СтатусКода = "";
		ИначеЕсли ТаймерОбший > 0 Тогда
			СтатусКода = СтрШаблон(НСтр("ru = 'Истекает через %1:%2'"), Цел(ТаймерОбший / 60), Формат(ТаймерОбший % 60, "ЧЦ=2; ЧВН="));
		Иначе
			СтатусКода = НСтр("ru = 'Истек срок действия пароля'");
			Элементы.СтатусКода.ЦветТекста = WebЦвета.Красный;
		КонецЕсли;
		
		Если ТаймерОбший > 0 ИЛИ Таймер > 0 Тогда
			ПодключитьОбработчикОжидания("ОбратныйОтсчетКодТелефона", 1, Истина);
		КонецЕсли;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьОбратныйОтсчетКодТелефона(Таймер, СрокДействия)
	
	ТаймерОкончание = ТекущаяДата() + Таймер;
	ТаймерСрока		= ТекущаяДата() + СрокДействия;
	ПовторитьКод 	= "";
	СтатусКода		= "";
	
	Элементы.СтатусКода.ЦветТекста = WebЦвета.Серый;
	Элементы.ПовторитьКод.Гиперссылка = Ложь;
	ОтключитьОбратныйОтсчет = 0;
	ПодключитьОбработчикОжидания("ОбратныйОтсчетКодТелефона", 1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверитьСледующийШаг()
	
	ШагАвторизации = ШагАвторизации + 1;
	
	Если ШагАвторизации = 2 Тогда
		Шаг_КодТелефона();
		
	ИначеЕсли ШагАвторизации = 3 Тогда
		Если Не ЗначениеЗаполнено(СохраняемоеЗначениеПароля) Тогда
			ШагАвторизации = 4;
		КонецЕсли;
		ПоказатьСообщение("", Ложь);
		
	КонецЕсли;	
	
	УправлениеФормой(ЭтотОбъект);
	
	Если ШагАвторизации = 2 Тогда
		ТекущийЭлемент 	= Элементы.КодТелефона;
	ИначеЕсли ШагАвторизации = 3 И НЕ ПарольПроверен Тогда
		ТекущийЭлемент 	= Элементы.ПарольПользователя;
	Иначе
		ТекущийЭлемент 	= Элементы.Подтвердить;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Шаг_КодТелефона()
	
	ПоказатьСообщение(НСтр("ru = 'Выполняется отправка пароля в SMS-сообщении на номер'"), Истина);
	ТекущийЭлемент 	= Элементы.КодТелефона;
	Оповещение 		= Новый ОписаниеОповещения("ПолучитьВременныйПарольПослеВыполнения", ЭтотОбъект);
	СервисКриптографииСлужебныйКлиент.ОжидатьЗавершенияВыполненияВФоне(Оповещение, ПолучитьПарольНаСервере());
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСообщение(ТекстСообщения, Ожидать = Ложь, ЭтоОшибка = Ложь)
	
	Элементы.Пояснение.Заголовок = ТекстСообщения;
	Если ЭтоОшибка Тогда 
		Элементы.Пояснение.ЦветТекста = WebЦвета.Красный;
	Иначе
		Элементы.Пояснение.ЦветТекста = Элементы.ПовторитьКод.ЦветТекста;
	КонецЕсли;	
	
	Если Элементы.ИндикаторДлительнойОперации.Видимость <> Ожидать Тогда
		Элементы.ИндикаторДлительнойОперации.Видимость = Ожидать;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВременныйПарольПослеВыполнения(Результат, ВходящийКонтекст) Экспорт
	
	Результат = СервисКриптографииСлужебныйКлиент.ПолучитьРезультатВыполненияВФоне(Результат);
	
	Если Результат.Выполнено Тогда
		Таймер = Результат.РезультатВыполнения.ЗадержкаПередПовторнойОтправкой;
		Если Результат.РезультатВыполнения.Свойство("ИдентификаторСессии") Тогда 
			ИдентификаторСессии = Результат.РезультатВыполнения.ИдентификаторСессии;
		КонецЕсли;
		
		ПоказатьСообщение(НСтр("ru = 'Пароль отправлен на номер:'") + " " + ПредставлениеТелефона(Получатель));

		ЗапуститьОбратныйОтсчетКодТелефона(Таймер, 600);
		УправлениеФормой(ЭтотОбъект);
		
	Иначе
		ПоказатьСообщение(НСтр("ru = 'Сервис отправки SMS-сообщений временно недоступен.'"), , Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьКодТелефона(ТекущийКод)
	
	Если ШагАвторизации <> 2 Тогда
		ОтключитьОбратныйОтсчет = 99;
		
	ИначеЕсли ВыполняетсяПроверка Тогда
		СтатусКода 	= НСтр("ru = 'Ожидается ответ'");
		ОтключитьОбратныйОтсчет = 10;
		
	ИначеЕсли ОтключитьОбратныйОтсчет = 99 Тогда
		СтатусКода 	= НСтр("ru = 'Необходимо повторить процедуру'");
		
	ИначеЕсли ЗначениеЗаполнено(ТекущийКод) И СтрДлина(ТекущийКод) = 6 Тогда
		ВыполняетсяПроверка = Истина;
		ПоказатьСообщение(НСтр("ru = 'Выполняется проверка пароля'"), Истина);
		Оповещение 			= Новый ОписаниеОповещения("ПодтвердитьПарольПослеВыполнения", ЭтотОбъект);
		СервисКриптографииСлужебныйКлиент.ОжидатьЗавершенияВыполненияВФоне(Оповещение, ПодтвердитьНаСервере(ИдентификаторСессии));
		
	ИначеЕсли ЗначениеЗаполнено(ТекущийКод) И СтрДлина(ТекущийКод) <> 6 Тогда
		СтатусКода 	= НСтр("ru = 'Пароль должен быть из 6 цифр'");
		ОтключитьОбратныйОтсчет = 10;
		
	Иначе
		СтатусКода 	= НСтр("ru = 'Пароль не указан'");
		ОтключитьОбратныйОтсчет = 10;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьНастройкиПолученияВременныхПаролейПослеВыполнения(Результат, ВходящийКонтекст) Экспорт
	
	Результат = СервисКриптографииСлужебныйКлиент.ПолучитьРезультатВыполненияВФоне(Результат);
	
	Если Результат.Выполнено Тогда
		НастройкиТелефона   = Результат.РезультатВыполнения;
		Получатель 			= НастройкиТелефона.Телефон;
		ПоказатьСообщение("", Ложь);
		ПроверитьСледующийШаг();
		
	Иначе	
		ПоказатьСообщение(НСтр("ru = 'Сервис отправки SMS-сообщений временно недоступен. Повторите попытку позже.'"), , Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПоказаПредупреждения(ВходящийКонтекст) Экспорт
	
	ЗакрытьОткрытую(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидимостьПароля(ПринудительноСпрятать = Ложь)
	
	НовыйРежим 	= НЕ Элементы.ПарольПользователя.РежимПароля;
	Элементы.ПарольПользователя.КнопкаВыбора = НЕ МассивРесурсов[0].Вид = ВидКартинки.Пустая;
	
	Если ПринудительноСпрятать Тогда
		Элементы.ПарольПользователя.КартинкаКнопкиВыбора = МассивРесурсов[0];
		Элементы.ПарольПользователя.РежимПароля = Истина;
		
	ИначеЕсли Не НовыйРежим Тогда
		Элементы.ПарольПользователя.КартинкаКнопкиВыбора = МассивРесурсов[1];
		Элементы.ПарольПользователя.РежимПароля = НовыйРежим;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы 	= Форма.Элементы;
	
	Элементы.КодТелефона.Доступность = Форма.ШагАвторизации = 2;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПарольНаСервере(Повторно = Ложь, ИдентификаторСессии = Неопределено)
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ИдентификаторСертификата", СервисКриптографииСлужебный.Идентификатор(Сертификат));
	ПараметрыПроцедуры.Вставить("ПовторнаяОтправка", Повторно);
	ПараметрыПроцедуры.Вставить("Тип", "phone");
	ПараметрыПроцедуры.Вставить("ИдентификаторСессии", ИдентификаторСессии);
	
	Возврат СервисКриптографииСлужебный.ВыполнитьВФоне(
		"СервисКриптографииСлужебный.ПолучитьВременныйПароль", ПараметрыПроцедуры);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеТекущегоПользователя()
	
	Результат = Новый Структура("Логин, СохраняемоеЗначениеПароля");
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекущийПользователь 		= Пользователи.АвторизованныйПользователь();
	ИдентификаторПользователя 	= ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущийПользователь, "ИдентификаторПользователяИБ");
	СвойстваПользователя 		= Пользователи.СвойстваПользователяИБ(ИдентификаторПользователя);
	
	Если СвойстваПользователя <> Неопределено Тогда
		Результат.Логин 					= СвойстваПользователя.Имя;
		Результат.СохраняемоеЗначениеПароля = СвойстваПользователя.СохраняемоеЗначениеПароля;
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПроверитьПарольПользователя(СохраняемоеЗначениеПароля, ТекущийПароль)
	
	Результат = Ложь;
	
	Если НЕ ЗначениеЗаполнено(СохраняемоеЗначениеПароля) и ПустаяСтрока(ТекущийПароль) Тогда
		Результат = Истина;
	ИначеЕсли ЗначениеЗаполнено(СохраняемоеЗначениеПароля) Тогда
		ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.SHA1);
		ХешированиеДанных.Добавить(ТекущийПароль);
			
		НовоеЗначение = Base64Строка(ХешированиеДанных.ХешСумма);
		
		ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.SHA1);
		ХешированиеДанных.Добавить(ВРег(ТекущийПароль));
		
		НовоеЗначение = НовоеЗначение + ","
			+ Base64Строка(ХешированиеДанных.ХешСумма);
			
		Результат = СохраняемоеЗначениеПароля = НовоеЗначение;
	КонецЕсли;	
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОтразитьИзмененияСервер()
	
	ЭлектроннаяПодписьВМоделиСервиса.НастроитьИспользованиеДолговременногоТокена(Перечисления.СпособыПодтвержденияКриптоопераций.ДолговременныйТокен, Сертификат);
	
КонецПроцедуры	

&НаСервереБезКонтекста
Процедура СохранитьМаркерыБезопасности(Знач МаркерыБезопасности)
	
	УстановитьПривилегированныйРежим(Истина);
	СервисКриптографииСлужебный.СохранитьМаркерыБезопасности(МаркерыБезопасности);
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Функция ПодтвердитьНаСервере(ИдентификаторСессии = Неопределено)
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ИдентификаторСертификата", СервисКриптографииСлужебный.Идентификатор(Сертификат));
	ПараметрыПроцедуры.Вставить("ВременныйПароль", КодТелефона);
	ПараметрыПроцедуры.Вставить("ИдентификаторСессии", ИдентификаторСессии);
	
	Возврат СервисКриптографииСлужебный.ВыполнитьВФоне(
		"СервисКриптографииСлужебный.ПолучитьСеансовыйКлюч", ПараметрыПроцедуры);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПредставлениеТелефона(ТекущийТелефон)
	
	Результат   = СокрЛП(ТекущийТелефон);
	Счетчик 	= СтрДлина(Результат);
	ВсегоЦифр	= 0;
	
	Пока Счетчик > 0 Цикл
		ЭтоЦифра    = СтрНайти("0123456789", Сред(Результат, Счетчик, 1))  > 0;
		Если ЭтоЦифра Тогда
			ВсегоЦифр = ВсегоЦифр + 1;
		КонецЕсли;
		
		Если ВсегоЦифр > 2 И ЭтоЦифра Тогда
			Результат = Сред(Результат, 1, Счетчик - 1) + "*" + Сред(Результат, Счетчик + 1);
		КонецЕсли;
		
		Если ВсегоЦифр >= 7 Тогда
			Прервать;
		КонецЕсли;
		
		Счетчик 	= Счетчик - 1;
		
	КонецЦикла;	
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПодготовитьМассивРесурсов()
	
	Результат = Новый Массив;
	Результат.Добавить(ПолучитьКартинкуБиблиотеки("ВидимостьЗакрыто"));
	Результат.Добавить(ПолучитьКартинкуБиблиотеки("ВидимостьОткрыто"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.СпособыПодтвержденияКриптоопераций.ДолговременныйТокен"));
	
	Возврат Результат;

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьКартинкуБиблиотеки(ИмяКартинки)
	
	Если Метаданные.ОбщиеКартинки.Найти(ИмяКартинки) <> Неопределено Тогда
		Результат = БиблиотекаКартинок[ИмяКартинки];
	Иначе
		Результат = Новый Картинка;
	КонецЕсли;	
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПодтвердитьПарольПослеВыполнения(Результат, ВходящийКонтекст) Экспорт

	Результат 			= СервисКриптографииСлужебныйКлиент.ПолучитьРезультатВыполненияВФоне(Результат);
	ВыполняетсяПроверка = Ложь;
	
	ПоказатьСообщение("", Ложь);
	
	Если Результат.Выполнено Тогда
		СохранитьМаркерыБезопасности(Результат.РезультатВыполнения);
		СтатусКода		= НСтр("ru = 'Указан верный пароль'");
		ПроверитьСледующийШаг();
		УправлениеФормой(ЭтотОбъект);
		
	Иначе
		ТекстИсключения = ОбработкаОшибок.ПодробноеПредставлениеОшибки(Результат.ИнформацияОбОшибке);
		Если СтрНайти(ТекстИсключения, "УказанНеверныйПароль") Тогда
			СтатусКода = НСтр("ru = 'Указан неверный пароль'");
			ОтключитьОбратныйОтсчет = 10;
		ИначеЕсли СтрНайти(ТекстИсключения, "ПревышенЛимитПопытокВводаПароля") Тогда
			СтатусКода = НСтр("ru = 'Превышен лимит попыток'"); 
			ИдентификаторСессии = "";
			ОтключитьОбратныйОтсчет = 99;
		ИначеЕсли СтрНайти(ТекстИсключения, "СрокДействияПароляИстек") Тогда
			СтатусКода = НСтр("ru = 'Срок действия пароля истек'");
			ИдентификаторСессии = "";
			ОтключитьОбратныйОтсчет = 99;
		Иначе 
			СтатусКода = НСтр("ru = 'Выполнение операции временно невозможно'");
			ОтключитьОбратныйОтсчет = 99;
		КонецЕсли;		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
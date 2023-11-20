///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "СПАРКРиски".
// ОбщийМодуль.СПАРКРискиПереопределяемый.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет свойства справочников контрагентов.
// Параметры:
//	СвойстваСправочников - ТаблицаЗначений - в таблице заполняется список
//		справочников контрагентов и их свойства. Колонки таблицы:
//		* Имя - Строка - имя справочника;
//		* Иерархический - Булево - справочник является иерархическим;
//		* РеквизитИНН - Строка- имя реквизита ИНН;
//		* ИмяФормыПодбора - Строка - если для справочника определена собственная
//			форма подбора контрагентов, в этом поле можно указать ее полное имя.
//			Форма должна возвращать в оповещении о выборе Массив ссылок на
//			элементы справочника контрагентов.
//			Если не определена, тогда используется стандартная форма подбора.
//
//@skip-warning
Процедура ПриОпределенииСвойствСправочниковКонтрагентов(СвойстваСправочников) Экспорт
	
	СПАРКРискиУНФ.ПриОпределенииСвойствСправочниковКонтрагентов(СвойстваСправочников);
	
КонецПроцедуры

// В методе заполняется список контрагентов для постановки на мониторинг и для
// снятия с мониторинга.
// Используется регламентным заданием ЗаполнениеКонтрагентовНаМониторингеСПАРКРиски
// и методом программного интерфейса СПАРКРиски.ЗаполнитьКонтрагентовНаМониторинге().
// При получении списком контрагентов можно использовать обращение к регистру сведений
// КонтрагентыНаМониторингеСПАРКРиски: если запись присутствует в регистре сведений,
// то это означает, что контрагент уже поставлен на мониторинг.
// Допускается обращение к регистру сведений КонтрагентыНаМониторингеСПАРКРиски:
// контрагент уже добавлен в список для мониторинга, если в регистре существует
// запись со значениями измерений:
//	- Контрагент = <Текущий контрагент>;
//	- РучноеДобавление = Ложь.
//
// Параметры:
//	ПоставитьНаМониторинг - Массив из ОпределяемыйТипСсылка.КонтрагентБИП - контрагенты для постановки на мониторинг;
//	СнятьСМониторинга - Массив из ОпределяемыйТипСсылка.КонтрагентБИП -  контрагенты для снятия с мониторинга;
//
//@skip-warning
Процедура КонтрагентыДляМониторинга(ПоставитьНаМониторинг, СнятьСМониторинга) Экспорт
	
	
КонецПроцедуры

// Определяет параметры отображения отчетов.
//
// Параметры:
//	ПараметрыОтображения - Структура - параметры отображения отчетов.
//		Поля структуры:
//		* ИмяМакетаОформления - Строка - имя макета оформления отчетов,
//			По умолчанию используются стандартный макет оформления.
//
//@skip-warning
Процедура ПараметрыОтображенияОтчетов(ПараметрыОтображения) Экспорт
	
	СПАРКРискиУНФ.ПараметрыОтображенияОтчетов(ПараметрыОтображения);
	
КонецПроцедуры

#Область ИндексыСПАРКРиски

// Вызывается из форм, в которые встроен показ индексов 1СПАРК Риски.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения - форма, в которой инициировано событие;
//  КонтрагентОбъект     - Объект, Неопределено - заполняется в том случае, если форма - это форма
//                         элемента справочника, а не форма документа.
//  Контрагент           - ОпределяемыйТип.КонтрагентБИП, Строка - Контрагент или ИНН контрагента;
//  ВидКонтрагента       - ПеречислениеСсылка.ВидыКонтрагентовСПАРКРиски - вид проверки данных контрагента;
//  ПараметрыОтображения - Структура - прочие параметры. Возможные ключи:
//    * ВариантОтображения - Строка - см. описание в СПАРКРиски.ОтобразитьИндексыСПАРК.
//  ИспользованиеРазрешено          - Булево - признак разрешения использования функциональности;
//  СтандартнаяОбработкаБиблиотекой - Булево - в этот параметр возвратить Ложь, если надо запретить
//                                    стандартную обработку события библиотекой.
//
//@skip-warning
Процедура ПриСозданииНаСервере(
		Форма,
		КонтрагентОбъект,
		Контрагент,
		ВидКонтрагента,
		ПараметрыОтображения,
		ИспользованиеРазрешено,
		СтандартнаяОбработкаБиблиотекой) Экспорт


КонецПроцедуры

// Переопределяет время ожидания завершения фонового задания получения индексов СПАРК Риски.
//
// Параметры:
//  ОжидатьЗавершение - Число - значение ключа "ОжидатьЗавершение" для параметра ПараметрыВыполнения.ОжидатьЗавершение
//           процедуры ДлительныеОперации.ВыполнитьВФоне. Если = 0, то не ожидать завершения.
//
//@skip-warning
Процедура ВремяОжиданияФоновогоЗадания(ОжидатьЗавершение) Экспорт
	
	СПАРКРискиУНФ.ВремяОжиданияФоновогоЗадания(ОжидатьЗавершение);
	
КонецПроцедуры

#КонецОбласти

#Область ОтчетыСПАКРРиски

// Определяет данные входящего НДС для формирования отчета "Надежность входящего НДС 1СПАРК Риски".
//
// Параметры:
//  МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - менеджер в который должны быть
//                            помещена временная таблица с данными об НДС и именем "ВТ_ДанныеНДС".
//                            Таблица должна содержать поля:
//                              *Контрагент - ОпределяемыйТип.КонтрагентБИП - ссылка на объект контрагента;
//                              *Сумма - Число - общая сумма покупок за переданный период;
//                              *СуммаНДС - Число - общая сумма покупок за переданный период;
//  ПараметрыОтбора - Структура - настройки отбора отчета:
//   *ДатаНачала - Дата - начало периода отчета;
//   *ДатаОкончания - Дата - окончание периода отчета;
//   *Организация - ОпределяемыйТип.Организация, Неопределено - организация для которые необходимо сделать выборку.
//                  Если не заполнено, игнорировать отбор;
//   *Контрагенты - Массив из ОпределяемыйТип.КонтрагентБИП, Неопределено - список контрагентов по которым формируется отчет.
//                  Если не заполнено, игнорировать отбор;
//  Использование - Булево - если Ложь пользователю будет показана ошибка. Следует использовать в программах
//                  в которых не ведется учет входящего НДС.
//
Процедура ПриФормированииОтчетаНадежностьВходящегоНДС(МенеджерВременныхТаблиц, ПараметрыОтбора, Использование) Экспорт
	
	СПАРКРискиУНФ.ПриФормированииОтчетаНадежностьВходящегоНДС(МенеджерВременныхТаблиц, ПараметрыОтбора, Использование);
	
КонецПроцедуры

// Определяет данные дебиторской задолженности для формирования отчета "Надежность входящего НДС 1СПАРК Риски".
//
// Параметры:
//  МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - менеджер в который должны быть
//                            помещена временная таблица с данными о задолженности и именем "ВТ_Долги".
//                            Таблица должна содержать поля:
//                              *Раздел - Строка - поле группировки в отчете;
//                              *Контрагент - ОпределяемыйТип.КонтрагентБИП - ссылка на объект контрагента;
//                              *Задолженность - Число - общая сумма задолженности;
//  ПараметрыОтбора - Структура - настройки отбора отчета:
//   *Дата - Дата - дата на которую выполняется выборка данных;
//   *Организация - ОпределяемыйТип.Организация, Неопределено - организация для которые необходимо сделать выборку.
//                  Если не заполнено, игнорировать отбор;
//   *Контрагенты - Массив из ОпределяемыйТип.КонтрагентБИП, Неопределено - список контрагентов по которым формируется отчет.
//                  Если не заполнено, игнорировать отбор;
//  Использование - Булево - если Ложь пользователю будет показана ошибка. Следует использовать в программах
//                  в которых не ведется учет входящего НДС.
//
Процедура ПриФормированииНадежностьДебиторов(МенеджерВременныхТаблиц, ПараметрыОтбора, Использование) Экспорт
	
	СПАРКРискиУНФ.ПриФормированииНадежностьДебиторов(МенеджерВременныхТаблиц, ПараметрыОтбора, Использование);
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИБ

// Вызывается при переходе на версию конфигурации с внедренной подсистемой СПАРКРиски.
// Возвращает параметры, необходимые для начального заполнения данных
// в объектах метаданных подсистемы.
//
// Параметры:
//	ПараметрыЗаполнения - Структура - в параметре возвращаются значения для
//		начального заполнения данных подсистемы.
//		Поля структуры:
//		* ЗапросСвойствКонтрагентов - Строка - текст запроса для получения свойств
//			контрагентов, подлежащих проверке в сервисе 1СПАРК Риски: только
//			юридические лица, не являющиеся иностранными.
//			В запросе должны быть определены колонки:
//			** Контрагент - ОпределяемыйТип.КонтрагентБИП - ссылка на элемент
//				справочника контрагентов;
//			** ИНН - Строка - ИНН контрагента;
//			** СвояОрганизация - Булево - признак того, что контрагент является собственным -
//				дочерним по отношению к организации, в которой ведется учет.
//				Свойство может быть использовано для отбора данных в отчетах;
//			Значение по умолчанию: Неопределено.
//			Если значение свойства Неопределено, будет вызвано исключение.
//			Если значение - пустая строка - получение свойств контрагентов
//			не будет выполнено;
//		* ЗаполнитьКонтрагентовНаМониторинге - Булево - провести заполнение
//			списка контрагентов на мониторинге в соответствии с алгоритмом,
//			определенным в методе КонтрагентыДляМониторинга() текущего модуля.
//			Значение по умолчанию: Ложь;
//		* ЗаполнитьИндексыКонтрагентов - Булево - заполнить значения индексов
//			контрагентов. Истина - заполнить, Ложь - не заполнять.
//			Для заполненных индексов значения будут обновлены при следующем
//			обновлении значений индексов по расписанию (в регламентов).
//			Если индексы не заполнены, тогда контрагенты будут добавляться в
//			список индексов "По требованию";
//			Правило заполнения определяется значением поля
//			ЗапросКонтрагентовДляЗаполненияИндексов.
//		* ЗапросКонтрагентовДляЗаполненияИндексов - Строка - текст запроса для
//			получения контрагентов для заполнения индексов. Используется только
//			при ЗаполнитьИндексыКонтрагентов = Истина.
//			Если значение <Пустая строка>, список индексов будет заполнен
//			всеми контрагентами, полученными при выполнении запроса
//			ЗапросСвойствКонтрагентов, иначе - в соответствии с текстом запроса.
//			Значение по умолчанию: <Пустая строка>.
//			В запросе должна быть определена колонка:
//			** Контрагент - ОпределяемыйТип.КонтрагентБИП - ссылка на элемент
//				справочника контрагентов;
//
//@skip-warning
Процедура ПараметрыНачальногоЗаполненияДанных1СПАРКРискиЮридическихЛиц(ПараметрыЗаполнения) Экспорт
	
	СПАРКРискиУНФ.ПараметрыНачальногоЗаполненияДанных1СПАРКРискиЮридическихЛиц(ПараметрыЗаполнения);
	
КонецПроцедуры

// Вызывается при переходе на версию конфигурации с внедренной подсистемой СПАРКРиски.
// Возвращает параметры, необходимые для начального заполнения данных
// в объектах метаданных подсистемы.
//
// Параметры:
//	ПараметрыЗаполнения - Структура - в параметре возвращаются значения для
//		начального заполнения данных подсистемы.
//		Поля структуры:
//		* ЗапросСвойствКонтрагентов - Строка - текст запроса для получения свойств
//			контрагентов, подлежащих проверке в сервисе 1СПАРК Риски: только
//			индивидуальных предпринимателей, не являющиеся иностранными.
//			В запросе должны быть определены колонки:
//			** Контрагент - ОпределяемыйТип.КонтрагентБИП - ссылка на элемент
//				справочника контрагентов;
//			** ИНН - Строка - ИНН контрагента;
//			** СвояОрганизация - Булево - признак того, что контрагент является собственным -
//				дочерним по отношению к организации, в которой ведется учет.
//				Свойство может быть использовано для отбора данных в отчетах;
//			Значение по умолчанию: Неопределено.
//			Если значение свойства Неопределено, будет вызвано исключение.
//			Если значение - пустая строка - получение свойств контрагентов
//			не будет выполнено;
//		* ЗаполнитьКонтрагентовНаМониторинге - Булево - провести заполнение
//			списка контрагентов на мониторинге в соответствии с алгоритмом,
//			определенным в методе КонтрагентыДляМониторинга() текущего модуля.
//			Значение по умолчанию: Ложь;
//		* ЗаполнитьИндексыКонтрагентов - Булево - заполнить значения индексов
//			контрагентов. Истина - заполнить, Ложь - не заполнять.
//			Для заполненных индексов значения будут обновлены при следующем
//			обновлении значений индексов по расписанию (в регламентов).
//			Если индексы не заполнены, тогда контрагенты будут добавляться в
//			список индексов "По требованию";
//			Правило заполнения определяется значением поля
//			ЗапросКонтрагентовДляЗаполненияИндексов.
//		* ЗапросКонтрагентовДляЗаполненияИндексов - Строка - текст запроса для
//			получения контрагентов для заполнения индексов. Используется только
//			при ЗаполнитьИндексыКонтрагентов = Истина.
//			Если значение <Пустая строка>, список индексов будет заполнен
//			всеми контрагентами, полученными при выполнении запроса
//			ЗапросСвойствКонтрагентов, иначе - в соответствии с текстом запроса.
//			Значение по умолчанию: <Пустая строка>.
//			В запросе должна быть определена колонка:
//			** Контрагент - ОпределяемыйТип.КонтрагентБИП - ссылка на элемент
//				справочника контрагентов;
//
//@skip-warning
Процедура ПараметрыНачальногоЗаполненияДанных1СПАРКРискиИндивидуальныхПредпринимателей(ПараметрыЗаполнения) Экспорт
	
	СПАРКРискиУНФ.ПараметрыНачальногоЗаполненияДанных1СПАРКРискиИндивидуальныхПредпринимателей(ПараметрыЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

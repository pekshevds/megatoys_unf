#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция СоставБригады(Бригада, Организация, Дата = '0001-01-01') Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	БригадыСостав.Сотрудник КАК Сотрудник,
	|	ЕСТЬNULL(СотрудникиСрезПоследних.СтруктурнаяЕдиница, ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)) КАК СтруктурнаяЕдиница
	|ИЗ
	|	Справочник.Бригады.Состав КАК БригадыСостав
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники.СрезПоследних(&ПериодСреза, Организация = &Организация) КАК СотрудникиСрезПоследних
	|		ПО БригадыСостав.Сотрудник = СотрудникиСрезПоследних.Сотрудник
	|ГДЕ
	|	БригадыСостав.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Бригада);	
	Запрос.УстановитьПараметр("Организация", Организация);	
	Запрос.УстановитьПараметр("ПериодСреза", ?(ЗначениеЗаполнено(Дата), Дата, КонецДня(ТекущаяДата())));
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти 	
	
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если Параметры.Свойство("СотрудникИБригада") 
		И Параметры.СотрудникИБригада 
		И ВидФормы = "ФормаВыбора" Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "Справочник.Сотрудники.Форма.ФормаСпискаСотрудникиИБригады";
	КонецЕсли; 	
	
КонецПроцедуры

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Свойство("СотрудникИБригада") И Параметры.СотрудникИБригада Тогда
		СтандартнаяОбработка = Ложь;
		ПроизводствоСервер.ЗаполнитьДанныеВыбораСотрудникиБригады(ДанныеВыбора, Параметры);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти 

#КонецЕсли
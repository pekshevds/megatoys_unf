
#Область ПрограммныйИнтерфейс

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОтражениеНДСПриобретения() Экспорт
	
	Возврат НСтр("ru='НДС по приобретенным ценностям'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СторнированиеНДСПриобретения() Экспорт
	
	Возврат НСтр("ru = 'Сторнирование НДС по приобретенным ценностям'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОтражениеНДСПродажи() Экспорт
	
	Возврат НСтр("ru='НДС с продажи'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция КурсоваяРазница() Экспорт
	
	Возврат НСтр("ru='Курсовая разница'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОплатаОтБанкаЭквайера() Экспорт
	
	Возврат НСтр("ru='Оплата от банка-эквайера'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция КомиссияБанкаЭквайера() Экспорт
	
	Возврат НСтр("ru='Комиссия банка-эквайера'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОприходованиеЗапасов() Экспорт
	
	Возврат НСтр("ru = 'Оприходование запасов'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОприходованиеДополнительныхРасходов() Экспорт
	
	Возврат НСтр("ru = 'Оприходование доп. расходов'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПрочееОприходованиеЗапасов() Экспорт
	
	Возврат НСтр("ru = 'Прочее оприходование запасов'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОприходованиеЗатрат() Экспорт
	
	Возврат НСтр("ru = 'Оприходование затрат'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОприходованиеЗапасовПринятых() Экспорт
	
	Возврат НСтр("ru = 'Оприходование запасов принятых'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОприходованиеЗапасовПереданных() Экспорт
	
	Возврат НСтр("ru = 'Оприходование запасов переданных'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПриемЗапасов() Экспорт
	
	Возврат НСтр("ru = 'Прием запасов'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОплатаПоставщику() Экспорт
	
	Возврат НСтр("ru = 'Оплата поставщику'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПрочиеРасходы() Экспорт
	
	Возврат НСтр("ru = 'Прочие расходы'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПрочиеДоходы() Экспорт
	
	Возврат НСтр("ru = 'Прочие доходы'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПоступлениеПрочихДоходов() Экспорт
	
	Возврат НСтр("ru = 'Поступление прочих доходов'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция Взаимозачет() Экспорт
	
	Возврат НСтр("ru = 'Взаимозачет'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОтражениеЗатрат() Экспорт
	
	Возврат НСтр("ru = 'Отражение затрат'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ЗачетПредоплаты() Экспорт
	
	Возврат НСтр("ru = 'Зачет предоплаты'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СторнированиеПредоплаты() Экспорт
	
	Возврат НСтр("ru = 'Сторнирование предоплаты'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ВосстановлениеАванса() Экспорт
	
	Возврат НСтр("ru = 'Восстановление аванса'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СторнированиеСебестоимости() Экспорт
	
	Возврат НСтр("ru = 'Сторнирование себестоимости'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СторнированиеВыручки() Экспорт
	
	Возврат НСтр("ru = 'Сторнирование выручки'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СторнированиеПоставки() Экспорт
	
	Возврат НСтр("ru = 'Сторнирование поставки'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СторнированиеАвансаПокупателя() Экспорт
	
	Возврат НСтр("ru = 'Сторнирование аванса покупателя'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция Наценка() Экспорт
	
	Возврат НСтр("ru = 'Наценка'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ТаможеннаяПошлина() Экспорт
	
	Возврат НСтр("ru = 'Таможенная пошлина'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ТаможенныйСбор() Экспорт
	
	Возврат НСтр("ru = 'Таможенный сбор'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ТаможенныйШтраф() Экспорт
	
	Возврат НСтр("ru = 'Таможенный штраф'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ТаможенныйНДС() Экспорт
	
	Возврат НСтр("ru = 'НДС, уплаченный таможенным органам'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОтражениеДоходов() Экспорт
	
	Возврат НСтр("ru='Отражение доходов'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОтражениеРасходов() Экспорт
	
	Возврат НСтр("ru='Отражение расходов'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция Выручка() Экспорт
	
	Возврат НСтр("ru='Выручка от продажи'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция Доставка() Экспорт
	
	Возврат НСтр("ru='Выручка от доставки'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ВозникновениеАвансаПокупателя() Экспорт
	
	Возврат НСтр("ru = 'Возникновение аванса покупателя'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СписаниеЗапасов() Экспорт
	
	Возврат НСтр("ru = 'Списание запасов'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция НачислениеАмортизации() Экспорт
	
	Возврат НСтр("ru = 'Начисление амортизации'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СписаниеАмортизации() Экспорт
	
	Возврат НСтр("ru = 'Списание амортизации'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОплатаДолга() Экспорт
	
	Возврат НСтр("ru = 'Оплата долга'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОплатаСБП() Экспорт
	
	Возврат НСтр("ru = 'Оплата СБП'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОплатаКредитом() Экспорт
	
	Возврат НСтр("ru = 'Оплата кредитом'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОплатаПлатежнымиКартами() Экспорт
	
	Возврат НСтр("ru = 'Оплата платежными картами'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ВыдачаНаличныхСКарты() Экспорт
	
	Возврат НСтр("ru = 'Выдача наличных с платежной карты'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОтражениеРасходовПоПереработке() Экспорт
	
	Возврат НСтр("ru = 'Отражение расходов по переработке'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ЗадолженностьКомитенту() Экспорт
	
	Возврат НСтр("ru = 'Задолженность комитенту'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СторнированиеДоходов() Экспорт
	
	Возврат НСтр("ru = 'Сторнирование доходов'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СторнированиеКурсовойРазницы() Экспорт
	
	Возврат НСтр("ru = 'Сторнирование курсовой разницы'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СторнированиеРасходов() Экспорт
	
	Возврат НСтр("ru = 'Сторнирование расходов'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОтчетОтКомиссионера() Экспорт
	
	Возврат НСтр("ru = 'Отчет комиссионера'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПередачаЗапасов() Экспорт
	
	Возврат НСтр("ru='Передача запасов'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СебестоимостьПродажи() Экспорт
	
	Возврат НСтр("ru='Себестоимость продажи'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция КомиссионноеВознаграждение() Экспорт
	
	Возврат НСтр("ru='Комиссионное вознаграждение'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СторнированиеКомиссионногоВознаграждения() Экспорт
	
	Возврат НСтр("ru = 'Сторнирование комиссионного вознаграждения'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция НачислениеНДСПродажи() Экспорт
	
	Возврат НСтр("ru = 'Начисление НДС с продаж'");
	
КонецФункции


#КонецОбласти



#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьОчередь(Команда)
	
	ВыполнитьОчередьНаСервере();
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОчередьСообщений(Команда)
	ВыполнитьОчередьСообщенийНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВыполнитьОчередьНаСервере()
	
	АссистентУправления.ВыполнитьРегулярныеЗадачиСейчас();
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьОчередьСообщенийНаСервере()
	
	ОбсужденияУНФ.ЗаписатьОтложенныеСообщенияВСистемуВзаимодействия();
	
КонецПроцедуры

#КонецОбласти

Функция ПолучитьСерверВБ()Экспорт 
	
	Возврат "statistics-api.wildberries.ru";
КонецФункции

Функция ПолучитьСерверОзон()Экспорт 
	
	Возврат "api-seller.ozon.ru";
КонецФункции

Функция ПолучитьпараметрыПодключенияКОзонЛК1()Экспорт 
	
	Заголовки = Новый Соответствие;		
	Заголовки.Вставить("Client-Id", "53300");
	Заголовки.Вставить("Api-Key", "1803b312-5970-4978-bc04-8d856d114115");
		
	Возврат Заголовки;
КонецФункции

Функция ПолучитьпараметрыПодключенияКОзонЛК2()Экспорт 
	
	Заголовки = Новый Соответствие;		
	Заголовки.Вставить("Client-Id", "893430");
	Заголовки.Вставить("Api-Key", "e0a87961-c930-4520-bcec-40fb4dafef33");
		
	Возврат Заголовки;
КонецФункции

Функция ПолучитьпараметрыПодключенияКВБЛК1()Экспорт 
	
	Заголовки = Новый Соответствие;		
	Заголовки.Вставить("Authorization", "eyJhbGciOiJFUzI1NiIsImtpZCI6IjIwMjMxMDI1djEiLCJ0eXAiOiJKV1QifQ.eyJlbnQiOjEsImV4cCI6MTcxNzYyNTA0NSwiaWQiOiI4NjM3N2RlYy01ZmNmLTRkZDQtYThiOS1kOTQ5ODkzMTg0ZjQiLCJpaWQiOjQ1OTEyNjI3LCJvaWQiOjE5NDEzMSwicyI6NTEwLCJzaWQiOiIxMzA1OGEwZC0wNzBlLTRkNWUtYmNmYS1mMmYwZTdjN2M0N2YiLCJ1aWQiOjQ1OTEyNjI3fQ.iVG8m0y5BR-lvVhHwoQjKdodoXKEXcf7WIxjPmA1yE81UIJKyH80UPR_8aGLjdIcQDPIjrU-How-OwpdwD9hQQ");
			
	Возврат Заголовки;
КонецФункции
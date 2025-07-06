# Тестовое задание по знанию SQL (Microsoft SQL Server)

## Описание таблиц.


Таблица [dbo].[booking] содержит брони.   
id_booking [int]  - ID брони (уникальный ключ).  
	id_provider [int] - ID провайдера (ссылка на таблицу [dbo].[provider]).  
	creation_date [date] - дата создания брони.  
	start_date [date] - дата заезда.  
	status [int] - статус брони.  
	nights [int] - количество ночей.  
	price [float] - сумма брони.  
	id_currency [nvarchar] (3) - валюта брони   
	id_source [int] - источник брони (ссылка на таблицу [dbo].[source]).  
	creator [nvarchar](3) - канал брони, в случае если source_name = ‘BS-CHANNEL_MANAGER’, если source_name != ‘BS-CHANNEL_MANAGER’, то значение равно пустой строке.  
Таблица [dbo].[provider] содержит информацию по провайдерам (гостиницам).   
	id_provider [int] - ID провайдера (уникальный ключ).  
	id_country  [int] - ID страны (ссылка на [dbo].[country]).  
	id_city  [int] - ID города (ссылка на [dbo].[city]).  
	provider_name  [nvarchar](100) - название отеля. 
Таблица [dbo].[country]  содержит название стран.  
Таблица [dbo].[city]  содержит название городов.  
Таблица [dbo].[currency_rate] содержит информацию о курсе валюты в рубли на определенную дату.  
id_currency [char](3) - валюта
	[date] [datetime] - дата, на которую актуален курс
	[rate] [float] - курс валюты в рубли
 
## Создание таблиц


```
CREATE TABLE [dbo].[booking](
	id_booking [int] NOT NULL PRIMARY KEY,
	id_provider [int] NOT NULL,
	creation_date [date] NOT NULL,
	start_date [date] NOT NULL,
	status [int] NOT NULL,
	nights [int] NOT NULL,
	price [float] NOT NULL,
	id_currency [nvarchar] (3) NOT NULL,
	id_source [int] NOT NULL,
	creator [nvarchar](3) NOT NULL
)

CREATE TABLE [dbo].[provider](
	id_provider [int] NOT NULL PRIMARY KEY,
	id_country  [int] NOT NULL,
	id_city  [int] NOT NULL,
	provider_name  [nvarchar](100) NOT NULL
)

CREATE TABLE [dbo].[country](
	id_country [int] NOT NULL PRIMARY KEY,
	country_name  [nvarchar](100) NOT NULL
)

CREATE TABLE [dbo].[city](
	id_city [int] NOT NULL PRIMARY KEY,
	city_name  [nvarchar](100) NOT NULL
)

CREATE TABLE [dbo].[source](
	id_source [int] NOT NULL PRIMARY KEY,
	source_name  [nvarchar](100) NOT NULL
)

CREATE TABLE [dbo].[currency_rate](
	id_currency [char](3) NOT NULL,
	[date] [datetime] NOT NULL,
	[rate] [float] NOT NULL
)
```

## Задания:


### 1. Создать view, где будет содержаться следующая информация:

ID провайдера  
Название провайдера  
Страна  
Город  
Дата создания брони  
Дата заезда в брони  
Количество ночей  
Сумма брони в исходной валюте  
Валюта брони  
Сумма брони в рублях (конвертация происходит по дате создания брони)  

### 2. Создать view, который содержал бы следующую информацию:  

ID провайдера  
Название провайдера  
Страна  
Город  
Год создания брони  
Месяц создания брони  
Доля броней среди всех броней провайдера, где source_name =  ‘BS-CHANNEL_MANAGER’  
Доля броней среди всех броней провайдера, где source_name =  ‘BS-CHANNEL_MANAGER’ и creator = ‘BGC’   

### 3.  Подсчитать среднее количество броней и среднюю сумму броней в месяц с условием, что у провайдера есть хотя бы одна бронь каждый месяц. Если в какой-то из месяцев броней нет, такой провайдер не должен выводится.  

ID провайдера  
Название провайдера  
Страна  
Город  
Год создания брони  
Месяц создания брони  
Среднее количество броней  
Средняя сумма броней  
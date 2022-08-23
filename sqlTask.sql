DROP DATABASE IF EXISTS bankdb; 
CREATE DATABASE bankdb;

GO

/*	Создание структуры базы данных
	●	У одного банка могут быть филиалы в нескольких городах. В одном городе может быть несколько филиалов
	●	В одном банке у клиента может быть только один аккаунт (аналог расчетного счета в реальных банках)
	●	К каждому аккаунту может быть привязано несколько карточек. Также могут быть аккаунты БЕЗ карточек.
	●	У каждого клиента обязательно должен быть ОДИН соц статус.
	-   Еще есть Баланс на аккауте и на каждой из карточек. Один человек может быть клиентом разных банков, но в каждом банке по одному аккаунту
*/

USE bankdb;

CREATE TABLE Banks
(
	Id INT PRIMARY KEY IDENTITY,
	BankName NVARCHAR(50) NOT NULL,
		CONSTRAINT UQ_Bank_Name UNIQUE (BankName)
);

CREATE TABLE Cities
(
	Id INT PRIMARY KEY IDENTITY,
	CityName NVARCHAR(50) NOT NULL,
		CONSTRAINT UQ_City_Name UNIQUE (CityName)
);

CREATE TABLE Departments
(
	Id INT PRIMARY KEY IDENTITY,
	DepartmentName NVARCHAR(50) NOT NULL,
	BankId INT NOT NULL,
	CityId INT NOT NULL,
	FOREIGN KEY (BankId) REFERENCES Banks (Id) ON DELETE CASCADE,
	FOREIGN KEY (CityId) REFERENCES Cities (Id) ON DELETE CASCADE
);

CREATE TABLE SocialStatus
(
	Id INT PRIMARY KEY IDENTITY,
	StatusName NVARCHAR(30) NOT NULL,
		CONSTRAINT UQ_Status_Name UNIQUE (StatusName)
);

CREATE TABLE Clients
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	SecondName NVARCHAR(30) NOT NULL,
	Phone NVARCHAR(20) NOT NULL,
	Email NVARCHAR(30),
	Age INT CHECK(Age > 0 AND Age < 100),	
	StatusId INT,
	FOREIGN KEY (StatusId) REFERENCES SocialStatus (Id) ON DELETE CASCADE,
		CONSTRAINT UQ_Phone UNIQUE (Phone),
);

CREATE TABLE Accounts
(
	Id INT PRIMARY KEY IDENTITY,
	Balance MONEY DEFAULT(0) CHECK (Balance >= 0),
	BankId INT NOT NULL,
	ClientId INT NOT NULL,
	FOREIGN KEY (BankId) REFERENCES Banks (Id) ON DELETE CASCADE,
	FOREIGN KEY (ClientId) REFERENCES Clients (Id) ON DELETE CASCADE
);

CREATE TABLE Cards
(
	Id INT PRIMARY KEY IDENTITY,
	CardNumber NVARCHAR(16) NOT NULL,
	Balance MONEY DEFAULT(0) CHECK (Balance >= 0),
	AccountId INT NOT NULL,
	FOREIGN KEY (AccountId) REFERENCES Accounts (Id) ON DELETE CASCADE
);

GO

/*Инициализация значениями*/

INSERT INTO Banks(BankName)
VALUES
('Alfa Bank'),
('Bank BelVEB'),
('VTB Bank'),
('Belagroprombank'),
('Belinvestbank');

INSERT INTO Cities(CityName)
VALUES
('Minsk'),
('Brest'),
('Gomel'),
('Grodno'),
('Vitebsk');
	
INSERT INTO Departments(DepartmentName, BankId, CityId)
VALUES
( 
	'Dep #1', 
	(SELECT Id FROM Banks WHERE BankName = 'Alfa Bank' ),
	(SELECT Id FROM Cities WHERE CityName = 'Minsk' )
),
( 
	'Dep #2', 
	(SELECT Id FROM Banks WHERE BankName = 'Alfa Bank' ),
	(SELECT Id FROM Cities WHERE CityName = 'Minsk' )
),
( 
	'Dep #3', 
	(SELECT Id FROM Banks WHERE BankName = 'Alfa Bank' ),
	(SELECT Id FROM Cities WHERE CityName = 'Brest' )
),
( 
	'Dep #4', 
	(SELECT Id FROM Banks WHERE BankName = 'Alfa Bank' ),
	(SELECT Id FROM Cities WHERE CityName = 'Gomel' )
),
( 
	'Office #1', 
	(SELECT Id FROM Banks WHERE BankName = 'Bank BelVEB' ),
	(SELECT Id FROM Cities WHERE CityName = 'Brest' )
),
( 
	'Office #2', 
	(SELECT Id FROM Banks WHERE BankName = 'Bank BelVEB' ),
	(SELECT Id FROM Cities WHERE CityName = 'Gomel' )
),
( 
	'Main dep #1', 
	(SELECT Id FROM Banks WHERE BankName = 'VTB Bank' ),
	(SELECT Id FROM Cities WHERE CityName = 'Minsk' )
),
( 
	'Main dep #2', 
	(SELECT Id FROM Banks WHERE BankName = 'VTB Bank' ),
	(SELECT Id FROM Cities WHERE CityName = 'Minsk' )
),
( 
	'Main dep #3', 
	(SELECT Id FROM Banks WHERE BankName = 'VTB Bank' ),
	(SELECT Id FROM Cities WHERE CityName = 'Grodno' )
),
( 
	'XO #1', 
	(SELECT Id FROM Banks WHERE BankName = 'Belagroprombank' ),
	(SELECT Id FROM Cities WHERE CityName = 'Minsk' )
),
( 
	'XO #2', 
	(SELECT Id FROM Banks WHERE BankName = 'Belagroprombank' ),
	(SELECT Id FROM Cities WHERE CityName = 'Vitebsk' )
),
( 
	'XO #3', 
	(SELECT Id FROM Banks WHERE BankName = 'Belagroprombank' ),
	(SELECT Id FROM Cities WHERE CityName = 'Vitebsk' )
),
( 
	'XO #4', 
	(SELECT Id FROM Banks WHERE BankName = 'Belagroprombank' ),
	(SELECT Id FROM Cities WHERE CityName = 'Vitebsk' )
),
( 
	'XO #5', 
	(SELECT Id FROM Banks WHERE BankName = 'Belagroprombank' ),
	(SELECT Id FROM Cities WHERE CityName = 'Vitebsk' )
),
( 
	'Bank #1', 
	(SELECT Id FROM Banks WHERE BankName = 'Belinvestbank' ),
	(SELECT Id FROM Cities WHERE CityName = 'Gomel' )
),
( 
	'Bank #2', 
	(SELECT Id FROM Banks WHERE BankName = 'Belinvestbank' ),
	(SELECT Id FROM Cities WHERE CityName = 'Gomel' )
),
( 
	'Bank #3', 
	(SELECT Id FROM Banks WHERE BankName = 'Belinvestbank' ),
	(SELECT Id FROM Cities WHERE CityName = 'Grodno' )
),
( 
	'Bank #4', 
	(SELECT Id FROM Banks WHERE BankName = 'Belinvestbank' ),
	(SELECT Id FROM Cities WHERE CityName = 'Minsk' )
);

INSERT INTO SocialStatus(StatusName)
VALUES
('unidentified'),
('worker'),
('student'),
('pensioner'),
('invalid'),
('schoolboy');

INSERT INTO Clients(FirstName, SecondName, Phone, Email, Age, StatusId)
VALUES
(
	'Nikita', 'Hripach', '375333355315', 'nikita.hripach@gmail.com', 18,
	(SELECT Id FROM SocialStatus WHERE StatusName = 'student')
),
(
	'Monica', 'Berry', '375669198173', 'MonicaKBerry@rhyta.com', 69,
	(SELECT Id FROM SocialStatus WHERE StatusName = 'pensioner')
),
(
	'Walter', 'Arnett', '375781064799', 'WalterCArnett@armyspy.com', 74,
	(SELECT Id FROM SocialStatus WHERE StatusName = 'pensioner')
),
(
	'Justin', 'Soucy', '375888653212', 'JustinRSoucy@teleworm.us', 47,
	(SELECT Id FROM SocialStatus WHERE StatusName = 'worker')
),
(
	'Julian', 'Unger', '375722510239', 'JulianCUnger@dayrep.com', 20,
	(SELECT Id FROM SocialStatus WHERE StatusName = 'worker')
),
(
	'Lynnette', 'Vega', '375679971433', 'LynnetteRVega@jourrapide.com', 41,
	(SELECT Id FROM SocialStatus WHERE StatusName = 'student')
),
(
	'Maribel', 'Stansfield', '375532665762', 'MaribelEStansfield@dayrep.com', 25,
	(SELECT Id FROM SocialStatus WHERE StatusName = 'student')
),
(
	'Agnes', 'Lara', '375884541219', 'AgnesJLara@rhyta.com', 27,
	(SELECT Id FROM SocialStatus WHERE StatusName = 'invalid')
),
(
	'Mario', 'Allen', '375519648428', 'MarioNAllen@rhyta.com', 34 ,
	(SELECT Id FROM SocialStatus WHERE StatusName = 'unidentified')
);

INSERT INTO Accounts(Balance, BankId, ClientId)
VALUES
(
	500,
	(SELECT Id FROM Banks WHERE BankName = 'Alfa Bank' ),
	(SELECT Id FROM Clients WHERE FirstName = 'Nikita' AND SecondName = 'Hripach')
),
(
	700,
	(SELECT Id FROM Banks WHERE BankName = 'Belinvestbank' ),
	(SELECT Id FROM Clients WHERE FirstName = 'Nikita' AND SecondName = 'Hripach')
),
(
	356,
	(SELECT Id FROM Banks WHERE BankName = 'Bank BelVEB' ),
	(SELECT Id FROM Clients WHERE FirstName = 'Monica' AND SecondName = 'Berry')
),
(
	721,
	(SELECT Id FROM Banks WHERE BankName = 'VTB Bank' ),
	(SELECT Id FROM Clients WHERE FirstName = 'Walter' AND SecondName = 'Arnett')
),
(
	41,
	(SELECT Id FROM Banks WHERE BankName = 'Belagroprombank' ),
	(SELECT Id FROM Clients WHERE FirstName = 'Justin' AND SecondName = 'Soucy')
),
(
	217,
	(SELECT Id FROM Banks WHERE BankName = 'Belinvestbank' ),
	(SELECT Id FROM Clients WHERE FirstName = 'Julian' AND SecondName = 'Unger')
),
(
	296,
	(SELECT Id FROM Banks WHERE BankName = 'Alfa Bank' ),
	(SELECT Id FROM Clients WHERE FirstName = 'Lynnette' AND SecondName = 'Vega')
),
(
	900,
	(SELECT Id FROM Banks WHERE BankName = 'VTB Bank' ),
	(SELECT Id FROM Clients WHERE FirstName = 'Lynnette' AND SecondName = 'Vega')
),
(
	296,
	(SELECT Id FROM Banks WHERE BankName = 'Bank BelVEB' ),
	(SELECT Id FROM Clients WHERE FirstName = 'Maribel' AND SecondName = 'Stansfield')
),
(
	72,
	(SELECT Id FROM Banks WHERE BankName = 'VTB Bank' ),
	(SELECT Id FROM Clients WHERE FirstName = 'Agnes' AND SecondName = 'Lara')
),
(
	823,
	(SELECT Id FROM Banks WHERE BankName = 'Belagroprombank' ),
	(SELECT Id FROM Clients WHERE FirstName = 'Mario' AND SecondName = 'Allen')
);

INSERT INTO Cards(Balance, CardNumber, AccountId)
VALUES
(
	200,
	'6808199377909843',
	(SELECT Id 
	 FROM Accounts 
	 WHERE BankId = (SELECT Id FROM Banks WHERE BankName = 'Alfa Bank' ) 
		 AND ClientId = (SELECT Id FROM Clients WHERE FirstName = 'Nikita' AND SecondName = 'Hripach'))
),
(
	200,
	'2430615927850053',
	(SELECT Id 
	 FROM Accounts 
	 WHERE BankId = (SELECT Id FROM Banks WHERE BankName = 'Alfa Bank' ) 
		 AND ClientId = (SELECT Id FROM Clients WHERE FirstName = 'Nikita' AND SecondName = 'Hripach'))
),
(
	700,
	'0455140094566939',
	(SELECT Id 
	 FROM Accounts 
	 WHERE BankId = (SELECT Id FROM Banks WHERE BankName = 'Belinvestbank' ) 
		 AND ClientId = (SELECT Id FROM Clients WHERE FirstName = 'Nikita' AND SecondName = 'Hripach'))
),
(
	653,
	'1673014554636870',
	(SELECT Id 
	 FROM Accounts 
	 WHERE BankId = (SELECT Id FROM Banks WHERE BankName = 'VTB Bank' ) 
		 AND ClientId = (SELECT Id FROM Clients WHERE FirstName = 'Walter' AND SecondName = 'Arnett'))
),
(
	41,
	'4077340731499758',
	(SELECT Id 
	 FROM Accounts 
	 WHERE BankId = (SELECT Id FROM Banks WHERE BankName = 'Belagroprombank' ) 
		 AND ClientId = (SELECT Id FROM Clients WHERE FirstName = 'Justin' AND SecondName = 'Soucy'))
),
(
	0,
	'4330741451230910',
	(SELECT Id 
	 FROM Accounts 
	 WHERE BankId = (SELECT Id FROM Banks WHERE BankName = 'Belagroprombank' ) 
		 AND ClientId = (SELECT Id FROM Clients WHERE FirstName = 'Justin' AND SecondName = 'Soucy'))
),
(
	150,
	'9031798456541448',
	(SELECT Id 
	 FROM Accounts 
	 WHERE BankId = (SELECT Id FROM Banks WHERE BankName = 'Belinvestbank' ) 
		 AND ClientId = (SELECT Id FROM Clients WHERE FirstName = 'Julian' AND SecondName = 'Unger'))
),
(
	10,
	'6610085034425592',
	(SELECT Id 
	 FROM Accounts 
	 WHERE BankId = (SELECT Id FROM Banks WHERE BankName = 'Belinvestbank' ) 
		 AND ClientId = (SELECT Id FROM Clients WHERE FirstName = 'Julian' AND SecondName = 'Unger'))
),
(
	700,
	'6962076314587078',
	(SELECT Id 
	 FROM Accounts 
	 WHERE BankId = (SELECT Id FROM Banks WHERE BankName = 'VTB Bank' ) 
		 AND ClientId = (SELECT Id FROM Clients WHERE FirstName = 'Lynnette' AND SecondName = 'Vega'))
),
(
	270,
	'6928083635774655',
	(SELECT Id 
	 FROM Accounts 
	 WHERE BankId = (SELECT Id FROM Banks WHERE BankName = 'Bank BelVEB' ) 
		 AND ClientId = (SELECT Id FROM Clients WHERE FirstName = 'Maribel' AND SecondName = 'Stansfield'))
),
(
	673,
	'8700246346670098',
	(SELECT Id 
	 FROM Accounts 
	 WHERE BankId = (SELECT Id FROM Banks WHERE BankName = 'Belagroprombank' ) 
		 AND ClientId = (SELECT Id FROM Clients WHERE FirstName = 'Mario' AND SecondName = 'Allen'))
);

GO

/*
	1. Покажи мне список банков у которых 
	есть филиалы в городе X (Минск)
*/
SELECT DISTINCT BankName 
FROM Banks
	JOIN Departments ON Departments.BankId = Banks.Id
	JOIN Cities ON Cities.Id = Departments.CityId
WHERE CityName = 'Minsk';

GO

/*
	2. Получить список карточек с указанием 
	имени владельца, баланса и названия банка
*/

SELECT Clients.FirstName, Clients.SecondName, Accounts.Id AS AccountId, Cards.Id AS CardId, Cards.CardNumber, Cards.Balance AS CardBalance, Banks.BankName
FROM Cards
	JOIN Accounts ON Cards.AccountId = Accounts.Id
	JOIN Banks ON Accounts.BankId = Banks.Id
	JOIN Clients ON Accounts.ClientId = Clients.Id

GO

/*
	3. Показать список банковских аккаунтов у 
	которых баланс не совпадает с суммой баланса
	по карточкам. В отдельной колонке вывести разницу
*/

SELECT  Accounts.Id as AccountId, MAX(Accounts.Balance) AS AccountBalance, ISNULL(SUM(Cards.Balance), 0) as CardBalance, (MAX(Accounts.Balance) - ISNULL(SUM(Cards.Balance), 0)) as BalanceDifference
FROM Accounts
	LEFT JOIN Cards ON Accounts.Id = Cards.AccountId
GROUP BY Accounts.Id
HAVING ISNULL(SUM(Cards.Balance), 0) != MAX(Accounts.Balance)

GO

/*
	4. Вывести кол-во банковских карточек для каждого 
	соц статуса (2 реализации, GROUP BY и подзапросом)
*/

SELECT SocialStatus.Id AS StatusId,  MAX(SocialStatus.StatusName) AS StatusName, COUNT(Cards.Id) as CardsAmount
FROM SocialStatus
	LEFT JOIN Clients ON SocialStatus.Id = Clients.StatusId
	LEFT JOIN Accounts ON Clients.Id = Accounts.ClientId
	LEFT JOIN Cards ON Accounts.Id = Cards.AccountId
GROUP BY SocialStatus.Id

GO

SELECT SocialStatus.Id AS StatusId, SocialStatus.StatusName,
	(SELECT COUNT(*)
	 FROM Cards
		JOIN Accounts ON Cards.AccountId = Accounts.Id
		JOIN Clients ON Accounts.ClientId = Clients.Id
	 WHERE Clients.StatusId = SocialStatus.Id) AS CardsAmount
FROM SocialStatus

GO

/*
	5. Написать stored procedure которая будет добавлять 
	по 10$ на каждый банковский аккаунт для определенного соц статуса 
	Входной параметр процедуры - Id социального статуса
*/

CREATE PROCEDURE AddTenToBalanceByStatusId
	@statusId INT
AS 
BEGIN
	
	IF (SELECT Id FROM SocialStatus WHERE Id = @statusId) IS NULL
		THROW 60000, 'Status does not exist', 1;

	IF NOT EXISTS(SELECT COUNT(*) 
		FROM Accounts 
			JOIN Clients ON Accounts.ClientId = Clients.Id 
		WHERE StatusId = @statusId)
		THROW 60001, 'No linked accounts', 1;


	UPDATE Accounts
	SET Balance = Balance + 10
	WHERE ClientId = ANY(SELECT Clients.Id 
						 FROM Clients 
						 WHERE StatusId = @statusId)

END;

GO

/*Тест процедуры AddTenToBalanceByStatusId. Ошибок не ожидается*/

DECLARE @updateStatus INT;
SET @updateStatus = (SELECT SocialStatus.Id 
					 FROM SocialStatus 
					 WHERE SocialStatus.StatusName = 'worker')

SELECT Accounts.Id AS AccountId, Accounts.Balance, Clients.Id AS ClientId, Clients.StatusId
FROM Accounts
	JOIN Clients ON Accounts.ClientId = Clients.Id
WHERE Clients.StatusId = @updateStatus;

EXEC AddTenToBalanceByStatusId @updateStatus;

SELECT Accounts.Id AS AccountId, Accounts.Balance, Clients.Id AS ClientId, Clients.StatusId
FROM Accounts
	JOIN Clients ON Accounts.ClientId = Clients.Id
WHERE Clients.StatusId = @updateStatus;

GO

/*
	6. Получить список доступных средств для каждого клиента.
	Если на аккаунте 60, а на 2х карточках по 15, тогда доступно 30
	для перевода на карточку
*/

SELECT Clients.Id AS ClientId, (ISNULL(SUM(AccountData.AccountBalance), 0) - ISNULL(SUM(AccountData.CardsSum), 0)) AS FreeMoney
FROM Clients
	LEFT JOIN (SELECT MAX(Accounts.ClientId) AS ClientId,  MAX(Accounts.Balance) AS AccountBalance, ISNULL(SUM(Cards.Balance), 0) AS CardsSum
			   FROM Accounts
				  LEFT JOIN Cards ON Accounts.Id =  Cards.AccountId
			   GROUP BY Accounts.Id) AS AccountData ON AccountData.ClientId = Clients.Id
GROUP BY Clients.Id

GO

/*
	7. Написать процедуру которая будет переводить определённую сумму
	со счёта на карту этого аккаунта.  При этом будем считать что 
	деньги на счёту все равно останутся, просто сумма средств на карте увеличится.
	Переводить БЕЗОПАСНО. То есть использовать транзакцию
*/

CREATE PROCEDURE SendMoneyToCard
	@cardId INT,
	@moneyToSend MONEY
AS
BEGIN
	DECLARE @freeMoney INT;

	IF @moneyToSend <= 0
		THROW 60004, 'Invalid parameter @moneyToSend', 1;

	IF (SELECT Id FROM Cards WHERE Id = @cardId) IS NULL
		THROW 60002, 'Card does not exist', 1;
	
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
	BEGIN TRANSACTION

	SET @freeMoney = (SELECT MAX(Accounts.Balance) - ISNULL(SUM(Cards.Balance), 0) AS FreeMoney
					  FROM Accounts
						 LEFT JOIN Cards ON Accounts.Id = Cards.AccountId
					  WHERE Accounts.Id = (SELECT Cards.AccountId
										   FROM Cards
										   WHERE Cards.Id = @cardId)
					  GROUP BY Accounts.Id)

	IF @moneyToSend > @freeMoney
		THROW 60003, 'Not enough money', 1;

	UPDATE Cards
	SET Balance = Balance + @moneyToSend
	WHERE Cards.Id = @cardId

	if (@@ERROR <> 0)
			ROLLBACK

	COMMIT

END;

GO

/*
	Тест процедуры SendMoneyToCard. Ошибок не ожидается. 
	Лимит для перевода на заданноую карту 68
*/

DECLARE @updateCard INT, @moneyToSend INT;
SET @moneyToSend = 23
SET @updateCard = (SELECT Cards.Id 
				   FROM Cards 
				   WHERE Cards.CardNumber = '1673014554636870')

SELECT Accounts.Id AS AccountId, Accounts.Balance AS AccountBalance, Cards.Id AS CardId, Cards.Balance AS CardBalance
FROM Cards
	JOIN Accounts ON Accounts.Id = Cards.AccountId
WHERE Cards.Id =  @updateCard;

EXEC SendMoneyToCard @updateCard, @moneyToSend;

SELECT Accounts.Id AS AccountId, Accounts.Balance AS AccountBalance, Cards.Id AS CardId, Cards.Balance AS CardBalance
FROM Cards
	JOIN Accounts ON Accounts.Id = Cards.AccountId
WHERE Cards.Id =  @updateCard;

GO

/*
	8. Написать триггер на таблицу Account
	нельзя изменить значение в Account на меньшее, 
	чем сумма балансов по всем карточкам
*/

CREATE TRIGGER Accounts_UPDATE
ON Accounts
AFTER UPDATE
AS 
BEGIN
	IF  (0 > ANY(SELECT MAX(inserted.Balance) - ISNULL(SUM(Cards.Balance), 0) as BalanceDifference
				 FROM inserted
					LEFT JOIN Cards ON inserted.Id = Cards.AccountId
				 GROUP BY inserted.Id))
	BEGIN 
		ROLLBACK;
		THROW 60005, 'Account balance less than Cards Sum', 1;
	END	
END;

GO

/*
	Тест на триггер Accounts_UPDATE
	Уменьшение баланса на 50 долл
*/

DECLARE @accountId TABLE(AccountId INT)
INSERT @accountId
VALUES 
(1), (6)

SELECT Accounts.Id AS AccountId, Accounts.Balance, SUM(Cards.Balance) AS CardsBalanceSum
FROM Accounts
	LEFT JOIN Cards ON Accounts.Id = Cards.AccountId
WHERE Accounts.Id = ANY(SELECT AccountId FROM @accountId)
GROUP BY Accounts.Id, Accounts.Balance

UPDATE Accounts
SET Balance = Balance - 67
WHERE Accounts.Id = ANY(SELECT AccountId FROM @accountId)

SELECT Accounts.Id AS AccountId, Accounts.Balance, SUM(Cards.Balance) AS CardsBalanceSum
FROM Accounts
	LEFT JOIN Cards ON Accounts.Id = Cards.AccountId
WHERE Accounts.Id = ANY(SELECT AccountId FROM @accountId)
GROUP BY Accounts.Id, Accounts.Balance

GO

/*
	8. Написать триггер на таблицу Cards 
	Нельзя изменить баланс карты если в 
	итоге сумма на картах будет больше чем баланс аккаунта
*/

CREATE TRIGGER Cards_UPDATE
ON Cards
AFTER UPDATE
AS 
BEGIN
	IF 0 > ANY(SELECT MAX(Accounts.Balance) - ISNULL(SUM(Cards.Balance), 0) AS FreeMoney
			   FROM Accounts
				  LEFT JOIN Cards ON Accounts.Id = Cards.AccountId
			   WHERE Accounts.Id IN (SELECT inserted.AccountId FROM inserted)
			   GROUP BY Accounts.Id)
	BEGIN
		ROLLBACK;
		THROW 60006, 'Card balance more than Account balance', 1;
	END;
END;

GO

/*
	Тест на триггер Cards_UPDATE
	Увеличение баланса на 25 долл
*/

DECLARE @cardsId TABLE(CardId INT)
INSERT @cardsId
VALUES 
(10), (11)
SELECT AccountFullInfo.AccountId, AccountBalance, CardsSumBalance, CardId, CardBalance
FROM (SELECT Cards.Id AS CardId, Cards.Balance AS CardBalance, Cards.AccountId
	  FROM Cards
	  WHERE Cards.Id = ANY(SELECT CardId 
						   FROM @cardsId)) AS CardsInfo
	JOIN (SELECT AccountData.AccountId, AccountData.AccountBalance, SUM(Cards.Balance) AS CardsSumBalance
		  FROM Cards
			 JOIN (SELECT Accounts.Id AS AccountId, Accounts.Balance AS AccountBalance
				   FROM Accounts
				   WHERE Accounts.Id = ANY(SELECT Cards.AccountId 
										   FROM Cards
										   WHERE Cards.Id = ANY(SELECT CardId 
															    FROM @cardsId))) AS AccountData ON AccountData.AccountId = Cards.AccountId
		  GROUP BY AccountData.AccountId, AccountData.AccountBalance) AS AccountFullInfo ON CardsInfo.AccountId = AccountFullInfo.AccountId
	
UPDATE Cards
SET Balance = Balance + 25
WHERE Cards.Id = ANY(SELECT CardId FROM @cardsId)

SELECT AccountFullInfo.AccountId, AccountBalance, CardsSumBalance, CardId, CardBalance
FROM (SELECT Cards.Id AS CardId, Cards.Balance AS CardBalance, Cards.AccountId
	  FROM Cards
	  WHERE Cards.Id = ANY(SELECT CardId 
						   FROM @cardsId)) AS CardsInfo
	JOIN (SELECT AccountData.AccountId, AccountData.AccountBalance, SUM(Cards.Balance) AS CardsSumBalance
		  FROM Cards
			 JOIN (SELECT Accounts.Id AS AccountId, Accounts.Balance AS AccountBalance
				   FROM Accounts
				   WHERE Accounts.Id = ANY(SELECT Cards.AccountId 
										   FROM Cards
										   WHERE Cards.Id = ANY(SELECT CardId 
															    FROM @cardsId))) AS AccountData ON AccountData.AccountId = Cards.AccountId
		  GROUP BY AccountData.AccountId, AccountData.AccountBalance) AS AccountFullInfo ON CardsInfo.AccountId = AccountFullInfo.AccountId
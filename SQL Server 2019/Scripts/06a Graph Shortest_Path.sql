-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Datenbank (erneut) anlegen und wechseln
:SETVAR dbname dotnetconsulting.Graph
USE [master];
IF EXISTS (SELECT * FROM [sys].[databases] WHERE [name] = '$(dbname)')
BEGIN
	ALTER DATABASE [$(dbname)] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [$(dbname)];
	PRINT '''$(dbname)''-Datenbank gelöscht';
END
GO
CREATE DATABASE [$(dbname)];
GO
USE [$(dbname)];
PRINT '''$(dbname)''-Datenbank erstellt und gewechselt';
GO

/*----------------------------------------------------
Knoten-Tabellen erzeugen
----------------------------------------------------*/

-- People
CREATE TABLE [dbo].[People](
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED ,
	[Name] VARCHAR(100) NOT NULL ) 
AS NODE;
GO

CREATE TABLE [dbo].[Pets](
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED ,
	[Name] VARCHAR(100) NOT NULL ) 
AS NODE;
GO

/*----------------------------------------------------
Kanten-Tabellen erzeugen
----------------------------------------------------*/

-- Follows
CREATE TABLE [dbo].[Follows](
    Since DateTime2 NOT NULL DEFAULT(GETDATE()),
    CONSTRAINT People_to_People CONNECTION ([dbo].[People] TO [dbo].[People])
)
AS EDGE;
GO

-- Owner (of Pets)
CREATE TABLE [dbo].[Owns](
    Since DateTime2 NOT NULL DEFAULT(GETDATE()),
    CONSTRAINT People_to_Pet CONNECTION ([dbo].[People] TO [dbo].[Pets])
)
AS EDGE;
GO

/*----------------------------------------------------
Inhalte
----------------------------------------------------*/
SET NOCOUNT ON;

--TRUNCATE TABLE [dbo].[Owns];
--TRUNCATE TABLE [dbo].[Follows];
--DELETE FROM [dbo].[People];

DECLARE @counter INT, @maxCounter INT;

-- Personen anlegen
SET @maxCounter = 30; -- Anzahl Personen
SET @counter = 0;

WHILE @counter < @maxCounter
BEGIN
	DECLARE @name VARCHAR(100) = CONCAT('Person#', @counter + 1);
	
	INSERT [dbo].[People] ([Name]) VALUES (@name);

	SET @counter = @counter + 1;
END

-- Pets anlegen
SET @maxCounter = 10; -- Anzahl Pets
SET @counter = 0;

WHILE @counter < @maxCounter
BEGIN
	SET @name = CONCAT('Pet#', @counter + 1);
	
	INSERT [dbo].[Pets] ([Name]) VALUES (@name);

	SET @counter = @counter + 1;
END

-- Verbindungen anlegen ('Follows')
DECLARE @NumberOfPeople INT;
SELECT @NumberOfPeople = COUNT(*) FROM [dbo].[People];

SET @maxCounter = 30 * 4; -- Anzahl Verbindungen
SET @counter = 0;
WHILE @counter < @maxCounter
BEGIN
	retry:
	DECLARE @idFrom INT = (RAND() * @NumberOfPeople) + 1;
	DECLARE @idTo INT = (RAND() * @NumberOfPeople) + 1;
	
	-- Sich selbst sollte niemand folgen müssen. Das ist traurig
	IF @idFrom = @idTo 
		GOTO retry

	-- NodeIds "Von" & "Nach" ermitteln
	DECLARE @nodeIdFrom NVARCHAR(1000),
			@nodeIdTo NVARCHAR(1000);

	SELECT @nodeIdFrom = $node_id FROM [dbo].[People] WHERE Id = @idFrom;
	SELECT @nodeIdTo = $node_id FROM [dbo].[People] WHERE Id = @idTo;

	-- Beziehung einfügen
	INSERT [dbo].[Follows] ($from_id, $to_id)
	VALUES (@nodeIdFrom, @nodeIdTo);

	SET @counter = @counter + 1;
END

-- Abfrage des kürzesten, nicht redundanten Pfades
DECLARE @form VARCHAR(100) = 'Person#1';

SELECT 
	pFrom.Id, 
	pFrom.[Name]											AS StartNode,
	LAST_VALUE(pTo.[Name]) WITHIN GROUP (GRAPH PATH)		AS FinalNode,
	STRING_AGG(pTo.[Name],'->') WITHIN GROUP (GRAPH PATH)	AS [Edges Path],
	COUNT(pTo.Id) WITHIN GROUP (GRAPH PATH)					AS [Level]
FROM
	[dbo].[People] pFrom,
	[dbo].[People] FOR PATH pTo,
	[dbo].[Follows] FOR PATH follows
WHERE 
	--MATCH(SHORTEST_PATH(pFrom(-(follows)->pTo){1,99})) -- Max 1-2 Level tief (1..2)
	MATCH(SHORTEST_PATH(pFrom(-(follows)->pTo)+)) -- So viele Level wie nötig sind für den Pfad
	AND pFrom.[Name] = @form;

go
-- Abfrage eine Pfad von bis
DECLARE @form VARCHAR(100) = 'Person#1';
DECLARE @to VARCHAR(100) = 'Person#11';

;WITH cte AS 
(
	SELECT 
		pFrom.Id, 
		pFrom.[Name]											AS StartNode,
		LAST_VALUE(pTo.[Name]) WITHIN GROUP (GRAPH PATH)		AS FinalNode,
		STRING_AGG(pTo.[Name],'->') WITHIN GROUP (GRAPH PATH)	AS [Edges Path],
		COUNT(pTo.Id) WITHIN GROUP (GRAPH PATH)					AS [Level]
	FROM
		[dbo].[People] pFrom,
		[dbo].[People] FOR PATH pTo,
		[dbo].[Follows] FOR PATH follows
	WHERE 
		-- MATCH(SHORTEST_PATH(pFrom(-(follows)->pTo){1,2})) -- Max 1-2 Level tief (1..2)
		MATCH(SHORTEST_PATH(pFrom(-(follows)->pTo)+)) -- So viele Level wie nötig sind für den Pfad
)
SELECT * FROM cte
WHERE StartNode = @form AND FinalNode = @to;
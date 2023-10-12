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
Knoten Tabellen
----------------------------------------------------*/

-- Biere
CREATE TABLE [dbo].[Biere]
(
    Id INT PRIMARY KEY,
    [Name] VARCHAR(50),
) AS NODE;
CREATE NONCLUSTERED INDEX idx_Biername ON [dbo].[Biere] ([name]);

-- Brauereien
CREATE TABLE [dbo].[Brauereien]
(
    Id INT PRIMARY KEY,
    [Name] VARCHAR(50),
) AS NODE;
CREATE NONCLUSTERED INDEX idx_Brauereiname ON [dbo].[Brauereien] ([name]);

-- Städte
create table [dbo].[Staedte]
(
    Id INT PRIMARY KEY,
    [Name] VARCHAR(50),
) AS NODE;
CREATE NONCLUSTERED INDEX idx_Stadtname ON [dbo].[Staedte]([name]);

-- Länder
CREATE TABLE [dbo].[Laender]
(
    Id INT PRIMARY KEY,
    [Name] VARCHAR(50),
) AS NODE;
CREATE NONCLUSTERED INDEX idx_Laendername ON [dbo].[Laender]([name]);



/*----------------------------------------------------
Kanten Tabellen
----------------------------------------------------*/

-- Gebraut von
CREATE TABLE [dbo].[GebrautVon] AS EDGE;
CREATE UNIQUE NONCLUSTERED INDEX idx_GebrautVon ON [dbo].[GebrautVon] ($from_id, $to_id);

-- Brauereistandort
CREATE TABLE [dbo].[Brauereistandort] AS EDGE;
CREATE UNIQUE NONCLUSTERED INDEX idx_Brauereistandort ON [dbo].[Brauereistandort] ($from_id, $to_id);

-- Im Land
CREATE TABLE [dbo].[LiegtInLand] AS EDGE;
CREATE UNIQUE NONCLUSTERED INDEX idx_Herkunftsland ON [dbo].[LiegtInLand] ($from_id, $to_id);



/*----------------------------------------------------
Inhalte
----------------------------------------------------*/
SET NOCOUNT ON;
DECLARE @counter INT = 1;

DELETE [dbo].[Biere];
SET @COUNTER = 1;
WHILE @counter <= 50
BEGIN
	INSERT [dbo].[Biere] ([Id], [Name]) VALUES (@counter, CONCAT('Bier #', @counter));
	SET @counter = @counter + 1;
END

DELETE [dbo].[Brauereien];
SET @COUNTER = 1;
WHILE @counter <= 10
BEGIN
	INSERT [dbo].[Brauereien] ([Id], [Name]) VALUES (@counter, CONCAT('Brauerei #', @counter));
	SET @counter = @counter + 1;
END

DELETE [dbo].[Staedte];
SET @COUNTER = 1;
WHILE @counter <= 10
BEGIN
	INSERT [dbo].[Staedte] ([Id], [Name]) VALUES (@counter, CONCAT('Stadt #', @counter));
	SET @counter = @counter + 1;
END

DELETE [dbo].[Laender];
SET @COUNTER = 1;
WHILE @counter <= 5
BEGIN
	INSERT [dbo].[Laender] ([Id], [Name]) VALUES (@counter, CONCAT('Land #', @counter));
	SET @counter = @counter + 1;
END

PRINT 'Tabelle und Inhalte erstellt';

-- Bier 1-3 werden in Brauerei #1 gebraut
INSERT [dbo].[GebrautVon]
SELECT (SELECT $node_id FROM [dbo].[Biere] WHERE ID = 1),
	   (SELECT $node_id FROM [dbo].[Brauereien] WHERE ID = 1);
INSERT [dbo].[GebrautVon]
SELECT (SELECT $node_id FROM [dbo].[Biere] WHERE ID = 2),
	   (SELECT $node_id FROM [dbo].[Brauereien] WHERE ID = 1);
INSERT [dbo].[GebrautVon]
SELECT (SELECT $node_id FROM [dbo].[Biere] WHERE ID = 3),
	   (SELECT $node_id FROM [dbo].[Brauereien] WHERE ID = 1);

-- Brauerei #1 liegt in Stadt #7
INSERT [dbo].[Brauereistandort]
SELECT (SELECT $node_id FROM [dbo].[Brauereien] WHERE ID = 1),
	   (SELECT $node_id FROM [dbo].[Staedte] WHERE ID = 7);

-- Und Stadt #7 wiederrum in Land #5
INSERT [dbo].[LiegtInLand]
SELECT (SELECT $node_id FROM [dbo].[Staedte] WHERE ID = 7),
	   (SELECT $node_id FROM [dbo].[Laender] WHERE ID = 5);

PRINT 'Graph-Relationen erstellt';


-- Test-Abfragen

-- Welche Biere wurden von Brauerei #1 gebraut?
SELECT	[Biere].[Name] AS 'Bier'
FROM	[dbo].[Biere], [dbo].[GebrautVon], [dbo].[Brauereien] 
WHERE	MATCH (Biere-(GebrautVon)->Brauereien) AND
		[Brauereien].[name] = 'Brauerei #1';

-- Welche Biere kommen aus Stadt #7?
SELECT	[Biere].[Name] as 'Bier',
		[Brauereien].[Name] as 'Brauerei',
		[Staedte].[Name] AS 'Stadt'
FROM	[dbo].[Biere], [dbo].[GebrautVon], [dbo].[Brauereien],[dbo].[Brauereistandort],[dbo].[Staedte]
WHERE	MATCH (Biere-(GebrautVon)->Brauereien-(Brauereistandort)->Staedte) AND
		[Staedte].[Name] = 'Stadt #7';
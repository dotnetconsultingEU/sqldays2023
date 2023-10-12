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

-- Exemplarisch eine weitere Person hinzufügen (optional)
DECLARE @form VARCHAR(100) = 'Person#1';
DECLARE @to VARCHAR(100) = 'Person#2';

INSERT [dbo].[People] ([Name]) VALUES (@form), (@to);

-- NodeIds "Von" & "Nach" ermitteln
DECLARE @nodeIdFrom NVARCHAR(1000),
		@nodeIdTo NVARCHAR(1000);

SELECT @nodeIdFrom = $node_id FROM [dbo].[People] WHERE [Name] = @form;
SELECT @nodeIdTo = $node_id FROM [dbo].[People] WHERE [Name] = @to;
INSERT [dbo].[Follows] ($to_id, $from_id) VALUES (@nodeIdFrom, @nodeIdTo);
GO

-- Owns kann nicht von People -> Pets verwendet werden
DECLARE @form VARCHAR(100) = 'Person#1';
DECLARE @to VARCHAR(100) = 'Pet#1';

INSERT [dbo].[Pets] ([Name]) VALUES (@to);

DECLARE @nodeIdFrom NVARCHAR(1000),
		@nodeIdTo NVARCHAR(1000);

SELECT @nodeIdFrom = $node_id FROM [dbo].[People] WHERE [Name] = @form;
SELECT @nodeIdTo = $node_id FROM [dbo].[Pets] WHERE [Name] = @to;

-- Beziehung einfügen (Fehler!)
INSERT [dbo].[Owns] ($to_id, $from_id)
VALUES (@nodeIdFrom, @nodeIdTo);
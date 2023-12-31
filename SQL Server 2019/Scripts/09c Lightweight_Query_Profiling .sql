-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Datenbank (erneut) anlegen und wechseln
:SETVAR dbname dotnetconsulting.LightweightQueryProfling
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
SET NOCOUNT ON;
GO
ALTER DATABASE CURRENT SET COMPATIBILITY_LEVEL = 150;
GO
-- Funktioniert nicht in CTP 2.2. Später?
-- ALTER DATABASE CURRENT SET LIGHTWEIGHT_QUERY_PROFILING OFF
GO

CREATE Table [dbo].[Demo]
(
   Id INT IDENTITY(1,1) PRIMARY KEY,
   [Data1] varchar(50),
   [Data2] varchar(50)
);
GO

DECLARE @c INT = 1;

WHILE @c <= 1000   
BEGIN 
    INSERT [dbo].[Demo] (Data1, Data2) VALUES 
    (
	    CONCAT('Data1 - ', @c),
	    CONCAT('Data2 - ', @c)
    )
   Set @c = @c + 1
END;
GO

-- Aktivierung ab SQL Server 2019 nicht mehr nötig
--DBCC TRACEON (7412, -1);
--DBCC TRACESTATUS();

-- Viel Arbeit für nichts
SELECT * FROM 
[dbo].[Demo] d1 CROSS JOIN
[dbo].[Demo] d2 CROSS JOIN
[dbo].[Demo] d3 CROSS JOIN
[dbo].[Demo] d4;

-- Welche Abfragen-Profiles gibt es?
SELECT * FROM sys.dm_exec_query_profiles
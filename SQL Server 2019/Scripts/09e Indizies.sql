-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschr�nkungen verwendet oder ver�ndert werden.
-- Jedoch wird keine Garantie �bernommen, dass eine Funktionsf�higkeit mit aktuellen und 
-- zuk�nftigen API-Versionen besteht. Der Autor �bernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgef�hrt wird.
-- F�r Anregungen und Fragen stehe ich jedoch gerne zur Verf�gung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Datenbank (erneut) anlegen und wechseln
:SETVAR dbname dotnetconsulting.Indizies
USE [master];
IF EXISTS (SELECT * FROM [sys].[databases] WHERE [name] = '$(dbname)')
BEGIN
	ALTER DATABASE [$(dbname)] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [$(dbname)];
	PRINT '''$(dbname)''-Datenbank gel�scht';
END
GO
CREATE DATABASE [$(dbname)];
GO
USE [$(dbname)];
PRINT '''$(dbname)''-Datenbank erstellt und gewechselt';
GO
SET NOCOUNT ON;
GO

CREATE Table [dbo].[Demo]
(
   Id INT IDENTITY(1,1) PRIMARY KEY,
   [Data1] varchar(50),
   [Data2] varchar(50)
);
GO

DECLARE @c INT = 1;

WHILE @c <= 10000   
BEGIN 
    INSERT [dbo].[Demo] (Data1, Data2) VALUES 
    (
	    CONCAT('Data1 - ', @c),
	    CONCAT('Data2 - ', @c)
    )
   Set @c = @c + 1
END;
GO

-- Index ggf. l�schen, neu erstellen und anhalten
DROP INDEX IF EXISTS  CI_Idx1 ON [dbo].[Demo]
GO

CREATE NONCLUSTERED INDEX CI_Idx1
ON [dbo].[Demo](Data1)
WITH (ONLINE = ON, RESUMABLE = ON);
GO

-- WAITFOR DELAY '0:0:1';
GO
ALTER INDEX [CI_Idx1] ON [dbo].[Demo] PAUSE;
GO
ALTER INDEX [CI_Idx1] ON [dbo].[Demo] RESUME;

-- Welcher Index kannn fortgesetzt werden?
SELECT * FROM sys.index_resumable_operations;
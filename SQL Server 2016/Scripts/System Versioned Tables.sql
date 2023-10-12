-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Datenbank anlegen und wechseln
CREATE DATABASE dotnetconsulting_SystemVersionedTables;
GO
USE dotnetconsulting_SystemVersionedTables;
GO

-- System Versioned Table anlegen
CREATE TABLE dbo.Werte
(
       ID INT IDENTITY(1,1) NOT NULL,
       Wert1 NVARCHAR(10) NULL,
       Wert2 NVARCHAR(10) NULL,
       StartTime datetime2(7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
       EndTime datetime2(7) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
       PERIOD FOR SYSTEM_TIME(StartTime, EndTime),
       CONSTRAINT Werte_PK PRIMARY KEY (ID)
)
WITH
(
       SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.Werte_History)
)
GO

-- Bestehende Tabelle zur System Versioned Table machen
ALTER TABLE dbo.Werte ADD
	StartTime datetime2(7) GENERATED ALWAYS AS ROW START DEFAULT GETUTCDATE() NOT NULL,
	EndTime datetime2(7) GENERATED ALWAYS AS ROW END DEFAULT '9999-12-31 23:59:59.9999999' NOT NULL,
	PERIOD FOR SYSTEM_TIME(StartTime, EndTime);
GO
ALTER TABLE dbo.Werte SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.Werte_History));



-- Ein paar Zeilen einfügen, ändern und löschen
INSERT [dbo].[Werte] (Wert1, Wert2) VALUES
('A1','A2'), ('B1','B2'), ('C1','C2');
UPDATE [dbo].[Werte] SET Wert1 = 'A1_neu' WHERE ID = 1;
DELETE [dbo].[Werte] WHERE ID = 2;

-- Schauen, wie die Daten und die Historisierung ausschaut
SELECT * FROM dbo.Werte;
SELECT *, StartTime, EndTime FROM dbo.Werte;

SELECT * FROM dbo.Werte_History;

-- AS OF
SELECT * FROM dbo.Werte FOR SYSTEM_TIME AS OF '2023-05-08 08:00:07.1491525';

DECLARE @d DATETIME = '2021-10-05T12:34:10';
SELECT * FROM dbo.Werte FOR SYSTEM_TIME AS OF @d;
GO

-- ALL
SELECT *, StartTime, EndTime FROM dbo.Werte FOR SYSTEM_TIME ALL;
GO

-- FROM TO (Auschluss der oberen Grenze)
DECLARE @d1 DATETIME = '2016-01-25 18:21:24';
DECLARE @d2 DATETIME = '2016-01-25 18:21:24';

SELECT * FROM dbo.Werte FOR SYSTEM_TIME FROM @d1 TO @d2;
GO

-- BETWEEN AND (Einschließlich der oberen Grenze)
DECLARE @d1 DATETIME = '2016-01-25 18:21:24';
DECLARE @d2 DATETIME = '2016-01-25 18:21:24';

SELECT * FROM dbo.Werte FOR SYSTEM_TIME BETWEEN  @d1 AND @d2;
GO

-- CONTAINED IN (Nur historische Werte)
DECLARE @d1 DATETIME = '2016-01-25 18:21:24';
DECLARE @d2 DATETIME = '2016-01-25 18:21:24';

SELECT * FROM dbo.Werte FOR SYSTEM_TIME CONTAINED IN (@d1, @d2);
GO

-- History Tabelle wird ebenso angepaßt!
ALTER TABLE dbo.Werte ADD Wert3 NVARCHAR(10) NULL; 
ALTER TABLE dbo.Werte DROP COLUMN Wert3; 

UPDATE dbo.Werte SET StartTime = '2015-01-01' WHERE ID = 1; -- Fehler
TRUNCATE TABLE dbo.Werte; -- Fehler
TRUNCATE TABLE [dbo].[Werte_History]; -- Fehler
DELETE [dbo].[Werte_History]; -- Fehler


-- Transaktion damit keine Änderungen stattfinden ohne Versionierung stattfinden 
-- (Transaktion nicht zwingend notwendig für SYSTEM_VERSIONING = OFF)
BEGIN TRANSACTION;
ALTER TABLE dbo.Werte SET (SYSTEM_VERSIONING = OFF);
TRUNCATE TABLE dbo.Werte; -- Fehler, wenn SYSTEM_VERSIONING = ON
TRUNCATE TABLE dbo.Werte_History; -- Fehler, wenn SYSTEM_VERSIONING = ON
DELETE dbo.Werte_History; -- Fehler, wenn SYSTEM_VERSIONING = ON

ALTER TABLE dbo.Werte SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.Werte_History));
COMMIT TRANSACTION;
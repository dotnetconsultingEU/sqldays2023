-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Datenbank (erneut) anlegen und wechseln
:SETVAR dbname dotnetconsulting_Ledger
USE [master];
IF EXISTS (SELECT * FROM [sys].[databases] WHERE [name] = '$(dbname)')
BEGIN
	ALTER DATABASE [$(dbname)] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [$(dbname)];
	PRINT '''$(dbname)''-Datenbank gelöscht';
END
GO
CREATE DATABASE [$(dbname)] WITH LEDGER = ON;
GO
USE [$(dbname)];
PRINT '''$(dbname)''-Datenbank erstellt und gewechselt';
GO
SELECT is_ledger_on, * FROM sys.databases WHERE [Name] = '$(dbname)';
GO
ALTER DATABASE CURRENT SET ALLOW_SNAPSHOT_ISOLATION ON;
GO

-- Updatable Ledger-Tabelle
CREATE TABLE [dbo].[UpdatableLedger] 
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [Value1] NVARCHAR(10) NULL,
    [Value2] NVARCHAR(10) NULL,
	-- Ledger
	[ledger_start_transaction_id] [bigint] GENERATED ALWAYS AS transaction_id START HIDDEN NOT NULL,
	[ledger_end_transaction_id] [bigint] GENERATED ALWAYS AS transaction_id END HIDDEN NULL,
	[ledger_start_sequence_number] [bigint] GENERATED ALWAYS AS sequence_number START HIDDEN NOT NULL,
	[ledger_end_sequence_number] [bigint] GENERATED ALWAYS AS sequence_number END HIDDEN NULL,
	-- System Versioning/ Temporal tables (SQL Server 2016)
    StartTime datetime2(7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    EndTime datetime2(7) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
	PERIOD FOR SYSTEM_TIME(StartTime, EndTime),
	PRIMARY KEY CLUSTERED ([ID] ASC
)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
WITH
(
	SYSTEM_VERSIONING = ON (
		HISTORY_TABLE = [dbo].[UpdatableLedger_History]
	), 
	LEDGER = ON (
		LEDGER_VIEW = [dbo].[vwUpdatableLedger] (
		TRANSACTION_ID_COLUMN_NAME = [ledger_transaction_id], 
		SEQUENCE_NUMBER_COLUMN_NAME = [ledger_sequence_number], 
		OPERATION_TYPE_COLUMN_NAME = [ledger_operation_type], 
		OPERATION_TYPE_DESC_COLUMN_NAME = [ledger_operation_type_desc]
	))
);
GO

-- Ein paar Zeilen einfügen, ändern und löschen
INSERT [dbo].[UpdatableLedger] (Value1, Value2) VALUES
('A1','A2'), ('B1','B2'), ('C1','C2');
WAITFOR DELAY '0:00:05';
UPDATE [dbo].[UpdatableLedger] SET Value1 = 'A1_neu' WHERE ID = 1;
WAITFOR DELAY '0:00:05';
DELETE [dbo].[UpdatableLedger] WHERE ID = 2;
WAITFOR DELAY '0:00:05';
GO

-- AS OF
SELECT *, StartTime, EndTime FROM [dbo].[UpdatableLedger] FOR SYSTEM_TIME AS OF '2023-09-27 12:44:32.1447688';

DECLARE @d DATETIME = '2021-10-05T12:34:10';
SELECT * FROM [dbo].[UpdatableLedger] FOR SYSTEM_TIME AS OF @d;
GO


-- Append-only Ledger-Tabelle
CREATE TABLE [dbo].[AppendOnlyLedger] 
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [Value1] NVARCHAR(10) NULL,
    [Value2] NVARCHAR(10) NULL,
)
	WITH (LEDGER = ON (APPEND_ONLY = ON, LEDGER_VIEW = [dbo].[vwAppendOnlyLedger])
);
GO

-- Ein paar Zeilen einfügen, ändern und löschen
INSERT [dbo].[AppendOnlyLedger] (Value1, Value2) VALUES
('A1','A2'), ('B1','B2'), ('C1','C2');
WAITFOR DELAY '0:00:05';
GO
-- Diese Anweisungen erzeugen Fehler (AppendOnly)
UPDATE [dbo].[AppendOnlyLedger] SET Value1 = 'A1_neu' WHERE ID = 1;
WAITFOR DELAY '0:00:05';
DELETE [dbo].[AppendOnlyLedger] WHERE ID = 2;

-- Abfragen auf [dbo].[UpdatableLedger]
SELECT * FROM [dbo].[UpdatableLedger];
SELECT * FROM [dbo].[vwUpdatableLedger];
SELECT [ID]
      ,[Value1]
      ,[Value2]
      ,[ledger_start_transaction_id]
      ,[ledger_end_transaction_id]
      ,[ledger_start_sequence_number]
      ,[ledger_end_sequence_number]
      ,[StartTime]
      ,[EndTime]
  FROM [dbo].[UpdatableLedger];
GO

-- Abfragen auf [dbo].[AppendOnlyLedger]
SELECT * FROM [dbo].[AppendOnlyLedger];
SELECT * FROM [dbo].[vwAppendOnlyLedger];
SELECT [ID]
      ,[Value1]
      ,[Value2]
      ,[ledger_start_transaction_id]
      ,[ledger_start_sequence_number]
  FROM [dbo].[AppendOnlyLedger];
GO

-- == Verifizierung ==
-- SQL Server (On-premises)
--ALTER DATABASE CURRENT SET ALLOW_SNAPSHOT_ISOLATION ON;
--GO
DECLARE @table TABLE (col1 NVARCHAR(MAX));
DECLARE @ledger_digest NVARCHAR(MAX);
INSERT @table
EXECUTE sys.sp_generate_database_ledger_digest;
SELECT @ledger_digest = col1 FROM @table;
SELECT @ledger_digest;
--{
--   "database_name":"dotnetconsulting_Ledger",
--   "block_id":2,
--   "hash":"0x454E4A71413034CAFE20AE8F61445B25C2F327E0270374997067365FE4E25B53",
--   "last_transaction_commit_time":"2023-01-16T20:41:28.1833333",
--   "digest_time":"2023-01-16T19:41:36.8262573"
--}
EXECUTE sys.sp_verify_database_ledger @digests = @ledger_digest;
EXECUTE sys.sp_verify_database_ledger @digests = @ledger_digest, @table_name = N'[dbo].[UpdatableLedger]';

GO

-- SQL Azure
--ALTER DATABASE CURRENT SET ALLOW_SNAPSHOT_ISOLATION ON;
--GO

--DECLARE @digest_locations NVARCHAR(MAX) = (SELECT * FROM sys.database_ledger_digest_locations FOR JSON AUTO, INCLUDE_NULL_VALUES);
--SELECT @digest_locations as digest_locations;
--BEGIN TRY
--    EXEC sys.sp_verify_database_ledger_from_digest_storage @digest_locations;
--    SELECT 'Ledger verification succeeded.' AS Result;
--END TRY
--BEGIN CATCH
--    THROW;
--END CATCH

--EXEC sp_verify_database_ledger @digests = 'digests' [ , [@table_name = ] 'dbo.UpdatableLedger' ]
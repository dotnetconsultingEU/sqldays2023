-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Datenbank anlegen und wechseln
DROP DATABASE IF EXISTS  dotnetconsulting_CCI;
GO
CREATE DATABASE dotnetconsulting_CCI;
GO
USE dotnetconsulting_CCI;
GO

-- Sogar Umstellung auf SQL Server 2014 Kompatibilität möglich (hat keine Auswirkungen)
ALTER DATABASE [dotnetconsulting_CCI] SET COMPATIBILITY_LEVEL = 120;
GO

-- Tabelle anlegen 
CREATE TABLE [dbo].[CCITable](
	[ID] [int] NULL,
	[Wert1] [varchar](50) NULL,
	[Wert2] [varchar](50) NULL
); 
GO

-- Cluster Columnstore Index anlegen
CREATE CLUSTERED COLUMNSTORE INDEX [idxCCI] ON [dbo].[CCITable] WITH (DROP_EXISTING = OFF);
GO

-- Secondary B-Tree Index anlegen
CREATE NONCLUSTERED INDEX [btidx] ON [dbo].[CCITable] (ID ASC);
GO

-- Nach wie vor darf es nur einen Clustered Index geben
CREATE CLUSTERED INDEX [btidx2] ON [dbo].[CCITable] (ID ASC); -- Fehler!
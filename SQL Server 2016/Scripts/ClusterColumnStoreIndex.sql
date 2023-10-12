-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschr�nkungen verwendet oder ver�ndert werden.
-- Jedoch wird keine Garantie �bernommen, dass eine Funktionsf�higkeit mit aktuellen und 
-- zuk�nftigen API-Versionen besteht. Der Autor �bernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgef�hrt wird.
-- F�r Anregungen und Fragen stehe ich jedoch gerne zur Verf�gung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Datenbank anlegen und wechseln
DROP DATABASE IF EXISTS  dotnetconsulting_CCI;
GO
CREATE DATABASE dotnetconsulting_CCI;
GO
USE dotnetconsulting_CCI;
GO

-- Sogar Umstellung auf SQL Server 2014 Kompatibilit�t m�glich (hat keine Auswirkungen)
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
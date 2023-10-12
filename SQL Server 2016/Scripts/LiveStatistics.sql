-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Aktivierung ab SQL Server 2019 nicht mehr nötig
DBCC TRACEON (7412, -1);
DBCC TRACESTATUS();

-- Dummy Abfrage
SELECT * FROM sys.sysobjects o1
CROSS JOIN sys.sysobjects o2
CROSS JOIN sys.sysobjects o3;


-- Aktivierung ohne SSMS
SET STATISTICS XML ON;
-- oder
SET STATISTICS PROFILE ON;
-- oder
-- Warnung!!! 30% oder mehr Performanceverlust
CREATE EVENT SESSION [query_post_execution_showplan_Test]
ON SERVER
ADD EVENT sqlserver.query_post_execution_showplan(
WHERE ([duration]=(5000000)));
GO
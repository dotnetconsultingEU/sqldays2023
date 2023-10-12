-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsultin

-- Sorgenfrei Löschen
DROP PROCEDURE IF EXISTS dbo.uspProc1;
DROP TABLE IF EXISTS dbo.table1;
DROP VIEW IF EXISTS dbo.view1;

-- 
CREATE OR ALTER VIEW dbo.vwTest
AS
	SELECT * FROM sys.databases;

-- Nachbessern, keine Snapshots
CREATE OR ALTER VIEW dbo.vwTest
AS
	SELECT * FROM sys.databases WHERE source_database_id IS NULL;

-- Ausräumen
DROP IF EXISTS VIEW dbo.vwTest;
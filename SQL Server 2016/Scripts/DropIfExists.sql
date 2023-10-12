-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschr�nkungen verwendet oder ver�ndert werden.
-- Jedoch wird keine Garantie �bernommen, dass eine Funktionsf�higkeit mit aktuellen und 
-- zuk�nftigen API-Versionen besteht. Der Autor �bernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgef�hrt wird.
-- F�r Anregungen und Fragen stehe ich jedoch gerne zur Verf�gung.

-- Thorsten Kansy, www.dotnetconsultin

-- Sorgenfrei L�schen
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

-- Ausr�umen
DROP IF EXISTS VIEW dbo.vwTest;
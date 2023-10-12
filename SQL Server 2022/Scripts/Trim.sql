-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

DECLARE @caption VARCHAR(100) = '-== SQL Server 2022 ==-';

SELECT LTRIM(@caption, '-= ') AS [LTRIM],
	   RTRIM(@caption, '-= ') AS [RTRIM];

SELECT TRIM(LEADING '-= ' FROM @caption) AS [LEADING],
	   TRIM(TRAILING '-= ' FROM @caption) AS [TRAILING],
	   TRIM(BOTH '-= ' FROM @caption) AS [BOTH];
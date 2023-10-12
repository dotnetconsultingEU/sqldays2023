-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Eingeschaltet?
SELECT [name], [value], [value_in_use] FROM sys.configurations
	WHERE [name] = 'column encryption enclave type';

-- Einschalten 
EXEC sys.sp_configure 'column encryption enclave type', 1; 
--Kein VBS (Virtual based security) ;(
RECONFIGURE;
SHUTDOWN; -- & Restart

-- Rich computations on encrypted columns
DBCC TRACEON(127,-1);

DBCC TRACESTATUS();
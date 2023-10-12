-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschr�nkungen verwendet oder ver�ndert werden.
-- Jedoch wird keine Garantie �bernommen, dass eine Funktionsf�higkeit mit aktuellen und 
-- zuk�nftigen API-Versionen besteht. Der Autor �bernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgef�hrt wird.
-- F�r Anregungen und Fragen stehe ich jedoch gerne zur Verf�gung.

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
-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschr�nkungen verwendet oder ver�ndert werden.
-- Jedoch wird keine Garantie �bernommen, dass eine Funktionsf�higkeit mit aktuellen und 
-- zuk�nftigen API-Versionen besteht. Der Autor �bernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgef�hrt wird.
-- F�r Anregungen und Fragen stehe ich jedoch gerne zur Verf�gung.

-- Thorsten Kansy, www.dotnetconsulting.eu

USE [dotnetconsulting_Roles];
GO

-- User deaktiviern
REVOKE CONNECT FROM [Jens];

-- User aktivieren
GRANT CONNECT TO [Jens];

-- �bersicht verschaffen
SELECT name, hasdbaccess FROM sys.sysusers WHERE islogin = 1 
ORDER BY name;
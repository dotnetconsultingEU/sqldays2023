-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschr�nkungen verwendet oder ver�ndert werden.
-- Jedoch wird keine Garantie �bernommen, dass eine Funktionsf�higkeit mit aktuellen und 
-- zuk�nftigen API-Versionen besteht. Der Autor �bernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgef�hrt wird.
-- F�r Anregungen und Fragen stehe ich jedoch gerne zur Verf�gung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Datenbank anlegen
CREATE DATABASE dotnetconsulting_ApplicationRole;
GO
USE dotnetconsulting_ApplicationRole;
GO

-- Anwendungsrolle anlegen
CREATE APPLICATION ROLE [AnwendungsRolle1] WITH PASSWORD = N'abc'
GO


DECLARE @cookie varbinary(8000);

EXEC sp_setapprole     
	@rolename = 'AnwendungsRolle1',     
	@password = 'abc', 
	@fCreateCookie = true,    
	@cookie = @cookie OUTPUT;

SELECT SUSER_SNAME(); -- SQL Server kennt nach wie vor die orginale Identit�t
SELECT USER_NAME(); -- Name der Anwendungsrolle

EXEC sp_unsetapprole @cookie;
-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

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

SELECT SUSER_SNAME(); -- SQL Server kennt nach wie vor die orginale Identität
SELECT USER_NAME(); -- Name der Anwendungsrolle

EXEC sp_unsetapprole @cookie;
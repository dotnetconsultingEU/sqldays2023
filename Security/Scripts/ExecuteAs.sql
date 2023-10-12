-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Datenbank (erneut) anlegen und wechseln
:SETVAR dbname dotnetconsulting_ExecuteAs
USE [master];
IF EXISTS (SELECT * FROM [sys].[databases] WHERE [name] = '$(dbname)')
BEGIN
	ALTER DATABASE [$(dbname)] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [$(dbname)];
	PRINT '''$(dbname)''-Datenbank gelöscht';
END
GO
CREATE DATABASE [$(dbname)];
GO
USE [$(dbname)];
PRINT '''$(dbname)''-Datenbank erstellt und gewechselt';
GO

-- User anlgen
CREATE USER [Felix] WITHOUT LOGIN;
GO

-- Prozeduren anlegen
CREATE PROCEDURE dbo.usp_ExecuteAsUser_Dbo
WITH EXECUTE AS 'dbo'
AS
BEGIN
	SET NOCOUNT ON;

	SELECT User 'dbo.usp_ExecuteAsUser_Dbo';
END
GO

CREATE PROCEDURE dbo.usp_ExecuteAsCaller
WITH EXECUTE AS CALLER
AS
BEGIN
	SET NOCOUNT ON;

	SELECT User 'dbo.usp_ExecuteAsCaller';
END
GO

CREATE PROCEDURE dbo.usp_ExecuteAsOwner
WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;

	SELECT User 'dbo.usp_ExecuteAsOwner';
END
GO

CREATE PROCEDURE dbo.usp_ExecuteAsSelf
WITH EXECUTE AS SELF
AS
BEGIN
	SET NOCOUNT ON;

	SELECT User 'dbo.usp_ExecuteAsSelf';
END
GO

-- Alle Prozeduren ausführen
GRANT EXECUTE ON SCHEMA::dbo TO Felix;
GO

-- Test mit User
EXECUTE AS USER = 'Felix';
--SELECT USER;
GO
EXEC dbo.usp_ExecuteAsCaller;
EXEC dbo.usp_ExecuteAsUser_dbo;
EXEC dbo.usp_ExecuteAsOwner;
EXEC dbo.usp_ExecuteAsSelf;
REVERT;
--SELECT USER;


-- Alternativer Test mit User
EXECUTE ('
	SELECT USER;

	EXEC dbo.usp_ExecuteAsCaller;
	EXEC dbo.usp_ExecuteAsUser_dbo;
	EXEC dbo.usp_ExecuteAsOwner;
	EXEC dbo.usp_ExecuteAsSelf;
') AS User = 'Felix';
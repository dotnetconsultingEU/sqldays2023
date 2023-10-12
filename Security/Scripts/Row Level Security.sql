-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschr�nkungen verwendet oder ver�ndert werden.
-- Jedoch wird keine Garantie �bernommen, dass eine Funktionsf�higkeit mit aktuellen und 
-- zuk�nftigen API-Versionen besteht. Der Autor �bernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgef�hrt wird.
-- F�r Anregungen und Fragen stehe ich jedoch gerne zur Verf�gung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Datenbank (erneut) anlegen und wechseln
:SETVAR dbname dotnetconsulting_RowLevelSecurity
USE [master];
IF EXISTS (SELECT * FROM [sys].[databases] WHERE [name] = '$(dbname)')
BEGIN
	ALTER DATABASE [$(dbname)] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [$(dbname)];
	PRINT '''$(dbname)''-Datenbank gel�scht';
END
GO
CREATE DATABASE [$(dbname)];
GO
USE [$(dbname)];
PRINT '''$(dbname)''-Datenbank erstellt und gewechselt';
GO

DROP TABLE IF EXISTS [dbo].[Mitarbeiter];
GO
CREATE TABLE [dbo].[Mitarbeiter]
(
    [ID] [int] PRIMARY KEY CLUSTERED IDENTITY(1,1) NOT NULL,
    [Name] [varchar](100) NULL,
    [Address] [varchar](256) NULL,
    [Email] [varchar](256) NULL,
    [Gehalt] [decimal](18,2) NOT NULL,
    [SecurityDescriptor] [varchar](128) NULL
);
GO

-- Werte einf�gen
INSERT [dbo].[Mitarbeiter] ([Name], [Address], [Email], [Gehalt], [SecurityDescriptor])
VALUES
('Thorsten Kansy', 'Nidderau', 'tkansy@dotnetconsulting.eu', 15000.0, 'Chef'),
('James Bond', 'London', 'bond@mi5.co.uk', 10000.0, NULL),
('Maria Kron', 'Suffhausen', 'mk@hotmail.com', 1.0, NULL),
('Harry Hirsch', 'Wald', 'hh@gmail.de', 10000.0, 'CHEF');
GO

-- Funktion f�r Sicherheitsfilter erstellen
DROP FUNCTION IF EXISTS dbo.fn_AccessFilter;
GO
CREATE FUNCTION dbo.fn_AccessFilter(@RoleOrUsername AS sysname)
    RETURNS TABLE
	WITH SCHEMABINDING -- Muss angegeben werden
AS
RETURN
(
	SELECT 1 'Granted' WHERE -- R�ckgabe einer Zeile => Datenzeile passiert Filter!
		USER_NAME() = @RoleOrUsername OR IS_MEMBER(ISNULL(@RoleOrUsername, 'PUBLIC')) = 1
);
GO

-- Security Policy (Standard: aktiviert bei Erstellung)
DROP SECURITY POLICY IF EXISTS SecurityFilter;
GO
CREATE SECURITY POLICY SecurityFilter
ADD FILTER PREDICATE dbo.fn_AccessFilter([SecurityDescriptor]) ON [dbo].[Mitarbeiter],
ADD BLOCK PREDICATE dbo.fn_AccessFilter([SecurityDescriptor]) ON [dbo].[Mitarbeiter] AFTER INSERT,
ADD BLOCK PREDICATE dbo.fn_AccessFilter([SecurityDescriptor]) ON [dbo].[Mitarbeiter] BEFORE DELETE,
ADD BLOCK PREDICATE dbo.fn_AccessFilter([SecurityDescriptor]) ON [dbo].[Mitarbeiter] BEFORE UPDATE;
-- Weitere Filter/ Block Pr�dikate f�r weitere Tabelle 
GO

-- User anlegen
DROP USER IF EXISTS [UserA];
GO
CREATE USER [UserA] WITHOUT LOGIN;
GO
DROP USER IF EXISTS [UserB];
GO
CREATE USER [UserB] WITHOUT LOGIN;

-- Rolle anlegen und Mitglieder zuweisen
DROP ROLE IF EXISTS [Chef];
GO
CREATE ROLE [Chef];
ALTER ROLE [Chef] ADD MEMBER [UserA];

-- Rechte vergeben
GRANT SELECT, INSERT, DELETE, UPDATE ON [dbo].[Mitarbeiter] TO PUBLIC;
GRANT SHOWPLAN TO PUBLIC;
GO

-- UserB (NICHT in Chef-Rolle)
EXECUTE AS USER = 'UserB'; 
SELECT CONCAT ('Ausf�hren als: ', USER_NAME());

-- Wird gefiltert
SELECT * FROM dbo.Mitarbeiter;

-- Werden geblockt
DELETE FROM dbo.Mitarbeiter WHERE SecurityDescriptor = 'Chef';
UPDATE dbo.Mitarbeiter SET SecurityDescriptor = '(Peng)' WHERE SecurityDescriptor = 'Chef';

REVERT; -- Urspr�nglicher User


-- UserA (in Chef-Rolle)
EXECUTE AS USER = 'UserA'; 
SELECT CONCAT ('Ausf�hren als: ', USER_NAME());

SELECT * FROM dbo.Mitarbeiter;

REVERT; -- Urspr�nglicher User


-- Securtiy Policy aktivieren/ deaktivieren (f�r Wartung, etc.)
ALTER SECURITY POLICY [dbo].[SecurityFilter] WITH (STATE = OFF);
ALTER SECURITY POLICY [dbo].[SecurityFilter] WITH (STATE = ON);
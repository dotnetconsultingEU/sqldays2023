-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

DROP DATABASE IF EXISTS dotnetconsulting_RowLevelSecurity;
GO
CREATE DATABASE dotnetconsulting_RowLevelSecurity;
GO
USE dotnetconsulting_RowLevelSecurity;
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

-- Werte einfügen
INSERT [dbo].[Mitarbeiter] ([Name], [Address], [Email], [Gehalt], [SecurityDescriptor])
VALUES
('Thorsten Kansy', 'Nidderau', 'tkansy@dotnetconsulting.eu', 15000.0, 'Chef'),
('James Bond', 'London', 'bond@mi5.co.uk', 10000.0, NULL),
('Maria Kron', 'Suffhausen', 'mk@hotmail.com', 1.0, NULL),
('Harry Hirsch', 'Wald', 'hh@gmail.de', 10000.0, 'CHEF');
GO


-- Funktion für Sicherheitsfilter erstellen
DROP FUNCTION IF EXISTS dbo.fn_AccessFilter;
GO
CREATE FUNCTION dbo.fn_AccessFilter(@RoleOrUsername AS sysname)
    RETURNS TABLE
	WITH SCHEMABINDING -- Muss angegeben werden
AS
RETURN
(
	SELECT 1 'Granted' WHERE -- Rückgabe einer Zeile => Datenzeile passiert Filter!
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
-- Weitere Filter/ Block Prädikate für weitere Tabelle 
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
SELECT CONCAT ('Ausführen als: ', USER_NAME());

-- Wird gefiltert
SELECT * FROM dbo.Mitarbeiter;

-- Werden geblockt
DELETE FROM dbo.Mitarbeiter WHERE SecurityDescriptor = 'Chef';
UPDATE dbo.Mitarbeiter SET SecurityDescriptor = '(Peng)' WHERE SecurityDescriptor = 'Chef';

REVERT; -- Ursprünglicher User


-- UserA (in Chef-Rolle)
EXECUTE AS USER = 'UserA'; 
SELECT CONCAT ('Ausführen als: ', USER_NAME());

SELECT * FROM dbo.Mitarbeiter;

REVERT; -- Ursprünglicher User


-- Securtiy Policy aktivieren/ deaktivieren (für Wartung, etc.)
ALTER SECURITY POLICY [dbo].[SecurityFilter] WITH (STATE = OFF);
ALTER SECURITY POLICY [dbo].[SecurityFilter] WITH (STATE = ON);
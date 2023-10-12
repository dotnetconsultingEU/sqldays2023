-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Datenbank anlegen
CREATE DATABASE dotnetconsulting_OwershipChaining
GO
USE dotnetconsulting_OwershipChaining;

-- Logins und User anlgen
CREATE LOGIN [Silke] WITH PASSWORD=N'123', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;
CREATE LOGIN [Uwe] WITH PASSWORD=N'123', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;
CREATE LOGIN [Jens] WITH PASSWORD=N'123', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;
CREATE LOGIN [Michael] WITH PASSWORD=N'123', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;
GO

-- User anlegen
CREATE USER [Silke] FOR LOGIN [Silke];
CREATE USER [Uwe] FOR LOGIN [Uwe];
CREATE USER [Jens] FOR LOGIN [Jens];
CREATE USER [Michael] FOR LOGIN [Michael];
GO

-- User sollen Tabellen, Sichten, Proceduren und Schemata anlegen dürfen
GRANT CREATE SCHEMA TO [Jens];
GRANT CREATE TABLE TO [Jens];
GRANT CREATE PROCEDURE TO [Jens];

GRANT CREATE SCHEMA TO [Uwe];
GRANT CREATE VIEW TO [Uwe];

GRANT CREATE SCHEMA TO [Silke];
GRANT CREATE VIEW TO [Silke];


-- Die Tabelle von User Jens anlgen
EXECUTE AS USER = 'Jens';
SELECT USER;
GO
CREATE SCHEMA schemaJens;
GO

CREATE TABLE schemaJens.SpesenXY
(
	ID INT,
	IrgendEinWert VARCHAR(100)
);
INSERT schemaJens.SpesenXY
VALUES (1, 'A1'), (2, 'A2'), (3, 'A3');

REVERT;
SELECT USER;


-- Die Sicht von User Uwe anlgen
EXECUTE AS USER = 'Uwe';
SELECT USER;
GO
CREATE SCHEMA schemaUwe;
GO
CREATE VIEW schemaUwe.AccAlterXY
AS
	SELECT * FROM schemaJens.SpesenXY;
GO

REVERT;
SELECT USER;


-- Die Sichten von User Silke anlgen
EXECUTE AS USER = 'Silke';
SELECT USER;
GO
CREATE SCHEMA schemaSilke;
GO

CREATE VIEW schemaSilke.Rechnungen
AS
	SELECT * FROM schemaUwe.AccAlterXY;
GO

CREATE VIEW schemaSilke.VerkaufXY
AS
	SELECT * FROM schemaSilke.Rechnungen;
GO

CREATE VIEW schemaSilke.Juli2015
AS
	SELECT * FROM schemaSilke.VerkaufXY;
GO

REVERT;
SELECT USER;


-- Rechnte an den Lesenden User vergeben
GRANT SELECT ON [schemaSilke].[Juli2015] TO [Michael];
-- Mehr Rechte
--GRANT SELECT ON [schemaUwe].[AccAlterXY] TO [Michael];
--GRANT SELECT ON [schemaJens].[SpesenXY] TO [Michael];

EXECUTE AS USER = 'Michael';
SELECT USER;
GO
SELECT * FROM [schemaSilke].[Juli2015];

REVERT;
SELECT USER;


-- Besitzer abfragen
SELECT s.name + '.' + o.name AS ObjectName , COALESCE(p.name, p2.name) AS OwnerName ,*
FROM sys.all_objects o 
LEFT OUTER JOIN sys.database_principals p ON o.principal_id = p.principal_id
LEFT OUTER JOIN sys.schemas s ON o.schema_id = s.schema_id
LEFT OUTER JOIN sys.database_principals p2 ON s.principal_id = p2.principal_id
WHERE o.type IN ('V', 'P', 'U') AND s.name NOT IN ('sys', 'INFORMATION_SCHEMA')


-- == ALternative mit Stored Procedure
REVOKE  SELECT ON [schemaJens].[SpesenXY] TO [Michael];
GRANT EXECUTE ON SCHEMA::[schemaJens] TO [Michael];

-- Prozedure von Jens anlegen lassen
EXECUTE AS USER = 'Jens';
SELECT USER;
GO

CREATE PROCEDURE schemaJens.sp_GetSpesenXY
AS
BEGIN
	SET NOCOUNT ON;
	SELECT * FROM schemaJens.SpesenXY;
END;

REVERT;
SELECT USER;

-- Test
EXECUTE AS USER = 'Michael';
SELECT USER;
GO
-- SP ausführen ja (mit Zugriff auf schemaJens.SpesenXY)
EXEC schemaJens.sp_GetSpesenXY;

-- Direkter Zugriff auf schemaJens.SpesenXY, Nein!
SELECT * FROM schemaJens.SpesenXY;
REVERT;
SELECT USER;
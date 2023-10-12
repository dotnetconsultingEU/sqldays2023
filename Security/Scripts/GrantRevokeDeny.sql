-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Datenbank anlegen
CREATE DATABASE dotnetconsulting_Permissions;
GO
USE dotnetconsulting_Permissions;


-- Logins und User anlgen
CREATE LOGIN [Jens] WITH PASSWORD=N'123', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;
GO
CREATE USER [Jens] FOR LOGIN [Jens];
GO

-- DDL Anweisungen berechtigen
GRANT CREATE TABLE TO [Jens];
GRANT CREATE PROCEDURE TO [Jens];
REVOKE CREATE TABLE TO [Jens];

-- Der User könnte nun kreativ werden...

CREATE TABLE dbo.SpesenXY
(
	ID INT,
	IrgendEinWert VARCHAR(100)
);
INSERT dbo.SpesenXY
VALUES (1, 'A1'), (2, 'A2'), (3, 'A3');
SELECT * FROM dbo.SpesenXY;


-- Rechte durch Rollenmitgliedschaft(en);
ALTER ROLE [db_datareader] ADD MEMBER [Jens];

CREATE ROLE [RolleSpesenLesen];
GRANT SELECT ON [dbo].[SpesenXY] TO [RolleSpesenLesen];
GRANT UPDATE ON [dbo].[SpesenXY] TO [RolleSpesenLesen];
GRANT INSERT ON [dbo].[SpesenXY] TO [RolleSpesenLesen];
-- Und auch direkt
GRANT SELECT ON [dbo].[SpesenXY] TO [Jens];

-- Für SELECT und UPDATE sind auch Rechte auf Eben von Spalten möglich
-- ACHTUNG, WENN DAS KEINE GUTE IDEE IST
GRANT SELECT ON [dbo].[SpesenXY] (ID) TO [Jens];
DENY UPDATE ON [dbo].[SpesenXY] (ID) TO [Jens];

-- Test mit User
EXECUTE AS USER = 'Jens';
SELECT USER;
GO
SELECT * FROM  dbo.SpesenXY;

REVERT;
SELECT USER;

-- Doch ein Verbot reicht
DENY SELECT ON  [dbo].[SpesenXY] TO [Jens];
-- Verbot wieder entziehen
REVOKE SELECT ON [dbo].[SpesenXY] TO [Jens];
-- oder so
GRANT SELECT ON [dbo].[SpesenXY] TO [Jens];
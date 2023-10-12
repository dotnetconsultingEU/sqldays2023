-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschr�nkungen verwendet oder ver�ndert werden.
-- Jedoch wird keine Garantie �bernommen, dass eine Funktionsf�higkeit mit aktuellen und 
-- zuk�nftigen API-Versionen besteht. Der Autor �bernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgef�hrt wird.
-- F�r Anregungen und Fragen stehe ich jedoch gerne zur Verf�gung.

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

-- Der User k�nnte nun kreativ werden...

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

-- F�r SELECT und UPDATE sind auch Rechte auf Eben von Spalten m�glich
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
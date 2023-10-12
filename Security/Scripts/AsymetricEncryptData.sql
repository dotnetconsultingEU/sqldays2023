-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Datenbank (erneut) anlegen und wechseln
:SETVAR dbname dotnetconsulting_AsymetricEncryptData
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

-- Einen asymmetrischen Schlüssel mit Kennwort erstellen
-- Mögliche Algorithmen RSA_4096, RSA_3072, RSA_2048, RSA_1024 & RSA_512.
CREATE ASYMMETRIC KEY AsymmetricKey WITH ALGORITHM = RSA_2048
	ENCRYPTION BY PASSWORD = N'GanzGeheim$123';

-- Welche Schlüssel gibt es in der Db?
SELECT * FROM sys.asymmetric_keys;

-- Kennwort ändern
ALTER ASYMMETRIC KEY AsymmetricKey   
    WITH PRIVATE KEY
	(  
		DECRYPTION BY PASSWORD = 'GanzGeheim$123',  
		ENCRYPTION BY PASSWORD = 'UltraGeheim$123'
	);  
GO  

-- Tabelle erstellen
CREATE TABLE dbo.Mitarbeiter
(
	ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Name varchar(100) NOT NULL,
	KontoNrEnctryted varbinary(MAX)
);

-- Und mit einige Daten befüllen
INSERT dbo.Mitarbeiter (Name, KontoNrEnctryted) 
VALUES
('Thorsten Kansy', EncryptByAsymKey(AsymKey_ID('AsymmetricKey'), '123-123-123')), 
('James Bond', EncryptByAsymKey(AsymKey_ID('AsymmetricKey'), '007-007-007')),
('Harry Hirsch', EncryptByAsymKey(AsymKey_ID('AsymmetricKey'), '4711-4711-4711')),
('Maria Kron', EncryptByAsymKey(AsymKey_ID('AsymmetricKey'), '0815-0815-0815'));

-- Schauen wir uns den Inhalt an
SELECT * FROM dbo.Mitarbeiter;

-- Versuchen, den Inhalt mit falschem Kennwort zu entschlüsseln
SELECT ID,
	   Name,
	   CONVERT(VARCHAR(100), DecryptByAsymKey(AsymKey_ID('AsymmetricKey'), KontoNrEnctryted, N'FalschesKennwort'))
FROM dbo.Mitarbeiter;

-- Dann doch besser kein Kennwort übergeben
SELECT ID,
	   Name,
	   CONVERT(VARCHAR(100), DecryptByAsymKey(AsymKey_ID('AsymmetricKey'), KontoNrEnctryted, NULL))
FROM dbo.Mitarbeiter;

-- So ist es richtig
DECLARE @Password NVARCHAR(128) = 'UltraGeheim$123';

SELECT ID,
	   Name,
	   CONVERT(VARCHAR(100), DecryptByAsymKey(AsymKey_ID('AsymmetricKey'), KontoNrEnctryted, @Password))
FROM dbo.Mitarbeiter;

-- User ohne Rechte auf den asymetrischen Schlüssel anlegen
CREATE USER [UserOhneRechte] WITHOUT LOGIN;
GO
GRANT SELECT ON dbo.Mitarbeiter TO UserOhneRechte; 
GO

-- Zugriff ihne Rechte auf den Schlüssel trotz richtigem Kennwort möglich?
EXECUTE AS USER = 'UserOhneRechte';
GO
SELECT USER;
SELECT ID,
	   Name,
	   CONVERT(VARCHAR(100), DecryptByAsymKey(AsymKey_ID('AsymmetricKey'), KontoNrEnctryted, N'UltraGeheim$123'))
FROM dbo.Mitarbeiter;
REVERT;
SELECT USER;

-- Geben wir dem User die notwendigen Recht
GRANT CONTROL ON ASYMMETRIC KEY::AsymmetricKey TO UserOhneRechte; 
GO

-- Jetzt noch ein Versuch, der auch funktionieren sollte
EXECUTE AS USER = 'UserOhneRechte';
GO
DECLARE @password NVARCHAR(100) = 'UltraGeheim$123';
SELECT USER;
SELECT ID,
	   Name,
	   CONVERT(VARCHAR(100), DecryptByAsymKey(AsymKey_ID('AsymmetricKey'), KontoNrEnctryted, @password))
FROM dbo.Mitarbeiter;
REVERT;
SELECT USER;
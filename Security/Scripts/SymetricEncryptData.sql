-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Datenbank (erneut) anlegen und wechseln
:SETVAR dbname dotnetconsulting_SymmetricEncryptData
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

-- Service Master Key abfragen (wird bei der Installation erstellt)
SELECT * FROM master.sys.symmetric_keys WHERE name = '##MS_ServiceMasterKey##';
GO

-- Database Master Key erstellen
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Geheim$123A';
GO

-- Selbst signiertes Zertifikat erstellen
CREATE CERTIFICATE Zertifikat1 WITH SUBJECT = 'SensibleDaten';
GO

-- Zertifikat von Certificate Authority (CA) installieren
--CREATE CERTIFICATE Zertifikat2 
--    FROM FILE = 'Certificate.cer' WITH PRIVATE KEY (FILE = 'PrivateKey.pvk', 
--    DECRYPTION BY PASSWORD = '123123');
--GO 

-- Selbst signiertes Zertifikat erstellen, mit Password
CREATE CERTIFICATE Zertifikat3 ENCRYPTION BY PASSWORD = 'AuchGeheim$123A'
WITH SUBJECT = 'SensibleDaten';
GO

-- Kennwort ändern
ALTER CERTIFICATE Zertifikat3   
    WITH PRIVATE KEY
	(  
		DECRYPTION BY PASSWORD = 'AuchGeheim$123A',  
		ENCRYPTION BY PASSWORD = 'UltraGeheim$123'
	);  
GO 

-- Zertifikat sichern
BACKUP CERTIFICATE Zertifikat3 TO FILE = 'C:\Temp\Zertifikat3Certificate.cer' 
    WITH PRIVATE KEY 
	( 
		FILE = 'C:\Temp\Zertifikat3Certificate.pvk' ,   
		ENCRYPTION BY PASSWORD = '123456', --Private Key mit diesem Kennwort verschlüsseln
		DECRYPTION BY PASSWORD = 'UltraGeheim$123' -- Kennwort der Zertifikates
	);  
GO 

-- Zertifikat löschen
DROP CERTIFICATE Zertifikat3;

-- Zertifikat wiederherstellen
CREATE CERTIFICATE Zertifikat3 
    FROM FILE = 'C:\Temp\Zertifikat3Certificate.cer' 
	WITH PRIVATE KEY 
	(
		FILE = 'C:\Temp\Zertifikat3Certificate.pvk', 
		DECRYPTION BY PASSWORD = '123456'
	);

-- Symmetrische Schlüssel erzeugen 
CREATE SYMMETRIC KEY SymmetricKey1  WITH ALGORITHM = AES_128 ENCRYPTION BY CERTIFICATE Zertifikat1;
GO
CREATE SYMMETRIC KEY SymmetricKey3  WITH ALGORITHM = AES_128 ENCRYPTION BY CERTIFICATE Zertifikat3;
GO
-- Welche Schlüssel existieren nun in der Db?
SELECT * FROM sys.symmetric_keys;

-- Tabelle erstellen
CREATE TABLE dbo.Mitarbeiter
(
	ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Name varchar(100) NOT NULL,
	KontoNrEnctryted varbinary(MAX)
);

-- und mit einige Daten befüllen
OPEN SYMMETRIC KEY SymmetricKey1 DECRYPTION BY CERTIFICATE Zertifikat1;
INSERT dbo.Mitarbeiter (Name, KontoNrEnctryted) 
VALUES
('Thorsten Kansy', EncryptByKey( Key_GUID('SymmetricKey1'), CONVERT(varchar,'123-123-123'))), 
('James Bond', EncryptByKey( Key_GUID('SymmetricKey1'), CONVERT(varchar,'007-007-007'))),
('Harry Hirsch', EncryptByKey( Key_GUID('SymmetricKey1'), CONVERT(varchar,'4711-4711-4711'))),
('Maria Kron', EncryptByKey( Key_GUID('SymmetricKey1'), CONVERT(varchar,'0815-0815-0815')));
CLOSE SYMMETRIC KEY SymmetricKey1;

-- Schauen wir uns den Inhalt an
SELECT * FROM dbo.Mitarbeiter;

-- Und wieder auslesen
OPEN SYMMETRIC KEY SymmetricKey1 DECRYPTION BY CERTIFICATE Zertifikat1;
SELECT ID, 
	   Name,
	   CONVERT(VARCHAR, DecryptByKey(KontoNrEnctryted))
FROM dbo.Mitarbeiter;
CLOSE SYMMETRIC KEY SymmetricKey1;

-- User ohne Rechte anlegen
CREATE USER [UserOhneRechte] WITHOUT LOGIN;
GO

GRANT SELECT ON dbo.Mitarbeiter TO UserOhneRechte; 
GO

-- In den Sicherheitskontext dieses Users wechseln
EXECUTE AS USER = 'UserOhneRechte';
GO
SELECT USER;

-- Lesen? Nö
OPEN SYMMETRIC KEY SymmetricKey1 DECRYPTION BY CERTIFICATE Zertifikat1;
SELECT ID, 
	   Name,
	   CONVERT(VARCHAR, DecryptByKey(KontoNrEnctryted))
FROM dbo.Mitarbeiter;
CLOSE SYMMETRIC KEY SymmetricKey1;
REVERT;
SELECT USER;

-- Geben wir dem User die notwendigen Recht
GRANT CONTROL ON SYMMETRIC KEY::SymmetricKey1 TO UserOhneRechte; 
GO
GRANT CONTROL ON Certificate::Zertifikat1 TO UserOhneRechte;
GO

-- Noch ein Versuch
EXECUTE AS USER = 'UserOhneRechte';
SELECT USER;
OPEN SYMMETRIC KEY SymmetricKey1 DECRYPTION BY CERTIFICATE Zertifikat1;
SELECT ID, 
	   Name,
	   CONVERT(VARCHAR, DecryptByKey(KontoNrEnctryted))
FROM dbo.Mitarbeiter;
CLOSE SYMMETRIC KEY SymmetricKey1;
REVERT;
SELECT USER;
-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschr�nkungen verwendet oder ver�ndert werden.
-- Jedoch wird keine Garantie �bernommen, dass eine Funktionsf�higkeit mit aktuellen und 
-- zuk�nftigen API-Versionen besteht. Der Autor �bernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgef�hrt wird.
-- F�r Anregungen und Fragen stehe ich jedoch gerne zur Verf�gung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Datenbank anlegen
CREATE DATABASE dotnetconsulting_EncryptData;
GO
USE master;
GO
SELECT * FROM sys.symmetric_keys WHERE name = '##MS_ServiceMasterKey##';
GO

-- Database Master Key erstellen
USE dotnetconsulting_EncryptData;
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Geheim';
GO

-- Selbst signiertes Zertifikat erstellen
CREATE CERTIFICATE Zertifikat1 WITH SUBJECT = 'SensibleDaten';
GO

CREATE CERTIFICATE Zertifikat2 
    FROM FILE = 'Certificate.cer' WITH PRIVATE KEY (FILE = 'PrivateKey.pvk', 
    DECRYPTION BY PASSWORD = '123123');
GO 

CREATE CERTIFICATE Zertifikat3 ENCRYPTION BY PASSWORD = 'AuchGeheim'
WITH SUBJECT = 'SensibleDaten';
GO

-- 
CREATE SYMMETRIC KEY SymmetricKey1  WITH ALGORITHM = AES_128 ENCRYPTION BY CERTIFICATE Zertifikat1;
GO
CREATE SYMMETRIC KEY SymmetricKey3  WITH ALGORITHM = AES_128 ENCRYPTION BY CERTIFICATE Zertifikat3;
GO

-- Asymetrische Schl�ssel?


-- Verschl�sseln
-- Populating encrypted data into new column
USE encrypt_test;
GO

-- Tabelle erstellung
CREATE TABLE dbo.Mitarbeiter
(
	ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Name varchar(100) NOT NULL,
	KontoNrEnctryted varbinary(MAX)
);

-- und mit einige Daten bef�llen
OPEN SYMMETRIC KEY SymmetricKey1 DECRYPTION BY CERTIFICATE Zertifikat1;

INSERT dbo.Mitarbeiter (Name, KontoNrEnctryted) 
OUTPUT inserted.* VALUES
('Thorsten Kansy', EncryptByKey( Key_GUID('SymmetricKey1'), CONVERT(varchar,'123-123-123'))), 
('James Bond', EncryptByKey( Key_GUID('SymmetricKey1'), CONVERT(varchar,'007-007-007'))),
('Harry Hirsch', EncryptByKey( Key_GUID('SymmetricKey1'), CONVERT(varchar,'4711-4711-4711'))),
('Maria Kron', EncryptByKey( Key_GUID('SymmetricKey1'), CONVERT(varchar,'0815-0815-0815')));

CLOSE SYMMETRIC KEY SymmetricKey1;

-- User f�r Testzwecke anlegen
USE MASTER;
CREATE LOGIN [UnbekanntesLogin] WITH PASSWORD=N'123', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;
GO
USE dotnetconsulting_EncryptData;
CREATE USER [UserOhneRechte] FOR LOGIN [UnbekanntesLogin];
GO
GRANT SELECT ON dbo.Mitarbeiter TO UserOhneRechte; 
GO

-- In den Sicherheitskontext dieses Users wechseln
EXECUTE AS USER = 'UserOhneRechte';
GO
SELECT USER;

-- Lesen?
OPEN SYMMETRIC KEY SymmetricKey1 DECRYPTION BY CERTIFICATE Zertifikat1;
SELECT ID, 
	   Name,
	   CONVERT(VARCHAR, DecryptByKey(KontoNrEnctryted))
FROM dbo.Mitarbeiter;
CLOSE SYMMETRIC KEY SymmetricKey1;

-- Zur�ck in den orginal Sicherheitskontext
REVERT;

-- Geben wir dem User die notwendigen Recht
GRANT VIEW DEFINITION ON SYMMETRIC KEY::SymmetricKey1 TO UserOhneRechte; 
GO
GRANT VIEW DEFINITION ON Certificate::Zertifikat1 TO UserOhneRechte;
GO

EXECUTE AS USER = 'UserOhneRechte';
GO
SELECT USER;
-- Noch ein Versuch
OPEN SYMMETRIC KEY SymmetricKey1 DECRYPTION BY CERTIFICATE Zertifikat1;
SELECT ID, 
	   Name,
	   CONVERT(VARCHAR, DecryptByKey(KontoNrEnctryted))
FROM dbo.Mitarbeiter;
CLOSE SYMMETRIC KEY SymmetricKey1;
REVERT;

// https://www.mssqltips.com/sqlservertip/2431/sql-server-column-level-encryption-example-using-symmetric-keys/
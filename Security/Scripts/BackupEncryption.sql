-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschr�nkungen verwendet oder ver�ndert werden.
-- Jedoch wird keine Garantie �bernommen, dass eine Funktionsf�higkeit mit aktuellen und 
-- zuk�nftigen API-Versionen besteht. Der Autor �bernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgef�hrt wird.
-- F�r Anregungen und Fragen stehe ich jedoch gerne zur Verf�gung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Datenbank (erneut) anlegen und wechseln
:SETVAR dbname dotnetconsulting_EncryptBackup
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

USE MASTER;
-- Zertifikat l�schen (wenn vorhanden)
DROP CERTIFICATE dncCertificate;

-- Zertifikat anlegen
CREATE CERTIFICATE dncCertificate WITH SUBJECT = 'Backup Certificate';  
GO 

-- Backup erstellen
BACKUP DATABASE [dotnetconsulting_EncryptBackup] TO  
DISK = N'c:\temp\dotnetconsulting_EncryptBackup.bak' WITH FORMAT, INIT,  
NAME = N'dotnetconsulting_TDE-Full Database Backup', 
SKIP, NOREWIND, NOUNLOAD, COMPRESSION,
ENCRYPTION
(
	ALGORITHM = AES_128, 
	SERVER CERTIFICATE = [dncCertificate]
),  STATS = 10
GO

-- Wir gehen auf Nummer sicher und machen ein Backup
BACKUP CERTIFICATE dncCertificate TO FILE = 'C:\Temp\dncCertificate1.cer';  
GO 
BACKUP CERTIFICATE dncCertificate TO FILE = 'C:\Temp\dncCertificate2.cer'  
    WITH PRIVATE KEY ( FILE = 'C:\Temp\dncCertificate2.pvk' ,   
    ENCRYPTION BY PASSWORD = '123456' );  
GO 

-- Datenbank l�schen
DROP DATABASE IF EXISTS dotnetconsulting_EncryptBackup;

DROP CERTIFICATE /* IF EXISTS */ dncCertificate;
GO

-- Restore nur m�glich, wenn Zertifikat vorhanden
RESTORE DATABASE [dotnetconsulting_EncryptBackup] 
FROM  DISK = N'C:\Temp\dotnetconsulting_EncryptBackup.bak' 
WITH  FILE = 1,  NOUNLOAD,  STATS = 5;

-- Zertifikat wiederherstellen
CREATE CERTIFICATE dncCertificate   
    FROM FILE = 'C:\Temp\dncCertificate2.cer'   
    WITH PRIVATE KEY (FILE = 'C:\Temp\dncCertificate2.pvk',   
    DECRYPTION BY PASSWORD = '123456'); 
GO

RESTORE DATABASE [dotnetconsulting_EncryptBackup] 
FROM  DISK = N'C:\Temp\dotnetconsulting_EncryptBackup.bak' 
WITH  FILE = 1,  NOUNLOAD,  STATS = 5;
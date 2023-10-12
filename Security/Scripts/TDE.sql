-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschr�nkungen verwendet oder ver�ndert werden.
-- Jedoch wird keine Garantie �bernommen, dass eine Funktionsf�higkeit mit aktuellen und 
-- zuk�nftigen API-Versionen besteht. Der Autor �bernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgef�hrt wird.
-- F�r Anregungen und Fragen stehe ich jedoch gerne zur Verf�gung.
-- Thorsten Kansy, www.dotnetconsulting.eu

-- Datenbank (erneut) anlegen und wechseln
:SETVAR dbname dotnetconsulting_TDE
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

USE master;
-- Master Key erstellen (wenn nicht vorhanden)
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'IchBinLangUndGeheim'; 
GO  
-- Zertifikat l�schen (wenn vorhanden)
DROP CERTIFICATE /* IF EXISTS */ dncCertificate;
GO
-- Zertifikat anlegen
CREATE CERTIFICATE dncCertificate WITH SUBJECT = 'TDE Certificate';  
GO  

use dotnetconsulting_TDE;
-- ENCRYPTION KEY erstellen 
CREATE DATABASE ENCRYPTION KEY  
	WITH ALGORITHM = AES_128 ENCRYPTION BY SERVER CERTIFICATE dncCertificate;  

-- Wir gehen auf Nummer sicher und machen ein Backup
use master;
GO

BACKUP CERTIFICATE dncCertificate TO FILE = 'C:\Temp\dncCertificate1.cer';  
GO 
BACKUP CERTIFICATE dncCertificate TO FILE = 'C:\Temp\dncCertificate2.cer'  
    WITH PRIVATE KEY ( FILE = 'C:\Temp\dncCertificate2.pvk' ,   
    ENCRYPTION BY PASSWORD = '123456' );  
GO 

-- L�schen und wiederherstellen	
DROP CERTIFICATE /* IF EXISTS */ dncCertificate;
GO
-- Backup wiederherstellen
CREATE CERTIFICATE dncCertificate   
    FROM FILE = 'C:\Temp\dncCertificate2.cer'   
    WITH PRIVATE KEY (FILE = 'C:\Temp\dncCertificate2.pvk',   
    DECRYPTION BY PASSWORD = '123456');  
GO  

-- So, und nun TDE einschalten
ALTER DATABASE dotnetconsulting_TDE SET ENCRYPTION ON;  
GO  
-- encryption_state = 1 => Keine Verschl�sselung
-- encryption_state = 2 => Verschl�sselung/ Entschl�sselung l�uft
-- encryption_state = 3 => Verschl�sselung abgeschlossen
SELECT * FROM sys.dm_database_encryption_keys WHERE database_id  = DB_ID('dotnetconsulting_TDE');

-- Backup erstellen
BACKUP DATABASE [dotnetconsulting_TDE] TO  DISK = N'c:\temp\dncTDE.bak' WITH NOFORMAT, INIT,  NAME = N'dotnetconsulting_TDE-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
-- Datenbank und Certifikat l�schen und dann ein Restore versuchen
-- Gleiche Situation, als wenn die DB auf einem anderen Server wiederhergestellt
-- werden soll
USE MASTER;
GO
DROP DATABASE IF EXISTS dotnetconsulting_TDE;
GO
DROP CERTIFICATE /* IF EXISTS */ dncCertificate;
GO

-- Ergo: Kein Zertifikat, kein Restore
RESTORE DATABASE [dotnetconsulting_TDE] FROM  DISK = N'C:\Temp\dncTDE.bak' WITH  FILE = 1,  NOUNLOAD,  STATS = 5

USE MASTER;
GO

-- Zertifikat wiederherstellen
CREATE CERTIFICATE dncCertificate   
    FROM FILE = 'C:\Temp\dncCertificate2.cer'   
    WITH PRIVATE KEY (FILE = 'C:\Temp\dncCertificate2.pvk',   
    DECRYPTION BY PASSWORD = '123456'); 
GO
RESTORE DATABASE [dotnetconsulting_TDE] FROM  DISK = N'C:\Temp\dncTDE.bak' WITH  FILE = 1,  NOUNLOAD,  STATS = 5;
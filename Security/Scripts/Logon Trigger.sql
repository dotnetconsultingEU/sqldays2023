-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschr�nkungen verwendet oder ver�ndert werden.
-- Jedoch wird keine Garantie �bernommen, dass eine Funktionsf�higkeit mit aktuellen und 
-- zuk�nftigen API-Versionen besteht. Der Autor �bernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgef�hrt wird.
-- F�r Anregungen und Fragen stehe ich jedoch gerne zur Verf�gung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- In die Master-Datenbank wechseln
USE [master];

-- Trigger ggf. vorher l�schen
IF EXISTS (SELECT* FROM [sys].[server_triggers] WHERE [name] = 'Logon_Trigger')
    DROP TRIGGER [Logon_Trigger] ON ALL SERVER;
GO

-- Trigger anlegen
CREATE TRIGGER [Logon_Trigger] ON ALL SERVER
    FOR LOGON
AS
	--IF (SELECT COUNT(*) FROM  [sys].[dm_exec_sessions] 
	--		WHERE is_user_process = 1 AND original_login_name = ORIGINAL_LOGIN()) > 1
		ROLLBACK;
	
GO

-- Dedicated Admin Connection (DAC)
-- SELECT name FROM sys.server_triggers;
-- DROP TRIGGER <name> ON ALL SERVER;
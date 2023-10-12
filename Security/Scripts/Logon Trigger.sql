-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- In die Master-Datenbank wechseln
USE [master];

-- Trigger ggf. vorher löschen
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
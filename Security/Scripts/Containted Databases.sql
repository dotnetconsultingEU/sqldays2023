-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

EXEC SP_CONFIGURE 'show advanced options', 1;
RECONFIGURE;
GO
EXEC SP_CONFIGURE 'contained database authentication', 1;
RECONFIGURE;


USE [master]
GO
ALTER DATABASE [Accounting] SET CONTAINMENT = PARTIAL
GO


USE ContainedDatabase;

CREATE USER tkansy WITH PASSWORD = 'Geheim4711';

EXECUTE sp_migrate_user_to_contained 
    @username = N'TKansy', 
    @rename = N'keep_name',
    @disablelogin = N'disable_login';


USE ContainedDatabase;

DECLARE @username sysname ;
DECLARE user_cursor CURSOR
    FOR 
        SELECT dp.name 
        FROM sys.database_principals AS dp
        JOIN sys.server_principals AS sp 
        ON dp.sid = sp.sid
        WHERE dp.authentication_type = 1 AND sp.is_disabled = 0;
OPEN user_cursor
FETCH NEXT FROM user_cursor INTO @username
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXECUTE sp_migrate_user_to_contained 
        @username = @username,
        @rename = N'keep_name',
        @disablelogin = N'disable_login';
    FETCH NEXT FROM user_cursor INTO @username
    END
CLOSE user_cursor ;
DEALLOCATE user_cursor ;


USE ContainedDatabase;

-- Join mit sys.objects, um den Namen des Objekts ausgeben zu können
SELECT SO.name, UE.* FROM sys.dm_db_uncontained_entities AS UE
LEFT JOIN sys.objects AS SO
    ON UE.major_id = SO.object_id;

CREATE VIEW vwTorten
AS
SELECT * FROM TonisTortenTraum..TortenSatz
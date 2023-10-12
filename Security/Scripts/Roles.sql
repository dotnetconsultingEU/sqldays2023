-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Datenbank anlegen
CREATE DATABASE dotnetconsulting_Roles;
GO
USE dotnetconsulting_Roles;

-- Test mit aktuelle User (dbo)
SELECT IS_MEMBER('db_owner');
SELECT IS_MEMBER('ungültigeRolle');

-- Logins und User anlgen
CREATE LOGIN [Jens] WITH PASSWORD=N'123', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;
GO
CREATE USER [Jens] FOR LOGIN [Jens];
GO

-- Tabelle anlegen
CREATE TABLE dbo.SpesenXY
(
	ID INT,
	IrgendEinWert VARCHAR(100)
);
INSERT dbo.SpesenXY
VALUES (1, 'A1'), (2, 'A2'), (3, 'A3');
SELECT * FROM dbo.SpesenXY;

-- Mitgliedschaft in der Rolle 'db_owner'
ALTER ROLE [db_owner] ADD MEMBER [Jens];
-- ALTER ROLE [db_owner] DROP MEMBER [Jens];

-- Test mit User
EXECUTE AS USER = 'Jens';
SELECT USER;
GO
SELECT IS_MEMBER('db_owner');

REVERT;
SELECT USER;


-- Datenbankrollen anlegen
CREATE ROLE [RolleA];
CREATE ROLE [RolleB];
CREATE ROLE [RolleC];

-- Verschaltete Rollen
-- RolleA Mitglied von db_owner
-- RolleB Mitglied von RolleA
-- RolleC Mitglied von RolleB
-- User Jens Mitgleid von Rolle C
ALTER ROLE [db_owner] ADD MEMBER [RolleA];
ALTER ROLE [RolleA] ADD MEMBER [RolleB];
ALTER ROLE [RolleB] ADD MEMBER [RolleC];
ALTER ROLE [RolleC] ADD MEMBER [Jens];

-- Test mit User
EXECUTE AS USER = 'Jens';
SELECT USER;
GO
SELECT IS_MEMBER('db_owner') 'db_owner';
SELECT IS_MEMBER('RolleA') 'RolleA';
SELECT IS_MEMBER('RolleB') 'RolleB';
SELECT IS_MEMBER('RolleC') 'RolleC';
SELECT * FROM dbo.SpesenXY;
REVERT;
SELECT USER;

-- Datenbankrollen auflisten und deren Mitglieder anzeigen
-- So ähnlich macht es das SSMS
 WITH RoleMembers (member_principal_id,role_principal_id)
AS (
	SELECT rm1.member_principal_id
		,rm1.role_principal_id
	FROM sys.database_role_members rm1(NOLOCK)
	
	UNION ALL
	
	SELECT d.member_principal_id
		,rm.role_principal_id
	FROM sys.database_role_members rm(NOLOCK)
	INNER JOIN RoleMembers AS d ON rm.member_principal_id = d.role_principal_id
	)
SELECT DISTINCT rp.NAME AS database_role, mp.NAME AS database_userl
FROM RoleMembers drm
INNER JOIN sys.database_principals rp ON (drm.role_principal_id = rp.principal_id)
INNER JOIN sys.database_principals mp ON (drm.member_principal_id = mp.principal_id)
ORDER BY rp.NAME;


-- Serverrollen
USE master;

SELECT IS_SRVROLEMEMBER('sysadmin');

CREATE SERVER ROLE [MyServerRole];
ALTER SERVER ROLE [MyServerRole] ADD MEMBER [DNC3\Thorsten];

SELECT IS_SRVROLEMEMBER('MyServerRole');
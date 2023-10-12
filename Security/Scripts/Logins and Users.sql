-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

SELECT Current_User,
	System_User,
	User_Name(),
	Suser_Sname();

SELECT suser_name(principal_id),
	suser_name(sid),
	suser_sname(principal_id),
	suser_sname(sid)
FROM sys.server_principals
WHERE NAME = suser_name();

CREATE DATABASE [dotnetconsulting];
GO
USE [dotnetconsulting];
GO

CREATE USER [User1] WITHOUT LOGIN;
GO

EXECUTE AS USER = 'User1';

SELECT Current_User,
	System_User,
	User_Name(),
	Suser_Sname();

SELECT suser_name(principal_id),
	suser_name(sid),
	suser_sname(principal_id),
	suser_sname(sid)
FROM sys.server_principals
WHERE NAME = suser_name();

REVERT;
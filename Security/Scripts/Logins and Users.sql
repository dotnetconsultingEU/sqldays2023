-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschr�nkungen verwendet oder ver�ndert werden.
-- Jedoch wird keine Garantie �bernommen, dass eine Funktionsf�higkeit mit aktuellen und 
-- zuk�nftigen API-Versionen besteht. Der Autor �bernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgef�hrt wird.
-- F�r Anregungen und Fragen stehe ich jedoch gerne zur Verf�gung.

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
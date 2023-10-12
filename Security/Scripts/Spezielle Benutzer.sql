-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

USE [dotnetconsulting_Roles];
GO

-- User deaktiviern
REVOKE CONNECT FROM [Jens];

-- User aktivieren
GRANT CONNECT TO [Jens];

-- Übersicht verschaffen
SELECT name, hasdbaccess FROM sys.sysusers WHERE islogin = 1 
ORDER BY name;
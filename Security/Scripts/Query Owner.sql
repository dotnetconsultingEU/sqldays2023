-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

USE dotnetconsulting_Permissions;
GO

-- Besitzer abfragen
SELECT s.name + '.' + o.name AS ObjectName , COALESCE(p.name, p2.name) AS OwnerName ,*
FROM sys.all_objects o 
LEFT OUTER JOIN sys.database_principals p ON o.principal_id = p.principal_id
LEFT OUTER JOIN sys.schemas s ON o.schema_id = s.schema_id
LEFT OUTER JOIN sys.database_principals p2 ON s.principal_id = p2.principal_id
WHERE o.type IN ('V', 'P', 'U') AND s.name NOT IN ('sys', 'INFORMATION_SCHEMA')


-- Besitzer ändern
ALTER AUTHORIZATION ON [dbo].[SpesenXY] to [Jens];
ALTER AUTHORIZATION ON [dbo].[SpesenXY] to dbo;
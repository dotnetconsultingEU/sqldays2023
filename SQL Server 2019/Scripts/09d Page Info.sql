-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

USE [dotnetconsulting_Videogames];

-- DBCC PAGE
-- Seite ausgeben
DBCC TRACEON(3604)
GO
-- Database|DatabaseId
-- FileNr (sp_helpfile)
-- PageNr
--0 – print just the page header
--1 – page header plus per-row hex dumps and a dump of the page slot array
--2 – page header plus whole page hex dump
--3 – page header plus detailed per-row interpretation
DBCC PAGE(dotnetconsulting_Videogames, /* Database */ 1, /* Page */ 1, 0);

-- SQL Server 2019
SELECT * FROM sys.dm_db_page_info(/* Database */ 1, /* Page */ 1, 0, 'DETAILED'); 

-- Beispiel von MS
SELECT page_info.* 
FROM sys.dm_exec_requests AS d 
  CROSS APPLY sys.fn_PageResCracker(d.page_resource) AS r
  CROSS APPLY sys.dm_db_page_info(r.db_id, r.file_id, r.page_id,'DETAILED')
    AS page_info;
-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Datenbank anlegen und wechseln
USE [AdventureWorks2014];

-- Query Store einschalten
ALTER DATABASE [AdventureWorks2014] SET QUERY_STORE = ON;

-- Test Abfragen
SELECT * FROM [Sales].[vSalesPerson];
SELECT * FROM [HumanResources].[vEmployee];
SELECT * FROM [Sales].[vStoreWithContacts];
-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

USE AdventureWorks;
GO

-- Query cost: 41%
DBCC DROPCLEANBUFFERS;
SELECT APPROX_COUNT_DISTINCT([OrderQty]) AS Approx_Distinct_OrderKey
FROM [Sales].[SalesOrderDetail];

-- Query cost: 59% 
DBCC DROPCLEANBUFFERS;
SELECT COUNT(DISTINCT [OrderQty]) AS Approx_Distinct_OrderKey
FROM [Sales].[SalesOrderDetail];
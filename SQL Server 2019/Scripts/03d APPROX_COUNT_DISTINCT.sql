-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschr�nkungen verwendet oder ver�ndert werden.
-- Jedoch wird keine Garantie �bernommen, dass eine Funktionsf�higkeit mit aktuellen und 
-- zuk�nftigen API-Versionen besteht. Der Autor �bernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgef�hrt wird.
-- F�r Anregungen und Fragen stehe ich jedoch gerne zur Verf�gung.

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
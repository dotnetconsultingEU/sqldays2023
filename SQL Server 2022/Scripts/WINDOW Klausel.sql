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
-- Pre SQL Server 2022
SELECT SalesOrderID, ProductID, OrderQty
    ,SUM(OrderQty) OVER (PARTITION BY SalesOrderID) AS Total
    ,AVG(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Avg"
    ,COUNT(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Count"
    ,MIN(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Min"
    ,MAX(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Max"
    FROM Sales.SalesOrderDetail
WHERE SalesOrderID IN(43659,43664);
GO

-- SQL Server 2022
SELECT SalesOrderID, ProductID, OrderQty
    ,SUM(OrderQty) OVER win AS Total
    ,AVG(OrderQty) OVER win AS "Avg"
    ,COUNT(OrderQty) OVER win AS "Count"
    ,MIN(OrderQty) OVER win AS "Min"
    ,MAX(OrderQty) OVER win AS "Max"
FROM Sales.SalesOrderDetail
WHERE SalesOrderID IN(43659,43664)
WINDOW win AS (PARTITION BY SalesOrderID);
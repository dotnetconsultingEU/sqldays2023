-- Disclaimer:
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Es wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen steht der Autor gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

USE AdventureWorks;
GO
SELECT Name, ListPrice,
       FIRST_VALUE(Name) RESPECT NULLS OVER (ORDER BY ListPrice ASC) AS LeastExpensive
FROM Production.Product
WHERE ProductSubcategoryID = 37;

SELECT Name, ListPrice,
       FIRST_VALUE(Name) IGNORE NULLS OVER (ORDER BY ListPrice ASC) AS LeastExpensive
FROM Production.Product
WHERE ProductSubcategoryID = 37;

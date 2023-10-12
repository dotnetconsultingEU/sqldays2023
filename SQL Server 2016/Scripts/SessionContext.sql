-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Ab SQL Server 2008
DECLARE @context VARBINARY(128);
SET @context = CAST('Sales' AS VARBINARY(128));
SET CONTEXT_INFO @context;

-- Abfragen 
SELECT CAST(CONTEXT_INFO() AS VARCHAR(128));

-- Filter nach Abteilung
USE AdventureWorks;
SELECT 
	Dep.Name AS 'Department Name',
	Per.LastName,
	Per.FirstName
FROM [HumanResources].[Department] Dep 
LEFT JOIN [HumanResources].[EmployeeDepartmentHistory] EmpDep ON Dep.DepartmentID = EmpDep.DepartmentID
LEFT JOIN [HumanResources].[Employee] Emp ON Emp.BusinessEntityID = EmpDep.BusinessEntityID
LEFT JOIN [Person].[Person] Per ON Per.BusinessEntityID = EmpDep.BusinessEntityID
WHERE EmpDep.EndDate IS NULL AND Emp.CurrentFlag = 1 AND 
(CONTEXT_INFO() IS NULL OR Dep.Name = CAST(CONTEXT_INFO() AS VARCHAR(128)));

-- Löschen
SET CONTEXT_INFO 0x;


-- Ab SQL Server 2016
EXEC sp_set_session_context @key = 'Department',  @value='Sales';

-- Abfragen
SELECT SESSION_CONTEXT(N'Department');

USE AdventureWorks;
SELECT 
	Dep.Name AS 'Department Name',
	Per.LastName,
	Per.FirstName
FROM [HumanResources].[Department] Dep 
LEFT JOIN [HumanResources].[EmployeeDepartmentHistory] EmpDep ON Dep.DepartmentID = EmpDep.DepartmentID
LEFT JOIN [HumanResources].[Employee] Emp ON Emp.BusinessEntityID = EmpDep.BusinessEntityID
LEFT JOIN [Person].[Person] Per ON Per.BusinessEntityID = EmpDep.BusinessEntityID
WHERE EmpDep.EndDate IS NULL AND Emp.CurrentFlag = 1 AND 
(SESSION_CONTEXT(N'Department') IS NULL OR Dep.Name = SESSION_CONTEXT(N'Department'));

-- Löschen
EXEC sp_set_session_context @key = 'Department',  @value=NULL;
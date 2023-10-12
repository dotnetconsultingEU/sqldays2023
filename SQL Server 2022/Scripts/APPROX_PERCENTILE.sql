-- Disclaimer:
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Es wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen steht der Autor gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

SET NOCOUNT ON
GO
DROP TABLE IF EXISTS #Employee;
GO
CREATE TABLE #Employee 
(
	EmplId INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
	DeptId INT,
	Salary int
);
GO
INSERT #Employee
VALUES (1, 31), (1, 33), (1, 18), (2, 25), (2, 35), (2, 10), (2, 10), 
       (3, 1), (3, NULL), (4, NULL), (4, NULL);
GO

-- Kontinuierliche Werte
SELECT DISTINCT DeptId,
       PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY Salary) OVER (PARTITION BY DeptId) AS 'P10',
       PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY Salary) OVER (PARTITION BY DeptId) AS 'P90'  
FROM #Employee;

SELECT DeptId,
	   APPROX_PERCENTILE_CONT(0.10) WITHIN GROUP(ORDER BY Salary) AS 'P10',
	   APPROX_PERCENTILE_CONT(0.90) WITHIN GROUP(ORDER BY Salary) AS 'P90'
FROM #Employee
GROUP BY DeptId;

-- Diskrete Werte
SELECT DISTINCT DeptId,
       PERCENTILE_DISC(0.10) WITHIN GROUP (ORDER BY Salary) OVER (PARTITION BY DeptId) AS 'P10',
       PERCENTILE_DISC(0.90) WITHIN GROUP (ORDER BY Salary) OVER (PARTITION BY DeptId) AS 'P90'  
FROM #Employee;

SELECT DeptId,
       APPROX_PERCENTILE_DISC(0.10) WITHIN GROUP(ORDER BY Salary) AS 'P10',
       APPROX_PERCENTILE_DISC(0.90) WITHIN GROUP(ORDER BY Salary) AS 'P90'
FROM #Employee
GROUP BY DeptId;

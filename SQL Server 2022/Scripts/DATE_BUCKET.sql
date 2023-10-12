-- Disclaimer:
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Es wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen steht der Autor gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu
SELECT @@DATEFIRST '@@DATEFIRST', DATENAME(WEEKDAY, @@DATEFIRST) 'Weekday'

DECLARE @date DATETIME2 = '2022-02-24 00:00:00';
SELECT 'WEEK', DATE_BUCKET(WEEK, 1, @date); -- 2022-02-21 00:00:00.0000000
SELECT 'MONTH', DATE_BUCKET(MONTH, 1, @date); -- 2022-02-21 00:00:00.0000000
SELECT 'YEAR', DATE_BUCKET(YEAR, 1, @date); -- 2022-01-01 00:00:00.0000000

DECLARE @date DATETIME2 = '2022-02-24 00:00:00';
DECLARE @origin1 DATETIME2 = '2021-01-01 00:00:00';
DECLARE @origin2 DATETIME2 = '2021-02-22 00:00:00';
SELECT 'WEEK', DATE_BUCKET(WEEK, 1, @date, @origin1); -- 2022-02-18 00:00:00.0000000
SELECT 'WEEK', DATE_BUCKET(WEEK, 1, @date, @origin2); -- 2022-02-21 00:00:00.0000000



-- Playground
SELECT 'MONTH', DATE_BUCKET(MONTH, 1, @origin, @date); -- 2022-02-21 00:00:00.0000000
SELECT 'YEAR', DATE_BUCKET(YEAR, 1, @origin, @date); -- 2022-01-01 00:00:00.0000000

DECLARE @start DATETIME2 = '2022-01-03';
DECLARE @end DATETIME2 = '2022-12-26';
SELECT DATE_BUCKET(MONTH, 9, @start);

-- "Bucket" von einem Tag ist der Anfang jeden Tages
DECLARE @origin DATETIME2 = '2022-01-03 20:20:20' -- null => 1900-01-01 00:00:00.000
DECLARE @date DATETIME2 = '2022-12-26 23:59:59';
SELECT 'WEEK', DATE_BUCKET(WEEK, 2, @origin, @date)
UNION ALL
SELECT 'HOUR', DATE_BUCKET(HOUR, 1, @origin)
UNION ALL
SELECT 'MINUTE', DATE_BUCKET(MINUTE, 1, @origin)
UNION ALL
SELECT 'SECOND', DATE_BUCKET(SECOND, 1, @origin);
GO

-- "Bucket" von einem Tag ist der Anfang jeden Tages
DECLARE @date DATETIME2 = GETDATE();
DECLARE @origin DATETIME2 = '2022-01-01 00:00:00.000' -- null => 1900-01-01 00:00:00.000
SELECT 'Day', @date, DATE_BUCKET(DAY, 1, @date, @origin)
UNION ALL
SELECT 'Day', @date, DATE_BUCKET(DAY, 1, DATEADD(Day, 1, @date), @origin)
UNION ALL
SELECT 'Day', @date, DATE_BUCKET(DAY, 1, DATEADD(Day, 2, @date), @origin)
UNION ALL
SELECT 'Day', @date, DATE_BUCKET(DAY, 1, DATEADD(MONTH, 3, @date), @origin);
GO

-- "Bucket" von zwei Tagen ist der Anfang jeden Tages
DECLARE @date DATETIME2 = GETDATE();
DECLARE @origin DATETIME2 = '2022-01-01 00:00:00.000' -- null => 1900-01-01 00:00:00.000
SELECT 'Day', @date, DATE_BUCKET(DAY, 2, @date, @origin)
UNION ALL
SELECT 'Day', @date, DATE_BUCKET(DAY, 2, DATEADD(Day, 1, @date), @origin)
UNION ALL
SELECT 'Day', @date, DATE_BUCKET(DAY, 2, DATEADD(Day, 2, @date), @origin)
UNION ALL
SELECT 'Day', @date, DATE_BUCKET(DAY, 2, DATEADD(Day, 3, @date), @origin);
GO

-- "Bucket" von einer Woche ist der Anfang der Woche
DECLARE @date DATETIME2 = GETDATE();
DECLARE @origin DATETIME2 = '2022-01-01 00:00:00.000' -- null => 1900-01-01 00:00:00.000
SELECT 'Week', @date, DATE_BUCKET(Week, 1, @date, @origin)
UNION ALL
SELECT 'Week', @date, DATE_BUCKET(Week, 1, DATEADD(Day, 1, @date), @origin)
UNION ALL
SELECT 'Week', @date, DATE_BUCKET(Week, 1, DATEADD(Day, 2, @date), @origin)
UNION ALL
SELECT 'Week', @date, DATE_BUCKET(Week, 1, DATEADD(Day, 3, @date), @origin);
GO

-- "Bucket" von einem Jahr ist der Anfang des Jahres
DECLARE @date DATETIME2 = GETDATE();
DECLARE @origin DATETIME2 = '2022-01-01 00:00:00.000' -- null => 1900-01-01 00:00:00.000
SELECT 'Year', @date, DATE_BUCKET(Year, 1, @date, @origin)
UNION ALL
SELECT 'Year', @date, DATE_BUCKET(Year, 1, DATEADD(Year, 1, @date), @origin)
UNION ALL
SELECT 'Year', @date, DATE_BUCKET(Year, 1, DATEADD(Year, 2, @date), @origin)
UNION ALL
SELECT 'Year', @date, DATE_BUCKET(Year, 1, DATEADD(Year, 3, @date), @origin);
GO
-- Disclaimer:
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Es wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen steht der Autor gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

DECLARE @d DATETIME2 = GETDATE();
SELECT 'Year', DATETRUNC(YEAR, @d); -- 2022-01-01 00:00:00.0000000
SELECT 'Quarter', DATETRUNC(QUARTER, @d); --2022-10-01 00:00:00.0000000
SELECT 'Month', DATETRUNC(MONTH, @d); -- 2022-12-01 00:00:00.0000000
SELECT 'Week', DATETRUNC(WEEK, @d); -- 2022-12-11 00:00:00.0000000
SELECT 'Iso_week', DATETRUNC(ISO_WEEK, @d); -- 2022-12-12 00:00:00.0000000
SELECT 'DayOfYear', DATETRUNC(DAYOFYEAR, @d); -- 2022-12-17 00:00:00.0000000
SELECT 'Day', DATETRUNC(DAY, @d); -- 2022-12-17 00:00:00.0000000
SELECT 'Hour', DATETRUNC(HOUR, @d); -- 2022-12-17 19:00:00.0000000
SELECT 'Minute', DATETRUNC(MINUTE, @d); -- 2022-12-17 19:45:00.0000000
SELECT 'Second', DATETRUNC(SECOND, @d); -- 2022-12-17 19:45:17.0000000
SELECT 'Millisecond', DATETRUNC(MILLISECOND, @d); -- 2022-12-17 19:45:17.5800000
SELECT 'Microsecond', DATETRUNC(MICROSECOND, @d); -- 2022-12-17 19:45:17.5800000

-- Relevant für 'WEEK'
SELECT @@DATEFIRST '@@DATEFIRST', DATENAME(WEEKDAY, @@DATEFIRST) 'Weekday'

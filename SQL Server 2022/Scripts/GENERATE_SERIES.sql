-- Disclaimer:
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Es wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen steht der Autor gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Von 1 bis <=50 in 5er Schritten => 1..6..11..41..46
SELECT value FROM GENERATE_SERIES(/* Start */ 1, /*STOP*/ 50, /*STEP*/ 5);

-- Auch andere (numerische) Datentypen sind erlaubt
SELECT value FROM GENERATE_SERIES(/* Start */ 1.0, /*STOP*/ 10.0, /*STEP*/ .5);

-- Alle Kalenderwochen 2022
SELECT CAST(DATEADD(WEEK, value - 1, '2022-01-03') AS DATE), value FROM GENERATE_SERIES(1, 52);
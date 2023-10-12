-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Horizontales Maxi-/ Minimum
SELECT GREATEST('6.62', 3.1415, N'7') AS 'GREATEST', -- 7.0000
	   LEAST( '6.62', 3.1415, N'7') AS 'LEAST'; -- 3.1415

SELECT GREATEST('A', 'B', 'C') AS 'GREATEST', -- C
	   LEAST('A', 'B', 'C') AS 'LEAST'; -- A

-- Max/ Min funktionieren nicht, da dies Aggregate sind!
--SELECT MAX( '6.62', 3.1415, N'7' ) AS GREATEST; 
--SELECT MIN( '6.62', 3.1415, N'7' ) AS LEAST; 
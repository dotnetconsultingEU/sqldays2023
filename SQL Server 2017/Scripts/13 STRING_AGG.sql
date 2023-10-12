-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschr�nkungen verwendet oder ver�ndert werden.
-- Jedoch wird keine Garantie �bernommen, dass eine Funktionsf�higkeit mit aktuellen und 
-- zuk�nftigen API-Versionen besteht. Der Autor �bernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgef�hrt wird.
-- F�r Anregungen und Fragen stehe ich jedoch gerne zur Verf�gung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Ab SQL Server 2016
SELECT * FROM STRING_SPLIT('A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z',',');

-- Alle Datenbanken ohne bestimmte Sortierung
SELECT STRING_AGG([name], '; ') AS Datenbanken FROM sys.databases;

-- Ebenfalls alle Datenbanken, diesmal sortiert nach Namen
SELECT STRING_AGG([name], '; ') WITHIN GROUP (ORDER BY [name]) AS Datenbanken FROM sys.databases;
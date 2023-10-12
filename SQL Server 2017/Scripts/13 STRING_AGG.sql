-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Ab SQL Server 2016
SELECT * FROM STRING_SPLIT('A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z',',');

-- Alle Datenbanken ohne bestimmte Sortierung
SELECT STRING_AGG([name], '; ') AS Datenbanken FROM sys.databases;

-- Ebenfalls alle Datenbanken, diesmal sortiert nach Namen
SELECT STRING_AGG([name], '; ') WITHIN GROUP (ORDER BY [name]) AS Datenbanken FROM sys.databases;
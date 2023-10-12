-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Erweiterte Optionen anzeigen
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

-- clr strict security auslesen. Das Ergebnis sollte 1 (aktiv) sein
EXEC sp_configure 'clr strict security';

-- Entgegen Microsofts Ratschlag ausschalten
EXEC sp_configure 'clr strict security', 0;
RECONFIGURE;
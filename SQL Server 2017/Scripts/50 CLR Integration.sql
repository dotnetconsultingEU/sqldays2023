-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschr�nkungen verwendet oder ver�ndert werden.
-- Jedoch wird keine Garantie �bernommen, dass eine Funktionsf�higkeit mit aktuellen und 
-- zuk�nftigen API-Versionen besteht. Der Autor �bernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgef�hrt wird.
-- F�r Anregungen und Fragen stehe ich jedoch gerne zur Verf�gung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Erweiterte Optionen anzeigen
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

-- clr strict security auslesen. Das Ergebnis sollte 1 (aktiv) sein
EXEC sp_configure 'clr strict security';

-- Entgegen Microsofts Ratschlag ausschalten
EXEC sp_configure 'clr strict security', 0;
RECONFIGURE;
-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschr�nkungen verwendet oder ver�ndert werden.
-- Jedoch wird keine Garantie �bernommen, dass eine Funktionsf�higkeit mit aktuellen und 
-- zuk�nftigen API-Versionen besteht. Der Autor �bernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgef�hrt wird.
-- F�r Anregungen und Fragen stehe ich jedoch gerne zur Verf�gung.

-- Thorsten Kansy, www.dotnetconsulting.eu

USE AdventureWorks;
GO

-- Ausschalten, auch bei Compatibility Level 150+
ALTER DATABASE SCOPED CONFIGURATION SET DEFERRED_COMPILATION_TV  = OFF;

-- Wieder einschalten
ALTER DATABASE SCOPED CONFIGURATION SET DEFERRED_COMPILATION_TV  = ON;

-- Deaktivierung pro Abfrage
DECLARE @Person TABLE 
(
	BusinessEntityID INT NOT NULL,
	NameStyle BIT NOT NULL,
	Firstname VARCHAR(50) NOT NULL,
	Lastname VARCHAR(50) NOT NULL
);

INSERT @Person
SELECT BusinessEntityID, NameStyle, Firstname, Lastname
FROM Person.Person;

SELECT	*
FROM @Person p
INNER JOIN [Person].[Password] pwd ON p.BusinessEntityID = pwd.BusinessEntityID
WHERE p.NameStyle = 0
OPTION (USE HINT('DISABLE_DEFERRED_COMPILATION_TV'));
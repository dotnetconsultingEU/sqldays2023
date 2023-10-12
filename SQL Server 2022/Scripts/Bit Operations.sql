-- Disclaimer:
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Es wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen steht der Autor gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Datenbank (erneut) anlegen und wechseln
:SETVAR dbname dotnetconsulting_BitOperations
USE [master];
IF EXISTS (SELECT * FROM [sys].[databases] WHERE [name] = '$(dbname)')
BEGIN
	ALTER DATABASE [$(dbname)] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [$(dbname)];
	PRINT '''$(dbname)''-Datenbank gelöscht';
END
GO
CREATE DATABASE [$(dbname)];
GO
USE [$(dbname)];
PRINT '''$(dbname)''-Datenbank erstellt und gewechselt';
GO

CREATE FUNCTION dbo.ConvertToBit 
(
	@number INT
)
RETURNS VARCHAR(32)
AS
BEGIN
	DECLARE @result VARCHAR(32) = '';

	WHILE 1 = 1 BEGIN
	  SELECT @result = CONVERT(CHAR(1), @number % 2) + @result,
			 @number = CONVERT(INT, @number / 2)
	  IF @number = 0 
		BREAK
	END
	RETURN @result;
END
GO

DECLARE @number INT = 1234;

-- RIGHT_SHIFT()/ LEFT_SHIFT()
SELECT dbo.ConvertToBit(@number), dbo.ConvertToBit(RIGHT_SHIFT(@number, 1)) '>> 1', dbo.ConvertToBit(RIGHT_SHIFT(@number, 2)) '>> 2', dbo.ConvertToBit(RIGHT_SHIFT(@number, 3)) '>> 3';
SELECT dbo.ConvertToBit(@number), dbo.ConvertToBit(LEFT_SHIFT(@number, 1)) '<< 1', dbo.ConvertToBit(LEFT_SHIFT(@number, 2)) '<< 2', dbo.ConvertToBit(LEFT_SHIFT(@number, 3)) '<< 3';

-- BIT_COUNT()
SELECT dbo.ConvertToBit(@number), BIT_COUNT(@number) 'Number of 1s';

-- SET_BIT()/ GET_BIT()
SELECT GET_BIT(@number, 0) 'Pos 0', GET_BIT(@number, 1) 'Pos 1';
SELECT dbo.ConvertToBit(SET_BIT(@number, 0)) 'Set Pos 0';
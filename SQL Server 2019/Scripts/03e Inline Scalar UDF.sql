-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Datenbank wechseln
:SETVAR dbname dotnetconsulting_Videogames
USE [$(dbname)];
GO

-- Scalar Funktionen anlegen
CREATE OR ALTER FUNCTION [dbo].[fnDivScore]
(
	@Punkte INT,
	@Div INT
)
RETURNS INT -- VARCHAR(50)
WITH INLINE = OFF
AS
BEGIN
	RETURN @Punkte / @Div;		                
END
GO

CREATE OR ALTER FUNCTION [dbo].[fnRateScore]
(
	@Punkte INT
)
RETURNS VARCHAR(50)
AS
BEGIN
	RETURN CASE 
				WHEN @Punkte < 1000000000 THEN 'Wenig'
				WHEN @Punkte < 1500000000 THEN 'Mittel'
				ELSE 'Viel'
			END		                
END
GO

CREATE OR ALTER FUNCTION [dbo].[fnVowelRate]
(
    @String NVARCHAR(4000)
)
RETURNS DECIMAL(18,2)
AS
BEGIN
	-- Länge des Strings
	DECLARE @l INT = LEN(@String),
			@c INT = 1, -- Anfang mit 1  
			@vowel DECIMAL(18,2) = 0, -- Anzahl der Vokale
	        @result DECIMAL(18,2) = -1.0;

	-- Vokale suchen
	WHILE @c <= @l
	BEGIN
		IF SUBSTRING(@String, @c, 1) IN ('a', 'e', 'i', 'o', 'u')
			SET @vowel = @vowel + 1;

		SET @c = @c +1;
	END

	SET @result = @vowel / CAST(@l AS DECIMAL);

	-- Letzte Anweisung muss ein RETURN sein
	RETURN @result;
END
GO

-- Abfrage mit UDF (Ausführen mit INLINE = ON/ OFF)
DBCC DROPCLEANBUFFERS;
GO
SET STATISTICS TIME ON;
SELECT [dbo].[fnDivScore](Punkte, 1000), * FROM [dbo].[Highscores]
	WHERE [dbo].[fnDivScore](Punkte, 1000) > 758577
SET STATISTICS TIME OFF;
-- wird zu
SELECT Punkte / 1000, * FROM [dbo].[Highscores]
	WHERE Punkte / 1000 > 758577;

-- Wie oft wurde die Funktion aufgerufen?
SELECT [function] = OBJECT_NAME([object_id]), execution_count 
  FROM sys.dm_exec_function_stats
  WHERE object_name(object_id) IS NOT NULL;

GO
--SELECT [dbo].[fnRateScore](Punkte), * FROM [dbo].[Highscores];
--SELECT [dbo].[fnDivScore](Punkte, 1000), * FROM [dbo].[Highscores];
--SELECT [dbo].[fnVowelRate]([Name]), * FROM [dbo].[Spieler];

-- Was kann "ge-inlined" werden?
SELECT [is_inlineable], '|' [|], * FROM sys.sql_modules;

-- Auf Datenbanklevel kann die Funktion ausgeschaltet werden
ALTER DATABASE SCOPED CONFIGURATION SET TSQL_SCALAR_UDF_INLINING = OFF;
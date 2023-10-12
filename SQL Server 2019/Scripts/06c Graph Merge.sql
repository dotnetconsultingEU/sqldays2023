-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschr�nkungen verwendet oder ver�ndert werden.
-- Jedoch wird keine Garantie �bernommen, dass eine Funktionsf�higkeit mit aktuellen und 
-- zuk�nftigen API-Versionen besteht. Der Autor �bernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgef�hrt wird.
-- F�r Anregungen und Fragen stehe ich jedoch gerne zur Verf�gung.

-- Thorsten Kansy, www.dotnetconsulting.eu

:SETVAR dbname dotnetconsulting.Graph
USE [$(dbname)];
PRINT 'In ''$(dbname)''-Datenbank gewechselt';
GO

-- Einen einzelnen Follower hinzuf�gen
CREATE OR ALTER PROCEDURE [dbo].[usp_AddFollowerSingle]
	@fromName VARCHAR(100),
	@toName VARCHAR(100)
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON;

	-- Sicher stellen, dass die neuen Follower auch als Person-Node vorhanden sind
	MERGE [dbo].[People] T
	USING 
	(
		SELECT @fromName AS [Name]
	) S
	ON S.[Name] = t.[Name]
	WHEN NOT MATCHED THEN INSERT ([Name]) VALUES (s.[Name])
	OUTPUT $action AS [People.$Action], S.[Name];
 
	-- Follow-Edge anlegen wenn nicht vorhanden
	MERGE [dbo].[Follows]
	USING
	(
		(SELECT @fromName, @toName) AS T (fromName, toName)
		JOIN [dbo].[people] [from] ON T.[fromName] = [from].[Name]
		JOIN [dbo].[people] [to] ON T.[toName] = [to].[Name]
	)
	ON MATCH ([from]-(Follows)->[to])
	WHEN NOT MATCHED THEN INSERT ($from_id, $to_id) VALUES ([from].$node_id, [to].$node_id)
	OUTPUT $action AS [Follows.$Action], [from].$node_id, [to].$node_id; -- $edge_id?
END
GO

-- SP um mehere Follower hinzuzuf�gen
DROP PROCEDURE IF EXISTS [dbo].[usp_AddFollowerMultiple];
DROP TYPE IF EXISTS tvp_Follower;
GO

CREATE TYPE tvp_Follower AS TABLE
(
	fromName VARCHAR(100),
	toName VARCHAR(100)
);
GO

CREATE PROCEDURE [dbo].[usp_AddFollowerMultiple]
	@follower tvp_Follower READONLY
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON;

	-- Sicherstellen, dass die neuen Follower und die Gefolgten auch als Person-Node vorhanden sind
	MERGE [dbo].[People] T
	USING 
	(
		SELECT fromName AS [Name] FROM @follower
		UNION
		SELECT toName FROM @follower
	) S
	ON S.[Name] = t.[Name]
	WHEN NOT MATCHED THEN INSERT ([Name]) VALUES (s.[Name])
	OUTPUT $action AS [People.$Action], S.[Name];

	-- Follow-Edge anlegen, wenn nicht vorhanden
	MERGE [dbo].[Follows]
	USING
	(
		(SELECT * FROM @follower) AS T 
		JOIN [dbo].[people] [from] ON T.[fromName] = [from].[Name]
		JOIN [dbo].[people] [to] ON T.[toName] = [to].[Name]
	)
	ON MATCH ([from]-(Follows)->[to])
	WHEN NOT MATCHED THEN INSERT ($from_id, $to_id) VALUES ([from].$node_id, [to].$node_id)
	-- WHEN NOT MATCHED BY SOURCE THEN DELETE
	OUTPUT $action AS [Follows.$Action], [from].$node_id, [to].$node_id; -- $edge_id?
END
GO

---------------
-- Demo Aufrufe
---------------

-- Einen Follower hinzuf�gen
EXEC [usp_AddFollowerSingle] @FromName = 'Person#1001', @ToName = 'Person#1';
EXEC [usp_AddFollowerSingle] @FromName = 'Person#1001', @ToName = 'Person#2';

-- Mehere Follower hinzuf�gen
DECLARE @follower tvp_Follower;

INSERT @follower VALUES ('Person#10', 'Person#11'), 
						('Person#20', 'Person#21'), 
						('Person#30', 'Person#31'),
						('Person#1001', 'Person#2');

EXEC [dbo].[usp_AddFollowerMultiple] @follower = @follower;
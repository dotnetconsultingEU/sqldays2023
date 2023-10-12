-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting

SELECT TOP 3 
  name, database_id, source_database_id 
FROM sys.databases 
ORDER BY database_id
FOR JSON AUTO;
--[  
--   {  
--      "name":"master",
--      "database_id":1
--   },
--   {  
--      "name":"tempdb",
--      "database_id":2
--   },
--   {   
--      "name":"model",
--      "database_id":3
--   }
--]
 
SELECT TOP 3
  name, database_id, source_database_id 
FROM sys.databases 
ORDER BY database_id
FOR JSON PATH, ROOT('Databases');
--{ 
--   "Databases":[  
--      {  
--         "name":"master",
--         "database_id":1
--      },
--      {  
--         "name":"tempdb",
--         "database_id":2
--      },
--      {  
--         "name":"model",
--         "database_id":3
--      }
--   ]
--}

SELECT TOP 3
  name, database_id, source_database_id 
FROM sys.databases 
ORDER BY database_id
FOR JSON PATH, ROOT('Databases'), INCLUDE_NULL_VALUES;
--{  
--   "Databases":[  
--      {  
--         "name":"master",
--         "database_id":1,
--         "source_database_id":null
--      },
--      {  
--         "name":"tempdb",
--         "database_id":2,
--         "source_database_id":null
--      },
--      {  
--         "name":"model",
--         "database_id":3,
--         "source_database_id":null
--      }
--   ]
--}

-- Einzelne Werte
SELECT f FROM (SELECT 'foo') AS x(f) FOR JSON AUTO;

-- Sonderzeichen werden richtig behandelt
DECLARE @json NVARCHAR(256) = 
   N'cr/lf: ' + CHAR(13) + CHAR(10) +
   N'slashes: /\' +
   N'tab: ' + CHAR(9) +
   N'quote: "';

SELECT @json AS json FOR JSON PATH;
--{
--   "json":"cr\/lf: \r\nslashes: \/\\tab: \tquote: \""
--}

-- JSON für CLR Typen?
DECLARE @g GEOGRAPHY;
SELECT @g '@g' FOR JSON PATH;
GO

DECLARE @g GEOMETRY;
SELECT @g '@g' FOR JSON PATH;
GO

DECLARE @h HIERARCHYID = '/1/2/'
SELECT @h '@h' FOR JSON PATH;

-- Genau eine Zeile (ab CTP 3.3 funktioniert's richtig)
SELECT f FROM (SELECT REPLICATE('x',2023)) AS x(f) FOR JSON AUTO;
-- Plötzlich zwei Zeilen?!
SELECT f FROM (SELECT REPLICATE('x',2024)) AS x(f) FOR JSON AUTO;
-- 2033 Zeichen mehr => 3 Zeilen
SELECT f FROM (SELECT REPLICATE('x',4057)) AS x(f) FOR JSON AUTO;
-- 2033 Zeichen mehr => 4 Zeilen
SELECT f FROM (SELECT REPLICATE('x',6090)) AS x(f) FOR JSON AUTO;

-- == JSON Path
--•'$' - references entire JSON object in the input text,
--•'$.property1' – references property1 in JSON object,
--•'$[5]' – references 5-th element in JSON array,
--•'$.property1.property2.array1[5].property3.array2[15].property4' – references complex nested property in the JSON object


-- == JSON_VALUE
DECLARE @json VARCHAR(4000);
SELECT @json = x FROM 
(
	SELECT TOP 3
	  name, database_id, source_database_id 
	FROM sys.databases 
	ORDER BY database_id
	FOR JSON PATH, ROOT('Databases'), INCLUDE_NULL_VALUES
) f(x);

SELECT JSON_VALUE(@json, 'strict$.Databases[0].name');
SELECT JSON_VALUE(@json, '$.Databases[0].name');
SELECT JSON_VALUE(@json, '$.Databases[0].name');
SELECT JSON_VALUE(@json, 'lax$.Databases[1].name');
SELECT JSON_VALUE(@json, 'strict$.Databases[2].name');


-- == OPENJSON
GO
DECLARE @json VARCHAR(4000)= '
{  
   "Databases":[  
      {  
         "name":"master",
         "database_id":1,
         "source_database_id":null
      },
      {  
         "name":"tempdb", 
         "database_id":2,
         "source_database_id":null
      },
      {  
         "name":"model",
         "database_id":3,
         "source_database_id":null
      }
   ]
}';

SELECT * FROM OPENJSON (@json, '$.Databases')
WITH (
    name VARCHAR(200), 
    database_id INT,
    source_database_id INT
) AS Databases ORDER BY name;


-- == JSON_QUERY
GO
DECLARE @json VARCHAR(4000)= '
{  
   "Databases":[  
      {  
         "name":"master",
         "database_id":1,
         "source_database_id":null
      },
      {  
         "name":"tempdb", 
         "database_id":2,
         "source_database_id":null
      },
      {  
         "name":"model",
         "database_id":3,
         "source_database_id":null
      }
   ]
}';

SELECT JSON_QUERY(@json, '$.Databases') AS Databases;


-- == JSON_MODIFY
SET @json = JSON_MODIFY(@json, '$.Databases[0].name', 'TestDb');
SELECT JSON_QUERY(@json, '$.Databases') AS Databases;


-- == Tabelle
GO
CREATE DATABASE dotnetconsulting_JSON;
GO
USE dotnetconsulting_JSON;
GO

-- Tabelle
CREATE TABLE dbo.Servers
(
  ID INT PRIMARY KEY IDENTITY(1,1),
  Servername SYSNAME,
  DatabasesJSON VARCHAR(4000),
  CONSTRAINT chkJSON_Databases CHECK (ISJSON(DatabasesJSON)=1),
  Details AS (CONVERT(VARCHAR(128), JSON_VALUE(DatabasesJSON, 'lax.$.Databases[0].name')))
);
 
-- Indexierung
CREATE INDEX idx_Details1 ON dbo.Servers(Details);

-- Leider nicht so ;-(
CREATE INDEX idx_Details2 ON dbo.Servers(Details) 
WHERE Details NOT IS NULL;

-- Und so auch nicht
CREATE INDEX idx_Details3 ON dbo.Servers(Details) 
WHERE JSON_VALUE(DatabasesJSON, 'lax.$.Databases[0].name') NOT IS NULL;
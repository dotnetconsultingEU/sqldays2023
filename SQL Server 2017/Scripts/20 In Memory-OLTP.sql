-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschr�nkungen verwendet oder ver�ndert werden.
-- Jedoch wird keine Garantie �bernommen, dass eine Funktionsf�higkeit mit aktuellen und 
-- zuk�nftigen API-Versionen besteht. Der Autor �bernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgef�hrt wird.
-- F�r Anregungen und Fragen stehe ich jedoch gerne zur Verf�gung.

-- Thorsten Kansy, www.dotnetconsulting.eu

CREATE TABLE xtp.Product(
    Id int PRIMARY KEY NONCLUSTERED,
    Name nvarchar(400) NOT NULL,
    Price float,
    Data nvarchar(4000)
        CONSTRAINT [Data must be JSON] CHECK (ISJSON(Data)=1),
    YearMadeIn AS CAST(JSON_VALUE(Data, '$. YearMadeIn') as NVARCHAR(50)) PERSISTED,
    TotalCost AS CAST(JSON_VALUE(Data, '$. TotalCost') as FLOAT)
) WITH (MEMORY_OPTIMIZED=ON);

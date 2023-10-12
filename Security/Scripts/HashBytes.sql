-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschr�nkungen verwendet oder ver�ndert werden.
-- Jedoch wird keine Garantie �bernommen, dass eine Funktionsf�higkeit mit aktuellen und 
-- zuk�nftigen API-Versionen besteht. Der Autor �bernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgef�hrt wird.
-- F�r Anregungen und Fragen stehe ich jedoch gerne zur Verf�gung.

-- Thorsten Kansy, www.dotnetconsulting.eu

DECLARE @HashThis nvarchar(4000)= 'Microsoft SQL Server';

-- Message-Digest 
SELECT DATALENGTH(HASHBYTES('MD2', @HashThis)), HASHBYTES('MD2', @HashThis); -- => 16 Bytes/ 128 Bits
SELECT DATALENGTH(HASHBYTES('MD4', @HashThis)), HASHBYTES('MD4', @HashThis); -- => 16 Bytes/ 128 Bits
SELECT DATALENGTH(HASHBYTES('MD5', @HashThis)), HASHBYTES('MD5', @HashThis); -- => 16 Bytes/ 128 Bits

-- Secure Hash Algorithm
SELECT DATALENGTH(HASHBYTES('SHA', @HashThis)), HASHBYTES('SHA', @HashThis); -- => 20 Bytes/ 160 Bits
SELECT DATALENGTH(HASHBYTES('SHA1', @HashThis)), HASHBYTES('SHA1', @HashThis); -- => 20 Bytes/ 160 Bits

SELECT DATALENGTH(HASHBYTES('SHA2_256', @HashThis)), HASHBYTES('SHA2_256', @HashThis); -- => 20 Bytes/ 160 Bits
SELECT DATALENGTH(HASHBYTES('SHA2_512', @HashThis)), HASHBYTES('SHA2_512', @HashThis); -- => 20 Bytes/ 160 Bits
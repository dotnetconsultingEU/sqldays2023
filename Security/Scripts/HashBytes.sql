-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

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
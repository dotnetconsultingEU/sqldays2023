-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Ver- und entschlüsseln
DECLARE @password VARCHAR(MAX) = N'geheim';
DECLARE @geheim VARCHAR(MAX) = N'Das ist ein Geheimnis ;-)';

DECLARE @cipher VARBINARY(8000) = ENCRYPTBYPASSPHRASE(@password, @geheim);
PRINT @cipher;
PRINT CAST(DECRYPTBYPASSPHRASE(@password, @cipher) AS VARCHAR(MAX));
GO

-- Ver- und entschlüsseln mit Authenticator
DECLARE @password VARCHAR(MAX) = N'geheim';
DECLARE @geheim VARCHAR(MAX) = N'Das ist ein Geheimnis ;-)';

DECLARE @cipher VARBINARY(8000) = ENCRYPTBYPASSPHRASE(@password, @geheim, 1, '4711');
PRINT @cipher
PRINT CAST(DECRYPTBYPASSPHRASE(@password, @cipher, 1, '4711') AS VARCHAR(MAX));
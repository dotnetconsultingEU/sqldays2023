-- Disclaimer
-- Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschr�nkungen verwendet oder ver�ndert werden.
-- Jedoch wird keine Garantie �bernommen, dass eine Funktionsf�higkeit mit aktuellen und 
-- zuk�nftigen API-Versionen besteht. Der Autor �bernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgef�hrt wird.
-- F�r Anregungen und Fragen stehe ich jedoch gerne zur Verf�gung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Ver- und entschl�sseln
DECLARE @password VARCHAR(MAX) = N'geheim';
DECLARE @geheim VARCHAR(MAX) = N'Das ist ein Geheimnis ;-)';

DECLARE @cipher VARBINARY(8000) = ENCRYPTBYPASSPHRASE(@password, @geheim);
PRINT @cipher;
PRINT CAST(DECRYPTBYPASSPHRASE(@password, @cipher) AS VARCHAR(MAX));
GO

-- Ver- und entschl�sseln mit Authenticator
DECLARE @password VARCHAR(MAX) = N'geheim';
DECLARE @geheim VARCHAR(MAX) = N'Das ist ein Geheimnis ;-)';

DECLARE @cipher VARBINARY(8000) = ENCRYPTBYPASSPHRASE(@password, @geheim, 1, '4711');
PRINT @cipher
PRINT CAST(DECRYPTBYPASSPHRASE(@password, @cipher, 1, '4711') AS VARCHAR(MAX));
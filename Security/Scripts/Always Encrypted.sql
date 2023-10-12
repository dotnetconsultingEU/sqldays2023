-- Disclaimer
-- Dieser Quellecode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
-- Auflagen oder Einschränkungen verwendet oder verändert werden.
-- Jedoch wird keine Garantie übernommen, dass eine Funktionsfähigkeit mit aktuellen und 
-- zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
-- Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
-- Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.

-- Thorsten Kansy, www.dotnetconsulting.eu

-- Datenbank (erneut) anlegen und wechseln
:SETVAR dbname dotnetconsulting_AlwaysEncrypted
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

-- Tabelle ohne Verschlüsselung
CREATE TABLE [dbo].[Secrets](
    [ID] INT IDENTITY PRIMARY KEY,
    [User] NVARCHAR(50) NOT NULL,
    [Secret] NVARCHAR(50) NOT NULL,
    [Unwichtig] NVARCHAR(100) NULL 
);

-- Column Master Key anlegen
CREATE COLUMN MASTER KEY [Windows Vault]
WITH
(
	KEY_STORE_PROVIDER_NAME = N'MSSQL_CERTIFICATE_STORE',
	KEY_PATH = N'CurrentUser/My/EF7D40B9BDB1031661A5CE94C9C5E37EF4B174FE'
)
GO

-- Column EntryptionKey anlegen, dabei den Column Master Key verwenden
CREATE COLUMN ENCRYPTION KEY [CEK_WindowsVault]
WITH VALUES
(
	COLUMN_MASTER_KEY = [Windows Vault],
	ALGORITHM = 'RSA_OAEP',
	ENCRYPTED_VALUE = 0x016E008000630075007200720065006E00740075007300650072002F006D0079002F00650066003700640034003000620039006200640062003100300033003100360036003100610035006300650039003400630039006300350065003300370065006600340062003100370034006600650079594FE49EA1467947AFFD1D7E519D404FC6D29796D013028989F44B061448DB162D05C5035138B386D4335D248FBA2FB9A0D4B606D1182549D7FE556A9CBD0F4584EB20AEDD04B75338EF25F3AA5E394A5184BAC6158755690AD9AFC748AE4C4B15E8A0D0758756B03B1E7B39EEC835483630263E085761AC1C451924797B34075A9A8718DC33FE62A32E2CF9B426EFA121697215EB9B543A9C90D9F24471C71A7B382217E236C5DA0E219342F91E943490D213E84C0B151DF4FF05ACE9935325ADD8933C1F61320C93D79CA93BF86E1060E39CF1B3C0B828CE24952D4781C6AFDB5D7A4A9FEA411495BBABB1FA6EA95C19DE6314056F9CD59809E7552EBF27
)
GO

-- Tabelle mit zwei verschlüsselten Spalten anlegen
CREATE TABLE [dbo].[SecretsWindowsKeyVault](
    [ID] INT IDENTITY PRIMARY KEY, 

    [User] NVARCHAR(50) COLLATE Latin1_General_BIN2 
      ENCRYPTED WITH (ENCRYPTION_TYPE = DETERMINISTIC, 
      ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256', 
      COLUMN_ENCRYPTION_KEY = [CEK_WindowsVault]) NOT NULL,

    [Secret] NVARCHAR(50) 
      ENCRYPTED WITH (ENCRYPTION_TYPE = RANDOMIZED, 
      ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256', 
      COLUMN_ENCRYPTION_KEY = [CEK_WindowsVault]) NOT NULL,

    [Unwichtig] NVARCHAR(100) NULL 
);
 GO

-- Und Daten einfügen? Nein
INSERT [dbo].[SecretsWindowsKeyVault] ([User], [Secret]) VALUES ('James Bond', '...jagt Dr. No');

-- So auch nicht
DECLARE @user NVARCHAR(50) = 'James Bond';
DECLARE @secret NVARCHAR(50) = '...jagt Dr. No';
INSERT [dbo].[SecretsWindowsKeyVault] ([User], [Secret]) VALUES (@user, @secret);


-- Connection String für ADO.NET 4.8/ ADO.NET Core
-- Data Source=.; Initial Catalog=dotnetconsulting_AlwaysEncrypted; Integrated Security=true; Column Encryption Setting=enabled;
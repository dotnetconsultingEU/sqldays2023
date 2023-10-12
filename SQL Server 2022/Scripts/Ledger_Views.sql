CREATE VIEW [dbo].[vwUpdatableLedger] AS
SELECT [ID],
       [Value1],
       [Value2],
       [StartTime],
       [EndTime],
       [ledger_start_transaction_id] AS [ledger_transaction_id],
       [ledger_start_sequence_number] AS [ledger_sequence_number],
       1 AS [ledger_operation_type],
       N'INSERT' AS [ledger_operation_type_desc]
FROM [dbo].[UpdatableLedger]
UNION ALL
SELECT [ID],
       [Value1],
       [Value2],
       [StartTime],
       CONVERT(DATETIME2(7), SYSMAXDATETIME(CONVERT(SMALLINT, 7))) AS [EndTime],
       [ledger_start_transaction_id] AS [ledger_transaction_id],
       [ledger_start_sequence_number] AS [ledger_sequence_number],
       1 AS [ledger_operation_type],
       N'INSERT' AS [ledger_operation_type_desc]
FROM [dbo].[UpdatableLedger_History]
UNION ALL
SELECT [ID],
       [Value1],
       [Value2],
       [StartTime],
       [EndTime],
       [ledger_end_transaction_id] AS [ledger_transaction_id],
       [ledger_end_sequence_number] AS [ledger_sequence_number],
       2 AS [ledger_operation_type],
       N'DELETE' AS [ledger_operation_type_desc]
FROM [dbo].[UpdatableLedger_History]



CREATE VIEW [dbo].[vwAppendOnlyLedger] AS
SELECT [ID],
       [Value1],
       [Value2],
       [ledger_start_transaction_id] AS [ledger_transaction_id],
       [ledger_start_sequence_number] AS [ledger_sequence_number],
       1 AS [ledger_operation_type],
       N'INSERT' AS [ledger_operation_type_desc]
FROM [dbo].[AppendOnlyLedger]
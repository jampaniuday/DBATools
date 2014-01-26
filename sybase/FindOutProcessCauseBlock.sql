sp_who
sp_lock

SELECT SPID, InstanceID, KPID, ServerUserID, BatchID, LineNumber, SequenceInLine, SQLText
INTO #temp_psqltext5
FROM master..monProcessSQLText  WHERE SPID= blk-spid

SELECT * FROM #temp_psqltext5

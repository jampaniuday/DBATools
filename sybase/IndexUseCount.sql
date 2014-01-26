
USE db_name
GO

select 
DB = convert(char(20), db_name()),
TableName = convert(char(20),  object_name(i.id, db_id())),
IndexName = convert(char(20),i.name),
IndID = i.indid,
a.UsedCount
from master..monOpenObjectActivity a,
sysindexes i
where a.ObjectID =* i.id
and a.IndexID =* i.indid
--and (a.UsedCount = 0 or a.UsedCount is NULL)  -- uncomment this line will find out the index never used
and i.indid > 0
and object_name(i.id, db_id()) not like "sys%"
order BY a.UsedCount DESC, 2, 4 asc

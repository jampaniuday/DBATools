接着LocksTransaction01.sql另开一个会话，执行以下两个UPDATE

update tx_emp set ename = upper(ename);
update tx_dept set deptno = deptno-10;



执行LocksTransaction01.sql中同样的查询
USERNAME	SID	RBS	SLOT	SEQ	LMODE	REQUEST
SCOTT	146	1	28	764	0	6
SCOTT	146	8	21	792	6	0
SCOTT	142	1	28	764	6	0
						
XIDUSN	XIDSLOT	XIDSQN				
8	21	792				
1	28	764		

对输出的说明
1. 可以看到多了一个Transaction, ID=8,21,792
2. 新的SESSION, SID=146, 在v$lock中有2行
3. 其中一行持有LOMODE=6的锁，是update tx_emp这个查询产生的Lock
4. 另一行REQUEST=6, 表示请求一个排它锁.


查看谁block谁的查询
select
(select username from v$session where sid=a.sid) blocker,
a.sid,
' is blocking ',
(select username from v$session where sid=b.sid) blockee,
b.sid
from v$lock a, v$lock b
where a.block = 1
and b.request > 0
and a.id1 = b.id1
and a.id2 = b.id2;


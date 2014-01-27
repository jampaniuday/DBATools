### v$lock, v$session, v$transaction 视图例子 ####
##################################################


create table tx_dept as select * from scott.dept;

create table tx_emp as select * from scott.emp;

alter table tx_dept add constraint tx_dept_pk primary key(deptno);


alter table tx_emp add constraint tx_emp_pk primary key(empno);

alter table tx_emp add constraint tx_emp_fk_dept foreign key (deptno) references tx_dept(deptno);

create index tx_emp_deptno_idx on tx_emp(deptno);

-- Let’s start a transaction now:
update tx_dept set dname = initcap(dname);

-- Find out Locks
select username,
v$lock.sid,
trunc(id1/power(2,16)) rbs,
bitand(id1,to_number('ffff','xxxx'))+0 slot,
id2 seq,
lmode,
request
from v$lock, v$session
where v$lock.type = 'TX'
and v$lock.sid = v$session.sid
and v$session.username = USER;

OUTPUT
USERNAME	SID	  RBS	  SLOT	SEQ	  LMODE	REQUEST
SCOTT	    142	  1	    28	  764	  6	    0

解释说明
LMODE=6表示排它锁
REQUEST=0表示已经持有这个锁
RBS,SLOT,SEQ 是事务的TransactionID,与下面Transaction视图中的信息匹配

-- select v$transaction table
select XIDUSN, XIDSLOT, XIDSQN from v$transaction;
OUTPUT
XIDUSN	XIDSLOT	XIDSQN
1	      28	    764


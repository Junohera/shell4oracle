> sqlplus 사용시 프롬프트상에서 실행시킬 sql 모음
> sqlplus 접속시 해당 경로로 이동하여 사용
- tutorial
```shell
su - root
chown -R oracle:oinstall /oracle12/admin/shell4oracle

su - oracle

vi ~/.bash_profile
alias 'sss=c;cd /oracle12/admin/shell4oracle/sql; sqlplus / as sysdba'
:wq

sss

SQL> !ls
arch_check.sql  default_undo.sql  log_check.sql  status.sql

SQL> @arch_check

no rows selected

SQL> @default_undo

UNDOTBS1
/oracle12/app/oracle/oradata/db1/undotbs01.dbf
AVAILABLE YES ONLINE


SQL> @log_check

  1 /oracle12/app/oracle/oradata/db1/redo01.log          200   13 INACTIVE NO
  2 /oracle12/app/oracle/oradata/db1/redo02.log          200   14 INACTIVE NO
  3 /oracle12/app/oracle/oradata/db1/redo03.log          200   15 CURRENT  NO

SQL> @status

db1              OPEN


2023-09-01 15:19:18
```
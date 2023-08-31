# offlineBackup

1. 실행시 화면

TODO: physical backup

![image-20230831184535607](./assets/image-20230831184535607.png)

## flow

1. database 연동할 profile 불러오기
2. logging file 초기화
3. config file 읽기
4. config file을 통해 불러온 정보 검사
5. 백업ID 생성
6. 백업 경로 생성
7. controlfile 백업스크립트 백업 준비
8. controlfile 백업스크립트 백업전 status체크
9. controlfile 백업스크립트 백업 실행
10. shutdown immediate
11. TODO: physical backup
12. startup open

---

## log

```sql
======= TRY CONNECTION AT: 2023-08-31 18:49:54 ========
CHECK STATUS BEFORE EXECUTE QUERY
-------------------- INFO ---------------------
    TAG= 12791607154S491831082023
    username= system
    pagesize= 0
    linesize= 2000
-------------------- QUERY --------------------
select instance_name, status from v$instance;
-------------------- RESULT -------------------
db1		 OPEN
-------------------- DONE ---------------------
    TAG= 12791607154S491831082023
operation time: 0
======= SUCCESS AT: 2023-08-31 18:49:54 ===============

======= TRY CONNECTION AT: 2023-08-31 18:49:54 ========
EXECUTE QUERY FOR BACKUP CONTROL FILE GENERATION SCRIPT
-------------------- INFO ---------------------
    TAG= 21648877054S491831082023
    username= system
    pagesize= 0
    linesize= 2000
-------------------- QUERY --------------------
alter database backup controlfile to trace as '/opt/backup4oracle/BACKUP_202308311849/control.sql';
-------------------- RESULT -------------------

-------------------- DONE ---------------------
    TAG= 21648877054S491831082023
operation time: 0
======= SUCCESS AT: 2023-08-31 18:49:54 ===============

======= TRY CONNECTION AT: 2023-08-31 18:49:54 ========
SHUTDOWN IMMEDIATE
-------------------- INFO ---------------------
    TAG= 31279085154S491831082023
    connection=  / as sysdba
    pagesize= 0
    linesize= 2000
-------------------- QUERY --------------------
shutdown immediate;
-------------------- RESULT -------------------
Database closed.
Database dismounted.
ORACLE instance shut down.
-------------------- DONE ---------------------
    TAG= 31279085154S491831082023
operation time: 49
======= SUCCESS AT: 2023-08-31 18:50:43 ===============

======= TRY CONNECTION AT: 2023-08-31 18:50:43 ========
STARTUP OPEN
-------------------- INFO ---------------------
    TAG= 42518575843S501831082023
    connection=  / as sysdba
    pagesize= 0
    linesize= 2000
-------------------- QUERY --------------------
startup open;
-------------------- RESULT -------------------
ORACLE instance started.
Total System Global Area 2046820352 bytes
Fixed Size		    8794552 bytes
Variable Size		 1258294856 bytes
Database Buffers	  771751936 bytes
Redo Buffers		    7979008 bytes
Database mounted.
Database opened.
-------------------- DONE ---------------------
    TAG= 42518575843S501831082023
operation time: 8
======= SUCCESS AT: 2023-08-31 18:50:51 ===============

======= TRY CONNECTION AT: 2023-08-31 18:50:51 ========
CHECK STATUS AFTER STARTUP OPEN
-------------------- INFO ---------------------
    TAG= 17838993251S501831082023
    username= system
    pagesize= 0
    linesize= 2000
-------------------- QUERY --------------------
select instance_name, status from v$instance;
-------------------- RESULT -------------------
db1		 OPEN
-------------------- DONE ---------------------
    TAG= 17838993251S501831082023
operation time: 0
======= SUCCESS AT: 2023-08-31 18:50:51 ===============
```


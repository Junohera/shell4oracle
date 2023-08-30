# Test

```sql
-- mkdir -p /oracle12/app/oracle/oradata/db1/another/
create tablespace test_for_another_path
         datafile '/oracle12/app/oracle/oradata/db1/another/test_for_another_path-01.dbf' size 1m,
                  '/oracle12/app/oracle/oradata/db1/another/test_for_another_path-02.dbf' size 1m,
                  '/oracle12/app/oracle/oradata/db1/another/test_for_another_path-03.dbf' size 1m;
                  
alter tablespace test_for_another_path drop datafile '/oracle12/app/oracle/oradata/db1/another/test_for_another_path-02.dbf';
rm /oracle12/app/oracle/oradata/db1/another/test_for_another_path-03.dbf
touch /oracle12/app/oracle/oradata/db1/another/fake.dbf
touch /oracle12/app/oracle/oradata/db1/fake.dbf
```
```sql
select 'data' as type, file_name, file_id
  from dba_data_files
 union all
select 'temp' as type, file_name, file_id
  from dba_temp_files
 order by type, file_id;
```
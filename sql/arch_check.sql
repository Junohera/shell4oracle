set pagesize 200
set lines 200
col name format a50

select name,
			 SEQUENCE#,
			 FIRST_CHANGE#,
			 NEXT_CHANGE#
  from v$archived_log
 order by first_change#;
set linesize 100
set pagesize 100
col g format 99
col member format a50
col mb format 9999
col seq# format 999
col status format a8
col arc format a3

select a.group# as G
     , a.member
     , b.bytes/1024/1024 mb
     , b.sequence# "seq#"
     , b.status
     , b.archived arc
  from v$logfile a
     , v$log b
 where a.group# = b.group#
 order by 1, 2;
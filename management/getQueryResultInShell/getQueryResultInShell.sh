#!/bin/sh

query="
  select to_char(sysdate + level, 'YYYYMMDD HH24:MI:SS') as yyyymmdd
    from dual
 connect by level <= 10;
"
result=$(sqlplus -S system/oracle <<_eof_
set head off
set feedback off
set pagesize 0
set linesize 1000
$query
_eof_
)

echo "$result"

#!/bin/sh

username=system
password=oracle
pagesize=1
linesize=10
query='
select name
  from v$database;
'
result=$(sqlplus -S ${username}/${password} <<_eof_
set head off
set feedback off
set pagesize ${pagesize}
set linesize ${linesize}
${query}
exit;
_eof_
)
echo $result

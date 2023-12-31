#!/bin/sh

# move management
cd $MANAGER_PATH;

# load profile
. loadProfile/loadProfile.sh system

query="
  select to_char(sysdate + level, 'YYYYMMDD HH24:MI:SS') as yyyymmdd
    from dual
 connect by level <= 10;
"
result=$(sqlplus -S ${db_user_name}/${db_password} <<_eof_
set head off
set feedback off
set pagesize ${db_pagesize}
set linesize ${db_linesize}
$query
_eof_
)
if [ $? -ne 0 ]; 
then
  LOG_ERROR "$result"
else
  LOG_INFO "$result"
fi
#!/bin/bash

clear

DIST_PATH="$0.result"

ALIAS='TEST'
IP='172.16.16.1'
PORT='1521'
SERVER_MODE='DEDICATED'
SERVICE_NAME='TEST'


TEMPLATE='
${ALIAS} = 
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ${IP})(PORT = ${PORT}))
    (CONNECT_DATA =
      (SERVER = ${SERVER_MODE})
      (SERVICE_NAME = ${SERVICE_NAME})
    )
  )
'
echo "$TEMPLATE" |
sed 's/${ALIAS}/'"${ALIAS}"'/g' |
sed 's/${IP}/'"${IP}"'/g' |
sed 's/${PORT}/'"${PORT}"'/g' |
sed 's/${SERVER_MODE}/'"${SERVER_MODE}"'/g' |
sed 's/${SERVICE_NAME}/'"${SERVICE_NAME}"'/g' |
sed '/^$/d' > "$DIST_PATH"

cat -n "$DIST_PATH"

# 참고 쿼리: select name from v$database;

username=scott
password=oracle
pagesize=1
linesize=10
query='
select name
  from v$dtabase;
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
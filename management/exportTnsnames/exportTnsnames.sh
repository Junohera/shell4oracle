#!/bin/sh

clear

cd $MANAGER_PATH;
echo $(pwd)

IP=$(sh "getInternetProtocolAddress/getInternetProtocolAddress.sh")
PORT=1521
SERVER_MODE=DEDICATED
SERVICE_NAME=$(sh "getServiceName/getServiceName.sh")
ALIAS=$SERVICE_NAME

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
APPLIED=$(
  echo "$TEMPLATE" |
    sed 's/${ALIAS}/'"${ALIAS}"'/g' |
    sed 's/${IP}/'"${IP}"'/g' |
    sed 's/${PORT}/'"${PORT}"'/g' |
    sed 's/${SERVER_MODE}/'"${SERVER_MODE}"'/g' |
    sed 's/${SERVICE_NAME}/'"${SERVICE_NAME}"'/g' |
    sed '/^$/d'
)
# ECHO_NORMALIZE "$APPLIED" > .temp
LOG_DEBUG "$APPLIED"
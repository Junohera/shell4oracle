#!/bin/bash

clear

FULL_PATH=$0
FILE=$(echo $FULL_PATH | awk -F"/" '{print $NF}')
NAME=$(echo $FILE | awk -F"." '{print $1}')
CURRENT_PATH=$(echo $FULL_PATH | awk -F"$FILE" '{print $1}' )
PARENT_PATH=$(echo $FULL_PATH | awk -F"$NAME" '{print $1}')

IP=$(sh "${PARENT_PATH}getInternetProtocolAddress/getInternetProtocolAddress.sh")
PORT=1521
SERVER_MODE=DEDICATED
SERVICE_NAME=$(sh "${PARENT_PATH}getServiceName/getServiceName.sh")
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
echo "$APPLIED"
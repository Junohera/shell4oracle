#!/bin/sh

# TODO:
# 1. shutdown이든 startup이든 진행되게
# 2. instance_name은 환경변수 $ORACLE_SID로부터
# 3. 디렉토리에 online/offline 접두사 추가
clear;

prefix="$(echo $0 | awk -F"/" '{print $1}')"

START_SECOND=$(date +%s)

BACKUP_DIRECTORY=""
ORACLE_DATA=""
ORACLE_DBS=$(echo ${ORACLE_HOME}/dbs)

# SET TRACE
TRACE_CONTEXT=""
TRACE_AT_START=""
TRACE_AT_END=""
TRACE_START () { 
  TRACE_CONTEXT="$1"

  TRACE_NOW=$(date +%F" "%T" "%N)
  TRACE_AT_START_SECOND=$(date +%s)

  LOG_TRACE "::: ${TRACE_NOW} ${TRACE_CONTEXT} START :::";
}
TRACE_END () {
  TRACE_NOW=$(date +%F" "%T" "%N)
  TRACE_AT_END_SECOND=$(date +%s)
  TRACE_OPERATION_TIME_SECOND=$(($TRACE_AT_END_SECOND - $TRACE_AT_START_SECOND))

  if [ $TRACE_OPERATION_TIME_SECOND -gt 5 ];
  then
    LOG_WARN "::: ${TRACE_NOW} ${TRACE_CONTEXT} COMPLETE (${TRACE_OPERATION_TIME_SECOND}s):::";
  else
    LOG_TRACE "::: ${TRACE_NOW} ${TRACE_CONTEXT} COMPLETE (${TRACE_OPERATION_TIME_SECOND}s):::";
  fi
}

TRACE_START "LOAD PROFILE START"
. loadProfile/loadProfile.sh system
TRACE_END

TRACE_START "RECORD DISK INFORMATION INITIALIZING"
temp_directory="${MANAGER_PATH}/${prefix}/.temp"
temp_disk_info_before="${temp_directory}/disk_info_before.txt"
temp_disk_info_after="${temp_directory}/disk_info_after.txt"
temp_disk_info_diff="${temp_directory}/disk_info_diff.txt"
if [ ! -d $temp_directory ]; then mkdir -p $temp_directory; fi
TRACE_END

TRACE_START "RECORD DISK INFORMATION BEFORE"
echo "$(df | awk '{print $6" : "$5}')" > $temp_disk_info_before
TRACE_END

TRACE_START "LOGGING FILE INITIALIZING"
logging_directory="${MANAGER_PATH}/${prefix}/.log"
logging_file="${logging_directory}/$(echo $(date +%Y%m%d%H%M)).txt"
if [ ! -d $logging_directory ]; then mkdir -p $logging_directory; fi
if [ ! -f $logging_file ]; then touch $logging_file; fi
TRACE_END

TRACE_START "READ CONFIG FILE"
config="${MANAGER_PATH}/${prefix}/.config"
BACKUP_DIRECTORY=$(cat $config | sed '/^#/d' | grep 'BACKUP_DIRECTORY=' | awk -F= '{print $NF}');
TRACE_END

TRACE_START "VALIDATION DIRECTORY BY CONFIG FILE"
if [ -z $BACKUP_DIRECTORY ];  then LOG_ERROR "BACKUP_DIRECTORY is not defined. (.config)"; exit 1; fi
TRACE_END

TRACE_START "CHECK BACKUP_DIRECTORY"
if ! [ -d $BACKUP_DIRECTORY ]; then
  LOG_ERROR "$BACKUP_DIRECTORY is not directory."
  echo -n $(LOG_INFO "If you want that directory to be created, type Enter.(mkdir -p ${BACKUP_DIRECTORY})")
  read is_create_backup_directory

  if ! [ -z $is_create_backup_directory ]; then
    LOG_INFO "The End."
    exit 1
  fi

  mkdir -p ${BACKUP_DIRECTORY}
  if [ $? -ne 0 ]; then
    LOG_ERROR "su - root"
    LOG_ERROR "mkdir -p ${BACKUP_DIRECTORY}"
    LOG_ERROR "chown -R oracle:oinstall ${BACKUP_DIRECTORY}"
    exit 1
  fi
fi
TRACE_END

TRACE_START "GET INSTANCE_NAME FOR FIND ORACLE_DATA_DIRECTORY_PATH"
query="
select instance_name
  from v\$instance;"
result="$(
  sh "${MANAGER_PATH}/executeQueryWithLog/executeQueryWithLog.sh"\
  "$query" "$TRACE_CONTEXT" "$logging_file"
)"
if [ $? -ne 0 ]; then LOG_ERROR "$result"; LOG_ERROR "MAYBE SHUTDOWN"; exit 255; fi
LOG_INFO "INSTANCE_NAME: ${result}"
INSTANCE_NAME=$result
TRACE_END

TRACE_START "GET ORACLE_DATA_DIRECTORY_PATH BY INSTANCE_NAME"

for maybe in $(find "${ORACLE_BASE}/oradata" -mindepth 1 -maxdepth 1 -type d); do
  last=$(echo "$maybe" | awk -F/ '{print $NF}')
  if [ "${last}" = "${INSTANCE_NAME}" ]; then
    ORACLE_DATA=$maybe
    break
  fi
done

if [ -z $ORACLE_DATA ]; then
  LOG_INFO "ORACLE_DATA is not exists"
fi
LOG_INFO "ORACLE_DATA: ${ORACLE_DATA}"
TRACE_END

TRACE_START "CHECK ORACLE_DATA, ORACLE_DBS"
ls $ORACLE_DATA | grep ".dbf" > /dev/null
IS_EXIST_DBF=$(echo $?)
ls $ORACLE_DATA | grep ".ctl" > /dev/null
IS_EXIST_CTL=$(echo $?)
ls $ORACLE_DATA | grep ".log" > /dev/null
IS_EXIST_LOG=$(echo $?)
ls $ORACLE_DBS | grep ".ora" > /dev/null
IS_EXIST_ORA=$(echo $?)

if [ $IS_EXIST_DBF -ne 0 ]; then LOG_ERROR "NOT EXISTS ($ORACLE_DATA/*.dbf)"; exit 127; fi
if [ $IS_EXIST_CTL -ne 0 ]; then LOG_ERROR "NOT EXISTS ($ORACLE_DATA/*.ctl)"; exit 127; fi
if [ $IS_EXIST_LOG -ne 0 ]; then LOG_ERROR "NOT EXISTS ($ORACLE_DATA/*.log)"; exit 127; fi
if [ $IS_EXIST_ORA -ne 0 ]; then LOG_ERROR "NOT EXISTS ($ORACLE_DBS/*.ora)"; exit 127; fi

LOG_INFO "BACKUP_DIRECTORY: ${BACKUP_DIRECTORY}"
LOG_INFO "ORACLE_DATA: ${ORACLE_DATA}"
LOG_INFO "ORACLE_DBS: ${ORACLE_DBS}"
TRACE_END

TRACE_START "CREATE BACKUP_ID"
BACKUP_ID="BACKUP_$(date +%Y%m%d%H%M)"
LOG_INFO "BACKUP_ID: ${BACKUP_ID}"
TRACE_END

TRACE_START "CREATE BACKUP_TARGET_DIRECTORY"
BACKUP_TARGET_DIRECTORY="${BACKUP_DIRECTORY}/${BACKUP_ID}"
mkdir -p $BACKUP_TARGET_DIRECTORY
LOG_INFO "BACKUP_TARGET_DIRECTORY: ${BACKUP_TARGET_DIRECTORY}"
TRACE_END

TRACE_START "READY BACKUP CONTROL FILE PATH"
BACKUP_CONTROLFILE_PATH="$BACKUP_TARGET_DIRECTORY/control.sql"
BACKUP_CONTROLFILE_PATH_FOR_QUERY="'"$BACKUP_TARGET_DIRECTORY/control.sql"'"
if [ -f $BACKUP_CONTROLFILE_PATH ]
then
  rm $BACKUP_CONTROLFILE_PATH
fi
TRACE_END

TRACE_START "CHECK STATUS BEFORE EXECUTE QUERY"
query="select instance_name, status from v\$instance;"
result="$(
  sh "${MANAGER_PATH}/executeQueryWithLog/executeQueryWithLog.sh"\
  "$query" "$TRACE_CONTEXT" "$logging_file"
)"
if [ $? -ne 0 ]; then LOG_ERROR "$result"; exit 255; fi
TRACE_END

TRACE_START "EXECUTE QUERY FOR BACKUP CONTROL FILE GENERATION SCRIPT"
query="
alter database backup controlfile
to trace as $BACKUP_CONTROLFILE_PATH_FOR_QUERY;
"
result="$(
  sh "${MANAGER_PATH}/executeQueryWithLog/executeQueryWithLog.sh"\
  "$query" "$TRACE_CONTEXT" "$logging_file"
)"
if [ $? -ne 0 ]; then
  LOG_ERROR "$result"
  LOG_INFO "when Permission denied (chown -R oracle:oinstall $BACKUP_DIRECTORY)"
  exit 255
fi
LOG_INFO "BACKUP_CONTROLFILE_PATH: $(ls $BACKUP_CONTROLFILE_PATH)"
TRACE_END

TRACE_START "CHECK DIRECTORIES BEFORE PHYSICAL BACKUP"
LOG_INFO "ORACLE_DATA: $ORACLE_DATA"
LOG_INFO "ORACLE_DBS: $ORACLE_DBS"
LOG_INFO "BACKUP_TARGET_DIRECTORY: $BACKUP_TARGET_DIRECTORY"
TRACE_END

TRACE_START "SHUTDOWN IMMEDIATE"
query="shutdown immediate;"
result="$(
  sh "${MANAGER_PATH}/executeQueryWithLog/executeQueryWithLog.sh"\
  "$query" "$TRACE_CONTEXT" "$logging_file" "as sysdba"
)"
LOG_INFO "$result"
TRACE_END

TRACE_START "EXECUTE PHYSICAL BACKUP"
cp -r $(echo "$ORACLE_DATA/*") $BACKUP_TARGET_DIRECTORY
cp -r $(echo "$ORACLE_DBS/*") $BACKUP_TARGET_DIRECTORY
TRACE_END

TRACE_START "STARTUP OPEN"
query="startup open;"
result="$(
  sh "${MANAGER_PATH}/executeQueryWithLog/executeQueryWithLog.sh"\
  "$query" "$TRACE_CONTEXT" "$logging_file" "as sysdba"
)"
if [ $? -ne 0 ]; then LOG_ERROR "$result"; exit 255; fi
LOG_INFO "$result"
TRACE_END

TRACE_START "CHECK STATUS AFTER STARTUP OPEN"
query="select instance_name, status from v\$instance;"
result="$(
  sh "${MANAGER_PATH}/executeQueryWithLog/executeQueryWithLog.sh"\
  "$query" "$TRACE_CONTEXT" "$logging_file"
)"
if [ $? -ne 0 ]; then LOG_ERROR "$result"; exit 255; fi
LOG_INFO "$result"
TRACE_END

TRACE_START "RECORD DISK INFORMATION AFTER"
echo "$(df | awk '{print $6" : "$5}')" > $temp_disk_info_after
TRACE_END

TRACE_START "DIFF DISK INFORMATION"
diff -y $temp_disk_info_before $temp_disk_info_after > $temp_disk_info_diff
TRACE_END

TRACE_START "REPORT BACKUP_DIRECTORY SIZE"
BACKUP_DIRECTORY_SIZE=$(du -s $BACKUP_DIRECTORY | awk '{print $1}')
BACKUP_DIRECTORY_SIZE_AS_GIGA=$(echo "scale=2; $BACKUP_DIRECTORY_SIZE / 1024 / 1024" | bc)
echo $(
  LOG_INFO "BACKUP_DIRECTORY: ${BACKUP_DIRECTORY}";
  ECHO_GREEN "${BACKUP_DIRECTORY_SIZE_AS_GIGA}GB";
)

BACKUP_TARGET_DIRECTORY_SIZE=$(du -s $BACKUP_TARGET_DIRECTORY | awk '{print $1}')
BACKUP_TARGET_DIRECTORY_SIZE_AS_GIGA=$(echo "scale=2; $BACKUP_TARGET_DIRECTORY_SIZE / 1024 / 1024" | bc)
echo $(
  LOG_INFO "BACKUP_TARGET_DIRECTORY: ${BACKUP_TARGET_DIRECTORY}";
  ECHO_GREEN "${BACKUP_TARGET_DIRECTORY_SIZE_AS_GIGA}GB";
)

TRACE_END

TRACE_START "REPORT DIFF DISK INFORMATION"
i=1
while IFS= read -r line; do
  echo $line | grep '|' > /dev/null
  if [ $? -gt 0 ]; then
    continue
  fi

  directory=$(echo $line | awk -F"|" '{print $1}' | awk -F":" '{print $1}' | awk '{print $1}')
  before=$(echo $line | awk -F"|" '{print $1}' | awk -F":" '{print $2}' | awk '{print $1}')
  after=$(echo $line | awk -F"|" '{print $2}' | awk -F":" '{print $2}' | awk '{print $1}')
  echo $(
    LOG_INFO "DIFF DISK INFORMATION - $i: ";
    ECHO_MAGENTA "${directory}";
    ECHO_BLUE "${before}";
    LOG_TRACE "->";
    ECHO_RED "${after}";
  )
  i=$(expr $i + 1)
done < $temp_disk_info_diff
TRACE_END

TRACE_START "CHECK PHYSICAL BACKUP"
LOG_INFO "$(echo "$(ls -al $BACKUP_TARGET_DIRECTORY)")"
TRACE_END

TRACE_START "COMPLETE"
END_SECOND=$(date +%s)
OPERATION_TIME_SECOND=$((END_SECOND - START_SECOND))

LOG_INFO "BACKUP_TARGET_DIRECTORY: ${BACKUP_TARGET_DIRECTORY} (TOTAL: ${OPERATION_TIME_SECOND}s)"
TRACE_END
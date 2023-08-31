#!/bin/sh

# load profile
. loadProfile/loadProfile.sh system

cd getDiffDataFiles
prefix="$(echo $0 | awk -F"/" '{print $1}')"
logging_directory="${MANAGER_PATH}/${prefix}/.log"
logging_file="${logging_directory}/$(echo $(date +%Y%m%d%H)).txt"
if [ ! -d logging_directory ]; then mkdir -p $logging_directory; fi
if [ ! -f logging_file ]; then touch $logging_file; fi

# create temp 4 shell
createTemp4Shell() {
  if [ ! -d .temp ]; then mkdir .temp; fi
  directories=".temp/directories"
  physicals=".temp/physicals"
  logicals=".temp/logicals"
  delete_target=".temp/delete_target"
  missing_target=".temp/missing_target"
}
# clear temp 4 shell
clearTemp4Shell() {
  if [ -f $directories ]; then rm $directories; fi
  if [ -f $physicals ]; then rm $physicals; fi
  if [ -f $logicals ]; then rm $logicals; fi
  if [ -f $delete_target ]; then rm $delete_target; fi
  if [ -f $missing_target ]; then rm $missing_target; fi
  if [ -d .temp ]; then rm -r .temp; fi
}

# load distinct directories by query
loadDirectoriesByQuery() {
  query="
  select distinct substr(file_name, 1, instr(file_name, '/', -1) - 1) as datafile_directory
    from (select 'data' as type, file_name, file_id
            from dba_data_files
           union all
          select 'temp' as type, file_name, file_id
            from dba_temp_files
           order by type, file_id);
  "
  result=$(sh "${MANAGER_PATH}/executeQueryWithLog/executeQueryWithLog.sh" "$query" "GET_UNIQUE_DIRECTORIES" "$logging_file")
  if [ $? -ne 0 ]; then
    LOG_ERROR "$result"
    exit 255
  fi
  
  echo "$result" > $directories
}
# load physical datafiles
loadPhysicalDatafiles() {
  > $physicals
  while IFS= read -r directory;
  do
    find $directory -maxdepth 1 -mindepth 1 -type f -name "*.dbf" >> $physicals
  done < $directories
}
# load logical datafiles
loadLogicalDatafiles() {
	> $logicals
  query="
  select file_name
    from (select 'data' as type, file_name, file_id
            from dba_data_files
           union all
          select 'temp' as type, file_name, file_id
            from dba_temp_files
           order by type, file_id);
  "
  result=$(sh "${MANAGER_PATH}/executeQueryWithLog/executeQueryWithLog.sh" "$query" 'GET_UNIQUE_DIRECTORIES' "$logging_file")
  
  echo "$result" > $logicals
}
# get missing target: logical minus physical
getMissingTargets() {
  > "${missing_target}"

  echo "select path from (select null as path from dual" >> "${missing_target}"
  while IFS= read -r line;
  do
		with_single_quotation="'$line'"
    echo " union all select ${with_single_quotation} from dual" >> "${missing_target}"
  done < "$logicals"
  echo ") where path is not null"  >> "${missing_target}"

  echo " minus" >> "${missing_target}"

  echo "select path from (select null as path from dual" >> "${missing_target}"
  while IFS= read -r line;
  do
		with_single_quotation="'$line'"
		echo " union all select ${with_single_quotation} from dual" >> "${missing_target}"
  done < "$physicals"
  echo ") where path is not null"  >> "${missing_target}"

  echo ";" >> "${missing_target}"

  result=$(sh "${MANAGER_PATH}/executeQueryWithLog/executeQueryWithLog.sh" "$(cat "${missing_target}")" "GET_MISSING_TARGETS(LOGICAL-PHYSICAL)" "$logging_file")
  echo "$result"
}
# get delete target: physical minus logical
getDeleteTargets() {
  > "${delete_target}"

  echo "select path from (select null as path from dual" >> "${delete_target}"
  while IFS= read -r line;
  do
		with_single_quotation="'$line'"
		echo " union all select ${with_single_quotation} from dual" >> "${delete_target}"
  done < "$physicals"
  echo ") where path is not null"  >> "${delete_target}"

  echo " minus" >> "${delete_target}"

  echo "select path from (select null as path from dual" >> "${delete_target}"
  while IFS= read -r line;
  do
		with_single_quotation="'$line'"
    echo " union all select ${with_single_quotation} from dual" >> "${delete_target}"
  done < "$logicals"
  echo ") where path is not null"  >> "${delete_target}"

  echo ";" >> "${delete_target}"

  result=$(sh "${MANAGER_PATH}/executeQueryWithLog/executeQueryWithLog.sh" "$(cat "${delete_target}")" "GET_DELETE_TARGETS(PHYSICAL-LOGICAL)" "$logging_file")
  echo "$result"
}

createTemp4Shell

loadDirectoriesByQuery
loadPhysicalDatafiles
loadLogicalDatafiles
LOG_INFO "DELETE DATAFILES"
LOG_WARN "$(getDeleteTargets)"
LOG_INFO "MISSING DATAFILES"
LOG_FATAL "$(getMissingTargets)"

# clearTemp4Shell # If you want to see a history of our internal procedures, comment and check the .temp directory
[toc]

> 오라클을 운영하면서 필요한 쉘파일

# Project Structure
__management__: 서버 관점에서의 오라클 운영과 관련된 쉘파일

__.etc__: 클라이언트 관점에서의 기타 쉘파일

---

# Project Explain
## Management
### why 
** ❓ 실제 운영시 필요한 기능을 자동화하기 위함 **
** ❓ 단일책임원칙을 최대한 유지해가며 복잡하고 어려운 기능을 단순하고 쉬운 기능으로 분리하여 어려운 문제도 단순한 문제로 만들어가면서 해결하기  위함

쿼리와 shell을  직접 구현하고,게 하기위하여 하나의 파일안에서 작성 가능한 수준의 여러 파일들을 

### how to use
```shell
# step 1. execute Manager.sh
sh Manager.sh

1  exportTnsnames
2  getDiffDataFiles
3  getInternetProtocolAddress
4  getQueryResultInShell
5  getServiceName
6  sample
Enter number:
# step 2. input number
1

# step 3. done
DB1 = 
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 172.16.229.132)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = DB1)
    )
  )
[oracle@oel7 admin]$ 
```
### TIP 🎁
```shell
# 현재 실행중인 쉘파일 절대경로
CURRENT=$(dirname $(realpath $0))
echo "${CURRENT}"

# db connection 정보 가져오기
. loadProfile/loadProfile.sh scott
. loadProfile/loadProfile.sh system
. loadProfile/loadProfile.sh ${WHO}

# 쿼리 실행 및 로깅
tail -f executeQueryWithLog.sh.log

result=$(sh executeQueryWithLog.sh 'select 1 from dual;')
if [ $? -eq 0 ]; then echo "${result}"; else echo_red "${result}"; fi
result=$(sh executeQueryWithLog.sh 'select sysdate from dual;' '현재시간 조회')
if [ $? -eq 0 ]; then echo "${result}"; else echo_red "${result}"; fi
result=$(sh executeQueryWithLog.sh 'select * from dba_tablespaces;' getTablespaces)
if [ $? -eq 0 ]; then echo "${result}"; else echo_red "${result}"; fi
```
### services
1. TODO:_executeQueryWithLog: 입력받은 쿼리를 수행하고, 결과반환 및 로깅
1. +exportTnsnames: 클라이언트에서 접근하기위한 tnsnames.ora 파일에 추가해야할 내용 반환
1. TODO:+getDiffDataFiles: 모든 datafile과 모든 tempfile들을 논리집합, 물리집합으로 구분하여 누락된 데이터파일과 제거해야할 데이터파일을 색출
1. TODO:+getGapAnalysis: A B 간의 갭 조회
1. +getInternetProtocolAddress: ip 반환
1. +getQueryResultInShell: 샘플 쿼리 결과 조회 shell
1. +getServicename: Service ID 조회
1. _loadProfile: db profile 설정

### how to develop
```shell
# step 1. create directory, file
cd "${PROJECT_ROOT}/management"
mkdir new_service
vi new_service.sh

#!/bin/sh
echo "hello world"
:wq

# step 2. register services
echo "new_service" | tee -a .services

# step 3. exeucute service
sh Manager.sh 'new_service'
or
sh Manager.sh
```

## .etc
```shell
# step 1. open git bash(Window)
# step 2. direct execute ${service}.sh
sh Manager.sh
```
**findTnsnamesWindow**: client에서 tnsnames.ora 파일 중 우선순위 가장 높은 파일 검색

**~~getInternetProtocolAddress(window)~~**: ipconfig 결과 가공
---
# TODO
1. log위치 입력받아 저장
2. 
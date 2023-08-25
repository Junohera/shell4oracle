[toc]

> 오라클을 운영하면서 필요한 쉘파일

# Project Structure
__management__: 서버 관점에서의 오라클 운영과 관련된 쉘파일

__.etc__: 클라이언트 관점에서의 기타 쉘파일

---

# Project Explain
## Management
### 목적
- **실제 운영시 필요한 기능을 자동화하기 위함**
- **복잡한 기능을 단순한 기능으로 분리하기 위함**
- **기능 작업시 기존의 플로우를 참고 및 활용하여 쉘 프로그래밍에 대한 두려움 최소화**
- **동일한 업무, 동일한 코드를 최소화하기 위함**
- **shell과 sql간의 괴리감을 최소화하여 어색하지 않은 프로그래밍을 하기 위함**
- **코드관리를 통해 얕게는 코드의 품질부터 깊게는 프로그래밍의 품질 향상을 증대하기 위함**
- **예상하지 못한 문제들을 정확하게 해결할 수 있는 경험치를 얻기 위함**
- **DBA로서 보다 정확한 판단을 할 수 있는 여유를 극대화하기 위함**

### 사용법
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
2. offlinebackup restore를 동적으로 경로를 받아와 구현
3. onlinebackup restore를 동적으로 경로를 받아와 구현
4. 용량 최적화를 위해 백업폴더경로를 입력받아 특정 날짜지난 폴더 정리
5. 크론탭 관리 폴더 추가

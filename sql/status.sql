set head off
select instance_name,
		   status
  from v$instance;
select to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS')
  from dual;
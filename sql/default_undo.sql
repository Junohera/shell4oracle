select tablespace_name,
       file_name,
       status,
       autoextensible,
       online_status  
  from dba_data_files
 where tablespace_name = (select value
                            from v$parameter
                           where name = 'undo_tablespace');
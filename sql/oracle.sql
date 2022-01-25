-- Start DB
  su oracle
  lsnrctl start
  echo startup | ${ORACLE_HOME}/bin/sqlplus / as sysdba
-- Initialize DB:
  cat schema.sql | ${ORACLE_HOME}/bin/sqlplus / as sysdba

${ORACLE_HOME}/bin/sqlplus / as sysdba -- Connect from the command line

-- NAVIGATION --
  SELECT table_name, owner FROM user_tables;

-- FORMAT TABLE VIEW --
  SET linesize 310;
  SET wrap off;

  -- specific column width:
  column NAME format a25;

-- Active sessions:
  select
    sid,
    serial#,
    osuser,
    machine,
    program,
    module
  from v$session

  select
    machine
  from v$session

-- Locked sessions:
  column sid format a5;
  column serial format a5;
  column oracle_username format a10;
  column os_user_name format a10;
  column object_name format a20;
  column locked_mode format a3;

  select
    sess.sid,
    sess.serial#,
    lo.oracle_username,
    lo.os_user_name,
    ao.object_name,
    lo.locked_mode
  from
    v$locked_object lo,
    dba_objects     ao,
    v$session       sess
  where
    ao.object_id = lo.object_id
  and
    lo.session_id = sess.sid;

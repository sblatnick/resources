-- Start DB
  su oracle
  lsnrctl start
  echo startup | ${ORACLE_HOME}/bin/sqlplus / as sysdba
-- Initialize DB:
  cat schema.sql | ${ORACLE_HOME}/bin/sqlplus / as sysdba

${ORACLE_HOME}/bin/sqlplus / as sysdba -- Connect from the command line

-- NAVIGATION --
  SELECT table_name FROM user_tables;

-- DROP ALL TABLES -- (source: https://stackoverflow.com/questions/1690404/how-to-drop-all-user-tables)
  SELECT 'drop table '||table_name||' cascade constraints;' FROM user_tables;
  drop sequence id_sequence;

-- FORMAT TABLE VIEW --
  SET linesize 310;
  SET wrap off;

  -- specific column width:
  column NAME format a25;

  -- revert formatting:
  column NAME CLEAR;

-- Sequences
  select my_sequence.currval from DUAL;

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

-- Locked sessions: (source: http://www.dba-oracle.com/oracle_tips_locked_sessions.htm)
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

  -- Kill locked sessions (untested):
  spool run_nuke.sql

  select
    'alter system kill session '''||
    sess.sid||','||sess.serial#||''';'
  from
    v$locked_object lo,
    dba_objects     ao,
    v$session       sess
  where
    ao.object_id = lo.object_id
    and lo.session_id = sess.sid;

--LIMIT in Oracle:
  FETCH FIRST 1 ROWS ONLY

-- Start DB
  su oracle
  lsnrctl start
  echo startup | ${ORACLE_HOME}/bin/sqlplus / as sysdba
-- Initialize DB:
  cat schema.sql | ${ORACLE_HOME}/bin/sqlplus / as sysdba

${ORACLE_HOME}/bin/sqlplus / as sysdba -- Connect from the command line

-- NAVIGATION --
  SELECT table_name, owner FROM user_tables;


-- Start DB
  java -cp h2-*.jar org.h2.tools.Server -baseDir /tmp/db -tcp -tcpPort 9092
-- Connect
  java \
    -cp h2-*.jar \
    org.h2.tools.Shell \
    -url jdbc:h2:tcp://localhost/tmp/db;MODE=Oracle;AUTO_RECONNECT=TRUE;AUTO_SERVER=TRUE \
    -user 'user' \
    -password 'pass'
-- Print next in sequence
  VALUES NEXT VALUE FOR my_sequence;
  -- Oracle mode:
  select public.my_sequence.currval from DUAL;
-- Set mode
  SET MODE Oracle;
-- Navigate
  SHOW TABLES;


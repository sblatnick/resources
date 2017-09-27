
-- NAVIGATION --
  -- Connect to DB:
  CONNECT db;
  -- Exit:
  exit

  -- Find tables/databases:
  SHOW DATABASES;

  CONNECT db;
  SHOW TABLES; -- only after connecting to the database

  -- Describe a table's columns:
  DESC db.tbl;
  -- Show create query:
  SHOW CREATE TABLE db.tbl;

-- SELECTS --
  SELECT col FROM db.tbl;


-- WRITES --
  INSERT INTO db.tbl (col1, col2) VALUES (1, 2);
  INSERT INTO db.tbl1 SELECT * from db.tbl2;
  UPDATE db.tbl SET col1 = 1 WHERE col2 = 2;
  UPDATE db.tbl1 a SET a.col1 = (SELECT b.col1 FROM db.tbl2 b WHERE b.UUID = a.CUSTOMER_ID);

  INSERT INTO tbl (id, name, age) VALUES(1, "A", 19) ON DUPLICATE KEY UPDATE name="A", age=19;
  REPLACE INTO tbl (id, name, age) VALUES(1, "A", 19);

-- MODIFICATIONS --

  -- Redefine column and add not null:
  ALTER TABLE db.tbl MODIFY col INT(11) NOT NULL;
  -- Change column order:
  ALTER TABLE db.tbl CHANGE COLUMN col col2 INT(11) FIRST;
  -- Delete column:
  ALTER TABLE db.tbl DROP col;
  -- Add column:
  ALTER TABLE db.tbl ADD COLUMN col INT(11) AFTER col2;

-- CREATE TABLE --
  CREATE TABLE db.tbl (
    `col1` INT(11) NOT NULL,
    PRIMARY KEY  (`col1`)
  );


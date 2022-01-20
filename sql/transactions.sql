

BEGIN;
-- Prevent other clients from modifying this row until committed:
SELECT * FROM kv WHERE k = 1 FOR UPDATE;

-- In another terminal:
SELECT * FROM kv WHERE k = 1 FOR UPDATE;
-- waits for the lock to be released

-- Back in the first terminal:
UPDATE kv SET v = v + 5 WHERE k = 1;
COMMIT;


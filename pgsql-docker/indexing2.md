# Indexing 

StudentID :

StudentName: 

```sql
-- account table
CREATE TABLE account(
    account_id serial PRIMARY KEY,
    name text NOT NULL,
    dob date
);
```

```sql
-- thread table
CREATE TABLE thread(
    thread_id serial PRIMARY KEY,
    account_id integer NOT NULL REFERENCES account(account_id),
    title text NOT NULL
);
```

```sql
-- post table
CREATE TABLE post(
    post_id serial PRIMARY KEY,
    thread_id integer NOT NULL REFERENCES thread(thread_id),
    account_id integer NOT NULL REFERENCES account(account_id),
    created timestamp with time zone NOT NULL DEFAULT now(),
    visible boolean NOT NULL DEFAULT TRUE,
    comment text NOT NULL
);
```


```sql
-- word table create with word in linux file
CREATE TABLE words (word TEXT) ;
\copy words (word) FROM '/data/words';
```

```sql
-- create account data
INSERT INTO account (name, dob)
SELECT
    substring('AEIOU', (random()*4)::int + 1, 1) ||
    substring('ctdrdwftmkndnfnjnknsntnyprpsrdrgrkrmrnzslstwl', (random()*22*2 + 1)::int, 2) ||
    substring('aeiou', (random()*4 + 1)::int, 1) || 
    substring('ctdrdwftmkndnfnjnknsntnyprpsrdrgrkrmrnzslstwl', (random()*22*2 + 1)::int, 2) ||
    substring('aeiou', (random()*4 + 1):: int, 1),
    Now() + ('1 days':: interval * random() * 365)
FROM generate_series (1, 100)
;
```

```sql
-- create thread data 
INSERT INTO thread (account_id, title)
WITH random_titles AS (
    -- 1. สร้างชื่อ Title สุ่มเตรียมไว้ 1,000 ชุด (หรือเท่ากับจำนวนที่ต้องการ insert)
    -- วิธีนี้จะทำการสุ่มคำเพียงครั้งเดียวต่อหนึ่ง title
    SELECT 
        row_number() OVER () as id,
        initcap(sentence) as title
    FROM (
        SELECT (SELECT string_agg(word, ' ') FROM (SELECT word FROM words ORDER BY random() LIMIT 5) AS w) as sentence
        FROM generate_series(1, 1000)
    ) s
)
SELECT
    (RANDOM() * 99 + 1)::int,
    rt.title
FROM generate_series(1, 1000) AS s(n)
JOIN random_titles rt ON rt.id = s.n
;
```

```sql
-- create post data
INSERT INTO post (thread_id, account_id, created, visible, comment)
WITH random_comments AS (
    SELECT row_number() OVER () as id, sentence
    FROM (
        SELECT (SELECT string_agg(word, ' ') FROM (SELECT word FROM words ORDER BY random() LIMIT 20) AS w) as sentence
        FROM generate_series(1, 1000)
    ) s
),
source_data AS (
    -- สร้างโครงข้อมูล 100,000 แถว พร้อมสุ่ม ID สำหรับเลือก comment
    SELECT 
        (RANDOM() * 999 + 1)::int AS t_id,
        (RANDOM() * 99 + 1)::int AS a_id,
        NOW() - ('1 days'::interval * random() * 1000) AS c_date,
        (RANDOM() > 0.1) AS vis,
        floor(random() * 1000 + 1)::int AS comment_id
    FROM generate_series(1, 100000)
)
SELECT 
    sd.t_id, 
    sd.a_id, 
    sd.c_date, 
    sd.vis, 
    rc.sentence
FROM source_data sd
JOIN random_comments rc ON sd.comment_id = rc.id -- ใช้ JOIN เพื่อการันตีว่าข้อมูลต้องมีค่า
;
```


# WITHOUT INDEXING

```sql
-- table and index data
SELECT
    t.table_name,
    pg_size_pretty(pg_total_relation_size('public.' || t.table_name)) AS total_size,
    pg_size_pretty(pg_indexes_size('public.' || t.table_name)) AS index_size,
    pg_size_pretty(pg_relation_size('public.' || t.table_name)) AS table_size,
    COALESCE(pg_class.reltuples::bigint, 0) AS num_rows
FROM
    information_schema.tables t
LEFT JOIN
    pg_class ON pg_class.relname = t.table_name
LEFT JOIN
    pg_namespace ON pg_namespace.oid = pg_class.relnamespace
WHERE
    t.table_schema = 'public'
    AND pg_namespace.nspname = 'public'
ORDER BY
    t.table_name ASC
;
-- Output
  table_name | total_size | index_size | table_size | num_rows 
------------+------------+------------+------------+----------
 account    | 32 kB      | 16 kB      | 8192 bytes |      100
 post       | 30 MB      | 2208 kB    | 28 MB      |   100000
 thread     | 160 kB     | 40 kB      | 88 kB      |     1000
 words      | 10024 kB   | 0 bytes    | 9984 kB    |   235976
(4 rows)

```


### Exercise 2 See all my posts
```sql
-- Query 1: See all my posts
EXPLAIN ANALYZE
SELECT * FROM post
WHERE account_id = 1
;

-- Output
                                               QUERY PLAN
--------------------------------------------------------------------------------------------------------
 Seq Scan on post  (cost=0.00..4822.00 rows=510 width=243) (actual time=0.428..39.322 rows=521 loops=1)
   Filter: (account_id = 1)
   Rows Removed by Filter: 99479
 Planning Time: 0.124 ms
 Execution Time: 39.390 ms
(5 rows)

```

### Exercise 3 How many post have i made?
```sql
-- Query 2: How many post have i made?
EXPLAIN ANALYZE
SELECT COUNT(*) FROM post
WHERE account_id = 1;

-- Output
                                                 QUERY PLAN
------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=4823.27..4823.28 rows=1 width=8) (actual time=32.437..32.438 rows=1 loops=1)
   ->  Seq Scan on post  (cost=0.00..4822.00 rows=510 width=0) (actual time=0.325..32.368 rows=521 loops=1)
         Filter: (account_id = 1)
         Rows Removed by Filter: 99479
 Planning Time: 0.110 ms
 Execution Time: 32.480 ms
(6 rows)

```

### Exercise 4 See all current posts for a Thread

```sql
-- Query 3: See all current posts for a Thread
EXPLAIN ANALYZE
SELECT * FROM post
WHERE thread_id = 1
AND visible = TRUE;

-- Output
                                              QUERY PLAN
------------------------------------------------------------------------------------------------------
 Seq Scan on post  (cost=0.00..4822.00 rows=89 width=243) (actual time=1.811..34.009 rows=43 loops=1)
   Filter: (visible AND (thread_id = 1))
   Rows Removed by Filter: 99957
 Planning Time: 0.189 ms
 Execution Time: 34.049 ms
(5 rows)

```

### Exercise 5 How many posts have i made to a Thread?

```sql
-- Query 4: How many posts have i made to a Thread?
EXPLAIN ANALYZE
SELECT COUNT(*)
FROM post
WHERE thread_id = 1 AND visible = TRUE AND account_id = 1;

-- Output
                                               QUERY PLAN
---------------------------------------------------------------------------------------------------------
 Aggregate  (cost=5072.00..5072.01 rows=1 width=8) (actual time=23.561..23.562 rows=1 loops=1)
   ->  Seq Scan on post  (cost=0.00..5072.00 rows=1 width=0) (actual time=23.555..23.555 rows=0 loops=1)
         Filter: (visible AND (thread_id = 1) AND (account_id = 1))
         Rows Removed by Filter: 100000
 Planning Time: 0.165 ms
 Execution Time: 23.607 ms
(6 rows)



```

### Exercise 6 See all current posts for a Thread for this month, in order

```sql
-- Query 5: See all current posts for a Thread for this month, in order
EXPLAIN ANALYZE
SELECT *
FROM post
WHERE thread_id = 1 AND visible = TRUE AND created > NOW() - '1 month'::interval
ORDER BY created;

-- Output
                                                        QUERY PLAN
--------------------------------------------------------------------------------------------------------------------------
 Gather Merge  (cost=5405.37..5405.60 rows=2 width=243) (actual time=21.584..25.900 rows=3 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Sort  (cost=4405.34..4405.35 rows=1 width=243) (actual time=14.281..14.283 rows=1 loops=3)
         Sort Key: created
         Sort Method: quicksort  Memory: 25kB
         Worker 0:  Sort Method: quicksort  Memory: 25kB
         Worker 1:  Sort Method: quicksort  Memory: 25kB
         ->  Parallel Seq Scan on post  (cost=0.00..4405.33 rows=1 width=243) (actual time=10.194..14.070 rows=1 loops=3)
               Filter: (visible AND (thread_id = 1) AND (created > (now() - '1 mon'::interval)))
               Rows Removed by Filter: 33332
 Planning Time: 0.251 ms
 Execution Time: 25.975 ms
(13 rows)

```


## CREATE INDEXES

### Case A Baseline

```sql
EXPLAIN ANALYZE
SELECT * FROM post WHERE account_id = 1; 
```
  table_name | total_size | index_size | table_size | num_rows 
------------+------------+------------+------------+----------
 account    | 32 kB      | 16 kB      | 8192 bytes |      100
 post       | 30 MB      | 2208 kB    | 28 MB      |   100000
 thread     | 160 kB     | 40 kB      | 88 kB      |     1000
 words      | 10024 kB   | 0 bytes    | 9984 kB    |   235976
(4 rows)

                                               QUERY PLAN
--------------------------------------------------------------------------------------------------------
 Seq Scan on post  (cost=0.00..4822.00 rows=510 width=243) (actual time=0.275..31.470 rows=521 loops=1)
   Filter: (account_id = 1)
   Rows Removed by Filter: 99479
 Planning Time: 0.158 ms
 Execution Time: 31.554 ms
(5 rows)

### Case B Single Index

```sql
CREATE INDEX post_account_id_idx ON post(account_id);

EXPLAIN ANALYZE
SELECT * FROM post WHERE account_id = 1; 
table_name | total_size | index_size | table_size | num_rows
------------+------------+------------+------------+----------
 account    | 32 kB      | 16 kB      | 8192 bytes |      100
 post       | 31 MB      | 2928 kB    | 28 MB      |   100000
 thread     | 160 kB     | 40 kB      | 88 kB      |     1000
 words      | 10024 kB   | 0 bytes    | 9984 kB    |   235976
(4 rows)

                                                          QUERY PLAN
--------------------------------------------------------------------------------------------------------------------------------
 Bitmap Heap Scan on post  (cost=8.24..1399.69 rows=510 width=243) (actual time=0.372..1.676 rows=521 loops=1)
   Recheck Cond: (account_id = 1)
   Heap Blocks: exact=488
   ->  Bitmap Index Scan on post_account_id_idx  (cost=0.00..8.12 rows=510 width=0) (actual time=0.183..0.184 rows=521 loops=1)
         Index Cond: (account_id = 1)
 Planning Time: 0.503 ms
 Execution Time: 1.804 ms
(7 rows)

```

### Case C Composite Index

```sql
DROP INDEX post_account_id_idx;

CREATE INDEX post_thread_id_account_id_idx ON post(thread_id, account_id);

EXPLAIN ANALYZE
SELECT * FROM post WHERE thread_id = 1 AND account_id = 1;
                                                              QUERY PLAN
--------------------------------------------------------------------------------------------------------------------------------------
 Index Scan using post_thread_id_account_id_idx on post  (cost=0.29..8.31 rows=1 width=243) (actual time=0.060..0.060 rows=0 loops=1)
   Index Cond: ((thread_id = 1) AND (account_id = 1))
 Planning Time: 0.554 ms
 Execution Time: 0.092 ms
(4 rows)

```

### Case D Full Composite Index

```sql
DROP INDEX post_thread_id_account_id_idx;

CREATE INDEX post_thread_id_account_id_visible_idx ON post(thread_id, account_id, visible);

EXPLAIN ANALYZE
SELECT * FROM post WHERE thread_id = 1 AND account_id = 1 AND visible = TRUE;
```
                                                                 QUERY PLAN
----------------------------------------------------------------------------------------------------------------------------------------------
 Index Scan using post_thread_id_account_id_visible_idx on post  (cost=0.42..8.44 rows=1 width=243) (actual time=0.051..0.052 rows=0 loops=1)
   Index Cond: ((thread_id = 1) AND (account_id = 1) AND (visible = true))
 Planning Time: 0.549 ms
 Execution Time: 0.083 ms
(4 rows)


### Case E Partial Index

```sql
DROP INDEX post_thread_id_account_id_visible_idx;

CREATE INDEX post_thread_id_visible_idx ON post(thread_id) WHERE visible = TRUE;

EXPLAIN ANALYZE
SELECT * FROM post WHERE thread_id = 1 AND visible = TRUE;
```
                                                             QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------------------
 Bitmap Heap Scan on post  (cost=4.98..316.66 rows=89 width=243) (actual time=0.067..0.249 rows=43 loops=1)
   Recheck Cond: ((thread_id = 1) AND visible)
   Heap Blocks: exact=43
   ->  Bitmap Index Scan on post_thread_id_visible_idx  (cost=0.00..4.96 rows=89 width=0) (actual time=0.043..0.044 rows=43 loops=1)
         Index Cond: (thread_id = 1)
 Planning Time: 0.400 ms
 Execution Time: 0.285 ms
(7 rows)

### Case F Sorting

```sql
DROP INDEX post_thread_id_visible_idx;

CREATE INDEX post_thread_id_create_idx ON post(thread_id, created DESC);

EXPLAIN ANALYZE
SELECT * FROM post WHERE thread_id = 1 ORDER BY created DESC LIMIT 10;

```
                                                                QUERY PLAN
--------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=0.42..40.59 rows=10 width=243) (actual time=0.058..0.087 rows=10 loops=1)
   ->  Index Scan using post_thread_id_create_idx on post  (cost=0.42..394.09 rows=98 width=243) (actual time=0.055..0.082 rows=10 loops=1)
         Index Cond: (thread_id = 1)
 Planning Time: 0.564 ms
 Execution Time: 0.117 ms
(5 rows)

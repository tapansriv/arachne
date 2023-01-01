CREATE TABLE duck_table_112_0 AS SELECT "t5"."p_personid" AS "personid", "t8"."k_person2id" AS "friendid"
FROM (SELECT "t1"."p_personid"
FROM (SELECT "t"."p_personid", "t0"."pl_containerplaceid"
FROM (SELECT "p_personid", "p_placeid"
FROM '/mnt/disks/ldbc/parquet/person.parquet' AS person) AS "t"
INNER JOIN (SELECT "pl_placeid", "pl_containerplaceid"
FROM '/mnt/disks/ldbc/parquet/place.parquet' AS place) AS "t0" ON "t"."p_placeid" = "t0"."pl_placeid") AS "t1"
INNER JOIN (SELECT "pl_placeid"
FROM '/mnt/disks/ldbc/parquet/place.parquet' AS place
WHERE "pl_name" = 'China') AS "t4" ON "t1"."pl_containerplaceid" = "t4"."pl_placeid") AS "t5"
INNER JOIN (SELECT "k_person1id", "k_person2id"
FROM '/mnt/disks/ldbc/parquet/knows.parquet' AS knows
WHERE "k_creationdate" >= 1354147200000 AND "k_creationdate" <= 1362441600000) AS "t8" ON "t5"."p_personid" = "t8"."k_person1id"
;
CREATE TABLE duck_table_112_1 AS SELECT "t5"."p_personid", "t8"."k_person1id", "t8"."k_person2id"
FROM (SELECT "t1"."p_personid"
FROM (SELECT "t"."p_personid", "t0"."pl_containerplaceid"
FROM (SELECT "p_personid", "p_placeid"
FROM '/mnt/disks/ldbc/parquet/person.parquet' AS person) AS "t"
INNER JOIN (SELECT "pl_placeid", "pl_containerplaceid"
FROM '/mnt/disks/ldbc/parquet/place.parquet' AS place) AS "t0" ON "t"."p_placeid" = "t0"."pl_placeid") AS "t1"
INNER JOIN (SELECT "pl_placeid"
FROM '/mnt/disks/ldbc/parquet/place.parquet' AS place
WHERE "pl_name" = 'China') AS "t4" ON "t1"."pl_containerplaceid" = "t4"."pl_placeid") AS "t5"
INNER JOIN (SELECT "k_person1id", "k_person2id"
FROM '/mnt/disks/ldbc/parquet/knows.parquet' AS knows
WHERE "k_creationdate" >= 1354147200000 AND "k_creationdate" <= 1362441600000) AS "t8" ON "t5"."p_personid" = "t8"."k_person1id"
;
CREATE TABLE duck_table_112_2 AS SELECT "t"."personid", "t"."friendid", "t0"."personid" AS "personid0", "t0"."friendid" AS "friendid0", "duck_table_112_0"."personid" AS "personid1", "duck_table_112_0"."friendid" AS "friendid1", "duck_table_112_00"."personid" AS "personid2", "duck_table_112_00"."friendid" AS "friendid2"
FROM (SELECT "p_personid" AS "personid", "k_person2id" AS "friendid"
FROM "duck_table_112_1") AS "t"
INNER JOIN (SELECT "p_personid" AS "personid", "k_person2id" AS "friendid"
FROM "duck_table_112_1") AS "t0" ON "t"."friendid" = "t0"."personid" AND "t"."personid" < "t0"."personid"
INNER JOIN "duck_table_112_0" ON "t0"."friendid" = "duck_table_112_0"."personid" AND "t0"."personid" < "duck_table_112_0"."personid"
INNER JOIN "duck_table_112_0" AS "duck_table_112_00" ON "duck_table_112_0"."friendid" = "duck_table_112_00"."personid" AND "t"."personid" = "duck_table_112_00"."friendid" AND "duck_table_112_0"."personid" < "duck_table_112_00"."personid"
;
SELECT COUNT(*)
FROM "duck_table_112_2"
;

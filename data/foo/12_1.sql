CREATE TABLE duck_table_12_0 AS SELECT "t12"."p_personid" AS "k_person1id"
FROM (SELECT "t1"."p_personid"
FROM (SELECT "t"."p_personid", "t0"."pl_containerplaceid"
FROM (SELECT "p_personid", "p_placeid"
FROM '/mnt/disks/ldbc/parquet/person.parquet' AS person) AS "t"
INNER JOIN (SELECT "pl_placeid", "pl_containerplaceid"
FROM '/mnt/disks/ldbc/parquet/place.parquet' AS place) AS "t0" ON "t"."p_placeid" = "t0"."pl_placeid") AS "t1"
INNER JOIN (SELECT "t7"."pl_placeid"
FROM (SELECT "t3"."pl_containerplaceid"
FROM (SELECT "p_placeid"
FROM '/mnt/disks/ldbc/parquet/person.parquet' AS person) AS "t2"
INNER JOIN (SELECT "pl_placeid", "pl_containerplaceid"
FROM '/mnt/disks/ldbc/parquet/place.parquet' AS place) AS "t3" ON "t2"."p_placeid" = "t3"."pl_placeid") AS "t4"
INNER JOIN (SELECT "pl_placeid"
FROM '/mnt/disks/ldbc/parquet/place.parquet' AS place
WHERE "pl_name" IN ('China', 'India', 'Mexico')) AS "t7" ON "t4"."pl_containerplaceid" = "t7"."pl_placeid"
GROUP BY "t7"."pl_placeid"
HAVING COUNT(*) > 100) AS "t11" ON "t1"."pl_containerplaceid" = "t11"."pl_placeid") AS "t12"
INNER JOIN (SELECT "k_person1id", "k_person2id"
FROM '/mnt/disks/ldbc/parquet/knows.parquet' AS knows
WHERE "k_creationdate" >= 1354147200000 AND "k_creationdate" <= 1362441600000) AS "t15" ON "t12"."p_personid" = "t15"."k_person1id"
;
CREATE TABLE duck_table_12_1 AS SELECT "t12"."p_personid" AS "k_person1id", "t15"."k_person2id"
FROM (SELECT "t1"."p_personid"
FROM (SELECT "t"."p_personid", "t0"."pl_containerplaceid"
FROM (SELECT "p_personid", "p_placeid"
FROM '/mnt/disks/ldbc/parquet/person.parquet' AS person) AS "t"
INNER JOIN (SELECT "pl_placeid", "pl_containerplaceid"
FROM '/mnt/disks/ldbc/parquet/place.parquet' AS place) AS "t0" ON "t"."p_placeid" = "t0"."pl_placeid") AS "t1"
INNER JOIN (SELECT "t7"."pl_placeid"
FROM (SELECT "t3"."pl_containerplaceid"
FROM (SELECT "p_placeid"
FROM '/mnt/disks/ldbc/parquet/person.parquet' AS person) AS "t2"
INNER JOIN (SELECT "pl_placeid", "pl_containerplaceid"
FROM '/mnt/disks/ldbc/parquet/place.parquet' AS place) AS "t3" ON "t2"."p_placeid" = "t3"."pl_placeid") AS "t4"
INNER JOIN (SELECT "pl_placeid"
FROM '/mnt/disks/ldbc/parquet/place.parquet' AS place
WHERE "pl_name" IN ('China', 'India', 'Mexico')) AS "t7" ON "t4"."pl_containerplaceid" = "t7"."pl_placeid"
GROUP BY "t7"."pl_placeid"
HAVING COUNT(*) > 100) AS "t11" ON "t1"."pl_containerplaceid" = "t11"."pl_placeid") AS "t12"
INNER JOIN (SELECT "k_person1id", "k_person2id"
FROM '/mnt/disks/ldbc/parquet/knows.parquet' AS knows
WHERE "k_creationdate" >= 1354147200000 AND "k_creationdate" <= 1362441600000) AS "t15" ON "t12"."p_personid" = "t15"."k_person1id"
;
CREATE TABLE duck_table_12_2 AS SELECT "t12"."p_personid", "t15"."k_person1id", "t15"."k_person2id"
FROM (SELECT "t1"."p_personid"
FROM (SELECT "t"."p_personid", "t0"."pl_containerplaceid"
FROM (SELECT "p_personid", "p_placeid"
FROM '/mnt/disks/ldbc/parquet/person.parquet' AS person) AS "t"
INNER JOIN (SELECT "pl_placeid", "pl_containerplaceid"
FROM '/mnt/disks/ldbc/parquet/place.parquet' AS place) AS "t0" ON "t"."p_placeid" = "t0"."pl_placeid") AS "t1"
INNER JOIN (SELECT "t7"."pl_placeid"
FROM (SELECT "t3"."pl_containerplaceid"
FROM (SELECT "p_placeid"
FROM '/mnt/disks/ldbc/parquet/person.parquet' AS person) AS "t2"
INNER JOIN (SELECT "pl_placeid", "pl_containerplaceid"
FROM '/mnt/disks/ldbc/parquet/place.parquet' AS place) AS "t3" ON "t2"."p_placeid" = "t3"."pl_placeid") AS "t4"
INNER JOIN (SELECT "pl_placeid"
FROM '/mnt/disks/ldbc/parquet/place.parquet' AS place
WHERE "pl_name" IN ('China', 'India', 'Mexico')) AS "t7" ON "t4"."pl_containerplaceid" = "t7"."pl_placeid"
GROUP BY "t7"."pl_placeid"
HAVING COUNT(*) > 100) AS "t11" ON "t1"."pl_containerplaceid" = "t11"."pl_placeid") AS "t12"
INNER JOIN (SELECT "k_person1id", "k_person2id"
FROM '/mnt/disks/ldbc/parquet/knows.parquet' AS knows
WHERE "k_creationdate" >= 1354147200000 AND "k_creationdate" <= 1362441600000) AS "t15" ON "t12"."p_personid" = "t15"."k_person1id"
;
CREATE TABLE duck_table_12_3 AS SELECT "t0"."k_person1id", "duck_table_12_1"."k_person2id" AS "k_person2id0"
FROM (SELECT "p_personid" AS "k_person1id", "k_person2id"
FROM "duck_table_12_2"
WHERE CAST("p_personid" AS BIGINT) = 28587302322191) AS "t0"
INNER JOIN "duck_table_12_1" ON "t0"."k_person2id" = "duck_table_12_1"."k_person1id"
;
CREATE TABLE duck_table_12_4 AS SELECT "t0"."k_person1id", "t0"."k_person2id", "duck_table_12_1"."k_person1id" AS "k_person1id0", "duck_table_12_1"."k_person2id" AS "k_person2id0"
FROM (SELECT "p_personid" AS "k_person1id", "k_person2id"
FROM "duck_table_12_2"
WHERE CAST("p_personid" AS BIGINT) = 28587302322191) AS "t0"
INNER JOIN "duck_table_12_1" ON "t0"."k_person2id" = "duck_table_12_1"."k_person1id"
;
CREATE TABLE duck_table_12_5 AS SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (VALUES (28587302322191, 28587302322191, 0)) AS "t" ("src", "dst", "w")
UNION ALL
SELECT "p_personid" AS "src", "k_person2id" AS "dst", 1 AS "w"
FROM "duck_table_12_2"
WHERE 1 = 1 AND CAST("p_personid" AS BIGINT) = 28587302322191) AS "t"
UNION ALL
SELECT "k_person1id" AS "src", "k_person2id0" AS "dst", 2 AS "w"
FROM "duck_table_12_4") AS "t"
UNION ALL
SELECT "duck_table_12_3"."k_person1id" AS "src", "duck_table_12_3"."k_person2id0" AS "dst", 3 AS "w"
FROM "duck_table_12_3"
INNER JOIN "duck_table_12_0" ON "duck_table_12_3"."k_person2id0" = "duck_table_12_0"."k_person1id") AS "t"
UNION ALL
SELECT "t9"."k_person1id" AS "src", "t9"."k_person2id0" AS "dst", 4 AS "w"
FROM (SELECT "duck_table_12_30"."k_person1id", "duck_table_12_30"."k_person2id0", "t8"."k_person2id" AS "k_person2id1"
FROM "duck_table_12_3" AS "duck_table_12_30"
INNER JOIN (SELECT *
FROM "duck_table_12_1") AS "t8" ON "duck_table_12_30"."k_person2id0" = "t8"."k_person1id") AS "t9"
INNER JOIN "duck_table_12_0" AS "duck_table_12_00" ON "t9"."k_person2id1" = "duck_table_12_00"."k_person1id"
;
SELECT "src", "dst", MIN("w")
FROM "duck_table_12_5"
GROUP BY "src", "dst"
;

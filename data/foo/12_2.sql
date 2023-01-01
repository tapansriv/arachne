CREATE TABLE duck_table_12_0 AS SELECT "t12"."p_personid", "t15"."k_person1id", "t15"."k_person2id"
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
CREATE TABLE duck_table_12_1 AS SELECT "t12"."p_personid", "t15"."k_person1id", "t15"."k_person2id"
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
SELECT "src", "dst", MIN("w")
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (VALUES (28587302322191, 28587302322191, 0)) AS "t" ("src", "dst", "w")
UNION ALL
SELECT "p_personid" AS "src", "k_person2id" AS "dst", 1 AS "w"
FROM "duck_table_12_1"
WHERE 1 = 1 AND CAST("p_personid" AS BIGINT) = 28587302322191) AS "t"
UNION ALL
SELECT "t5"."k_person1id" AS "src", "t6"."k_person2id" AS "dst", 2 AS "w"
FROM (SELECT "p_personid" AS "k_person1id", "k_person2id"
FROM "duck_table_12_1"
WHERE CAST("p_personid" AS BIGINT) = 28587302322191) AS "t5"
INNER JOIN (SELECT "p_personid" AS "k_person1id", "k_person2id"
FROM "duck_table_12_1") AS "t6" ON "t5"."k_person2id" = "t6"."k_person1id") AS "t"
UNION ALL
SELECT "t12"."k_person1id" AS "src", "t12"."k_person2id0" AS "dst", 3 AS "w"
FROM (SELECT "t10"."k_person1id", "t11"."k_person2id" AS "k_person2id0"
FROM (SELECT "p_personid" AS "k_person1id", "k_person2id"
FROM "duck_table_12_1"
WHERE CAST("p_personid" AS BIGINT) = 28587302322191) AS "t10"
INNER JOIN (SELECT "p_personid" AS "k_person1id", "k_person2id"
FROM "duck_table_12_1") AS "t11" ON "t10"."k_person2id" = "t11"."k_person1id") AS "t12"
INNER JOIN (SELECT "p_personid" AS "k_person1id"
FROM "duck_table_12_1") AS "t14" ON "t12"."k_person2id0" = "t14"."k_person1id") AS "t"
UNION ALL
SELECT "t23"."k_person1id" AS "src", "t23"."k_person2id0" AS "dst", 4 AS "w"
FROM (SELECT "t20"."k_person1id", "t20"."k_person2id0", "t22"."k_person2id" AS "k_person2id1"
FROM (SELECT "t18"."k_person1id", "t19"."k_person2id" AS "k_person2id0"
FROM (SELECT "p_personid" AS "k_person1id", "k_person2id"
FROM "duck_table_12_1"
WHERE CAST("p_personid" AS BIGINT) = 28587302322191) AS "t18"
INNER JOIN (SELECT "p_personid" AS "k_person1id", "k_person2id"
FROM "duck_table_12_1") AS "t19" ON "t18"."k_person2id" = "t19"."k_person1id") AS "t20"
INNER JOIN (SELECT "p_personid" AS "k_person1id", "k_person2id"
FROM "duck_table_12_1") AS "t22" ON "t20"."k_person2id0" = "t22"."k_person1id") AS "t23"
INNER JOIN (SELECT "p_personid" AS "k_person1id"
FROM "duck_table_12_1") AS "t25" ON "t23"."k_person2id1" = "t25"."k_person1id") AS "t27"
GROUP BY "src", "dst"
;

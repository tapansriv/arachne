SELECT COUNT(*)
FROM (SELECT "t5"."p_personid" AS "personid", "t8"."k_person2id" AS "friendid"
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
WHERE "k_creationdate" >= 1354147200000 AND "k_creationdate" <= 1362441600000) AS "t8" ON "t5"."p_personid" = "t8"."k_person1id") AS "t9"
INNER JOIN (SELECT "t16"."p_personid" AS "personid", "t19"."k_person2id" AS "friendid"
FROM (SELECT "t12"."p_personid"
FROM (SELECT "t10"."p_personid", "t11"."pl_containerplaceid"
FROM (SELECT "p_personid", "p_placeid"
FROM '/mnt/disks/ldbc/parquet/person.parquet' AS person) AS "t10"
INNER JOIN (SELECT "pl_placeid", "pl_containerplaceid"
FROM '/mnt/disks/ldbc/parquet/place.parquet' AS place) AS "t11" ON "t10"."p_placeid" = "t11"."pl_placeid") AS "t12"
INNER JOIN (SELECT "pl_placeid"
FROM '/mnt/disks/ldbc/parquet/place.parquet' AS place
WHERE "pl_name" = 'China') AS "t15" ON "t12"."pl_containerplaceid" = "t15"."pl_placeid") AS "t16"
INNER JOIN (SELECT "k_person1id", "k_person2id"
FROM '/mnt/disks/ldbc/parquet/knows.parquet' AS knows
WHERE "k_creationdate" >= 1354147200000 AND "k_creationdate" <= 1362441600000) AS "t19" ON "t16"."p_personid" = "t19"."k_person1id") AS "t20" ON "t9"."friendid" = "t20"."personid" AND "t9"."personid" < "t20"."personid"
INNER JOIN (SELECT "t27"."p_personid" AS "personid", "t30"."k_person2id" AS "friendid"
FROM (SELECT "t23"."p_personid"
FROM (SELECT "t21"."p_personid", "t22"."pl_containerplaceid"
FROM (SELECT "p_personid", "p_placeid"
FROM '/mnt/disks/ldbc/parquet/person.parquet' AS person) AS "t21"
INNER JOIN (SELECT "pl_placeid", "pl_containerplaceid"
FROM '/mnt/disks/ldbc/parquet/place.parquet' AS place) AS "t22" ON "t21"."p_placeid" = "t22"."pl_placeid") AS "t23"
INNER JOIN (SELECT "pl_placeid"
FROM '/mnt/disks/ldbc/parquet/place.parquet' AS place
WHERE "pl_name" = 'China') AS "t26" ON "t23"."pl_containerplaceid" = "t26"."pl_placeid") AS "t27"
INNER JOIN (SELECT "k_person1id", "k_person2id"
FROM '/mnt/disks/ldbc/parquet/knows.parquet' AS knows
WHERE "k_creationdate" >= 1354147200000 AND "k_creationdate" <= 1362441600000) AS "t30" ON "t27"."p_personid" = "t30"."k_person1id") AS "t31" ON "t20"."friendid" = "t31"."personid" AND "t20"."personid" < "t31"."personid"
INNER JOIN (SELECT "t38"."p_personid" AS "personid", "t41"."k_person2id" AS "friendid"
FROM (SELECT "t34"."p_personid"
FROM (SELECT "t32"."p_personid", "t33"."pl_containerplaceid"
FROM (SELECT "p_personid", "p_placeid"
FROM '/mnt/disks/ldbc/parquet/person.parquet' AS person) AS "t32"
INNER JOIN (SELECT "pl_placeid", "pl_containerplaceid"
FROM '/mnt/disks/ldbc/parquet/place.parquet' AS place) AS "t33" ON "t32"."p_placeid" = "t33"."pl_placeid") AS "t34"
INNER JOIN (SELECT "pl_placeid"
FROM '/mnt/disks/ldbc/parquet/place.parquet' AS place
WHERE "pl_name" = 'China') AS "t37" ON "t34"."pl_containerplaceid" = "t37"."pl_placeid") AS "t38"
INNER JOIN (SELECT "k_person1id", "k_person2id"
FROM '/mnt/disks/ldbc/parquet/knows.parquet' AS knows
WHERE "k_creationdate" >= 1354147200000 AND "k_creationdate" <= 1362441600000) AS "t41" ON "t38"."p_personid" = "t41"."k_person1id") AS "t42" ON "t31"."friendid" = "t42"."personid" AND "t9"."personid" = "t42"."friendid" AND "t31"."personid" < "t42"."personid"


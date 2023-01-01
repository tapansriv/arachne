CREATE TABLE duck_table_02_0 AS SELECT "t2"."d_week_seq", SUM("t1"."sales_price") FILTER (WHERE "t2"."=") AS "sun_sales", SUM("t1"."sales_price") FILTER (WHERE "t2"."=3") AS "mon_sales", SUM("t1"."sales_price") FILTER (WHERE "t2"."=4") AS "tue_sales", SUM("t1"."sales_price") FILTER (WHERE "t2"."=5") AS "wed_sales", SUM("t1"."sales_price") FILTER (WHERE "t2"."=6") AS "thu_sales", SUM("t1"."sales_price") FILTER (WHERE "t2"."=7") AS "fri_sales", SUM("t1"."sales_price") FILTER (WHERE "t2"."=8") AS "sat_sales"
FROM (SELECT "ws_sold_date_sk" AS "sold_date_sk", "ws_ext_sales_price" AS "sales_price"
FROM '/mnt/disks/tpcds/parquet/web_sales.parquet' AS web_sales
UNION ALL
SELECT "cs_sold_date_sk" AS "sold_date_sk", "cs_ext_sales_price" AS "sales_price"
FROM '/mnt/disks/tpcds/parquet/catalog_sales.parquet' AS catalog_sales) AS "t1"
INNER JOIN (SELECT "d_date_sk", "d_week_seq", "d_day_name" = 'Sunday' AS "=", "d_day_name" = 'Monday' AS "=3", "d_day_name" = 'Tuesday' AS "=4", "d_day_name" = 'Wednesday' AS "=5", "d_day_name" = 'Thursday' AS "=6", "d_day_name" = 'Friday' AS "=7", "d_day_name" = 'Saturday' AS "=8"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim) AS "t2" ON "t1"."sold_date_sk" = "t2"."d_date_sk"
GROUP BY "t2"."d_week_seq"
;
CREATE TABLE duck_table_02_1 AS SELECT "t3"."d_week_seq1", ROUND("t3"."sun_sales1" / "t8"."sun_sales2", 2) AS "r1", ROUND("t3"."mon_sales1" / "t8"."mon_sales2", 2) AS "r2", ROUND("t3"."tue_sales1" / "t8"."tue_sales2", 2) AS "r3", ROUND("t3"."wed_sales1" / "t8"."wed_sales2", 2) AS "r4", ROUND("t3"."thu_sales1" / "t8"."thu_sales2", 2) AS "r5", ROUND("t3"."fri_sales1" / "t8"."fri_sales2", 2) AS "r6", ROUND("t3"."sat_sales1" / "t8"."sat_sales2", 2)
FROM (SELECT "duck_table_02_0"."d_week_seq" AS "d_week_seq1", "duck_table_02_0"."sun_sales" AS "sun_sales1", "duck_table_02_0"."mon_sales" AS "mon_sales1", "duck_table_02_0"."tue_sales" AS "tue_sales1", "duck_table_02_0"."wed_sales" AS "wed_sales1", "duck_table_02_0"."thu_sales" AS "thu_sales1", "duck_table_02_0"."fri_sales" AS "fri_sales1", "duck_table_02_0"."sat_sales" AS "sat_sales1"
FROM "duck_table_02_0"
INNER JOIN (SELECT "d_week_seq"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_year" = 2001) AS "t1" ON "duck_table_02_0"."d_week_seq" = "t1"."d_week_seq") AS "t3"
INNER JOIN (SELECT "duck_table_02_00"."sun_sales" AS "sun_sales2", "duck_table_02_00"."mon_sales" AS "mon_sales2", "duck_table_02_00"."tue_sales" AS "tue_sales2", "duck_table_02_00"."wed_sales" AS "wed_sales2", "duck_table_02_00"."thu_sales" AS "thu_sales2", "duck_table_02_00"."fri_sales" AS "fri_sales2", "duck_table_02_00"."sat_sales" AS "sat_sales2", "duck_table_02_00"."d_week_seq" - 53 AS "-"
FROM "duck_table_02_0" AS "duck_table_02_00"
INNER JOIN (SELECT "d_week_seq"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_year" = 2001 + 1) AS "t6" ON "duck_table_02_00"."d_week_seq" = "t6"."d_week_seq") AS "t8" ON "t3"."d_week_seq1" = "t8"."-"
;
SELECT *
FROM "duck_table_02_1"
ORDER BY "d_week_seq1" NULLS FIRST
;

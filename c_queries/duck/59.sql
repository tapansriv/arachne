SELECT "t8"."s_store_name1", "t8"."s_store_id1", "t8"."d_week_seq1", "t8"."sun_sales1" / "t19"."sun_sales2", "t8"."mon_sales1" / "t19"."mon_sales2", "t8"."tue_sales1" / "t19"."tue_sales2", "t8"."wed_sales1" / "t19"."wed_sales2", "t8"."thu_sales1" / "t19"."thu_sales2", "t8"."fri_sales1" / "t19"."fri_sales2", "t8"."sat_sales1" / "t19"."sat_sales2"
FROM (SELECT "t4"."s_store_name" AS "s_store_name1", "t4"."d_week_seq" AS "d_week_seq1", "t4"."s_store_id" AS "s_store_id1", "t4"."sun_sales" AS "sun_sales1", "t4"."mon_sales" AS "mon_sales1", "t4"."tue_sales" AS "tue_sales1", "t4"."wed_sales" AS "wed_sales1", "t4"."thu_sales" AS "thu_sales1", "t4"."fri_sales" AS "fri_sales1", "t4"."sat_sales" AS "sat_sales1"
FROM (SELECT "t2"."d_week_seq", "t2"."sun_sales", "t2"."mon_sales", "t2"."tue_sales", "t2"."wed_sales", "t2"."thu_sales", "t2"."fri_sales", "t2"."sat_sales", "t3"."s_store_id", "t3"."s_store_name"
FROM (SELECT "t0"."d_week_seq", "t"."ss_store_sk", SUM("t"."ss_sales_price") FILTER (WHERE "t0"."=") AS "sun_sales", SUM("t"."ss_sales_price") FILTER (WHERE "t0"."=3") AS "mon_sales", SUM("t"."ss_sales_price") FILTER (WHERE "t0"."=4") AS "tue_sales", SUM("t"."ss_sales_price") FILTER (WHERE "t0"."=5") AS "wed_sales", SUM("t"."ss_sales_price") FILTER (WHERE "t0"."=6") AS "thu_sales", SUM("t"."ss_sales_price") FILTER (WHERE "t0"."=7") AS "fri_sales", SUM("t"."ss_sales_price") FILTER (WHERE "t0"."=8") AS "sat_sales"
FROM (SELECT "ss_sold_date_sk", "ss_store_sk", "ss_sales_price"
FROM '/mnt/disks/tpcds/parquet/store_sales.parquet' AS store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk", "d_week_seq", "d_day_name" = 'Sunday' AS "=", "d_day_name" = 'Monday' AS "=3", "d_day_name" = 'Tuesday' AS "=4", "d_day_name" = 'Wednesday' AS "=5", "d_day_name" = 'Thursday' AS "=6", "d_day_name" = 'Friday' AS "=7", "d_day_name" = 'Saturday' AS "=8"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim) AS "t0" ON "t"."ss_sold_date_sk" = "t0"."d_date_sk"
GROUP BY "t0"."d_week_seq", "t"."ss_store_sk") AS "t2"
INNER JOIN (SELECT "s_store_sk", "s_store_id", "s_store_name"
FROM '/mnt/disks/tpcds/parquet/store.parquet' AS store) AS "t3" ON "t2"."ss_store_sk" = "t3"."s_store_sk") AS "t4"
INNER JOIN (SELECT "d_week_seq"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_month_seq" >= 1212 AND "d_month_seq" <= 1212 + 11) AS "t7" ON "t4"."d_week_seq" = "t7"."d_week_seq") AS "t8"
INNER JOIN (SELECT "t14"."s_store_id" AS "s_store_id2", "t14"."sun_sales" AS "sun_sales2", "t14"."mon_sales" AS "mon_sales2", "t14"."tue_sales" AS "tue_sales2", "t14"."wed_sales" AS "wed_sales2", "t14"."thu_sales" AS "thu_sales2", "t14"."fri_sales" AS "fri_sales2", "t14"."sat_sales" AS "sat_sales2", "t14"."d_week_seq" - 52 AS "-"
FROM (SELECT "t12"."d_week_seq", "t12"."sun_sales", "t12"."mon_sales", "t12"."tue_sales", "t12"."wed_sales", "t12"."thu_sales", "t12"."fri_sales", "t12"."sat_sales", "t13"."s_store_id", "t13"."s_store_name"
FROM (SELECT "t10"."d_week_seq", "t9"."ss_store_sk", SUM("t9"."ss_sales_price") FILTER (WHERE "t10"."=") AS "sun_sales", SUM("t9"."ss_sales_price") FILTER (WHERE "t10"."=3") AS "mon_sales", SUM("t9"."ss_sales_price") FILTER (WHERE "t10"."=4") AS "tue_sales", SUM("t9"."ss_sales_price") FILTER (WHERE "t10"."=5") AS "wed_sales", SUM("t9"."ss_sales_price") FILTER (WHERE "t10"."=6") AS "thu_sales", SUM("t9"."ss_sales_price") FILTER (WHERE "t10"."=7") AS "fri_sales", SUM("t9"."ss_sales_price") FILTER (WHERE "t10"."=8") AS "sat_sales"
FROM (SELECT "ss_sold_date_sk", "ss_store_sk", "ss_sales_price"
FROM '/mnt/disks/tpcds/parquet/store_sales.parquet' AS store_sales) AS "t9"
INNER JOIN (SELECT "d_date_sk", "d_week_seq", "d_day_name" = 'Sunday' AS "=", "d_day_name" = 'Monday' AS "=3", "d_day_name" = 'Tuesday' AS "=4", "d_day_name" = 'Wednesday' AS "=5", "d_day_name" = 'Thursday' AS "=6", "d_day_name" = 'Friday' AS "=7", "d_day_name" = 'Saturday' AS "=8"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim) AS "t10" ON "t9"."ss_sold_date_sk" = "t10"."d_date_sk"
GROUP BY "t10"."d_week_seq", "t9"."ss_store_sk") AS "t12"
INNER JOIN (SELECT "s_store_sk", "s_store_id", "s_store_name"
FROM '/mnt/disks/tpcds/parquet/store.parquet' AS store) AS "t13" ON "t12"."ss_store_sk" = "t13"."s_store_sk") AS "t14"
INNER JOIN (SELECT "d_week_seq"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_month_seq" >= 1212 + 12 AND "d_month_seq" <= 1212 + 23) AS "t17" ON "t14"."d_week_seq" = "t17"."d_week_seq") AS "t19" ON "t8"."s_store_id1" = "t19"."s_store_id2" AND "t8"."d_week_seq1" = "t19"."-"
ORDER BY "t8"."s_store_name1" NULLS FIRST, "t8"."s_store_id1" NULLS FIRST, "t8"."d_week_seq1" NULLS FIRST
FETCH NEXT 100 ROWS ONLY


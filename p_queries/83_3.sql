CREATE TABLE duck_table_83_0 AS SELECT "t1"."i_item_id" AS "item_id", SUM("t1"."sr_return_quantity") AS "sr_item_qty", SUM("t1"."sr_return_quantity") * 1.0000 AS "*"
FROM (SELECT "t"."sr_returned_date_sk", "t"."sr_return_quantity", "t0"."i_item_id"
FROM (SELECT "sr_returned_date_sk", "sr_item_sk", "sr_return_quantity"
FROM '/mnt/disks/tpcds/parquet/store_returns.parquet' AS store_returns) AS "t"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t0" ON "t"."sr_item_sk" = "t0"."i_item_sk") AS "t1"
INNER JOIN (SELECT "date_dim"."d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
INNER JOIN (SELECT "date_dim0"."d_date"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS "date_dim0"
INNER JOIN (SELECT "d_week_seq"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_date" IN (DATE '2000-06-30', DATE '2000-09-27', DATE '2000-11-17')
GROUP BY "d_week_seq") AS "t5" ON "date_dim0"."d_week_seq" = "t5"."d_week_seq"
GROUP BY "date_dim0"."d_date") AS "t8" ON "date_dim"."d_date" = "t8"."d_date") AS "t10" ON "t1"."sr_returned_date_sk" = "t10"."d_date_sk"
GROUP BY "t1"."i_item_id";
SELECT "t14"."item_id", "t14"."sr_item_qty", "t14"."*" / ("t14"."+" + "t29"."wr_item_qty") / 3.0000 * 100 AS "sr_dev", "t14"."cr_item_qty", "t14"."*5" / ("t14"."+" + "t29"."wr_item_qty") / 3.0000 * 100 AS "cr_dev", "t29"."wr_item_qty", "t29"."*" / ("t14"."+" + "t29"."wr_item_qty") / 3.0000 * 100 AS "wr_dev", ("t14"."+" + "t29"."wr_item_qty") / 3.0 AS "average"
FROM (SELECT "duck_table_83_0"."item_id", "duck_table_83_0"."sr_item_qty", "t13"."cr_item_qty", "duck_table_83_0"."*", "duck_table_83_0"."sr_item_qty" + "t13"."cr_item_qty" AS "+", "t13"."*" AS "*5"
FROM "duck_table_83_0"
INNER JOIN (SELECT "t1"."i_item_id" AS "item_id", SUM("t1"."cr_return_quantity") AS "cr_item_qty", SUM("t1"."cr_return_quantity") * 1.0000 AS "*"
FROM (SELECT "t"."cr_returned_date_sk", "t"."cr_return_quantity", "t0"."i_item_id"
FROM (SELECT "cr_returned_date_sk", "cr_item_sk", "cr_return_quantity"
FROM '/mnt/disks/tpcds/parquet/catalog_returns.parquet' AS catalog_returns) AS "t"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t0" ON "t"."cr_item_sk" = "t0"."i_item_sk") AS "t1"
INNER JOIN (SELECT "date_dim"."d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
INNER JOIN (SELECT "date_dim0"."d_date"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS "date_dim0"
INNER JOIN (SELECT "d_week_seq"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_date" IN (DATE '2000-06-30', DATE '2000-09-27', DATE '2000-11-17')
GROUP BY "d_week_seq") AS "t5" ON "date_dim0"."d_week_seq" = "t5"."d_week_seq"
GROUP BY "date_dim0"."d_date") AS "t8" ON "date_dim"."d_date" = "t8"."d_date") AS "t10" ON "t1"."cr_returned_date_sk" = "t10"."d_date_sk"
GROUP BY "t1"."i_item_id") AS "t13" ON "duck_table_83_0"."item_id" = "t13"."item_id") AS "t14"
INNER JOIN (SELECT "t17"."i_item_id" AS "item_id", SUM("t17"."wr_return_quantity") AS "wr_item_qty", SUM("t17"."wr_return_quantity") * 1.0000 AS "*"
FROM (SELECT "t15"."wr_returned_date_sk", "t15"."wr_return_quantity", "t16"."i_item_id"
FROM (SELECT "wr_returned_date_sk", "wr_item_sk", "wr_return_quantity"
FROM '/mnt/disks/tpcds/parquet/web_returns.parquet' AS web_returns) AS "t15"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t16" ON "t15"."wr_item_sk" = "t16"."i_item_sk") AS "t17"
INNER JOIN (SELECT "date_dim2"."d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS "date_dim2"
INNER JOIN (SELECT "date_dim3"."d_date"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS "date_dim3"
INNER JOIN (SELECT "d_week_seq"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_date" IN (DATE '2000-06-30', DATE '2000-09-27', DATE '2000-11-17')
GROUP BY "d_week_seq") AS "t21" ON "date_dim3"."d_week_seq" = "t21"."d_week_seq"
GROUP BY "date_dim3"."d_date") AS "t24" ON "date_dim2"."d_date" = "t24"."d_date") AS "t26" ON "t17"."wr_returned_date_sk" = "t26"."d_date_sk"
GROUP BY "t17"."i_item_id") AS "t29" ON "t14"."item_id" = "t29"."item_id"
ORDER BY "t14"."item_id" NULLS FIRST, "t14"."sr_item_qty" NULLS FIRST
FETCH NEXT 100 ROWS ONLY;

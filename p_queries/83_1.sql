CREATE TABLE duck_table_83_0 AS SELECT "date_dim"."d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
INNER JOIN (SELECT "date_dim0"."d_date"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS "date_dim0"
INNER JOIN (SELECT "d_week_seq"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_date" IN (DATE '2000-06-30', DATE '2000-09-27', DATE '2000-11-17')
GROUP BY "d_week_seq") AS "t2" ON "date_dim0"."d_week_seq" = "t2"."d_week_seq"
GROUP BY "date_dim0"."d_date") AS "t5" ON "date_dim"."d_date" = "t5"."d_date";
CREATE TABLE duck_table_83_1 AS SELECT "t4"."item_id", "t4"."sr_item_qty", "t10"."cr_item_qty", "t4"."*" AS "*", "t4"."sr_item_qty" + "t10"."cr_item_qty" AS "+", "t10"."*" AS "*5"
FROM (SELECT "t1"."i_item_id" AS "item_id", SUM("t1"."sr_return_quantity") AS "sr_item_qty", SUM("t1"."sr_return_quantity") * 1.0000 AS "*"
FROM (SELECT "t"."sr_returned_date_sk", "t"."sr_return_quantity", "t0"."i_item_id"
FROM (SELECT "sr_returned_date_sk", "sr_item_sk", "sr_return_quantity"
FROM '/mnt/disks/tpcds/parquet/store_returns.parquet' AS store_returns) AS "t"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t0" ON "t"."sr_item_sk" = "t0"."i_item_sk") AS "t1"
INNER JOIN "duck_table_83_0" ON "t1"."sr_returned_date_sk" = "duck_table_83_0"."d_date_sk"
GROUP BY "t1"."i_item_id") AS "t4"
INNER JOIN (SELECT "t7"."i_item_id" AS "item_id", SUM("t7"."cr_return_quantity") AS "cr_item_qty", SUM("t7"."cr_return_quantity") * 1.0000 AS "*"
FROM (SELECT "t5"."cr_returned_date_sk", "t5"."cr_return_quantity", "t6"."i_item_id"
FROM (SELECT "cr_returned_date_sk", "cr_item_sk", "cr_return_quantity"
FROM '/mnt/disks/tpcds/parquet/catalog_returns.parquet' AS catalog_returns) AS "t5"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t6" ON "t5"."cr_item_sk" = "t6"."i_item_sk") AS "t7"
INNER JOIN "duck_table_83_0" AS "duck_table_83_00" ON "t7"."cr_returned_date_sk" = "duck_table_83_00"."d_date_sk"
GROUP BY "t7"."i_item_id") AS "t10" ON "t4"."item_id" = "t10"."item_id";
SELECT "duck_table_83_1"."item_id", "duck_table_83_1"."sr_item_qty", "duck_table_83_1"."*" / ("duck_table_83_1"."+" + "t13"."wr_item_qty") / 3.0000 * 100 AS "sr_dev", "duck_table_83_1"."cr_item_qty", "duck_table_83_1"."*5" / ("duck_table_83_1"."+" + "t13"."wr_item_qty") / 3.0000 * 100 AS "cr_dev", "t13"."wr_item_qty", "t13"."*" / ("duck_table_83_1"."+" + "t13"."wr_item_qty") / 3.0000 * 100 AS "wr_dev", ("duck_table_83_1"."+" + "t13"."wr_item_qty") / 3.0 AS "average"
FROM "duck_table_83_1"
INNER JOIN (SELECT "t1"."i_item_id" AS "item_id", SUM("t1"."wr_return_quantity") AS "wr_item_qty", SUM("t1"."wr_return_quantity") * 1.0000 AS "*"
FROM (SELECT "t"."wr_returned_date_sk", "t"."wr_return_quantity", "t0"."i_item_id"
FROM (SELECT "wr_returned_date_sk", "wr_item_sk", "wr_return_quantity"
FROM '/mnt/disks/tpcds/parquet/web_returns.parquet' AS web_returns) AS "t"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t0" ON "t"."wr_item_sk" = "t0"."i_item_sk") AS "t1"
INNER JOIN (SELECT "date_dim"."d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
INNER JOIN (SELECT "date_dim0"."d_date"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS "date_dim0"
INNER JOIN (SELECT "d_week_seq"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_date" IN (DATE '2000-06-30', DATE '2000-09-27', DATE '2000-11-17')
GROUP BY "d_week_seq") AS "t5" ON "date_dim0"."d_week_seq" = "t5"."d_week_seq"
GROUP BY "date_dim0"."d_date") AS "t8" ON "date_dim"."d_date" = "t8"."d_date") AS "t10" ON "t1"."wr_returned_date_sk" = "t10"."d_date_sk"
GROUP BY "t1"."i_item_id") AS "t13" ON "duck_table_83_1"."item_id" = "t13"."item_id"
ORDER BY "duck_table_83_1"."item_id" NULLS FIRST, "duck_table_83_1"."sr_item_qty" NULLS FIRST
FETCH NEXT 100 ROWS ONLY;

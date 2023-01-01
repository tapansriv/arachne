SELECT "t29"."item_id", "t29"."sr_item_qty", "t29"."*" / ("t29"."+" + "t44"."wr_item_qty") / 3.0000 * 100 AS "sr_dev", "t29"."cr_item_qty", "t29"."*5" / ("t29"."+" + "t44"."wr_item_qty") / 3.0000 * 100 AS "cr_dev", "t44"."wr_item_qty", "t44"."*" / ("t29"."+" + "t44"."wr_item_qty") / 3.0000 * 100 AS "wr_dev", ("t29"."+" + "t44"."wr_item_qty") / 3.0 AS "average"
FROM (SELECT "t13"."item_id", "t13"."sr_item_qty", "t28"."cr_item_qty", "t13"."*" AS "*", "t13"."sr_item_qty" + "t28"."cr_item_qty" AS "+", "t28"."*" AS "*5"
FROM (SELECT "t1"."i_item_id" AS "item_id", SUM("t1"."sr_return_quantity") AS "sr_item_qty", SUM("t1"."sr_return_quantity") * 1.0000 AS "*"
FROM (SELECT "t"."sr_returned_date_sk", "t"."sr_return_quantity", "t0"."i_item_id"
FROM (SELECT "sr_returned_date_sk", "sr_item_sk", "sr_return_quantity"
FROM store_returns) AS "t"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM item) AS "t0" ON "t"."sr_item_sk" = "t0"."i_item_sk") AS "t1"
INNER JOIN (SELECT "date_dim"."d_date_sk"
FROM date_dim
INNER JOIN (SELECT "date_dim0"."d_date"
FROM date_dim AS "date_dim0"
INNER JOIN (SELECT "d_week_seq"
FROM date_dim
WHERE "d_date" IN (DATE '2000-06-30', DATE '2000-09-27', DATE '2000-11-17')
GROUP BY "d_week_seq") AS "t5" ON "date_dim0"."d_week_seq" = "t5"."d_week_seq"
GROUP BY "date_dim0"."d_date") AS "t8" ON "date_dim"."d_date" = "t8"."d_date") AS "t10" ON "t1"."sr_returned_date_sk" = "t10"."d_date_sk"
GROUP BY "t1"."i_item_id") AS "t13"
INNER JOIN (SELECT "t16"."i_item_id" AS "item_id", SUM("t16"."cr_return_quantity") AS "cr_item_qty", SUM("t16"."cr_return_quantity") * 1.0000 AS "*"
FROM (SELECT "t14"."cr_returned_date_sk", "t14"."cr_return_quantity", "t15"."i_item_id"
FROM (SELECT "cr_returned_date_sk", "cr_item_sk", "cr_return_quantity"
FROM catalog_returns) AS "t14"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM item) AS "t15" ON "t14"."cr_item_sk" = "t15"."i_item_sk") AS "t16"
INNER JOIN (SELECT "date_dim2"."d_date_sk"
FROM date_dim AS "date_dim2"
INNER JOIN (SELECT "date_dim3"."d_date"
FROM date_dim AS "date_dim3"
INNER JOIN (SELECT "d_week_seq"
FROM date_dim
WHERE "d_date" IN (DATE '2000-06-30', DATE '2000-09-27', DATE '2000-11-17')
GROUP BY "d_week_seq") AS "t20" ON "date_dim3"."d_week_seq" = "t20"."d_week_seq"
GROUP BY "date_dim3"."d_date") AS "t23" ON "date_dim2"."d_date" = "t23"."d_date") AS "t25" ON "t16"."cr_returned_date_sk" = "t25"."d_date_sk"
GROUP BY "t16"."i_item_id") AS "t28" ON "t13"."item_id" = "t28"."item_id") AS "t29"
INNER JOIN (SELECT "t32"."i_item_id" AS "item_id", SUM("t32"."wr_return_quantity") AS "wr_item_qty", SUM("t32"."wr_return_quantity") * 1.0000 AS "*"
FROM (SELECT "t30"."wr_returned_date_sk", "t30"."wr_return_quantity", "t31"."i_item_id"
FROM (SELECT "wr_returned_date_sk", "wr_item_sk", "wr_return_quantity"
FROM web_returns) AS "t30"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM item) AS "t31" ON "t30"."wr_item_sk" = "t31"."i_item_sk") AS "t32"
INNER JOIN (SELECT "date_dim5"."d_date_sk"
FROM date_dim AS "date_dim5"
INNER JOIN (SELECT "date_dim6"."d_date"
FROM date_dim AS "date_dim6"
INNER JOIN (SELECT "d_week_seq"
FROM date_dim
WHERE "d_date" IN (DATE '2000-06-30', DATE '2000-09-27', DATE '2000-11-17')
GROUP BY "d_week_seq") AS "t36" ON "date_dim6"."d_week_seq" = "t36"."d_week_seq"
GROUP BY "date_dim6"."d_date") AS "t39" ON "date_dim5"."d_date" = "t39"."d_date") AS "t41" ON "t32"."wr_returned_date_sk" = "t41"."d_date_sk"
GROUP BY "t32"."i_item_id") AS "t44" ON "t29"."item_id" = "t44"."item_id"
ORDER BY "t29"."item_id" NULLS FIRST, "t29"."sr_item_qty" NULLS FIRST
FETCH NEXT 100 ROWS ONLY


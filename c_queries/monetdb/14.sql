SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT "channel", "i_brand_id", "i_class_id", "i_category_id", SUM("sales") AS "sum_sales", SUM("number_sales") AS "number_sales"
FROM (SELECT *
FROM (SELECT 'store' AS "channel", "t22"."i_brand_id", "t22"."i_class_id", "t22"."i_category_id", "t22"."sales", "t22"."number_sales"
FROM (SELECT "t17"."i_brand_id", "t17"."i_class_id", "t17"."i_category_id", SUM("t17"."*") AS "sales", COUNT(*) AS "number_sales"
FROM (SELECT "t15"."ss_sold_date_sk", "t16"."i_brand_id", "t16"."i_class_id", "t16"."i_category_id", "t15"."*" AS "*"
FROM (SELECT "store_sales"."ss_sold_date_sk", "store_sales"."ss_item_sk", "store_sales"."ss_quantity" * "store_sales"."ss_list_price" AS "*"
FROM store_sales
INNER JOIN (SELECT "item"."i_item_sk" AS "ss_item_sk"
FROM item,
(SELECT *
FROM (SELECT "item0"."i_brand_id" AS "brand_id", "item0"."i_class_id" AS "class_id", "item0"."i_category_id" AS "category_id"
FROM store_sales AS "store_sales0",
item AS "item0",
date_dim
WHERE "store_sales0"."ss_item_sk" = "item0"."i_item_sk" AND "store_sales0"."ss_sold_date_sk" = "date_dim"."d_date_sk" AND "date_dim"."d_year" >= 1999 AND "date_dim"."d_year" <= 1999 + 2
INTERSECT
SELECT "item1"."i_brand_id", "item1"."i_class_id", "item1"."i_category_id"
FROM catalog_sales,
item AS "item1",
date_dim AS "date_dim0"
WHERE "catalog_sales"."cs_item_sk" = "item1"."i_item_sk" AND "catalog_sales"."cs_sold_date_sk" = "date_dim0"."d_date_sk" AND "date_dim0"."d_year" >= 1999 AND "date_dim0"."d_year" <= 1999 + 2) AS "t"
INTERSECT
SELECT "item2"."i_brand_id", "item2"."i_class_id", "item2"."i_category_id"
FROM web_sales,
item AS "item2",
date_dim AS "date_dim1"
WHERE "web_sales"."ws_item_sk" = "item2"."i_item_sk" AND "web_sales"."ws_sold_date_sk" = "date_dim1"."d_date_sk" AND "date_dim1"."d_year" >= 1999 AND "date_dim1"."d_year" <= 1999 + 2) AS "t9"
WHERE "item"."i_brand_id" = "t9"."brand_id" AND "item"."i_class_id" = "t9"."class_id" AND "item"."i_category_id" = "t9"."category_id"
GROUP BY "item"."i_item_sk") AS "t13" ON "store_sales"."ss_item_sk" = "t13"."ss_item_sk") AS "t15"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_class_id", "i_category_id"
FROM item) AS "t16" ON "t15"."ss_item_sk" = "t16"."i_item_sk") AS "t17"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1999 + 2 AND "d_moy" = 11) AS "t20" ON "t17"."ss_sold_date_sk" = "t20"."d_date_sk"
GROUP BY "t17"."i_brand_id", "t17"."i_class_id", "t17"."i_category_id") AS "t22"
LEFT JOIN (SELECT CASE COUNT("average_sales") WHEN 0 THEN NULL WHEN 1 THEN "average_sales" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM (SELECT AVG("quantity" * "list_price") AS "average_sales"
FROM (SELECT *
FROM (SELECT "store_sales1"."ss_quantity" AS "quantity", "store_sales1"."ss_list_price" AS "list_price"
FROM store_sales AS "store_sales1",
date_dim AS "date_dim3"
WHERE "store_sales1"."ss_sold_date_sk" = "date_dim3"."d_date_sk" AND ("date_dim3"."d_year" >= 1999 AND "date_dim3"."d_year" <= 2001)
UNION ALL
SELECT "catalog_sales0"."cs_quantity" AS "quantity", "catalog_sales0"."cs_list_price" AS "list_price"
FROM catalog_sales AS "catalog_sales0",
date_dim AS "date_dim4"
WHERE "catalog_sales0"."cs_sold_date_sk" = "date_dim4"."d_date_sk" AND "date_dim4"."d_year" >= 1999 AND "date_dim4"."d_year" <= 1999 + 2) AS "t"
UNION ALL
SELECT "web_sales0"."ws_quantity" AS "quantity", "web_sales0"."ws_list_price" AS "list_price"
FROM web_sales AS "web_sales0",
date_dim AS "date_dim5"
WHERE "web_sales0"."ws_sold_date_sk" = "date_dim5"."d_date_sk" AND "date_dim5"."d_year" >= 1999 AND "date_dim5"."d_year" <= 1999 + 2) AS "t33") AS "t36") AS "t37" ON TRUE
WHERE "t22"."sales" > "t37"."$f0"
UNION ALL
SELECT 'catalog' AS "channel", "t64"."i_brand_id", "t64"."i_class_id", "t64"."i_category_id", "t64"."sales", "t64"."number_sales"
FROM (SELECT "t59"."i_brand_id", "t59"."i_class_id", "t59"."i_category_id", SUM("t59"."*") AS "sales", COUNT(*) AS "number_sales"
FROM (SELECT "t57"."cs_sold_date_sk", "t58"."i_brand_id", "t58"."i_class_id", "t58"."i_category_id", "t57"."*" AS "*"
FROM (SELECT "catalog_sales1"."cs_sold_date_sk", "catalog_sales1"."cs_item_sk", "catalog_sales1"."cs_quantity" * "catalog_sales1"."cs_list_price" AS "*"
FROM catalog_sales AS "catalog_sales1"
INNER JOIN (SELECT "item4"."i_item_sk" AS "ss_item_sk"
FROM item AS "item4",
(SELECT *
FROM (SELECT "item5"."i_brand_id" AS "brand_id", "item5"."i_class_id" AS "class_id", "item5"."i_category_id" AS "category_id"
FROM store_sales AS "store_sales2",
item AS "item5",
date_dim AS "date_dim6"
WHERE "store_sales2"."ss_item_sk" = "item5"."i_item_sk" AND "store_sales2"."ss_sold_date_sk" = "date_dim6"."d_date_sk" AND "date_dim6"."d_year" >= 1999 AND "date_dim6"."d_year" <= 1999 + 2
INTERSECT
SELECT "item6"."i_brand_id", "item6"."i_class_id", "item6"."i_category_id"
FROM catalog_sales AS "catalog_sales2",
item AS "item6",
date_dim AS "date_dim7"
WHERE "catalog_sales2"."cs_item_sk" = "item6"."i_item_sk" AND "catalog_sales2"."cs_sold_date_sk" = "date_dim7"."d_date_sk" AND "date_dim7"."d_year" >= 1999 AND "date_dim7"."d_year" <= 1999 + 2) AS "t"
INTERSECT
SELECT "item7"."i_brand_id", "item7"."i_class_id", "item7"."i_category_id"
FROM web_sales AS "web_sales1",
item AS "item7",
date_dim AS "date_dim8"
WHERE "web_sales1"."ws_item_sk" = "item7"."i_item_sk" AND "web_sales1"."ws_sold_date_sk" = "date_dim8"."d_date_sk" AND "date_dim8"."d_year" >= 1999 AND "date_dim8"."d_year" <= 1999 + 2) AS "t51"
WHERE "item4"."i_brand_id" = "t51"."brand_id" AND "item4"."i_class_id" = "t51"."class_id" AND "item4"."i_category_id" = "t51"."category_id"
GROUP BY "item4"."i_item_sk") AS "t55" ON "catalog_sales1"."cs_item_sk" = "t55"."ss_item_sk") AS "t57"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_class_id", "i_category_id"
FROM item) AS "t58" ON "t57"."cs_item_sk" = "t58"."i_item_sk") AS "t59"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1999 + 2 AND "d_moy" = 11) AS "t62" ON "t59"."cs_sold_date_sk" = "t62"."d_date_sk"
GROUP BY "t59"."i_brand_id", "t59"."i_class_id", "t59"."i_category_id") AS "t64"
LEFT JOIN (SELECT CASE COUNT("average_sales") WHEN 0 THEN NULL WHEN 1 THEN "average_sales" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM (SELECT AVG("quantity" * "list_price") AS "average_sales"
FROM (SELECT *
FROM (SELECT "store_sales3"."ss_quantity" AS "quantity", "store_sales3"."ss_list_price" AS "list_price"
FROM store_sales AS "store_sales3",
date_dim AS "date_dim10"
WHERE "store_sales3"."ss_sold_date_sk" = "date_dim10"."d_date_sk" AND ("date_dim10"."d_year" >= 1999 AND "date_dim10"."d_year" <= 2001)
UNION ALL
SELECT "catalog_sales3"."cs_quantity" AS "quantity", "catalog_sales3"."cs_list_price" AS "list_price"
FROM catalog_sales AS "catalog_sales3",
date_dim AS "date_dim11"
WHERE "catalog_sales3"."cs_sold_date_sk" = "date_dim11"."d_date_sk" AND "date_dim11"."d_year" >= 1999 AND "date_dim11"."d_year" <= 1999 + 2) AS "t"
UNION ALL
SELECT "web_sales2"."ws_quantity" AS "quantity", "web_sales2"."ws_list_price" AS "list_price"
FROM web_sales AS "web_sales2",
date_dim AS "date_dim12"
WHERE "web_sales2"."ws_sold_date_sk" = "date_dim12"."d_date_sk" AND "date_dim12"."d_year" >= 1999 AND "date_dim12"."d_year" <= 1999 + 2) AS "t75") AS "t78") AS "t79" ON TRUE
WHERE "t64"."sales" > "t79"."$f0") AS "t"
UNION ALL
SELECT 'web' AS "channel", "t107"."i_brand_id", "t107"."i_class_id", "t107"."i_category_id", "t107"."sales", "t107"."number_sales"
FROM (SELECT "t102"."i_brand_id", "t102"."i_class_id", "t102"."i_category_id", SUM("t102"."*") AS "sales", COUNT(*) AS "number_sales"
FROM (SELECT "t100"."ws_sold_date_sk", "t101"."i_brand_id", "t101"."i_class_id", "t101"."i_category_id", "t100"."*" AS "*"
FROM (SELECT "web_sales3"."ws_sold_date_sk", "web_sales3"."ws_item_sk", "web_sales3"."ws_quantity" * "web_sales3"."ws_list_price" AS "*"
FROM web_sales AS "web_sales3"
INNER JOIN (SELECT "item9"."i_item_sk" AS "ss_item_sk"
FROM item AS "item9",
(SELECT *
FROM (SELECT "item10"."i_brand_id" AS "brand_id", "item10"."i_class_id" AS "class_id", "item10"."i_category_id" AS "category_id"
FROM store_sales AS "store_sales4",
item AS "item10",
date_dim AS "date_dim13"
WHERE "store_sales4"."ss_item_sk" = "item10"."i_item_sk" AND "store_sales4"."ss_sold_date_sk" = "date_dim13"."d_date_sk" AND "date_dim13"."d_year" >= 1999 AND "date_dim13"."d_year" <= 1999 + 2
INTERSECT
SELECT "item11"."i_brand_id", "item11"."i_class_id", "item11"."i_category_id"
FROM catalog_sales AS "catalog_sales4",
item AS "item11",
date_dim AS "date_dim14"
WHERE "catalog_sales4"."cs_item_sk" = "item11"."i_item_sk" AND "catalog_sales4"."cs_sold_date_sk" = "date_dim14"."d_date_sk" AND "date_dim14"."d_year" >= 1999 AND "date_dim14"."d_year" <= 1999 + 2) AS "t"
INTERSECT
SELECT "item12"."i_brand_id", "item12"."i_class_id", "item12"."i_category_id"
FROM web_sales AS "web_sales4",
item AS "item12",
date_dim AS "date_dim15"
WHERE "web_sales4"."ws_item_sk" = "item12"."i_item_sk" AND "web_sales4"."ws_sold_date_sk" = "date_dim15"."d_date_sk" AND "date_dim15"."d_year" >= 1999 AND "date_dim15"."d_year" <= 1999 + 2) AS "t94"
WHERE "item9"."i_brand_id" = "t94"."brand_id" AND "item9"."i_class_id" = "t94"."class_id" AND "item9"."i_category_id" = "t94"."category_id"
GROUP BY "item9"."i_item_sk") AS "t98" ON "web_sales3"."ws_item_sk" = "t98"."ss_item_sk") AS "t100"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_class_id", "i_category_id"
FROM item) AS "t101" ON "t100"."ws_item_sk" = "t101"."i_item_sk") AS "t102"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1999 + 2 AND "d_moy" = 11) AS "t105" ON "t102"."ws_sold_date_sk" = "t105"."d_date_sk"
GROUP BY "t102"."i_brand_id", "t102"."i_class_id", "t102"."i_category_id") AS "t107"
LEFT JOIN (SELECT CASE COUNT("average_sales") WHEN 0 THEN NULL WHEN 1 THEN "average_sales" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM (SELECT AVG("quantity" * "list_price") AS "average_sales"
FROM (SELECT *
FROM (SELECT "store_sales5"."ss_quantity" AS "quantity", "store_sales5"."ss_list_price" AS "list_price"
FROM store_sales AS "store_sales5",
date_dim AS "date_dim17"
WHERE "store_sales5"."ss_sold_date_sk" = "date_dim17"."d_date_sk" AND ("date_dim17"."d_year" >= 1999 AND "date_dim17"."d_year" <= 2001)
UNION ALL
SELECT "catalog_sales5"."cs_quantity" AS "quantity", "catalog_sales5"."cs_list_price" AS "list_price"
FROM catalog_sales AS "catalog_sales5",
date_dim AS "date_dim18"
WHERE "catalog_sales5"."cs_sold_date_sk" = "date_dim18"."d_date_sk" AND "date_dim18"."d_year" >= 1999 AND "date_dim18"."d_year" <= 1999 + 2) AS "t"
UNION ALL
SELECT "web_sales5"."ws_quantity" AS "quantity", "web_sales5"."ws_list_price" AS "list_price"
FROM web_sales AS "web_sales5",
date_dim AS "date_dim19"
WHERE "web_sales5"."ws_sold_date_sk" = "date_dim19"."d_date_sk" AND "date_dim19"."d_year" >= 1999 AND "date_dim19"."d_year" <= 1999 + 2) AS "t118") AS "t121") AS "t122" ON TRUE
WHERE "t107"."sales" > "t122"."$f0") AS "t126"
GROUP BY "channel", "i_brand_id", "i_class_id", "i_category_id"
UNION
SELECT "channel", "i_brand_id", "i_class_id", NULL AS "i_category_id", SUM("sum_sales") AS "EXPR$4", SUM("number_sales") AS "EXPR$5"
FROM (SELECT "channel", "i_brand_id", "i_class_id", SUM("sales") AS "sum_sales", SUM("number_sales") AS "number_sales"
FROM (SELECT *
FROM (SELECT 'store' AS "channel", "t152"."i_brand_id", "t152"."i_class_id", "t152"."i_category_id", "t152"."sales", "t152"."number_sales"
FROM (SELECT "t147"."i_brand_id", "t147"."i_class_id", "t147"."i_category_id", SUM("t147"."*") AS "sales", COUNT(*) AS "number_sales"
FROM (SELECT "t145"."ss_sold_date_sk", "t146"."i_brand_id", "t146"."i_class_id", "t146"."i_category_id", "t145"."*" AS "*"
FROM (SELECT "store_sales6"."ss_sold_date_sk", "store_sales6"."ss_item_sk", "store_sales6"."ss_quantity" * "store_sales6"."ss_list_price" AS "*"
FROM store_sales AS "store_sales6"
INNER JOIN (SELECT "item14"."i_item_sk" AS "ss_item_sk"
FROM item AS "item14",
(SELECT *
FROM (SELECT "item15"."i_brand_id" AS "brand_id", "item15"."i_class_id" AS "class_id", "item15"."i_category_id" AS "category_id"
FROM store_sales AS "store_sales7",
item AS "item15",
date_dim AS "date_dim20"
WHERE "store_sales7"."ss_item_sk" = "item15"."i_item_sk" AND "store_sales7"."ss_sold_date_sk" = "date_dim20"."d_date_sk" AND "date_dim20"."d_year" >= 1999 AND "date_dim20"."d_year" <= 1999 + 2
INTERSECT
SELECT "item16"."i_brand_id", "item16"."i_class_id", "item16"."i_category_id"
FROM catalog_sales AS "catalog_sales6",
item AS "item16",
date_dim AS "date_dim21"
WHERE "catalog_sales6"."cs_item_sk" = "item16"."i_item_sk" AND "catalog_sales6"."cs_sold_date_sk" = "date_dim21"."d_date_sk" AND "date_dim21"."d_year" >= 1999 AND "date_dim21"."d_year" <= 1999 + 2) AS "t"
INTERSECT
SELECT "item17"."i_brand_id", "item17"."i_class_id", "item17"."i_category_id"
FROM web_sales AS "web_sales6",
item AS "item17",
date_dim AS "date_dim22"
WHERE "web_sales6"."ws_item_sk" = "item17"."i_item_sk" AND "web_sales6"."ws_sold_date_sk" = "date_dim22"."d_date_sk" AND "date_dim22"."d_year" >= 1999 AND "date_dim22"."d_year" <= 1999 + 2) AS "t139"
WHERE "item14"."i_brand_id" = "t139"."brand_id" AND "item14"."i_class_id" = "t139"."class_id" AND "item14"."i_category_id" = "t139"."category_id"
GROUP BY "item14"."i_item_sk") AS "t143" ON "store_sales6"."ss_item_sk" = "t143"."ss_item_sk") AS "t145"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_class_id", "i_category_id"
FROM item) AS "t146" ON "t145"."ss_item_sk" = "t146"."i_item_sk") AS "t147"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1999 + 2 AND "d_moy" = 11) AS "t150" ON "t147"."ss_sold_date_sk" = "t150"."d_date_sk"
GROUP BY "t147"."i_brand_id", "t147"."i_class_id", "t147"."i_category_id") AS "t152"
LEFT JOIN (SELECT CASE COUNT("average_sales") WHEN 0 THEN NULL WHEN 1 THEN "average_sales" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM (SELECT AVG("quantity" * "list_price") AS "average_sales"
FROM (SELECT *
FROM (SELECT "store_sales8"."ss_quantity" AS "quantity", "store_sales8"."ss_list_price" AS "list_price"
FROM store_sales AS "store_sales8",
date_dim AS "date_dim24"
WHERE "store_sales8"."ss_sold_date_sk" = "date_dim24"."d_date_sk" AND ("date_dim24"."d_year" >= 1999 AND "date_dim24"."d_year" <= 2001)
UNION ALL
SELECT "catalog_sales7"."cs_quantity" AS "quantity", "catalog_sales7"."cs_list_price" AS "list_price"
FROM catalog_sales AS "catalog_sales7",
date_dim AS "date_dim25"
WHERE "catalog_sales7"."cs_sold_date_sk" = "date_dim25"."d_date_sk" AND "date_dim25"."d_year" >= 1999 AND "date_dim25"."d_year" <= 1999 + 2) AS "t"
UNION ALL
SELECT "web_sales7"."ws_quantity" AS "quantity", "web_sales7"."ws_list_price" AS "list_price"
FROM web_sales AS "web_sales7",
date_dim AS "date_dim26"
WHERE "web_sales7"."ws_sold_date_sk" = "date_dim26"."d_date_sk" AND "date_dim26"."d_year" >= 1999 AND "date_dim26"."d_year" <= 1999 + 2) AS "t163") AS "t166") AS "t167" ON TRUE
WHERE "t152"."sales" > "t167"."$f0"
UNION ALL
SELECT 'catalog' AS "channel", "t194"."i_brand_id", "t194"."i_class_id", "t194"."i_category_id", "t194"."sales", "t194"."number_sales"
FROM (SELECT "t189"."i_brand_id", "t189"."i_class_id", "t189"."i_category_id", SUM("t189"."*") AS "sales", COUNT(*) AS "number_sales"
FROM (SELECT "t187"."cs_sold_date_sk", "t188"."i_brand_id", "t188"."i_class_id", "t188"."i_category_id", "t187"."*" AS "*"
FROM (SELECT "catalog_sales8"."cs_sold_date_sk", "catalog_sales8"."cs_item_sk", "catalog_sales8"."cs_quantity" * "catalog_sales8"."cs_list_price" AS "*"
FROM catalog_sales AS "catalog_sales8"
INNER JOIN (SELECT "item19"."i_item_sk" AS "ss_item_sk"
FROM item AS "item19",
(SELECT *
FROM (SELECT "item20"."i_brand_id" AS "brand_id", "item20"."i_class_id" AS "class_id", "item20"."i_category_id" AS "category_id"
FROM store_sales AS "store_sales9",
item AS "item20",
date_dim AS "date_dim27"
WHERE "store_sales9"."ss_item_sk" = "item20"."i_item_sk" AND "store_sales9"."ss_sold_date_sk" = "date_dim27"."d_date_sk" AND "date_dim27"."d_year" >= 1999 AND "date_dim27"."d_year" <= 1999 + 2
INTERSECT
SELECT "item21"."i_brand_id", "item21"."i_class_id", "item21"."i_category_id"
FROM catalog_sales AS "catalog_sales9",
item AS "item21",
date_dim AS "date_dim28"
WHERE "catalog_sales9"."cs_item_sk" = "item21"."i_item_sk" AND "catalog_sales9"."cs_sold_date_sk" = "date_dim28"."d_date_sk" AND "date_dim28"."d_year" >= 1999 AND "date_dim28"."d_year" <= 1999 + 2) AS "t"
INTERSECT
SELECT "item22"."i_brand_id", "item22"."i_class_id", "item22"."i_category_id"
FROM web_sales AS "web_sales8",
item AS "item22",
date_dim AS "date_dim29"
WHERE "web_sales8"."ws_item_sk" = "item22"."i_item_sk" AND "web_sales8"."ws_sold_date_sk" = "date_dim29"."d_date_sk" AND "date_dim29"."d_year" >= 1999 AND "date_dim29"."d_year" <= 1999 + 2) AS "t181"
WHERE "item19"."i_brand_id" = "t181"."brand_id" AND "item19"."i_class_id" = "t181"."class_id" AND "item19"."i_category_id" = "t181"."category_id"
GROUP BY "item19"."i_item_sk") AS "t185" ON "catalog_sales8"."cs_item_sk" = "t185"."ss_item_sk") AS "t187"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_class_id", "i_category_id"
FROM item) AS "t188" ON "t187"."cs_item_sk" = "t188"."i_item_sk") AS "t189"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1999 + 2 AND "d_moy" = 11) AS "t192" ON "t189"."cs_sold_date_sk" = "t192"."d_date_sk"
GROUP BY "t189"."i_brand_id", "t189"."i_class_id", "t189"."i_category_id") AS "t194"
LEFT JOIN (SELECT CASE COUNT("average_sales") WHEN 0 THEN NULL WHEN 1 THEN "average_sales" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM (SELECT AVG("quantity" * "list_price") AS "average_sales"
FROM (SELECT *
FROM (SELECT "store_sales10"."ss_quantity" AS "quantity", "store_sales10"."ss_list_price" AS "list_price"
FROM store_sales AS "store_sales10",
date_dim AS "date_dim31"
WHERE "store_sales10"."ss_sold_date_sk" = "date_dim31"."d_date_sk" AND ("date_dim31"."d_year" >= 1999 AND "date_dim31"."d_year" <= 2001)
UNION ALL
SELECT "catalog_sales10"."cs_quantity" AS "quantity", "catalog_sales10"."cs_list_price" AS "list_price"
FROM catalog_sales AS "catalog_sales10",
date_dim AS "date_dim32"
WHERE "catalog_sales10"."cs_sold_date_sk" = "date_dim32"."d_date_sk" AND "date_dim32"."d_year" >= 1999 AND "date_dim32"."d_year" <= 1999 + 2) AS "t"
UNION ALL
SELECT "web_sales9"."ws_quantity" AS "quantity", "web_sales9"."ws_list_price" AS "list_price"
FROM web_sales AS "web_sales9",
date_dim AS "date_dim33"
WHERE "web_sales9"."ws_sold_date_sk" = "date_dim33"."d_date_sk" AND "date_dim33"."d_year" >= 1999 AND "date_dim33"."d_year" <= 1999 + 2) AS "t205") AS "t208") AS "t209" ON TRUE
WHERE "t194"."sales" > "t209"."$f0") AS "t"
UNION ALL
SELECT 'web' AS "channel", "t237"."i_brand_id", "t237"."i_class_id", "t237"."i_category_id", "t237"."sales", "t237"."number_sales"
FROM (SELECT "t232"."i_brand_id", "t232"."i_class_id", "t232"."i_category_id", SUM("t232"."*") AS "sales", COUNT(*) AS "number_sales"
FROM (SELECT "t230"."ws_sold_date_sk", "t231"."i_brand_id", "t231"."i_class_id", "t231"."i_category_id", "t230"."*" AS "*"
FROM (SELECT "web_sales10"."ws_sold_date_sk", "web_sales10"."ws_item_sk", "web_sales10"."ws_quantity" * "web_sales10"."ws_list_price" AS "*"
FROM web_sales AS "web_sales10"
INNER JOIN (SELECT "item24"."i_item_sk" AS "ss_item_sk"
FROM item AS "item24",
(SELECT *
FROM (SELECT "item25"."i_brand_id" AS "brand_id", "item25"."i_class_id" AS "class_id", "item25"."i_category_id" AS "category_id"
FROM store_sales AS "store_sales11",
item AS "item25",
date_dim AS "date_dim34"
WHERE "store_sales11"."ss_item_sk" = "item25"."i_item_sk" AND "store_sales11"."ss_sold_date_sk" = "date_dim34"."d_date_sk" AND "date_dim34"."d_year" >= 1999 AND "date_dim34"."d_year" <= 1999 + 2
INTERSECT
SELECT "item26"."i_brand_id", "item26"."i_class_id", "item26"."i_category_id"
FROM catalog_sales AS "catalog_sales11",
item AS "item26",
date_dim AS "date_dim35"
WHERE "catalog_sales11"."cs_item_sk" = "item26"."i_item_sk" AND "catalog_sales11"."cs_sold_date_sk" = "date_dim35"."d_date_sk" AND "date_dim35"."d_year" >= 1999 AND "date_dim35"."d_year" <= 1999 + 2) AS "t"
INTERSECT
SELECT "item27"."i_brand_id", "item27"."i_class_id", "item27"."i_category_id"
FROM web_sales AS "web_sales11",
item AS "item27",
date_dim AS "date_dim36"
WHERE "web_sales11"."ws_item_sk" = "item27"."i_item_sk" AND "web_sales11"."ws_sold_date_sk" = "date_dim36"."d_date_sk" AND "date_dim36"."d_year" >= 1999 AND "date_dim36"."d_year" <= 1999 + 2) AS "t224"
WHERE "item24"."i_brand_id" = "t224"."brand_id" AND "item24"."i_class_id" = "t224"."class_id" AND "item24"."i_category_id" = "t224"."category_id"
GROUP BY "item24"."i_item_sk") AS "t228" ON "web_sales10"."ws_item_sk" = "t228"."ss_item_sk") AS "t230"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_class_id", "i_category_id"
FROM item) AS "t231" ON "t230"."ws_item_sk" = "t231"."i_item_sk") AS "t232"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1999 + 2 AND "d_moy" = 11) AS "t235" ON "t232"."ws_sold_date_sk" = "t235"."d_date_sk"
GROUP BY "t232"."i_brand_id", "t232"."i_class_id", "t232"."i_category_id") AS "t237"
LEFT JOIN (SELECT CASE COUNT("average_sales") WHEN 0 THEN NULL WHEN 1 THEN "average_sales" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM (SELECT AVG("quantity" * "list_price") AS "average_sales"
FROM (SELECT *
FROM (SELECT "store_sales12"."ss_quantity" AS "quantity", "store_sales12"."ss_list_price" AS "list_price"
FROM store_sales AS "store_sales12",
date_dim AS "date_dim38"
WHERE "store_sales12"."ss_sold_date_sk" = "date_dim38"."d_date_sk" AND ("date_dim38"."d_year" >= 1999 AND "date_dim38"."d_year" <= 2001)
UNION ALL
SELECT "catalog_sales12"."cs_quantity" AS "quantity", "catalog_sales12"."cs_list_price" AS "list_price"
FROM catalog_sales AS "catalog_sales12",
date_dim AS "date_dim39"
WHERE "catalog_sales12"."cs_sold_date_sk" = "date_dim39"."d_date_sk" AND "date_dim39"."d_year" >= 1999 AND "date_dim39"."d_year" <= 1999 + 2) AS "t"
UNION ALL
SELECT "web_sales12"."ws_quantity" AS "quantity", "web_sales12"."ws_list_price" AS "list_price"
FROM web_sales AS "web_sales12",
date_dim AS "date_dim40"
WHERE "web_sales12"."ws_sold_date_sk" = "date_dim40"."d_date_sk" AND "date_dim40"."d_year" >= 1999 AND "date_dim40"."d_year" <= 1999 + 2) AS "t248") AS "t251") AS "t252" ON TRUE
WHERE "t237"."sales" > "t252"."$f0") AS "t256"
GROUP BY "channel", "i_brand_id", "i_class_id", "i_category_id") AS "t258"
GROUP BY "channel", "i_brand_id", "i_class_id") AS "t"
UNION
SELECT "channel", "i_brand_id", NULL AS "i_class_id", NULL AS "i_category_id", SUM("sum_sales") AS "EXPR$4", SUM("number_sales") AS "EXPR$5"
FROM (SELECT "channel", "i_brand_id", SUM("sales") AS "sum_sales", SUM("number_sales") AS "number_sales"
FROM (SELECT *
FROM (SELECT 'store' AS "channel", "t285"."i_brand_id", "t285"."i_class_id", "t285"."i_category_id", "t285"."sales", "t285"."number_sales"
FROM (SELECT "t280"."i_brand_id", "t280"."i_class_id", "t280"."i_category_id", SUM("t280"."*") AS "sales", COUNT(*) AS "number_sales"
FROM (SELECT "t278"."ss_sold_date_sk", "t279"."i_brand_id", "t279"."i_class_id", "t279"."i_category_id", "t278"."*" AS "*"
FROM (SELECT "store_sales13"."ss_sold_date_sk", "store_sales13"."ss_item_sk", "store_sales13"."ss_quantity" * "store_sales13"."ss_list_price" AS "*"
FROM store_sales AS "store_sales13"
INNER JOIN (SELECT "item29"."i_item_sk" AS "ss_item_sk"
FROM item AS "item29",
(SELECT *
FROM (SELECT "item30"."i_brand_id" AS "brand_id", "item30"."i_class_id" AS "class_id", "item30"."i_category_id" AS "category_id"
FROM store_sales AS "store_sales14",
item AS "item30",
date_dim AS "date_dim41"
WHERE "store_sales14"."ss_item_sk" = "item30"."i_item_sk" AND "store_sales14"."ss_sold_date_sk" = "date_dim41"."d_date_sk" AND "date_dim41"."d_year" >= 1999 AND "date_dim41"."d_year" <= 1999 + 2
INTERSECT
SELECT "item31"."i_brand_id", "item31"."i_class_id", "item31"."i_category_id"
FROM catalog_sales AS "catalog_sales13",
item AS "item31",
date_dim AS "date_dim42"
WHERE "catalog_sales13"."cs_item_sk" = "item31"."i_item_sk" AND "catalog_sales13"."cs_sold_date_sk" = "date_dim42"."d_date_sk" AND "date_dim42"."d_year" >= 1999 AND "date_dim42"."d_year" <= 1999 + 2) AS "t"
INTERSECT
SELECT "item32"."i_brand_id", "item32"."i_class_id", "item32"."i_category_id"
FROM web_sales AS "web_sales13",
item AS "item32",
date_dim AS "date_dim43"
WHERE "web_sales13"."ws_item_sk" = "item32"."i_item_sk" AND "web_sales13"."ws_sold_date_sk" = "date_dim43"."d_date_sk" AND "date_dim43"."d_year" >= 1999 AND "date_dim43"."d_year" <= 1999 + 2) AS "t272"
WHERE "item29"."i_brand_id" = "t272"."brand_id" AND "item29"."i_class_id" = "t272"."class_id" AND "item29"."i_category_id" = "t272"."category_id"
GROUP BY "item29"."i_item_sk") AS "t276" ON "store_sales13"."ss_item_sk" = "t276"."ss_item_sk") AS "t278"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_class_id", "i_category_id"
FROM item) AS "t279" ON "t278"."ss_item_sk" = "t279"."i_item_sk") AS "t280"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1999 + 2 AND "d_moy" = 11) AS "t283" ON "t280"."ss_sold_date_sk" = "t283"."d_date_sk"
GROUP BY "t280"."i_brand_id", "t280"."i_class_id", "t280"."i_category_id") AS "t285"
LEFT JOIN (SELECT CASE COUNT("average_sales") WHEN 0 THEN NULL WHEN 1 THEN "average_sales" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM (SELECT AVG("quantity" * "list_price") AS "average_sales"
FROM (SELECT *
FROM (SELECT "store_sales15"."ss_quantity" AS "quantity", "store_sales15"."ss_list_price" AS "list_price"
FROM store_sales AS "store_sales15",
date_dim AS "date_dim45"
WHERE "store_sales15"."ss_sold_date_sk" = "date_dim45"."d_date_sk" AND ("date_dim45"."d_year" >= 1999 AND "date_dim45"."d_year" <= 2001)
UNION ALL
SELECT "catalog_sales14"."cs_quantity" AS "quantity", "catalog_sales14"."cs_list_price" AS "list_price"
FROM catalog_sales AS "catalog_sales14",
date_dim AS "date_dim46"
WHERE "catalog_sales14"."cs_sold_date_sk" = "date_dim46"."d_date_sk" AND "date_dim46"."d_year" >= 1999 AND "date_dim46"."d_year" <= 1999 + 2) AS "t"
UNION ALL
SELECT "web_sales14"."ws_quantity" AS "quantity", "web_sales14"."ws_list_price" AS "list_price"
FROM web_sales AS "web_sales14",
date_dim AS "date_dim47"
WHERE "web_sales14"."ws_sold_date_sk" = "date_dim47"."d_date_sk" AND "date_dim47"."d_year" >= 1999 AND "date_dim47"."d_year" <= 1999 + 2) AS "t296") AS "t299") AS "t300" ON TRUE
WHERE "t285"."sales" > "t300"."$f0"
UNION ALL
SELECT 'catalog' AS "channel", "t327"."i_brand_id", "t327"."i_class_id", "t327"."i_category_id", "t327"."sales", "t327"."number_sales"
FROM (SELECT "t322"."i_brand_id", "t322"."i_class_id", "t322"."i_category_id", SUM("t322"."*") AS "sales", COUNT(*) AS "number_sales"
FROM (SELECT "t320"."cs_sold_date_sk", "t321"."i_brand_id", "t321"."i_class_id", "t321"."i_category_id", "t320"."*" AS "*"
FROM (SELECT "catalog_sales15"."cs_sold_date_sk", "catalog_sales15"."cs_item_sk", "catalog_sales15"."cs_quantity" * "catalog_sales15"."cs_list_price" AS "*"
FROM catalog_sales AS "catalog_sales15"
INNER JOIN (SELECT "item34"."i_item_sk" AS "ss_item_sk"
FROM item AS "item34",
(SELECT *
FROM (SELECT "item35"."i_brand_id" AS "brand_id", "item35"."i_class_id" AS "class_id", "item35"."i_category_id" AS "category_id"
FROM store_sales AS "store_sales16",
item AS "item35",
date_dim AS "date_dim48"
WHERE "store_sales16"."ss_item_sk" = "item35"."i_item_sk" AND "store_sales16"."ss_sold_date_sk" = "date_dim48"."d_date_sk" AND "date_dim48"."d_year" >= 1999 AND "date_dim48"."d_year" <= 1999 + 2
INTERSECT
SELECT "item36"."i_brand_id", "item36"."i_class_id", "item36"."i_category_id"
FROM catalog_sales AS "catalog_sales16",
item AS "item36",
date_dim AS "date_dim49"
WHERE "catalog_sales16"."cs_item_sk" = "item36"."i_item_sk" AND "catalog_sales16"."cs_sold_date_sk" = "date_dim49"."d_date_sk" AND "date_dim49"."d_year" >= 1999 AND "date_dim49"."d_year" <= 1999 + 2) AS "t"
INTERSECT
SELECT "item37"."i_brand_id", "item37"."i_class_id", "item37"."i_category_id"
FROM web_sales AS "web_sales15",
item AS "item37",
date_dim AS "date_dim50"
WHERE "web_sales15"."ws_item_sk" = "item37"."i_item_sk" AND "web_sales15"."ws_sold_date_sk" = "date_dim50"."d_date_sk" AND "date_dim50"."d_year" >= 1999 AND "date_dim50"."d_year" <= 1999 + 2) AS "t314"
WHERE "item34"."i_brand_id" = "t314"."brand_id" AND "item34"."i_class_id" = "t314"."class_id" AND "item34"."i_category_id" = "t314"."category_id"
GROUP BY "item34"."i_item_sk") AS "t318" ON "catalog_sales15"."cs_item_sk" = "t318"."ss_item_sk") AS "t320"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_class_id", "i_category_id"
FROM item) AS "t321" ON "t320"."cs_item_sk" = "t321"."i_item_sk") AS "t322"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1999 + 2 AND "d_moy" = 11) AS "t325" ON "t322"."cs_sold_date_sk" = "t325"."d_date_sk"
GROUP BY "t322"."i_brand_id", "t322"."i_class_id", "t322"."i_category_id") AS "t327"
LEFT JOIN (SELECT CASE COUNT("average_sales") WHEN 0 THEN NULL WHEN 1 THEN "average_sales" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM (SELECT AVG("quantity" * "list_price") AS "average_sales"
FROM (SELECT *
FROM (SELECT "store_sales17"."ss_quantity" AS "quantity", "store_sales17"."ss_list_price" AS "list_price"
FROM store_sales AS "store_sales17",
date_dim AS "date_dim52"
WHERE "store_sales17"."ss_sold_date_sk" = "date_dim52"."d_date_sk" AND ("date_dim52"."d_year" >= 1999 AND "date_dim52"."d_year" <= 2001)
UNION ALL
SELECT "catalog_sales17"."cs_quantity" AS "quantity", "catalog_sales17"."cs_list_price" AS "list_price"
FROM catalog_sales AS "catalog_sales17",
date_dim AS "date_dim53"
WHERE "catalog_sales17"."cs_sold_date_sk" = "date_dim53"."d_date_sk" AND "date_dim53"."d_year" >= 1999 AND "date_dim53"."d_year" <= 1999 + 2) AS "t"
UNION ALL
SELECT "web_sales16"."ws_quantity" AS "quantity", "web_sales16"."ws_list_price" AS "list_price"
FROM web_sales AS "web_sales16",
date_dim AS "date_dim54"
WHERE "web_sales16"."ws_sold_date_sk" = "date_dim54"."d_date_sk" AND "date_dim54"."d_year" >= 1999 AND "date_dim54"."d_year" <= 1999 + 2) AS "t338") AS "t341") AS "t342" ON TRUE
WHERE "t327"."sales" > "t342"."$f0") AS "t"
UNION ALL
SELECT 'web' AS "channel", "t370"."i_brand_id", "t370"."i_class_id", "t370"."i_category_id", "t370"."sales", "t370"."number_sales"
FROM (SELECT "t365"."i_brand_id", "t365"."i_class_id", "t365"."i_category_id", SUM("t365"."*") AS "sales", COUNT(*) AS "number_sales"
FROM (SELECT "t363"."ws_sold_date_sk", "t364"."i_brand_id", "t364"."i_class_id", "t364"."i_category_id", "t363"."*" AS "*"
FROM (SELECT "web_sales17"."ws_sold_date_sk", "web_sales17"."ws_item_sk", "web_sales17"."ws_quantity" * "web_sales17"."ws_list_price" AS "*"
FROM web_sales AS "web_sales17"
INNER JOIN (SELECT "item39"."i_item_sk" AS "ss_item_sk"
FROM item AS "item39",
(SELECT *
FROM (SELECT "item40"."i_brand_id" AS "brand_id", "item40"."i_class_id" AS "class_id", "item40"."i_category_id" AS "category_id"
FROM store_sales AS "store_sales18",
item AS "item40",
date_dim AS "date_dim55"
WHERE "store_sales18"."ss_item_sk" = "item40"."i_item_sk" AND "store_sales18"."ss_sold_date_sk" = "date_dim55"."d_date_sk" AND "date_dim55"."d_year" >= 1999 AND "date_dim55"."d_year" <= 1999 + 2
INTERSECT
SELECT "item41"."i_brand_id", "item41"."i_class_id", "item41"."i_category_id"
FROM catalog_sales AS "catalog_sales18",
item AS "item41",
date_dim AS "date_dim56"
WHERE "catalog_sales18"."cs_item_sk" = "item41"."i_item_sk" AND "catalog_sales18"."cs_sold_date_sk" = "date_dim56"."d_date_sk" AND "date_dim56"."d_year" >= 1999 AND "date_dim56"."d_year" <= 1999 + 2) AS "t"
INTERSECT
SELECT "item42"."i_brand_id", "item42"."i_class_id", "item42"."i_category_id"
FROM web_sales AS "web_sales18",
item AS "item42",
date_dim AS "date_dim57"
WHERE "web_sales18"."ws_item_sk" = "item42"."i_item_sk" AND "web_sales18"."ws_sold_date_sk" = "date_dim57"."d_date_sk" AND "date_dim57"."d_year" >= 1999 AND "date_dim57"."d_year" <= 1999 + 2) AS "t357"
WHERE "item39"."i_brand_id" = "t357"."brand_id" AND "item39"."i_class_id" = "t357"."class_id" AND "item39"."i_category_id" = "t357"."category_id"
GROUP BY "item39"."i_item_sk") AS "t361" ON "web_sales17"."ws_item_sk" = "t361"."ss_item_sk") AS "t363"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_class_id", "i_category_id"
FROM item) AS "t364" ON "t363"."ws_item_sk" = "t364"."i_item_sk") AS "t365"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1999 + 2 AND "d_moy" = 11) AS "t368" ON "t365"."ws_sold_date_sk" = "t368"."d_date_sk"
GROUP BY "t365"."i_brand_id", "t365"."i_class_id", "t365"."i_category_id") AS "t370"
LEFT JOIN (SELECT CASE COUNT("average_sales") WHEN 0 THEN NULL WHEN 1 THEN "average_sales" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM (SELECT AVG("quantity" * "list_price") AS "average_sales"
FROM (SELECT *
FROM (SELECT "store_sales19"."ss_quantity" AS "quantity", "store_sales19"."ss_list_price" AS "list_price"
FROM store_sales AS "store_sales19",
date_dim AS "date_dim59"
WHERE "store_sales19"."ss_sold_date_sk" = "date_dim59"."d_date_sk" AND ("date_dim59"."d_year" >= 1999 AND "date_dim59"."d_year" <= 2001)
UNION ALL
SELECT "catalog_sales19"."cs_quantity" AS "quantity", "catalog_sales19"."cs_list_price" AS "list_price"
FROM catalog_sales AS "catalog_sales19",
date_dim AS "date_dim60"
WHERE "catalog_sales19"."cs_sold_date_sk" = "date_dim60"."d_date_sk" AND "date_dim60"."d_year" >= 1999 AND "date_dim60"."d_year" <= 1999 + 2) AS "t"
UNION ALL
SELECT "web_sales19"."ws_quantity" AS "quantity", "web_sales19"."ws_list_price" AS "list_price"
FROM web_sales AS "web_sales19",
date_dim AS "date_dim61"
WHERE "web_sales19"."ws_sold_date_sk" = "date_dim61"."d_date_sk" AND "date_dim61"."d_year" >= 1999 AND "date_dim61"."d_year" <= 1999 + 2) AS "t381") AS "t384") AS "t385" ON TRUE
WHERE "t370"."sales" > "t385"."$f0") AS "t389"
GROUP BY "channel", "i_brand_id", "i_class_id", "i_category_id") AS "t391"
GROUP BY "channel", "i_brand_id") AS "t"
UNION
SELECT "channel", NULL AS "i_brand_id", NULL AS "i_class_id", NULL AS "i_category_id", SUM("sum_sales") AS "EXPR$4", SUM("number_sales") AS "EXPR$5"
FROM (SELECT "channel", SUM("sales") AS "sum_sales", SUM("number_sales") AS "number_sales"
FROM (SELECT *
FROM (SELECT 'store' AS "channel", "t418"."i_brand_id", "t418"."i_class_id", "t418"."i_category_id", "t418"."sales", "t418"."number_sales"
FROM (SELECT "t413"."i_brand_id", "t413"."i_class_id", "t413"."i_category_id", SUM("t413"."*") AS "sales", COUNT(*) AS "number_sales"
FROM (SELECT "t411"."ss_sold_date_sk", "t412"."i_brand_id", "t412"."i_class_id", "t412"."i_category_id", "t411"."*" AS "*"
FROM (SELECT "store_sales20"."ss_sold_date_sk", "store_sales20"."ss_item_sk", "store_sales20"."ss_quantity" * "store_sales20"."ss_list_price" AS "*"
FROM store_sales AS "store_sales20"
INNER JOIN (SELECT "item44"."i_item_sk" AS "ss_item_sk"
FROM item AS "item44",
(SELECT *
FROM (SELECT "item45"."i_brand_id" AS "brand_id", "item45"."i_class_id" AS "class_id", "item45"."i_category_id" AS "category_id"
FROM store_sales AS "store_sales21",
item AS "item45",
date_dim AS "date_dim62"
WHERE "store_sales21"."ss_item_sk" = "item45"."i_item_sk" AND "store_sales21"."ss_sold_date_sk" = "date_dim62"."d_date_sk" AND "date_dim62"."d_year" >= 1999 AND "date_dim62"."d_year" <= 1999 + 2
INTERSECT
SELECT "item46"."i_brand_id", "item46"."i_class_id", "item46"."i_category_id"
FROM catalog_sales AS "catalog_sales20",
item AS "item46",
date_dim AS "date_dim63"
WHERE "catalog_sales20"."cs_item_sk" = "item46"."i_item_sk" AND "catalog_sales20"."cs_sold_date_sk" = "date_dim63"."d_date_sk" AND "date_dim63"."d_year" >= 1999 AND "date_dim63"."d_year" <= 1999 + 2) AS "t"
INTERSECT
SELECT "item47"."i_brand_id", "item47"."i_class_id", "item47"."i_category_id"
FROM web_sales AS "web_sales20",
item AS "item47",
date_dim AS "date_dim64"
WHERE "web_sales20"."ws_item_sk" = "item47"."i_item_sk" AND "web_sales20"."ws_sold_date_sk" = "date_dim64"."d_date_sk" AND "date_dim64"."d_year" >= 1999 AND "date_dim64"."d_year" <= 1999 + 2) AS "t405"
WHERE "item44"."i_brand_id" = "t405"."brand_id" AND "item44"."i_class_id" = "t405"."class_id" AND "item44"."i_category_id" = "t405"."category_id"
GROUP BY "item44"."i_item_sk") AS "t409" ON "store_sales20"."ss_item_sk" = "t409"."ss_item_sk") AS "t411"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_class_id", "i_category_id"
FROM item) AS "t412" ON "t411"."ss_item_sk" = "t412"."i_item_sk") AS "t413"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1999 + 2 AND "d_moy" = 11) AS "t416" ON "t413"."ss_sold_date_sk" = "t416"."d_date_sk"
GROUP BY "t413"."i_brand_id", "t413"."i_class_id", "t413"."i_category_id") AS "t418"
LEFT JOIN (SELECT CASE COUNT("average_sales") WHEN 0 THEN NULL WHEN 1 THEN "average_sales" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM (SELECT AVG("quantity" * "list_price") AS "average_sales"
FROM (SELECT *
FROM (SELECT "store_sales22"."ss_quantity" AS "quantity", "store_sales22"."ss_list_price" AS "list_price"
FROM store_sales AS "store_sales22",
date_dim AS "date_dim66"
WHERE "store_sales22"."ss_sold_date_sk" = "date_dim66"."d_date_sk" AND ("date_dim66"."d_year" >= 1999 AND "date_dim66"."d_year" <= 2001)
UNION ALL
SELECT "catalog_sales21"."cs_quantity" AS "quantity", "catalog_sales21"."cs_list_price" AS "list_price"
FROM catalog_sales AS "catalog_sales21",
date_dim AS "date_dim67"
WHERE "catalog_sales21"."cs_sold_date_sk" = "date_dim67"."d_date_sk" AND "date_dim67"."d_year" >= 1999 AND "date_dim67"."d_year" <= 1999 + 2) AS "t"
UNION ALL
SELECT "web_sales21"."ws_quantity" AS "quantity", "web_sales21"."ws_list_price" AS "list_price"
FROM web_sales AS "web_sales21",
date_dim AS "date_dim68"
WHERE "web_sales21"."ws_sold_date_sk" = "date_dim68"."d_date_sk" AND "date_dim68"."d_year" >= 1999 AND "date_dim68"."d_year" <= 1999 + 2) AS "t429") AS "t432") AS "t433" ON TRUE
WHERE "t418"."sales" > "t433"."$f0"
UNION ALL
SELECT 'catalog' AS "channel", "t460"."i_brand_id", "t460"."i_class_id", "t460"."i_category_id", "t460"."sales", "t460"."number_sales"
FROM (SELECT "t455"."i_brand_id", "t455"."i_class_id", "t455"."i_category_id", SUM("t455"."*") AS "sales", COUNT(*) AS "number_sales"
FROM (SELECT "t453"."cs_sold_date_sk", "t454"."i_brand_id", "t454"."i_class_id", "t454"."i_category_id", "t453"."*" AS "*"
FROM (SELECT "catalog_sales22"."cs_sold_date_sk", "catalog_sales22"."cs_item_sk", "catalog_sales22"."cs_quantity" * "catalog_sales22"."cs_list_price" AS "*"
FROM catalog_sales AS "catalog_sales22"
INNER JOIN (SELECT "item49"."i_item_sk" AS "ss_item_sk"
FROM item AS "item49",
(SELECT *
FROM (SELECT "item50"."i_brand_id" AS "brand_id", "item50"."i_class_id" AS "class_id", "item50"."i_category_id" AS "category_id"
FROM store_sales AS "store_sales23",
item AS "item50",
date_dim AS "date_dim69"
WHERE "store_sales23"."ss_item_sk" = "item50"."i_item_sk" AND "store_sales23"."ss_sold_date_sk" = "date_dim69"."d_date_sk" AND "date_dim69"."d_year" >= 1999 AND "date_dim69"."d_year" <= 1999 + 2
INTERSECT
SELECT "item51"."i_brand_id", "item51"."i_class_id", "item51"."i_category_id"
FROM catalog_sales AS "catalog_sales23",
item AS "item51",
date_dim AS "date_dim70"
WHERE "catalog_sales23"."cs_item_sk" = "item51"."i_item_sk" AND "catalog_sales23"."cs_sold_date_sk" = "date_dim70"."d_date_sk" AND "date_dim70"."d_year" >= 1999 AND "date_dim70"."d_year" <= 1999 + 2) AS "t"
INTERSECT
SELECT "item52"."i_brand_id", "item52"."i_class_id", "item52"."i_category_id"
FROM web_sales AS "web_sales22",
item AS "item52",
date_dim AS "date_dim71"
WHERE "web_sales22"."ws_item_sk" = "item52"."i_item_sk" AND "web_sales22"."ws_sold_date_sk" = "date_dim71"."d_date_sk" AND "date_dim71"."d_year" >= 1999 AND "date_dim71"."d_year" <= 1999 + 2) AS "t447"
WHERE "item49"."i_brand_id" = "t447"."brand_id" AND "item49"."i_class_id" = "t447"."class_id" AND "item49"."i_category_id" = "t447"."category_id"
GROUP BY "item49"."i_item_sk") AS "t451" ON "catalog_sales22"."cs_item_sk" = "t451"."ss_item_sk") AS "t453"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_class_id", "i_category_id"
FROM item) AS "t454" ON "t453"."cs_item_sk" = "t454"."i_item_sk") AS "t455"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1999 + 2 AND "d_moy" = 11) AS "t458" ON "t455"."cs_sold_date_sk" = "t458"."d_date_sk"
GROUP BY "t455"."i_brand_id", "t455"."i_class_id", "t455"."i_category_id") AS "t460"
LEFT JOIN (SELECT CASE COUNT("average_sales") WHEN 0 THEN NULL WHEN 1 THEN "average_sales" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM (SELECT AVG("quantity" * "list_price") AS "average_sales"
FROM (SELECT *
FROM (SELECT "store_sales24"."ss_quantity" AS "quantity", "store_sales24"."ss_list_price" AS "list_price"
FROM store_sales AS "store_sales24",
date_dim AS "date_dim73"
WHERE "store_sales24"."ss_sold_date_sk" = "date_dim73"."d_date_sk" AND ("date_dim73"."d_year" >= 1999 AND "date_dim73"."d_year" <= 2001)
UNION ALL
SELECT "catalog_sales24"."cs_quantity" AS "quantity", "catalog_sales24"."cs_list_price" AS "list_price"
FROM catalog_sales AS "catalog_sales24",
date_dim AS "date_dim74"
WHERE "catalog_sales24"."cs_sold_date_sk" = "date_dim74"."d_date_sk" AND "date_dim74"."d_year" >= 1999 AND "date_dim74"."d_year" <= 1999 + 2) AS "t"
UNION ALL
SELECT "web_sales23"."ws_quantity" AS "quantity", "web_sales23"."ws_list_price" AS "list_price"
FROM web_sales AS "web_sales23",
date_dim AS "date_dim75"
WHERE "web_sales23"."ws_sold_date_sk" = "date_dim75"."d_date_sk" AND "date_dim75"."d_year" >= 1999 AND "date_dim75"."d_year" <= 1999 + 2) AS "t471") AS "t474") AS "t475" ON TRUE
WHERE "t460"."sales" > "t475"."$f0") AS "t"
UNION ALL
SELECT 'web' AS "channel", "t503"."i_brand_id", "t503"."i_class_id", "t503"."i_category_id", "t503"."sales", "t503"."number_sales"
FROM (SELECT "t498"."i_brand_id", "t498"."i_class_id", "t498"."i_category_id", SUM("t498"."*") AS "sales", COUNT(*) AS "number_sales"
FROM (SELECT "t496"."ws_sold_date_sk", "t497"."i_brand_id", "t497"."i_class_id", "t497"."i_category_id", "t496"."*" AS "*"
FROM (SELECT "web_sales24"."ws_sold_date_sk", "web_sales24"."ws_item_sk", "web_sales24"."ws_quantity" * "web_sales24"."ws_list_price" AS "*"
FROM web_sales AS "web_sales24"
INNER JOIN (SELECT "item54"."i_item_sk" AS "ss_item_sk"
FROM item AS "item54",
(SELECT *
FROM (SELECT "item55"."i_brand_id" AS "brand_id", "item55"."i_class_id" AS "class_id", "item55"."i_category_id" AS "category_id"
FROM store_sales AS "store_sales25",
item AS "item55",
date_dim AS "date_dim76"
WHERE "store_sales25"."ss_item_sk" = "item55"."i_item_sk" AND "store_sales25"."ss_sold_date_sk" = "date_dim76"."d_date_sk" AND "date_dim76"."d_year" >= 1999 AND "date_dim76"."d_year" <= 1999 + 2
INTERSECT
SELECT "item56"."i_brand_id", "item56"."i_class_id", "item56"."i_category_id"
FROM catalog_sales AS "catalog_sales25",
item AS "item56",
date_dim AS "date_dim77"
WHERE "catalog_sales25"."cs_item_sk" = "item56"."i_item_sk" AND "catalog_sales25"."cs_sold_date_sk" = "date_dim77"."d_date_sk" AND "date_dim77"."d_year" >= 1999 AND "date_dim77"."d_year" <= 1999 + 2) AS "t"
INTERSECT
SELECT "item57"."i_brand_id", "item57"."i_class_id", "item57"."i_category_id"
FROM web_sales AS "web_sales25",
item AS "item57",
date_dim AS "date_dim78"
WHERE "web_sales25"."ws_item_sk" = "item57"."i_item_sk" AND "web_sales25"."ws_sold_date_sk" = "date_dim78"."d_date_sk" AND "date_dim78"."d_year" >= 1999 AND "date_dim78"."d_year" <= 1999 + 2) AS "t490"
WHERE "item54"."i_brand_id" = "t490"."brand_id" AND "item54"."i_class_id" = "t490"."class_id" AND "item54"."i_category_id" = "t490"."category_id"
GROUP BY "item54"."i_item_sk") AS "t494" ON "web_sales24"."ws_item_sk" = "t494"."ss_item_sk") AS "t496"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_class_id", "i_category_id"
FROM item) AS "t497" ON "t496"."ws_item_sk" = "t497"."i_item_sk") AS "t498"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1999 + 2 AND "d_moy" = 11) AS "t501" ON "t498"."ws_sold_date_sk" = "t501"."d_date_sk"
GROUP BY "t498"."i_brand_id", "t498"."i_class_id", "t498"."i_category_id") AS "t503"
LEFT JOIN (SELECT CASE COUNT("average_sales") WHEN 0 THEN NULL WHEN 1 THEN "average_sales" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM (SELECT AVG("quantity" * "list_price") AS "average_sales"
FROM (SELECT *
FROM (SELECT "store_sales26"."ss_quantity" AS "quantity", "store_sales26"."ss_list_price" AS "list_price"
FROM store_sales AS "store_sales26",
date_dim AS "date_dim80"
WHERE "store_sales26"."ss_sold_date_sk" = "date_dim80"."d_date_sk" AND ("date_dim80"."d_year" >= 1999 AND "date_dim80"."d_year" <= 2001)
UNION ALL
SELECT "catalog_sales26"."cs_quantity" AS "quantity", "catalog_sales26"."cs_list_price" AS "list_price"
FROM catalog_sales AS "catalog_sales26",
date_dim AS "date_dim81"
WHERE "catalog_sales26"."cs_sold_date_sk" = "date_dim81"."d_date_sk" AND "date_dim81"."d_year" >= 1999 AND "date_dim81"."d_year" <= 1999 + 2) AS "t"
UNION ALL
SELECT "web_sales26"."ws_quantity" AS "quantity", "web_sales26"."ws_list_price" AS "list_price"
FROM web_sales AS "web_sales26",
date_dim AS "date_dim82"
WHERE "web_sales26"."ws_sold_date_sk" = "date_dim82"."d_date_sk" AND "date_dim82"."d_year" >= 1999 AND "date_dim82"."d_year" <= 1999 + 2) AS "t514") AS "t517") AS "t518" ON TRUE
WHERE "t503"."sales" > "t518"."$f0") AS "t522"
GROUP BY "channel", "i_brand_id", "i_class_id", "i_category_id") AS "t524"
GROUP BY "channel") AS "t"
UNION
SELECT NULL AS "channel", NULL AS "i_brand_id", NULL AS "i_class_id", NULL AS "i_category_id", SUM("sum_sales") AS "EXPR$4", SUM("number_sales") AS "EXPR$5"
FROM (SELECT SUM("sales") AS "sum_sales", SUM("number_sales") AS "number_sales"
FROM (SELECT *
FROM (SELECT 'store' AS "channel", "t551"."i_brand_id", "t551"."i_class_id", "t551"."i_category_id", "t551"."sales", "t551"."number_sales"
FROM (SELECT "t546"."i_brand_id", "t546"."i_class_id", "t546"."i_category_id", SUM("t546"."*") AS "sales", COUNT(*) AS "number_sales"
FROM (SELECT "t544"."ss_sold_date_sk", "t545"."i_brand_id", "t545"."i_class_id", "t545"."i_category_id", "t544"."*" AS "*"
FROM (SELECT "store_sales27"."ss_sold_date_sk", "store_sales27"."ss_item_sk", "store_sales27"."ss_quantity" * "store_sales27"."ss_list_price" AS "*"
FROM store_sales AS "store_sales27"
INNER JOIN (SELECT "item59"."i_item_sk" AS "ss_item_sk"
FROM item AS "item59",
(SELECT *
FROM (SELECT "item60"."i_brand_id" AS "brand_id", "item60"."i_class_id" AS "class_id", "item60"."i_category_id" AS "category_id"
FROM store_sales AS "store_sales28",
item AS "item60",
date_dim AS "date_dim83"
WHERE "store_sales28"."ss_item_sk" = "item60"."i_item_sk" AND "store_sales28"."ss_sold_date_sk" = "date_dim83"."d_date_sk" AND "date_dim83"."d_year" >= 1999 AND "date_dim83"."d_year" <= 1999 + 2
INTERSECT
SELECT "item61"."i_brand_id", "item61"."i_class_id", "item61"."i_category_id"
FROM catalog_sales AS "catalog_sales27",
item AS "item61",
date_dim AS "date_dim84"
WHERE "catalog_sales27"."cs_item_sk" = "item61"."i_item_sk" AND "catalog_sales27"."cs_sold_date_sk" = "date_dim84"."d_date_sk" AND "date_dim84"."d_year" >= 1999 AND "date_dim84"."d_year" <= 1999 + 2) AS "t"
INTERSECT
SELECT "item62"."i_brand_id", "item62"."i_class_id", "item62"."i_category_id"
FROM web_sales AS "web_sales27",
item AS "item62",
date_dim AS "date_dim85"
WHERE "web_sales27"."ws_item_sk" = "item62"."i_item_sk" AND "web_sales27"."ws_sold_date_sk" = "date_dim85"."d_date_sk" AND "date_dim85"."d_year" >= 1999 AND "date_dim85"."d_year" <= 1999 + 2) AS "t538"
WHERE "item59"."i_brand_id" = "t538"."brand_id" AND "item59"."i_class_id" = "t538"."class_id" AND "item59"."i_category_id" = "t538"."category_id"
GROUP BY "item59"."i_item_sk") AS "t542" ON "store_sales27"."ss_item_sk" = "t542"."ss_item_sk") AS "t544"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_class_id", "i_category_id"
FROM item) AS "t545" ON "t544"."ss_item_sk" = "t545"."i_item_sk") AS "t546"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1999 + 2 AND "d_moy" = 11) AS "t549" ON "t546"."ss_sold_date_sk" = "t549"."d_date_sk"
GROUP BY "t546"."i_brand_id", "t546"."i_class_id", "t546"."i_category_id") AS "t551"
LEFT JOIN (SELECT CASE COUNT("average_sales") WHEN 0 THEN NULL WHEN 1 THEN "average_sales" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM (SELECT AVG("quantity" * "list_price") AS "average_sales"
FROM (SELECT *
FROM (SELECT "store_sales29"."ss_quantity" AS "quantity", "store_sales29"."ss_list_price" AS "list_price"
FROM store_sales AS "store_sales29",
date_dim AS "date_dim87"
WHERE "store_sales29"."ss_sold_date_sk" = "date_dim87"."d_date_sk" AND ("date_dim87"."d_year" >= 1999 AND "date_dim87"."d_year" <= 2001)
UNION ALL
SELECT "catalog_sales28"."cs_quantity" AS "quantity", "catalog_sales28"."cs_list_price" AS "list_price"
FROM catalog_sales AS "catalog_sales28",
date_dim AS "date_dim88"
WHERE "catalog_sales28"."cs_sold_date_sk" = "date_dim88"."d_date_sk" AND "date_dim88"."d_year" >= 1999 AND "date_dim88"."d_year" <= 1999 + 2) AS "t"
UNION ALL
SELECT "web_sales28"."ws_quantity" AS "quantity", "web_sales28"."ws_list_price" AS "list_price"
FROM web_sales AS "web_sales28",
date_dim AS "date_dim89"
WHERE "web_sales28"."ws_sold_date_sk" = "date_dim89"."d_date_sk" AND "date_dim89"."d_year" >= 1999 AND "date_dim89"."d_year" <= 1999 + 2) AS "t562") AS "t565") AS "t566" ON TRUE
WHERE "t551"."sales" > "t566"."$f0"
UNION ALL
SELECT 'catalog' AS "channel", "t593"."i_brand_id", "t593"."i_class_id", "t593"."i_category_id", "t593"."sales", "t593"."number_sales"
FROM (SELECT "t588"."i_brand_id", "t588"."i_class_id", "t588"."i_category_id", SUM("t588"."*") AS "sales", COUNT(*) AS "number_sales"
FROM (SELECT "t586"."cs_sold_date_sk", "t587"."i_brand_id", "t587"."i_class_id", "t587"."i_category_id", "t586"."*" AS "*"
FROM (SELECT "catalog_sales29"."cs_sold_date_sk", "catalog_sales29"."cs_item_sk", "catalog_sales29"."cs_quantity" * "catalog_sales29"."cs_list_price" AS "*"
FROM catalog_sales AS "catalog_sales29"
INNER JOIN (SELECT "item64"."i_item_sk" AS "ss_item_sk"
FROM item AS "item64",
(SELECT *
FROM (SELECT "item65"."i_brand_id" AS "brand_id", "item65"."i_class_id" AS "class_id", "item65"."i_category_id" AS "category_id"
FROM store_sales AS "store_sales30",
item AS "item65",
date_dim AS "date_dim90"
WHERE "store_sales30"."ss_item_sk" = "item65"."i_item_sk" AND "store_sales30"."ss_sold_date_sk" = "date_dim90"."d_date_sk" AND "date_dim90"."d_year" >= 1999 AND "date_dim90"."d_year" <= 1999 + 2
INTERSECT
SELECT "item66"."i_brand_id", "item66"."i_class_id", "item66"."i_category_id"
FROM catalog_sales AS "catalog_sales30",
item AS "item66",
date_dim AS "date_dim91"
WHERE "catalog_sales30"."cs_item_sk" = "item66"."i_item_sk" AND "catalog_sales30"."cs_sold_date_sk" = "date_dim91"."d_date_sk" AND "date_dim91"."d_year" >= 1999 AND "date_dim91"."d_year" <= 1999 + 2) AS "t"
INTERSECT
SELECT "item67"."i_brand_id", "item67"."i_class_id", "item67"."i_category_id"
FROM web_sales AS "web_sales29",
item AS "item67",
date_dim AS "date_dim92"
WHERE "web_sales29"."ws_item_sk" = "item67"."i_item_sk" AND "web_sales29"."ws_sold_date_sk" = "date_dim92"."d_date_sk" AND "date_dim92"."d_year" >= 1999 AND "date_dim92"."d_year" <= 1999 + 2) AS "t580"
WHERE "item64"."i_brand_id" = "t580"."brand_id" AND "item64"."i_class_id" = "t580"."class_id" AND "item64"."i_category_id" = "t580"."category_id"
GROUP BY "item64"."i_item_sk") AS "t584" ON "catalog_sales29"."cs_item_sk" = "t584"."ss_item_sk") AS "t586"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_class_id", "i_category_id"
FROM item) AS "t587" ON "t586"."cs_item_sk" = "t587"."i_item_sk") AS "t588"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1999 + 2 AND "d_moy" = 11) AS "t591" ON "t588"."cs_sold_date_sk" = "t591"."d_date_sk"
GROUP BY "t588"."i_brand_id", "t588"."i_class_id", "t588"."i_category_id") AS "t593"
LEFT JOIN (SELECT CASE COUNT("average_sales") WHEN 0 THEN NULL WHEN 1 THEN "average_sales" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM (SELECT AVG("quantity" * "list_price") AS "average_sales"
FROM (SELECT *
FROM (SELECT "store_sales31"."ss_quantity" AS "quantity", "store_sales31"."ss_list_price" AS "list_price"
FROM store_sales AS "store_sales31",
date_dim AS "date_dim94"
WHERE "store_sales31"."ss_sold_date_sk" = "date_dim94"."d_date_sk" AND ("date_dim94"."d_year" >= 1999 AND "date_dim94"."d_year" <= 2001)
UNION ALL
SELECT "catalog_sales31"."cs_quantity" AS "quantity", "catalog_sales31"."cs_list_price" AS "list_price"
FROM catalog_sales AS "catalog_sales31",
date_dim AS "date_dim95"
WHERE "catalog_sales31"."cs_sold_date_sk" = "date_dim95"."d_date_sk" AND "date_dim95"."d_year" >= 1999 AND "date_dim95"."d_year" <= 1999 + 2) AS "t"
UNION ALL
SELECT "web_sales30"."ws_quantity" AS "quantity", "web_sales30"."ws_list_price" AS "list_price"
FROM web_sales AS "web_sales30",
date_dim AS "date_dim96"
WHERE "web_sales30"."ws_sold_date_sk" = "date_dim96"."d_date_sk" AND "date_dim96"."d_year" >= 1999 AND "date_dim96"."d_year" <= 1999 + 2) AS "t604") AS "t607") AS "t608" ON TRUE
WHERE "t593"."sales" > "t608"."$f0") AS "t"
UNION ALL
SELECT 'web' AS "channel", "t636"."i_brand_id", "t636"."i_class_id", "t636"."i_category_id", "t636"."sales", "t636"."number_sales"
FROM (SELECT "t631"."i_brand_id", "t631"."i_class_id", "t631"."i_category_id", SUM("t631"."*") AS "sales", COUNT(*) AS "number_sales"
FROM (SELECT "t629"."ws_sold_date_sk", "t630"."i_brand_id", "t630"."i_class_id", "t630"."i_category_id", "t629"."*" AS "*"
FROM (SELECT "web_sales31"."ws_sold_date_sk", "web_sales31"."ws_item_sk", "web_sales31"."ws_quantity" * "web_sales31"."ws_list_price" AS "*"
FROM web_sales AS "web_sales31"
INNER JOIN (SELECT "item69"."i_item_sk" AS "ss_item_sk"
FROM item AS "item69",
(SELECT *
FROM (SELECT "item70"."i_brand_id" AS "brand_id", "item70"."i_class_id" AS "class_id", "item70"."i_category_id" AS "category_id"
FROM store_sales AS "store_sales32",
item AS "item70",
date_dim AS "date_dim97"
WHERE "store_sales32"."ss_item_sk" = "item70"."i_item_sk" AND "store_sales32"."ss_sold_date_sk" = "date_dim97"."d_date_sk" AND "date_dim97"."d_year" >= 1999 AND "date_dim97"."d_year" <= 1999 + 2
INTERSECT
SELECT "item71"."i_brand_id", "item71"."i_class_id", "item71"."i_category_id"
FROM catalog_sales AS "catalog_sales32",
item AS "item71",
date_dim AS "date_dim98"
WHERE "catalog_sales32"."cs_item_sk" = "item71"."i_item_sk" AND "catalog_sales32"."cs_sold_date_sk" = "date_dim98"."d_date_sk" AND "date_dim98"."d_year" >= 1999 AND "date_dim98"."d_year" <= 1999 + 2) AS "t"
INTERSECT
SELECT "item72"."i_brand_id", "item72"."i_class_id", "item72"."i_category_id"
FROM web_sales AS "web_sales32",
item AS "item72",
date_dim AS "date_dim99"
WHERE "web_sales32"."ws_item_sk" = "item72"."i_item_sk" AND "web_sales32"."ws_sold_date_sk" = "date_dim99"."d_date_sk" AND "date_dim99"."d_year" >= 1999 AND "date_dim99"."d_year" <= 1999 + 2) AS "t623"
WHERE "item69"."i_brand_id" = "t623"."brand_id" AND "item69"."i_class_id" = "t623"."class_id" AND "item69"."i_category_id" = "t623"."category_id"
GROUP BY "item69"."i_item_sk") AS "t627" ON "web_sales31"."ws_item_sk" = "t627"."ss_item_sk") AS "t629"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_class_id", "i_category_id"
FROM item) AS "t630" ON "t629"."ws_item_sk" = "t630"."i_item_sk") AS "t631"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1999 + 2 AND "d_moy" = 11) AS "t634" ON "t631"."ws_sold_date_sk" = "t634"."d_date_sk"
GROUP BY "t631"."i_brand_id", "t631"."i_class_id", "t631"."i_category_id") AS "t636"
LEFT JOIN (SELECT CASE COUNT("average_sales") WHEN 0 THEN NULL WHEN 1 THEN "average_sales" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM (SELECT AVG("quantity" * "list_price") AS "average_sales"
FROM (SELECT *
FROM (SELECT "store_sales33"."ss_quantity" AS "quantity", "store_sales33"."ss_list_price" AS "list_price"
FROM store_sales AS "store_sales33",
date_dim AS "date_dim101"
WHERE "store_sales33"."ss_sold_date_sk" = "date_dim101"."d_date_sk" AND ("date_dim101"."d_year" >= 1999 AND "date_dim101"."d_year" <= 2001)
UNION ALL
SELECT "catalog_sales33"."cs_quantity" AS "quantity", "catalog_sales33"."cs_list_price" AS "list_price"
FROM catalog_sales AS "catalog_sales33",
date_dim AS "date_dim102"
WHERE "catalog_sales33"."cs_sold_date_sk" = "date_dim102"."d_date_sk" AND "date_dim102"."d_year" >= 1999 AND "date_dim102"."d_year" <= 1999 + 2) AS "t"
UNION ALL
SELECT "web_sales33"."ws_quantity" AS "quantity", "web_sales33"."ws_list_price" AS "list_price"
FROM web_sales AS "web_sales33",
date_dim AS "date_dim103"
WHERE "web_sales33"."ws_sold_date_sk" = "date_dim103"."d_date_sk" AND "date_dim103"."d_year" >= 1999 AND "date_dim103"."d_year" <= 1999 + 2) AS "t647") AS "t650") AS "t651" ON TRUE
WHERE "t636"."sales" > "t651"."$f0") AS "t655"
GROUP BY "channel", "i_brand_id", "i_class_id", "i_category_id") AS "t657") AS "t660"
ORDER BY "channel", "i_brand_id", "i_class_id", "i_category_id"
LIMIT 100
;

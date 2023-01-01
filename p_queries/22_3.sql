SELECT i_product_name,
       i_brand,
       i_class,
       i_category,
       qoh
FROM results_rollup
ORDER BY qoh NULLS FIRST,
         i_product_name NULLS FIRST,
         i_brand NULLS FIRST,
         i_class NULLS FIRST,
         i_category NULLS FIRST
LIMIT 100;


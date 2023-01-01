package org.arachne.common;

public final class Queries {
    private Queries() {}

    public static final String qry0 = "SELECT * FROM store_sales";
    public static final String qry1 = "SELECT * FROM emps WHERE name like '%e%' AND empid > 100";
    public static final String qry2 = "SELECT * FROM \"emps\", \"depts\" WHERE \"emps\".\"deptno\" = \"depts\".\"deptno\"";
    public static final String qry3 = "SELECT \"empid\", SUM(\"salary\") FROM \"emps\" GROUP BY \"empid\"";
    public static final String qry4 = "SELECT * FROM lineitem";
    public static final String qry5 = "SELECT  l_linestatus, sum(l_quantity) AS expr$2, sum(l_extendedprice) AS sum_base_price, sum(l_extendedprice * (1 - l_discount)) AS sum_disc_price, sum(l_extendedprice * (1 - l_discount) * (1 + l_tax)) AS sum_charge, avg(l_quantity) AS avg_qty, avg(l_extendedprice) AS avg_price, avg(l_discount) AS avg_disc, count(*) AS count_order FROM lineitem WHERE l_shipdate <= CAST('1998-09-02' AS date) GROUP BY l_returnflag, l_linestatus ORDER BY l_returnflag, l_linestatus LIMIT 10";
    public static final String qry6 = "SELECT d.name, COUNT(*) FROM (SELECT * FROM emps) AS e JOIN depts AS d ON e.deptno = d.deptno GROUP BY d.name";
    public static final String qry7 = "SELECT * FROM emps as e, depts as d, lineitem as l WHERE e.deptno = d.deptno AND e.deptno = l.deptno";
    public static final String qry8 = "SELECT emps.* FROM (SELECT empid, deptno, SUM(salary) FROM emps GROUP BY empid, deptno) emps JOIN depts ON emps.deptno = depts.deptno WHERE emps.empid > 100";
    public static final String qry9 = "SELECT t1.empid,t1.deptno,t1.EXPR$2 FROM (SELECT emps.empid,emps.deptno,SUM(salary) AS EXPR$2 FROM emps GROUP BY emps.empid,emps.deptno )AS t1 JOIN depts AS t2 ON (t1.deptno = t2.deptno) WHERE (t1.empid > 100)";
    public static final String qry10 = "SELECT c_count, count(*) AS custdist FROM ( SELECT c_custkey, count(o_orderkey) FROM customer LEFT OUTER JOIN orders ON c_custkey = o_custkey AND o_comment NOT LIKE '%special%requests%' GROUP BY c_custkey) AS c_orders (c_custkey, c_count) GROUP BY c_count ORDER BY custdist DESC, c_count DESC";
    public static final String qry11 = "SELECT COUNT(o_orderkey) AS c_count, COUNT(*) AS CUSTDIST FROM customer  JOIN orders  ON ((customer.c_custkey = orders.o_custkey) AND NOT((orders.o_comment LIKE '%special%requests%'))) GROUP BY customer.c_custkey, c_count ORDER BY COUNT(*), COUNT(o_orderkey)";
    public static final String qry12 =
            "select\n" +
                    "    sum(l.l_extendedprice * l.l_discount) as revenue\n" +
                    "from\n" +
                    "    lineitem l\n" +
                    "where\n" +
                    "    l.l_shipdate >= '1994-01-01'\n" +
                    "    and l.l_shipdate < '1995-01-01'\n" +
                    "    and l.l_discount between (5 - 0.01) AND (5 + 0.01)\n" +
                    "    and l.l_quantity < 5";
    public static final String qry100 = "SELECT \n" +
            "          sum(coalesce(ss_sales_price*ss_quantity,0))\n" +
            "   FROM store_sales\n" +
            "   GROUP BY ss_store_sk";

    public static final String testqry =
            " SELECT \n" +
                    "          i_class,\n" +
                    "          i_brand,\n" +
                    "          i_product_name,\n" +
                    "          d_year,\n" +
                    "          d_qoy,\n" +
                    "          d_moy,\n" +
                    "          s_store_id ,\n" +
                    "          sum(coalesce(ss_sales_price*ss_quantity,0)) sumsales\n" +
                    "   FROM store_sales,\n" +
                    "        date_dim,\n" +
                    "        store,\n" +
                    "        item\n" +
                    "   WHERE ss_sold_date_sk=d_date_sk\n" +
                    "     AND ss_item_sk=i_item_sk\n" +
                    "     AND ss_store_sk = s_store_sk\n" +
                    "     AND d_month_seq BETWEEN 1200 AND 1200 + 11\n" +
                    "   GROUP BY i_category,\n" +
                    "            i_class,\n" +
                    "            i_brand,\n" +
                    "            i_product_name,\n" +
                    "            d_year,\n" +
                    "            d_qoy,\n" +
                    "            d_moy,\n" +
                    "            s_store_id";

        public static final String testqry2 = "WITH results_rollup AS\n" +
            "  (SELECT i_category,\n" +
            "          i_class,\n" +
            "          i_brand,\n" +
            "          i_product_name,\n" +
            "          d_year,\n" +
            "          d_qoy,\n" +
            "          d_moy,\n" +
            "          s_store_id,\n" +
            "          sumsales\n" +
            "   FROM results\n" +
            "   UNION ALL SELECT i_category,\n" +
            "                    i_class,\n" +
            "                    i_brand,\n" +
            "                    i_product_name,\n" +
            "                    d_year,\n" +
            "                    d_qoy,\n" +
            "                    d_moy,\n" +
            "                    NULL s_store_id,\n" +
            "                         sum(sumsales) sumsales\n" +
            "   FROM results\n" +
            "   GROUP BY i_category,\n" +
            "            i_class,\n" +
            "            i_brand,\n" +
            "            i_product_name,\n" +
            "            d_year,\n" +
            "            d_qoy,\n" +
            "            d_moy\n" +
            "   UNION ALL SELECT i_category,\n" +
            "                    i_class,\n" +
            "                    i_brand,\n" +
            "                    i_product_name,\n" +
            "                    d_year,\n" +
            "                    d_qoy,\n" +
            "                    NULL d_moy,\n" +
            "                         NULL s_store_id,\n" +
            "                              sum(sumsales) sumsales\n" +
            "   FROM results\n" +
            "   GROUP BY i_category,\n" +
            "            i_class,\n" +
            "            i_brand,\n" +
            "            i_product_name,\n" +
            "            d_year,\n" +
            "            d_qoy\n" +
            "   UNION ALL SELECT i_category,\n" +
            "                    i_class,\n" +
            "                    i_brand,\n" +
            "                    i_product_name,\n" +
            "                    d_year,\n" +
            "                    NULL d_qoy,\n" +
            "                         NULL d_moy,\n" +
            "                              NULL s_store_id,\n" +
            "                                   sum(sumsales) sumsales\n" +
            "   FROM results\n" +
            "   GROUP BY i_category,\n" +
            "            i_class,\n" +
            "            i_brand,\n" +
            "            i_product_name,\n" +
            "            d_year\n" +
            "   UNION ALL SELECT i_category,\n" +
            "                    i_class,\n" +
            "                    i_brand,\n" +
            "                    i_product_name,\n" +
            "                    NULL d_year,\n" +
            "                         NULL d_qoy,\n" +
            "                              NULL d_moy,\n" +
            "                                   NULL s_store_id,\n" +
            "                                        sum(sumsales) sumsales\n" +
            "   FROM results\n" +
            "   GROUP BY i_category,\n" +
            "            i_class,\n" +
            "            i_brand,\n" +
            "            i_product_name\n" +
            "   UNION ALL SELECT i_category,\n" +
            "                    i_class,\n" +
            "                    i_brand,\n" +
            "                    NULL i_product_name,\n" +
            "                         NULL d_year,\n" +
            "                              NULL d_qoy,\n" +
            "                                   NULL d_moy,\n" +
            "                                        NULL s_store_id,\n" +
            "                                             sum(sumsales) sumsales\n" +
            "   FROM results\n" +
            "   GROUP BY i_category,\n" +
            "            i_class,\n" +
            "            i_brand\n" +
            "   UNION ALL SELECT i_category,\n" +
            "                    i_class,\n" +
            "                    NULL i_brand,\n" +
            "                         NULL i_product_name,\n" +
            "                              NULL d_year,\n" +
            "                                   NULL d_qoy,\n" +
            "                                        NULL d_moy,\n" +
            "                                             NULL s_store_id,\n" +
            "                                                  sum(sumsales) sumsales\n" +
            "   FROM results\n" +
            "   GROUP BY i_category,\n" +
            "            i_class\n" +
            "   UNION ALL SELECT i_category,\n" +
            "                    NULL i_class,\n" +
            "                         NULL i_brand,\n" +
            "                              NULL i_product_name,\n" +
            "                                   NULL d_year,\n" +
            "                                        NULL d_qoy,\n" +
            "                                             NULL d_moy,\n" +
            "                                                  NULL s_store_id,\n" +
            "                                                       sum(sumsales) sumsales\n" +
            "   FROM results\n" +
            "   GROUP BY i_category\n" +
            "   UNION ALL SELECT NULL i_category,\n" +
            "                         NULL i_class,\n" +
            "                              NULL i_brand,\n" +
            "                                   NULL i_product_name,\n" +
            "                                        NULL d_year,\n" +
            "                                             NULL d_qoy,\n" +
            "                                                  NULL d_moy,\n" +
            "                                                       NULL s_store_id,\n" +
            "                                                            sum(sumsales) sumsales\n" +
            "   FROM results)\n" +
            "SELECT *\n" +
            "FROM\n" +
            "  (SELECT i_category ,\n" +
            "          i_class ,\n" +
            "          i_brand ,\n" +
            "          i_product_name ,\n" +
            "          d_year ,\n" +
            "          d_qoy ,\n" +
            "          d_moy ,\n" +
            "          s_store_id ,\n" +
            "          sumsales ,\n" +
            "          rank() OVER (PARTITION BY i_category\n" +
            "                       ORDER BY sumsales DESC) rk\n" +
            "   FROM results_rollup) dw2\n" +
            "WHERE rk <= 100\n" +
            "ORDER BY i_category NULLS LAST,\n" +
            "         i_class NULLS LAST,\n" +
            "         i_brand NULLS LAST,\n" +
            "         i_product_name NULLS LAST,\n" +
            "         d_year NULLS LAST,\n" +
            "         d_qoy NULLS LAST,\n" +
            "         d_moy NULLS LAST,\n" +
            "         s_store_id NULLS LAST,\n" +
            "         sumsales NULLS LAST,\n" +
            "         rk NULLS LAST\n" +
            "LIMIT 100";

    public static final String noWindow = "WITH results AS\n" +
            "  (SELECT i_category,\n" +
            "          i_class,\n" +
            "          i_brand,\n" +
            "          i_product_name,\n" +
            "          d_year,\n" +
            "          d_qoy,\n" +
            "          d_moy,\n" +
            "          s_store_id ,\n" +
            "          sum(coalesce(ss_sales_price*ss_quantity,0)) sumsales\n" +
            "   FROM store_sales,\n" +
            "        date_dim,\n" +
            "        store,\n" +
            "        item\n" +
            "   WHERE ss_sold_date_sk=d_date_sk\n" +
            "     AND ss_item_sk=i_item_sk\n" +
            "     AND ss_store_sk = s_store_sk\n" +
            "     AND d_month_seq BETWEEN 1200 AND 1200 + 11\n" +
            "   GROUP BY i_category,\n" +
            "            i_class,\n" +
            "            i_brand,\n" +
            "            i_product_name,\n" +
            "            d_year,\n" +
            "            d_qoy,\n" +
            "            d_moy,\n" +
            "            s_store_id) ,\n" +
            "     results_rollup AS\n" +
            "  (SELECT i_category,\n" +
            "          i_class,\n" +
            "          i_brand,\n" +
            "          i_product_name,\n" +
            "          d_year,\n" +
            "          d_qoy,\n" +
            "          d_moy,\n" +
            "          s_store_id,\n" +
            "          sumsales\n" +
            "   FROM results\n" +
            "   UNION ALL SELECT i_category,\n" +
            "                    i_class,\n" +
            "                    i_brand,\n" +
            "                    i_product_name,\n" +
            "                    d_year,\n" +
            "                    d_qoy,\n" +
            "                    d_moy,\n" +
            "                    NULL s_store_id,\n" +
            "                         sum(sumsales) sumsales\n" +
            "   FROM results\n" +
            "   GROUP BY i_category,\n" +
            "            i_class,\n" +
            "            i_brand,\n" +
            "            i_product_name,\n" +
            "            d_year,\n" +
            "            d_qoy,\n" +
            "            d_moy\n" +
            "   UNION ALL SELECT i_category,\n" +
            "                    i_class,\n" +
            "                    i_brand,\n" +
            "                    i_product_name,\n" +
            "                    d_year,\n" +
            "                    d_qoy,\n" +
            "                    NULL d_moy,\n" +
            "                         NULL s_store_id,\n" +
            "                              sum(sumsales) sumsales\n" +
            "   FROM results\n" +
            "   GROUP BY i_category,\n" +
            "            i_class,\n" +
            "            i_brand,\n" +
            "            i_product_name,\n" +
            "            d_year,\n" +
            "            d_qoy\n" +
            "   UNION ALL SELECT i_category,\n" +
            "                    i_class,\n" +
            "                    i_brand,\n" +
            "                    i_product_name,\n" +
            "                    d_year,\n" +
            "                    NULL d_qoy,\n" +
            "                         NULL d_moy,\n" +
            "                              NULL s_store_id,\n" +
            "                                   sum(sumsales) sumsales\n" +
            "   FROM results\n" +
            "   GROUP BY i_category,\n" +
            "            i_class,\n" +
            "            i_brand,\n" +
            "            i_product_name,\n" +
            "            d_year\n" +
            "   UNION ALL SELECT i_category,\n" +
            "                    i_class,\n" +
            "                    i_brand,\n" +
            "                    i_product_name,\n" +
            "                    NULL d_year,\n" +
            "                         NULL d_qoy,\n" +
            "                              NULL d_moy,\n" +
            "                                   NULL s_store_id,\n" +
            "                                        sum(sumsales) sumsales\n" +
            "   FROM results\n" +
            "   GROUP BY i_category,\n" +
            "            i_class,\n" +
            "            i_brand,\n" +
            "            i_product_name\n" +
            "   UNION ALL SELECT i_category,\n" +
            "                    i_class,\n" +
            "                    i_brand,\n" +
            "                    NULL i_product_name,\n" +
            "                         NULL d_year,\n" +
            "                              NULL d_qoy,\n" +
            "                                   NULL d_moy,\n" +
            "                                        NULL s_store_id,\n" +
            "                                             sum(sumsales) sumsales\n" +
            "   FROM results\n" +
            "   GROUP BY i_category,\n" +
            "            i_class,\n" +
            "            i_brand\n" +
            "   UNION ALL SELECT i_category,\n" +
            "                    i_class,\n" +
            "                    NULL i_brand,\n" +
            "                         NULL i_product_name,\n" +
            "                              NULL d_year,\n" +
            "                                   NULL d_qoy,\n" +
            "                                        NULL d_moy,\n" +
            "                                             NULL s_store_id,\n" +
            "                                                  sum(sumsales) sumsales\n" +
            "   FROM results\n" +
            "   GROUP BY i_category,\n" +
            "            i_class\n" +
            "   UNION ALL SELECT i_category,\n" +
            "                    NULL i_class,\n" +
            "                         NULL i_brand,\n" +
            "                              NULL i_product_name,\n" +
            "                                   NULL d_year,\n" +
            "                                        NULL d_qoy,\n" +
            "                                             NULL d_moy,\n" +
            "                                                  NULL s_store_id,\n" +
            "                                                       sum(sumsales) sumsales\n" +
            "   FROM results\n" +
            "   GROUP BY i_category\n" +
            "   UNION ALL SELECT NULL i_category,\n" +
            "                         NULL i_class,\n" +
            "                              NULL i_brand,\n" +
            "                                   NULL i_product_name,\n" +
            "                                        NULL d_year,\n" +
            "                                             NULL d_qoy,\n" +
            "                                                  NULL d_moy,\n" +
            "                                                       NULL s_store_id,\n" +
            "                                                            sum(sumsales) sumsales\n" +
            "   FROM results)\n" +
            "SELECT i_category ,\n" +
            "       i_class ,\n" +
            "       i_brand ,\n" +
            "       i_product_name ,\n" +
            "       d_year ,\n" +
            "       d_qoy ,\n" +
            "       d_moy ,\n" +
            "       s_store_id ,\n" +
            "       sumsales \n" +
            "FROM results_rollup\n" +
            "ORDER BY i_category NULLS LAST,\n" +
            "         i_class NULLS LAST,\n" +
            "         i_brand NULLS LAST,\n" +
            "         i_product_name NULLS LAST,\n" +
            "         d_year NULLS LAST,\n" +
            "         d_qoy NULLS LAST,\n" +
            "         d_moy NULLS LAST,\n" +
            "         s_store_id NULLS LAST,\n" +
            "         sumsales NULLS LAST\n" +
            "LIMIT 100";

    public static final String qry13 = "WITH results AS\n" +
            "  (SELECT i_category,\n" +
            "          i_class,\n" +
            "          i_brand,\n" +
            "          i_product_name,\n" +
            "          d_year,\n" +
            "          d_qoy,\n" +
            "          d_moy,\n" +
            "          s_store_id ,\n" +
            "          sum(coalesce(ss_sales_price*ss_quantity,0)) sumsales\n" +
            "   FROM store_sales,\n" +
            "        date_dim,\n" +
            "        store,\n" +
            "        item\n" +
            "   WHERE ss_sold_date_sk=d_date_sk\n" +
            "     AND ss_item_sk=i_item_sk\n" +
            "     AND ss_store_sk = s_store_sk\n" +
            "     AND d_month_seq BETWEEN 1200 AND 1200 + 11\n" +
            "   GROUP BY i_category,\n" +
            "            i_class,\n" +
            "            i_brand,\n" +
            "            i_product_name,\n" +
            "            d_year,\n" +
            "            d_qoy,\n" +
            "            d_moy,\n" +
            "            s_store_id) ,\n" +
            "     results_rollup AS\n" +
            "  (SELECT i_category,\n" +
            "          i_class,\n" +
            "          i_brand,\n" +
            "          i_product_name,\n" +
            "          d_year,\n" +
            "          d_qoy,\n" +
            "          d_moy,\n" +
            "          s_store_id,\n" +
            "          sumsales\n" +
            "   FROM results\n" +
            "   UNION ALL SELECT i_category,\n" +
            "                    i_class,\n" +
            "                    i_brand,\n" +
            "                    i_product_name,\n" +
            "                    d_year,\n" +
            "                    d_qoy,\n" +
            "                    d_moy,\n" +
            "                    NULL s_store_id,\n" +
            "                         sum(sumsales) sumsales\n" +
            "   FROM results\n" +
            "   GROUP BY i_category,\n" +
            "            i_class,\n" +
            "            i_brand,\n" +
            "            i_product_name,\n" +
            "            d_year,\n" +
            "            d_qoy,\n" +
            "            d_moy\n" +
            "   UNION ALL SELECT i_category,\n" +
            "                    i_class,\n" +
            "                    i_brand,\n" +
            "                    i_product_name,\n" +
            "                    d_year,\n" +
            "                    d_qoy,\n" +
            "                    NULL d_moy,\n" +
            "                         NULL s_store_id,\n" +
            "                              sum(sumsales) sumsales\n" +
            "   FROM results\n" +
            "   GROUP BY i_category,\n" +
            "            i_class,\n" +
            "            i_brand,\n" +
            "            i_product_name,\n" +
            "            d_year,\n" +
            "            d_qoy\n" +
            "   UNION ALL SELECT i_category,\n" +
            "                    i_class,\n" +
            "                    i_brand,\n" +
            "                    i_product_name,\n" +
            "                    d_year,\n" +
            "                    NULL d_qoy,\n" +
            "                         NULL d_moy,\n" +
            "                              NULL s_store_id,\n" +
            "                                   sum(sumsales) sumsales\n" +
            "   FROM results\n" +
            "   GROUP BY i_category,\n" +
            "            i_class,\n" +
            "            i_brand,\n" +
            "            i_product_name,\n" +
            "            d_year\n" +
            "   UNION ALL SELECT i_category,\n" +
            "                    i_class,\n" +
            "                    i_brand,\n" +
            "                    i_product_name,\n" +
            "                    NULL d_year,\n" +
            "                         NULL d_qoy,\n" +
            "                              NULL d_moy,\n" +
            "                                   NULL s_store_id,\n" +
            "                                        sum(sumsales) sumsales\n" +
            "   FROM results\n" +
            "   GROUP BY i_category,\n" +
            "            i_class,\n" +
            "            i_brand,\n" +
            "            i_product_name\n" +
            "   UNION ALL SELECT i_category,\n" +
            "                    i_class,\n" +
            "                    i_brand,\n" +
            "                    NULL i_product_name,\n" +
            "                         NULL d_year,\n" +
            "                              NULL d_qoy,\n" +
            "                                   NULL d_moy,\n" +
            "                                        NULL s_store_id,\n" +
            "                                             sum(sumsales) sumsales\n" +
            "   FROM results\n" +
            "   GROUP BY i_category,\n" +
            "            i_class,\n" +
            "            i_brand\n" +
            "   UNION ALL SELECT i_category,\n" +
            "                    i_class,\n" +
            "                    NULL i_brand,\n" +
            "                         NULL i_product_name,\n" +
            "                              NULL d_year,\n" +
            "                                   NULL d_qoy,\n" +
            "                                        NULL d_moy,\n" +
            "                                             NULL s_store_id,\n" +
            "                                                  sum(sumsales) sumsales\n" +
            "   FROM results\n" +
            "   GROUP BY i_category,\n" +
            "            i_class\n" +
            "   UNION ALL SELECT i_category,\n" +
            "                    NULL i_class,\n" +
            "                         NULL i_brand,\n" +
            "                              NULL i_product_name,\n" +
            "                                   NULL d_year,\n" +
            "                                        NULL d_qoy,\n" +
            "                                             NULL d_moy,\n" +
            "                                                  NULL s_store_id,\n" +
            "                                                       sum(sumsales) sumsales\n" +
            "   FROM results\n" +
            "   GROUP BY i_category\n" +
            "   UNION ALL SELECT NULL i_category,\n" +
            "                         NULL i_class,\n" +
            "                              NULL i_brand,\n" +
            "                                   NULL i_product_name,\n" +
            "                                        NULL d_year,\n" +
            "                                             NULL d_qoy,\n" +
            "                                                  NULL d_moy,\n" +
            "                                                       NULL s_store_id,\n" +
            "                                                            sum(sumsales) sumsales\n" +
            "   FROM results)\n" +
            "SELECT *\n" +
            "FROM\n" +
            "  (SELECT i_category ,\n" +
            "          i_class ,\n" +
            "          i_brand ,\n" +
            "          i_product_name ,\n" +
            "          d_year ,\n" +
            "          d_qoy ,\n" +
            "          d_moy ,\n" +
            "          s_store_id ,\n" +
            "          sumsales ,\n" +
            "          rank() OVER (PARTITION BY i_category\n" +
            "                       ORDER BY sumsales DESC) rk\n" +
            "   FROM results_rollup) dw2\n" +
            "WHERE rk <= 100\n" +
            "ORDER BY i_category NULLS LAST,\n" +
            "         i_class NULLS LAST,\n" +
            "         i_brand NULLS LAST,\n" +
            "         i_product_name NULLS LAST,\n" +
            "         d_year NULLS LAST,\n" +
            "         d_qoy NULLS LAST,\n" +
            "         d_moy NULLS LAST,\n" +
            "         s_store_id NULLS LAST,\n" +
            "         sumsales NULLS LAST,\n" +
            "         rk NULLS LAST\n" +
            "LIMIT 100";
}

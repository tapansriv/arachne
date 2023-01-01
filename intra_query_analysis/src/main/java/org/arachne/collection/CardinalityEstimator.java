package org.arachne.collection;

import com.google.common.collect.ImmutableMap;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.core.TableScan;
import org.arachne.common.ColumnSizes;
import org.arachne.profiling.rel.ProfileRel;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Utility class to find all unique scans of base tables to factor into size/card estimation
 */
public class CardinalityEstimator {
    public List<String> tableNames;
    public Long cardinality;
    public double extraSizeGB;
    public double extraSizeParquetGB;

    // put in like json files? seems fair and flexible to size and then just another specifiation or some shit
    public Map<String, Double> parquetSizeByTable = ImmutableMap.<String, Double>builder()
            .put("call_center", 0.000012)
            .put("catalog_page", 0.0018)
            .put("catalog_returns", 14d)
            .put("catalog_sales", 133.0)
            .put("customer", 0.874)
            .put("customer_address", 0.251)
            .put("customer_demographics", 0.012)
            .put("date_dim", 0.0021)
            .put("household_demographics", 0.000040)
            .put("income_band", 0.0000040)
            .put("inventory", 5.2)
            .put("item", 0.036)
            .put("promotion", 0.000084)
            .put("reason", 0.0000040)
            .put("ship_mode", 0.0000040)
            .put("store", 0.000108)
            .put("store_returns", 21d)
            .put("store_sales", 175d)
            .put("time_dim", 0.0013)
            .put("warehouse", 0.0000040)
            .put("web_page", 0.000040)
            .put("web_returns", 6.3)
            .put("web_sales", 68d)
            .put("web_site", 0.000012)
            // ldbc tables
            .put("comment", 10.3172248183)
            .put("forum", 0.1028258912)
            .put("forum_person", 1.5164454188)
            .put("forum_tag", 0.1108380901)
            .put("knows", 0.6096431818)
            .put("likes", 2.9804569576)
            .put("message_tag", 2.7476866506)
            .put("organisation", 0.0002714777)
            .put("person", 0.0304743256)
            .put("person_company", 0.0108570531)
            .put("person_tag", 0.0474168072)
            .put("person_university", 0.0064339582)
            .put("place", 0.0000339989)
            .put("post", 2.3743509231)
            .put("tag", 0.0005424013)
            .put("tagclass", 0.0000026496)
            .build();

    public Map<String, Long> cardByTable = ImmutableMap.<String,Long>builder()
            .put("call_center", 42L)
            .put("catalog_page", 30000L)
            .put("catalog_returns", 143996756L)
            .put("catalog_sales", 1439980416L)
            .put("customer", 12000000L)
            .put("customer_address", 6000000L)
            .put("customer_demographics", 1920800L)
            .put("date_dim", 73049L)
            .put("household_demographics", 7200L)
            .put("income_band", 20L)
            .put("inventory", 783000000L)
            .put("item", 300000L)
            .put("promotion", 1500L)
            .put("reason", 65L)
            .put("ship_mode", 20L)
            .put("store", 1002L)
            .put("store_returns", 287999764L)
            .put("store_sales", 2879987999L)
            .put("time_dim", 86400L)
            .put("warehouse", 20L)
            .put("web_page", 3000L)
            .put("web_returns", 71997522L)
            .put("web_sales", 720000376L)
            .put("web_site", 54L)
            // ldbc tables
            .put("organisation", 7955L)
            .put("place", 1460L)
            .put("tag", 16080L)
            .put("tagclass", 71L)
            .put("comment", 238859896L)
            .put("message_tag", 381508745L)
            .put("forum", 4876750L)
            .put("forum_person", 336799532L)
            .put("forum_tag", 15787515L)
            .put("person", 487700L)
            .put("person_tag", 11398465L)
            .put("knows", 46233610L)
            .put("likes", 348986704L)
            .put("person_university", 390266L)
            .put("person_company", 1061627L)
            .put("post", 67764850L)
            .build();

    // add some thing to the constructor
    public CardinalityEstimator() {
        tableNames = new ArrayList<>();
        cardinality = 0L;
        this.extraSizeParquetGB = 0d;
        this.extraSizeGB = 0d;
    }

    private void traverse(RelNode node, int ordinal, RelNode parent) {
        int size = node.getInputs().size();
        if (node instanceof TableScan) {
            TableScan t = (TableScan) node;
            String tableName = t.getTable().getQualifiedName().get(1);
            if (!tableName.contains("table") && !tableNames.contains(tableName)) {
                Long t_card = cardByTable.get(tableName);
                Double parquetSize = parquetSizeByTable.get(tableName);
                this.cardinality += t_card;
                this.extraSizeGB += (t_card * ColumnSizes.estimateRowSize(t)) / 1_000_000_000.0;
                this.extraSizeParquetGB += parquetSize;
                tableNames.add(tableName);
            }
        }
        for (int i = 0; i < size; i++) {
            RelNode r = node.getInput(i);
            traverse(r, i, node);
        }
    }

    private void traverseExceptIndex(ProfileRel node, int excludeId) {
        if (node.getArachneID() != excludeId) {
            if (node instanceof TableScan) {
                TableScan t = (TableScan) node;
                String tableName = t.getTable().getQualifiedName().get(1);
                if (!tableName.contains("table") && !tableNames.contains(tableName)) {
                    Long t_card = cardByTable.get(tableName);
                    Double parquetSize = parquetSizeByTable.get(tableName);
                    this.cardinality += t_card;
                    this.extraSizeGB += (t_card * ColumnSizes.estimateRowSize(t)) / 1_000_000_000.0;
                    this.extraSizeParquetGB += parquetSize;
                    tableNames.add(tableName);
                }
            }
            for (RelNode r : node.getInputs()) {
                traverseExceptIndex((ProfileRel)r, excludeId);
            }
        } else {
            if (!tableNames.contains("table0")) { // only want to hit once, otherwise we'll duplicate add to size
                Long t_card = node.getCardinality();
                this.cardinality += t_card;
                double sizeGB = (t_card * ColumnSizes.estimateRowSize(node)) / 1_000_000_000.0;
                this.extraSizeGB += sizeGB;
                this.extraSizeParquetGB += (sizeGB / 2.1d);
                tableNames.add("table0");
            }
        }
    }

    public void computeTables(RelNode root) {
        traverse(root, 0, null);
    }

    public void computeTablesExceptId(ProfileRel root, int excludeId) {
        traverseExceptIndex(root, excludeId);
    }
}

package org.arachne.schema;

import org.apache.calcite.DataContext;
import org.apache.calcite.linq4j.Enumerable;
import org.apache.calcite.rel.type.RelDataType;
import org.apache.calcite.rel.type.RelDataTypeFactory;
import org.apache.calcite.rel.type.RelDataTypeField;
import org.apache.calcite.rel.type.RelDataTypeFieldImpl;
import org.apache.calcite.rel.type.RelRecordType;
import org.apache.calcite.rel.type.StructKind;
import org.apache.calcite.schema.ScannableTable;
import org.apache.calcite.schema.Statistic;
import org.apache.calcite.schema.impl.AbstractTable;
import org.apache.calcite.sql.type.SqlTypeName;

import java.util.ArrayList;
import java.util.List;

public class ArachneTable extends AbstractTable implements ScannableTable {

    private final String tableName;
    private final List<String> fieldNames;
    private final List<SqlTypeName> fieldTypes;
    private final ArachneStatistic statistic;
    private RelDataType rowType;

    public static ArachneTable emps = ArachneTable.newBuilder("emps")
                            .addField("empid", SqlTypeName.INTEGER)
                            .addField("deptno", SqlTypeName.INTEGER)
                            .addField("name", SqlTypeName.VARCHAR)
                            .addField("salary", SqlTypeName.INTEGER)
                            .addField("commission", SqlTypeName.INTEGER)
                            .withRowCount(100L)
                            .build();

    public static ArachneTable depts = ArachneTable.newBuilder("depts")
                            .addField("deptno", SqlTypeName.INTEGER)
                            .addField("name", SqlTypeName.VARCHAR)
                            .withRowCount(200L)
                            .build();
    public static ArachneTable lineitem = ArachneTable.newBuilder("lineitem")
                                .addField("l_orderkey", SqlTypeName.INTEGER)
                                .addField("l_partkey", SqlTypeName.INTEGER)
                                .addField("l_suppkey", SqlTypeName.INTEGER)
                                .addField("l_linenumber", SqlTypeName.INTEGER)
                                .addField("l_quantity", SqlTypeName.DECIMAL)
                                .addField("l_extendedprice", SqlTypeName.DECIMAL)
                                .addField("l_discount", SqlTypeName.DECIMAL)
                                .addField("l_tax", SqlTypeName.DECIMAL)
                                .addField("l_returnflag", SqlTypeName.VARCHAR)
                                .addField("l_linestatus", SqlTypeName.VARCHAR)
                                .addField("l_shipdate", SqlTypeName.DATE)
                                .addField("l_commitdate", SqlTypeName.DATE)
                                .addField("l_receiptdate", SqlTypeName.DATE)
                                .addField("l_shipinstruct", SqlTypeName.VARCHAR)
                                .addField("l_shipmode", SqlTypeName.VARCHAR)
                                .addField("l_comment", SqlTypeName.VARCHAR)
                                .addField("deptno", SqlTypeName.INTEGER)
                                .withRowCount(60_000_000L)
                                .build();

    public static ArachneTable nation = ArachneTable.newBuilder("nation")
                                .addField("n_nationkey", SqlTypeName.INTEGER)
                                .addField("n_name", SqlTypeName.VARCHAR)
                                .addField("n_regionkey", SqlTypeName.INTEGER)
                                .addField("n_comment", SqlTypeName.VARCHAR)
                                .withRowCount(25)
                                .build();

    public static ArachneTable region = ArachneTable.newBuilder("region")
                                .addField("r_regionkey", SqlTypeName.INTEGER)
                                .addField("r_name", SqlTypeName.VARCHAR)
                                .addField("r_comment", SqlTypeName.VARCHAR)
                                .withRowCount(5)
                                .build();

    public static ArachneTable part = ArachneTable.newBuilder("part")
                                .addField("p_partkey", SqlTypeName.INTEGER)
                                .addField("p_name", SqlTypeName.VARCHAR)
                                .addField("p_mfgr", SqlTypeName.VARCHAR)
                                .addField("p_brand", SqlTypeName.VARCHAR)
                                .addField("p_type", SqlTypeName.VARCHAR)
                                .addField("p_size", SqlTypeName.INTEGER)
                                .addField("p_container", SqlTypeName.VARCHAR)
                                .addField("p_retailprice", SqlTypeName.DECIMAL)
                                .addField("p_comment", SqlTypeName.VARCHAR)
                                .withRowCount(2_000_000L)
                                .build();

    public static ArachneTable supplier = ArachneTable.newBuilder("supplier")
                                .addField("s_suppkey", SqlTypeName.INTEGER)
                                .addField("s_name", SqlTypeName.VARCHAR)
                                .addField("s_address", SqlTypeName.VARCHAR)
                                .addField("s_nationkey", SqlTypeName.INTEGER)
                                .addField("s_phone", SqlTypeName.VARCHAR)
                                .addField("s_acctbal", SqlTypeName.DECIMAL)
                                .addField("s_comment", SqlTypeName.VARCHAR)
                                .withRowCount(100_000L)
                                .build();

    public static ArachneTable partsupp = ArachneTable.newBuilder("partsupp")
                                .addField("ps_partkey", SqlTypeName.INTEGER)
                                .addField("ps_suppkey", SqlTypeName.INTEGER)
                                .addField("ps_availqty", SqlTypeName.INTEGER)
                                .addField("ps_supplycost", SqlTypeName.DECIMAL)
                                .addField("ps_comment", SqlTypeName.VARCHAR)
                                .withRowCount(8_000_000L)
                                .build();

    public static ArachneTable customer = ArachneTable.newBuilder("customer")
                                .addField("c_custkey", SqlTypeName.INTEGER)
                                .addField("c_name", SqlTypeName.VARCHAR)
                                .addField("c_address", SqlTypeName.VARCHAR)
                                .addField("c_nationkey", SqlTypeName.INTEGER)
                                .addField("c_phone", SqlTypeName.VARCHAR)
                                .addField("c_acctbal", SqlTypeName.DECIMAL)
                                .addField("c_mktsegment", SqlTypeName.VARCHAR)
                                .addField("c_comment", SqlTypeName.VARCHAR)
                                .withRowCount(1_500_000L)
                                .build();

    public static ArachneTable orders = ArachneTable.newBuilder("orders")
                                .addField("o_orderkey", SqlTypeName.INTEGER)
                                .addField("o_custkey", SqlTypeName.INTEGER)
                                .addField("o_orderstatus", SqlTypeName.VARCHAR)
                                .addField("o_totalprice", SqlTypeName.DECIMAL)
                                .addField("o_orderdate", SqlTypeName.DATE)
                                .addField("o_orderpriority", SqlTypeName.VARCHAR)
                                .addField("o_clerk", SqlTypeName.VARCHAR)
                                .addField("o_shippriority", SqlTypeName.INTEGER)
                                .addField("o_comment", SqlTypeName.VARCHAR)
                                .withRowCount(15_000_000L)
                                .build();

    private ArachneTable(String tableName, List<String> fieldNames, List<SqlTypeName> fieldTypes, ArachneStatistic statistic) {
        this.tableName = tableName;
        this.fieldNames = fieldNames;
        this.fieldTypes = fieldTypes;
        this.statistic = statistic;
    }

    public String getTableName() {
        return tableName;
    }

    @Override
    public RelDataType getRowType(RelDataTypeFactory typeFactory) {
        if (rowType == null) {
            List<RelDataTypeField> fields = new ArrayList<>(fieldNames.size());

            for (int i = 0; i < fieldNames.size(); i++) {
                RelDataType fieldType = typeFactory.createSqlType(fieldTypes.get(i));
                RelDataTypeField field = new RelDataTypeFieldImpl(fieldNames.get(i), i, fieldType);
                fields.add(field);
            }

            rowType = new RelRecordType(StructKind.PEEK_FIELDS, fields, false);
        }

        return rowType;
    }

    @Override
    public Statistic getStatistic() {
        return statistic;
    }

    @Override
    public Enumerable<Object[]> scan(DataContext root) {
        throw new UnsupportedOperationException("Not implemented");
    }

    public static Builder newBuilder(String tableName) {
        return new Builder(tableName);
    }

    public static final class Builder {

        private final String tableName;
        private final List<String> fieldNames = new ArrayList<>();
        private final List<SqlTypeName> fieldTypes = new ArrayList<>();
        private long rowCount;

        private Builder(String tableName) {
            if (tableName == null || tableName.isEmpty()) {
                throw new IllegalArgumentException("Table name cannot be null or empty");
            }

            this.tableName = tableName;
        }

        public Builder addField(String name, SqlTypeName typeName) {
            if (name == null || name.isEmpty()) {
                throw new IllegalArgumentException("Field name cannot be null or empty");
            }

            if (fieldNames.contains(name)) {
                throw new IllegalArgumentException("Field already defined: " + name);
            }

            fieldNames.add(name);
            fieldTypes.add(typeName);

            return this;
        }

        public Builder withRowCount(long rowCount) {
            this.rowCount = rowCount;
            return this;
        }

        public ArachneTable build() {
            if (fieldNames.isEmpty()) {
                throw new IllegalStateException("Table must have at least one field");
            }

            if (rowCount == 0L) {
                throw new IllegalStateException("Table must have positive row count");
            }

            return new ArachneTable(tableName, fieldNames, fieldTypes, new ArachneStatistic(rowCount));
        }
    }
}

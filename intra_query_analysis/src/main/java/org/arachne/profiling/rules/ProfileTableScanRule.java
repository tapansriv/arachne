package org.arachne.profiling.rules;

import org.apache.calcite.plan.Convention;
import org.apache.calcite.plan.RelOptTable;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.convert.ConverterRule;
import org.apache.calcite.rel.core.TableScan;
import org.apache.calcite.rel.logical.LogicalTableScan;
import org.apache.calcite.schema.Table;
import org.arachne.profiling.rel.ProfileConvention;
import org.arachne.profiling.rel.ProfileTableScan;
import org.checkerframework.checker.nullness.qual.Nullable;

public class ProfileTableScanRule extends ConverterRule{
    public static final ConverterRule.Config DEFAULT_CONFIG;

    public ProfileTableScanRule(ConverterRule.Config config) {
        super(config);
    }

    @Nullable
    public RelNode convert(RelNode rel) {
        TableScan scan = (TableScan)rel;
        RelOptTable relOptTable = scan.getTable();
        Table table = (Table)relOptTable.unwrap(Table.class);
        return ProfileTableScan.create(scan.getCluster(), relOptTable);
    }

    static {
        DEFAULT_CONFIG = ((ConverterRule.Config) ConverterRule.Config.EMPTY.as(ConverterRule.Config.class)).withConversion(LogicalTableScan.class, (r) -> {
            return true;
        }, Convention.NONE, ProfileConvention.INSTANCE, "ProfileTableScanRule").withRuleFactory(ProfileTableScanRule::new);
    }

}

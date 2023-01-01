package org.arachne.profiling.rules;

import org.apache.calcite.plan.Convention;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.convert.ConverterRule;
import org.apache.calcite.rel.core.Values;
import org.apache.calcite.rel.logical.LogicalValues;
import org.arachne.profiling.rel.ProfileConvention;
import org.arachne.profiling.rel.ProfileValues;
import org.checkerframework.checker.nullness.qual.Nullable;

public class ProfileValuesRule extends ConverterRule {
    public static final ConverterRule.Config DEFAULT_CONFIG;

    public ProfileValuesRule(ConverterRule.Config config) {
        super(config);
    }

    @Nullable
    public RelNode convert(RelNode rel) {
        Values val = (Values)rel;
        return ProfileValues.create(val.getCluster(), val.getRowType(), val.getTuples());
    }

    static {
        DEFAULT_CONFIG = ((ConverterRule.Config) ConverterRule.Config.EMPTY.as(ConverterRule.Config.class)).withConversion(LogicalValues.class, (r) -> {
            return true;
        }, Convention.NONE, ProfileConvention.INSTANCE, "ProfileValuesRule").withRuleFactory(ProfileValuesRule::new);
    }

}

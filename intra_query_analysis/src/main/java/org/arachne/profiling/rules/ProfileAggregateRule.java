package org.arachne.profiling.rules;

import org.apache.calcite.plan.Convention;
import org.apache.calcite.plan.RelTraitSet;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.core.Aggregate;
import org.apache.calcite.rel.logical.LogicalAggregate;
import org.arachne.plan.MonetaryConvention;
import org.arachne.plan.abstracts.AbstractMonetaryRule;
import org.arachne.profiling.rel.ProfileAggregate;
import org.arachne.profiling.rel.ProfileConvention;

public class ProfileAggregateRule extends AbstractMonetaryRule {
    public static final Config DEFAULT_CONFIG;

    public ProfileAggregateRule(Config config) {
        super(config);
    }

    public RelNode convert(RelNode rel) {
        Aggregate agg = (Aggregate)rel;
        final RelTraitSet traitSet = rel.getCluster().traitSet().replace(ProfileConvention.INSTANCE);
        return new ProfileAggregate(
                rel.getCluster(),
                traitSet,
                convert(agg.getInput(), traitSet),
                agg.getGroupSet(),
                agg.getGroupSets(),
                agg.getAggCallList());
    }

    static {
        DEFAULT_CONFIG = ((Config)Config.EMPTY.as(Config.class)).withConversion(LogicalAggregate.class, (p) -> {
            return true;
        }, Convention.NONE, ProfileConvention.INSTANCE, "ProfileAggregateRule").withRuleFactory(ProfileAggregateRule::new);
    }
}

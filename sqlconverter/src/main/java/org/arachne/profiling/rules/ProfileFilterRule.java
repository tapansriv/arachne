package org.arachne.profiling.rules;

import org.apache.calcite.plan.Convention;
import org.apache.calcite.plan.RelTraitSet;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.core.Filter;
import org.apache.calcite.rel.logical.LogicalFilter;
import org.arachne.plan.abstracts.AbstractMonetaryRule;
import org.arachne.profiling.rel.ProfileConvention;
import org.arachne.profiling.rel.ProfileFilter;

public class ProfileFilterRule extends AbstractMonetaryRule {
    public static final AbstractMonetaryRule.Config DEFAULT_CONFIG;
    public ProfileFilterRule(Config config) { super(config); }

    public RelNode convert(RelNode rel) {
        Filter filter = (Filter)rel;
        final RelTraitSet traitSet = rel.getCluster().traitSet().replace(ProfileConvention.INSTANCE);
        return new ProfileFilter(
                rel.getCluster(),
                traitSet,
                convert(filter.getInput(), traitSet),
                filter.getCondition());
    }

    static {
        DEFAULT_CONFIG = ((Config)Config.EMPTY.as(Config.class)).withConversion(LogicalFilter.class, (f) -> {
            return !f.containsOver();
        }, Convention.NONE, ProfileConvention.INSTANCE,
                "ProfileConvention").withRuleFactory(ProfileFilterRule::new);
    }
}

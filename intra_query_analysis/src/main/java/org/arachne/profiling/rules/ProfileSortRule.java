package org.arachne.profiling.rules;

import org.apache.calcite.plan.Convention;
import org.apache.calcite.plan.RelTraitSet;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.convert.ConverterRule;
import org.apache.calcite.rel.core.Sort;
import org.apache.calcite.rel.logical.LogicalSort;
import org.arachne.plan.abstracts.AbstractMonetaryRule;
import org.arachne.profiling.rel.ProfileConvention;
import org.arachne.profiling.rel.ProfileSort;

public class ProfileSortRule extends AbstractMonetaryRule {
    public static final ConverterRule.Config DEFAULT_CONFIG;

    public ProfileSortRule(Config config) { super(config); }

    public RelNode convert(RelNode rel) {
        Sort sort = (Sort)rel;
        final RelNode input = sort.getInput();
        final RelTraitSet traitSet = input.getTraitSet().replace(ProfileConvention.INSTANCE);
        return ProfileSort.create(
                convert(input, traitSet),
                sort.getCollation(),
                sort.offset,
                sort.fetch);
    }
    static {
        DEFAULT_CONFIG = Config.INSTANCE
                .withConversion(LogicalSort.class, Convention.NONE, ProfileConvention.INSTANCE, "ProfileSortRule")
                .withRuleFactory(ProfileSortRule::new);
    }
}

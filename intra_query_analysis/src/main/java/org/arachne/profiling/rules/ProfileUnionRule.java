package org.arachne.profiling.rules;

import org.apache.calcite.plan.Convention;
import org.apache.calcite.plan.RelTraitSet;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.convert.ConverterRule;
import org.apache.calcite.rel.core.Union;
import org.apache.calcite.rel.logical.LogicalUnion;
import org.apache.calcite.util.Util;
import org.arachne.plan.abstracts.AbstractMonetaryRule;
import org.arachne.profiling.rel.ProfileConvention;
import org.arachne.profiling.rel.ProfileUnion;
import org.checkerframework.checker.nullness.qual.Nullable;

import java.util.List;

public class ProfileUnionRule extends AbstractMonetaryRule {
    public static final ConverterRule.Config DEFAULT_CONFIG;

    public ProfileUnionRule(Config config) {
        super(config);
    }

    @Override
    public @Nullable RelNode convert(RelNode rel) {
        Union union = (Union)rel;
        final RelTraitSet traitSet = rel.getCluster().traitSet().replace(ProfileConvention.INSTANCE);
        final List<RelNode> newInputs = Util.transform(union.getInputs(), n -> convert(n, traitSet));
        return new ProfileUnion(rel.getCluster(), traitSet, newInputs, union.all);
    }
    static {
        DEFAULT_CONFIG = Config.INSTANCE
                .withConversion(LogicalUnion.class, Convention.NONE, ProfileConvention.INSTANCE, "ProfileUnionRule")
                .withRuleFactory(ProfileUnionRule::new);
    }
}

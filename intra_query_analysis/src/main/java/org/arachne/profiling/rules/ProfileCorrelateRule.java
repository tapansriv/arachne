package org.arachne.profiling.rules;

import org.apache.calcite.adapter.enumerable.EnumerableConvention;
import org.apache.calcite.adapter.enumerable.EnumerableCorrelate;
import org.apache.calcite.adapter.enumerable.EnumerableCorrelateRule;
import org.apache.calcite.plan.Convention;
import org.apache.calcite.plan.RelTraitSet;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.convert.ConverterRule;
import org.apache.calcite.rel.core.Correlate;
import org.apache.calcite.rel.core.Union;
import org.apache.calcite.rel.logical.LogicalCorrelate;
import org.apache.calcite.rel.logical.LogicalUnion;
import org.apache.calcite.util.Util;
import org.arachne.plan.abstracts.AbstractMonetaryRule;
import org.arachne.profiling.rel.ProfileConvention;
import org.arachne.profiling.rel.ProfileCorrelate;
import org.arachne.profiling.rel.ProfileUnion;
import org.checkerframework.checker.nullness.qual.Nullable;

import java.util.List;

public class ProfileCorrelateRule extends AbstractMonetaryRule {
    public static final ConverterRule.Config DEFAULT_CONFIG;

    public ProfileCorrelateRule(ConverterRule.Config config) {
        super(config);
    }

    @Override
    public RelNode convert(RelNode rel) {
        Correlate c = (Correlate)rel;
        return ProfileCorrelate.create(convert(c.getLeft(), c.getLeft().getTraitSet().replace(ProfileConvention.INSTANCE)),
                                       convert(c.getRight(), c.getRight().getTraitSet().replace(ProfileConvention.INSTANCE)),
                                       c.getCorrelationId(), c.getRequiredColumns(), c.getJoinType());
    }

    static {
        DEFAULT_CONFIG = ((Config)Config.EMPTY.as(Config.class)).withConversion(LogicalCorrelate.class, (r) -> {
            return true;
        }, Convention.NONE, ProfileConvention.INSTANCE, "ProfileCorrelateRule").withRuleFactory(ProfileCorrelateRule::new);
    }
}

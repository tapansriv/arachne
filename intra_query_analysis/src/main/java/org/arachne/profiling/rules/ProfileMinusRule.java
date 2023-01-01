package org.arachne.profiling.rules;

import org.apache.calcite.plan.Convention;
import org.apache.calcite.plan.RelTraitSet;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.convert.ConverterRule;
import org.apache.calcite.rel.core.Minus;
import org.apache.calcite.rel.logical.LogicalMinus;
import org.arachne.plan.abstracts.AbstractMonetaryRule;
import org.arachne.profiling.rel.ProfileConvention;
import org.arachne.profiling.rel.ProfileMinus;
import org.checkerframework.checker.nullness.qual.Nullable;

public class ProfileMinusRule extends AbstractMonetaryRule {
    /** Default configuration. */
    public static final ConverterRule.Config DEFAULT_CONFIG = Config.INSTANCE
            .withConversion(LogicalMinus.class, Convention.NONE,
                    ProfileConvention.INSTANCE, "ProfileMinusRule")
            .withRuleFactory(ProfileMinusRule::new);

    public ProfileMinusRule(ConverterRule.Config config) {
        super(config);
    }

    @Override
    public @Nullable RelNode convert(RelNode rel) {
        final Minus minus = (Minus) rel;
        final RelTraitSet traitSet =
                rel.getTraitSet().replace(
                        ProfileConvention.INSTANCE);
        return new ProfileMinus(rel.getCluster(), traitSet,
                convertList(minus.getInputs(), out), minus.all);
    }
}

package org.arachne.profiling.rel;

import org.apache.calcite.plan.*;
import org.apache.calcite.rel.RelNode;
import org.checkerframework.checker.nullness.qual.Nullable;

public enum ProfileConvention implements Convention {
    INSTANCE;

    public static final double COST_MULTIPLIER = 1.0d;

    @Override public String toString() {
        return getName();
    }

    @Override public Class getInterface() { return ProfileRel.class; }

    @Override public String getName() { return "PROFILE"; }

    @Override public @Nullable RelNode enforce(final RelNode input, final RelTraitSet required) {
        return null;
    }

    @Override public RelTraitDef getTraitDef() {
        return ConventionTraitDef.INSTANCE;
    }

    @Override public boolean satisfies(RelTrait trait) {
        return this == trait;
    }

    @Override public void register(RelOptPlanner planner) {}

    @Override public boolean canConvertConvention(Convention toConvention) {
        return false;
    }

    // TODO: very unsure why Enumerable flipped this from the default. Keeping
    // with enumerable's setting, but putting this here in case this is
    // important later
    @Override public boolean useAbstractConvertersForConversion(RelTraitSet fromTraits,
                                                                RelTraitSet toTraits) {
        return true;
    }
}

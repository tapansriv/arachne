package org.arachne.plan;

import org.apache.calcite.plan.Contexts;
import org.apache.calcite.plan.Convention;
import org.apache.calcite.plan.ConventionTraitDef;
import org.apache.calcite.plan.RelOptPlanner;
import org.apache.calcite.plan.RelTrait;
import org.apache.calcite.plan.RelTraitDef;
import org.apache.calcite.plan.RelTraitSet;
import org.apache.calcite.rel.RelCollation;
import org.apache.calcite.rel.RelCollations;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.core.RelFactories;

import org.checkerframework.checker.nullness.qual.Nullable;
import static java.util.Objects.requireNonNull;

/**
*/
public enum MonetaryConvention implements Convention {
    INSTANCE;

    /** 
     * Cost of a monetary node versus implementing an equivalent node in a
     * "typical" calling convention. 
     * TODO: Really not sure what this is used for
     * */
    public static final double COST_MULTIPLIER = 1.0d;

    @Override public String toString() {
        return getName();
    }

    @Override public Class getInterface() {
        return MonetaryRel.class;
    }

    @Override public String getName() {
        return "MONETARY";
    }

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

    // @Override public RelFactories.Struct getRelFactories() {
    //     return RelFactories.Struct.fromContext(
    //             Contexts.of(
    //                 EnumerableRelFactories.ENUMERABLE_TABLE_SCAN_FACTORY,
    //                 EnumerableRelFactories.ENUMERABLE_PROJECT_FACTORY,
    //                 EnumerableRelFactories.ENUMERABLE_FILTER_FACTORY,
    //                 EnumerableRelFactories.ENUMERABLE_SORT_FACTORY));
    // }
}


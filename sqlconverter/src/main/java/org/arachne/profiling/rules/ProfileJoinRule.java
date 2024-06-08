package org.arachne.profiling.rules;

import org.apache.calcite.linq4j.Ord;
import org.apache.calcite.plan.Convention;
import org.apache.calcite.plan.RelOptCluster;
import org.apache.calcite.plan.RelTraitSet;
import org.apache.calcite.rel.RelCollation;
import org.apache.calcite.rel.RelCollations;
import org.apache.calcite.rel.RelFieldCollation;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.convert.ConverterRule;
import org.apache.calcite.rel.core.Join;
import org.apache.calcite.rel.core.JoinInfo;
import org.apache.calcite.rel.logical.LogicalJoin;
import org.arachne.plan.abstracts.AbstractMonetaryRule;
import org.arachne.profiling.rel.ProfileConvention;
import org.arachne.profiling.rel.ProfileJoin;
import org.checkerframework.checker.nullness.qual.Nullable;

import java.util.ArrayList;
import java.util.List;

public class ProfileJoinRule extends AbstractMonetaryRule {
    public static final ConverterRule.Config DEFAULT_CONFIG;

    public ProfileJoinRule(Config config) { super(config); }

    @Override
    public @Nullable RelNode convert(RelNode rel) {
        Join join = (Join)rel;
        final JoinInfo info = join.analyzeCondition();
        // if (info.pairs().size() == 0) {
        //     // EnumerableMergeJoin CAN support cartesian join, but disable it for now.
        //     return null;
        // }
        final List<RelNode> newInputs = new ArrayList<>();
        final List<RelCollation> collations = new ArrayList<>();
        int offset = 0;
        for (Ord<RelNode> ord : Ord.zip(join.getInputs())) {
            RelTraitSet traits = ord.e.getTraitSet().replace(ProfileConvention.INSTANCE);
            if (!info.pairs().isEmpty()) {
                final List<RelFieldCollation> fieldCollations = new ArrayList<>();
                for (int key : info.keys().get(ord.i)) {
                    fieldCollations.add(
                            new RelFieldCollation(key, RelFieldCollation.Direction.ASCENDING,
                                    RelFieldCollation.NullDirection.LAST));
                }
                final RelCollation collation = RelCollations.of(fieldCollations);
                collations.add(RelCollations.shift(collation, offset));
                traits = traits.replace(collation);
            }
            newInputs.add(convert(ord.e, traits));
            offset += ord.e.getRowType().getFieldCount();
        }
        final RelNode left = newInputs.get(0);
        final RelNode right = newInputs.get(1);
        final RelOptCluster cluster = join.getCluster();
        RelNode newRel;

        RelTraitSet traitSet = join.getTraitSet().replace(ProfileConvention.INSTANCE);
        if (!collations.isEmpty()) {
            traitSet = traitSet.replace(collations);
        }
        // Re-arrange condition: first the equi-join elements, then the non-equi-join ones (if any);
        // this is not strictly necessary but it will be useful to avoid spurious errors in the
        // unit tests when verifying the plan.
        // final RexBuilder rexBuilder = join.getCluster().getRexBuilder();
        // final RexNode equi = info.getEquiCondition(left, right, rexBuilder);
        // final RexNode condition;
        // if (info.isEqui()) {
        //     condition = equi;
        // } else {
        //     final RexNode nonEqui = RexUtil.composeConjunction(rexBuilder, info.nonEquiConditions);
        //     condition = RexUtil.composeConjunction(rexBuilder, Arrays.asList(equi, nonEqui));
        // }
        return new ProfileJoin(cluster,
                traitSet,
                left,
                right,
                join.getCondition(),
                join.getVariablesSet(),
                join.getJoinType());
    }

    static {
        DEFAULT_CONFIG = Config.INSTANCE
                .withConversion(LogicalJoin.class, Convention.NONE, ProfileConvention.INSTANCE, "ProfileJoinRule")
                .withRuleFactory(ProfileJoinRule::new);
    }
}

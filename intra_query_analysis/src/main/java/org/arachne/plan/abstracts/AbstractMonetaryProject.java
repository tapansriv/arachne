package org.arachne.plan.abstracts;

import com.google.common.collect.ImmutableList;
import org.apache.calcite.plan.RelOptCluster;
import org.apache.calcite.plan.RelOptCost;
import org.apache.calcite.plan.RelOptPlanner;
import org.apache.calcite.plan.RelTraitSet;
import org.apache.calcite.rel.RelCollation;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.core.Project;
import org.apache.calcite.rel.core.Sort;
import org.apache.calcite.rel.hint.RelHint;
import org.apache.calcite.rel.metadata.RelMetadataQuery;
import org.apache.calcite.rel.type.RelDataType;
import org.apache.calcite.rex.RexNode;
import org.arachne.plan.MonetaryConvention;
import org.arachne.plan.MonetaryLocation;
import org.arachne.plan.MonetaryNodeType;
import org.arachne.plan.MonetaryRel;
import org.checkerframework.checker.nullness.qual.Nullable;

import java.util.List;

public abstract class AbstractMonetaryProject extends Project implements MonetaryRel {

    protected MonetaryNodeType type;
    protected MonetaryLocation location;
    protected Long card;
    protected Double timing;

    public MonetaryRel setCard(Long card) {
        this.card = card;
        return this;
    }

    public MonetaryRel setTiming(Double timing) {
        this.timing = timing;
        return this;
    }

    public Double getTiming() { return timing; }
    public Long getCard() { return card; }

    public AbstractMonetaryProject(RelOptCluster cluster, RelTraitSet traitSet, List<RelHint> hints,
                                   RelNode input, List<? extends RexNode> projects, RelDataType rowType) {
        super(cluster, traitSet, hints, input, projects, rowType);
        assert getConvention() instanceof MonetaryConvention;
    }

    @Override
    public @Nullable RelOptCost computeSelfCost(RelOptPlanner planner, RelMetadataQuery mq) {
        return MonetaryRel.super.computeSelfCost(planner, mq);
    }

    @Override
    public MonetaryNodeType getType() { return type; }

    @Override
    public MonetaryLocation getLocation() { return location; }
}

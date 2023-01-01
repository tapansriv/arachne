package org.arachne.plan.abstracts;

import org.apache.calcite.plan.RelOptCluster;
import org.apache.calcite.plan.RelOptCost;
import org.apache.calcite.plan.RelOptPlanner;
import org.apache.calcite.plan.RelTraitSet;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.core.Union;
import org.apache.calcite.rel.metadata.RelMetadataQuery;
import org.arachne.plan.MonetaryLocation;
import org.arachne.plan.MonetaryNodeType;
import org.arachne.plan.MonetaryRel;
import org.checkerframework.checker.nullness.qual.Nullable;

import java.util.List;

public abstract class AbstractMonetaryUnion extends Union implements MonetaryRel {

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

    public AbstractMonetaryUnion(RelOptCluster cluster, RelTraitSet traitSet, List<RelNode> inputs, boolean all) {
        super(cluster, traitSet, inputs, all);
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

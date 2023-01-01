package org.arachne.plan.abstracts;

import com.google.common.collect.ImmutableList;
import org.apache.calcite.plan.*;
import org.apache.calcite.rel.RelCollation;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.core.Sort;
import org.apache.calcite.rel.core.TableScan;
import org.apache.calcite.rel.hint.RelHint;
import org.apache.calcite.rel.metadata.RelMetadataQuery;
import org.apache.calcite.rex.RexNode;
import org.arachne.plan.MonetaryConvention;
import org.arachne.profiling.ProfileNode;
import org.arachne.plan.MonetaryLocation;
import org.arachne.plan.MonetaryNodeType;
import org.arachne.plan.MonetaryRel;
import org.checkerframework.checker.nullness.qual.Nullable;

import java.util.List;
import java.util.Map;

public abstract class AbstractMonetaryTableScan extends TableScan implements MonetaryRel {

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

    public AbstractMonetaryTableScan(RelOptCluster cluster, RelTraitSet traitSet, List<RelHint> hints, RelOptTable table) {
        super(cluster, traitSet, hints, table);
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

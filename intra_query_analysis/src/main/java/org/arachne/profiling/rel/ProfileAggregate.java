package org.arachne.profiling.rel;

import com.google.common.collect.ImmutableList;
import org.apache.calcite.plan.RelOptCluster;
import org.apache.calcite.plan.RelTraitSet;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.core.Aggregate;
import org.apache.calcite.rel.core.AggregateCall;
import org.apache.calcite.rel.hint.RelHint;
import org.apache.calcite.util.ImmutableBitSet;
import org.checkerframework.checker.nullness.qual.Nullable;

import java.util.List;

public class ProfileAggregate extends Aggregate implements ProfileRel {
    protected Long card;
    protected Double timing;
    protected int arachneId;
    protected double opportunity;
    protected double realSave;
    protected List<RelNode> parents;

    public ProfileAggregate(RelOptCluster cluster, RelTraitSet traitSet, List<RelHint> hints, RelNode input,
                                     ImmutableBitSet groupSet, @Nullable List<ImmutableBitSet> groupSets,
                                     List<AggregateCall> aggCalls) {
        super(cluster, traitSet, hints, input, groupSet, groupSets, aggCalls);
        this.arachneId = -1;
        this.opportunity = -1;
        this.realSave = -1;
        this.parents = null;
    }

    public ProfileAggregate(RelOptCluster cluster, RelTraitSet traitSet, RelNode input,
                                ImmutableBitSet groupSet, @Nullable List<ImmutableBitSet> groupSets,
                                List<AggregateCall> aggCalls) {

        this(cluster, traitSet, ImmutableList.of(), input, groupSet, groupSets, aggCalls);
    }

    @Override
    public Aggregate copy(RelTraitSet traitSet, RelNode input, ImmutableBitSet groupSet,
                          @Nullable List<ImmutableBitSet> groupSets, List<AggregateCall> aggCalls) {
        return (Aggregate) new ProfileAggregate(getCluster(), traitSet, ImmutableList.of(),
                input, groupSet, groupSets, aggCalls).copyProfileData(this);
    }

    @Override
    public Long getCardinality() { return this.card; }

    @Override
    public Double getTiming() {
        return timing;
    }

    @Override
    public void setCardinality(Long card) {
        this.card = card;
    }

    @Override
    public void setTiming(Double timing) {
        this.timing = timing;
    }

    @Override
    public int getArachneID() {
        return this.arachneId;
    }

    @Override
    public double getOpportunity() {
        return this.opportunity;
    }

    @Override
    public double getRealSave() {
        return this.realSave;
    }

    @Override
    public List<RelNode> getParents() {
        return this.parents;
    }

    @Override
    public void setArachneId(int id) {
        this.arachneId = id;
    }

    @Override
    public void setOpportunity(double opp) {
        this.opportunity = opp;
    }

    @Override
    public void setRealSave(double rs) {
        this.realSave = rs;
    }

    @Override
    public void setParents(List<RelNode> parents) {
        this.parents = parents;
    }
}
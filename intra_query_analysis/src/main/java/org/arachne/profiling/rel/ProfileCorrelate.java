package org.arachne.profiling.rel;

import org.apache.calcite.plan.Convention;
import org.apache.calcite.plan.RelOptCluster;
import org.apache.calcite.plan.RelTraitSet;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.core.Correlate;
import org.apache.calcite.rel.core.CorrelationId;
import org.apache.calcite.rel.core.JoinRelType;
import org.apache.calcite.rel.logical.LogicalCorrelate;
import org.apache.calcite.util.ImmutableBitSet;

import java.util.List;

public class ProfileCorrelate extends Correlate implements ProfileRel {
    protected Long card;
    protected Double timing;
    protected int arachneId;
    protected double opportunity;
    protected double realSave;
    protected List<RelNode> parents;

    public ProfileCorrelate(RelOptCluster cluster, RelTraitSet traitSet, RelNode left, RelNode right, CorrelationId correlationId, ImmutableBitSet requiredColumns, JoinRelType joinType) {
        super(cluster, traitSet, left, right, correlationId, requiredColumns, joinType);
        this.arachneId = -1;
        this.opportunity = -1;
        this.realSave = -1;
        this.parents = null;
    }

    @Override
    public Correlate copy(RelTraitSet relTraitSet, RelNode relNode, RelNode relNode1, CorrelationId correlationId, ImmutableBitSet immutableBitSet, JoinRelType joinRelType) {
        return (Correlate) new ProfileCorrelate(this.getCluster(), traitSet, left, right, correlationId, requiredColumns, joinType).copyProfileData(this);
    }

    public static ProfileCorrelate create(RelNode left, RelNode right, CorrelationId correlationId, ImmutableBitSet requiredColumns, JoinRelType joinType) {
        RelOptCluster cluster = left.getCluster();
        RelTraitSet traitSet = cluster.traitSetOf(ProfileConvention.INSTANCE);
        return new ProfileCorrelate(cluster, traitSet, left, right, correlationId, requiredColumns, joinType);
    }

    @Override
    public Long getCardinality() {
        return this.card;
    }

    @Override
    public Double getTiming() {
        return timing;
    }

    @Override
    public void setCardinality(Long card) { this.card = card; }

    @Override
    public void setTiming(Double timing) { this.timing = timing; }

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

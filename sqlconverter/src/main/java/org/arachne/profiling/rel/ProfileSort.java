package org.arachne.profiling.rel;

import org.apache.calcite.plan.RelOptCluster;
import org.apache.calcite.plan.RelTraitSet;
import org.apache.calcite.rel.RelCollation;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.core.Sort;
import org.apache.calcite.rex.RexNode;
import org.checkerframework.checker.nullness.qual.Nullable;

import java.util.List;

public class ProfileSort extends Sort implements ProfileRel {
    protected Long card;
    protected Double timing;
    protected int arachneId;
    protected double opportunity;
    protected double realSave;
    protected List<RelNode> parents;

    public ProfileSort(RelOptCluster cluster, RelTraitSet traitSet, RelNode input, RelCollation collation,
                           @Nullable RexNode offset, @Nullable RexNode fetch) {

        super(cluster, traitSet, input, collation, offset, fetch);
        this.arachneId = -1;
        this.opportunity = -1;
        this.realSave = -1;
        this.parents = null;
    }

    public static ProfileSort create(RelNode child, RelCollation collation,
                                         @Nullable RexNode offset, @Nullable RexNode fetch) {
        final RelOptCluster cluster = child.getCluster();
        final RelTraitSet traitSet = cluster.traitSetOf(ProfileConvention.INSTANCE).replace(collation);
        return new ProfileSort(cluster, traitSet, child, collation, offset, fetch);
    }

    @Override
    public Sort copy(RelTraitSet traitSet, RelNode newInput, RelCollation newCollation,
                     @Nullable RexNode offset, @Nullable RexNode fetch) {
        return (Sort) new ProfileSort(getCluster(), traitSet, newInput, newCollation, offset, fetch)
                                      .copyProfileData(this);
    }

    @Override
    public Long getCardinality() { return card; }

    @Override
    public Double getTiming() { return timing; }

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
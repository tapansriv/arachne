package org.arachne.profiling.rel;

import org.apache.calcite.plan.Convention;
import org.apache.calcite.plan.RelOptCluster;
import org.apache.calcite.plan.RelTraitSet;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.core.Intersect;
import org.apache.calcite.rel.core.SetOp;
import org.apache.calcite.rel.logical.LogicalIntersect;

import java.util.List;

public class ProfileIntersect extends Intersect implements ProfileRel {
    protected Long card;
    protected Double timing;
    protected int arachneId;
    protected double opportunity;
    protected double realSave;
    protected List<RelNode> parents;

    public ProfileIntersect(RelOptCluster cluster, RelTraitSet traits, List<RelNode> inputs, boolean all) {
        super(cluster, traits, inputs, all);
        this.arachneId = -1;
        this.opportunity = -1;
        this.realSave = -1;
        this.parents = null;
    }

    @Override public SetOp copy(RelTraitSet relTraitSet, List<RelNode> list, boolean b) {
        return (SetOp) new ProfileIntersect(getCluster(), traitSet, inputs, all).copyProfileData(this);
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
